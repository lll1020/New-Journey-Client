local npc = {}

npc._config = teshudata["npc_64"]
local UIHelper = NPC_UI_HELPER



local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/lingshou/bg.png", eff = false},
    closeButton = {x = 350 + 470, y = 180 + 288, skin = "res/wy/public/close_red_big.png"},
}

local function _has_cost(cost)
    if type(cost) ~= "table" then
        return false
    end
    local ok, canPay = pcall(function()
        return checkItemNum(cost)
    end)
    return ok and canPay == true
end

local function _item_count_by_name(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if not idx then
        return 0
    end
    return tonumber(SL:GetMetaValue("ITEM_COUNT", idx)) or 0
end

local function _redpoint_if(parent, condition, opts)
    local helper = UIHelper or NPC_UI_HELPER
    if condition and parent and helper and helper.redpoint_create then
        helper.redpoint_create(parent, opts)
    end
end

-- 灵兽孵化任务的界面内引导封装，进入契约界面后继续指向幼崽选择/领取按钮。
local function _try_xyl_guide(button, parent, marker, desc, opts)
    opts = opts or {}
    return NPC_UI_HELPER.tryStartXylGuide(npc, button, parent, marker, {
        taskName = "灵兽孵化",
        desc = desc,
        dir = opts.dir or 3,
        isForce = opts.isForce == true,
        hideMask = opts.hideMask,
        once = opts.once,
        idx = opts.idx,
    })
end

local LINGSHOU_BABY_ITEMS = {
    [1] = "麒麟幼崽",
    [2] = "青龙幼崽",
    [3] = "朱雀幼崽",
    [4] = "白虎幼崽",
    [5] = "玄武幼崽",
}

local LINGSHOU_BABY_STYLE = {
    [1] = {title = "山河镇守", desc = "护主承伤，稳守中宫", mark = "承伤守御", color = "#FFE49A"},
    [2] = {title = "青木回生", desc = "生息绵长，续航护体", mark = "回春续航", color = "#7CFFB2"},
    [3] = {title = "赤焰焚天", desc = "烈羽燎原，群攻最盛", mark = "群攻爆发", color = "#FF7952"},
    [4] = {title = "白虎破军", desc = "锋芒入阵，暴击破防", mark = "暴击破防", color = "#F6F0FF"},
    [5] = {title = "玄水藏珍", desc = "聚运寻宝，控场生财", mark = "聚运控场", color = "#75D9FF"},
}
local function _server_now(payload)
    local now = tonumber(payload and payload.server_time or 0) or 0
    if now <= 0 and SL and SL.GetMetaValue then
        now = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0
    end
    if now <= 0 then
        now = os.time()
    end
    return now
end

local function _format_seconds(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function _get_hatch(idx)
    local data = npc.ls_data and npc.ls_data.T_data or {}
    data.hatch = data.hatch or {}
    return data.hatch["" .. idx]
end

local function _get_baby_choice()
    local data = npc.ls_data and npc.ls_data.T_data or {}
    return tonumber(data.baby_choice or 0) or 0
end

local function _refresh_top_shortcut()
    local topNpc = Npclib and Npclib["anniu"]
    if not topNpc then
        return
    end
    if topNpc.refreshLingshouMainEntry then
        topNpc.refreshLingshouMainEntry()
        return
    end
    if topNpc.removeShortcutByNpcId then
        topNpc.removeShortcutByNpcId(64)
        return
    end
    topNpc._shortcut_render_signature = nil
    if topNpc.db_anniu and topNpc.db_anniu["64"] then
        pcall(function()
            GUI:removeFromParent(topNpc.db_anniu["64"])
        end)
        topNpc.db_anniu["64"] = nil
    end
    if topNpc.db_shortcut_entries then
        for i = #topNpc.db_shortcut_entries, 1, -1 do
            local entry = topNpc.db_shortcut_entries[i]
            if tonumber(entry and entry.cfg and entry.cfg[3] or 0) == 64 then
                pcall(function()
                    GUI:removeFromParent(entry.button)
                end)
                table.remove(topNpc.db_shortcut_entries, i)
            end
        end
    end
    if topNpc[1] then
        SL:ScheduleOnce(function()
            topNpc[1](0, 1, "")
        end, 0)
    end
end

local function _sync_shortcut_pet_data()
    local data = npc.ls_data and npc.ls_data.T_data
    if type(data) ~= "table" then
        return
    end
    rawset(_G, "NPC64_LAST_T_DATA", data)
    if (tonumber(data.dqzh or 0) or 0) > 0 then
        rawset(_G, "NPC64_OPEN_CONTRACT_ONCE", nil)
        rawset(_G, "NPC64_SILENT_SYNC_ONLY", nil)
        rawset(_G, "NPC64_HIDE_CONTRACT_SHORTCUT", true)
        _refresh_top_shortcut()
    else
        rawset(_G, "NPC64_HIDE_CONTRACT_SHORTCUT", nil)
        _refresh_top_shortcut()
        if Npclib and Npclib["anniu"] and Npclib["anniu"][1] then
            SL:ScheduleOnce(function()
                Npclib["anniu"][1](0, 1, "")
            end, 0)
        end
    end
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

    local function GUI_createLabel(localNode,idx) --小界面渲染
        GUI:removeAllChildren(localNode)
        if idx == 1 then
            GUI:Image_Create(localNode, "wz1", 490, 380, "res/custom/four_city/lingshou/xjm/tip_1.png")
            GUI:Image_Create(localNode, "wz2", 490, 380 - 70, "res/custom/four_city/lingshou/xjm/tip_5.png")
            -- GUI:Image_Create(localNode, "wz3", 490, 380 - 140, "res/custom/four_city/lingshou/xjm/tip_4.png")

            
            GUI:Text_setFontName(GUI:Text_Create(localNode, "b_skill",500,360 - 5, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].b_skill)
            , "fonts/font4.ttf")
            local s_skill = GUI:Text_Create(localNode, "s_skill",500,360 - 45 - 5, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].s_skill)
            GUI:Text_setFontName(s_skill, "fonts/font4.ttf")
            GUI:setAnchorPoint(s_skill,0, 1)


            if npc.ls_data.T_data.ls[""..npc.titles_sign] >= npc._config.config.wy.max_level then
                GUI:Text_setFontName(GUI:Text_Create(localNode, "tip_max",490, 170, 30, "#FF0000", "已达最高等级亲密度")
                , "fonts/font4.ttf")
                return
            end
            GUI:Image_Create(localNode, "cost_img", 490, 170, "res/custom/four_city/lingshou/xjm/cost.png")

            local cost = checkItemNumByTable_img_kuang(npc._config.config.wy.cost[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1], nil,localNode)
            GUI:setPosition(cost, 490 + 100, 160)

            local Button = GUI:Button_Create(localNode, "Button", 570, 90, "res/custom/four_city/lingshou/xjm/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 3, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
            end)
            _redpoint_if(Button, _has_cost(npc._config.config.wy.cost[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1]),{x=190,y=43})


        elseif idx == 2 then
            GUI:Image_Create(localNode, "wz1", 490, 380, "res/custom/four_city/lingshou/xjm/tip_2.png")
            GUI:Image_Create(localNode, "wz2", 490, 380 - 100, "res/custom/four_city/lingshou/xjm/tip_3.png")

            GUI:Text_setFontName(GUI:Text_Create(localNode, "attr_give_wz",500,360 - 40, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].attr_give_wz)
            , "fonts/font4.ttf")
            GUI:Text_setFontName(GUI:Text_Create(localNode, "attr_wz",500,360 - 100 - 40, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].attr_wz)
            , "fonts/font4.ttf")

            local attr = deepCopy(npc._config.config.wy.det[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1].attr)
            -- for v,k in pairs(attr) do
            --     local kuang = GUI:Image_Create(localNode, "kuang"..v, 500, 360 - (v-1)*20 - 30, "res/custom/tianshu/qh/tip.png")
            --     -- k[2] = k[2] * npc.data.T_data.level[""..npc.current_idx]
            --     GUI:RichText_Create(kuang, "attr_desc", 20, 0, Player:showAttr({{k[1],k[2]}}), 200, 17, "#f7f7de", 3,nil,nil)
            --     GUI:Image_Create(kuang, "jt", 150, 0, "res/custom/tianshu/qh/jt.png")
            --     GUI:Text_Create(kuang, "old_attr_v",200,3, 17, "#00FFFF", (npc.ls_data.T_data.ls[""..npc.titles_sign] < npc._config.config.wy.max_level) and (npc._config.config.wy.det[(npc.ls_data.T_data.ls[""..npc.titles_sign] or 1) + 1].attr[v][2]) .. "(下一等级亲密度)" or "已满级")
            -- end

        end
    end
    local function xjm_UI_updata() --小界面渲染
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_anniu_44_xjm",
            background = {skin = "res/custom/four_city/lingshou/xjm/bg.png"},
            closeButton = {x = 330 + 220 + 347, y = 180 + 180 + 51, skin = "res/wy/public/close_red_big.png"},
        })
        npc.xjm_node = npc.xjm_window.node

        local eff = GUI:Frames_Create(npc.xjm_node, "eff", 288, 314, "res/custom/four_city/lingshou/xjm/eff/"..npc.titles_sign.."/eff_", ".png", 1, 30,
            { speed = 75, count = 30, loop = -1})
        GUI:setAnchorPoint(eff,0.5, 0.5)
        local wz = GUI:Image_Create(npc.xjm_node, "wz1", 290, 430, "res/custom/four_city/lingshou/xjm/wz_"..npc.titles_sign..".png")
        GUI:setAnchorPoint(wz,0.5, 0.5)
        GUI:Text_Create(wz, "qmd", 170, 31, 20, "#FF00FF", ((npc.ls_data.T_data.ls[""..npc.titles_sign] or 0) * 10) .."%")
        GUI:Text_Create(wz, "zhsj", 170, 7, 18, "#00FFFF", npc._config.config.wy.det[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1].time.."秒")

        GUI:Image_Create(npc.xjm_node, "wz2", 430, 415, "res/custom/four_city/lingshou/xjm/wz/wz_"..npc.titles_sign..".png")

        GUI:Image_Create(npc.xjm_node, "syw", 170, 150, "res/custom/four_city/lingshou/xjm/syw.png")

        local kuang = GUI:Image_Create(npc.xjm_node, "kuang2", 170 + 120, 150 - 10, "res/wy/public/58_58_kuang.png")
        -- 灵兽圣遗物仅作为当前激活条件展示，不允许拖动。
        local item = GUI:ItemShow_Create(kuang, "item", 58/2, 58/2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.config.ls[npc.titles_sign].syw), look = true, movable = false, bgVisible = false })
        GUI:setAnchorPoint(item,0.5, 0.5)
        npc.ls_data.T_data.syw = npc.ls_data.T_data.syw or {}
        GUI:Text_Create(kuang, "qmd", 40, 0, 18, "#FF00FF", (npc.ls_data.T_data.syw[""..npc.titles_sign] and npc.ls_data.T_data.syw[""..npc.titles_sign] == 1) and "已激活" or "未激活")

        local Button= GUI:Button_Create(npc.xjm_node, "Button", 800, 0.00, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        -- GUI:Button_setTitleText(Button, "出战")
        -- GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            npc.ls_data.T_data.dqzh = npc.titles_sign
            SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
        end)
        local sywName = npc._config.config.ls[npc.titles_sign] and npc._config.config.ls[npc.titles_sign].syw
        local isSywActive = npc.ls_data.T_data.syw[""..npc.titles_sign] == 1
        _redpoint_if(Button, (not isSywActive) and _item_count_by_name(sywName) > 0)
        
        npc.Label = GUI:Node_Create(npc.xjm_node, "Label", 0, 0)
 
        npc.xjm_titles_sign = 1
        for i = 1, 2 do
            local cbl_item = GUI:Button_Create(npc.xjm_node, "item" .. i, 570 + (i-1)*150, 455, "res/custom/four_city/lingshou/xjm/list/"..(npc.xjm_titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.xjm_node)["item" .. npc.xjm_titles_sign], "res/custom/four_city/lingshou/xjm/list/n/"..npc.xjm_titles_sign..".png")
                npc.xjm_titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.xjm_node)["item" .. npc.xjm_titles_sign], "res/custom/four_city/lingshou/xjm/list/l/"..npc.xjm_titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.xjm_titles_sign)

    end

    local open_contract_window
    local function _outline_text(parent, name, x, y, size, color, text, opts)
        opts = opts or {}
        local node = GUI:Text_Create(parent, name, x, y, size, color, text)
        GUI:Text_setFontName(node, opts.font or "fonts/font4.ttf")
        GUI:Text_enableOutline(node, opts.outline or "#000000", opts.outlineSize or 1)
        return node
    end

    local function _contract_button(parent, name, x, y, title, color, cb)
        local btn = GUI:Button_Create(parent, name, x, y, "res/custom/four_city/lingshou/xjm/an7.png")
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:Button_setTitleText(btn, title)
        GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
        GUI:Button_setTitleFontSize(btn, 22)
        GUI:Button_setTitleColor(btn, color or "#FFFFFF")
        GUI:Button_titleEnableOutline(btn, "#160b05", 3)
        GUI:addOnClickEvent(btn, cb)
        return btn
    end

    local function _contract_title(parent, name, x, y, size, text)
        local title = _outline_text(parent, name, x, y, size, "#F8DA8B", text, {font = "fonts/502.ttf", outline = "#2A1200", outlineSize = 3})
        GUI:setAnchorPoint(title, 0.5, 0.5)
        return title
    end

    local function _contract_line(parent, name, x, y, text, color, size)
        local line = _outline_text(parent, name, x, y, size or 16, color or "#F7E8C5", text, {outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(line, 0, 0.5)
        return line
    end

    local function _contract_text_mask(parent, name, x, y, w, h, opacity)
        local mask = GUI:Image_Create(parent, name, x, y, "res/wy/public/tycccc.png")
        GUI:setAnchorPoint(mask, 0.5, 0.5)
        GUI:setContentSize(mask, w, h)
        GUI:setOpacity(mask, opacity or 185)
        return mask
    end

    local function _baby_state(idx, data, now, babyChoice)
        data = data or {}
        data.ls = data.ls or {}
        data.hatch = data.hatch or {}
        local hatch = data.hatch["" .. idx]
        local hasChoice = (tonumber(babyChoice or 0) or 0) > 0
        local isChoice = (tonumber(babyChoice or 0) or 0) == idx
        local isHatching = hatch and hatch.status == "hatching" and (tonumber(hatch.expireAt or 0) or 0) > now
        if isHatching then
            return "未孵化", "#00FFFF", false
        end
        if (tonumber(data.ls["" .. idx] or 0) or 0) > 0 then
            return "已孵化", "#00FF95", false
        end
        if hatch and hatch.status == "done" then
            return "孵化完成", "#00FF95", false
        end
        if isChoice then
            return "已选择", "#F7DE91", false
        end
        if hasChoice then
            return "已选择其他幼崽", "#999999", false
        end
        return "可领取", "#FF6666", true
    end

    local function open_baby_preview_window(idx, opts)
        opts = opts or {}
        idx = tonumber(idx) or 0
        local petCfg = npc._config.config.ls[idx]
        if not petCfg then
            SL:ShowSystemTips("灵兽配置异常")
            return
        end
        local data = npc.ls_data and npc.ls_data.T_data or {}
        local now = _server_now(npc.ls_data)
        local babyChoice = _get_baby_choice()
        local status, color, canClaim = _baby_state(idx, data, now, babyChoice)
        local babyName = LINGSHOU_BABY_ITEMS[idx] or (petCfg.name .. "幼崽")
        local canDeploy = (tonumber((data.ls or {})["" .. idx] or 0) or 0) > 0
        local hatch = _get_hatch(idx)
        local remain = hatch and math.max(0, (tonumber(hatch.expireAt or 0) or 0) - now) or 0
        local isHatching = hatch and hatch.status == "hatching" and remain > 0

        if npc.contract_window then
            NPC_UI_HELPER.closeWindow(npc.contract_window)
            npc.contract_window = nil
        end
        npc.baby_preview_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_64_baby_preview",
            background = {skin = "res/custom/four_city/lingshou/bg_1_1/eff_1.png", eff = false},
            closeButton = {x = 885, y = 468, skin = "res/wy/public/close_red_big.png"},
        })
        local node = npc.baby_preview_window.node
        local bg = npc.baby_preview_window.bg
        GUI:removeAllChildren(node)
        GUI:setLocalZOrder(GUI:Frames_Create(bg, "contract_bg_eff", 0, 0, "res/custom/four_city/lingshou/bg_1_1/eff_", ".png", 1, 30, {speed = 100, count = 30, loop = -1}), 1)

        _contract_text_mask(node, "title_text_mask", 596, 486, 635, 108, 165)
        _contract_text_mask(node, "info_text_mask", 648, 311, 552, 214, 155)

        _contract_title(node, "contract_title", 499, 520, 40, "灵兽契约")
        local subTitle = _outline_text(node, "contract_subtitle", 488, 482, 22, "#FFF3CF", "缔灵契，启仙兽；孵化完成后，可召唤", {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(subTitle, 0.5, 0.5)
        local red = _outline_text(node, "contract_subtitle_red", 720, 482, 22, "#FF4C38", "灵兽外显", {font = "fonts/502.ttf", outline = "#2A0000", outlineSize = 2})
        GUI:setAnchorPoint(red, 0.5, 0.5)
        local subTail = _outline_text(node, "contract_subtitle_tail", 804, 482, 22, "#FFF3CF", "并肩征战", {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(subTail, 0.5, 0.5)

        local eff = GUI:Frames_Create(node, "egg_eff", 225, 320, "res/custom/four_city/lingshou/xjm/eff/" .. idx .. "/eff_", ".png", 1, 30, {
            speed = 75,
            count = 30,
            loop = -1,
        })
        GUI:setAnchorPoint(eff, 0.5, 0.5)
        GUI:setScale(eff, 0.78)

        local eggLabel = GUI:Image_Create(node, "egg_label_bg", 225, 205, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(eggLabel, 0.5, 0.5)
        GUI:setContentSize(eggLabel, 124, 34)
        local name = _outline_text(node, "pet_name", 225, 205, 21, "#FFE49A", babyName, {font = "fonts/502.ttf", outline = "#2A1200", outlineSize = 2})
        GUI:setAnchorPoint(name, 0.5, 0.5)

        local progressBg = GUI:Image_Create(node, "hatch_progress_bg", 225, 160, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(progressBg, 0.5, 0.5)
        GUI:setContentSize(progressBg, 250, 18)
        local progressText = _outline_text(node, "hatch_progress_text", 225, 184, 19, "#FFE49A", isHatching and ("灵契凝息  " .. _format_seconds(remain)) or (canDeploy and "灵契已成，可出战" or status), {outline = "#1B0A00", outlineSize = 2})
        GUI:setAnchorPoint(progressText, 0.5, 0.5)
        local progressFill = GUI:Layout_Create(node, "hatch_progress_fill", 102, 153, isHatching and 80 or 240, 14, false)
        GUI:Layout_setBackGroundColorType(progressFill, 1)
        GUI:Layout_setBackGroundColor(progressFill, canDeploy and "#62D878" or "#F0C15A")
        GUI:Layout_setBackGroundColorOpacity(progressFill, 180)

        local infoPanel = GUI:Image_Create(node, "info_panel", 520, 294, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(infoPanel, 0.5, 0.5)
        GUI:setContentSize(infoPanel, 330, 230)
        _contract_title(node, "info_title", 520, 390, 25, "灵兽修行")
        local lines = {
            {"灵兽可淬炼星级，星耀越盛，战力越强。", "#F7E8C5"},
            {"可佩戴专属圣物，后续大陆可寻得机缘。", "#F7E8C5"},
            {"可与本命灵根共鸣，激活专属协同被动。", "#FF5A3D"},
            {"每日灵兽谷击杀神秘灵兽，可获珍稀掉落。", "#F7E8C5"},
            {"提升亲密好感，可令灵兽成长更快更强。", "#FF5A3D"},
            {"更多御兽秘法，前往四大陆后自行参悟。", "#F7E8C5"},
        }
        for i, line in ipairs(lines) do
            _contract_line(node, "info_line_" .. i, 366, 366 - i * 25, "· " .. line[1], line[2], 16)
        end
        local playBox = GUI:Image_Create(node, "preview_box", 790, 294, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(playBox, 0.5, 0.5)
        GUI:setContentSize(playBox, 140, 190)
        _contract_title(node, "preview_title", 790, 388, 21, "召灵预览")
        local playBtn = GUI:Button_Create(node, "preview_play", 790, 294, "res/custom/four_city/lingshou/xjm/an7.png")
        GUI:setAnchorPoint(playBtn, 0.5, 0.5)
        GUI:Button_setTitleText(playBtn, "观灵")
        GUI:Button_setTitleFontName(playBtn, "fonts/502.ttf")
        GUI:Button_setTitleFontSize(playBtn, 22)
        GUI:Button_setTitleColor(playBtn, "#FFE49A")
        GUI:Button_titleEnableOutline(playBtn, "#160b05", 3)
        GUI:addOnClickEvent(playBtn, function()
            SL:ShowSystemTips("灵兽召唤预览暂未开放")
        end)

        local quickHatchTip = _outline_text(node, "quick_hatch_tip", 570, 148, 23, "#FFF3CF", "累计充值", {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(quickHatchTip, 1, 0.5)
        local quickHatchRed = _outline_text(node, "quick_hatch_tip_red", 572, 148, 23, "#FF3B2E", "99元", {font = "fonts/502.ttf", outline = "#2A0000", outlineSize = 2})
        GUI:setAnchorPoint(quickHatchRed, 0, 0.5)
        local quickHatchTail = _outline_text(node, "quick_hatch_tip_tail", 625, 148, 23, "#FFF3CF", "即可点化灵胎，无需等待！", {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(quickHatchTail, 0, 0.5)

        local backBtn = _contract_button(node, "back_btn", 225, 86, opts.fromList and "返回灵契" or "收起契卷", "#7BFFB0", function()
            if npc.baby_preview_window then
                NPC_UI_HELPER.closeWindow(npc.baby_preview_window)
                npc.baby_preview_window = nil
            end
            if opts.fromList then
                open_contract_window(true)
            end
        end)

        local hatchNowBtn = _contract_button(node, "quick_hatch_btn", 625, 86, "立即点化", "#FF4D3A", function()
            SL:ShowSystemTips("真实累计充值达到99元后，可使用灵兽幼崽立即孵化")
        end)

        local claimBtn = GUI:Button_Create(node, "claim_btn", 790, 86, "res/custom/four_city/lingshou/xjm/an7.png")
        GUI:setAnchorPoint(claimBtn, 0.5, 0.5)
        GUI:Button_setTitleText(claimBtn, canDeploy and "召唤出战" or (canClaim and "缔契领取" or status))
        GUI:Button_setTitleFontName(claimBtn, "fonts/502.ttf")
        GUI:Button_setTitleFontSize(claimBtn, 22)
        GUI:Button_setTitleColor(claimBtn, canDeploy and "#7BFFB0" or "#FFE49A")
        GUI:Button_titleEnableOutline(claimBtn, "#160b05", 3)
        if not canDeploy then
            GUI:setTouchEnabled(claimBtn, canClaim)
            GUI:Button_setBright(claimBtn, canClaim)
        end
        if canDeploy then
            GUI:addOnClickEvent(claimBtn, function()
                if npc.ls_data and npc.ls_data.T_data then
                    npc.ls_data.T_data.dqzh = idx
                end
                SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({idx = idx}, false))
            end)
        elseif canClaim then
            _redpoint_if(claimBtn, true, {x = 176, y = 37})
            GUI:addOnClickEvent(claimBtn, function()
                SL:OpenCommonTipsPop({
                    str = "灵兽幼崽只能领取一次，确认选择【" .. babyName .. "】吗？",
                    btnType = 2,
                    callback = function(atype)
                        if atype == 1 then
                            SL:SendLuaNetMsg(100, npcid, 6, 0, SL:JsonEncode({idx = idx}, false))
                        end
                    end,
                })
            end)
        end
    end

    open_contract_window = function(forceList)
        if npc.baby_preview_window then
            NPC_UI_HELPER.closeWindow(npc.baby_preview_window)
            npc.baby_preview_window = nil
        end
        local babyChoice = _get_baby_choice()
        if not forceList and babyChoice > 0 then
            open_baby_preview_window(babyChoice, {fromList = false})
            return
        end
        npc.contract_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_64_contract",
            background = {skin = "res/custom/four_city/lingshou/bg_1_1/eff_1.png", eff = false},
            closeButton = {x = 350 + 470 + 75, y = 180 + 288, skin = "res/wy/public/close_red_big.png"},
            titleText = "领取灵兽蛋",
            subTitle = "选择幼崽",
        })
        local node = npc.contract_window.node
        local bg = npc.contract_window.bg
        GUI:removeAllChildren(node)

        GUI:setLocalZOrder(GUI:Frames_Create(bg, "bg_eff", 0, 0, "res/custom/four_city/lingshou/bg_1_1/eff_", ".png", 1, 30, {speed = 100, count = 30, loop = -1}), 1)

        local data = npc.ls_data and npc.ls_data.T_data or {}
        data.ls = data.ls or {}
        data.hatch = data.hatch or {}
        local now = _server_now(npc.ls_data)

        _contract_text_mask(node, "choice_title_mask", 556, 500, 610, 92, 150)
        _contract_title(node, "choice_title", 556, 530, 38, "五灵择契")
        local choiceDesc = _outline_text(node, "choice_desc", 556, 492, 19, "#FFF3CF", "灵兽契约只能择定其一；择定后将开启孵化，并决定后续成长流派。", {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(choiceDesc, 0.5, 0.5)
        local choiceTip = _outline_text(node, "choice_tip", 556, 464, 17, "#F8DA8B", "点击灵兽蛋，可查看契约与孵化详情", {font = "fonts/font4.ttf", outline = "#170A02", outlineSize = 2})
        GUI:setAnchorPoint(choiceTip, 0.5, 0.5)

        local Pos = {
            [1] = {x = 100 + 479, y = 250 + 80, eff = 60483 - 10, tagX = -96 + 38, tagY = -4 + 60, tagW = 150},
            [2] = {x = 243 + 479, y = 146 + 80, eff = 60484 - 10, tagX = 122 + 10 + 66, tagY = -18 + 60, tagW = 150},
            [3] = {x = 188 + 479, y = -21 + 80, eff = 60485 - 10, tagX = 30 + 160, tagY = 58 - 16, tagW = 150},
            [4] = {x = 12 + 479, y = -21 + 80, eff = 60486 - 10, tagX = -64 + 10, tagY = 36, tagW = 150},
            [5] = {x = -43 + 479, y = 146 + 80, eff = 60487 - 10, tagX = -60 + 10, tagY = -8 + 60, tagW = 150},
        }
        for i = 1, 5 do
            local x = Pos[i].x
            local y = Pos[i].y
            local lay = GUI:Layout_Create(node, "lay_" .. i, x, y, 100, 150)
            local style = LINGSHOU_BABY_STYLE[i] or {}
            local tag = GUI:Image_Create(lay, "baby_tag_bg_" .. i, Pos[i].tagX, Pos[i].tagY + 8, "res/wy/public/kfzj_bj.png")
            GUI:setAnchorPoint(tag, 0.5, 0.5)
            GUI:setContentSize(tag, Pos[i].tagW or 156, 120)
            GUI:setOpacity(tag, 150)
            GUI:setLocalZOrder(tag, 3)
            local btn = GUI:Effect_Create(lay, "baby_" .. i, 50, 75, 0, Pos[i].eff, 0, 0, 0, 1)
            GUI:setLocalZOrder(btn, 2)

            local hatch = _get_hatch(i)
            local received = hatch ~= nil
            local hasChoice = babyChoice > 0
            local isChoice = babyChoice == i
            local isHatching = hatch and hatch.status == "hatching" and (tonumber(hatch.expireAt or 0) or 0) > now
            local label = npc._config.config.ls[i] and npc._config.config.ls[i].name or LINGSHOU_BABY_ITEMS[i]
            local markText = _outline_text(lay, "style_mark_" .. i, Pos[i].tagX, Pos[i].tagY + 37, 14, style.color or "#FFFFFF", tostring(style.mark or "灵契"), {font = "fonts/502.ttf", outline = "#170A02", outlineSize = 2})
            GUI:setAnchorPoint(markText, 0.5, 0.5)
            GUI:setLocalZOrder(markText, 4)
            local nameText = GUI:Text_Create(lay, "name_" .. i, Pos[i].tagX, Pos[i].tagY + 17, 22, style.color or "#FFFFFF", label)
            GUI:setAnchorPoint(nameText, 0.5, 0.5)
            GUI:Text_setFontName(nameText, "fonts/502.ttf")
            GUI:Text_enableOutline(nameText, "#170A02", 3)
            GUI:setLocalZOrder(nameText, 4)
            local titleText = _outline_text(lay, "style_title_" .. i, Pos[i].tagX, Pos[i].tagY - 6, 16, "#F8DA8B", tostring(style.title or "灵契流派"), {font = "fonts/font4.ttf", outline = "#170A02", outlineSize = 2})
            GUI:setAnchorPoint(titleText, 0.5, 0.5)
            GUI:setLocalZOrder(titleText, 4)
            local descText = _outline_text(lay, "style_desc_" .. i, Pos[i].tagX, Pos[i].tagY - 27, 14, "#F4E7C5", tostring(style.desc or "潜力待启"), {font = "fonts/font4.ttf", outline = "#170A02", outlineSize = 2})
            GUI:setAnchorPoint(descText, 0.5, 0.5)
            GUI:setLocalZOrder(descText, 4)
            if isChoice or isHatching then
                local selected = _outline_text(lay, "selected_" .. i, Pos[i].tagX, Pos[i].tagY + 59, 15, "#7BFFB0", isHatching and "孵化中" or "已择契", {font = "fonts/502.ttf", outline = "#003018", outlineSize = 2})
                GUI:setAnchorPoint(selected, 0.5, 0.5)
                GUI:setLocalZOrder(selected, 4)
            elseif hasChoice then
                GUI:setOpacity(tag, 95)
                GUI:setOpacity(markText, 125)
                GUI:setOpacity(nameText, 125)
                GUI:setOpacity(titleText, 125)
                GUI:setOpacity(descText, 125)
            end

            GUI:setTouchEnabled(lay, true)
            GUI:addOnClickEvent(lay, function()
                open_baby_preview_window(i, {fromList = true})
            end)
        end
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.titles_sign = npc.titles_sign or 1

        npc.ls_data.T_data.ls = npc.ls_data.T_data.ls or {}
        npc.ls_data.T_data.ls_sp = npc.ls_data.T_data.ls_sp or {}
        npc.ls_data.T_data.syw = npc.ls_data.T_data.syw or {}


        for i = 1, 5 do
            local Button = GUI:Button_Create(node, "line"..i, 160 + (i-1)*130, 100 + (i%2) * 30, "res/custom/four_city/lingshou/l_"..i..".png")
            if npc.ls_data.T_data.dqzh and npc.ls_data.T_data.dqzh == i then
                local eff = GUI:Frames_Create(Button, "eff", 108, 355, "res/custom/four_city/lingshou/new/eff_", ".png", 1, 15,
                    { speed = 75, count = 15, loop = -1})
                GUI:setAnchorPoint(eff,0.5, 0.5)
            end
            for ii = 1, 3 do
                GUI:Image_Create(Button, "star"..ii, 90, 80 + (ii-1)*40, "res/custom/four_city/lingshou/star_"..((npc.ls_data.T_data.ls_sp[""..i] or 0)>ii and "l" or "n")..".png")
            end

            

            if npc.ls_data.T_data.ls[""..i] and npc.ls_data.T_data.ls[""..i] >= 1 then
            else
                GUI:Button_setBrightEx(Button, false)
            end
            local sywName = npc._config.config.ls[i] and npc._config.config.ls[i].syw
            local isSywActive = npc.ls_data.T_data.syw[""..i] == 1
            _redpoint_if(Button, (not isSywActive) and _item_count_by_name(sywName) > 0)
            GUI:addOnClickEvent(Button, function()
                npc.titles_sign = i
                xjm_UI_updata()
            end)
        end

        
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz1", 998/2, 80, "res/custom/four_city/lingshou/wz1.png")
        ,0.5, 0.5)

        local btn_tip = GUI:Button_Create(node, "btn_tip", 998/2 - 250, 80, "res/custom/four_city/lingshou/btn_tip.png")
        local btn_make = GUI:Button_Create(node, "btn_make", 998/2, 80, "res/custom/four_city/lingshou/btn_make.png")
        local btn_buy = GUI:Button_Create(node, "btn_buy", 998/2 + 250, 80, "res/custom/four_city/lingshou/btn_buy.png")
        GUI:setAnchorPoint(btn_tip,0.5, 0.5)
        GUI:setAnchorPoint(btn_make,0.5, 0.5)
        GUI:setAnchorPoint(btn_buy,0.5, 0.5)
        GUI:setVisible(btn_buy,false)


        GUI:addOnClickEvent(btn_make, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        _redpoint_if(btn_make, _has_cost(npc._config.cost),{x=240,y=55})

        GUI:addOnClickEvent(btn_tip, function()
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_44_xjm",
                background = {skin = "res/custom/four_city/lingshou/tip/bg.png"},
                closeButton = {x = 330 + 220 + 347 - 295, y = 180 + 180 + 51 - 100, skin = "res/wy/public/close_red_big.png"},
            })
        end)
    end


        if p2 == 0 then--界面
        npc.ls_data = SL:JsonDecode(msgData,false)
        _sync_shortcut_pet_data()
        if rawget(_G, "NPC64_SILENT_SYNC_ONLY") then
            rawset(_G, "NPC64_SILENT_SYNC_ONLY", nil)
            return
        end
        if npc.ls_data and tonumber(npc.ls_data.sync_only or 0) == 1 then
            return
        end
        if rawget(_G, "NPC64_OPEN_CONTRACT_ONCE") or (npc.ls_data and tonumber(npc.ls_data.open_contract or 0) == 1) then
            rawset(_G, "NPC64_OPEN_CONTRACT_ONCE", nil)
            open_contract_window()
            return
        end
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        _sync_shortcut_pet_data()
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        _sync_shortcut_pet_data()
        if npc.node then
            UI_updata(npc.node)
        end
        if npc.contract_window then
            NPC_UI_HELPER.closeWindow(npc.contract_window)
            npc.contract_window = nil
        end
        if npc.baby_preview_window then
            NPC_UI_HELPER.closeWindow(npc.baby_preview_window)
            npc.baby_preview_window = nil
        end
    elseif p2 == 3 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        _sync_shortcut_pet_data()
        xjm_UI_updata()
    elseif p2 == 6 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        _sync_shortcut_pet_data()
        UI_updata(npc.node)
        if npc.contract_window then
            NPC_UI_HELPER.closeWindow(npc.contract_window)
            npc.contract_window = nil
        end
        if npc.baby_preview_window then
            NPC_UI_HELPER.closeWindow(npc.baby_preview_window)
            npc.baby_preview_window = nil
        end
    end
end

return npc
