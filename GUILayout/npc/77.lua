local npc = {}

local UIHelper = NPC_UI_HELPER
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local BTN = "res/public/1900000660.png"

npc._config = teshudata["npc_77"] or {}

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then return defaultValue or 0 end
    return num
end

local function getState()
    return (npc.data and npc.data.T_data) or {}
end

local function getGodState(state, god)
    local gods = state.gods or {}
    return gods[tostring(god)] or gods[god] or {}
end

local function getPower(state, god)
    return toNumber(getGodState(state, god).power, 0)
end

local function isCert(state, god)
    return toNumber(getGodState(state, god).cert, 0) >= 1
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
    })
    npc.node = npc._window.node
    npc.bg = npc._window.bg
    return npc.node
end

local function renderPathCard(parent, npcid, god, x, y, selected)
    local cfg = (npc._config.shendao or {})[god] or {}
    local state = getState()
    local info = getGodState(state, god)
    local pathIdx = toNumber(info.path, 0)
    local pathNameText = ""
    if cfg.paths and cfg.paths[pathIdx] then
        pathNameText = tostring(cfg.paths[pathIdx].name or "")
    end
    local card = GUI:Node_Create(parent, "card_" .. god, x, y)
    createText(card, "name_" .. god, 150, 170, 24, selected and "#9DFF7A" or "#FFE08A", cfg.name or "神道", FONT_TITLE, 0.5, 0.5)
    createText(card, "power_" .. god, 150, 142, 18, "#8DFF72", string.format("%s：%d/%d", tostring(cfg.power_name or "神力值"), getPower(state, god), toNumber(npc._config.power_max, 1000)), FONT_MAIN, 0.5, 0.5)
    createText(card, "cert_state_" .. god, 150, 118, 17, isCert(state, god) and "#6CFF7B" or "#FF6A5A", isCert(state, god) and "自证奖励：已领取" or ("自证奖励：" .. tostring(cfg.certify_title or "")), FONT_MAIN, 0.5, 0.5)
    createText(card, "map_" .. god, 150, 96, 15, "#C9B390", tostring(cfg.map_desc or ""), FONT_MAIN, 0.5, 0.5)

    local y0 = 62
    for path, pcfg in ipairs(cfg.paths or {}) do
        local chosen = pathIdx == path
        createText(card, "path_name_" .. god .. "_" .. path, 10, y0 + 42, 18, chosen and "#9DFF7A" or "#F7E2B0", pcfg.name or "路径", FONT_TITLE, 0, 0.5)
        createRich(card, "path_desc_" .. god .. "_" .. path, 10, y0 + 24, tostring(pcfg.desc or ""), 210, 14)
        local btn = GUI:Button_Create(card, "select_" .. god .. "_" .. path, 218, y0 + 18, BTN)
        GUI:Button_setTitleText(btn, "选择")
        GUI:Button_setTitleFontSize(btn, 16)
        GUI:addOnClickEvent(btn, function()
            SL:OpenCommonTipsPop({
                str = "确认选择【" .. tostring(cfg.name or "") .. "·" .. tostring(pcfg.name or "") .. "】吗？选择后不可重复选择。",
                btnType = 2,
                callback = function(atype)
                    if atype == 1 then
                        SL:SendLuaNetMsg(100, npcid, 1, god, SL:JsonEncode({god = god, path = path}, false))
                    end
                end,
            })
        end)
        y0 = y0 - 66
    end

    local up = GUI:Button_Create(card, "upgrade_" .. god, 56, -94, BTN)
    GUI:Button_setTitleText(up, "升阶")
    GUI:Button_setTitleFontSize(up, 18)
    GUI:addOnClickEvent(up, function()
        SL:SendLuaNetMsg(100, npcid, 2, god, SL:JsonEncode({god = god}, false))
    end)

    local cert = GUI:Button_Create(card, "cert_btn_" .. god, 188, -94, BTN)
    GUI:Button_setTitleText(cert, "自证")
    GUI:Button_setTitleFontSize(cert, 18)
    GUI:addOnClickEvent(cert, function()
        SL:SendLuaNetMsg(100, npcid, 3, god, SL:JsonEncode({god = god}, false))
    end)
end

local function render(node, npcid)
    GUI:removeAllChildren(node)
    local state = getState()
    createText(node, "title", 394, 424, 34, "#FFE08A", "登神之路", FONT_TITLE, 0.5, 0.5)
    local chosen = {}
    for god in pairs(npc._config.shendao or {}) do
        local info = getGodState(state, god)
        local cfg = (npc._config.shendao or {})[god] or {}
        local pathIdx = toNumber(info.path, 0)
        if pathIdx > 0 then
            local pathNameText = ""
            if cfg.paths and cfg.paths[pathIdx] then
                pathNameText = tostring(cfg.paths[pathIdx].name or "")
            end
            chosen[#chosen + 1] = tostring(cfg.name or "") .. "·" .. pathNameText .. " " .. tostring(toNumber(info.rank, 1)) .. "/" .. tostring(toNumber(npc._config.max_rank, 9)) .. "阶"
        end
    end
    if #chosen > 0 then
        createText(node, "cur", 394, 392, 18, "#8DFF72", "当前路线：" .. table.concat(chosen, "    "), FONT_MAIN, 0.5, 0.5)
    else
        createText(node, "hint", 394, 392, 18, "#FFD86B", "兵神道、鬼神道可各选一条路线，自证后不可重复切换。", FONT_MAIN, 0.5, 0.5)
    end

    local state = getState()
    renderPathCard(node, npcid, 1, 112, 202, toNumber(getGodState(state, 1).path, 0) > 0)
    renderPathCard(node, npcid, 2, 420, 202, toNumber(getGodState(state, 2).path, 0) > 0)
    createText(node, "all_reward", 70, 54, 22, "#FF4B3B", "全部激活后获得：", FONT_TITLE, 0, 0.5)
end

function npc.main(npcid, p2, p3, msgData)
    npc.data = SL:JsonDecode(msgData, false) or {}
    ensureWindow(npcid)
    render(npc.node, npcid)
end

return npc
