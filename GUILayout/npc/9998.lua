local npc = {}

local WINDOW_OPTS = {
    background = {skin = "res/custom/gaiming/改头换面.png", width = 800, height = 440},
    closeButton = {
        x = 720,
        y = 380,
        skin = "res/wy/public/close_red_big.png",
    },
}

local function _decode(msgData)
    if type(msgData) ~= "string" or msgData == "" then
        return {}
    end
    return SL:JsonDecode(msgData, false) or {}
end

local function _show_tip(text)
    if SL and SL.ShowSystemTips then
        SL:ShowSystemTips(text)
    end
end

local function _ensure_window(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, WINDOW_OPTS)
    npc.node = npc._window.bg
    return npc.node
end

local function _close()
    if npc._window and npc._window.parent then
        GUI:Win_Close(npc._window.parent)
    end
    npc._window = nil
    npc.node = nil
end

local function _render(node, npcid, data)
    local old = GUI:GetWindow(node, "rename_content")
    if old then
        GUI:removeFromParent(old)
    end
    local content = GUI:Node_Create(node, "rename_content", 0, 0)
    GUI:setLocalZOrder(content, 120)

    local itemName = tostring(data.itemName or "改名卡")
    local tip = GUI:Text_Create(content, "tip", 92, 78, 18, "#f8e7bd", "当前使用：" .. itemName)
    GUI:setAnchorPoint(tip, 0, 0.5)
    GUI:Text_setFontName(tip, "fonts/502.ttf")
    GUI:Text_enableOutline(tip, "#160b05", 2)

    local inputBg = GUI:Image_Create(content, "input_bg", 562, 164, "res/public/1900000668.png")
    GUI:setAnchorPoint(inputBg, 0.5, 0.5)
    GUI:setContentSize(inputBg, 118, 34)
    GUI:setIgnoreContentAdaptWithSize(inputBg, false)
    GUI:setOpacity(inputBg, 35)

    local input = GUI:TextInput_Create(inputBg, "name_input", 0, 0, 250, 28, 17)
    GUI:setAnchorPoint(input, 0.5, 0.5)
    GUI:TextInput_setInputMode(input, 6)
    GUI:TextInput_setMaxLength(input, 14)
    GUI:TextInput_setPlaceHolder(input, "请输入新的角色名称")
    GUI:TextInput_setFontColor(input, "#ffffff")
    if GUI.TextInput_setPlaceholderFontColor then
        GUI:TextInput_setPlaceholderFontColor(input, "#9b8c78")
    end

    local submitBtn = GUI:Image_Create(content, "submit", 461, 91, "res/custom/gaiming/立即改名.png")
    GUI:setAnchorPoint(submitBtn, 0.5, 0.5)
    GUI:setLocalZOrder(submitBtn, 20)
    GUI:setTouchEnabled(submitBtn, true)
    GUI:addOnClickEvent(submitBtn, function()
        local newName = tostring(GUI:TextInput_getString(input) or "")
        newName = string.gsub(newName, "^%s*(.-)%s*$", "%1")
        if newName == "" then
            _show_tip("请输入新的角色名称")
            return
        end
        SL:SendLuaNetMsg(100, 9998, 1, 0, SL:JsonEncode({name = newName}, false))
        _close()
    end)

    local closeBtn = GUI:Layout_Create(content, "close", 560, 200, 48, 48, false)
    GUI:setAnchorPoint(closeBtn, 0.5, 0.5)
    GUI:setTouchEnabled(closeBtn, true)
    GUI:setLocalZOrder(closeBtn, 30)
    GUI:addOnClickEvent(closeBtn, function()
        _close()
    end)
end

function npc.main(npcid, p2, p3, msgData)
    local node = _ensure_window(npcid)
    _render(node, npcid, _decode(msgData))
end

return npc
