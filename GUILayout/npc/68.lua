local npc = {}

npc._config = teshudata["npc_68"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/lgsl/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/four_city/lgsl/title.png"},
}

local state_info = {
    [0] = {color = "#8FB6C8", text = "挑战中"},
    [1] = {color = "#FF5B5B", text = "未完成"},
    [2] = {color = "#54FF9F", text = "已激活"},
}

local function ensureTable(data, key)
    data[key] = data[key] or {}
    return data[key]
end

local function getTrialState(data, idx)
    local tData = data and data.T_data or {}
    local levels = tData.level or {}
    if levels[tostring(idx + 5)] ~= nil then
        return 3
    end

    local dljq = data and data.T_dljq or {}
    local npc68 = dljq["npc_68"] or {}
    local value = npc68[tostring(idx)]
    if value == 1 then
        return 2
    end
    if value == 0 then
        return 0
    end
    return 1
end

local function resolveNeedItemData(itemName)
    if not itemName or itemName == "" then
        return nil, nil
    end

    local exactIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if exactIndex and exactIndex > 0 then
        return exactIndex, SL:GetMetaValue("ITEM_DATA", exactIndex)
    end

    local titleIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName .. "[称号]")
    if titleIndex and titleIndex > 0 then
        return titleIndex, SL:GetMetaValue("ITEM_DATA", titleIndex)
    end

    return nil, nil
end

local function hasNeedTitle(itemName)
    if not itemName or itemName == "" then
        return true
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if idx and idx > 0 and SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil then
        return true
    end
    local titleIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName .. "[称号]")
    if titleIdx and titleIdx > 0 and SL:GetMetaValue("TITLE_DATA_BY_ID", titleIdx) ~= nil then
        return true
    end
    return false
end

function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(curNpcId)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(curNpcId, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, curNpcId, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function createText(parent, name, x, y, size, color, text, anchorX, anchorY)
        local label = GUI:Text_Create(parent, name, x, y, size, color, text)
        GUI:setAnchorPoint(label, anchorX or 0, anchorY or 0.5)
        GUI:Text_setFontName(label, "fonts/500.ttf")
        GUI:Text_enableOutline(label, "#000000", 2)
        return label
    end

    local function createRich(parent, name, x, y, width, size, text)
        local rich = GUI:RichText_Create(parent, name, x, y, text, width, size, "#D7D7D7", 0, nil, nil, {
            outlineSize = 2,
            outlineColor = SL:ConvertColorFromHexString("#000000"),
        })
        GUI:setAnchorPoint(rich, 0, 1)
        return rich
    end

    local function createLabel(labelNode, idx)
        GUI:removeAllChildren(labelNode)
        local config = npc._config.details[idx]
        if not config then
            return
        end

        local state = getTrialState(npc.data, idx)
        local stateCfg = state_info[state] or state_info[1]
        local model = GUI:Effect_Create(labelNode, "monster_model", 150, 230, 2, config.mob_shape or 0, 0, 0, 5)
        GUI:setScale(model, config.scale or 1)

        createText(labelNode, "mob_name", 150, 350, 24, "#EDE4C6", config.mob_name or "未知守护兽", 0.5, 0.5)
        createText(labelNode, "state_title", 382, 300, 22, "#EDE4C6", "当前状态：", 0, 0.5)
        createText(labelNode, "state_value", 490, 300, 22, stateCfg.color, stateCfg.text, 0, 0.5)
        createText(labelNode, "time_title", 382, 260, 20, "#EDE4C6", "试炼时限：", 0, 0.5)
        createText(labelNode, "time_value", 490, 260, 20, "#B2F022", tostring(config.time or 300) .. "秒", 0, 0.5)
        createRich(labelNode, "content_rich", 382 - 32, 230 + 15, 250, 16,
            "1. 进入专属试炼副本，\n     限时击败守护兽\n"
            .. "2. 通关后返回此处，\n     即可激活对应灵根\n"
            .. "3. 每种灵根试炼仅需完成一次")

        createText(labelNode, "enter_req", 175, 118 + 23, 25, "#F03022", tostring(config.yq or "无"), 0, 0.5)
        createText(labelNode, "reward_text", 175, 80 + 22, 25, "#BEFF26", tostring(config.jl or "激活对应灵根"), 0, 0.5)

        local needItemBg = GUI:Image_Create(labelNode, "need_item_bg", 600 - 60, 36, "res/wy/public/58-60.png")
        GUI:setAnchorPoint(needItemBg, 0.5, 0.5)

        local needIndex, needItemData = resolveNeedItemData(config.itme)
        if needItemData then
            UiTools.showItemData(needItemBg, needItemData)
        else
            createText(labelNode, "need_item_none", 600 - 60, 36, 20, "#F6E7C2", "无", 0.5, 0.5)
        end

        if state == 2 then
            local ok = GUI:Image_Create(labelNode, "ok", 155 + 37, -8 + 46 + 60, "res/custom/four_city/lgsl/ok.png")
            GUI:setAnchorPoint(ok, 0.5, 0.5)
        elseif state == 2 then
            -- local activeBtn = GUI:Button_Create(labelNode, "active_btn", 150, -8, "res/public/1900000660.png")
            -- GUI:setAnchorPoint(activeBtn, 0.5, 0.5)
            -- GUI:Button_setTitleText(activeBtn, "激活灵根")
            -- GUI:Button_setTitleFontSize(activeBtn, 18)
            -- GUI:Button_setTitleColor(activeBtn, "#F4E7B5")
            -- GUI:Button_titleEnableOutline(activeBtn, "#110b05", 2)
            -- GUI:addOnClickEvent(activeBtn, function()
            --     SL:SendLuaNetMsg(100, npcid, 2, idx, "")
            -- end)
        else
            local enterBtn = GUI:Button_Create(labelNode, "enter_btn", 150 + 37, -8 + 46, "res/custom/four_city/lgsl/btn.png")
            GUI:setAnchorPoint(enterBtn, 0.5, 0.5)
            GUI:addOnClickEvent(enterBtn, function()
                local needItem = tostring(config.itme or "")
                if needItem ~= "" and not hasNeedTitle(needItem) then
                    SL:ShowSystemTips(string.format("<font color='#FFCC66'>进入该灵根试炼需要先拥有称号或神器位装备：%s</font>", needItem))
                end
                SL:SendLuaNetMsg(100, npcid, 1, idx, "")
            end)
        end
    end

    local function updateUI(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.titles_sign = npc.titles_sign or 1

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        for i = 1, 5 do
            local cblItem = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/four_city/lgsl/list/" .. (npc.titles_sign == i and "l" or "n") .. "/" .. i .. ".png")
            GUI:addOnClickEvent(cblItem, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/four_city/lgsl/list/n/" .. npc.titles_sign .. ".png")
                npc.titles_sign = i
                createLabel(npc.Label, i)
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/four_city/lgsl/list/l/" .. npc.titles_sign .. ".png")
            end)
            GUI:Image_Create(npc.cbl_list, "fgx" .. i, 0, 0, "res/custom/fulitating/list/fgx.png")
        end

        createLabel(npc.Label, npc.titles_sign)
    end

    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_data = npc.data.T_data or {}
        npc.data.T_data.level = npc.data.T_data.level or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.T_dljq["npc_68"] = npc.data.T_dljq["npc_68"] or {}
        ensureWindow(npcid)
        updateUI(npc.node)
    elseif p2 == 1 then
        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        ensureTable(npc.data.T_dljq, "npc_68")[tostring(p3)] = 0
        npc.titles_sign = tonumber(p3) or npc.titles_sign or 1
        updateUI(npc.node)
    elseif p2 == 2 then
        npc.data = npc.data or {}
        npc.data.T_data = npc.data.T_data or {}
        ensureTable(npc.data.T_data, "level")[tostring(p3)] = 0
        npc.data.T_dljq = npc.data.T_dljq or {}
        ensureTable(npc.data.T_dljq, "npc_68")[tostring(p3)] = 1
        npc.titles_sign = tonumber(p3) or npc.titles_sign or 1
        updateUI(npc.node)
    end
end

return npc
