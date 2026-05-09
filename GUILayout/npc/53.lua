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
local SLOT_POS = {
    {x = 250, y = 338},
    {x = 372, y = 338},
    {x = 494, y = 338},
    {x = 616, y = 229},
    {x = 616, y = 338},
    {x = 494, y = 229},
    {x = 372, y = 229},
    {x = 250, y = 229},
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
    local boxes = _get_panel_boxes()
    local current = npc._boxName
    if current and boxes[current] and boxes[current] > 0 then
        return current
    end
    for _, boxName in ipairs(BOX_NAME_ORDER) do
        if boxes[boxName] and boxes[boxName] > 0 then
            npc._boxName = boxName
            return boxName
        end
    end
    npc._boxName = npc._boxName or BOX_NAME_ORDER[1]
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
    return _get_slot_base_name(slotIndex) .. "神石"
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

-- 按仙府当前已开放的槽位过滤神石列表，避免预览出现尚未解锁槽位的奖励。
local function _filter_item_list_by_open_slots(itemList)
    local openSlots = _get_open_slots()
    local out = {}
    for slotIndex, itemName in ipairs(itemList or {}) do
        if slotIndex <= openSlots and tostring(itemName or "") ~= "" then
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

local function _show_item_tips_by_name(itemName, anchorNode)
    local itemData = _get_item_data_by_name(itemName)
    if not itemData then
        return
    end
    local pos = anchorNode and GUI:getWorldPosition(anchorNode) or {x = 0, y = 0}
    SL:OpenItemTips({itemData = itemData, pos = {x = pos.x, y = pos.y}})
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

local function _build_compose_group_list()
    local state = _ensure_compose_state()
    local lookup = {}
    local slotList = _get_compose_slot_list(state.currentLevel)
    for idx, itemName in ipairs(slotList) do
        lookup[itemName] = idx
    end
    local groups = {}
    local groupMap = {}
    local bagData = SL:GetMetaValue("BAG_DATA") or {}
    for bagKey, itemData in pairs(bagData) do
        local itemName = tostring(itemData.Name or "")
        local slotIndex = lookup[itemName]
        if slotIndex then
            local makeIndex = tostring(itemData.MakeIndex or bagKey)
            local count = _toint(itemData.Count or itemData.OverLap or 1, 1)
            local group = groupMap[itemName]
            if not group then
                group = {
                    itemName = itemName,
                    slotIndex = slotIndex,
                    totalCount = 0,
                    itemData = itemData,
                    stacks = {},
                }
                groupMap[itemName] = group
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
        if a.slotIndex == b.slotIndex then
            return tostring(a.itemName) < tostring(b.itemName)
        end
        return a.slotIndex < b.slotIndex
    end)
    return groups
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
    local stack = _pick_stack_from_group(group)
    if not stack then
        return false
    end
    state.selectedList[#state.selectedList + 1] = {
        makeIndex = tostring(stack.makeIndex),
        slotIndex = group.slotIndex,
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
            return true
        end
    end
    return false
end

local function _auto_fill_compose()
    local state = _ensure_compose_state()
    local groups = _build_compose_group_list()
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

local function _render_page_bg(node)
    if not node then
        return
    end
    local skin = PAGE_BG[npc._page]
    if not skin then
        return
    end
    GUI:Image_Create(node, "page_bg", 428, 268, skin)
end

local function _ensure_window(npcid)
    npc._page = npc._page or "embed"
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, {
        windowName = WINDOW_NAME,
        background = {
            skin = "res/custom/three_city/sshc/new/底板.png",
        },
        closeButton = {
            x = 808,
            y = 488,
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
    local attrText = {}
    local equippedMap = _get_equipped_slot_map()
    for slotIndex = 1, 8 do
        local entry = equippedMap[slotIndex]
        if entry and entry.item_name and entry.item_name ~= "" then
            local equipData = SL:GetMetaValue("EQUIP_DATA", _toint(entry.where, 0))
            attrText[#attrText + 1] = string.format("<font color='%s'>【%s】</font>", QUALITY_COLOR[_get_slot_quality(entry.item_name)] or "#FFFFFF", _get_slot_display_name(entry.item_name, slotIndex))
            if equipData then
                attrText[#attrText + 1] = Player:showEquipAttr(equipData) or ""
            end
            attrText[#attrText + 1] = "<br>"
        end
    end
    if #attrText <= 0 then
        attrText[1] = "<font color='#C8C8C8'>当前尚未装配神石</font>"
    end
    GUI:RichText_Create(node, "embed_attr", 663, 394, table.concat(attrText, "<br>"), 158, 304, "#F5E8C9", 3, nil, nil, {
        outlineSize = 2,
        outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),
    })
end

local function _render_embed(node, npcid)
    local equippedMap = _get_equipped_slot_map()
    local openSlots = _get_open_slots()
    for slotIndex, pos in ipairs(SLOT_POS) do
        local isOpen = slotIndex <= openSlots
        local entry = equippedMap[slotIndex]
        local hasEquip = entry and entry.item_name and entry.item_name ~= ""
        local baseNode = GUI:Layout_Create(node, "embed_slot_" .. slotIndex, pos.x - 54, pos.y - 54, 108, 120, false)
        local icon = GUI:Image_Create(baseNode, "slot_icon_" .. slotIndex, 54, 62, _get_slot_icon_path(slotIndex, hasEquip))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        if not isOpen then
            local darkIcon = GUI:Image_Create(baseNode, "slot_dark_" .. slotIndex, 54, 62, _get_slot_icon_path(slotIndex, false))
            GUI:setAnchorPoint(darkIcon, 0.5, 0.5)
            GUI:Image_Create(baseNode, "slot_lock_" .. slotIndex, 54, 62, "res/custom/three_city/sshc/new/神石icon/锁.png")
            _create_stroke_text(baseNode, "slot_lock_text_" .. slotIndex, 54, 8, 14, "#B8B8B8", string.format("%d级仙府解锁", slotIndex), 0.5, 0.5)
        else
            local btn = GUI:Layout_Create(baseNode, "slot_touch_" .. slotIndex, 0, 0, 108, 120, false)
            GUI:setTouchEnabled(btn, true)
            GUI:addOnClickEvent(btn, function()
                SL:OpenBagUI()
                SL:ShowSystemTips("<font color='#FFCC66'>请在背包中双击对应神石进行装配</font>")
            end)
        end
        local labelColor = not isOpen and "#8E8E8E" or (hasEquip and (QUALITY_COLOR[_get_slot_quality(entry.item_name)] or "#FFFFFF") or "#F3F3F3")
        _create_stroke_text(baseNode, "slot_name_" .. slotIndex, 54, 10, 18, labelColor, _get_slot_display_name(hasEquip and entry.item_name or "", slotIndex), 0.5, 0.5)
        if hasEquip then
            local tipBtn = GUI:Layout_Create(baseNode, "slot_tip_" .. slotIndex, 0, 0, 108, 120, false)
            GUI:setTouchEnabled(tipBtn, true)
            GUI:addOnTouchEvent(tipBtn, function()
                _show_item_tips_by_name(entry.item_name, tipBtn)
            end)
        end
    end
    _render_embed_attr_panel(node)
end

local function _render_compose_level_tabs(node, npcid)
    local state = _ensure_compose_state()
    for level = 1, state.maxLevel do
        local leftName = ATLAS_TAB_NAME[level] or tostring(level)
        local rightName = ATLAS_TAB_NAME[level + 1] or tostring(level + 1)
        local x = 214 + (level - 1) * 152
        local y = 410
        local textColor = state.currentLevel == level and "#F6E6B4" or "#7E7E7E"
        local tab = GUI:Layout_Create(node, "compose_level_" .. level, x, y, 140, 26, false)
        GUI:setTouchEnabled(tab, true)
        GUI:addOnClickEvent(tab, function()
            if state.currentLevel == level then
                return
            end
            state.currentLevel = level
            _reset_compose_selection()
            if npc._render_current_page then
                npc._render_current_page(node, npcid)
            end
        end)
        _create_stroke_text(tab, "compose_level_text_" .. level, 70, 13, 18, textColor, string.format("%s→%s", leftName, rightName), 0.5, 0.5)
    end
end

local function _render_compose_target_slots(node)
    local state = _ensure_compose_state()
    local nextList = _get_compose_next_slot_list(state.currentLevel)
    local counts = _recompute_slot_counts()
    for slotIndex, pos in ipairs(SLOT_POS) do
        local itemName = nextList[slotIndex] or ""
        local itemData = _get_item_data_by_name(itemName)
        local baseNode = GUI:Layout_Create(node, "compose_target_" .. slotIndex, pos.x - 54, pos.y - 54, 108, 120, false)
        local icon = GUI:Image_Create(baseNode, "compose_icon_" .. slotIndex, 54, 62, _get_slot_icon_path(slotIndex, true))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
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
        _create_stroke_text(baseNode, "compose_name_" .. slotIndex, 54, 10, 18, "#F5F5F5", _get_slot_display_name(itemName, slotIndex), 0.5, 0.5)
        local selectedCount = _toint(counts[slotIndex], 0)
        if selectedCount > 0 then
            _create_stroke_text(baseNode, "compose_count_" .. slotIndex, 84, 92, 20, "#53F8BC", "x" .. tostring(selectedCount), 0.5, 0.5)
        end
    end
end

local function _render_compose_bag(node, npcid)
    local groups = _build_compose_group_list()
    local list = GUI:ListView_Create(node, "compose_bag_list", 646, 78, 168, 330, 1)
    GUI:ListView_setItemsMargin(list, 8)
    if #groups <= 0 then
        _create_stroke_text(node, "compose_empty", 730, 238, 18, "#FFCC8A", "背包中没有当前可合成的神石", 0.5, 0.5)
        return
    end
    for idx, group in ipairs(groups) do
        local row = GUI:Layout_Create(-1, "compose_bag_row_" .. idx, 0, 0, 158, 62, false)
        GUI:ListView_pushBackCustomItem(list, row)
        local itemData = group.itemData
        if itemData then
            GUI:ItemShow_Create(row, "compose_item_" .. idx, 8, 8, {itemData = itemData, count = 1, look = true, bgVisible = false})
        end
        _create_stroke_text(row, "compose_item_name_" .. idx, 58, 39, 14, "#F7E7C0", group.itemName, 0, 0.5)
        local remain = _get_group_remain_count(group)
        _create_stroke_text(row, "compose_item_count_" .. idx, 58, 18, 14, remain > 0 and "#8DFFB9" or "#A8A8A8", string.format("剩余 %d/%d", remain, _toint(group.totalCount, 0)), 0, 0.5)
        _create_stroke_text(row, "compose_item_put_" .. idx, 148, 29, 14, remain > 0 and "#7BFFE3" or "#7E7E7E", "放入", 1, 0.5)
        local clicker = GUI:Layout_Create(row, "compose_row_click_" .. idx, 0, 0, 158, 62, false)
        GUI:setTouchEnabled(clicker, true)
        GUI:addOnClickEvent(clicker, function()
            if _add_group_to_compose(group) then
                if npc._render_current_page then
                    npc._render_current_page(node, npcid)
                end
            else
                SL:ShowSystemTips("<font color='#FF0000'>当前神石数量不足或已放满</font>")
            end
        end)
    end
end

local function _render_compose(node, npcid)
    _render_compose_level_tabs(node, npcid)
    _render_compose_target_slots(node)
    _render_compose_bag(node, npcid)
    _create_stroke_text(node, "compose_rule", 428, 457, 18, "#F5E2AF", "十个相同品质的神石可以合成出更高一级的神石", 0.5, 0.5)
    _create_stroke_text(node, "compose_prob", 428, 429, 17, "#EFD9A7", _build_compose_probability_text(), 0.5, 0.5)
    _create_stroke_text(node, "compose_tip", 214, 100, 18, "#E6D2A5", "提示：自动补充会优先选择同类型神石进行补充", 0, 0.5)

    local takeoffBtn = GUI:Button_Create(node, "compose_takeoff_btn", 236, 145, "res/custom/three_city/sshc/new/合成/一键卸下.png")
    GUI:addOnClickEvent(takeoffBtn, function()
        _send_takeoff_all(npcid)
    end)

    local autoFillBtn = GUI:Button_Create(node, "compose_auto_fill_btn", 445, 145, "res/custom/three_city/sshc/new/合成/自动补充.png")
    GUI:addOnClickEvent(autoFillBtn, function()
        _auto_fill_compose()
        if npc._render_current_page then
            npc._render_current_page(node, npcid)
        end
    end)

    local composeBtn = GUI:Button_Create(node, "compose_btn", 348, 37, "res/custom/three_city/sshc/new/合成/立即合成.png")
    GUI:addOnClickEvent(composeBtn, function()
        _send_compose_request(npcid)
    end)

    local tipBtn = GUI:Button_Create(node, "compose_rule_btn", 561, 33, "res/custom/three_city/sshc/new/合成/本次可能会出...png")
    local state = _ensure_compose_state()
    GUI:addOnClickEvent(tipBtn, function()
        local extra = npc._config.extra_cost and npc._config.extra_cost[state.currentLevel] or nil
        local extraText = ""
        if type(extra) == "table" and extra[1] then
            extraText = string.format("<br><font color='#f5c35d'>额外消耗：%s*%s</font>", tostring(extra[1][1] or ""), tostring(extra[1][2] or 1))
        end
        SL:OpenCommonDescTipsPop({
            str = string.format("<font color='#ffffff'>%s</font>%s", _build_compose_probability_text(), extraText),
            worldPos = {x = 520, y = 180},
            anchorPoint = {x = 0, y = 0},
            formatWay = 1
        })
    end)
end

local function _render_box_preview(node)
    local boxName = _get_current_box_name()
    local previewPool = _flatten_box_pool(boxName)
    local list = GUI:ListView_Create(node, "box_preview_list", 182, 287, 534, 114, 2)
    GUI:ListView_setItemsMargin(list, 8)
    if #previewPool <= 7 then
        GUI:ListView_setItemsMargin(list, 4)
    end
    for idx, itemName in ipairs(previewPool) do
        local itemData = _get_item_data_by_name(itemName)
        local slot = GUI:Layout_Create(-1, "box_preview_slot_" .. idx, 0, 0, 76, 110, false)
        GUI:ListView_pushBackCustomItem(list, slot)
        local slotIndex = math.max(1, _get_slot_index_by_name(itemName))
        local icon = GUI:Image_Create(slot, "box_preview_icon_bg_" .. idx, 36, 62, _get_slot_icon_path(slotIndex, true))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        _create_stroke_text(slot, "box_preview_name_" .. idx, 38, 10, 16, "#F3F3F3", _get_slot_display_name(itemName, slotIndex), 0.5, 0.5)
        local touch = GUI:Layout_Create(slot, "box_preview_touch_" .. idx, 0, 0, 76, 110, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnTouchEvent(touch, function()
            if itemData then
                _show_item_tips_by_name(itemName, touch)
            end
        end)
    end
end

local function _render_box_cost(node)
    local boxName = _get_current_box_name()
    local boxCount = _get_panel_boxes()[boxName] or 0
    local keyCount = _toint(_get_panel_data().key_count, 0)
    local boxIndex = _get_item_index_by_name(boxName)
    local keyIndex = _get_item_index_by_name("神石宝箱钥匙")
    if boxIndex > 0 then
        GUI:ItemShow_Create(node, "box_cost_box", 355, 169, {index = boxIndex, count = 1, look = true, bgVisible = false})
    end
    if keyIndex > 0 then
        GUI:ItemShow_Create(node, "box_cost_key", 443, 169, {index = keyIndex, count = 1, look = true, bgVisible = false})
    end
    _create_stroke_text(node, "box_cost_box_count", 354, 136, 16, boxCount > 0 and "#79FFAE" or "#FF8C8C", string.format("%d/1", boxCount), 0.5, 0.5)
    _create_stroke_text(node, "box_cost_key_count", 444, 136, 16, keyCount > 0 and "#79FFAE" or "#FF8C8C", string.format("%d/1", keyCount), 0.5, 0.5)
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
        _create_stroke_text(btn, "box_selector_text_" .. idx, 61, 12, 16, color, string.format("%s(%d)", shortName, count), 0.5, 0.5)
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
    _close_box_popup()
    local parent = GUI:Win_Create("npc_53_box_popup", 0, 0, 0, 0, false, false, true, true, true, nil, 30)
    local overlay = GUI:Image_Create(parent, "overlay", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(overlay, 0.5, 0.5)
    GUI:setContentSize(overlay, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(overlay, true)
    local panel = GUI:Image_Create(parent, "panel", cogin.w / 2, cogin.h / 2, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/恭喜获得.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local stripMask = GUI:Layout_Create(panel, "strip_mask", 74, 138, 392, 120, false)
    GUI:Layout_setClippingEnabled(stripMask, true)
    local strip = GUI:Node_Create(stripMask, "strip", 0, 0)
    local highlight = GUI:Image_Create(panel, "highlight", 268, 138, "res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/边框.png")
    GUI:setAnchorPoint(highlight, 0.5, 0)
    local previewPool = _flatten_box_pool(tostring(resultData.box_name or BOX_NAME_ORDER[1]))
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
        local itemData = _get_item_data_by_name(itemName)
        local slotIndex = math.max(1, _get_slot_index_by_name(itemName))
        local quality = math.max(1, _get_slot_quality(itemName))
        local qualitySkin = quality == 1 and "稀有" or (quality == 2 and "史诗" or (quality == 3 and "传说" or "神话"))
        local qualityBg = GUI:Image_Create(slot, "box_roll_quality_" .. idx, 50, 62, string.format("res/custom/three_city/sshc/new/宝箱下级面板/开宝箱/%s.png", qualitySkin))
        GUI:setAnchorPoint(qualityBg, 0.5, 0.5)
        local icon = GUI:Image_Create(slot, "box_roll_icon_" .. idx, 50, 62, _get_slot_icon_path(slotIndex, true))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        if itemData then
            local touch = GUI:Layout_Create(slot, "box_roll_touch_" .. idx, 0, 0, 100, 120, false)
            GUI:setTouchEnabled(touch, true)
            GUI:addOnTouchEvent(touch, function()
                _show_item_tips_by_name(itemName, touch)
            end)
        end
        _create_stroke_text(slot, "box_roll_name_" .. idx, 50, 12, 16, "#F3F3F3", _get_slot_display_name(itemName, slotIndex), 0.5, 0.5)
    end

    local function finish_show()
        local rewardName = tostring(resultData.reward_name or "")
        local qualityText = tostring(resultData.quality_title or "")
        local rewardIndex = math.max(1, _get_slot_index_by_name(rewardName))
        GUI:setVisible(stripMask, false)
        GUI:setVisible(highlight, false)
        local resultIcon = GUI:Image_Create(panel, "result_icon", 270, 248, _get_slot_icon_path(rewardIndex, true))
        GUI:setAnchorPoint(resultIcon, 0.5, 0.5)
        _create_stroke_text(panel, "result_name", 270, 176, 22, QUALITY_COLOR[_get_slot_quality(rewardName)] or "#FFFFFF", rewardName, 0.5, 0.5, "fonts/500.ttf")
        _create_stroke_text(panel, "result_quality", 270, 144, 18, "#FFE6A1", qualityText ~= "" and qualityText or "获得成功", 0.5, 0.5)
        if npc.node then
            local activeNpcId = npc._npcid or 53
            if npc._render_current_page then
                npc._render_current_page(npc.node, activeNpcId)
            end
        end
        local closeBtn = GUI:Button_Create(panel, "result_close_btn", 78, 90, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/我知道了.png")
        GUI:addOnClickEvent(closeBtn, function()
            _close_box_popup()
        end)
        local reopenBtn = GUI:Button_Create(panel, "result_reopen_btn", 297, 90, "res/custom/three_city/sshc/new/宝箱下级面板/恭喜获得/再次开启.png")
        GUI:addOnClickEvent(reopenBtn, function()
            _close_box_popup()
            _send_open_box(npc._npcid or 53, tostring(resultData.box_name or _get_current_box_name()))
        end)
        GUI:addOnClickEvent(overlay, function()
            _close_box_popup()
        end)
    end

    if npc._skip_box_anim then
        GUI:setPosition(strip, targetX - (targetIndex - 1) * cellWidth, 0)
        finish_show()
    else
        GUI:setPosition(strip, 0, 0)
        GUI:runAction(strip, GUI:ActionSequence(
            GUI:ActionMoveTo(1.6, targetX - (targetIndex - 1) * cellWidth, 0),
            GUI:CallFunc(function()
                finish_show()
            end)
        ))
    end
end

local function _render_box(node, npcid)
    npc._boxName = _get_current_box_name()
    _render_box_preview(node)
    _render_box_selector(node, npcid)
    _render_box_cost(node)

    local skipLabel = _create_stroke_text(node, "box_skip_label", 232, 78, 22, "#F3E3A8", "跳过动画", 0, 0.5)
    local skipCheck = GUI:CheckBox_Create(node, "box_skip_check", 336, 52, "res/custom/three_city/sshc/new/宝箱/跳过动画有对号.png", "res/custom/three_city/sshc/new/宝箱/跳过动画空对号.png")
    GUI:CheckBox_setSelected(skipCheck, npc._skip_box_anim == true)
    GUI:CheckBox_addOnEvent(skipCheck, function(sender)
        npc._skip_box_anim = GUI:CheckBox_isSelected(sender)
    end)
    GUI:Text_enableOutline(skipLabel, OUTLINE_COLOR, 2)

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
        local btn = GUI:Button_Create(node, "atlas_top_" .. quality, ATLAS_TOP_TAB_POS[quality].x, ATLAS_TOP_TAB_POS[quality].y, string.format("res/custom/three_city/sshc/new/图鉴/上方按钮/%s/%s级图鉴.png", folder, ATLAS_TAB_NAME[quality]))
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
        local baseNode = GUI:Layout_Create(node, "atlas_slot_" .. slotIndex, pos.x - 54, pos.y - 54, 108, 120, false)
        local icon = GUI:Image_Create(baseNode, "atlas_icon_" .. slotIndex, 54, 62, _get_slot_icon_path(slotIndex, owned))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        if not owned then
            GUI:Image_Create(baseNode, "atlas_lock_" .. slotIndex, 54, 62, "res/custom/three_city/sshc/new/神石icon/锁.png")
        end
        _create_stroke_text(baseNode, "atlas_name_" .. slotIndex, 54, 10, 18, owned and "#F3F3F3" or "#A0A0A0", _get_slot_display_name(itemName, slotIndex), 0.5, 0.5)
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
    local line = GUI:Image_Create(node, "atlas_line", 428, 136, "res/custom/three_city/sshc/new/图鉴/分割线-.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)
    _create_stroke_text(node, "atlas_progress", 695, 106, 18, "#BFE6FF", string.format("已收集：%d/%d", hit, total), 0.5, 0.5)
    _create_stroke_text(node, "atlas_reward", 428, 54, 24, "#55F7FF", string.format("%s级全收集后：150级后等级+%d", ATLAS_TAB_NAME[atlasQuality], rewardLevel), 0.5, 0.5, "fonts/500.ttf")
end

local function _render_current_page(node, npcid)
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
