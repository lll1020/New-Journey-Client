local npc = {}

npc._config = teshudata["npc_74"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/tdmp/bg.png", eff = false},
}

local ENTRY_POS = {
    {x = 100 + 254,y = 2 + 319},
    {x = 200 - 3,y = 2 + 181},
    {x = 300 + 53,y = 2 + 30},
    {x = 400 + 89,y = 2 + 181},
}

local function getPanelState()
    local data = npc.data or {}
    local T_data = data.T_data or {}
    T_data["npc_74"] = T_data["npc_74"] or {}
    return T_data["npc_74"]
end
local other_wz = {
    "极品仙法爆率+ 5%",
    "境界压制 + 10%",
    "的灵根属性 +5%",
    "灵兽人物属性 + 5%",
}
local function isActivated(idx)
    return tonumber(getPanelState()[tostring(idx)] or 0) == 1
end

local function getActivatedCount()
    return tonumber(getPanelState().all or 0) or 0
end

local function hasAllBonus()
    return tonumber(getPanelState().level_bonus or 0) == 1
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

local function ensureDetailWindow(npcId)
    npc.detailWindow = NPC_UI_HELPER.ensureWindow(npc.detailWindow, npcId, {
        windowName = "npc_74_detail",
        background = {skin = "res/custom/five_city/tdmp/xjm/" .. tostring(npc.detail_idx or 1) .. ".png"},
        closeButton = {x = 265, y = 339, skin = "res/wy/public/close_red_big.png"},
    })
    npc.detailNode = npc.detailWindow.node
    return npc.detailNode
end

local function renderDetail(npcId, idx)
    idx = tonumber(idx) or 1
    npc.detail_idx = idx
    local cfg = npc._config.details[idx]
    if not cfg then
        return
    end

    local node = ensureDetailWindow(npcId)
    GUI:removeAllChildren(node)
    GUI:Image_Create(node, "bg", 0, 0, "res/custom/five_city/tdmp/xjm/" .. tostring(idx) .. ".png")

    -- local nameText = GUI:Text_Create(node, "name", 152, 308, 24, "#FFF2B0", cfg.name or "")
    -- GUI:Text_setFontName(nameText, "fonts/500.ttf")
    -- GUI:setAnchorPoint(nameText, 0.5, 0.5)

    -- local descTitle = GUI:Text_Create(node, "desc_title", 152, 246, 20, "#FF2E2E", "激活条件")
    -- GUI:Text_setFontName(descTitle, "fonts/font4.ttf")
    -- GUI:setAnchorPoint(descTitle, 0.5, 0.5)
    GUI:setAnchorPoint(GUI:RichText_Create(node, "attr_desc", 80, 270, Player:showAttr(npc._config.details[idx].attr).."\n"..other_wz[idx], 200, 16, "#FF00FF", 0,nil,nil)
    , 0, 1)
    local desc = GUI:Text_Create(node, "desc", 308/2, 214 - 115, 18, "#FFFFFF", cfg.desc or "无")
    GUI:setAnchorPoint(desc, 0.5, 0.5)
    GUI:Text_setFontName(desc, "fonts/font4.ttf")
    -- local rewardTitle = GUI:Text_Create(node, "reward_title", 70, 172, 20, "#FFE17A", "额外奖励")
    -- GUI:Text_setFontName(rewardTitle, "fonts/font4.ttf")
    -- GUI:setAnchorPoint(rewardTitle, 0, 0.5)
    -- GUI:setAnchorPoint(GUI:Text_Create(node, "reward", 26, 144, 18, "#FFFFFF", cfg.reward_desc or "无"), 0, 0.5)

    -- local allDesc = npc._config.all_desc or ""
    -- if allDesc ~= "" then
    --     GUI:setAnchorPoint(GUI:Text_Create(node, "all_desc", 26, 104, 18, hasAllBonus() and "#FFE17A" or "#FFE17A", allDesc), 0, 0.5)
    -- end

    local costNode = GUI:Node_Create(node, "cost_node", 34 + 12, 26)
    checkItemNumByTable_img_kuang(cfg.cost or {}, nil, costNode)

    if isActivated(idx) then
        GUI:Image_Create(node, "done", 170, 22 + 116, "res/wy/public/10_2.png")
    else
        local button = GUI:Button_Create(node, "activate", 154, 18 - 85, "res/custom/five_city/tdmp/xjm/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0)
        GUI:addOnClickEvent(button, function()
            SL:SendLuaNetMsg(100, npcId, 1, 0, SL:JsonEncode({idx = idx}, false))
        end)
    end
end

local function renderMain(node, npcId)
    if not node then
        return
    end

    GUI:removeAllChildren(node)
    -- local countText = GUI:Text_Create(node, "count", 392, 50, 22, "#FFF2B0",
    --     string.format("已激活：%d/%d", getActivatedCount(), tonumber(npc._config.all or 0) or 0))
    -- GUI:Text_setFontName(countText, "fonts/500.ttf")
    -- GUI:setAnchorPoint(countText, 0.5, 0.5)

    -- local bonusText = GUI:Text_Create(node, "bonus", 432, 10, 18, "#FFE17A",
    --     hasAllBonus() and "150级后等级+5已激活" or "全命盘激活后等级+5")
    -- GUI:Text_setFontName(bonusText, "fonts/500.ttf")
    -- GUI:setAnchorPoint(bonusText, 0.5, 0.5)
    GUI:Image_Create(node, "wz2", 671, 58, "res/custom/five_city/tdmp/wz2.png")

    GUI:Image_Create(node, "wz1", 600, 50, "res/custom/five_city/tdmp/wz1.png")

    for i, pos in ipairs(ENTRY_POS) do
        local button = GUI:Button_Create(node, "button_" .. i, pos.x, pos.y, "res/custom/five_city/tdmp/" .. tostring(i) .. ".png")
        GUI:addOnClickEvent(button, function()
            renderDetail(npcId, i)
        end)
        if isActivated(i) then
            GUI:Image_Create(button, "done_" .. i, 100 -88, 108 - 60 - 40, "res/wy/public/10_2.png")
        end
        local namePos = {
            [1] = {x = 72, y = 8},
            [2] = {x = 12, y = 14},
            [3] = {x = 24, y = -2},
            [4] = {x = 20, y = 14},
        }
        -- local text = GUI:Text_Create(button, "name_" .. i, namePos[i].x, namePos[i].y, 18, "#FFF2B0", npc._config.details[i].name or "")
        -- GUI:Text_setFontName(text, "fonts/500.ttf")
    end
end

function npc.main(npcId, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcId)
        renderMain(npc.node, npcId)
        if npc.detailWindow and npc.detail_idx then
            renderDetail(npcId, npc.detail_idx)
        end
    elseif p2 == 1 or p2 == 2 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        renderMain(npc.node, npcId)
        if npc.detailWindow and npc.detail_idx then
            renderDetail(npcId, npc.detail_idx)
        end
    end
end

return npc
