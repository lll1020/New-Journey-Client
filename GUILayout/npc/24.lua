--npc名称：天书
--npc功能：
local npc = {}

npc._config = teshudata["npc_24"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染
        local titles = {"仙法", "强化", "天赋", "觉醒", "往事"}
        GUI:removeAllChildren(node)


        local function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            local tt = GUI:Text_Create(Label_node, "tt", 1000/2, 500, 30, "#00FF00", titles[idx])
            GUI:setAnchorPoint(tt, 0.5, 0.5)
            if idx == 1 then


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
        UI_updata(npc.node)
    end
end

return npc