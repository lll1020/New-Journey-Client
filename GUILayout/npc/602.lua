
local npc = {}

npc._config = teshudata["npc_602"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)
        local GUI_list = GUI:ListView_Create(node, "GUI_list", 200, 100, 900, 270, 2)
        for i = 1, 5 do
            local kuang = GUI:Image_Create(GUI_list, "kuang"..i, 0, 0, "res/wy/public/anniu_999_bj.png")
            GUI:setContentSize(kuang, 150, 270)

            GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", npc._config.mob[i])
            , 0.5, 0.5)

            local Button= GUI:Button_Create(kuang, "Button", 150/2, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:Button_setTitleFontSize(Button, 14)
            npc.data.T_dljq["npc_602"] = npc.data.T_dljq["npc_602"] or {}
            if npc.data.T_dljq["npc_602"][""..i] and npc.data.T_dljq["npc_602"][""..i] == 1 then
                GUI:Button_setTitleText(Button, "激活")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 2, i, "")
                end)
            else
                GUI:Button_setTitleText(Button, "挑战")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, i, "")
                end)
            end



        end

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
    end
end

return npc