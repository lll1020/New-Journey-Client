local npc = {}

npc._config = teshudata["npc_75"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/zbjf/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/zbjf/title.png"},
}

local function ensureWindow(npcId)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcId, npc._config)
    opts.subTitle = npc._config and npc._config.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcId, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function getEquipName(where)
    return Player:getEquipNameByPos(where) or ""
end

local function canUpgrade(detail)
    local equipName = getEquipName(detail.where)
    return equipName == detail.now, equipName
end

local function isUpgraded(detail)
    return getEquipName(detail.where) == detail.give
end

local function renderTab(node, npcId, idx)
    if not node then
        return
    end

    GUI:removeAllChildren(node)
    local detail = npc._config.details[idx]
    if not detail then
        return
    end

    local ready, equipName = canUpgrade(detail)
    local upgraded = equipName == detail.give

    -- GUI:Text_setFontName(GUI:Text_Create(node, "name", 389, 290, 24, "#FFF2B0", detail.name or ""), "fonts/500.ttf")
    -- GUI:Text_setFontName(GUI:Text_Create(node, "need", 389, 256, 20, "#F8E6B8", "需求装备：" .. tostring(detail.now or "")), "fonts/500.ttf")

    -- local currentColor = upgraded and "#00FF00" or (ready and "#00FF00" or "#FF5A5A")
    -- GUI:Text_setFontName(GUI:Text_Create(node, "current", 389, 226, 18, currentColor,
    --     "当前穿戴：" .. (equipName ~= "" and equipName or "未穿戴")), "fonts/font4.ttf")

    local rewardNode = GUI:Node_Create(node, "reward_node", 280 + 80, 120 + 97)
    ItemNumByTable_img_new({{detail.give, 1}}, nil, rewardNode)

    local costNode = GUI:Node_Create(node, "cost_node", 232, 130)
    checkItemNumByTable_img_kuang(detail.cost or {}, nil, costNode)

    if upgraded then
        GUI:Image_Create(node, "done", 389, 8, "res/wy/public/10_2.png")
    else
        local button = GUI:Button_Create(node, "upgrade", 389, 8, "res/custom/five_city/zbjf/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0)
        -- GUI:setTouchEnabled(button, ready)
        -- GUI:Button_setBright(button, ready)
        GUI:addOnClickEvent(button, function()
            SL:SendLuaNetMsg(100, npcId, 1, 0, SL:JsonEncode({idx = idx}, false))
        end)
    end
end

local function renderMain(node, npcId)
    if not node then
        return
    end

    GUI:removeAllChildren(node)
    npc.titles_sign = npc.titles_sign or 1
    npc.tabNode = GUI:Node_Create(node, "tab_node", 0, 0)

    for i = 1, 4 do
        local button = GUI:Button_Create(node, "item" .. i, 27 + (i - 1) * 182, 330,
            "res/custom/five_city/zbjf/" .. (npc.titles_sign == i and "l" or "n") .. "_" .. i .. ".png")
        GUI:addOnClickEvent(button, function()
            GUI:Button_loadTextureNormal(GUI:ui_delegate(node)["item" .. npc.titles_sign],
                "res/custom/five_city/zbjf/n_" .. npc.titles_sign .. ".png")
            npc.titles_sign = i
            GUI:Button_loadTextureNormal(button, "res/custom/five_city/zbjf/l_" .. i .. ".png")
            renderTab(npc.tabNode, npcId, i)
        end)
    end

    renderTab(npc.tabNode, npcId, npc.titles_sign)
end

function npc.main(npcId, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcId)
        renderMain(npc.node, npcId)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        renderTab(npc.tabNode, npcId, npc.titles_sign or 1)
    end
end

return npc
