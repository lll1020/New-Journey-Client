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

-- 统一生成顶部说明文本，卖肉页和商店页分别复用不同说明。
local function createTipText(parent, name, text)
    local rich = GUI:RichText_Create(parent, name, 385, 455, tostring(text or ""), 360, 18, "#F8F8F8", 0, nil, nil, {
        outlineSize = 2,
        outlineColor = "#000000",
    })
    GUI:setAnchorPoint(rich, 0, 1)
    return rich
end

-- 卖肉页顶部说明，直接提示肉类来源和卖肉用途。
local function buildSellTipText()
    return table.concat({
        "<font color='#FFFFFF'>未来来！走过路过不要错过！小伙子，你</font><br>",
        "<font color='#FFFFFF'>若打到了肉，可</font><font color='#7CFB9A'>以卖我换取美食积分</font><font color='#FFFFFF'>，兑换奖励！</font>"
    }, "")
end

-- 商店页顶部说明，强调积分兑换与限购信息。
local function buildShopTipText()
    return table.concat({
        "<font color='#FFFFFF'>美食积分可</font><font color='#FFD27A'>兑换稀有材料与道具</font><font color='#FFFFFF'>，</font><br>",
        "<font color='#FFFFFF'>部分奖励存在</font><font color='#FF8F8F'>限购</font><font color='#FFFFFF'>，请按需求兑换。</font>"
    }, "")
end

-- 生成列表状态文案，卖肉与购买两页共用。
local function buildStateText(mode, enough, reachedLimit)
    if mode == "shop" then
        if reachedLimit then
            return "已售完", "#FF8F8F"
        end
        if not enough then
            return "积分不足", "#BFBFBF"
        end
        return "可购买", "#7CFB9A"
    end
    if not enough then
        return "数量不足", "#BFBFBF"
    end
    return "可出售", "#7CFB9A"
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

local renderMain

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
    createTipText(node, "sell_tip", buildSellTipText())
    createText(node, "point", 735, 440, 18, "#7CFB9A", "美食积分：" .. tostring(toNum(data.point, 0)), 1, 0.5)
    createText(node, "header_name", 468, 322, 19, "#79E3FF", "肉类", 0.5, 0.5)
    createText(node, "header_price", 611, 322, 19, "#FF9C9C", "回收价格", 0.5, 0.5)
    createText(node, "header_state", 720, 322, 19, "#7CFB9A", "是否售卖", 0.5, 0.5)
    local meats = data.meats or {}
    table.sort(meats, function(a, b)
        return toNum(a.point, 0) < toNum(b.point, 0)
    end)
    for i, one in ipairs(meats) do
        local y = 288 - (i - 1) * 59 - 54
        local itemIndex = toNum(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(one.name or "")), 0)
        if itemIndex > 0 then
            GUI:ItemShow_Create(node, "item_" .. i, 504 - 38, y + 14, {index = itemIndex, count = toNum(one.count, 0), look = true, bgVisible = true})
        end
        -- 每行补上肉类名称、积分收益和状态，避免只有按钮缺少信息。
        createText(node, "count_desc_" .. i, 494, y, 15, "#79E3FF", string.format("%s x%s", tostring(one.name or ""), tostring(toNum(one.count, 0))), 0, 0.5)
        createText(node, "point_desc_" .. i, 611, y + 14, 17, "#FFFFFF", string.format("美食积分*%s", tostring(toNum(one.point, 0))), 0.5, 0.5)
        local enough = toNum(one.count, 0) > 0
        local stateText, stateColor = buildStateText("sell", enough, false)
        createText(node, "state_desc_" .. i, 720, y + 14, 17, stateColor, stateText, 0.5, 0.5)
        local btn = GUI:Button_Create(node, "sell_btn_" .. i, 818 - 160, y  + 14, "res/custom/activity/屠夫/卖.png")
        GUI:addOnClickEvent(btn, function()
            if toNum(one.count, 0) <= 0 then
                SL:ShowSystemTips("该肉类数量不足")
                return
            end
            SL:SendLuaNetMsg(100, npcid, 1, 1, SL:JsonEncode({name = tostring(one.name or ""), count = 1}, false))
        end)
        if toNum(one.count, 0) <= 0 then
            GUI:setOpacity(btn, 150)
        end
    end
end

local function renderShopPage(node, npcid)
    local data = panelData()
    local point = toNum(data.point, 0)
    createTipText(node, "shop_tip", buildShopTipText())
    createText(node, "point", 735, 440, 18, "#7CFB9A", "美食积分：" .. tostring(point), 1, 0.5)
    createText(node, "shop_header_name", 468, 322, 19, "#79E3FF", "奖励", 0.5, 0.5)
    createText(node, "shop_header_cost", 611, 322, 19, "#FF9C9C", "积分消耗", 0.5, 0.5)
    createText(node, "shop_header_state", 720, 322, 19, "#7CFB9A", "兑换状态", 0.5, 0.5)
    local shop = data.shop or {}
    local buyMap = data.shop_buy or {}
    for i, one in ipairs(shop) do
        local y = 288 + (i - 1) * 59 - 54 - 59 * 2
        local reward = one.reward or {}
        local give = reward.give or {}
        local idx = toNum(one.idx, i)
        local itemName = tostring((give[1] or {})[1] or reward.name or one.name or "")
        local itemNum = toNum((give[1] or {})[2], 1)
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
        createText(node, "shop_limit_" .. i, 494, y, 15, "#79E3FF", limitText, 0, 0.5)
        createText(node, "shop_cost_" .. i, 611, y + 14, 16, "#FFE7A6", string.format("%s积分", tostring(cost)), 0.5, 0.5)
        local enough = point >= cost
        local reachedLimit = limit > 0 and buyNum >= limit
        local stateText, stateColor = buildStateText("shop", enough, reachedLimit)
        createText(node, "shop_state_" .. i, 720, y + 14, 16, stateColor, stateText, 0.5, 0.5)
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
            GUI:setOpacity(btn, 150)
        end
    end
end

-- 主渲染入口：切换标签页时直接重建内容，保证背景和列表状态同步。
renderMain = function(node, npcid)
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
