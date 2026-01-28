local npc = {}

npc._config = teshudata["npc_655"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/655_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_655"
local btn_pos = {450, 110}
local cost_pos = {507 - 314, 202 + 10 - 134}

function npc.main(npcid, p2, p3, msgData)


    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        local jl = ItemNumByTable_img_new({npc._config.jl[1],{npc._config.ch.."[称号]",1}}, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 600, 80)

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end
        local center_x, center_y = 265, 310
        local radius = 100
        local step = (2 * math.pi) / 9
        local start_angle = -math.pi / 2
        for i = 1, 9 do
            local angle = start_angle + (i - 1) * step
            local x = math.floor(center_x + radius * math.cos(angle) + 0.5)
            local y = math.floor(center_y + radius * math.sin(angle) + 0.5)
            GUI:setAnchorPoint(GUI:Image_Create(node, "node"..i, x, y, "res/custom/all_story_mission/4/655_"..(npc.data.T_dljq[key]>=i and 1 or 2)..".png"), 0.5, 0.5)
        end


        if npc.data.T_dljq[key] < npc._config.max_num then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/655_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == npc._config.max_num then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.T_dljq[key] = p3
        UI_updata(npc.node)
    end
end

return npc
