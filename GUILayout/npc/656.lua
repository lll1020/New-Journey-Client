local npc = {}

npc._config = teshudata["npc_656"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/656_bg.png"},
    closeButton = {x = 760, y = 380},
}
local key = "npc_656"
local btn_pos = {600, 110}
local cost_pos = {507 + 25  +140, 202 + 10 + 48}

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
        GUI:setPosition(jl, 480, 160)

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end
        local grid_center_x, grid_center_y = 265, 290
        local grid_spacing = 148
        local start_x = grid_center_x - grid_spacing
        local start_y = grid_center_y + grid_spacing
        for i = 1, 9 do
            local col = (i - 1) % 3
            local row = math.floor((i - 1) / 3)
            local x = start_x + col * grid_spacing
            local y = start_y - row * grid_spacing
            local anchor_x = (col == 0 and 0) or (col == 1 and 0.5) or 1
            local anchor_y = (row == 0 and 1) or (row == 1 and 0.5) or 0
            local img = GUI:Image_Create(node, "node"..i, x, y, "res/custom/all_story_mission/4/656_"..(npc.data.T_dljq[key]>=i and 2 or 1).."/"..i..".png")
            GUI:setAnchorPoint(img, anchor_x, anchor_y)
        end


        if npc.data.T_dljq[key] < npc._config.max_num then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/656_btn.png")
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
