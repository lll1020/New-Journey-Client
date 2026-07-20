local npc = {}

local NPC_ID = 723
local BASE = "res/custom/all_story_mission/6/"
local DEFAULT_BUTTON = "res/public/1900000660.png"
local COMPLETE_SKIN = "res/wy/public/7_1.png"
local DIALOG_BUTTON_POS = {x = 540, y = 150, w = 294, h = 50}
local _render
local SPEC = {
    folder = "凌雪",
    dialogs = {
        [1] = {talk = "对话1/1-.png", btn = "对话1/11.png", talkPos = {x = 535, y = 360}, btnPos = DIALOG_BUTTON_POS, submit = {{"星儿的玉佩碎片", 1}}, submitTitle = "对话1/提交道具.png", submitTitlePos = {x = 430, y = 238}, submitPos = {x = 500, y = 220, scale = 0.85}},
        [2] = {talk = "对话2/2.png", btn = "对话2/22.png", talkPos = {x = 535, y = 336}, btnPos = DIALOG_BUTTON_POS},
        [3] = {talk = "对话3/3.png", btn = "对话3/33.png", talkPos = {x = 535, y = 360}, btnPos = DIALOG_BUTTON_POS, submit = {{"星力冰晶", 10}}, submitTitle = "对话3/任务要求.png", submitTitlePos = {x = 420, y = 260}, submitPos = {x = 500 - 22, y = 242, scale = 0.85}, give = {{"星晶碎片", 20}}, rewardTitle = "对话3/任务奖励.png", rewardTitlePos = {x = 420, y = 206}, rewardPos = {x = 500, y = 184, scale = 0.85}},
        [4] = {talk = "对话4/4.png", btn = "对话4/44.png", talkPos = {x = 535, y = 336}, btnPos = DIALOG_BUTTON_POS},
    },
}

npc._config = teshudata["npc_" .. tostring(NPC_ID)] or {}

local function _toint(v, d)
    local n = tonumber(v)
    if n == nil then
        return d or 0
    end
    return math.floor(n)
end

local function _valid(node)
    return node and not (tolua and tolua.isnull and tolua.isnull(node))
end

local function _skin(path)
    if path and path ~= "" and (not SL or not SL.IsFileExist or SL:IsFileExist(path)) then
        return path
    end
    return nil
end

local function _asset(fileName)
    if not SPEC.folder or SPEC.folder == "" or not fileName or fileName == "" then
        return nil
    end
    return _skin(BASE .. SPEC.folder .. "/" .. fileName)
end

local function _copy_pos(pos, defaults)
    defaults = defaults or {}
    pos = pos or {}
    return {
        x = pos.x or pos[1] or defaults.x or defaults[1] or 390,
        y = pos.y or pos[2] or defaults.y or defaults[2] or 82,
        w = pos.w or pos.width or defaults.w or defaults.width or 226,
        h = pos.h or pos.height or defaults.h or defaults.height or 70,
        scale = pos.scale or defaults.scale,
    }
end

local function _normalize_items(items)
    if type(items) ~= "table" or #items <= 0 then
        return nil
    end
    local result = {}
    for _, item in ipairs(items) do
        if type(item) == "table" then
            result[#result + 1] = item
        elseif item and item ~= "" then
            result[#result + 1] = {tostring(item), 1}
        end
    end
    return #result > 0 and result or nil
end

local function _render_dialog_item_list(node, name, items, titleSkinName, titlePos, itemPos, isCost)
    items = _normalize_items(items)
    if not items then
        return
    end
    local skin = _asset(titleSkinName)
    if skin then
        titlePos = titlePos or {x = 435, y = 236}
        local title = GUI:Image_Create(node, name .. "_title", titlePos.x or titlePos[1], titlePos.y or titlePos[2], skin)
        GUI:setAnchorPoint(title, 0.5, 0.5)
    end
    local root = GUI:Node_Create(node, name, 0, 0)
    local widget
    if isCost then
        widget = checkItemNumByTable_img_kuang(items, nil, root)
    else
        widget = ItemNumByTable_img_new(items, nil, root)
    end
    if widget then
        itemPos = itemPos or {x = 585, y = 236}
        GUI:setPosition(widget, itemPos.x or itemPos[1] or 585, itemPos.y or itemPos[2] or 236)
        if itemPos.scale then
            GUI:setScale(widget, itemPos.scale)
        end
    end
end

local function _render_dialog_item_group(node, dialog)
    if not dialog then
        return
    end
    if dialog.submit then
        _render_dialog_item_list(node, "dialog_submit", dialog.submit, dialog.submitTitle, dialog.submitTitlePos, dialog.submitPos, true)
    end
    if dialog.give then
        _render_dialog_item_list(node, "dialog_reward", dialog.give, dialog.rewardTitle, dialog.rewardTitlePos, dialog.rewardPos, false)
    end
end

local function _render_dialogs(node, key, data)
    local story = data.T_dljq or {}
    local state = _toint(story[key])
    if state >= 2 then
        npc.dialogStep = 4
    elseif state >= 1 then
        npc.dialogStep = math.max(2, math.min(3, _toint(npc.dialogStep, 3)))
    else
        npc.dialogStep = 1
    end
    local step = npc.dialogStep
    local dialog = SPEC.dialogs[step] or SPEC.dialogs[1]
    local talkSkin = _asset(dialog.talk)
    if talkSkin then
        local talkPos = dialog.talkPos or {x = 535, y = 360}
        local talk = GUI:Image_Create(node, "dialog_talk", talkPos.x or talkPos[1], talkPos.y or talkPos[2], talkSkin)
        GUI:setAnchorPoint(talk, 0.5, 0.5)
    end
    _render_dialog_item_group(node, dialog)

    local btnPos = _copy_pos(dialog.btnPos, DIALOG_BUTTON_POS)
    if state >= 2 then
        local completeSkin = _asset("已提交.png") or COMPLETE_SKIN
        local done = GUI:Image_Create(node, "dialog_done", btnPos.x, btnPos.y, completeSkin)
        GUI:setAnchorPoint(done, 0.5, 0.5)
        return true
    end
    local btnSkin = _asset(dialog.btn) or DEFAULT_BUTTON
    local btn = GUI:Button_Create(node, "dialog_btn", btnPos.x, btnPos.y, btnSkin)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    if btnSkin == DEFAULT_BUTTON then
        GUI:Button_setTitleText(btn, step == 1 and "提交碎片" or (step == 3 and "提交任务" or "继续"))
        GUI:Button_setTitleFontSize(btn, 18)
    end
    GUI:addOnClickEvent(btn, function()
        if step == 1 then
            SL:SendLuaNetMsg(100, NPC_ID, 1, 0, "")
            return
        end
        if step == 2 then
            npc.dialogStep = 3
            if _render then
                _render()
            end
            return
        end
        if step == 3 then
            SL:SendLuaNetMsg(100, NPC_ID, 3, 0, "")
        end
    end)
    return true
end

local function _cfg()
    npc._config = teshudata["npc_" .. tostring(NPC_ID)] or npc._config or {}
    return npc._config
end

local function _ensure_window()
    local bgSkin = _asset((SPEC.folder or "") .. ".png") or _asset("示意图.png") or ""
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, NPC_ID, {
        background = {skin = bgSkin},
        closeButton = SPEC.close or {x = 747, y = 380},
    })
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

_render = function()
    if not _valid(npc.node) then
        _ensure_window()
    end
    local node = npc.node
    if not _valid(node) then
        return
    end
    GUI:removeAllChildren(node)
    _cfg()
    npc.data = npc.data or {}
    npc.data.T_dljq = npc.data.T_dljq or {}
    npc.data.sg_data = npc.data.sg_data or {}
    local key = "npc_" .. tostring(NPC_ID)
    _render_dialogs(node, key, npc.data)
end

function npc.main(_npcid, p2, _p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        local key = "npc_" .. tostring(NPC_ID)
        local state = _toint(npc.data.T_dljq[key])
        npc.dialogStep = state >= 2 and 4 or (state >= 1 and 3 or 1)
        _ensure_window()
        _render()
        return
    end
    local decoded = SL:JsonDecode(msgData, false)
    if type(decoded) == "table" then
        npc.data = decoded
    else
        npc.data = npc.data or {}
    end
    npc.data.T_dljq = npc.data.T_dljq or {}
    npc.data.sg_data = npc.data.sg_data or {}
    _render()
end

return npc