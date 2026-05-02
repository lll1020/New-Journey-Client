local npc = {}

npc._config = teshudata["npc_669"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/669_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_669"
local btn_pos = {600, 150}
local cost_pos = {507 + 25 - 250, 202 + 35}

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
        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240 + 320 - 410 - 191 + 225, 119, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))
        if npc._config.cost then
            local cost = ItemNumByTable_img_new(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0

        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then
            
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/669_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
                    windowName = "npc_669_xjm",
                    background = {skin = "res/custom/all_story_mission/4/669_1/bg.png"},
                    closeButton = {x = 200 + 178, y = 10 + 422,},
                })
                local xjm_node = npc.xjm_window.node
                local idx = 0
                for i = 1,4 do
                    local xButton = GUI:Button_Create(xjm_node, "xButton"..i, 50, 320 - (i-1)*80, "res/custom/all_story_mission/4/669_1/n/"..i..".png")
                    GUI:addOnClickEvent(xButton, function()
                        if idx ~= 0 then
                            GUI:Button_loadTextureNormal(GUI:ui_delegate(xjm_node)["xButton"..idx], "res/custom/all_story_mission/4/669_1/n/"..idx..".png")
                        end
                        idx = i
                        GUI:Button_loadTextureNormal(xButton, "res/custom/all_story_mission/4/669_1/l/"..idx..".png")
                    end)
                end

                local btn= GUI:Button_Create(xjm_node, "Button", 417/2 + 20, 40, "res/custom/all_story_mission/4/669_1/btn.png")
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                GUI:addOnClickEvent(btn, function()
                    if idx == 0 then
                        SL:ShowSystemTips("请选择一个祝福！")
                        return
                    end
                    SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                end)
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
