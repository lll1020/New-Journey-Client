-- 跨服传送

local npc = {}

function npc.main(npcid, link, msg, data)
    if link == 0 then
        npc.sj = SL:JsonDecode(data, false)
        local parent = GUI:GetWindow(nil, "npc_" .. npcid)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bj = GUI:Frames_Create(parent, "bg", 0, 0, "res/wy/eff/city/npc_18_bj_", ".png", 1, 15, {speed = 50, count = 15, loop = -1})
        GUI:setAnchorPoint(npc.bj, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bj, true)

        GUI:setAnchorPoint(GUI:Image_Create(npc.bj, "tt", 500, 490, "res/wy/public/npc_18_tt.png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(npc.bj, "wz", 500, 180, "res/wy/public/npc_18_wz.png"), 0.5, 0.5)

        npc.Button = GUI:Button_Create(npc.bj, "Button", 500, 100, "res/wy/public/npc_18_an.png")
        GUI:setAnchorPoint(npc.Button, 0.5, 0.5)
        GUI:addOnClickEvent(npc.Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        local close = GUI:Button_Create(npc.bj, "close", 828, 475, "res/wy/public/999.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
    end
end

return npc
