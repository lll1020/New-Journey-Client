--npc名称：
--npc功能：
local npc = {}

npc._config = teshudata["npc_11"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >每次提升的概率为50%，成功加一级失败不减</font>"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)


        local cllist = GUI:ListView_Create(node, "cllist", 200, 70, 500, 300, 1)
        GUI:ListView_setItemsMargin(cllist, 3)
        for v,k in ipairs(npc._config.config) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/wy/public/jdtk_1.png')
            GUI:setContentSize(l, 500, 50)
            GUI:RichText_Create(l, "text_name", 20, 20,
                    "<font color='#00FF00' size='16' >"..k.name.."</font>"..
                            "<font color='#0000FF' size='18' >"..k.attr_desc.." + "..(npc.data.dj_data[""..v] or 0).."%</font>"..
                            SetCompletionProgress((npc.data.dj_data[""..v] or 0), npc._config.max_level)
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


            local Button= GUI:Button_Create(l, "Button", 350, 5, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "升级")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
            end)
        end

        local kuang = GUI:Image_Create(node, "kuang2", 750, 250, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))


        local cost_show = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost_show, 750, 350)

        cost_show = ItemNumByTable_img(npc._config.max_cost, nil,GUI:Node_Create(node, "cost_show2", 0, 0))
        GUI:setPosition(cost_show, 750, 175)

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "一键全满")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)

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
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/01.png')
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
        UI_updata(npc.node)
    end
end

return npc