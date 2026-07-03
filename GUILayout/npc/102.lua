local npc = {}
npc._config = teshudata["npc_102"] or {}

local RES_DIR = "res/custom/xinquchongji/"
local BG = RES_DIR .. "新区冲级.png"
local TITLE = RES_DIR .. "标题.png"
local LINE = RES_DIR .. "分割线-.png"
local FRAME = RES_DIR .. "装备框-.png"
local CLAIMED_TAG = "res/wy/public/4.png"
local UNCLAIMED_TAG = "res/wy/public/4_1.png"
local FONT_TITLE = "fonts/502.ttf"
local FONT_TEXT = "fonts/font4.ttf"

local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 400, y = 282},
}

local function _toint(v, d)
    return tonumber(v or d or 0) or (d or 0)
end

local function _outline_text(parent, name, x, y, size, color, text, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size, color, tostring(text or ""))
    GUI:setAnchorPoint(label, ax or 0.5, ay or 0.5)
    GUI:Text_enableOutline(label, "#05080C", 2)
    return label
end

local function _set_font(label, fontName)
    if label and fontName then
        GUI:Text_setFontName(label, fontName)
    end
    return label
end

local function _style_title(label)
    _set_font(label, FONT_TITLE)
    GUI:Text_enableOutline(label, "#110A04", 3)
    return label
end

local function _style_body(label)
    _set_font(label, FONT_TEXT)
    GUI:Text_enableOutline(label, "#05080C", 2)
    return label
end

local function _title_item_index(titleName)
    if not titleName or titleName == "" then
        return nil
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName .. "[称号]")
    if not idx or tonumber(idx) == 0 then
        idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName)
    end
    return idx
end

local function _item_index(itemName)
    if not itemName or itemName == "" then
        return nil
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if not idx or tonumber(idx) == 0 then
        return nil
    end
    return idx
end

local function _ensure_window(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    GUI:setLocalZOrder(npc._window.node, 99)
    GUI:removeAllChildren(npc.bg)

    npc.panel = GUI:Image_Create(npc.bg, "panel", 0, 0, BG)
    GUI:setAnchorPoint(npc.panel, 0.5, 0.5)
    GUI:setTouchEnabled(npc.panel, true)
    GUI:Image_Create(npc.panel, "title", 45, 470 - 7, TITLE)
    local closeBtn = GUI:Button_Create(npc.panel, "close", 746, 500, "res/wy/public/close_red_big.png")
    GUI:addOnClickEvent(closeBtn, function()
        NPC_UI_HELPER.closeWindow(npc._window)
    end)
    npc.node = GUI:Node_Create(npc.panel, "node", 0, 0)
    return npc.node
end

local function _row_status(row)
    if _toint(row.no_reward) == 1 then
        return "无称号", "#8D99A6"
    end
    if _toint(row.claimed) == 1 then
        return "已发邮件", "#9FF6B2"
    end
    if _toint(row.order_ok, 1) == 0 then
        return "等待前置", "#D6A85A"
    end
    if _toint(row.remaining, -1) == 0 then
        return "已抢完", "#D05A5A"
    end
    if _toint(row.can_claim) == 1 then
        return "达标自动发", "#F8E0A0"
    end
    return "未达等级", "#8D99A6"
end

local function _local_reward_cfg(row)
    local idx = _toint(row and row.idx, 0)
    local cfg = (npc._config.rewards or {})[idx] or {}
    return cfg
end

local function _merge_row(row)
    row = row or {}
    local cfg = _local_reward_cfg(row)
    local limit = _toint(row.limit, cfg.limit)
    local used = _toint(row.used)
    local remaining = row.remaining
    if remaining == nil then
        remaining = limit > 0 and math.max(0, limit - used) or -1
    end
    return {
        idx = _toint(row.idx),
        level = _toint(row.level, cfg.level),
        title = tostring(cfg.title or ""),
        desc = tostring(cfg.desc or ""),
        items = cfg.items or {},
        limit = limit,
        used = used,
        remaining = remaining,
        claimed = _toint(row.claimed),
        has_title = _toint(row.has_title),
        can_claim = _toint(row.can_claim),
        order_ok = _toint(row.order_ok, 1),
        no_reward = _toint(row.no_reward),
    }
end

local function _open_quota_tip(widget, row)
    row = _merge_row(row)
    local limit = _toint(row.limit)
    local used = _toint(row.used)
    local quotaText = limit > 0 and string.format("总名额：%d<br>已发送：%d<br>剩余：%d", limit, used, math.max(0, limit - used)) or "总名额：无限"
    local rewardText = tostring(row.desc or "")
    if rewardText ~= "" then
        quotaText = quotaText .. "<br><font color='#F2D78D'>奖励：" .. rewardText .. "</font>"
    end
    local pos = GUI:getWorldPosition(widget)
    SL:OpenCommonDescTipsPop({
        str = string.format("<font color='#F4D179' size='20'>%s级 %s</font><br><font color='#DCEBFF' size='18'>%s</font>", tostring(row.level or 0), tostring(row.title or ""), quotaText),
        worldPos = {x = pos.x, y = pos.y},
        anchorPoint = {x = 0, y = 0},
        formatWay = 1
    })
end

local function _render_single_reward(parent, name, idx, count, x, y)
    if not idx or tonumber(idx) == 0 then
        return
    end
    local frame = GUI:Image_Create(parent, "frame_" .. tostring(name), x, y, FRAME)
    GUI:setAnchorPoint(frame, 0.5, 0.5)
    local item = GUI:ItemShow_Create(frame, "item", 29, 30, {index = idx, look = true, bgVisible = false})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    if _toint(count) > 1 then
        local countText = _outline_text(frame, "count", 47, 9, 15, "#F8E0A0", tostring(count), 1, 0.5)
        _style_body(countText)
    end
end

local function _collect_reward_icons(row)
    row = _merge_row(row)
    local rewards = {}
    local title = tostring(row.title or "")
    if title ~= "" then
        rewards[#rewards + 1] = {name = title, idx = _title_item_index(title), count = 1, is_title = true}
    end
    if type(row.items) == "table" then
        for _, item in ipairs(row.items) do
            if type(item) == "table" then
                local itemName = tostring(item[1] or "")
                if itemName ~= "" then
                    rewards[#rewards + 1] = {name = itemName, idx = _item_index(itemName), count = _toint(item[2], 1)}
                end
            end
        end
    end
    return rewards
end

local function _render_reward_icons(parent, row, startX, y)
    local rewards = _collect_reward_icons(row)
    if #rewards <= 0 then
        return
    end
    local gap = 55
    for i, reward in ipairs(rewards) do
        _render_single_reward(parent, tostring(row.idx) .. "_" .. i, reward.idx, reward.count, startX + (i - 1) * gap, y)
    end
end

local function _render_row_claim_tag(parent, row, x, y)
    local claimed = _toint(row.claimed) == 1
    local tag = GUI:Image_Create(parent, "claim_tag_" .. tostring(row.idx), x, y, claimed and CLAIMED_TAG or UNCLAIMED_TAG)
    GUI:setAnchorPoint(tag, 0.5, 0.5)
end

local function _render_row(parent, row, index, npcid)
    row = _merge_row(row)
    local y = 350 - 27 - (index - 1) * 58
    GUI:Image_Create(parent, "line_" .. index, 32, y - 30, LINE)
    _style_body(_outline_text(parent, "level_" .. index, 110, y, 21, "#EAF6FF", tostring(row.level or 0) .. "级", 0.5, 0.5))
    local quotaText = "无限"
    if _toint(row.limit) > 0 then
        quotaText = string.format("%d/%d", math.max(0, _toint(row.limit) - _toint(row.used)), _toint(row.limit))
    end
    local quotaNode = _style_body(_outline_text(parent, "quota_" .. index, 292 + 20, y, 21, "#DCEBFF", quotaText, 0.5, 0.5))
    GUI:Text_enableUnderline(quotaNode)
    GUI:setTouchEnabled(quotaNode, true)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(quotaNode, {onEnterFunc = function()
            _open_quota_tip(quotaNode, row)
        end, onLeaveFunc = function()
            SL:CloseCommonDescTipsPop()
        end})
    else
        GUI:addOnTouchEvent(quotaNode, function()
            _open_quota_tip(quotaNode, row)
        end)
    end
    _render_reward_icons(parent, row, 410 + 50, y + 3)
    _render_row_claim_tag(parent, row, 682, y)
end

local function _refresh_ui(npcid)
    local node = npc.node
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local data = npc.data or {}
    -- _style_title(_outline_text(node, "open_tip", 382, 410, 22, _toint(data.is_open) == 1 and "#9FF6B2" or "#FF7777",
        -- _toint(data.is_open) == 1 and "达到等级后自动邮件发放奖励" or "活动已结束：首次合区后关闭", 0.5, 0.5))
    _style_body(_outline_text(node, "my_level", 650 + 20, 410 - 42, 18, "#EAF6FF", "当前等级：" .. tostring(_toint(data.player_level)), 0.5, 0.5))
    for i, row in ipairs(data.rows or {}) do
        _render_row(node, row, i, npcid)
    end
end

function npc.main(npcid, p2, p3, msgData)
    if msgData and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or {}
    else
        npc.data = npc.data or {}
    end
    if p2 == 0 or not npc.node or not npc._window then
        _ensure_window(npcid)
    end
    _refresh_ui(npcid)
end

return npc
