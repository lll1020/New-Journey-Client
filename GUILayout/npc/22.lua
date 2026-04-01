--npc功能：
local npc = {}
npc._config = teshudata["npc_22"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/linggen/bg.png", eff = false},
    closeButton = {x = 800, y = 440, skin = "res/wy/public/close_red_big.png"},
}
local color = {
    "#FFD700",
    "#228B22",
    "#1E90FF",
    "#FF4500",
    "#967117",
    "#8A2BE2",
    "#B0E0E6",
    "#87CEFA",
    "#FF6347",
    "#704214",
}

local function _lg_base_ratio()
    return tonumber((npc._config or {}).base_ratio or 0.4) or 0.4
end

local function _lg_has_root(idx)
    local levelMap = npc.data and npc.data.T_data and npc.data.T_data.level or {}
    return idx and levelMap and levelMap[tostring(idx)] ~= nil
end

local function _lg_level_value(idx)
    local levelMap = npc.data and npc.data.T_data and npc.data.T_data.level or {}
    return tonumber(levelMap[tostring(idx)] or 0) or 0
end

local function _lg_effect_scale(idx, extraLevel)
    if not _lg_has_root(idx) then
        return 0
    end
    return _lg_level_value(idx) + (tonumber(extraLevel or 0) or 0) + _lg_base_ratio()
end

local function _lg_round_value(value)
    value = tonumber(value) or 0
    if value <= 0 then
        return 0
    end
    local ret = math.floor(value + 0.5)
    if ret <= 0 then
        ret = 1
    end
    return ret
end

local function _lg_build_attr_list(idx, extraLevel)
    local cfg = npc._config and npc._config.main_r and npc._config.main_r[idx]
    local scale = _lg_effect_scale(idx, extraLevel)
    local attrList = {}
    if not cfg or scale <= 0 then
        return attrList
    end
    for _, one in ipairs(cfg.attr or {}) do
        table.insert(attrList, {one[1], _lg_round_value((tonumber(one[2]) or 0) * scale)})
    end
    return attrList
end

local function _lg_format_scale_text(idx, extraLevel)
    local scale = _lg_effect_scale(idx, extraLevel)
    if scale <= 0 then
        return "0.0"
    end
    return string.format("%.1f", scale)
end

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
    function xjm_UI_updata(x_node) --小界面渲染
        local name = GUI:Text_Create(x_node, "name", 116 + 110, 222, 25, "#FFFFFF", npc._config.main_r[npc.current_idx].name.."灵根")
        GUI:setAnchorPoint(name, 0.5, 0.5)
        GUI:Text_setFontName(name, "fonts/501.ttf")

        local showItem = GUI:Image_Create(x_node, "item", 464/2, 276, "res/custom/linggen/itme_"..npc.current_idx..".png")
        GUI:setAnchorPoint(showItem, 0.5, 0.5)

        local currentAttrs = _lg_build_attr_list(npc.current_idx, 0)
        local nextAttrs = _lg_build_attr_list(npc.current_idx, 1)
        for v, k in pairs(currentAttrs) do
            local kuang = GUI:Image_Create(x_node, "kuang"..v, 10 + 110, 175 - (v-1)*20, "res/custom/tianshu/qh/tip.png")
            GUI:RichText_Create(kuang, "attr_desc", 20, 0, Player:showAttr({k}), 200, 17, "#f7f7de", 3,nil,nil)
            GUI:Image_Create(kuang, "jt", 128, 0, "res/custom/tianshu/qh/jt.png")
            local nextOne = nextAttrs[v]
            GUI:Text_Create(kuang, "old_attr_v",160,3, 17, "#00FFFF",
                (_lg_level_value(npc.current_idx) < npc._config.main_updata.max_level and nextOne) and nextOne[2] or "已满级")
        end

        -- for v,k in pairs(attr) do
        --     
        --     GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 20, "##00FFFF", k.attr_name.." +")
        --     , "fonts/502.ttf")
        --     local new_config = npc._config.details[1].details[(npc.data.T_data.level or 0) + 1]
        --     local old_config = npc._config.details[1].details[(npc.data.T_data.level or 0)]
        --     GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",125,-2, 20, "##00FFFF", old_config and old_config.attr[k.idx][2] or 0)
        --     , "fonts/502.ttf")
        --     
        --     
        --     GUI:Image_Create(kuang, "up", 270, 0, "res/custom/tianshu/qh/up.png")
        -- end
        if not (npc.data.T_data.level[""..npc.current_idx] and npc.data.T_data.level[""..npc.current_idx] < npc._config.main_updata.max_level) then
        
            GUI:Image_Create(x_node, "6_1", 50 + 110, 20, "res/wy/public/6_1.png")
            return
        end

        local cost = GUI:RichText_Create(x_node, "cost", 120 + 110, 80,  checkItemNumByTable_only(
            npc._config.main_updata.details[npc.current_idx <= 5 and "low" or "up"][npc.data.T_data.level[""..npc.current_idx] + 1].cost
        ), 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        GUI:setAnchorPoint(cost, 0.5, 0.5)


        local btn_upup = GUI:Button_Create(x_node, "btn_upup", 20 + 110, 10, "res/custom/linggen/btn_upup.png")
        GUI:addOnClickEvent(btn_upup, function()
            SL:SendLuaNetMsg(100, npcid, 5, npc.current_idx, "")
        end)
        
        local xjmNextCost = npc._config.main_updata.details[npc.current_idx <= 5 and "low" or "up"][npc.data.T_data.level[""..npc.current_idx] + 1].cost
        if xjmNextCost and checkItemNum(xjmNextCost) then
            NPC_UI_HELPER.redpoint_create(btn_upup,{x = 185,y = 35})
            NPC_UI_HELPER.tryStartXylGuide(npc, btn_upup, x_node, "linggen_upgrade_" .. tostring(npc.current_idx or 0), {
                taskName = "升级灵根",
                dir = 5,
                desc = "点击升级灵根",
            })
        end
    
    end

    local function renderLinggenDetailScroll(parent, idx, opts)
        opts = opts or {}
        if not parent or not idx or idx <= 0 or not npc._config.main_r[idx] then
            return nil
        end

        local yLift = 80
        local yOffset = (opts.yOffset or 0) + yLift
        local maxLevelForSeal = opts.maxLevelForSeal
        local scrollView = GUI:ScrollView_Create(parent, opts.scrollName or "ScrollView", 0, 0, 210, 215, 1)
        GUI:ScrollView_setBounceEnabled(scrollView, true)

        local innerH = 400
        GUI:ScrollView_setInnerContainerSize(scrollView, 210, innerH)

        local level = npc.data.T_data.level and npc.data.T_data.level["" .. idx]
        local cfg = npc._config.main_r[idx]

        local name = GUI:Text_Create(scrollView, "name", 10, 285 + yOffset, 25, color[idx], "【" .. cfg.name .. "灵根】")
        GUI:Text_setFontName(name, "fonts/501.ttf")

        if not (level and level >= 0) then
            return {scrollView = scrollView, level = level, isMax = false}
        end
        -- level = 1

        local up_num = GUI:Text_Create(scrollView, "up_num", 130, 285 + yOffset, 20, "#FFFFFF", "lv." .. level)
        local effect = GUI:Frames_Create(scrollView,opts.effectNodeName or "jcsx_eff",10,250 + yOffset,opts.effectPrefix or "res/private/item_tips/eff/jcsx/eff_",".png",1,15,{speed = 75, count = 15, loop = -1})

        local cursorY = 240 + yOffset
        local attr_desc = GUI:RichText_Create(scrollView, "attr_desc", 30, cursorY, Player:showAttr(_lg_build_attr_list(idx, 0)), 200, 17, "#f7f7de", 3, nil, nil)
        GUI:setAnchorPoint(attr_desc, 0, 1)
        cursorY = cursorY - GUI:getBoundingBox(attr_desc).height - 35

        local effect = GUI:Frames_Create(scrollView,opts.effectNodeName or "tsxg_eff",10,cursorY,opts.effectPrefix or "res/private/item_tips/eff/tsxg/eff_",".png",1,15,{speed = 75, count = 15, loop = -1})
        -- cursorY = cursorY - 35

        local main_name = GUI:Text_Create(scrollView, "main_name", 20, cursorY - 20, 20, "#FFD700", "主灵根效果")
        GUI:Text_setFontName(main_name, "fonts/501.ttf")
        cursorY = cursorY - 5
        local main_desc = GUI:RichText_Create(
            scrollView,
            "main_desc",
            10,
            cursorY-20,
            string.format(cfg.wz1, cfg.value1, _lg_format_scale_text(idx, 0)),
            200,
            17,
            "#f7f7de",
            2,
            nil,
            nil
        )
        GUI:setAnchorPoint(main_desc, 0, 1)
        cursorY = cursorY - GUI:getBoundingBox(main_desc).height - 10

        local other_name = GUI:Text_Create(scrollView, "other_name", 20, cursorY-30, 20, "#87CEFA", "副灵根效果")
        GUI:Text_setFontName(other_name, "fonts/501.ttf")
        cursorY = cursorY - 5
        local other_desc = GUI:RichText_Create(
            scrollView,
            "other_desc",
            10,
            cursorY-30,
            string.format(cfg.wz2, cfg.value2, _lg_format_scale_text(idx, 0)),
            200,
            17,
            "#f7f7de",
            2,
            nil,
            nil
        )
        GUI:setAnchorPoint(other_desc, 0, 1)
        cursorY = cursorY - GUI:getBoundingBox(other_desc).height - 10

        if cursorY < 0 then
            local delta = math.abs(cursorY) + 60
            innerH = innerH + delta
            GUI:ScrollView_setInnerContainerSize(scrollView, 210, innerH)
            for _, node in ipairs({name, up_num, effect, attr_desc, main_name, main_desc, other_name, other_desc}) do
                if node then
                    local p = GUI:getPosition(node)
                    GUI:setPosition(node, p.x, p.y + delta)
                end
            end
        end

        local isMax = maxLevelForSeal and level >= maxLevelForSeal
        if isMax then
            GUI:Image_Create(scrollView, "6_1", 50, 20 + yLift, "res/wy/public/6_1.png")
        end

        return {scrollView = scrollView, level = level, isMax = isMax}
    end

    local function getDefaultLinggenIdx()
        if npc.data and npc.data.T_data then
            return npc.data.T_data.main or npc.data.T_data.other or 0
        end
        return 0
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end
        local titles = {"灵根装配", "灵根升级",}
        GUI:removeAllChildren(node)


        --- 自新增移动类型 来自/去达
        local function mainfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 2, npc.current_move_node, "")
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
        end

        local function otherfromToEvent(_, data)
            SL:SendLuaNetMsg(100, npcid, 3, npc.current_move_node, "")
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
        end

        --- 自新增移动类型 来自/去达
        local function maintoout(_, data)
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end

        local function othertoout(_, data)
            SL:SendLuaNetMsg(100, npcid, 3, 0, "")
        end



        GUI:AddMoveWidgetTypeEvent("fromToEvent", "maintoFromEvent", mainfromToEvent, nil)
        GUI:AddMoveWidgetTypeEvent("fromToEvent", "othertoFromEvent", otherfromToEvent, nil)

        GUI:AddMoveWidgetTypeEvent("maintoFromEvent", "out", maintoout, nil)
        GUI:AddMoveWidgetTypeEvent("othertoFromEvent", "out", othertoout, nil)



        
        function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            -- local tt = GUI:Text_Create(Label_node, "tt", 1000/2, 500, 30, "#00FF00", titles[idx])
            -- GUI:setAnchorPoint(tt, 0.5, 0.5)


            if idx == 1 then
                local function xjm_updata()
                    if GUI:getChildByName(npc.Label, "current_kuang") then
                        GUI:removeChildByName(npc.Label, "current_kuang")
                    end
                    if npc.current_idx == nil or npc.current_idx <= 0 then
                        return
                    end
                
                    local current_kuang = GUI:Node_Create(npc.Label, "current_kuang", 125, 100)
                    renderLinggenDetailScroll(current_kuang, npc.current_idx, {
                    })
                end


                npc.current_move_node = 0
                if not npc.current_idx or npc.current_idx <= 0 then
                    npc.current_idx = getDefaultLinggenIdx()
                end

                GUI:Image_Create(Label_node, "wz_1", 760, 30, "res/custom/linggen/wz_3.png")
                GUI:Image_Create(Label_node, "wz_2", 155, 315, "res/custom/linggen/wz_1.png")

                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 400, 30, 435, 190, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))


                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/linggen/kuang.png")
                    

                    local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").fromToEvent, {
                        beginMoveCB = function(move_node)
                            npc.current_move_node = v
                            npc.current_idx = v
                            xjm_updata()
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, true)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, true)
                            GUI:setTouchEnabled(ScrollView, false)
                        end,
                        endMoveCB = function(move_node)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
                            GUI:setTouchEnabled(ScrollView, true)
                         end,
                        cancelMoveCB  = function(move_node)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                            GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)
                            GUI:setTouchEnabled(ScrollView, true)
                        end})
                    GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                    local showItem = GUI:Image_Create(moveWidget, "item"..v, 84/2, 86/2, "res/custom/linggen/itme_"..v..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..v..".png")
                    GUI:Text_Create(kuang, "level"..v, 70, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and ("lv."..npc.data.T_data.level[""..v]) or "未激活")


                    
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=40, y=10}})
                --主灵根


                -- local kuang = GUI:Image_Create(Label_node, "item_main_kuang", 430, 290, "res/wy/public/003.png")
                local kuang = GUI:Layout_Create(Label_node, "item_main_kuang", 430, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                local contentSize = kuang:getContentSize()
                local moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", contentSize.width / 2, contentSize.height / 2, 125, 160, SL:GetMetaValue("ITEMFROMUI_ENUM").maintoFromEvent,
                        {beginMoveCB = function(move_node)
                            npc.current_idx = npc.data.T_data.main or 0
                            xjm_updata()
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                -- local showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                if npc.data.T_data.main then
                    local showItem = GUI:Image_Create(moveWidget, "item", 130/2, 146/2, "res/custom/linggen/itme_"..npc.data.T_data.main..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..npc.data.T_data.main..".png")
                end

                kuang = GUI:Layout_Create(Label_node, "item_other_kuang", 603, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                contentSize = kuang:getContentSize()
                moveWidget = GUI:MoveWidget_Create(kuang, "moveWidget", contentSize.width / 2, contentSize.height / 2, 125, 160, SL:GetMetaValue("ITEMFROMUI_ENUM").othertoFromEvent,
                        {beginMoveCB = function(move_node)
                            npc.current_idx = npc.data.T_data.other or 0
                            xjm_updata()
                            GUI:setVisible(npc.out_moveWidget, true)
                        end,
                         endMoveCB = function(move_node)
                             GUI:setVisible(npc.out_moveWidget, false)
                         end
                        ,cancelMoveCB  = function(move_node)
                            GUI:setVisible(npc.out_moveWidget, false)
                        end})
                GUI:setAnchorPoint(moveWidget, 0.5, 0.5)
                -- showItem = GUI:Text_Create(moveWidget, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                if npc.data.T_data.other then
                    local showItem = GUI:Image_Create(moveWidget, "item", 130/2, 146/2, "res/custom/linggen/itme_"..npc.data.T_data.other..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..npc.data.T_data.other..".png")
                end


                npc.out_moveWidget = GUI:MoveWidget_Create(Label_node, "out_moveWidget", 365, 30, 435, 190, SL:GetMetaValue("ITEMFROMUI_ENUM").out,{})
                GUI:setContentSize(GUI:Image_Create(npc.out_moveWidget, "kuang", 0, 0, "res/wy/public/500-300.png")
                , 435, 190)
                GUI:setAnchorPoint(npc.out_moveWidget, 0, 0)

                contentSize = npc.out_moveWidget:getContentSize()
                local xx = GUI:Text_Create(npc.out_moveWidget, "xx", contentSize.width / 2, contentSize.height / 2, 50, "#FFFFFF", "放入卸下")
                GUI:setAnchorPoint(xx, 0.5, 0.5)
                GUI:Text_setFontName(xx, "fonts/501.ttf")

                GUI:setVisible(npc.out_moveWidget, false)

                local eff = GUI:Image_Create(GUI:ui_delegate(Label_node).item_main_kuang, "eff", 125/2, 160/2, "res/wy/public/003.png")
                GUI:setContentSize(eff, 125, 160)
                GUI:setAnchorPoint(eff, 0.5, 0.5)
                GUI:runAction(eff, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionScaleTo(0.5, 1.1), GUI:ActionScaleTo(0.5, 1))))
                
                eff = GUI:Image_Create(GUI:ui_delegate(Label_node).item_other_kuang, "eff", 125/2, 160/2, "res/wy/public/003.png")
                GUI:setContentSize(eff, 125, 160)
                GUI:setAnchorPoint(eff, 0.5, 0.5)
                GUI:runAction(eff, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionScaleTo(0.5, 1.1), GUI:ActionScaleTo(0.5, 1))))

                GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_main_kuang).eff, false)
                GUI:setVisible(GUI:ui_delegate(GUI:ui_delegate(npc.Label).item_other_kuang).eff, false)

                xjm_updata()

            elseif idx == 2 then
                --local Button= GUI:Button_Create(Label_node, "Button1", 750, 150.00, "res/public/1900000660.png")
                --GUI:Button_setTitleText(Button, "抽取一个低级灵根")
                --GUI:Button_setTitleFontSize(Button, 14)
                --
                --GUI:addOnClickEvent(Button, function()
                --    SL:SendLuaNetMsg(100, npcid, 1, 0, '')
                --end)

                local function qh_xjm(current_kuang) 
                    GUI:removeAllChildren(current_kuang)
                    if npc.current_idx and npc.current_idx > 0 then
                        local detail = renderLinggenDetailScroll(current_kuang, npc.current_idx, {
                            
                        })
                        if not detail or not (detail.level and detail.level >= 0) or detail.isMax then
                            return
                        end

                        local Button= GUI:Button_Create(current_kuang, "Button", 0, -90, "res/custom/linggen/btn_up.png")
                        GUI:addOnClickEvent(Button, function()
                            -- SL:SendLuaNetMsg(100, npcid, 5, npc.current_idx, "")
                            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                                windowName = "npc_anniu_22_xjm",
                                overlay = {skin = "res/custom/treasureBasin/x.png"},
                                background = {skin = "res/custom/linggen/x_bg.png"},
                                closeButton = {x = 415, y = 327, skin = "res/wy/public/close_red_big.png"},
                            })
                            npc.xjm_node = npc.xjm_window.node
                            xjm_UI_updata(npc.xjm_node)
                        end)
                        local lv = npc.data.T_data.level[""..npc.current_idx] or 0
                        local det = npc._config.main_updata.details[(npc.current_idx <= 5) and "low" or "up"]
                        local nextCfg = det and det[lv + 1]
                        if nextCfg and nextCfg.cost and checkItemNum(nextCfg.cost) then
                            NPC_UI_HELPER.redpoint_create_eff(Button,{x = 54,y = 50})
                        end
                    end
                end

                if not npc.current_idx or npc.current_idx <= 0 then
                    npc.current_idx = getDefaultLinggenIdx()
                end
                local current_kuang = GUI:Node_Create(Label_node, "current_kuang", 125, 100)


                GUI:Image_Create(Label_node, "wz_3", 760, 30, "res/custom/linggen/wz_3.png")

                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 400, 30, 435, 190, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 435, ((86 + 10) * math.ceil(#npc._config.main_r/3)))

                for v,k in pairs(npc._config.main_r or {}) do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/linggen/kuang.png")
                    -- local showItem = GUI:Text_Create(kuang, "item"..v, 84/2, 86/2, 20, "#FFFFFF", k.name)
                    local showItem = GUI:Image_Create(kuang, "item"..v, 84/2, 86/2, "res/custom/linggen/itme_"..v..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..v..".png")
                    GUI:Text_Create(kuang, "level"..v, 70, 0, 20, "#FF00FF", (npc.data.T_data.level and npc.data.T_data.level[""..v]) and ("lv."..npc.data.T_data.level[""..v]) or "未激活")

                    GUI:setTouchEnabled(kuang, true)
                    GUI:addOnClickEvent(kuang, function()
                        npc.current_idx = v
                        qh_xjm(current_kuang) 
                    end)
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=40, y=10}})


                --主灵根

                GUI:Image_Create(Label_node, "wz_2", 155, 315, "res/custom/linggen/wz_2.png")


                local kuang = GUI:Layout_Create(Label_node, "item_main_kuang", 430, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                -- local showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.main and npc._config.main_r[npc.data.T_data.main].name or "无")
                if npc.data.T_data.main then
                    local showItem = GUI:Image_Create(kuang, "item", 130/2, 146/2, "res/custom/linggen/itme_"..npc.data.T_data.main..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..npc.data.T_data.main..".png")
                end
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.main or 0
                    qh_xjm(current_kuang) 
                end)

                kuang = GUI:Layout_Create(Label_node, "item_other_kuang", 603, 290, 125, 160)
                -- GUI:setContentSize(kuang, 125, 160)
                if npc.data.T_data.other then
                    local showItem = GUI:Image_Create(kuang, "item", 130/2, 146/2, "res/custom/linggen/itme_"..npc.data.T_data.other..".png")
                    GUI:setAnchorPoint(showItem, 0.5, 0.5)
                    GUI:Image_Create(showItem, "icon", -5, 45, "res/custom/linggen/icon/"..npc.data.T_data.other..".png")
                end
                -- showItem = GUI:Text_Create(kuang, "item", 35, 35, 20, "#FFFFFF", npc.data.T_data.other and npc._config.main_r[npc.data.T_data.other].name or "无")
                -- GUI:setAnchorPoint(showItem, 0.5, 0.5)
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnClickEvent(kuang, function()
                    npc.current_idx = npc.data.T_data.other or 0
                    qh_xjm(current_kuang) 
                end)


                qh_xjm(current_kuang) 
                

                
            end
        end

        npc.titles_sign = 2
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        -- for i = 1, #titles do
        --     local cbl_item = GUI:Button_Create(node, "item" .. i, 100+(i-1)*120, 50, "res/public/1900000660.png")
        --     GUI:Button_setTitleText(cbl_item, titles[i])
        --     GUI:Button_setTitleFontSize(cbl_item, 14)
        --     GUI:addOnClickEvent(cbl_item, function()
        --         npc.titles_sign = i
        --         GUI_createLabel(npc.Label,i)
        --     end)
        -- end

        local btn_set = GUI:Button_Create(node, "btn_set", 105, 355, "res/custom/linggen/btn_set.png")
        GUI:addOnClickEvent(btn_set, function()
            if npc.titles_sign == 2 then
                GUI:Button_loadTextureNormal(btn_set, "res/custom/linggen/btn_save.png")
                npc.titles_sign = 1
                GUI_createLabel(npc.Label,1)
            else
                GUI:Button_loadTextureNormal(btn_set, "res/custom/linggen/btn_set.png")
                npc.titles_sign = 2
                GUI_createLabel(npc.Label,2)
            end
        end)


        GUI_createLabel(npc.Label,npc.titles_sign)
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData,false)
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_anniu_22_xjm",
            overlay = {skin = "res/custom/treasureBasin/x.png"},
            background = {skin = "res/custom/linggen/x_bg.png"},
            closeButton = {x = 415, y = 327, skin = "res/wy/public/close_red_big.png"},
        })
        npc.xjm_node = npc.xjm_window.node
        xjm_UI_updata(npc.xjm_node)
    end
end

return npc
