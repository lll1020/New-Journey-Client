local npc = {}

npc._config = teshudata["npc_85"] or {}

local UIHelper = NPC_UI_HELPER

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/星象圣图/星象圣图.png", eff = false},
    closeButton = {x = 848, y = 470 - 60, skin = "res/wy/public/close_red_big.png"},
}

local DETAIL_WINDOW_OPTS = {
    windowName = "npc_85_detail",
    background = {skin = "res/custom/six_city/星象圣图/次级页面/星象圣图次级页面.png", eff = false},
    closeButton = {x = 560 - 50, y = 594 - 70, skin = "res/wy/public/close_red_big.png"},
}

local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"

local BTN_UNLOCK = "res/custom/six_city/星象圣图/解锁圣图.png"
local BTN_LIGHT = "res/custom/six_city/星象圣图/次级页面/点亮星宿.png"
local COST_LABEL = "res/custom/six_city/星象圣图/所需消耗：.png"
local SELECT_SKIN = "res/custom/six_city/星象圣图/选中框.png"
local ITEM_BOX_SKIN = "res/custom/six_city/星象圣图/装备框-.png"
local DETAIL_ITEM_BOX_SKIN = "res/custom/six_city/星象圣图/次级页面/装备框-.png"

local MAIN_NODE_POS = {
    {x = 169, y = 265},
    {x = 305, y = 369 - 38},
    {x = 528, y = 265},
    {x = 476, y = 118 - 38},
    {x = 255, y = 137},
}

local DETAIL_COST_POS = {
    {x = 76 + 211, y = 210 + 61},
    {x = 164 + 211, y = 210 + 61},
    {x = 252 + 211, y = 210 + 61},
    {x = 340 + 211, y = 210 + 61},
    {x = 428 + 211, y = 210 + 61},
    {x = 516 + 211, y = 210 + 61},
}

local renderMain
local renderDetail

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function getPanelData()
    return npc.data or {}
end

local function createText(parent, name, x, y, size, color, value, fontName, anchorX, anchorY)
    local text = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(value or ""))
    GUI:Text_setFontName(text, fontName or FONT_MAIN)
    GUI:Text_enableOutline(text, "#000000", 2)
    GUI:setAnchorPoint(text, anchorX or 0, anchorY or 0.5)
    return text
end

local function createRichBlock(parent, name, x, y, width, height, html)
    local layout = GUI:Layout_Create(parent, name, x, y, width, height, false)
    GUI:setAnchorPoint(layout, 0, 0)
    local rich = GUI:RichText_Create(layout, name .. "_rich", 0, height, tostring(html or ""), width, 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, 0.5, 0.5)
    return layout
end

local function closeDetailWindow()
    if npc.detailWindow then
        UIHelper.closeWindow(npc.detailWindow)
        npc.detailWindow = nil
        npc.detailBg = nil
        npc.detailNode = nil
    end
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = UIHelper.formatNpcTitle(npcid, npc._config)
    opts.subTitle = npc._config and npc._config.name
    npc._window = UIHelper.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function ensureDetailWindow(npcid)
    npc.detailWindow = UIHelper.ensureWindow(npc.detailWindow, npcid, DETAIL_WINDOW_OPTS)
    npc.detailBg = npc.detailWindow and npc.detailWindow.bg or nil
    npc.detailNode = npc.detailWindow and npc.detailWindow.node or nil
    return npc.detailNode
end

local function getStageCfg(stageIdx)
    return (npc._config.stages or {})[stageIdx] or {}
end

local function getStageData(stageIdx)
    local all = ((getPanelData().T_data or {}).stage or {})
    return all[tostring(stageIdx)] or all[stageIdx] or {unlock = 0, full = 0, reward = 0, nodes = {}}
end

local function getCurrentStageIdx()
    local maxStage = #(npc._config.stages or {})
    if maxStage <= 0 then
        return 1
    end
    local stageIdx = toNumber(getPanelData().cur_stage, 1)
    if stageIdx < 1 then
        stageIdx = 1
    elseif stageIdx > maxStage then
        stageIdx = maxStage
    end
    return stageIdx
end

local function isStageUnlocked(stageIdx)
    return toNumber(getStageData(stageIdx).unlock, 0) == 1
end

local function isStageFull(stageIdx)
    return toNumber(getStageData(stageIdx).full, 0) == 1
end

local function isNodeLit(stageIdx, nodeIdx)
    local nodes = getStageData(stageIdx).nodes or {}
    return toNumber(nodes[tostring(nodeIdx)] or nodes[nodeIdx], 0) == 1
end

local function getNodeCount(stageIdx)
    return #((getStageCfg(stageIdx).nodes or {}))
end

local function getNextNodeIdx(stageIdx)
    for nodeIdx = 1, getNodeCount(stageIdx) do
        if not isNodeLit(stageIdx, nodeIdx) then
            return nodeIdx
        end
    end
    return getNodeCount(stageIdx)
end

local function getSelectedNodeIdx(stageIdx)
    if npc.selectedStageIdx ~= stageIdx then
        npc.selectedStageIdx = stageIdx
        npc.selectedNodeIdx = nil
    end
    local nodeCount = getNodeCount(stageIdx)
    if nodeCount <= 0 then
        return nil
    end
    if npc.selectedNodeIdx and npc.selectedNodeIdx >= 1 and npc.selectedNodeIdx <= nodeCount then
        return npc.selectedNodeIdx
    end
    local nextIdx = getNextNodeIdx(stageIdx)
    if nextIdx < 1 then
        nextIdx = 1
    end
    npc.selectedNodeIdx = nextIdx
    return nextIdx
end

local function canSelectedNodeUpgrade(stageIdx)
    local selectedNodeIdx = getSelectedNodeIdx(stageIdx)
    if not selectedNodeIdx then
        return false
    end
    if not isStageUnlocked(stageIdx) or isStageFull(stageIdx) then
        return false
    end
    if isNodeLit(stageIdx, selectedNodeIdx) then
        return false
    end
    return getNextNodeIdx(stageIdx) == selectedNodeIdx
end

local function collectEntryNames(entry)
    local list = {}
    local function pushName(name)
        if type(name) ~= "string" or name == "" then
            return
        end
        for _, one in ipairs(list) do
            if one == name then
                return
            end
        end
        list[#list + 1] = name
    end
    if type(entry) == "table" then
        if type(entry.name) == "table" then
            for _, name in ipairs(entry.name) do
                pushName(name)
            end
        else
            pushName(entry.name or entry[1])
        end
        for _, name in ipairs(entry.alias or {}) do
            pushName(name)
        end
    end
    return list
end

local function resolveEntryName(entry)
    local names = collectEntryNames(entry)
    for _, name in ipairs(names) do
        if toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name), 0) > 0 then
            return name
        end
    end
    return names[1] or ""
end

local function entryNeedNum(entry)
    if type(entry) ~= "table" then
        return 0
    end
    return toNumber(entry.num or entry[2], 0)
end

local function normalizeEntryList(entryList)
    local list = {}
    for _, entry in ipairs(entryList or {}) do
        local name = resolveEntryName(entry)
        local num = entryNeedNum(entry)
        if name ~= "" and num > 0 then
            list[#list + 1] = {name, num}
        end
    end
    return list
end

local function getOwnedCountByName(name)
    local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name), 0)
    if itemIndex <= 0 then
        return 0
    end
    if Player and Player.isCurrency and Player:isCurrency(itemIndex) then
        return toNumber(SL:GetMetaValue("MONEY_ASSOCIATED", itemIndex), 0)
    end
    return toNumber(SL:GetMetaValue("ITEM_COUNT", itemIndex), 0)
end

local function getOwnedCountByEntry(entry)
    local names = collectEntryNames(entry)
    if #names <= 0 then
        return 0
    end
    local firstIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", names[1]), 0)
    if firstIndex > 0 and Player and Player.isCurrency and Player:isCurrency(firstIndex) then
        return getOwnedCountByName(names[1])
    end
    local total = 0
    for _, name in ipairs(names) do
        total = total + getOwnedCountByName(name)
    end
    return total
end

local function hasEnoughEntryCost(entryList)
    for _, entry in ipairs(entryList or {}) do
        if getOwnedCountByEntry(entry) < entryNeedNum(entry) then
            return false
        end
    end
    return true
end

local function getStageBadgeSkin(stageIdx)
    local stageName = tostring(getStageCfg(stageIdx).name or "初星")
    return string.format("res/custom/six_city/星象圣图/星宿阶段/%s.png", stageName)
end

local function getNodeIconSkin(stageIdx, nodeIdx)
    local stageCfg = getStageCfg(stageIdx)
    local nodeCfg = (stageCfg.nodes or {})[nodeIdx] or {}
    local stageName = tostring(stageCfg.name or "初星")
    local nodeName = tostring(nodeCfg.name or ("星宿" .. tostring(nodeIdx)))
    return string.format("res/custom/six_city/星象圣图/%sicon/星宿%d·%s.png", stageName, nodeIdx, nodeName)
end

local function renderEntryCostBoxes(parent, entryList, positions, boxSkin)
    for idx, entry in ipairs(entryList or {}) do
        local pos = positions[idx]
        if pos then
            local displayName = resolveEntryName(entry)
            local needNum = entryNeedNum(entry)
            local ownNum = getOwnedCountByEntry(entry)
            local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", displayName), 0)
            local box = GUI:Image_Create(parent, "entry_box_" .. idx, pos.x, pos.y, boxSkin or ITEM_BOX_SKIN)
            if itemIndex > 0 then
                local item = GUI:ItemShow_Create(box, "entry_item_" .. idx, 29, 30, {index = itemIndex, look = true, movable = false, bgVisible = false})
                GUI:setAnchorPoint(item, 0.5, 0.5)
            else
                createText(box, "entry_name_" .. idx, 29, 18, 12, "#F5E6C6", displayName, FONT_MAIN, 0.5, 0.5)
            end
            createText(box, "entry_own_" .. idx, 28, -2, 12, ownNum >= needNum and "#6CFF7B" or "#FF5A5A", tostring(ownNum), FONT_MAIN, 1, 0)
            createText(box, "entry_need_" .. idx, 30, -2, 12, "#FFFFFF", "/" .. tostring(needNum), FONT_MAIN, 0, 0)
        end
    end
end

local function buildNodeStateText(stageIdx, nodeIdx)
    local unlocked = isStageUnlocked(stageIdx)
    local lit = isNodeLit(stageIdx, nodeIdx)
    if not unlocked then
        return "解锁圣图后开启星宿升级", "#FFD66D"
    end
    if lit then
        return "该星宿当前阶段已完成", "#6CFF7B"
    end
    if canSelectedNodeUpgrade(stageIdx) and getSelectedNodeIdx(stageIdx) == nodeIdx then
        return "可升级当前星宿", "#FFD66D"
    end
    return "请按顺序升级当前星宿", "#FF6B6B"
end

renderDetail = function(npcid, stageIdx, nodeIdx)
    local node = ensureDetailWindow(npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    local stageCfg = getStageCfg(stageIdx)
    local nodeCfg = (stageCfg.nodes or {})[nodeIdx] or {}
    local unlocked = isStageUnlocked(stageIdx)
    local lit = isNodeLit(stageIdx, nodeIdx)
    local canUpgrade = canSelectedNodeUpgrade(stageIdx) and getSelectedNodeIdx(stageIdx) == nodeIdx

    -- GUI:Image_Create(node, "node_select", 228, 438, SELECT_SKIN)
    local icon = GUI:Image_Create(node, "node_icon", 310 + 48, 520 - 28, getNodeIconSkin(stageIdx, nodeIdx))
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    -- createText(node, "title_text", 310, 430, 24, "#1E1A12", "升级获得", FONT_TITLE, 0.5, 0.5)
    createRichBlock(node, "attr_preview", 110 + 180 + 66, 278 + 15, 400, 100, Player:showAttrMergedRange(nodeCfg.attr or {}))

    -- local costTitle = GUI:Image_Create(node, "cost_title", 258, 254, COST_LABEL)
    -- GUI:setAnchorPoint(costTitle, 0.5, 0.5)
    renderEntryCostBoxes(node, nodeCfg.cost or {}, DETAIL_COST_POS, DETAIL_ITEM_BOX_SKIN)

    -- local stateText, stateColor = buildNodeStateText(stageIdx, nodeIdx)
    -- createText(node, "state_text", 310, 92, 18, stateColor, stateText, FONT_MAIN, 0.5, 0.5)

    local btn = GUI:Button_Create(node, "light_btn", 192 + 20, 116 + 51, BTN_LIGHT)
    GUI:addOnClickEvent(btn, function()
        if not unlocked then
            SL:ShowSystemTips("请先解锁当前圣图")
            return
        end
        if lit then
            SL:ShowSystemTips("该星宿当前阶段已完成")
            return
        end
        if not canUpgrade then
            SL:ShowSystemTips("请按顺序升级当前星宿")
            return
        end
        SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({stage = stageIdx, node = nodeIdx}, false))
    end)

    -- if canUpgrade and not lit and hasEnoughEntryCost(nodeCfg.cost or {}) then
    --     UIHelper.redpoint_create(btn, {x = 214, y = 62})
    -- end
end

local function renderNodeButtons(node, npcid, stageIdx)
    local selectedNodeIdx = getSelectedNodeIdx(stageIdx)
    local nextNodeIdx = getNextNodeIdx(stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    for nodeIdx, pos in ipairs(MAIN_NODE_POS) do
        if nodeIdx == selectedNodeIdx then
            GUI:Image_Create(node, "node_select_" .. nodeIdx, pos.x - 20, pos.y - 26, SELECT_SKIN)
        end
        local iconBtn = GUI:Button_Create(node, "node_btn_" .. nodeIdx, pos.x, pos.y, getNodeIconSkin(stageIdx, nodeIdx))
        GUI:addOnClickEvent(iconBtn, function()
            npc.selectedStageIdx = stageIdx
            npc.selectedNodeIdx = nodeIdx
            closeDetailWindow()
            renderMain(npc.node, npcid)
        end)
        if isStageUnlocked(stageIdx) and not isStageFull(stageIdx) and nodeIdx == nextNodeIdx and not isNodeLit(stageIdx, nodeIdx) then
            local nodeCfg = (stageCfg.nodes or {})[nodeIdx] or {}
            if hasEnoughEntryCost(nodeCfg.cost or {}) then
                UIHelper.redpoint_create(iconBtn, {x = 110, y = 86})
            end
        end
    end
end

local function renderStageInfo(node, stageIdx)
    local stageName = tostring((getStageCfg(stageIdx) or {}).name or "初星")
    local stageBadge = GUI:Image_Create(node, "stage_badge", 449, 266, getStageBadgeSkin(stageIdx))
    GUI:setAnchorPoint(stageBadge, 0.5, 0.5)
    createText(node, "stage_name", 451, 92, 28, "#D9B45C", stageName, FONT_TITLE, 0.5, 0.5)
    createText(node, "stage_progress", 451, 58, 16, "#F5E6C6", string.format("已点亮 %d/%d", getNextNodeIdx(stageIdx) - (isStageFull(stageIdx) and 0 or 1), getNodeCount(stageIdx)), FONT_MAIN, 0.5, 0.5)
end

local function renderRightAction(node, npcid, stageIdx)
    local selectedNodeIdx = getSelectedNodeIdx(stageIdx)
    local btn = GUI:Button_Create(node, "main_action_btn", 600, 54, BTN_UNLOCK)
    GUI:addOnClickEvent(btn, function()
        local unlocked = isStageUnlocked(stageIdx)
        local full = isStageFull(stageIdx)
        if not unlocked then
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({stage = stageIdx}, false))
            return
        end
        if full then
            SL:ShowSystemTips("当前阶段已完成")
            return
        end
        renderDetail(npcid, stageIdx, selectedNodeIdx)
    end)

    if not isStageUnlocked(stageIdx) then
        if hasEnoughEntryCost(getStageCfg(stageIdx).unlock_cost or {}) then
            UIHelper.redpoint_create(btn, {x = 174 - 30 + 10, y = 60 + 70 + 10})
        end
    elseif canSelectedNodeUpgrade(stageIdx) and hasEnoughEntryCost((((getStageCfg(stageIdx).nodes or {})[selectedNodeIdx] or {}).cost or {})) then
        UIHelper.redpoint_create(btn, {x = 174 - 30 + 10, y = 60 + 70 + 10})
    end
end

renderMain = function(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local stageIdx = getCurrentStageIdx()
    npc.selectedStageIdx = stageIdx
    getSelectedNodeIdx(stageIdx)
    -- renderStageInfo(node, stageIdx)
    renderNodeButtons(node, npcid, stageIdx)
    renderRightAction(node, npcid, stageIdx)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 or p2 == 2 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node, npcid)
        if npc.detailWindow and npc.selectedStageIdx and npc.selectedNodeIdx then
            renderDetail(npcid, npc.selectedStageIdx, npc.selectedNodeIdx)
        end
    end
end

return npc