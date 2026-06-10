--[[
                             _ooOoo_
                            o8888888o
                            88" . "88
                            (| -_- |)
                            O\  =  /O
                         ____/`---'\____
                       .'  \\|     |//  `.
                      /  \\|||  :  |||//  \
                     /  _||||| -:- |||||-  \
                     |   | \\\  -  /// |   |
                     | \_|  ''\---/''  |   |
                     \  .-\__  `-`  ___/-. /
                   ___`. .'  /--.--\  `. . __
                ."" '<  `.___\_<|>_/___.'  >'"".
               | | :  `- \`.;`\ _ /`;.`/ - ` : | |
               \  \ `-.   \_ __\ /__ _/   .-` /  /
          ======`-.____`-.___\_____/___.-`____.-'======
                             `=---='
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                     佛祖保佑        永无BUG
]]
--- 游戏逻辑模块
-- @file Player.lua
-- @description 角色逻辑
-- @author an
-- @email 490719516@qq.com
-- @version 1.0
-- @date 2024-08-11
local Player = {}
--检查idx是否是货币
---* idx：道具idx
function Player:isCurrency(idx)
    return idx < ssrConstCfg.itemlimit
end

--验证物品或者货币是否满足条件！
function Player:checkItemNumByTable(cost)
    for i, value in ipairs(cost) do
        local constName = value[1]
        local itemIdx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", constName))
        if not itemIdx then
            return "空",0
        end
        local myItemCount
        if self:isCurrency(itemIdx) then
            myItemCount = SL:GetMetaValue("MONEY_ASSOCIATED", itemIdx)
        else
            myItemCount = SL:GetMetaValue("ITEM_COUNT", itemIdx)
        end
        if value[3] then
            local bodyEquipName = self:getEquipNameByPos(value[3])
            if bodyEquipName == value[1] then
                myItemCount = 1
            else
                myItemCount = 0
            end
        end
        myItemCount = tonumber(myItemCount)
        local needItemCount = value[2]
        if myItemCount < needItemCount then
            return constName, needItemCount
        end
    end
end

--检测添加红点
---* widget：控件对象
---* cost：条件数据
---* x：x偏移
---* y：y偏移
function Player:checkAddRedPoint(widget, cost, x, y)
    delRedPoint(widget) --先删除一次
    local constName, needItemCount = self:checkItemNumByTable(cost)
    if not constName then
        addRedPoint(widget, x, y)
    end
end

--根据位置获取装备名字
function Player:getEquipNameByPos(pos)
    local equip = SL:GetMetaValue("EQUIP_DATA", pos)
    if equip then
        return equip.Name
    else
        return nil
    end
end
--根据位置获取装备IDX
function Player:getEquipIndexByPos(pos)
    local equip = SL:GetMetaValue("EQUIP_DATA", pos)
    if equip then
        return equip.Index
    else
        return nil
    end
end

--根据位置获取装备自定义字段
function Player:getEquipFieldByPos(pos, type)
    local equipIdx = self:getEquipIndexByPos(pos)
    if equipIdx then
        return self:getEquipFieldByIndex(equipIdx, type)
    else
        return nil
    end
end
--获取自定义进度条
function Player:getProgressBar(pos, index)
    local equip = SL:GetMetaValue("EQUIP_DATA", pos)
    if not equip then
        return nil, nil
    end
    index = index or 0
    local ProgressBar = equip.ExtendInfo["LH"..index]
    if not ProgressBar then
        return nil, nil
    end
    local cur = ProgressBar[6]
    local max = ProgressBar[7]
    return cur, max
end


--根据装备ID获取装备自定义字段
function Player:getEquipFieldByIndex(index, type)
    local itemData = SL:GetMetaValue("ITEM_DATA", index)
    if itemData then
        if type == 1 then
            return itemData.sDivParam1
        elseif type == 2 then
            return itemData.sDivParam2
        else
            return itemData.sDivParam1
        end
    end
end
--根据装备名自定义字段
function Player:getEquipFieldByName(name, type)
    local equipIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
    if equipIdx then
        return self:getEquipFieldByIndex(equipIdx, type)
    else
        return nil
    end
end

--根据位置获取装备自定义属性的属性值
---*  pos : 位置
---*  customAttrIndex : 自定义属性索引
function Player:getEquipCustomAttrValue(pos,customAttrIndex)
    customAttrIndex = customAttrIndex or 1
    local equip = SL:GetMetaValue("EQUIP_DATA", pos)
    if equip then
        local values = equip["ExAbil"]["abil"][customAttrIndex]["v"]
        if values then
            return values
        else
            return nil
        end
    else
        return nil
    end
end

--获取服务器下发的变量
---*  varName : 变量名
---@param varName string
---@return string
function Player:getServerVar(varName)
    return SL:GetMetaValue("SERVER_VALUE", varName)
end
--将服务器下发的json字符串转换为表
---*  str : json字符串
---@param str string
function Player:JsonToTbl(str)
    if not str or str == "" then
        return {}
    end
    local ok, ret = pcall(function()
        return SL:JsonDecode(str, false)
    end)
    if not ok or type(ret) ~= "table" then
        return {}
    end
    return ret
end

local function _fmt_percent(value)
    local num = tonumber(value) or 0
    if num == math.floor(num) then
        return string.format("%d", num)
    end
    return string.format("%.1f", num)
end

local function _clean_attr_name(name)
    name = tostring(name or "")
    name = string.gsub(name, " ", "")
    name = string.gsub(name, "　", "")
    return name
end

local function _format_attr_value(attConfig, value)
    if attConfig and attConfig.type == 2 then
        return _fmt_percent((tonumber(value) or 0) / 100) .. "%"
    end
    if attConfig and attConfig.type == 3 then
        return _fmt_percent(value) .. "%"
    end
    return tostring(value or 0)
end

local function _attr_line(name, value, color)
    color = color or 255
    return string.format("<font color='%s'>%s+%s</font>", SL:GetHexColorByStyleId(color), tostring(name or ""), tostring(value or 0))
end

local function _show_attr_merged_from_entries(entries)
    local sorted = {}
    for _, entry in ipairs(entries or {}) do
        local attConfig = SL:GetMetaValue("ATTR_CONFIG", entry.id)
        local cleanName = _clean_attr_name(attConfig and attConfig.name or "")
        local isPercent = attConfig and (attConfig.type == 2 or attConfig.type == 3)
        table.insert(sorted, {id = entry.id, value = entry.value, attConfig = attConfig, name = cleanName, isPercent = isPercent})
    end
    table.sort(sorted, function(a, b)
        if #a.name ~= #b.name then
            return #a.name < #b.name
        end
        if a.isPercent ~= b.isPercent then
            return not a.isPercent
        end
        return a.name < b.name
    end)

    local rangeNames = {["攻击"] = true, ["魔法"] = true, ["道术"] = true, ["防御"] = true, ["魔防"] = true}
    local pending = {}
    local result = {}
    for _, entry in ipairs(sorted) do
        local baseName = entry.name:match("^(.-)下限$")
        local side = baseName and "下限" or nil
        if not baseName then
            baseName = entry.name:match("^(.-)上限$")
            side = baseName and "上限" or nil
        end
        if baseName and rangeNames[baseName] then
            if not pending[baseName] then
                pending[baseName] = {color = (entry.attConfig and entry.attConfig.color) or 255}
                table.insert(result, {rangeName = baseName})
            end
            pending[baseName][side == "下限" and "low" or "high"] = _format_attr_value(entry.attConfig, entry.value)
        else
            table.insert(result, _attr_line(entry.name, _format_attr_value(entry.attConfig, entry.value), (entry.attConfig and entry.attConfig.color) or 255))
        end
    end

    local lines = {}
    for _, entry in ipairs(result) do
        if type(entry) == "table" and entry.rangeName then
            local name = entry.rangeName
            local one = pending[name]
            if one.low and one.high then
                table.insert(lines, _attr_line(name, one.low .. "-" .. one.high, one.color))
            elseif one.low then
                table.insert(lines, _attr_line(name .. "下限", one.low, one.color))
            elseif one.high then
                table.insert(lines, _attr_line(name .. "上限", one.high, one.color))
            end
        else
            table.insert(lines, entry)
        end
    end
    return table.concat(lines, "\n")
end


function Player:showEquipBaseAttr(item)
    local attList = GUIFunction:ParseItemBaseAtt(item.attribute)
    local attr_desc = ""
    local sorted = {}

    for _, v in pairs(attList) do
        local originId = v.id
        local attConfig = SL:GetMetaValue("ATTR_CONFIG", originId)
        if attConfig and originId >= 20 then
            local cleanName = attConfig.name or ""
            cleanName = string.gsub(cleanName, " ", "")
            cleanName = string.gsub(cleanName, "　", "")
            local isPercent = attConfig.type == 2 or attConfig.type == 3
            table.insert(sorted, {data = v, attConfig = attConfig, name = cleanName, isPercent = isPercent})
        end
    end

    table.sort(sorted, function(a, b)
        if #a.name ~= #b.name then
            return #a.name < #b.name
        end
        if a.isPercent ~= b.isPercent then
            return not a.isPercent -- 数值在前，百分比在后
        end
        return a.name < b.name
    end)

    for _, entry in ipairs(sorted) do
        local v = entry.data
        local attConfig = entry.attConfig
        local name = entry.name
        local value = v.value
        if (attConfig and attConfig.type == 2) then --万分比除100
            value = _fmt_percent(value / 100) .. "%"
        end
        if (attConfig and attConfig.type == 3) then --百分比
            value = _fmt_percent(value) .. "%"
        end
        local oneStr = name .."+".. value
        local color = attConfig.color
        
        if color and color > 0 then
            -- SL:release_print(string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr))
            attr_desc = attr_desc .. string.format("<font color='%s'>%s</font>\n", SL:GetHexColorByStyleId(color), oneStr)
        end
    end
    return attr_desc
end




function Player:showEquipAttr(item)
    return self:showEquipAttrMergedRange(item)
end

function Player:showEquipAttrMergedRange(item)
    if not item or not item.attribute then
        return ""
    end
    local attList = GUIFunction:ParseItemBaseAtt(item.attribute)
    local entries = {}
    for _, v in pairs(attList or {}) do
        table.insert(entries, {id = v.id, value = v.value})
    end
    return _show_attr_merged_from_entries(entries)
end

function Player:showAttr(attr)
    return self:showAttrMergedRange(attr)
end

function Player:showAttrMergedRange(attr)
    local entries = {}
    for _, v in pairs(attr or {}) do
        table.insert(entries, {id = v[1], value = v[2]})
    end
    return _show_attr_merged_from_entries(entries)
end



return Player
