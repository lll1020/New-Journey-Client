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

local function _draw_rank_list(node, rankData)
    _outline_text(node, "rank_title", 760 + 110, 170, 24, "#F5F1E7", "排行预览", 0.5, 0.5)
    for i = 1, 5 do
        local row = rankData[i] or {}
        local text = string.format("%d. %s  %s分", i, tostring(row.name or "未上榜"), tostring(tonumber(row.score or 0) or 0))
        _outline_text(node, "rank_" .. i, 760 + 110, 205 + (i - 1) * 36, 18, i <= 3 and "#FFD27A" or "#E6D3B0", text, 0.5, 0.5)
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
        GUI:setAnchorPoint(GUI:RichText_Create(node, "cur_tip", 208 - 72, 400,  Player:showEquipAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",current.name.."[称号]"))), 200, 17, "##00FFFF", 3,nil,nil)
        , 0, 1)
    else
        GUI:setAnchorPoint(GUI:RichText_Create(node, "cur_tip", 208 - 50, 400,  "<font color='#00FF00' size='18' >「墨纸未书，\n             侠名待启」</font>\n\n<font color='#00FFFF' size='16' >这张空白的宣纸，\n正等待你的故事。\n用文书与铜钱\n写下第一笔江湖印记，\n从此你的名字，\n将在这片大陆流传。</font>", 200, 17, "#f7f7de", 3,nil,nil)
        , 0, 1)
    end
    if (nextInfo.tip or "当前已达到最高称号") ~= "当前已达到最高称号" then
        GUI:setAnchorPoint(GUI:RichText_Create(node, "next_tip", 500 + 60, 400,  Player:showEquipAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",nextInfo.name.."[称号]"))), 200, 17, "##00FFFF", 3,nil,nil)
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
