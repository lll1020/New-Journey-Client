
local npc = {}

npc._config = {
    --{"地图名",x,y,限制fun,提示文字,所属大陆}
    [201] = {"山庄",0,0,nil,nil,1},
    [202] = {"幽谷",0,0,nil,nil,1},
    [203] = {"洞穴",0,0,nil,nil,1},
    [204] = {"古殿",0,0,nil,nil,1},

    [205] = {"隐藏地图二",100,100,nil,nil,2},
    [206] = {"野火帮",100,100,nil,nil,2},
    [207] = {"xx城郊",100,100,nil,nil,2},
    [208] = {"兵道古藏",100,100,nil,nil,2},
    [209] = {"夜魔洞",100,100,nil,nil,2},
    [210] = {"特殊秘境副本二",100,100,nil,nil,2},

    [211] = {"隐藏地图三",100,100,nil,nil,3},
    [212] = {"灰界",100,100,nil,nil,3},
    [213] = {"群星海",100,100,nil,nil,3},
    [214] = {"红尘城",100,100,nil,nil,3},
    [215] = {"无主深渊",100,100,nil,nil,3},
    [216] = {"草药谷",100,100,nil,nil,3},
    [217] = {"特殊秘境副本三",100,100,nil,nil,3},
}

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "进入地图")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        if npcid == 201 or npcid == 202 or npcid == 203 or npcid == 204 then
            Button= GUI:Button_Create(node, "Button1", 750, 200.00, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "进入地图深处")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 1, "")
            end)
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