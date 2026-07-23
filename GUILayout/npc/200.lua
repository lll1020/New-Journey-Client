local npc = {}

-- NPC 200 系列地图入口面板，负责展示地图信息与掉落

local RAW_MAP_CONFIG = {
    -- {地图名, x, y, 限制fun, 提示文本, 大陆ID, mob_name = "", mob_shape = 0, min_map = ""}
    [201] = {"山庄",0,0,nil,nil,1, mob_name = "枯灯客", mob_shape = 631, min_map = "010345"},
    [202] = {"幽谷",0,0,nil,nil,1, mob_name = "青苔妖", mob_shape = 200, min_map = "028561"},
    [203] = {"洞穴",0,0,nil,nil,1, mob_name = "石牙兽", mob_shape = 45, min_map = "027578"},
    [204] = {"古殿",0,0,nil,nil,1, mob_name = "破面俑", mob_shape = 12052, min_map = "027626"},

    -- [205] = {"隐藏地图二",0,0,nil,nil,2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [206] = {"野火帮",100,100,nil,nil,2, mob_name = "「焚骨统领·赤狱」", mob_shape = 16236, min_map = "028614"},
    [207] = {"极光城郊",100,100,nil,nil,2, mob_name = "「辉域守护者·冰霄」", mob_shape = 12015, min_map = "028574"},
    [208] = {"杀伐道场",100,100,nil,nil,2, mob_name = "古兵执戟者", mob_shape = 16192, min_map = "028808",other_name = "兵道古藏"},
    [209] = {"夜魔洞",100,100,nil,nil,2, mob_name = "「深夜魔君·漆渊」", mob_shape = 12011, min_map = "029393"},
    -- [210] = {"特殊秘境副本二",0,0,nil,nil,2, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},

    -- [211] = {"隐藏地图三",0,0,nil,nil,3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [212] = {"灰界",201,199,nil,nil,3, mob_name = "灰纹·潜噬者", mob_shape = 12033, min_map = "027907"},
    [213] = {"藏星海",100,100,nil,nil,3, mob_name = "≮群星渊皇≯", mob_shape = 16206, min_map = "027135",other_name = "葬星海"},
    [214] = {"苍云城",100,100,nil,nil,3, mob_name = "「红幕法皇」[咆哮]", mob_shape = 12054, min_map = "027198"},
    -- [215] = {"无主深渊",100,100,nil,nil,3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},
    [216] = {"草药谷",100,100,nil,nil,3, mob_name = "☆仙草大妖☆", mob_shape = 12079, min_map = "028854"},
    -- [217] = {"特殊秘境副本三",0,0,nil,nil,3, mob_name = "银爪收割者", mob_shape = 221, min_map = "000100"},

    [218] = {"酆都鬼城",100,100,nil,nil,4, mob_name = "「酆都之主·万魂冥君」", mob_shape = 16322, min_map = "027142"},
    [219] = {"大唐·长安城",100,100,nil,nil,4, mob_name = "「盛世暗面·长安城主」", mob_shape = 16247, min_map = "027166"},
    [220] = {"生肖灵域",100,100,nil,nil,4, mob_name = "★十二命相·生肖主宰★", mob_shape = 16251, min_map = "027231"},
    [221] = {"传说之地",100,100,nil,nil,4, mob_name = "≮万古传说·时代见证者≯", mob_shape = 16263, min_map = "027199"},

    [222] = {"灵兽谷",100,100,nil,nil,5, mob_name = "≮太古血脉·灵兽皇≯", mob_shape = 12100, min_map = "027246"},
    [223] = {"时空裂隙",100,100,nil,nil,5, mob_name = "★时空崩坏·裂界主★", mob_shape = 12100, min_map = "028125"},
    [224] = {"生命边界",100,100,nil,nil,5, mob_name = "≮生命终章·边界尊≯", mob_shape = 16121, min_map = "027242"},
    [225] = {"聊斋志异",100,100,nil,nil,5, mob_name = "≮书外真妖·异闻尊≯", mob_shape = 16121, min_map = "027146"},
    [226] = {"敦煌遗梦",100,100,nil,nil,5, mob_name = "≮文明余晖·敦煌尊≯", mob_shape = 16121, min_map = "010336"},
    [227] = {"世界禁墟",100,100,nil,nil,5, mob_name = "≮文明终点·禁墟尊≯", mob_shape = 16170, min_map = "027156"},

    [228] = {"登神之路",0,0,nil,nil,6, mob_name = "神庭执法者・圣光守卫", mob_shape = 16170, min_map = "027176", other_name = "登神之路"},
    [230] = {"冰川雪域",0,0,nil,nil,6, mob_name = "雪域冰王・寒魄", mob_shape = 16172, min_map = "028171", other_name = "冰川雪域"},
    [229] = {"血契之地",0,0,nil,nil,6, mob_name = "血契领主・血屠", mob_shape = 16171, min_map = "027402", other_name = "血契之地"},
    [231] = {"森罗魔域",0,0,nil,nil,6, mob_name = "森罗魔主・灭世", mob_shape = 16173, min_map = "028768", other_name = "森罗魔域"},
    [232] = {"边关烽城",0,0,nil,nil,6, mob_name = "镇关大将军・烈锋", mob_shape = 16174, min_map = "028574", other_name = "边关烽城"},
    [233] = {"盛世古城",0,0,nil,nil,6, mob_name = "古城守护神・天佑 [神圣]", mob_shape = 16175, min_map = "027248", other_name = "盛世古城"},
    [234] = {"兵道古藏",0,0,nil,nil,6, mob_name = "神道兵魂", mob_shape = 16176, min_map = "027188", other_name = "兵道古藏"},
    [235] = {"鬼道古藏",0,0,nil,nil,6, mob_name = "鬼道残魂", mob_shape = 16177, min_map = "027184", other_name = "鬼道古藏"},

    --特殊地图npc
    [300] = {"山脉入口", 92, 50,nil,nil,3, mob_name = "★南境荒王★", mob_shape = 12057, min_map = "027343"},
    [301] = {"旷野之原", 273, 33,nil,nil,3, mob_name = "≮北寒碎霜王≯", mob_shape = 12059, min_map = "027960"},
    [302] = {"恐怖裂隙", 34, 41,nil,nil,3, mob_name = "「灰翼风痕主」", mob_shape = 12039, min_map = "027941"},
    [303] = {"海峰孤岛", 33, 133,nil,nil,3, mob_name = "★西海古皇★[道法合一]", mob_shape = 12105, min_map = "027961"},
    [304] = {"葬星海滩", 184, 40,nil,nil,3, mob_name = "「海殇巨皇」[至高神灵]", mob_shape = 16166, min_map = "027241"},
    [305] = {"船长室", 40, 46,nil,nil,3, mob_name = "「幽航鬼主」[通灵]", mob_shape = 16147, min_map = "027802"},
    [306] = {"水手舱", 59, 11,nil,nil,3, mob_name = "≮水手怨皇≯[通灵]", mob_shape = 16150, min_map = "027975"},

    [307] = {"黄泉路", 49, 29,nil,nil,4, mob_name = "「黄泉尽头·忘川主宰」", mob_shape = 16131, min_map = "027825"},
    [308] = {"罗酆六天", 71, 78,nil,nil,4, mob_name = "★罗酆六天·冥律至尊★", mob_shape = 16131, min_map = "028802"},
    [309] = {"东海龙宫", 31, 83,nil,nil,4, mob_name = "≮东海真主·覆海龙皇≯", mob_shape = 16167, min_map = "027179"},
    [310] = {"黑风山", 158, 72,nil,nil,4, mob_name = "★黑风大王·裂山狂尊★", mob_shape = 16461, min_map = "028560"},
    [311] = {"黄风岭", 92, 368,nil,nil,4, mob_name = "≮黄风大圣·吞天妖尊≯", mob_shape = 16461, min_map = "028563"},
    [312] = {"女儿国", 161, 146,nil,nil,4, mob_name = "「红尘情劫·女国之主」", mob_shape = 16461, min_map = "027111"},
    [313] = {"通天河", 237, 39,nil,nil,4, mob_name = "≮通天河主·覆浪妖王≯", mob_shape = 16461, min_map = "028557"},
    [314] = {"狮驼岭", 17, 87,nil,nil,4, mob_name = "★狮驼三王·青狮★", mob_shape = 16461, min_map = "027295"},
    [315] = {"天竺山", 68, 66,nil,nil,4, mob_name = "≮梵天圣境·天竺尊主≯", mob_shape = 16461, min_map = "029407"},
    [316] = {"灵域·二层", 72, 25,nil,nil,4, mob_name = "≮灵域二层·秩序主宰≯", mob_shape = 16149, min_map = "027247"},
    [317] = {"灵域·三层", 63, 61,nil,nil,4, mob_name = "≮灵域三层·终序主宰≯", mob_shape = 16149, min_map = "029405"},
    [318] = {"灵域·秘境", 21, 20,nil,nil,4, mob_name = "★灵域秘境·原初主宰★", mob_shape = 16149, min_map = "027186"},
}

local CONTINENT_LABELS = {
    [1] = "第一大陆",
    [2] = "第二大陆",
    [3] = "第三大陆",
    [4] = "第四大陆",
    [5] = "第五大陆",
    [6] = "第六大陆",
}

local NPC_ALLOW_DEEP = {
    [201] = true,
    [202] = true,
    [203] = true,
    [204] = true,
}

local MAINLINE_ENTER_TASK_BY_NPC = {
    [201] = 2,
    [202] = 5,
    [203] = 8,
    [204] = 11,
}

local DEFAULT_OUTLINE = SL and SL:ConvertColorFromHexString("#100808") or "#100808"

npc._config = {}
npc._continents = {}

for id, value in pairs(RAW_MAP_CONFIG) do
    local cfg = {
        id = id,
        mapName = value.other_name or value[1],
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
local DEFAULT_DROP_NAMES = {
    "青天怒斩",
    "青天战幻甲",
    "青天战幻盔",
    "青天战幻链",
    "青天战幻镯",
    "青天战幻戒",
}
local defaultDropItems = nil

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

local function getDefaultDropItems()
    if defaultDropItems then
        return defaultDropItems
    end
    local list = {}
    for _, itemName in ipairs(DEFAULT_DROP_NAMES) do
        local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if idx then
            list[#list + 1] = {index = idx, name = itemName, count = 1}
        end
    end
    defaultDropItems = list
    return defaultDropItems
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
        return getDefaultDropItems()
    end
    if dropCache[monsterName] ~= nil then
        return dropCache[monsterName] ~= false and dropCache[monsterName] or getDefaultDropItems()
    end
    local cfg = npc.dlconfig and npc.dlconfig[monsterName]
    if not cfg or type(cfg.value) ~= "table" then
        dropCache[monsterName] = false
        return getDefaultDropItems()
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
    return dropCache[monsterName] ~= false and dropCache[monsterName] or getDefaultDropItems()
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
            GUI:setContentSize(GUI:Frames_Create(npc.bg, "eff1", 0, 0, "res/wy/eff/city/tongyong_0_dx_1_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
            GUI:setContentSize( GUI:Frames_Create(npc.bg, "eff2", 0, 0, "res/wy/eff/city/tongyong_0_dx_2_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
        

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
        renderMonsterModel(node, cfg, baseX - 40 + 90, monsterY + 20 - 332)

        createLabel(node, "monster_name", baseX + 4, monsterY - 33, 20, "#ff6666", string.format("%s", cfg.mobName or "未知"))


        renderDropList(node, baseX + 120 + 355, monsterY - 140 - 117, getDropItems(cfg.mobName, npc.data))
        renderMiniMap(node, cfg, baseX - 40 + 245, monsterY - 100)



        
        local actionY = -260
        local enterBtn = NPC_UI_HELPER.createPrimaryButton(node, "enter_btn", 0, actionY, nil, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end, {fontSize = 20,skin = "res/custom/ditu/qrcs_btn.png"})
        GUI:setAnchorPoint(enterBtn, 0.5, 0.5)
        NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, enterBtn, node, npcid, "enter", {
            dir = 5,
            taskMap = MAINLINE_ENTER_TASK_BY_NPC,
            desc = "点击进入地图",
            isForce = false,
            hideMask = false,
        })

        -- if NPC_ALLOW_DEEP[npcid] then
        --     local deepBtn = NPC_UI_HELPER.createPrimaryButton(node, "enter_deep_btn", 200, actionY, "进入地图深处", function()
        --         SL:SendLuaNetMsg(100, npcid, 1, 1, "")
        --     end, {fontSize = 20})
        --     GUI:setAnchorPoint(deepBtn, 0.5, 0.5)
        -- end

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
