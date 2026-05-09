local npc = {}
npc._config = teshudata["anniu_501"] or {}
local WINDOW_OPTS = {
    background = {skin = "res/custom/xianshifuli/限时福利.png"},
    closeButton = {x = 810 - 40, y = 454 - 79, skin = "res/wy/public/close_red_big.png"},
}
local CARD_SKIN = "res/custom/xianshifuli/框.png"
local CHOOSE_BTN_SKIN = "res/custom/xianshifuli/选择.png"
local CLAIM_ALL_BTN_SKIN = "res/custom/xianshifuli/我全都要.png"
local CARD_POS_LIST = {
    {x = 242, y = 178},
    {x = 371, y = 178},
    {x = 500, y = 178},
    {x = 629, y = 178},
}
local function create_outline_text(parent, name, x, y, size, color, text, outline)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text)
    GUI:Text_enableOutline(label, outline or "#000000", 1)
    return label
end
local function _show_tip(text)
    SL:ShowSystemTips(string.format("<font color='#FFCC66'>%s</font>", tostring(text or "")))
end
local function _get_welfare()
    local details = npc._config.details or {}
    return details.welfare or {}
end
local function _get_total_welfare_count(payload)
    local welfare = _get_welfare()
    local total = tonumber(payload and payload.welfare_count or 0) or 0
    if total <= 0 then
        total = #welfare
    end
    return math.min(total, #welfare)
end
local function _get_state()
    local payload = npc.data or {}
    local T_data = payload.T_data or {}
    T_data.main_claimed = tonumber(T_data.main_claimed or T_data.other_lb or 0) or 0
    T_data.welfare_claimed = tonumber(T_data.welfare_claimed or 0) or 0
    T_data.welfare_open_time = tonumber(T_data.welfare_open_time or payload.welfare_open_time or 0) or 0
    payload.T_data = T_data
    return payload, T_data
end
local function _get_server_time(payload)
    local now = tonumber(payload and payload.server_time or 0) or 0
    if now <= 0 then
        now = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0
    end
    return now
end
local function _get_left_seconds(payload, idx)
    local welfare = _get_welfare()
    local cfg = welfare[idx]
    if not cfg then
        return 0
    end
    if tonumber(payload.first_charge_ready or 0) >= 1 then
        return 0
    end
    local openTs = tonumber(payload.welfare_open_time or 0) or 0
    if openTs <= 0 then
        return tonumber(cfg.wait_sec or 0) or 0
    end
    local now = _get_server_time(payload)
    return math.max(openTs + (tonumber(cfg.wait_sec or 0) or 0) - now, 0)
end
local function _format_left_seconds(left)
    left = math.max(tonumber(left) or 0, 0)
    local hour = math.floor(left / 3600)
    local minute = math.floor((left % 3600) / 60)
    local second = left % 60
    if hour > 0 then
        return string.format("%02d:%02d:%02d", hour, minute, second)
    end
    return string.format("%02d:%02d", minute, second)
end
local function _get_reward_entry(cfg)
    local reward = cfg and cfg.reward and cfg.reward[1] or nil
    if type(reward) ~= "table" then
        return nil, 0, tostring(cfg and cfg.label or "")
    end
    return tostring(reward[1] or ""), tonumber(reward[2] or 0) or 0, tostring(cfg.label or reward[1] or "")
end
local function _get_card_state(payload, T_data, idx)
    local claimed = tonumber(T_data.welfare_claimed or 0) or 0
    local expected = claimed + 1
    local state = {
        idx = idx,
        claimed = claimed,
        expected = expected,
        action = 0,
        disabled = true,
        claimedDone = false,
        statusText = "未开启",
        statusColor = "#A89B8A",
        left = 0,
    }
    if claimed >= idx then
        state.claimedDone = true
        state.statusText = "已领取"
        state.statusColor = "#42FF89"
        return state
    end
    if idx ~= expected then
        state.statusText = tonumber(payload.first_charge_ready or 0) >= 1 and "待领取" or "未开启"
        state.statusColor = "#B8B2A5"
        return state
    end
    local left = _get_left_seconds(payload, idx)
    state.left = left
    if left > 0 then
        state.statusText = _format_left_seconds(left)
        state.statusColor = "#77D7FF"
        return state
    end
    state.action = idx
    state.disabled = false
    state.statusText = "可领取"
    state.statusColor = "#FFE26B"
    return state
end
local function _open_first_charge_panel()
    if npc._window and npc._window.parent and not tolua.isnull(npc._window.parent) then
        GUI:Win_Close(npc._window.parent)
    end
    SL:SendLuaNetMsg(101, 501, 0, 0, "")
end
local function _claim_all(npcid, payload, T_data)
    local total = _get_total_welfare_count(payload)
    local claimed = tonumber(T_data.welfare_claimed or 0) or 0
    if claimed >= total then
        _show_tip("限时福利已全部领取")
        return
    end
    if tonumber(payload.first_charge_ready or 0) < 1 then
        _open_first_charge_panel()
        return
    end
    for idx = claimed + 1, total do
        SL:SendLuaNetMsg(100, npcid, idx, 0, "")
    end
end
local function _render_card(node, npcid, payload, T_data, idx)
    local cfg = _get_welfare()[idx] or {}
    local pos = CARD_POS_LIST[idx]
    if not pos then
        return
    end
    local card = GUI:Image_Create(node, "card_" .. idx, pos.x, pos.y, CARD_SKIN)
    local rewardName, rewardCount, rewardLabel = _get_reward_entry(cfg)
    local state = _get_card_state(payload, T_data, idx)
    local rewardIndex = rewardName ~= "" and SL:GetMetaValue("ITEM_INDEX_BY_NAME", rewardName) or nil
    if rewardIndex and rewardIndex > 0 then
        local item = GUI:ItemShow_Create(card, "reward_item", 60 - 15, 102 - 15, {
            index = rewardIndex,
            count = rewardCount > 0 and rewardCount or 1,
            look = true,
            bgVisible = false,
        })
        GUI:setScale(item, 1)
        if state.claimedDone then
            GUI:ItemShow_setIconGrey(item, true)
        end
    else
        local fallback = create_outline_text(card, "reward_fallback_" .. idx, 60, 102, 16, "#FFF1C3", rewardName ~= "" and rewardName or "奖励", "#22140F")
        GUI:setAnchorPoint(fallback, 0.5, 0.5)
    end
    if state.claimedDone then
        GUI:Image_setGrey(card, true)
    end
    local title = create_outline_text(card, "reward_label_" .. idx, 60, 52 + 8, 15, "#6A391D", rewardLabel, "#F7E8C6")
    GUI:setAnchorPoint(title, 0.5, 0.5)
    local status = create_outline_text(card, "status_" .. idx, 64, 147, 13, state.statusColor, state.statusText, "#22140F")
    GUI:setAnchorPoint(status, 0.5, 0.5)
    if state.left > 0 and state.claimedDone ~= true and idx == state.expected then
        GUI:Text_COUNTDOWN(status, state.left, function()
            if npc.node and not tolua.isnull(npc.node) then
                UI_updata(npc.node, npcid)
            end
        end)
    end
    local btn = GUI:Button_Create(card, "card_btn_" .. idx, 20, 8, CHOOSE_BTN_SKIN)
    if state.disabled then
        GUI:Button_setGrey(btn, true)
        GUI:setOpacity(btn, 220)
    end
    GUI:addOnClickEvent(btn, function()
        if state.action > 0 then
            SL:SendLuaNetMsg(100, npcid, state.action, 0, "")
            return
        end
        if state.claimedDone then
            _show_tip("该档奖励已领取")
        elseif idx ~= state.expected then
            _show_tip("请按顺序领取限时福利")
        elseif state.left > 0 then
            _show_tip("倒计时未结束")
        else
            _show_tip("当前档位暂不可操作")
        end
    end)
end
local function _render_footer(node, npcid, payload, T_data)
    local total = _get_total_welfare_count(payload)
    local claimed = tonumber(T_data.welfare_claimed or 0) or 0
    local expected = claimed + 1
    local nextLeft = expected <= total and _get_left_seconds(payload, expected) or 0
    local hint = ""
    local hintColor = "#FFF1C3"
    if claimed >= total then
        hint = "四档奖励已全部领取"
        hintColor = "#42FF89"
    elseif tonumber(payload.first_charge_ready or 0) >= 1 then
        hint = "已首充，可点击下方【我全都要】直接领取剩余奖励"
        hintColor = "#FFE26B"
    elseif nextLeft > 0 then
        hint = string.format("当前第%d档倒计时：%s，领取后才会开始下一档", expected, _format_left_seconds(nextLeft))
        hintColor = "#77D7FF"
    else
        hint = string.format("当前第%d档已可领取，领取后才会开始下一档计时", expected)
        hintColor = "#FFE26B"
    end
    -- local hintText = create_outline_text(node, "footer_hint", 500, 144, 16, hintColor, hint, "#20120D")
    -- GUI:setAnchorPoint(hintText, 0.5, 0.5)
    local claimAllBtn = GUI:Button_Create(node, "claim_all_btn", 347 + 66, 106, CLAIM_ALL_BTN_SKIN)
    if claimed >= total then
        GUI:Button_setGrey(claimAllBtn, true)
        GUI:setOpacity(claimAllBtn, 220)
    end
    GUI:addOnClickEvent(claimAllBtn, function()
        _claim_all(npcid, payload, T_data)
    end)
end
function UI_updata(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local payload, T_data = _get_state()
    local total = _get_total_welfare_count(payload)
    for i = 1, math.min(total, #CARD_POS_LIST) do
        _render_card(node, npcid, payload, T_data, i)
    end
    _render_footer(node, npcid, payload, T_data)
end
function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow()
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end
    if p2 == 0 then
        npc.data = not msgData and {} or SL:JsonDecode(msgData, false)
        ensureWindow()
        UI_updata(npc.node, npcid)
        NPC_UI_HELPER.tryStartXylGuide(npc, npc._window and npc._window.close, npc.node, "welfare_open_close", {
            taskName = "限时福利",
            dir = 5,
            desc = "已查看，点击关闭继续",
        })
    elseif p2 == 1 then
        npc.data = not msgData and (npc.data or {}) or SL:JsonDecode(msgData, false)
        if npc.node and not tolua.isnull(npc.node) then
            UI_updata(npc.node, npcid)
        end
    end
end
return npc
