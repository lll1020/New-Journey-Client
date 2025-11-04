--npc功能：
local npc = {}

npc._config = teshudata["npc_22"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染
        local titles = {"灵根装配", "灵根升级",}
        GUI:removeAllChildren(node)


        --- 自新增移动类型 来自/去达
        local function mainfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 2, npc.current_move_node, "")
        end

        local function otherfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 3, npc.current_move_node, "")
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



        function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            local tt = GUI:Text_Create(Label_node, "tt", 1000/2, 500, 30, "#00FF00", titles[idx])
            GUI:setAnchorPoint(tt, 0.5, 0.5)


            if idx == 1 then

                npc.current_move_node = 0

                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(Label_node, "kuang"..v, 150 + (v-1)%5*120, 300 - math.floor((v-1)/5)*120, "res/wy/public/70_70_k.png")

                    local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").fromToEvent, {beginMoveCB = function(move_node)
                        npc.current_move_node = v
                    end})
                    GUI:setAnchorPoint(moveWidget, 0.5, 0.5)

                    local showItem = GUI:Text_Create(moveWidget, "item"..v, 35, 35, 20, "#FFFFFF", k.name)
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Text_Create(kuang, "level"..v, 0, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and (npc.data.T_data.level[""..v].."级") or "未激活")
                end

                --主灵根
                GUI:Text_Create(Label_node, "item_main", 200, 450, 20, "#FFFFFF", "当前装配主灵根")
                GUI:Text_Create(Label_node, "item_other", 500, 450, 20, "#FFFFFF", "当前装配副灵根")


                local kuang = GUI:Image_Create(Label_node, "item_main_kuang", 350, 400, "res/wy/public/70_70_k.png")
                local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").maintoFromEvent,
                        {beginMoveCB = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                local showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                GUI:setAnchorPoint(showItem, 0.5, 0.5)

                kuang = GUI:Image_Create(Label_node, "item_other_kuang", 650, 400, "res/wy/public/70_70_k.png")
                moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").othertoFromEvent,
                        {beginMoveCB = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                GUI:setAnchorPoint(showItem, 0.5, 0.5)


                npc.out_moveWidget = GUI:MoveWidget_Create(Label_node, "out_moveWidget", 800, 350, 100, 200, SL:GetMetaValue("ITEMFROMUI_ENUM").out,{})
                GUI:setContentSize(GUI:Image_Create(npc.out_moveWidget, "kuang", 0, 0, "res/wy/public/500-300.png")
                , 100, 200)
                GUI:Text_Create(npc.out_moveWidget, "item_main", 0, 0, 30, "#FFFFFF", "卸下")

                GUI:setVisible(npc.out_moveWidget, false)
            elseif idx == 2 then
                --local Button= GUI:Button_Create(Label_node, "Button1", 750, 150.00, "res/public/1900000660.png")
                --GUI:Button_setTitleText(Button, "抽取一个低级灵根")
                --GUI:Button_setTitleFontSize(Button, 14)
                --
                --GUI:addOnClickEvent(Button, function()
                --    SL:SendLuaNetMsg(100, npcid, 1, 0, '')
                --end)

                npc.current_idx = npc.current_idx or 0

                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(Label_node, "kuang"..v, 150 + (v-1)%5*120, 300 - math.floor((v-1)/5)*120, "res/wy/public/70_70_k.png")
                    local showItem = GUI:Text_Create(kuang, "item"..v, 35, 35, 20, "#FFFFFF", k.name)
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Text_Create(kuang, "level"..v, 0, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and (npc.data.T_data.level[""..v].."级") or "未激活")

                    GUI:setTouchEnabled(kuang, true)
                    GUI:addOnClickEvent(kuang, function()
                        npc.current_idx = v
                        GUI_createLabel(npc.Label,npc.titles_sign)
                    end)
                end

                --主灵根
                GUI:Text_Create(Label_node, "item_main", 200, 450, 20, "#FFFFFF", "当前装配主灵根")
                GUI:Text_Create(Label_node, "item_other", 500, 450, 20, "#FFFFFF", "当前装配副灵根")


                local kuang = GUI:Image_Create(Label_node, "item_main_kuang", 350, 400, "res/wy/public/70_70_k.png")
                local showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                GUI:setAnchorPoint(showItem, 0.5, 0.5)
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.main or 0
                    GUI_createLabel(npc.Label,npc.titles_sign)
                end)


                kuang = GUI:Image_Create(Label_node, "item_other_kuang", 650, 400, "res/wy/public/70_70_k.png")
                showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                GUI:setAnchorPoint(showItem, 0.5, 0.5)
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.other or 0
                    GUI_createLabel(npc.Label,npc.titles_sign)
                end)

                if npc.current_idx and npc.current_idx > 0 then
                    local current_kuang = GUI:Image_Create(Label_node, "kuang", 720, 80, "res/wy/public/500-300.png")
                    GUI:setContentSize(current_kuang, 250, 300)
                    GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "name", 250/2, 280, 20, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
                    , 0.5, 0.5)

                    GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "main_eff", 250/2, 250, 20, "#FFFFFF", "主灵根效果")
                    , 0.5, 0.5)
                    GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "other_eff", 250/2, 150, 20, "#FFFFFF", "副灵根效果")
                    , 0.5, 0.5)



                    if npc.data.T_data.level and npc.data.T_data.level[""..npc.current_idx] and npc.data.T_data.level[""..npc.current_idx] >= 0 then
                        GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_wz", 250/2, 100, 20, "#FFFFFF", "强化")
                        , 0.5, 0.5)
                        GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_num", 250/2, 80, 20, "#FFFFFF", npc.data.T_data.level[""..npc.current_idx].."/"..npc._config.main_updata.max_level)
                        , 0.5, 0.5)

                        local Button= GUI:Button_Create(current_kuang, "Button", 250/2, 10, "res/public/1900000660.png")
                        GUI:Button_setTitleText(Button, "升级")
                        GUI:setAnchorPoint(Button, 0.5, 0)
                        GUI:Button_setTitleFontSize(Button, 14)
                        GUI:addOnClickEvent(Button, function()
                            SL:SendLuaNetMsg(100, npcid, 5, npc.current_idx, "")
                        end)
                    else
                        GUI:setAnchorPoint(GUI:Text_Create(current_kuang, "up_wz", 250/2, 100, 20, "#FFFFFF", "未激活")
                        , 0.5, 0.5)
                    end





                end
            end
        end

        npc.titles_sign = 1
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        for i = 1, #titles do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 100+(i-1)*120, 50, "res/public/1900000660.png")
            GUI:Button_setTitleText(cbl_item, titles[i])
            GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:addOnClickEvent(cbl_item, function()
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        local parent = GUI:GetWindow(nil, "npc_" .. npcid)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, npcid, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc