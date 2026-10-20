local npc = {}

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/2/604_bg.png"},
    closeButton = {x = 747 + 90, y = 380 + 50},
}

local function createText(parent, name, x, y, size, color, text)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text)
    GUI:setAnchorPoint(label, 0.5, 0.5)
    GUI:Text_enableOutline(label, "#100808", 2)
    GUI:Text_setFontName(label, "fonts/502.ttf")
    return label
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = "筑基丹合成"
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.node = npc._window.node
    return npc.node
end

local function UI_update(node)
    if not node or type(npc.data) ~= "table" then
        return
    end
    GUI:removeAllChildren(node)
    local data = npc.data
    local need = data.need or {fragment = 10, rune = 5, gold = 500000}
    -- createText(node, "title", 390, 425, 26, "#FFE9A8", "筑基丹合成")
    -- createText(node, "desc", 390, 365, 18, "#FFFFFF", "筑基丹碎片*10 + 灵气符文*5 + 金币*50W")

    local costs = {
        {"筑基丹碎片", 10, 230},
        {"灵气符文", 5, 390},
        {"金币", 500000, 550},
    }

    checkItemNumByTable_img_kuang(costs, nil, GUI:Node_Create(node, "cost", 240 + 282,100 + 114))
    ItemNumByTable_img_new({{"筑基丹",1}}, nil, GUI:Node_Create(node, "show", 240 + 90+ 20,100))

    local button = GUI:Button_Create(node, "make", 390 + 394, 85, "res/custom/all_story_mission/6/ancient_ice_sword/immediate_compose.png")
    GUI:setAnchorPoint(button, 0.5, 0.5)
    GUI:addOnClickEvent(button, function()
        SL:SendLuaNetMsg(100, 604, 1, 0, "")
    end)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        UI_update(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        UI_update(npc.node)
    end
end

return npc
