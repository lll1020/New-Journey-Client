--npc功能：
local npc = {}

npc._config = teshudata["npc_22"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/linggen/bg.png", eff = false},
    closeButton = {x = 800, y = 440, skin = "res/wy/public/close_red_big.png"},

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
        local titles = {"灵根装配", "灵根升级",}
        GUI:removeAllChildren(node)


        --- 自新增移动类型 来自/去达
        local function mainfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 2, npc.current_move_node, "")
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
        end

        local function otherfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 3, npc.current_move_node, "")
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
        end

        --- 自新增移动类型 来自/去达
        local function maintoout(_, data)
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end

        local function othertoout(_, data)
            SL:SendLuaNetMsg(100, npcid, 3, 0, "")
        end



        GUI:AddMoveWidgetTypeEvent("fromToEvent", "maintoFromEvent", mainfromToEvent, nil)
        GUI:AddMoveWidgetTypeEvent("fromToEvent", "othertoFromEvent", otherfromToEvent, nil)

        GUI:AddMoveWidgetTypeEvent("maintoFromEvent", "out", maintoout, nil)
        GUI:AddMoveWidgetTypeEvent("othertoFromEvent", "out", othertoout, nil)



        function xjm_UI_updata(x_node) --小界面渲染
            
            local name = GUI:Text_Create(x_node, "name", 116, 222, 25, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
            GUI:setAnchorPoint(name, 0.5, 0.5)
            GUI:Text_setFontName(name, "fonts/501.ttf")
        

            local cost = GUI:RichText_Create(x_node, "cost", 120, 80,  checkItemNumByTable_only(
                npc._config.main_updata.details[npc.current_idx <= 5 and "low" or "up"][npc.data.T_data.level[""..npc.current_idx] + 1].cost
            ), 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(cost, 0.5, 0.5)


            local btn_upup = GUI:Button_Create(x_node, "btn_upup", 15, 10, "res/custom/linggen/btn_upup.png")
            GUI:addOnClickEvent(btn_upup, function()
                SL:SendLuaNetMsg(100, npcid, 5, npc.current_idx, "")
            end)
        
        end
        function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            -- local tt = GUI:Text_Create(Label_node, "tt", 1000/2, 500, 30, "#00FF00", titles[idx])
            -- GUI:setAnchorPoint(tt, 0.5, 0.5)


            if idx == 1 then
                local function xjm_updata()
                    local Label_node = npc.Label
                    if npc.current_idx and npc.current_idx > 0 then
                        if GUI:ui_delegate(Label_node).current_kuang then
                            GUI:removeAllChildren(GUI:ui_delegate(Label_node).current_kuang)
                        end
                        local current_kuang = GUI:ui_delegate(Label_node).current_kuang or GUI:Node_Create(Label_node, "current_kuang", 125, 0)

                        local name = GUI:Text_Create(current_kuang, "name", 30, 280, 25, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
                        GUI:Text_setFontName(name, "fonts/501.ttf")

                        -- local up_num = GUI:Text_Create(current_kuang, "up_num", 30, 250, 25, "#FFFFFF", "强化等级："..npc.data.T_data.level[""..npc.current_idx].."/"..npc._config.main_updata.max_level)
                    end
                end


                npc.current_move_node = 0

                GUI:Image_Create(Label_node, "wz_1", 760, 30, "res/custom/linggen/wz_3.png")
                GUI:Image_Create(Label_node, "wz_2", 155, 315, "res/custom/linggen/wz_1.png")

                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 400, 30, 435, 190, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))


                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/linggen/kuang.png")
                    

                    local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").fromToEvent, {
                        beginMoveCB = function(move_node)
                            npc.current_move_node = v
                            npc.current_idx = v
                            xjm_updata()
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, true)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, true)
                            GUI:setTouchEnabled(ScrollView, false)
                        end,
                        endMoveCB = function(move_node)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
                            GUI:setTouchEnabled(ScrollView, true)
                         end,
                        cancelMoveCB  = function(move_node)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
                            GUI:setTouchEnabled(ScrollView, true)
                        end})
                    GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                    local showItem = GUI:Image_Create(moveWidget, "item"..v, 84/2, 86/2, "res/custom/linggen/itme_"..v..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Text_Create(kuang, "level"..v, 70, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and ("lv."..npc.data.T_data.level[""..v]) or "未激活")


                    
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=40, y=10}})
                --主灵根


                -- local kuang = GUI:Image_Create(Label_node, "item_main_kuang", 430, 290, "res/wy/public/003.png")
                local kuang = GUI:Layout_Create(Label_node, "item_main_kuang", 430, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                local contentSize = kuang:getContentSize()
                local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", contentSize.width / 2, contentSize.height / 2, 125, 160, SL:GetMetaValue("ITEMFROMUI_ENUM").maintoFromEvent,
                        {beginMoveCB = function(move_node)
                            npc.current_idx = npc.data.T_data.main or 0
                            xjm_updata()
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                -- local showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                if npc.data.T_data.main then
                    local showItem = GUI:Image_Create(contentSize, "item", 125/2, 160/2, "res/custom/linggen/itme_"..npc.data.T_data.main..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                end

                kuang = GUI:Layout_Create(Label_node, "item_other_kuang", 603, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                contentSize = kuang:getContentSize()
                moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", contentSize.width / 2, contentSize.height / 2, 125, 160, SL:GetMetaValue("ITEMFROMUI_ENUM").othertoFromEvent,
                        {beginMoveCB = function(move_node)
                            npc.current_idx = npc.data.T_data.other or 0
                            xjm_updata()
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                -- showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                if npc.data.T_data.other then
                    local showItem = GUI:Image_Create(moveWidget, "item", 125/2, 160/2, "res/custom/linggen/itme_"..npc.data.T_data.other..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                end


                npc.out_moveWidget = GUI:MoveWidget_Create(Label_node, "out_moveWidget", 365, 30, 435, 190, SL:GetMetaValue("ITEMFROMUI_ENUM").out,{})
                GUI:setContentSize(GUI:Image_Create(npc.out_moveWidget, "kuang", 0, 0, "res/wy/public/500-300.png")
                , 435, 190)
                GUI:setAnchorPoint(npc.out_moveWidget, 0, 0)

                contentSize = npc.out_moveWidget:getContentSize()
                local xx = GUI:Text_Create(npc.out_moveWidget, "xx", contentSize.width / 2, contentSize.height / 2, 50, "#FFFFFF", "放入卸下")
                GUI:setAnchorPoint(xx, 0.5, 0.5)
                GUI:Text_setFontName(xx, "fonts/501.ttf")

                GUI:setVisible(npc.out_moveWidget, false)

                local eff = GUI:Image_Create(GUI:ui_delegate(Label_node).item_main_kuang, "eff", 125/2, 160/2, "res/wy/public/003.png")
                GUI:setContentSize(eff, 125, 160)
                GUI:setAnchorPoint(eff, 0.5, 0.5)
                GUI:runAction(eff, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionScaleTo(0.5, 1.1), GUI:ActionScaleTo(0.5, 1))))
                
                eff = GUI:Image_Create(GUI:ui_delegate(Label_node).item_other_kuang, "eff", 125/2, 160/2, "res/wy/public/003.png")
                GUI:setContentSize(eff, 125, 160)
                GUI:setAnchorPoint(eff, 0.5, 0.5)
                GUI:runAction(eff, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionScaleTo(0.5, 1.1), GUI:ActionScaleTo(0.5, 1))))

                GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)

            elseif idx == 2 then
                --local Button= GUI:Button_Create(Label_node, "Button1", 750, 150.00, "res/public/1900000660.png")
                --GUI:Button_setTitleText(Button, "抽取一个低级灵根")
                --GUI:Button_setTitleFontSize(Button, 14)
                --
                --GUI:addOnClickEvent(Button, function()
                --    SL:SendLuaNetMsg(100, npcid, 1, 0, '')
                --end)

                npc.current_idx = npc.current_idx or 0

                GUI:Image_Create(Label_node, "wz_3", 760, 30, "res/custom/linggen/wz_3.png")

                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 400, 30, 435, 190, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))

                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/linggen/kuang.png")
                    -- local showItem = GUI:Text_Create(kuang, "item"..v, 84/2, 86/2, 20, "#FFFFFF", k.name)
                    local showItem = GUI:Image_Create(kuang, "item"..v, 84/2, 86/2, "res/custom/linggen/itme_"..v..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Text_Create(kuang, "level"..v, 70, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and ("lv."..npc.data.T_data.level[""..v]) or "未激活")

                    GUI:setTouchEnabled(kuang, true)
                    GUI:addOnClickEvent(kuang, function()
                        npc.current_idx = v
                        GUI_createLabel(npc.Label,npc.titles_sign)
                    end)
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=40, y=10}})


                --主灵根

                GUI:Image_Create(Label_node, "wz_2", 155, 315, "res/custom/linggen/wz_2.png")


                local kuang = GUI:Layout_Create(Label_node, "item_main_kuang", 430, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                -- local showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                if npc.data.T_data.main then
                    local showItem = GUI:Image_Create(kuang, "item", 125/2, 160/2, "res/custom/linggen/itme_"..npc.data.T_data.main..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                end
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.main or 0
                    GUI_createLabel(npc.Label,npc.titles_sign)
                end)

                kuang = GUI:Layout_Create(Label_node, "item_other_kuang", 603, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                if npc.data.T_data.other then
                    local showItem = GUI:Image_Create(kuang, "item", 125/2, 160/2, "res/custom/linggen/itme_"..npc.data.T_data.other..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                end
                -- showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.other or 0
                    GUI_createLabel(npc.Label,npc.titles_sign)
                end)

                if npc.current_idx and npc.current_idx > 0 then
                    local current_kuang = GUI:Node_Create(Label_node, "current_kuang", 125, 0)
                    -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "name", 250/2, 280, 20, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
                    -- , 0.5, 0.5)

                    -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "main_eff", 250/2, 250, 20, "#FFFFFF", "主灵根效果")
                    -- , 0.5, 0.5)
                    -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "other_eff", 250/2, 150, 20, "#FFFFFF", "副灵根效果")
                    -- , 0.5, 0.5)
                    local name = GUI:Text_Create(current_kuang, "name", 30, 280, 25, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
                    GUI:Text_setFontName(name, "fonts/501.ttf")




                    if npc.data.T_data.level and npc.data.T_data.level[""..npc.current_idx] and npc.data.T_data.level[""..npc.current_idx] >= 0 then
                        local up_num = GUI:Text_Create(current_kuang, "up_num", 30, 250, 25, "#FFFFFF", "强化等级："..npc.data.T_data.level[""..npc.current_idx].."/"..npc._config.main_updata.max_level)

                        -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_wz", 250/2, 100, 20, "#FFFFFF", "强化")
                        -- , 0.5, 0.5)
                        -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_num", 250/2, 80, 20, "#FFFFFF", npc.data.T_data.level[""..npc.current_idx].."/"..npc._config.main_updata.max_level)
                        -- , 0.5, 0.5)

                        

                        local Button= GUI:Button_Create(current_kuang, "Button", 10, 10, "res/custom/linggen/btn_up.png")
                        GUI:addOnClickEvent(Button, function()
                            -- SL:SendLuaNetMsg(100, npcid, 5, npc.current_idx, "")
                            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                                windowName = "npc_anniu_22_xjm",
                                overlay = {skin = "res/custom/treasureBasin/x.png"},
                                background = {skin = "res/custom/linggen/x_bg.png"},
                                closeButton = {x = 209, y = 327, skin = "res/wy/public/close_red_big.png"},
                            })
                            npc.xjm_node = npc.xjm_window.node
                            xjm_UI_updata(npc.xjm_node)
                        end)
                    else
                        -- GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_wz", 10, 100, 20, "#FFFFFF", "未激活")
                        -- , 0.5, 0.5)
                    end
                end
            end
        end

        npc.titles_sign = 2
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        -- for i = 1, #titles do
        --     local cbl_item = GUI:Button_Create(node, "item" .. i, 100+(i-1)*120, 50, "res/public/1900000660.png")
        --     GUI:Button_setTitleText(cbl_item, titles[i])
        --     GUI:Button_setTitleFontSize(cbl_item, 14)
        --     GUI:addOnClickEvent(cbl_item, function()
        --         npc.titles_sign = i
        --         GUI_createLabel(npc.Label,i)
        --     end)
        -- end

        local btn_set = GUI:Button_Create(node, "btn_set", 105, 355, "res/custom/linggen/btn_set.png")
        GUI:addOnClickEvent(btn_set, function()
            if npc.titles_sign == 2 then
                GUI:Button_loadTextureNormal(btn_set, "res/custom/linggen/btn_save.png")
                npc.titles_sign = 1
                GUI_createLabel(npc.Label,1)
            else
                GUI:Button_loadTextureNormal(btn_set, "res/custom/linggen/btn_set.png")
                npc.titles_sign = 2
                GUI_createLabel(npc.Label,2)
            end
        end)


        GUI_createLabel(npc.Label,npc.titles_sign)
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc