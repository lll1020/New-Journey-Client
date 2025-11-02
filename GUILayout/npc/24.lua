--npc名称：天书
--npc功能：
local npc = {}

npc._config = teshudata["npc_24"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染
        local titles = {"强化", "仙法", "往事"}
        GUI:removeAllChildren(node)


        function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            local tt = GUI:Text_Create(Label_node, "tt", 1000/2, 500, 30, "#00FF00", titles[idx])
            GUI:setAnchorPoint(tt, 0.5, 0.5)
            if idx == 1 then
                GUI:setAnchorPoint(
                        GUI:RichText_Create(Label_node, "desc", 200, 430,
                                "<font color='#00FF00' size='20' >当前天书等级："..(npc.data.T_data.level or 0).."</font>"
                        , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                , 0, 1)
                local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)
                if item then
                    local kuang = GUI:Image_Create(Label_node, "kuang", 200, 250, "res/wy/public/70_70_k.png")
                    UiTools.showItemData(kuang, item)

                    local Button= GUI:Button_Create(Label_node, "Button", 750, 100.00, "res/public/1900000660.png")
                    GUI:Button_setTitleText(Button, "升级")
                    GUI:Button_setTitleFontSize(Button, 14)

                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                    end)

                end
            elseif idx == 2 then
                local GUI_list = GUI:ListView_Create(Label_node, "GUI_list", 200, 100, 700, 270, 2)
                for i = 1, 10 do
                    local kuang = GUI:Image_Create(GUI_list, "kuang"..i, 0, 0, "res/wy/public/anniu_999_bj.png")
                    GUI:setContentSize(kuang, 150, 270)
                    npc.data.T_data.caowei = npc.data.T_data.caowei or {}
                    if npc.data.T_data.caowei[""..i] then
                        GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", npc._config.details[2].details[npc.data.T_data.caowei[""..i][1]][npc.data.T_data.caowei[""..i][2]].name)
                        , 0.5, 0.5)
                    else
                        GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", "暂未解锁")
                        , 0.5, 0.5)
                    end
                    local Button= GUI:Button_Create(kuang, "Button", 150/2, 50, "res/public/1900000660.png")
                    GUI:setAnchorPoint(Button, 0.5, 0.5)
                    GUI:Button_setTitleText(Button, "洗练")
                    GUI:Button_setTitleFontSize(Button, 14)

                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({caowei = i}))
                    end)

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
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc