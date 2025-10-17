--npc名称：
--npc功能：
local npc = {}

npc._config = teshudata["npc_28"]

function npc.main(npcid, p2, p3, msgData)

    local function UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 200,50, 500, 400)



        local idx = 1
        for k,v in pairs(npc._config.where) do
            local EquipShow = GUI:EquipShow_Create(
                    GUI:Image_Create(dbLayout, "where_"..idx, 135.00, 80.00, "res/wy/public/70_70_k.png")
            , "EquipShow", 35, 35, k, false, {noMouseTips = true, look = false, movable = false, bgVisible = false, doubleTakeOff = false})
            GUI:EquipShow_setAutoUpdate(EquipShow)
            GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            GUI:Text_Create(EquipShow, "wz1", 56.00, 40.00, 14, "#ffffff", v[1])
            GUI:Text_Create(EquipShow, "wz2", 56.00, 20.00, 14, "#ffffff", "当前强化："..npc.data[""..k])
            GUI:setTouchEnabled(EquipShow, true)
            GUI:addOnClickEvent(EquipShow, function()
                if npc.kuang then
                    GUI:removeFromParent(npc.kuang)
                    npc.kuang = GUI:Image_Create(EquipShow, "kuang", -50, 15, "res/wy/public/new_jiantou.png")
                    npc.idx = k
                end
            end)
            if idx == 1 then
                npc.kuang = GUI:Image_Create(EquipShow, "kuang", -50, 15, "res/wy/public/new_jiantou.png")
                npc.idx = k
            end
            idx = idx + 1
        end

        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,gap = {x=150, y=5},colnum = 2})
        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200 + 544, 430,
                        "<font color='#00FF00' size='20' >全身10级：全属性+10%</font>\n"..
                        "<font color='#00FF00' size='20' >全身20级：全属性+20%</font>\n"..
                        "<font color='#00FF00' size='20' >全身30级：全属性+30%</font>\n"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "升级当前")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, npc.idx, "")
        end)

        Button= GUI:Button_Create(node, "Button2", 750, 150.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "自动升级")
        GUI:Button_setTitleFontSize(Button, 14)
        GUI:addOnClickEvent(Button, function()
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
        npc.data[""..p3] = npc.data[""..p3] + 1
        UI_updata(npc.node)
    end
end

return npc