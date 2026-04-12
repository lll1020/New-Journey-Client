local npc = {}

npc._config = teshudata["npc_623"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/623_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_623"
local btn_pos = {462 + 130, 70 + 91}

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

        if npc.data.T_dljq[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then
            local desc = GUI:Text_Create(node, "desc",300,220, 20, "#FFFFFF", "当前击杀："..(npc.data.sg_data[key] or 0).."/"..(npc._config.num or 0))
            GUI:Text_setFontName(desc, "fonts/font4.ttf")
            GUI:Text_enableOutline(desc, "#CA352C", 2)
            
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/3/btn_key.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/an_mx.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
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
