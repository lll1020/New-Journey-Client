local npc = {}

npc._config = teshudata["npc_633"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/633_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_633"
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

        local jl = ItemNumByTable_img_new(npc._config.jl, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 330 + 44 , 128)

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq[key.."_num"] = (npc.data.T_dljq and npc.data.T_dljq[key.."_num"]) and npc.data.T_dljq[key.."_num"] or 0
        local showFirstOpenTake = NPC_UI_HELPER.shouldShowFirstOpenTakeButton(key, npc._config.cost, npc.data.T_dljq[key.."_num"])

        local desc = GUI:Text_Create(node, "desc",500,150, 25, "#808080", "当前剩余挖宝次数："..npc._config.max_num - npc.data.T_dljq[key.."_num"])
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)



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
        UI_updata(npc.node)
    end
end

return npc

