local npc = {}

local UIHelper = NPC_UI_HELPER
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN = "res/public/1900000660.png"
local BG = "res/custom/six_city/残魂商店/示意图.png"
local ITEM_BOX = "res/custom/six_city/残魂商店/_装备框-.png"
local DIVIDER = "res/custom/six_city/残魂商店/分割线-.png"
local TITLE_BANNER = "res/custom/six_city/残魂商店/标题.png"

npc._config = teshudata["npc_78"] or {}

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then return defaultValue or 0 end
    return num
end

local function createText(parent, name, x, y, size, color, value, font, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(value or ""))
    GUI:Text_setFontName(label, font or FONT_MAIN)
    GUI:Text_enableOutline(label, "#100808", 2)
    if ax ~= nil or ay ~= nil then GUI:setAnchorPoint(label, ax or 0, ay or 0.5) end
    return label
end

local function createRich(parent, name, x, y, value, width, size)
    local rich = GUI:RichText_Create(parent, name, x, y, tostring(value or ""), width or 360, size or 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(rich, 0, 1)
    return rich
end

local function ensureWindow(npcid)
    npc._window = UIHelper.ensureWindow(npc._window, npcid, {
        titleText = UIHelper.formatNpcTitle(npcid, npc._config),
        subTitle = npc._config.name,
        background = {skin = BG, eff = false},
        closeButton = {x = 742, y = 500, skin = "res/wy/public/close_red_big.png"},
    })
    npc.node = npc._window.node
    npc.bg = npc._window.bg
    return npc.node
end

local function renderItem(parent, name, x, y, itemName)
    local box = GUI:Image_Create(parent, name .. "_box", x, y, ITEM_BOX)
    GUI:setAnchorPoint(box, 0.5, 0.5)
    local idx = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(itemName or "")), 0)
    if idx > 0 then
        local item = GUI:ItemShow_Create(box, name, 29, 30, {index = idx, look = true, movable = false, bgVisible = false})
        GUI:setAnchorPoint(item, 0.5, 0.5)
    else
        createText(box, name .. "_txt", 29, 30, 11, "#F7D58A", itemName, FONT_MAIN, 0.5, 0.5)
    end
    return box
end

local function pathLabel(god, path)
    if toNumber(god, 0) == 1 then
        return toNumber(path, 0) == 1 and "兵道·止戈" or "兵道·杀伐"
    end
    return toNumber(path, 0) == 1 and "鬼道·无常" or "鬼道·阎罗"
end

local function renderEquipRow(parent, npcid, idx, cfg, y)
    GUI:Image_Create(parent, "line_" .. idx, 0, y - 7, DIVIDER)
    renderItem(parent, "item_" .. idx, 34, y + 22, cfg.name)
    createText(parent, "name_" .. idx, 86, y + 45, 18, "#F6D38B", tostring(cfg.name or ""), FONT_TITLE, 0, 0.5)
    createText(parent, "type_" .. idx, 86, y + 20, 15, "#C9B390", pathLabel(cfg.god, cfg.path) .. "  " .. tostring(cfg.type or ""), FONT_MAIN, 0, 0.5)
    createText(parent, "rate_" .. idx, 286, y + 44, 15, "#FFD86B", tostring(cfg.map or "") .. "  " .. tostring(cfg.rate or ""), FONT_MAIN, 0, 0.5)
    createText(parent, "attr_" .. idx, 286, y + 20, 15, "#8DFF72", tostring(cfg.desc or ""), FONT_MAIN, 0, 0.5)

    local btn = GUI:Button_Create(parent, "recycle_" .. idx, 600, y + 10, BTN)
    GUI:Button_setTitleText(btn, "回收")
    GUI:Button_setTitleFontSize(btn, 17)
    GUI:addOnClickEvent(btn, function()
        SL:OpenCommonTipsPop({
            str = "确认回收【" .. tostring(cfg.name or "") .. "】获得" .. tostring(npc._config.recycle_money or 0) .. tostring(npc._config.recycle_money_name or "") .. "吗？",
            btnType = 2,
            callback = function(atype)
                if atype == 1 then
                    SL:SendLuaNetMsg(100, npcid, 1, idx, SL:JsonEncode({idx = idx}, false))
                end
            end,
        })
    end)
end

local function render(node, npcid)
    GUI:removeAllChildren(node)
    GUI:Image_Create(node, "title_banner", 182, 446, TITLE_BANNER)
    createText(node, "title", 396, 472, 30, "#FFE08A", "神道装备", FONT_TITLE, 0.5, 0.5)
    createText(node, "sub", 396, 438, 17, "#F5E6C6", tostring(npc._config.suit_desc or ""), FONT_MAIN, 0.5, 0.5)
    createText(node, "recycle_desc", 706, 472, 17, "#FFD86B", "回收：" .. tostring(npc._config.recycle_money or 0) .. tostring(npc._config.recycle_money_name or ""), FONT_TITLE, 1, 0.5)
    createText(node, "head_name", 82, 386, 22, "#BFC0C3", "物品名称", FONT_TITLE, 0, 0.5)
    createText(node, "head_need", 302, 386, 22, "#BFC0C3", "掉落来源", FONT_TITLE, 0, 0.5)
    createText(node, "head_buy", 588, 386, 22, "#BFC0C3", "回收按钮", FONT_TITLE, 0, 0.5)

    local list = npc._config.equip or {}
    local scroll = GUI:ScrollView_Create(node, "equip_scroll", 42, 82, 694, 284, 1)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local innerH = math.max(284, #list * 72)
    GUI:ScrollView_setInnerContainerSize(scroll, 694, innerH)
    for i, cfg in ipairs(list) do
        renderEquipRow(scroll, npcid, i, cfg, innerH - i * 72 + 4)
    end

    createRich(node, "tip", 48, 48, "<font color='#C9B390'>提示：</font><font color='#F5E6C6'>神道装备来自兵道/鬼道古藏，回收只处理当前背包内对应装备。</font>", 670, 15)
end

function npc.main(npcid, p2, p3, msgData)
    npc.data = SL:JsonDecode(msgData, false) or {}
    ensureWindow(npcid)
    render(npc.node, npcid)
end

return npc
