local npc = {}
npc._config = teshudata["npc_9"]
local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/9/bg.png", eff = false},
    title = {x = 56 + 40, y = 464, skin = "res/custom/one_city/9/title.png"},
}
local TAB_ORDER = {2, 1}
local RING_UI = {
    [1] = {
        key = "fh",
        nameSkin = "res/custom/one_city/9/ring_fh.png",
        tipSkin = "res/custom/one_city/9/tip_fh.png",
        tabOn = "res/custom/one_city/9/tab_fh_on.png",
        tabOff = "res/custom/one_city/9/tab_fh_off.png",
    },
    [2] = {
        key = "mb",
        nameSkin = "res/custom/one_city/9/ring_mb.png",
        tipSkin = "res/custom/one_city/9/tip_mb.png",
        tabOn = "res/custom/one_city/9/tab_mb_on.png",
        tabOff = "res/custom/one_city/9/tab_mb_off.png",
    },
}
local other_wz = {
    {
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
        "复活后生命值提升",
    },
    {
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
        "麻痹概率提升",
    },
}
local function getItemDataByName(name)
    local itemIndex = name and SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
    return itemIndex and SL:GetMetaValue("ITEM_DATA", itemIndex) or nil
end
local function getEquipLevel(item)
    if not item or not item.Index then
        return 0
    end
    return tonumber(Player:getEquipFieldByIndex(item.Index, 1)) or 0
end
local function getEquipItem(cfgIdx)
    local where = npc._config and npc._config.where and npc._config.where[cfgIdx]
    return where and SL:GetMetaValue("EQUIP_DATA", where) or nil
end
local function getNextConfig(cfgIdx, equipLevel)
    local configList = npc._config and npc._config.config and npc._config.config[cfgIdx]
    if type(configList) ~= "table" then
        return nil
    end
    return configList[equipLevel]
end
local function getDefaultCfgIdx()
    if RING_UI[npc.selectedCfgIdx] then
        return npc.selectedCfgIdx
    end
    for _, cfgIdx in ipairs(TAB_ORDER) do
        if getEquipItem(cfgIdx) then
            return cfgIdx
        end
    end
    return TAB_ORDER[1]
end
local function buildPreviewText(currentItem, nextItem, equipLevel)
    if not currentItem then
        return "<font color='#ff6666' size='18'>请先穿戴对应特戒</font>\n\n<font color='#d7d7d7' size='16'>穿戴后可在这里查看当前属性与升级后的属性预览。</font>"
    end
    local parts = {
        string.format("<font color='#efad21' size='18'>当前属性  Lv.%d</font>", math.max(1, equipLevel)),
        string.format("人物攻击 + %d%%", equipLevel) or "",
    }
    if nextItem then
        parts[#parts + 1] = ""
        parts[#parts + 1] = string.format("<font color='#56d8ff' size='18'>升级预览  Lv.%d</font>", equipLevel + 1)
        parts[#parts + 1] = string.format("人物攻击 + %d%%", equipLevel + 1) or "" 
    else
        parts[#parts + 1] = ""
        parts[#parts + 1] = "<font color='#efad21' size='18'>已达最高等级</font>"
    end
    return table.concat(parts, "\n")
end
function npc.main(npcid, p2, p3, msgData)
    local UI_updata

    -- 特戒面板里的当前装备和升级预览只用于展示，不允许拖动。
    local function create_static_item_show(parent, name, x, y, itemInfo)
        local show = GUI:ItemShow_Create(parent, name, x, y, itemInfo)
        if show then
            GUI:setAnchorPoint(show, 0.5, 0.5)
        end
        return show
    end

    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end
    local function drawTab(node, cfgIdx, posY)
        local uiCfg = RING_UI[cfgIdx] or {}
        local selected = npc.selectedCfgIdx == cfgIdx
        local tab = GUI:Button_Create(node, "tab_" .. cfgIdx, 0, posY, selected and uiCfg.tabOn or uiCfg.tabOff)
        GUI:setAnchorPoint(tab, 0, 0)
        GUI:addOnClickEvent(tab, function()
            if npc.selectedCfgIdx == cfgIdx then
                return
            end
            npc.selectedCfgIdx = cfgIdx
            if npc.node then
                GUI:removeAllChildren(npc.node)
                UI_updata(npc.node)
            end
        end)
        local item = getEquipItem(cfgIdx)
        local equipLevel = getEquipLevel(item)
        local nextConfig = (item and equipLevel < (npc._config.max_level or 0)) and getNextConfig(cfgIdx, equipLevel) or nil
        local canPay = nextConfig and nextConfig.cost and checkItemNum(nextConfig.cost)
        if canPay then
            NPC_UI_HELPER.redpoint_create(tab, {x = 120, y = 110, autoScale = 0.9})
        end
    end
    UI_updata = function(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        npc.selectedCfgIdx = getDefaultCfgIdx()
        local cfgIdx = npc.selectedCfgIdx
        local uiCfg = RING_UI[cfgIdx] or {}
        local item = getEquipItem(cfgIdx)
        local equipLevel = getEquipLevel(item)
        local nextConfig = (item and equipLevel < (npc._config.max_level or 0)) and getNextConfig(cfgIdx, equipLevel) or nil
        local nextItem = nextConfig and getItemDataByName(nextConfig.give) or nil
        local canUpgrade = item and equipLevel < (npc._config.max_level or 0) and nextConfig ~= nil
        local canPay = canUpgrade and checkItemNum(nextConfig.cost)
        -- GUI:Text_Create(node, "slogan_shadow", 82, 420, 22, "#000000", "左手麻痹 / 右手复活 / 传奇大陆横着走！")
        -- local slogan = GUI:Text_Create(node, "slogan", 80, 422, 22, "#DDEEFF", "左手麻痹 / 右手复活 / 传奇大陆横着走！")
        -- GUI:Text_setFontName(slogan, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(slogan, "#000000", 2)
        drawTab(node, 2, 252)
        drawTab(node, 1, 121)
        if uiCfg.nameSkin then
            GUI:Image_Create(node, "ring_name", 138, 360, uiCfg.nameSkin)
        end
        -- local levelText = item and string.format("Lv.%d", math.max(1, equipLevel)) or "未穿戴"
        -- local levelColor = item and "#EFAD21" or "#FF6666"
        -- local levelLabel = GUI:Text_Create(node, "level", 215, 358, 20, levelColor, levelText)
        -- GUI:Text_setFontName(levelLabel, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(levelLabel, "#000000", 2)
        if item then
            create_static_item_show(node, "item_current", 248, 128, {
                itemData = item,
                look = true,
                movable = false,
                bgVisible = false,
            })
        else
            local tip = GUI:Text_Create(node, "wear_tip", 248, 128, 25, "#A5A5A5", "请先穿戴")
            GUI:setAnchorPoint(tip, 0.5, 0.5)
            GUI:Text_setFontName(tip, "fonts/font4.ttf")
            GUI:Text_enableOutline(tip, "#000000", 2)
        end
        if canUpgrade and nextItem then
            create_static_item_show(node, "item_next", 248, 287, {
                itemData = nextItem,
                look = true,
                movable = false,
                bgVisible = false,
            })
        else
            local tipText = item and "满级" or "预览"
            local nextTip = GUI:Text_Create(node, "next_tip", 248, 287, 18, "#EFAD21", tipText)
            GUI:setAnchorPoint(nextTip, 0.5, 0.5)
            GUI:Text_setFontName(nextTip, "fonts/font4.ttf")
            GUI:Text_enableOutline(nextTip, "#000000", 2)
        end
        if nextConfig and nextConfig.cost then
            for costIdx = 1, math.min(2, #nextConfig.cost) do
                local entry = nextConfig.cost[costIdx]
                local costNode = checkItemNumByTable_img_kuang({entry}, nil, GUI:Node_Create(node, "cost_node_" .. costIdx, 0, 0))
                GUI:setPosition(costNode, (costIdx == 1) and 85 or 85 + 220, 122 + 20)
            end
        end
        local previewCenterX = 610
        local previewTopY = item and 302 or 280
        local function createPreviewLine(name, y, size, color, text)
            local line = GUI:Text_Create(node, name, previewCenterX, y, size, color, text)
            GUI:setAnchorPoint(line, 0.5, 0.5)
            -- GUI:Text_setFontName(line, "fonts/font4.ttf")
            -- GUI:Text_enableOutline(line, "#100808", 2)
            return line
        end
        if item then
            createPreviewLine("preview_cur_title", previewTopY, 18, "#EFAD21", string.format("当前属性  Lv.%d", math.max(1, equipLevel)))
            createPreviewLine("preview_cur_attr", previewTopY - 26, 17, "#F7F7DE", string.format("人物攻击 + %d%%", equipLevel))
            if nextItem then
                createPreviewLine("preview_next_title", previewTopY - 72, 18, "#56D8FF", string.format("升级预览  Lv.%d", equipLevel + 1))
                createPreviewLine("preview_next_attr", previewTopY - 98, 17, "#F7F7DE", string.format("人物攻击 + %d%%", equipLevel + 1))
                createPreviewLine("preview_next_desc", previewTopY - 124, 17, "#F7F7DE", other_wz[cfgIdx][equipLevel] or "")
            else
                createPreviewLine("preview_max", previewTopY - 72, 18, "#EFAD21", "已达最高等级")
            end
        else
            createPreviewLine("preview_empty_title", previewTopY, 18, "#FF6666", "请先穿戴对应特戒")
            createPreviewLine("preview_empty_desc1", previewTopY - 30, 16, "#D7D7D7", "穿戴后可在这里查看当前属性")
            createPreviewLine("preview_empty_desc2", previewTopY - 55, 16, "#D7D7D7", "与升级后的属性预览")
        end
        if uiCfg.tipSkin then
            GUI:Image_Create(node, "tip_img", 430, 36, uiCfg.tipSkin)
        end
        local upgradeBtn = GUI:Button_Create(node, "upgrade_btn", 250, 40, "res/custom/one_city/9/btn_upgrade.png")
        GUI:setAnchorPoint(upgradeBtn, 0.5, 0.5)
        GUI:addOnClickEvent(upgradeBtn, function()
            if not item then
                SL:ShowSystemTips("请先穿戴对应特戒")
                return
            end
            if not canUpgrade then
                SL:ShowSystemTips("当前特戒已达最高等级")
                return
            end
            SL:SendLuaNetMsg(100, npcid, 1, cfgIdx, "")
        end)
        GUI:Button_setGrey(upgradeBtn, not canUpgrade)
        if canPay then
            NPC_UI_HELPER.redpoint_create(upgradeBtn)
        end
    end
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        if npc.node then
            UI_updata(npc.node)
        end
    end
end
return npc
