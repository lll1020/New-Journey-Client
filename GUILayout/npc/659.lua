local npc = {}

npc._config = teshudata["npc_659"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/659_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_659"
local win_count = key.."_win"
local btn_pos = {600, 110}
local cost_pos = {507 + 25 - 135, 202 + 20}

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
        npc.data.T_dljq[win_count] = (npc.data.T_dljq and npc.data.T_dljq[win_count]) and npc.data.T_dljq[win_count] or 0
        local jl = ItemNumByTable_img_new({npc._config.jl[1],{npc._config.ch.."[称号]",1}}, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 170, 125)

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then
            local desc = GUI:Text_Create(node, "desc",500,180, 20, "#808080", "当前胜利次数："..(npc.data.T_dljq[win_count] or 0))
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#00FFFF", 2)
            
            for i = 1, 3 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 570 + (i-1)*120 - 200, 50, "res/custom/four_city/fwcq/list/n/"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                SL:SendLuaNetMsg(100, npcid, 1, i, "")
            end)
        end

            
        elseif npc.data.T_dljq[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc

