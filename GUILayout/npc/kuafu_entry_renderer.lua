local UI_HELPER = SL:Require("GUILayout/npc/ui_helper", true)

local renderer = {}

local RES = "res/custom/kuafu/幽邃洞窟等/"
local BG_MASK = "res/public/1900000651_1.png"
local TITLE_IMG = RES .. "信息底.png"
local ENTER_BTN = RES .. "进入地图.png"
local CLOSE_BTN = "res/wy/public/close_red_big.png"
local BG_FRAMES_PATH = RES .. "幽邃第窟序列/eff_"
local BG_FRAMES_EXT = ".png"
local BG_FRAMES_COUNT = 150
local PANEL_X = 88 + 400 - 100
local PANEL_Y = 8 + 300 - 100
local INFO_CENTER_X = 88
local NAME_X = 88
local NAME_Y = 154
local OPEN_DAY_Y = 18
local COND_Y = -42
local STATE_Y = -100
local BTN_X = 88
local BTN_Y = 0
local CLOSE_X = 310 + 300 + 200 - 50 - 100
local CLOSE_Y = 178 + 300 - 50 - 70

local IMAGE_BY_NPC = {
    [1013] = RES .. "幽邃地窟.png",
    [1014] = RES .. "摄魂红尘.png",
    [1015] = RES .. "逆灵离心.png",
    [1016] = RES .. "生死之门.png",
    [1017] = RES .. "跨服秘境.png",
}

local function text(parent, name, x, y, size, color, value, ax, ay, font)
    local node = GUI:Text_Create(parent, name, x, y, size, color, tostring(value or ""))
    GUI:setAnchorPoint(node, ax or 0.5, ay or 0.5)
    GUI:Text_setFontName(node, font or "fonts/502.ttf")
    GUI:Text_enableOutline(node, "#000000", 2)
    return node
end

function renderer.main(npcid, link, msg, data)
    if link ~= 0 then
        return
    end
    local decoded = SL:JsonDecode(data, false) or {}
    local win = GUI:GetWindow(nil, "npc_" .. npcid)
    if win then
        GUI:removeAllChildren(win)
        GUI:setPosition(win, cogin.w / 2, cogin.h / 2)
    else
        win = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
    end

    local mask = GUI:Image_Create(win, "mask", 0, 0, BG_MASK)
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(mask, true)
    -- GUI:setLocalZOrder(mask, -10)
    GUI:addOnClickEvent(mask, function()
        GUI:Win_Close(win)
    end)

    local bgAnim = GUI:Frames_Create(win, "bg_anim", 0, 0, BG_FRAMES_PATH, BG_FRAMES_EXT, 1, BG_FRAMES_COUNT, {
        count = BG_FRAMES_COUNT,
        speed = 100,
        loop = -1,
    })
    GUI:setAnchorPoint(bgAnim, 0.5, 0.5)
    -- GUI:setLocalZOrder(bgAnim, 10)

    local preview = GUI:Image_Create(bgAnim, "preview", 0 + 100, 0 + 192, IMAGE_BY_NPC[npcid] or TITLE_IMG)
    GUI:setAnchorPoint(preview, 0.5, 0.5)

    local panel = GUI:Image_Create(bgAnim, "panel", PANEL_X, PANEL_Y, TITLE_IMG)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setTouchEnabled(panel, true)

    -- text(bgAnim, "name", NAME_X + 300, NAME_Y + 120, 24, "#F6D08A", "地图掉落", 0.5, 0.5)
    text(bgAnim, "open_day", INFO_CENTER_X + 300, OPEN_DAY_Y + 128, 18, "#EAF6FF", "开启天数：" .. tostring(decoded.open_day or 0), 0.5, 0.5)
    text(bgAnim, "cond", INFO_CENTER_X + 300, COND_Y + 132, 18, "#F5E6C6", decoded.condition_desc or "", 0.5, 0.5, "fonts/font4.ttf")

    -- local stateText = decoded.can_enter == 1 and "当前可进入" or "当前不可进入"
    -- local stateColor = decoded.can_enter == 1 and "#7CFF9A" or "#FF7A7A"
    -- text(bgAnim, "state", INFO_CENTER_X + 300, STATE_Y + 120, 20, stateColor, stateText)

    local btn = GUI:Button_Create(bgAnim, "enter_btn", BTN_X + 300, BTN_Y + 40, ENTER_BTN)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)

    local close = GUI:Button_Create(bgAnim, "close", CLOSE_X, CLOSE_Y, CLOSE_BTN)
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(win)
    end)
end

return renderer
