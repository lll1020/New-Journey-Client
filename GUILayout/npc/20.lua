local npc = {}

npc._config = teshudata["npc_20"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/20_bg.png", eff = false},
    closeButton = { x = 750, y = 50 + 327},
}

local function getPanelName(data)
    local first = data and data.first or {}
    local name = first.name or first.mz or first.role_name or first.player_name or ""
    if type(name) ~= "string" then
        name = tostring(name or "")
    end
    name = string.gsub(name, "^%s+", "")
    name = string.gsub(name, "%s+$", "")
    if name == "" then
        return "暂未冠名"
    end
    return name
end

local function getPanelCharge(data)
    return tonumber(data and data.charge or 0) or 0
end

local function getPanelCost(data, cfg)
    return tonumber(data and data.cost or (cfg and cfg.cost) or 0) or 0
end

local function hasPanelTitle(data)
    return (tonumber(data and data.has_title or 0) or 0) >= 1
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

    local function createOutlinedText(parent, name, x, y, size, color, text, anchorX, anchorY)
        local label = GUI:Text_Create(parent, name, x, y, size, color, text)
        GUI:setAnchorPoint(label, anchorX or 0.5, anchorY or 0.5)
        GUI:Text_setFontName(label, "fonts/font4.ttf")
        GUI:Text_enableOutline(label, "#1b0d07", 2)
        return label
    end

    local function updateUI(node)
        if not node then
            return
        end

        npc.data = npc.data or {}
        GUI:removeAllChildren(node)

        local nameText = getPanelName(npc.data)
        local charge = getPanelCharge(npc.data)
        local cost = getPanelCost(npc.data, npc._config)
        local hasTitle = hasPanelTitle(npc.data)

        -- createOutlinedText(node, "title_tip", 389, 357, 24, "#FFE8A3", "首位冠名玩家", 0.5, 0.5)
        createOutlinedText(node, "player_name", 389 + 50 - 80, 303 - 270, 34, "#FFEDBF", nameText, 0, 0.5)

        local chargeColor = charge >= cost and "#7CFF7C" or "#FF8A7A"
        createOutlinedText(node, "charge_value", 380 + 244 + 44, 212 + 30 - 107, 22, chargeColor, tostring(charge) .. "/" .. tostring(cost), 1, 0.5)

        GUI:Effect_Create(node, "sz", 176, 60 + 110 + 117, 0, teshudata["npc_1002"].details.sz[8].sEffect, 0, 0, 3, 1)
        -- GUI:Effect_Create(node, "ch", 60 + 176, 60 + 110, 0, teshudata["npc_1002"].details.ch[1].sEffect, 0, 0, 3, 1)

        local cost_show = ItemNumByTable_img_new({{"时装：冠名",1},{"冠名[称号]",1}}, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost_show, 450 + 40 + 40, 100 + 50)

        -- local stateText = hasTitle and "已拥有冠名称号" or "达到条件后可领取冠名称号"
        -- local stateColor = hasTitle and "#7CFF7C" or "#FFD27A"
        -- createOutlinedText(node, "state_text", 389, 170, 22, stateColor, stateText, 0.5, 0.5)

        -- local titleItemName = tostring((npc._config and npc._config.ch) or "冠名") .. "[称号]"
        -- local titleItemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleItemName)
        -- if titleItemIndex and titleItemIndex > 0 then
        --     local itemBg = GUI:Image_Create(node, "item_bg", 389, 108, "res/wy/public/70_70_k.png")
        --     GUI:setAnchorPoint(itemBg, 0.5, 0.5)
        --     UiTools.showItemData(itemBg, SL:GetMetaValue("ITEM_DATA", titleItemIndex))
        -- end

        -- if hasTitle then
        --     local done = GUI:Image_Create(node, "done_btn", 389, 42, "res/wy/public/7_1.png")
        --     GUI:setAnchorPoint(done, 0.5, 0.5)
        -- else
        --     local btn = NPC_UI_HELPER.createPrimaryButton(node, "receive_btn", 389, 42, nil, function()
        --         SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        --     end, {
        --         skin = "res/public/1900000660.png",
        --     })
        --     GUI:setAnchorPoint(btn, 0.5, 0.5)
        --     GUI:Button_setTitleText(btn, "领取冠名")
        --     GUI:Button_setTitleFontSize(btn, 18)
        --     GUI:Button_setTitleColor(btn, charge >= cost and "#F9F2D8" or "#B8B8B8")
        --     GUI:Button_titleEnableOutline(btn, "#110b05", 2)

        --     if charge >= cost then
        --         NPC_UI_HELPER.redpoint_create(btn)
        --     end
        -- end
    end

    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcid)
        updateUI(npc.node)
    elseif p2 == 1 then
        if type(msgData) == "string" and msgData ~= "" then
            npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        else
            npc.data = npc.data or {}
            npc.data.has_title = 1
        end
        ensureWindow(npcid)
        updateUI(npc.node)
    end
end

return npc
