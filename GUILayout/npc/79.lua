local npc = {}

local UIHelper = NPC_UI_HELPER
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local LOCAL_BG = "res/custom/six_city/兵 鬼道秘宝/兵道秘宝.png"
local LOCAL_TITLE = "res/custom/six_city/兵 鬼道秘宝/标题.png"
local ITEM_BOX = "res/custom/six_city/兵 鬼道秘宝/装备框-.png"
local COMPOSE_BTN = "res/custom/six_city/兵 鬼道秘宝/立即合成.png"

npc._config = teshudata["npc_79"] or {}

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function getConfig()
    return npc._config or {}
end

local function createText(parent, name, x, y, size, color, value, fontName, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(value or ""))
    GUI:Text_setFontName(label, fontName or FONT_MAIN)
    GUI:Text_enableOutline(label, "#100808", 2)
    if ax ~= nil or ay ~= nil then
        GUI:setAnchorPoint(label, ax or 0, ay or 0.5)
    end
    return label
end

local function createRich(parent, name, x, y, value, width, size)
    local rich = GUI:RichText_Create(parent, name, x, y, tostring(value or ""), width or 360, size or 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, 0, 1)
    return rich
end

local function ensureWindow(npcid)
    local cfg = getConfig()
    npc._window = UIHelper.ensureWindow(npc._window, npcid, {
        titleText = UIHelper.formatNpcTitle(npcid, cfg),
        subTitle = cfg.name,
        background = {skin = LOCAL_BG, eff = false},
        closeButton = {x = 744, y = 507, skin = "res/wy/public/close_red_big.png"},
    })
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function renderItem(parent, name, x, y, itemName, count)
    local box = GUI:Image_Create(parent, name .. "_box", x, y, ITEM_BOX)
    GUI:setAnchorPoint(box, 0.5, 0.5)
    local idx = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(itemName or "")), 0)
    if idx > 0 then
        local item = GUI:ItemShow_Create(box, name, 27, 27, {index = idx, count = count or 1, look = true, movable = false, bgVisible = false})
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        createText(box, name .. "_txt", 27, 27, 11, "#F7D58A", itemName, FONT_MAIN, 0.5, 0.5)
    end
    return box
end

local function formatCostName(v)
    if type(v) ~= "table" then
        return ""
    end
    return tostring(v.name or v[1] or "")
end

local function formatCostCount(v)
    if type(v) ~= "table" then
        return 0
    end
    return toNumber(v.num or v[2], 1)
end

local function renderCost(parent, cfg)
    local pos = {
        {456, 204}, {524, 204}, {592, 204},
        {422, 130}, {490, 130}, {558, 130}, {626, 130},
    }
    for i, v in ipairs(cfg.cost or {}) do
        local p = pos[i]
        if p then
            local name = formatCostName(v)
            local count = formatCostCount(v)
            renderItem(parent, "cost_" .. i, p[1], p[2], name, count)
            createText(parent, "cost_num_" .. i, p[1], p[2] - 34, 13, "#FFCF6A", "x" .. tostring(count), FONT_MAIN, 0.5, 0.5)
        end
    end
end

local function render(node, npcid)
    GUI:removeAllChildren(node)
    local cfg = getConfig()
    local title = GUI:Image_Create(node, "title_img", 557, 356, LOCAL_TITLE)
    GUI:setAnchorPoint(title, 0.5, 0.5)
    createText(node, "item_name", 557, 326, 24, "#FF4135", tostring(cfg.item_name or cfg.name or "道基秘宝"), FONT_TITLE, 0.5, 0.5)
    createText(node, "cost_title", 470, 260, 22, "#F5E6C6", "所需消耗：", FONT_TITLE, 0, 0.5)
    renderCost(node, cfg)

    local hasItem = toNumber(npc.data and npc.data.has_item, 0) == 1
    local btn = GUI:Button_Create(node, "compose_btn", 557, 38, COMPOSE_BTN)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    if hasItem then
        createText(node, "owned", 557, 82, 20, "#8DFF72", "已拥有", FONT_TITLE, 0.5, 0.5)
    else
        GUI:addOnClickEvent(btn, function()
            SL:OpenCommonTipsPop({
                str = "确认合成【" .. tostring(cfg.item_name or "秘宝") .. "】吗？",
                btnType = 2,
                callback = function(atype)
                    if atype == 1 then
                        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                    end
                end,
            })
        end)
        if UIHelper and UIHelper.redpoint_create then
            UIHelper.redpoint_create(btn, {x = 174, y = 58})
        end
    end
end

function npc.main(npcid, p2, p3, msgData)
    npc.data = SL:JsonDecode(msgData, false) or {}
    ensureWindow(npcid)
    render(npc.node, npcid)
end

return npc
