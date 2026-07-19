local npc = {}

npc._config = teshudata["npc_662"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/662_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_662"
local btn_pos = {600, 110}
local cost_pos = {507 + 25, 202 + 10}

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
        GUI:setPosition(jl, 175, 132)

        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then

            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/an_tongyong.png")
            local Button_wz = GUI:Text_Create(Button, "desc",116,52, 25, "#FFFBF0", "比试比试")
            GUI:setAnchorPoint(Button_wz, 0.5, 0.5)
            GUI:Text_setFontName(Button_wz, "fonts/502.ttf")
            GUI:Text_enableOutline(Button_wz, "#CA352C", 2)

            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then
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
