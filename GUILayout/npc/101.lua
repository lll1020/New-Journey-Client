local npc = {
    currentTab = 1,
    selectedMilestoneIdx = nil,
}

npc._config = teshudata["npc_101"]

local REWARD_ITEM_EFFECT_ID = 14193

local function addRewardItemEffect(parent, name, x, y, scale)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local effect = GUI:Effect_Create(parent, name or "reward_item_eff", x or 0, y or 0, 0, REWARD_ITEM_EFFECT_ID, 0, 0, 0, 1)
    GUI:setScale(effect, scale or 1)
    return effect
end

local WINDOW_OPTS = {
    background = {skin = "res/custom/msfc/panel_bg.png"},
    closeButton = {x = 782, y = 470},
    title = {x = 80, y = 464, skin = "res/custom/msfc/title.png"},
}

local TAB_SKINS = {
    [1] = {
        light = "res/custom/msfc/tabs/tab1/state_2.png",
        dark = "res/custom/msfc/tabs/tab1/state_1.png",
    },
    [2] = {
        light = "res/custom/msfc/tabs/tab2/state_2.png",
        dark = "res/custom/msfc/tabs/tab2/state_1.png",
    },
}

local PAGE_BG_SKIN = {
    [1] = "res/custom/msfc/page1/bg.png",
    [2] = "res/custom/msfc/page2/bg.png",
}

local BOX_NAME = {
    low = "低级材料自选箱",
    high = "高级材料自选箱",
    super = "特级材料自选箱",
}

local BOX_P2 = {
    low = 1,
    high = 2,
    super = 3,
}

local UI_updata

local function toNumber(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function safeDecode(msgData)
    if type(msgData) ~= "string" or msgData == "" then
        return nil
    end
    return SL:JsonDecode(msgData, false)
end

local function ensureData(data)
    data = data or {}
    data.T_data = data.T_data or {}
    data.box_counts = data.box_counts or {}
    data.logs = data.logs or {}
    data.placeholder = data.placeholder or {}
    data.T_data.claim_normal = data.T_data.claim_normal or {}
    data.T_data.claim_crown = data.T_data.claim_crown or {}
    data.T_data.box_counts = data.T_data.box_counts or {}
    return data
end

local function getConfig()
    return npc._config or {}
end

local function getConfigValue(field, defaultValue)
    local cfg = getConfig()
    local value = cfg[field]
    if value == nil then
        return defaultValue
    end
    return value
end

local function getTokenName()
    return (npc.data and npc.data.token_name) or getConfigValue("token_name", getConfigValue("name", "抽奖次数"))
end

local function getDrawOnceCost()
    return toNumber((npc.data and npc.data.draw_once_cost), toNumber(getConfigValue("draw_once_cost", 1), 1))
end

local function getDrawTenCost()
    return toNumber((npc.data and npc.data.draw_ten_cost), toNumber(getConfigValue("draw_ten_cost", 10), 10))
end

local function getBuyCost()
    return (npc.data and npc.data.buy_cost) or getConfigValue("buy_cost", {})
end

local function getBuyCostText()
    local buyCost = getBuyCost()
    if type(buyCost) == "table" and type(buyCost[1]) == "table" then
        return tostring(toNumber(buyCost[1][2], 0))
    end
    return "0"
end

local function getDayCardConfig()
    return getConfigValue("day_card", {}) or {}
end

local function getDayCardNeedCharge()
    return toNumber((npc.data and npc.data.day_card_need_charge), toNumber(getDayCardConfig().need_charge, 28))
end

local function getDayCardTitleName()
    return tostring((getDayCardConfig().title or "日卡"))
end

local function getDayCardTokenCount()
    return toNumber(getDayCardConfig().token_count, 0)
end

local function getExchangeNeed()
    return toNumber((npc.data and npc.data.exchange_need), toNumber(getConfigValue("kill_per_exchange", 188), 188))
end

local function getExchangeLimit()
    return toNumber((npc.data and npc.data.exchange_limit), toNumber(getConfigValue("exchange_daily_limit", 50), 50))
end

local function getExchangeUsedCount()
    local candidates = {
        npc.data and npc.data.exchange_used,
        npc.data and npc.data.exchange_today_used,
        npc.data and npc.data.today_exchange_used,
        npc.data and npc.data.exchange_count,
        npc.data and npc.data.today_exchange_count,
    }
    for _, value in ipairs(candidates) do
        if tonumber(value) then
            return tonumber(value)
        end
    end

    local limit = getExchangeLimit()
    local available = toNumber(npc.data and npc.data.exchange_available, 0)
    if limit > 0 then
        return math.max(limit - available, 0)
    end
    return 0
end

local function getDailyKillCount()
    local candidates = {
        npc.data and npc.data.today_kills,
        npc.data and npc.data.total_kills,
        npc.data and npc.data.U_sgsl,
        npc.data and npc.data.daily_kill_count,
        npc.data and npc.data.today_kill_count,
        npc.data and npc.data.kill_count,
        npc.data and npc.data.today_kill,
        npc.data and npc.data.exchange_progress,
    }
    for _, value in ipairs(candidates) do
        if tonumber(value) then
            return tonumber(value)
        end
    end
    return 0
end

local function getBoxPool(boxType)
    local cfg = getConfig()
    local boxPool = cfg.box_pool or {}
    return boxPool[boxType] or {}
end

local function buildPoolTipText()
    local cfg = getConfig()
    local pool = cfg.pool or {}
    local fashionPool = cfg.fashion_pool or {}
    local guaranteeBoxes = cfg.guarantee_boxes or {}
    local lines = {
        "<font color='#FFE39A' size='18'>概率公示</font>",
        "<font color='#8DFFE0'>普通奖励</font>",
    }
    local fashionStarted = false

    for _, entry in ipairs(pool) do
        if entry.kind == "fashion_random" then
            if not fashionStarted then
                lines[#lines + 1] = "<font color='#FF9A6A'>时装奖励</font>"
                fashionStarted = true
            end
            for fashionIdx, fashionCfg in ipairs(fashionPool) do
                local rateText = fashionIdx <= 4 and "0.5%" or "0.25%"
                lines[#lines + 1] = string.format("<font color='#F3E8D0'>%s</font><font color='#9FFFD2'>  %s</font>", tostring(fashionCfg.name or ("时装" .. tostring(fashionIdx))), rateText)
            end
        else
            lines[#lines + 1] = string.format("<font color='#F3E8D0'>%s</font><font color='#9FFFD2'>  %s</font>", tostring(entry.label or ""), tostring(entry.show_rate or ""))
        end
    end

    lines[#lines + 1] = "<font color='#FFE39A'>保底规则</font>"
    lines[#lines + 1] = string.format("<font color='#F3E8D0'>每抽%s次</font><font color='#FFCF66'> 必出一个时装</font>", tostring(toNumber(cfg.fashion_pity_every, 200)))
    for _, guaranteeCfg in ipairs(guaranteeBoxes) do
        lines[#lines + 1] = string.format("<font color='#F3E8D0'>每%s抽必得：</font><font color='#B8D7FF'>%s</font>", tostring(toNumber(guaranteeCfg.every, 0)), tostring(guaranteeCfg.label or ""))
    end
    return table.concat(lines, "<br>")
end

local function getBoxCount(boxType)
    local dataCounts = npc.data and npc.data.box_counts
    if type(dataCounts) == "table" and dataCounts[boxType] ~= nil then
        return toNumber(dataCounts[boxType], 0)
    end
    local tDataCounts = npc.data and npc.data.T_data and npc.data.T_data.box_counts
    if type(tDataCounts) == "table" then
        return toNumber(tDataCounts[boxType], 0)
    end
    return 0
end

local function getHasCrown()
    if npc.data and npc.data.has_crown ~= nil then
        return toNumber(npc.data.has_crown, 0) == 1
    end
    return false
end

local function getMilestones()
    local milestones = {}
    local src = getConfigValue("milestones", {})
    for idx, cfg in pairs(src) do
        if type(cfg) == "table" then
            table.insert(milestones, {
                idx = toNumber(idx, 0),
                draw = toNumber(cfg.draw, 0),
                normal = cfg.normal,
                crown = cfg.crown,
            })
        end
    end
    table.sort(milestones, function(a, b)
        return a.draw < b.draw
    end)
    return milestones
end

local function findMilestoneByIdx(targetIdx)
    for _, cfg in ipairs(getMilestones()) do
        if cfg.idx == targetIdx then
            return cfg
        end
    end
    return nil
end

local function getMilestoneImage(draw)
    local skin = string.format("res/custom/msfc/page1/numbers/%s.png", tostring(draw))
    if SL and SL.IsFileExist and SL:IsFileExist(skin) then
        return skin
    end
    return nil
end

local function getRewardEntries(rewardPack)
    local list = {}

    local function pushEntry(name, count, label)
        if type(name) ~= "string" or name == "" then
            return
        end

        local realName = name
        local itemIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", realName), 0)
        if itemIndex <= 0 and not string.find(realName, "%[称号%]") then
            local titleName = realName .. "[称号]"
            local titleIndex = toNumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName), 0)
            if titleIndex > 0 then
                realName = titleName
                itemIndex = titleIndex
            end
        end

        table.insert(list, {
            name = realName,
            count = toNumber(count, 1),
            label = label or name,
            index = itemIndex,
        })
    end

    local function parseReward(reward)
        if type(reward) ~= "table" then
            return
        end
        local kind = tostring(reward.kind or "item")
        if kind == "item" then
            for _, give in ipairs(reward.give or {}) do
                pushEntry(give[1], give[2], reward.label)
            end
        elseif kind == "title" then
            pushEntry((reward.name or "") .. "[称号]", 1, reward.label or reward.name)
        elseif kind == "fashion" or kind == "footstep" then
            pushEntry(reward.name or reward.label or kind, 1, reward.label or reward.name or kind)
        elseif kind == "box" then
            pushEntry(reward.label or BOX_NAME[reward.box] or "自选箱", reward.num or 1, reward.label or BOX_NAME[reward.box])
        elseif kind == "placeholder" then
            pushEntry(reward.label or reward.name or "占位奖励", reward.num or 1, reward.label or reward.name)
        end
    end

    if type(rewardPack) == "table" then
        parseReward(rewardPack.main)
        parseReward(rewardPack.extra)
    end

    return list
end

local function getTodayRechargeValue()
    local candidates = {
        npc.data and npc.data.today_charge,
        npc.data and npc.data.day_recharge,
        npc.data and npc.data.today_recharge,
        npc.data and npc.data.rika_recharge,
        npc.data and npc.data.daily_recharge,
    }
    for _, value in ipairs(candidates) do
        if tonumber(value) then
            return tonumber(value)
        end
    end
    return 0
end

local function getDayCardRewards()
    local cfg = getDayCardConfig()
    local rewards = {}

    local titleName = getDayCardTitleName()
    local hasTitle = toNumber(npc.data and npc.data.day_card_has_title, 0) == 1
    if titleName ~= "" and not hasTitle then
        table.insert(rewards, {titleName .. "[称号]", 1})
    end

    for _, reward in ipairs(cfg.rewards or {}) do
        if type(reward) == "table" and type(reward[1]) == "string" then
            table.insert(rewards, {reward[1], toNumber(reward[2], 1)})
        end
    end

    local tokenCount = getDayCardTokenCount()
    if tokenCount > 0 then
        table.insert(rewards, {getTokenName(), tokenCount})
    end

    return rewards
end

local function getDayCardButtonState()
    local claimed = toNumber(npc.data and (npc.data.day_card_claimed or npc.data.rika_claimed), 0) == 1
    local canClaim = (not claimed) and getTodayRechargeValue() >= getDayCardNeedCharge()
    return canClaim, claimed
end

local function isDayCardUnlocked()
    return toNumber(npc.data and npc.data.day_card_unlocked, 0) == 1
end

local function isMilestoneClaimed(idx, isCrown)
    local T_data = (npc.data and npc.data.T_data) or {}
    local bucket = isCrown and (T_data.claim_crown or {}) or (T_data.claim_normal or {})
    return toNumber(bucket[tostring(idx)], 0) == 1
end

local function canClaimMilestone(cfg, isCrown)
    if not cfg then
        return false
    end
    if isMilestoneClaimed(cfg.idx, isCrown) then
        return false
    end
    if toNumber(npc.data and npc.data.draw_count, 0) < toNumber(cfg.draw, 0) then
        return false
    end
    if isCrown and not getHasCrown() then
        return false
    end
    return true
end

local function getHighestClaimableMilestone(isCrown)
    local target = nil
    for _, cfg in ipairs(getMilestones()) do
        if canClaimMilestone(cfg, isCrown) then
            target = cfg
        end
    end
    return target
end

local function buildRewardSummaryText(rewardPack)
    local entries = getRewardEntries(rewardPack)
    if #entries <= 0 then
        return "暂无奖励"
    end
    local summary = {}
    for idx = 1, math.min(#entries, 3) do
        local entry = entries[idx]
        table.insert(summary, string.format("%s×%s", tostring(entry.label or entry.name), tostring(entry.count or 1)))
    end
    return table.concat(summary, "\n")
end

local function pickDefaultMilestone()
    local milestones = getMilestones()
    if #milestones == 0 then
        npc.selectedMilestoneIdx = 1
        return
    end

    if findMilestoneByIdx(npc.selectedMilestoneIdx) then
        return
    end

    local highestNormal = getHighestClaimableMilestone(false)
    local highestCrown = getHighestClaimableMilestone(true)
    if highestNormal or highestCrown then
        npc.selectedMilestoneIdx = (highestCrown and highestCrown.idx) or (highestNormal and highestNormal.idx)
        return
    end

    for _, cfg in ipairs(milestones) do
        if not isMilestoneClaimed(cfg.idx, false) or not isMilestoneClaimed(cfg.idx, true) then
            npc.selectedMilestoneIdx = cfg.idx
            return
        end
    end

    npc.selectedMilestoneIdx = milestones[1].idx
end

local function setTextStyle(widget, outlineColor)
    if not widget then
        return
    end
    GUI:Text_setFontName(widget, "fonts/font4.ttf")
    GUI:Text_enableOutline(widget, outlineColor or "#100808", 2)
end

local function createTopStatBar(parent, name, x, y, width, title, valueText, valueColor)
    local bar = GUI:Layout_Create(parent, name, x, y, width, 30, false)
    GUI:setTouchEnabled(bar, false)

    local rich = GUI:RichText_Create(
        bar,
        "rich",
        9,
        15,
        string.format("<font color='#F3E8CE'>%s:</font><font color='%s'>%s</font>", tostring(title), valueColor or "#45ff93", tostring(valueText)),
        width - 18,
        16,
        "#F3E8CE",
        0,
        nil,
        nil,
        {outlineSize = 1, outlineColor = "#100808"}
    )
    GUI:setAnchorPoint(rich, 0, 0.5)
    -- GUI:RichText_setFontName(rich, "fonts/font4.ttf")
    return bar
end

local function createRewardCell(parent, name, x, y, rewardPack, stateText, stateColor, onClick)
    local node = GUI:Node_Create(parent, name, x, y)
    GUI:setContentSize(node, 50, 68)

    local bg = GUI:Image_Create(node, "bg", 0, 14, "res/custom/msfc/page1/item_box.png")
    GUI:setAnchorPoint(bg, 0, 0)
    addRewardItemEffect(bg, "reward_eff", 25, 26, 0.85)
    if onClick then
        GUI:setTouchEnabled(bg, true)
        GUI:addOnClickEvent(bg, onClick)
    end

    local entries = getRewardEntries(rewardPack)
    local reward = entries[1]
    if reward then
        if reward.index > 0 then
            local item = GUI:ItemShow_Create(bg, "item", 25, 26, {index = reward.index, look = true})
            GUI:setAnchorPoint(item, 0.5, 0.5)
            if "未冠名" == stateText then
            end
        else
            local rich = GUI:RichText_Create(bg, "label", 25, 27, reward.label or reward.name, 44, 11, "#f0c14b", 1, nil, nil)
            GUI:setAnchorPoint(rich, 0.5, 0.5)
        end

        if reward.count > 1 then
            local numText = GUI:Text_Create(bg, "num", 25, 1, 12, "#ffffff", tostring(reward.count))
            GUI:setAnchorPoint(numText, 0.5, 0)
            setTextStyle(numText, "#000000")
        end
    end

    if stateText and stateText ~= "" then
        local state = GUI:Text_Create(node, "state", 25, 0, 12, stateColor or "#ffe07a", stateText)
        GUI:setAnchorPoint(state, 0.5, 0)
        setTextStyle(state)
    end

    return node
end

local function closeBoxPopup()
    local popup = npc.boxPopup
    npc.boxPopup = nil
    if popup then
        pcall(function()
            GUI:removeFromParent(popup)
        end)
    end
end

local function closeBuyPopup()
    local popup = npc.buyPopup
    npc.buyPopup = nil
    npc.buyPopupInput = nil
    if popup then
        pcall(function()
            GUI:removeFromParent(popup)
        end)
    end
end

local function _get_buy_popup_count()
    if not npc.buyPopupInput then
        return 1
    end
    local count = tonumber(GUI:TextInput_getString(npc.buyPopupInput) or 0) or 0
    if count < 1 then
        count = 1
    end
    return math.floor(count)
end

local function openBuyPopup()
    closeBuyPopup()

    npc.buyPopup = GUI:Node_Create(npc.bg, "buy_popup", 0, 0)

    GUI:setLocalZOrder(npc.buyPopup, 100) -- 确保在其他界面元素之上

    local overlay = GUI:Image_Create(npc.buyPopup, "overlay", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(overlay, 0, 0)
    GUI:setContentSize(overlay, 818, 542)
    GUI:setIgnoreContentAdaptWithSize(overlay, false)
    GUI:setTouchEnabled(overlay, true)
    GUI:addOnClickEvent(overlay, function()
        closeBuyPopup()
    end)

    local panel = GUI:Image_Create(npc.buyPopup, "panel", 409, 271, "res/wy/public/500-300.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setContentSize(panel, 360, 220)
    GUI:setIgnoreContentAdaptWithSize(panel, false)
    GUI:setTouchEnabled(panel, true)

    local title = GUI:Text_Create(panel, "title", 180, 188, 22, "#ffe07a", "购买数量")
    GUI:setAnchorPoint(title, 0.5, 0.5)
    setTextStyle(title)

    local closeBtn = GUI:Button_Create(panel, "close", 332, 190, "res/wy/public/close_red_big.png")
    GUI:addOnClickEvent(closeBtn, function()
        closeBuyPopup()
    end)

    local tip = GUI:Text_Create(panel, "tip", 180, 146, 16, "#f3e8ce", string.format("每个消耗 %s灵石", tostring(getBuyCostText())))
    GUI:setAnchorPoint(tip, 0.5, 0.5)
    setTextStyle(tip)

    local inputBg = GUI:Image_Create(panel, "input_bg", 70, 96, "res/public/1900000668.png")
    GUI:setContentSize(inputBg, 220, 36)
    GUI:setIgnoreContentAdaptWithSize(inputBg, false)

    local input = GUI:TextInput_Create(inputBg, "input", 10, 4, 200, 28, 18)
    GUI:TextInput_setInputMode(input, 2)
    GUI:TextInput_setMaxLength(input, 6)
    GUI:TextInput_setString(input, "1")
    GUI:TextInput_setPlaceHolder(input, "请输入数量")
    GUI:TextInput_setFontColor(input, "#ffffff")
    npc.buyPopupInput = input

    local desc = GUI:Text_Create(panel, "desc", 180, 74, 16, "#8fd6ff", string.format("将购买【%s】", tostring(getTokenName())))
    GUI:setAnchorPoint(desc, 0.5, 0.5)
    setTextStyle(desc)

    local confirm = GUI:Button_Create(panel, "confirm", 200, 18, "res/custom/msfc/page1/action_2.png")
    GUI:addOnClickEvent(confirm, function()
        local count = _get_buy_popup_count()
        closeBuyPopup()
        SL:SendLuaNetMsg(100, 101, 4, count, SL:JsonEncode({count = count}, false))
    end)

    -- local cancel = GUI:Button_Create(panel, "cancel", 190, 18, "res/custom/msfc/page1/action_3.png")
    -- GUI:addOnClickEvent(cancel, function()
    --     closeBuyPopup()
    -- end)
end

local function openBoxPopup(boxType)
    closeBoxPopup()

    local boxPool = getBoxPool(boxType)
    if #boxPool <= 0 then
        SL:ShowSystemTips("当前没有可选奖励")
        return
    end

    npc.boxPopup = GUI:Node_Create(npc.bg, "box_popup", 0, 0)

    local overlay = GUI:Image_Create(npc.boxPopup, "overlay", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(overlay, 0, 0)
    GUI:setContentSize(overlay, 818, 542)
    GUI:setIgnoreContentAdaptWithSize(overlay, false)
    GUI:setTouchEnabled(overlay, true)
    GUI:addOnClickEvent(overlay, function()
        closeBoxPopup()
    end)

    local panel = GUI:Image_Create(npc.boxPopup, "panel", 409, 271, "res/wy/public/500-300.png")
    GUI:setAnchorPoint(panel, 0.5, 0.5)
    GUI:setContentSize(panel, 460, 290)
    GUI:setIgnoreContentAdaptWithSize(panel, false)
    GUI:setTouchEnabled(panel, true)

    local title = GUI:Text_Create(panel, "title", 230, 262, 22, "#ffe07a", BOX_NAME[boxType] or "材料自选箱")
    GUI:setAnchorPoint(title, 0.5, 0.5)
    setTextStyle(title)

    local closeBtn = GUI:Button_Create(panel, "close", 432, 260, "res/wy/public/close_red_big.png")
    GUI:addOnClickEvent(closeBtn, function()
        closeBoxPopup()
    end)

    local list = GUI:ListView_Create(panel, "list", 26, 24, 408, 210, 2)
    GUI:ListView_setItemsMargin(list, 12)
    GUI:ListView_setBounceEnabled(list, true)

    for idx, reward in ipairs(boxPool) do
        local itemNode = GUI:Node_Create(list, "item_" .. tostring(idx), 0, 0)
        GUI:setContentSize(itemNode, 124, 98)

        local btn = GUI:Button_Create(itemNode, "btn", 0, 0, "res/public/1900000660.png")
        GUI:setAnchorPoint(btn, 0, 0)
        GUI:setContentSize(btn, 124, 98)
        GUI:setIgnoreContentAdaptWithSize(btn, false)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, 101, 7, BOX_P2[boxType] or 0, SL:JsonEncode({
                box_type = boxType,
                idx = idx,
            }, false))
            closeBoxPopup()
        end)

        local rewardEntries = getRewardEntries({main = reward})
        local entry = rewardEntries[1]
        addRewardItemEffect(btn, "reward_eff", 62, 60, 0.95)
        if entry and entry.index > 0 then
            local item = GUI:ItemShow_Create(btn, "item", 62, 60, {index = entry.index, look = true})
            GUI:setAnchorPoint(item, 0.5, 0.5)
        end

        local label = GUI:RichText_Create(btn, "label", 62, 18, reward.label or (entry and entry.label) or "选择", 110, 13, "#f7f7de", 1, nil, nil)
        GUI:setAnchorPoint(label, 0.5, 0.5)
    end
end

local function createTabs(node)
    local tabY = {
        [1] = 247 + 50,
        [2] = 123 + 50,
    }

    for idx = 1, 2 do
        if idx == 2 and not isDayCardUnlocked() then
            break
        end
        local skin = (npc.currentTab == idx) and TAB_SKINS[idx].light or TAB_SKINS[idx].dark
        local btn = GUI:Button_Create(node, "tab_" .. tostring(idx), 6, tabY[idx], skin)
        GUI:setAnchorPoint(btn, 0, 0)
        GUI:addOnClickEvent(btn, function()
            if npc.currentTab ~= idx then
                npc.currentTab = idx
                closeBoxPopup()
                if npc.node and UI_updata then
                    UI_updata(npc.node)
                end
            end
        end)
    end
end

local function createMilestoneList(parent)
    local list = GUI:ListView_Create(parent, "milestone_list", 524, 65, 270, 346, 1)
    GUI:ListView_setItemsMargin(list, 8)
    GUI:ListView_setBounceEnabled(list, true)
    -- 
    for order, cfg in ipairs(getMilestones()) do
        local row = GUI:Node_Create(list, "row_" .. tostring(cfg.idx), 0, 0)
        GUI:setContentSize(row, 244, 70)

        GUI:setContentSize(GUI:Image_Create(row, "draw1", 0, -8, "res/wy/public/pick.png"), 90, 70 + 8)
        GUI:setContentSize(GUI:Image_Create(row, "draw2", 90, -8, "res/wy/public/pick.png"), 90, 70 + 8)
        GUI:setContentSize(GUI:Image_Create(row, "draw3", 90 + 90, -8, "res/wy/public/pick.png"), 90, 70 + 8)

        local drawSkin = getMilestoneImage(cfg.draw)
        if drawSkin then
            local numImg = GUI:Image_Create(row, "draw", -20, -8, drawSkin)
            GUI:setAnchorPoint(numImg, 0, 0)
            GUI:setTouchEnabled(numImg, true)
            GUI:addOnClickEvent(numImg, function()
                npc.selectedMilestoneIdx = cfg.idx
                if npc.node and UI_updata then
                    UI_updata(npc.node)
                end
            end)
        else
            local drawText = GUI:Text_Create(row, "draw_text", 10, 18, 28, "#ffe07a", tostring(cfg.draw))
            setTextStyle(drawText)
        end

        local normalStateText = nil
        local normalStateColor = nil
        if isMilestoneClaimed(cfg.idx, false) then
            normalStateText = "已领"
            normalStateColor = "#45ff93"
        elseif canClaimMilestone(cfg, false) then
            normalStateText = "可领"
            normalStateColor = "#ffe07a"
        end

        local crownStateText = nil
        local crownStateColor = nil
        if isMilestoneClaimed(cfg.idx, true) then
            crownStateText = "已领"
            crownStateColor = "#45ff93"
        elseif canClaimMilestone(cfg, true) then
            crownStateText = "可领"
            crownStateColor = "#ffe07a"
        elseif not getHasCrown() then
            crownStateText = "未冠名"
            crownStateColor = "#808080"
        end

        createRewardCell(row, "normal_" .. tostring(cfg.idx), 118 + 15, 25, cfg.normal, normalStateText, normalStateColor, function()
            npc.selectedMilestoneIdx = cfg.idx
            if npc.node and UI_updata then
                UI_updata(npc.node)
            end
        end)

        createRewardCell(row, "crown_" .. tostring(cfg.idx), 188 + 37, 25, cfg.crown, crownStateText, crownStateColor, function()
            npc.selectedMilestoneIdx = cfg.idx
            if npc.node and UI_updata then
                UI_updata(npc.node)
            end
        end)
    end
    GUI:Node_Create(list, "row_end", 0, 0)
end

function npc.renderFucai(node)
    GUI:Image_Create(node, "page_bg", 64, 10, PAGE_BG_SKIN[1])

    pickDefaultMilestone()
    createTopStatBar(    node,    "exchange_top_bar",    162 + 74, 458 + 5,    200,    "每日杀怪兑换",    string.format("%s/%s次", tostring(getExchangeUsedCount()), tostring(getExchangeLimit())),    "#45ff93")
    createTopStatBar(    node,    "kill_top_bar",    162 + 264, 458 + 5,    160,    "每日杀怪数",    string.format("%s只", tostring(getDailyKillCount())),    "#45ff93")
    createTopStatBar(    node,    "draw_top_bar",    162 + 430, 458 + 5,    160,    "已抽取次数",    string.format("%s次", tostring(toNumber(npc.data and npc.data.draw_count, 0))),    "#45ff93")

    -- local onceCost = GUI:Text_Create(node, "cost_once_value", 188, 135, 20, "#ffe07a", string.format("%sX%s", tokenName, tostring(getDrawOnceCost())))
    -- setTextStyle(onceCost)
    -- GUI:Text_enableUnderline(onceCost)
    -- local tenCost = GUI:Text_Create(node, "cost_ten_value", 382, 135, 20, "#ffe07a", string.format("%sX%s", tokenName, tostring(getDrawTenCost())))
    -- setTextStyle(tenCost)
    -- GUI:Text_enableUnderline(tenCost)
    local guang = GUI:Image_Create(node, "cost_once_value_img", 144 - 60, 82 - 25 + 78, "res/wy/public/guang.png")
    GUI:setContentSize(guang, 180, 30)

    local tip = GUI:Image_Create(node, "tip", 380 + 60, 350 + 30, "res/custom/msfc/page1/wenhao.png")
    local poolTipText = buildPoolTipText()
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
            local pos = GUI:getWorldPosition(tip)
            SL:OpenCommonDescTipsPop({str = poolTipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end, onLeaveFunc = function()
            SL:CloseCommonDescTipsPop()
        end})
    else
        GUI:setTouchEnabled(tip, true)
        GUI:addOnTouchEvent(tip, function(self)
            local pos = GUI:getWorldPosition(tip)
            SL:OpenCommonDescTipsPop({str = poolTipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end)
    end
    -- 
    GUI:Effect_Create(node, "sz", 176, 60 + 110 + 117, 0, 14191)
    GUI:RichText_Create(node, "jl1", 98 - 10,314 + 3,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc._config.pool[1].give[1][1]).."'>["..npc._config.pool[1].label.."]</a>", 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jl2", 400 + 20,314,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc._config.pool[2].give[1][1]).."'>["..npc._config.pool[2].label.."]</a>", 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jl3", 98 - 20,200,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc._config.pool[3].give[1][1]).."'>["..npc._config.pool[3].label.."]</a>", 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jl4", 350 - 20,200,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc._config.pool[4].give[1][1]).."'>["..npc._config.pool[4].label.."]</a>", 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

    GUI:RichText_Create(node, "jlsz1", 98,250,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：拉大车[展示]").."'>[".."时装：拉大车".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jlsz2", 210 + 30,250,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：圣诞老人[展示]").."'>[".."时装：圣诞老人".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jlsz3", 400,250,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：暗黑天使[展示]").."'>[".."时装：暗黑天使".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jlsz4", 98 - 30,280,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：熊猫人[展示]").."'>[".."时装：熊猫人".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jlsz5", 210,200,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：开挖掘机[展示]").."'>[".."时装：开挖掘机".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
    GUI:RichText_Create(node, "jlsz6", 400,280,  "<a href='jump#item_tips#"..SL:GetMetaValue("ITEM_INDEX_BY_NAME", "时装：天刀[展示]").."'>[".."时装：天刀".."]</a>", 500, 14, "#FF0000", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

    GUI:setScale(GUI:ItemShow_Create(guang, "icon", 105, 5, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","鹤嘴锄")}), 0.6)
    local currentTokenCount = toNumber(npc.data and npc.data.token_count, 0)
    local drawOnceCost = getDrawOnceCost()
    local currentTokenColor = currentTokenCount >= drawOnceCost and "#45ff93" or "#ff6666"
    GUI:RichText_Create(guang, "text", 130, 5, string.format("<font color='%s'>%s</font><font color='#FFFFFF'>/%s</font>", currentTokenColor, tostring(currentTokenCount), tostring(drawOnceCost)), 150, 16, "#FFFFFF", 0, nil, nil)

    local guang = GUI:Image_Create(node, "cost_ten_value_img", 144 - 60 + 190, 82 - 25 + 78, "res/wy/public/guang.png")
    GUI:setContentSize(guang, 180, 30)
    
    GUI:setScale(GUI:ItemShow_Create(guang, "icon", 105, 5, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","鹤嘴锄")}), 0.6)
    local currentTokenCount = toNumber(npc.data and npc.data.token_count, 0)
    local drawTenCost = getDrawTenCost()
    local currentTokenColor = currentTokenCount >= drawTenCost and "#45ff93" or "#ff6666"
    GUI:RichText_Create(guang, "text", 130, 5, string.format("<font color='%s'>%s</font><font color='#FFFFFF'>/%s</font>", currentTokenColor, tostring(currentTokenCount), tostring(drawTenCost)), 150, 16, "#FFFFFF", 0, nil, nil)

    local drawOnceBtn = GUI:Button_Create(node, "draw_once", 144 - 60 - 16, 82 - 25, "res/custom/msfc/page1/draw_once.png")
    GUI:setAnchorPoint(drawOnceBtn, 0, 0)
    GUI:addOnClickEvent(drawOnceBtn, function()
        SL:SendLuaNetMsg(100, 101, 1, 0, "")
    end)

    local drawTenBtn = GUI:Button_Create(node, "draw_ten", 378 - 60 - 55, 82 - 25, "res/custom/msfc/page1/draw_ten.png")
    GUI:setAnchorPoint(drawTenBtn, 0, 0)
    GUI:addOnClickEvent(drawTenBtn, function()
        SL:SendLuaNetMsg(100, 101, 2, 0, "")
    end)

    if toNumber(npc.data and npc.data.token_count, 0) >= getDrawOnceCost() then
        NPC_UI_HELPER.redpoint_create(drawOnceBtn)
    end
    if toNumber(npc.data and npc.data.token_count, 0) >= getDrawTenCost() then
        NPC_UI_HELPER.redpoint_create(drawTenBtn)
    end

    -- local exchangeRich = GUI:RichText_Create(node, "exchange_tips", 74, 30, string.format("每击杀<font color='#ff3030'>%s</font>只怪可兑换1个", tostring(getExchangeNeed())), 250, 18, "#f3e8ce", 0, nil, nil)
    -- GUI:setAnchorPoint(exchangeRich, 0, 0.5)

    -- local exchangeProgress = GUI:Text_Create(node, "exchange_progress", 74, 12, 16, "#8fd6ff",
    --     string.format("当前进度：%s/%s  今日剩余可兑：%s/%s",
    --         tostring(toNumber(npc.data and npc.data.exchange_progress, 0)),
    --         tostring(getExchangeNeed()),
    --         tostring(toNumber(npc.data and npc.data.exchange_available, 0)),
    --         tostring(getExchangeLimit())
    --     )
    -- )
    -- setTextStyle(exchangeProgress)

    local exchangeBtn = GUI:Button_Create(node, "exchange", 322 - 90, 17, "res/custom/msfc/page1/action_1.png")
    GUI:setAnchorPoint(exchangeBtn, 0, 0)
    GUI:addOnClickEvent(exchangeBtn, function()
        SL:SendLuaNetMsg(100, 101, 3, 0, "")
    end)
    if toNumber(npc.data and npc.data.exchange_available, 0) > 0 then
        NPC_UI_HELPER.redpoint_create(exchangeBtn, {x = 156, y = 23})
    end

    -- local buyRich = GUI:RichText_Create(node, "buy_tips", 426, 30, string.format("<font color='#ff3030'>%s</font>灵石可购买1个", getBuyCostText()), 180, 18, "#f3e8ce", 0, nil, nil)
    -- GUI:setAnchorPoint(buyRich, 0, 0.5)

    local buyBtn = GUI:Button_Create(node, "buy", 608 - 180, 17, "res/custom/msfc/page1/action_2.png")
    GUI:setAnchorPoint(buyBtn, 0, 0)
    GUI:addOnClickEvent(buyBtn, function()
        openBuyPopup()
    end)

    createMilestoneList(node)

    local selected = findMilestoneByIdx(npc.selectedMilestoneIdx) or getMilestones()[1]
    local normalTarget = getHighestClaimableMilestone(false) or selected
    local crownTarget = getHighestClaimableMilestone(true) or selected
    if selected then
        -- GUI:Text_Create(node, "preview_title_normal", 618, 422, 16, "#FFE07A", "当前所选普通奖励")
        -- setTextStyle(GUI:ui_delegate(node).preview_title_normal)
        -- GUI:Text_Create(node, "preview_title_crown", 710, 422, 16, "#FFE07A", "冠名奖励")
        -- setTextStyle(GUI:ui_delegate(node).preview_title_crown)

        -- local normalSummary = GUI:RichText_Create(node, "preview_normal", 612, 404, buildRewardSummaryText(selected.normal), 84, 42, "#f7f7de", 1, nil, nil, {outlineSize = 1, outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- GUI:setAnchorPoint(normalSummary, 0, 1)
        -- local crownSummary = GUI:RichText_Create(node, "preview_crown", 704, 404, buildRewardSummaryText(selected.crown), 84, 42, "#f7f7de", 1, nil, nil, {outlineSize = 1, outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- GUI:setAnchorPoint(crownSummary, 0, 1)
    end

    local normalBtn = GUI:Button_Create(node, "claim_normal", 610, 18, "res/custom/msfc/page1/action_3.png")
    GUI:setAnchorPoint(normalBtn, 0, 0)
    GUI:addOnClickEvent(normalBtn, function()
        if not normalTarget then
            return
        end
        SL:SendLuaNetMsg(100, 101, 5, normalTarget.idx, SL:JsonEncode({idx = normalTarget.idx, draw = normalTarget.draw}, false))
    end)

    local crownBtn = GUI:Button_Create(node, "claim_crown", 706, 18, "res/custom/msfc/page1/action_3.png")
    GUI:setAnchorPoint(crownBtn, 0, 0)
    GUI:addOnClickEvent(crownBtn, function()
        if not crownTarget then
            return
        end
        SL:SendLuaNetMsg(100, 101, 6, crownTarget.idx, SL:JsonEncode({idx = crownTarget.idx, draw = crownTarget.draw}, false))
    end)

    if normalTarget and canClaimMilestone(normalTarget, false) then
        NPC_UI_HELPER.redpoint_create(normalBtn, {x = 156, y = 23})
    end
    if crownTarget and canClaimMilestone(crownTarget, true) then
        NPC_UI_HELPER.redpoint_create(crownBtn, {x = 156, y = 23})
    end
end

function npc.renderRika(node)
    GUI:Image_Create(node, "page_bg", 64, 10, PAGE_BG_SKIN[2])
    local titleCharge = GUI:Image_Create(node, "title_charge", 410, 458, "res/custom/msfc/page2/today_recharge.png")
    GUI:setAnchorPoint(titleCharge, 0.5, 0)

    local rechargeValue = GUI:Text_Create(node, "recharge_value", 430, 465, 25, "#ff9696", tostring(getTodayRechargeValue()) .. "元")
    GUI:setAnchorPoint(rechargeValue, 0, 0)
    setTextStyle(rechargeValue)

    -- local rich1 = GUI:RichText_Create(node, "rika_desc_1", 454, 340, string.format("每日仅需累充<font color='#ff3030'>%s元</font>！", tostring(getDayCardNeedCharge())), 260, 28, "#fff0c8", 0, nil, nil)
    -- local rich2 = GUI:RichText_Create(node, "rika_desc_2", 438, 266, "日卡BUFF：<font color='#ff3030'>进入安全修炼地图</font>！", 300, 24, "#fff0c8", 0, nil, nil)
    -- local rich3 = GUI:RichText_Create(node, "rika_desc_3", 438, 224, "日卡BUFF：<font color='#ff3030'>打怪爆率+10%</font>！", 300, 24, "#fff0c8", 0, nil, nil)
    -- GUI:setAnchorPoint(rich1, 0, 0.5)
    -- GUI:setAnchorPoint(rich2, 0, 0.5)
    -- GUI:setAnchorPoint(rich3, 0, 0.5)

    local rewards = getDayCardRewards()
    local startX = 496
    for idx = 1, 4 do
        local box = GUI:Image_Create(node, "rika_box_" .. tostring(idx), startX + (idx - 1) * 70, 108, "res/custom/msfc/page2/item_box.png")
        GUI:setAnchorPoint(box, 0, 0)
        addRewardItemEffect(box, "reward_eff", 25, 26, 0.85)

        local reward = rewards[idx]
        local rewardName = reward and reward[1] or nil
        local rewardCount = reward and reward[2] or 1
        local rewardIndex = toNumber(rewardName and SL:GetMetaValue("ITEM_INDEX_BY_NAME", rewardName) or 0, 0)
        if rewardIndex > 0 then
            local item = GUI:ItemShow_Create(box, "item", 25, 26, {index = rewardIndex, look = true})
            GUI:setAnchorPoint(item, 0.5, 0.5)
            if toNumber(rewardCount, 1) > 1 then
                local countText = GUI:Text_Create(box, "num", 25, 1, 12, "#ffffff", tostring(rewardCount))
                GUI:setAnchorPoint(countText, 0.5, 0)
                setTextStyle(countText, "#000000")
            end
        elseif rewardName then
            local label = GUI:RichText_Create(box, "label", 25, 27, tostring(rewardName), 44, 11, "#f0c14b", 1, nil, nil)
            GUI:setAnchorPoint(label, 0.5, 0.5)
        end
        if idx > 1 then
            GUI:Image_Create(box, "tip_give" , 20, 20, "res/wy/public/tip_give.png")
        end

    end

    local canClaim, claimed = getDayCardButtonState()
    local button = GUI:Button_Create(node, "rika_claim", 516, 10, "res/custom/msfc/page2/claim_now.png")
    GUI:setAnchorPoint(button, 0, 0)
    GUI:addOnClickEvent(button, function()
        if claimed then
            SL:ShowSystemTips("今日奖励已领取")
            return
        end
        if canClaim then
            SL:SendLuaNetMsg(100, 101, 8, 0, "")
            return
        end
        SL:ShowSystemTips(string.format("今日累计充值达到%s元后可领取", tostring(getDayCardNeedCharge())))
    end)
    if not claimed and canClaim then
        NPC_UI_HELPER.redpoint_create(button)
    end
end

local function ensureWindow(npcid)
    local opts = {}
    for key, value in pairs(WINDOW_OPTS) do
        opts[key] = value
    end
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

UI_updata = function(node)
    if not node then
        return
    end

    if npc.currentTab == 2 and not isDayCardUnlocked() then
        npc.currentTab = 1
    end

    closeBoxPopup()
    closeBuyPopup()
    GUI:removeAllChildren(node)
    createTabs(node)

    if npc.currentTab == 1 then
        npc.renderFucai(node)
    else
        npc.renderRika(node)
    end
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        npc.currentTab = 1
        npc.selectedMilestoneIdx = nil
        npc.data = ensureData(safeDecode(msgData))
        ensureWindow(npcid)
        UI_updata(npc.node)
        return
    end

    local data = safeDecode(msgData)
    if data then
        npc.data = ensureData(data)
    else
        npc.data = ensureData(npc.data)
    end

    if not npc.node then
        ensureWindow(npcid)
    end
    UI_updata(npc.node)
end

return npc
