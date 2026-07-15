local npc = {}

npc._config = teshudata["npc_108"] or {}

local SELL_BG = "res/custom/activity/屠夫/卖肉.png"
local SHOP_BG = "res/custom/activity/屠夫/收肉.png"
local TITLE_BG = "res/custom/activity/屠夫/标题.png"

local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 400, y = 300 - 77,},
}

local function cfg()
    return npc._config or {}
end

local function activityCfg()
    local cfg = teshudata and teshudata["anniu_507"] or {}
    return cfg.meishikuanghuan or cfg.mskh or {}
end

local function panelData()
    return npc.data or {}
end

local function toNum(v, d)
    local n = tonumber(v)
    if n == nil then
        return d or 0
    end
    return n
end

local function createText(parent, name, x, y, size, color, text, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(text or ""))
    GUI:setAnchorPoint(label, ax or 0, ay or 0.5)
    GUI:Text_enableOutline(label, "#000000", 2)
    return label
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, cfg())
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    GUI:setLocalZOrder(npc._window.node, 99)
    GUI:removeAllChildren(npc.bg)
    npc.panel = GUI:Image_Create(npc.bg, "panel", 0, 0, SELL_BG)
    GUI:setTouchEnabled(npc.panel, true)
    GUI:setAnchorPoint(npc.panel, 0.5, 0.5)
    GUI:Image_Create(npc.panel, "title_img", 56 + 35, 464, TITLE_BG)
    local closeBtn = GUI:Button_Create(npc.panel, 'close', 750, 470, 'res/wy/public/close_red_big.png')
    GUI:setTouchEnabled(closeBtn, true)
    GUI:setLocalZOrder(closeBtn, 100)
    GUI:addOnClickEvent(closeBtn, function()
        NPC_UI_HELPER.closeWindow(npc._window)
    end)
    npc.node = GUI:Node_Create(npc.bg, "node", -415, -328)
    return npc.node
end

local function currentTab(npcid)
    local data = panelData()
    local tab = tostring(npc.tab or data.current_tab or cfg().default_tab or "sell")
    if tab ~= "shop" then
        tab = "sell"
    end
    npc.tab = tab
    return tab
end

local function refreshPanelSkin(npcid)
    if not npc.panel then
        return
    end
    local skin = currentTab(npcid) == "shop" and SHOP_BG or SELL_BG
    GUI:Image_loadTexture(npc.panel, skin)
end

local function renderTabButtons(node, npcid)
    local tab = currentTab(npcid)
    local leftSell = tab == "sell" and "亮" or "暗"
    local leftShop = tab == "shop" and "亮" or "暗"
    local sellBtn = GUI:Button_Create(node, "tab_sell", 10, 350, string.format("res/custom/activity/屠夫/左侧按钮/%s/卖肉.png", leftSell))
    local shopBtn = GUI:Button_Create(node, "tab_shop", 10, 228, string.format("res/custom/activity/屠夫/左侧按钮/%s/商店.png", leftShop))
    GUI:addOnClickEvent(sellBtn, function()
        npc.tab = "sell"
        renderMain(npc.node, npcid)
    end)
    GUI:addOnClickEvent(shopBtn, function()
        npc.tab = "shop"
        renderMain(npc.node, npcid)
    end)
end

local function renderSellPage(node, npcid)
    local data = panelData()
    createText(node, "point", 650, 405 + 130, 18, "#7CFB9A", "美食积分：" .. tostring(toNum(data.point, 0)), 1, 0.5)
    local counts = data.meat_counts or {}
    if next(counts) == nil and type(data.meats) == "table" then
        for _, one in ipairs(data.meats) do
            counts[tostring(one.name or "")] = toNum(one.count, 0)
        end
    end
    local meats = {}
    for itemName, one in pairs(activityCfg().meats or {}) do
        meats[#meats + 1] = {
            name = itemName,
            point = toNum(one.point, 0),
            count = toNum(counts[itemName], 0),
        }
    end
    table.sort(meats, function(a, b)
        return toNum(a.point, 0) < toNum(b.point, 0)
    end)
    for i, one in ipairs(meats) do
        local y = 288 - (i - 1) * 59 - 54
        local itemIndex = toNum(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(one.name or "")), 0)
        if itemIndex > 0 then
            GUI:ItemShow_Create(node, "item_" .. i, 504 - 38, y + 14, {index = itemIndex, count = toNum(one.count, 0), look = true, bgVisible = true})
        end
        -- createText(node, "point_desc_" .. i, 682, y + 15, 18, "#FFFFFF", string.format("美食积分*%s", tostring(toNum(one.point, 0))), 0.5, 0.5)
        createText(node, "count_desc_" .. i, 504 - 38, y, 15, "#79E3FF", string.format("%s x%s", tostring(one.name or ""), tostring(toNum(one.count, 0))), 0, 0.5)
        local btn = GUI:Button_Create(node, "sell_btn_" .. i, 818 - 160, y  + 14, "res/custom/activity/屠夫/卖.png")
        GUI:addOnClickEvent(btn, function()
            if toNum(one.count, 0) <= 0 then
                SL:ShowSystemTips("该肉类数量不足")
                return
            end
            SL:SendLuaNetMsg(100, npcid, 1, 1, SL:JsonEncode({name = tostring(one.name or ""), count = 1}, false))
        end)
        if toNum(one.count, 0) <= 0 then
            -- GUI:setOpacity(btn, 150)
        end
    end
end

local function renderShopPage(node, npcid)
    local data = panelData()
    local point = toNum(data.point, 0)
    createText(node, "point", 650, 405 + 130, 18, "#7CFB9A", "美食积分：" .. tostring(point), 1, 0.5)
    local shop = activityCfg().shop or {}
    local buyMap = data.shop_buy or {}
    for i, one in ipairs(shop) do
        local y = 288 + (i - 1) * 59 - 54 - 59 * 2
        local reward = one.reward or {}
        local give = reward.give or {}
        local idx = toNum(one.idx, i)
        local itemName = tostring((give[1] or {})[1] or reward.name or one.name or "")
        local itemNum = toNum((give[1] or {})[2], 1)
        if itemName == "美食家" then
            itemName = "美食家[称号]"
        end
        local itemIndex = toNum(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName), 0)
        if itemIndex > 0 then
            GUI:ItemShow_Create(node, "shop_item_" .. i, 504 - 38, y + 14, {index = itemIndex, count = itemNum, look = true, bgVisible = true})
        else
            createText(node, "shop_name_" .. i, 504 - 38, y + 14, 18, "#FFD27A", itemName, 0.5, 0.5)
        end
        local cost = toNum(one.cost, 0)
        local limit = toNum(one.limit, 0)
        local buyNum = toNum(buyMap[tostring(idx)] or buyMap[idx] or buyMap[tostring(i)] or buyMap[i], 0)
        local limitText = limit > 0 and string.format("%s %s/%s", tostring(one.name or ""), tostring(buyNum), tostring(limit)) or tostring(one.name or "")
        -- createText(node, "shop_limit_" .. i, 504 - 38, y, 15, "#79E3FF", limitText, 0, 0.5)
        -- createText(node, "shop_cost_" .. i, 650, y + 14, 16, "#FFE7A6", string.format("消耗:%s积分", tostring(cost)), 0.5, 0.5)
        local btn = GUI:Button_Create(node, "buy_btn_" .. i, 818 - 160, y  + 14, "res/custom/activity/屠夫/购买.png")
        GUI:addOnClickEvent(btn, function()
            if limit > 0 and buyNum >= limit then
                SL:ShowSystemTips("该奖励已达到兑换上限")
                return
            end
            if point < cost then
                SL:ShowSystemTips("美食积分不足")
                return
            end
            SL:SendLuaNetMsg(100, npcid, 2, idx, SL:JsonEncode({idx = idx}, false))
        end)
        if (limit > 0 and buyNum >= limit) or (point < cost) then
            -- GUI:setOpacity(btn, 150)
        end
    end
end

function renderMain(node, npcid)
    if not node then
        return
    end
    refreshPanelSkin(npcid)
    GUI:removeAllChildren(node)
    renderTabButtons(node, npcid)
    if currentTab(npcid) == "shop" then
        renderShopPage(node, npcid)
    else
        renderSellPage(node, npcid)
    end
end

function npc.main(npcid, p2, p3, msgData)
    if msgData and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or {}
    else
        npc.data = npc.data or {}
    end
    npc.tab = tostring((npc.data and npc.data.current_tab) or npc.tab or cfg().default_tab or "sell")
    if p2 == 0 then
        ensureWindow(npcid)
    end
    renderMain(npc.node, npcid)
end

return npc
