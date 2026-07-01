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

local PREVIEW_POS = {x = 254, y = 272}
local ACTION_BTN_POS = {x = 560, y = 72}
local CHECK_POS = {x = 712, y = 58}

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

-- 说明：固定配置只读取客户端 teshudata，服务端只下发动态状态。
local function getConfig()
    return npc._config or DEFAULT_CONFIG
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
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "preview_item", 25, 26, {index = itemIndex, look = true, movable = false, bgVisible = false}), 0.5, 0.5)
    end
    return box
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
    local previewNode = GUI:Node_Create(node, "preview_node", PREVIEW_POS.x, PREVIEW_POS.y)
    renderPreviewItem(previewNode)
end

-- 说明：渲染主界面按钮区与状态区。
local function renderActionArea(node, npcid)
    local signed = hasContract()
    local inMap = inContractMap()
    if signed then
        local enterBtn = GUI:Button_Create(node, "enter_btn", ACTION_BTN_POS.x, ACTION_BTN_POS.y, ENTER_BTN_SKIN)
        GUI:addOnClickEvent(enterBtn, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
        if canEnter() and (not inMap) then
            UIHelper.redpoint_create(enterBtn, {x = 150, y = 40})
        end
    else
        local signBtn = GUI:Button_Create(node, "sign_btn", ACTION_BTN_POS.x, ACTION_BTN_POS.y, CONTRACT_BTN_SKIN)
        GUI:addOnClickEvent(signBtn, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        UIHelper.redpoint_create(signBtn, {x = 140, y = 36})
    end

    local checkBg = GUI:Image_Create(node, "check_bg", CHECK_POS.x, CHECK_POS.y, CHECK_BG_SKIN)
    GUI:setAnchorPoint(checkBg, 0.5, 0.5)
    if signed then
        local checkOk = GUI:Image_Create(node, "check_ok", CHECK_POS.x, CHECK_POS.y, CHECK_OK_SKIN)
        GUI:setAnchorPoint(checkOk, 0.5, 0.5)
    end

end

-- 说明：渲染整个血契之门界面。
local function renderMain(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    renderPreviewSection(node)
    renderActionArea(node, npcid)
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
