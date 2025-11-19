local npc = {}

-- NPC 200 系列地图入口面板，负责展示地图信息与掉落

local RAW_MAP_CONFIG = {
    -- {地图名, x, y, 限制fun, 提示文本, 大陆ID, mob_name = "", mob_shape = 0, min_map = ""}
    [201] = {"山庄", 0, 0, nil, nil, 1, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [202] = {"幽谷", 0, 0, nil, nil, 1, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [203] = {"洞穴", 0, 0, nil, nil, 1, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [204] = {"古殿", 0, 0, nil, nil, 1, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},

    [205] = {"隐藏地图二", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [206] = {"野火帮", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [207] = {"极光城郊", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [208] = {"兵道古藏", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [209] = {"夜魔洞", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [210] = {"特殊秘境副本二", 100, 100, nil, nil, 2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},

    [211] = {"隐藏地图三", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [212] = {"灰界", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [213] = {"群星海", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [214] = {"红尘城", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [215] = {"无主深渊", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [216] = {"草药谷", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [217] = {"特殊秘境副本三", 100, 100, nil, nil, 3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
}

local CONTINENT_LABELS = {
    [1] = "第一大陆",
    [2] = "第二大陆",
    [3] = "第三大陆",
}

local NPC_ALLOW_DEEP = {
    [201] = true,
    [202] = true,
    [203] = true,
    [204] = true,
}

local DEFAULT_OUTLINE = SL and SL:ConvertColorFromHexString("#100808") or "#100808"

npc._config = {}
npc._continents = {}

for id, value in pairs(RAW_MAP_CONFIG) do
    local cfg = {
        id = id,
        mapName = value[1],
        x = value[2] or 0,
        y = value[3] or 0,
        limitFunc = value[4],
        tip = value[5],
        continent = value[6] or 1,
        mobName = value.mob_name,
        mobShape = value.mob_shape,
        minMap = value.min_map,
    }
    cfg.name = cfg.mapName
    npc._config[id] = cfg
    local bucket = npc._continents[cfg.continent]
    if not bucket then
        bucket = {}
        npc._continents[cfg.continent] = bucket
    end
    bucket[#bucket + 1] = cfg
end

for _, bucket in pairs(npc._continents) do
    table.sort(bucket, function(a, b)
        return a.id < b.id
    end)
end

npc.dlconfig = ssrRequireCsvCfg("cfg_TouShi")

local WINDOW_OPTS = {
    background = {skin = 'res/custom/ditu/ditu_bj_0.png'},
    closeButton = {x = 700, y = 440},
    node = {x = 500, y = 300},
}

local dropCache = {} -- 缓存怪物掉落解析结果
local MONSTER_MODEL_SIZE = {width = 260, height = 240}
local MINI_MAP_SIZE = {width = 390, height = 222}

local function getContinentLabel(continent)
    return CONTINENT_LABELS[continent] or string.format("第%s大陆", continent or "?")
end

local function toRichText(text)
    return (text or ""):gsub("\n", "<br/>")
end

local function resolveItemIndex(entry)
    if not entry then
        return nil
    end
    if type(entry) == "table" then
        if entry.index then
            return entry.index
        end
        if entry.name then
            return SL:GetMetaValue("ITEM_INDEX_BY_NAME", entry.name)
        end
    elseif type(entry) == "string" then
        return SL:GetMetaValue("ITEM_INDEX_BY_NAME", entry)
    end
    return nil
end

-- 返回该怪物的掉落清单：优先服务器下发的数据，其次 cfg_TouShi
local function getDropItems(monsterName, data)
    if data and type(data.drops) == "table" then
        local custom = {}
        for _, drop in ipairs(data.drops) do
            local idx = resolveItemIndex(drop)
            if idx then
                custom[#custom + 1] = {
                    index = idx,
                    count = (type(drop) == "table" and drop.count) or 1,
                    name = (type(drop) == "table" and drop.name) or drop,
                }
            end
        end
        if #custom > 0 then
            return custom
        end
    end
    if not monsterName or monsterName == "" then
        return nil
    end
    if dropCache[monsterName] ~= nil then
        return dropCache[monsterName] ~= false and dropCache[monsterName] or nil
    end
    local cfg = npc.dlconfig and npc.dlconfig[monsterName]
    if not cfg or type(cfg.value) ~= "table" then
        dropCache[monsterName] = false
        return nil
    end
    local list = {}
    for _, itemName in ipairs(cfg.value) do
        if type(itemName) == "string" and itemName ~= "" then
            local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            if idx then
                list[#list + 1] = {index = idx, name = itemName, count = 1}
            end
        end
    end
    dropCache[monsterName] = (#list > 0) and list or false
    return dropCache[monsterName] ~= false and dropCache[monsterName] or nil
end

local function createLabel(parent, name, x, y, size, color, text)
    local label = GUI:Text_Create(parent, name, x, y, size or 20, color or "#f7f7de", text or "")
    GUI:setAnchorPoint(label, 0, 1)
    GUI:Text_enableOutline(label, "#1d0f09", 1)
    return label
end

-- 掉落预览区：最多 6 件，使用 UserUILayout 自动排布
local function renderDropList(node, startX, startY, items)
    if not items or #items == 0 then
        createLabel(node, "drop_empty", startX, startY - 40, 18, "#a2c0c0", "暂无掉落数据")
        return
    end
    local preview = GUI:Layout_Create(node, "drop_preview", startX, startY - 50, 520, 120, false)
    GUI:setAnchorPoint(preview, 0.5, 0.5)
    local maxCount = math.min(#items, 6)
    for idx = 1, maxCount do
        local item = items[idx]
        local slot = GUI:Image_Create(preview, "drop_slot_" .. idx, 0, 0, "res/wy/public/58_58_kuang.png")
        local size = GUI:getContentSize(slot)
        local show = GUI:ItemShow_Create(slot, "drop_item_" .. idx, size.width / 2, size.height / 2, {
            index = item.index,
            count = item.count or 1,
            look = true,
            bgVisible = false
        })
        GUI:setAnchorPoint(show, 0.5, 0.5)
        GUI:setScale(show, 0.85)
    end
    GUI:UserUILayout(preview, {dir = 3, addDir = 1, colnum = 6, gap = {x = 5, y = 12}})
end


local function renderMonsterModel(node, cfg, originX, originY)
    GUI:removeChildByName(node, "monster_model_layer")
    local model = GUI:Effect_Create(node, "monster_model", originX, originY, 2, cfg.mobShape or 0, 0, 0, 5)
end

local function getMiniMapTexture(minMapId)
    if not minMapId or minMapId == "" then
        return nil
    end
    local candidates = {
        string.format("scene/uiminimap/%s.png", minMapId),
    }
    if UiTools and UiTools.getMiniMapPath then
        local fallback = UiTools.getMiniMapPath(minMapId)
        if fallback and fallback ~= "" then
            candidates[#candidates + 1] = fallback
        end
    end
    for _, path in ipairs(candidates) do
        if path and SL and SL.IsFileExist and SL:IsFileExist(path) then
            return path
        end
    end
    return nil
end

local function renderMiniMap(node, cfg, originX, originY)
    GUI:removeChildByName(node, "mini_map_layer")
    local layer = GUI:Layout_Create(node, "mini_map_layer", originX, originY, MINI_MAP_SIZE.width, MINI_MAP_SIZE.height, true)
    GUI:setAnchorPoint(layer, 0, 0.5)
    GUI:setTouchEnabled(layer, false)


    local mapPath = getMiniMapTexture(cfg and cfg.minMap)
    if mapPath then
        local mapImage = GUI:Image_Create(layer, "mini_map_image", MINI_MAP_SIZE.width / 2, MINI_MAP_SIZE.height / 2, mapPath)
        GUI:setAnchorPoint(mapImage, 0.5, 0.5)
        local size = GUI:getContentSize(mapImage)
        if size.width > 0 and size.height > 0 then
            local scale = math.min(MINI_MAP_SIZE.width / size.width, MINI_MAP_SIZE.height / size.height)
            GUI:setScale(mapImage, scale + 0.1)
        end
    else
        createLabel(layer, "mini_map_empty", 10, MINI_MAP_SIZE.height - 10, 18, "#f7f7de", "暂无地图预览")
    end

    local border = GUI:Image_Create(layer, "mini_map_border", MINI_MAP_SIZE.width / 2, MINI_MAP_SIZE.height / 2, "res/custom/ditu/ditu_zgai.png")
    GUI:setAnchorPoint(border, 0.5, 0.5)

    local base = GUI:Image_Create(layer, "monster_model_base", 10, GUI:getContentSize(border).height, "res/custom/ditu/ditu_name_box.png")
    GUI:setAnchorPoint(base, 0, 1)


    -- cfg and cfg.mapName  对这个汉语文字 每个汉字字之间加一个\n
    local mapName = cfg and cfg.mapName or "未知地图"
    SL:release_print("mapName:", mapName)

    local mapNameWithLineBreaks = mapName:gsub("[%z\1-\127\194-\244][\128-\191]*", "%0\n")
    local wz = GUI:Text_Create(base, "mini_map_coord", 8, GUI:getContentSize(base).height - 10, 30, "#ffe9c2", mapNameWithLineBreaks)
    GUI:setAnchorPoint(wz, 0, 1)
    GUI:Text_setFontName(wz, "fonts/500.ttf")


    local effwu = GUI:Frames_Create(layer, "effwu", 0, 0, "res/wy/eff/city/2_", ".png", 1, 15,
            { speed = 75, count = 15, loop = 1, finishhide = false })
    GUI:setContentSize(effwu, MINI_MAP_SIZE.width, MINI_MAP_SIZE.height)

    -- if cfg then
    --     local coordText = string.format("推荐坐标：(%d, %d)", cfg.x or 0, cfg.y or 0)
    --     local coordLabel = GUI:Text_Create(layer, "mini_map_coord", 10, -12, 18, "#ffe9c2", coordText)
    --     GUI:setAnchorPoint(coordLabel, 0, 0)
    --     GUI:Text_enableOutline(coordLabel, "#1d0f09", 1)
    -- end
end

function npc.main(npcid, p2, p3, msgData)
    npc.activeId = npcid
    npc.currentCfg = npc._config[npcid]

    -- 复用 NPC 通用窗口
    local function ensureWindow(id)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        if npc.currentCfg then
            opts.titleText = string.format("%s · %s", npc.currentCfg.mapName or NPC_UI_HELPER.formatNpcTitle(id), getContinentLabel(npc.currentCfg.continent))
        else
            opts.titleText = NPC_UI_HELPER.formatNpcTitle(id)
        end
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, id, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    -- 刷新核心界面
    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        local cfg = npc.currentCfg
        if not cfg then
            local warning = GUI:Text_Create(node, "missing_cfg", 0, 0, 24, "#ff6666", string.format("未找到 NPC %s 的地图配置", tostring(npcid)))
            GUI:setAnchorPoint(warning, 0.5, 0.5)
            GUI:Text_enableOutline(warning, "#200000", 1)
            return
        end

        local baseX = -320 - 73
        local topY = 200
        local monsterY = topY - 90
        createLabel(node, "monster_name", baseX + 4, monsterY - 33, 20, "#ff6666", string.format("%s", cfg.mobName or "未知"))


        renderMonsterModel(node, cfg, baseX - 40 + 90, monsterY + 20 - 332)
        renderDropList(node, baseX + 120 + 355, monsterY - 140 - 117, getDropItems(cfg.mobName, npc.data))
        renderMiniMap(node, cfg, baseX - 40 + 245, monsterY - 100)

        
        local actionY = -260
        local enterBtn = NPC_UI_HELPER.createPrimaryButton(node, "enter_btn", 0, actionY, nil, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end, {fontSize = 20,skin = "res/custom/ditu/qrcs_btn.png"})
        GUI:setAnchorPoint(enterBtn, 0.5, 0.5)

        if NPC_ALLOW_DEEP[npcid] then
            local deepBtn = NPC_UI_HELPER.createPrimaryButton(node, "enter_deep_btn", 200, actionY, "进入地图深处", function()
                SL:SendLuaNetMsg(100, npcid, 1, 1, "")
            end, {fontSize = 20})
            GUI:setAnchorPoint(deepBtn, 0.5, 0.5)
        end

        if npc.data and npc.data.extraTips then
            local infoRich = GUI:RichText_Create(node, "extra_tips", 220, actionY - 60,
                string.format("<font color='#f6ffb1' size='18'>%s</font>", toRichText(npc.data.extraTips)),
                300, 80, "#f6ffb1", 2, nil, nil, {outlineSize = 1, outlineColor = DEFAULT_OUTLINE})
            GUI:setAnchorPoint(infoRich, 0.5, 1)
        end
    end

    if p2 == 0 then
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = decodeData(msgData)
        UI_updata(npc.node)
    end
end

return npc
