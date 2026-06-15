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

local RUNE_POS = {
    [1] = {x = 82, y = 226, nameX = 42, nameY = 270},
    [2] = {x = 202, y = 246, nameX = 162, nameY = 290},
    [3] = {x = 210, y = 84, nameX = 170, nameY = 128},
    [4] = {x = 374, y = 286, nameX = 334, nameY = 330},
    [5] = {x = 548, y = 196, nameX = 508, nameY = 240},
    [6] = {x = 626, y = 96, nameX = 586, nameY = 140},
    [7] = {x = 694, y = 292, nameX = 654, nameY = 336},
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
            local selectImg = GUI:Image_Create(node, "select_" .. idx, pos.x - 12, pos.y - 12, SELECT_SKIN)
            GUI:setScale(selectImg, 0.78)
        end
        if isRuneActive(idx) then
            local stamp = GUI:Image_Create(node, "active_stamp_" .. idx, pos.x - 24, pos.y - 40, ACTIVE_STAMP)
            GUI:setScale(stamp, 0.82)
        elseif canRuneActivate(idx) then
            UIHelper.redpoint_create(btn, {x = 100, y = 72})
        end
    end
end

-- 说明：渲染右侧当前选中符文详情。
local function renderSelectedDetail(node, npcid)
    local idx = getSelectedIdx()
    local runeCfg = getRuneCfg(idx)
    local active = isRuneActive(idx)
    local canActive = canRuneActivate(idx)

    local detailNode = GUI:Node_Create(node, "detail_node", 0, 0)
    GUI:Image_Create(detailNode, "cond_box", 336, 180, COND_BOX_SKIN)
    GUI:Image_Create(detailNode, "cond_img", 374, 206, getConditionSkin(idx))

    createText(detailNode, "title_desc", 492, 252, 22, "#F94B42", tostring(runeCfg.name or "符文"), FONT_TITLE, 0.5, 0.5)
    createText(detailNode, "sub_desc", 492, 220, 18, active and "#6CFF7B" or (canActive and "#FFD66D" or "#FF5A5A"), active and "当前符文已激活" or (canActive and "已满足激活条件" or "尚未满足激活条件"), FONT_MAIN, 0.5, 0.5)

    if active then
        local activeImg = GUI:Image_Create(detailNode, "selected_active", 492, 140, ACTIVE_STAMP)
        GUI:setScale(activeImg, 0.82)
    else
        local btn = GUI:Button_Create(detailNode, "active_btn", 432, 110, BTN_ACTIVE)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
        end)
        if canActive then
            UIHelper.redpoint_create(btn, {x = 150, y = 42})
        else
            GUI:setOpacity(btn, 180)
        end
    end
end

-- 说明：渲染底部总奖励区。
local function renderRewardSection(node, npcid)
    local allCount = toNumber(getPanelData().all, 0)
    local totalNeed = #(npc._config.rune_order or {})
    local claimed = toNumber(getPanelData().claim, 0) == 1 or toNumber(getPanelData().has_title, 0) == 1
    local titleName = tostring(npc._config.title_reward or "世界符文·[真我]")
    local allDesc = tostring(npc._config.all_desc or "")

    createText(node, "reward_progress", 38, 84, 17, "#F94B42", string.format("激活进度：%d/%d", allCount, totalNeed), FONT_MAIN, 0, 0.5)
    createText(node, "reward_title_text", 300, 76, 16, "#F5E6C6", titleName, FONT_MAIN, 0.5, 0.5)
    createText(node, "reward_desc", 300, 46, 15, claimed and "#6CFF7B" or "#FFD66D", allDesc ~= "" and allDesc or "全部激活后领取总奖励", FONT_MAIN, 0.5, 0.5)

    local btn = GUI:Button_Create(node, "reward_btn", 552, 20, BTN_REWARD)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    if (allCount >= totalNeed) and (not claimed) then
        UIHelper.redpoint_create(btn, {x = 176, y = 50})
    else
        GUI:setOpacity(btn, claimed and 150 or 180)
    end

    local stateText = claimed and "奖励已领取" or ((allCount >= totalNeed) and "可领取总奖励" or "激活全部符文后解锁")
    local stateColor = claimed and "#6CFF7B" or ((allCount >= totalNeed) and "#FFD66D" or "#A0A0A0")
    createText(node, "reward_state", 646, 90, 15, stateColor, stateText, FONT_MAIN, 0.5, 0.5)
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
