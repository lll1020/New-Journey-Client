-- 第17号兑换NPC面板，基于 ui_helper.lua 重构
-- 提供双选项快捷兑换，统一布局注释
local npc = {}

npc._config = npc._config or {}

local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/duihuan/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/duihuan/title.png"},
}

local function createExchangeButton(parent, name, x, y, index, npcid)
    return NPC_UI_HELPER.createPrimaryButton(parent, name, x, y, "", function()
        SL:SendLuaNetMsg(100, npcid, index, 0, "")
    end, {skin = "res/custom/one_city/duihuan/btn.png", fontSize = 18, sound = false})
end

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
    opts.subTitle = "兑换说明"
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

-- 界面刷新逻辑
local function updateUI(npcid, node)
    if not node then
        return
    end
    GUI:removeAllChildren(node)


    -- 剩余兑换次数（兼容字段缺失）
    local data = npc.data or {}
    GUI:Text_Create(
        node, "hbdh1",
        670, 42 + 187,
        20, "#ffffff",
        (10 - (data.hbdh1 or 0)) .. "次"
    )
    GUI:Text_Create(
        node, "hbdh2",
        670, 42,
        20, "#ffffff",
            (10 - (data.hbdh2 or 0)) .. "次"
        )

    GUI:setAnchorPoint(GUI:ItemShow_Create(npc.bg, "item1", 70,300 - 187, { index = 1, look = true, bgVisible = false }),0.5, 0.5)
    GUI:setAnchorPoint(GUI:ItemShow_Create(npc.bg, "item2", 70 + 320,300 - 187, { index = 2, look = true, bgVisible = false }),0.5, 0.5)
    GUI:setAnchorPoint(GUI:ItemShow_Create(npc.bg, "item3", 70,300, { index = 3, look = true, bgVisible = false }),0.5, 0.5)
    GUI:setAnchorPoint(GUI:ItemShow_Create(npc.bg, "item4", 70 + 320,300, { index = 4, look = true, bgVisible = false }),0.5, 0.5)
    local num1 = GUI:TextAtlas_Create(npc.bg, "num1", 70 + 80,300 - 187 - 23, "1000", "res/custom/public/text1.png", 14, 30, ".")
    local num2 = GUI:TextAtlas_Create(npc.bg, "num2", 70 + 320+ 80,300 - 187 - 23, "1000", "res/custom/public/text1.png", 14, 30, ".")
    local num3 = GUI:TextAtlas_Create(npc.bg, "num3", 70+ 80,300 - 23, "1000", "res/custom/public/text1.png", 14, 30, ".")
    local num4 = GUI:TextAtlas_Create(npc.bg, "num4", 70 + 320+ 80,300 - 23, "1000", "res/custom/public/text1.png", 14, 30, ".")

    animateNumberTransition(0,1000000,0.2,20,function (value)    GUI:TextAtlas_setString(num1, tostring(value))end)
    animateNumberTransition(0,200000,0.2,20,function (value)    GUI:TextAtlas_setString(num2, tostring(value))end)
    animateNumberTransition(0,1000000,0.2,20,function (value)    GUI:TextAtlas_setString(num3, tostring(value))end)
    animateNumberTransition(0,200000,0.2,20,function (value)    GUI:TextAtlas_setString(num4, tostring(value))end)

    createExchangeButton(node, "Button1", 630, 260, 1, npcid)
    createExchangeButton(node, "Button2", 630, 70, 2, npcid)
    -- createExchangeButton(node, "Button3", 325, 180, 3, npcid)
    -- createExchangeButton(node, "Button4", 325, 110, 4, npcid)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then      -- 打开界面
        npc.data = SL:JsonDecode(msgData, false)
        local node = ensureWindow(npcid)
        updateUI(npcid, node)
    elseif p2 == 1 then  -- 仅刷新数据
        npc.data = SL:JsonDecode(msgData, false)
        updateUI(npcid, npc.node)
    end
end

return npc
