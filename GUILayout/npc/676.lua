local npc = {}

npc._config = teshudata["npc_676"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/676_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_676"
local btn_pos = {400, 80}
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
        npc.data.T_dljq[key.."_cnt"] = (npc.data.T_dljq and npc.data.T_dljq[key.."_cnt"]) and npc.data.T_dljq[key.."_cnt"] or 0


        local desc = GUI:Text_Create(node, "desc",180 + 195,130 + 32, 25, "#808080", (npc.data.sg_data[key] or 0))
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)

        desc = GUI:Text_Create(node, "number",180 + 195 + 82,130 + 32 + 78, 30, "#808080", 5 - (npc.data.T_dljq[key.."_cnt"] or 0))
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)

        local jl_c = ItemNumByTable_img_new(npc._config.jl_c, nil,GUI:Node_Create(node, "jl_c", 0, 0))
        GUI:setPosition(jl_c, 550, 70)


        if npc.data.T_dljq[key] == 0 then --接取任务
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then --领取奖励
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/676_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then --已完成
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

