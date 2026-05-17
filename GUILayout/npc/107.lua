local npc = {}
npc._config = teshudata["npc_107"] or {}

local PANEL_BG = "res/custom/activity/功勋称号/功勋称号.png"
local TITLE_BG = "res/custom/activity/功勋称号/标题.png"
local ARROW_BG = "res/custom/activity/功勋称号/称号晋升.png"

local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 400, y = 300 - 77,},
}

local function _cfg()
    return npc._config or {}
end

local function _get_data()
    return npc.data or {}
end

local function _ensure_window(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, _cfg())
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    GUI:setLocalZOrder(npc._window.node, 99)
    GUI:removeAllChildren(npc.bg)
    npc.panel = GUI:Image_Create(npc.bg, "panel", 0, 0, PANEL_BG)
    GUI:setAnchorPoint(npc.panel, 0.5, 0.5)
    GUI:setTouchEnabled(npc.panel, true)
    local titleImg = GUI:Image_Create(npc.panel, "title_img", 56, 464, TITLE_BG)
    local closeBtn = GUI:Button_Create(npc.panel, 'close', 750, 470, 'res/wy/public/close_red_big.png')
    GUI:setTouchEnabled(closeBtn, true)
    GUI:setLocalZOrder(closeBtn, 100)
    GUI:addOnClickEvent(closeBtn, function()
        NPC_UI_HELPER.closeWindow(npc._window)
    end)
    npc.node = GUI:Node_Create(npc.bg, "node", -415, -328)
    return npc.node
end

local function _outline_text(parent, name, x, y, size, color, text, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:setAnchorPoint(label, ax or 0.5, ay or 0.5)
    GUI:Text_enableOutline(label, "#100808", 2)
    return label
end

-- 生成称号说明：优先读取真实称号表中的属性描述，界面展示与服务端称号属性保持同源。
local function _build_title_desc(titleName, emptyTitle, emptyDesc)
    local name = tostring(titleName or "")
    if name == "" or name == "暂无称号" or name == "已满级" then
        return string.format(
            "<font color='#9CF8D4' size='18'>%s</font><br><font color='#E7F6FF' size='16'>%s</font>",
            tostring(emptyTitle or "暂无称号"),
            tostring(emptyDesc or "")
        )
    end
    local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name .. "[称号]") or 0) or 0
    if itemIndex <= 0 then
        return string.format(
            "<font color='#9CF8D4' size='18'>%s</font><br><font color='#E7F6FF' size='16'>称号属性读取失败，请检查称号表。</font>",
            name
        )
    end
    local itemData = SL:GetMetaValue("ITEM_DATA", itemIndex)
    local attrText = itemData and Player:showEquipAttr(itemData) or ""
    if attrText == "" then
        attrText = "<font color='#E7F6FF' size='16'>当前称号暂无额外属性。</font>"
    end
    return string.format("<font color='#9CF8D4' size='18'>%s</font><br>%s", name, attrText)
end

-- 生成功勋需求文本，满级时直接显示已满避免出现 0/0。
local function _build_merit_progress_text(data, nextInfo)
    local totalMerit = tonumber(data.total_merit or 0) or 0
    local needMerit = tonumber(nextInfo.need or 0) or 0
    if needMerit <= 0 then
        return "已满级"
    end
    return string.format("%s / %s", tostring(totalMerit), tostring(needMerit))
end

-- 生成底部战绩说明，保留排行分与击杀数两个核心字段。
local function _build_battle_text(data)
    local rankScore = tonumber(data.rank_score or 0) or 0
    local kills = tonumber(data.kills or 0) or 0
    return string.format("本场排行分：%s    击杀数：%s", tostring(rankScore), tostring(kills))
end

local function _draw_rank_list(node, rankData)
    _outline_text(node, "rank_title", 742, 228, 22, "#F5F1E7", "排行预览", 0.5, 0.5)
    for i = 1, 5 do
        local row = rankData[i] or {}
        local text = string.format("%d. %s  %s分", i, tostring(row.name or "未上榜"), tostring(tonumber(row.score or 0) or 0))
        _outline_text(node, "rank_" .. i, 742, 260 + (i - 1) * 30, 16, i <= 3 and "#FFD27A" or "#E6D3B0", text, 0.5, 0.5)
    end
end

local function _refresh_ui(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local data = _get_data()
    local current = data.current or {}
    local nextInfo = data.next or {}
    _outline_text(node, "top_notice", 415, 516, 20, "#FF5B57", tostring(data.top_notice or _cfg().top_notice or ""), 0.5, 0.5)
    _outline_text(node, "desc", 415, 468, 24, "#F5F1E7", tostring(data.desc or _cfg().desc or ""), 0.5, 0.5)
    _outline_text(node, "cur_label", 128, 409, 24, "#72F39A", "当前称号：", 0, 0.5)
    _outline_text(node, "next_label", 466, 409, 24, "#FF8D8D", "下级称号：", 0, 0.5)
    _outline_text(node, "cur_name", 236, 384, 20, "#FFF2D7", tostring(current.name or "暂无称号"), 0.5, 0.5)
    _outline_text(node, "next_name", 576, 384, 20, "#FFF2D7", tostring(nextInfo.name or "已满级"), 0.5, 0.5)
    _outline_text(node, "arrow_text", 410, 258, 44, "#F5B95C", ">>", 0.5, 0.5)
    _outline_text(node, "merit_label", 320, 153, 24, "#F5F1E7", "所需功勋", 0.5, 0.5)
    _outline_text(node, "merit_text", 410, 118, 24, "#FFF2D7", _build_merit_progress_text(data, nextInfo), 0.5, 0.5)
    _outline_text(node, "score_text", 410, 82, 18, "#E6D3B0", _build_battle_text(data), 0.5, 0.5)

    -- 左右两侧称号说明统一走真实称号属性展示，空称号则展示引导文案。
    local curTip = GUI:RichText_Create(
        node,
        "cur_tip",
        90,
        350,
        _build_title_desc(current.name, "暂无称号", "参加保卫村庄活动，积累功勋后即可开启第一档功勋称号。"),
        210,
        16,
        "#E7F6FF",
        3,
        nil,
        nil
    )
    GUI:setAnchorPoint(curTip, 0, 1)
    local nextTip = GUI:RichText_Create(
        node,
        "next_tip",
        428,
        350,
        _build_title_desc(nextInfo.name, "当前已满级", "当前已达到最高功勋称号，无需继续晋升。"),
        210,
        16,
        "#E7F6FF",
        3,
        nil,
        nil
    )
    GUI:setAnchorPoint(nextTip, 0, 1)

    local btn = GUI:Button_Create(node, "upgrade_btn", 620 - 206, 50 + 60, ARROW_BG)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        if tonumber(data.can_upgrade or 0) ~= 1 then
            return
        end
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
    if tonumber(data.can_upgrade or 0) == 1 then
        NPC_UI_HELPER.redpoint_create_eff(btn, {x = 150, y = 44})
    else
        GUI:setGrey(btn, true)
    end
    _draw_rank_list(node, data.rank_data or {})
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
    _refresh_ui(npc.node, npcid)
end

return npc
