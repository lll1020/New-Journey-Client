local npc = {}

npc._config = teshudata["npc_628"]

local KEY = "npc_628"
local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/628_bg.png"},
    closeButton = {x = 747, y = 420},
}
local TAKE_BUTTON_SKIN = "res/custom/all_story_mission/2/btn_take.png"
local PREP_BUTTON_SKIN = "res/custom/all_story_mission/3/628_btn.png"
local COMPLETE_SKIN = "res/wy/public/7_1.png"
local CHALLENGE_SKIN = "res/custom/three_city/zerq/btn_tz.png"
local PREP_POS = {600, 100}
local CHALLENGE_POS = {300, 100}
local CHALLENGE_TIP = "进入前请将【真视之眼】装备到神器位，否则只能看见妄灾的假身。"
local OPTIONAL_PREP_TIP = "前置任务为独立可选线路，可直接挑战讨伐。"

local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
    opts.subTitle = npc._config and npc._config.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function safeState(data, key)
    local tbl = (data and data.T_dljq) or {}
    return tonumber(tbl[key] or 0) or 0
end

local function bagCount(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    return tonumber(SL:GetMetaValue("ITEM_COUNT", itemName)) or 0
end

local function createOutlineText(parent, name, x, y, text, color, size)
    local label = GUI:Text_Create(parent, name, x, y, size or 20, color or "#FF0000", tostring(text or ""))
    GUI:Text_setFontName(label, "fonts/font4.ttf")
    GUI:Text_enableOutline(label, "#000000", 2)
    return label
end

local function createActionButton(parent, name, x, y, skin, callback)
    local button = GUI:Button_Create(parent, name, x, y, skin)
    GUI:setAnchorPoint(button, 0.5, 0.5)
    if callback then
        GUI:addOnClickEvent(button, callback)
    end
    return button
end

local function renderReward(node, reward)
    if type(reward) ~= "table" or #reward == 0 then
        return
    end
    createOutlineText(node, "tip1", 330 + 110, 120 + 30 - 20, "讨\n伐\n奖\n励", "#FFE46C", 14)
    local rewardNode = ItemNumByTable_img_new(reward, nil, GUI:Node_Create(node, "jl", 0, 0))
    GUI:setPosition(rewardNode, 330 + 135, 120 + 40 - 20)
    createOutlineText(node, "tip2", 330 + 110 + 150, 120 + 30 - 20, "关\n键\n物\n品", "#FFE46C", 14)
    local rewardNode2 = ItemNumByTable_img_new({{npc._config.prep_task.name, 1}}, nil, GUI:Node_Create(node, "jl1", 0, 0))
    GUI:setPosition(rewardNode2, 330 + 135 + 150, 120 + 40 - 20)
end

local function getPrepLines(cfg)
    local prep = cfg.prep_task or {}
    local leftName = prep.left_name or "真视之眼左"
    local rightName = prep.right_name or "真视之眼右"
    return {
        string.format("%s：%d/1", leftName, math.min(1, bagCount(leftName))),
        string.format("%s：%d/1", rightName, math.min(1, bagCount(rightName))),
    }
end

local function renderPrepSection(node, npcid, cfg, data, key)
    local prepKey = key .. "_rw"
    local prepState = safeState(data, prepKey)
    local prep = cfg.prep_task or {}
    local lines = getPrepLines(cfg)
    for idx, line in ipairs(lines) do
        createOutlineText(node, "prep_line_" .. idx, 455 + 170 - 70, 240 - (idx - 1) * 30 + 40, line, "#FF0000", 20)
    end

    createActionButton(node, "prep_btn", PREP_POS[1], PREP_POS[2], prepState == 0 and TAKE_BUTTON_SKIN or PREP_BUTTON_SKIN, function()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    return false
end

local function renderChallengeSection(node, npcid, data, key, prepDone)
    local mainState = safeState(data, key)
    if mainState >= 2 then
        GUI:setAnchorPoint(GUI:Image_Create(node, "main_finish", CHALLENGE_POS[1], CHALLENGE_POS[2], COMPLETE_SKIN), 0.5, 0.5)
        return
    end

    createActionButton(node, "challenge_btn", CHALLENGE_POS[1], CHALLENGE_POS[2], CHALLENGE_SKIN, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
end

local function updateUI(npcid, node)
    if not node then
        return
    end

    GUI:removeAllChildren(node)
    npc.data = npc.data or {}
    npc.data.T_dljq = npc.data.T_dljq or {}
    npc.data.sg_data = npc.data.sg_data or {}
    npc.data.T_dljq[KEY] = npc.data.T_dljq[KEY] or 0
    npc.data.T_dljq[KEY .. "_rw"] = npc.data.T_dljq[KEY .. "_rw"] or 0

    renderReward(node, npc._config.jl)
    local prepDone = renderPrepSection(node, npcid, npc._config, npc.data, KEY)
    renderChallengeSection(node, npcid, npc.data, KEY, prepDone)
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        updateUI(npcid, npc.node)
    elseif p2 == 1 then
        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.T_dljq[KEY .. "_rw"] = p3
        updateUI(npcid, npc.node)
    end
end

return npc
