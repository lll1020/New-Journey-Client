local npc = {}

npc._config = teshudata["npc_84"] or {}

local UIHelper = NPC_UI_HELPER

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/世界符文/世界符文.png", eff = false},
    closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
}

local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN_ACTIVE = "res/custom/six_city/世界符文/激活符文.png"
local BTN_REWARD = "res/custom/six_city/世界符文/领取奖励.png"
local SELECT_SKIN = "res/custom/six_city/世界符文/选中框.png"
local ACTIVE_STAMP = "res/custom/six_city/世界符文/已激活.png"
local COND_BOX_SKIN = "res/custom/six_city/世界符文/延伸框（激活条件）.png"
local REWARD_BOX_SKIN = "res/custom/six_city/世界符文/装备框-.png"

local RUNE_POS = {
    [1] = {x = 82 - 15, y = 226 + 50, nameX = 42 - 10, nameY = 270 + 50},
    [2] = {x = 202 - 30, y = 246 - 70, nameX = 162 - 30, nameY = 290 - 70 - 30},
    [3] = {x = 82 - 15, y = 84, nameX = 42 - 10, nameY = 128},
    [4] = {x = 374, y = 286, nameX = 334, nameY = 330},
    [5] = {x = 548 - 60, y = 196, nameX = 508 - 60 + 10, nameY = 240 - 10},
    [6] = {x = 626 - 260, y = 96, nameX = 586 - 260, nameY = 140},
    [7] = {x = 694 - 100, y = 96, nameX = 654 - 100, nameY = 140},
}

local COND_OFFSET = {x = 88 - 66, y = -32}
local WINDOW_CLICK_MAX_X = 662

local STAMP_OFFSET = {
    [1] = {x = -16, y = -42},
    [2] = {x = -18, y = -46},
    [3] = {x = -18, y = -42},
    [4] = {x = -20, y = -42},
    [5] = {x = -12, y = -44},
    [6] = {x = -34, y = -42},
    [7] = {x = -26, y = -78},
}

local renderMain = nil

-- 说明：统一转数字，避免服务端字段为空时界面报错。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function clampClickX(x)
    if x > WINDOW_CLICK_MAX_X then
        return WINDOW_CLICK_MAX_X
    end
    return x
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

-- 说明：返回当前面板数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：返回当前选中的符文序号，默认定位到第一个未激活符文。
local function getSelectedIdx()
    if npc.selectedIdx and npc._config.runes and npc._config.runes[npc.selectedIdx] then
        return npc.selectedIdx
    end
    local runeData = getPanelData().rune_data or {}
    for idx, _ in ipairs(npc._config.runes or {}) do
        if toNumber(runeData[tostring(idx)] or runeData[idx], 0) ~= 1 then
            npc.selectedIdx = idx
            return idx
        end
    end
    npc.selectedIdx = 1
    return npc.selectedIdx
end

-- 说明：返回指定符文配置。
local function getRuneCfg(idx)
    return (npc._config.runes or {})[idx] or {}
end

-- 说明：判断指定符文是否已激活。
local function isRuneActive(idx)
    local runeData = getPanelData().rune_data or {}
    return toNumber(runeData[tostring(idx)] or runeData[idx], 0) == 1
end

-- 说明：判断指定符文当前是否满足激活条件。
local function canRuneActivate(idx)
    local cond = getPanelData().cond or {}
    return toNumber(cond[tostring(idx)] or cond[idx], 0) == 1
end

-- 说明：统一创建带描边的文本。
local function createText(parent, name, x, y, size, color, text, fontName, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:Text_setFontName(label, fontName or FONT_MAIN)
    GUI:Text_enableOutline(label, "#000000", 2)
    if anchorX ~= nil or anchorY ~= nil then
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
    end
    return label
end

-- 说明：构建按钮素材路径。
local function getRuneButtonSkin(idx)
    local runeCfg = getRuneCfg(idx)
    local shortName = tostring(runeCfg.short or "")
    local folder = (isRuneActive(idx) or canRuneActivate(idx)) and "亮" or "暗"
    return string.format("res/custom/six_city/世界符文/按钮/%s/%s.png", folder, shortName)
end

-- 说明：构建名字素材路径。
local function getRuneNameSkin(idx)
    local runeCfg = getRuneCfg(idx)
    return string.format("res/custom/six_city/世界符文/名字/%s.png", tostring(runeCfg.short or ""))
end

-- 说明：构建条件图片路径。
local function getConditionSkin(idx)
    local runeCfg = getRuneCfg(idx)
    return string.format("res/custom/six_city/世界符文/激活条件/%s.png", tostring(runeCfg.check_desc or runeCfg.desc or ""))
end

-- 说明：渲染左侧 7 个世界符文按钮。
local function renderRuneButtons(node, npcid)
    local selectedIdx = getSelectedIdx()
    for idx, pos in ipairs(RUNE_POS) do
        local btn = GUI:Button_Create(node, "rune_btn_" .. idx, pos.x, pos.y, getRuneButtonSkin(idx))
        GUI:addOnClickEvent(btn, function()
            npc.selectedIdx = idx
            if renderMain then
                renderMain(npc.node, npcid)
            end
        end)
        GUI:Image_Create(node, "rune_name_" .. idx, pos.nameX, pos.nameY, getRuneNameSkin(idx))

        if idx == selectedIdx then
            local selectImg = GUI:Image_Create(node, "select_" .. idx, pos.x - 9, pos.y - 17, SELECT_SKIN)
        end
        if isRuneActive(idx) then
            local stampOffset = STAMP_OFFSET[idx] or {x = -24, y = -40}
            local stamp = GUI:Image_Create(node, "active_stamp_" .. idx, pos.x + stampOffset.x, pos.y + stampOffset.y, ACTIVE_STAMP)
        elseif canRuneActivate(idx) then
            UIHelper.redpoint_create(btn, {x = 100, y = 72})
        end
    end
end

-- 说明：渲染右侧当前选中符文详情。
local function renderSelectedDetail(node, npcid)
    local idx = getSelectedIdx()
    local active = isRuneActive(idx)
    local canActive = canRuneActivate(idx)
    local pos = RUNE_POS[idx] or {x = 374, y = 286}
    local boxX = pos.x + COND_OFFSET.x
    local boxY = pos.y + COND_OFFSET.y

    local detailNode = GUI:Node_Create(node, "detail_node", 0, 0)
    local condBox = GUI:Image_Create(detailNode, "cond_box", boxX, boxY, COND_BOX_SKIN)
    GUI:Image_Create(detailNode, "cond_img", boxX + 37 + 59, boxY + 25 + 55, getConditionSkin(idx))

    if active then
        local activeImg = GUI:Image_Create(detailNode, "selected_active", boxX + 88, boxY - 13, ACTIVE_STAMP)
    else
        local btn = GUI:Button_Create(detailNode, "active_btn", boxX + 130, boxY + 5 + 30, BTN_ACTIVE)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
        end)
        if canActive then
            UIHelper.redpoint_create(btn, {x = 118, y = 36})
        end
    end
end

-- 说明：渲染底部总奖励区。
local function renderRewardSection(node, npcid)
    local allCount = toNumber(getPanelData().all, 0)
    local totalNeed = #(npc._config.rune_order or {})
    local claimed = toNumber(getPanelData().claim, 0) == 1 or toNumber(getPanelData().has_title, 0) == 1
    local titleName = tostring(npc._config.title_reward or "世界符文·[真我]")
    local titleShowName = titleName .. "[称号]"
    local allDesc = tostring(npc._config.all_desc or "")

    local rewardBox = GUI:Image_Create(node, "reward_box", 282, 56, REWARD_BOX_SKIN)
    GUI:setAnchorPoint(rewardBox, 0.5, 0.5)
    UiTools.showItemData(rewardBox, SL:GetMetaValue("ITEM_DATA", SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleShowName)))
    -- createText(node, "reward_title_text", 342, 70, 17, "#F5E6C6", titleShowName, FONT_MAIN, 0, 0.5)
    -- createText(node, "reward_desc", 342, 44, 15, claimed and "#6CFF7B" or "#FFD66D", allDesc ~= "" and allDesc or string.format("激活进度：%d/%d", allCount, totalNeed), FONT_MAIN, 0, 0.5)

    local btn = GUI:Button_Create(node, "reward_btn", 548 - 220, 0, BTN_REWARD)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    if (allCount >= totalNeed) and (not claimed) then
        UIHelper.redpoint_create(btn, {x = 176, y = 50})
    end
end

-- 说明：渲染整个世界符文界面。
renderMain = function(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    renderRuneButtons(node, npcid)
    renderSelectedDetail(node, npcid)
    renderRewardSection(node, npcid)
end

-- 说明：处理服务端回包并刷新界面。
function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 or p2 == 2 or p2 == 9 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node, npcid)
    end
end

return npc

