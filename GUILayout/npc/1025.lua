local npc = {}

local RES = "res/custom/kuafu/跨服商店/"
local LEFT_RES = RES .. "左侧按钮/"

local function n(v, d)
    return tonumber(v or d or 0) or (d or 0)
end

local function data()
    return npc.data or {}
end

local function text(parent, name, x, y, size, color, value, ax, ay, font)
    local node = GUI:Text_Create(parent, name, x, y, size, color, tostring(value or ""))
    GUI:setAnchorPoint(node, ax or 0.5, ay or 0.5)
    GUI:Text_setFontName(node, font or "fonts/502.ttf")
    GUI:Text_enableOutline(node, "#000000", 2)
    return node
end

local function buttonText(btn, value)
    text(btn, "label", 52, 16, 18, "#FFF7E0", value, 0.5, 0.5, "fonts/font4.ttf")
end

local function rewardText(reward)
    if type(reward) ~= "table" or type(reward[1]) ~= "table" then
        return ""
    end
    return tostring(reward[1][1] or "") .. " x" .. tostring(reward[1][2] or 1)
end

local function renderPointPage(parent, npcid)
    GUI:Image_Create(parent, "top", 0, 172, RES .. "积分部分/顶端部分.png")
    text(parent, "point_title", 0, 197, 22, "#F4D179", "跨服积分领奖")
    text(parent, "point_value", 0, 152, 22, "#9FE2FF", "当前跨服积分：" .. tostring(n(data().point)))
    local rows = data().point_rewards or {}
    local y = 96
    for idx = 1, 4 do
        local row = rows[idx]
        if row then
            local itemBg = GUI:Image_Create(parent, "row_bg_" .. idx, 0, y, RES .. "积分部分/条形框.png")
            GUI:setAnchorPoint(itemBg, 0.5, 0.5)
            text(parent, "need_" .. idx, -180, y + 2, 18, "#F5E6C6", tostring(n(row.need)) .. "积分", 0, 0.5, "fonts/font4.ttf")
            text(parent, "reward_" .. idx, -20, y + 2, 18, "#FFD66A", rewardText(row.reward), 0, 0.5, "fonts/font4.ttf")
            local btn = GUI:Button_Create(parent, "claim_" .. idx, 220, y, RES .. "积分部分/领取.png")
            GUI:setAnchorPoint(btn, 0.5, 0.5)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
            end)
            y = y - 58
        end
    end
end

local function renderMedalPage(parent, npcid)
    GUI:Image_Create(parent, "top", 0, 172, RES .. "勋章部分/顶端部分.png")
    text(parent, "medal_title", 0, 197, 22, "#F4D179", "跨服勋章兑换")
    text(parent, "medal_value", 0, 152, 22, "#9FE2FF", tostring(data().medal_name or "跨服勋章") .. "：" .. tostring(n(data().medal)))
    local rows = data().medal_shop or {}
    local y = 96
    for idx = 1, 4 do
        local row = rows[idx]
        if row then
            local itemBg = GUI:Image_Create(parent, "row_bg_" .. idx, 0, y, RES .. "勋章部分/条形框.png")
            GUI:setAnchorPoint(itemBg, 0.5, 0.5)
            text(parent, "cost_" .. idx, -195, y + 2, 18, "#F5E6C6", tostring(n(row.cost)) .. "勋章", 0, 0.5, "fonts/font4.ttf")
            text(parent, "reward_" .. idx, -20, y + 2, 18, "#FFD66A", rewardText(row.reward), 0, 0.5, "fonts/font4.ttf")
            local limitText = n(row.limit) > 0 and ("限购 " .. tostring(n(row.limit))) or "不限购"
            text(parent, "limit_" .. idx, 125, y + 2, 16, "#B9F6C5", limitText, 0, 0.5, "fonts/font4.ttf")
            local btn = GUI:Button_Create(parent, "buy_" .. idx, 230, y, RES .. "勋章部分/兑换.png")
            GUI:setAnchorPoint(btn, 0.5, 0.5)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, npcid, 2, idx, SL:JsonEncode({idx = idx}, false))
            end)
            y = y - 58
        end
    end
end

local function renderPage(root, npcid)
    local content = GUI:Node_Create(root, "content", 190, 0)
    if npc.tab == 2 then
        renderMedalPage(content, npcid)
    else
        renderPointPage(content, npcid)
    end
end

function npc.main(npcid, link, msg, payload)
    if payload and payload ~= "" then
        npc.data = SL:JsonDecode(payload, false) or {}
    end
    npc.tab = npc.tab or 1
    local parent = GUI:GetWindow(nil, "npc_" .. npcid)
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
    end

    local mask = GUI:Image_Create(parent, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(mask, true)
    GUI:addOnClickEvent(mask, function()
        GUI:Win_Close(parent)
    end)

    local panel = GUI:Image_Create(parent, "panel", 0, 0, RES .. "面板底.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setTouchEnabled(panel, true)
    GUI:Image_Create(panel, "title", 0, 226, RES .. "标题.png")

    local pointBtn = GUI:Button_Create(panel, "tab_point", -275, 120, LEFT_RES .. "积分/" .. (npc.tab == 1 and "亮" or "暗") .. ".png")
    GUI:setAnchorPoint(pointBtn, 0.5, 0.5)
    GUI:addOnClickEvent(pointBtn, function()
        npc.tab = 1
        npc.main(npcid, 0, 0, payload)
    end)

    local medalBtn = GUI:Button_Create(panel, "tab_medal", -275, 40, LEFT_RES .. "勋章/" .. (npc.tab == 2 and "亮" or "暗") .. ".png")
    GUI:setAnchorPoint(medalBtn, 0.5, 0.5)
    GUI:addOnClickEvent(medalBtn, function()
        npc.tab = 2
        npc.main(npcid, 0, 0, payload)
    end)

    renderPage(panel, npcid)

    local close = GUI:Button_Create(panel, "close", 350, 230, "res/wy/public/close_red_big.png")
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
end

return npc
