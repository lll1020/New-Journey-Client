local npc = {}

local MIJING_CFG = {
    [86] = {name = "极光秘境", img = "极光秘境.png", need = "高级玩家赞助可进", artifact = "极光石", titleItem = "极光使者[可使用]"},
    [87] = {name = "苍云秘境", img = "苍云秘境.png", need = "高级玩家赞助可进", artifact = "苍云镜", titleItem = "白云苍狗[可使用]"},
    [88] = {name = "若水秘境", img = "若水秘境.png", need = "至尊玩家赞助可进", artifact = "若水灵珠", titleItem = "上善若水[可使用]"},
    [89] = {name = "红尘秘境", img = "红尘秘境.png", need = "至尊玩家赞助可进", artifact = "斩红尘", titleItem = "看破红尘[可使用]"},
    [90] = {name = "灵虚秘境", img = "灵虚秘境.png", need = "激活5条红色仙法", artifact = "灵虚剑", titleItem = "归入灵虚[可使用]"},
}

local WINDOW_OPTS = {
    background = {skin = "res/custom/mijing/示意图.png"},
    closeButton = {x = 720 - 120, y = 420 - 120},
    node = {x = 500, y = 300},
}

local function fileExists(path)
    return SL and SL.IsFileExist and SL:IsFileExist(path)
end

local function getBgPath(cfg)
    local path = "res/custom/mijing/" .. tostring((cfg and cfg.img) or "示意图.png")
    if fileExists(path) then
        return path
    end
    return "res/custom/mijing/示意图.png"
end

local function createOutlineText(parent, name, x, y, size, color, text)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:Text_setFontName(label, "fonts/font4.ttf")
    GUI:Text_enableOutline(label, "#140806", 2)
    GUI:setAnchorPoint(label, 0.5, 0.5)
    return label
end

local function getItemIndex(name)
    return tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(name or "")) or 0) or 0
end

local function createRewardCard(parent, name, x, y, iconPath, itemName)
    local icon = GUI:Image_Create(parent, "type_icon"..name, x, y, iconPath)
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    local idx = getItemIndex(itemName)
    if idx > 0 then
        local item = GUI:ItemShow_Create(icon, "item", 25 + 20, 24 + 20, {index = idx, look = true})
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        createOutlineText(icon, "empty", 25 + 20, 24 + 20, 14, "#ffe9a6", "待配置")
    end
    return icon
end

local function ensureWindow(npcid, cfg)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.background = {skin = getBgPath(cfg)}
    opts.titleText = cfg and cfg.name or NPC_UI_HELPER.formatNpcTitle(npcid)
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function render(node, npcid, cfg)
    GUI:removeAllChildren(node)
    local data = npc.data or {}
    local name = tostring(data.name or (cfg and cfg.name) or "秘境")
    local needText = tostring(data.need_desc or (cfg and cfg.need) or "")
    local artifact = tostring(data.artifact or (cfg and cfg.artifact) or "")
    local titleItem = tostring(data.title_item or (cfg and cfg.titleItem) or "")

    -- createOutlineText(node, "title", 0, 150, 32, "#ffe9b8", name)
    createOutlineText(node, "need", -130, -190, 20, "#e9f7ff", needText)
    createOutlineText(node, "status", 128 - 135, -190, 20, tonumber(data.can_enter or 0) == 1 and "#63ff8f" or "#ff7777", tonumber(data.can_enter or 0) == 1 and "已满足" or "未满足")

    -- createOutlineText(node, "reward_title", 0, 92, 24, "#ffdf87", "秘境掉落展示")
    createRewardCard(node, "artifact_card", -105 - 160, 20 - 145, "res/custom/mijing/背包神器.png", artifact)
    createRewardCard(node, "title_card", 105 - 160, 20 - 145, "res/custom/mijing/顶级称号.png", titleItem)

    local btn = GUI:Button_Create(node, "enter_btn", -166, -243, "res/custom/mijing/进入秘境.png")
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
end

function npc.main(npcid, p2, p3, msgData)
    local cfg = MIJING_CFG[tonumber(npcid or 0)] or MIJING_CFG[86]
    if type(msgData) == "string" and msgData ~= "" then
        npc.data = SL:JsonDecode(msgData, false) or {}
    else
        npc.data = npc.data or {}
    end
    ensureWindow(npcid, cfg)
    render(npc.node, npcid, cfg)
end

return npc
