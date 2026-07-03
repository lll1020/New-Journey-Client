local npc = {}

local UIHelper = NPC_UI_HELPER
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BG = "res/custom/six_city/残魂商店/示意图.png"

npc._config = teshudata["npc_78"] or {}

local function createText(parent, name, x, y, size, color, value, font, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(value or ""))
    GUI:Text_setFontName(label, font or FONT_MAIN)
    GUI:Text_enableOutline(label, "#100808", 2)
    GUI:setAnchorPoint(label, ax == nil and 0.5 or ax, ay == nil and 0.5 or ay)
    return label
end

local function ensureWindow(npcid)
    npc._window = UIHelper.ensureWindow(npc._window, npcid, {
        titleText = UIHelper.formatNpcTitle(npcid, npc._config),
        subTitle = npc._config.name,
        background = {skin = BG, eff = false},
        closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
    })
    npc.node = npc._window.node
    return npc.node
end

local function render(node)
    GUI:removeAllChildren(node)
    createText(node, "title", 390, 352, 30, "#FFE08A", "神道装备", FONT_TITLE)
    createText(node, "state", 390, 306, 22, "#FF6A5E", "该功能暂时关闭", FONT_TITLE)
    createText(node, "desc1", 390, 256, 18, "#F5E6C6", "npc78 当前不再使用，相关功能已停用。", FONT_MAIN)
    createText(node, "desc2", 390, 226, 18, "#D8C7A0", "后续如重新启用，再恢复神道装备展示与回收逻辑。", FONT_MAIN)
end

function npc.main(npcid, p2, p3, msgData)
    npc.data = SL:JsonDecode(msgData, false) or {}
    ensureWindow(npcid)
    render(npc.node)
end

return npc
