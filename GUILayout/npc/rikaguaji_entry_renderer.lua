local renderer = {}

local RES = "res/custom/rikaguaji/"
local BG_MASK = "res/public/1900000651_1.png"
local PANEL_BG = RES .. "安全挂机.png"
local TITLE_IMG = RES .. "标题.png"
local ENTER_BTN = RES .. "立即进入.png"
local CLOSE_BTN = "res/wy/public/close_red_big.png"

local IMAGE_BY_NAME = {
    ["苍云"] = RES .. "苍云.png",
    ["若水"] = RES .. "若水.png",
    ["红尘"] = RES .. "红尘.png",
    ["灵虚"] = RES .. "灵虚.png",
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
    GUI:addOnClickEvent(mask, function()
        GUI:Win_Close(win)
    end)

    local panel = GUI:Image_Create(win, "panel", 0, 0, PANEL_BG)
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setTouchEnabled(panel, true)
    GUI:Image_Create(panel, "title", 0 + 57, 210 + 246, TITLE_IMG)

    -- local preview = IMAGE_BY_NAME[decoded.img or ""] and GUI:Image_Create(panel, "preview", 0, 20, IMAGE_BY_NAME[decoded.img]) or nil
    -- if preview then
    --     GUI:setAnchorPoint(preview, 0.5, 0.5)
    -- end

    text(panel, "name", 0 + 622, 105 + 244, 28, "#F6D08A", decoded.name or "日卡挂机")
    -- text(panel, "cond", 0, 66, 18, "#F5E6C6", "进入条件：" .. tostring(decoded.need_desc or "开通日卡"), 0.5, 0.5, "fonts/font4.ttf")
    -- text(panel, "state", 0, 30, 19, decoded.can_enter == 1 and "#7CFF9A" or "#FF7A7A", decoded.can_enter == 1 and "当前可进入" or (decoded.error or "当前不可进入"), 0.5, 0.5, "fonts/font4.ttf")

    local btn = GUI:Button_Create(panel, "enter_btn", 0 + 613, -110 + 158, ENTER_BTN)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)

    local close = GUI:Button_Create(panel, "close", 292 + 440, 220 + 238, CLOSE_BTN)
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(win)
    end)
end

return renderer
