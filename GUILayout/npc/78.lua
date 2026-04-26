local npc = {}

npc._config = teshudata["npc_78"] or {}

local UIHelper = NPC_UI_HELPER

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

-- 说明：返回当前面板数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：读取签订契约状态。
local function hasContract()
    return toNumber((getPanelData().contract), 0) == 1
end

-- 说明：读取是否满足狂暴之力前置。
local function hasTitleNeed()
    return toNumber((getPanelData().has_title), 0) == 1
end

-- 说明：读取当前是否处于可进入状态。
local function canEnter()
    return toNumber((getPanelData().can_enter), 0) == 1
end

-- 说明：读取玩家是否已处于血契地图内。
local function inContractMap()
    return toNumber((getPanelData().in_map), 0) == 1
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
    local previewName = tostring(npc._config.preview_item or "")
    local itemIndex = previewName ~= "" and toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", previewName), 0) or 0
    local box = GUI:Image_Create(parent, "preview_box", 0, 0, ITEM_BOX_SKIN)
    if itemIndex > 0 then
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "preview_item", 29, 30, {index = itemIndex, look = true, bgVisible = false}), 0.5, 0.5)
    end
    return box
end

-- 说明：渲染进入条件单行文案。
local function renderConditionRow(parent, idx, text, passed, y)
    local color = passed and "#6CFF7B" or "#FF4A4A"
    createText(parent, "cond_idx_" .. idx, 0, y, 26, "#F5E6C6", tostring(idx) .. ".", FONT_TITLE, 0, 0.5)
    createText(parent, "cond_text_" .. idx, 38, y, 24, color, text, FONT_TITLE, 0, 0.5)
end

-- 说明：构建右侧风险说明富文本。
local function buildRiskRichText()
    local dropCfg = npc._config.drop or {}
    local extraDrop = npc._config.extra_drop or {}
    local deathCfg = npc._config.death or {}
    return table.concat({
        string.format("<font color='#FF3C2F'>1. 爆率提高</font>\n<font color='#EED8BF'>小怪双倍爆率，BOSS三倍爆率。</font>\n<font color='#DFA070'>额外补发：</font><font color='#FFDF7A'>小怪+%d，BOSS+%d</font>\n", toNumber(dropCfg.normal_extra, 0), toNumber(dropCfg.boss_extra, 0)),
        string.format("<font color='#FF3C2F'>2. 死亡惩罚</font>\n<font color='#EED8BF'>死亡时随机掉落一件</font><font color='#FFDF7A'>未绑定装备</font><font color='#EED8BF'>。</font>\n<font color='#DFA070'>掉落保留：</font><font color='#FFDF7A'>%d秒</font>\n", toNumber(deathCfg.keep_sec, 0)),
        string.format("<font color='#FF3C2F'>3. 额外收益</font>\n<font color='#EED8BF'>击杀小怪有概率额外掉落</font><font color='#FFDF7A'>%s</font><font color='#EED8BF'>。</font>", tostring(extraDrop.item or "高阶星尘"))
    }, "")
end

-- 说明：渲染底部统计信息。
local function renderStats(node)
    local data = getPanelData()
    createText(node, "open_desc", 60, 32, 18, "#F5E6C6", "开放时间：" .. tostring(data.open_desc or "全天开放"), FONT_MAIN, 0, 0.5)
    createText(node, "enter_count", 320, 32, 18, "#F5E6C6", "进入次数：" .. tostring(toNumber(data.enter_count, 0)), FONT_MAIN, 0, 0.5)
    createText(node, "drop_kill", 500, 32, 18, "#FFD86B", "额外掉落：" .. tostring(toNumber(data.drop_kill, 0)), FONT_MAIN, 0, 0.5)
    createText(node, "drop_death", 650, 32, 18, "#FF8A67", "死亡掉装：" .. tostring(toNumber(data.drop_death, 0)), FONT_MAIN, 0, 0.5)
end

-- 说明：渲染主界面按钮区。
local function renderActionArea(node, npcid)
    local signed = hasContract()
    local inMap = inContractMap()

    local signBtn = GUI:Button_Create(node, "sign_btn", 555, 95, CONTRACT_BTN_SKIN)
    if not signed then
        GUI:addOnClickEvent(signBtn, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        UIHelper.redpoint_create(signBtn, {x = 140, y = 36})
    else
        GUI:setOpacity(signBtn, 180)
    end

    local enterBtn = GUI:Button_Create(node, "enter_btn", 188, 106, ENTER_BTN_SKIN)
    if canEnter() and (not inMap) then
        GUI:addOnClickEvent(enterBtn, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
        UIHelper.redpoint_create(enterBtn, {x = 150, y = 40})
    else
        GUI:setOpacity(enterBtn, 180)
    end

    local checkBg = GUI:Image_Create(node, "check_bg", 716, 40, CHECK_BG_SKIN)
    GUI:setAnchorPoint(checkBg, 0.5, 0.5)
    if signed then
        local checkOk = GUI:Image_Create(node, "check_ok", 716, 40, CHECK_OK_SKIN)
        GUI:setAnchorPoint(checkOk, 0.5, 0.5)
    end

    local signState = signed and "已签订血色契约" or "尚未签订血色契约"
    local signColor = signed and "#6CFF7B" or "#FF5A5A"
    createText(node, "sign_state", 640, 84, 18, signColor, signState, FONT_MAIN, 0.5, 0.5)

    local enterState = inMap and "当前已在血契地图内" or (canEnter() and "已满足进入条件" or "暂未满足进入条件")
    local enterColor = inMap and "#FFD86B" or (canEnter() and "#6CFF7B" or "#FF5A5A")
    createText(node, "enter_state", 252, 82, 18, enterColor, enterState, FONT_MAIN, 0.5, 0.5)
end

-- 说明：渲染整个血契之门界面。
local function renderMain(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    local previewNode = GUI:Node_Create(node, "preview_node", 304, 316)
    renderPreviewItem(previewNode)

    renderConditionRow(node, 1, "开启狂暴之力", hasTitleNeed(), 194)
    renderConditionRow(node, 2, "签订血色契约", hasContract(), 146)

    local riskRich = createRichText(node, "risk_desc", 490, 298, buildRiskRichText(), 278, 190, 0, 1)
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