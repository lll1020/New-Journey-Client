local npc = {}

npc._config = teshudata["npc_1002"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/shape/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/shape/title.png"},
}

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
    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        GUI:Image_Create(Label_node, "wz1", 600, 20, "res/custom/one_city/shape/wz1.png")
        if idx == 1 then
            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (216 * math.ceil(#npc._config.details.sz/3)))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (216 * math.ceil(#npc._config.details.sz/3)))
            for k,v in ipairs(npc._config.details.sz) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/one_city/shape/kuang1.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",166/2, 185, 18, "#FF0000", v.name)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)
                GUI:Effect_Create(kuang, "rw", 60, 60, 4, v.shape, 0, 0, 3, 1)
                if npc.data.T_data.dqzb == k then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "xz", 166/2, 30, "res/custom/one_city/shape/bz2.png")
                    , 0.5, 0.5)
                elseif npc.data.T_data.yjs[""..k] and npc.data.T_data.yjs[""..k] == 1 then
                    local btn = GUI:Button_Create(kuang, "btn", 166/2, 30, "res/custom/one_city/shape/btn.png")
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                    GUI:addOnClickEvent(btn, function()
                        SL:SendLuaNetMsg(100, npcid, 1, k, "")
                    end)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "wjs", 166/2, 30, "res/custom/one_city/shape/bz1.png")
                    , 0.5, 0.5)
                end
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=0, y=0}})
            
        elseif idx == 2 then
            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (216 * math.ceil(#npc._config.details.ch/2)))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (216 * math.ceil(#npc._config.details.ch/2)))
            for k,v in ipairs(npc._config.details.ch) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/one_city/shape/kuang2.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",256/2, 185, 18, "#FF0000", v.name)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)
                GUI:Effect_Create(kuang, "rw", 120, 80, 0, v.sEffect, 0, 0, 3, 1)
                if SL:GetMetaValue("ACTIVATE_TITLE") == SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name) then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "xz", 256/2, 30, "res/custom/one_city/shape/bz2.png")
                    , 0.5, 0.5)
                elseif SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name)) then
                    local btn = GUI:Button_Create(kuang, "btn", 256/2, 30, "res/custom/one_city/shape/btn.png")
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                    GUI:addOnClickEvent(btn, function()
                        SL:ResquestActivateTitle(SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name))
                        GUI:Button_loadTextures(btn, "res/custom/one_city/shape/bz2.png")
                        GUI:Button_setBright(btn, true)
                    end)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "wjs", 256/2, 30, "res/custom/one_city/shape/bz1.png")
                    , 0.5, 0.5)
                end     

            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 2,gap = {x=0, y=0}})
            
        end
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = 1
        for i = 1, 2 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/one_city/shape/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/shape/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/shape/list/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.dqzb = npc.data.T_data.dqzb or 0
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.dqzb = npc.data.T_data.dqzb or 0
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        UI_updata(npc.node)
    end
end

return npc