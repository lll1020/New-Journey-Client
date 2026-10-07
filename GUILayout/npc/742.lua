local npc = {}

local DISPLAY_ID = 742
local SERVER_ID = 626
local KEY = "npc_626"
local WINDOW_OPTS = {background = {skin = "res/custom/all_story_mission/3/742_bg.png"}, closeButton = {x = 747, y = 420}}
local BUTTON_SKIN = "res/wy/public/an_tiaozhan.png"
local COMPLETE_SKIN = "res/wy/public/7_1.png"
local CHALLENGE_POS = {450, 60}

local function valid(node)
    return node and not tolua.isnull(node)
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do opts[k] = v end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, teshudata[KEY])
    opts.subTitle = teshudata[KEY] and teshudata[KEY].title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    return npc._window.node
end

local function render(node, npcid)
    if not valid(node) then return end
    GUI:removeAllChildren(node)
    local state = tonumber((npc.data.T_dljq or {})[KEY] or 0) or 0
    if state >= 2 then
        GUI:setAnchorPoint(GUI:Image_Create(node, "done", CHALLENGE_POS[1], CHALLENGE_POS[2], COMPLETE_SKIN), 0.5, 0.5)
        return
    end
    local rewardNode = ItemNumByTable_img_new(teshudata[KEY].jl, nil, GUI:Node_Create(node, "jl", 0, 0))
    GUI:setPosition(rewardNode, 330, 120)
    local button = GUI:Button_Create(node, "challenge", CHALLENGE_POS[1], CHALLENGE_POS[2], BUTTON_SKIN)
    GUI:setAnchorPoint(button, 0.5, 0.5)
    GUI:addOnClickEvent(button, function()
        NPC_UI_HELPER.closeWindow(npc._window)
        SL:SendLuaNetMsg(100, SERVER_ID, 1, 0, "")
    end)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.node = ensureWindow(npcid)
    else
        npc.data = npc.data or {T_dljq = {}}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.T_dljq[KEY] = p3
    end
    render(npc.node, npcid)
end

return npc