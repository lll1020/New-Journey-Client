local npc = {}

local UIHelper = NPC_UI_HELPER
local FONT_MAIN = "fonts/font4.ttf"
local FONT_TITLE = "fonts/502.ttf"
local RES = "res/custom/six_city/登神之路/"
local BG = RES .. "登神之路底.png"
local TITLE = RES .. "标题.png"
local BACK = RES .. "返回按钮.png"
local HOME_BG = RES .. "首页/登神之路1.png"
local HOME_BTN_RED = RES .. "首页/查看详情（红）.png"
local HOME_BTN_YELLOW = RES .. "首页/查看详情（黄）.png"
local PATH_BG = {
    [1] = RES .. "选择路径/兵神道.png",
    [2] = RES .. "选择路径/鬼神道.png",
}
local PATH_BTN = {
    [1] = {[1] = "路径·止戈.png", [2] = "路径·杀伐.png"},
    [2] = {[1] = "路径·无常.png", [2] = "路径·阎罗.png"},
}
local PATH_CONFIRM = RES .. "选择路径/选择此路径.png"
local UPGRADE_BG = {
    [1] = RES .. "神道进阶/兵神道进阶.png",
    [2] = RES .. "神道进阶/鬼神道进阶.png",
}
local UPGRADE_BTN = RES .. "神道进阶/神道进阶.png"
local CERT_BG = {
    [1] = RES .. "神道自证/兵神道进阶.png",
    [2] = RES .. "神道自证/鬼神道进阶.png",
}
local CERT_BTN = RES .. "神道自证/开始自证.png"

npc._config = teshudata["npc_77"] or {}
npc._view = "home"
npc._god = 1

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then return defaultValue or 0 end
    return num
end

local function state()
    return (npc.data and npc.data.T_data) or {}
end

local function godState(god)
    local gods = state().gods or {}
    return gods[tostring(god)] or gods[god] or {}
end

local function godCfg(god)
    return (npc._config.shendao or {})[god] or {}
end

local function pathCfg(god, path)
    return (godCfg(god).paths or {})[path] or {}
end

local function selectedPath(god)
    return toNumber(godState(god).path, 0)
end

local function resolveActiveGod(preferGod)
    preferGod = toNumber(preferGod, 0)
    if preferGod == 1 or preferGod == 2 then
        return preferGod
    end
    local currentGod = toNumber(npc._god, 1)
    if currentGod == 1 or currentGod == 2 then
        return currentGod
    end
    return 1
end

local function resolveDefaultView(god)
    return selectedPath(god) > 0 and "cert" or "path"
end

local function rank(god)
    return math.max(1, toNumber(godState(god).rank, 1))
end

local function power(god)
    return toNumber(godState(god).power, 0)
end

local function cert(god)
    return toNumber(godState(god).cert, 0) >= 1
end

local function applyLocalPathChoice(god, path)
    npc.data = npc.data or {}
    npc.data.T_data = npc.data.T_data or {}
    npc.data.T_data.gods = npc.data.T_data.gods or {}
    local key = tostring(god)
    local info = npc.data.T_data.gods[key] or {}
    info.path = toNumber(path, 0)
    info.rank = math.max(1, toNumber(info.rank, 1))
    info.power = toNumber(info.power, 0)
    info.kills = type(info.kills) == "table" and info.kills or {}
    info.cert = toNumber(info.cert, 0)
    npc.data.T_data.gods[key] = info
end

local function text(parent, name, x, y, size, color, value, font, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 18, color or "#FFFFFF", tostring(value or ""))
    GUI:Text_setFontName(label, font or FONT_MAIN)
    GUI:Text_enableOutline(label, "#120806", 2)
    GUI:setAnchorPoint(label, ax == nil and 0.5 or ax, ay == nil and 0.5 or ay)
    return label
end

local function rich(parent, name, x, y, value, width, size)
    local node = GUI:RichText_Create(parent, name, x, y, tostring(value or ""), width or 360, size or 18, "#FFFFFF", 0, nil, nil)
    GUI:setAnchorPoint(node, 0, 1)
    return node
end

local function button(parent, name, x, y, skin, cb)
    local btn = GUI:Button_Create(parent, name, x, y, skin)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    GUI:addOnClickEvent(btn, cb)
    return btn
end

local function pathStateText(god)
    local p = selectedPath(god)
    if p <= 0 then
        return "当前路线：未选择"
    end
    return "当前路线：" .. tostring(pathCfg(god, p).name or "未选择")
end

local function ensureWindow(npcid)
    npc._window = UIHelper.ensureWindow(npc._window, npcid, {
        titleText = UIHelper.formatNpcTitle(npcid, npc._config),
        subTitle = npc._config.name,
        background = {skin = BG, eff = false},
        closeButton = {x = 780, y = 438, skin = "res/wy/public/close_red_big.png"},
    })
    npc.node = npc._window.node
    return npc.node
end

local function send(npcid, action, god, payload)
    SL:SendLuaNetMsg(100, npcid, action, god or 0, SL:JsonEncode(payload or {god = god}, false))
end

local function renderTop(node)
    GUI:Image_Create(node, "title_img", 18, 42, TITLE)
end

local function renderBack(node, npcid)
    button(node, "back_btn", 63, 400, BACK, function()
        npc._view = "home"
        npc._god = 1
        npc.render(npcid)
    end)
end

local function renderHome(node, npcid)
    GUI:Image_Create(node, "home_bg", 0, 0, HOME_BG)
    text(node, "main_title", 410, 422, 30, "#FFE7A0", "登神之路", FONT_TITLE)
    text(node, "tip1", 410, 395, 18, "#FF655A", "神道共有九阶，到达九阶即可进行神道自证！", FONT_MAIN)
    text(node, "tip2", 410, 372, 17, "#F7D9A0", "先选路线，再累积神力升阶，最后完成自证并解锁专属成长。", FONT_MAIN)

    local coords = {
        [1] = {x = 245, y = 148},
        [2] = {x = 575, y = 148},
    }
    for god = 1, 2 do
        local cfg = godCfg(god)
        local x, y = coords[god].x, coords[god].y
        text(node, "god_name_" .. god, x, y + 112, 25, god == 1 and "#FFD66B" or "#D7A8FF", tostring(cfg.name or ""), FONT_TITLE)
        text(node, "path_" .. god, x, y + 80, 18, "#F5E6C6", pathStateText(god), FONT_MAIN)
        text(node, "rank_" .. god, x, y + 50, 18, "#8DFF72", string.format("阶级：%d/%d", rank(god), toNumber(npc._config.max_rank, 9)), FONT_MAIN)
        text(node, "power_" .. god, x, y + 20, 18, "#8DFF72", string.format("%s：%d/%d", tostring(cfg.power_name or "神力值"), power(god), toNumber(npc._config.power_max, 1000)), FONT_MAIN)
        text(node, "cert_" .. god, x, y - 10, 17, cert(god) and "#6CFF7B" or "#FFB26B", cert(god) and ("自证：已完成") or ("自证：" .. tostring(cfg.certify_title or "")), FONT_MAIN)
        text(node, "entry_" .. god, x, y - 40, 16, "#E9D2A2", selectedPath(god) > 0 and "点击下方进入神道进阶" or "点击下方进入路线选择", FONT_MAIN)
        button(node, "detail_" .. god, x, y - 76, god == 1 and HOME_BTN_YELLOW or HOME_BTN_RED, function()
            npc._view = selectedPath(god) > 0 and "cert" or "path"
            npc._god = god
            npc.render(npcid)
        end)
    end
end

local function renderPath(node, npcid, god)
    if selectedPath(god) > 0 then
        npc._view = "cert"
        npc._god = god
        npc.render(npcid)
        return
    end
    GUI:Image_Create(node, "path_bg", 0, 0, PATH_BG[god])
    renderBack(node, npcid)
    local cfg = godCfg(god)
    text(node, "title", 410, 418, 28, "#FFE7A0", tostring(cfg.name or "") .. "·选择路径", FONT_TITLE)
    text(node, "desc1", 410, 392, 17, "#FFFFFF", "每个神道只能选择一条路径，选择后不可重复切换。", FONT_MAIN)
    text(node, "desc2", 650, 392, 17, "#FF3D32", "一旦选择，不可反悔！", FONT_TITLE)
    local positions = {[1] = {252, 115}, [2] = {565, 115}}
    for path = 1, 2 do
        local pcfg = pathCfg(god, path)
        local x, y = positions[path][1], positions[path][2]
        local skinName = PATH_BTN[god] and PATH_BTN[god][path]
        if skinName then
            button(node, "path_tab_" .. path, x, y + 182, RES .. "选择路径/按钮/亮/" .. skinName, function() end)
        end
        local attrDesc = "路线特性："
        if god == 1 then
            attrDesc = path == 1 and "路线特性：累计生命成长" or "路线特性：累计攻击成长"
        else
            attrDesc = path == 1 and "路线特性：杀怪生命成长" or "路线特性：杀怪攻击成长"
        end
        rich(node, "path_desc_" .. path, x - 118, y + 128,
            "<font color='#FFE7A0' size='19'>" .. tostring(pcfg.name or "") .. "</font><br></br>" ..
            "<font color='#FF5C52' size='18'>" .. attrDesc .. "</font><br></br>" ..
            "<font color='#F5E6C6' size='17'>" .. tostring(pcfg.desc or "") .. "</font>", 236, 18)
        button(node, "choose_" .. path, x, y - 24, PATH_CONFIRM, function()
            if selectedPath(god) > 0 then
                npc._view = "cert"
                npc._god = god
                npc.render(npcid)
                return
            end
            SL:OpenCommonTipsPop({
                str = "确认选择【" .. tostring(cfg.name or "") .. "·" .. tostring(pcfg.name or "") .. "】吗？选择后不可切换。",
                btnType = 2,
                callback = function(atype)
                    if atype == 1 then
                        applyLocalPathChoice(god, path)
                        npc._god = god
                        npc._view = "cert"
                        npc.render(npcid)
                        send(npcid, 1, god, {god = god, path = path})
                    end
                end,
            })
        end)
    end
end

local function renderUpgrade(node, npcid, god)
    local p = selectedPath(god)
    if p <= 0 then
        npc._view = "path"
        npc.render(npcid)
        return
    end
    GUI:Image_Create(node, "upgrade_bg", 0, 0, UPGRADE_BG[god])
    renderBack(node, npcid)
    local cfg = godCfg(god)
    local nextRank = rank(god) + 1
    local maxRank = toNumber(npc._config.max_rank, 9)
    local needPower = toNumber((npc._config.rank_need or {})[nextRank], 0)
    text(node, "title", 410, 418, 28, "#FFE7A0", tostring(cfg.name or "") .. "·神道进阶", FONT_TITLE)
    text(node, "path", 410, 390, 18, "#F5E6C6", "当前路线：" .. tostring(pathCfg(god, p).name or ""), FONT_MAIN)
    text(node, "rank", 410, 346, 24, "#8DFF72", string.format("当前阶级：%d/%d", rank(god), maxRank), FONT_TITLE)
    text(node, "power", 410, 312, 20, "#8DFF72", string.format("%s：%d/%d", tostring(cfg.power_name or "神力值"), power(god), toNumber(npc._config.power_max, 1000)), FONT_MAIN)
    if nextRank <= maxRank then
        rich(node, "need", 228, 284,
            string.format("<font color='#FFD86B' size='18'>进阶条件：</font><font color='#F5E6C6' size='18'>升至%d阶需神力%d</font><br></br><font color='#FFD86B' size='18'>进阶消耗：</font><font color='#F5E6C6' size='18'>元宝%d，业火结晶%d</font>",
            nextRank, needPower, nextRank * toNumber(npc._config.upgrade_cost_base_yb, 500000), nextRank * toNumber(npc._config.upgrade_cost_fire, 10)), 370, 18)
    else
        text(node, "need", 410, 274, 18, "#FFD86B", "已满九阶，可前往神道自证。", FONT_MAIN)
    end
    rich(node, "attr", 228, 234, "<font color='#C9B390' size='18'>路线效果：</font><font color='#F5E6C6' size='18'>" .. tostring(pathCfg(god, p).desc or "") .. "</font>", 370, 18)
    button(node, "upgrade_btn", 410, 102, UPGRADE_BTN, function()
        send(npcid, 2, god, {god = god})
    end)
    button(node, "cert_page", 662, 378, RES .. "神道进阶/按钮/亮/神道自证.png", function()
        npc._view = "cert"
        npc.render(npcid)
    end)
end

local function renderCert(node, npcid, god)
    local p = selectedPath(god)
    if p <= 0 then
        npc._view = "path"
        npc.render(npcid)
        return
    end
    GUI:Image_Create(node, "cert_bg", 0, 0, CERT_BG[god])
    renderBack(node, npcid)
    local cfg = godCfg(god)
    text(node, "title", 410, 418, 28, "#FFE7A0", tostring(cfg.name or "") .. "·神道自证", FONT_TITLE)
    text(node, "rank", 410, 354, 22, "#8DFF72", string.format("当前阶级：%d/%d", rank(god), toNumber(npc._config.max_rank, 9)), FONT_TITLE)
    text(node, "power", 410, 322, 20, "#8DFF72", string.format("%s：%d/%d", tostring(cfg.power_name or "神力值"), power(god), toNumber(npc._config.power_max, 1000)), FONT_MAIN)
    rich(node, "cost", 244, 288, string.format("<font color='#C9B390' size='18'>自证消耗：</font><font color='#F5E6C6' size='18'>%d%s + 元宝%d</font><br></br><font color='#C9B390' size='18'>自证奖励：</font><font color='#FFE7A0' size='18'>称号：%s</font><br></br><font color='#8DFF72' size='18'>%s</font>", toNumber(npc._config.certify_cost_power, 1000), tostring(cfg.power_name or "神力值"), toNumber(npc._config.certify_cost_yb, 4500000), tostring(cfg.certify_title or ""), tostring(cfg.certify_desc or "")), 350, 18)
    text(node, "state", 410, 194, 20, cert(god) and "#6CFF7B" or "#FFB26B", cert(god) and "已完成自证，可进入专属地图" or "达到九阶后即可开始自证", FONT_MAIN)
    button(node, "cert_btn", 410, 102, CERT_BTN, function()
        send(npcid, 3, god, {god = god})
    end)
    button(node, "upgrade_page", 158, 378, RES .. "神道自证/按钮/亮/神道进阶.png", function()
        npc._view = "upgrade"
        npc.render(npcid)
    end)
end

function npc.render(npcid)
    local node = npc.node
    if not node then return end
    GUI:removeAllChildren(node)
    renderTop(node)
    if npc._view == "path" then
        renderPath(node, npcid, npc._god)
    elseif npc._view == "upgrade" then
        renderUpgrade(node, npcid, npc._god)
    elseif npc._view == "cert" then
        renderCert(node, npcid, npc._god)
    else
        renderHome(node, npcid)
    end
end

function npc.main(npcid, p2, p3, msgData)
    npc.data = SL:JsonDecode(msgData, false) or {}
    if p2 == 1 then
        npc._god = resolveActiveGod(p3)
        npc._view = resolveDefaultView(npc._god)
    else
        npc._view = "home"
        npc._god = resolveActiveGod(npc._god or 1)
    end
    ensureWindow(npcid)
    npc.render(npcid)
end

return npc
