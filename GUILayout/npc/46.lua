local npc = {}

npc._config = teshudata["npc_46"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/zerq/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/zerq/title.png"},
}

local state_info = {
    [1] = {
        color = "#FF0000", -- 红色
        text = "未完成"
    },
    [2] = {
        color = "#00FF00", -- 绿色
        text = "已通过"
    }
}

local route_info = {
    [1] = {step = "npc_623", boss = "npc_625"},
    [2] = {step = "npc_622", boss = "npc_627"},
    [3] = {step = "npc_624", boss = "npc_626"},
    [4] = {step = "npc_621", boss = "npc_628"},
}

local need_keys = {"npc_621", "npc_622", "npc_623", "npc_624", "npc_625", "npc_626", "npc_627", "npc_628"}

local function refreshMainlineUi()
    if MainAssist and type(MainAssist.UpdateCurrentXylTaskWidget) == "function" then
        MainAssist.UpdateCurrentXylTaskWidget()
    end
    if MainAssist and type(MainAssist.RequestGrayWorldTaskIconRefresh) == "function" then
        MainAssist.RequestGrayWorldTaskIconRefresh()
    end
end

function npc._isTaskAccepted()
    local task46Data = npc.data and npc.data.T_data and npc.data.T_data["npc_46"]
    if type(task46Data) == "table" then
        return (tonumber(task46Data.start or 0) or 0) >= 1 or (tonumber(task46Data.wc or 0) or 0) >= 1
    end
    return (tonumber(task46Data or 0) or 0) >= 1
end

function npc.main(npcid, p2, p3, msgData)


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

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        local currentRwid = 0
        if cogin and cogin.sjtb then
            currentRwid = tonumber(cogin.sjtb.rwid or cogin.sjtb.zxrwid or 0) or 0
        end
        if Player and type(Player.getServerVar) == "function" then
            local serverRwid = tonumber(Player:getServerVar("U11") or 0) or 0
            if serverRwid <= 0 then
                serverRwid = tonumber(Player:getServerVar("U_zxrw") or 0) or 0
            end
            if serverRwid > 0 then
                currentRwid = serverRwid
            end
        end

        local expectedRoute = nil
        if currentRwid == 37 then
            expectedRoute = 1
        elseif currentRwid == 39 then
            for routeIdx = 1, 4 do
                local route = route_info[routeIdx]
                if route and (npc.data.T_data[route.boss] or 0) < 2 then
                    expectedRoute = routeIdx
                    break
                end
            end
        end


        local function GUI_createLabel(label_node, idx)
            GUI:removeAllChildren(label_node)

            local config = npc._config.details[idx]
            local model = GUI:Effect_Create(label_node, "monster_model", 150, 130, 2, config.mob_eff or 0, 0, 0, 5)
            GUI:setScale(model, config.scale or 1)
            local mob_name = GUI:Text_Create(label_node, "mob_name",100 + 70,150 + 211, 28, "#FF0000", config.mob_name)
            GUI:Text_setFontName(mob_name, "fonts/500.ttf")
            GUI:setAnchorPoint(mob_name, 0.5, 0.5)
            GUI:Image_Create(label_node, "w", 310, 340, "res/custom/three_city/zerq/w_"..idx..".png")


            GUI:Text_Create(label_node, "name",460,293, 20, "#FF0000", config.mob_name)
            GUI:Text_Create(label_node, "map",460,293 - 44, 20, "#FF0000", config.map)
            local spa = GUI:Text_Create(label_node, "spa",460,293 - 44 - 44, 20, "#FF0000", config.spa)
            GUI:Text_enableUnderline(spa)
            tip_node(spa, config.spa_details)
            local kz = GUI:Text_Create(label_node, "kz",460,293 - 44 - 44 - 44, 20, "#FF0000", config.kz)
            GUI:Text_enableUnderline(kz)
            tip_node(kz, config.kz_details)
            local key = "npc_"..config.key
            npc.data.T_data[key] = (npc.data.T_data and npc.data.T_data[key]) and npc.data.T_data[key] or 0

            -- GUI:Text_Create(label_node, "kz",460,293 - 44 - 44 - 44, 20, "#FF0000", config.kz)
            local state = npc.data.T_data[key] >= 2 and 2 or 1
            GUI:Text_Create(label_node, "state",460,293 - 44 - 44 - 44 - 44, 20, state_info[state].color, state_info[state].text)

            local route = route_info[idx]
            if route then
                local stepDone = (npc.data.T_data[route.step] or 0) >= 2
                local bossDone = (npc.data.T_data[route.boss] or 0) >= 2
                local isCurrentRoute = expectedRoute == idx
                local statusText
                local statusColor
                if bossDone then
                    statusText = "当前阶段：已完成"
                    statusColor = "#7CFF7C"
                elseif not isCurrentRoute then
                    statusText = "当前阶段：待后续开放"
                    statusColor = "#AAAAAA"
                elseif stepDone then
                    statusText = "当前阶段：可前往讨伐"
                    statusColor = "#FFE46C"
                else
                    statusText = "当前阶段：先完成前置"
                    statusColor = "#FF6666"
                end
                local  route_status = GUI:Text_Create(label_node, "route_status", 200, 78, 20, statusColor, statusText)
                GUI:Text_setFontName(route_status, "fonts/font4.ttf")
                if not bossDone and isCurrentRoute and npc._isTaskAccepted() then
                    NPC_UI_HELPER.createPrimaryButton(label_node, "goto_btn", 570, 30, "", function()
                        SL:SendLuaNetMsg(100, npcid, 2, idx, "")
                    end, {fontSize = 18,skin = "res/wy/public/an_ljqw.png"})
                end
            end
            
        end

        local canClaim = true
        for _, taskKey in ipairs(need_keys) do
            if (npc.data.T_data[taskKey] or 0) < 2 then
                canClaim = false
                break
            end
        end
        local task46Data = npc.data.T_data["npc_46"]
        local task46Done = (type(task46Data) == "table" and tonumber(task46Data.wc or 0) or tonumber(task46Data or 0) or 0) >= 1
        local hasTitleReward = SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc._config.ch))
        local shouldAcceptMainline = currentRwid == 36 and not npc._isTaskAccepted()

        local kuang = GUI:Image_Create(node, "kuang2", 320 + 140, 15, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        if shouldAcceptMainline then
            local acceptButton = GUI:Button_Create(node, "Button_accept_mainline", 540, 10.00, "res/custom/all_story_mission/2/btn_take.png")
            GUI:addOnClickEvent(acceptButton, function()
                SL:SendLuaNetMsg(100, npcid, 3, 0, "")
            end)
            -- local acceptText = GUI:Text_Create(acceptButton, "accept_text", 105, 30, 20, "#FFE9A5", "接受灾厄入侵")
            -- GUI:setAnchorPoint(acceptText, 0.5, 0.5)
            -- GUI:Text_setFontName(acceptText, "fonts/502.ttf")
            -- GUI:Text_enableOutline(acceptText, "#000000", 2)
        elseif (not hasTitleReward) and canClaim then
            local Button= GUI:Button_Create(node, "Button_all", 540, 10.00, "res/custom/three_city/zerq/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif not canClaim then
            -- GUI:Text_Create(node, "claim_lock", 485, 18, 18, "#ff7676", "需完成全部灰界与四灾任务后领取")
        end
        


        for i = 1, 4 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 27 + (i-1)*182, 390, "res/custom/three_city/zerq/k_"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:removeChildByName(GUI:ui_delegate(node)["item" .. npc.titles_sign], "kuang")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "kuang", 182/2, 60/2, "res/custom/three_city/zerq/kuang.png")
                , 0.5, 0.5)
            end)
            if npc.titles_sign == nil or i == npc.titles_sign then
                npc.titles_sign = i
                GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "kuang", 182/2, 60/2, "res/custom/three_city/zerq/kuang.png")
                , 0.5, 0.5)
            end
        end
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
        


    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false) or {}
        npc.data.T_data = npc.data.T_data or {}
        npc.data.T_data["npc_46"] = npc.data.T_data["npc_46"] or {}
        if NPC_UI_HELPER and NPC_UI_HELPER.setThreeCityIntroSeen then
            NPC_UI_HELPER.setThreeCityIntroSeen(npc.data.three_city_intro_seen or 0)
        end
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        NPC_UI_HELPER.closeWindow(npc._window)
        refreshMainlineUi()
    elseif p2 == 3 then
        NPC_UI_HELPER.closeWindow(npc._window)
        refreshMainlineUi()
    elseif p2 == 8 then
        local data = SL:JsonDecode(msgData, false) or {}
        if NPC_UI_HELPER and NPC_UI_HELPER.setThreeCityIntroSeen then
            NPC_UI_HELPER.setThreeCityIntroSeen(data.three_city_intro_seen or 0)
            NPC_UI_HELPER.guochang_3(true)
        end
    end
end

return npc
