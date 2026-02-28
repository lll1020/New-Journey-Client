local npc = {}

npc._config = teshudata["npc_14"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/14_bg.png"},
    closeButton = {x = 920, y = 460},

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

        local cllist = GUI:ListView_Create(node, "cllist", 280, 70,645, 380, 2)
        GUI:ListView_setItemsMargin(cllist, 3)
        local hasAnyCanDrink = false
        for v,k in ipairs(npc._config.config) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/custom/one_city/14_itme_'..v..'.png')
           
            GUI:setAnchorPoint(GUI:RichText_Create(l, "text_attr", 106, 160,
                            "<font color='#FF00FF' size='18' >"..k.attr_desc.." + "..(npc.data.dj_data[""..v] or 0).."</font>"
            , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0.5, 0.5)
            
            GUI:setAnchorPoint(GUI:RichText_Create(l, "text_cs", 106, 20 + 68,
                            SetCompletionProgress((npc.data.dj_data[""..v] or 0), k.max_level)
            , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0.5, 0.5)

            local itemShow = GUI:ItemShow_Create(l, "item", 106, 270, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k.cost[1][1]), look = true, bgVisible = false })
            itemShow:setAnchorPoint(cc.p(0.5, 0.5))

            if (npc.data.dj_data[""..v] or 0) >= k.max_level then
                local tip_max = GUI:Text_Create(l, "tip_max",106, 50, 30, "#FF0000", "已达最高等级")
                GUI:Text_setFontName(tip_max, "fonts/500.ttf")
                GUI:setAnchorPoint(tip_max, 0.5, 0.5)
            else
                local Button= GUI:Button_Create(l, "Button", 106, 40, 'res/custom/one_city/btn_2.png')
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                if checkItemNum(k.cost) then
                    NPC_UI_HELPER.redpoint_create(Button)
                    hasAnyCanDrink = true
                end
                GUI:addOnTouchEvent(Button, function(sender, type)
                    -- 触发控件（sender）：控件本身
                    -- 事件类型（type）：触摸阶段 0-3
                    if type == SLDefine.TouchEventType.began then           -- 0 触摸开始
                        if not sender._clicking then
                            sender._clicking = true
                            SL:scheduleOnce(sender, function()
                                GUI:schedule(Button, function()
                                    if sender._clicking then
                                        SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
                                    else
                                        GUI:unSchedule(Button)
                                    end
                                end,0.1)
                            end, 0.5)
                        end
                    elseif type == SLDefine.TouchEventType.moved then       -- 1 触摸移动


                    elseif type == SLDefine.TouchEventType.ended or type == SLDefine.TouchEventType.canceled then       -- 2 触摸结束 3 触摸取消
                        if sender._clicking then
                            sender._clicking = false
                            SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
                        end
                    end
                end)

            end

            
        end

        local EquipShow_16 = GUI:EquipShow_Create(
            node
        , "EquipShow_16", 180, 90, 16, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
        GUI:EquipShow_setAutoUpdate(EquipShow_16)
        GUI:setAnchorPoint(EquipShow_16, 0.5, 0.5)


        local Button= GUI:Button_Create(node, "Button", 310, 30, "res/wy/public/an_tongyong.png")
        local Button_wz = GUI:Text_Create(Button, "desc",116,52, 25, "#FFFBF0", "一键全部饮用")
        GUI:setAnchorPoint(Button_wz, 0.5, 0.5)
        GUI:Text_setFontName(Button_wz, "fonts/500.ttf")
        GUI:Text_enableOutline(Button_wz, "#CA352C", 2)

        GUI:setAnchorPoint(Button, 0.5, 0.5)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
        if hasAnyCanDrink then
            NPC_UI_HELPER.redpoint_create(Button)
        end

        local kuang = GUI:Image_Create(node, "kuang2", 720, 0, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        --UI_updata(npc.node)
        local cllist = GUI:ui_delegate(npc.node).cllist
        for v,k in ipairs(npc._config.config) do
            
            local l = GUI:ui_delegate(cllist)["img_bj_l_"..v]
            GUI:removeChildByName(l, "text_cs")
            GUI:removeChildByName(l, "text_attr")
            GUI:setAnchorPoint(GUI:RichText_Create(l, "text_cs", 106, 20 + 68,
                            SetCompletionProgress((npc.data.dj_data[""..v] or 0), k.max_level)
            , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0.5, 0.5)
            GUI:setAnchorPoint(GUI:RichText_Create(l, "text_attr", 106, 160,
                            "<font color='#FF00FF' size='18' >"..k.attr_desc.." + "..(npc.data.dj_data[""..v] or 0).."</font>"
            , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0.5, 0.5)
        end

    end
end

return npc
