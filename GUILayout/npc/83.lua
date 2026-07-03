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

local BUY_BTN_SKIN = "res/custom/six_city/残魂商店/购买.png"
local DIVIDER_SKIN = "res/custom/six_city/残魂商店/分割线.png"
local ITEM_BOX_SKIN = "res/wy/public/58_58_kuang.png"
local TITLE_BANNER_SKIN = "res/custom/six_city/残魂商店/标题.png"
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local SHOP_SCROLL_RECT = {x = 8, y = 112, width = 720, height = 224}
local SHOP_ROW_HEIGHT = 74

local WINDOW_OPTS = {
    background = {skin = "res/wy/public/tongyong_0.png", eff = false},
    closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
    title = {x = 56, y = 464, skin = TITLE_BANNER_SKIN},
}

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function getPanelData()
    return npc.data or {}
end

local function getConfig()
    return npc._config or DEFAULT_CONFIG
end

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

local function getShopList()
    local cfg = getConfig()
    return cfg.shop or {}
end

local function getBuyCount(idx)
    local data = getPanelData()
    local buy = ((data.T_data or {}).buy or {})
    return toNumber(buy[tostring(idx)] or buy[idx], 0)
end

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

local function createText(parent, name, x, y, size, color, text, fontName, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:Text_setFontName(label, fontName or FONT_MAIN)
    GUI:Text_enableOutline(label, "#000000", 2)
    if anchorX ~= nil or anchorY ~= nil then
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
    end
    return label
end

local function renderTableHeader(node)
    createText(node, "slogan_text", 389, 398, 34, "#EAF5FF", "残魂值可以来这里购买货物！", FONT_TITLE, 0.5, 0.5)
    createText(node, "head_name", 145, 361, 23, "#D9D9D9", "物品名称", FONT_TITLE, 0.5, 0.5)
    createText(node, "head_cost", 454, 361, 23, "#D9D9D9", "所需残魂值", FONT_TITLE, 0.5, 0.5)
    createText(node, "head_limit", 570, 361, 23, "#D9D9D9", "限购情况", FONT_TITLE, 0.5, 0.5)
    createText(node, "head_buy", 686, 361, 23, "#D9D9D9", "购买换取", FONT_TITLE, 0.5, 0.5)
    GUI:Image_Create(node, "head_line", 4, 334, DIVIDER_SKIN)
end

local function renderRewardPreview(parent, cfg)
    local box = GUI:Image_Create(parent, "reward_box", 0, 0, ITEM_BOX_SKIN)
    local info = getRewardDisplayInfo(cfg)
    if not info then
        createText(box, "reward_empty", 29, 29, 12, "#A0A0A0", "暂无", FONT_MAIN, 0.5, 0.5)
        return box
    end

    local itemIndex = 0
    if info.name ~= "" then
        if info.isTitle then
            itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(info.name) .. "[称号]"), 0)
            if itemIndex <= 0 then
                itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", info.name), 0)
            end
        else
            itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", info.name), 0)
        end
    end

    if itemIndex > 0 then
        GUI:setAnchorPoint(GUI:ItemShow_Create(box, "reward_item", 29, 29, {
            index = itemIndex,
            count = info.num > 0 and info.num or 1,
            look = true,
            movable = false,
            bgVisible = false,
        }), 0.5, 0.5)
    elseif info.isTitle then
        createText(box, "reward_title_text", 29, 29, 11, "#6CFF7B", tostring(info.name or "") .. "[称号]", FONT_MAIN, 0.5, 0.5)
    else
        createText(box, "reward_item_text", 29, 30, 12, "#F5E6C6", info.name, FONT_MAIN, 0.5, 0.5)
        if info.num > 0 then
            createText(box, "reward_item_num", 29, 13, 11, "#FFD66D", "x" .. tostring(info.num), FONT_MAIN, 0.5, 0.5)
        end
    end
    return box
end

local function renderShopRow(parent, npcid, idx, cfg, y)
    local row = GUI:Node_Create(parent, "row_" .. tostring(idx), 0, y)
    GUI:Image_Create(row, "divider", 0, 0, DIVIDER_SKIN)

    local rewardNode = GUI:Node_Create(row, "reward_node", 28, 12)
    renderRewardPreview(rewardNode, cfg)

    createText(row, "name_" .. idx, 102, 52, 21, "#F5E6C6", cfg.name or ("条目" .. tostring(idx)), FONT_TITLE, 0, 0.5)
    createText(row, "cost_" .. idx, 446, 46, 21, "#FF4A4A", tostring(toNumber(cfg.cost, 0)), FONT_TITLE, 0.5, 0.5)

    local limit = toNumber(cfg.limit, 0)
    local buyNum = getBuyCount(idx)
    local limitText = limit > 0 and string.format("%d/%d", buyNum, limit) or "不限"
    createText(row, "limit_" .. idx, 560, 46, 21, "#F2F2F2", limitText, FONT_TITLE, 0.5, 0.5)

    local btn = GUI:Button_Create(row, "buy_" .. idx, 622, 24, BUY_BTN_SKIN)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
    end)
end

local function renderSummary(node)
    local data = getPanelData()
    local cfg = getConfig()
    local titleCfg = cfg.title_reward or DEFAULT_CONFIG.title_reward
    local pointName = tostring(cfg.point_name or DEFAULT_CONFIG.point_name)

    local pointBg = GUI:Image_Create(node, "point_bg", 585, 426, "res/wy/public/tycccc.png")
    GUI:setContentSize(pointBg, 176, 40)
    createText(pointBg, "point_label", 16, 20, 21, "#FFE6A3", pointName .. "：", FONT_TITLE, 0, 0.5)
    createText(pointBg, "point_value", 156, 20, 24, "#FFF7DD", tostring(toNumber(data.point, 0)), FONT_TITLE, 1, 0.5)

    local hasTitle = toNumber(data.has_title, 0) == 1
    local bonusDone = toNumber(data.title_bonus_done, 0) == 1
    local titleName = tostring(titleCfg.name or DEFAULT_CONFIG.title_reward.name)
    local extraDesc = string.format("称号奖励：%s，对【%s】额外造成%d%%伤害", titleName, tostring(titleCfg.target or DEFAULT_CONFIG.title_reward.target), toNumber(titleCfg.damage_pct, DEFAULT_CONFIG.title_reward.damage_pct))
    createText(node, "title_desc", 44, 78, 21, "#FFD76B", extraDesc, FONT_TITLE, 0, 0.5)

    local levelText = string.format("%d级后等级+%d", toNumber(titleCfg.level_need, DEFAULT_CONFIG.title_reward.level_need), toNumber(titleCfg.level_add, DEFAULT_CONFIG.title_reward.level_add))
    local levelColor = bonusDone and "#6CFF7B" or (hasTitle and "#FFD65A" or "#A0A0A0")
    local stateText = bonusDone and "已发放" or (hasTitle and "待达到等级发放" or "未获得称号")
    createText(node, "level_desc", 44, 48, 18, levelColor, levelText .. "，" .. stateText, FONT_TITLE, 0, 0.5)
end

local function renderShopList(node, npcid)
    local shop = getShopList()
    if #shop <= 0 then
        createText(node, "empty_desc", 392, 210, 24, "#CFCFCF", "暂无可兑换内容", FONT_TITLE, 0.5, 0.5)
        return
    end

    for idx, cfg in ipairs(shop) do
        local rowY = SHOP_SCROLL_RECT.y + SHOP_SCROLL_RECT.height - idx * SHOP_ROW_HEIGHT
        renderShopRow(node, npcid, idx, cfg, rowY)
    end
end

local function renderMain(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    renderSummary(node)
    renderTableHeader(node)
    renderShopList(node, npcid)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 or p2 == 2 or p2 == 9 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node, npcid)
    end
end

return npc
