local npc = {}

npc._config = teshudata["npc_11"]


local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/cuiti/bg.png", eff = true},
    -- title = {x = 56, y = 464, skin = "res/custom/one_city/cuiti/title.png"},
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

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >每次提升的概率为50%，成功加一级失败不减</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)


        -- local cllist = GUI:ListView_Create(node, "cllist", 200, 70, 500, 300, 1)
        -- GUI:ListView_setItemsMargin(cllist, 3)
        -- for v,k in ipairs(npc._config.config) do
        --     local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/wy/public/jdtk_1.png')
        --     GUI:setContentSize(l, 500, 50)

        -- end






        -- cost_show = ItemNumByTable_img(npc._config.max_cost, nil,GUI:Node_Create(node, "cost_show2", 0, 0))
        -- GUI:setPosition(cost_show, 750, 175)


        
        local function GUI_createLabel(label_node, idx)
            GUI:removeAllChildren(label_node)
            local k = npc._config.config[idx]

            GUI:RichText_Create(label_node, "text_name", 20 + 476, 10 + 272,
                "<font color='#FFFFFF' size='18' >"..k.attr_desc.." + "..(npc.data.dj_data[""..idx] or 0).."%</font>"..
                SetCompletionProgress((npc.data.dj_data[""..idx] or 0), npc._config.max_level)
            , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            if (npc.data.dj_data[""..idx] or 0) >= npc._config.max_level then
                 GUI:Text_setFontName(GUI:Text_Create(label_node, "tip_max",500,150, 30, "#FF0000", "已达最高等级")
                , "fonts/500.ttf")
                return
            end

            local cost_show = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(label_node, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 750 - 250, 350 - 200)

            
            local Button= GUI:Button_Create(label_node, "Button", 490, 70, "res/custom/one_city/cuiti/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..idx..'}')
            end)
        end
        local kuang = GUI:Image_Create(node, "kuang2", 320, 15, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", 250, -50, 170, 440, 1)
        GUI:ListView_setClippingEnabled(npc.cbl_list, false)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 5)
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title)) then
            
        else
            local Button= GUI:Button_Create(node, "Button_all", 480, 20.00, "res/custom/one_city/cuiti/btn_all.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        end
        


        for i = 1, 5 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/one_city/cuiti/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:RichText_Create(cbl_item, "text_name", 100,10,
                SetCompletionProgress((npc.data.dj_data[""..i] or 0), npc._config.max_level)
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            
            GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "ydx", 10, 25, "res/custom/one_city/cuiti/ydx/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            , 1, 1)

            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/cuiti/list/n/"..npc.titles_sign..".png")
                GUI:Image_loadTexture(GUI:ui_delegate(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign])["ydx"], "res/custom/one_city/cuiti/ydx/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/cuiti/list/l/"..npc.titles_sign..".png")
                GUI:Image_loadTexture(GUI:ui_delegate(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign])["ydx"], "res/custom/one_city/cuiti/ydx/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label, npc.titles_sign)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.titles_sign = 1
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc