local npc = {}

local UIHelper = NPC_UI_HELPER

local DEFAULT_CONFIG = {
    id = 82,
    name = "武器性格",
}

npc._config = teshudata["npc_82"] or teshudata["npc_79"] or DEFAULT_CONFIG

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/武器性格/武器性格.png", eff = false},
    closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
}

local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN_OK = "res/custom/six_city/武器性格/我知道了.png"
local SLOGAN_SKIN = "res/custom/six_city/武器性格/标语.png"
local TITLE_SKIN = "res/custom/six_city/武器性格/标题.png"

local PERSONALITY_SKIN = {
    baonu = "res/custom/six_city/武器性格/暴怒.png",
    lianmin = "res/custom/six_city/武器性格/怜悯.png",
    shixue = "res/custom/six_city/武器性格/嗜血.png",
    tanlan = "res/custom/six_city/武器性格/贪婪.png",
    lumang = "res/custom/six_city/武器性格/鲁莽.png",
}

-- 说明：统一转数字，便于处理服务端回包中的可空字段。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 说明：获取当前缓存的服务端数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：优先使用服务端下发配置，客户端本地配置只作为兜底。
local function getConfig()
    local data = getPanelData()
    return data.config or npc._config or DEFAULT_CONFIG
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

-- 说明：根据 key 返回对应性格的展示图片。
local function getPersonalitySkin(key)
    return PERSONALITY_SKIN[tostring(key or "")] or PERSONALITY_SKIN.baonu
end

-- 说明：根据性格 key 查询配置，便于补齐默认文案。
local function getPersonalityCfg(key)
    for _, one in pairs(getConfig().personalities or {}) do
        if type(one) == "table" and tostring(one.key or "") == tostring(key or "") then
            return one
        end
    end
    return {}
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

-- 说明：创建可滚动富文本区域，避免描述较长时被截断。
local function createScrollRichText(parent, name, x, y, width, height, html)
    local scroll = GUI:ScrollView_Create(parent, name, x, y, width, height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, width, height)
    local rich = GUI:RichText_Create(scroll, name .. "_content", 0, height - 4, tostring(html or ""), width - 14, 17, "#FFFFFF", 6, nil, nil)
    GUI:setAnchorPoint(rich, 0, 1)
    local richHeight = GUI:getBoundingBox(rich).height
    local innerHeight = math.max(height, richHeight + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, width, innerHeight)
    GUI:setPosition(rich, 0, innerHeight - 4)
    return scroll
end

-- 说明：补齐当前性格的名称。
local function getCurrentName(data)
    local cfg = getPersonalityCfg(data.current_key)
    local name = tostring(data.current_name or cfg.name or "")
    if name == "" then
        return "暴怒"
    end
    return name
end

-- 说明：补齐当前性格的基础描述。
local function getCurrentDesc(data)
    local cfg = getPersonalityCfg(data.current_key)
    local desc = tostring(data.current_desc or cfg.desc or "")
    if desc == "" then
        return "今日性格已生效，请根据当前状态调整打法。"
    end
    return desc
end

-- 说明：构建当前性格运行时状态描述。
local function buildRuntimeDesc(data)
    local key = tostring(data.current_key or "")
    local cfg = getPersonalityCfg(key)
    local lines = {}
    if key == "baonu" then
        local layer = toNumber(data.layer, 0)
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>当前杀戮：</font><font color='#FF4B3B'>%d/%d层</font>", layer, toNumber(cfg.layer_max, 5))
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>剩余时间：</font><font color='#FFD66D'>%d秒</font>", toNumber(data.layer_remain, 0))
        lines[#lines + 1] = "<font color='#E8E8E8'>满层后会获得额外爆伤，但也会承受更多伤害。</font>"
    elseif key == "shixue" then
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>当前地图：</font><font color='#FFD66D'>%s</font>", tostring(data.cur_map or "未知"))
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>累计击杀：</font><font color='#FF4B3B'>%d/%d</font>", toNumber(data.same_map_kill, 0), toNumber(cfg.kill_need, 100))
        lines[#lines + 1] = toNumber(data.same_map_active, 0) == 1 and "<font color='#6CFF7B'>状态：已激活对怪增伤</font>" or "<font color='#FFD66D'>状态：未达到激活条件</font>"
    elseif key == "tanlan" then
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>今日贪婪金币：</font><font color='#FFD66D'>%d</font>", toNumber(data.greed_gold, 0))
        lines[#lines + 1] = "<font color='#E8E8E8'>仅六大陆怪物会触发额外金币收益。</font>"
    elseif key == "lianmin" then
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>当前层差：</font><font color='#FF4B3B'>%d%%</font>", toNumber(data.temp_gap, 0))
        lines[#lines + 1] = "<font color='#E8E8E8'>攻击低于自身等级的玩家时动态刷新。</font>"
    elseif key == "lumang" then
        lines[#lines + 1] = string.format("<font color='#F5E6C6'>当前层差：</font><font color='#FF4B3B'>%d%%</font>", toNumber(data.temp_gap, 0))
        lines[#lines + 1] = "<font color='#E8E8E8'>与更高等级玩家交战时动态刷新。</font>"
    end
    return table.concat(lines, "\n")
end

-- 说明：组合基础说明和运行时状态说明。
local function buildDescRichText(data)
    local parts = {
        string.format("<font color='#F5E6C6'>%s</font>", getCurrentDesc(data)),
    }
    local runtime = buildRuntimeDesc(data)
    if runtime ~= "" then
        parts[#parts + 1] = "\n\n<font color='#FFDF68'>当前状态</font>\n" .. runtime
    end
    return table.concat(parts, "")
end

-- 说明：渲染顶部标题和当前性格展示。
local function renderCurrentTitle(node, data)
    local slogan = GUI:Image_Create(node, "slogan", 390, 376, SLOGAN_SKIN)
    GUI:setScale(slogan, 0.72)
    createText(node, "current_label", 126, 280, 26, "#F5E6C6", "今日性格：", FONT_TITLE, 0, 0.5)
    local personalityImg = GUI:Image_Create(node, "personality_name", 390, 250, getPersonalitySkin(data.current_key))
    GUI:setScale(personalityImg, 0.74)
    createText(node, "current_name", 390, 184, 20, "#FFD66D", string.format("当前为【%s】性格", getCurrentName(data)), FONT_MAIN, 0.5, 0.5)
    createText(node, "current_hint", 390, 156, 16, "#CFCFCF", "每日随机刷新，战斗中实时生效", FONT_MAIN, 0.5, 0.5)
end

-- 说明：渲染主体说明文本。
local function renderDesc(node, data)
    createText(node, "desc_title", 390, 128, 24, "#FFDF68", "性格特性", FONT_TITLE, 0.5, 0.5)
    createScrollRichText(node, "desc_scroll", 84, 28, 606, 118, buildDescRichText(data))
end

-- 说明：渲染底部关闭按钮。
local function renderButton(node)
    local btn = GUI:Button_Create(node, "know_btn", 282, 12, BTN_OK)
    GUI:addOnClickEvent(btn, function()
        if npc._window and npc._window.parent then
            GUI:Win_Close(npc._window.parent)
        end
    end)
end

-- 说明：渲染整个武器性格面板。
local function renderMain(node)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local data = getPanelData()
    renderCurrentTitle(node, data)
    renderDesc(node, data)
    renderButton(node)
end

-- 说明：处理服务端回包并刷新界面。
function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 or p2 == 9 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node)
    end
end

return npc