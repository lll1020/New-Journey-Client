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
local XIANFA_ATLAS_QUALITY_NAME = {
    [1] = "凡品",
    [2] = "优品",
    [3] = "仙品",
    [4] = "圣品",
    [5] = "极品",
}
local XIANFA_SKIP_ANIM_KEY = "tianshu_xianfa_skip_anim"
local function _ts_is_look_player()
    return npc.isLookPlayer == true
end
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
    local function _ts_normalize_payload(data)
        data = type(data) == "table" and data or {}
        if type(data.T_data) ~= "table" then
            local raw = {}
            for k, v in pairs(data) do
                if k ~= "lookPlayer" and k ~= "xianfa_all_unlock" then
                    raw[k] = v
                end
            end
            data = {
                T_data = raw,
                lookPlayer = data.lookPlayer,
                xianfa_all_unlock = data.xianfa_all_unlock,
            }
        end
        data.T_data = type(data.T_data) == "table" and data.T_data or {}
        data.T_data.caowei = type(data.T_data.caowei) == "table" and data.T_data.caowei or {}
        data.T_data.wangshi = type(data.T_data.wangshi) == "table" and data.T_data.wangshi or {}
        return data
    end
    local function _get_item_count(itemName)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if not itemIndex or itemIndex <= 0 then
            return 0
        end
        return tonumber(SL:GetMetaValue("ITEM_COUNT", itemIndex) or 0) or 0
    end
    local function _send_normal_xianfa_refresh(slot)
        if _ts_is_look_player() then
            return
        end
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
        if _ts_is_look_player() then
            return
        end
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
    local function _xianfa_atlas_tip(widget, info, quality, owned)
        if not widget or not info then
            return
        end
        local qualityName = XIANFA_ATLAS_QUALITY_NAME[quality] or "仙法"
        local stateText = owned and "<font color='#45FF93'>已获得</font>" or "<font color='#A0A0A0'>未获得</font>"
        local desc = string.format(
            "<font color='%s' size='20'>%s</font><font color='#F4D179'>（%s）</font>\n%s\n<font color='#FFFFFF'>%s</font>",
            level_coler[quality] or "#FFFFFF",
            tostring(info.name or ""),
            qualityName,
            stateText,
            tostring(info.wz or "")
        )
        local pos = GUI:getWorldPosition(widget)
        SL:OpenCommonDescTipsPop({
            str = desc,
            worldPos = {x = pos.x, y = pos.y},
            anchorPoint = {x = 0, y = 0},
            formatWay = 1
        })
    end
    local function _xianfa_bind_atlas_tip(widget, info, quality, owned)
        GUI:setTouchEnabled(widget, true)
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(widget, {
                onEnterFunc = function()
                    _xianfa_atlas_tip(widget, info, quality, owned)
                end,
                onLeaveFunc = function()
                    SL:CloseCommonDescTipsPop()
                end
            })
        else
            GUI:addOnTouchEvent(widget, function()
                _xianfa_atlas_tip(widget, info, quality, owned)
            end)
        end
    end
    local function _open_xianfa_atlas()
        local parent = GUI:GetWindow(nil, "tianshu_xianfa_atlas")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("tianshu_xianfa_atlas", 0, 0, 0, 0, false, false, true, true, true, nil, 120)
        end
        local function close_atlas()
            SL:CloseCommonDescTipsPop()
            GUI:Win_Close(parent)
        end
        local overlay = GUI:Image_Create(parent, "overlay", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(overlay, 0.5, 0.5)
        GUI:setContentSize(overlay, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(overlay, true)
        GUI:addOnClickEvent(overlay, close_atlas)

        local bg = GUI:Image_Create(parent, "bg", cogin.w / 2, cogin.h / 2, "res/custom/tianshu/tj/xbg.png")
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setTouchEnabled(bg, true)
        local closeBtn = GUI:Button_Create(bg, "close_btn", 724, 330 + 80, "res/wy/public/close_red_big.png")
        GUI:setAnchorPoint(closeBtn, 0.5, 0.5)
        GUI:addOnClickEvent(closeBtn, close_atlas)

        local quality = tonumber(npc._xianfa_atlas_quality or 1) or 1
        local function render_content()
            GUI:removeChildByName(bg, "content_node")
            local content = GUI:Node_Create(bg, "content_node", 0, 0)
            npc._xianfa_atlas_quality = quality
            for i = 1, 5 do
                local btn = GUI:Button_Create(content, "quality_btn_" .. i, 60 + (i - 1) * 132, 347, "res/custom/tianshu/tj/up_btn/btn_" .. i .. ".png")
                GUI:setOpacity(btn, quality == i and 255 or 170)
                GUI:addOnClickEvent(btn, function()
                    if quality == i then
                        return
                    end
                    quality = i
                    npc._xianfa_atlas_page = 1
                    render_content()
                end)
            end

            local cfg = npc._config.details[2]
            local details = cfg and cfg.details and cfg.details[quality] or {}
            local T_data = npc.data and npc.data.T_data or {}
            local tj = T_data.tj or {}
            local ownedMap = {}
            for key, value in pairs(tj) do
                if value == 1 or value == true then
                    ownedMap[tostring(key)] = true
                end
            end
            for _, value in pairs(T_data.caowei or {}) do
                if type(value) == "table" and value[1] and value[2] then
                    ownedMap[tostring(value[1]) .. "_" .. tostring(value[2])] = true
                end
            end
            local ownedCount = 0
            for idx2, _ in ipairs(details) do
                if ownedMap[quality .. "_" .. idx2] then
                    ownedCount = ownedCount + 1
                end
            end

            local pageSize = 8
            local pageCount = math.max(1, math.ceil(#details / pageSize))
            local page = math.max(1, math.min(tonumber(npc._xianfa_atlas_page or 1) or 1, pageCount))
            npc._xianfa_atlas_page = page
            local listNode = GUI:Layout_Create(content, "list_node", 58, 94, 648, 236, false)

            for slot = 1, pageSize do
                local idx2 = (page - 1) * pageSize + slot
                local info = details[idx2]
                if not info then
                    break
                end
                local col = (slot - 1) % 4
                local row = math.floor((slot - 1) / 4)
                local x = col * 162
                local y = 106 - row * (112 + 40)
                local item = GUI:Image_Create(listNode, "atlas_item_" .. idx2, x, y, "res/custom/tianshu/tj/item_kuang.png")
                
                local owned = ownedMap[quality .. "_" .. idx2] == true
                local title = GUI:Image_Create(item, "title", 7, 146, "res/custom/tianshu/tj/title/title_" .. quality .. ".png")
                GUI:setAnchorPoint(title, 0, 1)
                local iconPath = tostring(info.icon or "")
                if iconPath ~= "" then
                    local icon = GUI:Image_Create(item, "xianfa_icon", 81, 78 + 13, iconPath)
                    GUI:setTouchEnabled(icon, true)
                    _xianfa_bind_atlas_tip(icon, info, quality, owned)
                    GUI:setAnchorPoint(icon, 0.5, 0.5)
                end
                local name = GUI:Text_Create(item, "name", 84, 23 + 110, 17, level_coler[quality] or "#FFFFFF", tostring(info.name or "未知仙法"))
                GUI:setAnchorPoint(name, 0.5, 0.5)
                GUI:Text_enableOutline(name, "#000000", 1)
                local statusColor = owned and "#45FF93" or "#FF6B6B"
                local statusText = owned and "已激活" or "未激活"
                local statusBg = GUI:Image_Create(item, "status_bg", 84, 34, "res/wy/public/input.png")
                GUI:setAnchorPoint(statusBg, 0.5, 0.5)
                GUI:setContentSize(statusBg, 118, 26)
                GUI:setOpacity(statusBg, 95)
                local status = GUI:Text_Create(item, "status", 84, 34, 18, statusColor, statusText)
                GUI:setAnchorPoint(status, 0.5, 0.5)
                GUI:Text_setFontName(status, "fonts/502.ttf")
                GUI:Text_enableOutline(status, "#000000", 1)
                
            end

            -- GUI:Image_Create(content, "bottom_tip", 51 - 60 + 9, -14, "res/custom/tianshu/tj/img.png")
            -- local allText = GUI:Text_Create(content, "all_text", 80, 38, 18, "#FFFFFF", "本图鉴全部点亮可获得：")
            -- GUI:Text_enableOutline(allText, "#000000", 1)
            -- local progressText = GUI:Text_Create(content, "progress_text", 80, 14, 18, "#FFFFFF", string.format("当前已获得仙法：%d/%d", ownedCount, #details))
            -- GUI:Text_enableOutline(progressText, "#000000", 1)
            local prevBtn = GUI:Button_Create(content, "prev_page", 504 - 80, 25, "res/wy/public/kb_btn.png")
            GUI:setAnchorPoint(prevBtn, 0.5, 0.5)
            GUI:Button_setTitleText(prevBtn, "上一页")
            GUI:Button_setTitleFontSize(prevBtn, 16)
            GUI:Button_titleEnableOutline(prevBtn, "#000000", 1)
            GUI:Button_setGrey(prevBtn, page <= 1)
            GUI:addOnClickEvent(prevBtn, function()
                if page <= 1 then
                    return
                end
                npc._xianfa_atlas_page = page - 1
                render_content()
            end)
            local pageText = GUI:Text_Create(content, "page_text", 596 - 80, 25, 18, "#FFFFFF", string.format("%d/%d", page, pageCount))
            GUI:setAnchorPoint(pageText, 0.5, 0.5)
            GUI:Text_enableOutline(pageText, "#000000", 1)
            local nextBtn = GUI:Button_Create(content, "next_page", 688 - 80, 25, "res/wy/public/kb_btn.png")
            GUI:setAnchorPoint(nextBtn, 0.5, 0.5)
            GUI:Button_setTitleText(nextBtn, "下一页")
            GUI:Button_setTitleFontSize(nextBtn, 16)
            GUI:Button_titleEnableOutline(nextBtn, "#000000", 1)
            GUI:Button_setGrey(nextBtn, page >= pageCount)
            GUI:addOnClickEvent(nextBtn, function()
                if page >= pageCount then
                    return
                end
                npc._xianfa_atlas_page = page + 1
                render_content()
            end)
        end
        render_content()
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
        local rwid = tonumber(cogin and cogin.sjtb and (cogin.sjtb.zxrwid or cogin.sjtb.rwid) or 0) or 0
        if rwid == 18 or taskName == "初识仙法" or taskName == "查看仙法" or taskName == "天书仙法" or taskName == "进行天书仙法抽取" then
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
            npc.data = _ts_normalize_payload(npc.data)
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
                    -- if (tonumber(npc.data.T_data.level or 0) or 0) >= 20 then
                    --     local echoLines = {"<font color='#F4D179'>灵根回响共鸣：</font>"}
                    --     for _, cfg in ipairs(((teshudata["npc_22"] or {}).main_r or {})) do
                    --         if cfg.echo_name and cfg.echo_desc then
                    --             echoLines[#echoLines + 1] = string.format("<font color='#A7D58D'>%s</font><font color='#FFFFFF'>：%s</font>", tostring(cfg.echo_name), tostring(cfg.echo_desc))
                    --         end
                    --     end
                    --     GUI:RichText_Create(Label_node, "linggen_echo", 120, 420, table.concat(echoLines, "\n"), 360, 18, "#f7f7de", 1, nil, nil, {outlineSize = 1, outlineColor = SL:ConvertColorFromHexString("#100808")})
                    -- end
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
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 20, "#00FFFF", k.attr_name.." +")
                        , "fonts/502.ttf")
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",125,-2, 20, "#00FFFF", old_config and old_config.attr[k.idx][2] or 0)
                        , "fonts/502.ttf")
                        GUI:Image_Create(kuang, "jt", 170, -2, "res/custom/tianshu/qh/jt.png")
                        GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",215,-2, 20, "#109C18", new_config and ("+"..new_config.attr[k.idx][2]) or "已满级")
                        , "fonts/502.ttf")
                        GUI:Image_Create(kuang, "up", 290, 3, "res/custom/tianshu/qh/up.png")
                    end
                    GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})
                    GUI:setAnchorPoint(dbLayout, 0, 1)
                    npc.data.T_data.level = npc.data.T_data.level or 0
                    if npc.data.T_data.level < npc._config.details[1].max_level and not _ts_is_look_player() then
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
                            NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, Label_node, npcid, "tianshu_upgrade", {
                                taskMap = {[npcid] = 17},
                                keyPrefix = "mainline_tianshu_upgrade",
                                dir = 5,
                                desc = "点击强化天书",
                            })
                        end
                    elseif not _ts_is_look_player() then
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
                local unlock_cond = cfg.unlock_cond or {}
                local cur_lv = npc.data.T_data.level or 0
                local xianfa_all_unlock = tonumber(npc.data and npc.data.xianfa_all_unlock or 0) == 1
                local label_delegate = GUI:ui_delegate(Label_node)
                local layout_delegate = GUI:ui_delegate(dbLayout)
                local function get_actor_level()
                    return tonumber(SL:GetMetaValue("LEVEL") or SL:GetMetaValue("ACTOR_LEVEL") or SL:GetMetaValue("ACTOR_LEVEL", SL:GetMetaValue("MAIN_ACTOR_ID")) or 0) or 0
                end
                local function has_title(title)
                    if not title or title == "" then
                        return false
                    end
                    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", title)
                    return idx and SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil
                end
                local function get_slot_unlock_state(slot, slot_data)
                    if slot_data then
                        return true, "已解锁"
                    end
                    if xianfa_all_unlock then
                        return true, "已解锁"
                    end
                    local cond = unlock_cond[slot]
                    if not cond then
                        local need_lv = cfg.unlock_lv and cfg.unlock_lv[slot] or 1
                        return cur_lv >= need_lv, "天书等级"..need_lv.."级"
                    end
                    if cond.kind == "free" then
                        return true, cond.desc or "免费解锁"
                    elseif cond.kind == "level" then
                        local lv = tonumber(cond.level) or 0
                        return get_actor_level() >= lv, cond.desc or ("玩家等级Lv"..lv)
                    elseif cond.kind == "story" then
                        return has_title(cond.title), cond.desc or "完成指定剧情任务"
                    elseif cond.kind == "tianshu" then
                        local lv = tonumber(cond.level) or 0
                        return cur_lv >= lv, cond.desc or ("天书等级"..lv.."级")
                    end
                    return false, cond.desc or "未满足解锁条件"
                end
                local function is_slot_unlocked(slot, slot_data)
                    local unlocked = get_slot_unlock_state(slot, slot_data)
                    return unlocked
                end
                local function get_slot_info(slot, slot_data)
                    if slot_data then
                        local group = slot_data[1]
                        local idx2 = slot_data[2]
                        local info = cfg_details[group] and cfg_details[group][idx2]
                        if info then
                            return info.name, level_coler[group] or "#FFFFFF", info.wz, info
                        end
                    end
                    local unlocked, desc = get_slot_unlock_state(slot, slot_data)
                    if unlocked then
                        return "已解锁", "#00FF00", nil
                    end
                    return "解锁需："..desc, "#A0A0A4", nil
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
                        local group = slot_data[1]
                        local idx2 = slot_data[2]
                        local info = cfg_details[group] and cfg_details[group][idx2] or {}
                        local detailX = 50 + 549
                        local detailTop = 16 + 480
                        GUI:setAnchorPoint(GUI:Image_Create(npc.xf_node, "quality_deco", detailX - 18, detailTop + 22, "res/custom/tianshu/xf/l_"..group..".png"), 0, 1)
                        local iconBox = GUI:Image_Create(npc.xf_node, "xianfa_icon_box", detailX + 62, detailTop - 8, "res/wy/public/70_70_k.png")
                        GUI:setAnchorPoint(iconBox, 0, 1)
                        GUI:setContentSize(iconBox, 58, 58)
                        local iconPath = tostring(info.icon or "")
                        if iconPath ~= "" then
                            local icon = GUI:Image_Create(iconBox, "xianfa_icon", 29, 29, iconPath)
                            GUI:setAnchorPoint(icon, 0.5, 0.5)
                            GUI:setContentSize(icon, 42, 42)
                        end
                        local nameText = GUI:Text_Create(npc.xf_node, "xianfa_name", detailX + 128, detailTop - 28, 22, level_coler[group] or "#FFFFFF", tostring(info.name or "未知仙法"))
                        GUI:setAnchorPoint(nameText, 0, 0.5)
                        GUI:Text_setFontName(nameText, "fonts/502.ttf")
                        GUI:Text_enableOutline(nameText, "#100808", 2)
                        local descBg = GUI:Image_Create(npc.xf_node, "xianfa_desc_bg", detailX + 62, detailTop - 74, "res/wy/public/input.png")
                        GUI:setAnchorPoint(descBg, 0, 1)
                        GUI:setContentSize(descBg, 266, 88)
                        GUI:setOpacity(descBg, 70)
                        GUI:setAnchorPoint(GUI:RichText_Create(npc.xf_node, "attr_desc_next", detailX + 74, detailTop - 84, tostring(wz or ""), 246, 18, level_coler[group] or "#FFFFFF", 1,nil,nil), 0, 1)
                    else
                        local text = nil
                        local color = "#A0A0A4"
                        local unlocked, desc = get_slot_unlock_state(slot, slot_data)
                        if unlocked then
                            text = "已解锁"
                            color = "#00FF00"
                        else
                            text = "解锁需："..desc
                        end
                        -- 未解锁提示改为居中显示，避免与左侧信息区重叠。
                        local lockText = GUI:Text_Create(npc.xf_node, "wz5", 50 + 549 + 155, 16 + 480 - 12, 20, color, text)
                        GUI:setAnchorPoint(lockText, 0.5, 0.5)
                        GUI:Text_enableOutline(lockText, "#000000", 1)
                    end
                    local atlasBtn = GUI:Button_Create(npc.xf_node, "Button_chat_1", 50 + 549,80, "res/custom/tianshu/xf/btn_tj.png")
                    GUI:addOnClickEvent(atlasBtn, function()
                        _open_xianfa_atlas()
                    end)
                    if not _ts_is_look_player() then
                        local guang = GUI:Image_Create(npc.xf_node, "cost_once_value_img", 50 + 549 + 150 - 8, 150, "res/wy/public/guang.png")
                        GUI:setContentSize(guang, 180, 30)
                        GUI:setContentSize(GUI:Image_Create(guang, "img1", 0, 0, "res/wy/public/input.png"), 180, 30)
                        GUI:setContentSize(GUI:Image_Create(guang, "img2", 0, 0, "res/wy/public/jdtk_1.png"), 100, 30)
                        GUI:Text_Create(guang, "text", 5, 5, 18, "#FFFFFF", "刷新消耗：")
                        GUI:setScale(GUI:ItemShow_Create(guang, "icon",105, 5, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙法卷轴")}), 0.6)
                        local currentTokenCount = SL:GetMetaValue("ITEM_COUNT", SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙法卷轴"))
                        local drawOnceCost = 1
                        local currentTokenColor = currentTokenCount >= drawOnceCost and "#45ff93" or "#ff6666"
                        GUI:RichText_Create(guang, "num", 130, 5, string.format("<font color='%s'>%s</font><font color='#FFFFFF'>/%s</font>", currentTokenColor, tostring(currentTokenCount), tostring(drawOnceCost)), 150, 16, "#FFFFFF", 0, nil, nil)
                        if npc._xf_skip_anim == nil then
                            npc._xf_skip_anim = _get_xianfa_skip_anim_default()
                        end
                        local skipLabel = GUI:Text_Create(npc.xf_node, "skip_label", 50 + 549 + 20 - 8, 52 + 18 + 50 + 33, 18, "#FFFFFF", "跳过动画")
                        GUI:Text_enableOutline(skipLabel, "#000000", 1)
                        local skipCheck = GUI:CheckBox_Create(npc.xf_node, "skip_anim", 50 + 549 + 140 - 40 - 8, 53 + 18 + 52 + 33, "res/wy/public/xz_1.png", "res/wy/public/xz_0.png")
                        GUI:CheckBox_setSelected(skipCheck, npc._xf_skip_anim)
                        GUI:CheckBox_addOnEvent(skipCheck, function(sender)
                            npc._xf_skip_anim = GUI:CheckBox_isSelected(sender)
                            _set_xianfa_skip_anim_default(npc._xf_skip_anim)
                        end)
                        local Button = GUI:Button_Create(npc.xf_node, "Button", 50 + 549 + 76 + 80 + 5,80, "res/custom/tianshu/xf/btn_up.png")
                        local slot_unlocked = is_slot_unlocked(slot, slot_data)
                        if not slot_unlocked then
                            GUI:setOpacity(Button, 120)
                            GUI:setTouchEnabled(Button, false)
                        end
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
                            taskNames = {"初识仙法", "天书仙法", "进行天书仙法抽取"},
                            dir = 5,
                            desc = "点击刷新仙法",
                        })
                        NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, npc.xf_node, npcid, "tianshu_xianfa_" .. tostring(slot), {
                            taskMap = {[npcid] = 18},
                            keyPrefix = "mainline_tianshu_xianfa",
                            dir = 5,
                            desc = "点击刷新仙法",
                            idx = 1,
                        })
                    end
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
                local function build_wangshi_desc(config, values)
                    local args = {}
                    for n, v in ipairs(values or {}) do
                        local color = n == 1 and "#56F4FF" or "#FFD45A"
                        args[n] = string.format("<font color='%s'>%s</font>", color, tostring(v or ""))
                    end
                    return string.format(config.desc, unpack(args))
                end
                local function render_wangshi_title(parent, name, text)
                    local title = GUI:Text_Create(parent, name, 156, 118, 21, "#FFD45A", "[ " .. text .. " ]")
                    GUI:setAnchorPoint(title, 0.5, 0.5)
                    GUI:Text_setFontName(title, "fonts/502.ttf")
                    GUI:Text_enableOutline(title, "#100808", 3)
                    return title
                end
                for i = 1, #npc._config.details[3] do
                    local config = npc._config.details[3][i]
                    local kuang = GUI:Image_Create(dbLayout, "kuang"..i, 0, 0, "res/custom/tianshu/ws/xnj_bg.png")
                    render_wangshi_title(kuang, "name", config.name)
                    local line = GUI:Text_Create(kuang, "line", 156, 96, 16, "#8A5A22", "----------------")
                    GUI:setAnchorPoint(line, 0.5, 0.5)
                    GUI:Text_enableOutline(line, "#100808", 1)
                    if npc.data.T_data.wangshi[""..i] then
                        local html = build_wangshi_desc(config, npc.data.T_data.wangshi[""..i])
                        local desc = GUI:RichText_Create(kuang, "desc", 22, 82, html, 270, 17, "#FFF2B0", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                        GUI:setAnchorPoint(desc, 0, 1)
                    else
                        local desc = GUI:RichText_Create(kuang, "desc", 22, 82, "<font color='#8D8D8D'>尚未解锁，完成对应事件后记录天书往事</font>", 270, 17, "#8D8D8D", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                        GUI:setAnchorPoint(desc, 0, 1)
                    end
                end
                GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=10}})
            end
        end
        local tabOrder = _ts_is_look_player() and {2, 3} or {1, 2, 3}
        npc.titles_sign = tonumber(npc.titles_sign) or _get_default_tianshu_tab()
        if _ts_is_look_player() and npc.titles_sign ~= 2 and npc.titles_sign ~= 3 then
            npc.titles_sign = 2
        end
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)
        for displayIndex, tabId in ipairs(tabOrder) do
            local cbl_item = GUI:Frames_Create(node, "item" .. tabId, 100+(displayIndex-1)*170, -20, "res/custom/tianshu/"..titles[tabId].."/btn_", ".png", 1, 15,
            { speed = 100, count = 15, loop = -1})
            GUI:setTouchEnabled(cbl_item, true)
            if npc.titles_sign == tabId then
                local kuang = GUI:Image_Create(cbl_item, "kuang", 140/2, 140/2, "res/wy/public/003.png")
                GUI:setContentSize(kuang, 150, 140)
                GUI:setAnchorPoint(kuang, 0.5, 0.5)
            end
            -- GUI:Button_setTitleText(cbl_item, titles[tabId])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:addOnClickEvent(cbl_item, function()
                local lastItem = GUI:ui_delegate(node)["item"..npc.titles_sign]
                if lastItem then
                    GUI:removeChildByName(lastItem, "kuang")
                end
                npc.titles_sign = tabId
                local kuang = GUI:Image_Create(GUI:ui_delegate(node)["item"..tabId], "kuang", 140/2, 140/2, "res/wy/public/003.png")
                GUI:setContentSize(kuang, 150, 140)
                GUI:setAnchorPoint(kuang, 0.5, 0.5)
                GUI_createLabel(npc.Label,tabId)
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
    if p2 == 0 then--界面
        npc.data = _ts_normalize_payload(SL:JsonDecode(msgData,false))
        npc.isLookPlayer = tonumber(npc.data and npc.data.lookPlayer or 0) == 1 or npc.data.lookPlayer == true
        npc.titles_sign = nil
        npc._xf_skip_lingshi_confirm = false
        npc._xf_skip_anim = _get_xianfa_skip_anim_default()
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = _ts_normalize_payload(SL:JsonDecode(msgData,false))
        npc.isLookPlayer = tonumber(npc.data and npc.data.lookPlayer or 0) == 1 or npc.data.lookPlayer == true
        UI_updata(npc.node)
        local isXianfaMainline = NPC_UI_HELPER.isCurrentXylTask({"初识仙法", "查看仙法", "天书仙法", "进行天书仙法抽取"})
        if (not _ts_is_look_player()) and (not isXianfaMainline)
            and NPC_UI_HELPER.isCurrentXylTask({"天书强化", "进行天书强化1次"})
            and (tonumber(npc.data and npc.data.T_data and npc.data.T_data.level or 0) or 0) >= 1 then
            NPC_UI_HELPER.closeWindow(npc._window)
        end
    elseif p2 == 2 then
        npc.data = _ts_normalize_payload(SL:JsonDecode(msgData,false))
        npc.isLookPlayer = tonumber(npc.data and npc.data.lookPlayer or 0) == 1 or npc.data.lookPlayer == true
        GUI_createLabel(npc.Label,npc.titles_sign)
    elseif p2 == 10 then
        local data = SL:JsonDecode(msgData,false)
        npc._xf_skip_anim = npc._xf_skip_anim == true
        if npc._xf_skip_anim then
            local oldParent = GUI:GetWindow(nil, "xf_xjm")
            if oldParent then
                GUI:Win_Close(oldParent)
            end
            if npc.Label and npc.titles_sign then
                GUI_createLabel(npc.Label, npc.titles_sign)
            end
            return
        end
        local parent = GUI:GetWindow(nil, "xf_xjm")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("xf_xjm", 0, 0, 0, 0, false, false, true, true, true, nil, 24)
        end
        local startFrame = 1
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
                    local detailX = cogin.w / 2 - 140
                    local detailY = cogin.h / 2 + 92
                    local iconBox = GUI:Image_Create(parent, "xianfa_icon_box", detailX, detailY, "res/wy/public/70_70_k.png")
                    GUI:setAnchorPoint(iconBox, 0, 1)
                    GUI:setContentSize(iconBox, 76, 76)
                    GUI:setOpacity(iconBox, 0)
                    GUI:Timeline_FadeIn(iconBox, 1, nil)
                    local iconPath = info and tostring(info.icon or "") or ""
                    if iconPath ~= "" then
                        local icon = GUI:Image_Create(iconBox, "xianfa_icon", 38, 38, iconPath)
                        GUI:setAnchorPoint(icon, 0.5, 0.5)
                        GUI:setContentSize(icon, 54, 54)
                    end
                    local name = GUI:Text_Create(parent, "name", detailX + 92, detailY - 22, 40, level_coler[data.group] or "#FFFFFF", info and info.name or "未知仙法")
                    GUI:setAnchorPoint(name, 0, 0.5)
                    GUI:Text_setFontName(name, "fonts/448.ttf")
                    GUI:Text_enableOutline(name, "#000000", 2)
                    GUI:setOpacity(name, 0)
                    GUI:Timeline_FadeIn(name, 1,nil)
                    local descBg = GUI:Image_Create(parent, "xianfa_desc_bg", detailX, detailY - 92, "res/wy/public/input.png")
                    GUI:setAnchorPoint(descBg, 0, 1)
                    GUI:setContentSize(descBg, 330, 88)
                    GUI:setOpacity(descBg, 0)
                    GUI:Timeline_FadeIn(descBg, 1, nil)
                    local attr_desc = GUI:RichText_Create(parent, "attr_desc", detailX + 14, detailY - 105,  info and info.wz or "", 302, 18, "#f7f7de", 1,nil,nil)
                    GUI:setAnchorPoint(attr_desc, 0, 1)
                    GUI:setOpacity(attr_desc, 0)
                    GUI:Timeline_FadeIn(attr_desc, 1,nil)
                    local knowBtn = GUI:Button_Create(parent, "know_btn", cogin.w/2 - 110, 150, "res/wy/public/kb_btn.png")
                    GUI:setAnchorPoint(knowBtn, 0.5, 0)
                    GUI:Button_setTitleText(knowBtn, "我知道了")
                    GUI:Button_setTitleFontSize(knowBtn, 18)
                    GUI:setLocalZOrder(knowBtn, 100)
                    GUI:addOnClickEvent(knowBtn, function()
                        close_popup()
                    end)
                    if not _ts_is_look_player() then
                        local skipLabel = GUI:Text_Create(parent, "skip_label", cogin.w/2 - 60, 80, 20, "#FFFFFF", "跳过动画")
                        GUI:Text_enableOutline(skipLabel, "#000000", 1)
                        local skipCheck = GUI:CheckBox_Create(parent, "skip_anim", cogin.w/2 + 75, 80, "res/wy/public/xz_1.png", "res/wy/public/xz_0.png")
                        GUI:CheckBox_setSelected(skipCheck, npc._xf_skip_anim)
                        GUI:CheckBox_addOnEvent(skipCheck, function(sender)
                            npc._xf_skip_anim = GUI:CheckBox_isSelected(sender)
                            _set_xianfa_skip_anim_default(npc._xf_skip_anim)
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
                    end
                end})
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setTouchEnabled(bg, true)
    end
end
return npc
