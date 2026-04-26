local npc = {}

npc._config = teshudata["npc_79"] or {}

local UIHelper = NPC_UI_HELPER

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/武器性格/武器性格.png", eff = false},
    closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
}

local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN_OK = "res/custom/six_city/武器性格/我知道了.png"
local SLOGAN_SKIN = "res/custom/six_city/武器性格/标语.png"

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

-- 说明：获取面板缓存数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：根据 key 返回对应性格的展示图片。
local function getPersonalitySkin(key)
    return PERSONALITY_SKIN[tostring(key or "")] or PERSONALITY_SKIN.baonu
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

-- 说明：构建当前性格运行时状态描述。
local function buildRuntimeDesc(data)
    local key = tostring(data.current_key or "")
    local lines = {}
    if key == "baonu" then
        local layer = toNumber(data.layer, 0)
        lines[#lines + 1] = string.format("当前杀戮层数：<font color='#FF3D31'>%d</font>", layer)
        lines[#lines + 1] = string.format("剩余持续时间：<font color='#FFD66D'>%d秒</font>", toNumber(data.layer_remain, 0))
    elseif key == "shixue" then
        lines[#lines + 1] = string.format("当前地图：<font color='#FFD66D'>%s</font>", tostring(data.cur_map or "未知"))
        lines[#lines + 1] = string.format("累计击杀：<font color='#FF3D31'>%d</font>", toNumber(data.same_map_kill, 0))
        if toNumber(data.same_map_active, 0) == 1 then
            lines[#lines + 1] = "状态：<font color='#6CFF7B'>已激活对怪增伤</font>"
        else
            lines[#lines + 1] = "状态：<font color='#FFD66D'>未达到激活条件</font>"
        end
    elseif key == "tanlan" then
        lines[#lines + 1] = string.format("今日贪婪金币：<font color='#FFD66D'>%d</font>", toNumber(data.greed_gold, 0))
        lines[#lines + 1] = "说明：仅六大陆怪物会触发额外金币。"
    elseif key == "lianmin" then
        lines[#lines + 1] = string.format("当前怜悯层差：<font color='#FF3D31'>%d%%</font>", toNumber(data.temp_gap, 0))
        lines[#lines + 1] = "说明：攻击低于自身等级的玩家时动态刷新。"
    elseif key == "lumang" then
        lines[#lines + 1] = string.format("当前鲁莽层差：<font color='#FF3D31'>%d%%</font>", toNumber(data.temp_gap, 0))
        lines[#lines + 1] = "说明：与更高等级玩家交战时动态刷新。"
    end
    return table.concat(lines, "\n")
end

-- 说明：渲染当前性格名字与图标。
local function renderCurrentTitle(node, data)
    GUI:Image_Create(node, "slogan", 392, 410, SLOGAN_SKIN)
    GUI:Image_Create(node, "personality_name", 512, 314, getPersonalitySkin(data.current_key))
    createText(node, "current_label", 220, 350, 28, "#F5E6C6", "今日性格：", FONT_TITLE, 0, 0.5)
end

-- 说明：渲染主体说明文本。
local function renderDesc(node, data)
    createText(node, "desc_title", 389, 252, 26, "#FFDF68", "性格特性", FONT_TITLE, 0.5, 0.5)

    local fullText = table.concat({
        tostring(data.current_desc or ""),
        "",
        buildRuntimeDesc(data),
    }, "\n")

    local rich = GUI:RichText_Create(node, "desc_rich", 130, 220, fullText, 530, 24, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, 0, 1)
end

-- 说明：渲染底部关闭按钮。
local function renderButton(node)
    local btn = GUI:Button_Create(node, "know_btn", 300, 26, BTN_OK)
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