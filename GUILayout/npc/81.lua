local npc = {}

local UIHelper = NPC_UI_HELPER

local DEFAULT_CONFIG = {
    id = 81,
    name = "血契之门",
}

npc._config = teshudata["npc_81"] or teshudata["npc_78"] or DEFAULT_CONFIG

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/血契之门/血契之门.png", eff = false},
    closeButton = {x = 780, y = 470, skin = "res/wy/public/close_red_big.png"},
}

local CONTRACT_BTN_SKIN = "res/custom/six_city/血契之门/签到契约.png"
local ENTER_BTN_SKIN = "res/custom/six_city/血契之门/进入秘境.png"
local CHECK_BG_SKIN = "res/custom/six_city/血契之门/对勾底.png"
local CHECK_OK_SKIN = "res/custom/six_city/血契之门/对勾.png"
local ITEM_BOX_SKIN = "res/custom/six_city/血契之门/装备框-.png"
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"

local PREVIEW_POS = {x = 250, y = 270}
local ENTER_BTN_POS = {x = 116, y = 56}
local SIGN_BTN_POS = {x = 548, y = 72}
local CHECK_POS = {x = 708, y = 48}
local CONDITION_LAYOUT = {
    idxX = 148,
    textX = 186,
    rowY = {188, 140},
}
local RISK_LAYOUT = {
    x = 486,
    y = 336,
    width = 248,
    size = 16,
}
local STAT_LAYOUT = {
    openX = 50,
    countX = 220,
    extraDropX = 384,
    deathDropX = 542,
    rowY = 50,
    noticeX = 402,
    noticeY = 18,
}

-- 说明：统一转数字，避免服务端字段为空时界面渲染报错。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 说明：返回当前面板数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：优先使用服务端下发配置，客户端本地配置只做兜底。
local function getConfig()
    local data = getPanelData()
    return data.config or npc._config or DEFAULT_CONFIG
end

-- 说明：读取血契之门文案配置。
local function getTextPack()
    return getConfig().texts or {}
end

-- 说明：创建并复用主窗口。
local function ensureWindow(npcid)
    local opts = {}
    local cfg = getConfig()
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = UIHelper.formatNpcTitle(npcid, cfg)
    opts.subTitle = cfg and cfg.name
    npc._window = UIHelper.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

-- 说明：读取签订契约状态。
local function hasContract()
    return toNumber(getPanelData().contract, 0) == 1
end

-- 说明：读取是否满足前置称号条件。
local function hasTitleNeed()
    return toNumber(getPanelData().has_title, 0) == 1
end

-- 说明：读取当前是否处于可进入状态。
local function canEnter()
    return toNumber(getPanelData().can_enter, 0) == 1
end

-- 说明：读取玩家是否已处于血契地图内。
local function inContractMap()
    return toNumber(getPanelData().in_map, 0) == 1
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

-- 说明：统一创建富文本区域，便于描述信息换行展示。
local function createRichText(parent, name, x, y, text, width, size, anchorX, anchorY)
    local rich = GUI:RichText_Create(parent, name, x, y, tostring(text or ""), width or 260, size or 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, anchorX or 0, anchorY or 0)
    return rich
end

-- 说明：渲染掉落预览图标。
local function renderPreviewItem(parent)
    local cfg = getConfig()
    local previewName = tostring(cfg.preview_item or "")
    local itemIndex = previewName ~= "" and toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", previewName), 0) or 0
    local box = GUI:Image_Create(parent, "preview_box", 0, 0, ITEM_BOX_SKIN)
    if itemIndex > 0 then
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "preview_item", 29, 30, {index = itemIndex, look = true, movable = false, bgVisible = false}), 0.5, 0.5)
    end
    return box
end

-- 说明：渲染进入条件单行文案。
local function renderConditionRow(parent, idx, text, passed, y)
    local color = passed and "#6CFF7B" or "#FF4A4A"
    createText(parent, "cond_idx_" .. idx, CONDITION_LAYOUT.idxX, y, 22, "#F5E6C6", tostring(idx) .. ".", FONT_TITLE, 0, 0.5)
    createText(parent, "cond_text_" .. idx, CONDITION_LAYOUT.textX, y, 20, color, text, FONT_TITLE, 0, 0.5)
end

-- 说明：构建右侧风险说明富文本。
local function buildRiskRichText()
    local cfg = getConfig()
    local dropCfg = cfg.drop or {}
    local extraDrop = cfg.extra_drop or {}
    local deathCfg = cfg.death or {}
    local extraItem = tostring(extraDrop.item or "高阶星尘")
    return table.concat({
        string.format("<font color='#FF3C2F'>1. 爆率提高</font>\n<font color='#EED8BF'>小怪双倍爆率，BOSS三倍爆率。</font>\n<font color='#DFA070'>额外补发：</font><font color='#FFDF7A'>小怪+%d，BOSS+%d</font>\n\n", toNumber(dropCfg.normal_extra, 0), toNumber(dropCfg.boss_extra, 0)),
        string.format("<font color='#FF3C2F'>2. 死亡惩罚</font>\n<font color='#EED8BF'>死亡时随机掉落一件</font><font color='#FFDF7A'>未绑定装备</font><font color='#EED8BF'>。</font>\n<font color='#DFA070'>掉落保留：</font><font color='#FFDF7A'>%d秒</font>\n\n", toNumber(deathCfg.keep_sec, 0)),
        string.format("<font color='#FF3C2F'>3. 额外收益</font>\n<font color='#EED8BF'>击杀小怪有概率额外掉落</font><font color='#FFDF7A'>%s</font><font color='#EED8BF'>。</font>", extraItem)
    }, "")
end

-- 说明：返回进入按钮的当前状态文案与颜色。
local function getEnterStateInfo()
    local textPack = getTextPack()
    if inContractMap() then
        return "当前已在血契地图内", "#FFD86B"
    end
    if canEnter() then
        return textPack.enter_success or "已满足进入条件", "#6CFF7B"
    end
    if not hasTitleNeed() then
        return textPack.need_title or "进入前需先开启狂暴之力", "#FF6A6A"
    end
    if not hasContract() then
        return textPack.need_contract or "进入前需先签订血色契约", "#FF6A6A"
    end
    return textPack.not_open or "血契之门当前未开启", "#FF9A66"
end

-- 说明：返回契约按钮的当前状态文案与颜色。
local function getContractStateInfo()
    local textPack = getTextPack()
    if hasContract() then
        return textPack.signed or "已签订血色契约", "#6CFF7B"
    end
    return "点击签订血色契约", "#FF6A6A"
end

-- 说明：渲染左侧产出预览区。
local function renderPreviewSection(node)
    local cfg = getConfig()
    local previewName = tostring(cfg.preview_item or "")
    local previewNode = GUI:Node_Create(node, "preview_node", PREVIEW_POS.x, PREVIEW_POS.y)
    renderPreviewItem(previewNode)
    if previewName ~= "" then
        createText(node, "preview_name", PREVIEW_POS.x + 28, PREVIEW_POS.y - 34, 18, "#FFD86B", previewName, FONT_MAIN, 0.5, 0.5)
    end
end

-- 说明：渲染底部统计信息与提醒文案。
local function renderStats(node)
    local data = getPanelData()
    local cfg = getConfig()
    local notice = tostring(cfg.notice or "")
    createText(node, "open_desc", STAT_LAYOUT.openX, STAT_LAYOUT.rowY, 16, "#F5E6C6", "开放时间：" .. tostring(data.open_desc or "全天开放"), FONT_MAIN, 0, 0.5)
    createText(node, "enter_count", STAT_LAYOUT.countX, STAT_LAYOUT.rowY, 16, "#F5E6C6", "进入次数：" .. tostring(toNumber(data.enter_count, 0)), FONT_MAIN, 0, 0.5)
    createText(node, "drop_kill", STAT_LAYOUT.extraDropX, STAT_LAYOUT.rowY, 16, "#FFD86B", "额外掉落：" .. tostring(toNumber(data.drop_kill, 0)), FONT_MAIN, 0, 0.5)
    createText(node, "drop_death", STAT_LAYOUT.deathDropX, STAT_LAYOUT.rowY, 16, "#FF8A67", "死亡掉装：" .. tostring(toNumber(data.drop_death, 0)), FONT_MAIN, 0, 0.5)
    if notice ~= "" then
        createText(node, "notice", STAT_LAYOUT.noticeX, STAT_LAYOUT.noticeY, 15, "#C9B390", notice, FONT_MAIN, 0.5, 0.5)
    end
end

-- 说明：渲染主界面按钮区与状态区。
local function renderActionArea(node, npcid)
    local signed = hasContract()
    local inMap = inContractMap()
    local signBtn = GUI:Button_Create(node, "sign_btn", SIGN_BTN_POS.x, SIGN_BTN_POS.y, CONTRACT_BTN_SKIN)
    GUI:addOnClickEvent(signBtn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
    if not signed then
        UIHelper.redpoint_create(signBtn, {x = 140, y = 36})
    else
        GUI:setOpacity(signBtn, 210)
    end

    local enterBtn = GUI:Button_Create(node, "enter_btn", ENTER_BTN_POS.x, ENTER_BTN_POS.y, ENTER_BTN_SKIN)
    GUI:addOnClickEvent(enterBtn, function()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    if canEnter() and (not inMap) then
        UIHelper.redpoint_create(enterBtn, {x = 150, y = 40})
    else
        GUI:setOpacity(enterBtn, 190)
    end

    local checkBg = GUI:Image_Create(node, "check_bg", CHECK_POS.x, CHECK_POS.y, CHECK_BG_SKIN)
    GUI:setAnchorPoint(checkBg, 0.5, 0.5)
    if signed then
        local checkOk = GUI:Image_Create(node, "check_ok", CHECK_POS.x, CHECK_POS.y, CHECK_OK_SKIN)
        GUI:setAnchorPoint(checkOk, 0.5, 0.5)
    end

    local signText, signColor = getContractStateInfo()
    createText(node, "sign_state", 646, 60, 18, signColor, signText, FONT_MAIN, 0.5, 0.5)
    createText(node, "check_state", CHECK_POS.x, 22, 16, signed and "#6CFF7B" or "#B5A18B", signed and "血契已签" or "等待签订", FONT_MAIN, 0.5, 0.5)

    local enterText, enterColor = getEnterStateInfo()
    createText(node, "enter_state", 168, 38, 16, enterColor, enterText, FONT_MAIN, 0, 0.5)
end

-- 说明：渲染整个血契之门界面。
local function renderMain(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    renderPreviewSection(node)
    renderConditionRow(node, 1, "开启狂暴之力", hasTitleNeed(), CONDITION_LAYOUT.rowY[1])
    renderConditionRow(node, 2, "签订血色契约", hasContract(), CONDITION_LAYOUT.rowY[2])

    local riskRich = createRichText(node, "risk_desc", RISK_LAYOUT.x, RISK_LAYOUT.y, buildRiskRichText(), RISK_LAYOUT.width, RISK_LAYOUT.size, 0, 1)
    GUI:setAnchorPoint(riskRich, 0, 1)

    renderActionArea(node, npcid)
    renderStats(node)
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
