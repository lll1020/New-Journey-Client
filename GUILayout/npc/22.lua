local npc = {}
npc._config = teshudata["npc_22"]

local MAIN_WINDOW_OPTS = {
    -- 主界面背景与关闭按钮配置
    background = {skin = "res/custom/linggen/new/main/root_main_bg.png", eff = false},
    closeButton = {x = 926 - 43, y = 556 - 43, skin = "res/wy/public/close_red_big.png"},
}

local UPGRADE_WINDOW_OPTS = {
    -- 升级弹窗背景与关闭按钮配置
    windowName = "npc_anniu_22_xjm",
    overlay = {skin = "res/custom/treasureBasin/x.png"},
    background = {skin = "res/custom/linggen/new/updata/upgrade_bg.png", eff = false},
    closeButton = {x = 500, y = 376 - 60, skin = "res/wy/public/close_red_big.png"},
}

local ROOT_COLORS = {
    [1] = "#D9B55A",
    [2] = "#50B45A",
    [3] = "#4DA3FF",
    [4] = "#FF7A59",
    [5] = "#9A7A53",
    [6] = "#9B72FF",
    [7] = "#A7D58D",
    [8] = "#8FDBFF",
    [9] = "#FF6F5C",
    [10] = "#7F756C",
}

local ROOT_GRID_POS = {
    -- 顶部 10 个灵根图标的起始坐标、间距、列数
    startX = 345,
    startY = 482,
    gapX = 82,
    gapY = 82,
    cols = 5,
}
-- 单个顶部灵根格子的尺寸
local ROOT_SLOT_SIZE = {width = 70, height = 74}
-- 顶部灵根图标缩放
local ROOT_ICON_SCALE = 0.76
-- 选中框相对格子中心的偏移
local ROOT_SELECTED_OFFSET = {x = 0, y = 0}
-- 等级条相对格子左下角的位置
local ROOT_LEVEL_BAR_OFFSET = {x = -5, y = -14}
-- 等级文字在等级条上的位置
local ROOT_LEVEL_TEXT_POS = {x = 35, y = -1}

-- 主灵根槽位中心坐标
local MAIN_SLOT_POS = {x = 168 + 61, y = 419 + 18}
-- 副灵根槽位中心坐标
local OTHER_SLOT_POS = {x = 796 + 5, y = 419 + 20}
-- 主灵根图标实际渲染位置
local MAIN_SLOT_ITEM_POS = {x = 168 + 61, y = 419 + 18}
-- 副灵根图标实际渲染位置
local OTHER_SLOT_ITEM_POS = {x = 796 + 5, y = 419 + 20}
-- 主/副灵根点击与拖拽的命中区域尺寸
local SLOT_TOUCH_SIZE = {width = 125, height = 110}
-- 主/副灵根名字相对槽位中心的纵向偏移
local SLOT_NAME_OFFSET_Y = -67
-- 左下“灵根总体属性”文本区域左下角
local ATTR_BOX_POS = {x = 102 + 75, y = 34 + 47}
-- 左下“灵根总体属性”文本区域宽高
local ATTR_BOX_SIZE = {width = 335, height = 156}
-- 中间拖入卸下框的左下角坐标
local UNEQUIP_DROP_POS = {x = 300, y = 346}
-- 中间拖入卸下框的尺寸
local UNEQUIP_DROP_SIZE = {width = 410, height = 175}
-- 右下当前激活灵根效果区：主灵根/副灵根图标位置
local SKILL_ICON_POS = {
    main = {x = 570, y = 138 + 67},
    other = {x = 570, y = 66 + 54},
}
-- 中间升级按钮位置
local PAGE_UPGRADE_BTN_POS = {x = 482 + 30, y = 320}
-- 主灵根空槽位下方“装配”按钮位置
local MAIN_EQUIP_BTN_POS = {x = 152 + 83, y = 262 + 50}
-- 副灵根空槽位下方“装配”按钮位置
local OTHER_EQUIP_BTN_POS = {x = 812 - 6, y = 262 + 50}

-- 升级弹窗左侧属性预览区域左下角
local UPGRADE_PREVIEW_POS = {x = 35, y = 18}
-- 升级弹窗左侧属性预览区域尺寸
local UPGRADE_PREVIEW_SIZE = {width = 330, height = 300}
-- 升级弹窗右侧灵根图标位置
local UPGRADE_ITEM_POS = {x = 450, y = 285}
-- 升级弹窗右侧两个消耗框的位置
local UPGRADE_COST_POS = {
    {x = 393 - 65, y = 121 - 48},
    {x = 458 - 65 + 20, y = 121 - 48},
}
-- 升级弹窗“升级”按钮位置
local UPGRADE_BTN_POS = {x = 428 + 23, y = 50}

-- 部分技能图标文件名与技能名不完全一致，这里做映射
local SPECIAL_SKILL_ICON_NAME = {
    ["枯木生风"] = "ku_mu_cheng_feng",
    ["金汤"] = "gu_ruo_jin_tang",
    ["金之力"] = "jin_force",
    ["罡杀"] = "gang_sha",
    ["木之力"] = "mu_force",
    ["复苏"] = "fu_su",
    ["水之力"] = "shui_force",
    ["迟缓"] = "chi_huan",
    ["火之力"] = "huo_force",
    ["点燃"] = "dian_ran",
    ["土之力"] = "tu_force",
    ["铁壁"] = "tie_bi",
    ["九重天雷"] = "jiu_zhong_tian_lei",
    ["雷闪"] = "lei_shan",
    ["疾风"] = "ji_feng",
    ["极冰寒冬"] = "ji_bing_han_dong",
    ["冰冻"] = "bing_dong",
    ["焚天烈火"] = "fen_tian_lie_huo",
    ["天火"] = "tian_huo",
    ["坚如磐石"] = "jian_ru_pan_shi",
}

local _lg_refresh_upgrade_window

-- 绑定主/副灵根拖拽到中间卸下区域的移动事件。
local function _lg_bind_move_events(npcid)
    if npc._moveEventBound then
        return
    end
    npc._moveEventBound = true

    local function maintoout()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end

    local function othertoout()
        SL:SendLuaNetMsg(100, npcid, 3, 0, "")
    end

    GUI:AddMoveWidgetTypeEvent("lg_main_drag", "out", maintoout, nil)
    GUI:AddMoveWidgetTypeEvent("lg_other_drag", "out", othertoout, nil)
end

-- 创建主界面窗口并缓存引用。
local function ensureMainWindow(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, MAIN_WINDOW_OPTS)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

-- 创建升级弹窗并缓存引用。
local function ensureUpgradeWindow(npcid)
    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, UPGRADE_WINDOW_OPTS)
    npc.xjm_node = npc.xjm_window and npc.xjm_window.node or nil
    return npc.xjm_node
end

-- 创建带描边的文本，统一字体与描边风格。
local function strokeText(parent, name, x, y, size, color, text, font)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:Text_setFontName(label, font or "fonts/font4.ttf")
    GUI:Text_enableOutline(label, "#000000", 2)
    return label
end

-- 创建带描边的富文本，主用于属性与效果描述。
local function richText(parent, name, x, y, html, width, size, align)
    local widget = GUI:RichText_Create(parent, name, x, y, html or "", width or 200, size or 16, "#f7f7de", align or 1, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
    return widget
end

-- 获取灵根基础倍率配置。
local function _lg_base_ratio()
    return tonumber((npc._config or {}).base_ratio or 0.4) or 0.4
end

-- 读取当前角色所有灵根等级表。
local function _lg_level_map()
    return npc.data and npc.data.T_data and npc.data.T_data.level or {}
end

-- 判断指定灵根是否已经激活。
local function _lg_has_root(idx)
    local levelMap = _lg_level_map()
    return idx and levelMap and levelMap[tostring(idx)] ~= nil
end

-- 读取指定灵根当前等级。
local function _lg_level_value(idx)
    local levelMap = _lg_level_map()
    return tonumber(levelMap[tostring(idx)] or 0) or 0
end

-- 计算灵根效果倍率：当前等级 + 预览增量 + 基础倍率。
local function _lg_effect_scale(idx, extraLevel)
    if not _lg_has_root(idx) then
        return 0
    end
    return _lg_level_value(idx) + (tonumber(extraLevel or 0) or 0) + _lg_base_ratio()
end

-- 数值四舍五入并保证最小为 1。
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

-- 读取指定灵根配置。
local function _lg_root_cfg(idx)
    return npc._config and npc._config.main_r and npc._config.main_r[idx] or nil
end

-- 生成指定灵根当前/预览等级下的属性列表。
local function _lg_build_attr_list(idx, extraLevel)
    local cfg = _lg_root_cfg(idx)
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

-- 生成用于技能描述展示的倍率文本。
local function _lg_format_scale_text(idx, extraLevel)
    local scale = _lg_effect_scale(idx, extraLevel)
    if scale <= 0 then
        return "0.0"
    end
    -- return string.format("%.1f", scale)
    return "[灵根等级]"
end

-- 生成灵根本体图标路径。
local function _lg_root_item_path(idx)
    if not idx or idx <= 0 then
        return nil
    end
    return "res/custom/linggen/itme_" .. tostring(idx) .. ".png"
end

-- 从技能描述中提取【技能名】。
local function _lg_extract_skill_name(text)
    local name = tostring(text or ""):match("【(.-)】") or ""
    return SPECIAL_SKILL_ICON_NAME[name] or name
end

-- 根据技能名映射并生成技能图标路径。
local function _lg_skill_icon_path(skillName)
    skillName = tostring(skillName or "")
    if skillName == "" then
        return nil
    end
    return "res/custom/linggen/new/icon/" .. skillName .. ".png"
end

-- 根据灵根类型读取升级配置表（低阶/高阶）。
local function _lg_upgrade_detail(idx)
    local details = npc._config and npc._config.main_updata and npc._config.main_updata.details or {}
    return details[idx and idx <= 5 and "low" or "up"] or {}
end

-- 读取指定灵根下一等级的升级配置。
local function _lg_next_upgrade_cfg(idx)
    if not idx or idx <= 0 then
        return nil
    end
    local lv = _lg_level_value(idx)
    return _lg_upgrade_detail(idx)[lv + 1]
end

-- 判断指定灵根是否已满级。
local function _lg_is_max_level(idx)
    return _lg_level_value(idx) >= tonumber(npc._config.main_updata.max_level or 0)
end

-- 汇总当前所有已激活灵根的总属性。
local function _lg_collect_total_attrs()
    local attrs = {}
    for idx, _ in pairs(_lg_level_map()) do
        idx = tonumber(idx) or 0
        for _, attr in ipairs(_lg_build_attr_list(idx, 0)) do
            table.insert(attrs, attr)
        end
    end
    return attrs
end

-- 将属性列表拆成左右两列显示。
local function _lg_split_attr_lines(attrs)
    local line1 = {}
    local line2 = {}
    for i, attr in ipairs(attrs or {}) do
        if i % 2 == 1 then
            line1[#line1 + 1] = attr
        else
            line2[#line2 + 1] = attr
        end
    end
    return line1, line2
end

-- 构建升级弹窗左侧的属性预览与技能描述 HTML。
local function _lg_build_attr_preview_html(idx)
    if not idx or idx <= 0 then
        return "<font color='#6b6257'>请选择一个灵根</font>"
    end
    local cfg = _lg_root_cfg(idx)
    if not cfg then
        return "<font color='#6b6257'>暂无数据</font>"
    end

    local currentAttrs = _lg_build_attr_list(idx, 0)
    local nextAttrs = _lg_build_attr_list(idx, 1)
    local lines = {
        string.format("<font color='"..ROOT_COLORS[idx].."'>[%s灵根]</font>", tostring(cfg.name or "")),
        string.format("<font color='#00FF00'>当前等级：</font><font color='#FFFFFF'>Lv.%d</font>", _lg_level_value(idx)),
        "",
        "<font color='#FFFFFF'>属性预览:</font>",
    }
    -- lines[#lines + 1] = ""
    if #currentAttrs == 0 then
        lines[#lines + 1] = "<font color='#FF0000'>当前灵根未激活</font>"
    else
        for i, attr in ipairs(currentAttrs) do
            local nextValue = nextAttrs[i] and nextAttrs[i][2] or attr[2]
            local attrHtml = Player:showAttr({attr})
            local nextText = _lg_is_max_level(idx) and "已满级" or tostring(nextValue)
            local nextColor = _lg_is_max_level(idx) and "#FFFFFF" or "#4DA3FF"
            lines[#lines + 1] = string.format("%s<font color='#8C6B35'> -> </font><font color='%s'>%s</font>[下级属性]", attrHtml, nextColor, nextText)
        end
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "<font color='#DE0000'>主灵根效果:</font>"
    lines[#lines + 1] = string.format("<font color='#FFFFFF'>%s</font>", string.format(cfg.wz1, cfg.value1 or cfg.value or 0, _lg_format_scale_text(idx, 0)))
    lines[#lines + 1] = ""
    lines[#lines + 1] = "<font color='#4169E1'>副灵根效果:</font>"
    lines[#lines + 1] = string.format("<font color='#FFFFFF'>%s</font>", string.format(cfg.wz2, cfg.value2 or 0, _lg_format_scale_text(idx, 0)))
    return table.concat(lines, "\n")
end

-- 渲染升级弹窗右侧的消耗物品格子。
local function _lg_create_cost_items(parent, costList, positions)
    -- for i, pos in ipairs(positions or {}) do
    --     GUI:Image_Create(parent, "cost_bg_" .. i, pos.x, pos.y, "res/custom/linggen/new/updata/cost_slot.png")
    -- end
    if not costList then
        return
    end
    for i, one in ipairs(costList) do
        local pos = positions[i]
        if not pos then
            break
        end
        local node = checkItemNumByTable_img_kuang({one}, nil, GUI:Node_Create(parent, "cost_node_" .. i, 0, 0))
        GUI:setPosition(node, pos.x + 25, pos.y + 25)
    end
end

-- 将左下总属性区域渲染为可滚动面板，避免属性过多被截断。
local function _lg_render_attr_scroll(parent, attrs)
    local scroll = GUI:ScrollView_Create(parent, "attr_scroll", ATTR_BOX_POS.x, ATTR_BOX_POS.y, ATTR_BOX_SIZE.width, ATTR_BOX_SIZE.height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, ATTR_BOX_SIZE.width, ATTR_BOX_SIZE.height)

    if not attrs or #attrs <= 0 then
        local emptyText = richText(scroll, "total_attr_empty", 0, ATTR_BOX_SIZE.height - 6, "<font color='#6b6257'>暂无已激活灵根属性</font>", ATTR_BOX_SIZE.width, 17, 1)
        GUI:setAnchorPoint(emptyText, 0, 1)
        return scroll
    end

    local line1Attrs, line2Attrs = _lg_split_attr_lines(attrs)
    local colWidth = math.floor(ATTR_BOX_SIZE.width / 2) - 12
    local line1 = richText(scroll, "total_attr_1", 0, ATTR_BOX_SIZE.height - 6, Player:showAttr(line1Attrs), colWidth, 17, 1)
    GUI:setAnchorPoint(line1, 0, 1)
    local line2 = richText(scroll, "total_attr_2", colWidth + 28, ATTR_BOX_SIZE.height - 6, Player:showAttr(line2Attrs), colWidth, 17, 1)
    GUI:setAnchorPoint(line2, 0, 1)

    local h1 = GUI:getBoundingBox(line1).height
    local h2 = GUI:getBoundingBox(line2).height
    local innerH = math.max(ATTR_BOX_SIZE.height, math.max(h1, h2) + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, ATTR_BOX_SIZE.width, innerH)
    GUI:setPosition(line1, 0, innerH - 6)
    GUI:setPosition(line2, colWidth + 28, innerH - 6)
    return scroll
end

-- 将升级弹窗左侧属性预览区域渲染为可滚动面板，避免效果描述过长被截断。
local function _lg_render_preview_scroll(parent, html)
    local scroll = GUI:ScrollView_Create(parent, "preview_scroll", UPGRADE_PREVIEW_POS.x, UPGRADE_PREVIEW_POS.y, UPGRADE_PREVIEW_SIZE.width, UPGRADE_PREVIEW_SIZE.height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, UPGRADE_PREVIEW_SIZE.width, UPGRADE_PREVIEW_SIZE.height)

    local content = richText(scroll, "preview_content", 0, UPGRADE_PREVIEW_SIZE.height - 6, tostring(html or ""), UPGRADE_PREVIEW_SIZE.width - 8, 17, 1)
    GUI:setAnchorPoint(content, 0, 1)

    local contentHeight = GUI:getBoundingBox(content).height
    local innerH = math.max(UPGRADE_PREVIEW_SIZE.height, contentHeight + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, UPGRADE_PREVIEW_SIZE.width, innerH)
    GUI:setPosition(content, 0, innerH - 6)
    return scroll
end

-- 在指定位置绘制灵根图标。
local function _lg_show_root_icon(parent, name, x, y, idx, scale)
    if not idx or idx <= 0 then
        return nil
    end
    local item = GUI:Image_Create(parent, name, x, y, _lg_root_item_path(idx))
    GUI:setAnchorPoint(item, 0.5, 0.5)
    if scale and scale ~= 1 then
        GUI:setScale(item, scale)
    end
    return item
end

-- 在主/副灵根槽位下方绘制灵根名称。
local function _lg_create_slot_name(parent, name, x, y, idx)
    if not idx or idx <= 0 then
        return nil
    end
    local cfg = _lg_root_cfg(idx) or {}
    local label = strokeText(parent, name, x, y + SLOT_NAME_OFFSET_Y, 20, ROOT_COLORS[idx] or "#FFFFFF", tostring(cfg.name or "") .. "灵根", "fonts/font4.ttf")
    GUI:setAnchorPoint(label, 0.5, 0.5)
    return label
end

-- 创建中间拖入卸下区域，拖拽时显示提示框。
local function _lg_create_unequip_drag_area(parent)
    local outMoveWidget = GUI:MoveWidget_Create(
        parent,
        "out_moveWidget",
        UNEQUIP_DROP_POS.x,
        UNEQUIP_DROP_POS.y,
        UNEQUIP_DROP_SIZE.width,
        UNEQUIP_DROP_SIZE.height,
        SL:GetMetaValue("ITEMFROMUI_ENUM").out,
        {}
    )
    GUI:setAnchorPoint(outMoveWidget, 0, 0)
    GUI:setVisible(outMoveWidget, false)
    local bg = GUI:Image_Create(outMoveWidget, "kuang", 0, 0, "res/wy/public/500-300.png")
    GUI:setAnchorPoint(bg, 0, 0)
    GUI:setContentSize(bg, UNEQUIP_DROP_SIZE.width, UNEQUIP_DROP_SIZE.height)
    local tip = strokeText(outMoveWidget, "drop_tip", UNEQUIP_DROP_SIZE.width / 2, UNEQUIP_DROP_SIZE.height / 2, 22, "#FFFFFF", "放入框内卸下", "fonts/501.ttf")
    GUI:setAnchorPoint(tip, 0.5, 0.5)
    return outMoveWidget
end

-- 为主/副灵根槽位挂载拖拽控件，并绑定拖拽中跟随显示与卸下提示。
local function _lg_attach_drag_widget(parent, name, x, y, moveType, beginIdx)
    local dragBg = nil
    local dragItem = nil
    local drag = GUI:MoveWidget_Create(
        parent,
        name,
        x,
        y,
        SLOT_TOUCH_SIZE.width,
        SLOT_TOUCH_SIZE.height,
        moveType,
        {
            beginMoveCB = function()
                npc.current_idx = beginIdx
                if dragBg then
                    GUI:setVisible(dragBg, true)
                end
                if dragItem then
                    GUI:setVisible(dragItem, true)
                end
                if npc.out_moveWidget then
                    GUI:setVisible(npc.out_moveWidget, true)
                end
            end,
            endMoveCB = function()
                if dragBg then
                    GUI:setVisible(dragBg, false)
                end
                if dragItem then
                    GUI:setVisible(dragItem, false)
                end
                if npc.out_moveWidget then
                    GUI:setVisible(npc.out_moveWidget, false)
                end
            end,
            cancelMoveCB = function()
                if dragBg then
                    GUI:setVisible(dragBg, false)
                end
                if dragItem then
                    GUI:setVisible(dragItem, false)
                end
                if npc.out_moveWidget then
                    GUI:setVisible(npc.out_moveWidget, false)
                end
            end
        }
    )
    GUI:setAnchorPoint(drag, 0.5, 0.5)
    -- dragBg = GUI:Image_Create(drag, "drag_bg", SLOT_TOUCH_SIZE.width / 2, SLOT_TOUCH_SIZE.height / 2, "res/wy/public/003.png")
    -- GUI:setAnchorPoint(dragBg, 0.5, 0.5)
    -- GUI:setContentSize(dragBg, SLOT_TOUCH_SIZE.width, SLOT_TOUCH_SIZE.height)
    dragItem = _lg_show_root_icon(drag, "drag_item", SLOT_TOUCH_SIZE.width / 2, SLOT_TOUCH_SIZE.height / 2, beginIdx, 1.0)
    if dragItem then
        GUI:setScale(dragItem, 0.92)
    end
    -- GUI:setVisible(dragBg, false)
    if dragItem then
        GUI:setVisible(dragItem, false)
    end
    return drag
end

-- 渲染右下当前激活灵根：图标 + 对应技能效果说明。
local function _lg_render_skill_icons(parent)
    local mainIdx = npc.data and npc.data.T_data and npc.data.T_data.main or 0
    local otherIdx = npc.data and npc.data.T_data and npc.data.T_data.other or 0
    local mainCfg = _lg_root_cfg(mainIdx)
    local otherCfg = _lg_root_cfg(otherIdx)

    local mainSkill = mainCfg and _lg_extract_skill_name(mainCfg.wz1) or ""
    local otherSkill = otherCfg and _lg_extract_skill_name(otherCfg.wz2) or ""

    local function renderOne(name, skillName, pos, effectText)
        if skillName == "" then
            return
        end
        local iconPath = _lg_skill_icon_path(skillName)
        local icon = GUI:Image_Create(parent, name, pos.x, pos.y, iconPath)
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        local size = GUI:getContentSize(icon)
        if size and size.width > 0 then
            local s = math.min(58 / size.width, 58 / size.height)
            GUI:setScale(icon, s)
        end
        GUI:addOnClickEvent(icon, function()
        end)
        GUI:setTouchEnabled(icon, false)
        -- local label = strokeText(parent, name .. "_txt", pos.x + 52, pos.y + 8, 16, "#FFFFFF", skillName, "fonts/font4.ttf")
        -- GUI:setAnchorPoint(label, 0, 0.5)
        local effect = richText(parent, name .. "_effect", pos.x + 52, pos.y  + 37, tostring(effectText or ""), 250, 15, 1)
        GUI:setAnchorPoint(effect, 0, 1)
    end

    renderOne(
        "skill_main",
        mainSkill,
        SKILL_ICON_POS.main,
        mainCfg and string.format("<font color='#9FE2FF'>%s</font>", string.format(mainCfg.wz1, mainCfg.value1 or mainCfg.value or 0, _lg_format_scale_text(mainIdx, 0))) or ""
    )
    renderOne(
        "skill_other",
        otherSkill,
        SKILL_ICON_POS.other,
        otherCfg and string.format("<font color='#9FE2FF'>%s</font>", string.format(otherCfg.wz2, otherCfg.value2 or 0, _lg_format_scale_text(otherIdx, 0))) or ""
    )
end

-- 刷新灵根主界面：顶部列表、主副槽位、属性区、技能区、装配/升级入口。
local function _lg_refresh_main_page(npcid, node)
    GUI:removeAllChildren(node)
    _lg_bind_move_events(npcid)

    local selectedIdx = tonumber(npc.current_idx or 0) or 0
    if selectedIdx <= 0 then
        selectedIdx = npc.data and npc.data.T_data and (npc.data.T_data.main or npc.data.T_data.other) or 0
        npc.current_idx = selectedIdx
    end

    for idx, cfg in ipairs(npc._config.main_r or {}) do
        local row = math.floor((idx - 1) / ROOT_GRID_POS.cols)
        local col = (idx - 1) % ROOT_GRID_POS.cols
        local x = ROOT_GRID_POS.startX + col * ROOT_GRID_POS.gapX
        local y = ROOT_GRID_POS.startY - row * ROOT_GRID_POS.gapY
        local slot = GUI:Layout_Create(node, "root_slot_" .. idx, x - ROOT_SLOT_SIZE.width / 2, y - ROOT_SLOT_SIZE.height / 2, ROOT_SLOT_SIZE.width, ROOT_SLOT_SIZE.height, false)
        GUI:Image_Create(slot, "bg", 0, 0, "res/custom/linggen/new/main/slot_bg.png")
        local rootItem = _lg_show_root_icon(slot, "item", ROOT_SLOT_SIZE.width / 2, ROOT_SLOT_SIZE.height / 2, idx, ROOT_ICON_SCALE)
        GUI:setTouchEnabled(slot, true)
        GUI:addOnTouchEvent(slot, function(sender, type)
            -- 触发控件（sender）：控件本身
            -- 事件类型（type）：触摸阶段 0-3
            if type == SLDefine.TouchEventType.began then           -- 0 触摸开始
                
                if not sender._clicking then
                    sender._clicking = true
                    SL:scheduleOnce(sender, function()
                        if sender._clicking then
                            local pos = GUI:getWorldPosition(slot)
                            SL:OpenCommonDescTipsPop({str = _lg_build_attr_preview_html(idx), worldPos = {x = ATTR_BOX_POS.x, y = ATTR_BOX_POS.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
                        end
                    end, 0.1)
                end
            elseif type == SLDefine.TouchEventType.moved then       -- 1 触摸移动
                

            elseif type == SLDefine.TouchEventType.ended or type == SLDefine.TouchEventType.canceled then       -- 2 触摸结束 3 触摸取消
                sender._clicking = false
                npc.current_idx = idx
                _lg_refresh_main_page(npcid, node)
            end
        end)
        if rootItem then
            GUI:Image_setGrey(rootItem, not _lg_has_root(idx))
        end
        if selectedIdx == idx then
            local sel = GUI:Image_Create(slot, "selected", ROOT_SLOT_SIZE.width / 2, ROOT_SLOT_SIZE.height / 2 - 3, "res/custom/linggen/new/main/selected_frame.png")
            GUI:setAnchorPoint(sel, 0.5, 0.5)
            GUI:setLocalZOrder(sel, 1)
        end
        local level = _lg_has_root(idx) and ("Lv." .. tostring(_lg_level_value(idx))) or "未激活"
        local lv_bar = GUI:Image_Create(slot, "lv_bar", ROOT_LEVEL_BAR_OFFSET.x, ROOT_LEVEL_BAR_OFFSET.y, "res/custom/linggen/new/main/level_bar.png")
        GUI:setLocalZOrder(lv_bar, 95)
        GUI:setLocalZOrder(strokeText(slot, "lv", ROOT_LEVEL_TEXT_POS.x, ROOT_LEVEL_TEXT_POS.y, 14, _lg_has_root(idx) and "#FFFFFF" or "#8E8E8E", level, "fonts/font4.ttf"), 99)
        
        GUI:setAnchorPoint(GUI:getChildByName(slot, "lv"), 0.5, 0.5)
    end

    local mainIdx = npc.data and npc.data.T_data and npc.data.T_data.main or 0
    local otherIdx = npc.data and npc.data.T_data and npc.data.T_data.other or 0
    if mainIdx and mainIdx > 0 then
        _lg_show_root_icon(node, "main_item", MAIN_SLOT_ITEM_POS.x, MAIN_SLOT_ITEM_POS.y, mainIdx, 1.05)
        _lg_create_slot_name(node, "main_name", MAIN_SLOT_ITEM_POS.x, MAIN_SLOT_ITEM_POS.y, mainIdx)
    end
    if otherIdx and otherIdx > 0 then
        _lg_show_root_icon(node, "other_item", OTHER_SLOT_ITEM_POS.x, OTHER_SLOT_ITEM_POS.y, otherIdx, 1.05)
        _lg_create_slot_name(node, "other_name", OTHER_SLOT_ITEM_POS.x, OTHER_SLOT_ITEM_POS.y, otherIdx)
    end

    _lg_render_attr_scroll(node, _lg_collect_total_attrs())

    _lg_render_skill_icons(node)

    if selectedIdx > 0 and (not mainIdx or mainIdx <= 0) then
        local btnEquipMain = GUI:Button_Create(node, "btn_equip_main", MAIN_EQUIP_BTN_POS.x, MAIN_EQUIP_BTN_POS.y, "res/custom/linggen/new/main/btn_equip.png")
        GUI:setAnchorPoint(btnEquipMain, 0.5, 0.5)
        GUI:addOnClickEvent(btnEquipMain, function()
            SL:SendLuaNetMsg(100, npcid, 2, selectedIdx, "")
        end)
    elseif mainIdx and mainIdx > 0 then
        local btnUnequipMain = GUI:Button_Create(node, "btn_unequip_main", MAIN_EQUIP_BTN_POS.x, MAIN_EQUIP_BTN_POS.y, "res/custom/linggen/new/main/btn_unequip.png")
        GUI:setAnchorPoint(btnUnequipMain, 0.5, 0.5)
        GUI:addOnClickEvent(btnUnequipMain, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
    end
    if selectedIdx > 0 and (not otherIdx or otherIdx <= 0) then
        local btnEquipOther = GUI:Button_Create(node, "btn_equip_other", OTHER_EQUIP_BTN_POS.x, OTHER_EQUIP_BTN_POS.y, "res/custom/linggen/new/main/btn_equip.png")
        GUI:setAnchorPoint(btnEquipOther, 0.5, 0.5)
        GUI:addOnClickEvent(btnEquipOther, function()
            SL:SendLuaNetMsg(100, npcid, 3, selectedIdx, "")
        end)
    elseif otherIdx and otherIdx > 0 then
        local btnUnequipOther = GUI:Button_Create(node, "btn_unequip_other", OTHER_EQUIP_BTN_POS.x, OTHER_EQUIP_BTN_POS.y, "res/custom/linggen/new/main/btn_unequip.png")
        GUI:setAnchorPoint(btnUnequipOther, 0.5, 0.5)
        GUI:addOnClickEvent(btnUnequipOther, function()
            SL:SendLuaNetMsg(100, npcid, 3, 0, "")
        end)
    end

    local btnUpgradePage = GUI:Button_Create(node, "btn_open_upgrade", PAGE_UPGRADE_BTN_POS.x, PAGE_UPGRADE_BTN_POS.y, "res/custom/linggen/new/main/btn_upgrade.png")
    GUI:setAnchorPoint(btnUpgradePage, 0.5, 0.5)
    GUI:addOnClickEvent(btnUpgradePage, function()
        local xNode = ensureUpgradeWindow(npcid)
        if xNode then
            _lg_refresh_upgrade_window(npcid, xNode)
        end
    end)

    npc.out_moveWidget = _lg_create_unequip_drag_area(node)

    local mainTouch = GUI:Layout_Create(node, "main_slot_touch", MAIN_SLOT_POS.x - SLOT_TOUCH_SIZE.width / 2, MAIN_SLOT_POS.y - SLOT_TOUCH_SIZE.height / 2, SLOT_TOUCH_SIZE.width, SLOT_TOUCH_SIZE.height, false)
    GUI:setTouchEnabled(mainTouch, true)
    GUI:addOnClickEvent(mainTouch, function()
        local idx = tonumber(mainIdx or 0) or 0
        if idx > 0 then
            npc.current_idx = idx
            _lg_refresh_main_page(npcid, node)
        end
    end)
    if mainIdx and mainIdx > 0 then
        _lg_attach_drag_widget(node, "main_drag_touch", MAIN_SLOT_POS.x, MAIN_SLOT_POS.y, SL:GetMetaValue("ITEMFROMUI_ENUM").lg_main_drag, mainIdx)
    end

    local otherTouch = GUI:Layout_Create(node, "other_slot_touch", OTHER_SLOT_POS.x - SLOT_TOUCH_SIZE.width / 2, OTHER_SLOT_POS.y - SLOT_TOUCH_SIZE.height / 2, SLOT_TOUCH_SIZE.width, SLOT_TOUCH_SIZE.height, false)
    GUI:setTouchEnabled(otherTouch, true)
    GUI:addOnClickEvent(otherTouch, function()
        local idx = tonumber(otherIdx or 0) or 0
        if idx > 0 then
            npc.current_idx = idx
            _lg_refresh_main_page(npcid, node)
        end
    end)
    if otherIdx and otherIdx > 0 then
        _lg_attach_drag_widget(node, "other_drag_touch", OTHER_SLOT_POS.x, OTHER_SLOT_POS.y, SL:GetMetaValue("ITEMFROMUI_ENUM").lg_other_drag, otherIdx)
    end
end

-- 刷新灵根升级弹窗：预览属性、当前灵根、消耗、升级按钮。
_lg_refresh_upgrade_window = function(npcid, xNode)
    if not xNode then
        return
    end
    GUI:removeAllChildren(xNode)
    local idx = tonumber(npc.current_idx or 0) or 0
    if idx <= 0 then
        idx = npc.data and npc.data.T_data and (npc.data.T_data.main or npc.data.T_data.other) or 1
        npc.current_idx = idx
    end

    _lg_render_preview_scroll(xNode, _lg_build_attr_preview_html(idx))

    local cfg = _lg_root_cfg(idx)
    if cfg then
        _lg_show_root_icon(xNode, "item", UPGRADE_ITEM_POS.x, UPGRADE_ITEM_POS.y, idx, 1.0)
        strokeText(xNode, "title", UPGRADE_ITEM_POS.x, UPGRADE_ITEM_POS.y - 70, 20, ROOT_COLORS[idx] or "#FFFFFF", tostring(cfg.name or "") .. "灵根", "fonts/font4.ttf")
        GUI:setAnchorPoint(GUI:getChildByName(xNode, "title"), 0.5, 0.5)
        -- strokeText(xNode, "lv", UPGRADE_ITEM_POS.x, UPGRADE_ITEM_POS.y - 98, 18, "#FFFFFF", "Lv." .. tostring(_lg_level_value(idx)), "fonts/font4.ttf")
        -- GUI:setAnchorPoint(GUI:getChildByName(xNode, "lv"), 0.5, 0.5)
    end

    local nextCfg = _lg_next_upgrade_cfg(idx)
    _lg_create_cost_items(xNode, nextCfg and nextCfg.cost or nil, UPGRADE_COST_POS)

    local btn = GUI:Button_Create(xNode, "btn_upgrade", UPGRADE_BTN_POS.x, UPGRADE_BTN_POS.y, "res/custom/linggen/new/updata/btn_upgrade.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        if idx > 0 and not _lg_is_max_level(idx) then
            SL:SendLuaNetMsg(100, npcid, 5, idx, "")
        end
    end)

    if _lg_is_max_level(idx) then
        strokeText(xNode, "max_tip", UPGRADE_BTN_POS.x, UPGRADE_BTN_POS.y + 76, 18, "#7CFF7C", "当前灵根已满级", "fonts/font4.ttf")
        GUI:setAnchorPoint(GUI:getChildByName(xNode, "max_tip"), 0.5, 0.5)
    elseif nextCfg and checkItemNum(nextCfg.cost) then
        NPC_UI_HELPER.redpoint_create(btn, {x = 120, y = 46})
        NPC_UI_HELPER.tryStartXylGuide(npc, btn, xNode, "linggen_upgrade_" .. tostring(idx), {
            taskName = "升级灵根",
            dir = 5,
            desc = "点击升级灵根",
        })
    end
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureMainWindow(npcid)
        _lg_refresh_main_page(npcid, npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        ensureMainWindow(npcid)
        _lg_refresh_main_page(npcid, npc.node)
        if npc.xjm_node then
            _lg_refresh_upgrade_window(npcid, npc.xjm_node)
        end
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        local xNode = ensureUpgradeWindow(npcid)
        _lg_refresh_upgrade_window(npcid, xNode)
    end
end

return npc
