local npc = {}

npc._config = teshudata["npc_648"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/648_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_648"
local btn_pos = {600, 80}
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

        npc.data.jq_data[key] = (npc.data.jq_data and npc.data.jq_data[key]) and npc.data.jq_data[key] or 0

        local desc = GUI:Text_Create(node, "desc1",160 + 158,118, 20, "#808080", npc._config.attr_wz)
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#FFFF00", 2)

        

        if npc.data.jq_data[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.jq_data[key] == 1 then
            local desc = GUI:Text_Create(node, "desc",360 + 73,220, 18, "#F4D179", 
                "当前击杀：\n"..((npc.data.sg_data[key.."_a"] or 0) > 0 and "已讨伐" or "未击败").."\n"..((npc.data.sg_data[key.."_b"] or 0) > 0 and "已讨伐" or "未击败").."\n"..((npc.data.sg_data[key.."_c"] or 0) > 0 and "已讨伐" or "未击败"))
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#FFFF00", 2)

            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/3/btn_key.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        elseif npc.data.jq_data[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.jq_data[key] = p3
        UI_updata(npc.node)
    end
end

return npc
