local npc = {}

npc._config = teshudata["npc_629"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/629_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_629"
local btn_pos = {462 + 290 - 428, 85}
local cost_pos = {507 - 240 + 130, 202 + 40 - 27}

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

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost[1], nil,GUI:Node_Create(node, "cost1", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
            GUI:Text_Create(node, "or",cost_pos[1] + 95, cost_pos[2] + 10, 20, "#00FB00", "或者")
            cost = checkItemNumByTable_img_kuang(npc._config.cost[2], nil,GUI:Node_Create(node, "cost2", 0, 0))
            GUI:setPosition(cost, cost_pos[1] + 120, cost_pos[2])
        end
        local desc = GUI:Text_Create(node, "desc1",100,70, 20, "#ffffff", "解锁船长室")
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)

        if npc.data.T_dljq[key.."_a"] and npc.data.T_dljq[key.."_a"] == 1 then
            local Button = GUI:Image_Create(node, "Button_chat_1", btn_pos[1], btn_pos[2], "res/wy/public/npc_58_wz2.png")
            GUI:setAnchorPoint(Button, 1, 0.5)
        else
            local Button= GUI:Button_Create(node, "Button_chat_1", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/3/btn_629.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 1, "")
            end)
        end

        desc = GUI:Text_Create(node, "desc2",300 + 170,70, 20, "#ffffff", "解锁水手室")
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)

        if npc.data.T_dljq[key.."_b"] and npc.data.T_dljq[key.."_b"] == 1 then
            local Button = GUI:Image_Create(node, "Button2", btn_pos[1] + 370, btn_pos[2], "res/wy/public/npc_58_wz2.png")
            GUI:setAnchorPoint(Button, 1, 0.5)
        else
            local Button= GUI:Button_Create(node, "Button2", btn_pos[1] + 370, btn_pos[2], "res/custom/all_story_mission/3/btn_629.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 2, "")
            end)
        end

        

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc
