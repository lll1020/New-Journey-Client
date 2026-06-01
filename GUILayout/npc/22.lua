local npc = {}
npc._config = teshudata["npc_22"]

local MAIN_WINDOW_OPTS = {
    -- 主界面背景与关闭按钮配置
    background = {skin = "res/custom/linggen/new/main/bg/eff_1.png", eff = false},
    closeButton = {x = 926 - 43 + 135, y = 556 - 43, skin = "res/wy/public/close_red_big.png"},
}
local MAIN_DESIGN_SIZE = {width = 1136, height = 640}
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
    -- 左侧五行灵根竖排，基础/觉醒形态由右侧卡片展示。
    startX = 88,
    startY = 500,
    gapX = 0,
    gapY = 88,
    cols = 1,
}
-- 单个顶部灵根格子的尺寸
local ROOT_SLOT_SIZE = {width = 70, height = 74}
-- 顶部灵根图标缩放
local ROOT_ICON_SCALE = 0.62
-- 选中框相对格子中心的偏移
local ROOT_SELECTED_OFFSET = {x = 0, y = 0}
-- 等级条相对格子左下角的位置
local ROOT_LEVEL_BAR_OFFSET = {x = -5, y = -14}
-- 等级文字在等级条上的位置
local ROOT_LEVEL_TEXT_POS = {x = 35, y = -1}

-- 主灵根槽位中心坐标
local MAIN_SLOT_POS = {x = 407, y = 282}
-- 主灵根图标实际渲染位置
local MAIN_SLOT_ITEM_POS = {x = 407, y = 282}
-- 本命灵根点击命中区域尺寸
local SLOT_TOUCH_SIZE = {width = 125, height = 110}
-- 本命灵根名字相对槽位中心的纵向偏移
local SLOT_NAME_OFFSET_Y = -146
-- 左下“灵根总体属性”文本区域左下角
local ATTR_BOX_POS = {x = 696, y = 258, anchorX = "right", anchorY = "top"}
-- 左下“灵根总体属性”文本区域宽高
local ATTR_BOX_SIZE = {width = 350, height = 156}
-- 中间拖入卸下框的左下角坐标
local UNEQUIP_DROP_POS = {x = 300, y = 346}
-- 中间拖入卸下框的尺寸
local UNEQUIP_DROP_SIZE = {width = 410, height = 175}
local SKILL_PANEL_GROUP = {x = 596, y = 122, gapY = 88, titleGapY = 104, width = 358, titleWidth = 234, rightMargin = 30, anchorX = "right", anchorY = "bottom", minBottomY = 30}
local SKILL_PANEL_CHILD_POS = {iconX = 54, iconY = 52, textX = 108, textY = 84, textWidth = 226, fontSize = 14}
-- 中间升级按钮位置
local PAGE_UPGRADE_BTN_POS = {x = 760, y = 45, minY = 81}
-- 主灵根空槽位下方“装配”按钮位置
local MAIN_EQUIP_BTN_POS = {x = 92, y = 62, minY = 64}
local DUAL_SWITCH_BTN_POS = {x = 616, y = 45, minY = 36}

local MAIN_STATIC_PARTS = {
    {name = "attr_panel", x = 620, y = 250, width = 386, rightMargin = 30, anchorX = "right", anchorY = "top", skin = "res/custom/linggen/new/main/itme3.png"},
    {name = "attr_title", x = 640, y = 438, width = 188, follow = "attr_panel", followCenter = true, anchorX = "right", anchorY = "top", skin = "res/custom/linggen/new/main/itme4.png"},
    {name = "skill_panel_passive", x = SKILL_PANEL_GROUP.x, group = "skill_panel", offsetY = 0, width = SKILL_PANEL_GROUP.width, rightMargin = SKILL_PANEL_GROUP.rightMargin, anchorX = SKILL_PANEL_GROUP.anchorX, skin = "res/custom/linggen/new/main/itme2.png"},
    {name = "skill_panel_synergy", x = SKILL_PANEL_GROUP.x, group = "skill_panel", offsetY = -SKILL_PANEL_GROUP.gapY, width = SKILL_PANEL_GROUP.width, rightMargin = SKILL_PANEL_GROUP.rightMargin, anchorX = SKILL_PANEL_GROUP.anchorX, skin = "res/custom/linggen/new/main/itme2.png"},
    {name = "skill_title", x = SKILL_PANEL_GROUP.x, group = "skill_panel", offsetY = SKILL_PANEL_GROUP.titleGapY, width = SKILL_PANEL_GROUP.titleWidth, follow = "skill_panel_passive", followCenter = true, anchorX = SKILL_PANEL_GROUP.anchorX, skin = "res/custom/linggen/new/main/itme1.png"},
}
local FORM_CARD_POS = {
    basic = {x = 188, y = 314 - 50, anchorX = "left", anchorY = "top", title = "基础形态"},
    awaken = {x = 188, y = 110 - 50, anchorX = "left", anchorY = "top", title = "觉醒形态"},
}
local FORM_CARD_SIZE = {width = 135, height = 161}

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
    ["惊雷斩"] = "jin_force",
    ["万物回春"] = "mu_force",
    ["寻宝天眼"] = "shui_force",
    ["烈焰旋风"] = "huo_force",
    ["山河霸体"] = "tu_force",
    ["雷霆灭世斩"] = "jiu_zhong_tian_lei",
    ["风影重生"] = "ji_feng",
    ["寒霜祈运"] = "ji_bing_han_dong",
    ["焚天炼狱"] = "fen_tian_lie_huo",
    ["镇岳结界"] = "jian_ru_pan_shi",
}
local SKILL_ICON_BY_ROOT = {
    [1] = {passive = "jin_force", synergy = "gang_sha"},
    [2] = {passive = "mu_force", synergy = "fu_su"},
    [3] = {passive = "shui_force", synergy = "chi_huan"},
    [4] = {passive = "huo_force", synergy = "dian_ran"},
    [5] = {passive = "tu_force", synergy = "tie_bi"},
    [6] = {passive = "jiu_zhong_tian_lei", synergy = "lei_shan"},
    [7] = {passive = "ji_feng", synergy = "fu_su"},
    [8] = {passive = "ji_bing_han_dong", synergy = "bing_dong"},
    [9] = {passive = "fen_tian_lie_huo", synergy = "tian_huo"},
    [10] = {passive = "jian_ru_pan_shi", synergy = "gu_ruo_jin_tang"},
}

local _lg_refresh_main_page
local _lg_refresh_upgrade_window

-- 绑定本命灵根拖拽到中间卸下区域的移动事件。
local function _lg_bind_move_events(npcid)
    if npc._moveEventBound then
        return
    end
    -- 灵根卸下已改为按钮操作，这里不再注册拖拽卸下事件。
    npc._moveEventBound = true
end

local function _lg_screen_size()
    local sw = tonumber((cogin and cogin.w) or (SL and SL.GetMetaValue and SL:GetMetaValue("SCREEN_WIDTH")) or MAIN_DESIGN_SIZE.width) or MAIN_DESIGN_SIZE.width
    local sh = tonumber((cogin and cogin.h) or (SL and SL.GetMetaValue and SL:GetMetaValue("SCREEN_HEIGHT")) or MAIN_DESIGN_SIZE.height) or MAIN_DESIGN_SIZE.height
    return sw, sh
end

local function _lg_adapt_x(x, anchor)
    local sw = _lg_screen_size()
    local offsetX = (sw - MAIN_DESIGN_SIZE.width) / 2
    x = tonumber(x or 0) or 0
    if anchor == "right" then
        return x + offsetX
    elseif anchor == "center" then
        return x
    end
    return x - offsetX
end

local function _lg_adapt_y(y, anchor, minY)
    local _, sh = _lg_screen_size()
    local offsetY = (sh - MAIN_DESIGN_SIZE.height) / 2
    y = tonumber(y or 0) or 0
    minY = tonumber(minY)
    if anchor == "top" then
        return y + offsetY
    elseif anchor == "center" then
        return y
    end
    local ret = y - offsetY
    if minY then
        ret = math.max(minY, ret)
    end
    return ret
end

local function _lg_adapt_pos(pos, defaultAnchorX, defaultAnchorY)
    return {
        x = _lg_adapt_x(pos and pos.x or 0, pos and pos.anchorX or defaultAnchorX),
        y = _lg_adapt_y(pos and pos.y or 0, pos and pos.anchorY or defaultAnchorY, pos and pos.minY),
    }
end

local function _lg_right_aligned_x(width, rightMargin)
    return MAIN_DESIGN_SIZE.width - (tonumber(rightMargin or 70) or 70) - (tonumber(width or 0) or 0)
end

local function _lg_part_base_x(part)
    if part and part.rightMargin and part.width then
        return _lg_right_aligned_x(part.width, part.rightMargin)
    end
    return part and part.x or 0
end

local function _lg_group_base_y(group)
    if group == "skill_panel" then
        local bottomY = _lg_adapt_y(SKILL_PANEL_GROUP.y - SKILL_PANEL_GROUP.gapY, SKILL_PANEL_GROUP.anchorY)
        local minBottomY = tonumber(SKILL_PANEL_GROUP.minBottomY or 0) or 0
        return SKILL_PANEL_GROUP.y + math.max(0, minBottomY - bottomY)
    end
    return 0
end

local function _lg_group_y(group, offsetY)
    if group == "skill_panel" then
        return _lg_adapt_y(_lg_group_base_y(group) + (tonumber(offsetY or 0) or 0), SKILL_PANEL_GROUP.anchorY)
    end
    return _lg_adapt_y(tonumber(offsetY or 0) or 0, "bottom")
end

-- 创建主界面窗口并缓存引用。
local function ensureMainWindow(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, MAIN_WINDOW_OPTS)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    GUI:setLocalZOrder(GUI:Frames_Create(npc.bg, "bg_eff", 0, 0, "res/custom/linggen/new/main/bg/eff_", ".png", 1, 15, {speed = 100, count = 15, loop = -1}), 1)

    if npc._window.parent then
        GUI:setPosition(npc._window.parent, cogin.w / 2, cogin.h / 2)
    end
    return npc.node
end

-- 创建升级弹窗并缓存引用。
local function ensureUpgradeWindow(npcid)
    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, UPGRADE_WINDOW_OPTS)
    npc.xjm_node = npc.xjm_window and npc.xjm_window.node or nil
    return npc.xjm_node
end
-- 任务完成后同时关闭灵根主界面和升级弹窗，避免残留窗口。
local function _lg_close_all_windows()
    NPC_UI_HELPER.closeWindow(npc.xjm_window)
    npc.xjm_window = nil
    npc.xjm_node = nil
    NPC_UI_HELPER.closeWindow(npc._window)
end
-- 旧版 xyl 灵根装配任务已废弃，保留空实现兼容历史调用点。
local function _lg_try_finish_xyl_and_close()
    return false
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

-- 返回第一个已激活的灵根，用于主灵根未装配时的默认选中。
local function _lg_first_active_idx()
    for idx, _ in ipairs(npc._config.main_r or {}) do
        if _lg_has_root(idx) then
            return idx
        end
    end
    return 0
end

-- 进入界面时默认优先选中主灵根，否则选中当前已激活的灵根。
local function _lg_default_selected_idx()
    local mainIdx = tonumber(npc.data and npc.data.T_data and npc.data.T_data.main or 0) or 0
    if mainIdx > 0 then
        return mainIdx
    end
    local activeIdx = _lg_first_active_idx()
    if activeIdx > 0 then
        return activeIdx
    end
    return 1
end

local function _lg_get_current_xyl_task_name()
    return tostring(rawget(_G, "XYL_CURRENT_TASK_NAME") or "")
end

-- 灵根界面内的异闻录任务引导封装，统一按任务名匹配并绑定到具体按钮/格子。
local function _lg_try_xyl_guide(button, parent, marker, taskNames, desc, opts)
    opts = opts or {}
    return NPC_UI_HELPER.tryStartXylGuide(npc, button, parent, marker, {
        taskNames = taskNames,
        desc = desc,
        dir = opts.dir or 3,
        isForce = opts.isForce == true,
        hideMask = opts.hideMask,
        once = opts.once,
        idx = opts.idx,
    })
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
    local lv = math.max(1, math.min(10, math.floor(scale - _lg_base_ratio() + 0.5)))
    for _, one in ipairs(cfg.attr or {}) do
        local v1 = tonumber(one[2]) or 0
        local v10 = tonumber(one[3])
        local value = v10 and (v1 + (v10 - v1) * (lv - 1) / 9) or (v1 * scale)
        table.insert(attrList, {one[1], _lg_round_value(value)})
    end
    return attrList
end

-- 生成指定灵根当前/预览等级下的特殊效果列表，特殊效果不走 Player 属性表。
local function _lg_build_special_list(idx, extraLevel)
    local cfg = _lg_root_cfg(idx)
    local scale = _lg_effect_scale(idx, extraLevel)
    local list = {}
    if not cfg or scale <= 0 then
        return list
    end
    local lv = math.max(1, math.min(10, math.floor(scale - _lg_base_ratio() + 0.5)))
    for _, one in ipairs(cfg.special or {}) do
        local v1 = tonumber(one.v1 or one[2]) or 0
        local v10 = tonumber(one.v10 or one[3])
        local value = v10 and (v1 + (v10 - v1) * (lv - 1) / 9) or (v1 * scale)
        list[#list + 1] = {
            key = one.key,
            name = one.name or one[1] or one.key or "特殊效果",
            value = _lg_round_value(value),
            unit = one.unit or "",
        }
    end
    return list
end

-- 生成用于技能描述展示的倍率文本。
local function _lg_format_scale_text(idx, extraLevel)
    local scale = _lg_effect_scale(idx, extraLevel)
    if scale <= 0 then
        return "0.0"
    end
    -- 直接回显当前倍率值，避免继续显示占位文本。
    return string.format("%.1f", scale)
end

-- 将数值格式化为更适合文案展示的文本：整数不带小数，小数最多保留两位。
local function _lg_format_effect_number(value)
    value = tonumber(value) or 0
    if math.abs(value - math.floor(value + 0.5)) < 0.0001 then
        return tostring(math.floor(value + 0.5))
    end
    local text = string.format("%.2f", value)
    text = text:gsub("0+$", "")
    text = text:gsub("%.$", "")
    return text
end

-- 将灵根效果文案中的“5000*灵根倍率+2000”一类公式直接结算为实际数值。
local function _lg_strip_html(text)
    local plain = tostring(text or "")
    plain = plain:gsub("<[^>]->", "")
    plain = plain:gsub("^%s+", "")
    plain = plain:gsub("%s+$", "")
    return plain
end

local function _lg_sum_attr_map(attrs)
    local sum = {}
    for _, attr in ipairs(attrs or {}) do
        local attrId = tonumber(attr[1]) or 0
        if attrId > 0 then
            sum[attrId] = (sum[attrId] or 0) + (tonumber(attr[2]) or 0)
        end
    end
    return sum
end

local _lg_resolve_effect_text
local _lg_is_max_level

local function _lg_format_effect_preview_text(template, baseValue, idx)
    local currentText = _lg_resolve_effect_text(template, baseValue, idx, 0)
    if _lg_is_max_level(idx) then
        return currentText
    end
    local nextText = _lg_resolve_effect_text(template, baseValue, idx, 1)
    local currentValue = currentText:match("%[(.-)%]")
    local nextValue = nextText:match("%[(.-)%]")
    if currentValue and nextValue and currentValue ~= nextValue then
        local previewContent = string.format(
            "<font color='#FFFFFF'>%s</font><font color='#8C6B35'> -> </font><font color='#4DA3FF'>%s</font>",
            currentValue,
            nextValue
        )
        currentText = currentText:gsub("%[.-%]", function()
            return "[" .. previewContent .. "]"
        end, 1)
    end
    return currentText
end

local function _lg_build_effect_preview_lines(titleColor, titleText, template, baseValue, idx)
    return {
        string.format("<font color='%s'>%s</font>", titleColor or "#FFFFFF", titleText or ""),
        "　　" .. tostring(_lg_format_effect_preview_text(template, baseValue, idx) or "")
    }
end

_lg_resolve_effect_text = function(template, baseValue, idx, extraLevel)
    template = tostring(template or "")
    if template == "" then
        return ""
    end
    local scale = _lg_effect_scale(idx, extraLevel)
    if scale <= 0 then
        scale = 0
    end
    local formatted = string.format(template, tostring(baseValue or 0), _lg_format_effect_number(scale))
    formatted = formatted:gsub("([%d%.]+)%%%*([%d%.]+)%+([%d%.]+)%%", function(base, mul, add)
        local result = (tonumber(base) or 0) * (tonumber(mul) or 0) + (tonumber(add) or 0)
        return _lg_format_effect_number(result) .. "%"
    end)
    formatted = formatted:gsub("([%d%.]+)%*([%d%.]+)%+([%d%.]+)", function(base, mul, add)
        local result = (tonumber(base) or 0) * (tonumber(mul) or 0) + (tonumber(add) or 0)
        return _lg_format_effect_number(result)
    end)
    return formatted
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
_lg_is_max_level = function(idx)
    return _lg_level_value(idx) >= tonumber(npc._config.main_updata.max_level or 0)
end

local function _lg_can_upgrade(idx)
    if not idx or idx <= 0 or not _lg_has_root(idx) or _lg_is_max_level(idx) then
        return false
    end
    local nextCfg = _lg_next_upgrade_cfg(idx)
    return nextCfg and checkItemNum(nextCfg.cost) or false
end

local function _lg_unlock_chance()
    return tonumber(npc.data and npc.data.T_data and npc.data.T_data.unlock_chance or 0) or 0
end

local function _lg_can_unlock_basic(idx)
    return idx and idx >= 1 and idx <= 5 and (not _lg_has_root(idx)) and _lg_unlock_chance() > 0
end

local function _lg_can_dual_switch(mainIdx)
    mainIdx = tonumber(mainIdx or 0) or 0
    local pairIdx = npc._config and npc._config.awaken_pairs and npc._config.awaken_pairs[mainIdx] or nil
    return pairIdx and pairIdx > 0 and _lg_has_root(pairIdx), pairIdx
end

local function _lg_base_root_idx(idx)
    idx = tonumber(idx or 0) or 0
    if idx <= 0 then
        return 0
    end
    if idx <= 5 then
        return idx
    end
    return tonumber(npc._config and npc._config.awaken_pairs and npc._config.awaken_pairs[idx] or 0) or 0
end

local function _lg_awaken_root_idx(idx)
    idx = tonumber(idx or 0) or 0
    if idx <= 0 then
        return 0
    end
    if idx > 5 then
        return idx
    end
    return tonumber(npc._config and npc._config.awaken_pairs and npc._config.awaken_pairs[idx] or 0) or 0
end

local function _lg_element_card_path(idx)
    local baseIdx = _lg_base_root_idx(idx)
    if baseIdx <= 0 then
        baseIdx = math.max(1, math.min(5, tonumber(idx or 1) or 1))
    end
    return "res/custom/linggen/new/main/x_" .. tostring(baseIdx) .. ".png"
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

-- 汇总当前所有已激活灵根的特殊效果。
local function _lg_collect_total_specials()
    local list = {}
    for idx, _ in pairs(_lg_level_map()) do
        idx = tonumber(idx) or 0
        for _, one in ipairs(_lg_build_special_list(idx, 0)) do
            list[#list + 1] = one
        end
    end
    return list
end

-- 解析 Player:showAttr 的单条结果，复用原属性名、颜色和百分比格式。
local function _lg_attr_display_parts(attrId, value)
    local html = _lg_strip_html(Player:showAttr({{attrId, value}}))
    local name, textValue = html:match("^(.-)%+(.+)$")
    local attConfig = SL:GetMetaValue("ATTR_CONFIG", attrId)
    return tostring(name or attrId or ""), tostring(textValue or value or 0), (attConfig and attConfig.color) or 255
end

local function _lg_attr_color_hex(color)
    return SL:GetHexColorByStyleId(color or 255)
end

local function _lg_total_attr_line(name, valueText, color)
    return string.format("<font color='%s'>%s+%s</font>", _lg_attr_color_hex(color), tostring(name or ""), tostring(valueText or 0))
end

-- 将同 ID 属性先累加，再把攻击/魔法/道术/防御/魔防上下限合并为一条范围。
local function _lg_build_total_attr_lines(attrs)
    local sum = _lg_sum_attr_map(attrs)

    local rangePairs = {
        {low = 3, high = 4, name = "攻击"},
        {low = 5, high = 6, name = "魔法"},
        {low = 7, high = 8, name = "道术"},
        {low = 9, high = 10, name = "防御"},
        {low = 11, high = 12, name = "魔防"},
    }
    local consumed = {}
    local rangeLineByLow = {}
    for _, pair in ipairs(rangePairs) do
        if sum[pair.low] ~= nil and sum[pair.high] ~= nil then
            local _, lowText, color = _lg_attr_display_parts(pair.low, sum[pair.low])
            local _, highText = _lg_attr_display_parts(pair.high, sum[pair.high])
            rangeLineByLow[pair.low] = _lg_total_attr_line(pair.name, lowText .. "-" .. highText, color)
            consumed[pair.low] = true
            consumed[pair.high] = true
        end
    end

    local sortedIds = {}
    for attrId, _ in pairs(sum) do
        sortedIds[#sortedIds + 1] = attrId
    end
    table.sort(sortedIds)

    local lines = {}
    for _, attrId in ipairs(sortedIds) do
        if rangeLineByLow[attrId] then
            lines[#lines + 1] = rangeLineByLow[attrId]
        elseif not consumed[attrId] then
            local name, valueText, color = _lg_attr_display_parts(attrId, sum[attrId])
            lines[#lines + 1] = _lg_total_attr_line(name, valueText, color)
        end
    end
    return lines
end

local function _lg_format_special_line(one)
    if not one then
        return ""
    end
    return string.format("<font color='#A7D58D'>%s+%s%s</font>", tostring(one.name or "特殊效果"), tostring(one.value or 0), tostring(one.unit or ""))
end

local function _lg_build_total_special_lines(list)
    local map = {}
    local order = {}
    for _, one in ipairs(list or {}) do
        local key = tostring(one.key or one.name or "")
        if key ~= "" then
            if not map[key] then
                map[key] = {key = key, name = one.name, value = 0, unit = one.unit}
                order[#order + 1] = key
            end
            map[key].value = (tonumber(map[key].value) or 0) + (tonumber(one.value) or 0)
        end
    end
    table.sort(order)
    local lines = {}
    for _, key in ipairs(order) do
        lines[#lines + 1] = _lg_format_special_line(map[key])
    end
    return lines
end

local function _lg_attr_preview_range_line(name, currentText, nextText, color, isMaxLevel)
    local currentLine = _lg_total_attr_line(name, currentText, color)
    if isMaxLevel then
        return currentLine .. "<font color='#8C6B35'> [当前已满级]</font>"
    end
    return string.format(
        "%s<font color='#8C6B35'> -> </font><font color='#4DA3FF'>%s</font><font color='#8C6B35'>[下级属性]</font>",
        currentLine,
        tostring(nextText or 0)
    )
end

-- 升级预览属性同样合并同类、上下限，并按属性 ID 排序。
local function _lg_build_attr_preview_lines(currentAttrs, nextAttrs, isMaxLevel)
    local currentSum = _lg_sum_attr_map(currentAttrs)
    local nextSum = _lg_sum_attr_map(nextAttrs)
    local rangePairs = {
        {low = 3, high = 4, name = "攻击"},
        {low = 5, high = 6, name = "魔法"},
        {low = 7, high = 8, name = "道术"},
        {low = 9, high = 10, name = "防御"},
        {low = 11, high = 12, name = "魔防"},
    }
    local consumed = {}
    local rangeLineByLow = {}
    for _, pair in ipairs(rangePairs) do
        if currentSum[pair.low] ~= nil and currentSum[pair.high] ~= nil then
            local _, curLowText, color = _lg_attr_display_parts(pair.low, currentSum[pair.low])
            local _, curHighText = _lg_attr_display_parts(pair.high, currentSum[pair.high])
            local _, nextLowText = _lg_attr_display_parts(pair.low, nextSum[pair.low] or currentSum[pair.low])
            local _, nextHighText = _lg_attr_display_parts(pair.high, nextSum[pair.high] or currentSum[pair.high])
            rangeLineByLow[pair.low] = _lg_attr_preview_range_line(pair.name, curLowText .. "-" .. curHighText, nextLowText .. "-" .. nextHighText, color, isMaxLevel)
            consumed[pair.low] = true
            consumed[pair.high] = true
        end
    end

    local sortedIds = {}
    for attrId, _ in pairs(currentSum) do
        sortedIds[#sortedIds + 1] = attrId
    end
    table.sort(sortedIds)

    local lines = {}
    for _, attrId in ipairs(sortedIds) do
        if rangeLineByLow[attrId] then
            lines[#lines + 1] = rangeLineByLow[attrId]
        elseif not consumed[attrId] then
            local name, currentText, color = _lg_attr_display_parts(attrId, currentSum[attrId])
            local _, nextText = _lg_attr_display_parts(attrId, nextSum[attrId] or currentSum[attrId])
            lines[#lines + 1] = _lg_attr_preview_range_line(name, currentText, nextText, color, isMaxLevel)
        end
    end
    return lines
end

local function _lg_build_special_preview_lines(currentList, nextList, isMaxLevel)
    local nextMap = {}
    for _, one in ipairs(nextList or {}) do
        nextMap[tostring(one.key or one.name or "")] = one
    end
    local lines = {}
    for _, one in ipairs(currentList or {}) do
        local nextOne = nextMap[tostring(one.key or one.name or "")] or one
        local currentLine = _lg_format_special_line(one)
        if isMaxLevel then
            lines[#lines + 1] = currentLine .. "<font color='#6b6257'>（已满级）</font>"
        else
            lines[#lines + 1] = string.format(
                "%s <font color='#6b6257'>-></font> <font color='#54FF9F'>%s+%s%s</font>",
                currentLine,
                tostring(nextOne.name or one.name or "特殊效果"),
                tostring(nextOne.value or one.value or 0),
                tostring(nextOne.unit or one.unit or "")
            )
        end
    end
    return lines
end

-- 将展示行拆成左右两列显示。
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
    local currentSpecials = _lg_build_special_list(idx, 0)
    local nextSpecials = _lg_build_special_list(idx, 1)
    local lines = {
        string.format("<font color='"..ROOT_COLORS[idx].."'>[%s灵根]</font>", tostring(cfg.name or "")),
        string.format("<font color='#F4D179'>流派：</font><font color='#FFFFFF'>%s</font>", tostring(cfg.flow or "未配置")),
        string.format("<font color='#00FF00'>当前等级：</font><font color='#FFFFFF'>%d</font>", _lg_level_value(idx)),
        "<font color='#FFFFFF'>属性预览：</font>",
    }
    if #currentAttrs == 0 then
        lines[#lines + 1] = "<font color='#FF0000'>当前灵根未激活</font>"
    else
        for _, line in ipairs(_lg_build_attr_preview_lines(currentAttrs, nextAttrs, _lg_is_max_level(idx))) do
            lines[#lines + 1] = line
        end
        for _, line in ipairs(_lg_build_special_preview_lines(currentSpecials, nextSpecials, _lg_is_max_level(idx))) do
            lines[#lines + 1] = line
        end
    end

    lines[#lines + 1] = "<font color='#DE0000'>被动技能：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.passive or "暂无")
    lines[#lines + 1] = "<font color='#4169E1'>主动技能：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.active or "暂未接入主动技能逻辑")
    lines[#lines + 1] = "<font color='#F4D179'>灵兽专属协同：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.synergy or "暂无")
    lines[#lines + 1] = "<font color='#A7D58D'>天书回响共鸣：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.echo_name or "未配置") .. "：" .. tostring(cfg.echo_desc or "")
    lines[#lines + 1] = "<u><font color='#F4D179'>满级技能效果预览：</font></u>"
    lines[#lines + 1] = "　　" .. tostring(cfg.active or "暂未接入主动技能逻辑")
    return table.concat(lines, "\n")
end

-- 构建主界面点击灵根时的只读详情，不展示升级预览值。
local function _lg_build_attr_detail_html(idx)
    if not idx or idx <= 0 then
        return "<font color='#6b6257'>请选择一个灵根</font>"
    end
    local cfg = _lg_root_cfg(idx)
    if not cfg then
        return "<font color='#6b6257'>暂无数据</font>"
    end

    local currentAttrs = _lg_build_attr_list(idx, 0)
    local currentSpecials = _lg_build_special_list(idx, 0)
    local lines = {
        string.format("<font color='"..ROOT_COLORS[idx].."'>[%s灵根]</font>", tostring(cfg.name or "")),
        string.format("<font color='#F4D179'>流派：</font><font color='#FFFFFF'>%s</font>", tostring(cfg.flow or "未配置")),
        string.format("<font color='#00FF00'>当前等级：</font><font color='#FFFFFF'>%d</font>", _lg_level_value(idx)),
        "<font color='#FFFFFF'>当前属性：</font>",
    }

    if #currentAttrs == 0 then
        lines[#lines + 1] = "<font color='#FF0000'>当前灵根未激活</font>"
    else
        for _, line in ipairs(_lg_build_total_attr_lines(currentAttrs)) do
            lines[#lines + 1] = line
        end
        for _, line in ipairs(_lg_build_total_special_lines(currentSpecials)) do
            lines[#lines + 1] = line
        end
    end

    lines[#lines + 1] = "<font color='#DE0000'>被动技能：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.passive or "暂无")
    lines[#lines + 1] = "<font color='#4169E1'>主动技能：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.active or "暂未接入主动技能逻辑")
    lines[#lines + 1] = "<font color='#F4D179'>灵兽专属协同：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.synergy or "暂无")
    lines[#lines + 1] = "<font color='#A7D58D'>天书回响共鸣：</font>"
    lines[#lines + 1] = "　　" .. tostring(cfg.echo_name or "未配置") .. "：" .. tostring(cfg.echo_desc or "")
    lines[#lines + 1] = "<u><font color='#F4D179'>满级技能效果预览：</font></u>"
    lines[#lines + 1] = "　　" .. tostring(cfg.active or "暂未接入主动技能逻辑")
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

local function _lg_render_main_static_parts(parent)
    local rendered = {}
    for _, part in ipairs(MAIN_STATIC_PARTS) do
        local baseX = _lg_part_base_x(part)
        if part.follow and rendered[part.follow] and part.followCenter then
            baseX = rendered[part.follow].baseX + ((rendered[part.follow].width or 0) - (part.width or 0)) / 2
        end
        local partY = part.group and _lg_group_y(part.group, part.offsetY) or _lg_adapt_y(part.y, part.anchorY, part.minY)
        local img = GUI:Image_Create(parent, part.name, _lg_adapt_x(baseX, part.anchorX), partY, part.skin)
        GUI:setLocalZOrder(img, -10)
        rendered[part.name] = {baseX = baseX, width = part.width}
    end
end

-- 将左下总属性区域渲染为可滚动面板，避免属性过多被截断。
local function _lg_render_attr_scroll(parent, attrs, specials)
    local attrPos = _lg_adapt_pos(ATTR_BOX_POS, "right", "top")
    local scroll = GUI:ScrollView_Create(parent, "attr_scroll", attrPos.x + 60, attrPos.y + 9, ATTR_BOX_SIZE.width, ATTR_BOX_SIZE.height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, ATTR_BOX_SIZE.width, ATTR_BOX_SIZE.height)

    if (not attrs or #attrs <= 0) and (not specials or #specials <= 0) then
        local emptyText = richText(scroll, "total_attr_empty", 0, ATTR_BOX_SIZE.height - 10, "<font color='#6b6257'>暂无已激活灵根属性</font>", ATTR_BOX_SIZE.width, 15, 1)
        GUI:setAnchorPoint(emptyText, 0, 1)
        return scroll
    end

    local displayLines = _lg_build_total_attr_lines(attrs)
    for _, line in ipairs(_lg_build_total_special_lines(specials)) do
        displayLines[#displayLines + 1] = line
    end
    local line1Attrs, line2Attrs = _lg_split_attr_lines(displayLines)
    local colWidth = math.floor(ATTR_BOX_SIZE.width / 2) - 8
    local line1 = richText(scroll, "total_attr_1", 0, ATTR_BOX_SIZE.height - 10, table.concat(line1Attrs, "\n"), colWidth, 15, 1)
    GUI:setAnchorPoint(line1, 0, 1)
    local line2 = richText(scroll, "total_attr_2", colWidth + 14, ATTR_BOX_SIZE.height - 10, table.concat(line2Attrs, "\n"), colWidth, 15, 1)
    GUI:setAnchorPoint(line2, 0, 1)

    local h1 = GUI:getBoundingBox(line1).height
    local h2 = GUI:getBoundingBox(line2).height
    local innerH = math.max(ATTR_BOX_SIZE.height, math.max(h1, h2) + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, ATTR_BOX_SIZE.width, innerH)
    GUI:setPosition(line1, 0, innerH - 10)
    GUI:setPosition(line2, colWidth + 14, innerH - 10)
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

local function _lg_render_form_card(parent, name, idx, pos, npcid)
    if not idx or idx <= 0 or not pos then
        return nil
    end
    local active = _lg_has_root(idx)
    local cardPos = _lg_adapt_pos(pos, "left", "center")
    local card = GUI:Image_Create(parent, name .. "_card", cardPos.x, cardPos.y, _lg_element_card_path(idx))
    GUI:setLocalZOrder(card, -4)
    if not active then
        GUI:Image_setGrey(card, true)
    end

    local title = strokeText(parent, name .. "_title", cardPos.x + FORM_CARD_SIZE.width / 2, cardPos.y + FORM_CARD_SIZE.height + 18, 18, "#F4D179", pos.title or "", "fonts/font4.ttf")
    GUI:setAnchorPoint(title, 0.5, 0.5)
    -- local icon = _lg_show_root_icon(parent, name .. "_item", cardPos.x + FORM_CARD_SIZE.width / 2, cardPos.y + 86, idx, 0.78)
    if icon and not active then
        GUI:Image_setGrey(icon, true)
    end

    local cfg = _lg_root_cfg(idx) or {}
    local stateText = active and ("Lv." .. tostring(_lg_level_value(idx))) or "未激活"
    local label = strokeText(parent, name .. "_state", cardPos.x + FORM_CARD_SIZE.width / 2, cardPos.y + 18, 15, active and "#FFFFFF" or "#9B9B9B", stateText, "fonts/font4.ttf")
    GUI:setAnchorPoint(label, 0.5, 0.5)

    local touch = GUI:Layout_Create(parent, name .. "_touch", cardPos.x, cardPos.y, FORM_CARD_SIZE.width, FORM_CARD_SIZE.height, false)
    GUI:setTouchEnabled(touch, true)
    GUI:addOnClickEvent(touch, function()
        if active then
            npc.current_idx = idx
            _lg_refresh_main_page(npcid, parent)
            return
        end
        if idx <= 5 and _lg_can_unlock_basic(idx) then
            SL:OpenCommonTipsPop({
                str = string.format("确定消耗1次基础灵根解锁，选择【%s灵根】吗？", tostring(cfg.name or "")),
                btnType = 2,
                callback = function(atype)
                    if atype == 1 then
                        SL:SendLuaNetMsg(100, npcid, 1, idx, "")
                    end
                end,
            })
        else
            SL:ShowSystemTips(idx > 5 and "请先完成对应基础灵根试炼觉醒" or "该灵根未激活，暂无解锁机会")
        end
    end)
    return card
end

local function _lg_render_left_form_cards(parent, npcid, idx)
    local baseIdx = _lg_base_root_idx(idx)
    if baseIdx <= 0 then
        baseIdx = math.max(1, math.min(5, tonumber(idx or 1) or 1))
    end
    _lg_render_form_card(parent, "form_basic", baseIdx, FORM_CARD_POS.basic, npcid)
    local awakenIdx = _lg_awaken_root_idx(baseIdx)
    if awakenIdx > 0 then
        _lg_render_form_card(parent, "form_awaken", awakenIdx, FORM_CARD_POS.awaken, npcid)
    end
end

-- 在本命灵根槽位下方绘制灵根名称。
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
    -- 保留旧函数名，当前版本不再显示拖拽卸下区域。
    return nil
end

-- 为本命灵根槽位挂载拖拽控件，并绑定拖拽中跟随显示与卸下提示。
local function _lg_attach_drag_widget(parent, name, x, y, moveType, beginIdx)
    -- 保留旧函数名，避免旧调用报错；当前版本不再挂拖拽控件。
    return nil
end

-- 渲染右下当前激活灵根：图标 + 对应技能效果说明。
local function _lg_render_skill_icons(parent)
    local mainIdx = npc.data and npc.data.T_data and npc.data.T_data.main or 0
    local mainCfg = _lg_root_cfg(mainIdx)

    local function renderOne(name, panelName, sourceText, color, iconKey)
        if tostring(sourceText or "") == "" then
            return
        end
        local panel = GUI:getChildByName(parent, panelName)
        if not panel then
            return
        end
        local icon = GUI:Image_Create(panel, name, SKILL_PANEL_CHILD_POS.iconX, SKILL_PANEL_CHILD_POS.iconY, _lg_skill_icon_path(iconKey))
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        local size = GUI:getContentSize(icon)
        if size and size.width > 0 then
            local s = math.min(58 / size.width, 58 / size.height)
            GUI:setScale(icon, s)
        end
        -- GUI:addOnClickEvent(icon, function()
        --     if sourceText and sourceText ~= "" then
        --         local posWorld = GUI:getWorldPosition(icon)
        --         SL:OpenCommonDescTipsPop({
        --             str = tostring(sourceText),
        --             worldPos = {x = posWorld.x, y = posWorld.y},
        --             anchorPoint = {x = 0, y = 0},
        --             formatWay = 1,
        --         })
        --     end
        -- end)
        GUI:setTouchEnabled(icon, true)
        local effect = richText(panel, name .. "_effect", SKILL_PANEL_CHILD_POS.textX, SKILL_PANEL_CHILD_POS.textY, string.format("<font color='%s'>%s</font>", color or "#9FE2FF", tostring(sourceText or "")), SKILL_PANEL_CHILD_POS.textWidth, SKILL_PANEL_CHILD_POS.fontSize, 1)
        GUI:setAnchorPoint(effect, 0, 1)
    end

    local iconCfg = SKILL_ICON_BY_ROOT[tonumber(mainIdx or 0) or 0] or {}
    renderOne("skill_passive", "skill_panel_passive", mainCfg and mainCfg.passive or "", "#9FE2FF", iconCfg.passive)
    renderOne("skill_synergy", "skill_panel_synergy", mainCfg and mainCfg.synergy or "", "#F4D179", iconCfg.synergy)
end

-- 刷新灵根主界面：顶部列表、主副槽位、属性区、技能区、装配/升级入口。
_lg_refresh_main_page = function(npcid, node)
    GUI:removeAllChildren(node)
    _lg_bind_move_events(npcid)
    _lg_render_main_static_parts(node)

    local selectedIdx = tonumber(npc.current_idx or 0) or 0
    if selectedIdx <= 0 then
        selectedIdx = _lg_default_selected_idx()
        npc.current_idx = selectedIdx
    end
    local mainIdx = npc.data and npc.data.T_data and npc.data.T_data.main or 0
    _lg_render_left_form_cards(node, npcid, (mainIdx and mainIdx > 0) and mainIdx or selectedIdx)

    for idx, cfg in ipairs(npc._config.main_r or {}) do
        if idx > 5 then
            break
        end
        local row = math.floor((idx - 1) / ROOT_GRID_POS.cols)
        local col = (idx - 1) % ROOT_GRID_POS.cols
        local x = _lg_adapt_x(ROOT_GRID_POS.startX + col * ROOT_GRID_POS.gapX, "left")
        local y = _lg_adapt_y(ROOT_GRID_POS.startY - row * ROOT_GRID_POS.gapY, "top")
        -- 每个灵根格子都提前缓存激活状态，后续点击与置灰共用同一份判断。
        local rootActive = _lg_has_root(idx)
        local slot = GUI:Layout_Create(node, "root_slot_" .. idx, x - ROOT_SLOT_SIZE.width / 2, y - ROOT_SLOT_SIZE.height / 2, ROOT_SLOT_SIZE.width, ROOT_SLOT_SIZE.height, false)
        GUI:Image_Create(slot, "bg", 0, 0, "res/custom/linggen/new/main/slot_bg.png")
        local rootItem = _lg_show_root_icon(slot, "item", ROOT_SLOT_SIZE.width / 2, ROOT_SLOT_SIZE.height / 2, idx, ROOT_ICON_SCALE)
        GUI:setTouchEnabled(slot, rootActive or _lg_can_unlock_basic(idx))
        if _lg_can_unlock_basic(idx) then
            _lg_try_xyl_guide(slot, node, "unlock_basic_root", {"本命灵根", "选择你的本命灵根"}, "点击解锁基础灵根", {
                dir = 3,
                isForce = true,
                hideMask = false,
                once = true,
                idx = idx,
            })
        end
        GUI:addOnTouchEvent(slot, function(sender, type)
            -- 未激活灵根只保留灰态展示，不允许再被选中或触发长按预览。
            if not rootActive then
                sender._clicking = false
                if type == SLDefine.TouchEventType.ended then
                    if _lg_can_unlock_basic(idx) then
                        local cfg = _lg_root_cfg(idx) or {}
                        SL:OpenCommonTipsPop({
                            str = string.format("确定消耗1次基础灵根解锁，选择【%s灵根】吗？", tostring(cfg.name or "")),
                            btnType = 2,
                            callback = function(atype)
                                if atype == 1 then
                                    SL:SendLuaNetMsg(100, npcid, 1, idx, "")
                                end
                            end,
                        })
                    else
                        SL:ShowSystemTips(idx <= 5 and "该灵根未激活，暂无解锁机会" or "请先完成对应基础灵根试炼觉醒")
                    end
                end
                return
            end
            -- 触发控件（sender）：控件本身
            -- 事件类型（type）：触摸阶段 0-3
            if type == SLDefine.TouchEventType.began then           -- 0 触摸开始
                
                if not sender._clicking then
                    sender._clicking = true
                    SL:scheduleOnce(sender, function()
                        if sender._clicking then
                            local pos = GUI:getWorldPosition(slot)
                            local attrTipPos = _lg_adapt_pos(ATTR_BOX_POS, "right", "top")
                            SL:OpenCommonDescTipsPop({str = _lg_build_attr_detail_html(idx), worldPos = {x = attrTipPos.x, y = attrTipPos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
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
            GUI:Image_setGrey(rootItem, not rootActive)
        end
        if _lg_can_upgrade(idx) then
            local upgradeMark = GUI:Image_Create(slot, "upgrade_mark", ROOT_SLOT_SIZE.width + 8, 0, "res/wy/public/upup.png")
            GUI:setAnchorPoint(upgradeMark, 1, 0)
            GUI:setLocalZOrder(upgradeMark, 98)
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

    -- if mainIdx and mainIdx > 0 then
    --     local mainItemPos = _lg_adapt_pos(MAIN_SLOT_ITEM_POS, "center", "center")
    --     _lg_show_root_icon(node, "main_item", mainItemPos.x, mainItemPos.y, mainIdx, 1.42)
    --     _lg_create_slot_name(node, "main_name", mainItemPos.x, mainItemPos.y, mainIdx)
    --     local pairIdx = npc._config and npc._config.awaken_pairs and npc._config.awaken_pairs[mainIdx] or nil
    --     if mainIdx <= 5 and pairIdx and not _lg_has_root(pairIdx) then
    --         local awakenTip = strokeText(node, "awaken_tip", mainItemPos.x + 72, mainItemPos.y + 18, 18, "#FF6B4A", "未觉醒", "fonts/font4.ttf")
    --         GUI:setAnchorPoint(awakenTip, 0.5, 0.5)
    --         GUI:setTouchEnabled(awakenTip, true)
    --         GUI:addOnClickEvent(awakenTip, function()
    --             local pairCfg = _lg_root_cfg(pairIdx) or {}
    --             SL:ShowSystemTips("请前往四大陆灵根试炼NPC处觉醒" .. tostring(pairCfg.name or "") .. "灵根")
    --         end)
    --     elseif pairIdx and _lg_has_root(pairIdx) then
    --         local okText = strokeText(node, "awaken_tip", mainItemPos.x + 72, mainItemPos.y + 18, 18, "#54FF9F", "已觉醒", "fonts/font4.ttf")
    --         GUI:setAnchorPoint(okText, 0.5, 0.5)
    --     end
    -- end
    local mainTipPos = _lg_adapt_pos(MAIN_SLOT_ITEM_POS, "center", "center")
    strokeText(node, "unlock_chance_tip", 100, mainTipPos.y + 92 + 230, 20, "#F4D179", "基础灵根点数：" .. tostring(_lg_unlock_chance()), "fonts/font4.ttf")
    GUI:setAnchorPoint(GUI:getChildByName(node, "unlock_chance_tip"), 0, 0.5)

    _lg_render_attr_scroll(node, _lg_collect_total_attrs(), _lg_collect_total_specials())

    _lg_render_skill_icons(node)

    if selectedIdx > 0 and _lg_has_root(selectedIdx) and (not mainIdx or mainIdx <= 0) then
        local equipPos = _lg_adapt_pos(MAIN_EQUIP_BTN_POS, "left", "bottom")
        local btnEquipMain = GUI:Button_Create(node, "btn_equip_main", equipPos.x, equipPos.y, "res/custom/linggen/new/main/btn_equip.png")
        GUI:setAnchorPoint(btnEquipMain, 0.5, 0.5)
        _lg_try_xyl_guide(btnEquipMain, node, "equip_main_root", {"本命灵根", "选择你的本命灵根"}, "点击设为本命灵根", {
            dir = 3,
            isForce = true,
            hideMask = false,
        })
        GUI:addOnClickEvent(btnEquipMain, function()
            SL:SendLuaNetMsg(100, npcid, 2, selectedIdx, "")
        end)
    elseif mainIdx and mainIdx > 0 then
        local equipPos = _lg_adapt_pos(MAIN_EQUIP_BTN_POS, "left", "bottom")
        local btnUnequipMain = GUI:Button_Create(node, "btn_unequip_main", equipPos.x, equipPos.y, "res/custom/linggen/new/main/btn_unequip.png")
        GUI:setAnchorPoint(btnUnequipMain, 0.5, 0.5)
        GUI:addOnClickEvent(btnUnequipMain, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
    end
    local canSwitch, pairIdx = _lg_can_dual_switch(mainIdx)
    if mainIdx and mainIdx > 0 and canSwitch then
        local switchPos = _lg_adapt_pos(DUAL_SWITCH_BTN_POS, "right", "bottom")
        local btnSwitch = GUI:Button_Create(node, "btn_dual_switch", switchPos.x, switchPos.y, "res/custom/linggen/new/main/btn_equip.png")
        GUI:setAnchorPoint(btnSwitch, 0.5, 0.5)
        GUI:Button_setTitleText(btnSwitch, "切换形态")
        GUI:Button_setTitleFontSize(btnSwitch, 18)
        GUI:Button_setTitleColor(btnSwitch, "#F4E7B5")
        GUI:Button_titleEnableOutline(btnSwitch, "#110b05", 2)
        GUI:addOnClickEvent(btnSwitch, function()
            SL:SendLuaNetMsg(100, npcid, 6, pairIdx, "")
        end)
    end
    local upgradePos = _lg_adapt_pos(PAGE_UPGRADE_BTN_POS, "right", "bottom")
    local btnUpgradePage = GUI:Button_Create(node, "btn_open_upgrade", upgradePos.x - 300, upgradePos.y - 5, "res/custom/linggen/new/main/btn_upgrade.png")
    GUI:setAnchorPoint(btnUpgradePage, 0.5, 0.5)
    _lg_try_xyl_guide(btnUpgradePage, node, "open_linggen_upgrade", {"升级灵根", "升级一次你的本命灵根"}, "点击打开灵根升级", {
        dir = 3,
        isForce = true,
        hideMask = false,
    })
    GUI:addOnClickEvent(btnUpgradePage, function()
        local xNode = ensureUpgradeWindow(npcid)
        if xNode then
            _lg_refresh_upgrade_window(npcid, xNode)
        end
    end)
    -- 当前版本只保留按钮卸下，不再创建拖拽卸下区域。
    npc.out_moveWidget = nil

    local mainPos = _lg_adapt_pos(MAIN_SLOT_POS, "center", "center")
    local mainTouch = GUI:Layout_Create(node, "main_slot_touch", mainPos.x - SLOT_TOUCH_SIZE.width / 2, mainPos.y - SLOT_TOUCH_SIZE.height / 2, SLOT_TOUCH_SIZE.width, SLOT_TOUCH_SIZE.height, false)
    GUI:setTouchEnabled(mainTouch, true)
    GUI:addOnClickEvent(mainTouch, function()
        local idx = tonumber(mainIdx or 0) or 0
        if idx > 0 then
            npc.current_idx = idx
            _lg_refresh_main_page(npcid, node)
        end
    end)
end

-- 刷新灵根升级弹窗：预览属性、当前灵根、消耗、升级按钮。
_lg_refresh_upgrade_window = function(npcid, xNode)
    if not xNode then
        return
    end
    GUI:removeAllChildren(xNode)
    local idx = tonumber(npc.current_idx or 0) or 0
    if idx <= 0 then
        idx = _lg_default_selected_idx()
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
    _lg_try_xyl_guide(btn, xNode, "do_linggen_upgrade", {"升级灵根", "升级一次你的本命灵根"}, "点击升级本命灵根", {
        dir = 3,
        isForce = true,
        hideMask = false,
    })
    GUI:addOnClickEvent(btn, function()
        if idx > 0 and not _lg_is_max_level(idx) then
            SL:SendLuaNetMsg(100, npcid, 5, idx, "")
        end
    end)

    if _lg_is_max_level(idx) then
        strokeText(xNode, "max_tip", UPGRADE_BTN_POS.x, UPGRADE_BTN_POS.y + 76, 18, "#7CFF7C", "当前灵根已满级", "fonts/font4.ttf")
        GUI:setAnchorPoint(GUI:getChildByName(xNode, "max_tip"), 0.5, 0.5)
    elseif _lg_can_upgrade(idx) then
        NPC_UI_HELPER.redpoint_create(btn, {x = 120, y = 46})
    end
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.current_idx = _lg_default_selected_idx()
        ensureMainWindow(npcid)
        _lg_refresh_main_page(npcid, npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        if tonumber(npc.current_idx or 0) <= 0 then
            npc.current_idx = _lg_default_selected_idx()
        end
        ensureMainWindow(npcid)
        _lg_refresh_main_page(npcid, npc.node)
        if npc.xjm_node then
            _lg_refresh_upgrade_window(npcid, npc.xjm_node)
        end
        _lg_try_finish_xyl_and_close()
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        local xNode = ensureUpgradeWindow(npcid)
        _lg_refresh_upgrade_window(npcid, xNode)
    end
end

return npc
