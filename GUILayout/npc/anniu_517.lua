local npc = {}
rawset(_G, "__TREASURE_BASIN_517_UI__", nil)
local UPGRADE_HELPER = SL:Require("GUILayout/npc/upgrade_helper", true)

local RES = "res/custom/treasureBasin/"
local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
}

local tab = 1
local selectedStone = 1
local expandedContinent = nil

local CONTINENT_LABELS = {
    [1] = "通用材料",
    [2] = "第二大陆",
    [3] = "第三大陆",
    [4] = "第四大陆",
    [5] = "第五大陆",
    [6] = "第六大陆",
}
local model = {
    ["焚天禁器·炎狱龙尊"] = 30004,
    ["幽狱禁器·冥河鬼主"] = 30013,
    ["万灵禁器·太古神凰"] = 30019,
}

local function cfg()
    return (teshudata and teshudata["npc_106"]) or {}
end

local function levelCfg(level)
    local levels = cfg().levels or {}
    return levels[tonumber(level or 1) or 1] or levels[1] or {name = "聚宝盆", speed = 100, cap_text = "无存储"}
end

local function stonesCfg()
    return cfg().stones or {}
end

local function isContinentUnlocked(continent)
    local c = tonumber(continent or 0) or 0
    if c <= 1 then return true end
    local adminUnlock = cogin and cogin.sjtb and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
    if adminUnlock == 1 or adminUnlock >= c then
        return true
    end
    if type(dl_unlock_check) == "function" then
        local ok = dl_unlock_check(c)
        return ok == true
    end
    if type(dl_sz) == "function" then
        return dl_sz(c) == true
    end
    return true
end

local function visibleStones()
    local list = {}
    for i, one in ipairs(stonesCfg()) do
        local continent = tonumber(one.continent or 0) or 0
        if continent <= 0 or isContinentUnlocked(continent) then
            list[#list + 1] = {idx = i, cfg = one}
        end
    end
    return list
end

local function forbiddenCfg(id)
    local list = cfg().forbidden or {}
    return list[tonumber(id or 0) or 0] or {}
end

local function forbiddenCost(level)
    local list = cfg().forbidden_cost or {}
    return list[tonumber(level or 0) or 0] or {}
end

local function gradeName(lv)
    local grades = cfg().grades or {}
    return grades[(tonumber(lv or 0) or 0) + 1] or "极"
end

local function continentName(continent)
    local c = tonumber(continent or 1) or 1
    return CONTINENT_LABELS[c] or string.format("第%s大陆", c)
end

local function n(v, d)
    local x = tonumber(v)
    if x == nil then return d or 0 end
    return x
end

local function data()
    return npc.data or {}
end

local function isValidNode(node)
    return node ~= nil and (not tolua or not tolua.isnull or not tolua.isnull(node))
end

local function removeChildIfExists(parent, name)
    if not isValidNode(parent) then return end
    local child = GUI:getChildByName(parent, name)
    if isValidNode(child) then
        GUI:removeChildByName(parent, name)
    end
end

local function fmt(v)
    v = math.floor(n(v))
    if v >= 100000000 then return tostring(math.floor(v / 100000000)) .. "亿" end
    if v >= 10000 then return tostring(math.floor(v / 10000)) .. "万" end
    return tostring(v)
end

local function fmtTime(sec)
    sec = math.max(0, math.floor(n(sec)))
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function fmtCountdownText(sec)
    sec = math.max(0, math.floor(n(sec)))
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then
        return string.format("%d小时%d分%d秒", h, m, s)
    end
    if m > 0 then
        return string.format("%d分%d秒", m, s)
    end
    return string.format("%d秒", s)
end

local function fmtDuration(value)
    if type(value) == "string" and value ~= "" then
        return value
    end
    return fmtTime(value or 0)
end

local function bindCountdownText(widget, sec, onDone)
    if not widget then return end
    local left = math.max(0, math.floor(n(sec)))
    GUI:Text_setString(widget, fmtTime(left))
    if left <= 0 then
        if onDone then onDone() end
        return
    end
    SL:schedule(widget, function()
        left = math.max(0, left - 1)
        GUI:Text_setString(widget, fmtTime(left))
        if left <= 0 and onDone then
            onDone()
            onDone = nil
        end
    end, 1)
end

local function bindCountdownTextWithPrefix(widget, sec, prefix, doneText)
    if not widget then return end
    local left = math.max(0, math.floor(n(sec)))
    local prefixText = tostring(prefix or "")
    GUI:Text_setString(widget, left > 0 and (prefixText .. fmtCountdownText(left)) or tostring(doneText or ""))
    if left <= 0 then
        return
    end
    SL:schedule(widget, function()
        left = math.max(0, left - 1)
        GUI:Text_setString(widget, left > 0 and (prefixText .. fmtCountdownText(left)) or tostring(doneText or ""))
        if left <= 0 and GUI.Text_setTextColor then
            GUI:Text_setTextColor(widget, "#9DFF7C")
        end
    end, 1)
end

local function fontText(widget, font)
    if widget then
        GUI:Text_setFontName(widget, font or "fonts/502.ttf")
    end
end

local function text(parent, name, x, y, size, color, value, ax, ay, font)
    local t = GUI:Text_Create(parent, name, x, y, size, color, tostring(value or ""))
    GUI:setAnchorPoint(t, ax or 0.5, ay or 0.5)
    GUI:Text_enableOutline(t, "#120805", 2)
    fontText(t, font or "fonts/502.ttf")
    return t
end

local function rich(parent, name, x, y, html, width, size, align, ax, ay)
    local r = GUI:RichText_Create(parent, name, x, y, tostring(html or ""), width or 260, size or 16, "#F6E8C8", align or 1, nil, nil, {outlineSize = 1, outlineColor = "#120805"})
    GUI:setAnchorPoint(r, ax or 0, ay or 0)
    return r
end

local function image(parent, name, x, y, skin, ax, ay)
    local obj = GUI:Image_Create(parent, name, x, y, skin)
    GUI:setAnchorPoint(obj, ax or 0.5, ay or 0.5)
    return obj
end

local function panel(parent, name, x, y, w, h, skin)
    local bg = GUI:Image_Create(parent, name, x, y, skin or "res/wy/public/tycccc.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, w, h)
    GUI:setLocalZOrder(bg, -1)
    return bg
end

local function titleBar(parent, name, x, y, value, w)
    local bg = GUI:Image_Create(parent, name .. "_bg", x, y, "res/wy/public/new_kuang.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, w or 190, 34)
    GUI:setLocalZOrder(bg, -1)
    return text(parent, name, x, y + 1, 26, "#FFE8A8", value, 0.5, 0.5)
end

local function tipButton(parent, name, x, y, desc)
    local tip = GUI:Text_Create(parent, name, x, y, 22, "#7FE9FF", "?")
    GUI:setAnchorPoint(tip, 0.5, 0.5)
    GUI:Text_enableOutline(tip, "#120805", 2)
    GUI:Text_setFontName(tip, "fonts/502.ttf")
    GUI:setTouchEnabled(tip, true)
    local function openTip()
        local pos = GUI:getWorldPosition(tip)
        SL:OpenCommonDescTipsPop({str = tostring(desc or ""), worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
    end
    GUI:addMouseMoveEvent(tip, {onEnterFunc = openTip, onLeaveFunc = function()
        SL:CloseCommonDescTipsPop()
    end})
    GUI:addOnClickEvent(tip, openTip)
    return tip
end

local function button(parent, name, x, y, title, cb, scale)
    local btn = GUI:Button_Create(parent, name, x, y, "res/wy/public/an15.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    if scale and scale ~= 1 then
        GUI:setContentSize(btn, math.floor(104 * scale), math.floor(32 * scale))
    else
        GUI:setContentSize(btn, 104, 32)
    end
    GUI:Button_setTitleText(btn, tostring(title or ""))
    GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
    GUI:Button_setTitleFontSize(btn, 24)
    GUI:Button_setTitleColor(btn, "#FFF1B8")
    GUI:Button_titleEnableOutline(btn, "#120805", 3)
    
    if cb then GUI:addOnClickEvent(btn, cb) end
    return btn
end

local function smallButton(parent, name, x, y, title, cb, color)
    local btn = GUI:Button_Create(parent, name, x, y, "res/wy/public/an15.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:setContentSize(btn, 104, 32)
    GUI:Button_setTitleText(btn, tostring(title or ""))
    GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
    GUI:Button_setTitleFontSize(btn, 18)
    GUI:Button_setTitleColor(btn, color or "#FFE7A8")
    GUI:Button_titleEnableOutline(btn, "#120805", 2)
    if cb then GUI:addOnClickEvent(btn, cb) end
    return btn
end

local function rewardItem(parent, key, itemName, count, x, y)
    local box = GUI:Image_Create(parent, "reward_item_box_" .. tostring(key), x, y, "res/custom/ditu/58_58_kuang.png")
    GUI:setAnchorPoint(box, 0.5, 0.5)
    local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName) or 0) or 0
    if idx > 0 then
        local item = GUI:ItemShow_Create(box, "item", 29, 29, {
            index = idx,
            look = true,
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        text(box, "fallback_name", 29, 31, 14, "#FFD66A", tostring(itemName or ""), 0.5, 0.5)
    end
    local num = text(box, "count", 48, 4, 14, "#FFFFFF", fmt(count), 1, 0)
    GUI:Text_enableOutline(num, "#000000", 2)
    return box
end

local function stoneBagItem(parent, key, itemName, x, y)
    local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName) or 0) or 0
    local count = 0
    if idx > 0 then
        count = tonumber(SL:GetMetaValue("ITEM_COUNT", idx) or 0) or 0
    end
    local box = GUI:Image_Create(parent, "stone_item_box_" .. tostring(key), x, y, "res/custom/ditu/58_58_kuang.png")
    GUI:setAnchorPoint(box, 0.5, 0.5)
    GUI:setContentSize(box, 30, 30)
    if idx > 0 then
        local item = GUI:ItemShow_Create(box, "item", 15, 15, {
            index = idx,
            count = count,
            look = true,
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
    end
    return box
end

local function titleReward(parent, key, titleName, x, y, active, mode)
    local itemName = tostring(titleName or "") .. "[称号]"
    local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName) or 0) or 0
    local box = GUI:Image_Create(parent, "title_reward_box_" .. tostring(key), x + 300, y, "res/custom/ditu/58_58_kuang.png")
    GUI:setAnchorPoint(box, 0.5, 0.5)
    if idx > 0 then
        local item = GUI:ItemShow_Create(box, "item", 29, 29, {
            index = idx,
            look = true,
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        text(box, "fallback_title", 29, 31, 13, "#FFD66A", tostring(titleName or "称号"), 0.5, 0.5)
    end
    if mode == "bottom" then
        -- text(parent, "title_reward_name_" .. tostring(key), x + 40, y + 14, 24, active and "#9DFF7C" or "#FFD66A", tostring(titleName or "称号"), 0, 0.5)
        text(parent, "title_reward_state_" .. tostring(key), x + 40, y, 24, active and "#9DFF7C" or "#FFB85A", active and "称号已获得" or "激活三件禁器后获得：", 0, 0.5)
    else
        -- text(parent, "title_reward_name_" .. tostring(key), x + 40, y + 14, 24, active and "#9DFF7C" or "#FFD66A", tostring(titleName or "称号"), 0, 0.5)
        text(parent, "title_reward_state_" .. tostring(key), x + 40, y, 24, active and "#9DFF7C" or "#FFB85A", active and "称号已获得" or "激活三件禁器后获得：", 0, 0.5)
    end
    return box
end

local function closeForbiddenUpgradePopup()
    if npc.forbiddenUpgradePopup then
        NPC_UI_HELPER.closeWindow(npc.forbiddenUpgradePopup)
        npc.forbiddenUpgradePopup = nil
    end
end

local function closeBasinLevelPopup()
    if npc.basinLevelPopup then
        NPC_UI_HELPER.closeWindow(npc.basinLevelPopup)
        npc.basinLevelPopup = nil
    end
end

local function openBasinLevelPopup()
    closeBasinLevelPopup()
    local d = data()
    local lv = math.max(1, n(d.level, 1))
    local nextLv = math.min(5, lv + 1)
    local curCfg = levelCfg(lv)
    local nextCfg = levelCfg(nextLv)
    local maxed = lv >= 5
    local charge = math.max(n(d.charge), n(d.real_charge))
    local needCharge = n(nextCfg.charge)
    local lackCharge = math.max(0, needCharge - charge)

    npc.basinLevelPopup = NPC_UI_HELPER.ensureWindow(nil, 517, {
        windowName = "treasure_basin_level_popup",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = RES .. "xjm_bg.png"},
        closeButton = {x = 555, y = 338 + 24, skin = "res/wy/public/close_red_big.png", onClick = closeBasinLevelPopup},
        zOrder = 200,
    })
    local bg = npc.basinLevelPopup and npc.basinLevelPopup.node
    if not bg then return end

    local function levelDesc(one)
        return string.format("存储上限 %s", tostring(one.cap_text or "无存储"))
    end

    -- text(bg, "title", 300, 338, 30, "#FFE8A8", "聚宝盆品阶", 0.5, 0.5)
    local curIcon = GUI:Image_Create(bg, "cur_icon", 165 - 32, 192, RES .. "itme_" .. tostring(lv) .. ".png")
    GUI:setAnchorPoint(curIcon, 0.5, 0.5)
    local nextIcon = GUI:Image_Create(bg, "next_icon", 435 + 32, 192, RES .. "itme_" .. tostring(nextLv) .. ".png")
    GUI:setAnchorPoint(nextIcon, 0.5, 0.5)
    GUI:Image_Create(bg, "arrow", 300 - 32, 204 - 60, RES .. "jt.png")

    -- text(bg, "cur_name", 165, 284, 25, "#FFF1B8", tostring(curCfg.name or "聚宝盆"), 0.5, 0.5)
    -- text(bg, "next_name", 435, 284, 25, maxed and "#9DFF7C" or "#FFF1B8", maxed and "已达极品" or tostring(nextCfg.name or "聚宝盆"), 0.5, 0.5)
    -- text(bg, "cur_reward_title", 165, 247, 23, "#B9F6FF", "聚宝奖励", 0.5, 0.5)
    -- text(bg, "next_reward_title", 435, 247, 23, "#B9F6FF", "聚宝奖励", 0.5, 0.5)
    text(bg, "cur_reward_desc", 165 - 32, 215 + 20, 18, "#F6D08A", levelDesc(curCfg), 0.5, 0.5)
    text(bg, "next_reward_desc", 435 + 32, 215 + 20, 18, maxed and "#9DFF7C" or "#F6D08A", maxed and "已达最高收益" or levelDesc(nextCfg), 0.5, 0.5)
    -- text(bg, "cur_condition_title", 165, 162, 23, "#EFD7A0", "升级条件", 0.5, 0.5)
    -- text(bg, "next_condition_title", 435, 162, 23, "#EFD7A0", "升级条件", 0.5, 0.5)
    text(bg, "cur_condition_desc", 165 - 32, 130 + 20, 18, "#9DFF7C", "当前 Lv." .. tostring(lv), 0.5, 0.5)
    if maxed then
        text(bg, "next_condition_desc", 435 + 32, 130 + 20, 18, "#9DFF7C", "当前已是最高品阶", 0.5, 0.5)
        -- button(bg, "level_confirm", 300, 22 + 24 + 32, "已满级", function()
        --     SL:ShowSystemTips("当前已是最高品阶")
        -- end)
    else
        text(bg, "next_condition_desc", 435 + 32, 130 + 20, 18, lackCharge <= 0 and "#9DFF7C" or "#FF5A3D", string.format("真实充值 %s/%s", fmt(charge), fmt(needCharge)), 0.5, 0.5)
        -- text(bg, "next_condition_lack", 435, 114, 17, lackCharge <= 0 and "#9DFF7C" or "#FFB85A", lackCharge <= 0 and "条件已达成" or ("还差 " .. fmt(lackCharge)), 0.5, 0.5)
        local confirmBtn = button(bg, "level_confirm", 300, 22 + 24, "确认升级", function()
            if lackCharge > 0 then
                SL:ShowSystemTips("真实充值不足，还差 " .. fmt(lackCharge))
                return
            end
            npc._pendingLevelUpgradeFrom = lv
            SL:SendLuaNetMsg(101, 517, 9, 0, "")
        end, 1.3)
        if lackCharge <= 0 then
            NPC_UI_HELPER.redpoint_create_eff(confirmBtn, {x = 150, y = 44, autoScale = 0.65})
        end
    end
end

local function openForbiddenUpgradePopup(npcid, id, lv)
    closeForbiddenUpgradePopup()
    id = tonumber(id or 0) or 0
    lv = tonumber(lv or 0) or 0
    local nextLv = lv + 1
    local fc = forbiddenCfg(id)
    local cost = forbiddenCost(nextLv)
    if id <= 0 or lv <= 0 then
        SL:ShowSystemTips("请先激活该禁器")
        return
    end
    if lv >= 5 then
        SL:ShowSystemTips("该禁器已是极品")
        return
    end
    npc.forbiddenUpgradePopup = NPC_UI_HELPER.ensureWindow(nil, npcid or 517, {
        windowName = "treasure_basin_forbidden_upgrade_popup",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = RES .. "xjm_bg.png"},
        closeButton = {x = 555, y = 362, skin = "res/wy/public/close_red_big.png", onClick = closeForbiddenUpgradePopup},
        zOrder = 201,
    })
    local bg = npc.forbiddenUpgradePopup and npc.forbiddenUpgradePopup.node
    if not bg then return end

    local needLevel = n(cost.need_level)
    local yuanbao = n(cost.yuanbao)
    local crystal = n(cost.crystal)
    local levelOk = n(data().level) >= needLevel
    panel(bg, "title_bg", 300, 313, 548, 78, "res/wy/public/tycccc.png")
    panel(bg, "item_bg", 158, 154, 224, 210, "res/wy/public/tycccc.png")
    panel(bg, "preview_bg", 416, 207, 280, 92, "res/wy/public/tycccc.png")
    panel(bg, "cost_bg", 416, 95, 280, 104, "res/wy/public/tycccc.png")

    -- text(bg, "title", 300, 318, 29, "#FFE8A8", "禁器升级", 0.5, 0.5)
    -- GUI:Image_Create(bg, "arrow", 278, 266, RES .. "jt.png")

    -- rewardItem(bg, "upgrade_forbid_item", tostring(fc.name or "禁器"), 1, 158, 218)
    local model_eff = GUI:Effect_Create(bg, "model", 158, 200, 0, model[fc.name], 0, 0, 2, 0.8)
    -- GUI:setScale(model_eff, 0.5)

    text(bg, "name", 158, 30, 23, "#FFD66A", tostring(fc.name or "禁器"), 0.5, 0.5)
    

    text(bg, "level_label", 416, 247 + 100, 25, "#F6D08A", "升级预览", 0.5, 0.5)
    text(bg, "level", 416, 216 + 85, 22, "#9FE2FF", string.format("当前 Lv.%d  →  目标 Lv.%d", lv, nextLv), 0.5, 0.5)
    text(bg, "attr_label", 416, 184 + 80, 23, "#F6D08A", "属性加成", 0.5, 0.5)
    text(bg, "attr", 416, 157 + 80, 19, "#B9F6C5", tostring(fc.plus or ""), 0.5, 0.5)

    text(bg, "cost_title", 416, 136 + 75, 23, "#F6D08A", "升级消耗", 0.5, 0.5)
    -- text(bg, "cost_jy", 334, 107, 19, "#FFF1B8", "禁元神晶：" .. fmt(crystal), 0, 0.5)
    -- text(bg, "cost_yb", 112, 94, 19, "#FFF1B8", "元宝：" .. fmt(yuanbao), 0, 0.5)
    checkItemNumByTable_img_kuang({{"禁元神晶",crystal},{"元宝",yuanbao}},1, GUI:Node_Create(bg, "cost_items", 416 - 103, 95 + 30))
    text(bg, "need_level", 416, 78, 18, levelOk and "#9DFF7C" or "#FF5A3D", "聚宝盆品阶要求 Lv." .. tostring(needLevel), 0.5, 0.5)

    button(bg, "confirm", 300 + 145 - 28, 23 + 23, "确认升级", function()
        closeForbiddenUpgradePopup()
        SL:SendLuaNetMsg(101, npcid, 5, id, "")
    end, 1.35)
end

local function ensureWindow(npcid, keepCurrent)
    if keepCurrent and isValidNode(npc.node) then
        return npc.node
    end
    if keepCurrent then
        npc.node = nil
        npc.bg = nil
        npc._window = nil
    end
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, WINDOW_OPTS)
    local root = npc._window.bg
    GUI:setLocalZOrder(npc._window.node, 99)
    removeChildIfExists(root, "eff")
    npc.bg = GUI:Frames_Create(root, "eff", 0, 0, RES .. "bg/eff_", ".png", 1, 75, {speed = 75, count = 75, loop = -1})
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)
    removeChildIfExists(npc.bg, "node")
    npc.node = GUI:Node_Create(npc.bg, "node", 500, 360)
    return npc.node
end

local function renderBase(node)
    image(npc.bg, "title", 500, 520, RES .. "title.png")
end

local renderLevelInfo
local renderEnergy
local renderRefine
local renderForbidden

local function renderContent(node, npcid)
    if not isValidNode(node) then return end
    removeChildIfExists(node, "content_layer")
    local content = GUI:Node_Create(node, "content_layer", 0, 0)
    if not isValidNode(content) then return end
    if tab == 1 then
        renderLevelInfo(content, npcid)
        renderEnergy(content, npcid)
    elseif tab == 2 then
        renderRefine(content, npcid)
    else
        renderForbidden(content, npcid)
    end
end

local function renderTabs(node, npcid)
    local names = {"聚能收益", "炼灵宝石", "禁器养成"}
    local redState = UPGRADE_HELPER and UPGRADE_HELPER.treasureBasinRedState and UPGRADE_HELPER.treasureBasinRedState(data()) or {}
    for i, name in ipairs(names) do
        local y = 44 - (i - 1) * 82
        local selected = tab == i
        local bg = GUI:Image_Create(node, "tab_bg_" .. i, -350, y, selected and "res/wy/public/kb_btn.png" or "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setContentSize(bg, selected and 210 or 182, selected and 48 or 36)
        GUI:setLocalZOrder(bg, -2)
        local line = GUI:Image_Create(node, "tab_line_" .. i, -350, y - 26, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(line, 0.5, 0.5)
        GUI:setContentSize(line, selected and 175 or 118, 8)
        GUI:setLocalZOrder(line, -1)
        if selected then
            local side = GUI:Image_Create(node, "tab_side_" .. i, -453, y, "res/wy/public/kb_btn.png")
            GUI:setAnchorPoint(side, 0.5, 0.5)
            GUI:setContentSize(side, 14, 50)
            GUI:setLocalZOrder(side, -1)
        end
        text(node, "tab_mark_" .. i, -420, y, selected and 27 or 20, selected and "#FFF4B0" or "#A96A2E", selected and "◆" or "◇", 0.5, 0.5)
        text(node, "tab_text_" .. i, -337, y + 1, selected and 28 or 22, selected and "#FFF1B8" or "#C98C45", name, 0.5, 0.5)
        if not selected and (
            (i == 1 and (redState.energy or redState.level))
            or (i == 2 and redState.refine)
            or (i == 3 and redState.forbidden)
        ) then
            NPC_UI_HELPER.redpoint_create_eff(bg, {x = 178, y = 42, autoScale = 0.75})
        end
        local touch = GUI:Layout_Create(node, "tab_touch_" .. i, -455, y - 25, 220, 50, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnClickEvent(touch, function()
            tab = i
            npc.render(npcid, false)
        end)
    end
end

renderLevelInfo = function(node, npcid)
    local lx = 30
    panel(node, "level_info_panel", 306 + lx, -48, 292, 254, "res/wy/public/tycccc.png")
    local d = data()
    local r = d.energy_reward or {}
    local lv = n(d.level, 1)
    local lc = levelCfg(lv)
    local state = n(d.activated) >= 1 and (n(d.equipped) >= 1 and "神器已穿戴" or "已激活未穿戴") or "主线未激活"
    local color = n(d.activated) >= 1 and (n(d.equipped) >= 1 and "#9DFF7C" or "#FFB85A") or "#FF5A3D"
    titleBar(node, "level_title", 306 + lx, 74, tostring(lc.name or "聚宝盆") .. "  Lv." .. tostring(lv), 238)
    panel(node, "level_reward_bg", 306 + lx, 12, 242, 90, "res/wy/public/tycccc.png")
    panel(node, "level_state_bg", 306 + lx, -100, 242, 112, "res/wy/public/tycccc.png")
    text(node, "level_reward_title", 306 + lx, 47, 21, "#FFE8A8", "品阶收益", 0.5, 0.5)
    rewardItem(node, "level_gold", "金币", r.gold, 246 + lx, 5)
    rewardItem(node, "level_iron", "千年玄铁", r.iron, 306 + lx, 5)
    rewardItem(node, "level_hat", "斗笠碎片", r.hat, 366 + lx, 5)
    text(node, "level_need_title", 306 + lx, -58, 21, "#FFE8A8", "当前状态", 0.5, 0.5)
    text(node, "level_state", 306 + lx, -85, 20, color, state, 0.5, 0.5)
    text(node, "level_speed", 306 + lx, -113, 18, "#9FE2FF", "收益效率  固定", 0.5, 0.5)
    text(node, "level_cap", 306 + lx, -140, 18, "#FFD07A", "存储上限  " .. tostring(lc.cap_text or "无存储"), 0.5, 0.5)
    local levelBtn = button(node, "level_up_btn", 306 + lx, -203, "提升品阶", function()
        openBasinLevelPopup()
    end,1.4)
    local redState = UPGRADE_HELPER and UPGRADE_HELPER.treasureBasinRedState and UPGRADE_HELPER.treasureBasinRedState(d) or {}
    if redState.level then
        NPC_UI_HELPER.redpoint_create_eff(levelBtn, {x = 150, y = 48, autoScale = 0.7})
    end
end

renderEnergy = function(node, npcid)
    local ex = 40
    panel(node, "energy_info_panel", -72 + ex, -48, 430, 286, "res/wy/public/tycccc.png")
    local d = data()
    titleBar(node, "energy_title", -72 + ex, 96, "聚能收益", 230)
    if n(d.activated) < 1 then
        text(node, "locked", -72 + ex, 4, 22, "#FF5A3D", "请先完成二大陆聚宝盆主线任务", 0.5, 0.5)
        rich(node, "locked_desc", -220 + ex, -36, "完成后获得<font color='#FFD66A'>聚宝盆</font>背包神器，穿戴后开始显示聚能进度。", 300, 19, 1)
        return
    end
    local capText = tostring(levelCfg(d.level).cap_text or "无存储")
    panel(node, "energy_top_bg", -72 + ex, 48, 348, 64, "res/wy/public/tycccc.png")
    text(node, "energy_time_label", -150 + ex, 61, 18, "#D9A85A", "当前存储", 1, 0.5)
    text(node, "energy_time", -104 + ex, 61, 23, "#9FE2FF", tostring(d.energy_text or "00:00"), 0, 0.5)
    text(node, "energy_cap_label", -150 + ex, 34, 18, "#D9A85A", "存储上限", 1, 0.5)
    text(node, "energy_cap", -104 + ex, 34, 20, "#FFD07A", capText, 0, 0.5)
    local percent = 0
    local energy = n(d.energy_sec)
    local cap = n(d.cap_sec or d.cap)
    if cap > 0 then percent = math.max(0, math.min(100, energy / cap * 100)) end
    text(node, "energy_progress_label", -72 + ex, 2, 19, "#FFE8A8", "聚能进度", 0.5, 0.5)
    local barBg = GUI:Image_Create(node, "energy_bar_bg", -72 + ex, -20, RES .. "jdt_k.png")
    GUI:setAnchorPoint(barBg, 0.5, 0.5)
    GUI:setContentSize(barBg, 318, 18)
    GUI:setLocalZOrder(barBg, -1)
    local bar = GUI:LoadingBar_Create(node, "energy_bar", -72 + ex, -20, RES .. "jdt_m.png", 0)
    GUI:setAnchorPoint(bar, 0.5, 0.5)
    GUI:setContentSize(bar, 318, 18)
    GUI:LoadingBar_setPercent(bar, percent)
    text(node, "energy_percent", -72 + ex, -20, 17, "#FFF7D6", tostring(math.floor(percent)) .. "%", 0.5, 0.5)
    local r = d.energy_reward or {}
    local rewardBg = GUI:Image_Create(node, "energy_reward_bg", -72 + ex, -82, "res/wy/public/tycccc.png")
    GUI:setAnchorPoint(rewardBg, 0.5, 0.5)
    GUI:setContentSize(rewardBg, 348, 98)
    GUI:setLocalZOrder(rewardBg, -1)
    text(node, "reward_title", -72 + ex, -45, 21, "#FFE8A8", "可领取收益", 0.5, 0.5)
    rewardItem(node, "energy_gold", "金币", r.gold, -144 + ex, -84)
    rewardItem(node, "energy_iron", "千年玄铁", r.iron, -72 + ex, -84)
    rewardItem(node, "energy_hat", "斗笠碎片", r.hat, 0 + ex, -84)
    tipButton(node, "energy_rule_tip", 83 + ex, -45, "<font color='#F2E0B6'>在线完整累计，离线收益为在线的</font><font color='#7FE9FF'>50%</font><br/><font color='#F2E0B6'>存储上限跟聚宝盆品阶有关，领取后清空当前存储。</font>")
    local claimBtn = button(node, "claim_energy", -72 + ex, -164, "领取聚能", function()
        SL:SendLuaNetMsg(101, npcid, 1, 0, "")
    end, 1.5)
    local redState = UPGRADE_HELPER and UPGRADE_HELPER.treasureBasinRedState and UPGRADE_HELPER.treasureBasinRedState(d) or {}
    if redState.energy then
        NPC_UI_HELPER.redpoint_create_eff(claimBtn, {x = 205, y = 35, autoScale = 0.6})
    end
end

renderRefine = function(node, npcid)
    local rx = 100
    panel(node, "refine_list_panel", -132 + rx, -50, 300, 280, "res/wy/public/tycccc.png")
    panel(node, "refine_state_panel", 306, -50, 292, 280, "res/wy/public/tycccc.png")
    local d = data()
    local ref = d.refine or {}
    local visible = visibleStones()
    local selectedVisible = false
    for _, item in ipairs(visible) do
        if item.idx == selectedStone then selectedVisible = true break end
    end
    if not selectedVisible and visible[1] then
        selectedStone = visible[1].idx
    end
    local groups = {}
    local groupOrder = {}
    for _, item in ipairs(visible) do
        local continent = tonumber(item.cfg.continent or 1) or 1
        if continent <= 0 then continent = 1 end
        if not groups[continent] then
            groups[continent] = {bind = {}, free = {}}
            groupOrder[#groupOrder + 1] = continent
        end
        if tonumber(item.cfg.bind or 0) == 1 or tonumber(item.cfg.continent or 0) <= 0 then
            groups[continent].bind[#groups[continent].bind + 1] = item
        else
            groups[continent].free[#groups[continent].free + 1] = item
        end
        if item.idx == selectedStone and not expandedContinent then
            expandedContinent = continent
        end
    end
    table.sort(groupOrder)
    if not expandedContinent and groupOrder[1] then
        expandedContinent = groupOrder[1]
    end
    titleBar(node, "refine_title", -132 + rx, 82, "宝石选择", 218)
    text(node, "stone_tip", -132 + rx, 54, 17, "#E9D7B2", "已解锁大陆宝石列表", 0.5, 0.5)

    local viewW = 280
    local viewH = 216
    local innerH = 18
    for _, continent in ipairs(groupOrder) do
        innerH = innerH + 42
        if expandedContinent == continent then
            local group = groups[continent] or {bind = {}, free = {}}
            innerH = innerH + math.max(#group.bind, #group.free) * 36 + 6
        end
    end
    innerH = math.max(viewH, innerH)
    local scroll = GUI:ScrollView_Create(node, "stone_scroll", -272 + rx, -182, viewW, viewH, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, viewW, innerH)
    local listNode = GUI:Layout_Create(scroll, "stone_list_node", 0, 0, viewW, innerH, false)

    local cursorY = innerH - 22
    for _, continent in ipairs(groupOrder) do
        local isOpen = expandedContinent == continent
        local group = groups[continent] or {bind = {}, free = {}}
        local headerSkin = "res/wy/public/000.png"
        local headerBg = GUI:Image_Create(listNode, "stone_group_bg_" .. continent, viewW / 2, cursorY, headerSkin)
        GUI:setAnchorPoint(headerBg, 0.5, 0.5)
        GUI:setLocalZOrder(headerBg, -1)
        GUI:setContentSize(headerBg, 260, 38)
        text(listNode, "stone_group_arrow_" .. continent, 36, cursorY + 1, 23, isOpen and "#78FF7A" or "#C58A3E", isOpen and "◆" or "◇", 0.5, 0.5)
        text(listNode, "stone_group_text_" .. continent, 136, cursorY + 1, 27, isOpen and "#FFF1B8" or "#E8B86D", continentName(continent), 0.5, 0.5)
        local headerTouch = GUI:Layout_Create(listNode, "stone_group_touch_" .. continent, 10, cursorY - 19, 260, 38, false)
        GUI:setTouchEnabled(headerTouch, true)
        GUI:addOnClickEvent(headerTouch, function()
            expandedContinent = isOpen and nil or continent
            npc.render(npcid, true)
        end)
        cursorY = cursorY - 42
        if isOpen then
            local function renderStoneItem(item, col)
                local i = item.idx
                local one = item.cfg
                local x = viewW / 2
                local y = cursorY
                local selected = selectedStone == i
                local rowBg = GUI:Image_Create(listNode, "stone_row_bg_" .. i, x + 8, y, "res/wy/public/new_kuang.png")
                GUI:setAnchorPoint(rowBg, 0.5, 0.5)
                GUI:setContentSize(rowBg, selected and 234 or 222, 32)
                GUI:setLocalZOrder(rowBg, -1)
                local displayName = tostring(one.name or "")
                if tonumber(one.continent or 0) > 1 then
                    displayName = col == 1 and "宝石·绑定" or "宝石·非绑"
                end
                stoneBagItem(listNode, "stone_" .. i, tostring(one.name or ""), x - 88, y + 1)
                text(listNode, "stone_dot_" .. i, x - 56, y + 1, selected and 20 or 17, selected and "#78FF7A" or "#9B7141", selected and "◆" or "◇", 0.5, 0.5)
                text(listNode, "stone_" .. i, x - 32, y + 1, selected and 20 or 18, selected and "#9DFF7C" or (col == 1 and "#D9C08A" or "#8FC8E8"), displayName, 0, 0.5)
                local touch = GUI:Layout_Create(listNode, "stone_touch_" .. i, x - 112, y - 16, 234, 32, false)
                GUI:setTouchEnabled(touch, true)
                GUI:addOnClickEvent(touch, function()
                    selectedStone = i
                    expandedContinent = continent
                    npc.render(npcid, true)
                end)
                cursorY = cursorY - 36
            end
            local maxRows = math.max(#group.bind, #group.free)
            for row = 1, maxRows do
                if group.bind[row] then renderStoneItem(group.bind[row], 1) end
                if group.free[row] then renderStoneItem(group.free[row], 2) end
            end
            cursorY = cursorY - 6
        end
    end
    if #visible <= 1 then
        text(listNode, "stone_empty_tip", viewW / 2, innerH / 2, 16, "#FFB85A", "解锁新大陆后开放专属宝石", 0.5, 0.5)
    end
    local cfg = stonesCfg()[selectedStone] or stonesCfg()[1] or {}
    titleBar(node, "play_title", 306, 82, "炼灵信息", 230)
    panel(node, "sel_info_bg", 306, 22, 244, 86, "res/wy/public/new_kuang.png")
    text(node, "sel_label", 306, 51, 17, "#B9F6FF", "当前选择", 0.5, 0.5)
    text(node, "sel_name", 306, 25, 22, "#FFD66A", cfg.name, 0.5, 0.5)
    text(node, "sel_time", 306, -2, 18, "#9FE2FF", "炼灵耗时  " .. fmtDuration(cfg.time), 0.5, 0.5)
    panel(node, "sel_desc_bg", 306, -70, 244, 86, "res/wy/public/new_kuang.png")
    rich(node, "sel_desc", 196, -32 - 5, "<font color='#E9D7B2'>产出：</font><font color='#F6D08A'>" .. tostring(cfg.desc or "") .. "</font>", 222, 16, 1, 0, 1)
    if n(ref.active) >= 1 then
        local done = n(ref.done) >= 1
        panel(node, "ref_countdown_bg", 306, -135, 244, 54, "res/wy/public/000.png")
        text(node, "ref_status_label", 252, -124, 18, done and "#9DFF7C" or "#FFB85A", done and "炼灵完成" or "剩余倒计时", 0.5, 0.5)
        local countdownText = text(node, "ref_status_time", 356, -124, 26, done and "#9DFF7C" or "#FF5A3D", done and "可领取" or fmtTime(ref.left or 0), 0.5, 0.5)
        if not done then
            bindCountdownText(countdownText, ref.left or 0, function()
                GUI:Text_setString(countdownText, "可领取")
                npc.render(npcid, true)
            end)
        end
        local claimBtn = button(node, "claim_refine", 266 + 40, -194, "领取产物", function()
            SL:SendLuaNetMsg(101, npcid, 3, 0, "")
        end, 1.5)
        if done then
            NPC_UI_HELPER.redpoint_create_eff(claimBtn, {x = 205, y = 40, autoScale = 0.6})
        end
    else
        panel(node, "ref_countdown_bg", 306, -135, 244, 54, "res/wy/public/000.png")
        text(node, "ref_status_label", 252, -124, 18, "#B9F6C5", "炼灵状态", 0.5, 0.5)
        text(node, "ref_status_time", 356, -124, 22, "#9DFF7C", "空闲", 0.5, 0.5)
        local startBtn = button(node, "start_refine", 266 + 40, -194, "开始炼灵", function()
            SL:SendLuaNetMsg(101, npcid, 2, 0, SL:JsonEncode({stone = cfg.name}))
        end, 1.5)
        local redState = UPGRADE_HELPER and UPGRADE_HELPER.treasureBasinRedState and UPGRADE_HELPER.treasureBasinRedState(d) or {}
        local selectedStoneIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", cfg.name) or 0) or 0
        local selectedStoneCount = selectedStoneIndex > 0 and (tonumber(SL:GetMetaValue("ITEM_COUNT", selectedStoneIndex) or 0) or 0) or 0
        if redState.refine_start and selectedStoneCount > 0 then
            NPC_UI_HELPER.redpoint_create_eff(startBtn, {x = 205, y = 40, autoScale = 0.6})
        end
    end
end

renderForbidden = function(node, npcid)
    local fx = 95
    panel(node, "forbid_list_panel", -16 + fx, -82, 570, 392, "res/wy/public/tycccc.png")
    local d = data()
    local redState = UPGRADE_HELPER and UPGRADE_HELPER.treasureBasinRedState and UPGRADE_HELPER.treasureBasinRedState(d) or {}
    local point = n(d.forbidden_point)
    local needPoint = 8888
    local pointPercent = math.max(0, math.min(100, point / needPoint * 100))
    titleBar(node, "forbid_title", -16 + fx, 86, "禁器养成", 230)
    text(node, "point_label", -222 + fx, 49, 20, "#F6D08A", "聚宝值", 0.5, 0.5)
    local pointBarBg = GUI:Image_Create(node, "forbid_point_bar_bg", -58 + fx, 49, RES .. "jdt_k.png")
    GUI:setAnchorPoint(pointBarBg, 0.5, 0.5)
    GUI:setContentSize(pointBarBg, 286, 20)
    GUI:setLocalZOrder(pointBarBg, -1)
    local pointBar = GUI:LoadingBar_Create(node, "forbid_point_bar", -58 + fx, 49, RES .. "jdt_m.png", 0)
    GUI:setAnchorPoint(pointBar, 0.5, 0.5)
    GUI:setContentSize(pointBar, 286, 20)
    GUI:LoadingBar_setPercent(pointBar, pointPercent)
    text(node, "point_value", -58 + fx, 49, 17, "#FFFFFF", string.format("%s/%s", fmt(point), fmt(needPoint)), 0.5, 0.5)
    text(node, "forbid_tip", 194 + fx, 49, 17, "#B9F6C5", "击杀+1  炼化=大陆*10", 0.5, 0.5)
    titleReward(node, "forbid_all_title", "初识禁器", -16 + fx - 244, -188 - 120, n(d.has_forbidden_title) >= 1, "bottom")
    local list = d.forbidden or {}
    local cardW = 250
    local gap = 20
    local cardH = 236
    local viewW = 536
    local viewH = 286 + 60
    local innerW = cardW * 3 + gap * 2
    local scroll = GUI:ScrollView_Create(node, "forbid_scroll", -265 + fx - 33, -232 - 30, viewW + 33, viewH, 2)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    GUI:ScrollView_setInnerContainerSize(scroll, innerW, viewH)
    local listNode = GUI:Layout_Create(scroll, "forbid_list_node", 0, 0, innerW, viewH)
    for i = 1, 3 do
        local f = list[i] or {}
        local fc = forbiddenCfg(i)
        local active = n(f.lv) > 0
        local lv = n(f.lv)
        local selected = n(f.show) >= 1
        local buttonText = selected and "释放技能" or (active and "外显" or "选择")
        local buttonAction = selected and 7 or 6
        local cardX = (i - 1) * (cardW + gap)
        local card = GUI:Layout_Create(listNode, "forbid_card_" .. i, cardX, 0, cardW, viewH, false)
        panel(card, "forbid_row_bg_" .. i, cardW / 2, viewH / 2 - 20, cardW, cardH + 60, "res/wy/public/anniu_999_bj.png")
        local model_eff = GUI:Effect_Create(card, "model", cardW / 2 - 12, 192 + 30, 0,model[fc.name], 0, 0, 2, 0.8)
        GUI:setScale(model_eff, 0.5)
        if selected and active then
            local cdLeft = n(d.forbidden_skill_cd_left)
            local cdText = text(card, "forbid_skill_cd_" .. i, cardW / 2, 272, 18, cdLeft > 0 and "#FF5A3D" or "#9DFF7C", "", 0.5, 0.5)
            bindCountdownTextWithPrefix(cdText, cdLeft, "冷却  ", "技能可释放")
        end
        -- rewardItem(card, "forbid_equip_" .. i, tostring(fc.name or "禁器"), 1, cardW / 2, 192 + 30)
        local stateIcon = GUI:Image_Create(card, "forbid_state_" .. i, cardW / 2 + 30 , 128 + 30, active and "res/wy/public/10_2.png" or "res/wy/public/10_1.png")
        GUI:setAnchorPoint(stateIcon, 0.5, 0.5)
       
        text(card, "forbid_lv_" .. i, cardW / 2 + 30 + 60, 166 - 30, 20, "#FF3B30", "Lv." .. tostring(lv), 1, 0)
        text(card, "forbid_name_" .. i, cardW / 2, 145 + 30 - 55, 19, "#FFD66A", tostring(fc.name or "禁器"), 0.5, 0.5)

        text(card, "forbid_grade_" .. i, cardW / 2, 102 -8, 17, selected and "#FFE7A8" or (active and "#9FE2FF" or "#FF5A3D"), selected and "当前外显" or (active and "已激活" or "未激活"), 0.5, 0.5)
        text(card, "forbid_plus_" .. i, cardW / 2, 74 -8, 16, "#B9F6C5", tostring(fc.plus or ""), 0.5, 0.5)
        local touch = GUI:Image_Create(card, "forbid_tips", cardW / 2 + 30 + 45 , 128 + 30 - 100, "res/wy/public/an_tip.png")
        GUI:setTouchEnabled(touch, true)
        GUI:addOnTouchEvent(touch, function()
            local itemData = SL:GetMetaValue("ITEM_DATA", SL:GetMetaValue("ITEM_INDEX_BY_NAME", fc.name))
            if not itemData then
                return
            end
            local pos = touch and GUI:getWorldPosition(touch) or {x = 0, y = 0}
            SL:OpenItemTips({itemData = itemData, pos = {x = pos.x  + 100, y = pos.y}})
        end)

        local actionBtn = smallButton(card, "forbid_select_" .. i, cardW / 2 - 55, 8 + 30, buttonText, function()
        SL:SendLuaNetMsg(101, npcid, buttonAction, i, "")




        end, selected and "#FFE7A8" or (active and "#9FE2FF" or "#9DFF7C"))
        if selected and active and redState.forbidden_skill then
            NPC_UI_HELPER.redpoint_create_eff(actionBtn, {x = 92, y = 30, autoScale = 0.55})
        end
        if not active then
            local unlockBtn = smallButton(card, "forbid_unlock_" .. i, cardW / 2 + 55, 8 + 30, "激活", function()
                SL:SendLuaNetMsg(101, npcid, 4, i, "")
            end, "#FFD66A")
            if redState.forbidden_unlock and redState.forbidden_unlock[i] then
                NPC_UI_HELPER.redpoint_create_eff(unlockBtn, {x = 92, y = 30, autoScale = 0.55})
            end
        elseif lv < 5 then
            local upgradeBtn = smallButton(card, "forbid_upgrade_" .. i, cardW / 2 + 55, 8 + 30, "升级", function()
                openForbiddenUpgradePopup(npcid, i, lv)
            end, "#FFD66A")
            if redState.forbidden_upgrade and redState.forbidden_upgrade[i] then
                NPC_UI_HELPER.redpoint_create_eff(upgradeBtn, {x = 92, y = 30, autoScale = 0.55})
            end
        end
    end
end

function npc.render(npcid, contentOnly)
    local node = ensureWindow(npcid, contentOnly == true)
    contentOnly = contentOnly == true and isValidNode(node)
    if not contentOnly then
        renderBase(node)
        renderTabs(node, npcid)
    end
    renderContent(node, npcid)
end

function npc.main(npcid, p2, p3, msgData)
    local forceFullRefresh = false
    local hasWindow = isValidNode(npc.node)
    local oldLevel = n((npc.data or {}).level, 1)
    -- 顶部入口重新打开时，直接整窗重建，避免复用旧界面残留。
    if tonumber(p2 or 0) == 0 then
        forceFullRefresh = true
        tab = 1
    end
    if tonumber(p2 or 0) >= 4 and tonumber(p2 or 0) <= 7 then
        forceFullRefresh = tab ~= 3
        tab = 3
    end
    if msgData and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        rawset(_G, "__TREASURE_BASIN_517_DATA__", npc.data)
    else
        npc.data = npc.data or {}
    end
    if tonumber(p2 or 0) == 9 then
        local newLevel = n((npc.data or {}).level, 1)
        local pendingFrom = n(npc._pendingLevelUpgradeFrom, oldLevel)
        if newLevel > pendingFrom then
            closeBasinLevelPopup()
        end
        npc._pendingLevelUpgradeFrom = nil
    end
    npc.render(npcid, hasWindow and not forceFullRefresh)
end

return npc
