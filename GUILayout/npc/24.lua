local npc = {}

npc._config = teshudata["npc_24"]


local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 400, y = 200, skin = "res/wy/public/close_red_big.png"},
}
local level_coler = {
    [1] = "#44DDFF",
    [2] = "#00FFFF",
    [3] = "#DF009F",
    [4] = "#EFAD21",
    [5] = "#FF0000",
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

        npc.bg = GUI:Frames_Create(npc.bg, "eff", 0, 0, "res/custom/tianshu/bg/bg_", ".png", 1, 15,
            { speed = 100, count = 15, loop = -1})
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)

        GUI:setLocalZOrder(npc._window.node, 99)
        npc.node = GUI:Node_Create(npc.bg, 'node', 0, 0)
        return npc.node
    end


    local function UI_updata(node) --界面渲染
        if not node then
            return
        end
        local titles = {"qh", "xf", "ws"}
        GUI:removeAllChildren(node)


        function GUI_createLabel(Label_node,idx) --主界面渲染
            GUI:removeAllChildren(Label_node)
            local tt = GUI:Image_Create(Label_node, "tt", 60, 30, "res/custom/tianshu/title/title_"..idx..".png")
            local xjm = GUI:Image_Create(Label_node, "xjm", 0, 0, "res/custom/tianshu/"..titles[idx].."/xjm.png")
            -- GUI:setAnchorPoint(tt, 0.5, 0.5)
            if idx == 1 then
                -- GUI:setAnchorPoint(
                --         GUI:RichText_Create(Label_node, "desc", 200, 430,
                --                 "<font color='#00FF00' size='20' >当前天书等级："..(npc.data.T_data.level or 0).."</font>"
                --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                -- , 0, 1)

                
                local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)
                if item then
                    local level = GUI:Text_Create(Label_node, "level",30 + 288,40 + 93, 30, "#FF0000", "天书【lv."..(npc.data.T_data.level or 0).."】")
                    GUI:Text_setFontName(level, "fonts/501.ttf")

                    local new_config = npc._config.details[1].details[(npc.data.T_data.level or 0) + 1]
                    local old_config = npc._config.details[1].details[(npc.data.T_data.level or 0)]

                    local jdt = GUI:LoadingBar_Create(Label_node, "jdt", 726,227,"res/custom/tianshu/qh/jdt.png", 0)
                    GUI:LoadingBar_setPercent(jdt, (npc.data.T_data.jf or 0) / (new_config and new_config.jf or 0) * 100)

                    GUI:RichText_Create(Label_node, "text_name", 795,224,
                        SetCompletionProgress_14((npc.data.T_data.jf or 0), (new_config and new_config.jf or 0))
                    , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                    -- local kuang = GUI:Image_Create(Label_node, "kuang", 200, 250, "res/wy/public/70_70_k.png")
                    -- UiTools.showItemData(kuang, item)

                    local dbLayout = GUI:Layout_Create(Label_node, "dbLayout", 610,484, 315, 150)
                    local attr = {
                            {attr_name = "生命魔法", idx = 1},
                            {attr_name = "攻  魔  道", idx = 4},
                            {attr_name = "人物防御", idx = 10},
                    }


                    for v,k in pairs(attr) do
                        local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/tianshu/qh/tip.png")
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 20, "##00FFFF", k.attr_name.." +")
                        , "fonts/502.ttf")
                        
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",125,-2, 20, "##00FFFF", old_config and old_config.attr[k.idx][2] or 0)
                        , "fonts/502.ttf")
                        GUI:Image_Create(kuang, "jt", 170, -2, "res/custom/tianshu/qh/jt.png")
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",215,-2, 20, "##109C18", new_config and new_config.attr[k.idx][2] or "已满级")
                        , "fonts/502.ttf")
                        GUI:Image_Create(kuang, "up", 290, 3, "res/custom/tianshu/qh/up.png")

            
                    end
                    GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})
                    GUI:setAnchorPoint(dbLayout, 0, 1)
                    npc.data.T_data.level = npc.data.T_data.level or 0
                    if npc.data.T_data.level < npc._config.details[1].max_level then
                        local Button= GUI:Button_Create(Label_node, "Button", 660, 100.00, "res/custom/tianshu/qh/btn.png")
                        GUI:addOnClickEvent(Button, function()
                            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                        end)
                        if new_config and (not new_config.cost or checkItemNum(new_config.cost)) and (not new_config.jf or (npc.data.T_data.jf or 0) >= new_config.jf) then
                            NPC_UI_HELPER.redpoint_create_eff(Button,{x = 219,y = 35,autoScale = 1})
                        end
                    else
                        GUI:Image_Create(Label_node, "Button", 660, 100.00, "res/wy/public/15.png")
                    end


                    
                    
                end  
            elseif idx == 2 then
                -- local GUI_list = GUI:ListView_Create(Label_node, "GUI_list", 200, 100, 700, 270, 2)
                -- for i = 1, 10 do
                --     local kuang = GUI:Image_Create(GUI_list, "kuang"..i, 0, 0, "res/wy/public/anniu_999_bj.png")
                --     GUI:setContentSize(kuang, 150, 270)
                --     npc.data.T_data.caowei = npc.data.T_data.caowei or {}
                --     if npc.data.T_data.caowei[""..i] then
                --         GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", npc._config.details[2].details[npc.data.T_data.caowei[""..i][1]][npc.data.T_data.caowei[""..i][2]].name)
                --         , 0.5, 0.5)
                --     else
                --         GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", "暂未解锁")
                --         , 0.5, 0.5)
                --     end
                --     local Button= GUI:Button_Create(kuang, "Button", 150/2, 50, "res/public/1900000660.png")
                --     GUI:setAnchorPoint(Button, 0.5, 0.5)
                --     GUI:Button_setTitleText(Button, "洗练")
                --     GUI:Button_setTitleFontSize(Button, 14)

                --     GUI:addOnClickEvent(Button, function()
                --         SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({caowei = i}))
                --     end)

                -- end

                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 240, 110, 312, 346, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 312, ((36 + 10) * 10))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 312, ((36 + 10) * 10))
                npc.data.T_data.caowei = npc.data.T_data.caowei or {}
                local caowei = npc.data.T_data.caowei
                local cfg = npc._config.details[2]
                local cfg_details = cfg.details
                local unlock_lv = cfg.unlock_lv or {}
                local cur_lv = npc.data.T_data.level or 0
                local label_delegate = GUI:ui_delegate(Label_node)
                local layout_delegate = GUI:ui_delegate(dbLayout)

                local function get_slot_info(slot, slot_data)
                    if slot_data then
                        local group = slot_data[1]
                        local idx2 = slot_data[2]
                        local info = cfg_details[group] and cfg_details[group][idx2]
                        if info then
                            return info.name, level_coler[group] or "#FFFFFF", info.wz
                        end
                    end
                    local need_lv = unlock_lv[slot] or 1
                    if cur_lv >= need_lv then
                        return "已解锁", "#00FF00", nil
                    end
                    return "解锁天书等级："..need_lv, "#A0A0A4", nil
                end

                local function render_slot_detail(slot)
                    local slot_key = ""..slot
                    local slot_data = caowei[slot_key]
                    local _, _, wz = get_slot_info(slot, slot_data)

                    npc.xf_node = label_delegate["xf_node"]
                    if npc.xf_node then
                        GUI:removeAllChildren(npc.xf_node)
                    else
                        npc.xf_node = GUI:Node_Create(Label_node, "xf_node", 0, 0)
                    end

                    if wz then
                        -- GUI:setAnchorPoint(GUI:Text_Create(npc.xf_node, "wz5",50 + 549,16 + 480, 20, "#FF0000", wz), 0, 1)
                        GUI:setAnchorPoint(GUI:RichText_Create(npc.xf_node, "attr_desc_next", 50 + 549,16 + 480,  wz, 310, 17, "#f7f7de", 3,nil,nil)
                        , 0, 1)
                    else
                        local need_lv = unlock_lv[slot] or 1
                        local text = (cur_lv >= need_lv) and "已解锁,首次刷新免费" or ("解锁天书等级："..need_lv)
                        GUI:setAnchorPoint(GUI:Text_Create(npc.xf_node, "wz5",50 + 549,16 + 480, 20, "#A0A0A4", text), 0, 1)
                    end

                    local Button = GUI:Button_Create(npc.xf_node, "Button", 50 + 549 + 76,100, "res/custom/tianshu/xf/btn_up.png")
                    -- if checkItemNum({{"仙品仙法卷轴",1}}) then
                    --     NPC_UI_HELPER.redpoint_create(Button)
                    -- end
                    local function do_refresh()
                        if checkItemNum({{"仙品仙法卷轴",1}}) then
                            SL:OpenCommonTipsPop({str="是否要使用仙品仙法卷轴，必可得到仙品仙法！",btnType=2,callback=function(atype,param)
                                if atype == 1 then
                                    SL:SendLuaNetMsg(100, npcid, 2, 2, SL:JsonEncode({caowei = slot}))
                                else
                                    SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({caowei = slot}))
                                end
                            end})
                        else
                            SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({caowei = slot}))
                        end
                        
                    end
                    GUI:addOnClickEvent(Button, function()
                        local cur_quality = slot_data and slot_data[1] or 0
                        if cur_quality >= 4 then
                            SL:OpenCommonTipsPop({str="当前已是仙品仙法，是否继续刷新？",btnType=2,callback=function(atype,param)
                                if atype == 1 then
                                    do_refresh()
                                end
                            end})
                        else
                            do_refresh()
                        end
                    end)
                end

                for i = 1, 10 do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..i, 0, 0, "res/custom/tianshu/xf/k_0.png")
                    GUI:setTouchEnabled(kuang, true)
                    GUI:addOnClickEvent(kuang, function()
                        if npc.xf_sign then
                            GUI:removeChildByName(layout_delegate["kuang"..npc.xf_sign], "kuang_eff")
                        end
                        npc.xf_sign = i
                        GUI:Frames_Create(kuang, "kuang_eff", -8, -6, "res/custom/tianshu/xf/kuang/kuang_", ".png", 1, 15,
                            { speed = 100, count = 15, loop = -1})
                        render_slot_detail(i)
                    end)

                    local slot_key = ""..i
                    local slot_data = caowei[slot_key]
                    local name, color = get_slot_info(i, slot_data)
                    GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",50,16, 20, color, name), 0, 0.5)
                    local level = (slot_data and slot_data[1]) or 0
                    GUI:Image_loadTexture(kuang, "res/custom/tianshu/xf/k_"..level..".png")
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})

                npc.xf_sign = npc.xf_sign or 1
                if npc.xf_sign >= 1 and npc.xf_sign <= 10 then
                    local kuang = layout_delegate["kuang"..npc.xf_sign]
                    if kuang then
                        GUI:Frames_Create(kuang, "kuang_eff", -8, -6, "res/custom/tianshu/xf/kuang/kuang_", ".png", 1, 15,
                            { speed = 100, count = 15, loop = -1})
                        render_slot_detail(npc.xf_sign)
                    end
                end
            elseif idx == 3 then
                npc.data.T_data.wangshi = npc.data.T_data.wangshi or {}
                
                local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 220, 110, 333, 346, 1)
                GUI:ScrollView_setBounceEnabled(ScrollView, true)
                GUI:ScrollView_setInnerContainerSize(ScrollView, 333, ((157 + 10) * #npc._config.details[3]))
                local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 312, ((157 + 10) * #npc._config.details[3]))
                npc.data.T_data.caowei = npc.data.T_data.caowei or {}

                for i = 1, #npc._config.details[3] do
                    local config = npc._config.details[3][i]
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..i, 0, 0, "res/custom/tianshu/ws/xnj_bg.png")
                    GUI:Text_Create(kuang, "name", 20, 110, 20, "#FFFFFF", config.name)
                    if npc.data.T_data.wangshi[""..i] then
                        local desc = GUI:RichText_Create(kuang, "desc", 20, 100, string.format(config.desc,unpack(npc.data.T_data.wangshi[""..i])), 290, 16, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                        GUI:setAnchorPoint(desc, 0, 1)
                    end
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})
            end
        end



        npc.titles_sign = 1
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        for i = 1, #titles do
            local cbl_item = GUI:Frames_Create(node, "item" .. i, 100+(i-1)*170, -20, "res/custom/tianshu/"..titles[i].."/btn_", ".png", 1, 15,
            { speed = 100, count = 15, loop = -1})
            GUI:setTouchEnabled(cbl_item, true)
            if npc.titles_sign == i then
                local kuang = GUI:Image_Create(cbl_item, "kuang", 140/2, 140/2, "res/wy/public/003.png")
                GUI:setContentSize(kuang, 150, 140)
                GUI:setAnchorPoint(kuang, 0.5, 0.5)
            end
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:addOnClickEvent(cbl_item, function()
                GUI:removeChildByName(GUI:ui_delegate(node)["item"..npc.titles_sign],"kuang")
                npc.titles_sign = i
                local kuang = GUI:Image_Create(GUI:ui_delegate(node)["item"..npc.titles_sign], "kuang", 140/2, 140/2, "res/wy/public/003.png")
                GUI:setContentSize(kuang, 150, 140)
                GUI:setAnchorPoint(kuang, 0.5, 0.5)
                GUI_createLabel(npc.Label,i)
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc
