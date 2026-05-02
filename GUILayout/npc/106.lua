local npc = {}

npc._config = teshudata["npc_106"] or {}

local WINDOW_OPTS = {
    background = {skin = "res/custom/treasureBasin/xjm_bg.png"},
    closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
}

local function _cfg()
    return npc._config or {}
end

local function _show_name()
    local cfg = _cfg()
    return tostring(cfg.artifact_display_name or cfg.artifact_name or "聚宝盆")
end

-- 聚宝盆属性说明：百分比属性按百分数显示，其余属性保持原值。
local function _format_attr_text()
    local textList = {}
    for _, entry in ipairs((_cfg().attr or {})) do
        local attrId = tonumber(entry[1]) or 0
        local attrValue = tonumber(entry[2]) or 0
        local attrName = tostring(entry[3] or "")
        if attrName ~= "" then
            if attrId == 66 or attrId == 204 then
                textList[#textList + 1] = string.format("%s+%d%%", attrName, math.floor(attrValue / 100))
            else
                textList[#textList + 1] = string.format("%s+%d", attrName, attrValue)
            end
        end
    end
    return table.concat(textList, "、")
end

-- 奖励文案：统一显示“物品*数量”。
local function _format_reward_text(reward)
    local textList = {}
    for _, entry in ipairs(reward or {}) do
        local name = tostring(entry[1] or "")
        local num = tonumber(entry[2]) or 0
        if name ~= "" and num > 0 then
            textList[#textList + 1] = string.format("%s*%d", name, num)
        end
    end
    return table.concat(textList, "、")
end

-- 修复按钮可点击条件：碎片数量达到需求且尚未激活。
local function _can_rebuild()
    local data = npc.data or {}
    return (tonumber(data.activated or 0) or 0) < 1
        and (tonumber(data.fragment_have or 0) or 0) >= (tonumber(data.fragment_need or 0) or 0)
end

local function _create_outline_text(parent, name, x, y, size, color, text, anchorX, anchorY)
    local label = GUI:Text_Create(parent, name, x, y, size, color, tostring(text or ""))
    GUI:Text_enableOutline(label, "#100808", 2)
    if anchorX ~= nil or anchorY ~= nil then
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
    end
    return label
end

local function _ensure_window(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.bg = GUI:Frames_Create(npc.bg, "eff", 0, 0, "res/custom/treasureBasin/bg/eff_", ".png", 1, 75, {
        speed = 75,
        count = 75,
        loop = -1,
    })
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)
    GUI:setLocalZOrder(npc._window.node, 99)
    npc.node = GUI:Node_Create(npc.bg, "node", 500, 360)
    GUI:setAnchorPoint(GUI:Image_Create(npc.bg, "title", 500, 520, "res/custom/treasureBasin/title.png"), 0.5, 0.5)
    return npc.node
end

-- 刷新聚宝盆主界面：未修复显示重铸按钮，已修复显示自动发奖进度。
local function _refresh_ui(node, npcid)
    if not node then
        return
    end

    GUI:removeAllChildren(node)

    local data = npc.data or {}
    local cfg = _cfg()
    local progressCur = tonumber(data.progress_cur or 0) or 0
    local progressNeed = math.max(tonumber(data.progress_need or cfg.daily_kill or 1000) or 1000, 1)
    local progressPercent = math.min(progressCur / progressNeed * 100, 100)
    local rewardText = _format_reward_text(data.daily_reward or cfg.daily_reward or {{"金币", 2000000}})

    GUI:setAnchorPoint(GUI:Image_Create(node, "wz_4", 0, -200, "res/custom/treasureBasin/wz_4.png"), 0.5, 0.5)
    _create_outline_text(node, "name", 0, 110, 24, "#FFF2D7", _show_name(), 0.5, 0.5)
    _create_outline_text(node, "attr", 0, 65, 18, "#F4D179", "属性：" .. _format_attr_text(), 0.5, 0.5)
    _create_outline_text(
        node,
        "reward",
        0,
        30,
        18,
        "#9DFF7C",
        string.format("每日击杀%d只怪自动发放：%s", progressNeed, rewardText),
        0.5,
        0.5
    )

    if (tonumber(data.activated or 0) or 0) < 1 then
        local fragmentItem = tostring(data.fragment_item or cfg.fragment_item or "聚宝盆碎片")
        local fragmentNeed = tonumber(data.fragment_need or cfg.fragment_count or 20) or 20

        checkItemNumByTable_img_kuang({{fragmentItem, fragmentNeed}}, nil, GUI:Node_Create(node, "cost_show", -300, -123))
        ItemNumByTable_img_new({{_show_name(), 1}}, nil, GUI:Node_Create(node, "jl_show", 233, -123))

        local claimBtn = GUI:Frames_Create(node, "claim_btn", 0, -95, "res/custom/treasureBasin/btn1_eff/eff_", ".png", 1, 75, {
            speed = 75,
            count = 75,
            loop = -1,
        })
        GUI:setAnchorPoint(claimBtn, 0.5, 0.5)
        GUI:setTouchEnabled(claimBtn, true)
        GUI:addOnClickEvent(claimBtn, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

        NPC_UI_HELPER.tryStartXylGuide(npc, claimBtn, node, "treasure_basin_rebuild", {
            taskNames = {"修复聚宝盆", "聚宝盆任务"},
            dir = 7,
            desc = "点击修复聚宝盆",
        })

        if _can_rebuild() then
            NPC_UI_HELPER.redpoint_create_eff(claimBtn, {x = 200, y = 155})
        end
        return
    end

    local equipped = (tonumber(data.equipped or 0) or 0) >= 1
    local equipText = equipped
        and "装备状态：已穿戴，聚宝盆效果已生效"
        or "装备状态：已解锁，请穿戴到背包神器位后生效"
    local equipColor = equipped and "#9DFF7C" or "#FFD27A"
    _create_outline_text(node, "equip", 0, -15, 18, equipColor, equipText, 0.5, 0.5)

    local jdt_k = GUI:Image_Create(node, "jdt_k", 0, -150, "res/custom/treasureBasin/jdt_k.png")
    GUI:setAnchorPoint(jdt_k, 0.5, 0.5)
    local jdt = GUI:LoadingBar_Create(jdt_k, "jdt", 0, 0, "res/custom/treasureBasin/jdt_m.png", 0)
    GUI:LoadingBar_setPercent(jdt, progressPercent)
    _create_outline_text(
        jdt_k,
        "wz",
        337,
        12,
        18,
        "#FF0000",
        "今日进度：" .. tostring(progressCur) .. "/" .. tostring(progressNeed),
        0.5,
        0.5
    )

    local statusText = (tonumber(data.claimed or 0) or 0) >= 1
        and "今日奖励已自动发放"
        or "达到进度后将自动发放奖励"
    local statusColor = (tonumber(data.claimed or 0) or 0) >= 1 and "#9DFF7C" or "#FFF2D7"
    _create_outline_text(node, "status", 0, -85, 22, statusColor, statusText, 0.5, 0.5)
end

function npc.main(npcid, p2, p3, msgData)
    if msgData and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or {}
    else
        npc.data = npc.data or {}
    end

    if p2 == 0 then
        _ensure_window(npcid)
        _refresh_ui(npc.node, npcid)
        return
    end

    _refresh_ui(npc.node, npcid)

    if (tonumber((npc.data or {}).activated or 0) or 0) >= 1
        and NPC_UI_HELPER.isCurrentXylTask({"修复聚宝盆", "聚宝盆任务"}) then
        NPC_UI_HELPER.closeWindow(npc._window)
    end
end

return npc
