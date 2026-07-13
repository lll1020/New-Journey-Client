local npc = {}

local RES = "res/custom/kuafu/跨服商店/"
local LEFT_RES = RES .. "左侧按钮/"
local FONT_TITLE = "fonts/502.ttf"
local FONT_MAIN = "fonts/font4.ttf"

local PANEL_SKIN = RES .. "面板底.png"
local TITLE_SKIN = RES .. "标题.png"
local SPLIT_SKIN = RES .. "分割线-.png"
local SCROLL_TIP_SKIN = RES .. "上下滑动查看全部.png"
local ITEM_BOX_SKIN = RES .. "装备框-.png"

local TAB_POS = {
    point = {x = -355, y = 36},
    medal = {x = -355, y = 126},
}

local BG_POS = {
    x = 69,
    y = 18,
}

local LIST_VIEW = {
    x = 236,
    y = 14,
    w = 436,
    h = 344,
}
local POINT_TIP_SKIN = "res/wy/public/npc_81_tip.png"
local POINT_GAIN_TIP = "1.武道大会对战结算。\n2.武道大会周排行结算。\n3.跨服沙巴克固定奖励。"

local ROW_H = 74

local function n(v, d)
    return tonumber(v or d or 0) or (d or 0)
end

local function decodePayload(payload)
    if payload and payload ~= "" then
        npc.data = SL:JsonDecode(payload, false) or {}
    end
    return npc.data or {}
end

local function text(parent, name, x, y, size, color, value, ax, ay, font)
    local node = GUI:Text_Create(parent, name, x, y, size, color, tostring(value or ""))
    GUI:setAnchorPoint(node, ax or 0.5, ay or 0.5)
    GUI:Text_setFontName(node, font or FONT_TITLE)
    GUI:Text_enableOutline(node, "#000000", 2)
    return node
end

local function getRewardName(entry)
    if type(entry) ~= "table" then
        return ""
    end
    if entry.name then
        return tostring(entry.name)
    end
    if entry[1] then
        return tostring(entry[1])
    end
    return ""
end

local function getRewardCount(entry)
    if type(entry) ~= "table" then
        return 1
    end
    if entry.count then
        return n(entry.count, 1)
    end
    if entry[2] then
        return n(entry[2], 1)
    end
    return 1
end

local function getRewardIcon(entry)
    if type(entry) ~= "table" then
        return nil
    end
    return entry.icon or entry.icon_path or entry.skin
end

local function getRewardIndex(entry)
    local name = getRewardName(entry)
    if name == "" then
        return nil
    end
    return SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
end

local function getRowReward(row)
    local reward = row and row.reward
    if type(reward) == "table" and type(reward[1]) == "table" then
        return reward[1]
    end
    return reward
end

local function createTabButton(parent, name, x, y, group, selected, callback)
    local skin = LEFT_RES .. group .. "/" .. (selected and "亮" or "暗") .. ".png"
    local btn = GUI:Button_Create(parent, name, x, y, skin)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, callback)
    return btn
end

local function createItemPreview(parent, name, x, y, reward)
    local holder = GUI:Node_Create(parent, name, x, y)
    local box = GUI:Image_Create(holder, "box", 0, 0, ITEM_BOX_SKIN)
    GUI:setAnchorPoint(box, 0.5, 0.5)

    local itemIndex = getRewardIndex(reward)
    if itemIndex then
        local item = GUI:ItemShow_Create(holder, "item", 0, 0, {
            index = itemIndex,
            count = getRewardCount(reward),
            look = true,
            movable = false,
            bgVisible = false,
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        local icon = getRewardIcon(reward)
        if icon and icon ~= "" then
            local iconNode = GUI:Image_Create(holder, "icon", 0, 0, icon)
            GUI:setAnchorPoint(iconNode, 0.5, 0.5)
        else
            text(holder, "name", 0, 0, 16, "#F6D08A", getRewardName(reward), 0.5, 0.5, FONT_MAIN)
        end
    end
    local count = getRewardCount(reward)
    -- text(holder, "count", 23, -23, 16, "#FFD66A", "x" .. tostring(count), 1, 0.5, FONT_MAIN)
    return holder
end

local function createHeader(parent, tab, pointValue)
    local title = GUI:Image_Create(parent, "title", 366 - 262, 420 + 42, TITLE_SKIN)

    parent = GUI:Node_Create(parent, "parent", 0, 0 - 390)
    GUI:setAnchorPoint(title, 0.5, 0.5)
    local prefix = tab == 1 and "当前一共获得了：" or "当前拥有："
    local suffix = tab == 1 and "跨服积分" or "跨服勋章"
    text(parent, "prefix", 350, 420, 18, "#F8E8C7", prefix, 1, 0.5, FONT_TITLE)
    local bg = GUI:Image_Create(parent, "value_bg", 452, 420, "res/public/1900000668.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setOpacity(bg, 120)
    text(parent, "value", 452, 420, 18, "#FFFFFF", tostring(pointValue), 0.5, 0.5, FONT_MAIN)
    text(parent, "suffix", 560, 420, 18, "#F8E8C7", suffix, 0, 0.5, FONT_TITLE)
end

local function createColumnHeaders(parent, tab)
--     text(parent, "head_item", 274, 380, 20, "#F8E8C7", "道具", 0.5, 0.5, FONT_TITLE)
--     text(parent, "head_cost", 474, 380, 20, "#F8E8C7", tab == 1 and "所需积分" or "所需勋章", 0.5, 0.5, FONT_TITLE)
--     text(parent, "head_btn", 644, 380, 20, "#F8E8C7", tab == 1 and "领取按钮" or "兑换按钮", 0.5, 0.5, FONT_TITLE)
end

local function createListView(parent)
    local list = GUI:ScrollView_Create(parent, "list", LIST_VIEW.x - 10, LIST_VIEW.y + 50, LIST_VIEW.w + 20, LIST_VIEW.h, 1)
    GUI:ScrollView_setClippingEnabled(list, true)
    return list
end

local function renderRows(list, npcid, tab, rows)
    local count = #rows
    local innerH = math.max(LIST_VIEW.h, count * ROW_H + 10)
    GUI:ScrollView_setInnerContainerSize(list, LIST_VIEW.w, innerH)

    for i, row in ipairs(rows) do
        local y = innerH - (i - 0.5) * ROW_H
        local rowNode = GUI:Node_Create(list, "row_" .. i, LIST_VIEW.w / 2, y)

        local line = GUI:Image_Create(rowNode, "line", 0, -34, SPLIT_SKIN)
        GUI:setAnchorPoint(line, 0.5, 0.5)

        local reward = getRowReward(row)
        createItemPreview(rowNode, "item_" .. i, -188, 0, reward)

        local rewardName = getRewardName(reward)
        -- text(rowNode, "reward_name_" .. i, -128, 12, 18, "#F5E6C6", rewardName, 0, 0.5, FONT_MAIN)
        -- text(rowNode, "reward_count_" .. i, -128, -14, 16, "#FFD66A", "x" .. tostring(getRewardCount(reward)), 0, 0.5, FONT_MAIN)

        local costValue = tab == 1 and n(row.need) or n(row.cost)
        local costLabel = tab == 1 and "积分" or "勋章"
        text(rowNode, "cost_" .. i, 96 - 100 - 8, 0, 20, "#F8E8C7", tostring(costValue) .. costLabel, 0.5, 0.5, FONT_MAIN)

        if tab == 2 then
            local limitText = n(row.limit) > 0 and ("限购 " .. tostring(n(row.limit))) or "不限购"
            text(rowNode, "limit_" .. i, 96, -22, 15, "#8DF0B0", limitText, 0.5, 0.5, FONT_MAIN)
        end

        local btnSkin = tab == 1 and (RES .. "积分部分/领取.png") or (RES .. "勋章部分/兑换.png")
        local btn = GUI:Button_Create(rowNode, "btn_" .. i, 206 - 48 + 10, 0, btnSkin)
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:addOnClickEvent(btn, function()
            local action = tab == 1 and 1 or 2
            SL:SendLuaNetMsg(100, npcid, action, i, SL:JsonEncode({idx = i}, false))
        end)
    end
end

local function renderPage(panel, npcid)
    local info = npc.data or {}
    local tab = npc.tab or 1
    local bgSkin = tab == 1 and (RES .. "积分部分/积分背景.png") or (RES .. "勋章部分/勋章背景.png")
    local bg = GUI:Image_Create(panel, "page_bg", BG_POS.x, BG_POS.y, bgSkin)
    GUI:setAnchorPoint(bg, 0, 0)

    createHeader(bg, tab, tab == 1 and n(info.point) or n(info.medal))
    createColumnHeaders(bg, tab)
    local tip = GUI:Image_Create(bg, "scroll_tip", 702 + 20 - 10, 182 + 50, SCROLL_TIP_SKIN)
    GUI:setAnchorPoint(tip, 0.5, 0.5)

    local pointTip = GUI:Image_Create(bg, "point_gain_tip", 650 - 600, 34, POINT_TIP_SKIN)
    GUI:setAnchorPoint(pointTip, 0.5, 0.5)
    GUI:setTouchEnabled(pointTip, true)
    tip_node(pointTip, POINT_GAIN_TIP)

    local list = createListView(bg)
    local rows = tab == 1 and (info.point_rewards or {}) or (info.medal_shop or {})
    renderRows(list, npcid, tab, rows)
end

function npc.main(npcid, link, msg, payload)
    decodePayload(payload)
    npc.tab = npc.tab or 1

    local win = GUI:GetWindow(nil, "npc_" .. npcid)
    if win then
        GUI:removeAllChildren(win)
        GUI:setPosition(win, cogin.w / 2, cogin.h / 2)
    else
        win = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
    end

    local mask = GUI:Image_Create(win, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(mask, true)
    GUI:addOnClickEvent(mask, function()
        GUI:Win_Close(win)
    end)

    local panel = GUI:Image_Create(win, "panel", 0, 0, PANEL_SKIN)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setTouchEnabled(panel, true)

    createTabButton(panel, "tab_medal", TAB_POS.medal.x, TAB_POS.medal.y, "勋章", npc.tab == 2, function()
        if npc.tab ~= 2 then
            npc.tab = 2
            npc.main(npcid, 0, 0, payload)
        end
    end)

    createTabButton(panel, "tab_point", TAB_POS.point.x, TAB_POS.point.y, "积分", npc.tab == 1, function()
        if npc.tab ~= 1 then
            npc.tab = 1
            npc.main(npcid, 0, 0, payload)
        end
    end)

    renderPage(panel, npcid)

    local close = GUI:Button_Create(panel, "close", 0 + 800, 58 + 443, "res/wy/public/close_red_big.png")
    GUI:setAnchorPoint(close, 0.5, 0.5)
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(win)
    end)
end

return npc
