local npc = {}

local RES = "res/custom/kuafu/跨服商店/"
local FONT_TITLE = "fonts/502.ttf"
local FONT_MAIN = "fonts/font4.ttf"

local PANEL_SKIN = RES .. "面板底.png"
local TITLE_SKIN = RES .. "标题.png"
local SPLIT_SKIN = RES .. "分割线-.png"
local SCROLL_TIP_SKIN = RES .. "上下滑动查看全部.png"
local ITEM_BOX_SKIN = RES .. "装备框-.png"

local BG_POS = {
    x = 69,
    y = 18,
}

local LIST_VIEW = {
    x = 226,
    y = 58,
    w = 448,
    h = 302,
}

local ROW_H = 74
local POINT_TIP_SKIN = "res/wy/public/npc_81_tip.png"
local POINT_GAIN_TIP = "1.跨服地图中怪物掉落"

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
        text(holder, "name", 0, 0, 16, "#F6D08A", getRewardName(reward), 0.5, 0.5, FONT_MAIN)
    end
    text(holder, "count", 22, -22, 16, "#FFD66A", "x" .. tostring(getRewardCount(reward)), 1, 0.5, FONT_MAIN)
    return holder
end

local function createHeader(parent, medalCount, medalName)
    local title = GUI:Image_Create(parent, "title", 104, 462, TITLE_SKIN)
    GUI:setAnchorPoint(title, 0.5, 0.5)
    text(parent, "prefix", 352, 28, 18, "#F8E8C7", "当前拥有：", 1, 0.5, FONT_TITLE)
    local bg = GUI:Image_Create(parent, "value_bg", 454, 28, "res/public/1900000668.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setOpacity(bg, 120)
    text(parent, "value", 454, 28, 18, "#FFFFFF", tostring(medalCount), 0.5, 0.5, FONT_MAIN)
    text(parent, "suffix", 562, 28, 18, "#F8E8C7", tostring(medalName or "跨服勋章"), 0, 0.5, FONT_TITLE)
end

local function createColumnHeaders(parent)
    -- text(parent, "head_item", 286, 396, 20, "#F8E8C7", "勋章兑换", 0.5, 0.5, FONT_TITLE)
    -- text(parent, "head_cost", 478, 396, 20, "#F8E8C7", "所需勋章", 0.5, 0.5, FONT_TITLE)
    -- text(parent, "head_btn", 650, 396, 20, "#F8E8C7", "每日限购", 0.5, 0.5, FONT_TITLE)
end

local function createListView(parent)
    local list = GUI:ScrollView_Create(parent, "list", LIST_VIEW.x, LIST_VIEW.y+ 40, LIST_VIEW.w, LIST_VIEW.h, 1)
    GUI:ScrollView_setClippingEnabled(list, true)
    return list
end

local function renderRows(list, npcid, rows)
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
        -- text(rowNode, "reward_name_" .. i, -132, 10, 18, "#F5E6C6", getRewardName(reward), 0, 0.5, FONT_MAIN)
        text(rowNode, "cost_" .. i, 2 - 90, 0, 20, "#F8E8C7", tostring(n(row.cost)) .. "勋章", 0.5, 0.5, FONT_MAIN)

        local limitText = n(row.limit) > 0 and ("限购 " .. tostring(n(row.limit))) or "不限购"
        -- text(rowNode, "limit_" .. i, 2, -18, 15, "#8DF0B0", limitText, 0.5, 0.5, FONT_MAIN)
        text(rowNode, "limit_" .. i, 2 + 35, 0, 20, "#8DF0B0", limitText, 0.5, 0.5, FONT_MAIN)

        local btn = GUI:Button_Create(rowNode, "btn_" .. i, 176 - 15, 0, RES .. "勋章部分/兑换.png")
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, npcid, 1, i, SL:JsonEncode({idx = i}, false))
        end)
    end
end

local function renderPage(panel, npcid)
    local info = npc.data or {}
    local bg = GUI:Image_Create(panel, "page_bg", BG_POS.x, BG_POS.y, RES .. "勋章部分/勋章背景.png")
    GUI:setAnchorPoint(bg, 0, 0)

    createHeader(bg, n(info.medal), info.medal_name)
    createColumnHeaders(bg)

    local tip = GUI:Image_Create(bg, "scroll_tip", 722, 210, SCROLL_TIP_SKIN)
    GUI:setAnchorPoint(tip, 0.5, 0.5)

    local list = createListView(bg)
    renderRows(list, npcid, info.shop or {})

    local pointTip = GUI:Image_Create(bg, "point_gain_tip", 650 - 600, 34, POINT_TIP_SKIN)
    GUI:setAnchorPoint(pointTip, 0.5, 0.5)
    GUI:setTouchEnabled(pointTip, true)
    tip_node(pointTip, POINT_GAIN_TIP)
end

function npc.main(npcid, link, msg, payload)
    decodePayload(payload)

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

    renderPage(panel, npcid)

    local close = GUI:Button_Create(panel, "close", 800, 501, "res/wy/public/close_red_big.png")
    GUI:setAnchorPoint(close, 0.5, 0.5)
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(win)
    end)
end

return npc
