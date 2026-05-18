local npc = {}

local MIJING_CFG = {
    [86] = {name = "苍云秘境", img = "苍云秘境.png"},
    [87] = {name = "若水秘境", img = "若水秘境.png"},
    [88] = {name = "红尘秘境", img = "红尘秘境.png"},
    [89] = {name = "灵虚秘境", img = "灵虚秘境.png"},
    [90] = {name = "万灵秘境", img = "示意图.png"},
    [91] = {name = "诸天秘境", img = "示意图.png"},
}

local WINDOW_OPTS = {
    background = {skin = "res/custom/mijing/示意图.png"},
    closeButton = {x = 720 - 120, y = 420 - 120},
    node = {x = 500, y = 300},
}

local function fileExists(path)
    return SL and SL.IsFileExist and SL:IsFileExist(path)
end

local function getBgPath(cfg)
    local path = "res/custom/mijing/" .. tostring((cfg and cfg.img) or "示意图.png")
    if fileExists(path) then
        return path
    end
    return "res/custom/mijing/示意图.png"
end

local function createOutlineText(parent, name, x, y, size, color, text)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:Text_setFontName(label, "fonts/font4.ttf")
    GUI:Text_enableOutline(label, "#140806", 2)
    GUI:setAnchorPoint(label, 0.5, 0.5)
    return label
end

local function ensureWindow(npcid, cfg)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.background = {skin = getBgPath(cfg)}
    opts.titleText = cfg and cfg.name or NPC_UI_HELPER.formatNpcTitle(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function render(node, npcid, cfg)
    GUI:removeAllChildren(node)
    -- local name = tostring((cfg and cfg.name) or "秘境")
    -- createOutlineText(node, "title", 0, 155, 34, "#ffe9b8", name)
    createOutlineText(node, "need", 0 - 130, 92 - 282, 22, "#e9f7ff", "拥有【日卡】称号")

    -- local tip = npc.data and tonumber(npc.data.has_title or 0) == 1
    --     and "今日已解锁，可进入挑战"
    --     or "未拥有日卡称号，无法进入"
    -- createOutlineText(node, "status", 0, 52, 20, npc.data and tonumber(npc.data.has_title or 0) == 1 and "#7cff7c" or "#ff7777", tip)

    local btn = GUI:Button_Create(node, "enter_btn", 0 - 166, -155 -88, "res/custom/mijing/进入秘境.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)

    -- local titleIcon = GUI:Image_Create(node, "title_icon", -160, 85, "res/custom/mijing/顶级称号.png")
    -- GUI:setAnchorPoint(titleIcon, 0.5, 0.5)
    -- local bagIcon = GUI:Image_Create(node, "bag_icon", 160, 85, "res/custom/mijing/背包神器.png")
    -- GUI:setAnchorPoint(bagIcon, 0.5, 0.5)
end

function npc.main(npcid, p2, p3, msgData)
    local cfg = MIJING_CFG[tonumber(npcid or 0)] or MIJING_CFG[86]
    if type(msgData) == "string" and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or {}
    else
        npc.data = npc.data or {}
    end
    ensureWindow(npcid, cfg)
    render(npc.node, npcid, cfg)
end

return npc
