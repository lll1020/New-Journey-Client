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

-- 说明：获取当前缓存的服务端数据。
local function getPanelData()
    return npc.data or {}
end

-- 说明：固定配置只读取客户端 teshudata，服务端只下发动态状态。
local function getConfig()
    return npc._config or DEFAULT_CONFIG
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

-- 说明：渲染顶部标题和当前性格展示。
local function renderCurrentTitle(node, data)
    local slogan = GUI:Image_Create(node, "slogan", 389, 421, SLOGAN_SKIN)
    GUI:setAnchorPoint(slogan, 0.5, 0.5)
    local personalityImg = GUI:Image_Create(node, "personality_name", 389, 270, getPersonalitySkin(data.current_key))
    GUI:setAnchorPoint(personalityImg, 0.5, 0.5)
end

-- 说明：渲染底部关闭按钮。
local function renderButton(node)
    local btn = GUI:Button_Create(node, "know_btn", 282, 20, BTN_OK)
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
