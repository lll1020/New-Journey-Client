local npc = {}

npc._config = teshudata["npc_678"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/678/bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_678"
local btn_pos = {600, 140}
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
    local function xjm_678()
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_678_xjm",
            background = {skin = "res/custom/all_story_mission/4/678/bg/1.png"},
            closeButton = {x = 200 + 178 + 390, y = 10 + 422,},
        })
        local bg = npc.xjm_window.bg
        local xjm_node = npc.xjm_window.node
        npc.idx = npc.idx or 1
        for i = 1,8 do
            local xButton = GUI:Button_Create(xjm_node, "xButton"..i, 50 + (i-1)*90, 480, "res/custom/all_story_mission/4/678/list/"..(npc.idx == i and "l" or "n").."/"..i..".png")
            GUI:addOnClickEvent(xButton, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(xjm_node)["xButton"..npc.idx], "res/custom/all_story_mission/4/678/list/n/"..npc.idx..".png")
                npc.idx = i
                GUI:Button_loadTextureNormal(GUI:ui_delegate(xjm_node)["xButton"..npc.idx], "res/custom/all_story_mission/4/678/list/l/"..npc.idx..".png")
                GUI:Image_loadTexture(bg, "res/custom/all_story_mission/4/678/bg/"..npc.idx..".png")
                GUI:removeChildByName(xjm_node, "Button")
                if not npc.data.T_dljq[key.."_"..npc.idx] then
                    local Button= GUI:Button_Create(xjm_node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/678/btn_1.png")
                    GUI:setAnchorPoint(Button, 0.5, 0.5)
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, npcid, 2, npc.idx, "")
                    end)
                else
                    GUI:Image_Create(xjm_node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
                end
            end)
        end
        if not npc.data.T_dljq[key.."_"..npc.idx] then
            local Button= GUI:Button_Create(xjm_node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/678/btn_1.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, npc.idx, "")
            end)
        else
            GUI:Image_Create(xjm_node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end
    end

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0

        local ch_kuang = GUI:Image_Create(node, "ch_kuang",  185 + 202 + 26, 110, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))
        if npc.data.T_dljq[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then
            
            local count = 0
            for i=1,8 do
                if npc.data.T_dljq[key.."_"..i] and npc.data.T_dljq[key.."_"..i] == 1 then
                    count = count + 1
                end
            end
            if count >= 8 then
                local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 3, 0, "")
                end)
            else
                local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/678/btn_2.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    xjm_678()
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
        npc.data.T_dljq[key] = p3
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.data.T_dljq[key.."_"..p3] = 1
        UI_updata(npc.node)
        xjm_678()
    end
end

return npc
