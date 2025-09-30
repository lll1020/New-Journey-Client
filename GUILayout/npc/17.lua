--兑换面板
--npc名称：
--npc功能：
local npc = {}

npc._config = {}

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)

        GUI:Image_Create(node, "duihuan_wz1", 410.00, 135.00, "res/wy/public/duihuan_wz.png")
        GUI:Image_Create(node, "duihuan_wz2", 410.00, 80.00, "res/wy/public/duihuan_wz.png")
        GUI:Text_Create(node, "hbdh1", 410.00 + 160, 5+ 135.00, 20, "#ffffff", (10-npc.data.hbdh1).."次")
        GUI:Text_Create(node, "hbdh2", 410.00 + 160, 5+ 80.00, 20, "#ffffff", (10-npc.data.hbdh2).."次")
        local Button1 = GUI:Button_Create(node, "Button1", 470 + 200, 30+ 150 - 12, "res/wy/public/duihuan_an.png")
        local Button2 = GUI:Button_Create(node, "Button2", 470 + 200, 30+ 80, "res/wy/public/duihuan_an.png")
        GUI:addOnClickEvent(Button1, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        GUI:addOnClickEvent(Button2, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)

        local Button3 = GUI:Button_Create(node, "Button3", 325, 30+ 150 - 12, "res/wy/public/duihuan_an.png")
        local Button4 = GUI:Button_Create(node, "Button4", 325, 30+ 80, "res/wy/public/duihuan_an.png")
        GUI:addOnClickEvent(Button3, function()
            SL:SendLuaNetMsg(100, npcid, 3, 0, "")
        end)
        GUI:addOnClickEvent(Button4, function()
            SL:SendLuaNetMsg(100, npcid, 4, 0, "")
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
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/duihuan.png')
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