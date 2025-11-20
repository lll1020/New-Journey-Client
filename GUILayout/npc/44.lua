
--[[
NPC 44 (仙府玩法) 客户端界面；负责渲染 UI、同步服务器状态、发送操作。
结构：配置/布局 -> 状态与工具 -> 功能模块渲染 -> 菜单调度 -> NPC 入口。
]]

local npc = {}

-- 策划下发的玩法配置（PlantCfg/ShopCfg/...），用于驱动前端数据。
npc._config = teshudata["npc_44"] or {}

-- NPC 窗口的皮肤/关闭按钮等基础参数。
local WINDOW_OPTS = {
    background = {skin = 'res/wy/public/tongyong_0.png',},
    closeButton = {x = 750, y = 460},
    node = {x = 500, y = 300},
   
}

-- 用于定位各个功能模块的锚点与尺寸，方便统一排版。
local layout = {
    top = {x = 0, y = 250},
    farm = {x = -360, y = 160, size = 92, gap = 8, perRow = 3},
    farmDetail = {x = -360, y = -120},
    inventory = {x = 0, y = 170},
    quick = {x = 0, y = 40},
    visitor = {x = 0, y = -140},
    system = {x = 0, y = -240},
    shop = {x = 320, y = 170},
    refine = {x = 320, y = 20},
    pet = {x = 320, y = -140},
    rank = {x = 320, y = -260},
    menu = {x = 0, y = 210},
}

-- 顶部菜单栏配置：id 为逻辑关键字，label 为按钮文本。
local MENU_TABS = {
    {id = 'overview', label = '总览'},
    {id = 'farm', label = '菜园'},
    {id = 'inventory', label = '灵草仓储'},
    {id = 'social', label = '社交互动'},
    {id = 'shop', label = '商城装扮'},
    {id = 'refine', label = '炼丹炉'},
    {id = 'pet', label = '灵兽培养'},
    {id = 'rank', label = '排行称号'},
    {id = 'system', label = '系统提示'},
}

-- UI 文本及按钮常用配色，集中管理方便整体调色。

local MENU_PERMISSIONS = {
    self = {overview = true, farm = true, inventory = true, social = true, shop = true, refine = true, pet = true, rank = true, system = true},
    guest = {farm = true, social = true},
}

local colors = {
    primary = '#ffe9c2',
    accent = '#8af5ff',
    detail = '#c0f7a2',
    warning = '#ffcd7f',
    danger = '#ff8686',
    muted = '#9fb0c0',
}

-- 维护前端本地状态（选中地块、菜单页签等），避免 nil。
local function ensureState()
    npc._state = npc._state or {}
    local state = npc._state
    state.selectedPlot = state.selectedPlot or 1
    state.shopTab = state.shopTab or 'seeds'
    state.friendKey = state.friendKey or ''
    state.lastMessage = state.lastMessage or ''
    state.lastActionOk = state.lastActionOk or false
    state.menuTab = state.menuTab or 'overview'
    state.viewMode = state.viewMode or 'self'
    state.remoteGridId = math.max(1, math.min(npc._config.gridSize or 9, tonumber(state.remoteGridId) or 1))
    return state
end

-- === 通用工具：时间/序列化/通信 ===
local function serverNow()
    if SL and SL.GetMetaValue then
        return SL:GetMetaValue('SERVER_TIME') or os.time()
    end
    return os.time()
end

-- JSON 解码封装，保护未知结构。
local function parseJson(msg)
    if not msg or msg == '' then
        return nil
    end
    if not SL or not SL.JsonDecode then
        return nil
    end
    local ok, data = pcall(function()
        return SL:JsonDecode(msg, false)
    end)
    if ok then
        return data
    end
    return nil
end

-- JSON 编码封装，所有 action 复用。
local function encodeJson(payload)
    if not payload or not SL or not SL.JsonEncode then
        return ''
    end
    return SL:JsonEncode(payload, false)
end

-- 统一发送 action -> 服务器。
local function sendAction(npcid, action, param)
    if not npcid or not action then
        return
    end
    local payload = {action = action, param = param}
    SL:SendLuaNetMsg(100, npcid, 1, 0, encodeJson(payload))
end

local function getSnapshot()
    local state = ensureState()
    return state.snapshot or {}
end

local function wrapGuestSnapshot(target)
    if not target then
        return nil
    end
    local base = getSnapshot()
    local wrapped = {
        player = {
            key = target.key,
            name = target.name,
            xiangHua = target.xiangHua or 0,
            herbs = target.herbs or {},
            seeds = target.seeds or {},
            fields = target.fields or {},
            steal = {},
            guard = {},
            likes = {},
            decoration = target.decoration or {},
            refine = {},
            pet = target.pet or {},
            visitor = target.visitor or {},
        },
        cfg = (base and base.cfg) or {},
        rank = base and base.rank or {},
    }
    return wrapped
end

local function isGuestMode()
    return ensureState().viewMode == 'guest'
end

local function enterGuestMode(targetSnapshot)
    local wrapped = wrapGuestSnapshot(targetSnapshot)
    if not wrapped then
        return
    end
    local state = ensureState()
    state.viewMode = 'guest'
    state.guestSnapshot = wrapped
    state.menuTab = 'farm'
    state.friendKey = (targetSnapshot and (targetSnapshot.name or targetSnapshot.key)) or state.friendKey
end

local function exitGuestMode()
    local state = ensureState()
    state.viewMode = 'self'
    state.guestSnapshot = nil
    state.menuTab = state.menuTab == 'overview' and state.menuTab or 'overview'
end

local function getGuestTargetName()
    local state = ensureState()
    local guest = state.guestSnapshot and state.guestSnapshot.player
    if guest then
        return guest.name or guest.key or ''
    end
    return state.friendKey or ''
end

local function getActiveSnapshot()
    local state = ensureState()
    if state.viewMode == 'guest' and state.guestSnapshot then
        return state.guestSnapshot
    end
    return getSnapshot()
end

-- 刷新服务器快照，顺带修正当前选中地块。
local function updateSnapshot(data)
    if not data then
        return
    end
    local state = ensureState()
    state.snapshot = data
    state.lastSyncAt = serverNow()
    local fields = (data.player and data.player.fields) or {}
    if state.selectedPlot then
        local slot = fields[state.selectedPlot]
        if not slot then
            state.selectedPlot = 1
        end
    else
        state.selectedPlot = 1
    end
end

-- ===== 文本/数值格式化辅助 =====
local function formatNumber(value)
    local num = tonumber(value) or 0
    local formatted = tostring(math.floor(num + 0.5))
    local result = formatted
    local k = 0
    result = formatted
    while true do
        result, k = result:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return result
end

local function formatCost(cost)
    if type(cost) ~= 'table' then
        return '—'
    end
    local parts = {}
    for key, value in pairs(cost) do
        if type(value) == 'table' then
            local name = value[1]
            local amount = value[2]
            if name then
                parts[#parts + 1] = string.format('%s x%s', name, formatNumber(amount or 0))
            end
        elseif type(key) == 'string' then
            parts[#parts + 1] = string.format('%s x%s', key, formatNumber(value))
        end
    end
    table.sort(parts)
    return (#parts > 0) and table.concat(parts, ' / ') or '—'
end

local function formatAddValue(add)
    if type(add) ~= 'table' then
        return ''
    end
    local parts = {}
    for k, v in pairs(add) do
        parts[#parts + 1] = string.format('%s+%s', k, formatNumber(v))
    end
    table.sort(parts)
    return table.concat(parts, '、')
end

local function formatSeconds(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format('%02d:%02d:%02d', h, m, s)
    end
    return string.format('%02d:%02d', m, s)
end

local function safePairs(list)
    local arr = {}
    if type(list) ~= 'table' then
        return arr
    end
    for _, value in pairs(list) do
        arr[#arr + 1] = value
    end
    return arr
end

-- 读取地块配置（低阶/高阶灵草）。
local function buildPlantList(plantCfg)
    local list = {}
    for id, cfg in pairs(plantCfg or {}) do
        list[#list + 1] = {id = id, cfg = cfg}
    end
    table.sort(list, function(a, b)
        local aid = tonumber(a.cfg.id or a.id) or 0
        local bid = tonumber(b.cfg.id or b.id) or 0
        if aid == bid then
            return (a.cfg.name or a.id or '') < (b.cfg.name or b.id or '')
        end
        return aid < bid
    end)
    return list
end

local function resolveHerbCount(herbs, plantCfg, herbName)
    herbs = herbs or {}
    if herbs[herbName] ~= nil then
        return herbs[herbName]
    end
    for id, cfg in pairs(plantCfg or {}) do
        if cfg.name == herbName and herbs[id] ~= nil then
            return herbs[id]
        end
    end
    if herbName == '低阶灵草' and herbs.Low ~= nil then
        return herbs.Low
    end
    if herbName == '高阶灵草' and herbs.High ~= nil then
        return herbs.High
    end
    return herbs[herbName] or 0
end

local function pickStealTipNames(plantCfg)
    local stealable, safe = nil, nil
    for _, cfg in pairs(plantCfg or {}) do
        if cfg.canSteal and not stealable then
            stealable = cfg.name or cfg.id
        elseif cfg.canSteal == false and not safe then
            safe = cfg.name or cfg.id
        end
    end
    return stealable, safe
end

local function hasProductReward(product)
    if type(product) ~= 'table' then
        return false
    end
    for _, entry in pairs(product) do
        if type(entry) == 'table' then
            return true
        end
    end
    return false
end

local function summarizeProduct(product)
    if not hasProductReward(product) then
        return ''
    end
    local parts = {}
    for _, item in ipairs(product or {}) do
        if type(item) == 'table' then
            local name = item[1] or '?'
            local count = formatNumber(item[2] or 0)
            parts[#parts + 1] = string.format('%s*%s', name, count)
        end
    end
    return table.concat(parts, '、')
end

local function getPlantCfg(seedId)
    local cfg = (getSnapshot().cfg or {}).plant or {}
    return cfg[seedId]
end

local function canPlotBeStolen(plot)
    if not plot or plot.state ~= 'mature' then
        return false
    end
    if not hasProductReward(plot.product) then
        return false
    end
    local cfg = getPlantCfg(plot.seedId)
    return cfg and cfg.canSteal and true or false
end



-- 根据地块状态拼装提示文案。
local function describePlot(plot)
    plot = plot or {}
    local stateName = plot.state or 'empty'
    local cfg = getPlantCfg(plot.seedId)
    local name = cfg and cfg.name or (plot.seedId == 'High' and '高阶灵草' or (plot.seedId == 'Low' and '低阶灵草' or '未播种'))
    local now = serverNow()
    if stateName == 'growing' then
        local remain = math.max(0, (plot.finishAt or now) - now)
        return string.format('成长中\n%s', formatSeconds(remain)), cfg and cfg.canSteal and '可被偷' or '安全'
    elseif stateName == 'mature' then
        local reward = summarizeProduct(plot.product)
        local tips = (cfg and cfg.canSteal) and '未收获可被偷' or '不可被偷'
        local statusText = '可收获'
        if reward ~= '' then
            statusText = statusText .. '\n' .. reward
        end
        return statusText, tips
    elseif stateName == 'empty' then
        return '空地', '可播种'
    end
    return stateName, name
end

-- 小工具：统计 table 元素个数。
local function countTableSize(t)
    local n = 0
    if type(t) ~= 'table' then
        return 0
    end
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
    opts.subTitle = '仙府总览'
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
end

-- 顶部概览：玩家昵称/仙华/排行提示。
local function buildTopOverview(node, snapshot, baseSnapshot)
    local state = ensureState()
    local guestMode = isGuestMode()
    local player = snapshot.player or {}
    local rankList = (snapshot.rank and #snapshot.rank > 0) and snapshot.rank or ((baseSnapshot and baseSnapshot.rank) or {})
    local summary = GUI:Node_Create(node, 'top_summary', layout.top.x, layout.top.y)
    GUI:setAnchorPoint(summary, 0.5, 0.5)
    local titleFmt = guestMode and '拜访：%s    仙华值：%s' or '仙府主：%s    仙华值：%s'
    local topText = string.format(titleFmt, player.name or '--', formatNumber(player.xiangHua or 0))
    local label = GUI:Text_Create(summary, 'top_main', 0, 0, 22, colors.primary, topText)
    GUI:setAnchorPoint(label, 0.5, 0)
    GUI:Text_enableOutline(label, '#1d0f09', 2)
    local tip = guestMode and '拜访模式仅开放菜园与社交功能，其余操作需返回自宅。' or '仙华值通过点赞、装扮、炼丹等玩法提升，今日排名实时更新。'
    local tipLabel = GUI:Text_Create(summary, 'top_tip', 0, -26, 18, colors.detail, tip)
    GUI:setAnchorPoint(tipLabel, 0.5, 0)
    GUI:Text_enableOutline(tipLabel, '#0c1a22', 1)
    local rankN = math.min(#rankList, (npc._config.RankCfg and npc._config.RankCfg.topN) or #rankList)
    local parts = {}
    for i = 1, math.min(rankN, 5) do
        local entry = rankList[i]
        parts[#parts + 1] = string.format('%d.%s(%s)', i, entry and entry.name or '--', entry and formatNumber(entry.value or 0) or '0')
    end
    local rankText = (#parts > 0) and table.concat(parts, '  ') or '暂无排行数据'
    local rankLabel = GUI:Text_Create(summary, 'top_rank', 0, -52, 18, colors.accent, string.format('今日排行 Top %d：%s', math.max(rankN, 1), rankText))
    GUI:setAnchorPoint(rankLabel, 0.5, 0)
    GUI:Text_enableOutline(rankLabel, '#0d1b26', 1)
    local titleCfg = npc._config.TitleCfg or {}
    local rankTitle = titleCfg.XianHuaRank1 and titleCfg.XianHuaRank1.name or '荣华天下'
    local rewardTip = string.format('今日第一可获得称号「%s」（当天有效）', rankTitle)
    local rewardLabel = GUI:Text_Create(summary, 'top_reward', 0, -76, 18, colors.warning, rewardTip)
    GUI:setAnchorPoint(rewardLabel, 0.5, 0)
    GUI:Text_enableOutline(rewardLabel, '#1b0f07', 1)
    if guestMode then
        NPC_UI_HELPER.createPrimaryButton(summary, 'btn_exit_guest', 260, -76, '返回自宅', function()
            exitGuestMode()
            npc.render()
        end)
    end
end

local function drawMenuBar(node)
    local bar = GUI:Node_Create(node, 'menu_bar', layout.menu.x, layout.menu.y)
    GUI:setAnchorPoint(bar, 0.5, 0.5)
    local state = ensureState()
    local permission = MENU_PERMISSIONS[isGuestMode() and 'guest' or 'self'] or {}
    local total = #MENU_TABS
    local startX = -((total - 1) * 70)
    for idx, tab in ipairs(MENU_TABS) do
        local x = startX 
        local allowed = permission[tab.id]
        local btn = NPC_UI_HELPER.createPrimaryButton(bar, 'menu_btn_' .. tab.id, x, - (idx - 1) * 50, tab.label, function()
            local s = ensureState()
            if not allowed then
                s.lastMessage = '拜访模式仅开放菜园与社交功能'
                npc.render()
                return
            end
            if s.menuTab ~= tab.id then
                s.menuTab = tab.id
                npc.render()
            end
        end)
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        if allowed then
            GUI:Button_setBright(btn, state.menuTab ~= tab.id)
        else
            GUI:Button_setBright(btn, false)
        end
    end
end



-- ===== 菜园九宫格 =====
local function drawPlotCells(node, snapshot)
    local fields = (snapshot.player and snapshot.player.fields) or {}
    local gridSize = npc._config.gridSize or 9
    local perRow = layout.farm.perRow
    local cellSize = layout.farm.size
    local gap = layout.farm.gap
    local origin = GUI:Node_Create(node, 'farm_grid', layout.farm.x, layout.farm.y)
    GUI:setAnchorPoint(origin, 0.5, 0.5)
    local title = GUI:Text_Create(origin, 'farm_title', 0, cellSize + 40, 20, colors.primary, '菜园九宫格')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local state = ensureState()
    for i = 1, gridSize do
        local row = math.floor((i - 1) / perRow)
        local col = (i - 1) % perRow
        local x = (col - 1) * (cellSize + gap)
        local y = -(row) * (cellSize + gap)
        local btn = GUI:Button_Create(origin, 'plot_btn_' .. i, x, y, 'res/public/1900000660.png')
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:setContentSize(btn, cellSize, cellSize)
        local plot = fields[i] or {state = 'empty', gridId = i}
        local status, tip = describePlot(plot)
        local content = string.format('<font size="18" color="#ffe9c2">地块%s</font><br/><font size="16" color="#9fe9ff">%s</font><br/><font size="14" color="#c8ffb4">%s</font>', i, status, tip)
        NPC_UI_HELPER.createRichText(btn, 'plot_text_' .. i, 0, 0, content, {width = cellSize - 10, height = 20, anchor = {x = 0.5, y = 0.5}})
        if state.selectedPlot == i then
            GUI:Button_setBright(btn, false)
        else
            GUI:Button_setBright(btn, true)
        end
        GUI:addOnClickEvent(btn, function()
            local s = ensureState()
            s.selectedPlot = i
            npc.render()
        end)
    end
end

-- 地块详情 + 播种/收获操作提示。
local function drawPlotDetail(node, snapshot, npcid)
    local state = ensureState()
    local panel = GUI:Node_Create(node, 'farm_detail', layout.farmDetail.x, layout.farmDetail.y)
    GUI:setAnchorPoint(panel, 0, 1)
    local title = GUI:Text_Create(panel, 'farm_detail_title', 0, 0, 20, colors.primary, '地块详情')
    GUI:setAnchorPoint(title, 0, 1)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local player = snapshot.player or {}
    local fields = player.fields or {}
    local selected = math.max(1, math.min(state.selectedPlot or 1, npc._config.gridSize or 9))
    local plot = fields[selected] or {state = 'empty', gridId = selected}
    local cfg = getPlantCfg(plot.seedId)
    local plantCfg = snapshot.cfg and snapshot.cfg.plant or {}
    local stealableName, safeName = pickStealTipNames(plantCfg)
    local status, tip = describePlot(plot)
    local detailText = string.format('地块 %s｜状态：%s｜提示：%s', selected, status, tip)
    NPC_UI_HELPER.createRichText(panel, 'farm_detail_text', 0, -28, detailText, {width = 360, height = 40, anchor = {x = 0, y = 1}})
    local seedLabel = cfg and cfg.name or (plot.state == 'empty' and '未播种' or '未知种子')
    local rewardText = summarizeProduct(plot.product)
    local harvestInfo = string.format('作物：%s', seedLabel)
    if rewardText ~= '' then
        harvestInfo = harvestInfo .. string.format('｜奖励：%s', rewardText)
    end
    if plot.state == 'growing' and plot.finishAt then
        harvestInfo = harvestInfo .. string.format('｜成熟倒计时：%s', formatSeconds((plot.finishAt or 0) - serverNow()))
    end
    if plot.state == 'mature' then
        local theftTip = nil
        if cfg then
            if cfg.canSteal then
                theftTip = string.format('%s成熟后请尽快收取，超时可被偷。', cfg.name or '灵草')
            else
                theftTip = string.format('%s成熟不可偷，安心收获。', cfg.name or '灵草')
            end
        elseif stealableName then
            theftTip = string.format('%s成熟后请尽快收取，超时可被偷。', stealableName)
        end
        if theftTip then
            harvestInfo = harvestInfo .. '\n' .. theftTip
        end
    elseif plot.state == 'empty' then
        local baseTip
        if stealableName and safeName then
            baseTip = string.format('%s成熟未收会被偷，%s成熟不可偷。', stealableName, safeName)
        elseif stealableName then
            baseTip = string.format('%s成熟未收会被偷。', stealableName)
        elseif safeName then
            baseTip = string.format('%s成熟不可偷。', safeName)
        else
            baseTip = '请及时收获成熟灵草，避免损失。'
        end
        harvestInfo = harvestInfo .. '\n' .. baseTip
    end
    NPC_UI_HELPER.createRichText(panel, 'farm_detail_desc', 0, -64, harvestInfo, {width = 360, height = 60, anchor = {x = 0, y = 1}})

    local guestMode = isGuestMode()
    if guestMode then
        local guestTarget = getGuestTargetName()
        NPC_UI_HELPER.createRichText(panel, 'farm_guest_tip', 0, -100, '拜访模式仅可偷取成熟灵草，无法播种/收获。', {width = 360, height = 40, anchor = {x = 0, y = 1}, color = colors.warning})
        local canSteal = canPlotBeStolen(plot)
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'guest_steal_btn', 120, -140, '偷取', function()
            if not guestTarget or guestTarget == '' then
                state.lastMessage = '拜访对象无效，请返回自宅后重试'
                npc.render()
                return
            end
            if not canSteal then
                state.lastMessage = '当前地块不可偷取，请选择可偷的成熟灵草'
                npc.render()
                return
            end
            sendAction(npcid, 'steal', {targetName = guestTarget, gridId = plot.gridId or selected})
        end)
        GUI:setAnchorPoint(btn, 0, 0.5)
        if not canSteal then
            GUI:Button_setBright(btn, false)
        end
        return
    end

    local buttonY = -130
    local function createActionButton(name, x, text, callback, enabled)
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, name, x, buttonY, text, callback)
        if enabled == false then
            GUI:Button_setBright(btn, false)
        end
        return btn
    end

    if plot.state == 'empty' then
        createActionButton('btn_seed_low', 0, '播种·低阶', function()
            sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'Low'})
        end, true)
        createActionButton('btn_seed_high', 150, '播种·高阶', function()
            sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'High'})
        end, true)
    elseif plot.state == 'mature' then
        local canHarvest = hasProductReward(plot.product)
        createActionButton('btn_harvest', 0, '收获', function()
            sendAction(npcid, 'harvest', {gridId = plot.gridId or selected})
        end, canHarvest)
    elseif plot.state == 'growing' then
        createActionButton('btn_acc', 0, '加速（敬请期待）', function()
            local s = ensureState()
            s.lastMessage = '加速功能预留，暂未开放。'
            s.lastActionOk = false
            npc.render()
        end, false)
    else
        createActionButton('btn_idle', 0, '等待中', nil, false)
    end
end

local function drawInventory(node, snapshot, npcid)
    local panel = GUI:Node_Create(node, 'inventory_panel', layout.inventory.x, layout.inventory.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'inventory_title', 0, 80, 20, colors.primary, '灵草与库存')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    if isGuestMode() then
        NPC_UI_HELPER.createRichText(panel, 'inventory_guest_tip', 0, 20, '拜访模式不可查看仓库，请返回自宅后再尝试。', {width = 360, height = 40, anchor = {x = 0.5, y = 1}, color = colors.warning})
        return
    end
    local player = snapshot.player or {}
    local seeds = player.seeds or {}
    local herbs = player.herbs or {}
    local shop = (snapshot.cfg and snapshot.cfg.shop) or {}
    local plantCfg = snapshot.cfg and snapshot.cfg.plant or {}
    local seedList = shop.seeds or {}
    local plantList = buildPlantList(plantCfg)

    local y = 50
    if #seedList > 0 then
        local seedHeader = GUI:Text_Create(panel, 'inventory_seed_header', -170, y, 18, colors.detail, '种子库存 / 购买')
        GUI:setAnchorPoint(seedHeader, 0, 0.5)
        GUI:Text_enableOutline(seedHeader, '#1d0f09', 1)
        y = y - 26
        for idx, entry in ipairs(seedList) do
            local rowY = y - (idx - 1) * 30
            local label = string.format('%s：%s', entry.name or entry.id, formatNumber(seeds[entry.seed] or 0))
            local rowLabel = GUI:Text_Create(panel, 'inventory_seed_' .. idx, -170, rowY, 18, colors.primary, label)
            GUI:setAnchorPoint(rowLabel, 0, 0.5)
            GUI:Text_enableOutline(rowLabel, '#1d0f09', 1)
            local costLabel = GUI:Text_Create(panel, 'inventory_seed_cost_' .. idx, -20, rowY, 16, colors.detail, string.format('售价：%s', formatCost(entry.cost)))
            GUI:setAnchorPoint(costLabel, 0, 0.5)
            local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'inventory_buy_' .. entry.id, 150, rowY, '购买', function()
                sendAction(npcid, 'buySeed', {id = entry.id, amount = 1})
            end)
            GUI:setAnchorPoint(btn, 0, 0.5)
        end
        y = y - (#seedList * 30) - 20
    end

    local herbHeader = GUI:Text_Create(panel, 'inventory_herb_header', -170, y, 18, colors.detail, '灵草库存')
    GUI:setAnchorPoint(herbHeader, 0, 0.5)
    GUI:Text_enableOutline(herbHeader, '#1d0f09', 1)
    y = y - 26
    if #plantList == 0 then
        local emptyTip = GUI:Text_Create(panel, 'inventory_herb_empty', -170, y, 18, colors.warning, '暂无灵草配置')
        GUI:setAnchorPoint(emptyTip, 0, 0.5)
    else
        for idx, plant in ipairs(plantList) do
            local rowY = y - (idx - 1) * 26
            local herbName = plant.cfg.name or plant.id
            local count = resolveHerbCount(herbs, plantCfg, herbName)
            local stealState = plant.cfg.canSteal and '可偷' or '不可偷'
            local text = string.format('%s：%s｜%s', herbName, formatNumber(count), stealState)
            local rowLabel = GUI:Text_Create(panel, 'inventory_herb_' .. idx, -170, rowY, 18, colors.primary, text)
            GUI:setAnchorPoint(rowLabel, 0, 0.5)
            GUI:Text_enableOutline(rowLabel, '#1d0f09', 1)
        end
    end
end

local function drawQuickActions(node, snapshot, npcid, selfSnapshot)
    local panel = GUI:Node_Create(node, 'quick_panel', layout.quick.x, layout.quick.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'quick_title', 0, 70, 20, colors.primary, '偷菜 / 点赞入口')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local state = ensureState()
    local guestMode = isGuestMode()
    local baseSnapshot = selfSnapshot or snapshot
    local basePlayer = (baseSnapshot and baseSnapshot.player) or {}
    local stealCfg = baseSnapshot.cfg and baseSnapshot.cfg.steal or {}
    local likeCfg = baseSnapshot.cfg and baseSnapshot.cfg.like or {}
    local daily = (basePlayer.steal and basePlayer.steal.daily) or {}
    local stealLimit = stealCfg.dailyStealLimit or 0
    local stealUsed = daily.count or 0
    local remain = math.max(0, stealLimit - stealUsed)
    local stealTip = string.format('今日还可偷 %s 次（上限 %s 次 / 目标最多 %s 次）', formatNumber(remain), formatNumber(stealLimit), formatNumber(stealCfg.perTargetDailyLimit or 0))
    local likeTip = string.format('点赞每日对同一目标 %s 次，每次赠送 +%s 仙华', formatNumber(likeCfg.dailyLikePerTarget or 0), formatNumber(likeCfg.likeValue or 0))

    local targetName
    local gridIdInput = nil
    local function clampGrid(value)
        local gridSize = npc._config.gridSize or 9
        value = math.max(1, math.min(gridSize, value))
        state.remoteGridId = value
        return value
    end

    if guestMode then
        targetName = getGuestTargetName()
        NPC_UI_HELPER.createRichText(panel, 'quick_guest_label', -170, 30, string.format('当前拜访：%s', targetName ~= '' and targetName or '未知'), {width = 360, height = 20, anchor = {x = 0, y = 0.5}, color = colors.detail})
    else
        local inputBg = GUI:Image_Create(panel, 'quick_input_bg', -120, 30, 'res/public/1900000656.png')
        GUI:setAnchorPoint(inputBg, 0, 0.5)
        GUI:setContentSize(inputBg, 200, 36)
        local input = GUI:TextInput_Create(inputBg, 'quick_input', 100, 18, 190, 30, 18)
        GUI:setAnchorPoint(input, 0.5, 0.5)
        GUI:TextInput_setPlaceHolder(input, '输入目标名字')
        GUI:TextInput_setString(input, state.friendKey or '')
        GUI:TextInput_addOnEvent(input, function(_, eventType)
            if eventType == 1 then
                local textValue = GUI:TextInput_getString(input)
                state.friendKey = textValue or ''
            end
        end)
        local gridBg = GUI:Image_Create(panel, 'quick_grid_bg', 90, 30, 'res/public/1900000656.png')
        GUI:setAnchorPoint(gridBg, 0, 0.5)
        GUI:setContentSize(gridBg, 80, 36)
        gridIdInput = GUI:TextInput_Create(gridBg, 'quick_grid_input', 40, 18, 70, 30, 18)
        GUI:setAnchorPoint(gridIdInput, 0.5, 0.5)
        GUI:TextInput_setPlaceHolder(gridIdInput, '地块')
        GUI:TextInput_setString(gridIdInput, tostring(state.remoteGridId or 1))
        GUI:TextInput_addOnEvent(gridIdInput, function(_, eventType)
            if eventType == 1 then
                local num = tonumber(GUI:TextInput_getString(gridIdInput)) or 1
                num = clampGrid(num)
                GUI:TextInput_setString(gridIdInput, tostring(num))
            end
        end)

        local function ensureTarget(actionName, needGrid)
            local key = GUI:TextInput_getString(input) or ''
            if key == '' then
                state.lastMessage = '请输入目标名字后再尝试' .. actionName
                state.lastActionOk = false
                npc.render()
                return nil
            end
            state.friendKey = key
            local grid = state.remoteGridId or 1
            if needGrid then
                local gridStr = GUI:TextInput_getString(gridIdInput)
                grid = clampGrid(tonumber(gridStr) or grid)
                GUI:TextInput_setString(gridIdInput, tostring(grid))
            end
            return key, grid
        end

        NPC_UI_HELPER.createPrimaryButton(panel, 'quick_visit', 140, 30, '拜访', function()
            local key = ensureTarget('拜访', false)
            if key then
                sendAction(npcid, 'visit', {targetName = key})
            end
        end)
        NPC_UI_HELPER.createPrimaryButton(panel, 'quick_like', 210, 30, '点赞', function()
            local key = ensureTarget('点赞', false)
            if key then
                sendAction(npcid, 'like', {targetName = key})
            end
        end)
        NPC_UI_HELPER.createPrimaryButton(panel, 'quick_steal', 280, 30, '偷菜', function()
            local key, grid = ensureTarget('偷菜', true)
            if key and grid then
                sendAction(npcid, 'steal', {targetName = key, gridId = grid})
            end
        end)
    end

    if guestMode then
        local function ensureGuestGrid(actionName)
            local gridId = state.selectedPlot or 1
            local fields = (snapshot.player or {}).fields or {}
            local plot = fields[gridId]
            if not canPlotBeStolen(plot) then
                state.lastMessage = actionName .. '前请先选中可偷的成熟灵草'
                npc.render()
                return nil
            end
            return gridId
        end
        local function sendGuest(action, needGrid)
            targetName = getGuestTargetName()
            if not targetName or targetName == '' then
                state.lastMessage = '拜访对象无效，请返回自宅后重试'
                npc.render()
                return
            end
            local gridId
            if needGrid then
                gridId = ensureGuestGrid('偷菜')
                if not gridId then
                    return
                end
            end
            local payload = {targetName = targetName}
            if gridId then
                payload.gridId = gridId
            end
            sendAction(npcid, action, payload)
        end
        NPC_UI_HELPER.createPrimaryButton(panel, 'guest_like', 210, 30, '点赞', function()
            sendGuest('like', false)
        end)
        NPC_UI_HELPER.createPrimaryButton(panel, 'guest_steal', 280, 30, '偷菜', function()
            sendGuest('steal', true)
        end)
    end

    NPC_UI_HELPER.createRichText(panel, 'quick_tip_steal', 0, -10, stealTip, {width = 520, height = 18, anchor = {x = 0.5, y = 1}, color = colors.detail})
    NPC_UI_HELPER.createRichText(panel, 'quick_tip_like', 0, -40, likeTip, {width = 520, height = 18, anchor = {x = 0.5, y = 1}, color = colors.detail})
end

local function drawVisitorLog(node, snapshot)
    local panel = GUI:Node_Create(node, 'visitor_panel', layout.visitor.x, layout.visitor.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'visitor_title', 0, 80, 20, colors.primary, '访客石')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local logs = ((snapshot.player or {}).visitor or {}).log or {}
    local lines = {}
    local actionLabel = {like = '点赞', steal = '偷菜', visit = '拜访'}
    for index, entry in ipairs(logs) do
        if index > 6 then
            break
        end
        local timeText = os.date('%H:%M', (entry.time or 0))
        local actionText = actionLabel[entry.action] or (entry.action or '')
        local detail = entry.detail or ''
        lines[#lines + 1] = string.format('[%s] %s %s %s', timeText, entry.from or '??', actionText, detail)
    end
    if #lines == 0 then
        lines[1] = '暂无访客记录'
    end
    local content = table.concat(lines, '\n') .. '\n最多保留30条，自动滚动。'
    NPC_UI_HELPER.createRichText(panel, 'visitor_text', 0, 40, content, {width = 520, height = 20, anchor = {x = 0.5, y = 1}, color = colors.primary})
end

local shopTabs = {
    {id = 'seeds', label = '种子'},
    {id = 'eggs', label = '灵蛋'},
    {id = 'materials', label = '材料'},
    {id = 'decorate', label = '装扮'},
}

-- ===== 商城与装扮 =====
local function drawShop(node, snapshot, npcid)
    local panel = GUI:Node_Create(node, 'shop_panel', layout.shop.x, layout.shop.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'shop_title', 0, 120, 20, colors.primary, '商城 / 装扮')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    if isGuestMode() then
        NPC_UI_HELPER.createRichText(panel, 'shop_guest_tip', 0, 60, '拜访模式不可进入商城，请返回自宅后再试。', {width = 360, height = 40, anchor = {x = 0.5, y = 1}, color = colors.warning})
        return
    end
    local state = ensureState()
    for idx, tab in ipairs(shopTabs) do
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'shop_tab_' .. tab.id, -150 + (idx - 1) * 100, 90, tab.label, function()
            state.shopTab = tab.id
            npc.render()
        end)
        GUI:Button_setBright(btn, state.shopTab ~= tab.id)
    end

    local rows = {}
    local cfg = snapshot.cfg or {}
    local player = snapshot.player or {}
    local tabId = state.shopTab
    if tabId == 'seeds' then
        for _, entry in ipairs(cfg.shop and cfg.shop.seeds or {}) do
            local plant = (cfg.plant or {})[entry.seed]
            local canSteal = plant and plant.canSteal and '可偷' or '不可偷'
            local reward = summarizeProduct(plant and plant.product)
            local desc = string.format('成熟：%s｜奖励：%s｜%s', formatSeconds((plant and plant.matureTime) or 0), reward ~= '' and reward or '—', canSteal)
            rows[#rows + 1] = {
                name = entry.name,
                desc = string.format('%s｜价格：%s', desc, formatCost(entry.cost)),
                button = '购买',
                callback = function()
                    sendAction(npcid, 'buySeed', {id = entry.id, amount = 1})
                end,
            }
        end
    elseif tabId == 'eggs' then
        for _, entry in ipairs(cfg.shop and cfg.shop.eggs or {}) do
            local eggCfg = (cfg.pet and cfg.pet.eggs) and cfg.pet.eggs[entry.id]
            local beast = eggCfg and eggCfg.beast or {}
            local desc = string.format('灵兽：%s｜上限：%s级｜价格：%s', beast.type or '--', formatNumber(beast.maxLevel or 1), formatCost(entry.cost))
            rows[#rows + 1] = {
                name = entry.name,
                desc = desc,
                button = '购买',
                callback = function()
                    sendAction(npcid, 'buyEgg', {id = entry.id, amount = 1})
                end,
            }
        end
    elseif tabId == 'materials' then
        for _, entry in ipairs(cfg.shop and cfg.shop.materials or {}) do
            local desc = string.format('宠物养成材料｜价格：%s', formatCost(entry.cost))
            rows[#rows + 1] = {
                name = entry.name,
                desc = desc,
                button = '购买',
                callback = function()
                    sendAction(npcid, 'buyMaterial', {id = entry.id, amount = 1})
                end,
            }
        end
    elseif tabId == 'decorate' then
        local owned = ((player.decoration or {}).owned) or {}
        local equipped = (player.decoration or {}).equipped
        for _, entry in ipairs(safePairs(cfg.decorate or {})) do
            local own = owned[entry.id]
            local status
            local button
            local callback
            if own then
                if equipped == entry.id then
                    status = '已佩戴'
                else
                    button = '佩戴'
                    callback = function()
                        sendAction(npcid, 'equipDecoration', {decoId = entry.id})
                    end
                end
            else
                button = '购买'
                callback = function()
                    sendAction(npcid, 'buyDecoration', {decoId = entry.id})
                end
            end
            rows[#rows + 1] = {
                name = string.format('%s（+%s仙华）', entry.name, formatNumber(entry.xiangHua or 0)),
                desc = string.format('价格：%s｜%s', formatCost(entry.cost), status or '装扮可永久增加仙华（装备时生效）'),
                button = button,
                status = status,
                callback = callback,
            }
        end
    end

    local startY = 60
    for idx, row in ipairs(rows) do
        local y = startY - (idx - 1) * 30
        local nameLabel = GUI:Text_Create(panel, 'shop_row_name_' .. idx, -150, y, 18, colors.primary, row.name or '')
        GUI:setAnchorPoint(nameLabel, 0, 0.5)
        GUI:Text_enableOutline(nameLabel, '#1d0f09', 1)
        local descLabel = GUI:Text_Create(panel, 'shop_row_desc_' .. idx, -150, y - 16, 16, colors.detail, row.desc or '')
        GUI:setAnchorPoint(descLabel, 0, 0.5)
        GUI:Text_enableOutline(descLabel, '#0d1b26', 1)
        if row.button and row.callback then
            local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'shop_btn_' .. idx, 140, y - 8, row.button, row.callback)
            GUI:setAnchorPoint(btn, 0, 0.5)
        elseif row.status then
            local statusLabel = GUI:Text_Create(panel, 'shop_status_' .. idx, 140, y - 8, 16, colors.warning, row.status)
            GUI:setAnchorPoint(statusLabel, 0, 0.5)
        end
    end

    NPC_UI_HELPER.createRichText(panel, 'shop_tip', 0, -80, '装扮可永久增加仙华值（装备时生效）', {width = 360, height = 18, anchor = {x = 0.5, y = 1}, color = colors.warning})
end

-- 炼丹模块，展示配方/冷却。
local function drawRefine(node, snapshot, npcid)
    local panel = GUI:Node_Create(node, 'refine_panel', layout.refine.x, layout.refine.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'refine_title', 0, 80, 20, colors.primary, '炼丹炉')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    if isGuestMode() then
        NPC_UI_HELPER.createRichText(panel, 'refine_guest_tip', 0, 40, '拜访模式不可使用炼丹炉，请回到自宅。', {width = 360, height = 40, anchor = {x = 0.5, y = 1}, color = colors.warning})
        return
    end
    local cfg = snapshot.cfg or {}
    local recipes = cfg.refine and cfg.refine.recipes or {}
    local player = snapshot.player or {}
    local herbs = player.herbs or {}
    local plantCfg = cfg.plant or {}
    local lastTime = (player.refine or {}).lastTime or 0
    local cd = (cfg.refine and cfg.refine.furnaceCd) or 0
    local remainCd = math.max(0, (lastTime + cd) - serverNow())
    local ready = remainCd <= 0
    local rowIndex = 0
    for name, recipe in pairs(recipes) do
        rowIndex = rowIndex + 1
        local y = 50 - (rowIndex - 1) * 40
        local costHerb = formatCost(recipe.costHerb)
        local costCurrency = formatCost(recipe.costCurrency)
        local desc = string.format('%s｜灵草：%s｜货币：%s｜效果：%s', name, costHerb, costCurrency, formatAddValue(recipe.addValue))
        NPC_UI_HELPER.createRichText(panel, 'refine_row_' .. rowIndex, -150, y, desc, {width = 360, height = 36, anchor = {x = 0, y = 0.5}, color = colors.primary})
        local hasHerb = true
        if type(recipe.costHerb) == 'table' then
            for _, entry in pairs(recipe.costHerb) do
                if type(entry) == 'table' then
                    local herbName = entry[1]
                    local need = entry[2] or 0
                    if resolveHerbCount(herbs, plantCfg, herbName) < need then
                        hasHerb = false
                        break
                    end
                elseif type(entry) == 'string' then
                    if resolveHerbCount(herbs, plantCfg, entry) <= 0 then
                        hasHerb = false
                        break
                    end
                end
            end
        end
        local btnText = ready and '炼制' or string.format('冷却 %s', formatSeconds(remainCd))
        local enabled = ready and hasHerb
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'refine_btn_' .. rowIndex, 150, y, btnText, function()
            sendAction(npcid, 'refine', {recipeId = name})
        end)
        GUI:setAnchorPoint(btn, 0, 0.5)
        if not enabled then
            GUI:Button_setBright(btn, false)
        end
    end
    local tip = '集齐全部丹方自动授予称号「极品炼丹师」'
    NPC_UI_HELPER.createRichText(panel, 'refine_tip', 0, -40, tip, {width = 360, height = 30, anchor = {x = 0.5, y = 1}, color = colors.warning})
end

local function drawPet(node, snapshot, npcid)
    local panel = GUI:Node_Create(node, 'pet_panel', layout.pet.x, layout.pet.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'pet_title', 0, 100, 20, colors.primary, '灵兽成长')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    if isGuestMode() then
        NPC_UI_HELPER.createRichText(panel, 'pet_guest_tip', 0, 60, '拜访模式不可操作灵兽，请返回自宅。', {width = 360, height = 40, anchor = {x = 0.5, y = 1}, color = colors.warning})
        return
    end
    local player = snapshot.player or {}
    local pet = player.pet or {}
    local beasts = pet.beasts or {}
    local materials = pet.materials or {}
    local eggs = pet.eggs or {}
    local cfg = snapshot.cfg or {}
    local feedCfg = cfg.pet and cfg.pet.feed or {}
    local idx = 0
    for petId, beast in pairs(beasts) do
        idx = idx + 1
        local y = 60 - (idx - 1) * 30
        local expNeed = (beast.level or 1) * 10
        local progress = string.format('%s/%s', formatNumber(beast.exp or 0), formatNumber(expNeed))
        local line = string.format('%s Lv.%s｜经验：%s', petId, formatNumber(beast.level or 1), progress)
        local label = GUI:Text_Create(panel, 'pet_row_' .. petId, -150, y, 18, colors.primary, line)
        GUI:setAnchorPoint(label, 0, 0.5)
        GUI:Text_enableOutline(label, '#1d0f09', 1)
        NPC_UI_HELPER.createPrimaryButton(panel, 'pet_feed_' .. petId, 150, y, '喂养', function()
            sendAction(npcid, 'feed', {petId = petId, amount = 1})
        end)
        NPC_UI_HELPER.createPrimaryButton(panel, 'pet_identify_' .. petId, 210, y, '鉴定', function()
            sendAction(npcid, 'identify', {petId = petId})
        end)
    end
    local eggLine = 60 - idx * 30
    for eggId, count in pairs(eggs) do
        local line = string.format('灵蛋 %s x%s', eggId, formatNumber(count))
        local label = GUI:Text_Create(panel, 'pet_egg_' .. eggId, -150, eggLine, 16, colors.detail, line)
        GUI:setAnchorPoint(label, 0, 0.5)
        NPC_UI_HELPER.createPrimaryButton(panel, 'pet_hatch_' .. eggId, 150, eggLine, '孵化', function()
            sendAction(npcid, 'hatch', {eggId = eggId})
        end)
        eggLine = eggLine - 26
    end
    local matText = string.format('材料：精魄 x%s｜每次喂养消耗 %s， +%s 经验', formatNumber(materials[feedCfg.resource or 'essence'] or 0), formatNumber(feedCfg.perFeed or 0), formatNumber(feedCfg.exp or 0))
    NPC_UI_HELPER.createRichText(panel, 'pet_material', 0, -40, matText, {width = 360, height = 18, anchor = {x = 0.5, y = 1}, color = colors.primary})
    NPC_UI_HELPER.createRichText(panel, 'pet_tip', 0, -70, '完成所有灵兽图鉴获得「极品御兽师」', {width = 360, height = 18, anchor = {x = 0.5, y = 1}, color = colors.warning})
end

-- 排行榜卡片。
local function drawRank(node, snapshot)
    local panel = GUI:Node_Create(node, 'rank_panel', layout.rank.x, layout.rank.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'rank_title', 0, 60, 20, colors.primary, '排行卡片')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local list = snapshot.rank or {}
    if #list == 0 then
        GUI:Text_Create(panel, 'rank_empty', 0, 20, 18, colors.muted, '暂无排行数据')
        return
    end
    for i, entry in ipairs(list) do
        if i > 5 then
            break
        end
        local y = 40 - (i - 1) * 22
        local line = string.format('%d. %s  %s', i, entry.name or '--', formatNumber(entry.value or 0))
        local color = (i == 1) and colors.warning or colors.primary
        local label = GUI:Text_Create(panel, 'rank_row_' .. i, -100, y, 18, color, line)
        GUI:setAnchorPoint(label, 0, 0.5)
        GUI:Text_enableOutline(label, '#1d0f09', 1)
    end
    NPC_UI_HELPER.createRichText(panel, 'rank_tip', 0, -10, '每日0点结算昨日排行并发放称号', {width = 320, height = 18, anchor = {x = 0.5, y = 1}, color = colors.detail})
end

-- 系统提示区域（服务器信息 + 策划文案）。
local function drawSystemMessages(node, snapshot)
    local panel = GUI:Node_Create(node, 'system_panel', layout.system.x, layout.system.y)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    local title = GUI:Text_Create(panel, 'system_title', 0, 40, 20, colors.primary, '系统提示')
    GUI:setAnchorPoint(title, 0.5, 0)
    GUI:Text_enableOutline(title, '#1d0f09', 1)
    local state = ensureState()
    local base = {
        string.format('服务器提示：%s', state.lastMessage ~= '' and state.lastMessage or '准备就绪'),
        '所有消耗以配置表 cost 为准，按钮旁提示具体材料/货币名称。',
        '尚未开启剧情请先完成 NPC55 相关任务。',
        '点击拜访可查看对方菜园、访客记录和点赞/偷菜入口。',
    }
    local stealDaily = ((snapshot.player or {}).steal or {}).daily or {}
    local likeGiven = ((snapshot.player or {}).likes or {}).given or {}
    local stealInfo = string.format('今日偷菜 %s/%s 次', formatNumber(stealDaily.count or 0), formatNumber(((snapshot.cfg or {}).steal or {}).dailyStealLimit or 0))
    base[#base + 1] = stealInfo
    local likeInfo = string.format('累计点赞次数：%s', formatNumber(countTableSize(likeGiven)))
    base[#base + 1] = likeInfo
    local content = table.concat(base, '\n')
    NPC_UI_HELPER.createRichText(panel, 'system_text', 0, 10, content, {width = 520, height = 20, anchor = {x = 0.5, y = 1}, color = colors.primary})
end

-- 根据菜单标签渲染对应模块，默认 overview 为常用组合。
local function renderSection(tab, snapshot, baseSnapshot, npcid)
    local guestMode = isGuestMode()
    local permission = MENU_PERMISSIONS[guestMode and 'guest' or 'self'] or {}
    if guestMode and not permission[tab] and tab ~= 'overview' then
        NPC_UI_HELPER.createRichText(npc.node, 'guest_block_tip', 0, -40, '拜访模式仅开放菜园与社交功能', {width = 520, height = 30, anchor = {x = 0.5, y = 0}, color = colors.warning})
        return
    end
    if tab == 'farm' then
        drawPlotCells(npc.node, snapshot)
        drawPlotDetail(npc.node, snapshot, npcid)
    elseif tab == 'inventory' then
        drawInventory(npc.node, snapshot, npcid)
    elseif tab == 'social' then
        drawQuickActions(npc.node, snapshot, npcid, baseSnapshot)
        drawVisitorLog(npc.node, snapshot)
    elseif tab == 'shop' then
        drawShop(npc.node, snapshot, npcid)
    elseif tab == 'refine' then
        drawRefine(npc.node, snapshot, npcid)
    elseif tab == 'pet' then
        drawPet(npc.node, snapshot, npcid)
    elseif tab == 'rank' then
        drawRank(npc.node, snapshot)
    elseif tab == 'system' then
        drawSystemMessages(npc.node, snapshot)
    else
        if guestMode then
            renderSection('farm', snapshot, baseSnapshot, npcid)
        else
            drawInventory(npc.node, snapshot, npcid)
            drawQuickActions(npc.node, snapshot, npcid, baseSnapshot)
            drawVisitorLog(npc.node, snapshot)
            drawRank(npc.node, snapshot)
            drawSystemMessages(npc.node, snapshot)
        end
    end
end

-- 主渲染：顶部概览 + 菜单 + 当前模块。
function npc.render()
    if not npc.node then
        return
    end
    GUI:removeAllChildren(npc.node)
    local baseSnapshot = getSnapshot()
    if not baseSnapshot.player then
        local label = GUI:Text_Create(npc.node, 'loading', 0, 0, 20, colors.primary, '正在同步仙府数据...')
        GUI:setAnchorPoint(label, 0.5, 0.5)
        return
    end
    local displaySnapshot = getActiveSnapshot()
    local state = ensureState()
    local npcid = state.npcid
    local guestMode = isGuestMode()
    local permission = MENU_PERMISSIONS[guestMode and 'guest' or 'self'] or {}
    local currentTab = state.menuTab or 'overview'
    if not permission[currentTab] then
        state.menuTab = guestMode and 'farm' or 'overview'
    end
    buildTopOverview(npc.node, displaySnapshot, baseSnapshot)
    drawMenuBar(npc.node)
    renderSection(state.menuTab or 'overview', displaySnapshot, baseSnapshot, npcid)
end

-- 处理首次进入 NPC 的快照。
local function handleInitial(msgData)
    local data = parseJson(msgData)
    updateSnapshot(data)
    exitGuestMode()
    npc.render()
end

-- 处理服务器 action 回执。
local function handleAction(npcid, msgData)
    local payload = parseJson(msgData)
    if not payload then
        return
    end
    local state = ensureState()
    state.lastMessage = payload.message or ''
    state.lastActionOk = payload.ok and true or false
    if payload.state then
        updateSnapshot(payload.state)
    end
    local extra = payload.extra
    if extra and extra.visitMode and extra.target then
        enterGuestMode(extra.target)
    elseif not extra and payload.action == 'sync' then
        exitGuestMode()
    end
    npc.render()
end

-- NPC 入口：注册窗口并分发消息。
function npc.main(npcid, p2, p3, msgData)
    ensureState().npcid = npcid
    ensureWindow(npcid)
    if p2 == 0 then
        handleInitial(msgData)
    else
        handleAction(npcid, msgData)
    end
end

return npc
