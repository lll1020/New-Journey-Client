-- 第53号合成面板（npc_53），复用 ui_helper.lua 布局策略
local npc = {}

npc._config = teshudata["npc_53"]

local WINDOW_OPTS = {
    background = {skin = 'res/wy/public/tongyong_0.png'},
    node = {x = 500, y = 300},
}

local NEED_ITEM_NUM = npc._config and npc._config.needitemnum or 10

-- 布局配置表：统一管理所有 UI 坐标与尺寸，方便整体调整
local layoutCfg = {
    bag = {x = -200, y = -90, width = 320, height = 320},            -- 左侧材料列表位置及滚动区域大小
    selection = {x = 0, y = -50, cols = 5, colGap = 86, rowGap = 94}, -- 右侧已选槽位的起点、列数与间距
    reward = {x = 250, y = 80},                                     -- “可能获得”展示节点
    slotTip = {x = 280, y = -140},                                    -- “点击可移除”提示坐标
    buttons = {                                                       -- 底部操作按钮坐标
        compose = {x = 340, y = -260},                               -- “开始合成”
        clear = {x = 210, y = -260},                                 -- “清空材料”
        bag = {x = 80, y = -260},                                    -- “打开背包”
    },
    level = {startX = -360, startY = 130, gapX = 170},               -- 顶部等级切换按钮：起点与横向间距
}

local tierNames = {"稀有", "史诗", "神话", "传说"}

-- 读取指定等级的槽位表，并生成“槽位名称 -> 索引”的查找表
local function getSlotData(level)
    local slotList = {}
    local lookup = {}
    if npc._config and npc._config.cost then
        slotList = npc._config.cost[level] or {}
        for idx, name in ipairs(slotList) do
            lookup[name] = idx
        end
    end
    return slotList, lookup
end


-- 延迟初始化界面状态，保证每次打开/切换等级时数据一致
local function ensureState()
    npc._state = npc._state or {}
    local state = npc._state
    local totalLevels = npc._config and npc._config.cost and #npc._config.cost or 0
    state.maxLevel = math.max(1, totalLevels - 1)
    state.currentLevel = state.currentLevel or 1
    if state.maxLevel < 1 then
        state.maxLevel = 1
    end
    state.currentLevel = math.max(1, math.min(state.currentLevel, state.maxLevel))
    state.slotList, state.slotLookup = getSlotData(state.currentLevel)
    state.nextLevelList = npc._config.cost[state.currentLevel + 1] or {}
    state.selectedList = state.selectedList or {}
    state.selectedCounts = state.selectedCounts or {}
    state.slotCounts = state.slotCounts or {}
end

-- 清空已选材料及其统计（切换等级或手动清空时调用）
local function resetSelection()
    ensureState()
    local state = npc._state
    state.selectedList = {}
    state.selectedCounts = {}
    state.slotCounts = {}
end

-- 切换当前合成等级，若发生变化则重建相关缓存
local function setCurrentLevel(level)
    ensureState()
    local state = npc._state
    local targetLevel = math.max(1, math.min(level, state.maxLevel))
    if state.currentLevel ~= targetLevel then
        state.currentLevel = targetLevel
        state.slotList, state.slotLookup = getSlotData(targetLevel)
        state.nextLevelList = npc._config.cost[targetLevel + 1] or {}
        resetSelection()
        return true
    end
    return false
end

-- 根据选中材料重新累计每个槽位的投入数量
local function recomputeSlotCounts()
    ensureState()
    local state = npc._state
    local counts = {}
    for _, entry in ipairs(state.selectedList) do
        counts[entry.slotIndex] = (counts[entry.slotIndex] or 0) + 1
    end
    state.slotCounts = counts
end

local function updateLevelButtons()
    if not npc._ui or not npc._ui.levelButtons then
        return
    end
    local state = npc._state
    for level, btn in ipairs(npc._ui.levelButtons) do
        local highlight = (level ~= state.currentLevel)
        GUI:Button_setBright(btn, highlight)
        GUI:Button_setTitleColor(btn, highlight and "#f1e2c6" or "#33ff99")
    end
end

-- 根据当前选择情况拼装提示文案，突出“10 个同槽位必成”规则
local function updateProbabilityText()
    if not npc._ui or not npc._ui.rewardProb then
        return
    end
    ensureState()
    local state = npc._state
    recomputeSlotCounts()
    local total = #state.selectedList
    if total == 0 then
        GUI:Text_setString(npc._ui.rewardProb, string.format("请选择 %d 件材料，十个相同槽位必定提升。", NEED_ITEM_NUM))
        return
    end
    local parts = {}
    for slotIndex, count in pairs(state.slotCounts) do
        local slotName = state.slotList[slotIndex] or ("槽位" .. slotIndex)
        local percent = math.floor((count / NEED_ITEM_NUM) * 100)
        table.insert(parts, string.format("%s %d/%d (%d%%)", slotName, count, NEED_ITEM_NUM, percent))
    end
    table.sort(parts)
    local tip = table.concat(parts, "；")
    if total == NEED_ITEM_NUM and next(state.slotCounts) then
        local uniqueSlots = 0
        for _ in pairs(state.slotCounts) do
            uniqueSlots = uniqueSlots + 1
        end
        if uniqueSlots == 1 then
            tip = tip .. "（满足 10/10，100% 获得对应上一级）"
        else
            tip = tip .. "（根据占比随机获得对应上一级）"
        end
    else
        tip = tip .. string.format("（已选 %d/%d）", total, NEED_ITEM_NUM)
    end
    GUI:Text_setString(npc._ui.rewardProb, tip)
end

-- 展示下一等级所有可能奖励（顺序固定，方便对号入座）
local function updateRewardPreview()
    if not npc._ui or not npc._ui.rewardNode then
        return
    end
    ensureState()
    local state = npc._state
    GUI:removeAllChildren(npc._ui.rewardNode)
    local nextList = state.nextLevelList
    if not nextList or #nextList == 0 then
        GUI:Text_Create(npc._ui.rewardNode, "reward_tip", 0, 0, 18, "#ff5a5a", "该等级已是最高，无法继续合成")
        npc._ui.rewardProb = nil
        return
    end
    npc._ui.rewardTitle = GUI:Text_Create(npc._ui.rewardNode, "reward_title", 0, 110, 18, "#f1e2c6", "可能获得：")
    GUI:setAnchorPoint(npc._ui.rewardTitle, 0.5, 0.5)
    npc._ui.rewardProb = GUI:Text_Create(npc._ui.rewardNode, "reward_prob", 0, 88, 16, "#f6ff8f", "")
    GUI:setAnchorPoint(npc._ui.rewardProb, 0.5, 0.5)
    local startX = -140
    for idx, name in ipairs(nextList) do
        local col = (idx - 1) % 4
        local row = math.floor((idx - 1) / 4)
        local bg = GUI:Image_Create(npc._ui.rewardNode, "reward_bg_" .. idx, startX + col * 70, 10 - row * 80, "res/wy/public/70_70_k.png")
        GUI:setAnchorPoint(bg, 0, 0.5)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
        local itemData = itemIndex and SL:GetMetaValue("ITEM_DATA", itemIndex)
        if itemData then
            local itemNode = GUI:ItemShow_Create(bg, "reward_item_" .. idx, 35, 35, {itemData = itemData, count = 1, look = true, bgVisible = false})
            GUI:setAnchorPoint(itemNode, 0.5, 0.5)
        else
            -- 备用：GUI:Text_Create(bg, "reward_name_" .. idx, 35, 35, 16, "#ffeeaa", name)
        end
        -- 备用：GUI:Text_Create(bg, "reward_label_" .. idx, 35, -10, 16, "#8fd6ff", name)
    end
    updateProbabilityText()
end

-- 计算某个分组在扣除已选数量后的剩余件数
local function getGroupRemain(entry, state)
    local remain = entry.totalCount or 0
    for _, stack in ipairs(entry.stacks or {}) do
        local used = state.selectedCounts[stack.makeIndex] or 0
        if used > 0 then
            remain = remain - math.min(used, stack.count)
        end
    end
    return math.max(remain, 0)
end

-- 返回该分组中仍有余量的实际背包堆叠
local function pickStackFromGroup(entry, state)
    for _, stack in ipairs(entry.stacks or {}) do
        local used = state.selectedCounts[stack.makeIndex] or 0
        if used < stack.count then
            return stack, used
        end
    end
end

-- 当背包数量变化或选材改变时，刷新列表中每行的“可用数量 / 可点状态”
local function updateBagListSelectionState()
    if not npc._bagList or not npc._ui or not npc._ui.bagEntries then
        return
    end
    ensureState()
    local state = npc._state
    for _, entry in ipairs(npc._bagList) do
        local ui = npc._ui.bagEntries[entry.uniqueKey]
        if ui then
            local remain = getGroupRemain(entry, state)
            local text = string.format("持有:%d  可用:%d", entry.totalCount or 0, remain)
            GUI:Text_setString(ui.countText, text)
            local canUse = remain > 0 and #state.selectedList < NEED_ITEM_NUM
            GUI:Button_setBright(ui.addBtn, canUse)
            GUI:setTouchEnabled(ui.addBtn, canUse)
        end
    end
end

-- 重绘 10 个材料槽位：有物品则展示并允许点掉，空位显示“+”
local function updateSelectionSlots()
    if not npc._ui or not npc._ui.selectionSlots then
        return
    end
    ensureState()
    local state = npc._state
    recomputeSlotCounts()
    for idx, slotNode in ipairs(npc._ui.selectionSlots) do
        GUI:removeAllChildren(slotNode)
        local entry = state.selectedList[idx]
        if entry then
            
            GUI:setAnchorPoint(GUI:ItemShow_Create(slotNode, "sel_item_" .. idx, 35, 35, {itemData = entry.itemData, count = 1, look = true, bgVisible = false})
            , 0.5, 0.5)
            -- 备用：GUI:Text_Create(slotNode, "sel_name_" .. idx, 35, -10, 16, "#c0faff", entry.name or "")
            GUI:setTouchEnabled(slotNode, true)
        else
            GUI:setAnchorPoint(GUI:Text_Create(slotNode, "sel_hint_" .. idx, 35, 35, 18, "#666666", "+"), 0.5, 0.5)
            GUI:setTouchEnabled(slotNode, false)
        end
    end
    updateProbabilityText()
    updateBagListSelectionState()
end
local function refreshBagList()
    if not npc._ui or not npc._ui.bagList then
        return
    end
    ensureState()
    local state = npc._state
    GUI:ListView_removeAllItems(npc._ui.bagList)
    npc._bagList = {}
    npc._ui.bagEntries = {}
    local groupMap = {}
    local bagData = SL:GetMetaValue("BAG_DATA") or {}
    for bagKey, itemData in pairs(bagData) do
        local itemName = itemData.Name or ""
        local slotIndex = state.slotLookup[itemName]
        if slotIndex then
            local makeIndex = tostring(itemData.MakeIndex or bagKey)
            local count = itemData.Count or itemData.OverLap or 1
            local groupKey = string.format("%s|%s", slotIndex, itemName)
            local group = groupMap[groupKey]
            if not group then
                group = {
                    uniqueKey = groupKey,
                    slotIndex = slotIndex,
                    name = itemName,
                    slotName = state.slotList[slotIndex] or ("槽位" .. slotIndex),
                    totalCount = 0,
                    stacks = {},
                    itemData = itemData,
                }
                groupMap[groupKey] = group
                table.insert(npc._bagList, group)
            end
            table.insert(group.stacks, {
                makeIndex = makeIndex,
                count = count,
                itemData = itemData,
            })
            group.totalCount = group.totalCount + count
        end
    end
    table.sort(npc._bagList, function(a, b)
        if a.slotIndex == b.slotIndex then
            if a.name == b.name then
                return a.uniqueKey < b.uniqueKey
            end
            return (a.name or "") < (b.name or "")
        end
        return a.slotIndex < b.slotIndex
    end)
    if #npc._bagList == 0 then
        GUI:setVisible(npc._ui.emptyBagTip, true)
        return
    end
    GUI:setVisible(npc._ui.emptyBagTip, false)
    for idx, entry in ipairs(npc._bagList) do
        local rowWidth = layoutCfg.bag.width - 10
        local layout = GUI:Layout_Create(npc._ui.bagList, "npc53_item_" .. idx, 0, 0, rowWidth, 80, false)
        -- 备用：GUI:ListView_pushBackCustomItem(npc._ui.bagList, layout)
        local bg = GUI:Image_Create(layout, "row_bg_" .. idx, 0, 0, "res/wy/public/500-300.png")
        GUI:setAnchorPoint(bg, 0, 0)
        GUI:setContentSize(bg, rowWidth - 4, 80 - 4)
        GUI:setAnchorPoint(
        GUI:ItemShow_Create(GUI:Image_Create(bg, "row_item_kuang" .. idx, 5, 0, "res/wy/public/70_70_k.png")
                , "row_item_" .. idx, 35, 35, {itemData = entry.itemData, count = entry.totalCount, look = true, bgVisible = false})
        , 0.5, 0.5)
        
        GUI:Text_Create(bg, "row_name_" .. idx, 90, 50, 18, "#f1e2c6", entry.name)
        GUI:Text_Create(bg, "row_slot_" .. idx, 90, 30, 16, "#8fd6ff", string.format("槽位：%s", entry.slotName))
        local countText = GUI:Text_Create(bg, "row_count_" .. idx, 90, 0, 16, "#ffeeaa", "")
        local btn = GUI:Button_Create(bg, "row_add_" .. idx, rowWidth - 90, 0, "res/public/1900000660.png")
        GUI:setScale(btn, 0.7)
        GUI:Button_setTitleText(btn, "添加")
        GUI:Button_setTitleFontSize(btn, 18)
        GUI:addOnClickEvent(btn, function()
            if #state.selectedList >= NEED_ITEM_NUM then
                SL:ShowSystemTips(string.format("<font color='#ff0000'>最多只能放入%d件材料</font>", NEED_ITEM_NUM))
                return
            end
            local remain = getGroupRemain(entry, state)
            if remain <= 0 then
                SL:ShowSystemTips("<font color='#ff0000'>该材料数量不足</font>")
                return
            end
            local stack, used = pickStackFromGroup(entry, state)
            if not stack then
                SL:ShowSystemTips("<font color='#ff0000'>该材料数量不足</font>")
                return
            end
            table.insert(state.selectedList, {
                makeIndex = stack.makeIndex,
                slotIndex = entry.slotIndex,
                name = entry.name,
                itemData = stack.itemData or entry.itemData
            })
            state.selectedCounts[stack.makeIndex] = (used or 0) + 1
            updateSelectionSlots()
        end)
        npc._ui.bagEntries[entry.uniqueKey] = {countText = countText, addBtn = btn, entry = entry}
    end
    updateBagListSelectionState()
end

-- 手动清空所有已选材料
local function clearSelection()
    resetSelection()
    updateSelectionSlots()
end

-- 将已选材料打包成后端协议，提交合成请求
local function sendComposeRequest(npcid)
    ensureState()
    local state = npc._state
    if #state.selectedList ~= NEED_ITEM_NUM then
        SL:ShowSystemTips(string.format("<font color='#ff0000'>需要放入 %d 件材料</font>", NEED_ITEM_NUM))
        return
    end
    -- 仅需要 makeIndex 列表即可，后端会自行校验数量
    local payload = {item_level = state.currentLevel, itemlist = {}}
    for _, entry in ipairs(state.selectedList) do
        table.insert(payload.itemlist, entry.makeIndex)
    end
    SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode(payload, false))
end

-- 创建 10 个方格并绑定点击删除逻辑
local function buildSelectionArea(parent)
    npc._ui.selectionSlots = {}
    local slotContainer = GUI:Node_Create(parent, "slot_container", layoutCfg.selection.x, layoutCfg.selection.y)
    for i = 1, NEED_ITEM_NUM do
        local col = (i - 1) % layoutCfg.selection.cols
        local row = math.floor((i - 1) / layoutCfg.selection.cols)
        local slot = GUI:Image_Create(
            slotContainer,
            "slot_bg_" .. i,
            col * layoutCfg.selection.colGap,
            -row * layoutCfg.selection.rowGap,
            "res/wy/public/70_70_k.png"
        )
        GUI:setAnchorPoint(slot, 0, 1)
        -- 备用：GUI:addOnClickEvent(slot, function())
        --     ensureState()
        --     if npc._state.selectedList[i] then
        --         -- 退回材料：恢复堆叠剩余数并重新渲染
        --         local entry = npc._state.selectedList[i]
        --         npc._state.selectedCounts[entry.makeIndex] = math.max((npc._state.selectedCounts[entry.makeIndex] or 1) - 1, 0)
        --         table.remove(npc._state.selectedList, i)
        --         updateSelectionSlots()
        --     end
        -- 备用：end)
        npc._ui.selectionSlots[i] = slot
    end
    -- 备用：GUI:Text_Create(parent, "slot_tip", layoutCfg.slotTip.x, layoutCfg.slotTip.y, 16, "#7fe5ff", "点击已选材料可以移除")
end

-- 构建背包列表容器与空状态提示
local function buildBagPanel(parent)
    local bg = GUI:Image_Create(parent, "bag_panel_bg", layoutCfg.bag.x, layoutCfg.bag.y, "res/wy/public/500-300.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, layoutCfg.bag.width + 40, layoutCfg.bag.height + 10)
    npc._ui.bagList = GUI:ListView_Create(parent, "bag_list", layoutCfg.bag.x, layoutCfg.bag.y, layoutCfg.bag.width, layoutCfg.bag.height, 1)
    GUI:setAnchorPoint(npc._ui.bagList, 0.5, 0.5)
    GUI:ListView_setItemsMargin(npc._ui.bagList, 10)
    npc._ui.emptyBagTip = GUI:Text_Create(parent, "bag_empty", layoutCfg.bag.x, layoutCfg.bag.y, 18, "#ffad60", "背包中暂无符合条件的神石")
    GUI:setAnchorPoint(npc._ui.emptyBagTip, 0.5, 0.5)
    GUI:setVisible(npc._ui.emptyBagTip, false)
end


function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    -- 统一的界面刷新函数，便于首开与后续刷新复用
    local function UI_updata(node)
        if not node then
            return
        end
        ensureState()
        GUI:removeAllChildren(node)
        npc._ui = {root = node}

        -- 标题与规则说明
        GUI:Text_Create(node, "title", 0, 220, 26, "#f6ff8f", "灵神石合成")
        local ruleText = "规则：投入 10 件相同等级的神石即可尝试升级。十个相同槽位材料=100% 获得对应上一级，否则按照投入占比计算概率。"
        GUI:setAnchorPoint(GUI:Text_Create(node, "rule", 0, 200, 18, "#ffecc6", ruleText), 0.5, 0.5)

        -- 左上：等级选择按钮组（稀有→史诗→神话→传说）
        npc._ui.levelButtons = {}
        local state = npc._state
        for level = 1, state.maxLevel do
            local leftTier = tierNames[level] or string.format("等级%d", level)
            local rightTier = tierNames[level + 1] or string.format("等级%d", level + 1)
            local label = string.format("%s → %s", leftTier, rightTier)
            local btnX = layoutCfg.level.startX + (level - 1) * layoutCfg.level.gapX
            local btn = GUI:Button_Create(node, "level_btn_" .. level, btnX, layoutCfg.level.startY, "res/public/1900000660.png")
            GUI:setScale(btn, 0.9)
            GUI:Button_setTitleText(btn, label)
            GUI:Button_setTitleFontSize(btn, 18)
            GUI:addOnClickEvent(btn, function()
                if setCurrentLevel(level) then
                    refreshBagList()
                    updateLevelButtons()
                    updateRewardPreview()
                    updateSelectionSlots()
                end
            end)
            npc._ui.levelButtons[level] = btn
        end

        -- 右上：下一等级的产出预览
        npc._ui.rewardNode = GUI:Node_Create(node, "reward_node", layoutCfg.reward.x, layoutCfg.reward.y)
        -- 中部：10 个材料槽 + 概率提示区域
        buildSelectionArea(node)
        -- 左侧：背包材料列表
        buildBagPanel(node)

        -- 底部按钮：开始合成 / 清空 / 打开背包
        local composeBtn = GUI:Button_Create(node, "btn_compose", layoutCfg.buttons.compose.x, layoutCfg.buttons.compose.y, "res/public/1900000660.png")
        GUI:Button_setTitleText(composeBtn, "开始合成")
        GUI:Button_setTitleFontSize(composeBtn, 20)
        GUI:addOnClickEvent(composeBtn, function()
            sendComposeRequest(npcid)
        end)

        local clearBtn = GUI:Button_Create(node, "btn_clear", layoutCfg.buttons.clear.x, layoutCfg.buttons.clear.y, "res/public/1900000660.png")
        GUI:Button_setTitleText(clearBtn, "清空材料")
        GUI:Button_setTitleFontSize(clearBtn, 20)
        GUI:addOnClickEvent(clearBtn, function()
            clearSelection()
        end)

        local bagBtn = GUI:Button_Create(node, "btn_bag", layoutCfg.buttons.bag.x, layoutCfg.buttons.bag.y, "res/public/1900000660.png")
        GUI:Button_setTitleText(bagBtn, "打开背包")
        GUI:Button_setTitleFontSize(bagBtn, 20)
        GUI:addOnClickEvent(bagBtn, function()
            SL:OpenBagUI()
        end)

        updateLevelButtons()
        updateRewardPreview()
        refreshBagList()
        updateSelectionSlots()
    end

    if p2 == 0 then
        -- 首次打开：刷新背包&状态，并生成窗口骨架
        npc.data = SL:JsonDecode(msgData, false) or {}
        resetSelection()
        local parent = GUI:GetWindow(nil, "npc_" .. npcid)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, npcid, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/tongyong_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close_red_big.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        npc.node = GUI:Node_Create(npc.bg, "node", 500, 300)
        UI_updata(npc.node)
    elseif p2 == 1 then
        -- 合成成功或后端同步后刷新界面
        npc.data = SL:JsonDecode(msgData, false) or npc.data
        resetSelection()
        if npc.node then
            UI_updata(npc.node)
        end
    end
end

return npc
