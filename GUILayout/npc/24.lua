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
local XIANFA_SKIP_ANIM_KEY = "tianshu_xianfa_skip_anim"
local function _get_xianfa_skip_anim_default()
    return tostring(SL:GetLocalString(XIANFA_SKIP_ANIM_KEY) or "") == "1"
end
local function _set_xianfa_skip_anim_default(value)
    SL:SetLocalString(XIANFA_SKIP_ANIM_KEY, value and "1" or "0")
end
local function _ywl_vertical_text(text)
                    if not text then
                        return ""
                    end
                    local s = tostring(text)
                    local out = {}
                    local i = 1
                    while i <= #s do
                        local c = string.byte(s, i)
                        local len = 1
                        if c >= 0xF0 then
                            len = 4
                        elseif c >= 0xE0 then
                            len = 3
                        elseif c >= 0xC0 then
                            len = 2
                        end
                        local ch = string.sub(s, i, i + len - 1)
                        if ch == "（" or ch == "(" then
                            local close = (ch == "（") and "）" or ")"
                            local j = i + len
                            while j <= #s do
                                local cb = string.byte(s, j)
                                local clen = 1
                                if cb >= 0xF0 then
                                    clen = 4
                                elseif cb >= 0xE0 then
                                    clen = 3
                                elseif cb >= 0xC0 then
                                    clen = 2
                                end
                                local cj = string.sub(s, j, j + clen - 1)
                                if cj == close then
                                    j = j + clen
                                    break
                                end
                                j = j + clen
                            end
                            i = j
                        else
                            table.insert(out, ch)
                            i = i + len
                        end
                    end
                    return table.concat(out, "\n")
                end
function npc.main(npcid, p2, p3, msgData)
    local function _get_item_count(itemName)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if not itemIndex or itemIndex <= 0 then
            return 0
        end
        return tonumber(SL:GetMetaValue("ITEM_COUNT", itemIndex) or 0) or 0
    end
    local function _send_normal_xianfa_refresh(slot)
        SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({caowei = slot}))
    end
    -- 没有普通仙法卷轴时，先确认是否改为消耗100灵石刷新。
    local function _open_lingshi_refresh_confirm(slot)

        local parent = GUI:GetWindow(nil, "xf_lingshi_confirm")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("xf_lingshi_confirm", 0, 0, 0, 0, false, false, true, true, true, nil, 100)
        end
        local function close_confirm()
            GUI:Win_Close(parent)
        end
        local overlay = GUI:Image_Create(parent, "overlay", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(overlay, 0.5, 0.5)
        GUI:setContentSize(overlay, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(overlay, true)
        GUI:addOnClickEvent(overlay, function()
            close_confirm()
        end)
        local bg = GUI:Image_Create(parent, "bg", cogin.w / 2, cogin.h / 2, "res/wy/public/anniu_999_bj.png")
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setContentSize(bg, 380, 150)
        GUI:setTouchEnabled(bg, true)
        GUI:setLocalZOrder(bg, 10)
        
        local title = GUI:Text_Create(bg, "title", 190, 125, 24, "#FFF2C6", "刷新确认")
        GUI:setAnchorPoint(title, 0.5, 0.5)
        GUI:Text_enableOutline(title, "#000000", 1)
        local desc = GUI:Text_Create(bg, "desc", 190, 90, 20, "#FFFFFF", "是否花费100灵石刷新仙法？")
        GUI:setAnchorPoint(desc, 0.5, 0.5)
        GUI:Text_enableOutline(desc, "#000000", 1)
        local checkBox = GUI:CheckBox_Create(bg, "skip_confirm", 92, 36 + 10, "res/wy/public/xz_1.png", "res/wy/public/xz_0.png")
        GUI:CheckBox_setSelected(checkBox, false)
        local checkLabel = GUI:Text_Create(bg, "skip_label", 140, 44 + 10, 18, "#FFFFFF", "本次不再提示")
        GUI:setAnchorPoint(checkLabel, 0, 0.5)
        GUI:Text_enableOutline(checkLabel, "#000000", 1)
        
        GUI:setTouchEnabled(checkLabel, true)
        GUI:addOnClickEvent(checkLabel, function()
            local selected = not GUI:CheckBox_isSelected(checkBox)
            GUI:CheckBox_setSelected(checkBox, selected)
        end)
        local cancelBtn = GUI:Button_Create(bg, "cancel_btn", 95, 9, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(cancelBtn, 0.5, 0)
        GUI:Button_setTitleText(cancelBtn, "取消")
        GUI:Button_setTitleFontSize(cancelBtn, 18)
        GUI:addOnClickEvent(cancelBtn, function()
            close_confirm()
        end)
        local confirmBtn = GUI:Button_Create(bg, "confirm_btn", 285, 9, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(confirmBtn, 0.5, 0)
        GUI:Button_setTitleText(confirmBtn, "确定")
        GUI:Button_setTitleFontSize(confirmBtn, 18)
        GUI:addOnClickEvent(confirmBtn, function()
            npc._xf_skip_lingshi_confirm = GUI:CheckBox_isSelected(checkBox)
            close_confirm()
            _send_normal_xianfa_refresh(slot)
        end)
    end
    local function _try_refresh_xianfa(slot)
        local function _refresh_without_best_token()
            if _get_item_count("仙法卷轴") > 0 then
                _send_normal_xianfa_refresh(slot)
                return
            end
            if npc._xf_skip_lingshi_confirm then
                _send_normal_xianfa_refresh(slot)
                return
            end
            _open_lingshi_refresh_confirm(slot)
        end
        if checkItemNum({{"极品仙法卷轴",1}}) then
            SL:OpenCommonTipsPop({str="是否要使用极品仙法卷轴，必可得到帝品仙法！",btnType=2,callback=function(atype,param)
                if atype == 1 then
                    SL:SendLuaNetMsg(100, npcid, 2, 2, SL:JsonEncode({caowei = slot}))
                else
                    _refresh_without_best_token()
                end
            end})
            return
        end
        _refresh_without_best_token()
    end
    local function _has_any_xianfa_equipped()
        local T_data = npc.data and npc.data.T_data or {}
        local caowei = T_data.caowei or {}
        for i = 1, 10 do
            if type(caowei[tostring(i)]) == "table" then
                return true
            end
        end
        return false
    end
    local function _get_default_tianshu_tab()
        local taskName = tostring(rawget(_G, "XYL_CURRENT_TASK_NAME") or "")
        SL:release_print("当前任务", taskName)
        if taskName == "初识仙法" or taskName == "查看仙法" or taskName == "进行天书仙法抽取" then
            return 2
        end
        local tianshuLevel = tonumber(npc.data and npc.data.T_data and npc.data.T_data.level or 0) or 0
        if tianshuLevel >= 1 and not _has_any_xianfa_equipped() then
            return 2
        end
        return 1
    end
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
                GUI:Effect_Create(Label_node, "eff", 400, 360, 0, 60449)
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
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",215,-2, 20, "##109C18", new_config and ("+"..new_config.attr[k.idx][2]) or "已满级")
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
                            NPC_UI_HELPER.tryStartXylGuide(npc, Button, Label_node, "tianshu_upgrade", {
                                taskNames = {"天书强化", "进行天书强化1次"},
                                dir = 5,
                                desc = "点击强化天书",
                            })
                        end
                    else
                        GUI:Image_Create(Label_node, "Button", 660, 100.00, "res/wy/public/15.png")
                    end
                end
                local tip = GUI:Image_Create(Label_node, "tip", 380 + 500, 350 - 187, "res/wy/public/xqh_tip.png")
                if SL:GetMetaValue("WINPLAYMODE") then
                    GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                        local pos = GUI:getWorldPosition(tip)
                        SL:OpenItemTips({itemData = item,pos = {x = pos.x, y = pos.y}})
                    end, onLeaveFunc = function()
                        SL:CloseItemTips()
                    end})
                else
                    GUI:setTouchEnabled(tip, true)
                    GUI:addOnTouchEvent(tip, function(self)
                        local pos = GUI:getWorldPosition(tip)
                        SL:OpenItemTips({itemData = item,pos = {x = pos.x, y = pos.y}})
                    end)
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
                local xianfa_all_unlock = tonumber(npc.data and npc.data.xianfa_all_unlock or 0) == 1
                local label_delegate = GUI:ui_delegate(Label_node)
                local layout_delegate = GUI:ui_delegate(dbLayout)
                local function is_slot_unlocked(slot, slot_data)
                    if slot_data then
                        return true
                    end
                    if xianfa_all_unlock then
                        return true
                    end
                    local need_lv = unlock_lv[slot] or 1
                    return cur_lv >= need_lv
                end
                local function get_slot_info(slot, slot_data)
                    if slot_data then
                        local group = slot_data[1]
                        local idx2 = slot_data[2]
                        local info = cfg_details[group] and cfg_details[group][idx2]
                        if info then
                            return info.name, level_coler[group] or "#FFFFFF", info.wz
                        end
                    end
                    if xianfa_all_unlock then
                        return "已解锁", "#00FF00", nil
                    end
                    local need_lv = unlock_lv[slot] or 1
                    if cur_lv >= need_lv then
                        return "已解锁", "#00FF00", nil
                    end
                    return "解锁需天书等级："..need_lv, "#A0A0A4", nil
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
                        GUI:setAnchorPoint(GUI:Image_Create(npc.xf_node, "wz5", 30 + 549, 16 + 480 + 50, "res/custom/tianshu/xf/l_"..slot_data[1]..".png")
                        , 0, 1)
                        GUI:setAnchorPoint(GUI:RichText_Create(npc.xf_node, "attr_desc_next", 50 + 549 + 60,16 + 480,  wz, 310 - 40, 17, level_coler[slot_data[1]], 3,nil,nil)
                        , 0, 1)
                    else
                        local text = nil
                        local color = "#A0A0A4"
                        if xianfa_all_unlock then
                            text = "已解锁"
                            color = "#00FF00"
                        else
                            local need_lv = unlock_lv[slot] or 1
                            if cur_lv >= need_lv then
                                text = "已解锁"
                                color = "#00FF00"
                            else
                                text = "解锁天书等级："..need_lv
                            end
                        end
                        -- 未解锁提示改为居中显示，避免与左侧信息区重叠。
                        local lockText = GUI:Text_Create(npc.xf_node, "wz5", 50 + 549 + 155, 16 + 480 - 12, 20, color, text)
                        GUI:setAnchorPoint(lockText, 0.5, 0.5)
                        GUI:Text_enableOutline(lockText, "#000000", 1)
                    end
                    local guang = GUI:Image_Create(npc.xf_node, "cost_once_value_img", 50 + 549 + 70, 150, "res/wy/public/guang.png")
                    GUI:setContentSize(guang, 180, 30)
                    GUI:setContentSize(GUI:Image_Create(guang, "img1", 0, 0, "res/wy/public/input.png"), 180, 30)
                    GUI:setContentSize(GUI:Image_Create(guang, "img2", 0, 0, "res/wy/public/jdtk_1.png"), 100, 30)
                    GUI:Text_Create(guang, "text", 5, 5, 18, "#FFFFFF", "刷新消耗：")
                    GUI:setScale(GUI:ItemShow_Create(guang, "icon",105, 5, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙法卷轴")}), 0.6)
                    local currentTokenCount = SL:GetMetaValue("ITEM_COUNT", SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙法卷轴"))
                    local drawOnceCost = 1
                    local currentTokenColor = currentTokenCount >= drawOnceCost and "#45ff93" or "#ff6666"
                    GUI:RichText_Create(guang, "num", 130, 5, string.format("<font color='%s'>%s</font><font color='#FFFFFF'>/%s</font>", currentTokenColor, tostring(currentTokenCount), tostring(drawOnceCost)), 150, 16, "#FFFFFF", 0, nil, nil)
                    -- 第一次抽取默认不跳过；首次动画展示完成后默认勾选跳过动画。
                    if npc._xf_skip_anim == nil then
                        npc._xf_skip_anim = _get_xianfa_skip_anim_default()
                    end
                    local skipLabel = GUI:Text_Create(npc.xf_node, "skip_label", 50 + 549 + 20, 52 + 18 + 50, 18, "#FFFFFF", "跳过动画")
                    GUI:Text_enableOutline(skipLabel, "#000000", 1)
                    local skipCheck = GUI:CheckBox_Create(npc.xf_node, "skip_anim", 50 + 549 + 140 - 40, 53 + 18 + 52, "res/wy/public/xz_1.png", "res/wy/public/xz_0.png")
                    GUI:CheckBox_setSelected(skipCheck, npc._xf_skip_anim)
                    GUI:CheckBox_addOnEvent(skipCheck, function(sender)
                        npc._xf_skip_anim = GUI:CheckBox_isSelected(sender)
                        _set_xianfa_skip_anim_default(npc._xf_skip_anim)
                    end)
                    local Button = GUI:Button_Create(npc.xf_node, "Button", 50 + 549 + 76 + 80,80, "res/custom/tianshu/xf/btn_up.png")
                    local slot_unlocked = is_slot_unlocked(slot, slot_data)
                    if not slot_unlocked then
                        GUI:setOpacity(Button, 120)
                        GUI:setTouchEnabled(Button, false)
                    end
                    -- if checkItemNum({{"极品仙法卷轴",1}}) then
                    --     NPC_UI_HELPER.redpoint_create(Button)
                    -- end
                    local function do_refresh()
                        _try_refresh_xianfa(slot)
                    end
                    GUI:addOnClickEvent(Button, function()
                        if not slot_unlocked then
                            return
                        end
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
                    NPC_UI_HELPER.tryStartXylGuide(npc, Button, npc.xf_node, "tianshu_xianfa_" .. tostring(slot), {
                        idx = 1,
                        once = true,
                        taskNames = {"初识仙法", "进行天书仙法抽取"},
                        dir = 5,
                        desc = "点击刷新仙法",
                    })
                end
                for i = 1, 10 do
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..i, 0, 0, "res/custom/tianshu/xf/k_0.png")
                    GUI:setTouchEnabled(kuang, true)
                    GUI:addOnClickEvent(kuang, function()
                        -- 未解锁槽位仅展示锁定状态，不允许切换右侧详情与刷新入口。
                        if not is_slot_unlocked(i, caowei[""..i]) then
                            SL:ShowSystemTips("该仙法槽位尚未解锁")
                            return
                        end
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
                -- 默认选中第一个已解锁槽位，避免首次打开时落在未解锁格子上。
                if not npc.xf_sign or not is_slot_unlocked(npc.xf_sign, caowei[""..npc.xf_sign]) then
                    npc.xf_sign = nil
                    for slot = 1, 10 do
                        if is_slot_unlocked(slot, caowei[""..slot]) then
                            npc.xf_sign = slot
                            break
                        end
                    end
                end
                if npc.xf_sign and npc.xf_sign >= 1 and npc.xf_sign <= 10 then
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
        npc.titles_sign = tonumber(npc.titles_sign) or _get_default_tianshu_tab()
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
        npc.titles_sign = nil
        npc._xf_skip_lingshi_confirm = false
        npc._xf_skip_anim = _get_xianfa_skip_anim_default()
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
        if NPC_UI_HELPER.isCurrentXylTask({"天书强化", "进行天书强化1次"})
            and (tonumber(npc.data and npc.data.T_data and npc.data.T_data.level or 0) or 0) >= 1 then
            NPC_UI_HELPER.closeWindow(npc._window)
        end
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label,npc.titles_sign)
    elseif p2 == 10 then
        local data = SL:JsonDecode(msgData,false)
        local parent = GUI:GetWindow(nil, "xf_xjm")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("xf_xjm", 0, 0, 0, 0, false, false, true, true, true, nil, 24)
        end
        npc._xf_skip_anim = npc._xf_skip_anim == true
        local startFrame = npc._xf_skip_anim and 104 or 1
        local endFrame = 158
        local function close_popup()
            GUI:Win_Close(parent)
        end
        local function do_refresh_current_slot()
            local slot = tonumber(npc.xf_sign) or 1
            _try_refresh_xianfa(slot)
        end
        local overlay = GUI:Image_Create(parent, 'bjt', 0, 0, 'res/public/1900000651_1.png')
        GUI:setAnchorPoint(overlay, 0.5, 0.5)
        GUI:setContentSize(overlay, (cogin.w + 100), (cogin.h + 100))
        GUI:setTouchEnabled(overlay, true)
        local bg = GUI:Frames_Create(parent, "bg", cogin.w/2,  cogin.h/2, "res/custom/tianshu/xf/eff/eff_", ".png", startFrame, endFrame,
                { speed = 50, count = 158, loop = 1,callback = function(self)
                    if startFrame == 1 then
                        npc._xf_skip_anim = true
                        _set_xianfa_skip_anim_default(true)
                    end
                    local tit = GUI:Image_Create(parent, "tit", 150, cogin.h/2, "res/custom/tianshu/xf/l_".. data.group ..".png")
                    GUI:setAnchorPoint(tit, 0.5, 0.5)
                    GUI:setOpacity(tit, 0)
                    GUI:Timeline_FadeIn(tit, 1,nil)
                    local cfg = npc._config.details[2]
                    local cfg_details = cfg.details
                    local info = cfg_details[data.group] and cfg_details[data.group][data.idx]
                    -- info.name, level_coler[group] or "#FFFFFF", info.wz
                    local name = GUI:Text_Create(parent, "name", cogin.w/2,  cogin.h/2 + 30, 50, level_coler[data.group] or "#FFFFFF", info.name)
                    GUI:setAnchorPoint(name, 0.5, 0)
                    GUI:Text_setFontName(name, "fonts/448.ttf")
                    GUI:Text_enableOutline(name, "#000000", 2)
                    GUI:setOpacity(name, 0)
                    GUI:Timeline_FadeIn(name, 1,nil)
                    local attr_desc = GUI:RichText_Create(parent, "attr_desc", cogin.w/2,  cogin.h/2,  info.wz, 310, 17, "#f7f7de", 3,nil,nil)
                    GUI:setAnchorPoint(attr_desc, 0.5, 1)
                    GUI:setOpacity(attr_desc, 0)
                    GUI:Timeline_FadeIn(attr_desc, 1,nil)
                    local skipLabel = GUI:Text_Create(parent, "skip_label", cogin.w/2 - 60, 80, 20, "#FFFFFF", "跳过动画")
                    GUI:Text_enableOutline(skipLabel, "#000000", 1)
                    local skipCheck = GUI:CheckBox_Create(parent, "skip_anim", cogin.w/2 + 75, 80, "res/wy/public/xz_1.png", "res/wy/public/xz_0.png")
                    GUI:CheckBox_setSelected(skipCheck, npc._xf_skip_anim)
                    GUI:CheckBox_addOnEvent(skipCheck, function(sender)
                        npc._xf_skip_anim = GUI:CheckBox_isSelected(sender)
                        _set_xianfa_skip_anim_default(npc._xf_skip_anim)
                    end)
                    local knowBtn = GUI:Button_Create(parent, "know_btn", cogin.w/2 - 110, 150, "res/wy/public/kb_btn.png")
                    GUI:setAnchorPoint(knowBtn, 0.5, 0)
                    GUI:Button_setTitleText(knowBtn, "我知道了")
                    GUI:Button_setTitleFontSize(knowBtn, 18)
                    GUI:setLocalZOrder(knowBtn, 100)
                    GUI:addOnClickEvent(knowBtn, function()
                        close_popup()
                    end)
                    local refreshBtn = GUI:Button_Create(parent, "refresh_btn", cogin.w/2 + 110, 150, "res/wy/public/kb_btn.png")
                    GUI:setAnchorPoint(refreshBtn, 0.5, 0)
                    GUI:Button_setTitleText(refreshBtn, "再次刷新")
                    GUI:Button_setTitleFontSize(refreshBtn, 18)
                    GUI:setLocalZOrder(refreshBtn, 100)
                    GUI:addOnClickEvent(refreshBtn, function()
                        close_popup()
                        do_refresh_current_slot()
                    end)
                end})
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setTouchEnabled(bg, true)
    end
end
return npc
