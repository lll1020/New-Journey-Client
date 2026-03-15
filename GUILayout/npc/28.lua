local npc = {}

npc._config = teshudata["npc_28"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/zbqh/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/two_city/zbqh/title.png"},
}

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

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 70,30, 500, 340)
        npc.dbLayout = GUI:Layout_Create(node, "attr_dbLayout", 610 - 355,484 - 150, 315, 150)
        local attr = {
            {attr_name = "人物生命", idx = 3},
            {attr_name = "人物攻击", idx = 1},
            {attr_name = "人物防御", idx = 4},
        }

        local tip = GUI:Image_Create(node, "tip", 700, 150, "res/wy/public/xqh_tip.png")
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = "<全装备位置强化 + 10/FCOLOR=243>\\<            全属性+  10%/FCOLOR=249>\\_________________\\<全装备位置强化 + 20/FCOLOR=243>\\<            全属性+  20%/FCOLOR=249>\\_________________\\<全装备位置强化 + 30/FCOLOR=243>\\<            全属性+  30%/FCOLOR=249>", worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end, onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end})
         else
            GUI:setTouchEnabled(tip, true)
            GUI:addOnTouchEvent(tip, function(self)
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = "<全装备位置强化 + 10/FCOLOR=243>\\<            全属性+  10%/FCOLOR=249>\\_________________\\<全装备位置强化 + 20/FCOLOR=243>\\<            全属性+  20%/FCOLOR=249>\\_________________\\<全装备位置强化 + 30/FCOLOR=243>\\<            全属性+  30%/FCOLOR=249>", worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end)
        end


        local idx = 1
        for k,v in pairs(npc._config.where) do
            local EquipShow = GUI:EquipShow_Create(
                    GUI:Image_Create(dbLayout, "where_"..k, 0.00, 0.00, "res/wy/public/58-60.png")
            , "EquipShow", 58/2, 60/2, k, false, {noMouseTips = true, look = false, movable = false, bgVisible = false, doubleTakeOff = false})
            GUI:EquipShow_setAutoUpdate(EquipShow)
            GUI:setAnchorPoint(EquipShow, 0.5, 0.5)

            GUI:setTouchEnabled(EquipShow, true)
            GUI:addOnClickEvent(EquipShow, function()
                npc.idx = k
                UI_updata(node)
            end)
            if (idx == 1 and not npc.idx) or npc.idx == k then
                npc.idx = k
            end
            idx = idx + 1
        end

        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,gap = {x=10, y=10},colnum = 2})

        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200 + 544, 430,
        --                 "<font color='#00FF00' size='20' >全身10级：全属性+10%</font>\n"..
        --                 "<font color='#00FF00' size='20' >全身20级：全属性+20%</font>\n"..
        --                 "<font color='#00FF00' size='20' >全身30级：全属性+30%</font>\n"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)

        local item = SL:GetMetaValue("EQUIP_DATA", npc.idx)
        

        GUI:Text_Create(node, "wz1", 50.00 + 283, 40.00 + 312, 20, "#ffffff", "["..npc._config.where[npc.idx][1].."]"..(item and SL:GetMetaValue("ITEM_DATA",item.Index).Name or "无装备"))
        GUI:Text_Create(node, "wz2", 60.00 + 550 + 65, 40.00 + 312, 20, "#ffffff", "lv."..npc.data[""..npc.idx])

        local config = npc._config.details[npc.data[""..npc.idx] + 1]
        npc.cost_show = GUI:Node_Create(node, "cost_show", 372, 90)
        if config then
            checkItemNumByTable_img_kuang(config.cost, nil,npc.cost_show)
            local Button= GUI:Button_Create(node, "Button", 750 - 375, 0, "res/custom/two_city/zbqh/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, npc.idx, "")
            end)
            if checkItemNum(config.cost) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        else
            GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",750 - 375, 50, 30, "#FF0000", "已达最高等级")
            , "fonts/500.ttf")
        end

        npc.kuang = GUI:Image_Create(GUI:ui_delegate(dbLayout)["where_"..npc.idx], "kuang", 58/2 + 2, 60/2 + 2, "res/custom/two_city/qyzb/kuang.png")
        GUI:setContentSize(npc.kuang, 58, 60)
        GUI:setAnchorPoint(npc.kuang, 0.5, 0.5)



        for v,k in pairs(attr) do
            local kuang = GUI:Image_Create(npc.dbLayout, "kuang"..v, 0, 0, "res/custom/tianshu/qh/tip.png")
            GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 24, "##00FFFF", k.attr_name.." +")
            , "fonts/502.ttf")
            local new_config = config
            local old_config = npc._config.details[npc.data[""..npc.idx]]
            GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",160,-2, 24, "##00FFFF", old_config and old_config.attr[k.idx][2] or 0)
            , "fonts/502.ttf")
            GUI:Image_Create(kuang, "jt", 220, 0, "res/custom/tianshu/qh/jt.png")
            GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",260,-2, 24, "##109C18", new_config and ("+"..new_config.attr[k.idx][2]) or "已满级")
            , "fonts/502.ttf")
            GUI:Image_Create(kuang, "up", 340, 3, "res/custom/tianshu/qh/up.png")
        end
        GUI:UserUILayout(npc.dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})
        GUI:setAnchorPoint(npc.dbLayout, 0, 1)


        

        local s_s_btn = GUI:Image_Create(node, "s_s_btn", 590, 20, "res/custom/two_city/zbqh/zd.png")
        local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox",GUI:getContentSize(s_s_btn).width - 25, 0, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
        GUI:CheckBox_setSelected(s_s_CheckBox,npc.Schedule_open)
        GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
            if GUI:CheckBox_isSelected(s_s_CheckBox) then
                npc.Schedule = SL:Schedule(function ()
                    local low_idx = 0
                    for v,k in pairs(npc._config.where) do
                        npc.data[""..v] = npc.data[""..v] or 0
                        if npc.data[""..v] < (npc.data[""..low_idx] or 0) then
                            low_idx = v
                        end
                    end
                    
                    local config = npc._config.details[npc.data[""..low_idx] + 1]
                    if config and checkItemNum(config.cost) then
                        SL:SendLuaNetMsg(100, npcid, 1, low_idx, "")
                        npc.idx = low_idx
                        npc.Schedule_open = true
                        -- UI_updata(npc.node)
                        
                    else
                        SL:UnSchedule(npc.Schedule)
                        npc.Schedule = nil
                        npc.Schedule_open = false
                    end
                
                end, 1)
            else
                SL:UnSchedule(npc.Schedule)
                npc.Schedule = nil
                npc.Schedule_open = false
            end
        end)
        
        

        -- Button= GUI:Button_Create(node, "Button2", 750, 150.00, "res/public/1900000660.png")
        -- GUI:Button_setTitleText(Button, "自动升级")
        -- GUI:Button_setTitleFontSize(Button, 14)
        -- GUI:addOnClickEvent(Button, function()
        -- end)
    end
 
    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data[""..p3] = npc.data[""..p3] + 1
        UI_updata(npc.node)
    end

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_28"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            SL:UnSchedule(npc.Schedule)
            npc.node = nil
            npc.Schedule = nil
            npc.Schedule_open = false
        end
    end)
end

return npc
