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

local function _fmt_attr_value(attConfig, value)
    value = tonumber(value) or 0
    if attConfig and attConfig.type == 2 then
        local num = value / 100
        return (num == math.floor(num)) and tostring(num) .. "%" or string.format("%.1f%%", num)
    end
    if attConfig and attConfig.type == 3 then
        return (value == math.floor(value)) and tostring(value) .. "%" or string.format("%.1f%%", value)
    end
    return tostring(value)
end

local function _attr_rich_line(name, value, color)
    return string.format("<font color='%s'>%s+%s</font>", SL:GetHexColorByStyleId(color or 255), tostring(name or ""), tostring(value or 0))
end

local function _show_equip_attr_merged(itemData)
    if not itemData or not itemData.attribute then
        return ""
    end
    local attList = GUIFunction:ParseItemBaseAtt(itemData.attribute)
    local sorted = {}
    for _, v in pairs(attList or {}) do
        local cfg = SL:GetMetaValue("ATTR_CONFIG", v.id)
        local name = tostring(cfg and cfg.name or ""):gsub(" ", ""):gsub("　", "")
        table.insert(sorted, {id = v.id, value = v.value, cfg = cfg, name = name, isPercent = cfg and (cfg.type == 2 or cfg.type == 3)})
    end
    table.sort(sorted, function(a, b)
        if #a.name ~= #b.name then
            return #a.name < #b.name
        end
        if a.isPercent ~= b.isPercent then
            return not a.isPercent
        end
        return a.name < b.name
    end)

    local rangeNames = {["攻击"] = true, ["魔法"] = true, ["道术"] = true, ["防御"] = true, ["魔防"] = true}
    local pending = {}
    local result = {}
    for _, entry in ipairs(sorted) do
        local baseName = entry.name:match("^(.-)下限$")
        local side = baseName and "下限" or nil
        if not baseName then
            baseName = entry.name:match("^(.-)上限$")
            side = baseName and "上限" or nil
        end
        if baseName and rangeNames[baseName] then
            if not pending[baseName] then
                pending[baseName] = {color = (entry.cfg and entry.cfg.color) or 255}
                table.insert(result, {rangeName = baseName})
            end
            pending[baseName][side == "下限" and "low" or "high"] = _fmt_attr_value(entry.cfg, entry.value)
        else
            table.insert(result, _attr_rich_line(entry.name, _fmt_attr_value(entry.cfg, entry.value), entry.cfg and entry.cfg.color or 255))
        end
    end

    local lines = {}
    for _, one in ipairs(result) do
        if type(one) == "table" and one.rangeName then
            local name = one.rangeName
            local range = pending[name]
            if range.low and range.high then
                table.insert(lines, _attr_rich_line(name, range.low .. "-" .. range.high, range.color))
            elseif range.low then
                table.insert(lines, _attr_rich_line(name .. "下限", range.low, range.color))
            elseif range.high then
                table.insert(lines, _attr_rich_line(name .. "上限", range.high, range.color))
            end
        else
            table.insert(lines, one)
        end
    end
    return table.concat(lines, "\n")
end

local function _title_attr_text(titleName)
    local itemData = SL:GetMetaValue("ITEM_DATA", SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName .. "[称号]"))
    return _show_equip_attr_merged(itemData)
end

local function _build_rank_tips(rankData)
    local lines = {}
    for line = 1, 5 do
        local rank = 6 - line
        local row = rankData[rank] or {}
        local text = string.format("%d.%s %s分", rank, tostring(row.name or "未上榜"), tostring(tonumber(row.score or 0) or 0))
        table.insert(lines, string.format("<font color='#F4D4A8' size='20'>%s</font>", text))
    end
    return table.concat(lines, "<br>") .. "<br><font color='#F5F1E7' size='24'>排行预览</font>"
end

local function _open_rank_tips(widget, rankData)
    local pos = GUI:getWorldPosition(widget)
    SL:OpenCommonDescTipsPop({
        str = _build_rank_tips(rankData or {}),
        worldPos = {x = pos.x, y = pos.y},
        anchorPoint = {x = 0, y = 0},
        formatWay = 1
    })
end

local function _draw_rank_list(node, rankData)
    local rankText = _outline_text(node, "rank_title", 870 - 180, 347 - 240, 24, "#F5F1E7", "排行榜", 0.5, 0.5)
    GUI:Text_enableUnderline(rankText)
    GUI:setTouchEnabled(rankText, true)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(rankText, {onEnterFunc = function()
            _open_rank_tips(rankText, rankData)
        end, onLeaveFunc = function()
            SL:CloseCommonDescTipsPop()
        end})
    else
        GUI:addOnTouchEvent(rankText, function()
            _open_rank_tips(rankText, rankData)
        end)
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
    -- _outline_text(node, "top_notice", 500, 62, 22, "#FF5B57", tostring(data.top_notice or _cfg().top_notice or ""), 0.5, 0.5)
    -- _outline_text(node, "desc", 500, 112, 22, "#F5F1E7", tostring(data.desc or _cfg().desc or ""), 0.5, 0.5)
    -- _outline_text(node, "cur_label", 208, 182, 24, "#72F39A", "当前称号", 0.5, 0.5)
    _outline_text(node, "cur_name", 208 + 78, 252 + 165, 20, "#FFF2D7", tostring(current.name or "暂无称号"), 0.5, 0.5)
    -- _outline_text(node, "cur_tip", 208, 320, 18, "#E6D3B0", tostring(current.tip or "尚未获得功勋称号"), 0.5, 0.5)
    -- GUI:setAnchorPoint(GUI:Image_Create(node, "arrow", 352, 250, ARROW_BG), 0.5, 0.5)
    -- _outline_text(node, "next_label", 500, 182, 24, "#FF8D8D", "下级称号", 0.5, 0.5)
    _outline_text(node, "next_name", 500 + 134, 252 + 165, 20, "#FFF2D7", tostring(nextInfo.name or "已满级"), 0.5, 0.5)
    -- _outline_text(node, "next_tip", 500, 320, 18, "#E6D3B0", tostring(nextInfo.tip or "当前已达到最高称号"), 0.5, 0.5)
    local meritText = string.format("%s/%s", tostring(tonumber(data.total_merit or 0) or 0),tostring(tonumber(nextInfo.need or 0) or 0))
    -- local needText = string.format("晋升需求：%s", tostring(tonumber(nextInfo.need or 0) or 0))
    local scoreText = string.format("本场排行分：%s    击杀数：%s", tostring(tonumber(data.rank_score or 0) or 0), tostring(tonumber(data.kills or 0) or 0))
    _outline_text(node, "merit_text", 350 + 65, 420 - 255, 22, "#FFF2D7", meritText, 0.5, 0.5)
    -- _outline_text(node, "need_text", 350, 455, 22, "#FFD27A", needText, 0.5, 0.5)
    -- _outline_text(node, "score_text", 350, 490, 18, "#E6D3B0", scoreText, 0.5, 0.5)
    if (current.tip or "尚未获得功勋称号") ~= "尚未获得功勋称号" then
        GUI:setAnchorPoint(GUI:RichText_Create(node, "cur_tip", 208 - 72, 400,  _title_attr_text(tostring(current.name or "")), 200, 17, "##00FFFF", 3,nil,nil)
        , 0, 1)
    else
        GUI:setAnchorPoint(GUI:RichText_Create(node, "cur_tip", 208 - 50, 400,  "<font color='#00FF00' size='18' >「墨纸未书，\n             侠名待启」</font>\n<font color='#00FFFF' size='16' >这张空白的宣纸，\n正等待你的故事。\n用文书与铜钱\n写下第一笔江湖印记，\n从此你的名字，\n将在这片大陆流传。</font>", 200, 17, "#f7f7de", 3,nil,nil)
        , 0, 1)
    end
    if (nextInfo.tip or "当前已达到最高称号") ~= "当前已达到最高称号" then
        GUI:setAnchorPoint(GUI:RichText_Create(node, "next_tip", 500 + 60, 400,  _title_attr_text(tostring(nextInfo.name or "")), 200, 17, "##00FFFF", 3,nil,nil)
        , 0, 1)
    else
        GUI:setAnchorPoint(GUI:RichText_Create(node, "next_tip", 500 + 80, 400,  "<font color='#00FF00' size='18' >「墨纸未书，\n             侠名待启」</font>\n\n<font color='#00FFFF' size='16' >这张空白的宣纸，\n正等待你的故事。\n用文书与铜钱\n写下第一笔江湖印记，\n从此你的名字，\n将在这片大陆流传。</font>", 200, 17, "#f7f7de", 3,nil,nil)
        , 0, 1)
    end

    local btn = GUI:Button_Create(node, "upgrade_btn", 620 - 206, 50 + 60, ARROW_BG)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
    if tonumber(data.can_upgrade or 0) == 1 then
        NPC_UI_HELPER.redpoint_create_eff(btn, {x = 150, y = 44})
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
