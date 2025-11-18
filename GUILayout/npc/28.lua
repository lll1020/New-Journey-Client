local npc = {}

npc._config = teshudata["npc_28"]



local WINDOW_OPTS = {}

function npc.main(npcid, p2, p3, msgData)


    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

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
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data[""..p3] = npc.data[""..p3] + 1
        UI_updata(npc.node)
    end
end

return npc