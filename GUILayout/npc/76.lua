local npc = {}

npc._config = teshudata["npc_76"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/tmsl/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/tmsl/title.png"},
}

local function ensureWindow(npcId)
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcId, npc._config)
    opts.subTitle = npc._config and npc._config.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcId, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end

local function getTaskData()
    local data = npc.data or {}
    local T_data = data.T_data or {}
    T_data["npc_74"] = T_data["npc_74"] or {}
    T_data["npc_76"] = T_data["npc_76"] or {}
    return T_data
end

local function isPreActivated(idx)
    return tonumber(getTaskData()["npc_74"][tostring(idx)] or 0) == 1
end

local function isTrialDone(idx)
    return tonumber(getTaskData()["npc_76"][tostring(idx)] or 0) == 1
end

local function getTrialDesc(idx)
    local cfg = (((npc._config or {}).details or {})[idx] or {}).trial or {}
    if idx == 1 then
        return string.format("进入副本后召出灵兽，由灵兽攻击BOSS造成伤害。\n灵兽每%d秒造成%d%%生命伤害。",
            tonumber(cfg.pet_tick_sec or 1) or 1,
            tonumber(cfg.pet_hurt_pct or 0) or 0)
    elseif idx == 2 then
        return string.format("清理全部敌人后通关。\n普通怪%d只、精英%d只、BOSS1只。",
            tonumber(cfg.mob_count or 0) or 0,
            tonumber(cfg.elite_count or 0) or 0)
    elseif idx == 3 then
        return string.format("在%d秒内成功抵挡%d次雷劫。\n【%s】可免疫1次雷劫，持续%d秒。",
            tonumber(cfg.fb_time or 0) or 0,
            tonumber(cfg.need_success or 0) or 0,
            tostring(cfg.dan_item or "天道·渡劫丹"),
            tonumber(cfg.dan_keep_sec or 0) or 0)
    elseif idx == 4 then
        return string.format("站在安全区累计积分达到%d即可通关。\n安全区每%d秒轮换一次，共%d轮。",
            tonumber(cfg.score_target or 0) or 0,
            tonumber(cfg.round_sec or 0) or 0,
            tonumber(cfg.total_round or 0) or 0)
    end
    return ""
end

local function getPanelStatusText(idx)
    local runIdx = tonumber((npc.data or {}).run_idx or 0) or 0
    local inFb = tonumber((npc.data or {}).in_fb or 0) == 1
    if isTrialDone(idx) then
        return "已通关", "#00FF00"
    end
    if inFb and runIdx == idx then
        return "试炼进行中", "#00FF00"
    end
    if inFb and runIdx ~= idx then
        return "正在其他试炼中", "#FFB84D"
    end
    if not isPreActivated(idx) then
        return "需先激活对应命盘", "#FF5A5A"
    end
    return "可进入试炼", "#F8E6B8"
end

local function renderPanel(node, npcId, idx)
    GUI:removeAllChildren(node)
    local detail = npc._config.details[idx]
    if not detail then
        return
    end

    local statusText, statusColor = getPanelStatusText(idx)
    local runIdx = tonumber((npc.data or {}).run_idx or 0) or 0
    local inFb = tonumber((npc.data or {}).in_fb or 0) == 1

    -- local title = GUI:Text_Create(node, "title", 295, 316, 24, "#FFF2B0", detail.name or "")
    -- GUI:Text_setFontName(title, "fonts/font4.ttf")
    -- GUI:setAnchorPoint(title, 0.5, 0.5)

    local need = GUI:Text_Create(node, "need", 300, 208 - 23, 20, "#F8E6B8",
        "前置要求：完成【" .. tostring((teshudata["npc_74"].details[idx] or {}).name or "") .. "】命盘激活")
    GUI:Text_setFontName(need, "fonts/font4.ttf")
    GUI:setAnchorPoint(need, 0.5, 0.5)

    -- local status = GUI:Text_Create(node, "status", 300, 176, 18, statusColor, statusText)
    -- GUI:Text_setFontName(status, "fonts/500.ttf")
    -- GUI:setAnchorPoint(status, 0.5, 0.5)

    local descNode = GUI:Node_Create(node, "desc_node", 86, 284 + 62)
    GUI:setAnchorPoint(GUI:RichText_Create(descNode, "desc", 0, 0, getTrialDesc(idx), 450, 18, "#FFFFFF", 3, nil, nil), 0, 1)

    local cost = checkItemNumByTable_img_kuang(npc._config.details[idx].cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
    GUI:setPosition(cost, 400, 100)
    cost = checkItemNumByTable_img_kuang(npc._config.details[idx].reward, nil,GUI:Node_Create(node, "jl_show", 0, 0))
    GUI:setPosition(cost, 205, 100)

    cost = ItemNumByTable_img_new({{"天命·复活",1},{"天命·麻痹",1},{"天命·神镰",1},{"天命·神斧",1}}, nil,GUI:Node_Create(node, "jl2_show", 0, 0))
    GUI:setPosition(cost, 80, 20)

    if inFb and runIdx == idx then
        local button = GUI:Button_Create(node, "leave", 468, 10, "res/custom/five_city/tmsl/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0)
        GUI:Button_setTitleText(button, "离开试炼")
        GUI:Button_setTitleFontSize(button, 18)
        GUI:addOnClickEvent(button, function()
            SL:SendLuaNetMsg(100, npcId, 2, 0, "")
        end)
    elseif isTrialDone(idx) then
        GUI:Image_Create(node, "done", 468, 10, "res/wy/public/10_2.png")
    elseif isPreActivated(idx) and not inFb then
        local button = GUI:Button_Create(node, "enter", 468, 10, "res/custom/five_city/tmsl/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0)
        -- GUI:Button_setTitleText(button, "进入试炼")
        -- GUI:Button_setTitleFontSize(button, 18)
        GUI:addOnClickEvent(button, function()
            SL:SendLuaNetMsg(100, npcId, 1, 0, SL:JsonEncode({idx = idx}, false))
        end)
    end
end

local function renderMain(node, npcId)
    if not node then
        return
    end

    GUI:removeAllChildren(node)
    npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
    GUI:ListView_setGravity(npc.cbl_list, 1)
    GUI:ListView_setItemsMargin(npc.cbl_list, 10)
    npc.Label = GUI:Node_Create(node, "Label", 170, 15)

    npc.titles_sign = npc.titles_sign or 1
    for i = 1, 4 do
        local item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0,
            "res/custom/five_city/tmsl/list/" .. (npc.titles_sign == i and "l" or "n") .. "/" .. i .. ".png")
        GUI:Image_Create(npc.cbl_list, "fgx" .. i, 0, 0, "res/custom/fulitating/list/fgx.png")
        if isTrialDone(i) then
            GUI:Image_Create(item, "done_" .. i, 110, 32, "res/wy/public/10_2.png")
        end
        GUI:addOnClickEvent(item, function()
            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign],
                "res/custom/five_city/tmsl/list/n/" .. npc.titles_sign .. ".png")
            npc.titles_sign = i
            renderPanel(npc.Label, npcId, i)
            GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign],
                "res/custom/five_city/tmsl/list/l/" .. npc.titles_sign .. ".png")
        end)
    end

    renderPanel(npc.Label, npcId, npc.titles_sign)
end

function npc.main(npcId, p2, p3, msgData)
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false) or {}
        ensureWindow(npcId)
        renderMain(npc.node, npcId)
    elseif p2 == 1 or p2 == 2 or p2 == 3 or p2 == 4 or p2 == 5 then
        npc.data = SL:JsonDecode(msgData, false) or npc.data or {}
        renderMain(npc.node, npcId)
    end
end

return npc
