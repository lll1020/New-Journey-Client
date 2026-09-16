local npc = {}

npc._config = {
    id = 1030,
    name = "合成夜明珠",
    cost = {
        {"夜明珠", 1},
        {"金币", 880000},
        {"千年玄铁", 38},
    },
    ch = "诸邪退散",
}

local WINDOW_OPTS = {
    windowName = "npc_1030",
    background = {
        skin = "res/custom/all_story_mission/3/1030_bg.png"
    },
    closeButton = {
        x = 900,
        y = 390,
        skin = "res/wy/public/close_red_big.png",
    },
}

local function text(parent, name, x, y, size, color, value, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size or 20, color or "#FFFFFF", tostring(value or ""))
    GUI:setAnchorPoint(label, anchorX == nil and 0.5 or anchorX, anchorY == nil and 0.5 or anchorY)
    GUI:Text_setFontName(label, "fonts/502.ttf")
    GUI:Text_enableOutline(label, "#000000", 2)
    return label
end

local function itemIndex(name)
    return tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name) or 0) or 0
end

local function renderItem(parent, name, x, y, itemName, count)
    local box = GUI:Image_Create(parent, name .. "_box", x, y, "res/wy/public/70_70_k.png")
    GUI:setAnchorPoint(box, 0.5, 0.5)
    local index = itemIndex(itemName)
    if index > 0 then
        local item = GUI:ItemShow_Create(box, name .. "_item", 35, 35, {
            index = index,
            count = count or 1,
            look = true,
            movable = false,
            bgVisible = false,
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
    end
    text(parent, name .. "_name", x, y - 58, 17, "#F6E4B2", itemName, 0.5, 0.5)
    text(parent, name .. "_count", x, y - 80, 15, "#FFFFFF", "x" .. tostring(count or 1), 0.5, 0.5)
    return box
end

local function renderFormula(node, done)
    GUI:removeAllChildren(node)

    -- text(node, "title", 472, 465, 30, "#FFE9A5", "合成夜明珠", 0.5, 0.5)
    -- text(node, "formula_title", 472, 405, 20, "#D9D0C0", "合成公式", 0.5, 0.5)

    -- renderItem(node, "cost_1", 175, 300, "夜明珠", 1)
    -- text(node, "plus_1", 260, 300, 34, "#F4D179", "+", 0.5, 0.5)
    -- renderItem(node, "cost_2", 355, 300, "金币", 880000)
    -- text(node, "plus_2", 440, 300, 34, "#F4D179", "+", 0.5, 0.5)
    -- renderItem(node, "cost_3", 535, 300, "千年玄铁", 38)

    -- text(node, "equal", 635, 300, 36, "#F4D179", "=", 0.5, 0.5)
    -- renderItem(node, "reward", 770, 300, "诸邪退散（光环）", 1)

    -- if done then
    --     text(node, "done", 472, 145, 26, "#8CFF9B", "已完成", 0.5, 0.5)
    --     text(node, "done_desc", 472, 112, 17, "#D9D0C0", "该称号不可重复合成", 0.5, 0.5)
    --     return
    -- end

    -- local button = GUI:Button_Create(node, "compose", 472, 125, "res/public/1900000660.png")
    -- GUI:setAnchorPoint(button, 0.5, 0.5)
    -- GUI:Button_setTitleText(button, "立即合成")
    -- GUI:Button_setTitleFontName(button, "fonts/502.ttf")
    -- GUI:Button_setTitleFontSize(button, 20)
    -- GUI:Button_setTitleColor(button, "#FFE9A5")
    -- GUI:Button_titleEnableOutline(button, "#000000", 2)
    -- GUI:addOnClickEvent(button, function()
    --     SL:SendLuaNetMsg(100, npc.currentNpcid or npc._config.id, 1, 0, "")
    -- end)

    local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
    GUI:setPosition(cost, 410, 225)

    local kuang = GUI:Image_Create(node, "kuang2", 750 - 327, 105, "res/wy/public/70_70_k.png")
    UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))


    if done then
        GUI:Image_Create(node, "Button", 550, 30.00, "res/wy/public/7_1.png")
    else
        local Button= GUI:Button_Create(node, "Button", 550, 30.00, "res/custom/two_city/601_btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npc.currentNpcid or npc._config.id, 1, 0, "")
        end)
    end


end

local function ensureWindow(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, WINDOW_OPTS)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function refreshMainlineUi()
    if MainAssist and type(MainAssist.UpdateCurrentXylTaskWidget) == "function" then
        MainAssist.UpdateCurrentXylTaskWidget()
    end
    if MainAssist and type(MainAssist.RequestGrayWorldTaskIconRefresh) == "function" then
        MainAssist.RequestGrayWorldTaskIconRefresh()
    end
end

function npc.main(npcid, p2, p3, msgData)
    npc.currentNpcid = npcid
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderFormula(npc.node, tonumber(npc.data.done or 0) == 1)
    elseif p2 == 1 then
        npc.data = npc.data or {}
        npc.data.done = tonumber((SL:JsonDecode(msgData, false) or {}).done or p3 or 0) or 0
        if npc.node then
            renderFormula(npc.node, npc.data.done == 1 or tonumber(p3 or 0) == 2)
        end
        refreshMainlineUi()
    end
end

return npc

