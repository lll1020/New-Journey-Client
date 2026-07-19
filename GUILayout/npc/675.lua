local npc = {}

npc._config = teshudata["npc_675"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/675_bg.png"},
    closeButton = {x = 747, y = 380},
}

local btn_pos = {600, 110}
local cost_pos = {643, 195}
local star_origin_x = 458
local star_origin_y = 304
local star_gap_x = 84
local star_gap_y = 54

local function n(v)
    return tonumber(v or 0) or 0
end

local function ensureWindow(npcId)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcId, npc._config)
    opts.subTitle = npc._config and npc._config.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcId, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function createOutlineText(parent, name, x, y, size, color, text, font, outline)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text)
    if font then
        GUI:Text_setFontName(label, font)
    end
    if outline then
        GUI:Text_enableOutline(label, outline, 2)
    end
    return label
end

local function renderAffixList(node, list)
    local title = createOutlineText(node, "affix_title", 198, 284, 20, "#F3D38B", "当前逐日弓词条", "fonts/501.ttf", "#3C1E0B")
    GUI:setAnchorPoint(title, 0, 0.5)
    if type(list) ~= "table" or #list == 0 then
        local empty = createOutlineText(node, "affix_empty", 198, 252, 18, "#C8C8C8", "暂未获得词条", "fonts/font4.ttf", "#000000")
        GUI:setAnchorPoint(empty, 0, 0.5)
        return
    end
    for i, text in ipairs(list) do
        local y = 252 - (i - 1) * 22
        local label = createOutlineText(node, "affix_" .. i, 198, y, 17, "#F6F1E0", string.format("%d. %s", i, tostring(text or "")), "fonts/font4.ttf", "#000000")
        GUI:setAnchorPoint(label, 0, 0.5)
    end
end

local function updateUI(npcId, node)
    if not node then
        return
    end
    GUI:removeAllChildren(node)

    local affixCount = n(npc.data and npc.data.affix_count)
    local maxNum = n((npc.data and npc.data.max_num) or (npc._config and npc._config.max_num) or 9)
    local bagBowCount = n(npc.data and npc.data.bag_bow_count)
    local hasEquippedBow = n(npc.data and npc.data.has_equipped_bow) >= 1
    local taskDone = n(npc.data and npc.data.task_done) >= 1
    local arrowCount = n(npc.data and npc.data.arrow_count)

    if npc._config.cost then
        local costNode = checkItemNumByTable_img_kuang(npc._config.cost, nil, GUI:Node_Create(node, "cost_node", 0, 0))
        if costNode then
            GUI:setPosition(costNode, cost_pos[1], cost_pos[2])
        end
    end

    GUI:RichText_Create(node, "cost_hb", 274, 162, ItemNumByTable(npc._config.hb), 502, 18, "#f7f7de", 3, nil, nil, {outlineSize = 2, outlineColor = SL:ConvertColorFromHexString("#100808")})

    local stateText = hasEquippedBow and "状态：已穿戴神器槽逐日弓" or "状态：请先将逐日弓穿戴到背包神器槽位"
    createOutlineText(node, "state_text", 198, 344, 18, hasEquippedBow and "#98F0A6" or "#FF8E8E", stateText, "fonts/font4.ttf", "#000000")
    createOutlineText(node, "progress_text", 198, 318, 24, "#F7D37C", string.format("当前词条：%d/%d", affixCount, maxNum), "fonts/501.ttf", "#5B2409")
    createOutlineText(node, "arrow_text", 198, 178, 18, "#F5E6C6", string.format("当前箭矢：%d", arrowCount), "fonts/font4.ttf", "#000000")

    for i = 1, maxNum do
        local col = (i - 1) % 3
        local row = math.floor((i - 1) / 3)
        local star = GUI:Image_Create(node, "star_" .. i, star_origin_x + col * star_gap_x, star_origin_y - row * star_gap_y, "res/custom/all_story_mission/4/675/t.png")
        GUI:setAnchorPoint(star, 0.5, 0.5)
        GUI:Image_setGrey(star, i > affixCount)
    end

    renderAffixList(node, npc.data and npc.data.affix_list or {})

    if taskDone and affixCount >= maxNum then
        GUI:Image_Create(node, "finish_img", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
    else
        local shootBtn = GUI:Button_Create(node, "shoot_btn", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/675/btn_1.png")
        GUI:setAnchorPoint(shootBtn, 0.5, 0.5)
        GUI:addOnClickEvent(shootBtn, function()
            SL:SendLuaNetMsg(100, npcId, 1, 0, "")
        end)
    end

    if bagBowCount <= 0 then
        local buyBtn = GUI:Button_Create(node, "buy_btn", btn_pos[1] - 300, btn_pos[2], "res/custom/all_story_mission/4/675/btn_2.png")
        GUI:setAnchorPoint(buyBtn, 0.5, 0.5)
        GUI:addOnClickEvent(buyBtn, function()
            SL:SendLuaNetMsg(100, npcId, 2, 0, "")
        end)
    end
end

function npc.main(npcId, p2, p3, msgData)
    if p2 == 0 or p2 == 1 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcId)
        updateUI(npcId, npc.node)
    end
end

return npc

