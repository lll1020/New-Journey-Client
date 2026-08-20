local npc = {}

npc._config = teshudata["npc_671"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/671_bg.png"},
    closeButton = {x = 747, y = 450},
}
local key = "npc_671"
local btn_pos = {650, 70}
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
        GUI:setPosition(jl, 178 + 250, 135)


        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq["npc_671_token"] = (npc.data.T_dljq and npc.data.T_dljq["npc_671_token"]) and npc.data.T_dljq["npc_671_token"] or 0
        npc.data.T_dljq["npc_671_lv"] = math.min(npc.data.T_dljq["npc_671_token"] or 0, 18) + 1
        npc.data.T_dljq["npc_671_cur"] = 0

        local list = GUI:ListView_Create(node, "list", 120, 80, 600, 300 + 86, 1)
        GUI:ListView_setBounceEnabled(list, true)
        for i = 1, 18 do
            local item_bg = GUI:Image_Create(list, "item_bg"..i, 0, 0, "res/custom/all_story_mission/4/671_1/"..i..".png")
            if npc.data.T_dljq["npc_671_lv"] > i then
                GUI:Text_Create(item_bg, "item_text", 120, 0, 17, "#00FB00", "已完成")
            elseif npc.data.T_dljq["npc_671_lv"] == i then
                GUI:Text_Create(item_bg, "item_text", 120, 0, 17, "#44DDFF", "进行中")
            else
                GUI:Text_Create(item_bg, "item_text", 120, 0, 17, "#FF0000", "未开启")
            end
        end

        local desc = GUI:Text_Create(node, "desc",300 + 358,220 - 68, 20, "#808080", (npc.data.T_dljq["npc_671_token"] or 0).."/18 个信物")
        GUI:Text_setFontName(desc, "fonts/501.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)
        



    
        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then
            if npc.data.T_dljq["npc_671_token"] == 18 then
                local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 2, 0, "")
                end)
            else
                local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/an_tiaozhan.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                end)
                -- GUI:Button_setTitleText(Button, "前往地图")
                -- GUI:Button_setTitleFontSize(Button, 16)
                -- GUI:Button_setTitleColor(Button, "#F4E7B5")
                -- GUI:Button_titleEnableOutline(Button, "#000000", 2)
            end
            
            
            Button= GUI:Button_Create(node, "Button1", btn_pos[1] - 250, btn_pos[2], "res/custom/all_story_mission/4/671_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 3, 0, "")
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
