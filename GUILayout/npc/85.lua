local npc = {}

npc._config = teshudata["npc_85"] or {}

local UIHelper = NPC_UI_HELPER

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/星象圣图/星象圣图.png", eff = false},
    closeButton = {x = 848, y = 470, skin = "res/wy/public/close_red_big.png"},
}

local DETAIL_WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/星象圣图/次级页面/星象圣图次级页面.png", eff = false},
    closeButton = {x = 560, y = 594, skin = "res/wy/public/close_red_big.png"},
}

local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN_UNLOCK = "res/custom/six_city/星象圣图/解锁圣图.png"
local BTN_LIGHT = "res/custom/six_city/星象圣图/次级页面/点亮星宿.png"
local COST_LABEL = "res/custom/six_city/星象圣图/所需消耗：.png"
local REWARD_LABEL = "res/custom/six_city/星象圣图/点亮全部星宿获得.png"
local SELECT_SKIN = "res/custom/six_city/星象圣图/选中框.png"
local ITEM_BOX_SKIN = "res/custom/six_city/星象圣图/装备框-.png"
local DETAIL_ITEM_BOX_SKIN = "res/custom/six_city/星象圣图/次级页面/装备框-.png"

local MAIN_NODE_POS = {
    {x = 126, y = 224},
    {x = 334, y = 350},
    {x = 584, y = 260},
    {x = 554, y = 76},
    {x = 260, y = 82},
}

local DETAIL_COST_POS = {
    {x = 86, y = 218},
    {x = 174, y = 218},
    {x = 262, y = 218},
    {x = 350, y = 218},
    {x = 438, y = 218},
    {x = 526, y = 218},
}

local renderMain = nil
local renderDetail = nil

local NODE_ICON_NAME_OVERRIDE = {
    [7] = {
        [1] = "紫薇星",
        [2] = "天玑星",
    },
}

-- 说明：统一转数字，避免服务端字段为空时界面渲染报错。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 说明：创建并复用主窗口。
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

-- 说明：创建并复用星宿次级页面。
local function ensureDetailWindow(npcid)
    local opts = {}
    for k, v in pairs(DETAIL_WINDOW_OPTS) do
        opts[k] = v
    end
    opts.windowName = "npc_85_detail"
    npc.detailWindow = UIHelper.ensureWindow(npc.detailWindow, npcid, opts)
    npc.detailBg = npc.detailWindow.bg
    npc.detailNode = npc.detailWindow.node
    return npc.detailNode
end

-- 说明：返回当前面板缓存数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：返回指定阶段配置。
local function getStageCfg(stageIdx)
    return (npc._config.stages or {})[stageIdx] or {}
end

-- 说明：返回指定阶段状态。
local function getStageData(stageIdx)
    local stage = ((getPanelData().T_data or {}).stage or {})
    return stage[tostring(stageIdx)] or stage[stageIdx] or {unlock = 0, full = 0, reward = 0, nodes = {}}
end

-- 说明：返回当前服务端认定的阶段序号。
local function getCurrentStageIdx()
    local curStage = toNumber(getPanelData().cur_stage, 1)
    if curStage <= 0 then
        curStage = 1
    end
    if curStage > #(npc._config.stages or {}) then
        curStage = #(npc._config.stages or {})
    end
    return curStage
end

-- 说明：判断指定阶段是否已解锁。
local function isStageUnlocked(stageIdx)
    return toNumber(getStageData(stageIdx).unlock, 0) == 1
end

-- 说明：判断指定阶段是否已全满。
local function isStageFull(stageIdx)
    return toNumber(getStageData(stageIdx).full, 0) == 1
end

-- 说明：判断指定节点是否已点亮。
local function isNodeLit(stageIdx, nodeIdx)
    local nodes = getStageData(stageIdx).nodes or {}
    return toNumber(nodes[tostring(nodeIdx)] or nodes[nodeIdx], 0) == 1
end

-- 说明：返回阶段内当前可点亮的下一个节点序号。
local function getNextNodeIdx(stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    for nodeIdx = 1, #(stageCfg.nodes or {}) do
        if not isNodeLit(stageIdx, nodeIdx) then
            return nodeIdx
        end
    end
    return #(stageCfg.nodes or {})
end

-- 说明：返回当前主界面选中的节点，默认选中当前下一节点。
local function getSelectedNodeIdx(stageIdx)
    if npc.selectedStageIdx ~= stageIdx then
        npc.selectedStageIdx = stageIdx
        npc.selectedNodeIdx = nil
    end
    local stageCfg = getStageCfg(stageIdx)
    if npc.selectedNodeIdx and (stageCfg.nodes or {})[npc.selectedNodeIdx] then
        return npc.selectedNodeIdx
    end
    local nextNode = getNextNodeIdx(stageIdx)
    if nextNode <= 0 then
        nextNode = 1
    end
    npc.selectedNodeIdx = nextNode
    return npc.selectedNodeIdx
end

-- 说明：整理配置中的名称别名列表。
local function collectEntryNames(entry)
    local names = {}
    local function pushName(name)
        if type(name) ~= "string" or name == "" then
            return
        end
        for _, one in ipairs(names) do
            if one == name then
                return
            end
        end
        names[#names + 1] = name
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
    return names
end

-- 说明：优先选取客户端可识别的名称用于图标和数量检查。
local function resolveEntryName(entry)
    for _, name in ipairs(collectEntryNames(entry)) do
        if toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name), 0) > 0 then
            return name
        end
    end
    local names = collectEntryNames(entry)
    return names[1] or ""
end

-- 说明：读取配置条目的需求数量。
local function entryNeedNum(entry)
    if type(entry) ~= "table" then
        return 0
    end
    return toNumber(entry.num or entry[2], 0)
end

-- 说明：将 cost/give 结构转为客户端通用的 {{name,num}} 形式。
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

-- 说明：读取单个名称在客户端中的实际拥有数量，货币走货币接口，普通道具走背包数量。
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

-- 说明：按服务端逻辑合并别名数量，保证星辰/星尘这类道具显示准确。
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

-- 说明：检查一组消耗当前是否满足，用于解锁/点亮按钮红点判断。
local function hasEnoughEntryCost(entryList)
    for _, entry in ipairs(entryList or {}) do
        if getOwnedCountByEntry(entry) < entryNeedNum(entry) then
            return false
        end
    end
    return true
end

-- 说明：构建阶段中心图片路径。
local function getStageBadgeSkin(stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    return string.format("res/custom/six_city/星象圣图/星宿阶段/%s.png", tostring(stageCfg.name or "初星"))
end

-- 说明：构建主界面星宿图标路径。
local function getNodeIconSkin(stageIdx, nodeIdx)
    local stageCfg = getStageCfg(stageIdx)
    local nodeCfg = (stageCfg.nodes or {})[nodeIdx] or {}
    local displayName = (((NODE_ICON_NAME_OVERRIDE[stageIdx] or {})[nodeIdx]) or tostring(nodeCfg.name or "星宿"))
    return string.format("res/custom/six_city/星象圣图/%sicon/星宿%d·%s.png", tostring(stageCfg.name or "初星"), nodeIdx, displayName)
end

-- 说明：统计当前已点亮节点的总属性，用于主界面汇总展示。
local function collectTotalAttrs()
    local attrs = {}
    local function addAttr(attrId, value)
        local key = tostring(attrId)
        attrs[key] = (attrs[key] or 0) + toNumber(value, 0)
    end
    for stageIdx, stageCfg in ipairs(npc._config.stages or {}) do
        for nodeIdx, nodeCfg in ipairs(stageCfg.nodes or {}) do
            if isNodeLit(stageIdx, nodeIdx) then
                for _, attr in ipairs(nodeCfg.attr or {}) do
                    addAttr(attr[1], attr[2])
                end
            end
        end
    end
    local list = {}
    for attrId, value in pairs(attrs) do
        list[#list + 1] = {toNumber(attrId, 0), value}
    end
    table.sort(list, function(a, b)
        return (a[1] or 0) < (b[1] or 0)
    end)
    return list
end

-- 说明：根据当前已激活技能效果生成说明文案。
local function buildSkillDesc()
    local skill = getPanelData().skill or {}
    local lines = {}
    if skill.huti then
        lines[#lines + 1] = string.format("护体：受击%d%%概率减伤%d%%，持续%d秒", toNumber(skill.huti.rate, 0), toNumber(skill.huti.reduce, 0), toNumber(skill.huti.duration, 0))
    end
    if skill.mang then
        lines[#lines + 1] = string.format("茫击：攻击额外附加%d伤害，冷却%d秒", toNumber(skill.mang.damage, 0), toNumber(skill.mang.cd, 0))
    end
    if skill.heal then
        lines[#lines + 1] = string.format("复苏：战斗中每秒恢复%d生命", toNumber(skill.heal.value, 0))
    end
    if skill.fan then
        lines[#lines + 1] = string.format("反震：%d%%概率反弹%d%%伤害", toNumber(skill.fan.rate, 0), toNumber(skill.fan.reflect, 0))
    end
    if skill.burst then
        lines[#lines + 1] = string.format("爆发：攻速+%d，持续%d秒，冷却%d秒", toNumber(skill.burst.speed, 0), toNumber(skill.burst.duration, 0), toNumber(skill.burst.cd, 0))
    end
    if skill.domain then
        lines[#lines + 1] = string.format("领域：队友全属性+%d%%，减伤+%d%%，持续%d秒", toNumber(skill.domain.all_pct, 0), toNumber(skill.domain.reduce, 0), toNumber(skill.domain.duration, 0))
    end
    if skill.emperor then
        lines[#lines + 1] = string.format("帝星：进入帝星状态，持续%d秒，冷却%d秒", toNumber(skill.emperor.duration, 0), toNumber(skill.emperor.cd, 0))
    end
    if #lines <= 0 then
        return "当前暂无激活圣图技能效果"
    end
    return table.concat(lines, "\n")
end

-- 说明：统一创建带描边文本。
local function createText(parent, name, x, y, size, color, text, fontName, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:Text_setFontName(label, fontName or FONT_MAIN)
    GUI:Text_enableOutline(label, "#000000", 2)
    if anchorX ~= nil or anchorY ~= nil then
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
    end
    return label
end

-- 说明：创建可滚动富文本区域，避免属性和技能说明过长被截断。
local function createScrollRichText(parent, name, x, y, width, height, html)
    local scroll = GUI:ScrollView_Create(parent, name, x, y, width, height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, width, height)
    local rich = GUI:RichText_Create(scroll, name .. "_content", 0, height - 4, tostring(html or ""), width - 8, 16, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, 0, 1)
    local richHeight = GUI:getBoundingBox(rich).height
    local innerHeight = math.max(height, richHeight + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, width, innerHeight)
    GUI:setPosition(rich, 0, innerHeight - 4)
    return scroll
end

-- 说明：按固定坐标渲染一组消耗格子，并显示当前数量/需求数量。
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
                GUI:setAnchorPoint(GUI:ItemShow_Create(box, "entry_item_" .. idx, 29, 30, {index = itemIndex, look = true, movable = false, bgVisible = false}), 0.5, 0.5)
            else
                createText(box, "entry_name_" .. idx, 29, 20, 12, "#F5E6C6", displayName, FONT_MAIN, 0.5, 0.5)
            end

            local ownColor = ownNum >= needNum and "#6CFF7B" or "#FF5A5A"
            createText(box, "entry_cur_" .. idx, 40, 0, 12, ownColor, tostring(ownNum), FONT_MAIN, 1, 0)
            createText(box, "entry_need_" .. idx, 40, 0, 12, "#FFFFFF", "/" .. tostring(needNum), FONT_MAIN, 0, 0)
        end
    end
end

-- 说明：渲染奖励展示图标或称号文本。
local function renderRewardPreview(parent, reward)
    if not reward then
        return
    end
    if tostring(reward.type or "item") == "title" then
        local titleBox = GUI:Image_Create(parent, "reward_box", 0, 0, ITEM_BOX_SKIN)
        createText(titleBox, "reward_title_type", 29, 34, 14, "#F5E6C6", "称号", FONT_MAIN, 0.5, 0.5)
        createText(titleBox, "reward_title_name", 29, 12, 12, "#6CFF7B", tostring(reward.name or "星空主宰"), FONT_MAIN, 0.5, 0.5)
        return
    end
    local list = normalizeEntryList(reward.give or {})
    if #list <= 0 then
        return
    end
    local box = GUI:Image_Create(parent, "reward_box", 0, 0, ITEM_BOX_SKIN)
    local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", list[1][1]), 0)
    if itemIndex > 0 then
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "reward_item", 29, 30, {index = itemIndex, count = list[1][2], look = true, movable = false, bgVisible = false}), 0.5, 0.5)
    else
        createText(box, "reward_item_name", 29, 22, 14, "#F5E6C6", list[1][1], FONT_MAIN, 0.5, 0.5)
        createText(box, "reward_item_num", 29, 6, 12, "#FFD66D", "x" .. tostring(list[1][2]), FONT_MAIN, 0.5, 0.5)
    end
end

-- 说明：渲染主界面五个星宿节点。
local function renderNodeButtons(node, npcid, stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    local stageUnlocked = isStageUnlocked(stageIdx)
    local selectedNodeIdx = getSelectedNodeIdx(stageIdx)
    local nextNodeIdx = getNextNodeIdx(stageIdx)

    for nodeIdx, pos in ipairs(MAIN_NODE_POS) do
        if nodeIdx == selectedNodeIdx then
            GUI:Image_Create(node, "node_select_" .. nodeIdx, pos.x - 18, pos.y - 18, SELECT_SKIN)
        end
        local iconBtn = GUI:Button_Create(node, "node_btn_" .. nodeIdx, pos.x, pos.y, getNodeIconSkin(stageIdx, nodeIdx))
        GUI:addOnClickEvent(iconBtn, function()
            npc.selectedStageIdx = stageIdx
            npc.selectedNodeIdx = nodeIdx
            renderMain(npc.node, npcid)
        end)
        if stageUnlocked and (not isNodeLit(stageIdx, nodeIdx)) and nodeIdx == nextNodeIdx and hasEnoughEntryCost(((stageCfg.nodes or {})[nodeIdx] or {}).cost or {}) then
            UIHelper.redpoint_create(iconBtn, {x = 110, y = 86})
        end
    end
end

-- 说明：渲染主界面右侧消耗区与解锁按钮。
local function renderUnlockArea(node, npcid, stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    local unlocked = isStageUnlocked(stageIdx)
    local full = isStageFull(stageIdx)
    local displayEntries = stageCfg.unlock_cost or {}
    if unlocked and (not full) then
        local nextNodeCfg = ((stageCfg.nodes or {})[getNextNodeIdx(stageIdx)] or {})
        displayEntries = nextNodeCfg.cost or {}
    elseif unlocked and full then
        displayEntries = {}
    end

    GUI:Image_Create(node, "cost_label", 672, 282, COST_LABEL)
    renderEntryCostBoxes(node, displayEntries, {
        {x = 724, y = 246},
        {x = 782, y = 246},
        {x = 840, y = 246},
        {x = 724, y = 186},
        {x = 782, y = 186},
        {x = 840, y = 186},
    }, ITEM_BOX_SKIN)

    local btn = GUI:Button_Create(node, "unlock_btn", 704, 54, BTN_UNLOCK)
    GUI:addOnClickEvent(btn, function()
        local nodeIdx = getSelectedNodeIdx(stageIdx)
        npc.detailStageIdx = stageIdx
        npc.detailNodeIdx = nodeIdx
        renderDetail(npcid, stageIdx, nodeIdx)
    end)
    if not unlocked then
        if hasEnoughEntryCost(stageCfg.unlock_cost or {}) then
            UIHelper.redpoint_create(btn, {x = 174, y = 60})
        end
        createText(node, "unlock_state", 704, 38, 16, "#FFD66D", "解锁当前圣图后可继续点亮星宿", FONT_MAIN, 0.5, 0.5)
    else
        GUI:setVisible(btn, false)
        local stateText = full and "当前阶段已全部点亮" or "当前阶段已解锁，点击星宿查看点亮"
        local stateColor = full and "#6CFF7B" or "#FFD66D"
        createText(node, "unlock_state", 704, 38, 16, stateColor, stateText, FONT_MAIN, 0.5, 0.5)
    end
end

-- 说明：渲染主界面底部汇总信息。
local function renderBottomInfo(node, stageIdx)
    local stageCfg = getStageCfg(stageIdx)
    local stageName = tostring(stageCfg.name or "初星")
    local stageData = getStageData(stageIdx)
    local totalNodes = #(stageCfg.nodes or {})
    local litCount = 0
    for nodeIdx = 1, totalNodes do
        if isNodeLit(stageIdx, nodeIdx) then
            litCount = litCount + 1
        end
    end

    GUI:Image_Create(node, "reward_label", 28, 42, REWARD_LABEL)
    renderRewardPreview(GUI:Node_Create(node, "reward_preview_node", 86, 44), stageCfg.reward)

    createText(node, "stage_progress", 250, 44, 18, "#F5E6C6", string.format("当前阶段：%s  %d/%d", stageName, litCount, totalNodes), FONT_MAIN, 0, 0.5)
    createScrollRichText(node, "skill_scroll", 250, 64, 360, 46, buildSkillDesc())

    local totalAttr = collectTotalAttrs()
        createScrollRichText(node, "attr_scroll", 628, 52, 228, 52, Player:showAttrMergedRange(totalAttr))
end

-- 说明：渲染星象圣图主界面。
renderMain = function(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    local stageIdx = getCurrentStageIdx()
    npc.selectedStageIdx = stageIdx
    local stageBadge = GUI:Image_Create(node, "stage_badge", 390, 204, getStageBadgeSkin(stageIdx))
    GUI:setAnchorPoint(stageBadge, 0.5, 0.5)

    renderNodeButtons(node, npcid, stageIdx)
    renderUnlockArea(node, npcid, stageIdx)
    renderBottomInfo(node, stageIdx)
end

-- 说明：渲染次级页面内容，负责单个星宿的顺序点亮。
renderDetail = function(npcid, stageIdx, nodeIdx)
    local node = ensureDetailWindow(npcid)
    GUI:removeAllChildren(node)

    local stageCfg = getStageCfg(stageIdx)
    local nodeCfg = (stageCfg.nodes or {})[nodeIdx] or {}
    local stageUnlocked = isStageUnlocked(stageIdx)
    local canLight = stageUnlocked and (not isStageFull(stageIdx)) and (getNextNodeIdx(stageIdx) == nodeIdx)
    local lit = isNodeLit(stageIdx, nodeIdx)

    GUI:Image_Create(node, "node_select", 228, 438, SELECT_SKIN)
    local icon = GUI:Image_Create(node, "node_icon", 310, 520, getNodeIconSkin(stageIdx, nodeIdx))
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    createText(node, "attr_title", 308, 430, 24, "#1E1A12", "点亮获得", FONT_TITLE, 0.5, 0.5)
        createScrollRichText(node, "attr_preview", 110, 274, 400, 108, Player:showAttrMergedRange(nodeCfg.attr or {}))

    GUI:Image_Create(node, "cost_label", 260, 252, COST_LABEL)
    renderEntryCostBoxes(node, nodeCfg.cost or {}, DETAIL_COST_POS, DETAIL_ITEM_BOX_SKIN)

    local btn = GUI:Button_Create(node, "light_btn", 192, 118, BTN_LIGHT)
    GUI:addOnClickEvent(btn, function()
        if not stageUnlocked then
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({stage = stageIdx}, false))
            return
        end
        if not lit then
            SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({stage = stageIdx, node = nodeIdx}, false))
        end
    end)
    if not stageUnlocked then
        if hasEnoughEntryCost(stageCfg.unlock_cost or {}) then
            UIHelper.redpoint_create(btn, {x = 214, y = 62})
        end
    elseif canLight and (not lit) then
        if hasEnoughEntryCost(nodeCfg.cost or {}) then
            UIHelper.redpoint_create(btn, {x = 214, y = 62})
        end
    end

    local stateText = (not stageUnlocked) and "解锁圣图后开启星宿点亮" or (lit and "该星宿已点亮" or (canLight and "可点亮当前星宿" or "请按顺序点亮星宿"))
    local stateColor = lit and "#6CFF7B" or ((canLight or not stageUnlocked) and "#FFD66D" or "#FF5A5A")
    createText(node, "node_state", 310, 88, 18, stateColor, stateText, FONT_MAIN, 0.5, 0.5)
end

npc._renderDetail = renderDetail

-- 说明：处理服务端回包并刷新主界面/次级页面。
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
