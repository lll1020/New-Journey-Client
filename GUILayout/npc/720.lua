local npc = {}

npc._config = teshudata["npc_720"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/720/chief_bg.png"},
    closeButton = {x = 747, y = 380},
}

local BG_MAIN = "res/custom/all_story_mission/5/720/chief_bg_alt.png"
local BTN_DO = "res/custom/all_story_mission/5/720/btn_bury_chief.png"
local BTN_DONE = "res/custom/all_story_mission/5/720/btn_thanks_chief.png"
local function ensureWindow(id)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(id, npc._config)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, id, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end
local function getChoice()
    local data = npc.data and npc.data.T_dljq or {}
    local choice = tonumber(data["npc_705_choice"] or npc.choice or 0) or 0
    if choice == 1 or choice == 2 then
        return choice
    end
    return 0
end

local function getState()
    local data = npc.data and npc.data.T_dljq or {}
    return tonumber(data["npc_720"] or 0) or 0
end

local function render(node)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    -- GUI:Image_Create(node, "bg", 0, 0, BG_MAIN)
    if getChoice() == 2 then
        GUI:Image_Create(node, "bg", 0, 0, BG_MAIN)
    end

    -- local cost = npc._config and npc._config.task_cfg and npc._config.task_cfg.cost_a or nil
    -- if cost then
    --     local costNode = checkItemNumByTable_img_kuang(cost, nil, GUI:Node_Create(node, "cost_node", 0, 0))
    --     GUI:setPosition(costNode, 455, 145)
    -- end

    if getState() >= 2 then
        GUI:Image_Create(node, "btn_done", 541, 47, "res/wy/public/7_1.png")
    else
        local btn = GUI:Button_Create(node, "btn_submit", 541, 47, getChoice() == 2 and BTN_DONE or BTN_DO)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, npc.npcid, 1, 0, "")
        end)
    end
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc._config = teshudata["npc_720"]
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.npcid = npcid
        ensureWindow(npcid)
        render(npc.node)
        return
    end

    npc.data = npc.data or {}
    npc.data.T_dljq = npc.data.T_dljq or {}
    npc.data.T_dljq["npc_720"] = 2

    if not npc.node then
        ensureWindow(npcid)
    end
    npc.npcid = npcid
    render(npc.node)
end

return npc
