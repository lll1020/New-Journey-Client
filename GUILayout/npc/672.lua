local npc = {}

npc._config = teshudata["npc_672"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/672_bg.png"},
    closeButton = {x = 747, y = 420},
}
local key = "npc_672"
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
    local function xjm_UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        -- local xjm_count = SL:GetItemNumById("修罗道令牌") + (npc.data.T_dljq["xjm_count"] or 0)
        -- local xjm = ItemNumByTable_img_new({{"修罗道令牌", xjm_count}}, nil,GUI:Node_Create(node, "xjm", 0, 0))
        -- GUI:setPosition(xjm, 178, 135)
        local desc = GUI:Text_Create(node, "desc",300 + 358 - 175,220 - 68 + 137, 20, "#FF0000", npc._config.details[npc.idx].wz)
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#150800", 1)
        if npc.data.T_dljq[key.."_"..npc.idx] and npc.data.T_dljq[key.."_"..npc.idx] >= 2 then
            -- GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        else
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/672_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, npc.idx, "")
            end)
        end

        
    end

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.idx = npc.idx or 1
        npc.xjm = GUI:Node_Create(node, "xjm", 0, 0)

        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240 + 320 - 410 + 235 - 191 + 230 + 245, 105, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))


        local center_x, center_y = 235, 280
        local radius = 150
        local step = (2 * math.pi) / 6
        local start_angle = -math.pi / 2
        for i = 1, 6 do
            local angle = start_angle + (i - 1) * step
            local x = math.floor(center_x + radius * math.cos(angle) + 0.5)
            local y = math.floor(center_y + radius * math.sin(angle) + 0.5)
            local Btn= GUI:Button_Create(node, "node"..i, x, y, "res/custom/all_story_mission/4/672_1/"..i..".png")
            if npc.idx == i then
                GUI:setAnchorPoint(GUI:Image_Create(Btn, "kuang", 129/2, 122/2, "res/custom/all_story_mission/4/672_1/kuang.png"), 0.5, 0.5)
            end
            GUI:setAnchorPoint(Btn, 0.5, 0.5)
            GUI:addOnClickEvent(Btn, function()
                GUI:removeChildByName(GUI:ui_delegate(node)["node"..npc.idx],"kuang")
                npc.idx = i
                GUI:setAnchorPoint(GUI:Image_Create(Btn, "kuang", 129/2, 122/2, "res/custom/all_story_mission/4/672_1/kuang.png"), 0.5, 0.5)
                xjm_UI_updata(npc.xjm)
            end)
            if npc.data.T_dljq[key.."_"..i] and npc.data.T_dljq[key.."_"..i] >= 2 then
                GUI:setAnchorPoint(GUI:Image_Create(Btn, "wc", 129/2, 122/2, "res/custom/all_story_mission/4/672_1/wc.png"), 0.5, 0.5)
            end
        end
        xjm_UI_updata(npc.xjm)


        if npc.data.T_dljq[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then
            local count = 0
            for i=1,6 do
                if npc.data.T_dljq[key.."_"..i] and npc.data.T_dljq[key.."_"..i] >= 2 then
                    count = count + 1
                end
            end
            if count >= 6 then
                local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 3, 0, "")
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
        npc.data.T_dljq[key.."_"..p3] = 2
        UI_updata(npc.node)
    end
end

return npc

