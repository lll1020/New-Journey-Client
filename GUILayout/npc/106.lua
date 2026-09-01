local npc = {}

local RES = "res/custom/treasureBasin/"
local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
}

local tab = 1
local selectedStone = 1
local selectedForbidden = 1

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

local function gradeName(lv)
    local grades = cfg().grades or {}
    return grades[(tonumber(lv or 0) or 0) + 1] or "极"
end

local function n(v, d)
    local x = tonumber(v)
    if x == nil then return d or 0 end
    return x
end

local function data()
    return npc.data or {}
end

local function fmt(v)
    v = math.floor(n(v))
    if v >= 100000000 then return tostring(math.floor(v / 100000000)) .. "亿" end
    if v >= 10000 then return tostring(math.floor(v / 10000)) .. "万" end
    return tostring(v)
end

local function fontText(widget, font)
    if widget then
        GUI:Text_setFontName(widget, font or "fonts/502.ttf")
    end
end

local function text(parent, name, x, y, size, color, value, ax, ay, font)
    local t = GUI:Text_Create(parent, name, x, y, size, color, tostring(value or ""))
    GUI:setAnchorPoint(t, ax or 0.5, ay or 0.5)
    GUI:Text_enableOutline(t, "#000000", 3)
    fontText(t, font or "fonts/502.ttf")
    return t
end


local function rich(parent, name, x, y, html, width, size, align)
    local r = GUI:RichText_Create(parent, name, x, y, tostring(html or ""), width or 260, size or 16, "#F6E8C8", align or 1, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
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
    return text(parent, name, x, y + 1, 24, "#FFD66A", value, 0.5, 0.5)
end

local function button(parent, name, x, y, title, cb)
    local btn = GUI:Button_Create(parent, name, x, y, RES .. "bnt_2.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:Button_setTitleText(btn, tostring(title or ""))
    GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
    GUI:Button_setTitleFontSize(btn, 27)
    GUI:Button_setTitleColor(btn, "#FFE7A8")
    GUI:Button_titleEnableOutline(btn, "#120805", 3)
    if cb then GUI:addOnClickEvent(btn, cb) end
    return btn
end

local function smallButton(parent, name, x, y, title, cb, color)
    local btn = GUI:Button_Create(parent, name, x, y, RES .. "btn_up.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:setContentSize(btn, 92, 32)
    GUI:Button_setTitleText(btn, tostring(title or ""))
    GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
    GUI:Button_setTitleFontSize(btn, 18)
    GUI:Button_setTitleColor(btn, color or "#FFE7A8")
    GUI:Button_titleEnableOutline(btn, "#120805", 2)
    if cb then GUI:addOnClickEvent(btn, cb) end
    return btn
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
    local charge = n(d.charge)
    local needCharge = n(nextCfg.charge)
    local lackCharge = math.max(0, needCharge - charge)

    npc.basinLevelPopup = NPC_UI_HELPER.ensureWindow(nil, 106, {
        windowName = "treasure_basin_task_level_popup",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = RES .. "xjm_bg.png"},
        closeButton = {x = 555, y = 338, skin = "res/wy/public/close_red_big.png", onClick = closeBasinLevelPopup},
        zOrder = 200,
    })
    local bg = npc.basinLevelPopup and npc.basinLevelPopup.node
    if not bg then return end

    text(bg, "title", 300, 338, 30, "#FFE8A8", "聚宝盆品阶", 0.5, 0.5)
    local curIcon = GUI:Image_Create(bg, "cur_icon", 165, 192, RES .. "itme_" .. tostring(lv) .. ".png")
    GUI:setAnchorPoint(curIcon, 0.5, 0.5)
    local nextIcon = GUI:Image_Create(bg, "next_icon", 435, 192, RES .. "itme_" .. tostring(nextLv) .. ".png")
    GUI:setAnchorPoint(nextIcon, 0.5, 0.5)
    GUI:Image_Create(bg, "arrow", 300, 204, RES .. "jt.png")

    text(bg, "cur_name", 165, 76, 22, "#FFD66A", tostring(curCfg.name or "聚宝盆"), 0.5, 0.5)
    text(bg, "cur_lv", 165, 48, 19, "#9FE2FF", "当前 Lv." .. tostring(lv), 0.5, 0.5)
    text(bg, "next_name", 435, 76, 22, maxed and "#9DFF7C" or "#FFD66A", maxed and "已达极品" or tostring(nextCfg.name or "聚宝盆"), 0.5, 0.5)
    text(bg, "next_lv", 435, 48, 19, maxed and "#9DFF7C" or "#9FE2FF", maxed and "满级" or ("目标 Lv." .. tostring(nextLv)), 0.5, 0.5)

    panel(bg, "info_bg", 300, 94, 250, 72, "res/wy/public/tycccc.png")
    if maxed then
        text(bg, "condition", 300, 106, 20, "#9DFF7C", "当前已是最高品阶", 0.5, 0.5)
        text(bg, "bonus", 300, 78, 18, "#F6D08A", "当前存储上限 " .. tostring(curCfg.cap_text or "无存储"), 0.5, 0.5)
        button(bg, "level_confirm", 300, 22, "已满级", function()
            SL:ShowSystemTips("当前已是最高品阶")
        end)
    else
        text(bg, "condition", 300, 116, 20, lackCharge <= 0 and "#9DFF7C" or "#FF5A3D", string.format("真实充值 %s/%s", fmt(charge), fmt(needCharge)), 0.5, 0.5)
        text(bg, "lack", 300, 92, 18, lackCharge <= 0 and "#9DFF7C" or "#FFB85A", lackCharge <= 0 and "条件已达成，请手动点击升级" or ("还差 " .. fmt(lackCharge)), 0.5, 0.5)
        text(bg, "bonus", 300, 68, 17, "#F6D08A", "下阶：存储上限 " .. tostring(nextCfg.cap_text or "无存储"), 0.5, 0.5)
        button(bg, "level_confirm", 300, 22, lackCharge <= 0 and "确认升级" or "条件不足", function()
            if lackCharge > 0 then
                SL:ShowSystemTips("真实充值不足，还差 " .. fmt(lackCharge))
                return
            end
            SL:ShowSystemTips("请从顶部聚宝盆按钮进入功能界面同步品阶")
        end)
    end
end

local function ensureWindow(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, WINDOW_OPTS)
    local root = npc._window.bg
    GUI:setLocalZOrder(npc._window.node, 99)
    GUI:removeChildByName(root, "eff")
    npc.bg = GUI:Frames_Create(root, "eff", 0, 0, RES .. "bg/eff_", ".png", 1, 75, {speed = 75, count = 75, loop = -1})
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)
    GUI:removeChildByName(npc.bg, "node")
    npc.node = GUI:Node_Create(npc.bg, "node", 500, 360)
    return npc.node
end

local function renderBase(node)
    image(npc.bg, "title", 500, 520, RES .. "title.png")
end

local function renderTabs(node, npcid)
    local names = {"聚能收益", "炼灵宝石", "禁器养成"}
    for i, name in ipairs(names) do
        local y = 44 - (i - 1) * 62
        local selected = tab == i
        local bg = GUI:Image_Create(node, "tab_bg_" .. i, -405, y, "res/wy/public/tycccc.png")
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setContentSize(bg, selected and 205 or 178, selected and 50 or 40)
        GUI:setLocalZOrder(bg, -2)
        local line = GUI:Image_Create(node, "tab_line_" .. i, -405, y - 22, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(line, 0.5, 0.5)
        GUI:setContentSize(line, selected and 170 or 126, 10)
        GUI:setLocalZOrder(line, -1)
        if selected then
            local side = GUI:Image_Create(node, "tab_side_" .. i, -505, y, "res/wy/public/new_kuang.png")
            GUI:setAnchorPoint(side, 0.5, 0.5)
            GUI:setContentSize(side, 12, 44)
            GUI:setLocalZOrder(side, -1)
        end
        text(node, "tab_mark_" .. i, -475, y, selected and 26 or 20, selected and "#FFF0A8" or "#B77A39", selected and "◆" or "◇", 0.5, 0.5)
        text(node, "tab_text_" .. i, -392, y + 1, selected and 28 or 23, selected and "#FFE7A8" or "#D7A86A", name, 0.5, 0.5)
        local touch = GUI:Layout_Create(node, "tab_touch_" .. i, -510, y - 25, 220, 50, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnClickEvent(touch, function()
            tab = i
            npc.render(npcid)
        end)
    end
end

local function renderLevelInfo(node, npcid)
    panel(node, "level_info_panel", 304, -44, 275, 225, RES .. "xjm_bg.png")
    local d = data()
    local r = d.energy_reward or {}
    local lv = n(d.level, 1)
    local lc = levelCfg(lv)
    local state = n(d.activated) >= 1 and (n(d.equipped) >= 1 and "神器已穿戴" or "已激活未穿戴") or "主线未激活"
    local color = n(d.activated) >= 1 and (n(d.equipped) >= 1 and "#9DFF7C" or "#FFB85A") or "#FF5A3D"
    titleBar(node, "level_title", 304, 64, tostring(lc.name or "聚宝盆") .. " Lv." .. tostring(lv), 238)
    text(node, "level_reward_title", 304, 28, 19, "#E9D7B2", "品阶收益", 0.5, 0.5)
    text(node, "level_reward_1", 304, 2, 19, "#FFD66A", "金币 " .. fmt(r.gold), 0.5, 0.5)
    text(node, "level_reward_2", 304, -25, 18, "#B9F6C5", "玄铁 " .. fmt(r.iron) .. "  斗笠 " .. fmt(r.hat), 0.5, 0.5)
    text(node, "level_need_title", 304, -62, 19, "#E9D7B2", "当前状态", 0.5, 0.5)
    text(node, "level_state", 304, -88, 18, color, state, 0.5, 0.5)
    text(node, "level_speed", 304, -116, 18, "#9FE2FF", "收益效率  固定", 0.5, 0.5)
    text(node, "level_cap", 304, -144, 18, "#F6D08A", "存储上限 " .. tostring(lc.cap_text or "无存储"), 0.5, 0.5)
    local upBtn = GUI:Button_Create(node, "level_up_btn", 416, 64, RES .. "btn_up.png")
    GUI:setAnchorPoint(upBtn, 0.5, 0.5)
    GUI:addOnClickEvent(upBtn, openBasinLevelPopup)
end

local function renderEnergy(node, npcid)
    panel(node, "energy_info_panel", -155, -44, 390, 270, RES .. "xjm_bg.png")
    local d = data()
    titleBar(node, "energy_title", -155, 90, "聚能收益", 220)
    if n(d.activated) < 1 then
        text(node, "locked", -155, 0, 22, "#FF5A3D", "请先完成二大陆聚宝盆主线任务", 0.5, 0.5)
        rich(node, "locked_desc", -295, -38, "完成后获得<font color='#FFD66A'>聚宝盆</font>背包神器，穿戴后开始显示聚能进度。", 280, 19, 1)
        return
    end
    local capText = tostring(levelCfg(d.level).cap_text or "无存储")
    text(node, "energy_time", -155, 48, 22, "#9FE2FF", "当前存储  " .. tostring(d.energy_text or "00:00"), 0.5, 0.5)
    text(node, "energy_cap", -155, 18, 19, "#F6D08A", "存储上限  " .. capText, 0.5, 0.5)
    local energy = n(d.energy_sec)
    local cap = n(d.cap_sec or d.cap)
    if cap > 0 then
        local percent = math.max(0, math.min(100, energy / cap * 100))
        local barBg = GUI:Image_Create(node, "energy_bar_bg", -155, -14, RES .. "jdt_k.png")
        GUI:setAnchorPoint(barBg, 0.5, 0.5)
        GUI:setContentSize(barBg, 280, 16)
        GUI:setLocalZOrder(barBg, -1)
        local bar = GUI:LoadingBar_Create(node, "energy_bar", -155, -14, RES .. "jdt_m.png", 0)
        GUI:setAnchorPoint(bar, 0.5, 0.5)
        GUI:setContentSize(bar, 280, 16)
        GUI:LoadingBar_setPercent(bar, percent)
        text(node, "energy_percent", -155, -14, 17, "#FFFFFF", tostring(math.floor(percent)) .. "%", 0.5, 0.5)
    else
        text(node, "energy_no_cap", -155, -14, 18, "#B8A07B", "当前品阶暂无储能进度", 0.5, 0.5)
    end
    local r = d.energy_reward or {}
    local rewardBg = GUI:Image_Create(node, "energy_reward_bg", -155, -58, "res/wy/public/tycccc.png")
    GUI:setAnchorPoint(rewardBg, 0.5, 0.5)
    GUI:setContentSize(rewardBg, 310, 56)
    GUI:setLocalZOrder(rewardBg, -1)
    text(node, "reward_1", -155, -47, 21, "#FFD66A", "可领取金币  " .. fmt(r.gold), 0.5, 0.5)
    text(node, "reward_2", -155, -74, 19, "#B9F6C5", "千年玄铁 " .. fmt(r.iron) .. "    斗笠碎片 " .. fmt(r.hat), 0.5, 0.5)
    rich(node, "rule", -310, -105, "<font color='#E9D7B2'>在线完整累计，离线收益为在线的</font><font color='#9FE2FF'>50%</font><font color='#E9D7B2'>；领取后清空当前存储。</font>", 315, 17, 1)
    button(node, "claim_energy", -155, -194, "领取聚能", function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
end

local function renderRefine(node, npcid)
    panel(node, "refine_list_panel", -160, -52, 430, 260, "res/wy/public/tycccc.png")
    panel(node, "refine_state_panel", 300, -36, 270, 220, RES .. "xjm_bg.png")
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
    titleBar(node, "refine_title", -160, 80, "宝石选择", 210)
    text(node, "stone_tip", -160, 52, 16, "#E9D7B2", "仅显示已解锁大陆可炼灵宝石", 0.5, 0.5)
    text(node, "stone_head_bind", -245, 28, 18, "#FFD66A", "绑定宝石", 0.5, 0.5)
    text(node, "stone_head_trade", -58, 28, 18, "#9FE2FF", "非绑宝石", 0.5, 0.5)
    local bindRow = 0
    local freeRow = 0
    for _, item in ipairs(visible) do
        local i = item.idx
        local cfg = item.cfg
        local bind = tonumber(cfg.bind or 0) or 0
        local col = bind == 1 and 0 or 1
        if tonumber(cfg.continent or 0) <= 0 then col = 0 end
        if col == 0 then bindRow = bindRow + 1 else freeRow = freeRow + 1 end
        local row = col == 0 and bindRow or freeRow
        local x = -245 + col * 187
        local y = -4 - (row - 1) * 29
        local selected = selectedStone == i
        local rowBg = GUI:Image_Create(node, "stone_row_bg_" .. i, x, y, "res/wy/public/new_kuang.png")
        GUI:setAnchorPoint(rowBg, 0.5, 0.5)
        GUI:setContentSize(rowBg, selected and 175 or 156, selected and 27 or 22)
        GUI:setLocalZOrder(rowBg, -1)
        if selectedStone == i then
            text(node, "stone_sel_" .. i, x, y + 1, 17, "#9DFF7C", "◆ " .. cfg.name, 0.5, 0.5)
        else
            text(node, "stone_" .. i, x, y + 1, 16, cfg.name:find("非绑") and "#9FE2FF" or "#F6D08A", cfg.name, 0.5, 0.5)
        end
        local touch = GUI:Layout_Create(node, "stone_touch_" .. i, x - 86, y - 14, 172, 28, false)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnClickEvent(touch, function()
            selectedStone = i
            npc.render(npcid)
        end)
    end
    if #visible <= 1 then
        text(node, "stone_empty_tip", -58, -4, 16, "#FFB85A", "解锁新大陆后开放专属宝石", 0.5, 0.5)
    end
    local cfg = stonesCfg()[selectedStone] or stonesCfg()[1] or {}
    titleBar(node, "play_title", 300, 70, "玩法说明", 210)
    text(node, "sel_name", 300, 38, 19, "#FFD66A", cfg.name, 0.5, 0.5)
    text(node, "sel_time", 300, 10, 18, "#9FE2FF", "炼灵耗时  " .. cfg.time, 0.5, 0.5)
    rich(node, "sel_desc", 190, -24, "<font color='#E9D7B2'>产出规则：</font><font color='#F6D08A'>" .. cfg.desc .. "</font>", 225, 18, 1)
    if n(ref.active) >= 1 then
        local done = n(ref.done) >= 1
        text(node, "ref_status", 300, -82, 20, done and "#9DFF7C" or "#FFB85A", done and "炼灵完成，可领取" or ("炼灵中 " .. tostring(ref.left or 0) .. "秒"), 0.5, 0.5)
        button(node, "claim_refine", 300, -186, "领取产物", function()
            SL:SendLuaNetMsg(100, npcid, 3, 0, "")
        end)
    else
        text(node, "ref_status", 300, -82, 20, "#B9F6C5", "当前空闲，可放入一枚宝石", 0.5, 0.5)
        button(node, "start_refine", 300, -186, "开始炼灵", function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({stone = cfg.name}))
        end)
    end
end

local function renderForbidden(node, npcid)
    local d = data()
    local point = n(d.forbidden_point)
    local needPoint = 8888
    local pointPercent = math.max(0, math.min(100, point / needPoint * 100))
    local list = d.forbidden or {}
    if selectedForbidden < 1 or selectedForbidden > 3 then selectedForbidden = 1 end
    local sf = list[selectedForbidden] or {}
    local sfc = forbiddenCfg(selectedForbidden)
    local lv = n(sf.lv)
    local active = lv > 0
    local nextLv = math.min(5, lv + 1)
    local maxed = active and lv >= 5
    local costs = cfg().forbidden_cost or {}
    local cost = costs[nextLv] or {}
    local skillCdLeft = n(d.forbidden_skill_cd_left)
    local skillCdText = tostring(d.forbidden_skill_cd_text or "")
    local skillCooling = skillCdLeft > 0

    panel(node, "forbid_left_panel", -205, -54, 275, 268, RES .. "xjm_bg.png")
    panel(node, "forbid_top_panel", 150, 48, 300, 82, "res/wy/public/tycccc.png")
    panel(node, "forbid_detail_panel", 150, -74, 300, 156, RES .. "xjm_bg.png")
    panel(node, "forbid_cost_panel", 150, -168, 230, 58, "res/wy/public/tycccc.png")

    titleBar(node, "forbid_title", 150, 84, "禁器养成", 210)
    rich(node, "forbid_rule", 18, 52, "<font color='#E9D7B2'>禁器技能三件共享24小时CD：</font><font color='" .. (skillCooling and "#FFB85A" or "#9DFF7C") .. "'>" .. (skillCooling and ("冷却中 " .. skillCdText) or "当前可释放") .. "</font>", 260, 17, 1)

    titleBar(node, "forbid_left_title", -205, 70, "三大禁器", 205)
    text(node, "point_label", -318, 42, 17, "#F6D08A", "聚宝值", 0.5, 0.5)
    local pointBarBg = GUI:Image_Create(node, "forbid_point_bar_bg", -196, 42, RES .. "jdt_k.png")
    GUI:setAnchorPoint(pointBarBg, 0.5, 0.5)
    GUI:setContentSize(pointBarBg, 190, 13)
    GUI:setLocalZOrder(pointBarBg, -1)
    local pointBar = GUI:LoadingBar_Create(node, "forbid_point_bar", -196, 42, RES .. "jdt_m.png", 0)
    GUI:setAnchorPoint(pointBar, 0.5, 0.5)
    GUI:setContentSize(pointBar, 190, 13)
    GUI:LoadingBar_setPercent(pointBar, pointPercent)
    text(node, "point_value", -196, 42, 15, "#FFFFFF", string.format("%s/%s", fmt(point), fmt(needPoint)), 0.5, 0.5)

    for i = 1, 3 do
        local f = list[i] or {}
        local fc = forbiddenCfg(i)
        local rowActive = n(f.lv) > 0
        local claimed = n(f.used) >= 1 or skillCooling
        local y = 5 - (i - 1) * 58
        local selected = selectedForbidden == i
        panel(node, "forbid_row_bg_" .. i, -205, y, selected and 244 or 222, selected and 51 or 43, "res/wy/public/new_kuang.png")
        text(node, "forbid_mark_" .. i, -314, y + 1, selected and 22 or 18, selected and "#9DFF7C" or "#B77A39", selected and "◆" or "◇", 0.5, 0.5)
        text(node, "forbid_name_" .. i, -292, y + 12, 18, selected and "#FFE7A8" or "#D7A86A", tostring(fc.name or "禁器"), 0, 0.5)
        text(node, "forbid_grade_" .. i, -292, y - 12, 16, rowActive and "#9FE2FF" or "#FF8A65", rowActive and ("品阶 " .. gradeName(f.lv)) or "未激活", 0, 0.5)
        text(node, "forbid_state_" .. i, -110, y - 12, 15, claimed and "#FFB85A" or (rowActive and "#9DFF7C" or "#FF5A3D"), n(f.show) >= 1 and (skillCooling and "冷却中" or "外显中") or (claimed and "冷却中" or ""), 0.5, 0.5)
        local touch = GUI:Layout_Create(node, "forbid_touch_" .. i, -326, y - 25, 244, 50, 0)
        GUI:setTouchEnabled(touch, true)
        GUI:addOnClickEvent(touch, function()
            selectedForbidden = i
            npc.render(npcid)
        end)
    end

    local iconNode = GUI:Node_Create(node, "forbid_icon_node", -302, -174)
    if type(ItemNumByTable_img_new) == "function" then
        ItemNumByTable_img_new({{tostring(sfc.name or "禁器"), 1}}, nil, iconNode)
    end
    text(node, "forbid_selected_name", -188, -152, 20, "#FFD66A", tostring(sfc.name or "禁器"), 0, 0.5)
    text(node, "forbid_selected_plus", -188, -178, 17, "#B9F6C5", tostring(sfc.plus or ""), 0, 0.5)

    text(node, "detail_name", 150, 14, 22, "#FFE7A8", tostring(sfc.name or "禁器"), 0.5, 0.5)
    text(node, "detail_lv", 150, -16, 19, "#9FE2FF", active and ("当前 Lv." .. tostring(lv) .. "  →  目标 Lv." .. tostring(nextLv)) or "当前未激活", 0.5, 0.5)
    text(node, "detail_skill", 150, -45, 18, "#F6D08A", "禁器技能：" .. tostring(sfc.skill or "未知"), 0.5, 0.5)
    text(node, "detail_bonus", 150, -74, 18, "#B9F6C5", "属性加成：" .. tostring(sfc.plus or ""), 0.5, 0.5)
    text(node, "detail_state", 150, -104, 18, skillCooling and "#FFB85A" or (maxed and "#9DFF7C" or (active and "#FFD66A" or "#FF8A65")), skillCooling and ("公共CD剩余：" .. skillCdText) or (maxed and "已炼至极品" or (active and ("下阶需要聚宝盆 Lv." .. tostring(cost.need_level or 0)) or "消耗聚宝值可激活")), 0.5, 0.5)

    if active and not maxed then
        text(node, "cost_yb", 76, -161, 17, "#F6D08A", "元宝：" .. fmt(cost.yuanbao or 0), 0.5, 0.5)
        text(node, "cost_crystal", 223, -161, 17, "#F6D08A", "禁元神晶：" .. fmt(cost.crystal or 0), 0.5, 0.5)
    elseif active and maxed then
        text(node, "cost_max", 150, -161, 18, "#9DFF7C", "当前禁器已达到最高品阶", 0.5, 0.5)
    else
        text(node, "cost_unlock", 150, -161, 18, "#F6D08A", "激活消耗：聚宝值 8888", 0.5, 0.5)
    end

    smallButton(node, "forbid_main_action", 150, -208, maxed and "已满级" or (active and "确认升级" or "激活禁器"), function()
        if maxed then
            SL:ShowSystemTips("该禁器已是极品")
            return
        end
        SL:SendLuaNetMsg(100, npcid, active and 5 or 4, selectedForbidden, "")
    end, active and "#FFE7A8" or "#9DFF7C")
    smallButton(node, "forbid_show_btn", 48, -208, n(sf.show) >= 1 and "外显中" or "设为外显", function()
        SL:SendLuaNetMsg(100, npcid, 6, selectedForbidden, "")
    end, n(sf.show) >= 1 and "#9FE2FF" or "#FFE7A8")
    smallButton(node, "forbid_claim_btn", 252, -208, skillCooling and "冷却中" or "释放技能", function()
        SL:SendLuaNetMsg(100, npcid, 7, selectedForbidden, "")
    end, skillCooling and "#FFB85A" or "#FFD66A")
end

local function canRebuildTask()
    local d = data()
    return n(d.activated) < 1 and n(d.fragment_have) >= n(d.fragment_need)
end


local function renderTaskWindow(npcid)
    local node = ensureWindow(npcid)
    renderBase(node)
    local d = data()
    local fragmentName = tostring(d.fragment_item or (cfg().fragment_item or "聚宝盆碎片"))
    local need = n(d.fragment_need, cfg().fragment_count or 20)
    local have = n(d.fragment_have)
    local artifactName = tostring(d.artifact_item_name or "聚宝盆")
    if n(d.activated) < 1 then

        -- text(node, "task_desc", 0, 115, 22, "#FFFFFF", "主线目标：收集" .. fmt(need) .. "个" .. fragmentName .. "，完成聚宝盆修复。", 0.5, 0.5)

        image(node, "task_need_title", -458, 30, RES .. "任务要求.png", 0, 0.5)
        image(node, "task_reward_title", -458, -46 - 30, RES .. "任务奖励.png", 0, 0.5)


        text(node, "task_need_desc", -92 - 70 - 133, 17 - 40, 26, have >= need and "#66CCFF" or "#FF5A5A", "当前已收集 " .. fmt(have) .. "/" .. fmt(need) , 0.5, 0.5)

        local checkItemNumByTable_img_kuang = checkItemNumByTable_img_kuang({{fragmentName, need}}, nil, GUI:Node_Create(node, "task_cost_show", -342 + 134, -104 + 51))
        _add_reward_effect_for_table(checkItemNumByTable_img_kuang, "reward_eff", 28, 30, 0.9, 13054)



        text(node, "task_reward_desc_1", -78 - 157, -80 - 30, 22, "#FFFFFF", "修复完成后获得【" .. artifactName .. "】", 0.5, 0.5)
        text(node, "task_reward_desc_2", -78 - 157, -102 - 30, 22, "#66CCFF", "穿戴后开始累计聚能收益。", 0.5, 0.5)
        local itemNumByTable_img_new = ItemNumByTable_img_new({{artifactName, 1}}, nil, GUI:Node_Create(node, "task_reward_show", 334 + 134 - 853 + 326, -94 + 41 - 146 + 53))
        _add_reward_effect_for_table(itemNumByTable_img_new, "reward_eff", 28, 30, 0.9, 13054)


        local taskTip1 = text(node, "task_tip_1", -118, -194 - 50, 22, "#66CCFF", "点击此处可购买包含聚宝盆碎片的礼包[一举多得]！！！！", 0.5, 0.5)
        GUI:Text_enableUnderline(taskTip1)
        GUI:setTouchEnabled(taskTip1, true)
        GUI:addOnClickEvent(taskTip1, function()
            SL:SendLuaNetMsg(100, npcid, 10, 0, "")
        end)
        -- text(node, "task_tip_2", -118, -218, 22, "#FFFFFF", "材料集齐后点击右下方按钮修复即可。", 0.5, 0.5)

        local claimBtn = GUI:Frames_Create(node, "task_claim_btn", 246, -172, "res/custom/treasureBasin/btn1_eff/eff_", ".png", 1, 75, {speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(claimBtn, 0.5, 0.5)
        GUI:setTouchEnabled(claimBtn, true)
        GUI:addOnClickEvent(claimBtn, function()
            if not canRebuildTask() then
                NPC_UI_HELPER.closeWindow(npc._window)
            end
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        NPC_UI_HELPER.tryStartXylGuide(npc, claimBtn, node, "treasure_basin_rebuild", {
            taskNames = {"修复聚宝盆", "聚宝盆", "聚宝盆任务"},
            dir = 7,
            desc = "点击修复聚宝盆",
        })
        -- NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, claimBtn, node, npcid, "treasure_basin_rebuild", {
        --     taskMap = {[npcid] = 23},
        --     keyPrefix = "mainline_treasure_basin",
        --     dir = 7,
        --     desc = "点击修复聚宝盆",
        -- })
        if canRebuildTask() then
            NPC_UI_HELPER.redpoint_create_eff(claimBtn, {x = 200, y = 155})
        end
        return
    end

    image(node, "task_reward_title", -458, -46 - 30, RES .. "任务奖励.png", 0, 0.5)

    local rewardItem = ItemNumByTable_img_new({{artifactName, 1}}, nil, GUI:Node_Create(node, "task_reward_show_done", 334 + 134 - 853 + 326, -94 + 41 - 146 + 53))
    _add_reward_effect_for_table(rewardItem, "reward_eff", 28, 30, 0.9, 13054)


    local equipColor = n(d.equipped) >= 1 and "#66CCFF" or "#FFFFFF"
    if n(d.equipped) >= 1 then
        text(node, "task_equip_1", -78 - 157, -80 - 30, 22, equipColor, "聚宝盆已穿戴，", 0.5, 0.5)
        text(node, "task_equip_2", -78 - 157, -102 - 30, 22, equipColor, "当前聚能收益正在生效。", 0.5, 0.5)
    else
        text(node, "task_equip_1", -78 - 157, -80 - 30, 22, equipColor, "聚宝盆已修复，", 0.5, 0.5)
        text(node, "task_equip_2", -78 - 157, -102 - 30, 22, equipColor, "请穿戴到背包神器位后开始生效。", 0.5, 0.5)
    end
end
function npc.render(npcid)
    local node = ensureWindow(npcid)
    renderBase(node)
    renderTabs(node, npcid)
    renderLevelInfo(node, npcid)
    if tab == 1 then
        renderEnergy(node, npcid)
    elseif tab == 2 then
        renderRefine(node, npcid)
    else
        renderForbidden(node, npcid)
    end
end

function npc.main(npcid, p2, p3, msgData)
    if msgData and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
    else
        npc.data = npc.data or {}
    end 
    renderTaskWindow(npcid)
    if p2 ~= 0 and n((npc.data or {}).activated) >= 1
        and NPC_UI_HELPER.isCurrentXylTask({"修复聚宝盆", "聚宝盆", "聚宝盆任务"}) then
        NPC_UI_HELPER.closeWindow(npc._window)
    end
end

return npc



