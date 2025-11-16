-- 兑换面板
-- npc名称 / npc功能
local npc = {}

npc._config = npc._config or {}

-- 创建兑换按钮
local function createExchangeButton(parent, name, x, y, index, npcid)
    local btn = GUI:Button_Create(parent, name, x, y, "res/wy/public/duihuan_an.png")
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, index, 0, "")
    end)
    return btn
end

-- 创建窗口和背景
local function createWindow(npcid, msgData)
    npc.data = SL:JsonDecode(msgData, false)

    local parent = GUI:GetWindow(nil, "npc_" .. npcid)
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create(
            "npc_" .. npcid,
            cogin.w / 2, cogin.h / 2,
            0, 0,
            false, false, true, true, true,
            npcid, 1
        )
    end

    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(bjt, true)
    GUI:addOnClickEvent(bjt, function()
        GUI:Win_Close(parent)
    end)

    npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, "res/wy/public/duihuan.png")
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)
    GUI:Timeline_Window1(npc.bg)

    local close = GUI:Button_Create(npc.bg, "close", 930 - 204, 480 - 127, "res/wy/public/close.png")
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)

    npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
    return npc.node
end

-- 界面渲染
local function updateUI(npcid, node)
    GUI:removeAllChildren(node)

    local titleX, titleY1, titleY2 = 410, 135, 80
    local textOffsetX, textOffsetY = 160, 5

    GUI:Image_Create(node, "duihuan_wz1", titleX, titleY1, "res/wy/public/duihuan_wz.png")
    GUI:Image_Create(node, "duihuan_wz2", titleX, titleY2, "res/wy/public/duihuan_wz.png")

    -- 剩余兑换次数展示（防止字段缺失时报错）
    GUI:Text_Create(
        node, "hbdh1",
        titleX + textOffsetX, textOffsetY + titleY1,
        20, "#ffffff",
        (10 - (npc.data.hbdh1 or 0)) .. "次"
    )
    GUI:Text_Create(
        node, "hbdh2",
        titleX + textOffsetX, textOffsetY + titleY2,
        20, "#ffffff",
        (10 - (npc.data.hbdh2 or 0)) .. "次"
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
        local node = createWindow(npcid, msgData)
        updateUI(npcid, node)
    elseif p2 == 1 then  -- 刷新数据
        npc.data = SL:JsonDecode(msgData, false)
        if npc.node then
            updateUI(npcid, npc.node)
        end
    end
end

return npc

