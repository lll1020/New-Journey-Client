local npc = {}

local UIHelper = NPC_UI_HELPER

local DEFAULT_CONFIG = {
    id = 83,
    name = "残魂商店",
    point_name = "残魂值",
    fire_name = "业火值",
    title_reward = {
        name = "向死而生",
        target = "天罚猎杀者",
        damage_pct = 20,
        level_need = 150,
        level_add = 1,
    },
    shop = {},
}

npc._config = teshudata["npc_83"] or teshudata["npc_77"] or DEFAULT_CONFIG

local WINDOW_OPTS = {
    background = {skin = "res/custom/six_city/残魂商店/示意图.png", eff = false},
    closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
}

local BUY_BTN_SKIN = "res/custom/six_city/残魂商店/购买.png"
local DIVIDER_SKIN = "res/custom/six_city/残魂商店/分割线-.png"
local ITEM_BOX_SKIN = "res/custom/six_city/残魂商店/_装备框-.png"
local TITLE_BANNER_SKIN = "res/custom/six_city/残魂商店/标题.png"
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local SHOP_SCROLL_RECT = {x = 24, y = 60, width = 720, height = 294}
local SHOP_ROW_HEIGHT = 78

-- 说明：统一转数字，避免服务端字段为空时界面报错。
local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 说明：返回当前面板缓存数据，统一兜底为空表。
local function getPanelData()
    return npc.data or {}
end

-- 说明：优先使用服务端下发的配置，客户端本地配置只作为兜底。
local function getConfig()
    local data = getPanelData()
    return data.config or npc._config or DEFAULT_CONFIG
end

-- 说明：创建并复用 NPC 主窗口。
local function ensureWindow(npcid)
    local opts = {}
    local cfg = getConfig()
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = UIHelper.formatNpcTitle(npcid, cfg)
    opts.subTitle = cfg and cfg.name
    npc._window = UIHelper.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

-- 说明：返回服务端下发的商店列表，若没有则回退到配置表。
local function getShopList()
    local data = getPanelData()
    local cfg = getConfig()
    return data.shop or cfg.shop or {}
end

-- 说明：读取指定条目的已购买次数。
local function getBuyCount(idx)
    local data = getPanelData()
    local buy = ((data.T_data or {}).buy or {})
    return toNumber(buy[tostring(idx)] or buy[idx], 0)
end

-- 说明：根据奖励配置解析展示用的物品名。
local function getRewardDisplayInfo(cfg)
    local reward = cfg and cfg.reward or {}
    if tostring(reward.kind or "") == "title" then
        return {isTitle = true, name = tostring(reward.name or cfg.name or "称号奖励"), num = 1}
    end
    local give = reward and reward.give or {}
    local entry = give and give[1] or nil
    if type(entry) ~= "table" then
        return nil
    end
    return {
        isTitle = false,
        name = tostring(entry.name or entry[1] or ""),
        num = toNumber(entry.num or entry[2], 0),
    }
end

-- 说明：创建通用描边文字，减少重复样式代码。
local function createText(parent, name, x, y, size, color, text, fontName, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:Text_setFontName(label, fontName or FONT_MAIN)
    GUI:Text_enableOutline(label, "#000000", 2)
    if anchorX ~= nil or anchorY ~= nil then
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
    end
    return label
end

-- 说明：创建富文本并保持统一锚点风格。
local function createRichText(parent, name, x, y, text, width, size, anchorX, anchorY)
    local rich = GUI:RichText_Create(parent, name, x, y, tostring(text or ""), width or 260, size or 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, anchorX or 0, anchorY or 0.5)
    return rich
end

-- 说明：渲染奖励预览，物品奖励显示图标，称号奖励显示文字。
local function renderRewardPreview(parent, cfg)
    local box = GUI:Image_Create(parent, "reward_box", 0, 0, ITEM_BOX_SKIN)
    local info = getRewardDisplayInfo(cfg)
    if not info then
        createText(box, "reward_empty", 29, 18, 12, "#A0A0A0", "暂无", FONT_MAIN, 0.5, 0.5)
        return box
    end
    local itemIndex = info.name ~= "" and toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", info.name), 0) or 0
    if (not info.isTitle) and itemIndex > 0 then
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "reward_item", 29, 30, {index = itemIndex, count = info.num, look = true, bgVisible = false}), 0.5, 0.5)
    elseif info.isTitle then
        createText(box, "reward_title_name", 29, 34, 14, "#F6D38B", "称号", FONT_MAIN, 0.5, 0.5)
        createText(box, "reward_title_text", 29, 12, 12, "#6CFF7B", info.name, FONT_MAIN, 0.5, 0.5)
    else
        createText(box, "reward_item_text", 29, 22, 12, "#F5E6C6", info.name, FONT_MAIN, 0.5, 0.5)
        if info.num > 0 then
            createText(box, "reward_item_num", 29, 8, 11, "#FFD66D", "x" .. tostring(info.num), FONT_MAIN, 0.5, 0.5)
        end
    end
    return box
end

-- 说明：计算当前条目的购买状态，用于按钮和状态文案展示。
local function getPurchaseState(cfg, idx)
    local data = getPanelData()
    local point = toNumber(data.point, 0)
    local limit = toNumber(cfg and cfg.limit, 0)
    local buyNum = getBuyCount(idx)
    local cost = toNumber(cfg and cfg.cost, 0)
    local reward = cfg and cfg.reward or {}

    if tostring(reward.kind or "") == "title" and toNumber(data.has_title, 0) == 1 then
        return false, "已拥有", "#6CFF7B"
    end
    if limit > 0 and buyNum >= limit then
        return false, "已达上限", "#9A9A9A"
    end
    if point < cost then
        return false, "残魂不足", "#FF5A5A"
    end
    return true, "可兑换", "#F6D38B"
end

-- 说明：渲染单条商店条目。
local function renderShopRow(parent, npcid, idx, cfg, y)
    local row = GUI:Node_Create(parent, "row_" .. tostring(idx), 0, y)
    GUI:Image_Create(row, "divider", 0, 0, DIVIDER_SKIN)

    local rewardNode = GUI:Node_Create(row, "reward_node", 28, 8)
    renderRewardPreview(rewardNode, cfg)

    createText(row, "name_" .. idx, 102, 50, 17, "#F5E6C6", cfg.name or ("条目" .. tostring(idx)), FONT_TITLE, 0, 0.5)
    local desc = tostring(cfg.desc or "")
    if desc ~= "" then
        local rich = createRichText(row, "desc_" .. idx, 102, 28, desc, 244, 14, 0, 1)
        GUI:setAnchorPoint(rich, 0, 1)
    end

    createText(row, "cost_" .. idx, 398, 34, 20, "#FF4A4A", tostring(toNumber(cfg.cost, 0)), FONT_TITLE, 0.5, 0.5)

    local limit = toNumber(cfg.limit, 0)
    local buyNum = getBuyCount(idx)
    local limitText = limit > 0 and string.format("%d/%d", buyNum, limit) or "不限"
    createText(row, "limit_" .. idx, 516, 34, 20, "#E8E8E8", limitText, FONT_TITLE, 0.5, 0.5)

    local canBuy, stateText, stateColor = getPurchaseState(cfg, idx)
    createText(row, "state_" .. idx, 646, 56, 14, stateColor, stateText, FONT_MAIN, 0.5, 0.5)

    local btn = GUI:Button_Create(row, "buy_" .. idx, 602, 12, BUY_BTN_SKIN)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
    end)
    if canBuy then
        UIHelper.redpoint_create(btn, {x = 104, y = 28})
    else
        GUI:setOpacity(btn, 150)
    end
end

-- 说明：渲染顶部货币和称号奖励摘要。
local function renderSummary(node)
    local data = getPanelData()
    local cfg = getConfig()
    local titleCfg = cfg.title_reward or DEFAULT_CONFIG.title_reward
    local pointName = tostring(cfg.point_name or DEFAULT_CONFIG.point_name)
    local fireName = tostring(cfg.fire_name or DEFAULT_CONFIG.fire_name)

    GUI:Image_Create(node, "summary_title", 176, 446, TITLE_BANNER_SKIN)
    createText(node, "point_text", 716, 502, 20, "#F5E6C6", string.format("%s：%d", pointName, toNumber(data.point, 0)), FONT_TITLE, 1, 0.5)
    createText(node, "fire_text", 716, 474, 18, "#FFE6D1", string.format("%s：%d", fireName, toNumber(data.fire, 0)), FONT_MAIN, 1, 0.5)

    local hasTitle = toNumber(data.has_title, 0) == 1
    local bonusDone = toNumber(data.title_bonus_done, 0) == 1
    local titleName = tostring(titleCfg.name or DEFAULT_CONFIG.title_reward.name)
    local extraDesc = string.format("称号奖励：%s，对【%s】额外造成%d%%伤害", titleName, tostring(titleCfg.target or DEFAULT_CONFIG.title_reward.target), toNumber(titleCfg.damage_pct, DEFAULT_CONFIG.title_reward.damage_pct))
    createText(node, "title_desc", 40, 54, 17, "#F6D38B", extraDesc, FONT_MAIN, 0, 0.5)

    local levelText = string.format("%d级后等级+%d", toNumber(titleCfg.level_need, DEFAULT_CONFIG.title_reward.level_need), toNumber(titleCfg.level_add, DEFAULT_CONFIG.title_reward.level_add))
    local levelColor = bonusDone and "#6CFF7B" or (hasTitle and "#FFD65A" or "#A0A0A0")
    local stateText = bonusDone and "已发放" or (hasTitle and "待达到等级发放" or "未获得称号")
    createText(node, "level_desc", 40, 28, 16, levelColor, levelText .. "，" .. stateText, FONT_MAIN, 0, 0.5)
end

-- 说明：渲染中部商店列表，并支持条目数量超出时滚动查看。
local function renderShopList(node, npcid)
    local shop = getShopList()
    if #shop <= 0 then
        createText(node, "empty_desc", 392, 210, 24, "#CFCFCF", "暂无可兑换内容", FONT_TITLE, 0.5, 0.5)
        return
    end

    local scroll = GUI:ScrollView_Create(node, "shop_scroll", SHOP_SCROLL_RECT.x, SHOP_SCROLL_RECT.y, SHOP_SCROLL_RECT.width, SHOP_SCROLL_RECT.height, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local innerHeight = math.max(SHOP_SCROLL_RECT.height, #shop * SHOP_ROW_HEIGHT)
    GUI:ScrollView_setInnerContainerSize(scroll, SHOP_SCROLL_RECT.width, innerHeight)

    for idx, cfg in ipairs(shop) do
        local rowY = innerHeight - idx * SHOP_ROW_HEIGHT
        renderShopRow(scroll, npcid, idx, cfg, rowY)
    end
end

-- 说明：渲染整个残魂商店界面。
local function renderMain(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    renderSummary(node)
    renderShopList(node, npcid)
end

-- 说明：处理服务端回包并刷新界面。
function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 or p2 == 2 or p2 == 9 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node, npcid)
    end
end

return npc
