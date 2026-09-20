local Atlas = {}

local AtlasCfg = SL:Require("GUILayout/Data/atlas_data", true) or {}
local state = {
    monster = {},
    equip = {},
    monster_claimed = {},
    equip_claimed = {},
    chapter_claimed = {},
    monster_attr = {},
}

local ROOT_NAME = "npc_518_atlas"
local RES = "res/custom/tj/"
local FONT = "fonts/502.ttf"
local GOLD = "#F7DFA5"
local ORANGE = "#EFA54A"
local MUTED = "#A8B0B9"
local GREEN = "#6DFF9A"
local RED = "#FF796D"
local OUTLINE = "#000000"
local SCREEN_W = 1360
local SCREEN_H = 760
local CARD_W = 205
local CARD_H = 315
local CARD_GAP = 12
local SIDE_W = 278
local SIDE_H = 590
local CARD_LAZY_BUFFER = CARD_H * 1.5
local ItemIndexCache = {}
local ItemNameColorCache = {}

local function getScreenSize()
    local sw = tonumber(cogin and cogin.w) or SCREEN_W
    local sh = tonumber(cogin and cogin.h) or SCREEN_H
    return math.max(sw, 1), math.max(sh, 1)
end

local function getLayout()
    local sw, sh = getScreenSize()
    local margin = 18
    local gap = 16
    local sideW = sw >= 1200 and SIDE_W or 258
    local sideH = math.min(SIDE_H, sh - 118)
    local panelW = math.min(1080, sw - margin * 2 - sideW - gap)
    local panelH = math.min(600, sh - 118)
    local sideX = -sw / 2 + margin + sideW / 2
    local panelX = -sw / 2 + margin + sideW + gap + panelW / 2

    return {
        sw = sw,
        sh = sh,
        topY = sh / 2 - 46,
        sideX = sideX,
        sideY = -30,
        sideW = sideW,
        sideH = sideH,
        panelX = panelX,
        panelY = -30,
        panelW = panelW,
        panelH = panelH,
    }
end

local function valid(node)
    return node and (not tolua or not tolua.isnull or not tolua.isnull(node))
end

local function decode(data)
    if type(data) == "table" then
        return data
    end
    if type(data) == "string" and data ~= "" then
        return SL:JsonDecode(data, false) or {}
    end
    return {}
end

local function ensureStateTable(key)
    if type(state[key]) ~= "table" then
        state[key] = {}
    end
    return state[key]
end

local function replaceState(data)
    data = type(data) == "table" and data or {}
    for _, key in ipairs({"monster", "equip", "monster_claimed", "equip_claimed", "chapter_claimed", "monster_attr"}) do
        state[key] = type(data[key]) == "table" and data[key] or {}
    end
end

local function snapshotState()
    local snapshot = {}
    for _, key in ipairs({"monster", "equip", "monster_claimed", "equip_claimed", "chapter_claimed", "monster_attr"}) do
        snapshot[key] = state[key]
    end
    return snapshot
end

local function setEntryState(kind, id, activated, claimed, attrValue)
    local key = tostring(id or "")
    if key == "" or (kind ~= "monster" and kind ~= "equip") then
        return
    end
    local activeMap = ensureStateTable(kind)
    local claimedMap = ensureStateTable(kind .. "_claimed")
    if activated ~= nil then
        activeMap[key] = tonumber(activated) == 1 and 1 or nil
    end
    if claimed ~= nil then
        claimedMap[key] = tonumber(claimed) == 1 and 1 or nil
    end
    if attrValue ~= nil and kind == "monster" then
        state.monster_attr[key] = tonumber(attrValue) or 0
    end
end

local function getEntryId(entry, index)
    return tostring(entry and (entry.id or entry.name) or index or "")
end

local function getName(entry, fallback)
    return tostring(entry and (entry.name or entry.title) or fallback or "未命名")
end

local function getCount(entry)
    if type(entry) ~= "table" then
        return 1
    end
    return tonumber(entry.count or entry[2] or 1) or 1
end

local function getRewardName(entry)
    if type(entry) == "string" then
        return entry
    end
    if type(entry) ~= "table" then
        return ""
    end
    return tostring(entry.name or entry.item or entry[1] or "")
end

local function itemIndex(name)
    name = tostring(name or "")
    if name == "" then
        return 0
    end
    if ItemIndexCache[name] ~= nil then
        return ItemIndexCache[name]
    end
    local index = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name) or 0) or 0
    ItemIndexCache[name] = index
    return index
end

local function getEntryNameColor(kind, entry)
    if kind == "monster" then
        return RED
    end
    local name = getName(entry)
    if ItemNameColorCache[name] then
        return ItemNameColorCache[name]
    end
    local index = itemIndex(name)
    local itemData = index > 0 and SL:GetMetaValue("ITEM_DATA", index) or nil
    local styleId = type(itemData) == "table" and tonumber(itemData.Color or 0) or 0
    local color = GOLD
    if styleId > 0 then
        color = SL:GetHexColorByStyleId(styleId) or GOLD
    end
    ItemNameColorCache[name] = color
    return color
end

local function framedItem(parent, name, x, y, index, count, grey)
    local frame = GUI:Image_Create(parent, name .. "_frame", x, y, "res/wy/public/58-60.png")
    GUI:setAnchorPoint(frame, 0.5, 0.5)
    local item = GUI:ItemShow_Create(frame, name .. "_show", 29, 30, {
        index = index,
        count = count or 1,
        look = true,
        movable = false,
        bgVisible = false,
    })
    GUI:setAnchorPoint(item, 0.5, 0.5)
    if grey then
        GUI:ItemShow_setIconGrey(item, true)
    end
    return frame
end

local function text(parent, name, x, y, size, color, value, ax, ay, FONTNAME)
    local node = GUI:Text_Create(parent, name, x, y, size or 18, color or GOLD, tostring(value or ""))
    GUI:setAnchorPoint(node, ax == nil and 0.5 or ax, ay == nil and 0.5 or ay)
    GUI:Text_setFontName(node, FONTNAME or FONT)
    GUI:Text_enableOutline(node, OUTLINE, 1)
    return node
end

local function button(parent, name, x, y, label, callback, skin)
    local node = GUI:Button_Create(parent, name, x, y, skin or "res/wy/public/an15.png")
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:Button_setTitleText(node, label or "")
    GUI:Button_setTitleFontName(node, FONT)
    GUI:Button_setTitleFontSize(node, 17)
    GUI:Button_setTitleColor(node, GOLD)
    GUI:Button_titleEnableOutline(node, OUTLINE, 1)
    GUI:addOnClickEvent(node, callback)
    return node
end
local function nomove_button(parent, name, x, y, label, callback, skin)
    local node = GUI:Button_Create(parent, name, x, y, skin or "res/wy/public/an15.png")
    GUI:Button_loadTexturePressed(node, skin or "res/wy/public/an15.png")
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:Button_setTitleText(node, label or "")
    GUI:Button_setTitleFontName(node, FONT)
    GUI:Button_setTitleFontSize(node, 17)
    GUI:Button_setTitleColor(node, GOLD)
    GUI:Button_titleEnableOutline(node, OUTLINE, 1)
    GUI:addOnClickEvent(node, callback)
    return node
end

local closeWindow

local function navButton(parent, name, x, y, label, active, callback)
    local node = button(parent, name, x, y, label, callback, RES .. "tj_21.png")
    GUI:setContentSize(node, 132, 42)
    GUI:Button_setTitleFontSize(node, active and 25 or 20)
    GUI:Button_setTitleColor(node, active and GOLD or "#00FFFF")
    if active then
        local underline = GUI:Image_Create(parent, name .. "_underline", x, y - 26, RES .. "tj_13.png")
        GUI:setAnchorPoint(underline, 0.5, 0.5)
        GUI:setContentSize(underline, 88, 3)
    end
    return node
end

local function renderTopNav(root, active)
    local layout = getLayout()
    local left = -layout.sw / 2
    local brandX = left + 52
    local brandTextX = left + 82
    local navStart = math.max(-255, left + 300)
    local mark = GUI:Image_Create(root, "brand_mark", brandX, layout.topY, "res/wy/public/itembg.png")
    GUI:setAnchorPoint(mark, 0.5, 0.5)
    GUI:setContentSize(mark, 50, 50)
    text(root, "brand_mark_text", brandX, layout.topY, 40, GOLD, "鉴", 0.5, 0.5)
    text(root, "brand_title", brandTextX, layout.topY, 30, GOLD, "万象图鉴", 0, 0.5)
    -- text(root, "brand_subtitle", brandTextX, layout.topY - 21, 10, MUTED, "COLLECTION ARCHIVE", 0, 0.5)

    navButton(root, "nav_overview", navStart, layout.topY, "图鉴总览", active == "overview", function()
        Atlas.view = nil
        Atlas.renderOverview()
    end)
    navButton(root, "nav_monster", navStart + 150, layout.topY, "怪物图鉴", active == "monster", function()
        Atlas.view = "monster"
        Atlas.renderDetail()
    end)
    navButton(root, "nav_equip", navStart + 300, layout.topY, "装备图鉴", active == "equip", function()
        Atlas.view = "equip"
        Atlas.renderDetail()
    end)

    button(root, "close", layout.sw / 2 - 65, layout.topY, "", function()
        local win = GUI:GetWindow(nil, ROOT_NAME)
        if win then
            GUI:Win_Close(win)
        end
    end, "res/wy/public/gjyj_x.png")
end

local function addItem(parent, name, x, y, reward)
    local rewardName = getRewardName(reward)
    local idx = itemIndex(rewardName)
    if idx > 0 then
        return framedItem(parent, name, x, y, idx, getCount(reward))
    end
    local count = getCount(reward)
    local label = rewardName ~= "" and rewardName or "暂无"
    if rewardName ~= "" then
        label = string.format("%s x%d", label, count)
    end
    return text(parent, name, x, y, 14, MUTED, label, 0.5, 0.5)
end

local function addRewards(parent, rewards, x, y, maxCount)
    if type(rewards) ~= "table" then
        return
    end
    local list = rewards
    if rewards.name or rewards.item or (rewards[1] and type(rewards[1]) ~= "table") then
        list = {rewards}
    end
    local limit = math.min(#list, maxCount or 3)
    for i = 1, limit do
        addItem(parent, "reward_" .. i, x + (i - 1) * 62, y, list[i])
    end
end

local function addAttrReward(parent, name, attr, x, y)
    if type(attr) ~= "table" then
        return
    end
    local minValue = tonumber(attr.min or 0) or 0
    local maxValue = tonumber(attr.max or minValue) or minValue
    local actualRaw = (state.monster_attr or {})[name]
    local actual = tonumber(actualRaw or 0) or 0
    local label
    if actualRaw ~= nil then
        label = string.format("%s\n%d", attr.name or "属性", actual)
    elseif minValue == maxValue then
        label = string.format("%s\n%d", attr.name or "属性", minValue)
    else
        label = string.format("%s\n%d-%d", attr.name or "属性", minValue, maxValue)
    end
    text(parent, "attr_reward_" .. tostring(name), x, y, 20, ORANGE, label, 0.5, 0.5)
end

local function getChapterReward(map, kind)
    if not map then
        return {}
    end
    return map[kind .. "_chapter_reward"] or map.chapter_reward or {}
end

local function isActive(kind, entry)
    return tonumber((state[kind] or {})[getEntryId(entry)] or 0) == 1
end

local function isClaimed(kind, entry)
    return tonumber((state[kind .. "_claimed"] or {})[getEntryId(entry)] or 0) == 1
end

local function isEntryClaimable(kind, entry)
    return isActive(kind, entry) and not isClaimed(kind, entry)
end

local function getEntryRenderKey(kind, entry)
    local id = getEntryId(entry)
    local active = isActive(kind, entry) and "1" or "0"
    local claimed = isClaimed(kind, entry) and "1" or "0"
    local attrValue = kind == "monster" and tostring((state.monster_attr or {})[id] or "") or ""
    return active .. ":" .. claimed .. ":" .. attrValue
end

local function getEntryCardSkin(kind, entry)
    if entry and entry.card_skin then
        return entry.card_skin
    end
    if isClaimed(kind, entry) then
        return RES .. "tj_28.png"
    end
    return isActive(kind, entry) and RES .. "tj_26.png" or RES .. "tj_25.png"
end

local function applyEntryCardShell(card, kind, entry)
    if valid(card) then
        GUI:Image_loadTexture(card, getEntryCardSkin(kind, entry))
    end
end

local function getSortedEntries(kind, entries)
    if type(entries) ~= "table" or #entries <= 1 then
        return entries or {}
    end

    -- Keep the configured order stable inside each group. Only move entries
    -- that can be claimed to the front of the current map.
    local claimable = {}
    local rest = {}
    for index, entry in ipairs(entries) do
        local item = {entry = entry, index = index}
        if isEntryClaimable(kind, entry) then
            claimable[#claimable + 1] = item
        else
            rest[#rest + 1] = item
        end
    end

    local result = {}
    for _, item in ipairs(claimable) do
        result[#result + 1] = item.entry
    end
    for _, item in ipairs(rest) do
        result[#result + 1] = item.entry
    end
    return result
end

local function getEntriesOrderKey(entries)
    local ids = {}
    for index, entry in ipairs(entries or {}) do
        ids[index] = getEntryId(entry, index)
    end
    return table.concat(ids, "|")
end

local function mapComplete(kind, map)
    local entries = map and map[kind] or {}
    if type(entries) ~= "table" or #entries == 0 then
        return false
    end
    for _, entry in ipairs(entries) do
        if not isActive(kind, entry) then
            return false
        end
    end
    return true
end

local function mapProgress(kind, map)
    local entries = map and map[kind] or {}
    local total, active = #entries, 0
    for _, entry in ipairs(entries) do
        if isActive(kind, entry) then
            active = active + 1
        end
    end
    return active, total
end

local function refreshNodeRedPoint(node, show, opts)
    if not valid(node) then
        return
    end
    local delegate = GUI:ui_delegate(node)
    if show == true then
        if not (delegate and delegate.redpoint) then
            NPC_UI_HELPER.redpoint_create_eff(node, opts)
        end
    elseif delegate and delegate.redpoint then
        GUI:removeChildByName(node, "redpoint")
    end
end

local function mapSupportsKind(kind, map)
    if not map or type(map[kind]) ~= "table" or #map[kind] == 0 then
        return false
    end
    if kind == "equip" then
        return true
    end
    return map.direct_equip ~= true
end

local function isContinentUnlocked(continent)
    local continentId = tonumber(continent and continent.id or 0) or 0
    if continentId <= 1 then
        return continentId == 1
    end
    if type(dl_unlock_check) == "function" then
        local ok, unlocked = pcall(dl_unlock_check, continentId)
        if not ok then
            return false
        end
        return unlocked == true
            or tonumber(unlocked or 0) == 1
            or tostring(unlocked) == "true"
    end
    local adminUnlock = cogin and cogin.sjtb
        and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
    return adminUnlock == 1 or adminUnlock >= continentId
end

local function getVisibleMaps(continent, kind)
    local result = {}
    for _, map in ipairs((continent and continent.maps) or {}) do
        if mapSupportsKind(kind, map) then
            result[#result + 1] = map
        end
    end
    return result
end

local function mapKey(kind, map)
    return tostring(kind) .. ":" .. tostring(map and map.id or "")
end

local function mapHasPending(kind, map)
    if not map or not mapSupportsKind(kind, map) then
        return false
    end
    for _, entry in ipairs(map[kind] or {}) do
        if isActive(kind, entry) and not isClaimed(kind, entry) then
            return true
        end
    end
    return mapComplete(kind, map)
        and tonumber((state.chapter_claimed or {})[mapKey(kind, map)] or 0) ~= 1
end

local getVisibleContinents

local function continentHasPending(kind, continent)
    for _, map in ipairs(getVisibleMaps(continent, kind)) do
        if mapHasPending(kind, map) then
            return true
        end
    end
    return false
end

local function kindHasPending(kind)
    for _, continent in ipairs(getVisibleContinents(kind)) do
        if continentHasPending(kind, continent) then
            return true
        end
    end
    return false
end

local function refreshOverviewRedpoints()
    local nodes = Atlas.overviewNodes
    if type(nodes) ~= "table" then
        return
    end
    for _, kind in ipairs({"monster", "equip"}) do
        refreshNodeRedPoint(nodes[kind], kindHasPending(kind), {
            x = 360,
            y = 462,
        })
    end
end

local function refreshSidebarRedpoints()
    local nodes = Atlas.sidebarNodes
    local kind = Atlas.sidebarKind
    if type(nodes) ~= "table" or (kind ~= "monster" and kind ~= "equip") then
        return
    end

    for _, data in pairs(nodes.continent or {}) do
        refreshNodeRedPoint(data.node, continentHasPending(kind, data.continent), {
            x = data.width - 12,
            y = data.height / 2,
            autoScale = 0.55,
        })
    end
    for _, data in pairs(nodes.map or {}) do
        refreshNodeRedPoint(data.node, mapHasPending(kind, data.map), {
            x = data.width - 8,
            y = data.height / 2,
            autoScale = 0.52,
        })
    end
end

getVisibleContinents = function(kind)
    local result = {}
    for _, continent in ipairs(AtlasCfg.continents or {}) do
        if isContinentUnlocked(continent) and #getVisibleMaps(continent, kind) > 0 then
            result[#result + 1] = continent
        end
    end
    return result
end

local function findConfigMap(mapId)
    for _, continent in ipairs(AtlasCfg.continents or {}) do
        for _, map in ipairs(continent.maps or {}) do
            if tostring(map.id or "") == tostring(mapId or "") then
                return map, continent
            end
        end
    end
    return nil, nil
end

local function normalizeExpanded(continents, preferredId)
    Atlas.expanded = Atlas.expanded or {}

    local keepId = preferredId and tostring(preferredId) or nil
    if not keepId or keepId == "" then
        for _, continent in ipairs(continents or {}) do
            local continentId = tostring(continent.id or "")
            if Atlas.expanded[continentId] == true then
                keepId = continentId
                break
            end
        end
    end

    for _, continent in ipairs(continents or {}) do
        local continentId = tostring(continent.id or "")
        Atlas.expanded[continentId] = keepId ~= nil and continentId == keepId
    end
end

local CONTINENT_ALIASES = {
    ["1"] = {"第一大陆", "一大陆", "盟重"},
    ["2"] = {"第二大陆", "二大陆", "极光"},
    ["3"] = {"第三大陆", "三大陆", "苍云"},
    ["4"] = {"第四大陆", "四大陆", "若水"},
    ["5"] = {"第五大陆", "五大陆", "红尘"},
    ["6"] = {"第六大陆", "六大陆", "灵虚"},
}

local function containsAny(value, words)
    value = tostring(value or "")
    for _, word in ipairs(words or {}) do
        word = tostring(word or "")
        if word ~= "" and string.find(value, word, 1, true) then
            return true
        end
    end
    return false
end

local function getCurrentMapSelection(kind)
    local currentMapId = tostring(SL:GetMetaValue("MAP_ID") or "")
    local currentMapName = tostring(SL:GetMetaValue("MAP_NAME") or "")
    local fallbackContinent = tostring(AtlasCfg.default_continent or "6")
    local fallbackMap = tostring(AtlasCfg.default_map or "")
    local selectedContinent
    local selectedMap
    local continents = getVisibleContinents(kind)

    for _, continent in ipairs(continents) do
        local continentId = tostring(continent.id or "")
        local continentMatched = containsAny(currentMapName, CONTINENT_ALIASES[continentId])
        for _, map in ipairs(getVisibleMaps(continent, kind)) do
            local mapId = tostring(map.id or "")
            local mapName = tostring(map.name or map.map_name or "")
            local mapMatched = currentMapName ~= "" and currentMapName == mapName
            if type(map.aliases) == "table" and containsAny(currentMapName, map.aliases) then
                mapMatched = true
            end
            if type(map.map_ids) == "table" and containsAny(currentMapId, map.map_ids) then
                mapMatched = true
            end
            if currentMapId ~= "" and currentMapId == mapId
                or mapMatched then
                selectedContinent = continent
                selectedMap = map
                break
            end
            if not selectedContinent and continentMatched then
                selectedContinent = continent
                selectedMap = selectedMap or map
            end
            if not selectedMap and mapId == fallbackMap then
                selectedContinent = continent
                selectedMap = map
            end
        end
        if selectedMap and (currentMapId == tostring(selectedMap.id or "")
            or currentMapName == tostring(selectedMap.name or "")) then
            break
        end
    end

    if not selectedContinent then
        for _, continent in ipairs(continents) do
            if tostring(continent.id or "") == fallbackContinent then
                selectedContinent = continent
                selectedMap = getVisibleMaps(continent, kind)[1]
                break
            end
        end
    end
    if not selectedContinent then
        selectedContinent = continents[1]
        selectedMap = selectedContinent and getVisibleMaps(selectedContinent, kind)[1]
    end
    return selectedContinent, selectedMap
end

local function updateRedPoint(show)
    if type(_G.ATLAS518_REFRESH_REDPOINT) == "function" then
        _G.ATLAS518_REFRESH_REDPOINT(show == true)
    end
end

local function sendEntryClaim(kind, id)
    SL:SendLuaNetMsg(101, 518, 1, 0, SL:JsonEncode({
        kind = kind,
        id = tostring(id),
    }, false))
end

local function sendChapterClaim(kind, mapId)
    SL:SendLuaNetMsg(101, 518, 2, 0, SL:JsonEncode({
        kind = kind,
        map_id = tostring(mapId),
    }, false))
end

local function requestState()
    SL:SendLuaNetMsg(101, 518, 0, 0, "")
end

closeWindow = function()
    local win = GUI:GetWindow(nil, ROOT_NAME)
    if win then
        GUI:Win_Close(win)
    end
end

local function createRoot()
    local win = GUI:GetWindow(nil, ROOT_NAME)
    local sw = tonumber(cogin and cogin.w) or SCREEN_W
    local sh = tonumber(cogin and cogin.h) or SCREEN_H
    if win then
        GUI:removeAllChildren(win)
        GUI:setPosition(win, sw / 2, sh / 2)
    else
        win = GUI:Win_Create(ROOT_NAME, sw / 2, sh / 2,
            0, 0, false, false, true, true, true, 518, 999)
    end
    local mask = GUI:Image_Create(win, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, sw + 100, sh + 100)
    GUI:setTouchEnabled(mask, true)
    GUI:addOnClickEvent(mask, closeWindow)

    local bg = GUI:Image_Create(win, "background", 0, 0, RES .. "tj_17.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, sw, sh)
    GUI:setTouchEnabled(bg, true)
    GUI:addMouseOverTips(bg, "", {x = 0, y = 0}, {x = 0, y = 0})

    -- The window itself is centered. Keep the background and content root as
    -- siblings so the content root's local origin is the window center.
    local root = GUI:Node_Create(win, "root", 0, 0)
    GUI:setPosition(root, 0, 0)
    GUI:setLocalZOrder(root, 99)
    return root
end

local function renderOverview(root)
    GUI:removeAllChildren(root)
    Atlas.sidebarKind = nil
    Atlas.sidebarNodes = nil
    renderTopNav(root, "overview")
    -- text(root, "title", 0, 205, 30, GOLD, "图鉴总览", 0.5, 0.5)
    -- text(root, "subtitle", 0, 168, 15, MUTED, "记录你走过的地图与亲手拾取过的珍稀装备", 0.5, 0.5)

    local cards = {
        {kind = "monster", skin = RES .. "tj_3.png", x = -225, title = "怪物图鉴"},
        {kind = "equip", skin = RES .. "tj_2.png", x = 225, title = "装备图鉴"},
    }
    Atlas.overviewNodes = {}
    for _, info in ipairs(cards) do
        local card = GUI:Image_Create(root, info.kind .. "_overview", info.x, -35, info.skin)
        GUI:setAnchorPoint(card, 0.5, 0.5)
        -- GUI:setContentSize(card, 250, 316)
        Atlas.overviewNodes[info.kind] = card
        GUI:setTouchEnabled(card, true)
        GUI:addOnClickEvent(card, function()
            Atlas.view = info.kind
            Atlas.renderDetail()
        end)
        local total, active = 0, 0
        for _, continent in ipairs(getVisibleContinents(info.kind)) do
            for _, map in ipairs(continent.maps or {}) do
                for _, entry in ipairs(map[info.kind] or {}) do
                    total = total + 1
                    if isActive(info.kind, entry) then
                        active = active + 1
                    end
                end
            end
        end
        -- text(root, info.kind .. "_overview_title", info.x, -225, 22, GOLD, info.title, 0.5, 0.5)
        text(root, info.kind .. "_overview_progress", info.x + 59 + 38, -255 + 66, 30, active > 0 and GREEN or MUTED,
            string.format("%d/%d", active, total), 1, 0.5,"fonts/503.ttf")
    end
    refreshOverviewRedpoints()
end

local function renderSideBar(root)
    local layout = getLayout()
    local kind = Atlas.view == "equip" and "equip" or "monster"
    local continents = getVisibleContinents(kind)
    Atlas.sidebarKind = kind
    Atlas.sidebarNodes = {
        continent = {},
        map = {},
    }
    -- tj_8 is the dedicated left-side continent and map list background.
    local side = GUI:Image_Create(root, "side_bg", layout.sideX, layout.sideY, RES .. "tj_12.png")
    GUI:setAnchorPoint(side, 0.5, 0.5)
    GUI:setContentSize(side, layout.sideW, layout.sideH)
    GUI:setLocalZOrder(side, 5)
    local bigkuang = GUI:Image_Create(root, "bigkuang", layout.sideX, layout.sideY, "res/wy/public/box.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 0.5)
    GUI:setContentSize(bigkuang, layout.sideW + 4, layout.sideH + 4)
    GUI:setLocalZOrder(bigkuang, 4)

    -- text(side, "side_type", 20, layout.sideH - 28, 11, GOLD,
    --     Atlas.view == "equip" and "EQUIPMENT ARCHIVE" or "BOSS ARCHIVE", 0, 0.5)
    text(side, "side_title", 20, layout.sideH - 35, 23, GOLD,
        Atlas.view == "equip" and "装备图鉴" or "怪物图鉴", 0, 0.5)
        -- qyl_fgx
    local qyl_fgx = GUI:Image_Create(side, "qyl_fgx", layout.sideW / 2, layout.sideH - 60, "res/wy/public/qyl_fgx.png")
    GUI:setAnchorPoint(qyl_fgx, 0.5, 0.5)
    GUI:setContentSize(qyl_fgx, layout.sideW + 4, 2)


    local scrollW = layout.sideW - 26
    local scrollH = layout.sideH - 75
    local scroll = GUI:ScrollView_Create(side, "continent_scroll",
        13 + scrollW / 2, 12 + scrollH / 2, scrollW, scrollH, 1)
    GUI:setAnchorPoint(scroll, 0.5, 0.5)
    GUI:ScrollView_setClippingEnabled(scroll, true)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local rowH = 42
    local totalRows = 0
    for _, continent in ipairs(continents) do
        local maps = getVisibleMaps(continent, kind)
        totalRows = totalRows + 1
        if Atlas.expanded[tostring(continent.id or "")] == true
            and not (maps[1] and maps[1].direct_equip) then
            totalRows = totalRows + #maps
        end
    end
    local innerH = math.max(scrollH, totalRows * rowH + 12)
    GUI:ScrollView_setInnerContainerSize(scroll, scrollW, innerH)

    local y = innerH - 25
    for _, continent in ipairs(continents) do
        local continentId = tostring(continent.id or "")
        local maps = getVisibleMaps(continent, kind)
        local directMap = maps[1] and maps[1].direct_equip and maps[1] or nil
        local expanded = Atlas.expanded[continentId] == true
        local continentActive = false
        for _, map in ipairs(maps) do
            if tostring(Atlas.mapId or "") == tostring(map.id or "") then
                continentActive = true
                break
            end
        end
        local head = nomove_button(scroll, "continent_" .. continentId, scrollW / 2, y,
            "", function()
                local firstMap = directMap or maps[1]
                for _, otherContinent in ipairs(continents) do
                    local otherId = tostring(otherContinent.id or "")
                    Atlas.expanded[otherId] = false
                end
                Atlas.expanded[continentId] = directMap == nil and firstMap ~= nil
                Atlas.mapId = firstMap and tostring(firstMap.id or "") or nil
                Atlas.renderDetail()
            end,"res/wy/public/" .. (expanded and "zl_mrrwwc" or "kfzj_wz") .. ".png")
        GUI:setContentSize(head, scrollW - 8, 38)
        Atlas.sidebarNodes.continent[continentId] = {
            node = head,
            continent = continent,
            width = scrollW - 8,
            height = 38,
        }
        -- GUI:Text_Create(head, "progress", 10, 0, 12,expanded and GREEN or MUTED,)
        local progress = text(head, "progress", 10, 38/2 - 2, 25,
            expanded and ORANGE or GOLD,
            getName(continent, "未知大陆"), 0, 0.5,"fonts/506.ttf")
            GUI:Text_enableOutline(progress, OUTLINE, expanded and 1 or 0.5)
        y = y - rowH
        if expanded and not directMap then
            for _, map in ipairs(maps) do
                local mapId = tostring(map.id or "")
                local selected = tostring(Atlas.mapId or "") == mapId
                local mapBtn = nomove_button(scroll, "map_" .. mapId, scrollW / 2 - 10, y,
                    "", function()
                        Atlas.mapId = mapId
                        Atlas.renderDetail()
                    end,"res/wy/public/" .. (selected and "zl_mrrwwc" or "kfzj_wz") .. ".png")
                local active, total = mapProgress(Atlas.view, map)
                GUI:setContentSize(mapBtn, scrollW - 70, 34)
                Atlas.sidebarNodes.map[mapId] = {
                    node = mapBtn,
                    map = map,
                    width = scrollW - 70,
                    height = 34,
                }
                local map_progress = text(mapBtn, "progress", 10, 34/2 - 2, 20,
                    selected and ORANGE or GOLD,
                    (selected and "└ " or "└ ") .. getName(map, "未知地图"), 0, 0.5,"fonts/506.ttf")
                GUI:Text_enableOutline(map_progress, OUTLINE, 0)
                y = y - rowH
            end
        end
    end
    GUI:ScrollView_setInnerContainerSize(scroll, scrollW, math.max(scrollH, innerH - y + 12))
    refreshSidebarRedpoints()
end

local function renderMonsterModel(card, entry)
    local model = tonumber(entry.model or entry.mob_shape or entry.shape or 0) or 0
    if model > 0 then
        local node = GUI:Effect_Create(card, "model", CARD_W / 2 - 20, 142, 2, model, 0, 0, 5, 0.65)
    else

        local preview = GUI:Image_Create(card, "model_preview", CARD_W / 2, 150 + 28, "res/wy/public/kb_5.png")
        GUI:setAnchorPoint(preview, 0.5, 0.5)
        text(card, "model_empty", CARD_W / 2, 150, 14, "#D9E7F0", "BOSS", 0.5, 0.5)
    end
end

local function renderEntryCard(card, kind, entry)
    local id = getEntryId(entry)
    local renderKey = getEntryRenderKey(kind, entry)
    local data = Atlas.cards and Atlas.cards[kind] and Atlas.cards[kind][id] or nil
    if data and data.rendered == true and data.renderKey == renderKey then
        return
    end
    GUI:removeAllChildren(card)
    if data then
        data.rendered = true
        data.renderKey = renderKey
    end
    local active = isActive(kind, entry)
    local claimed = isClaimed(kind, entry)
    applyEntryCardShell(card, kind, entry)
    if kind == "monster" then
        renderMonsterModel(card, entry)
    else
        local idx = itemIndex(getName(entry))
        if idx > 0 then
            framedItem(card, "item", CARD_W / 2, 142 + 32, idx, 1, false)
        else
            text(card, "item_empty", CARD_W / 2, 142, 14, MUTED, "未配置物品", 0.5, 0.5)
        end
    end

    -- text(card, "kind", 12, CARD_H - 22, 11, GOLD,
    --     kind == "monster" and "红名 BOSS" or "专属装备", 0, 0.5)
    -- text(card, "active", CARD_W - 12, CARD_H - 22, 11, active and GREEN or MUTED,
    --     claimed and "已领取" or (active and "待领取" or "未激活"), 1, 0.5)
    text(card, "name", CARD_W / 2, 92 + 185, 20, getEntryNameColor(kind, entry), getName(entry), 0.5, 0.5)
    -- text(card, "trigger", CARD_W / 2, 68, 13, MUTED,
    --     active and (kind == "monster" and "击杀激活" or "拾取激活")
    --         or (kind == "monster" and "击杀对应 BOSS 后激活" or "拾取进入背包后激活"),
    --     0.5, 0.5)


    if claimed then
        -- text(card, "claimed", CARD_W / 2, 10, 13, GREEN, "已领取", 0.5, 0.5)
        GUI:Image_Create(card, "claimed", CARD_W / 2, 50, "res/wy/public/10_2.png")
        GUI:setAnchorPoint(GUI:getChildByName(card, "claimed"), 0.5, 0.5)
    else
        text(card, "reward_title", CARD_W / 2 - 54, 48 + 185 - 181, 20, MUTED, "激活\n奖励", 0.5, 0.5)
        addRewards(card, entry.reward, 68 + 55 - 20, 35 + 15, 3)
        -- if kind == "monster" then
        --     addAttrReward(card, getEntryId(entry), entry.attr_reward, 68 + 55 - 15 + 15 + 40, 35 + 15)
        -- end
        local claim = button(card, "claim", CARD_W / 2, 0, active and "领取奖励" or "未激活", function()
            if not active then
                SL:ShowSystemTips("<font color='#FF6666'>该图鉴尚未激活</font>")
                return
            end
            sendEntryClaim(kind, getEntryId(entry))
        end)
        GUI:setContentSize(claim, CARD_W - 22, 30)
        if not active then
            GUI:Button_setGrey(claim, true)
        end
        refreshNodeRedPoint(claim, active and not claimed, {
            x = CARD_W - 18,
            y = 15,
            autoScale = 0.65,
        })
    end
end

local function renderChapterPanel(parent, kind, map)
    local layout = Atlas.layout or getLayout()
    local complete = mapComplete(kind, map)
    local claimed = tonumber((state.chapter_claimed or {})[mapKey(kind, map)] or 0) == 1
    local active, total = mapProgress(kind, map)
    local panel = GUI:Image_Create(parent, "chapter_panel",
        layout.panelW - 150, layout.panelH - 60, RES .. "tj_7.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setContentSize(panel, 286, 106)
    text(panel, "chapter_label", 10, 104, 20, GOLD, "本章节全部收集奖励", 0, 1)
    text(panel, "chapter_state", 10, 104 - 20, 20, complete and GREEN or MUTED,
        complete and "章节已完成" or string.format("已激活 %d/%d", active, total), 0, 1)
    addRewards(panel, getChapterReward(map, kind), 40, 30, 3)
    if claimed then
        text(panel, "chapter_claimed", 236, 30, 13, GREEN, "已领取", 0.5, 0.5)
    else
        local claim = button(panel, "chapter_claim", 236, 30, complete and "领取" or "未完成", function()
            if not complete then
                SL:ShowSystemTips("<font color='#FF6666'>章节尚未完成</font>")
                return
            end
            sendChapterClaim(kind, map.id)
        end)
        GUI:setContentSize(claim, 78, 30)
        if not complete then
            GUI:Button_setGrey(claim, true)
        end
        refreshNodeRedPoint(claim, complete and not claimed, {
            x = 72,
            y = 15,
            autoScale = 0.65,
        })
    end
end

local function refreshProgress(parent, kind, map)
    if not parent or not map then
        return
    end
    local active, total = mapProgress(kind, map)
    local percentage = total > 0 and math.floor(active * 100 / total) or 0
    local progressText = GUI:getChildByName(parent, "progress_text")
    if progressText then
        GUI:Text_setString(progressText, string.format("章节进度 %d/%d", active, total))
    end
    local progressPercent = GUI:getChildByName(parent, "progress_percent")
    if progressPercent then
        GUI:Text_setString(progressPercent, percentage .. "%")
    end
    local progressFill = GUI:getChildByName(parent, "progress_fill")
    if progressFill then
        local progressBg = GUI:getChildByName(parent, "progress_bg")
        local progressSize = progressBg and GUI:getContentSize(progressBg) or {}
        local progressW = tonumber(progressSize.width) or 630
        GUI:setContentSize(progressFill, math.max(1, percentage * progressW / 100), 6)
    end
end

local refreshEntryPositions
local updateVisibleEntryCards

local function refreshOverviewProgress()
    if not valid(Atlas.root) then
        return
    end

    for _, kind in ipairs({"monster", "equip"}) do
        local total, active = 0, 0
        for _, continent in ipairs(getVisibleContinents(kind)) do
            for _, map in ipairs(continent.maps or {}) do
                for _, entry in ipairs(map[kind] or {}) do
                    total = total + 1
                    if isActive(kind, entry) then
                        active = active + 1
                    end
                end
            end
        end
        local progress = GUI:getChildByName(Atlas.root, kind .. "_overview_progress")
        if progress then
            GUI:Text_setString(progress, string.format("%d/%d", active, total))
            GUI:Text_setTextColor(progress, active > 0 and GREEN or MUTED)
        end
    end
    refreshOverviewRedpoints()
end

local function refreshDetailState(previousState)
    local kind = Atlas.view == "equip" and "equip" or "monster"
    local map = findConfigMap(Atlas.mapId)
    local panel = valid(Atlas.root) and GUI:getChildByName(Atlas.root, "detail_panel") or nil
    if not map or not panel or not mapSupportsKind(kind, map) then
        return false
    end

    local activeChanged = false
    local cardChanged = false
    local chapterKey = mapKey(kind, map)
    local chapterChanged = (tonumber((previousState.chapter_claimed or {})[chapterKey] or 0) == 1)
        ~= (tonumber((state.chapter_claimed or {})[chapterKey] or 0) == 1)
    for _, entry in ipairs(map[kind] or {}) do
        local id = getEntryId(entry)
        local oldActive = tonumber((previousState[kind] or {})[id] or 0) == 1
        local newActive = isActive(kind, entry)
        local oldClaimed = tonumber((previousState[kind .. "_claimed"] or {})[id] or 0) == 1
        local newClaimed = isClaimed(kind, entry)
        local oldAttr = kind == "monster" and (tonumber((previousState.monster_attr or {})[id] or 0) or 0) or 0
        local newAttr = kind == "monster" and (tonumber((state.monster_attr or {})[id] or 0) or 0) or 0

        if oldActive ~= newActive then
            activeChanged = true
        end
        if oldActive ~= newActive or oldClaimed ~= newClaimed or oldAttr ~= newAttr then
            local data = (Atlas.cards[kind] or {})[id]
            if data and valid(data.node) then
                renderEntryCard(data.node, kind, data.entry)
            end
            cardChanged = true
        end
    end

    if cardChanged then
        refreshEntryPositions(kind, map)
    end
    if activeChanged or cardChanged or chapterChanged then
        GUI:removeChildByName(panel, "chapter_panel")
        refreshProgress(panel, kind, map)
        renderChapterPanel(panel, kind, map)
    end
    return activeChanged or cardChanged or chapterChanged
end

local function sameStateTable(a, b)
    a = type(a) == "table" and a or {}
    b = type(b) == "table" and b or {}
    for key, value in pairs(a) do
        if tostring(value) ~= tostring(b[key]) then
            return false
        end
    end
    for key, value in pairs(b) do
        if tostring(value) ~= tostring(a[key]) then
            return false
        end
    end
    return true
end

local function stateChanged(previousState)
    previousState = type(previousState) == "table" and previousState or {}
    for _, key in ipairs({"monster", "equip", "monster_claimed", "equip_claimed", "chapter_claimed", "monster_attr"}) do
        if not sameStateTable(previousState[key], state[key]) then
            return true
        end
    end
    return false
end

local function renderDetail(root)
    GUI:removeAllChildren(root)
    Atlas.overviewNodes = nil
    local kind = Atlas.view == "equip" and "equip" or "monster"
    renderTopNav(root, kind)
    Atlas.layout = getLayout()
    local layout = Atlas.layout

    local continents = AtlasCfg.continents or {}
    if #continents == 0 then
        text(root, "empty_config", 0, 0, 20, MUTED, "图鉴配置为空，请先维护客户端 atlas_data.lua", 0.5, 0.5)
        return
    end
    local visibleContinents = getVisibleContinents(kind)
    local currentMap, currentContinent = findConfigMap(Atlas.mapId)
    if not Atlas.mapId
        or not mapSupportsKind(kind, currentMap)
        or not isContinentUnlocked(currentContinent) then
        local selectedContinent, selectedMap = getCurrentMapSelection(kind)
        if selectedContinent then
            Atlas.expanded[tostring(selectedContinent.id or "")] = true
            local firstMap = getVisibleMaps(selectedContinent, kind)[1]
            if firstMap and firstMap.direct_equip then
                Atlas.expanded[tostring(selectedContinent.id or "")] = false
            end
        end
        Atlas.mapId = selectedMap and tostring(selectedMap.id or "") or nil
        normalizeExpanded(visibleContinents, selectedContinent and selectedContinent.id)
    else
        local selectedMap, selectedContinent = findConfigMap(Atlas.mapId)
        local firstMap = selectedContinent and getVisibleMaps(selectedContinent, kind)[1]
        normalizeExpanded(visibleContinents,
            firstMap and firstMap.direct_equip and nil or (selectedContinent and selectedContinent.id))
    end
    renderSideBar(root)

    local map, continent = findConfigMap(Atlas.mapId)
    if not map or not isContinentUnlocked(continent) or not mapSupportsKind(kind, map) then
        text(root, "empty_map", layout.panelX, layout.panelY, 18, MUTED, "请选择左侧地图", 0.5, 0.5)
        return
    end
    
    local bigkuang = GUI:Image_Create(root, "detail_bigkuang", layout.panelX, layout.panelY, "res/wy/public/guang.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 0.5)
    GUI:setContentSize(bigkuang, layout.panelW + 2, layout.panelH + 2)

    local panel = GUI:Image_Create(root, "detail_panel", layout.panelX, layout.panelY, RES .. "tj_30.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setContentSize(panel, layout.panelW, layout.panelH)
    GUI:setLocalZOrder(panel, 1)
    local active, total = mapProgress(kind, map)
    local percentage = total > 0 and math.floor(active * 100 / total) or 0
    local panelTop = layout.panelH
    text(panel, "map_title", 10, panelTop - 10, 30, GOLD,
        string.format("%s · %s", getName(continent, "未知大陆"), getName(map, "未知地图")), 0, 1)
    text(panel, "map_subtitle", 10, panelTop - 40, 18, MUTED,
        kind == "equip" and "本章节收录当前地图专属装备，拾取后立即激活。"
            or "本章节收录当前地图BOSS，击杀后立即激活。", 0, 1)


    local progressW = math.max(300, math.min(630, layout.panelW - 390))
    local progressBg = GUI:Image_Create(panel, "progress_bg", 10 + progressW / 2, panelTop - 80, RES .. "tj_16.png")
    GUI:setAnchorPoint(progressBg, 0.5, 0.5)
    GUI:setContentSize(progressBg, progressW, 16)
    local progressFill = GUI:Image_Create(panel, "progress_fill", 10, panelTop - 80, RES .. "tj_13.png")
    GUI:setAnchorPoint(progressFill, 0, 0.5)
    GUI:setContentSize(progressFill, math.max(1, percentage * progressW / 100), 6)
    text(panel, "progress_text", 50, panelTop - 80, 14, GOLD,
        string.format("章节进度 %d/%d", active, total), 0, 0.5)
    text(panel, "progress_percent", 10 + progressW + 20, panelTop - 80, 15, MUTED, percentage .. "%", 1, 0.5)

    local qyl_fgx = GUI:Image_Create(panel, "qyl_fgx", layout.panelW/2, layout.panelH - 120, "res/wy/public/qyl_fgx.png")
    GUI:setAnchorPoint(qyl_fgx, 0.5, 0.5)
    GUI:setContentSize(qyl_fgx, layout.panelW, 2)


    local entries = getSortedEntries(kind, map[kind] or {})
    local viewW = layout.panelW - 40
    local viewH = layout.panelH - 120
    local viewX = 20 + viewW / 2
    local viewY = viewH / 2
    local scroll = GUI:ScrollView_Create(panel, "entry_scroll", viewX, viewY, viewW, viewH, 1)
    GUI:setAnchorPoint(scroll, 0.5, 0.5)
    GUI:ScrollView_setDirection(scroll, 1)
    GUI:ScrollView_setClippingEnabled(scroll, true)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local columns = viewW >= CARD_W * 4 + CARD_GAP * 3 + 24 and 4 or 3
    local rows = math.max(1, math.ceil(#entries / columns))
    local gridW = columns * CARD_W + (columns - 1) * CARD_GAP
    local innerW = math.max(viewW, gridW + 20)
    local innerH = math.max(viewH, rows * CARD_H + (rows + 1) * CARD_GAP)
    GUI:ScrollView_setInnerContainerSize(scroll, innerW, innerH)
    Atlas.cards[kind] = {}
    Atlas.entryLayout = {
        kind = kind,
        mapId = tostring(map.id or ""),
        scroll = scroll,
        viewW = viewW,
        viewH = viewH,
        columns = columns,
        gridW = gridW,
        innerW = innerW,
        innerH = innerH,
        orderKey = getEntriesOrderKey(entries),
    }
    if type(GUI.ScrollView_addOnScrollEvent) == "function" then
        pcall(function()
            GUI:ScrollView_addOnScrollEvent(scroll, function()
                if updateVisibleEntryCards then
                    updateVisibleEntryCards()
                end
            end)
        end)
    end
    for i, entry in ipairs(entries) do
        local id = getEntryId(entry, i)
        local col = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        local gridLeft = math.max(CARD_GAP, (innerW - gridW) / 2)
        local cardX = gridLeft + col * (CARD_W + CARD_GAP)
        -- Keep the first row at the top, matching the client's vertical
        -- ScrollView convention used by the other list interfaces.
        local cardY = innerH - CARD_GAP - CARD_H / 2 - row * (CARD_H + CARD_GAP)
        local card = GUI:Image_Create(scroll, "entry_" .. id, cardX, cardY,
            entry.card_skin or (kind == "monster" and RES .. "tj_25.png" or RES .. "tj_26.png"))
        GUI:setAnchorPoint(card, 0, 0.5)
        GUI:setContentSize(card, CARD_W, CARD_H)
        Atlas.cards[kind][id] = {
            node = card,
            entry = entry,
            order = i,
            kind = kind,
            y = cardY,
        }
        applyEntryCardShell(card, kind, entry)
        if i <= columns * 2 then
            renderEntryCard(card, kind, entry)
        end
    end
    if updateVisibleEntryCards then
        updateVisibleEntryCards()
    end
    if #entries == 0 then
        text(panel, "empty_entries", 0, -80, 18, MUTED, "当前地图暂无图鉴配置", 0.5, 0.5)
    end
    renderChapterPanel(panel, kind, map)
end

refreshEntryPositions = function(kind, map)
    local layout = Atlas.entryLayout
    if type(layout) ~= "table"
        or layout.kind ~= kind
        or tostring(layout.mapId or "") ~= tostring(map and map.id or "")
        or not valid(layout.scroll) then
        return
    end

    local entries = getSortedEntries(kind, map[kind] or {})
    local orderKey = getEntriesOrderKey(entries)
    if layout.orderKey == orderKey then
        if updateVisibleEntryCards then
            updateVisibleEntryCards()
        end
        return
    end
    layout.orderKey = orderKey
    local gridLeft = math.max(CARD_GAP, (layout.innerW - layout.gridW) / 2)
    for index, entry in ipairs(entries) do
        local id = getEntryId(entry, index)
        local data = (Atlas.cards[kind] or {})[id]
        if data and valid(data.node) then
            local col = (index - 1) % layout.columns
            local row = math.floor((index - 1) / layout.columns)
            local cardX = gridLeft + col * (CARD_W + CARD_GAP)
            local cardY = layout.innerH - CARD_GAP - CARD_H / 2
                - row * (CARD_H + CARD_GAP)
            GUI:setPosition(data.node, cardX, cardY)
            data.y = cardY
            data.order = index
        end
    end
    if updateVisibleEntryCards then
        updateVisibleEntryCards()
    end
end

local function getEntryScrollInnerY(scroll)
    if type(GUI.ScrollView_getInnerContainerPosition) ~= "function" then
        return nil
    end
    local ok, pos = pcall(function()
        return GUI:ScrollView_getInnerContainerPosition(scroll)
    end)
    if ok and pos then
        return tonumber(pos.y or 0) or 0
    end
    return nil
end

local function isEntryDataNearView(data, layout, innerY)
    if innerY == nil then
        return true
    end
    local y = tonumber(data.y or (valid(data.node) and GUI:getPositionY(data.node)) or 0) or 0
    local top = y + CARD_H / 2
    local bottom = y - CARD_H / 2
    local viewBottom = -innerY - CARD_LAZY_BUFFER
    local viewTop = -innerY + (layout.viewH or 0) + CARD_LAZY_BUFFER
    return top >= viewBottom and bottom <= viewTop
end

updateVisibleEntryCards = function()
    local layout = Atlas.entryLayout
    if type(layout) ~= "table" or not valid(layout.scroll) then
        return
    end
    local kind = layout.kind
    local cards = Atlas.cards and Atlas.cards[kind] or {}
    local innerY = getEntryScrollInnerY(layout.scroll)
    for _, data in pairs(cards) do
        if data and valid(data.node) and isEntryDataNearView(data, layout, innerY) then
            renderEntryCard(data.node, kind, data.entry)
        end
    end
end

function Atlas.renderOverview()
    if valid(Atlas.root) then
        renderOverview(Atlas.root)
    end
end

function Atlas.renderDetail()
    if valid(Atlas.root) then
        renderDetail(Atlas.root)
    end
end

function Atlas.refreshEntry(kind, id)
    local data = (Atlas.cards[kind] or {})[tostring(id or "")]
    if data and valid(data.node) then
        renderEntryCard(data.node, kind, data.entry)
    end
    local map = findConfigMap(Atlas.mapId)
    local panel = valid(Atlas.root) and GUI:getChildByName(Atlas.root, "detail_panel") or nil
    local affectsCurrentMap = false
    if map then
        for _, entry in ipairs(map[kind] or {}) do
            if getEntryId(entry) == tostring(id or "") then
                affectsCurrentMap = true
                break
            end
        end
    end
    if map and panel and affectsCurrentMap then
        refreshEntryPositions(kind, map)
        GUI:removeChildByName(panel, "chapter_panel")
        refreshProgress(panel, kind, map)
        renderChapterPanel(panel, kind, map)
    end
    refreshSidebarRedpoints()
end

function Atlas.refreshChapter(kind, mapId)
    if not valid(Atlas.root) or tostring(Atlas.mapId or "") ~= tostring(mapId or "") then
        refreshSidebarRedpoints()
        return
    end
    local map = findConfigMap(mapId)
    local panel = GUI:getChildByName(Atlas.root, "detail_panel")
    if map and panel then
        GUI:removeChildByName(panel, "chapter_panel")
        renderChapterPanel(panel, kind, map)
    end
    refreshSidebarRedpoints()
end

function Atlas.handle(mode, msgData)
    local data = decode(msgData)
    mode = tonumber(mode) or 0
    if mode == 1 then
        if not valid(Atlas.root) then
            Atlas.open(true)
        end
        local previousState = snapshotState()
        replaceState(data.state)
        if not stateChanged(previousState) then
            return
        end
        if Atlas.view == "monster" or Atlas.view == "equip" then
            refreshDetailState(previousState)
            refreshSidebarRedpoints()
        elseif valid(Atlas.root) then
            refreshOverviewProgress()
            refreshSidebarRedpoints()
        end
    elseif mode == 2 or mode == 3 then
        setEntryState(data.kind, data.id, data.activated, data.claimed, data.attr_value)
        Atlas.refreshEntry(data.kind, data.id)
    elseif mode == 4 then
        state.chapter_claimed[tostring(data.kind or "") .. ":" .. tostring(data.map_id or "")] =
            tonumber(data.claimed or 1) == 1 and 1 or nil
        Atlas.refreshChapter(data.kind, data.map_id)
    end
end

function Atlas.open(skipRequest)
    Atlas.expanded = {}
    Atlas.cards = Atlas.cards or {monster = {}, equip = {}}
    Atlas.view = nil
    Atlas.mapId = nil
    Atlas.root = createRoot()
    Atlas.renderOverview()
    updateRedPoint(false)
    if not skipRequest then
        requestState()
    end
end

function Atlas.main()
    Atlas.open()
end

function Atlas.getConfig()
    return AtlasCfg
end

function Atlas.getState()
    return state
end

return Atlas
