local npc = {}

npc._config = teshudata["npc_630"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/630_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_630"
local btn_pos = {462 + 158, 70 + 60}
local cost_pos = {507 - 240 + 180, 202 + 40}

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

        local jl = ItemNumByTable_img_new(npc._config.jl, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 330 + 44 , 120 + 30)

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        local showFirstOpenTake = NPC_UI_HELPER.shouldShowFirstOpenTakeButton(key, npc._config.cost, npc.data.T_dljq[key])
        local desc = GUI:Text_Create(node, "desc",500 + 160,120 + 133, 30, "#00FB00", npc._config.max_num - npc.data.T_dljq[key])
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        -- GUI:Text_enableOutline(desc, "#F03022", 2)



        if npc.data.T_dljq[key] < npc._config.max_num then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], showFirstOpenTake and "res/custom/all_story_mission/2/btn_take.png" or "res/custom/all_story_mission/3/btn_630.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                if showFirstOpenTake then
                    NPC_UI_HELPER.handleFirstOpenTakeButton(npc._window)
                    return
                end
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        else
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
