
--[[
NPC 44 (仙府玩法) 客户端界面；负责渲染 UI、同步服务器状态、发送操作。
结构：配置/布局 -> 状态与工具 -> 功能模块渲染 -> 菜单调度 -> NPC 入口。
]]

local npc = {}

-- 策划下发的玩法配置（PlantCfg/ShopCfg/...），用于驱动前端数据。
npc._config = teshudata["npc_44"] or {}

-- NPC 窗口的皮肤/关闭按钮等基础参数。

-- 用于定位各个功能模块的锚点与尺寸，方便统一排版。
local layout = {
    top = {x = 0, y = 250},
    farm = {x = -360, y = 160, size = 120, gap = 8, perRow = 3},
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
    {idx = 1,id = 'social', label = '社交互动'},
    {idx = 4,id = 'shop', label = '商城装扮'},
    {idx = 4,id = 'refine', label = '炼丹炉'},
    {idx = 7,id = 'pet', label = '灵兽培养'},
    {id = 'rank', label = '排行称号'},
    {id = 'system', label = '系统提示'},
    {idx = 2,id = 'shape', label = '装扮'},
}
local MENU_TABS_LIST = {
    [1] = {4,5,10},
    [2] = {6,7},
}

-- UI 文本及按钮常用配色，集中管理方便整体调色。

local MENU_PERMISSIONS = {
    self = {overview = true, farm = true, inventory = true, social = true, shop = true, refine = true, pet = true, rank = true, system = true, shape = true},
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
    if herbName == '仙草' and herbs.Low ~= nil then
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
    local name = cfg and cfg.name or (plot.seedId == 'High' and '高阶灵草' or (plot.seedId == 'Low' and '仙草' or '未播种'))
    local now = serverNow()
    if stateName == 'growing' then
        local remain = math.max(0, (plot.finishAt or now) - now)
        -- return string.format('成长中\n%s', formatSeconds(remain)), cfg and cfg.canSteal and '可被偷' or '安全'
        return string.format('成长中\n%s', formatSeconds(remain)), ""
    elseif stateName == 'mature' then
        local reward = summarizeProduct(plot.product)
        -- local tips = (cfg and cfg.canSteal) and '未收获可被偷' or '不可被偷'
        local tips = ""
        local statusText = '可收获'
        if reward ~= '' then
            -- statusText = statusText .. '\n' .. reward
            statusText = ""
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
    local parent = GUI:GetWindow(nil, "npc_44")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_44", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
    end

    local bjt = GUI:Image_Create(parent, 'bjt', 0, 0, "res/custom/three_city/xianfu/bg.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w, cogin.h)
    GUI:setTouchEnabled(bjt, true)
    GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})
    npc.bg = bjt
    npc.node = GUI:Node_Create(bjt, 'node', cogin.w / 2, cogin.h / 2)

    local closeBtn = GUI:Button_Create(npc.bg, 'close', cogin.w-100, cogin.h-150, 'res/wy/public/anniu_4_x_close.png')
    GUI:setLocalZOrder(closeBtn, 100)
    GUI:addOnClickEvent(closeBtn, function()
        GUI:Win_Close(parent)
    end)

end

-- 顶部概览：玩家昵称/仙华/排行提示。
local function buildTopOverview(node, snapshot, baseSnapshot, npcid)

    local state = ensureState()
    local guestMode = isGuestMode()
    local player = snapshot.player or {}
    local rankList = (snapshot.rank and #snapshot.rank > 0) and snapshot.rank or ((baseSnapshot and baseSnapshot.rank) or {})

    local d_2 = GUI:Image_Create(node, 'd_2', 0, cogin.h / 2 - 40, "res/custom/three_city/xianfu/d_2.png")
    GUI:setAnchorPoint(d_2, 0.5, 1)


    local top_img = GUI:Image_Create(node, 'top_img', cogin.w / 2, cogin.h / 2, "res/custom/three_city/xianfu/d_4.png")
    GUI:setAnchorPoint(top_img, 1, 1)
    GUI:setContentSize(top_img, cogin.w, GUI:getContentSize(top_img).height)

    local wz1 = GUI:Image_Create(top_img, 'wz1', cogin.w - 500, 10, "res/custom/three_city/xianfu/wz1.png")
    local wz2 = GUI:Image_Create(top_img, 'wz2', cogin.w - 300, 10, "res/custom/three_city/xianfu/wz2.png")


    local titleFmt = guestMode and '拜访：%s' or '仙府主：%s'
    local topText = string.format(titleFmt, player.name)
    local label = GUI:Text_Create(top_img, 'top_main', 20, 15, 22, colors.primary, topText)
    GUI:setAnchorPoint(label, 0, 0)
    GUI:Text_enableOutline(label, '#1d0f09', 2)

    local xiangHua = GUI:TextAtlas_Create(wz1, "xiangHua", 120, 3, tonumber(player.xiangHua or 0), "res/custom/public/text1.png", 14, 30, ".")

    local likenum = GUI:TextAtlas_Create(wz2, "likenum", 120, 3, tonumber(player.likenum or 0), "res/custom/public/text1.png", 14, 30, ".")


    --SL:dump(player,"playerdata")


    -- local tip = guestMode and '拜访模式仅开放菜园与社交功能，其余操作需返回自宅。' or '仙华值通过点赞、装扮、炼丹等玩法提升，今日排名实时更新。'
    -- local tipLabel = GUI:Text_Create(summary, 'top_tip', 0, -26, 18, colors.detail, tip)
    -- GUI:setAnchorPoint(tipLabel, 0.5, 0)
    -- GUI:Text_enableOutline(tipLabel, '#0c1a22', 1)
    -- local rankN = math.min(#rankList, (npc._config.RankCfg and npc._config.RankCfg.topN) or #rankList)
    -- local parts = {}
    -- for i = 1, math.min(rankN, 5) do
    --     local entry = rankList[i]
    --     parts[#parts + 1] = string.format('%d.%s(%s)', i, entry and entry.name or '--', entry and formatNumber(entry.value or 0) or '0')
    -- end
    -- local rankText = (#parts > 0) and table.concat(parts, '  ') or '暂无排行数据'
    -- local rankLabel = GUI:Text_Create(summary, 'top_rank', 0, -52, 18, colors.accent, string.format('今日排行 Top %d：%s', math.max(rankN, 1), rankText))
    -- GUI:setAnchorPoint(rankLabel, 0.5, 0)
    -- GUI:Text_enableOutline(rankLabel, '#0d1b26', 1)
    -- local titleCfg = npc._config.TitleCfg or {}
    -- local rankTitle = titleCfg.XianHuaRank1 and titleCfg.XianHuaRank1.name or '荣华天下'
    -- local rewardTip = string.format('今日第一可获得称号「%s」（当天有效）', rankTitle)
    -- local rewardLabel = GUI:Text_Create(summary, 'top_reward', 0, -76, 18, colors.warning, rewardTip)
    -- GUI:setAnchorPoint(rewardLabel, 0.5, 0)
    -- GUI:Text_enableOutline(rewardLabel, '#1b0f07', 1)
    if guestMode then
    --返回自宅
        NPC_UI_HELPER.createPrimaryButton(top_img, 'btn_exit_guest', cogin.w - 260, -200, '', function()
            exitGuestMode()
            npc.render()
        end,{skin = "res/custom/three_city/xianfu/btn/l/3.png"})

        NPC_UI_HELPER.createPrimaryButton(top_img, 'btn_like_guest', cogin.w - 400, -200, '', function()
            sendAction(npcid, 'like', {targetName = player.name})
        end,{skin = "res/custom/three_city/xianfu/btn/l/2.png"})
    end
end

local function drawMenuBar(node)

    local under_img = GUI:Image_Create(node, 'under_img', cogin.w / 2,  - cogin.h / 2, "res/custom/three_city/xianfu/d_3.png")
    GUI:setAnchorPoint(under_img, 1, 0)
    GUI:setContentSize(under_img, cogin.w, GUI:getContentSize(under_img).height)

    local btn_list_img = GUI:Image_Create(under_img, 'btn_list_img', cogin.w / 2,  10, "res/custom/three_city/xianfu/d_1.png")
    GUI:setAnchorPoint(btn_list_img, 0.5, 0)

    local bar = GUI:Node_Create(node, 'menu_bar', layout.menu.x, layout.menu.y)
    GUI:setAnchorPoint(bar, 0.5, 0.5)
    local state = ensureState()
    local permission = MENU_PERMISSIONS[isGuestMode() and 'guest' or 'self'] or {}
    local total = #MENU_TABS
    local startX = -((total - 1) * 70)
    -- for idx, tab in ipairs(MENU_TABS) do
    --     local x = startX 
    --     local allowed = permission[tab.id]
    --     local btn = NPC_UI_HELPER.createPrimaryButton(bar, 'menu_btn_x' .. tab.id, x, - (idx - 1) * 50, tab.label, function()
    --         local s = ensureState()
    --         if not allowed then
    --             s.lastMessage = '拜访模式仅开放菜园与社交功能'
    --             npc.render()
    --             return
    --         end
    --         if s.menuTab ~= tab.id then
    --             s.menuTab = tab.id
    --             npc.render()
    --         end
    --     end)
    --     GUI:setAnchorPoint(btn, 0.5, 0.5)
    --     if allowed then
    --         GUI:Button_setBright(btn, state.menuTab ~= tab.id)
    --     else
    --         GUI:Button_setBright(btn, false)
    --     end
    -- end

    for idx, k in ipairs(MENU_TABS_LIST[1]) do
        local tab = MENU_TABS[k]
        local x = startX 
        local allowed = permission[tab.id]
        local btn = NPC_UI_HELPER.createPrimaryButton(node, 'menu_btn_' .. tab.id, cogin.w / 2 + 10, - (idx - 1) * 100 + 150, "", function()
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
        end,{skin = "res/custom/three_city/xianfu/list/l/"..tab.idx..".png",Disabled_skin = "res/custom/three_city/xianfu/list/n/"..tab.idx..".png"})
        GUI:setAnchorPoint(btn, 1, 0)
        if allowed then
            GUI:Button_setBright(btn, state.menuTab ~= tab.id)
        else
            GUI:Button_setBright(btn, false)
        end
    end

    for idx, k in ipairs(MENU_TABS_LIST[2]) do
        local tab = MENU_TABS[k]
        local x = startX 
        local allowed = permission[tab.id]
        local btn = NPC_UI_HELPER.createPrimaryButton(btn_list_img, 'menux_btn_' .. tab.id, 560 + (idx - 1) * 150, -10, "", function()

            if tab.id == "pet" then
                SL:SendLuaNetMsg(105, 64, 64, 0, '')
                return
            end
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
        end,{skin = "res/custom/three_city/xianfu/btn/l/"..tab.idx..".png",Disabled_skin = "res/custom/three_city/xianfu/btn/n/"..tab.idx..".png"})
        GUI:setAnchorPoint(btn, 0.5, 0)
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
    local origin = GUI:Node_Create(node, 'farm_grid', 0, 0)
    GUI:setAnchorPoint(origin, 0.5, 0.5)

    local Pos = {
        {0,90,0.35,-15,-15,-18},
        {-120,45,0.37,-10,-10,-14},
        {120,45,0.4,-14,-10,-14},
        {-240,0,0.4,-10,-10,-14},
        {0,0,0.4,-10,-10,-14},
        {240,0,0.4,-10,-10,-14},
        {-120,-45,0.4,0,0,-14},
        {120,-45,0.4,4,-5,-14},
        {0,-90,0.4,4,4,-14},
    }



    -- local title = GUI:Text_Create(origin, 'farm_title', 0, cellSize + 40, 20, colors.primary, '菜园九宫格')
    -- GUI:Text_enableOutline(title, '#1d0f09', 1)
    local state = ensureState()
    for i = 1, gridSize do
        local row = math.floor((i - 1) / perRow)
        local col = (i - 1) % perRow
        local x = (col - 1) * (cellSize + gap)
        local y = -(row) * (cellSize + gap)
        local itme = GUI:Node_Create(origin, 'itme'.. i, Pos[i][1], Pos[i][2] - 50)

        local plot_img = GUI:Image_Create(itme, "plot_img", 0, 0, "res/custom/three_city/xianfu/plot/p_"..i.."/k_2.png")
        GUI:setAnchorPoint(plot_img, 0.5, 0.5)

        local Layout = GUI:Layout_Create(itme, "Layout"..i, 0, 0, 100, 100)
        GUI:setAnchorPoint(Layout, 0.5, 0.5)

        
        

        local btn = GUI:Button_Create(Layout, 'plot_btn_' .. i, 50, 50 + (Pos[i][6] or 0), 'res/public/0.png')
        GUI:setRotation(btn,45)
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:setContentSize(btn, cellSize + Pos[i][4], cellSize + Pos[i][5] + Pos[i][5])

        GUI:setScaleY(Layout, Pos[i][3])

        GUI:addOnClickEvent(btn, function()
            local s = ensureState()
            s.selectedPlot = i
            npc.render()
        end)


        local plot = fields[i] or {state = 'empty', gridId = i}
        local status, tip = describePlot(plot)
        local content = string.format('<font size="16" color="#9fe9ff">%s</font><br/><font size="14" color="#c8ffb4">%s</font>', status, tip)

        local stateName = plot.state or 'empty'
        local cfg = getPlantCfg(plot.seedId)
        local name = cfg and cfg.name or (plot.seedId == 'High' and '高阶灵草' or (plot.seedId == 'Low' and '仙草' or '未播种'))
        local now = serverNow()
        
        if state.selectedPlot == i then
            -- GUI:Button_setBright(btn, false)
            local guang = GUI:Image_Create(btn, "guang", GUI:getContentSize(btn).width/2, GUI:getContentSize(btn).height/2, "res/wy/public/itembg.png")
            GUI:setAnchorPoint(guang, 0.5, 0.5)
            GUI:setContentSize(guang, GUI:getContentSize(btn).width + 70, GUI:getContentSize(btn).height + 70)
        elseif GUI:getChildByName(btn,"guang") then
            -- GUI:Button_setBright(btn, true)
            GUI:removeChildByName(btn, "guang")
        end

        if stateName == 'growing' then
            GUI:setAnchorPoint(GUI:Image_Create(itme, "plot_sl", 0, 0, "res/custom/three_city/xianfu/plot/p_"..i.."/k_1.png")
            , 0.5, 0.5)

            -- local remain = math.max(0, (plot.finishAt or now) - now)
            -- return string.format('成长中\n%s', formatSeconds(remain)), cfg and cfg.canSteal and '可被偷' or '安全'
        elseif stateName == 'mature' then
            if name == '仙草' then
                GUI:setAnchorPoint(GUI:Image_Create(itme, "plot_sl", 0, 0, "res/custom/three_city/xianfu/plot/p_"..i.."/k_3.png")
                , 0.5, 0.5)

            elseif name == '高阶灵草' then
                GUI:setAnchorPoint(GUI:Image_Create(itme, "plot_sl", 0, 0, "res/custom/three_city/xianfu/plot/p_"..i.."/k_4.png")
                , 0.5, 0.5)

            end

            -- local reward = summarizeProduct(plot.product)
            -- local tips = (cfg and cfg.canSteal) and '未收获可被偷' or '不可被偷'
            -- local statusText = '可收获'
            -- if reward ~= '' then
            --     statusText = statusText .. '\n' .. reward
            -- end
            -- return statusText, tips
        elseif stateName == 'empty' then
            -- return '空地', '可播种'
        end
        NPC_UI_HELPER.createRichText(itme, 'plot_text_' .. i, 10, 0, content, {width = cellSize - 10, height = 20, anchor = {x = 0.5, y = 0.5}})

        
    end
end

-- 地块详情 + 播种/收获操作提示。
local function drawPlotDetail(node, snapshot, npcid)
    local state = ensureState()
    local panel = GUI:ui_delegate(GUI:ui_delegate(node).under_img).btn_list_img

    local player = snapshot.player or {}
    local fields = player.fields or {}
    local selected = math.max(1, math.min(state.selectedPlot or 1, npc._config.gridSize or 9))
    local plot = fields[selected] or {state = 'empty', gridId = selected}
    local cfg = getPlantCfg(plot.seedId)
    local plantCfg = snapshot.cfg and snapshot.cfg.plant or {}
    local stealableName, safeName = pickStealTipNames(plantCfg)
    local status, tip = describePlot(plot)
    
    -- local title = GUI:Text_Create(panel, 'farm_detail_title', 0, 0, 20, colors.primary, '地块详情')
    -- GUI:setAnchorPoint(title, 0, 1)
    -- GUI:Text_enableOutline(title, '#1d0f09', 1)
    
    -- local detailText = string.format('地块 %s｜状态：%s｜提示：%s', selected, status, tip)
    -- NPC_UI_HELPER.createRichText(panel, 'farm_detail_text', 0, -28, detailText, {width = 360, height = 40, anchor = {x = 0, y = 1}})
    -- local seedLabel = cfg and cfg.name or (plot.state == 'empty' and '未播种' or '未知种子')
    -- local rewardText = summarizeProduct(plot.product)
    -- local harvestInfo = string.format('作物：%s', seedLabel)
    -- if rewardText ~= '' then
    --     harvestInfo = harvestInfo .. string.format('｜奖励：%s', rewardText)
    -- end
    -- if plot.state == 'growing' and plot.finishAt then
    --     harvestInfo = harvestInfo .. string.format('｜成熟倒计时：%s', formatSeconds((plot.finishAt or 0) - serverNow()))
    -- end
    -- if plot.state == 'mature' then
    --     local theftTip = nil
    --     if cfg then
    --         if cfg.canSteal then
    --             theftTip = string.format('%s成熟后请尽快收取，超时可被偷。', cfg.name or '灵草')
    --         else
    --             theftTip = string.format('%s成熟不可偷，安心收获。', cfg.name or '灵草')
    --         end
    --     elseif stealableName then
    --         theftTip = string.format('%s成熟后请尽快收取，超时可被偷。', stealableName)
    --     end
    --     if theftTip then
    --         harvestInfo = harvestInfo .. '\n' .. theftTip
    --     end
    -- elseif plot.state == 'empty' then
    --     local baseTip
    --     if stealableName and safeName then
    --         baseTip = string.format('%s成熟未收会被偷，%s成熟不可偷。', stealableName, safeName)
    --     elseif stealableName then
    --         baseTip = string.format('%s成熟未收会被偷。', stealableName)
    --     elseif safeName then
    --         baseTip = string.format('%s成熟不可偷。', safeName)
    --     else
    --         baseTip = '请及时收获成熟灵草，避免损失。'
    --     end
    --     harvestInfo = harvestInfo .. '\n' .. baseTip
    -- end
    -- NPC_UI_HELPER.createRichText(panel, 'farm_detail_desc', 0, -64, harvestInfo, {width = 360, height = 60, anchor = {x = 0, y = 1}})

    local guestMode = isGuestMode()
    if guestMode then
        local guestTarget = getGuestTargetName()
        NPC_UI_HELPER.createRichText(panel, 'farm_guest_tip', 0, -100, '拜访模式仅可偷取成熟灵草，无法播种/收获。', {width = 360, height = 40, anchor = {x = 0, y = 1}, color = colors.warning})
        local canSteal = canPlotBeStolen(plot)
        -- '偷取'
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'guest_steal_btn', 245, -10, '', function()
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
        end,{skin = "res/custom/three_city/xianfu/btn/l/6.png",Disabled_skin = "res/custom/three_city/xianfu/btn/n/6.png"})
        GUI:setAnchorPoint(btn, 0.5, 0)
        if not canSteal then
            GUI:Button_setBright(btn, false)
        end
        return
    end

    local buttonY = -10
    local function createActionButton(name, x, text, callback, enabled,opts)
        local btn = NPC_UI_HELPER.createPrimaryButton(panel, name, x, buttonY, text, callback,opts)
        if enabled == false then
            GUI:Button_setBright(btn, false)
        end
        return btn
    end

    if plot.state == 'empty' or true then

        
        local btn_seed = GUI:Button_Create(panel, "btn_seed", 100, buttonY, "res/custom/three_city/xianfu/btn/"..(plot.state == 'empty' and "l" or "n").."/8.png")
        GUI:setAnchorPoint(btn_seed, 0.5, 0)
        if plot.state == 'empty' then
        local seeds = player.seeds or {}
        local shop = (snapshot.cfg and snapshot.cfg.shop) or {}
        local seedList = shop.seeds or {}
        local plantList = buildPlantList(plantCfg)
        local herbs = player.herbs or {}
        local hasAnySeed = false
        for _, entry in ipairs(seedList) do
            if entry and entry.name and (tonumber(SL:GetMetaValue("ITEM_COUNT", entry.name)) or 0) > 0 then
                hasAnySeed = true
                break
            end
        end
        if hasAnySeed then
            NPC_UI_HELPER.redpoint_create(btn_seed)
        end
        GUI:addOnClickEvent(btn_seed, function()
            sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'Low'})
        end)

        


        if #plantList == 0 then
            -- local emptyTip = GUI:Text_Create(btn_seed, 'inventory_herb_empty', -170, y, 18, colors.warning, '暂无灵草配置')
            -- GUI:setAnchorPoint(emptyTip, 0, 0.5)
        else
            for idx, entry in ipairs(seedList) do
                local desc = GUI:Text_Create(btn_seed, "desc",5 + (idx - 1)*83, 150, 23, "#081839", "仙草种子："..SL:GetMetaValue("ITEM_COUNT", entry.name))
                GUI:Text_setFontName(desc, "fonts/500.ttf")
                GUI:Text_enableOutline(desc, "#FFFFFF", 2)

                -- local kuang = GUI:Image_Create(btn_seed, "btn_seed"..idx, 0 + (idx - 1)*83, 150, "res/wy/public/58_58_kuang.png")
                -- local item = GUI:ItemShow_Create(kuang, "item", 29, 29, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",entry.name), look = true, bgVisible = false })
                -- GUI:setAnchorPoint(item, 0.5, 0.5)
                -- GUI:Text_Create(kuang, "count",5,0, 14, "#FF0000", "库存:"..SL:GetMetaValue("ITEM_COUNT", entry.name))
                -- GUI:ItemShow_addReplaceClickEvent(item, function()
                --     if idx == 1 then
                --         sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'Low'})
                --     elseif idx == 2 then
                --         sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'High'})
                --     end

                -- end)
                
            end
        end

            
            -- kuang = GUI:Image_Create(btn_seed, "btn_seed_high", 83, 150, "res/wy/public/70_70_k.png")

            -- NPC_UI_HELPER.createPrimaryButton(btn_seed, 'btn_seed_low', -100, 80, '播种·低阶', function()
            --     sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'Low'})
            -- end)
            -- NPC_UI_HELPER.createPrimaryButton(btn_seed, 'btn_seed_high', -100, 30, '播种·高阶', function()
            --     sendAction(npcid, 'plant', {gridId = plot.gridId or selected, seedId = 'High'})
            -- end)
        end


    elseif plot.state == 'growing' then
        -- createActionButton('btn_acc', 0, '加速（敬请期待）', function()
        --     local s = ensureState()
        --     s.lastMessage = '加速功能预留，暂未开放。'
        --     s.lastActionOk = false
        --     npc.render()
        -- end, false)
    else
        -- createActionButton('btn_idle', 0, '等待中', nil, false)
    end

    if plot.state == 'mature' or true then
        local canHarvest = hasProductReward(plot.product)
        local btn = createActionButton('btn_harvest', 245, '', function()
            sendAction(npcid, 'harvest', {gridId = plot.gridId or selected})
        end, canHarvest,{skin = "res/custom/three_city/xianfu/btn/l/5.png",Disabled_skin = "res/custom/three_city/xianfu/btn/n/5.png"})
        GUI:setAnchorPoint(btn, 0.5, 0)
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

local function drawVisitorLog(node, snapshot, npcid)
    local function GUI_Visitor_createLabel(Label_node)
        GUI:removeAllChildren(Label_node)

        local logs = ((snapshot.player or {}).visitor or {}).log or {}
        local lines = {}
        local actionLabel = {like = '点赞', steal = '偷菜', visit = '拜访'}
        --SL:dump(logs,"logslogslogslogslogslogslogslogs")

        local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30,15, 330, 330, 1)
        GUI:ScrollView_setBounceEnabled(ScrollView, true)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 330, ((30) * math.ceil(#logs)) > 330 and ((30) * math.ceil(#logs)) or 330)
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 330, ((30) * math.ceil(#logs)) > 330 and ((30) * math.ceil(#logs)) or 330)
        for index, entry in ipairs(logs) do
            local kuang = GUI:Image_Create(dbLayout, "kuang"..index, 0, 0.00, "res/custom/three_city/xianfu/baifang/Visitor/k"..(index%2 == 1 and 1 or 2)..".png")
            local timeText = os.date('%H:%M', (entry.time or 0))
            local actionText = actionLabel[entry.action] or (entry.action or '')
            local detail = entry.detail or ''
            GUI:Text_Create(kuang, "wz",40, 6, 16, "#00FB00", string.format('[%s] %s %s %s', timeText, entry.from or '??', actionText, detail))
        end
        if #logs == 0 then
            local kuang = GUI:Image_Create(dbLayout, "kuang", 0, 0.00, "res/custom/three_city/xianfu/baifang/Visitor/k2.png")
            GUI:Text_Create(kuang, "wz",40, 3, 18, "#00FB00", '暂无访客记录')

        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=0, y=0}})


        local btn = NPC_UI_HELPER.createPrimaryButton(Label_node, 'btn_rank', 550, 80, "", function()
            npc.xxjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_44_xxjm",
                overlay = {skin = "res/custom/treasureBasin/x.png"},
                background = {skin = "res/custom/three_city/xianfu/baifang/rank/bg.png"},
                closeButton = {x = 300 + 504, y = 180 + 140 + 119, skin = "res/wy/public/close_red_big.png"},
            })
            npc.xxjm_node = npc.xxjm_window.node
            npc.xx_Label = GUI:Node_Create(npc.xxjm_node, "Label", 0, 0)
            local list = snapshot.rank or {}


            local ScrollView = GUI:ScrollView_Create(npc.xx_Label, "ScrollView", 45 + 55, 40 + 100, 736, 295, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 736, ((38) * math.ceil(#list)) > (295) and ((38) * math.ceil(#list)) or (295))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 10,0, 736, (((38) * math.ceil(#list)) > 295 and ((38) * math.ceil(#list)) or 295))

            --SL:dump(list,"listlistlistlistlistlistlistlist")
            if #list == 0 then
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0, "res/custom/three_city/xianfu/baifang/rank/k1.png")
                GUI:Text_Create(kuang, 'rank_empty', 0, 20, 18, colors.muted, '暂无排行数据')

                return
            end
            for i, entry in ipairs(list) do
                if i > 10 then
                    break
                end
                local kuang = GUI:Image_Create(dbLayout, "kuang"..i, 0, 0, "res/custom/three_city/xianfu/baifang/rank/k"..(i%2 == 1 and 1 or 2)..".png")

                local color = (i == 1) and colors.warning or colors.primary

                GUI:setAnchorPoint(GUI:Text_Create(kuang, 'i', 60, 19, 18, color, tostring(i)), 0.5, 0.5)
                GUI:setAnchorPoint(GUI:Text_Create(kuang, 'name', 266, 19, 18, color, tostring(entry.name)), 0.5, 0.5)
                GUI:setAnchorPoint(GUI:Text_Create(kuang, 'value', 640, 19, 18, color, tostring(entry.value or 0)), 0.5, 0.5)
                GUI:setAnchorPoint(GUI:Text_Create(kuang, 'likenum', 480, 19, 18, color, tostring(entry.likenum or 0)), 0.5, 0.5)
            

            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=0, y=0}})

        end,{skin = "res/custom/three_city/xianfu/baifang/Visitor/btn_rank.png"})
        GUI:setAnchorPoint(btn, 0.5, 0.5)

    end

    

    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
        windowName = "npc_anniu_44_xjm",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = "res/custom/three_city/xianfu/baifang/Visitor/bg.png"},
        closeButton = {x = 330 + 220 + 170, y = 180 + 180 + 50, skin = "res/wy/public/close_red_big.png"},
    })
    npc.xjm_node = npc.xjm_window.node
    npc.xjm_Label = GUI:Node_Create(npc.xjm_node, "Label", 0, 0)

    
    GUI_Visitor_createLabel(npc.xjm_Label)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_anniu_44_xjm"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            local s = ensureState()
            if s.menuTab ~= "farm" then
                s.menuTab = "farm"
                npc.render()
            end
        end
    end)
    -- local panel = GUI:Node_Create(node, 'visitor_panel', layout.visitor.x, layout.visitor.y)
    -- GUI:setAnchorPoint(panel, 0.5, 0.5)
    -- local title = GUI:Text_Create(panel, 'visitor_title', 0, 80, 20, colors.primary, '访客石')
    -- GUI:setAnchorPoint(title, 0.5, 0)
    -- GUI:Text_enableOutline(title, '#1d0f09', 1)
    -- local logs = ((snapshot.player or {}).visitor or {}).log or {}
    -- local lines = {}
    -- local actionLabel = {like = '点赞', steal = '偷菜', visit = '拜访'}
    -- for index, entry in ipairs(logs) do
    --     if index > 6 then
    --         break
    --     end
    --     local timeText = os.date('%H:%M', (entry.time or 0))
    --     local actionText = actionLabel[entry.action] or (entry.action or '')
    --     local detail = entry.detail or ''
    --     lines[#lines + 1] = string.format('[%s] %s %s %s', timeText, entry.from or '??', actionText, detail)
    -- end
    -- if #lines == 0 then
    --     lines[1] = '暂无访客记录'
    -- end
    -- local content = table.concat(lines, '\n') .. '\n最多保留30条，自动滚动。'
    -- NPC_UI_HELPER.createRichText(panel, 'visitor_text', 0, 40, content, {width = 520, height = 20, anchor = {x = 0.5, y = 1}, color = colors.primary})
end

local shopTabs = {
    {id = 'seeds', label = '种子'},
    {id = 'materials', label = '材料'},
    {id = 'eggs', label = '灵蛋'},
    {id = 'decorate', label = '装扮'},
}
local shapeTabs = {
    {id = 'statue', label = '种子'},
    {id = 'cave', label = '材料'},
    {id = 'welcome', label = '灵蛋'},
    {id = 'spring', label = '装扮'},
    {id = 'wall', label = '装扮'},
}



-- ===== 商城与装扮 =====
local function drawShop(node, snapshot, npcid)

    local function GUI_Shop_createLabel(Label_node,titles_sign)
        GUI:removeAllChildren(Label_node)
        if shopTabs[titles_sign] == nil then
            return
        end

        local cfg = snapshot.cfg or {}
        local player = snapshot.player or {}

        if shopTabs[titles_sign].id == 'seeds' then
            local config = cfg.shop and cfg.shop.seeds or {}

            GUI:Image_Create(Label_node, "wz1", 550, 20, "res/custom/one_city/shape/wz1.png")


            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 40, 0, 670, 440, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            for k,v in ipairs(config) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/xianfu/shop/kuang.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",142/2, 162, 18, "#FF0000", v.name)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)

                local cost = GUI:RichText_Create(kuang, "cost", 142/2, 50,  ItemNumByTable(v.cost), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(cost, 0.5, 0.5)
                
                GUI:setAnchorPoint(GUI:ItemShow_Create(kuang, "item", 70, 118, {index= SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.seed),count = 1,look= true})
                , 0.5, 0.5)

                local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 142/2, 18, "", function()
                    sendAction(npcid, 'buySeed', {id = v.id, amount = 1})
                end,{skin = "res/custom/three_city/xianfu/shop/btn.png"})
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                    
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=30, y=20}})
        elseif shopTabs[titles_sign].id == 'materials' then
            -- 材料 
            local config = cfg.shop and cfg.shop.materials or {}

            GUI:Image_Create(Label_node, "wz1", 550, 20, "res/custom/one_city/shape/wz1.png")


            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 40, 0, 670, 440, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            for k,v in ipairs(config) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/xianfu/shop/kuang.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",142/2, 162, 18, "#FF0000", v.name)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)

                local cost = GUI:RichText_Create(kuang, "cost", 142/2, 50,  ItemNumByTable(v.cost), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(cost, 0.5, 0.5)
                
                GUI:setAnchorPoint(GUI:ItemShow_Create(kuang, "item", 70, 118, {index= SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.seed),count = 1,look= true})
                , 0.5, 0.5)

                local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 142/2, 18, "", function()
                    sendAction(npcid, 'buyMaterial', {id = v.id, amount = 1})
                end,{skin = "res/custom/three_city/xianfu/shop/btn.png"})
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                    
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=30, y=20}})
        elseif shopTabs[titles_sign].id == 'eggs' then
            -- 蛋类 
            local config = cfg.shop and cfg.shop.eggs or {}

            GUI:Image_Create(Label_node, "wz1", 550, 20, "res/custom/one_city/shape/wz1.png")


            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 40, 0, 670, 440, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            for k,v in ipairs(config) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/xianfu/shop/kuang.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",142/2, 162, 18, "#FF0000", v.name)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)

                local cost = GUI:RichText_Create(kuang, "cost", 142/2, 50,  ItemNumByTable(v.cost), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(cost, 0.5, 0.5)
                
                GUI:setAnchorPoint(GUI:ItemShow_Create(kuang, "item", 70, 118, {index= SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.seed),count = 1,look= true})
                , 0.5, 0.5)

                local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 142/2, 18, "", function()
                    sendAction(npcid, 'buyEgg', {id = v.id, amount = 1})
                end,{skin = "res/custom/three_city/xianfu/shop/btn.png"})
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                    
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=30, y=20}})
        elseif shopTabs[titles_sign].id == 'decorate' then
            -- 装扮
            local config = safePairs(cfg.decorate or {})

            GUI:Image_Create(Label_node, "wz1", 550, 20, "res/custom/one_city/shape/wz1.png")

            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 40, 0, 670, 440, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, ((180 + 20) * math.ceil(#config/3)) > 440 and ((180 + 20) * math.ceil(#config/3)) or 440)

            local owned = ((player.decoration or {}).owned) or {}
            local equipped = (player.decoration or {}).equipped

            for k,v in ipairs(config) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/xianfu/shop/kuang.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",142/2, 162, 18, "#FF0000", string.format("%s +%s仙华", v.name or v.id or "装扮", formatNumber(v.xiangHua or 0)))
                GUI:setAnchorPoint(wz5, 0.5, 0.5)

                local costText = ItemNumByTable(v.cost)
                local cost = GUI:RichText_Create(kuang, "cost", 142/2, 50, costText, 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(cost, 0.5, 0.5)

                -- 装扮不一定有物品条目，优先使用 icon 字段，其次尝试道具索引
                if v.icon then
                    local icon = GUI:Image_Create(kuang, "icon"..k, 70, 118, v.icon)
                    GUI:setAnchorPoint(icon, 0.5, 0.5)
                else
                    local index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", v.item or v.id or "")
                    if index then
                        GUI:setAnchorPoint(GUI:ItemShow_Create(kuang, "item"..k, 70, 118, {index = index,count = 1,look= true}), 0.5, 0.5)
                    end
                end
                local own = owned[""..v.id]
                if own then
                    
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "ok", 142/2, 23, "res/wy/public/6.png")
                    , 0.5, 0.5)
                else
                    local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 142/2, 18, "", 
                        function()
                            sendAction(npcid, 'buyDecoration', {decoId = v.id})
                        end
                    , {skin = "res/custom/three_city/xianfu/shop/btn.png"})
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                end

            end

            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=30, y=20}})
        end

    end

    

    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
        windowName = "npc_anniu_44_xjm",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = "res/custom/three_city/xianfu/shop/bg.png"},
        title = {x = 56, y = 464, skin = "res/custom/three_city/xianfu/shop/title.png"},
        closeButton = {x = 330 + 220 + 185, y = 180 + 180 + 103, skin = "res/wy/public/close_red_big.png"},
    })
    npc.xjm_node = npc.xjm_window.node

    if isGuestMode() then
        SL:ShowSystemTips("<font color='#FF0000'>拜访模式不可使用商城与装扮功能，请返回自宅后再尝试。</font>")
        return
    end

    npc.cbl_list = GUI:ListView_Create(npc.xjm_node, "cbl_list", -5, 10, 170, 440, 1)
    GUI:ListView_setGravity(npc.cbl_list, 1)
    GUI:ListView_setItemsMargin(npc.cbl_list, 10)
    npc.Label = GUI:Node_Create(npc.xjm_node, "Label", 170, 15)

    npc.titles_sign = npc.titles_sign or 1
    for i = 1, 4 do
        local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/three_city/xianfu/shop/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
        -- GUI:Button_setTitleText(cbl_item, titles[i])
        -- GUI:Button_setTitleFontSize(cbl_item, 14)
        GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
        GUI:addOnClickEvent(cbl_item, function()
            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/xianfu/shop/list/n/"..npc.titles_sign..".png")
            npc.titles_sign = i
            GUI_Shop_createLabel(npc.Label,i)

            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/xianfu/shop/list/l/"..npc.titles_sign..".png")
        end)
    end
    GUI_Shop_createLabel(npc.Label,npc.titles_sign)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_anniu_44_xjm"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            local s = ensureState()
            if s.menuTab ~= "farm" then
                s.menuTab = "farm"
                npc.titles_sign = 1
                npc.render()
            end
        end
    end)


    -- local panel = GUI:Node_Create(node, 'shop_panel', layout.shop.x, layout.shop.y)
    -- GUI:setAnchorPoint(panel, 0.5, 0.5)
    -- local title = GUI:Text_Create(panel, 'shop_title', 0, 120, 20, colors.primary, '商城 / 装扮')
    -- GUI:setAnchorPoint(title, 0.5, 0)
    -- GUI:Text_enableOutline(title, '#1d0f09', 1)

    -- local state = ensureState()
    -- for idx, tab in ipairs(shopTabs) do
    --     local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'shop_tab_' .. tab.id, -150 + (idx - 1) * 100, 90, tab.label, function()
    --         state.shopTab = tab.id
    --         npc.render()
    --     end)
    --     GUI:Button_setBright(btn, state.shopTab ~= tab.id)
    -- end

    -- local rows = {}
    -- local cfg = snapshot.cfg or {}
    -- local player = snapshot.player or {}
    -- local tabId = state.shopTab
    -- if tabId == 'seeds' then
    --     for _, entry in ipairs(cfg.shop and cfg.shop.seeds or {}) do
    --         local plant = (cfg.plant or {})[entry.seed]
    --         local canSteal = plant and plant.canSteal and '可偷' or '不可偷'
    --         local reward = summarizeProduct(plant and plant.product)
    --         local desc = string.format('成熟：%s｜奖励：%s｜%s', formatSeconds((plant and plant.matureTime) or 0), reward ~= '' and reward or '—', canSteal)
    --         rows[#rows + 1] = {
    --             name = entry.name,
    --             desc = string.format('%s｜价格：%s', desc, formatCost(entry.cost)),
    --             button = '购买',
    --             callback = function()
    --                 sendAction(npcid, 'buySeed', {id = entry.id, amount = 1})
    --             end,
    --         }
    --     end
    -- elseif tabId == 'eggs' then
    --     for _, entry in ipairs(cfg.shop and cfg.shop.eggs or {}) do
    --         local eggCfg = (cfg.pet and cfg.pet.eggs) and cfg.pet.eggs[entry.id]
    --         local beast = eggCfg and eggCfg.beast or {}
    --         local desc = string.format('灵兽：%s｜上限：%s级｜价格：%s', beast.type or '--', formatNumber(beast.maxLevel or 1), formatCost(entry.cost))
    --         rows[#rows + 1] = {
    --             name = entry.name,
    --             desc = desc,
    --             button = '购买',
    --             callback = function()
    --                 sendAction(npcid, 'buyEgg', {id = entry.id, amount = 1})
    --             end,
    --         }
    --     end
    -- elseif tabId == 'materials' then
    --     for _, entry in ipairs(cfg.shop and cfg.shop.materials or {}) do
    --         local desc = string.format('宠物养成材料｜价格：%s', formatCost(entry.cost))
    --         rows[#rows + 1] = {
    --             name = entry.name,
    --             desc = desc,
    --             button = '购买',
    --             callback = function()
    --                 sendAction(npcid, 'buyMaterial', {id = entry.id, amount = 1})
    --             end,
    --         }
    --     end
    -- elseif tabId == 'decorate' then
    --     local owned = ((player.decoration or {}).owned) or {}
    --     local equipped = (player.decoration or {}).equipped
    --     for _, entry in ipairs(safePairs(cfg.decorate or {})) do
    --         local own = owned[entry.id]
    --         local status
    --         local button
    --         local callback
    --         if own then
    --             if equipped == entry.id then
    --                 status = '已佩戴'
    --             else
    --                 button = '佩戴'
    --                 callback = function()
    --                     sendAction(npcid, 'equipDecoration', {decoId = entry.id})
    --                 end
    --             end
    --         else
    --             button = '购买'
    --             callback = function()
    --                 sendAction(npcid, 'buyDecoration', {decoId = entry.id})
    --             end
    --         end
    --         rows[#rows + 1] = {
    --             name = string.format('%s（+%s仙华）', entry.name, formatNumber(entry.xiangHua or 0)),
    --             desc = string.format('价格：%s｜%s', formatCost(entry.cost), status or '装扮可永久增加仙华（装备时生效）'),
    --             button = button,
    --             status = status,
    --             callback = callback,
    --         }
    --     end
    -- end

    -- local startY = 60
    -- for idx, row in ipairs(rows) do
    --     local y = startY - (idx - 1) * 30
    --     local nameLabel = GUI:Text_Create(panel, 'shop_row_name_' .. idx, -150, y, 18, colors.primary, row.name or '')
    --     GUI:setAnchorPoint(nameLabel, 0, 0.5)
    --     GUI:Text_enableOutline(nameLabel, '#1d0f09', 1)
    --     local descLabel = GUI:Text_Create(panel, 'shop_row_desc_' .. idx, -150, y - 16, 16, colors.detail, row.desc or '')
    --     GUI:setAnchorPoint(descLabel, 0, 0.5)
    --     GUI:Text_enableOutline(descLabel, '#0d1b26', 1)
    --     if row.button and row.callback then
    --         local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'shop_btn_' .. idx, 140, y - 8, row.button, row.callback)
    --         GUI:setAnchorPoint(btn, 0, 0.5)
    --     elseif row.status then
    --         local statusLabel = GUI:Text_Create(panel, 'shop_status_' .. idx, 140, y - 8, 16, colors.warning, row.status)
    --         GUI:setAnchorPoint(statusLabel, 0, 0.5)
    --     end
    -- end

    -- NPC_UI_HELPER.createRichText(panel, 'shop_tip', 0, -80, '装扮可永久增加仙华值（装备时生效）', {width = 360, height = 18, anchor = {x = 0.5, y = 1}, color = colors.warning})
end

-- ===== 装扮 =====
local function drawshape(node, snapshot, npcid)

    local function GUI_Shop_createLabel(Label_node,titles_sign)
        GUI:removeAllChildren(Label_node)
        if shapeTabs[titles_sign] == nil then
            return
        end
        local config = npc._config.DecorateplaceCfg[shapeTabs[titles_sign].id] or {}


        GUI:Image_Create(Label_node, "wz1", 550, 100, "res/custom/one_city/shape/wz1.png")
        local player = snapshot.player or {}

        local owned = ((player.decoration or {}).owned) or {}
        local equipped = (player.decoration or {}).equipped
        -- --SL:dump(owned, "owned")
        -- --SL:dump(equipped, "equipped")


        local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 40, 0, 670, 440, 1)
        GUI:ScrollView_setBounceEnabled(ScrollView, true)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 670, ((180 + 20) * math.ceil(#config.list/3)) > 440 and ((180 + 20) * math.ceil(#config.list/3)) or 440)
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, ((180 + 20) * math.ceil(#config.list/3)) > 440 and ((180 + 20) * math.ceil(#config.list/3)) or 440)
        local num = 0
        for k,v in ipairs(config.list) do
            if owned[tostring(v)] == nil then
                goto continue
            end
            num = num + 1
            local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/xianfu/zhuangshi/kuang.png")
            local itme = npc._config.DecorateCfg[v]
            local wz5 = GUI:Text_Create(kuang, "wz5",145/2, 143, 16, "#FF0000", itme.name)
            GUI:setAnchorPoint(wz5, 0.5, 0.5)

            
            GUI:setAnchorPoint(GUI:Text_Create(kuang, "xhz",145/2, 42, 16, "#FF0000", "+"..itme.xiangHua)
            , 0.5, 0.5)
            if equipped and equipped[shapeTabs[titles_sign].id] == tostring(v) then
                local yifu = GUI:Image_Create(kuang, "yifu", 145/2, 18, "res/custom/three_city/xianfu/zhuangshi/new.png")
                GUI:setAnchorPoint(yifu, 0.5, 0.5)
            else
                local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 145/2, 18, "", function()
                    sendAction(npcid, 'equipDecoration', {decoId = v})
                end,{skin = "res/custom/three_city/xianfu/zhuangshi/btn.png"})
                GUI:setAnchorPoint(btn, 0.5, 0.5)
            end
            ::continue::
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=30, y=20}})
        if num == 0 then
            local emptyTip = GUI:Text_Create(Label_node, 'empty_tip', 300, 200, 20, colors.warning, '暂无已拥有的装扮，快去商城购买吧！')
            GUI:setAnchorPoint(emptyTip, 0.5, 0.5)
        end
    end

        

    

    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
        windowName = "npc_anniu_44_xjm",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = "res/custom/three_city/xianfu/zhuangshi/bg.png"},
        title = {x = 56, y = 464, skin = "res/custom/three_city/xianfu/zhuangshi/title.png"},
        closeButton = {x = 330 + 220 + 185, y = 180 + 180 + 103, skin = "res/wy/public/close_red_big.png"},
    })
    npc.xjm_node = npc.xjm_window.node

    if isGuestMode() then
        SL:ShowSystemTips("<font color='#FF0000'>拜访模式不可使用商城与装扮功能，请返回自宅后再尝试。</font>")
        return
    end

    npc.cbl_list = GUI:ListView_Create(npc.xjm_node, "cbl_list", -5, 10, 170, 440, 1)
    GUI:ListView_setGravity(npc.cbl_list, 1)
    GUI:ListView_setItemsMargin(npc.cbl_list, 10)
    npc.Label = GUI:Node_Create(npc.xjm_node, "Label", 170, 15)

    npc.titles_sign = npc.titles_sign or 1
    for i = 1, 5 do
        local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/three_city/xianfu/zhuangshi/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
        -- GUI:Button_setTitleText(cbl_item, titles[i])
        -- GUI:Button_setTitleFontSize(cbl_item, 14)
        GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
        GUI:addOnClickEvent(cbl_item, function()
            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/xianfu/zhuangshi/list/n/"..npc.titles_sign..".png")
            npc.titles_sign = i
            GUI_Shop_createLabel(npc.Label,i)

            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/xianfu/zhuangshi/list/l/"..npc.titles_sign..".png")
        end)
    end
    GUI_Shop_createLabel(npc.Label,npc.titles_sign)

    local btn = NPC_UI_HELPER.createPrimaryButton(npc.xjm_node, 'btn', 650, 50, "", function()
        npc.titles_sign = 4
        drawShop(node, snapshot, npcid)
    end,{skin = "res/custom/three_city/xianfu/zhuangshi/btn_shop.png"})
    GUI:setAnchorPoint(btn, 0.5, 0.5)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_anniu_44_xjm"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            local s = ensureState()
            if s.menuTab ~= "farm" then
                s.menuTab = "farm"
                npc.titles_sign = 1
                npc.render()
            end
        end
    end)
end

-- 炼丹模块，展示配方/冷却。
local function drawRefine(node, snapshot, npcid)

    local function GUI_Refine_createLabel(Label_node,titles_sign)
        GUI:removeAllChildren(Label_node)

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
        local collection = player.refine and player.refine.collection or {}
        npc.name_sign = npc.name_sign or recipes and next(recipes) and next(recipes) or nil
        -- --SL:dump(recipes, "recipes")
        -- --SL:dump(npc.name_sign, "name_sign")

        
        -- GUI:Text_Create(Label_node, 'remainCd', 568, 300, 18, colors.primary, string.format('冷却 %s', formatSeconds(remainCd)))
        

        for k,v in ipairs(recipes[npc.name_sign].cost) do
            local kuang = GUI:Image_Create(Label_node, "cost_"..k, 115, 300.00 - (k-1)*60, "res/custom/three_city/xianfu/ldl/kuang.png")
            GUI:setAnchorPoint(
                GUI:ItemShow_Create(kuang, "item", 48 / 2, 52 / 2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",v[1]),count = v[2], look = true, bgVisible = false })
            , 0.5, 0.5)
        end
        

        
        GUI:Image_Create(Label_node, "cost", 80, 140.00, "res/custom/three_city/xianfu/ldl/cost.png")
        

        local btn = NPC_UI_HELPER.createPrimaryButton(Label_node, 'btn_make', 750/2, 80, "", function()
            sendAction(npcid, 'refine', {recipeId = npc.name_sign})
        end,{skin = "res/custom/three_city/xianfu/ldl/btn_make.png"})
        GUI:setAnchorPoint(btn, 0.5, 0.5)

        btn = NPC_UI_HELPER.createPrimaryButton(Label_node, 'btn_tj', 750/2 - 230, 80, "", function()
            npc.xxjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_44_xxjm",
                overlay = {skin = "res/custom/treasureBasin/x.png"},
                background = {skin = "res/custom/three_city/xianfu/ldl/tj/bg.png"},
                title = {x = 56, y = 464, skin = "res/custom/three_city/xianfu/ldl/tj/title.png"},
                closeButton = {x = 330 + 220 + 185, y = 180 + 180 + 103, skin = "res/wy/public/close_red_big.png"},
            })
            npc.xxjm_node = npc.xxjm_window.node
            npc.xx_Label = GUI:Node_Create(npc.xxjm_node, "Label", 15, 15 + 75)

            local ScrollView = GUI:ScrollView_Create(npc.xx_Label, "ScrollView", 10, 0, 720, 370, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 720, ((190) * math.ceil(#recipes/6)) > 370 and ((190) * math.ceil(#recipes/6)) or 370)
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 720, ((190) * math.ceil(#recipes/6)) > 370 and ((190) * math.ceil(#recipes/6)) or 370)
            local num = 0
            for k,v in pairs(recipes) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0, "res/custom/three_city/xianfu/ldl/tj/kuang.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",121/2, 155, 18, "#FF0000", k)
                GUI:setAnchorPoint(wz5, 0.5, 0.5)

                local itme_kuang = GUI:Image_Create(kuang, "xz_kuang", 121/2, 105.00, "res/custom/three_city/xianfu/ldl/kuang.png")
                GUI:setAnchorPoint(itme_kuang, 0.5, 0.5)
                UiTools.showItemData(itme_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)))

                if collection and collection[k] then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "ok", 121/2, 55, "res/custom/three_city/xianfu/ldl/tj/ydl.png")
                    , 0.5, 0.5)
                else
                    local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 121/2, 55, "", function()
                        npc.name_sign = k
                        GUI_Refine_createLabel(npc.Label,npc.name_sign)
                        local parent = GUI:GetWindow(nil, "npc_anniu_44_xxjm")
                        if parent then
                            GUI:Win_Close(parent)
                        end
                    end,{skin = "res/custom/three_city/xianfu/ldl/tj/bntn_lz.png"})
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                end 
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 6,gap = {x=0, y=0}})
        end,{skin = "res/custom/three_city/xianfu/ldl/btn_tj.png"})
        GUI:setAnchorPoint(btn, 0.5, 0.5)

        btn = NPC_UI_HELPER.createPrimaryButton(Label_node, 'btn_xz', 750/2 + 230, 80, "", function()
            npc.xxjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_44_xxjm",
                overlay = {skin = "res/custom/treasureBasin/x.png"},
                background = {skin = "res/custom/three_city/xianfu/ldl/xz_bg.png"},
                closeButton = {x = 300, y = 180 + 140, skin = "res/wy/public/close_red_big.png"},
            })
            npc.xxjm_node = npc.xxjm_window.node
            npc.xx_Label = GUI:Node_Create(npc.xxjm_node, "Label", 0, 0)

            local ScrollView = GUI:ScrollView_Create(npc.xx_Label, "ScrollView", 45, 40, 280, 240, 1)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 280, ((52 + 70) * math.ceil(#recipes/4)) > (240 + 70) and ((52 + 70) * math.ceil(#recipes/4)) or (240 + 70))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 10,0, 280, 70 + (((52 + 70) * math.ceil(#recipes/4)) > 240 and ((52 + 70) * math.ceil(#recipes/4)) or 240))
            for k,v in pairs(recipes) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0, "res/custom/three_city/xianfu/ldl/kuang.png")

                local itemShow = GUI:ItemShow_Create(kuang, "item", 48 / 2, 52 / 2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k), look = true, bgVisible = false })
                GUI:setAnchorPoint(itemShow, 0.5, 0.5)

                local desc = GUI:Text_Create(kuang, "desc",48 / 2,-10, 20, "#808080", k)
                GUI:setAnchorPoint(desc, 0.5, 0.5)
                GUI:Text_setFontName(desc, "fonts/500.ttf")
                GUI:Text_enableOutline(desc, "#00FFFF", 2)

                local btn = NPC_UI_HELPER.createPrimaryButton(kuang, 'btn', 25, -40, "", function()
                    npc.name_sign = k
                    GUI_Refine_createLabel(npc.Label,npc.name_sign)
                    local parent = GUI:GetWindow(nil, "npc_anniu_44_xxjm")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                end,{skin = "res/custom/three_city/xianfu/ldl/btn_xz1.png"})
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=20, y=50}})

        end,{skin = "res/custom/three_city/xianfu/ldl/btn_xz.png"})
        GUI:setAnchorPoint(btn, 0.5, 0.5)

        
        GUI:setAnchorPoint(GUI:Image_Create(btn, "xz_itme", 150/2, 60, "res/custom/three_city/xianfu/ldl/jt.png")
        , 0.5, 0.5)
        local xz_kuang = GUI:Image_Create(btn, "xz_kuang", 150/2, 100.00, "res/custom/three_city/xianfu/ldl/kuang.png")
        GUI:setAnchorPoint(xz_kuang, 0.5, 0.5)
        local itemShow = GUI:ItemShow_Create(xz_kuang, "item", 48 / 2, 52 / 2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc.name_sign), look = true, bgVisible = false })
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)

        local desc = GUI:Text_Create(xz_kuang, "desc",50,0, 20, "#808080", npc.name_sign)
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)
    end

        

    

    npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
        windowName = "npc_anniu_44_xjm",
        overlay = {skin = "res/custom/treasureBasin/x.png"},
        background = {skin = "res/custom/three_city/xianfu/ldl/bg/eff_1.png"},
        title = {x = 56 + 222, y = 464 - 105, skin = "res/custom/three_city/xianfu/ldl/title.png"},
        closeButton = {x = 330 + 220 + 130, y = 180 + 180, skin = "res/wy/public/close_red_big.png"},
    })
    npc.xjm_node = npc.xjm_window.node

    if isGuestMode() then
        SL:ShowSystemTips("<font color='#FF0000'>拜访模式不可使用商城与装扮功能，请返回自宅后再尝试。</font>")
        return
    end

    local eff = GUI:Frames_Create(npc.xjm_window.bg, "eff", 0, 0, "res/custom/three_city/xianfu/ldl/bg/eff_", ".png", 1, 120,
            { speed = 75, count = 120, loop = -1})
    GUI:setLocalZOrder(eff, -1)

    npc.Label = GUI:Node_Create(npc.xjm_node, "Label", 0, 0)

    
    GUI_Refine_createLabel(npc.Label,npc.titles_sign)


    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_anniu_44_xjm"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            local s = ensureState()
            if s.menuTab ~= "farm" then
                s.menuTab = "farm"
                npc.render()
            end
        end
    end)


    -- local panel = GUI:Node_Create(node, 'refine_panel', layout.refine.x, layout.refine.y)
    -- GUI:setAnchorPoint(panel, 0.5, 0.5)
    -- local title = GUI:Text_Create(panel, 'refine_title', 0, 80, 20, colors.primary, '炼丹炉')
    -- GUI:setAnchorPoint(title, 0.5, 0)
    -- GUI:Text_enableOutline(title, '#1d0f09', 1)
    -- if isGuestMode() then
    --     NPC_UI_HELPER.createRichText(panel, 'refine_guest_tip', 0, 40, '拜访模式不可使用炼丹炉，请回到自宅。', {width = 360, height = 40, anchor = {x = 0.5, y = 1}, color = colors.warning})
    --     return
    -- end
    -- local cfg = snapshot.cfg or {}
    -- local recipes = cfg.refine and cfg.refine.recipes or {}
    -- local player = snapshot.player or {}
    -- local herbs = player.herbs or {}
    -- local plantCfg = cfg.plant or {}
    -- local lastTime = (player.refine or {}).lastTime or 0
    -- local cd = (cfg.refine and cfg.refine.furnaceCd) or 0
    -- local remainCd = math.max(0, (lastTime + cd) - serverNow())
    -- local ready = remainCd <= 0
    -- local rowIndex = 0
    -- for name, recipe in pairs(recipes) do
    --     rowIndex = rowIndex + 1
    --     local y = 50 - (rowIndex - 1) * 40
    --     local costHerb = formatCost(recipe.costHerb)
    --     local costCurrency = formatCost(recipe.costCurrency)
    --     local desc = string.format('%s｜灵草：%s｜货币：%s｜效果：%s', name, costHerb, costCurrency, formatAddValue(recipe.addValue))
    --     NPC_UI_HELPER.createRichText(panel, 'refine_row_' .. rowIndex, -150, y, desc, {width = 360, height = 36, anchor = {x = 0, y = 0.5}, color = colors.primary})
    --     local hasHerb = true
    --     if type(recipe.costHerb) == 'table' then
    --         for _, entry in pairs(recipe.costHerb) do
    --             if type(entry) == 'table' then
    --                 local herbName = entry[1]
    --                 local need = entry[2] or 0
    --                 if resolveHerbCount(herbs, plantCfg, herbName) < need then
    --                     hasHerb = false
    --                     break
    --                 end
    --             elseif type(entry) == 'string' then
    --                 if resolveHerbCount(herbs, plantCfg, entry) <= 0 then
    --                     hasHerb = false
    --                     break
    --                 end
    --             end
    --         end
    --     end
    --     local btnText = ready and '炼制' or string.format('冷却 %s', formatSeconds(remainCd))
    --     local enabled = ready and hasHerb
    --     local btn = NPC_UI_HELPER.createPrimaryButton(panel, 'refine_btn_' .. rowIndex, 150, y, btnText, function()
    --         sendAction(npcid, 'refine', {recipeId = name})
    --     end)
    --     GUI:setAnchorPoint(btn, 0, 0.5)
    --     if not enabled then
    --         GUI:Button_setBright(btn, false)
    --     end
    -- end
    -- local tip = '集齐全部丹方自动授予称号「极品炼丹师」'
    -- NPC_UI_HELPER.createRichText(panel, 'refine_tip', 0, -40, tip, {width = 360, height = 30, anchor = {x = 0.5, y = 1}, color = colors.warning})
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
        -- drawQuickActions(npc.node, snapshot, npcid, baseSnapshot)
        drawVisitorLog(npc.node, snapshot, npcid)
    elseif tab == 'shop' then
        drawShop(npc.node, snapshot, npcid)
    elseif tab == 'refine' then
        drawRefine(npc.node, snapshot, npcid)
    elseif tab == 'pet' then
        -- drawPet(npc.node, snapshot, npcid)
        
    elseif tab == 'rank' then
        drawRank(npc.node, snapshot)
    elseif tab == 'system' then
        drawSystemMessages(npc.node, snapshot)
    elseif tab == 'shape' then
        drawshape(npc.node, snapshot, npcid)
    else
        drawPlotCells(npc.node, snapshot)
        drawPlotDetail(npc.node, snapshot, npcid)
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
    buildTopOverview(npc.node, displaySnapshot, baseSnapshot, npcid)
    drawMenuBar(npc.node)
    local btn_knashu = GUI:Frames_Create(npc.node, "eff1", cogin.w/2,  - cogin.h/2 + 120, "res/custom/three_city/xianfu/kanshu/btn/eff_", ".png", 1, 75,
                { speed = 75, count = 75, loop = -1})
    GUI:setAnchorPoint(btn_knashu, 1, 0)
    GUI:setTouchEnabled(btn_knashu, true)
    GUI:addOnClickEvent(btn_knashu, function()
        SL:SendLuaNetMsg(101, 30, 0, 0, '')
    end)
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
