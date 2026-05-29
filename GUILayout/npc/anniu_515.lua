local npc = {
    currentTab = 1,
    milestonePage = 1,
    searchKey = "",
}

local UI_updata
local UI_HELPER = SL:Require("GUILayout/npc/ui_helper", true)
local REWARD_ITEM_EFFECT_ID = 14193

local function addRewardItemEffect(parent, name, x, y, scale)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local effect = GUI:Effect_Create(parent, name or "reward_item_eff", x or 0, y or 0, 0, REWARD_ITEM_EFFECT_ID, 0, 0, 0, 1)
    GUI:setScale(effect, scale or 1)
    return effect
end

-- 515 的静态展示配置全部走客户端本地表，服务端只下发运行态数据。
npc._config = SL:Require("GUILayout/npc/anniu_515_cfg", true) or {}
if type(npc._config) ~= "table" then
    npc._config = {}
end

-- 主窗口基础配置，坐标以当前资源图为准。
local WINDOW_OPTS = {
    background = {skin = "res/custom/fairyFate/main_bg.png"},
    closeButton = {x = 940, y = 430},
}

-- 页签顺序和资源名映射保持一致，避免界面显示顺序被配置打乱。
local GROUP_ORDER = {"总览", "角色", "PVP", "PVE", "其他"}
local GROUP_KEY = {
    ["总览"] = "overview",
    ["角色"] = "role",
    ["PVP"] = "pvp",
    ["PVE"] = "pve",
    ["其他"] = "other",
}
local GROUP_PROGRESS_ORDER = {"角色", "PVE", "PVP", "其他"}
local GROUP_PROGRESS_POS = {
    ["角色"] = {barX = 130, barY = 97, valueX = 236, valueY = 113},
    ["PVE"] = {barX = 389, barY = 97, valueX = 495, valueY = 113},
    ["PVP"] = {barX = 130, barY = 26, valueX = 236, valueY = 42},
    ["其他"] = {barX = 389, barY = 26, valueX = 495, valueY = 42},
}

local TAB_POS_X = 114
local TAB_POS_Y = {400, 335, 270, 205, 140}
local MILESTONES_PER_PAGE = 4
local DETAIL_ROW_HEIGHT = 122
local DEFAULT_ICON = "res/custom/fairyFate/icons/23.png"
local MAIN_PANEL_SKIN = "res/custom/fairyFate/1/panel_bg.png"
local MAIN_PANEL_POS = {x = 230, y = 43}
local DETAIL_AREA = {
    x = 224,
    y = 58,
    width = 336,
    height = 425,
}

-- 属性汇总面板里统一做一次别名转换，避免配置名称和展示名称不一致。
local ATTR_PANEL_TEXT_ALIAS = {
    ["增加攻击伤害"] = "攻击伤害",
    ["跨服怪物额外增伤"] = "跨服增伤",
    ["固定生命"] = "生命值",
    ["固定攻击"] = "攻击",
    ["攻击力"] = "攻击",
    ["打怪暴率"] = "打怪爆率",
    ["打怪增伤"] = "对怪增伤",
    ["强化不消耗道具几率"] = "强化免耗概率",
}

local RAW_ATTR_META = {
    [1] = {label = "生命值"},
    [2] = {label = "固定魔法"},
    [21] = {label = "暴击几率", percent = true, scale = 100},
    [22] = {label = "暴击伤害", percent = true, scale = 100},
    [25] = {label = "攻击伤害", percent = true, scale = 100},
    [27] = {label = "魔法伤害减少", percent = true, scale = 100},
    [33] = {label = "死亡爆装概率", percent = true, sign = "-"},
    [36] = {label = "防御加成", percent = true},
    [67] = {label = "神力倍功", percent = true},
    [76] = {label = "PK增伤", percent = true},
    [77] = {label = "PK减伤", percent = true},
    [79] = {label = "神圣一击概率", percent = true},
    [200] = {label = "对怪攻速", percent = true},
    [204] = {label = "金币回收", percent = true},
    [206] = {label = "伤害吸收", percent = true},
    [242] = {label = "打怪爆率", percent = true},
    [243] = {label = "移动速度", percent = true, scale = 100},
    [244] = {label = "对怪切割"},
    [245] = {label = "对怪增伤", percent = true},
    [248] = {label = "对怪固定吸血"},
    [255] = {label = "受怪格挡"},
    [282] = {label = "人物攻击", percent = true},
}

local SPECIAL_ATTR_META = {
    realm_exp = {label = "修为"},
    cross_mon_damage_up = {label = "跨服怪物额外增伤", percent = true},
    popularity = {label = "人缘"},
    charm = {label = "魅力"},
    strength_free = {label = "强化免耗概率", percent = true},
    hurt_taken_up = {label = "受到伤害", percent = true},
}

-- 服务端字段里 number/string/bool 会混用，这里统一兜底。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 515 消息体统一按 JSON 字符串处理，空串视为无数据。
local function safeDecode(msgData)
    if type(msgData) ~= "string" or msgData == "" then
        return nil
    end
    return SL:JsonDecode(msgData, false)
end

-- 补齐运行态结构，避免刷新界面时频繁判空。
local function ensureData(data)
    data = data or {}
    data.T_data = data.T_data or {}
    data.T_data.done = data.T_data.done or {}
    data.T_data.milestone_claim = data.T_data.milestone_claim or {}
    data.T_data.counter = data.T_data.counter or {}
    data.special = data.special or {}
    data.fake_attr = data.fake_attr or {}
    data.done_count = toNumber(data.done_count, 0)
    return data
end

-- 某些窗口已被销毁但 Lua 仍持有引用，这里统一判断 cobj 是否还活着。
local function isValidGuiNode(node)
    if not node then
        return false
    end
    return pcall(function()
        GUI:getContentSize(node)
    end)
end

-- 缓存只保存本次 515 窗口节点，失效后全部重取。
local function clearWindowCache()
    npc._window = nil
    npc.bg = nil
    npc.node = nil
end

-- 统一关闭主界面，同时清掉缓存，避免下一次刷新打到失效节点。
local function closeMainWindow()
    local parent = nil
    if npc._window and isValidGuiNode(npc._window.parent) then
        parent = npc._window.parent
    elseif npc._npcid then
        parent = GUI:GetWindow(nil, string.format("npc_%s", npc._npcid))
    end
    clearWindowCache()
    if parent and isValidGuiNode(parent) then
        GUI:Win_Close(parent)
    end
end

-- done 表里只要值可判定为真，就算已完成。
local function countDone(doneMap)
    local total = 0
    for _, value in pairs(doneMap or {}) do
        if value == true or toNumber(value, 0) >= 1 then
            total = total + 1
        end
    end
    return total
end

-- 文本统一走这个样式，避免不同控件字体和描边不一致。
local function setTextStyle(widget, color, size, fontName)
    if not widget then
        return
    end
    if color then
        GUI:Text_setTextColor(widget, color)
    end
    if size then
        GUI:Text_setFontSize(widget, size)
    end
    GUI:Text_enableOutline(widget, "#100808", 2)
    GUI:Text_setFontName(widget, fontName or "fonts/font4.ttf")
end

local function getDoneMap()
    return (npc.data and npc.data.T_data and npc.data.T_data.done) or {}
end

-- 服务端 done 可能用数字 key，也可能用字符串 key。
local function isDetailDone(detailId)
    local doneMap = getDoneMap()
    return doneMap[detailId] == true
        or doneMap[tostring(detailId)] == true
        or toNumber(doneMap[detailId], 0) >= 1
        or toNumber(doneMap[tostring(detailId)], 0) >= 1
end

-- 里程碑领取状态同样兼容 number/string 两套 key。
local function isMilestoneClaimed(count)
    local claimMap = npc.data and npc.data.T_data and npc.data.T_data.milestone_claim or {}
    return claimMap[count] == true
        or claimMap[tostring(count)] == true
        or toNumber(claimMap[count], 0) >= 1
        or toNumber(claimMap[tostring(count)], 0) >= 1
end

-- 优先使用服务端直接下发的 done_count，缺失时再本地统计。
local function getTotalDoneCount()
    local count = toNumber(npc.data and npc.data.done_count, -1)
    if count >= 0 then
        return count
    end
    return countDone(getDoneMap())
end

local function getAllDetails()
    return npc._config.details or {}
end

-- 详情配置按 id 查找，解锁弹窗和右侧属性汇总都依赖这里。
local function getDetailById(detailId)
    detailId = toNumber(detailId, 0)
    for _, detail in ipairs(getAllDetails()) do
        if toNumber(detail.id, 0) == detailId then
            return detail
        end
    end
    return nil
end

-- 当前分组下的配置列表。
local function getGroupDetails(groupName)
    local list = {}
    for _, detail in ipairs(getAllDetails()) do
        if tostring(detail.group or "") == tostring(groupName or "") then
            list[#list + 1] = detail
        end
    end
    return list
end

-- 分组进度只看本地配置中的条目，再用服务端状态判断完成数。
local function getGroupDoneCount(groupName)
    local count = 0
    for _, detail in ipairs(getGroupDetails(groupName)) do
        if isDetailDone(detail.id) then
            count = count + 1
        end
    end
    return count
end

-- 返回分组完成数、总数和百分比，给总览进度条复用。
local function getGroupProgress(groupName)
    local total = #getGroupDetails(groupName)
    local done = getGroupDoneCount(groupName)
    local percent = total > 0 and math.floor(done * 100 / total) or 0
    return done, total, percent
end

local function normalizeSearchText(text)
    text = tostring(text or "")
    text = string.lower(text)
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    return text
end

local function compactSearchText(text)
    text = normalizeSearchText(text)
    text = text:gsub("[%s%p%c，。；：、“”‘’（）【】《》·]+", "")
    return text
end

-- 搜索支持多关键字，以空格和中文标点切词。
local function splitSearchTerms(text)
    local terms = {}
    text = normalizeSearchText(text)
    text = text:gsub("[，。；：、]+", " ")
    for term in string.gmatch(text, "%S+") do
        if term ~= "" then
            terms[#terms + 1] = term
        end
    end
    if #terms == 0 and text ~= "" then
        terms[1] = text
    end
    return terms
end

-- 模糊搜索按“名称包含”或“按字序匹配”处理，只对名字生效。
local function utf8SubsequenceMatch(source, key)
    if key == "" then
        return true
    end
    local pos = 1
    for char in string.gmatch(key, "[%z\1-\127\194-\244][\128-\191]*") do
        local _, endPos = string.find(source, char, pos, true)
        if not endPos then
            return false
        end
        pos = endPos + 1
    end
    return true
end

local function utf8Length(text)
    local total = 0
    for _ in string.gmatch(tostring(text or ""), "[%z\1-\127\194-\244][\128-\191]*") do
        total = total + 1
    end
    return total
end

-- 搜索只匹配成就名字，不匹配条件和奖励文本。
local function matchSearch(detail, key)
    if key == "" then
        return true
    end
    local source = normalizeSearchText(detail.name)
    local compactSource = compactSearchText(source)
    for _, term in ipairs(splitSearchTerms(key)) do
        local rawTerm = normalizeSearchText(term)
        local compactTerm = compactSearchText(term)
        if rawTerm ~= "" and string.find(source, rawTerm, 1, true) then
            return true
        end
        if compactTerm ~= "" and string.find(compactSource, compactTerm, 1, true) then
            return true
        end
        if compactTerm ~= "" and utf8SubsequenceMatch(compactSource, compactTerm) then
            return true
        end
    end
    return false
end

-- 当前页签下的最终显示列表。
local function getFilteredDetails(groupName)
    local list = {}
    for _, detail in ipairs(getGroupDetails(groupName)) do
        if matchSearch(detail, npc.searchKey or "") then
            list[#list + 1] = detail
        end
    end
    return list
end

local function getTitleItemIndex(titleName)
    local exactIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName), 0)
    if exactIndex > 0 then
        return exactIndex
    end
    return toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName .. "[称号]"), 0)
end

-- 总览页里程碑优先展示物品或称号图标，找不到再退回文本。
local function getRewardPreview(rewardText)
    rewardText = tostring(rewardText or "")
    local titleName = string.match(rewardText, "^称号：(.*)$")
    if titleName and titleName ~= "" then
        return {
            kind = "title",
            name = titleName,
            label = titleName,
            count = 1,
            index = getTitleItemIndex(titleName .. "[称号]"),
        }
    end

    local itemName, itemNum = string.match(rewardText, "^(.-)%*(%d+)$")
    if itemName and itemNum then
        return {
            kind = "item",
            name = itemName,
            label = itemName .. "*" .. tostring(itemNum),
            count = toNumber(itemNum, 1),
            index = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName), 0),
        }
    end

    return {
        kind = "text",
        name = rewardText,
        label = rewardText,
        count = 1,
        index = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", rewardText), 0),
    }
end

-- 成就图标统一改为 id 命名，避免继续依赖中文文件名。
local function getAchievementIcon(detailOrName, detailId)
    local detail = nil
    if type(detailOrName) == "table" then
        detail = detailOrName
    elseif tonumber(detailOrName) then
        detail = getDetailById(detailOrName)
    elseif detailId then
        detail = getDetailById(detailId)
    elseif type(detailOrName) == "string" and detailOrName ~= "" then
        for _, item in ipairs(getAllDetails()) do
            if tostring(item.name or "") == detailOrName then
                detail = item
                break
            end
        end
    end

    local iconId = detail and toNumber(detail.id, 0) or 0
    if iconId > 0 then
        local path = string.format("res/custom/fairyFate/icons/%s.png", tostring(iconId))
        if SL and SL.IsFileExist and SL:IsFileExist(path) then
            return path
        end
    end
    return DEFAULT_ICON
end

local function cloneAttrShowEntry(info)
    if type(info) ~= "table" then
        return nil
    end
    local ret = {}
    for key, value in pairs(info) do
        ret[key] = value
    end
    return ret
end

local function buildRangeAttrEntry(label, minValue, maxValue)
    minValue = toNumber(minValue, 0)
    maxValue = toNumber(maxValue, 0)
    if minValue <= 0 and maxValue <= 0 then
        return nil
    end
    return {
        label = label,
        mode = "range",
        min = minValue,
        max = maxValue,
    }
end

local function buildValueAttrEntry(label, value, meta, extraLabel, extraFormat)
    local config = meta or {}
    label = tostring(extraLabel or config.label or label or "")
    value = toNumber(value, 0)
    if label == "" or value <= 0 then
        return nil
    end
    local scale = toNumber(config.scale, 1)
    if scale <= 0 then
        scale = 1
    end
    local isPercent = config.percent == true or tostring(extraFormat or "") == "percent"
    return {
        label = label,
        value = value * scale,
        percent = isPercent and 1 or nil,
        sign = config.sign,
        color = config.color,
    }
end

local function matchComboAttr(detailAttrs, startIndex, expectIds)
    local baseValue = nil
    for offset, expectId in ipairs(expectIds) do
        local info = detailAttrs[startIndex + offset - 1]
        if type(info) ~= "table" or toNumber(info[1], 0) ~= expectId then
            return nil
        end
        local value = toNumber(info[2], 0)
        if value <= 0 then
            return nil
        end
        if baseValue == nil then
            baseValue = value
        elseif baseValue ~= value then
            return nil
        end
    end
    return baseValue
end

-- 兼容旧 attr_show 和新 attr/jl，统一转成客户端现有展示结构。
local function getDetailAttrShowEntries(detail)
    if type(detail) ~= "table" then
        return {}
    end
    if type(detail._attr_show_cache) == "table" then
        return detail._attr_show_cache
    end

    local cached = {}
    if type(detail.attr_show) == "table" then
        for _, info in ipairs(detail.attr_show) do
            local entry = cloneAttrShowEntry(info)
            if entry then
                cached[#cached + 1] = entry
            end
        end
    end
    if #cached > 0 then
        detail._attr_show_cache = cached
        return cached
    end

    local attrs = type(detail.attr) == "table" and detail.attr or {}
    local idx = 1
    while idx <= #attrs do
        local info = attrs[idx]
        local attrKey = type(info) == "table" and info[1] or nil
        local attrValue = type(info) == "table" and info[2] or nil
        local labelText = type(info) == "table" and info[3] or nil
        local valueFormat = type(info) == "table" and info[4] or nil

        local comboValue = matchComboAttr(attrs, idx, {3, 4, 5, 6, 7, 8})
        if comboValue then
            cached[#cached + 1] = {label = "攻魔道", value = comboValue}
            idx = idx + 6
        elseif toNumber(attrKey, 0) == 3 then
            local nextInfo = attrs[idx + 1]
            if type(nextInfo) == "table" and toNumber(nextInfo[1], 0) == 4 then
                local entry = buildRangeAttrEntry("攻击", attrValue, nextInfo[2])
                if entry then
                    cached[#cached + 1] = entry
                end
                idx = idx + 2
            else
                local entry = buildRangeAttrEntry("攻击", attrValue, 0)
                if entry then
                    cached[#cached + 1] = entry
                end
                idx = idx + 1
            end
        elseif toNumber(attrKey, 0) == 4 then
            local entry = buildRangeAttrEntry("攻击", 0, attrValue)
            if entry then
                cached[#cached + 1] = entry
            end
            idx = idx + 1
        elseif toNumber(attrKey, 0) == 8 then
            local nextInfo = attrs[idx + 1]
            if type(nextInfo) == "table" and toNumber(nextInfo[1], 0) == 9 then
                local entry = buildRangeAttrEntry("防御", attrValue, nextInfo[2])
                if entry then
                    cached[#cached + 1] = entry
                end
                idx = idx + 2
            else
                local entry = buildRangeAttrEntry("防御", attrValue, 0)
                if entry then
                    cached[#cached + 1] = entry
                end
                idx = idx + 1
            end
        elseif toNumber(attrKey, 0) == 9 then
            local entry = buildRangeAttrEntry("防御", 0, attrValue)
            if entry then
                cached[#cached + 1] = entry
            end
            idx = idx + 1
        elseif type(attrKey) == "number" then
            local meta = RAW_ATTR_META[toNumber(attrKey, 0)]
            local entry = buildValueAttrEntry(nil, attrValue, meta)
            if entry then
                cached[#cached + 1] = entry
            end
            idx = idx + 1
        elseif type(attrKey) == "string" then
            local meta = SPECIAL_ATTR_META[attrKey] or {}
            local entry = buildValueAttrEntry(nil, attrValue, meta, labelText, valueFormat)
            if entry then
                cached[#cached + 1] = entry
            end
            idx = idx + 1
        else
            idx = idx + 1
        end
    end

    detail._attr_show_cache = cached
    return cached
end

local function getDetailRewardItems(detail)
    if type(detail) ~= "table" then
        return {}
    end
    if type(detail._reward_item_cache) == "table" then
        return detail._reward_item_cache
    end

    local cached = {}
    for _, item in ipairs(type(detail.jl) == "table" and detail.jl or {}) do
        local itemName = tostring((type(item) == "table" and (item.name or item[1])) or "")
        local itemCount = toNumber(type(item) == "table" and (item.count or item[2]) or 0, 0)
        if itemName ~= "" then
            cached[#cached + 1] = {
                name = itemName,
                count = math.max(1, itemCount),
            }
        end
    end

    detail._reward_item_cache = cached
    return cached
end

-- 右侧汇总面板和弹窗属性展示共用格式化逻辑。
local function formatAttrPanelText(text)
    text = tostring(text or "")
    for fromText, toText in pairs(ATTR_PANEL_TEXT_ALIAS) do
        text = text:gsub(fromText, toText)
    end
    return text
end

local function formatPanelPercent(value)
    local num = toNumber(value, 0) / 100
    if math.floor(num) == num then
        return tostring(math.floor(num)) .. "%"
    end
    return tostring(num) .. "%"
end

-- 汇总时统一属性名，确保同义词能叠加到一起。
local function normalizeSummaryLabel(label)
    return formatAttrPanelText(label)
end

-- 颜色优先级：条目自定义 > cfg 统一配置 > 默认值。
local function resolveSummaryColor(label, color, isPercent)
    label = normalizeSummaryLabel(label)
    color = tostring(color or "")
    if color ~= "" then
        return color
    end
    local cfgColor = npc._config and npc._config.attr_show_color and npc._config.attr_show_color[label]
    if tostring(cfgColor or "") ~= "" then
        return tostring(cfgColor)
    end
    return isPercent and "#ffe39a" or "#ffffff"
end

-- 解锁弹窗内的奖励属性统一从本地配置归一化结构生成。
local function buildUnlockAttrText(detail)
    local lines = {}
    for _, info in ipairs(getDetailAttrShowEntries(detail)) do
        local label = normalizeSummaryLabel(info.label or "")
        local sign = tostring(info.sign or "+")
        local mode = tostring(info.mode or "")
        local isPercent = info.percent == true or toNumber(info.percent, 0) >= 1
        local color = resolveSummaryColor(label, info.color, isPercent)
        local text = ""
        if mode == "range" then
            local minValue = toNumber(info.min, 0)
            local maxValue = toNumber(info.max, 0)
            if minValue > 0 or maxValue > 0 then
                if minValue > 0 and maxValue > 0 and minValue ~= maxValue then
                    text = string.format("%s%s%s-%s", label, sign, tostring(minValue), tostring(maxValue))
                else
                    text = string.format("%s%s%s", label, sign, tostring(math.max(minValue, maxValue)))
                end
            end
        else
            local value = toNumber(info.value, 0)
            if value > 0 then
                text = string.format("%s%s%s", label, sign, isPercent and formatPanelPercent(value) or tostring(value))
            end
        end
        if text ~= "" then
            lines[#lines + 1] = string.format("<font color='%s'>%s</font>", color, text)
        end
    end
    return table.concat(lines, "\n")
end

local function buildUnlockItemText(detail)
    local lines = {}
    for _, item in ipairs(getDetailRewardItems(detail)) do
        local text = tostring(item.name or "")
        if toNumber(item.count, 1) > 1 then
            text = string.format("%s*%s", text, tostring(item.count))
        end
        if text ~= "" then
            lines[#lines + 1] = string.format("<font color='#ffe2a8'>%s</font>", text)
        end
    end
    return table.concat(lines, "\n")
end

local function buildUnlockRewardText(detail, info)
    local lines = {}
    local attrText = buildUnlockAttrText(detail)
    local itemText = buildUnlockItemText(detail)
    if attrText ~= "" then
        lines[#lines + 1] = attrText
    end
    if itemText ~= "" then
        lines[#lines + 1] = itemText
    end
    if #lines > 0 then
        return table.concat(lines, "\n")
    end

    local rawReward = tostring((detail and detail.reward) or (info and info.reward) or "")
    if rawReward ~= "" then
        return string.format("<font color='#8fe9ff'>%s</font>", rawReward)
    end
    return ""
end

-- 右侧属性汇总只统计已激活成就，并按本地配置归一化后的属性聚合。
local function buildAttrSummaryText()
    local summaryMap = {}
    local order = {}

    local function ensureNode(label, color, isPercent, sign)
        label = normalizeSummaryLabel(label)
        if label == "" then
            return nil
        end
        local node = summaryMap[label]
        if not node then
            node = {
                label = label,
                color = resolveSummaryColor(label, color, isPercent),
                percent = isPercent and true or false,
                sign = sign or "+",
                mode = "value",
                value = 0,
                min = 0,
                max = 0,
            }
            summaryMap[label] = node
            order[#order + 1] = label
        end
        if sign then
            node.sign = sign
        end
        node.color = resolveSummaryColor(label, color, node.percent or isPercent)
        node.percent = node.percent or isPercent
        return node
    end

    for _, detail in ipairs(getAllDetails()) do
        if isDetailDone(detail.id) then
            for _, info in ipairs(getDetailAttrShowEntries(detail)) do
                local sign = tostring(info.sign or " + ")
                if tostring(info.mode or "") == "range" then
                    local node = ensureNode(info.label, info.color, false, sign)
                    if node then
                        node.mode = "range"
                        node.min = node.min + toNumber(info.min, 0)
                        node.max = node.max + toNumber(info.max, 0)
                    end
                else
                    local isPercent = info.percent == true or toNumber(info.percent, 0) >= 1
                    local node = ensureNode(info.label, info.color, isPercent, sign)
                    if node then
                        node.value = node.value + toNumber(info.value, 0)
                    end
                end
            end
        end
    end

    local lines = {}
    for _, label in ipairs(order) do
        local node = summaryMap[label]
        local valueText = ""
        if node.mode == "range" then
            if node.min > 0 and node.max > 0 and node.min ~= node.max then
                valueText = string.format("%s%s-%s", node.sign, tostring(node.min), tostring(node.max))
            else
                local showValue = math.max(node.min, node.max)
                if showValue > 0 then
                    valueText = string.format("%s%s", node.sign, tostring(showValue))
                end
            end
        else
            if node.value > 0 then
                valueText = string.format("%s%s", node.sign, node.percent and formatPanelPercent(node.value) or tostring(node.value))
            end
        end
        if valueText ~= "" then
            lines[#lines + 1] = {
                labelText = node.label,
                valueText = valueText,
                color = node.color,
                label = node.label,
                sortLen = utf8Length(node.label),
            }
        end
    end

    if #lines == 0 then
        return "<font color='#7f8ca3'>暂未激活任何成就属性</font>"
    end
    table.sort(lines, function(a, b)
        if a.sortLen ~= b.sortLen then
            return a.sortLen < b.sortLen
        end
        if tostring(a.label) ~= tostring(b.label) then
            return tostring(a.label) < tostring(b.label)
        end
        return tostring(a.valueText) < tostring(b.valueText)
    end)

    local richLines = {}
    for _, info in ipairs(lines) do
        richLines[#richLines + 1] = string.format(
            "<font color='#ffffff'>%s</font><font color='%s'>%s</font>",
            tostring(info.labelText or ""),
            info.color,
            tostring(info.valueText or "")
        )
    end
    return table.concat(richLines, "\n")
end

-- 主窗口通过 UI_HELPER 统一创建，复用遮罩和关闭按钮逻辑。
local function ensureWindow(npcid)
    npc._npcid = npcid or npc._npcid
    local opts = {
        background = WINDOW_OPTS.background,
        closeButton = {
            x = WINDOW_OPTS.closeButton.x,
            y = WINDOW_OPTS.closeButton.y,
            onClick = closeMainWindow,
        },
        overlay = {onClick = closeMainWindow},
    }
    npc._window = UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

-- 节点失效时重新创建，避免 removeAllChildren 时打到无效 cobj。
local function ensureWindowAlive(npcid)
    if not isValidGuiNode(npc.node) or not isValidGuiNode(npc.bg) then
        clearWindowCache()
    end
    if not npc.node or not npc.bg then
        return ensureWindow(npcid or npc._npcid)
    end
    return npc.node
end

-- 统一刷新入口，所有页签切换和消息更新都走这里。
local function refreshWindow(npcid)
    local node = ensureWindowAlive(npcid)
    if node then
        UI_updata(node)
    end
end

-- 左侧页签只负责切换状态，不做额外业务判断。
local function renderTabs(node)
    for idx, groupName in ipairs(GROUP_ORDER) do
        local skinDir = npc.currentTab == idx and "on" or "off"
        local skinName = GROUP_KEY[groupName] or groupName
        local button = GUI:Button_Create(node, "tab_" .. idx, TAB_POS_X, TAB_POS_Y[idx], string.format("res/custom/fairyFate/tabs/%s/%s.png", skinDir, skinName))
        GUI:setAnchorPoint(button, 0.5, 0.5)
        GUI:addOnClickEvent(button, function()
            if npc.currentTab ~= idx then
                npc.currentTab = idx
                npc.milestonePage = 1
                refreshWindow()
            end
        end)
    end
end

-- 总览页右侧属性汇总。
local function renderAttrPanel(parent)
    local scroll = GUI:ScrollView_Create(parent, "attr_scroll", 526, 18, 168, 336, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local rich = GUI:RichText_Create(scroll, "attr_rich", 0, 0, buildAttrSummaryText(), 170, 15, "#dfefff", 0, nil, nil, {outlineSize = 1, outlineColor = "#100808"})
    GUI:setAnchorPoint(rich, 0, 1)
    local size = GUI:getContentSize(rich)
    local innerHeight = math.max(336, size.height + 20)
    GUI:ScrollView_setInnerContainerSize(scroll, 160, innerHeight)
    GUI:setPosition(rich, 0, innerHeight)
end

-- 总览页主体底板。
local function renderOverviewPanel(node, name)
    local panel = GUI:Image_Create(node, name, MAIN_PANEL_POS.x, MAIN_PANEL_POS.y, MAIN_PANEL_SKIN)
    GUI:setAnchorPoint(panel, 0, 0)
    return panel
end

-- 明细页主容器，搜索框和滚动列表都挂这里。
local function renderDetailContainer(node, name)
    local panel = GUI:Layout_Create(node, name, DETAIL_AREA.x, DETAIL_AREA.y, DETAIL_AREA.width, DETAIL_AREA.height)
    GUI:setAnchorPoint(panel, 0, 0)
    return panel
end

-- 总览页里程碑卡片。
local function renderMilestoneCard(parent, idx, milestone)
    local baseX = 18 + (idx - 1) * 120
    local card = GUI:Image_Create(parent, "milestone_card_" .. idx, baseX, 210, "res/custom/fairyFate/1/card_bg.png")
    GUI:setAnchorPoint(card, 0, 0)

    local countText = GUI:Text_Create(card, "count", 65, 135 - 70, 16, "#ff3bd7", string.format("%s成就", tostring(milestone.count or 0)))
    GUI:setAnchorPoint(countText, 0.5, 0.5)
    GUI:Text_setTextColor(countText, "#ff3bd7")
    GUI:Text_setFontSize(countText, 16)
    GUI:Text_setFontName(countText, "fonts/font4.ttf")

    local preview = getRewardPreview(milestone.reward)
    if preview.index > 0 then
        addRewardItemEffect(card, "reward_eff", 64, 102, 0.9)
        local item = GUI:ItemShow_Create(card, "item", 64, 102, {index = preview.index, count = preview.count, look = true, bgVisible = false})
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        local rewardText = GUI:Text_Create(card, "reward_text", 62, 85, 15, "#2f3745", preview.label)
        GUI:setAnchorPoint(rewardText, 0.5, 0.5)
        GUI:Text_setTextAreaSize(rewardText, {width = 96, height = 42})
        GUI:Text_setTextHorizontalAlignment(rewardText, 1)
        setTextStyle(rewardText, "#34465c", 15)
    end

    local claimed = isMilestoneClaimed(milestone.count)
    local canClaim = (not claimed) and getTotalDoneCount() >= toNumber(milestone.count, 0)

    if claimed then
        local claimedText = GUI:Text_Create(card, "claimed_text", 65, 30, 18, "#4AE74A", "已领取")
        GUI:setAnchorPoint(claimedText, 0.5, 0.5)
        GUI:Text_setFontSize(claimedText, 18)
        GUI:Text_setFontName(claimedText, "fonts/font4.ttf")
        return
    end

    local button = GUI:Button_Create(card, "claim", 16, 10, "res/custom/fairyFate/1/claim_btn.png")
    GUI:setAnchorPoint(button, 0, 0)
    if canClaim then
        UI_HELPER.redpoint_create(button, {x = 90, y = 28})
    end

    GUI:addOnClickEvent(button, function()
        if not canClaim then
            SL:ShowSystemTips(string.format("达成%s个成就后可领取", tostring(milestone.count or 0)))
            return
        end
        SL:SendLuaNetMsg(101, 515, 1, toNumber(milestone.count, 0), "")
    end)
end

-- 总览页：上方里程碑，下方四组进度条。
local function renderOverview(panel)
    local milestones = npc._config.milestones or {}
    local totalPages = math.max(1, math.ceil(#milestones / MILESTONES_PER_PAGE))
    npc.milestonePage = math.max(1, math.min(npc.milestonePage, totalPages))

    local totalDone = getTotalDoneCount()
    local totalCount = #getAllDetails()
    local totalText = GUI:Text_Create(panel, "overview_count", 320, 195, 22, "#b51d12", string.format("%s/%s", tostring(totalDone), tostring(totalCount)))
    GUI:setAnchorPoint(totalText, 0.5, 0.5)
    setTextStyle(totalText, "#fff2d7", 24, "fonts/font4.ttf")

    local startIndex = (npc.milestonePage - 1) * MILESTONES_PER_PAGE + 1
    for idx = 1, MILESTONES_PER_PAGE do
        local milestone = milestones[startIndex + idx - 1]
        if milestone then
            renderMilestoneCard(panel, idx, milestone)
        end
    end

    local leftArrow = GUI:Button_Create(panel, "milestone_prev", 12, 286, "res/custom/fairyFate/1/arrow_left.png")
    GUI:setAnchorPoint(leftArrow, 0.5, 0.5)
    if npc.milestonePage <= 1 then
        GUI:setOpacity(leftArrow, 120)
    end
    GUI:addOnClickEvent(leftArrow, function()
        if npc.milestonePage > 1 then
            npc.milestonePage = npc.milestonePage - 1
            refreshWindow()
        end
    end)

    local rightArrow = GUI:Button_Create(panel, "milestone_next", 505, 286, "res/custom/fairyFate/1/arrow_right.png")
    GUI:setAnchorPoint(rightArrow, 0.5, 0.5)
    if npc.milestonePage >= totalPages then
        GUI:setOpacity(rightArrow, 120)
    end
    GUI:addOnClickEvent(rightArrow, function()
        if npc.milestonePage < totalPages then
            npc.milestonePage = npc.milestonePage + 1
            refreshWindow()
        end
    end)

    for _, groupName in ipairs(GROUP_PROGRESS_ORDER) do
        local done, total, percent = getGroupProgress(groupName)
        local pos = GROUP_PROGRESS_POS[groupName]
        local value = GUI:Text_Create(panel, "group_value_" .. groupName, pos.valueX, pos.valueY, 16, "#cad5e5", string.format("%s/%s", tostring(done), tostring(total)))
        GUI:setAnchorPoint(value, 1, 0.5)
        setTextStyle(value, "#cad5e5", 16)

        local barBg = GUI:Image_Create(panel, "bar_bg_" .. groupName, pos.barX, pos.barY, "res/custom/fairyFate/1/progress_bg.png")
        GUI:setAnchorPoint(barBg, 0.5, 0.5)
        local bar = GUI:LoadingBar_Create(panel, "bar_" .. groupName, pos.barX, pos.barY, "res/custom/fairyFate/1/progress_fill.png", 0)
        GUI:setAnchorPoint(bar, 0.5, 0.5)
        GUI:LoadingBar_setPercent(bar, percent)
    end
end

-- 单条成就项，布局坐标按当前已调好的资源位置保留。
local function renderDetailRow(parent, detail, rowTop)
    local row = GUI:Image_Create(parent, "row_" .. tostring(detail.id), 0, rowTop, "res/custom/fairyFate/2/row_bg.png")
    GUI:setAnchorPoint(row, 0, 1)

    local icon = GUI:Image_Create(row, "icon", 56, 61, getAchievementIcon(detail))
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    local active = isDetailDone(detail.id)
    local nameText = GUI:Text_Create(row, "name", 108, 88, 20, active and "#39d17c" or "#e9eef5", tostring(detail.name or ""))
    GUI:setAnchorPoint(nameText, 0, 0.5)
    setTextStyle(nameText, active and "#39d17c" or "#eef3f8", 20, "fonts/font4.ttf")

    local condText = GUI:RichText_Create(row, "cond", 328, 66, string.format("<font color='#97a5b8'>条件：</font><font color='#d8e1ec'>%s</font>", tostring(detail.cond or "")), 430, 18, "#d8e1ec", 1, nil, nil, {outlineSize = 1, outlineColor = "#100808"})
    GUI:setAnchorPoint(condText, 0.5, 1)

    local rewardText = GUI:RichText_Create(row, "reward", 328, 35, string.format("<font color='#97a5b8'>奖励：</font><font color='#ffe2a8'>%s</font>", tostring(detail.reward or "")), 430, 18, "#ffe2a8", 1, nil, nil, {outlineSize = 1, outlineColor = "#100808"})
    GUI:setAnchorPoint(rewardText, 0.5, 1)

    local statusSkin = active and "res/custom/fairyFate/2/state_done.png" or "res/custom/fairyFate/2/state_locked.png"
    local status = GUI:Image_Create(row, "status", 626, 61, statusSkin)
    GUI:setAnchorPoint(status, 0.5, 0.5)
end

-- 明细页：分组进度、搜索框、成就列表。
local function renderDetailPage(node, groupName)
    local panel = renderDetailContainer(node, "detail_panel")

    local progressBanner = GUI:Image_Create(panel, "group_progress_banner", 0, 341, "res/custom/fairyFate/2/group_progress.png")
    GUI:setAnchorPoint(progressBanner, 0, 0)

    local done, total = getGroupProgress(groupName)
    local progressText = GUI:Text_Create(panel, "group_progress", 240, 380, 22, "#f7f2de", string.format("%s/%s", tostring(done), tostring(total)))
    GUI:setAnchorPoint(progressText, 0.5, 0.5)
    setTextStyle(progressText, "#f6f1de", 22, "fonts/font4.ttf")

    local inputBg = GUI:Image_Create(panel, "search_bg", 400, 367, "res/custom/fairyFate/2/search_box.png")
    GUI:setAnchorPoint(inputBg, 0, 0)
    local input = GUI:TextInput_Create(inputBg, "search_input", 34, 16, 160, 28, 18)
    GUI:setAnchorPoint(input, 0, 0.5)
    GUI:TextInput_setString(input, npc.searchKey or "")
    GUI:TextInput_setPlaceHolder(input, "点击输入查找成就")
    GUI:TextInput_setFontColor(input, "#dbe7f6")
    GUI:TextInput_setPlaceholderFontColor(input, "#7b8da7")
    GUI:TextInput_setInputMode(input, 6)
    GUI:TextInput_setMaxLength(input, 30)

    local searchBtn = GUI:Button_Create(panel, "search_btn", 604, 368, "res/custom/fairyFate/2/search_btn.png")
    GUI:setAnchorPoint(searchBtn, 0, 0)
    GUI:addOnClickEvent(searchBtn, function()
        npc.searchKey = tostring(GUI:TextInput_getString(input) or "")
        refreshWindow()
    end)

    local scroll = GUI:ScrollView_Create(panel, "detail_scroll", 18, 9, 718, 320, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)

    local details = getFilteredDetails(groupName)
    local innerHeight = math.max(320, #details * DETAIL_ROW_HEIGHT)
    GUI:ScrollView_setInnerContainerSize(scroll, 718, innerHeight)
    local layout = GUI:Layout_Create(scroll, "detail_layout", 0, 0, 718, innerHeight)
    GUI:setAnchorPoint(layout, 0, 0)

    for idx, detail in ipairs(details) do
        local rowTop = innerHeight - ((idx - 1) * DETAIL_ROW_HEIGHT)
        renderDetailRow(layout, detail, rowTop)
    end

    if #details == 0 then
        local emptyText = GUI:Text_Create(scroll, "empty", 359, 160, 22, "#93a1b4", "没有匹配的成就")
        GUI:setAnchorPoint(emptyText, 0.5, 0.5)
        setTextStyle(emptyText, "#93a1b4", 22)
    end

    local hint = GUI:Image_Create(node, "detail_hint", 972, 259, "res/custom/fairyFate/2/scroll_hint.png")
    GUI:setAnchorPoint(hint, 0.5, 0.5)
end

-- 解锁弹窗：上方放介绍，下方放奖励，3 秒后自动关闭。
local function showUnlockToast(info, detailId)
    local windowName = "fairy_fate_unlock"
    local detail = getDetailById(detailId)
    local parent = GUI:GetWindow(nil, windowName)
    if parent then
        GUI:Win_Close(parent)
    end

    parent = GUI:Win_Create(windowName, cogin.w / 2, cogin.h / 2 - 120, 0, 0, false, false, true, true, true, 515, 99)
    local bg = GUI:Image_Create(parent, "bg", 0, 0, "res/custom/fairyFate/unlock/unlock_bg.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)

    local icon = GUI:Image_Create(bg, "icon", 74, 94 - 5, getAchievementIcon(detail or info.name, detailId))
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    local title = GUI:Text_Create(bg, "title", 223, 64 + 46, 20, "#ffe9ad", tostring((detail and detail.name) or info.name or "成就达成"))
    GUI:setAnchorPoint(title, 0.5, 0.5)
    setTextStyle(title, "#ffe9ad", 20, "fonts/font4.ttf")

    local intro = tostring((detail and (detail.intro or detail.desc or detail.cond)) or info.desc or info.cond or "")
    if intro ~= "" then
        local introText = GUI:RichText_Create(bg, "intro", 223, 28 + 46, string.format("<font color='#8ca2bf'>介绍：</font><font color='#dfeaf7'>%s</font>", intro), 230, 14, "#dfeaf7", 1, nil, nil, {outlineSize = 1, outlineColor = "#100808"})
        GUI:setAnchorPoint(introText, 0.5, 0.5)
    end

    local reward = tostring((detail and detail.reward) or info.reward or "")
    local rewardRich = buildUnlockRewardText(detail, info)
    if rewardRich ~= "" or reward ~= "" then
        local rewardText = GUI:RichText_Create(bg, "reward", 223, -18 + 46 + 17, string.format("<font color='#8ca2bf'>奖励：</font>%s", rewardRich ~= "" and rewardRich or string.format("<font color='#8fe9ff'>%s</font>", reward)), 230, 14, "#8fe9ff", 1, nil, nil, {outlineSize = 1, outlineColor = "#100808"})
        GUI:setAnchorPoint(rewardText, 0.5, 0.5)
    end
    local closeBtn = GUI:Button_Create(bg, 'close', 740 - 380, 90, "res/public/1900000511.png")
    GUI:addOnClickEvent(closeBtn, function()
        GUI:Win_Close(parent)
    end)
    GUI:Timeline_DelayTime(bg, 5, function()
        local curParent = GUI:GetWindow(nil, windowName)
        if curParent then
            GUI:Win_Close(curParent)
        end
    end)
end

-- 统一重绘当前界面。
UI_updata = function(node)
    if not isValidGuiNode(node) or not isValidGuiNode(npc.bg) then
        clearWindowCache()
        return
    end

    GUI:removeAllChildren(node)
    renderTabs(node)

    if npc.currentTab == 1 then
        local panel = renderOverviewPanel(node, "overview_panel_bg")
        renderAttrPanel(panel)
        renderOverview(panel)
    else
        renderDetailPage(node, GROUP_ORDER[npc.currentTab])
    end
end

-- p2: 0 打开主界面；2 成就解锁通知；其余按刷新处理。
function npc.main(npcid, p2, p3, msgData)
    npc._npcid = npcid or npc._npcid

    if p2 == 0 then
        npc.currentTab = 1
        npc.milestonePage = 1
        npc.searchKey = ""
        npc.data = ensureData(safeDecode(msgData))
        refreshWindow(npcid)
        return
    end

    if p2 == 2 then
        local info = safeDecode(msgData) or {}
        npc.data = ensureData(npc.data)
        npc.data.T_data.done[tostring(p3)] = 1
        npc.data.done_count = countDone(npc.data.T_data.done)
        showUnlockToast(info, p3)
        if isValidGuiNode(npc.node) and isValidGuiNode(npc.bg) then
            refreshWindow(npcid)
        end
        return
    end

    npc.data = ensureData(safeDecode(msgData) or npc.data)
    refreshWindow(npcid)
end

return npc
