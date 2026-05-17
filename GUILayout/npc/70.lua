local npc = {}

npc._config = teshudata["npc_70"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/emjg/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/emjg/title.png"},
}

local COST_POS = {
    {x = 438, y = 172},
    {x = 102, y = 172},
}

local ITEM_POS = {
    {x = 114, y = 245},
    {x = 265, y = 245},
    {x = 416, y = 245},
    {x = 567, y = 245},
}

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

-- 统一创建描边文字，减少酒馆面板重复样式代码。
local function createStrokeText(parent, name, x, y, size, color, text, anchorX, anchorY, fontName)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:setAnchorPoint(label, anchorX == nil and 0.5 or anchorX, anchorY == nil and 0.5 or anchorY)
    GUI:Text_setFontName(label, fontName or "fonts/font4.ttf")
    GUI:Text_enableOutline(label, "#100808", 2)
    return label
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
    opts.subTitle = npc._config and npc._config.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function normalizeData(data)
    data = type(data) == "table" and data or {}
    data.num = toNumber(data.num, 0)
    return data
end

local function getWeightText()
    local weight = npc._config and npc._config.weight or {}
    local right = tostring(weight[2] or "")
    if right == "" then
        return "万年仙酒：100%"
    end

    local nameMap = {
        ["4"] = "万年仙酒",
        ["3"] = "千年仙酒",
        ["2"] = "百年仙酒",
        ["1"] = "十年仙酒",
    }

    local textList = {}
    for part in string.gmatch(right, "[^|]+") do
        local id, rate = string.match(part, "(%d+)%#(%d+)")
        if id and rate then
            table.insert(textList, string.format("%s %s%%", nameMap[id] or ("奖池" .. tostring(id)), tostring(rate)))
        end
    end

    return table.concat(textList, "  ")
end

-- 酒葫芦已满时客户端直接灰掉按钮，避免继续重复点击。
local function canDrink()
    return npc.data.num < toNumber((npc._config and npc._config.max_zuiyi) or 100, 100)
end

local function renderRewardPool(node)
    for idx, pos in ipairs(ITEM_POS) do
        local detail = npc._config.details and npc._config.details[idx] or nil
        if detail then
            local frame = GUI:Image_Create(node, "reward_frame_" .. idx, pos.x, pos.y, "res/custom/five_city/emjg/kuang.png")
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", detail.cost[1][1])
            local item = GUI:ItemShow_Create(frame, "item_" .. idx, 71, 76, {
                index = itemIndex,
                look = true,
                bgVisible = false
            })
            GUI:setAnchorPoint(item, 0.5, 0.5)
            createStrokeText(frame, "reward_num_" .. idx, 71, 30, 16, "#FFE89C", string.format("+%s醉酒值", tostring(detail.num or 0)), 0.5, 0.5)
        end
    end
end

local function renderCostAndButton(node, npcid, idx)
    local cost = npc._config.cost and npc._config.cost[idx] or {}
    local costNode = GUI:Node_Create(node, "cost_node_" .. idx, 0, 0)
    local costShow = checkItemNumByTable_img_kuang(cost, nil, costNode)
    GUI:setPosition(costShow, COST_POS[idx].x, COST_POS[idx].y)

    local button = GUI:Button_Create(node, "drink_btn_" .. idx, idx == 1 and 461 or 121, 56, "res/custom/five_city/emjg/btn_" .. idx .. ".png")
    local enable = canDrink()
    GUI:Button_setGrey(button, not enable)
    GUI:setTouchEnabled(button, enable)
    if enable then
        GUI:addOnClickEvent(button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = idx}, false))
        end)
        if checkItemNum(cost) then
            NPC_UI_HELPER.redpoint_create(button)
        end
    end
end

function renderMain(node, npcid)
    if not node then
        return
    end

    GUI:removeAllChildren(node)

    renderRewardPool(node)
    renderCostAndButton(node, npcid, 1)
    renderCostAndButton(node, npcid, 2)

    -- createStrokeText(node, "weight_text", 390, 32, 18, "#FF3E36", getWeightText(), 0.5, 0.5, "fonts/500.ttf")
    createStrokeText(
        node,
        "full_tip",
        391,
        486,
        18,
        canDrink() and "#DDEBFF" or "#FF7B7B",
        canDrink() and "醉酒值满100，即可开启“醉酒狂魔斩”" or "醉酒值已满，无法继续饮酒",
        0.5,
        0.5,
        "fonts/500.ttf"
    )

    GUI:TextAtlas_Create(node, "drunk_value", 190, 32, tostring(npc.data.num), "res/custom/public/text1.png", 14, 30, ".")
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 or p2 == 1 then
        npc.data = normalizeData(SL:JsonDecode(msgData, false))
        ensureWindow(npcid)
        renderMain(npc.node, npcid)
    end
end

return npc
