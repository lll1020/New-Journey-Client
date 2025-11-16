--npc名称：
--npc功能：
local npc = {}

npc._config = teshudata["npc_26"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)
        for v,k in ipairs(npc._config.details) do
            local kuang = GUI:Image_Create(node, "kuang"..v, 200 + (v-1)*100, 250, "res/wy/public/70_70_k.png")
            UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)))
            if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)) then
                GUI:Text_Create(kuang, "Text_Money5", 56.00, 24.00, 14, "#ffffff", "当前")
            end
        end

        local cost = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        GUI:setPosition(cost, 800, 200)


        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "占卜")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
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
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

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
        UI_updata(npc.node)
    end
end

return npc