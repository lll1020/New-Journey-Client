-- @file util.lua
-- @description 工具库
-- @author an
-- @email 490719516@qq.com
-- @version 1.0
-- @date 2024-08-11
--[[
    @desc: 配置表属性转客户端显示数据
    --@attr: table 配置表属性
    --@state: number =0:正常显示   >0:满级   <0:0级
    --@state: chnum 属性名中间的空格数
    @return: table 客户端显示数据
]]
local cfg_att_score = ssrRequireGameCfg("cfg_att_score")
local cfg_custpro_caption = ssrRequireGameCfg("cfg_custpro_caption")

local _attrgroup = {{3,4},{5,6},{7,8},{9,10},{11,12}}        --属性组：攻击 魔法 道术 防御 魔御 的下上限idx
local _attrname = {[3]="攻%s击", [5]="魔%s法", [7]="道%s术", [9]="防%s御", [11]="魔%s御"}
function ssrAttrToClient(attr, state, chnum)
    state = state or 0
    
    --深拷贝表
    local newattr = SL:CopyData(attr)
    local attridxs = {}
    for i,v in ipairs(newattr) do
        attridxs[i] = tonumber(v[1])
    end

    --重组属性
    for _,v in ipairs(_attrgroup) do
        local loweridx, upperidx =  v[1], v[2]
        local lower, upper = table.indexof(attridxs, loweridx), table.indexof(attridxs, upperidx)
        if lower and upper then                 --同时有某上下限属性
            table.remove(attridxs, upper)
            local upper_attr = table.remove(newattr, upper)
            -- SL:Print("=============================")
            -- SL:dump(newattr,"添加前1111111")
            -- SL:dump(upper_attr,"upper_attr")
            table.insertto(newattr[lower], upper_attr)
            -- SL:dump(newattr,"添加后1111111")
            -- SL:Print("=============================")
        elseif lower and not upper then         --有下限属性
            -- SL:Print("=============================")
            -- SL:dump(newattr,"添加前2222222222")
            table.insertto(newattr[lower], {loweridx+1, 0})
            -- SL:dump(newattr,"添加后2222222222")
            -- SL:Print("=============================")
        elseif not lower and upper then         --有上限属性
            table.insert(newattr[upper], 0, 1)
            table.insert(newattr[upper], upperidx-1, 1)
        end
    end

    --转显示属性
    local showattr = {}
    for i,v in ipairs(newattr) do
        local idx = v[1]
        local name = _attrname[idx] or cfg_att_score[idx].name

        local value = ""
        --下限 上限 值
        local attrvalue1, attrvalue2 = v[2], v[4]

        if state == 0 then
            if not attrvalue2 then
                local type = cfg_att_score[idx].type or 1
                if type == 1 then
                    value = attrvalue1..""
                elseif type == 2 then--万分比
                    if idx == 67 then
                        value = (attrvalue1*0.0001) .. "倍"
                    else
                        value = (attrvalue1 / 100) .. "%"
                    end
                elseif type == 3 then --百分比
                    value = attrvalue1.."%"
                end
            end
        else
            value = state < 0 and "0" or "已满级"
        end

        if attrvalue2 then
            local ch = ""
            if chnum and chnum > 0 then
                for i=1,chnum do ch = ch.."　" end
            end
            name = string.format(name, ch)
            if state == 0 then
                value = attrvalue1.."-"..attrvalue2
            else
                value = state < 0 and "11111110-0" or "已满级"
            end
        end
        name = name .. "："
        showattr[i] = {name=name, value=value}
    end

    return showattr
end

--[[
    @desc: 配置表属性转客户端显示数据
    --@cfg: table 配置表数据
    --@index: number cfg表的下标索引            cfg[index]
    --@field: string cfg表的下标索引中属性字段  cfg[index][field]
    --@state: chnum 属性名中间的空格数
    @return: table 客户端显示数据
]]
function ssrAttrToClientEx(cfg, index, field, chnum)
    local newindex,state = index, 0
    if index == 0 then
        state = -1
        newindex = 1
    elseif index > #cfg then
        state = 1
        newindex = #cfg
    end
    local attr = cfg[index] and cfg[index][field] or cfg[newindex][field]
    return ssrAttrToClient(attr, state, chnum)
end

function getCfg_att_score(index)
    return cfg_att_score[index]
end

function getCfg_custpro_caption(index)
    return cfg_custpro_caption[index]
end

-- 保留n位小数
function ssrKeepDecimalTest(num, n)
    --整数直接返回
    if num == math.floor(num) then return num end
    --如果是负数转整数
    local change = num < 0 and -1 or 1
    if change==-1 then num = num * change end
    --取整数与小数部分
    local int = math.floor(num)
    local decimal = num - int 
    --默认保留2位小数
    n = n or 2
    --获取小数放大倍数
    local multiple = 1
    for i=1, n do multiple = multiple * 10 end
    --保留小数部分转整数并去除多余的小数部分 +0.1是为了解决lua中的bug
    decimal = math.floor(decimal*multiple+0.1)
    --整数部分+保留小数部分
    num = int + (decimal/multiple)
    --完美返回
    return num * change
end
--type = 1：地面 2：背包 3：内观
function ssrGetLooksPath(looks, type)
    type = type or 3

    local index = string.format("%06d", looks)
    local pathindex = math.floor(looks/10000)
    local pathname
    if type == 1 then
        pathname = "item_ground"
    elseif type == 2 then
        pathname = "item"
    else
        pathname = "player_show"
    end
    return "res/"..pathname.."/" .. pathname.. "_" .. pathindex .. "/" .. index ..".png"
end
--把属性分割成数组
function ssrAttributeToArray(attribute)
    local attrarr = {}

    local arr_arr = SL:Split(attribute, "|")
    for _,str in ipairs(arr_arr) do
        local arr = SL:Split(str, "#")
        if #arr == 3 then
            table.remove(arr,1)
            table.insert(attrarr, arr)
        end
    end

    return attrarr
end

--使用字符串比较
function compareValues(value1, operator, value2)
    value1 = tonumber(value1)
    value2 = tonumber(value2)
    if operator == ">" then
        return value1 > value2
    elseif operator == "<" then
        return value1 < value2
    elseif operator == ">=" then
        return value1 >= value2
    elseif operator == "<=" then
        return value1 <= value2
    elseif operator == "==" then
        return value1 == value2
    elseif operator == "~=" then
        return value1 ~= value2
    else
        return false
    end
end

--查询表数量
function tableNums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--获取服务器下发的变量
---*  varName : 变量名
---@param varName string
---@return string
function getServerVar(varName)
    return SL:GetMetaValue("SERVER_VALUE", varName)
end

--稀疏编码和稀疏解码，压缩网络空间的传输
--稀疏编码
function sparse_encode(data)
    local encoded = {}
    for index, value in pairs(data) do
        if value == 1 then
            table.insert(encoded, index)
        end
    end
    return encoded
end

--序列化解析
function serialize_sparse(encoded)
    return table.concat(encoded, ",")
end

--稀疏解码
function sparse_decode(encoded)
    local data = {}
    for _, index in ipairs(encoded) do
        data[index] = 1
    end
    return data
end

--反序列化
function deserialize_sparse(str)
    local encoded = {}
    for index in string.gmatch(str, "([^,]+)") do
        table.insert(encoded, tonumber(index))
    end
    return encoded
end
-- 用于获取 UTF-8 字符的数量
function utf8_length(str)
    local len = 0
    local i = 1
    local charByte
    
    while i <= #str do
        charByte = string.byte(str, i)
        
        if charByte >= 0xF0 then
            -- 四字节字符
            i = i + 4
        elseif charByte >= 0xE0 then
            -- 三字节字符
            i = i + 3
        elseif charByte >= 0xC0 then
            -- 两字节字符
            i = i + 2
        else
            -- 一字节字符
            i = i + 1
        end
        
        len = len + 1
    end
    
    return len
end

--给自己发送消息通知
function sendmsg9(msg)
    if not msg then return end
    local content = ""
    local msgArr = SL:Split(msg, "|")
    for _, v in ipairs(msgArr) do
        local str = SL:Split(v, "#")
        local colorNum = tonumber(str[2])
        colorNum = colorNum or 255
        local hexColor = SL:GetHexColorByStyleId(colorNum)
        content = content .. "<font color='" .. hexColor .. "'>" .. str[1] .. "</font>"
    end
    SL:ShowSystemTips(content)
end

function mathSign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

--计算百分比值进度条使用
---* numerator：分子
---* denominator：分母
function calculatePercentage(numerator, denominator)
    if denominator == 0 then
        return 0
    end
    if numerator >= denominator then
        return 100
    end
    local percentage = (numerator / denominator) * 100
    return percentage
end

function evaluate_condition(condition)
    -- 1. 替换逻辑运算符
    condition = condition:gsub("%s*&%s*", " and ")
    condition = condition:gsub("%s*#%s*", " or ")

    -- 2. 处理比较运算符
    condition = condition:gsub("!=", "~=")
    -- 处理单独的 "="，避免影响 ">=" 和 "<="
    condition = condition:gsub("([^<>=~])=([^=])", "%1==%2")
    condition = condition:gsub("^=([^=])", "==%1")
    condition = condition:gsub("([^=])=$", "%1==")

    -- 处理小于等于和大于等于
    condition = condition:gsub(">==", ">=")
    condition = condition:gsub("<==", "<=")

    -- 3. 提取变量名
    local variables = {}
    for var in string.gmatch(condition, "[%a_][%w_]*") do
        if not variables[var] and not ({
            ["and"] = true, ["or"] = true, ["not"] = true,
            ["true"] = true, ["false"] = true, ["nil"] = true,
            ["=="] = true, ["~="] = true, [">="] = true,
            ["<="] = true, [">"] = true, ["<"] = true,
            ["("] = true, [")"] = true
        })[var] then
            variables[var] = tonumber(SL:GetMetaValue("SERVER_VALUE", var))
        end
    end

    -- 4. 替换变量名为变量值
    for var, value in pairs(variables) do
        -- 使用 %f 确保只匹配完整的变量名
        local pattern = "%f[%w_]" .. var .. "%f[^%w_]"
        condition = condition:gsub(pattern, tostring(value))
    end

    -- 5. 评估条件表达式
    local func, err = loadstring("return (" .. condition .. ")")
    if not func then
        SL:release_print("条件语句有误: " .. err)
    end
    local status, result = pcall(func)
    if not status then
        SL:release_print("评估条件时出错: " .. result)
    end
    return result
end

--- 把秒数转换成形如 "1时5秒"、"2分10秒"、"45秒" 等可变格式的中文描述
-- @param totalSeconds number 总秒数
-- @return string 返回时分秒描述
function secondsToVariedChineseHMS(totalSeconds)
    local hours   = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    local parts = {}
    
    if hours > 0 then
        table.insert(parts, string.format("%d时", hours))
    end
    if minutes > 0 then
        table.insert(parts, string.format("%d分", minutes))
    end
    if seconds > 0 or (hours == 0 and minutes == 0 and seconds == 0) then
        -- 如果总秒数为0，hours 和 minutes 都为0，seconds也是0，此时仍要显示 "0秒"
        table.insert(parts, string.format("%d秒", seconds))
    end

    return table.concat(parts)
end