local npc = {}
npc._config = teshudata and teshudata["npc_104"] or {}
local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/104/npc_104_seq/npc_104_00000.png"},
    closeButton = {x = 742, y = 455},
}
local CLIENT_CONFIG = {
    max_refresh = 999999,
}
local OUTLINE_COLOR = "#100808"
local NAME_COLOR_MAP = {
    ["杀伐"] = "#ff3f32",
    ["夺金"] = "#35e7ff",
    ["幸运"] = "#ffd24a",
    ["神罚"] = "#d46bff",
    ["历练"] = "#35e7ff",
    ["回收"] = "#35e7ff",
    ["爆率"] = "#ffd24a",
    ["暴击"] = "#d46bff",
    ["急速"] = "#40f28b",
}
local DISPLAY_NAME_MAP = {
    ["爆率"] = "幸运",
    ["暴击"] = "神罚",
}
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
local function getMaxRefresh()
    return math.max(toNumber((getConfig() or {}).max_refresh, 0), CLIENT_CONFIG.max_refresh)
end
local function ensureWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end
-- 运行态数据只做兜底，避免服务端刷新时机不同导致客户端报错。
local function normalizeData(data)
    data = type(data) == "table" and data or {}
    data.T_data = type(data.T_data) == "table" and data.T_data or {}
    data.T_data.refresh_times = toNumber(data.T_data.refresh_times, 0)
    data.T_data.preview = type(data.T_data.preview) == "table" and data.T_data.preview or {}
    data.T_data.preview_keep = toNumber(data.T_data.preview_keep, 0)
    data.preview = type(data.preview) == "table" and data.preview or data.T_data.preview or {}
    data.current = type(data.current) == "table" and data.current or {}
    data.current_list = type(data.current_list) == "table" and data.current_list or {}
    return data
end
local function createStrokeText(parent, name, x, y, size, color, text, anchorX, anchorY, fontName)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    local ax = anchorX
    local ay = anchorY
    if ax == nil then
        ax = 0.5
    end
    if ay == nil then
        ay = 0.5
    end
    GUI:setAnchorPoint(label, ax, ay)
    GUI:Text_enableOutline(label, OUTLINE_COLOR, 2)
    if fontName then
        GUI:Text_setFontName(label, fontName)
    end
    return label
end
local function createRich(parent, name, x, y, width, size, content, color, anchorX, anchorY)
    local rich = GUI:RichText_Create(parent, name, x, y, content or "", width or 220, size or 18, color or "#f7f7de", 1, nil, nil, {
        outlineSize = 2,
        outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),
    })
    local ax = anchorX
    local ay = anchorY
    if ax == nil then
        ax = 0
    end
    if ay == nil then
        ay = 0.5
    end
    GUI:setAnchorPoint(rich, ax, ay)
    return rich
end
local function getEquippedTianshu()
    local cfg = getConfig()
    return SL:GetMetaValue("EQUIP_DATA", toNumber(cfg.where, 90))
end
local function getItemCountByName(name)
    if not name or name == "" then
        return 0
    end
    local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name), 0)
    if itemIndex > 0 then
        local itemCount = tonumber(SL:GetMetaValue("ITEM_COUNT", itemIndex))
        if itemCount ~= nil then
            return itemCount
        end
    end
    local total = 0
    local bagItems = SL:GetMetaValue("BAG_DATA") or {}
    for _, item in pairs(bagItems) do
        if type(item) == "table" then
            local itemName = tostring(item.Name or item.name or "")
            if itemName == name then
                total = total + toNumber(item.Overlap or item.count or item.Count, 1)
            elseif itemIndex > 0 and toNumber(item.Index, 0) == itemIndex then
                total = total + toNumber(item.Overlap or item.count or item.Count, 1)
            end
        end
    end
    return total
end
local function getCostOwnedCount(itemName, itemIndex)
    if not itemName or itemName == "" then
        return 0
    end
    if itemName == "金币" then
        return toNumber(SL:GetMetaValue("MONEY_ASSOCIATED", 3), 0)
    end
    return getItemCountByName(itemName)
end
local function getCostState()
    local cfg = getConfig()
    local cost = cfg.cost or {}
    local list = {}
    for idx, one in ipairs(cost) do
        local itemName = one and one[1] or ""
        local need = toNumber(one and one[2], 0)
        local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName), 0)
        local itemData = itemIndex > 0 and SL:GetMetaValue("ITEM_DATA", itemIndex) or nil
        list[#list + 1] = {
            idx = idx,
            name = itemName,
            need = need,
            have = getCostOwnedCount(itemName, itemIndex),
            itemData = itemData,
            itemIndex = itemIndex,
        }
    end
    return list
end
local function getChoiceNameColor(name)
    return NAME_COLOR_MAP[tostring(name or "")] or "#ffe4ae"
end
local function getDisplayName(name)
    name = tostring(name or "")
    return DISPLAY_NAME_MAP[name] or name
end
local function buildDescFromAttrs(name, attrs)
    attrs = type(attrs) == "table" and attrs or {}
    local values = {}
    local attrIds = {}
    for idx, attr in ipairs(attrs) do
        values[idx] = toNumber(attr.value or attr[3], 0)
        attrIds[idx] = toNumber(attr.id or attr[2], 0)
    end
    if #attrIds == 2 and attrIds[1] == 66 and attrIds[2] == 204 then
        return string.format("打怪经验+%d%% 金币回收+%d%%", math.floor((values[1] or 0) / 100), math.floor((values[2] or 0) / 100))
    end
    if #attrIds == 2 and attrIds[1] == 200 and attrIds[2] == 201 then
        return string.format("攻击速度+%d%%", math.floor((values[1] or 0) / 100))
    end
    if name == "爆率" then
        return string.format("打怪爆率+%d%%", math.floor((values[1] or 0) / 100))
    elseif name == "杀伐" then
        return string.format("攻击伤害+%d%%", math.floor((values[1] or 0) / 100))
    elseif name == "历练" then
        return string.format("打怪经验+%d%%", math.floor((values[1] or 0) / 100))
    elseif name == "回收" then
        return string.format("金币回收+%d%%", math.floor((values[1] or 0) / 100))
    elseif name == "夺金" then
        return string.format("打怪经验+%d%% 金币回收+%d%%", math.floor((values[1] or 0) / 100), math.floor((values[2] or 0) / 100))
    elseif name == "暴击" then
        return string.format("暴击几率+%d%%", values[1] or 0)
    elseif name == "急速" then
        return string.format("攻击速度+%d%%", math.floor((values[1] or 0) / 100))
    end
    return ""
end
local function normalizeLegacyDesc(name, desc)
    desc = tostring(desc or "")
    if desc == "" then
        return ""
    end
    if name == "急速" then
        local value = tonumber(string.match(desc, "攻击速度%+(%d+)%%"))
        if value then
            return string.format("攻击速度+%d%%", math.floor(value / 100))
        end
    end
    return desc
end
local function getChoiceState(choice)
    choice = type(choice) == "table" and choice or {}
    local rawName = tostring(choice.name or "")
    local name = getDisplayName(rawName)
    local desc = buildDescFromAttrs(rawName, choice.attrs)
    if desc == "" then
        desc = buildDescFromAttrs(name, choice.attrs)
    end
    if desc == "" then
        desc = normalizeLegacyDesc(rawName ~= "" and rawName or name, choice.desc)
    end
    if name == "" and desc == "" then
        desc = "暂无词条"
    end
    return {
        name = name,
        desc = desc,
        attrs = type(choice.attrs) == "table" and choice.attrs or {},
        _displayReady = true,
    }
end
local function buildChoiceRichText(choice, idx, selected)
    local state = choice
    if type(state) ~= "table" or state._displayReady ~= true then
        state = getChoiceState(choice)
    end
    local prefix = idx and string.format("%d.", idx) or ""
    local headColor = getChoiceNameColor(state.name)
    local bodyColor = selected and "#fff6dc" or "#f5ead3"
    if state.name == "" then
        return string.format("<font color='%s'>%s</font>", bodyColor, state.desc)
    end
    return string.format("%s<font color='%s'>%s：\n</font><font color='%s'>%s</font>", prefix, headColor, state.name, bodyColor, state.desc)
end
local getCurrentChoice
local getPreviewChoice
local function canRefresh(data)
    return toNumber((data.T_data or {}).refresh_times, 0) < getMaxRefresh()
end
local function setButtonState(button, enabled)
    if not button then
        return
    end
    GUI:Button_setGrey(button, not enabled)
    GUI:setTouchEnabled(button, enabled)
end
local function renderTianshuItem(parent, name, x, y)
    local holder = GUI:Image_Create(parent, name, x, y, "res/custom/one_city/104/item_frame.png")
    GUI:setAnchorPoint(holder, 0.5, 0.5)
    local equip = getEquippedTianshu()
    if equip then
        UiTools.showItemData(holder, equip)
    else
        createStrokeText(holder, name .. "_empty", 90, 84, 18, "#ffe5c7", "未装配", 0.5, 0.5, "fonts/500.ttf")
    end
    return holder
end
local function renderCost(node, data)
    local costList = getCostState()
    local label = GUI:Image_Create(node, "cost_label", 100, 50, "res/custom/one_city/104/refresh_cost_label.png")
    GUI:setAnchorPoint(label, 0, 0.5)
    local startX = 275
    local gapX = 100
    local cost_show = checkItemNumByTable_img_kuang(getConfig().cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost_show, startX, 25)
    -- for idx, costState in ipairs(costList) do
    --     local baseX = startX + (idx - 1) * gapX
    --     local iconBg = GUI:Image_Create(node, "cost_item_bg_" .. idx, baseX, 44, "res/wy/public/58_58_kuang.png")
    --     GUI:setAnchorPoint(iconBg, 0.5, 0.5)
    --     if costState.itemData then
    --         UiTools.showItemData(iconBg, costState.itemData)
    --     else
    --         createStrokeText(node, "cost_name_" .. idx, baseX, 44, 16, "#ffe5c7", tostring(costState.name or ""), 0.5, 0.5, "fonts/500.ttf")
    --     end
    --     local countColor = costState.have >= costState.need and "#7dff9b" or "#ff7e7e"
    --     createRich(node, "cost_count_" .. idx, baseX + 34, 40, 120, 17,
    --         string.format("<font color='%s'>%s</font><font color='#f7f7de'>/%s</font>", countColor, tostring(costState.have), tostring(costState.need)),
    --         "#f7f7de", 0, 0.5)
    -- end
    -- createStrokeText(node, "refresh_times", 600, 87, 20, "#fff1c8",
    --     string.format("已刷新 %d/%d 次", toNumber((data.T_data or {}).refresh_times, 0), getMaxRefresh()),
    --     0.5, 0.5, "fonts/500.ttf")
end
getCurrentChoice = function(data)
    if type(data.current_list) == "table" and #data.current_list > 0 then
        return getChoiceState(data.current_list[#data.current_list])
    end
    return getChoiceState(data.current)
end
getPreviewChoice = function(data)
    local preview = data.preview
    if type(preview) == "table" then
        if tostring(preview.name or "") ~= "" or type(preview.attrs) == "table" then
            return getChoiceState(preview)
        end
        if type(preview[1]) == "table" then
            return getChoiceState(preview[1])
        end
    end
    return getChoiceState(nil)
end
local function renderCurrentPanel(node, data)
    local panel = GUI:Image_Create(node, "attr_panel", 500, 150, "res/custom/one_city/104/attr_panel.png")
    GUI:setAnchorPoint(panel, 0, 0)
    local current = getCurrentChoice(data)
    if current.name ~= "" then
        createRich(node, "current_summary", 135, 120, 360, 20, buildChoiceRichText(current, nil, true), "#f7f7de", 0, 0.5)
    end
end
local function renderMain(node, npcid, data)
    -- createRich(node, "top_tip_text", 120, 455, 620, 20,
    --     string.format("<font color='#f7f7de'>请为你的天书附魔先天词条，至多可刷新%d次！</font>", getMaxRefresh()),
    --     "#f7f7de", 0, 0.5)
    renderTianshuItem(node, "tianshu_item", 246, 210)
    renderCurrentPanel(node, data)
    renderCost(node, data)
    local refreshBtn = GUI:Button_Create(node, "main_refresh_btn", 500, 20, "res/custom/one_city/104/main_refresh.png")
    GUI:addOnClickEvent(refreshBtn, function()
        SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    end)
    NPC_UI_HELPER.tryStartXylGuide(npc, refreshBtn, node, "tianshu_refine_once", {
        taskNames = {"洗炼天书","引导天书使者洗炼一次"},
        dir = 5,
        desc = "点击洗炼天书",
    })
    -- setButtonState(refreshBtn, canRefresh(data))
    if canRefresh(data) and checkItemNum(getConfig().cost or {}) then
        NPC_UI_HELPER.redpoint_create_eff(refreshBtn, {x = 176 + 40, y = 37, autoScale = 0.5})
    end
end
local function renderPreviewPanel(node, npcid, data)
    local preview = getPreviewChoice(data)
    if preview.name == "" then
        return
    end
    local panel = GUI:Image_Create(node, "preview_panel", 190, 230, "res/custom/one_city/104/panel2/bg.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    renderTianshuItem(panel, "preview_item", 397 - 85, 266 - 93)
    createRich(panel, "preview_new", 64, 180, 150, 22, buildChoiceRichText(preview, nil, true), "#f7f7de", 0, 1)
    local current = getCurrentChoice(data)
    local currentText = current.name ~= "" and buildChoiceRichText(current, nil, true) or "<font color='#f5ead3'>暂无词条</font>"
    createRich(panel, "preview_current", 388, 180, 150, 22, currentText, "#f7f7de", 0, 1)
    -- createStrokeText(panel, "preview_tip", 555, 24, 16, "#5a4b3f",
    --     string.format("已刷新 %d/%d 次", toNumber((data.T_data or {}).refresh_times, 0), getMaxRefresh()),
    --     0.5, 0.5, "fonts/500.ttf")
    -- local refreshBtn = GUI:Button_Create(panel, "preview_refresh_btn", 198 - 121, 8, "res/custom/one_city/104/panel2/refresh.png")
    -- GUI:addOnClickEvent(refreshBtn, function()
    --     SL:SendLuaNetMsg(100, npcid, 1, 0, "")
    -- end)
    -- setButtonState(refreshBtn, canRefresh(data))
    local keepBtn = GUI:Button_Create(panel, "preview_keep_btn", 522 - 121, 8, "res/custom/one_city/104/panel2/keep.png")
    GUI:addOnClickEvent(keepBtn, function()
        SL:SendLuaNetMsg(100, npcid, 2, 1, SL:JsonEncode({idx = 1}))
    end)
    NPC_UI_HELPER.tryStartXylGuide(npc, keepBtn, panel, "tianshu_refine_once", {
        taskNames = {"洗炼天书","引导天书使者洗炼一次"},
        dir = 5,
        desc = "点击洗炼天书",
    })
    setButtonState(keepBtn, true)
end
local function UI_updata(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local mainLayer = GUI:Node_Create(node, "main_layer", 0, 0)
    renderMain(mainLayer, npcid, npc.data)
    local preview = getPreviewChoice(npc.data)
    if preview.name ~= "" then
        GUI:setOpacity(mainLayer, 150)
        renderPreviewPanel(node, npcid, npc.data)
    else
        GUI:setOpacity(mainLayer, 255)
    end
end
function npc.main(npcid, p2, p3, msgData)
    if msgData and msgData ~= "" then
        npc.data = normalizeData(SL:JsonDecode(msgData, false))
    else
        npc.data = normalizeData(npc.data)
    end
    local node = ensureWindow(npcid)
    UI_updata(node, npcid)
end
return npc
