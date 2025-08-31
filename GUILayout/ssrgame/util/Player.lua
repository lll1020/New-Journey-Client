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


return Player