local npc = {}

npc._config = teshudata["npc_53"] or {}

local WINDOW_NAME = "npc_53"
local WINDOW_SIZE = {width = 856, height = 536}
local PAGE_KEY = {
    embed = "镶嵌",
    compose = "合成",
    box = "宝箱",
    atlas = "图鉴",
}
local PAGE_ORDER = {"embed", "compose", "box", "atlas"}
local PAGE_BG = {
    embed = "res/custom/three_city/sshc/new/镶嵌/镶嵌部件.png",
    compose = "res/custom/three_city/sshc/new/合成/合成部件.png",
    box = "res/custom/three_city/sshc/new/宝箱/宝箱部件.png",
    atlas = "res/custom/three_city/sshc/new/图鉴/空.png",
}
local LEFT_TAB_POS = {
    embed = {x = 18, y = 341},
    compose = {x = 18, y = 251},
    box = {x = 18, y = 162},
    atlas = {x = 18, y = 73},
}
local BOX_NAME_ORDER = {"神石宝箱", "神石宝箱[史诗级]", "神石宝箱[传说级]"}
local SLOT_BASE_NAMES = {"山川", "海洋", "天空", "清风", "火焰", "满月", "大地", "雷电"}
local EMPTY_STONE_SKIN = "res/custom/three_city/sshc/new/神石纯底.png"
local SLOT_POS = {
    {x = 250 - 10, y = 338 + 25 + 5},
    {x = 372 - 10, y = 338 + 25 + 5},
    {x = 494 - 10, y = 338 + 25 + 5},
    {x = 616 - 10, y = 338 + 25 + 5},
    {x = 250 - 10, y = 229 + 25},
    {x = 372 - 10, y = 229 + 25},
    {x = 494 - 10, y = 229 + 25},
    {x = 616 - 10, y = 229 + 25},
}
local ATLAS_TOP_TAB_POS = {
    [1] = {x = 185, y = 406},
    [2] = {x = 351, y = 406},
    [3] = {x = 517, y = 406},
    [4] = {x = 683, y = 406},
}
local ATLAS_TAB_NAME = {
    [1] = "稀有",
    [2] = "史诗",
    [3] = "传说",
    [4] = "神话",
}
local QUALITY_COLOR = {
    [1] = "#D8F0FF",
    [2] = "#C48EFF",
    [3] = "#F5C35D",
    [4] = "#FF6B6B",
}
local QUALITY_NAME = {
    [1] = "稀有",
    [2] = "史诗",
    [3] = "传说",
    [4] = "神话",
}
local QUALITY_FRAME_SKIN = {
    [1] = "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/稀有.png",
    [2] = "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/史诗.png",
    [3] = "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/传说.png",
    [4] = "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/神话.png",
}
local DOUBLE_CLICK_INTERVAL = 0.35
local BOX_SKIP_ANIM_KEY = "npc_53_box_skip_anim"
local BOX_RATE_DESC = {
    ["神石宝箱"] = "<font color='#d8f0ff'>稀有 84%</font><br><font color='#c48eff'>史诗 10%</font><br><font color='#f5c35d'>传说 1%</font><br><font color='#ff6b6b'>神话 5%</font>",
    ["神石宝箱[史诗级]"] = "<font color='#c48eff'>固定开启史诗级神石</font>",
    ["神石宝箱[传说级]"] = "<font color='#f5c35d'>固定开启传说级神石</font>",
}
local OUTLINE_COLOR = "#100808"
local NEED_ITEM_NUM = tonumber(npc._config.needitemnum or 10) or 10

--[[
基础数据与显示辅助方法说明：
1. _toint(value, defaultValue)
   用途：将任意值安全转成数字，失败时返回默认值。
   参数：value=待转换值；defaultValue=转换失败时的兜底值。
2. _get_panel_data()
   用途：读取服务端下发到当前 NPC 面板的动态数据。
   参数：无。
3. _get_slot_item_name(slotIndex, qualityLevel)
   用途：根据槽位序号与品质层级，读取配置中的神石名称。
   参数：slotIndex=槽位序号；qualityLevel=品质层级。
4. _get_box_rate_desc(boxName)
   用途：获取当前宝箱对应的概率说明富文本。
   参数：boxName=宝箱名称。
5. _get_slot_base_name(slotIndex)
   用途：获取槽位对应的基础名称，用于拼接图标与默认文案。
   参数：slotIndex=槽位序号。
6. _get_item_index_by_name(itemName)
   用途：通过物品名查询客户端物品索引。
   参数：itemName=物品名称。
7. _get_item_data_by_name(itemName)
   用途：通过物品名读取客户端缓存的完整物品数据。
   参数：itemName=物品名称。
8. _get_panel_boxes() / _get_current_box_name()
   用途：读取宝箱数量，并确定当前选中的宝箱类型。
   参数：boxName=宝箱名称，仅 _get_current_box_name 内部使用当前状态。
9. _get_slot_icon_path(slotIndex, isBright)
   用途：按槽位与亮灭状态返回神石图标路径。
   参数：slotIndex=槽位序号；isBright=true 亮态，false 暗态。
10. _get_slot_quality(itemName) / _get_slot_index_by_name(itemName)
    用途：根据物品名反查神石品质与槽位。
    参数：itemName=神石物品名称。
11. _get_slot_display_name(itemName, slotIndex)
    用途：生成槽位上显示的神石名称，没有物品时回退到默认名。
    参数：itemName=神石物品名；slotIndex=槽位序号。
12. _get_equipped_slot_map() / _get_open_slots() / _get_owned_map() / _get_progress_map()
    用途：读取装备槽、开放槽位、图鉴拥有数据和图鉴进度数据。
    参数：无。
13. _set_text_style(widget, color, size, outline)
    用途：统一设置文本颜色、字号和描边。
    参数：widget=文本控件；color=颜色；size=字号；outline=描边颜色。
14. _create_stroke_text(parent, name, x, y, size, color, text, anchorX, anchorY, fontName)
    用途：创建带描边的文本，减少重复 UI 代码。
    参数：parent=父节点；name=控件名；x/y=坐标；size=字号；color=颜色；text=文本；
         anchorX/anchorY=锚点；fontName=字体路径。
15. _show_item_tips_by_name(itemName, anchorNode)
    用途：根据物品名打开物品 Tips。
    参数：itemName=物品名称；anchorNode=Tips 锚点节点。
16. _create_desc_tip(tipNode, desc)
    用途：为问号按钮绑定鼠标/触摸说明弹窗。
    参数：tipNode=触发节点；desc=显示说明文本。
]]
local function _toint(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function _get_panel_data()
    return npc.data or {}
end

local function _get_slot_item_name(slotIndex, qualityLevel)
    local list = npc._config.cost and npc._config.cost[qualityLevel] or {}
    return list and list[slotIndex] or nil
end

local function _get_box_rate_desc(boxName)
    return BOX_RATE_DESC[boxName] or BOX_RATE_DESC["神石宝箱"]
end

local function _get_slot_base_name(slotIndex)
    return SLOT_BASE_NAMES[slotIndex] or ("槽位" .. tostring(slotIndex))
end

local function _get_item_index_by_name(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    return _toint(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName), 0)
end

local function _get_item_data_by_name(itemName)
    local index = _get_item_index_by_name(itemName)
    if index <= 0 then
        return nil
    end
    return SL:GetMetaValue("ITEM_DATA", index)
end

local function _get_panel_boxes()
    local panel = _get_panel_data()
    local boxes = panel.boxes or {}
    local out = {}
    for _, boxName in ipairs(BOX_NAME_ORDER) do
        out[boxName] = _toint(boxes[boxName], 0)
    end
    return out
end

local function _get_current_box_name()
    local current = npc._boxName
    if current then
        for _, boxName in ipairs(BOX_NAME_ORDER) do
            if current == boxName then
                return current
            end
        end
    end
    npc._boxName = BOX_NAME_ORDER[1]
    return npc._boxName
end

local function _get_slot_icon_path(slotIndex, isBright)
    local folder = isBright and "亮" or "暗"
    return string.format("res/custom/three_city/sshc/new/神石icon/%s/%s.png", folder, _get_slot_base_name(slotIndex))
end

local function _get_slot_quality(itemName)
    itemName = tostring(itemName or "")
    for level, list in ipairs(npc._config.cost or {}) do
        for _, name in ipairs(list or {}) do
            if name == itemName then
                return level
            end
        end
    end
    return 0
end

local function _get_slot_index_by_name(itemName)
    itemName = tostring(itemName or "")
    if itemName == "" then
        return 0
    end
    for _, list in ipairs(npc._config.cost or {}) do
        for slotIndex, name in ipairs(list or {}) do
            if name == itemName then
                return slotIndex
            end
        end
    end
    return 0
end

local function _get_slot_display_name(itemName, slotIndex)
    itemName = tostring(itemName or "")
    if itemName ~= "" then
        local baseName = string.match(itemName, "^(.-)神石")
        if baseName and baseName ~= "" then
            return baseName .. "神石"
        end
        return itemName
    end
    return string.format("神石槽%d", _toint(slotIndex, 0))
end

local function _get_embed_slot_label(slotIndex)
    return _get_slot_base_name(slotIndex)
end

local function _get_short_stone_name(itemName, slotIndex)
    itemName = tostring(itemName or "")
    if itemName ~= "" then
        local baseName = string.match(itemName, "^(.-)神石")
        if baseName and baseName ~= "" then
            return baseName
        end
    end
    return _get_slot_base_name(slotIndex)
end

local function _strip_stone_name_from_attr_text(attrText)
    attrText = tostring(attrText or "")
    if attrText == "" then
        return ""
    end
    attrText = attrText:gsub("<br%s*/?>", "\n")
    attrText = attrText:gsub("\r\n", "\n")
    attrText = attrText:gsub("\r", "\n")
    local out = {}
    for line in string.gmatch(attrText .. "\n", "(.-)\n") do
        local plain = string.gsub(line, "<.->", "")
        plain = string.gsub(plain, "%s+", "")
        if plain ~= "" and not string.find(plain, "神石", 1, true) then
            out[#out + 1] = line
        end
    end
    return table.concat(out, "<br>")
end

local function _each_attr_line(attrText, callback)
    local text = tostring(attrText or "")
    if text == "" or type(callback) ~= "function" then
        return
    end
    text = text:gsub("<br%s*/?>", "\n")
    text = text:gsub("\r\n", "\n")
    text = text:gsub("\r", "\n")
    for line in string.gmatch(text .. "\n", "(.-)\n") do
        if tostring(line or "") ~= "" then
            callback(line)
        end
    end
end

local function _parse_attr_line(line)
    local raw = tostring(line or "")
    if raw == "" then
        return nil
    end
    local color = raw:match("<font[^>]-color=['\"]?([^'\">%s]+)")
    local plain = raw:gsub("<.->", ""):gsub("%s+", "")
    if plain == "" or plain:find("神石", 1, true) then
        return nil
    end
    local name, low, high = plain:match("^(.-)%+([%-]?%d+)%s*%-%s*([%-]?%d+)$")
    if name then
        return {name = name, low = tonumber(low) or 0, high = tonumber(high) or 0, color = color}
    end
    name, low = plain:match("^(.-)%+([%-]?%d+)$")
    if name then
        return {name = name, low = tonumber(low) or 0, high = nil, color = color}
    end
    return nil
end

local function _add_merged_attr_line(order, map, line)
    local attr = _parse_attr_line(line)
    if not attr or attr.name == "" then
        return
    end
    local item = map[attr.name]
    if not item then
        item = {name = attr.name, low = 0, high = nil, color = attr.color}
        map[attr.name] = item
        order[#order + 1] = attr.name
    end
    item.low = item.low + (attr.low or 0)
    if attr.high ~= nil then
        item.high = (item.high or 0) + attr.high
    end
    if not item.color and attr.color then
        item.color = attr.color
    end
end

local ATTR_SORT_ID_BY_NAME = {
    ["生命值"] = 1,
    ["魔法值"] = 2,
    ["攻击"] = 3,
    ["攻击上限"] = 4,
    ["魔法"] = 5,
    ["魔法上限"] = 6,
    ["道术"] = 7,
    ["道术上限"] = 8,
    ["防御"] = 9,
    ["防御上限"] = 10,
    ["魔防"] = 11,
    ["魔法防御"] = 11,
    ["魔防上限"] = 12,
    ["准确"] = 13,
    ["敏捷"] = 14,
    ["打怪切割"] = 244,
}

local function _get_attr_sort_id(name)
    name = tostring(name or "")
    if ATTR_SORT_ID_BY_NAME[name] then
        return ATTR_SORT_ID_BY_NAME[name]
    end
    for attrId = 1, 320 do
        local cfg = SL:GetMetaValue("ATTR_CONFIG", attrId) or {}
        if tostring(cfg.name or "") == name then
            ATTR_SORT_ID_BY_NAME[name] = attrId
            return attrId
        end
    end
    return 999999
end

local function _escape_rich_text(text)
    text = tostring(text or "")
    text = text:gsub("&", "&amp;")
    text = text:gsub("<", "&lt;")
    text = text:gsub(">", "&gt;")
    return text
end

local function _format_merged_attr_lines(order, map)
    local lines = {}
    local sorted = {}
    local indexMap = {}
    for index, name in ipairs(order or {}) do
        indexMap[name] = index
        sorted[#sorted + 1] = name
    end
    table.sort(sorted, function(a, b)
        local sortA = _get_attr_sort_id(a)
        local sortB = _get_attr_sort_id(b)
        if sortA == sortB then
            return (indexMap[a] or 0) < (indexMap[b] or 0)
        end
        return sortA < sortB
    end)
    for _, name in ipairs(sorted) do
        local item = map[name]
        if item then
            local valueText = item.high ~= nil and string.format("+%d-%d", item.low or 0, item.high or 0) or string.format("+%d", item.low or 0)
            lines[#lines + 1] = string.format("<font color='%s'>%s%s</font>", item.color or "#F5E8C9", tostring(item.name or ""), valueText)
        end
    end
    return lines
end

local function _get_equipped_slot_map()
    local panel = _get_panel_data()
    local out = {}
    for _, entry in ipairs(panel.equipped or {}) do
        out[_toint(entry.slot, 0)] = entry
    end
    return out
end

local function _get_open_slots()
    return math.max(0, _toint(_get_panel_data().open_slots, 0))
end

local function _filter_item_list_by_open_slots(itemList)
    local out = {}
    for _, itemName in ipairs(itemList or {}) do
        if tostring(itemName or "") ~= "" then
            out[#out + 1] = itemName
        end
    end
    return out
end

local function _get_owned_map()
    return _get_panel_data().owned or {}
end

local function _get_progress_map()
    return _get_panel_data().progress or {}
end

local function _set_text_style(widget, color, size, outline)
    if not widget then
        return
    end
    if color then
        GUI:Text_setTextColor(widget, color)
    end
    if size then
        GUI:Text_setFontSize(widget, size)
    end
    GUI:Text_enableOutline(widget, outline or OUTLINE_COLOR, 2)
end

local function _create_stroke_text(parent, name, x, y, size, color, text, anchorX, anchorY, fontName)
    local widget = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", text or "")
    if anchorX ~= nil and anchorY ~= nil then
        GUI:setAnchorPoint(widget, anchorX, anchorY)
    end
    if fontName then
        GUI:Text_setFontName(widget, fontName)
    end
    GUI:Text_enableOutline(widget, OUTLINE_COLOR, 2)
    return widget
end

local function _create_center_rich_text(parent, name, x, y, html, width, size)
    local rich = GUI:RichText_Create(parent, name, x, y, html or "", width or 360, size or 20, "#FFFFFF", 1, nil, nil, {
        outlineSize = 2,
        outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),
    })
    GUI:setAnchorPoint(rich, 0.5, 0.5)
    return rich
end

local function _create_quality_stone_icon(parent, prefix, x, y, slotIndex, quality, bright, scale)
    quality = _toint(quality, 0)
    if quality > 0 and QUALITY_FRAME_SKIN[quality] then
        local frame = GUI:Image_Create(parent, prefix .. "_quality_frame", x, y, QUALITY_FRAME_SKIN[quality])
        GUI:setAnchorPoint(frame, 0.5, 0.5)
        GUI:setScale(frame, scale or (quality >= 3 and 0.76 or 0.68))
    end
    local icon = GUI:Image_Create(parent, prefix .. "_icon", x + 5, y - 10, _get_slot_icon_path(slotIndex, bright ~= false))
    GUI:setAnchorPoint(icon, 0.5, 0.5)
    if quality >= 4 then
        GUI:setScale(icon, 0.9)
    else
        GUI:setScale(icon, 0.8)
    end
    return icon
end

local function _create_quality_label(parent, name, x, y, quality)
    quality = _toint(quality, 0)
    local text = QUALITY_NAME[quality] or ""
    if text == "" then
        return nil
    end
    local label = _create_stroke_text(parent, name, x, y, quality >= 3 and 16 or 14, QUALITY_COLOR[quality] or "#FFFFFF", text, 0.5, 0.5, quality >= 3 and "fonts/500.ttf" or nil)
    if quality >= 3 then
        GUI:Text_enableOutline(label, QUALITY_COLOR[quality] or OUTLINE_COLOR, 1)
    end
    return label
end

local function _show_item_tips_by_name(itemName, anchorNode)
    local itemData = _get_item_data_by_name(itemName)
    if not itemData then
        return
    end
    local pos = anchorNode and GUI:getWorldPosition(anchorNode) or {x = 0, y = 0}
    SL:OpenItemTips({itemData = itemData, pos = {x = pos.x  + 100, y = pos.y}})
end

local function _create_desc_tip(tipNode, desc)
    if not tipNode or desc == "" then
        return
    end
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(tipNode, {
            onEnterFunc = function()
                local pos = GUI:getWorldPosition(tipNode)
                SL:OpenCommonDescTipsPop({str = desc, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
            end,
            onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end
        })
    else
        GUI:setTouchEnabled(tipNode, true)
        GUI:addOnTouchEvent(tipNode, function()
            local pos = GUI:getWorldPosition(tipNode)
            SL:OpenCommonDescTipsPop({str = desc, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end)
    end
end

--[[
合成状态与候选数据辅助方法说明：
1. _flatten_box_pool(boxName)
   用途：根据宝箱类型展开预览奖池，供宝箱页与开奖动画使用。
   参数：boxName=宝箱名称。
2. _ensure_compose_state()
   用途：初始化并返回合成页的本地状态缓存。
   参数：无。
3. _reset_compose_selection()
   用途：清空当前合成页已选材料状态。
   参数：无。
4. _recompute_slot_counts()
   用途：重算当前已选材料在各槽位上的数量分布。
   参数：无。
5. _get_compose_slot_list(level) / _get_compose_next_slot_list(level)
   用途：读取当前品质和下一品质的神石列表。
   参数：level=当前合成品质层级。
6. _build_compose_group_list()
   用途：从背包中提取当前可用于合成的神石分组数据。
   参数：无。
7. _get_group_used_count(group) / _get_group_remain_count(group)
   用途：统计某个神石分组已使用数量与剩余数量。
   参数：group=背包神石分组对象。
8. _pick_stack_from_group(group)
   用途：从某个分组中挑出一个还能继续使用的具体堆叠。
   参数：group=背包神石分组对象。
9. _add_group_to_compose(group)
   用途：向合成区追加一个指定分组的神石。
   参数：group=背包神石分组对象。
10. _remove_one_selected_by_slot(slotIndex)
    用途：从合成区移除一个指定槽位的已选神石。
    参数：slotIndex=槽位序号。
11. _auto_fill_compose()
    用途：按当前已选倾向和背包余量自动补满合成材料。
    参数：无。
12. _build_compose_probability_text()
    用途：根据当前材料分布拼接“100%/按占比随机”提示文案。
    参数：无。
]]
local function _flatten_box_pool(boxName)
    local pool = {}
    if boxName == "神石宝箱[史诗级]" then
        for _, itemName in ipairs(_filter_item_list_by_open_slots(npc._config.cost[2] or {})) do
            pool[#pool + 1] = itemName
        end
        return pool
    end
    if boxName == "神石宝箱[传说级]" then
        for _, itemName in ipairs(_filter_item_list_by_open_slots(npc._config.cost[3] or {})) do
            pool[#pool + 1] = itemName
        end
        return pool
    end
    for level = 1, #(npc._config.cost or {}) do
        for _, itemName in ipairs(_filter_item_list_by_open_slots(npc._config.cost[level] or {})) do
            pool[#pool + 1] = itemName
        end
    end
    return pool
end

local function _build_anim_box_pool(boxName, rewardName)
    local basePool = _flatten_box_pool(boxName)
    local qualityBuckets = {{}, {}, {}, {}}
    for _, itemName in ipairs(basePool) do
        local quality = math.max(1, math.min(_get_slot_quality(itemName), 4))
        qualityBuckets[quality][#qualityBuckets[quality] + 1] = itemName
    end
    local displayPool = {}
    local function pushFromQuality(quality, repeatCount)
        local bucket = qualityBuckets[quality] or {}
        if #bucket <= 0 then
            return
        end
        for _ = 1, repeatCount do
            for _, itemName in ipairs(bucket) do
                displayPool[#displayPool + 1] = itemName
            end
        end
    end
    pushFromQuality(1, 1)
    pushFromQuality(2, 2)
    pushFromQuality(3, 4)
    pushFromQuality(4, 5)
    if #displayPool <= 0 then
        displayPool = basePool
    end
    if #displayPool <= 0 then
        displayPool[1] = tostring(rewardName or "")
    end
    return displayPool
end

local function _build_box_preview_pool(boxName)
    local basePool = _flatten_box_pool(boxName)
    local qualityBuckets = {{}, {}, {}, {}}
    for _, itemName in ipairs(basePool) do
        local quality = math.max(1, math.min(_get_slot_quality(itemName), 4))
        qualityBuckets[quality][#qualityBuckets[quality] + 1] = itemName
    end
    local highestQuality = 0
    for quality = 4, 1, -1 do
        if #(qualityBuckets[quality] or {}) > 0 then
            highestQuality = quality
            break
        end
    end
    if highestQuality <= 0 then
        return {}
    end
    local previewPool = {}
    for _, itemName in ipairs(qualityBuckets[highestQuality]) do
        previewPool[#previewPool + 1] = itemName
    end
    for quality = highestQuality - 1, 1, -1 do
        if #previewPool >= 20 then
            break
        end
        for _, itemName in ipairs(qualityBuckets[quality]) do
            if #previewPool >= 20 then
                break
            end
            previewPool[#previewPool + 1] = itemName
        end
    end
    return previewPool
end

local function _ensure_compose_state()
    npc._composeState = npc._composeState or {}
    local state = npc._composeState
    state.maxLevel = math.max(1, #(npc._config.cost or {}) - 1)
    state.currentLevel = math.max(1, math.min(_toint(state.currentLevel, 1), state.maxLevel))
    state.selectedList = state.selectedList or {}
    state.selectedCounts = state.selectedCounts or {}
    state.slotCounts = state.slotCounts or {}
    return state
end

local function _reset_compose_selection()
    local state = _ensure_compose_state()
    state.selectedList = {}
    state.selectedCounts = {}
    state.slotCounts = {}
    state.currentLevel = 1
end

local function _is_double_click_action(key)
    key = tostring(key or "")
    if key == "" then
        return false
    end
    npc._doubleClickState = npc._doubleClickState or {}
    local now = os.clock()
    local last = npc._doubleClickState[key] or 0
    npc._doubleClickState[key] = now
    if now - last <= DOUBLE_CLICK_INTERVAL then
        npc._doubleClickState[key] = 0
        return true
    end
    return false
end

local function _recompute_slot_counts()
    local state = _ensure_compose_state()
    local counts = {}
    for _, entry in ipairs(state.selectedList) do
        counts[entry.slotIndex] = (counts[entry.slotIndex] or 0) + 1
    end
    state.slotCounts = counts
    return counts
end

local function _get_compose_slot_list(level)
    level = level or _ensure_compose_state().currentLevel
    return npc._config.cost[level] or {}
end

local function _get_compose_next_slot_list(level)
    level = level or _ensure_compose_state().currentLevel
    return npc._config.cost[level + 1] or {}
end

local function _build_compose_group_list(forceLevel)
    local state = _ensure_compose_state()
    local lockLevel = tonumber(forceLevel or (#state.selectedList > 0 and state.currentLevel or nil))
    local lookup = {}
    local maxLevel = state.maxLevel or math.max(1, #(npc._config.cost or {}) - 1)
    local startLevel = lockLevel or 1
    local endLevel = lockLevel or maxLevel
    for level = startLevel, endLevel do
        local slotList = npc._config.cost and npc._config.cost[level] or {}
        for idx, itemName in ipairs(slotList or {}) do
            lookup[itemName] = {slotIndex = idx, level = level}
        end
    end
    local groups = {}
    local groupMap = {}
    local bagData = SL:GetMetaValue("BAG_DATA") or {}
    for bagKey, itemData in pairs(bagData) do
        local itemName = tostring(itemData.Name or "")
        local info = lookup[itemName]
        if info then
            local makeIndex = tostring(itemData.MakeIndex or bagKey)
            local count = _toint(itemData.Count or itemData.OverLap or 1, 1)
            local groupKey = tostring(info.level) .. "|" .. itemName
            local group = groupMap[groupKey]
            if not group then
                group = {
                    itemName = itemName,
                    slotIndex = info.slotIndex,
                    level = info.level,
                    totalCount = 0,
                    itemData = itemData,
                    stacks = {},
                }
                groupMap[groupKey] = group
                groups[#groups + 1] = group
            end
            group.totalCount = group.totalCount + count
            group.stacks[#group.stacks + 1] = {
                makeIndex = makeIndex,
                count = count,
                itemData = itemData,
            }
        end
    end
    table.sort(groups, function(a, b)
        if a.level ~= b.level then
            return a.level < b.level
        end
        if a.slotIndex == b.slotIndex then
            return tostring(a.itemName) < tostring(b.itemName)
        end
        return a.slotIndex < b.slotIndex
    end)
    return groups
end

local function _build_embed_bag_godstone_list()
    local equippedMap = _get_equipped_slot_map()
    local equippedSame = {}
    for _, entry in pairs(equippedMap or {}) do
        local itemName = tostring(entry.item_name or "")
        local slotIndex = _get_slot_index_by_name(itemName)
        if slotIndex > 0 then
            equippedSame[slotIndex] = true
        end
    end
    local hasEmptySlot = false
    for slotIndex = 1, #SLOT_POS do
        if not equippedMap[slotIndex] or tostring(equippedMap[slotIndex].item_name or "") == "" then
            hasEmptySlot = true
            break
        end
    end
    local out = {}
    local bagData = SL:GetMetaValue("BAG_DATA") or {}
    for bagKey, itemData in pairs(bagData) do
        local itemName = tostring(itemData.Name or "")
        local slotIndex = _get_slot_index_by_name(itemName)
        if slotIndex > 0 then
            local quality = _get_slot_quality(itemName)
            local canTakeOn = hasEmptySlot and not equippedSame[slotIndex]
            out[#out + 1] = {
                itemName = itemName,
                slotIndex = slotIndex,
                quality = quality,
                canTakeOn = canTakeOn,
                makeIndex = tostring(itemData.MakeIndex or bagKey),
                itemData = itemData,
            }
        end
    end
    table.sort(out, function(a, b)
        if a.canTakeOn ~= b.canTakeOn then
            return a.canTakeOn
        end
        if a.quality ~= b.quality then
            return a.quality > b.quality
        end
        if a.slotIndex ~= b.slotIndex then
            return a.slotIndex < b.slotIndex
        end
        return tostring(a.itemName) < tostring(b.itemName)
    end)
    return out
end

local function _get_group_used_count(group)
    local state = _ensure_compose_state()
    local used = 0
    for _, stack in ipairs(group.stacks or {}) do
        used = used + _toint(state.selectedCounts[stack.makeIndex], 0)
    end
    return used
end

local function _get_group_remain_count(group)
    return math.max(0, _toint(group.totalCount, 0) - _get_group_used_count(group))
end

local function _pick_stack_from_group(group)
    local state = _ensure_compose_state()
    for _, stack in ipairs(group.stacks or {}) do
        local used = _toint(state.selectedCounts[stack.makeIndex], 0)
        if used < _toint(stack.count, 0) then
            return stack
        end
    end
    return nil
end

local function _add_group_to_compose(group)
    local state = _ensure_compose_state()
    if #state.selectedList >= NEED_ITEM_NUM then
        return false
    end
    local groupLevel = _toint(group and group.level, 0)
    if groupLevel <= 0 then
        return false
    end
    if #state.selectedList <= 0 then
        state.currentLevel = groupLevel
    elseif groupLevel ~= _toint(state.currentLevel, 1) then
        return false
    end
    local stack = _pick_stack_from_group(group)
    if not stack then
        return false
    end
    state.selectedList[#state.selectedList + 1] = {
        makeIndex = tostring(stack.makeIndex),
        slotIndex = group.slotIndex,
        level = groupLevel,
        itemName = group.itemName,
        itemData = stack.itemData or group.itemData,
    }
    state.selectedCounts[stack.makeIndex] = _toint(state.selectedCounts[stack.makeIndex], 0) + 1
    _recompute_slot_counts()
    return true
end

local function _remove_one_selected_by_slot(slotIndex)
    local state = _ensure_compose_state()
    for idx = #state.selectedList, 1, -1 do
        local entry = state.selectedList[idx]
        if _toint(entry.slotIndex, 0) == _toint(slotIndex, 0) then
            local makeIndex = tostring(entry.makeIndex or "")
            if makeIndex ~= "" then
                state.selectedCounts[makeIndex] = math.max(0, _toint(state.selectedCounts[makeIndex], 0) - 1)
            end
            table.remove(state.selectedList, idx)
            _recompute_slot_counts()
            if #state.selectedList <= 0 then
                state.currentLevel = 1
            else
                state.currentLevel = _toint(state.selectedList[1].level, state.currentLevel)
            end
            return true
        end
    end
    return false
end

local function _auto_fill_compose()
    local state = _ensure_compose_state()
    if #state.selectedList <= 0 then
        state.currentLevel = 1
    end
    local groups = _build_compose_group_list(state.currentLevel)
    local preferredMap = {}
    for slotIndex, count in pairs(state.slotCounts or {}) do
        if _toint(count, 0) > 0 then
            preferredMap[_toint(slotIndex, 0)] = true
        end
    end
    while #state.selectedList < NEED_ITEM_NUM do
        local candidate = nil
        for _, group in ipairs(groups) do
            local remain = _get_group_remain_count(group)
            if remain > 0 then
                local inPreferred = preferredMap[group.slotIndex] == true
                if not candidate then
                    candidate = group
                else
                    local candidatePreferred = preferredMap[candidate.slotIndex] == true
                    local candidateRemain = _get_group_remain_count(candidate)
                    if inPreferred and not candidatePreferred then
                        candidate = group
                    elseif inPreferred == candidatePreferred then
                        if remain > candidateRemain then
                            candidate = group
                        elseif remain == candidateRemain and group.slotIndex < candidate.slotIndex then
                            candidate = group
                        end
                    end
                end
            end
        end
        if not candidate then
            break
        end
        if not _add_group_to_compose(candidate) then
            break
        end
        preferredMap[candidate.slotIndex] = true
    end
end

local function _build_compose_probability_text()
    local state = _ensure_compose_state()
    local counts = _recompute_slot_counts()
    local parts = {}
    local total = #state.selectedList
    if total <= 0 then
        return string.format("请先放入 %d 个同品质神石", NEED_ITEM_NUM)
    end
    for slotIndex = 1, 8 do
        local count = _toint(counts[slotIndex], 0)
        if count > 0 then
            parts[#parts + 1] = string.format("%s %d/%d", _get_slot_base_name(slotIndex), count, NEED_ITEM_NUM)
        end
    end
    if #parts <= 0 then
        return string.format("当前已放入 %d/%d", total, NEED_ITEM_NUM)
    end
    local summary = table.concat(parts, "  ")
    if total >= NEED_ITEM_NUM then
        local uniqueCount = 0
        for _, count in pairs(counts) do
            if _toint(count, 0) > 0 then
                uniqueCount = uniqueCount + 1
            end
        end
        if uniqueCount == 1 then
            summary = summary .. "  100%获得对应高一级神石"
        else
            summary = summary .. "  按投入占比随机产出"
        end
    else
        summary = summary .. string.format("  当前进度 %d/%d", total, NEED_ITEM_NUM)
    end
    return summary
end

-- 生成神石合成页的固定消耗说明文本，直接展示必需数量与额外卷轴需求。
local function _build_compose_cost_text()
    local state = _ensure_compose_state()
    local parts = {string.format("必需数量：同品质神石 %d 个", NEED_ITEM_NUM)}
    local extra = npc._config.extra_cost and npc._config.extra_cost[state.currentLevel] or nil
    if type(extra) == "table" and extra[1] then
        parts[#parts + 1] = string.format("额外道具：%s x%s", tostring(extra[1][1] or ""), tostring(extra[1][2] or 1))
    end
    return table.concat(parts, "    ")
end

--[[
网络请求与主界面绘制方法说明：
1. _send_compose_request(npcid)
   用途：向服务端提交当前合成请求。
   参数：npcid=当前神石 NPC 编号。
2. _send_takeoff_all(npcid)
   用途：向服务端请求一键卸下全部神石。
   参数：npcid=当前神石 NPC 编号。
3. _send_open_box(npcid, boxName)
   用途：向服务端请求开启指定类型的神石宝箱。
   参数：npcid=当前神石 NPC 编号；boxName=宝箱名称。
4. _render_page_bg(node)
   用途：根据当前页签重建页面底图，避免复用已销毁的 cobj。
   参数：node=页面根节点。
5. _ensure_window(npcid)
   用途：创建或复用神石主窗口，并返回内容节点。
   参数：npcid=当前神石 NPC 编号。
6. _render_left_tabs(node, npcid)
   用途：绘制左侧页签并切换主页面。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
7. _render_embed_attr_panel(node) / _render_embed(node, npcid)
   用途：绘制镶嵌页的属性预览和槽位状态。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
8. _render_compose_level_tabs(node, npcid) / _render_compose_target_slots(node)
   用途：绘制合成页品质切换和目标槽位区域。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
9. _render_compose_bag(node, npcid) / _render_compose(node, npcid)
   用途：绘制背包候选材料与合成页整体按钮区域。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
10. _render_box_preview(node) / _render_box_cost(node) / _render_box_selector(node, npcid)
    用途：绘制宝箱页预览、消耗展示和宝箱类型切换。
    参数：node=页面根节点；npcid=当前神石 NPC 编号。
]]
local function _send_compose_request(npcid)
    local state = _ensure_compose_state()
    if #state.selectedList ~= NEED_ITEM_NUM then
        SL:ShowSystemTips(string.format("<font color='#FF0000'>需要放入%d个神石后才可合成</font>", NEED_ITEM_NUM))
        return
    end
    state.currentLevel = _toint(state.selectedList[1] and state.selectedList[1].level, state.currentLevel)
    local payload = {item_level = state.currentLevel, itemlist = {}}
    for _, entry in ipairs(state.selectedList) do
        payload.itemlist[#payload.itemlist + 1] = tostring(entry.makeIndex)
    end
    SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode(payload, false))
end

local function _send_takeoff_all(npcid)
    SL:SendLuaNetMsg(100, npcid, 3, 0, "")
end

local function _send_open_box(npcid, boxName)
    if not boxName or boxName == "" then
        boxName = BOX_NAME_ORDER[1]
    end
    SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({box_name = boxName}, false))
end

local function _send_claim_box_reward(npcid, token)
    SL:SendLuaNetMsg(100, npcid, 4, 0, SL:JsonEncode({token = tostring(token or "")}, false))
end

local function _request_panel_refresh(npcid)
    SL:SendLuaNetMsg(100, npcid or npc._npcid or 53, 7, 0, "")
end

local function _schedule_panel_refresh(npcid)
    if not npc.node or (tolua and tolua.isnull and tolua.isnull(npc.node)) then
        return
    end
    SL:scheduleOnce(npc.node, function()
        _request_panel_refresh(npcid)
    end, 0.15)
end

local function _get_user_default()
    if cc and cc.UserDefault and cc.UserDefault.getInstance then
        return cc.UserDefault:getInstance()
    end
    return nil
end

local function _load_skip_box_anim()
    if npc._skip_box_anim ~= nil then
        return npc._skip_box_anim == true
    end
    local userDefault = _get_user_default()
    if userDefault and userDefault.getBoolForKey then
        npc._skip_box_anim = userDefault:getBoolForKey(BOX_SKIP_ANIM_KEY, false) == true
    else
        npc._skip_box_anim = false
    end
    return npc._skip_box_anim == true
end

local function _save_skip_box_anim(enabled)
    npc._skip_box_anim = enabled == true
    local userDefault = _get_user_default()
    if userDefault and userDefault.setBoolForKey then
        userDefault:setBoolForKey(BOX_SKIP_ANIM_KEY, npc._skip_box_anim)
        if userDefault.flush then
            userDefault:flush()
        end
    end
end

local function _send_take_on_godstone(npcid, makeIndex)
    SL:SendLuaNetMsg(100, npcid, 5, 0, SL:JsonEncode({makeIndex = tostring(makeIndex or "")}, false))
    _schedule_panel_refresh(npcid)
end

local function _send_take_off_godstone(npcid, where)
    SL:SendLuaNetMsg(100, npcid, 6, 0, SL:JsonEncode({where = _toint(where, 0)}, false))
    _schedule_panel_refresh(npcid)
end

local function _render_page_bg(node)
    if not node then
        return
    end
    local skin = PAGE_BG[npc._page]
    if not skin then
        return
    end
    GUI:Image_Create(node, "page_bg", 184, 20, skin)
end

local function _ensure_window(npcid)
    npc._page = npc._page or "embed"
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, {
        windowName = WINDOW_NAME,
        background = {
            skin = "res/custom/three_city/sshc/new/底板.png",
        },
        closeButton = {
            x = 808 + 15,
            y = 488 - 80 + 15,
        },
        node = {
            x = 0,
            y = 0,
        },
    })
    npc.node = npc._window.node
    return npc.node
end

local function _render_left_tabs(node, npcid)
    for _, page in ipairs(PAGE_ORDER) do
        local skin = string.format("res/custom/three_city/sshc/new/左侧按钮/%s/%s.png", npc._page == page and "亮" or "暗", PAGE_KEY[page])
        local pos = LEFT_TAB_POS[page]
        local btn = GUI:Button_Create(node, "page_" .. page, pos.x, pos.y, skin)
        GUI:setTouchEnabled(btn, true)
        GUI:addOnClickEvent(btn, function()
            if npc._page == page then
                return
            end
            npc._page = page
            if page ~= "compose" then
                _reset_compose_selection()
            end
            if npc._render_current_page and npc.node then
                npc._render_current_page(npc.node, npcid)
            end
        end)
    end
end

local function _render_embed_attr_panel(node)
    local attrOrder = {}
    local attrMap = {}
    local equippedMap = _get_equipped_slot_map()
    for slotIndex = 1, 8 do
        local entry = equippedMap[slotIndex]
        if entry and entry.item_name and entry.item_name ~= "" then
            local equipData = SL:GetMetaValue("EQUIP_DATA", _toint(entry.where, 0))
            if equipData then
                local attr = _strip_stone_name_from_attr_text(Player:showEquipAttrMergedRange(equipData) or "")
                _each_attr_line(attr, function(line)
                    _add_merged_attr_line(attrOrder, attrMap, line)
                end)
            end
        end
    end
    local attrText = _format_merged_attr_lines(attrOrder, attrMap)
    if #attrText <= 0 then
        attrText[1] = "<font color='#C8C8C8'>当前尚未装配神石</font>"
    end
    local scroll = GUI:ScrollView_Create(node, "embed_attr_scroll", 660, 155 - 100, 170, 244 - 10 + 100, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, 170, math.max(244, 28 + #attrText * 26))
    GUI:RichText_Create(scroll, "embed_attr", 8, math.max(18, #attrText * 26) - 10 - 30, table.concat(attrText, "\n"), 154, 16, "#F5E8C9", 1, nil, nil, {
        outlineSize = 2,
        outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),
    })
    _create_stroke_text(node, "embed_attr_tip", 744, 128 - 90, 16, "#9FB6B8", "属性随穿戴实时生效", 0.5, 0.5)
end

local function _render_embed_bag_list(node, npcid)
    local bagList = _build_embed_bag_godstone_list()
    local list = GUI:ListView_Create(node, "embed_bag_stone_list", 206 - 14, 20, 430 + 20, 143, 2)
    GUI:ListView_setBounceEnabled(list, true)
    GUI:ListView_setItemsMargin(list, 0)
    if #bagList <= 0 then
        _create_stroke_text(node, "embed_bag_empty", 420, 86, 16, "#9FB6B8", "背包中暂无神石", 0.5, 0.5)
        return
    end
    for idx, entry in ipairs(bagList) do
        local slot = GUI:Layout_Create(-1, "embed_bag_slot_" .. idx, 0, 0, 100, 70, false)
        GUI:ListView_pushBackCustomItem(list, slot)
        _create_quality_stone_icon(slot, "embed_bag_" .. idx, 50, 43, entry.slotIndex, entry.quality, entry.canTakeOn)
        -- _create_stroke_text(slot, "embed_bag_name_" .. idx, 31, 8, 12, entry.canTakeOn and (QUALITY_COLOR[entry.quality] or "#F3F3F3") or "#777777", _get_short_stone_name(entry.itemName, entry.slotIndex), 0.5, 0.5)
        if entry.canTakeOn then
            _create_stroke_text(slot, "embed_bag_mark_" .. idx, 48 + 35, 60, 12, "#74FF9F", "可", 0.5, 0.5)
        end
        local touch = GUI:Layout_Create(slot, "embed_bag_touch_" .. idx, 0, 0, 62, 70, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnClickEvent(touch, function()
            if entry.canTakeOn then
                if _is_double_click_action("embed_bag_" .. tostring(entry.makeIndex or "")) then
                    _send_take_on_godstone(npcid, entry.makeIndex)
                else
                    _show_item_tips_by_name(entry.itemName, touch)
                    SL:ShowSystemTips("<font color='#FFCC66'>再次点击可直接穿戴该神石</font>")
                end
            else
                _show_item_tips_by_name(entry.itemName, touch)
                SL:ShowSystemTips("<font color='#FFCC66'>当前没有空槽或同名神石已穿戴</font>")
            end
        end)
    end
end

local function _render_embed(node, npcid)
    local equippedMap = _get_equipped_slot_map()
    local openSlots = _get_open_slots()
    for slotIndex, pos in ipairs(SLOT_POS) do
        local isOpen = slotIndex <= openSlots
        local entry = equippedMap[slotIndex]
        local hasEquip = entry and entry.item_name and entry.item_name ~= ""
        local baseNode = GUI:Layout_Create(node, "embed_slot_" .. slotIndex, pos.x - 54, pos.y - 54, 108, 120, false)
        local quality = hasEquip and _get_slot_quality(entry.item_name) or 0
        local stoneSlotIndex = hasEquip and math.max(1, _get_slot_index_by_name(entry.item_name)) or slotIndex
        if hasEquip then
            _create_quality_stone_icon(baseNode, "slot_" .. slotIndex, 54, 62, stoneSlotIndex, quality, true)
        else
            local icon = GUI:Image_Create(baseNode, "slot_icon_" .. slotIndex, 54, 62, EMPTY_STONE_SKIN)
            GUI:setAnchorPoint(icon, 0.5, 0.5)
        end
        if not isOpen then
            GUI:Image_Create(baseNode, "slot_lock_" .. slotIndex, 5, 15, "res/custom/three_city/sshc/new/神石icon/锁.png")
            -- _create_stroke_text(baseNode, "slot_lock_text_" .. slotIndex, 54, 8, 14, "#B8B8B8", string.format("第%d槽", slotIndex), 0.5, 0.5)
        elseif not hasEquip then
            local btn = GUI:Layout_Create(baseNode, "slot_touch_" .. slotIndex, 0, 0, 108, 120, false)
            GUI:setTouchEnabled(btn, true)
            GUI:addOnClickEvent(btn, function()
                SL:ShowSystemTips("<font color='#FFCC66'>点击下方背包神石可直接穿戴</font>")
            end)
        end
        -- local labelColor = not isOpen and "#8E8E8E" or (hasEquip and (QUALITY_COLOR[_get_slot_quality(entry.item_name)] or "#FFFFFF") or "#F3F3F3")
        -- _create_stroke_text(baseNode, "slot_name_" .. slotIndex, 54, 10, 17, labelColor, hasEquip and _get_short_stone_name(entry.item_name, stoneSlotIndex) or _get_embed_slot_label(slotIndex), 0.5, 0.5)
        if hasEquip then
            -- _create_quality_label(baseNode, "slot_quality_" .. slotIndex, 54, 104, quality)
            local tipBtn = GUI:Layout_Create(baseNode, "slot_tip_" .. slotIndex, 0, 0, 108, 120, false)
            GUI:setTouchEnabled(tipBtn, true)
            GUI:addOnClickEvent(tipBtn, function()
                if _is_double_click_action("embed_slot_" .. tostring(entry.where or slotIndex)) then
                    _send_take_off_godstone(npcid, entry.where)
                else
                    _show_item_tips_by_name(entry.item_name, tipBtn)
                    SL:ShowSystemTips("<font color='#FFCC66'>再次点击可卸下该神石</font>")
                end
            end)
        end
    end
    _render_embed_bag_list(node, npcid)
    _render_embed_attr_panel(node)
end

local function _render_compose_level_tabs(node, npcid)
    local state = _ensure_compose_state()
    local level = _toint(state.currentLevel, 1)
    local leftName = ATLAS_TAB_NAME[level] or tostring(level)
    local rightName = ATLAS_TAB_NAME[level + 1] or tostring(level + 1)
    local text = #state.selectedList > 0 and string.format("当前阶段：%s→%s", leftName, rightName) or "默认阶段：稀有→史诗"
    _create_stroke_text(node, "compose_level_hint", 428, 410, 18, "#F6E6B4", text, 0.5, 0.5)
    if #state.selectedList <= 0 then
        _create_stroke_text(node, "compose_level_tip", 428, 386, 15, "#C7E7E3", "选择第一颗神石后自动锁定对应合成阶段", 0.5, 0.5)
    end
end

local function _render_compose_target_slots(node)
    local state = _ensure_compose_state()
    local nextList = _get_compose_next_slot_list(state.currentLevel)
    local counts = _recompute_slot_counts()
    for slotIndex, pos in ipairs(SLOT_POS) do
        local itemName = nextList[slotIndex] or ""
        local itemData = _get_item_data_by_name(itemName)
        local baseNode = GUI:Layout_Create(node, "compose_target_" .. slotIndex, pos.x - 54 - 10, pos.y - 54 - 38, 108, 120, false)
        local quality = _get_slot_quality(itemName)
        _create_quality_stone_icon(baseNode, "compose_" .. slotIndex, 54, 62, slotIndex, quality, true)
        if itemData then
            local touch = GUI:Layout_Create(baseNode, "compose_touch_" .. slotIndex, 0, 0, 108, 120, false)
            GUI:setTouchEnabled(touch, true)
            GUI:addOnTouchEvent(touch, function()
                _show_item_tips_by_name(itemName, touch)
            end)
            GUI:addOnClickEvent(touch, function()
                if _remove_one_selected_by_slot(slotIndex) then
                    if npc._render_current_page then
                        npc._render_current_page(node, npcid)
                    end
                end
            end)
        end
        -- _create_stroke_text(baseNode, "compose_name_" .. slotIndex, 54, 10, 17, QUALITY_COLOR[quality] or "#F5F5F5", _get_short_stone_name(itemName, slotIndex), 0.5, 0.5)
        -- _create_quality_label(baseNode, "compose_quality_" .. slotIndex, 54, 104, quality)
        local selectedCount = _toint(counts[slotIndex], 0)
        if selectedCount > 0 then
            _create_stroke_text(baseNode, "compose_count_" .. slotIndex, 84 - 53, 100, 20, "#53F8BC", "x" .. tostring(selectedCount), 0.5, 0.5)
        end
    end
end

local function _render_compose_bag(node, npcid)
    local state = _ensure_compose_state()
    local groups = _build_compose_group_list()
    local list = GUI:ListView_Create(node, "compose_bag_list", 660, 75 - 50, 180, 333, 1)
    GUI:ListView_setItemsMargin(list, 6)
    if #groups <= 0 then
        _create_stroke_text(node, "compose_empty_1", 731, 252, 18, "#FFCC8A", "暂无可合成神石", 0.5, 0.5)
        _create_stroke_text(node, "compose_empty_2", 731, 222, 15, "#9FB6B8", "检查背包或清空已选材料", 0.5, 0.5)
        return
    end
    -- local bagHint = #state.selectedList > 0 and string.format("当前只显示%s材料", ATLAS_TAB_NAME[state.currentLevel] or tostring(state.currentLevel)) or "未选择：显示全部神石"
    -- _create_stroke_text(node, "compose_bag_hint", 731, 420, 15, "#BFFFEF", bagHint, 0.5, 0.5)
    for idx, group in ipairs(groups) do
        local row = GUI:Layout_Create(-1, "compose_bag_row_" .. idx, 0, 0, 154, 58, false)
        GUI:ListView_pushBackCustomItem(list, row)
        local itemData = group.itemData
        if itemData then
            -- 合成背包列表中的神石仅用于拖入前预览，不允许直接拖出列表控件。
            GUI:ItemShow_Create(row, "compose_item_" .. idx, 6, 7, {itemData = itemData, count = 1, look = true, movable = false, bgVisible = false})
        end
        local levelText = #state.selectedList <= 0 and ((ATLAS_TAB_NAME[group.level] or tostring(group.level)) .. " ") or ""
        _create_stroke_text(row, "compose_item_name_" .. idx, 54, 38, 14, "#F7E7C0", levelText .. _get_short_stone_name(group.itemName, group.slotIndex), 0, 0.5)
        local remain = _get_group_remain_count(group)
        _create_stroke_text(row, "compose_item_count_" .. idx, 54, 18, 13, remain > 0 and "#8DFFB9" or "#A8A8A8", string.format("%d/%d", remain, _toint(group.totalCount, 0)), 0, 0.5)
        -- _create_stroke_text(row, "compose_item_put_" .. idx, 148, 29, 14, remain > 0 and "#7BFFE3" or "#7E7E7E", "+", 1, 0.5)
        local clicker = GUI:Image_Create(row, "compose_item_put_" .. idx, 130, 15, "res/wy/public/hd_sd_jia.png")
        GUI:setTouchEnabled(clicker, true)
        GUI:addOnClickEvent(clicker, function()
            if _add_group_to_compose(group) then
                if npc._render_current_page then
                    npc._render_current_page(node, npcid)
                end
            else
                SL:ShowSystemTips("<font color='#FF0000'>当前神石数量不足、阶段不一致或已放满</font>")
            end
        end)
    end
end

local function _render_compose(node, npcid)
    -- _render_compose_level_tabs(node, npcid)
    _render_compose_target_slots(node)
    _render_compose_bag(node, npcid)
    -- _create_stroke_text(node, "compose_rule", 428, 457, 17, "#F5E2AF", tostring(npc._config.compose_desc or "十个相同品质的神石可以合成出更高一级的神石"), 0.5, 0.5)
    -- _create_stroke_text(node, "compose_prob", 428, 429, 16, "#EFD9A7", _build_compose_probability_text(), 0.5, 0.5)
    -- -- 合成页常驻展示必需数量与额外卷轴消耗，避免玩家只能通过问号查看。
    -- _create_stroke_text(node, "compose_cost_rule", 428, 402, 15, "#FFD891", _build_compose_cost_text(), 0.5, 0.5)
    -- _create_stroke_text(node, "compose_tip", 214, 100, 16, "#E6D2A5", "提示：自动补充会优先选择同类型神石", 0, 0.5)

    local takeoffBtn = GUI:Button_Create(node, "compose_takeoff_btn", 236, 145 - 18, "res/custom/three_city/sshc/new/合成/一键卸下.png")
    GUI:addOnClickEvent(takeoffBtn, function()
        _reset_compose_selection()
        if npc._render_current_page and node and not (tolua and tolua.isnull and tolua.isnull(node)) then
            npc._render_current_page(node, npcid)
        end
    end)

    local autoFillBtn = GUI:Button_Create(node, "compose_auto_fill_btn", 445, 145 - 18, "res/custom/three_city/sshc/new/合成/自动补充.png")
    GUI:addOnClickEvent(autoFillBtn, function()
        _auto_fill_compose()
        if npc._render_current_page and node and not (tolua and tolua.isnull and tolua.isnull(node)) then
            npc._render_current_page(node, npcid)
        end
    end)

    local composeBtn = GUI:Button_Create(node, "compose_btn", 348, 20, "res/custom/three_city/sshc/new/合成/立即合成.png")
    GUI:addOnClickEvent(composeBtn, function()
        _send_compose_request(npcid)
    end)

    local tipBtn = GUI:Button_Create(node, "compose_rule_btn", 561 - 365, 33, "res/custom/three_city/sshc/new/合成/本次可能会出...png")
    local state = _ensure_compose_state()


    GUI:addOnClickEvent(tipBtn, function()
        local extra = npc._config.extra_cost and npc._config.extra_cost[state.currentLevel] or nil
        local extraText = ""
        if type(extra) == "table" and extra[1] then
            extraText = string.format("<br><font color='#f5c35d'>额外消耗：%s*%s</font>", tostring(extra[1][1] or ""), tostring(extra[1][2] or 1))
        end
        local pos = GUI:getWorldPosition(tipBtn)
        SL:OpenCommonDescTipsPop({
            str = string.format("<font color='#ffffff'>%s</font>%s", _build_compose_probability_text(), extraText),
            worldPos = {x = pos.x, y = pos.y},
            anchorPoint = {x = 0, y = 0},
            formatWay = 1
        })
    end)
end

local function _render_box_preview(node)
    local boxName = _get_current_box_name()
    local previewPool = _build_box_preview_pool(boxName)
    local list = GUI:ListView_Create(node, "box_preview_list", 184, 250, 532 + 113, 116, 2)
    GUI:ListView_setItemsMargin(list, 10)
    if #previewPool <= 7 then
        GUI:ListView_setItemsMargin(list, 4)
    end
    for idx, itemName in ipairs(previewPool) do
        local slot = GUI:Layout_Create(-1, "box_preview_slot_" .. idx, 0, 0, 76, 112, false)
        GUI:ListView_pushBackCustomItem(list, slot)
        local slotIndex = math.max(1, _get_slot_index_by_name(itemName))
        local quality = _get_slot_quality(itemName)
        _create_quality_stone_icon(slot, "box_preview_" .. idx, 36, 62, slotIndex, quality, true, quality >= 3 and 0.56 or 0.5)
        -- _create_stroke_text(slot, "box_preview_name_" .. idx, 38, 10, 15, QUALITY_COLOR[quality] or "#F3F3F3", _get_short_stone_name(itemName, slotIndex), 0.5, 0.5)
    end
end

local function _render_box_cost(node)
    local boxName = _get_current_box_name()
    local boxCount = _get_panel_boxes()[boxName] or 0
    local keyCount = _toint(_get_panel_data().key_count, 0)
    local boxIndex = _get_item_index_by_name(boxName)
    local keyIndex = _get_item_index_by_name("神石宝箱钥匙")
    if boxIndex > 0 then
        GUI:ItemShow_Create(node, "box_cost_box", 355 + 100, 169 - 50, {index = boxIndex, count = 1, look = true, movable = false, bgVisible = false})
    end
    if keyIndex > 0 then
        GUI:ItemShow_Create(node, "box_cost_key", 443 + 100, 169 - 50, {index = keyIndex, count = 1, look = true, movable = false, bgVisible = false})
    end
    -- _create_stroke_text(node, "box_cost_title", 400, 262, 20, "#F5E7B8", "所需材料", 0.5, 0.5)
    _create_stroke_text(node, "box_cost_box_count", 354 + 115, 136 - 20, 16, boxCount > 0 and "#79FFAE" or "#FF8C8C", string.format("%d/1", boxCount), 0.5, 0.5)
    _create_stroke_text(node, "box_cost_key_count", 444 + 115, 136 - 20, 16, keyCount > 0 and "#79FFAE" or "#FF8C8C", string.format("%d/1", keyCount), 0.5, 0.5)
end

local function _render_box_selector(node, npcid)
    local boxes = _get_panel_boxes()
    for idx, boxName in ipairs(BOX_NAME_ORDER) do
        local x = 245 + (idx - 1) * 130
        local btn = GUI:Layout_Create(node, "box_selector_" .. idx, x, 202, 122, 24, false)
        GUI:setTouchEnabled(btn, true)
        GUI:addOnClickEvent(btn, function()
            npc._boxName = boxName
            if npc._render_current_page then
                npc._render_current_page(node, npcid)
            end
        end)
        local color = npc._boxName == boxName and "#F5E7B8" or "#7C7C7C"
        local count = _toint(boxes[boxName], 0)
        local shortName = idx == 1 and "普通宝箱" or (idx == 2 and "史诗宝箱" or "传说宝箱")
        _create_stroke_text(btn, "box_selector_text_" .. idx, 61, 12, 15, color, string.format("%s(%d)", shortName, count), 0.5, 0.5)
    end
    local tip = GUI:Image_Create(node, "box_tip", 698, 203, "res/custom/msfc/page1/wenhao.png")
    _create_desc_tip(tip, _get_box_rate_desc(_get_current_box_name()))
end

--[[
弹窗与页面切换方法说明：
1. _close_box_popup()
   用途：关闭当前神石开箱结果弹窗。
   参数：无。
2. _show_box_result_popup(resultData)
   用途：根据服务端返回的开奖结果播放动画并刷新主页面。
   参数：resultData=服务端返回的开奖结果表，包含 reward_name、quality_title、panel 等字段。
3. _render_box(node, npcid)
   用途：绘制宝箱主页面。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
4. _render_atlas(node, npcid)
   用途：绘制图鉴页面和品质切换。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
5. _render_current_page(node, npcid)
   用途：按照当前页签重绘主页面内容。
   参数：node=页面根节点；npcid=当前神石 NPC 编号。
]]
local function _close_box_popup()
    local parent = GUI:GetWindow(nil, "npc_53_box_popup")
    if parent then
        GUI:Win_Close(parent)
    end
end

local function _show_box_result_popup(resultData)
    resultData = resultData or {}
    if resultData.panel then
        npc.data = resultData.panel
    end
    if _load_skip_box_anim() then
        local claimToken = tostring(resultData.token or "")
        if claimToken ~= "" then
            _send_claim_box_reward(npc._npcid or 53, claimToken)
        end
        return
    end
    _close_box_popup()
    local parent = GUI:Win_Create("npc_53_box_popup", 0, 0, 0, 0, false, false, true, true, true, nil, 30)
    local overlay = GUI:Image_Create(parent, "overlay", cogin.w/2, cogin.h/2, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(overlay, 0.5, 0.5)
    GUI:setContentSize(overlay, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(overlay, true)
    local panel = GUI:Image_Create(parent, "panel", cogin.w / 2, cogin.h / 2, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/恭喜获得.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local topCloseBtn = GUI:Button_Create(panel, "popup_top_close_btn", 492, 424, "res/wy/public/close_red_big.png")
    GUI:setVisible(topCloseBtn, false)
    GUI:addOnClickEvent(topCloseBtn, function()
        _close_box_popup()
    end)
    local stripMask = GUI:Layout_Create(panel, "strip_mask", 74, 138, 392, 120, false)
    GUI:Layout_setClippingEnabled(stripMask, true)
    local strip = GUI:Node_Create(stripMask, "strip", 0, 0)
    local highlight = GUI:Image_Create(panel, "highlight", 268, 138 - 175, "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/边框.png")
    GUI:setAnchorPoint(highlight, 0.5, 0)
    local previewPool = _build_anim_box_pool(tostring(resultData.box_name or BOX_NAME_ORDER[1]), tostring(resultData.reward_name or ""))
    if #previewPool <= 0 then
        previewPool[1] = tostring(resultData.reward_name or "")
    end
    local targetIndex = 11
    local totalCells = 18
    local cellWidth = 108
    local targetX = 196
    for idx = 1, totalCells do
        local itemName = previewPool[((idx - 1) % #previewPool) + 1]
        if idx == targetIndex then
            itemName = tostring(resultData.reward_name or itemName)
        end
        local slot = GUI:Layout_Create(strip, "box_roll_slot_" .. idx, (idx - 1) * cellWidth, 0, 100, 120, false)
        GUI:setAnchorPoint(slot, 0, 0)
        local slotIndex = math.max(1, _get_slot_index_by_name(itemName))
        local quality = math.max(1, _get_slot_quality(itemName))
        _create_quality_stone_icon(slot, "box_roll_" .. idx, 50, 62, slotIndex, quality, true, quality >= 3 and 0.62 or 0.56)
        _create_stroke_text(slot, "box_roll_name_" .. idx, 50, 12, 15, QUALITY_COLOR[quality] or "#F3F3F3", _get_short_stone_name(itemName, slotIndex), 0.5, 0.5)
    end

    local function finish_show()
        local rewardName = tostring(resultData.reward_name or "")
        local qualityText = tostring(resultData.quality_title or "")
        local rewardIndex = math.max(1, _get_slot_index_by_name(rewardName))
        GUI:setVisible(stripMask, false)
        GUI:setVisible(highlight, false)
        _create_quality_stone_icon(panel, "result", 270, 248 - 10, rewardIndex, _get_slot_quality(rewardName), true, 0.82)
        _create_stroke_text(panel, "result_name", 270, 176 - 10, 22, QUALITY_COLOR[_get_slot_quality(rewardName)] or "#FFFFFF", _get_short_stone_name(rewardName, rewardIndex) .. "神石", 0.5, 0.5, "fonts/500.ttf")
        -- _create_stroke_text(panel, "result_quality", 270, 144, 18, "#FFE6A1", qualityText ~= "" and qualityText or "获得成功", 0.5, 0.5)
        local claimToken = tostring(resultData.token or "")
        if claimToken ~= "" then
            _send_claim_box_reward(npc._npcid or 53, claimToken)
        end
        GUI:setVisible(topCloseBtn, true)
        local closeBtn = GUI:Button_Create(panel, "result_close_btn", 78, 90 - 10, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/我知道了.png")
        GUI:addOnClickEvent(closeBtn, function()
            _close_box_popup()
        end)
        local reopenBtn = GUI:Button_Create(panel, "result_reopen_btn", 297, 90 - 10, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/再次开启.png")
        GUI:addOnClickEvent(reopenBtn, function()
            -- _close_box_popup()
            _send_open_box(npc._npcid or 53, tostring(resultData.box_name or _get_current_box_name()))
        end)
        GUI:addOnClickEvent(overlay, function()
            _close_box_popup()
        end)
    end

    GUI:setPosition(strip, 0, 0)
    local finalX = targetX - (targetIndex - 1) * cellWidth
    GUI:runAction(strip, GUI:ActionSequence(
        GUI:ActionMoveTo(0.45, finalX + cellWidth * 3, 0),
        GUI:ActionMoveTo(0.65, finalX + cellWidth, 0),
        GUI:ActionMoveTo(0.9, finalX, 0),
        GUI:CallFunc(function()
            finish_show()
        end)
    ))
end

local function _render_box(node, npcid)
    npc._boxName = _get_current_box_name()
    _render_box_preview(node)
    -- _render_box_selector(node, npcid)
    _render_box_cost(node)

    -- local skipLabel = _create_stroke_text(node, "box_skip_label", 232, 78, 22, "#F3E3A8", "跳过动画", 0, 0.5)
    local skipCheck = GUI:CheckBox_Create(node, "box_skip_check", 250, 52, "res/custom/three_city/sshc/new/宝箱/跳过动画空对号.png", "res/custom/three_city/sshc/new/宝箱/跳过动画有对号.png")
    GUI:CheckBox_setSelected(skipCheck, _load_skip_box_anim())
    GUI:CheckBox_addOnEvent(skipCheck, function(sender)
        _save_skip_box_anim(GUI:CheckBox_isSelected(sender))
    end)

    local openBtn = GUI:Button_Create(node, "box_open_btn", 412, 35, "res/custom/three_city/sshc/new/宝箱/立即开启.png")
    GUI:addOnClickEvent(openBtn, function()
        _send_open_box(npcid, _get_current_box_name())
    end)

    local bagBtn = GUI:Button_Create(node, "box_bag_btn", 642, 35, "res/custom/three_city/sshc/new/宝箱/箱子不够了？点我！.png")
    GUI:addOnClickEvent(bagBtn, function()
        SL:OpenBagUI()
    end)
end

local function _render_atlas(node, npcid)
    local atlasQuality = math.max(1, math.min(_toint(npc._atlasQuality, 1), 4))
    npc._atlasQuality = atlasQuality
    local progressMap = _get_progress_map()
    local ownedMap = _get_owned_map()
    for quality = 1, 4 do
        local folder = atlasQuality == quality and "亮" or "暗"
        local btn = GUI:Button_Create(node, "atlas_top_" .. quality, ATLAS_TOP_TAB_POS[quality].x, ATLAS_TOP_TAB_POS[quality].y - 35, string.format("res/custom/three_city/sshc/new/图鉴/上方按钮/%s/%s级图鉴.png", folder, ATLAS_TAB_NAME[quality]))
        GUI:addOnClickEvent(btn, function()
            if npc._atlasQuality == quality then
                return
            end
            npc._atlasQuality = quality
            if npc._render_current_page then
                npc._render_current_page(node, npcid)
            end
        end)
    end

    local list = npc._config.cost[atlasQuality] or {}
    for slotIndex, pos in ipairs(SLOT_POS) do
        local itemName = list[slotIndex] or ""
        local owned = ownedMap[itemName] == 1 or ownedMap[itemName] == true
        local baseNode = GUI:Layout_Create(node, "atlas_slot_" .. slotIndex, pos.x - 54 + 72, pos.y - 54 - 58, 108, 120, false)
        local quality = atlasQuality
        _create_quality_stone_icon(baseNode, "atlas_" .. slotIndex, 54, 62, slotIndex, quality, owned)
        if not owned then
            -- GUI:Image_Create(baseNode, "atlas_lock_" .. slotIndex, 10, 15, "res/custom/three_city/sshc/new/神石icon/锁.png")
        end
        -- _create_stroke_text(baseNode, "atlas_name_" .. slotIndex, 54, 10, 17, owned and (QUALITY_COLOR[quality] or "#F3F3F3") or "#A0A0A0", _get_short_stone_name(itemName, slotIndex), 0.5, 0.5)
        local touch = GUI:Layout_Create(baseNode, "atlas_touch_" .. slotIndex, 0, 0, 108, 120, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnTouchEvent(touch, function()
            _show_item_tips_by_name(itemName, touch)
        end)

    end

    local progress = progressMap[tostring(atlasQuality)] or {}
    local hit = _toint(progress.hit, 0)
    local total = _toint(progress.total, 0)
    local rewardLevel = _toint(progress.reward, 0)
    local line = GUI:Image_Create(node, "atlas_line", 428 + 83, 136, "res/custom/three_city/sshc/new/图鉴/分割线-.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)
    _create_center_rich_text(node, "atlas_progress", 695, 106, string.format(
        "<font color='#F4E6C8' size='21' face='fonts/502.ttf'>已收集：</font><font color='#62F7FF' size='21' face='fonts/502.ttf'>%d/%d</font>",
        hit, total
    ), 220, 21)
    _create_center_rich_text(node, "atlas_reward", 428, 54, string.format(
        "<font color='#65F6E8' size='25' face='fonts/502.ttf'>%s级全收集后：</font><font color='#FFE08A' size='25' face='fonts/502.ttf'>150级后等级+%d</font>",
        _escape_rich_text(ATLAS_TAB_NAME[atlasQuality] or ""), rewardLevel
    ), 560, 25)
end

local function _render_current_page(node, npcid)
    if not node or (tolua and tolua.isnull and tolua.isnull(node)) then
        local window = npc._window and npc._window.node or nil
        if not window or (tolua and tolua.isnull and tolua.isnull(window)) then
            window = _ensure_window(npcid)
        end
        node = window
    end
    if not node or (tolua and tolua.isnull and tolua.isnull(node)) then
        return
    end
    GUI:removeAllChildren(node)
    _render_page_bg(node)
    _render_left_tabs(node, npcid)
    if npc._page == "compose" then
        npc._render_compose(node, npcid)
    elseif npc._page == "box" then
        npc._render_box(node, npcid)
    elseif npc._page == "atlas" then
        npc._render_atlas(node, npcid)
    else
        npc._render_embed(node, npcid)
    end
end

npc._render_embed = _render_embed
npc._render_compose = _render_compose
npc._render_box = _render_box
npc._render_atlas = _render_atlas
npc._render_current_page = _render_current_page

local function _refresh_on_equip_change()
    if npc.node and not (tolua and tolua.isnull and tolua.isnull(npc.node)) and npc._npcid then
        _render_current_page(npc.node, npc._npcid)
    end
end

SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "npc_53_equip_change_refresh", _refresh_on_equip_change)
SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, "npc_53_take_on_refresh", _refresh_on_equip_change)

--[[
npc.main(npcid, p2, p3, msgData)
用途：神石系统客户端主入口，负责接收服务端消息并刷新界面。
参数：
1. npcid：当前 NPC 编号。
2. p2：消息类型；0=打开主界面，1=刷新主界面，10=显示开箱结果弹窗。
3. p3：预留参数，当前未使用。
4. msgData：服务端下发的 JSON 数据。
]]
function npc.main(npcid, p2, p3, msgData)
    npc._npcid = npcid
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc._page = npc._page or "embed"
        npc._atlasQuality = npc._atlasQuality or 1
        _ensure_compose_state()
        local node = _ensure_window(npcid)
        _render_current_page(node, npcid)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        _reset_compose_selection()
        if npc.node then
            _render_current_page(npc.node, npcid)
        end
    elseif p2 == 10 then
        local resultData = SL:JsonDecode(msgData, false) or {}
        _show_box_result_popup(resultData)
    end
end

return npc
