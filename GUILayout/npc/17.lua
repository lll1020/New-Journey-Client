-- 第17号兑换NPC面板，基于 ui_helper.lua 重构
-- 提供双选项快捷兑换，统一布局注释
local npc = {}

npc._config = npc._config or {}

local WINDOW_OPTS = {
    background = {skin = "res/wy/public/duihuan.png"},
    closeButton = {x = 930 - 204, y = 480 - 127},
}

local function createExchangeButton(parent, name, x, y, index, npcid)
    return NPC_UI_HELPER.createPrimaryButton(parent, name, x, y, "", function()
        SL:SendLuaNetMsg(100, npcid, index, 0, "")
    end, {skin = "res/wy/public/duihuan_an.png", fontSize = 18, sound = false})
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

    local titleX, titleY1, titleY2 = 410, 135, 80
    local textOffsetX, textOffsetY = 160, 5

    GUI:Image_Create(node, "duihuan_wz1", titleX, titleY1, "res/wy/public/duihuan_wz.png")
    GUI:Image_Create(node, "duihuan_wz2", titleX, titleY2, "res/wy/public/duihuan_wz.png")

    -- 剩余兑换次数（兼容字段缺失）
    local data = npc.data or {}
    GUI:Text_Create(
        node, "hbdh1",
        titleX + textOffsetX, textOffsetY + titleY1,
        20, "#ffffff",
        (10 - (data.hbdh1 or 0)) .. "次"
    )
    GUI:Text_Create(
        node, "hbdh2",
        titleX + textOffsetX, textOffsetY + titleY2,
        20, "#ffffff",
        (10 - (data.hbdh2 or 0)) .. "次"
    )

    local btnXRight = 470 + 200
    local btnXLeft  = 325
    local btnY1     = 30 + 150 - 12
    local btnY2     = 30 + 80

    createExchangeButton(node, "Button1", btnXRight, btnY1, 1, npcid)
    createExchangeButton(node, "Button2", btnXRight, btnY2, 2, npcid)
    createExchangeButton(node, "Button3", btnXLeft,  btnY1, 3, npcid)
    createExchangeButton(node, "Button4", btnXLeft,  btnY2, 4, npcid)
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
