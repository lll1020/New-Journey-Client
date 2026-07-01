local npc = {}

npc._config = teshudata["npc_16"] or {}
local REWARD_ITEM_EFFECT_ID = 14193

local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/sbk/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/sbk/title.png"},
}

local ENTER_POS = {
    {461, 108},
    {329, 94},
    {416, 181},
    {238, 214},
}

local function _to_number(value, defaultValue)
    local num = tonumber(value)
    if num == nil then
        return defaultValue or 0
    end
    return num
end

local function _to_string(value, defaultValue)
    if value == nil then
        return defaultValue or ""
    end
    return tostring(value)
end

local function _format_num(value)
    return SL:GetSimpleNumber(_to_number(value, 0), 0)
end

local function _create_text(parent, name, x, y, size, color, text, anchorX, anchorY, fontName, outlineColor, outlineSize)
    local widget = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:setAnchorPoint(widget, anchorX or 0, anchorY or 0)
    GUI:Text_setFontName(widget, fontName or "fonts/font4.ttf")
    if outlineColor then
        GUI:Text_enableOutline(widget, outlineColor, outlineSize or 1)
    end
    return widget
end

local function _add_reward_item_effect(parent, name, x, y, scale)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local effect = GUI:Effect_Create(parent, name or "reward_item_eff", x or 0, y or 0, 0, REWARD_ITEM_EFFECT_ID, 0, 0, 0, 1)
    GUI:setScale(effect, scale or 1)
    GUI:setLocalZOrder(effect, 5)
    return effect
end

local function _resolve_title_item()
    local candidates = {
        "沙巴克城主[称号]",
        "沙巴克[称号]",
        "沙城之主[称号]",
        "中州城主[称号]",
    }
    for _, itemName in ipairs(candidates) do
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if itemIndex and itemIndex ~= 0 then
            return itemName
        end
    end
    return nil
end

local function _get_reward_value(totalReward, totalPoints, myPoints)
    totalReward = _to_number(totalReward, 0)
    totalPoints = _to_number(totalPoints, 0)
    myPoints = _to_number(myPoints, 0)
    if totalReward <= 0 or totalPoints <= 0 or myPoints <= 0 then
        return 0
    end
    return math.floor((totalReward * myPoints / totalPoints) + 0.5)
end

local function _get_reward_prefix()
    local prefix = _to_string((npc.data or {}).money, "")
    if prefix ~= "" then
        return prefix
    end
    return "绑定灵符"
end

local function _get_reward_item_name()
    local prefix = _get_reward_prefix()
    prefix = tostring(prefix or "")
    prefix = prefix:gsub("#.*$", "")
    return prefix
end

local function _get_camp_name()
    local camp = _to_number((npc.data or {}).castleidentity, 0)
    if camp == 0 then
        return "失败方"
    end
    return "胜利方"
end

local function _get_claim_state_text()
    local data = npc.data or {}
    local claimed = _to_number(data.claimed, 0)
    local myPoints = _to_number(data.myPoints, 0)
    local minimum = _to_number(data.minimum, 0)
    if _to_number(data.need_first_charge, 0) == 1 and _to_number(data.has_first_charge, 0) ~= 1 then
        return "需先领取首充礼包", "#FF7B7B"
    end
    if claimed >= 1 then
        return "今日奖励已领取", "#72FF99"
    end
    if myPoints < minimum then
        return string.format("积分不足，需达到%s", _format_num(minimum)), "#FF7B7B"
    end
    return "奖励可领取", "#FFE38D"
end

local function _create_reward_desc(parent, name, x, y, title, rewardItems, color)
    local group = GUI:Node_Create(parent, name, x, y)
    GUI:setAnchorPoint(group, 0, 1)
    _create_text(group, "title", 0, 0, 22, color or "#FFFFFF", title, 0, 1, "fonts/font4.ttf", "#000000", 2)
    if type(rewardItems) == "table" and #rewardItems > 0 then
        local rewardNode = ItemNumByTable_img_new(rewardItems, nil, GUI:Node_Create(group, "reward_items", 0, -48))
        GUI:setScale(rewardNode, 0.9)
        local effectHost = GUI:getChildByName(rewardNode, "cllist") or rewardNode
        local children = GUI:getChildren(effectHost) or {}
        for idx, child in ipairs(children) do
            if child and not tolua.isnull(child) then
                _add_reward_item_effect(child, "reward_eff_" .. idx, 29, 30, 0.85)
            end
        end
    end
    return group
end

local function _is_fixed_reward_mode()
    local data = npc.data or {}
    return _to_string(data.reward_mode, "") == "fixed" and type(data.fixed_rewards) == "table"
end

local function _get_fixed_reward_list(key)
    local fixed = (npc.data or {}).fixed_rewards or {}
    return type(fixed[key]) == "table" and fixed[key] or {}
end

local function _render_enter_page(parent, npcid)
    GUI:Image_Create(parent, "bg", 0, 0, "res/custom/one_city/sbk/bg_1.png")
    local enterCount = #(((npc.data or {}).enter_maps) or (npc._config or {}).map or {})
    if enterCount <= 0 then
        enterCount = #(ENTER_POS or {})
    end
    for idx, entry in ipairs(ENTER_POS) do
        if idx > enterCount then
            break
        end
        local btn = GUI:Button_Create(parent, "enter_btn_" .. idx, entry[1], entry[2], "res/custom/one_city/sbk/btn/l/btn_" .. idx .. ".png")
        GUI:setAnchorPoint(btn, 0.5, 0)
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(100, npcid, 1, idx, "")
        end)
    end
end

local function _render_reward_page(parent, npcid)
    local data = npc.data or {}
    GUI:Image_Create(parent, "bg", 0, 0, "res/custom/one_city/sbk/bg_2.png")

    local myPoints = _to_number(data.myPoints, 0)
    local minimum = _to_number(data.minimum, 0)
    local winnerPoints = _to_number(data.winnerPoints, 0)
    local loserPoints = _to_number(data.loserPoints, 0)
    local winReward = _to_number(data.winReward, 0)
    local loserReward = _to_number(data.loserReward, 0)
    local rewardItemName = _get_reward_item_name()
    local winnerRewardItems = _is_fixed_reward_mode() and _get_fixed_reward_list("winner") or {{rewardItemName, _get_reward_value(winReward, winnerPoints, myPoints)}}
    local loserRewardItems = _is_fixed_reward_mode() and _get_fixed_reward_list("loser") or {{rewardItemName, _get_reward_value(loserReward, loserPoints, myPoints)}}
    local chairmanRewardItems = _is_fixed_reward_mode() and _get_fixed_reward_list("chairman") or nil

    _create_reward_desc(parent, "winner_reward", 20, 462 - 70, "", winnerRewardItems, "#FFFFFF")
    _create_reward_desc(parent, "loser_reward", 20, 304 - 22, "", loserRewardItems, "#F4B7B7")
    _create_reward_desc(parent, "chairman_reward", 20, 146 + 18, "", chairmanRewardItems, "#7DF19D")

    local titleItemName = _resolve_title_item()
    -- if titleItemName then
    --     local titleNode = ItemNumByTable_img_new({{titleItemName, 1}}, nil, GUI:Node_Create(parent, "title_preview", 470, 214))
    --     GUI:setScale(titleNode, 1.05)
    -- else
    --     local titleBox = GUI:Image_Create(parent, "title_preview_empty", 498, 243, "res/wy/public/70_70_k.png")
    --     GUI:setAnchorPoint(titleBox, 0.5, 0.5)
    --     _create_text(parent, "title_preview_label", 498, 243, 16, "#D7D7D7", "称号占位", 0.5, 0.5, "fonts/font4.ttf", "#000000", 1)
    -- end

    local winnerGuildName = _to_string(data.winnerGuildName, "")
    local guildText = winnerGuildName ~= "" and winnerGuildName or "当前暂无胜利行会"
    _create_text(parent, "guild_name", 498 - 53, 192, 18, "#F2F2F2", guildText, 0.5, 0.5, "fonts/font4.ttf", "#000000", 1)

    local progressText = string.format("我的积分：%s/%s", _format_num(myPoints), _format_num(minimum))
    -- _create_text(parent, "my_points", 20, 380, 18, "#F7F3E8", progressText, 0, 1, "fonts/font4.ttf", "#000000", 1)

    local campText = string.format("当前阵营：%s", _get_camp_name())
    -- _create_text(parent, "camp_text", 20, 352, 18, "#F7F3E8", campText, 0, 1, "fonts/font4.ttf", "#000000", 1)

    local winnerPointsText = string.format("胜利方达标积分：%s", _format_num(winnerPoints))
    -- _create_text(parent, "winner_points", 20, 324, 18, "#F7F3E8", winnerPointsText, 0, 1, "fonts/font4.ttf", "#000000", 1)

    local loserPointsText = string.format("失败方达标积分：%s", _format_num(loserPoints))
    -- _create_text(parent, "loser_points", 20, 296, 18, "#F7F3E8", loserPointsText, 0, 1, "fonts/font4.ttf", "#000000", 1)

    local stateText, stateColor = _get_claim_state_text()
    -- _create_text(parent, "claim_state", 20, 94, 18, stateColor, stateText, 0, 1, "fonts/font4.ttf", "#000000", 1)

    local claimBtn = GUI:Button_Create(parent, "claim_btn", 458, 78, "res/wy/public/npc_19_tip_jl.png")
    GUI:setAnchorPoint(claimBtn, 0.5, 0.5)
    -- _create_text(claimBtn, "claim_btn_text", 101, 24, 22, "#FFF7E8", "领取奖励", 0.5, 0.5, "fonts/font4.ttf", "#6F3A00", 1)

    local canClaim = _to_number(data.claimed, 0) < 1
        and myPoints >= minimum
        and (_to_number(data.need_first_charge, 0) ~= 1 or _to_number(data.has_first_charge, 0) == 1)
    -- GUI:Button_setBright(claimBtn, canClaim)
    GUI:addOnClickEvent(claimBtn, function()
        if not canClaim then
            if _to_number(data.need_first_charge, 0) == 1 and _to_number(data.has_first_charge, 0) ~= 1 then
                SL:ShowSystemTips("需先领取首充礼包后才能领取攻沙奖励")
            elseif _to_number(data.claimed, 0) >= 1 then
                SL:ShowSystemTips("今日沙巴克奖励已领取")
            else
                SL:ShowSystemTips(string.format("攻沙积分需达到%s后才能领取", _format_num(minimum)))
            end
            return
        end
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    if canClaim then
        NPC_UI_HELPER.redpoint_create(claimBtn, {x = 180, y = 48})
    end
end

local function _render_page(parent, pageIdx, npcid)
    GUI:removeAllChildren(parent)
    if pageIdx == 1 then
        _render_enter_page(parent, npcid)
    else
        _render_reward_page(parent, npcid)
    end
end

function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(currentNpcId)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(currentNpcId, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, currentNpcId, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = npc.titles_sign or 1
        for idx = 1, 2 do
            local isSelected = npc.titles_sign == idx
            local item = GUI:Button_Create(npc.cbl_list, "item" .. idx, 0, 0, "res/custom/one_city/sbk/list/" .. (isSelected and "l" or "n") .. "/" .. idx .. ".png")
            GUI:Image_Create(npc.cbl_list, "fgx" .. idx, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(item, function()
                local oldBtn = GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign]
                if oldBtn then
                    GUI:Button_loadTextureNormal(oldBtn, "res/custom/one_city/sbk/list/n/" .. npc.titles_sign .. ".png")
                end
                npc.titles_sign = idx
                _render_page(npc.Label, idx, npcid)
                local curBtn = GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign]
                if curBtn then
                    GUI:Button_loadTextureNormal(curBtn, "res/custom/one_city/sbk/list/l/" .. npc.titles_sign .. ".png")
                end
            end)
        end

        _render_page(npc.Label, npc.titles_sign, npcid)
    end

    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc
