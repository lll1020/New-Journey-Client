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
local PATH_TIP_ICON = RES .. "选择路径/问号.png"
local UPGRADE_TIP_ICON = RES .. "神道进阶/问号.png"
local UPGRADE_PAGE_ON = RES .. "神道自证/按钮/亮/神道进阶.png"
local UPGRADE_PAGE_OFF = RES .. "神道自证/按钮/暗/神道进阶.png"
local CERT_PAGE_ON = RES .. "神道进阶/按钮/亮/神道自证.png"
local CERT_PAGE_OFF = RES .. "神道进阶/按钮/暗/神道自证.png"

npc._config = teshudata["npc_77"] or {}
npc._view = "home"
npc._god = 1

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
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
    return selectedPath(god) > 0 and "upgrade" or "path"
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
    GUI:Text_enableOutline(label, "#120806", 3)
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

local function bindDescTip(target, tipText)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(target, {
            onEnterFunc = function()
                local pos = GUI:getWorldPosition(target)
                SL:OpenCommonDescTipsPop({str = tipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
            end,
            onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end,
        })
    else
        GUI:setTouchEnabled(target, true)
        GUI:addOnTouchEvent(target, function()
            local pos = GUI:getWorldPosition(target)
            SL:OpenCommonDescTipsPop({str = tipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end)
    end
end

local function getPathBtnSkin(god, path, state)
    local skinName = PATH_BTN[god] and PATH_BTN[god][path]
    if not skinName then
        return nil
    end
    local base = RES .. "选择路径/按钮/" .. tostring(state or "亮") .. "/"
    return base .. skinName
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
    GUI:Image_Create(node, "title_img", -30, 42, TITLE)
end

local function renderBack(node, npcid)
    button(node, "back_btn", 80, 416, BACK, function()
        npc._view = "home"
        npc._god = 1
        npc.render(npcid)
    end)
end

local function renderHome(node, npcid)
    GUI:Image_Create(node, "home_bg", 0, 0, HOME_BG)
    local coords = {
        [1] = {x = 245, y = 148},
        [2] = {x = 575, y = 148},
    }
    for god = 1, 2 do
        local x, y = coords[god].x, coords[god].y
        button(node, "detail_" .. god, x, y - 76, god == 1 and HOME_BTN_YELLOW or HOME_BTN_RED, function()
            npc._view = selectedPath(god) > 0 and "upgrade" or "path"
            npc._god = god
            npc.render(npcid)
        end)
    end
end

local function renderPath(node, npcid, god)
    if selectedPath(god) > 0 then
        npc._view = "upgrade"
        npc._god = god
        npc.render(npcid)
        return
    end
    GUI:Image_Create(node, "path_bg", 0, 0, PATH_BG[god])
    renderBack(node, npcid)
    local cfg = godCfg(god)
    local equipCfg = (npc._config.npc_78 and npc._config.npc_78.equip) or ((teshudata["npc_78"] or {}).equip) or {}
    npc._path_preview = npc._path_preview or {}

    local function showStaticItem(parent, name, x, y, itemName)
        local frame = GUI:Image_Create(parent, name, x, y, "res/wy/public/70_70_k.png")
        local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName), 0)
        local itemData = itemIndex > 0 and SL:GetMetaValue("ITEM_DATA", itemIndex) or nil
        if itemData then
            UiTools.showItemData(frame, itemData, nil, nil, {movable = false, doubleTakeOff = false})
        end
        return frame
    end

    local function getPathEquip(path)
        local list = {}
        for _, equip in ipairs(equipCfg) do
            if toNumber(equip.god, 0) == god and toNumber(equip.path, 0) == path then
                list[#list + 1] = equip
            end
        end
        return list
    end

    local function renderPathContent(path)
        npc._path_preview[god] = path
        GUI:removeChildByName(node, "path_content_layer")
        local content = GUI:Node_Create(node, "path_content_layer", 0, 0)
        local pcfg = pathCfg(god, path)
        local pathTipText
        local attrDesc = path == 1 and "生命值" or "攻击力"
        if god == 1 then
            pathTipText = path == 1
                and "<font color='#F6D48A' size='18'>止戈路线说明</font><br></br><font color='#FFB347' size='16'>1.</font><font color='#F8F1DE' size='16'> 选择后不可更改</font><br></br><font color='#FFB347' size='16'>2.</font><font color='#F8F1DE' size='16'> 通过击杀玩家获得</font><font color='#7CFF7A' size='16'>神力值·兵</font><br></br><font color='#FFB347' size='16'>3.</font><font color='#F8F1DE' size='16'> 每次成长增加</font><font color='#9FE2FF' size='16'>固定生命</font><br></br><font color='#FFB347' size='16'>4.</font><font color='#F8F1DE' size='16'> 升阶后历史击杀会按当前阶级回溯重算</font><br></br><font color='#FFB347' size='16'>5.</font><font color='#F8F1DE' size='16'> 九阶后可进行神道自证</font>"
                or "<font color='#F6D48A' size='18'>杀伐路线说明</font><br></br><font color='#FFB347' size='16'>1.</font><font color='#F8F1DE' size='16'> 选择后不可更改</font><br></br><font color='#FFB347' size='16'>2.</font><font color='#F8F1DE' size='16'> 通过击杀玩家获得</font><font color='#7CFF7A' size='16'>神力值·兵</font><br></br><font color='#FFB347' size='16'>3.</font><font color='#F8F1DE' size='16'> 每次成长增加</font><font color='#FF8A5B' size='16'>固定攻击</font><br></br><font color='#FFB347' size='16'>4.</font><font color='#F8F1DE' size='16'> 升阶后历史击杀会按当前阶级回溯重算</font><br></br><font color='#FFB347' size='16'>5.</font><font color='#F8F1DE' size='16'> 九阶后可进行神道自证</font>"
        else
            pathTipText = path == 1
                and "<font color='#F6D48A' size='18'>无常路线说明</font><br></br><font color='#FFB347' size='16'>1.</font><font color='#F8F1DE' size='16'> 选择后不可更改</font><br></br><font color='#FFB347' size='16'>2.</font><font color='#F8F1DE' size='16'> 通过击杀六大陆怪物获得</font><font color='#7CFF7A' size='16'>神力值·鬼</font><br></br><font color='#FFB347' size='16'>3.</font><font color='#F8F1DE' size='16'> 每次成长增加</font><font color='#9FE2FF' size='16'>固定生命</font><br></br><font color='#FFB347' size='16'>4.</font><font color='#F8F1DE' size='16'> 升阶后历史击杀会按当前阶级回溯重算</font><br></br><font color='#FFB347' size='16'>5.</font><font color='#F8F1DE' size='16'> 九阶后可进行神道自证</font>"
                or "<font color='#F6D48A' size='18'>阎罗路线说明</font><br></br><font color='#FFB347' size='16'>1.</font><font color='#F8F1DE' size='16'> 选择后不可更改</font><br></br><font color='#FFB347' size='16'>2.</font><font color='#F8F1DE' size='16'> 通过击杀六大陆怪物获得</font><font color='#7CFF7A' size='16'>神力值·鬼</font><br></br><font color='#FFB347' size='16'>3.</font><font color='#F8F1DE' size='16'> 每次成长增加</font><font color='#FF8A5B' size='16'>固定攻击</font><br></br><font color='#FFB347' size='16'>4.</font><font color='#F8F1DE' size='16'> 升阶后历史击杀会按当前阶级回溯重算</font><br></br><font color='#FFB347' size='16'>5.</font><font color='#F8F1DE' size='16'> 九阶后可进行神道自证</font>"
        end

        text(content, "path_attr_value", 780 - 80, 248 + 22, 26, "#D63B32", attrDesc, FONT_TITLE, 0, 0.5)

        local positions = {[1] = {485, 342}, [2] = {690, 342}}
        for idx = 1, 2 do
            local skin = getPathBtnSkin(god, idx, idx == path and "亮" or "暗")
            if skin then
                button(content, "path_tab_" .. idx, positions[idx][1], positions[idx][2], skin, function()
                    renderPathContent(idx)
                end)
            end
        end

        local equips = getPathEquip(path)
        local iconX = 485
        for i, equip in ipairs(equips) do
            local x = iconX + (i - 1) * 120
            showStaticItem(content, "equip_" .. i, x, 78, tostring(equip.name or ""))
            text(content, "equip_name_" .. i, x + 35, 56, 16, "#F5E6C6", tostring(equip.name or ""), FONT_MAIN, 0.5, 0.5)
        end

        local pathTip = GUI:Image_Create(content, "path_rule_tip", 730, 92, PATH_TIP_ICON)
        bindDescTip(pathTip, pathTipText)

        button(content, "path_choose_btn", 266, 74, PATH_CONFIRM, function()
            SL:OpenCommonTipsPop({
                str = "确认选择【" .. tostring(cfg.name or "") .. "·" .. tostring(pcfg.name or "") .. "】吗？选择后不可切换。",
                btnType = 2,
                callback = function(atype)
                    if atype == 1 then
                        applyLocalPathChoice(god, path)
                        npc._god = god
                        npc._view = "upgrade"
                        npc.render(npcid)
                        send(npcid, 1, god, {god = god, path = path})
                    end
                end,
            })
        end)
    end

    local selectedPreviewPath = toNumber(npc._path_preview[god], 1)
    if selectedPreviewPath ~= 1 and selectedPreviewPath ~= 2 then
        selectedPreviewPath = 1
    end
    renderPathContent(selectedPreviewPath)
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
    local pcfg = pathCfg(god, p)
    local nextRank = rank(god) + 1
    local maxRank = toNumber(npc._config.max_rank, 9)
    local baseAttr = (pcfg.attr or {})[1] or {}
    local baseValue = toNumber(baseAttr[2], 0)
    local attrName = tostring(baseAttr[3] or "属性")
    local nextGain = nextRank <= maxRank and (baseValue * nextRank) or (baseValue * rank(god))
    local costYb = nextRank * toNumber(npc._config.upgrade_cost_base_yb, 500000)
    local costFire = nextRank * toNumber(npc._config.upgrade_cost_fire, 10)
    local costTable = {{"元宝", costYb}, {"业火结晶", costFire}}
    local labelX = 398
    local valueX = 504
    local sectionY = {
        need = 286,
        power = 232,
        gain = 178,
        cost = 122,
    }
    local powerTipText = god == 1
        and "<font color='#FFE7A0' size='18'>神力值获取</font><br></br><font color='#F5E6C6' size='16'>选择兵神道路线后生效</font><br></br><font color='#8DFF72' size='16'>击杀玩家：神力值·兵 +20</font><br></br><font color='#FFB85C' size='16'>升阶后历史击杀会按当前阶级回溯重算</font>"
        or "<font color='#FFE7A0' size='18'>神力值获取</font><br></br><font color='#F5E6C6' size='16'>选择鬼神道路线后生效</font><br></br><font color='#8DFF72' size='16'>击杀六大陆怪物：神力值·鬼 +1</font><br></br><font color='#FFB85C' size='16'>升阶后历史击杀会按当前阶级回溯重算</font>"

    if nextRank <= maxRank then
        rich(node, "upgrade_need_text", valueX, sectionY.need - 7,
            string.format("<font color='#F5E6C6' size='18'>当前阶段%d阶</font><br></br>", nextRank - 1),
            255, 18
        )
        rich(node, "upgrade_power_text", valueX, sectionY.power + 5,
            string.format("<font color='#8DFF72' size='18'>%s：%d/%d</font>", tostring(cfg.power_name or "神力值"), power(god), toNumber(npc._config.power_max, 1000)),
            255, 18
        )
        local powerTip = GUI:Image_Create(node, "upgrade_power_tip", 730, sectionY.power - 143, UPGRADE_TIP_ICON)
        bindDescTip(powerTip, powerTipText)
        rich(node, "upgrade_gain_text", valueX, sectionY.gain + 13,
            string.format("<font color='#FFB85C' size='18'>每次%s+%d</font>", attrName, nextGain),
            255, 18
        )
        local costNode = GUI:Node_Create(node, "upgrade_cost_items", 0, 0)
        checkItemNumByTable_img_kuang(costTable, nil, costNode)
        GUI:setPosition(costNode, 492, 102)
    else
        rich(node, "upgrade_need_text", valueX, sectionY.need - 7,
            "<font color='#FFD86B' size='18'>已满九阶，可前往神道自证。</font>",
            255, 18
        )
        rich(node, "upgrade_power_text", valueX, sectionY.power + 5,
            string.format("<font color='#8DFF72' size='18'>%s：%d/%d</font>", tostring(cfg.power_name or "神力值"), power(god), toNumber(npc._config.power_max, 1000)),
            255, 18
        )
        local powerTip = GUI:Image_Create(node, "upgrade_power_tip", 730, sectionY.power - 143, UPGRADE_TIP_ICON)
        bindDescTip(powerTip, powerTipText)
        rich(node, "upgrade_gain_text", valueX, sectionY.gain + 13,
            "<font color='#FFE7A0' size='18'>当前已达最高阶</font>",
            255, 18
        )
    end

    button(node, "upgrade_btn", 610, 57, UPGRADE_BTN, function()
        send(npcid, 2, god, {god = god})
    end)
    button(node, "cert_page", 651, 333, CERT_PAGE_ON, function()
        npc._view = "cert"
        npc.render(npcid)
    end)
    button(node, "upgrade_page", 451, 333, UPGRADE_PAGE_OFF, function()
        npc._view = "upgrade"
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

    button(node, "cert_btn", 610, 57, CERT_BTN, function()
        send(npcid, 3, god, {god = god})
    end)
    button(node, "upgrade_page", 451, 333, UPGRADE_PAGE_ON, function()
        npc._view = "upgrade"
        npc.render(npcid)
    end)
    button(node, "cert_page", 651, 333, CERT_PAGE_OFF, function()
        npc._view = "cert"
        npc.render(npcid)
    end)
end

function npc.render(npcid)
    local node = npc.node
    if not node then
        return
    end
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
