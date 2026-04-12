local npc = {}

npc._config = teshudata["npc_64"]
local UIHelper = NPC_UI_HELPER

local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/lingshou/bg.png", eff = false},
    closeButton = {x = 350 + 470, y = 180 + 288, skin = "res/wy/public/close_red_big.png"},
}

local DETAIL_WINDOW_OPTS = {
    windowName = "npc_64_detail",
    background = {skin = "res/custom/four_city/lingshou/xjm/bg.png"},
    closeButton = {x = 330 + 220 + 347, y = 180 + 180 + 51, skin = "res/wy/public/close_red_big.png"},
}

local TIP_WINDOW_OPTS = {
    windowName = "npc_64_tip",
    background = {skin = "res/custom/four_city/lingshou/tip/bg.png"},
    closeButton = {x = 330 + 220 + 347 - 295, y = 180 + 180 + 51 - 100, skin = "res/wy/public/close_red_big.png"},
}

local MAX_STAR = math.min(tonumber(npc._config and npc._config.max_star or 3) or 3, 3)
local GRID_COLUMNS = 8
local GRID_CELL_W = 74
local GRID_CELL_H = 86
local GRID_WIDTH = GRID_COLUMNS * GRID_CELL_W
local GRID_HEIGHT = 360

local function _type_count()
    return #(npc._config and npc._config.config and npc._config.config.ls or {})
end

local function _has_cost(cost)
    if type(cost) ~= "table" then
        return false
    end
    local ok, result = pcall(function()
        return checkItemNum(cost)
    end)
    return ok and result == true
end

local function _item_count_by_name(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if not idx then
        return 0
    end
    return tonumber(SL:GetMetaValue("ITEM_COUNT", idx)) or 0
end

local function _redpoint_if(parent, condition, opts)
    if condition and parent and UIHelper and UIHelper.redpoint_create then
        UIHelper.redpoint_create(parent, opts)
    end
end

local function _deep_copy(data)
    if type(data) ~= "table" then
        return data
    end
    local result = {}
    for key, value in pairs(data) do
        result[key] = _deep_copy(value)
    end
    return result
end

function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(id)
        local opts = {}
        for key, value in pairs(WINDOW_OPTS) do
            opts[key] = value
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(id, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, id, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function getData()
        npc.data = npc.data or {}
        npc.data.T_data = npc.data.T_data or {}
        npc.data.T_data.warehouse = npc.data.T_data.warehouse or {}
        npc.data.T_data.syw_type = npc.data.T_data.syw_type or {}
        return npc.data
    end

    local function getWarehouse()
        return getData().T_data.warehouse
    end

    local function getTypeCfg(typeId)
        return npc._config and npc._config.config and npc._config.config.ls and npc._config.config.ls[typeId] or nil
    end

    local function getFeedCfg(level)
        return npc._config and npc._config.config and npc._config.config.wy and npc._config.config.wy.det and npc._config.config.wy.det[level] or nil
    end

    local function getFeedCost(level)
        return npc._config and npc._config.config and npc._config.config.wy and npc._config.config.wy.cost and npc._config.config.wy.cost[level] or nil
    end

    local function findItemByUid(uid)
        if not uid then
            return nil
        end
        for _, item in ipairs(getWarehouse()) do
            if item and tonumber(item.uid or 0) == tonumber(uid) then
                return item
            end
        end
        return nil
    end

    local function getCurrentSummonItem()
        return findItemByUid(getData().T_data.dqzh_uid)
    end

    local function getSameStarCount(typeId, star)
        local count = 0
        for _, item in ipairs(getWarehouse()) do
            if item and tonumber(item.id or 0) == tonumber(typeId or 0) and tonumber(item.star or 0) == tonumber(star or 0) then
                count = count + 1
            end
        end
        return count
    end

    local function canFeedItem(item)
        if not item then
            return false
        end
        local feed = tonumber(item.feed or 1) or 1
        local maxLevel = tonumber(npc._config.config.wy.max_level or 1) or 1
        if feed >= maxLevel then
            return false
        end
        return _has_cost(getFeedCost(feed + 1))
    end

    local function canStarItem(item)
        if not item then
            return false
        end
        local star = tonumber(item.star or 0) or 0
        if star >= MAX_STAR then
            return false
        end
        return getSameStarCount(item.id, star) >= 3
    end

    local function canEquipSyw(item)
        if not item then
            return false
        end
        local data = getData()
        if data.T_data.syw_type[tostring(item.id)] == 1 then
            return false
        end
        local typeCfg = getTypeCfg(item.id)
        return _item_count_by_name(typeCfg and typeCfg.syw or nil) > 0
    end

    local function buildWarehouseList()
        local data = getData()
        local currentUid = tonumber(data.T_data.dqzh_uid or 0) or 0
        local list = {}
        for _, item in ipairs(getWarehouse()) do
            if item then
                table.insert(list, {
                    uid = tonumber(item.uid or 0) or 0,
                    id = tonumber(item.id or 0) or 0,
                    star = tonumber(item.star or 0) or 0,
                    feed = tonumber(item.feed or 1) or 1,
                    syw = data.T_data.syw_type[tostring(item.id)] == 1,
                    current = tonumber(item.uid or 0) == currentUid,
                })
            end
        end
        table.sort(list, function(left, right)
            if left.current ~= right.current then
                return left.current
            end
            if left.id ~= right.id then
                return left.id < right.id
            end
            if left.star ~= right.star then
                return left.star > right.star
            end
            if left.feed ~= right.feed then
                return left.feed > right.feed
            end
            return left.uid < right.uid
        end)
        return list
    end

    local function createPetCard(parent, item, x, y, scaleValue, clickCb)
        local typeCfg = getTypeCfg(item.id)
        local button = GUI:Button_Create(parent, "pet_" .. tostring(item.uid), x, y, "res/custom/four_city/lingshou/l_" .. tostring(item.id) .. ".png")
        GUI:setScale(button, scaleValue or 1)

        for starIndex = 1, MAX_STAR do
            local active = item.star >= starIndex
            local starY = 78 + (starIndex - 1) * 30
            local star = GUI:Image_Create(button, "star_" .. starIndex, 88, starY, "res/custom/four_city/lingshou/star_" .. (active and "l" or "n") .. ".png")
            GUI:setScale(star, 0.82)
        end

        local feedText = GUI:Text_Create(button, "feed", 88, 18, 16, "#00FFFF", "亲密" .. tostring(item.feed))
        GUI:setAnchorPoint(feedText, 0.5, 0.5)
        GUI:Text_setFontName(feedText, "fonts/font4.ttf")
        GUI:Text_enableOutline(feedText, "#000000", 1)

        if item.current then
            local state = GUI:Text_Create(button, "state", 88, 42, 16, "#00FF95", "出战中")
            GUI:setAnchorPoint(state, 0.5, 0.5)
            GUI:Text_setFontName(state, "fonts/font4.ttf")
            GUI:Text_enableOutline(state, "#000000", 1)
            local eff = GUI:Frames_Create(button, "eff", 108, 355, "res/custom/four_city/lingshou/new/eff_", ".png", 1, 15,
                {speed = 75, count = 15, loop = -1})
            GUI:setAnchorPoint(eff, 0.5, 0.5)
        end

        if item.syw then
            local sywText = GUI:Text_Create(button, "syw", 88, 60, 15, "#F7DE91", "圣遗")
            GUI:setAnchorPoint(sywText, 0.5, 0.5)
            GUI:Text_setFontName(sywText, "fonts/font4.ttf")
            GUI:Text_enableOutline(sywText, "#000000", 1)
        end

        local name = GUI:Text_Create(parent, "name_" .. tostring(item.uid), x + 88 * (scaleValue or 1), y - 12, 18, "#FFFFFF", typeCfg and typeCfg.name or "")
        GUI:setAnchorPoint(name, 0.5, 0.5)
        GUI:Text_setFontName(name, "fonts/500.ttf")
        GUI:Text_enableOutline(name, "#000000", 1)

        if clickCb then
            GUI:addOnClickEvent(button, clickCb)
        end
        return button
    end

    local function renderTipsWindow()
        npc.tipWindow = NPC_UI_HELPER.ensureWindow(npc.tipWindow, npcid, TIP_WINDOW_OPTS)
    end

    local function renderDetailWindow(item)
        if not item then
            return
        end
        local typeCfg = getTypeCfg(item.id)
        if not typeCfg then
            return
        end

        npc.detailWindow = NPC_UI_HELPER.ensureWindow(npc.detailWindow, npcid, DETAIL_WINDOW_OPTS)
        local node = npc.detailWindow.node
        GUI:removeAllChildren(node)

        local effect = GUI:Frames_Create(node, "eff", 288, 314, "res/custom/four_city/lingshou/xjm/eff/" .. tostring(item.id) .. "/eff_", ".png", 1, 30,
            {speed = 75, count = 30, loop = -1})
        GUI:setAnchorPoint(effect, 0.5, 0.5)

        local titleImage = GUI:Image_Create(node, "title", 290, 430, "res/custom/four_city/lingshou/xjm/wz_" .. tostring(item.id) .. ".png")
        GUI:setAnchorPoint(titleImage, 0.5, 0.5)
        GUI:Text_Create(titleImage, "qmd", 170, 31, 20, "#FF00FF", tostring(item.feed * 10) .. "%")
        local feedCfg = getFeedCfg(item.feed) or {}
        GUI:Text_Create(titleImage, "zhsj", 170, 7, 18, "#00FFFF", tostring(feedCfg.time or 0) .. "秒")

        local title = GUI:Text_Create(node, "detail_title", 288, 470, 20, "#F7DE91", string.format("%s  UID:%d", typeCfg.name, item.uid))
        GUI:setAnchorPoint(title, 0.5, 0.5)
        GUI:Text_setFontName(title, "fonts/500.ttf")
        GUI:Text_enableOutline(title, "#000000", 1)

        local infoText = string.format(
            "当前星级：%d星\n当前亲密：%d级\n基础属性：%s\n羁绊技能：%s\n主动技能：%s",
            item.star,
            item.feed,
            tostring(typeCfg.attr_wz or ""),
            tostring(typeCfg.b_skill or ""),
            tostring(typeCfg.s_skill or "")
        )
        local info = GUI:RichText_Create(node, "info", 430, 392, infoText, 360, 20, "#FFFFFF", 6, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
        GUI:setAnchorPoint(info, 0, 1)

        GUI:Image_Create(node, "syw", 170, 150, "res/custom/four_city/lingshou/xjm/syw.png")
        local sywFrame = GUI:Image_Create(node, "syw_frame", 290, 140, "res/wy/public/58_58_kuang.png")
        local sywItem = GUI:ItemShow_Create(sywFrame, "syw_item", 29, 29, {
            index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", typeCfg.syw),
            look = true,
            bgVisible = false,
        })
        GUI:setAnchorPoint(sywItem, 0.5, 0.5)
        local sywActive = getData().T_data.syw_type[tostring(item.id)] == 1
        GUI:Text_Create(sywFrame, "syw_state", 40, 0, 18, sywActive and "#00FF95" or "#FF6666", sywActive and "已激活" or "未激活")

        local feedCost = getFeedCost(item.feed + 1) or {}
        if item.feed < tonumber(npc._config.config.wy.max_level or 1) then
            GUI:Image_Create(node, "cost_img", 490, 110, "res/custom/four_city/lingshou/xjm/cost.png")
            local costNode = checkItemNumByTable_img_kuang(feedCost, nil, node)
            GUI:setPosition(costNode, 590, 100)
        end

        local summonBtn = GUI:Button_Create(node, "btn_summon", 760, 110, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        GUI:Button_setTitleText(summonBtn, item.current and "出战中" or "出战")
        GUI:Button_setTitleFontSize(summonBtn, 18)
        if item.current then
            GUI:Button_setBrightEx(summonBtn, false)
        else
            GUI:addOnClickEvent(summonBtn, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({uid = item.uid}, false))
            end)
        end

        local feedBtn = GUI:Button_Create(node, "btn_feed", 760, 55, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        GUI:Button_setTitleText(feedBtn, item.feed >= tonumber(npc._config.config.wy.max_level or 1) and "亲密已满" or "提升亲密")
        GUI:Button_setTitleFontSize(feedBtn, 18)
        if canFeedItem(item) then
            GUI:addOnClickEvent(feedBtn, function()
                SL:SendLuaNetMsg(100, npcid, 3, 0, SL:JsonEncode({uid = item.uid}, false))
            end)
            _redpoint_if(feedBtn, true, {x = 150, y = 40})
        else
            GUI:Button_setBrightEx(feedBtn, false)
        end

        local starBtn = GUI:Button_Create(node, "btn_star", 760, 0, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        local sameStarCount = getSameStarCount(item.id, item.star)
        local starText = item.star >= MAX_STAR and "已满星" or ("提升星级 " .. tostring(math.min(sameStarCount, 3)) .. "/3")
        GUI:Button_setTitleText(starBtn, starText)
        GUI:Button_setTitleFontSize(starBtn, 18)
        if canStarItem(item) then
            GUI:addOnClickEvent(starBtn, function()
                SL:SendLuaNetMsg(100, npcid, 4, 0, SL:JsonEncode({uid = item.uid}, false))
            end)
            _redpoint_if(starBtn, true, {x = 150, y = 40})
        else
            GUI:Button_setBrightEx(starBtn, false)
        end

        local sywBtn = GUI:Button_Create(node, "btn_syw", 760, -55, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        GUI:Button_setTitleText(sywBtn, sywActive and "圣遗已激活" or "激活圣遗")
        GUI:Button_setTitleFontSize(sywBtn, 18)
        if canEquipSyw(item) then
            GUI:addOnClickEvent(sywBtn, function()
                SL:SendLuaNetMsg(100, npcid, 5, 0, SL:JsonEncode({uid = item.uid}, false))
            end)
            _redpoint_if(sywBtn, true, {x = 150, y = 40})
        else
            GUI:Button_setBrightEx(sywBtn, false)
        end

        local attrPanel = GUI:Node_Create(node, "attr_panel", 430, 150)
        local attrList = _deep_copy(feedCfg.attr or {})
        for index, attr in ipairs(attrList) do
            local rowY = 110 - (index - 1) * 26
            local row = GUI:Image_Create(attrPanel, "attr_row_" .. index, 0, rowY, "res/custom/tianshu/qh/tip.png")
            GUI:RichText_Create(row, "attr_desc", 20, 0, Player:showAttr({{attr[1], attr[2]}}), 240, 17, "#f7f7de", 3, nil, nil)
        end
    end

    local function renderMain(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)

        local warehouse = buildWarehouseList()
        local currentItem = getCurrentSummonItem()

        GUI:Text_Create(node, "left_title", 150, 445, 24, "#F7DE91", "当前出战")
        GUI:Text_setFontName(GUI:getChildByName(node, "left_title"), "fonts/500.ttf")
        GUI:Text_enableOutline(GUI:getChildByName(node, "left_title"), "#000000", 1)

        if currentItem then
            createPetCard(node, currentItem, 70, 150, 0.9, function()
                npc.selectedUid = currentItem.uid
                renderDetailWindow(currentItem)
            end)
        else
            local empty = GUI:Text_Create(node, "empty_current", 160, 280, 22, "#999999", "未出战")
            GUI:setAnchorPoint(empty, 0.5, 0.5)
            GUI:Text_setFontName(empty, "fonts/500.ttf")
            GUI:Text_enableOutline(empty, "#000000", 1)
        end

        GUI:Text_Create(node, "right_title", 370, 445, 24, "#F7DE91", "灵兽仓库")
        GUI:Text_setFontName(GUI:getChildByName(node, "right_title"), "fonts/500.ttf")
        GUI:Text_enableOutline(GUI:getChildByName(node, "right_title"), "#000000", 1)

        local gridBg = GUI:Image_Create(node, "grid_bg", 340, 70, "res/wy/public/15.png")
        GUI:setContentSize(gridBg, GRID_WIDTH + 20, GRID_HEIGHT)
        GUI:setOpacity(gridBg, 0)

        local scrollView = GUI:ScrollView_Create(gridBg, "warehouse_scroll", 0, 0, GRID_WIDTH + 20, GRID_HEIGHT, 1)
        GUI:ScrollView_setClippingEnabled(scrollView, true)

        local rowCount = math.max(1, math.ceil(#warehouse / GRID_COLUMNS))
        local contentHeight = math.max(rowCount * GRID_CELL_H, GRID_HEIGHT)
        GUI:ScrollView_setInnerContainerSize(scrollView, GRID_WIDTH + 20, contentHeight)

        for index, item in ipairs(warehouse) do
            local col = (index - 1) % GRID_COLUMNS
            local row = math.floor((index - 1) / GRID_COLUMNS)
            local x = 6 + col * GRID_CELL_W
            local y = contentHeight - (row + 1) * GRID_CELL_H + 8

            local cell = GUI:Node_Create(scrollView, "cell_" .. tostring(item.uid), x, y)
            createPetCard(cell, item, 0, 0, 0.36, function()
                npc.selectedUid = item.uid
                renderDetailWindow(item)
            end)

            local uidText = GUI:Text_Create(cell, "uid", 32, -2, 14, item.current and "#00FF95" or "#B8B8B8", "UID:" .. tostring(item.uid))
            GUI:setAnchorPoint(uidText, 0.5, 0.5)
            GUI:Text_setFontName(uidText, "fonts/font4.ttf")
            GUI:Text_enableOutline(uidText, "#000000", 1)
        end

        GUI:setAnchorPoint(GUI:Image_Create(node, "wz1", 998 / 2, 80, "res/custom/four_city/lingshou/wz1.png"), 0.5, 0.5)
        local summary = GUI:Text_Create(node, "summary", 499, 48, 20, "#F7DE91",
            string.format("仓库：%d/140    当前出战：%s", #warehouse, currentItem and (getTypeCfg(currentItem.id).name) or "未出战"))
        GUI:setAnchorPoint(summary, 0.5, 0.5)
        GUI:Text_setFontName(summary, "fonts/font4.ttf")
        GUI:Text_enableOutline(summary, "#000000", 1)

        local btnTip = GUI:Button_Create(node, "btn_tip", 998 / 2 - 250, 80, "res/custom/four_city/lingshou/btn_tip.png")
        local btnMake = GUI:Button_Create(node, "btn_make", 998 / 2, 80, "res/custom/four_city/lingshou/btn_make.png")
        GUI:setAnchorPoint(btnTip, 0.5, 0.5)
        GUI:setAnchorPoint(btnMake, 0.5, 0.5)

        GUI:addOnClickEvent(btnTip, renderTipsWindow)
        GUI:addOnClickEvent(btnMake, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        _redpoint_if(btnMake, _has_cost(npc._config.cost), {x = 240, y = 55})
    end

    local function refresh()
        ensureWindow(npcid)
        renderMain(npc.node)
        if npc.detailWindow and npc.selectedUid then
            local selected = findItemByUid(npc.selectedUid)
            if selected then
                renderDetailWindow(selected)
            end
        end
    end

    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        renderMain(npc.node)
    elseif p2 == 1 or p2 == 3 then
        local newData = SL:JsonDecode(msgData, false) or {}
        if type(newData) == "table" and next(newData) ~= nil then
            npc.data = newData
        end
        refresh()
    end
end

return npc
