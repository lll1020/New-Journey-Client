local MainAssistXylHelper = {}

-- 备注：伏妖录当前任务变更事件名。
MainAssistXylHelper.EVENT_CURRENT_TASK_CHANGE = "伏妖录当前任务变更"

local DETAIL_POPUP_DEFAULT_POS = {x = 220, y = 0}
local XYL_DYNAMIC_REFRESH_DELAY = 0.2
local GRAY_WORLD_PANEL_POS = {x = 40, y = 0}
local GRAY_WORLD_BG_PATH = "res/wy/eff/npc_but_bj_1.png"
local GRAY_WORLD_PANEL_SIZE = {width = 200, height = 190}
local GRAY_WORLD_LINE_SCALE = 0.41
local GRAY_WORLD_LINES = {
    {idx = 1, skin = "res/wy/public/bigkuang.png"},
    {idx = 2, skin = "res/wy/public/bigkuang.png"},
    {idx = 3, skin = "res/wy/public/bigkuang.png"},
    {idx = 4, skin = "res/wy/public/bigkuang.png"},
}
local GRAY_WORLD_TOUCH_SKIN = "res/public/0.png"
local GRAY_WORLD_TOUCH_REGIONS = {
    {idx = 1, x = 2, y = 122, width = 194, height = 28, btnX = 97, btnY = 14, btnWidth = 250, btnHeight = 34, rotation = -16},
    {idx = 2, x = 2, y = 96,  width = 194, height = 28, btnX = 97, btnY = 14, btnWidth = 250, btnHeight = 34, rotation = -16},
    {idx = 3, x = 2, y = 70,  width = 194, height = 28, btnX = 97, btnY = 14, btnWidth = 250, btnHeight = 34, rotation = -16},
    {idx = 4, x = 2, y = 44,  width = 194, height = 28, btnX = 97, btnY = 14, btnWidth = 250, btnHeight = 34, rotation = -16},
}
local GRAY_WORLD_ROUTE_CONFIGS = {
    {idx = 1, step = "npc_623", boss = "npc_625", order = 1},
    {idx = 2, step = "npc_622", boss = "npc_627", order = 2},
    {idx = 3, step = "npc_624", boss = "npc_626", order = 3},
    {idx = 4, step = "npc_621", boss = "npc_628", order = 4},
}
local GRAY_WORLD_PREP_ITEM_KEYS = {
    "npc_626",
    "npc_627",
    "npc_628",
}
local GRAY_WORLD_TEXT_POS = {x = 3, y = 48}
local GRAY_WORLD_TEXT_SECONDARY_X = 19
local GRAY_WORLD_TOP_TEXT_POS = {x = 70, y = 48}
local GRAY_WORLD_TOP_TEXT_SECONDARY_X = 83
local GRAY_WORLD_REDPOINT_POS = {
    [1] = {x = 94 + 6, y = 84 + 6},
    [2] = {x = 94 + 6, y = 84 + 6},
    [3] = {x = 94, y = 84},
    [4] = {x = 94, y = 64},
}
local GRAY_WORLD_MAP_NAMES = {
    ["灰界"] = true,
    ["灰界南部"] = true,
    ["灰界北部"] = true,
    ["灰界东部"] = true,
    ["灰界西部"] = true,
    ["虚妄山脉"] = true,
    ["鬼嘲深渊"] = true,
    ["叹息旷野"] = true,
    ["禁忌之海"] = true,
    ["讨伐嘲灾"] = true,
    ["讨伐忌灾"] = true,
    ["讨伐息灾"] = true,
    ["讨伐妄灾"] = true,
}
local GRAY_WORLD_MAP_IDS = {
    ["212"] = true,
    ["300"] = true,
    ["301"] = true,
    ["302"] = true,
    ["303"] = true,
}
local GRAY_WORLD_MAP_KEYWORDS = {"灰界", "虚妄山脉", "鬼嘲深渊", "叹息旷野", "禁忌之海", "讨伐嘲灾", "讨伐忌灾", "讨伐息灾", "讨伐妄灾"}
local GRAY_WORLD_MAP_SUFFIXES = {
    "_npc625",
    "_npc626",
    "_npc627",
    "_npc628",
}

-- 备注：给任务栏挂载伏妖录当前任务的通用逻辑。
function MainAssistXylHelper.bind(MainAssist)
    if type(MainAssist) ~= "table" then
        return
    end
    if MainAssist._xylHelperBound then
        return
    end
    MainAssist._xylHelperBound = true

    MainAssist._xylTaskNameMap = nil
    MainAssist._xylTaskDqMap = nil
    MainAssist._xylTaskInfoMap = nil
    MainAssist._xylTaskData = nil
    MainAssist._xylCurrentTask = nil
    MainAssist._xylDetailPopupPos = nil
    MainAssist._xylDynamicRefreshTimer = nil
    MainAssist._xylLastTraceKey = nil
    MainAssist._xylLastPrintTaskKey = nil

    local function _debug_xyl_trace(tag, data)
        return
    end

    function MainAssist.DebugXylTrace(tag, data)
        _debug_xyl_trace(tag, data)
    end

    local function _build_xyl_task_maps()
        if MainAssist._xylTaskNameMap and MainAssist._xylTaskDqMap and MainAssist._xylTaskInfoMap then
            return MainAssist._xylTaskNameMap, MainAssist._xylTaskDqMap, MainAssist._xylTaskInfoMap
        end

        local nameMap = {}
        local dqMap = {}
        local infoMap = {}
        local ok, xyl = pcall(function()
            return SL:Require("GUILayout/Data/xyl.lua", true)
        end)
        if ok and type(xyl) == "table" then
            MainAssist._xylTaskData = xyl
            for i = 2, #xyl do
                local lCfg = xyl[i]
                if type(lCfg) == "table" then
                    for j = 1, #lCfg do
                        local chapter = lCfg[j]
                        local jq = chapter and chapter.jq
                        if type(jq) == "table" then
                            for z, task in ipairs(jq) do
                                if type(task) == "table" then
                                    local taskName = tostring(task[1] or "")
                                    local dqKey = string.format("%d_%d_%d", i, j, z)
                                    dqMap[dqKey] = taskName
                                    infoMap[dqKey] = {
                                        name = taskName,
                                        i = i,
                                        j = j,
                                        z = z,
                                        task = task,
                                    }
                                    local tk = type(task.tk) == "string" and task.tk:match("^npc_(%d+)$") or nil
                                    if tk then
                                        nameMap[tonumber(tk)] = taskName
                                    end
                                    local ydNpcId = task.yd and tonumber(task.yd[3]) or nil
                                    if ydNpcId and ydNpcId > 0 and not nameMap[ydNpcId] then
                                        nameMap[ydNpcId] = taskName
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        MainAssist._xylTaskNameMap = nameMap
        MainAssist._xylTaskDqMap = dqMap
        MainAssist._xylTaskInfoMap = infoMap
        return nameMap, dqMap, infoMap
    end

    local function _get_xyl_task_dq(data)
        if type(data) ~= "table" then
            data = {}
        end

        local dq = data.dq
            or data.current_xyl_dq
            or data.currentXylDq
            or data.ywl_dq
            or data.ywlDq

        if not dq and type(data.ywl) == "table" then
            dq = data.ywl.dq
                or data.ywl.current_xyl_dq
                or data.ywl.currentXylDq
        end

        if not dq then
            local cached = MainAssist._xylCurrentTask
            dq = cached and (cached.dq or cached.current_xyl_dq or cached.currentXylDq) or nil
        end

        if type(dq) ~= "string" or dq == "" then
            return nil
        end
        return dq
    end

    local function _get_xyl_task_id(data)
        if type(data) ~= "table" then
            data = {}
        end

        local xylTaskId = tonumber(
            data.xyl_task_id
            or data.xylTaskId
            or data.current_xyl_task_id
            or data.currentXylTaskId
            or data.dq_id
            or data.ywl_task_id
            or data.ywlTaskId
        )
        if xylTaskId then
            return xylTaskId
        end

        local cached = MainAssist._xylCurrentTask or {}

        return tonumber(
            cached.xyl_task_id
            or cached.xylTaskId
            or cached.current_xyl_task_id
            or cached.currentXylTaskId
            or cached.dq_id
            or cached.ywl_task_id
            or cached.ywlTaskId
        )
    end

    local function _get_xyl_current_task_info(data)
        local _, _, infoMap = _build_xyl_task_maps()
        local dq = _get_xyl_task_dq(data)
        if dq and infoMap[dq] then
            return infoMap[dq]
        end
        return nil
    end

    local function _get_xyl_current_task_action_text(info)
        local task = type(info) == "table" and info.task or nil
        local canClaim = (type(task) == "table" and task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
        return canClaim and "领取奖励" or "立即前往"
    end

    local function _get_xyl_current_task_cache_key(data, info)
        info = info or _get_xyl_current_task_info(data)
        if type(info) == "table" and info.i and info.j and info.z then
            return string.format("%s_%s_%s", tostring(info.i), tostring(info.j), tostring(info.z))
        end

        local dq = _get_xyl_task_dq(data)
        if dq and dq ~= "" then
            return dq
        end

        local taskId = _get_xyl_task_id(data)
        if taskId then
            return "暂无任务简介"
        end

        return ""
    end

    local function _flush_xyl_dynamic_content()
        MainAssist._xylDynamicRefreshTimer = nil
        if not MainAssist._xylCurrentTask then
            return
        end

        MainAssist.UpdateCurrentXylTaskWidget()

        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            _refresh_xyl_detail_popup_content()
        end
    end

    local function _request_xyl_dynamic_refresh()
        if MainAssist._xylDynamicRefreshTimer then
            return
        end

        local schedulerNode = MainAssist._ui and MainAssist._ui["Panel_assist"]
        if not schedulerNode then
            _flush_xyl_dynamic_content()
            return
        end

        MainAssist._xylDynamicRefreshTimer = SL:scheduleOnce(schedulerNode, function()
            _flush_xyl_dynamic_content()
        end, XYL_DYNAMIC_REFRESH_DELAY)
    end

    local function _is_gray_world_map(eventData)
        local mapId = tostring(SL:GetMetaValue("MAP_ID") or "")
        if mapId == "" and type(eventData) == "table" then
            mapId = tostring(eventData.mapID or "")
        end
        if mapId ~= "" and GRAY_WORLD_MAP_IDS[mapId] then
            return true
        end

        local mapName = tostring(SL:GetMetaValue("MAP_NAME") or "")
        if mapName == "" then
            if type(eventData) == "table" then
                MainAssist._grayWorldLastMapEvent = {
                    mapID = tostring(eventData.mapID or ""),
                    lastMapID = tostring(eventData.lastMapID or ""),
                }
            end
            return false
        end
        if GRAY_WORLD_MAP_NAMES[mapName] then
            return true
        end
        for _, keyword in ipairs(GRAY_WORLD_MAP_KEYWORDS) do
            if string.find(mapName, keyword, 1, true) ~= nil then
                return true
            end
        end
        local currentPlayerName = tostring(SL:GetMetaValue("REAL_USER_NAME") or SL:GetMetaValue("USER_NAME") or "")
        if currentPlayerName ~= "" then
            for _, suffix in ipairs(GRAY_WORLD_MAP_SUFFIXES) do
                if mapName == currentPlayerName .. suffix then
                    return true
                end
            end
        end
        for _, suffix in ipairs(GRAY_WORLD_MAP_SUFFIXES) do
            if string.find(mapName, suffix, 1, true) ~= nil then
                return true
            end
        end
        return false
    end

    local function _gray_world_to_num(value, defaultValue)
        local num = tonumber(value)
        if num == nil then
            return defaultValue or 0
        end
        return num
    end

    local function _gray_world_parse_server_json(varName)
        local raw = SL:GetMetaValue("SERVER_VALUE", varName)
        if type(raw) ~= "string" or raw == "" then
            return {}
        end
        local ok, data = pcall(function()
            return SL:JsonDecode(raw, false)
        end)
        if not ok or type(data) ~= "table" then
            return {}
        end
        return data
    end

    local function _gray_world_get_runtime_data()
        return _gray_world_parse_server_json("T13"), _gray_world_parse_server_json("T35")
    end

    local function _gray_world_get_cfg(key)
        local data = rawget(_G, "teshudata")
        if type(data) ~= "table" then
            return {}
        end
        local cfg = data[key]
        if type(cfg) ~= "table" then
            return {}
        end
        return cfg
    end

    local function _gray_world_get_bag_count(itemName)
        if type(itemName) ~= "string" or itemName == "" then
            return 0
        end
        return _gray_world_to_num(SL:GetMetaValue("ITEM_COUNT", itemName), 0)
    end

    local function _gray_world_is_step_claimable(stepCfg, taskState, sgData, taskKey)
        if taskState <= 0 then
            return true
        end
        if taskState ~= 1 then
            return false
        end
        local needNum = _gray_world_to_num(stepCfg.num, 0)
        if needNum <= 0 then
            return false
        end
        return _gray_world_to_num(sgData[taskKey], 0) >= needNum
    end

    local function _gray_world_is_boss_prep_claimable(bossCfg, prepState, sgData, bossKey)
        if prepState <= 0 then
            return true
        end
        if prepState ~= 1 then
            return false
        end

        local prepCfg = type(bossCfg.prep_task) == "table" and bossCfg.prep_task or {}
        if bossKey == "npc_625" then
            return _gray_world_to_num(sgData[bossKey .. "_rw"], 0) >= 50
        end
        if bossKey == "npc_626" or bossKey == "npc_627" then
            return _gray_world_get_bag_count(prepCfg.item_name) >= _gray_world_to_num(prepCfg.need, 0)
        end
        if bossKey == "npc_628" then
            return _gray_world_get_bag_count(prepCfg.left_name) >= 1 and _gray_world_get_bag_count(prepCfg.right_name) >= 1
        end
        return false
    end

    local function _gray_world_build_route_state(routeCfg, jqData, sgData)
        local stepCfg = _gray_world_get_cfg(routeCfg.step)
        local bossCfg = _gray_world_get_cfg(routeCfg.boss)
        local stepState = _gray_world_to_num(jqData[routeCfg.step], 0)
        local bossState = _gray_world_to_num(jqData[routeCfg.boss], 0)
        local prepState = _gray_world_to_num(jqData[routeCfg.boss .. "_rw"], 0)

        if bossState >= 2 then
            return {
                idx = routeCfg.idx,
                order = routeCfg.order,
                statusText = "已完成",
                canJump = false,
                showRedPoint = false,
                completed = true,
            }
        end

        if stepState < 2 then
            return {
                idx = routeCfg.idx,
                order = routeCfg.order,
                statusText = tostring(stepCfg.name or routeCfg.step),
                canJump = true,
                showRedPoint = _gray_world_is_step_claimable(stepCfg, stepState, sgData, routeCfg.step),
                completed = false,
            }
        end

        return {
            idx = routeCfg.idx,
            order = routeCfg.order,
            statusText = tostring(bossCfg.name or routeCfg.boss),
            canJump = true,
            showRedPoint = _gray_world_is_boss_prep_claimable(bossCfg, prepState, sgData, routeCfg.boss),
            completed = false,
        }
    end

    local function _gray_world_build_route_state_key(routeState)
        return table.concat({
            tostring(routeState.idx or 0),
            tostring(routeState.statusText or ""),
            routeState.canJump and "1" or "0",
            routeState.showRedPoint and "1" or "0",
            routeState.completed and "1" or "0",
        }, "|")
    end

    local function _gray_world_build_runtime_cache_key()
        local parts = {
            tostring(SL:GetMetaValue("SERVER_VALUE", "T13") or ""),
            tostring(SL:GetMetaValue("SERVER_VALUE", "T35") or ""),
        }

        for _, npcKey in ipairs(GRAY_WORLD_PREP_ITEM_KEYS) do
            local prepCfg = _gray_world_get_cfg(npcKey).prep_task or {}
            if prepCfg.item_name and prepCfg.item_name ~= "" then
                parts[#parts + 1] = npcKey .. ":" .. prepCfg.item_name .. "=" .. tostring(_gray_world_get_bag_count(prepCfg.item_name))
            end
            if prepCfg.left_name and prepCfg.left_name ~= "" then
                parts[#parts + 1] = npcKey .. ":" .. prepCfg.left_name .. "=" .. tostring(_gray_world_get_bag_count(prepCfg.left_name))
            end
            if prepCfg.right_name and prepCfg.right_name ~= "" then
                parts[#parts + 1] = npcKey .. ":" .. prepCfg.right_name .. "=" .. tostring(_gray_world_get_bag_count(prepCfg.right_name))
            end
        end

        return table.concat(parts, "||")
    end

    local function _gray_world_vertical_text(text)
        text = tostring(text or "")
        if text == "" then
            return ""
        end

        local chars = {}
        local i = 1
        local len = #text
        while i <= len do
            local c = string.byte(text, i)
            local step = 1
            if c >= 240 then
                step = 4
            elseif c >= 224 then
                step = 3
            elseif c >= 192 then
                step = 2
            end
            chars[#chars + 1] = string.sub(text, i, i + step - 1)
            i = i + step
        end

        return table.concat(chars, "\n")
    end

    local function _gray_world_split_step_text(text)
        text = tostring(text or "")
        local prefix, suffix = string.match(text, "^(踏入)·(.+)$")
        if prefix and suffix and suffix ~= "" then
            return prefix, suffix
        end
        return nil, "    "..text
    end

    local function _gray_world_get_text_color(routeState)
        local text = tostring(routeState and routeState.statusText or "")
        if routeState and routeState.completed then
            return "#00FF00"
        end
        if string.match(text, "^踏入") then
            return "#FFFF00"
        end
        if string.match(text, "^讨伐") then
            return "#FF0000"
        end
        return "#FFFFFF"
    end

    local function _gray_world_get_text_layout(routeIdx)
        if routeIdx == 1 or routeIdx == 2 then
            return {
                primaryX = GRAY_WORLD_TOP_TEXT_POS.x,
                primaryY = GRAY_WORLD_TOP_TEXT_POS.y + 25,
                secondaryX = GRAY_WORLD_TOP_TEXT_SECONDARY_X,
                secondaryY = GRAY_WORLD_TOP_TEXT_POS.y - 10,
            }
        end

        return {
            primaryX = GRAY_WORLD_TEXT_POS.x,
            primaryY = GRAY_WORLD_TEXT_POS.y + 25,
            secondaryX = GRAY_WORLD_TEXT_SECONDARY_X,
            secondaryY = GRAY_WORLD_TEXT_POS.y - 10,
        }
    end

    local function _gray_world_get_redpoint_pos(routeIdx)
        local pos = GRAY_WORLD_REDPOINT_POS[routeIdx]
        if type(pos) == "table" then
            return pos
        end
        return {x = 94, y = 84}
    end

    local function _gray_world_update_line(panel, routeState)
        local line = GUI:getChildByName(panel, "line_" .. tostring(routeState.idx))
        if not line then
            return
        end

        local prefixText, suffixText = _gray_world_split_step_text(routeState.statusText or "")
        local lineText = GUI:getChildByName(line, "status_text")
        local lineText2 = GUI:getChildByName(line, "status_text_2")
        local textColor = _gray_world_get_text_color(routeState)
        local textLayout = _gray_world_get_text_layout(routeState.idx)

        if not lineText then
            lineText = GUI:Text_Create(line, "status_text", textLayout.primaryX, textLayout.primaryY, 12, "#FFFFFF", "")
            GUI:setAnchorPoint(lineText, 0, 0.5)
            GUI:Text_setFontName(lineText, "fonts/font4.ttf")
            GUI:Text_enableOutline(lineText, "#000000", 2)
        else
            GUI:setPosition(lineText, textLayout.primaryX, textLayout.primaryY)
        end

        if prefixText then
            if not lineText2 then
                lineText2 = GUI:Text_Create(line, "status_text_2", textLayout.secondaryX, textLayout.secondaryY, 12, "#FFFFFF", "")
                GUI:setAnchorPoint(lineText2, 0, 0.5)
                GUI:Text_setFontName(lineText2, "fonts/font4.ttf")
                GUI:Text_enableOutline(lineText2, "#000000", 2)
            else
                GUI:setPosition(lineText2, textLayout.secondaryX, textLayout.secondaryY)
            end
            GUI:Text_setString(lineText, _gray_world_vertical_text(prefixText))
            GUI:Text_setString(lineText2, _gray_world_vertical_text(suffixText))
            GUI:Text_setTextColor(lineText, textColor)
            GUI:Text_setTextColor(lineText2, textColor)
            GUI:setVisible(lineText2, true)
        else
            GUI:Text_setString(lineText, _gray_world_vertical_text(suffixText))
            GUI:Text_setTextColor(lineText, textColor)
            if lineText2 then
                GUI:setVisible(lineText2, false)
            end
        end

        -- GUI:Image_setGrey(line, routeState.completed == true)
        -- GUI:setOpacity(line, routeState.completed and 210 or 255)

        local touchBtn = GUI:getChildByName(line, "touch_btn")
        if not touchBtn then
            touchBtn = GUI:Button_Create(line, "touch_btn", 50, 47, GRAY_WORLD_TOUCH_SKIN)
            GUI:setAnchorPoint(touchBtn, 0.5, 0.5)
            GUI:setContentSize(touchBtn, 100, 95)
            GUI:addOnClickEvent(touchBtn, function()
                if touchBtn._grayWorldCompleted then
                    return
                end
                SL:SendLuaNetMsg(100, 46, 2, touchBtn._grayWorldRouteIdx or 0, "")
            end)
        end
        touchBtn._grayWorldRouteIdx = routeState.idx
        touchBtn._grayWorldCompleted = routeState.completed == true
        GUI:setTouchEnabled(touchBtn, routeState.canJump == true)
        GUI:Button_setBright(touchBtn, routeState.canJump == true)

        local redPoint = GUI:getChildByName(line, "redpoint")
        if routeState.showRedPoint then
            if not redPoint then
                local pos = _gray_world_get_redpoint_pos(routeState.idx)
                redPoint = NPC_UI_HELPER.redpoint_create(line, {
                    name = "redpoint",
                    x = pos.x,
                    y = pos.y,
                    anchorX = 1,
                    anchorY = 1,
                })
            end
            if redPoint then
                GUI:setVisible(redPoint, true)
                local pos = _gray_world_get_redpoint_pos(routeState.idx)
                GUI:setPosition(redPoint, pos.x, pos.y)
            end
        elseif redPoint then
            GUI:setVisible(redPoint, false)
        end
    end

    local function _gray_world_refresh_panel(panel)
        if not panel then
            return
        end
        local runtimeCacheKey = _gray_world_build_runtime_cache_key()
        if panel._grayWorldRuntimeCacheKey == runtimeCacheKey then
            return
        end

        local jqData, sgData = _gray_world_get_runtime_data()
        panel._grayWorldRouteStateCache = panel._grayWorldRouteStateCache or {}
        local routeStates = {}
        for _, routeCfg in ipairs(GRAY_WORLD_ROUTE_CONFIGS) do
            routeStates[#routeStates + 1] = _gray_world_build_route_state(routeCfg, jqData, sgData)
        end

        table.sort(routeStates, function(a, b)
            return _gray_world_to_num(a.order, 999) < _gray_world_to_num(b.order, 999)
        end)

        local allowRedPoint = true
        local allowClick = true
        for _, routeState in ipairs(routeStates) do
            if not allowClick then
                routeState.canJump = false
            end
            if not allowRedPoint then
                routeState.showRedPoint = false
            end
            if not routeState.completed then
                allowClick = false
                allowRedPoint = false
            end
        end

        local firstRedPointIdx = nil
        for _, routeState in ipairs(routeStates) do
            if routeState.showRedPoint then
                firstRedPointIdx = routeState.idx
                break
            end
        end

        for _, routeState in ipairs(routeStates) do
            routeState.showRedPoint = routeState.showRedPoint and routeState.idx == firstRedPointIdx
            local routeStateKey = _gray_world_build_route_state_key(routeState)
            if panel._grayWorldRouteStateCache[routeState.idx] ~= routeStateKey then
                _gray_world_update_line(panel, routeState)
                panel._grayWorldRouteStateCache[routeState.idx] = routeStateKey
            end
        end
        panel._grayWorldRuntimeCacheKey = runtimeCacheKey
    end

    local function _ensure_gray_world_icon()
        if MainAssist._grayWorldTaskIcon then
            return MainAssist._grayWorldTaskIcon
        end

        local parent = MainAssist._ui and MainAssist._ui["Panel_assist"]
        if not parent then
            return nil
        end

        local panel = GUI:Layout_Create(parent, "Panel_gray_world_task", GRAY_WORLD_PANEL_POS.x, GRAY_WORLD_PANEL_POS.y, GRAY_WORLD_PANEL_SIZE.width, GRAY_WORLD_PANEL_SIZE.height, false)
        if not panel then
            return nil
        end

        GUI:setLocalZOrder(panel, 1001)
        GUI:setTouchEnabled(panel, true)
        panel._grayWorldRuntimeCacheKey = nil
        panel._grayWorldRouteStateCache = {}

        local bg = GUI:Image_Create(panel, "bg", 0, 0, GRAY_WORLD_BG_PATH)
        if bg then
            GUI:setAnchorPoint(bg, 0, 0)
            local bgSize = GUI:getContentSize(bg)
            if bgSize and bgSize.width > 0 and bgSize.height > 0 then
                GUI:setScaleX(bg, GRAY_WORLD_PANEL_SIZE.width / bgSize.width)
                GUI:setScaleY(bg, GRAY_WORLD_PANEL_SIZE.height / bgSize.height)
            end
        end
        local line2 = GUI:Layout_Create(panel, "line_" .. 2, 100, 95, 100, 95, false)
        local line3 = GUI:Layout_Create(panel, "line_" .. 3, 0, 0, 100, 95, false)
        local line4 = GUI:Layout_Create(panel, "line_" .. 4, 100, 0, 100, 95, false)
        local line1 = GUI:Layout_Create(panel, "line_" .. 1, 0, 95, 100, 95, false)

        GUI:setContentSize(line1, 100, 95)
        GUI:setContentSize(line2, 100, 95)
        GUI:setContentSize(line3, 100, 95)
        GUI:setContentSize(line4, 100, 95)
        
        GUI:setAnchorPoint(GUI:Image_Create(line1, "zg", 0, 95, "res/custom/three_city/zerq/1.png"), 0, 1)
        GUI:setAnchorPoint(GUI:Image_Create(line2, "zg", 100, 95, "res/custom/three_city/zerq/2.png"), 1, 1)
        GUI:setAnchorPoint(GUI:Image_Create(line3, "zg", 0, 0, "res/custom/three_city/zerq/3.png"), 0, 0)
        GUI:setAnchorPoint(GUI:Image_Create(line4, "zg", 100, 0, "res/custom/three_city/zerq/4.png"), 1, 0)

        -- local lineY = 136
        -- for _, cfg in ipairs(GRAY_WORLD_LINES) do
        --     local lineImg = GUI:Image_Create(panel, "line_" .. tostring(cfg.idx), 6, lineY, cfg.skin)
        --     if lineImg then
        --         GUI:setAnchorPoint(lineImg, 0, 0.5)
        --         GUI:setScale(lineImg, GRAY_WORLD_LINE_SCALE)
        --     end
        --     lineY = lineY - 26
        -- end

        -- for _, region in ipairs(GRAY_WORLD_TOUCH_REGIONS) do
        --     local touchRoot = GUI:Layout_Create(panel, "line_touch_root_" .. tostring(region.idx), region.x, region.y, region.width, region.height, true)
        --     if touchRoot then
        --         GUI:setAnchorPoint(touchRoot, 0, 0)
        --         GUI:setTouchEnabled(touchRoot, false)

        --         local btn = GUI:Button_Create(touchRoot, "line_touch_" .. tostring(region.idx), region.btnX, region.btnY, GRAY_WORLD_TOUCH_SKIN)
        --         if btn then
        --             GUI:setAnchorPoint(btn, 0.5, 0.5)
        --             GUI:setRotation(btn, region.rotation or 0)
        --             GUI:setContentSize(btn, region.btnWidth, region.btnHeight)
        --             GUI:addOnClickEvent(btn, function()
        --                 SL:SendLuaNetMsg(100, 46, 2, region.idx, "")
        --             end)
        --         end
        --     end
        -- end

        MainAssist._grayWorldTaskIcon = panel
        return panel
    end


    function MainAssist.UpdateGrayWorldTaskIcon(eventData)
        if type(eventData) == "table" then
            MainAssist._grayWorldLastMapEvent = {
                mapID = tostring(eventData.mapID or ""),
                lastMapID = tostring(eventData.lastMapID or ""),
            }
        end
        local panel = _ensure_gray_world_icon()
        if not panel then
            MainAssist._grayWorldTaskIconPendingRefresh = true
            return
        end
        MainAssist._grayWorldTaskIconPendingRefresh = false
        _gray_world_refresh_panel(panel)
        GUI:setVisible(panel, _is_gray_world_map(eventData or MainAssist._grayWorldLastMapEvent))
    end

    function MainAssist.RequestGrayWorldTaskIconRefresh(eventData)
        if type(eventData) == "table" then
            MainAssist._grayWorldLastMapEvent = {
                mapID = tostring(eventData.mapID or ""),
                lastMapID = tostring(eventData.lastMapID or ""),
            }
        end

        if MainAssist._grayWorldTaskIconTimer then
            return
        end

        local schedulerNode = MainAssist._ui and MainAssist._ui["Panel_assist"]
        if not schedulerNode then
            MainAssist._grayWorldTaskIconPendingRefresh = true
            MainAssist.UpdateGrayWorldTaskIcon(eventData or MainAssist._grayWorldLastMapEvent)
            return
        end

        MainAssist._grayWorldTaskIconTimer = SL:scheduleOnce(schedulerNode, function()
            MainAssist._grayWorldTaskIconTimer = nil
            MainAssist.UpdateGrayWorldTaskIcon(MainAssist._grayWorldLastMapEvent)
        end, 0.05)
    end

    local function _go_to_current_xyl_task()
        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            SL:ShowSystemTips("当前没有可前往的伏妖录任务")
            return
        end

        local task = info.task or {}
        local enable = (task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
        SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
            string.format('{"i":%d,"j":%d,"k":0,"z":%d}', info.i, info.j, info.z))
    end

    local function _get_xyl_current_task_desc(task)
        if type(task) ~= "table" then
            return "暂无任务简介"
        end

        _build_xyl_task_maps()

        local xylData = MainAssist._xylTaskData
        if type(xylData) == "table" and type(xylData.build_task_desc) == "function" then
            local ok, builtDesc = pcall(xylData.build_task_desc, task)
            if ok and type(builtDesc) == "string" and builtDesc ~= "" then
                return builtDesc
            end
        end

        return tostring(task.desc or task.wz or "暂无任务简介")
    end

    local function _xyl_append_reward_entries(outList, rewardList, seenMap)
        if type(rewardList) ~= "table" then
            return
        end
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and entry[1] ~= nil and entry[2] ~= nil then
                local key = tostring(entry[1])
                local count = tonumber(entry[2]) or 0
                if key ~= "" and count > 0 then
                    local pos = seenMap[key]
                    if pos then
                        outList[pos][2] = (tonumber(outList[pos][2]) or 0) + count
                    else
                        table.insert(outList, {entry[1], count})
                        seenMap[key] = #outList
                    end
                end
            end
        end
    end

    local function _xyl_normalize_title_reward_name(titleName)
        if type(titleName) ~= "string" then
            return ""
        end
        local rewardName = string.gsub(titleName, "^%s+", "")
        rewardName = string.gsub(rewardName, "%s+$", "")
        if rewardName == "" then
            return ""
        end
        local oldTitleName = string.match(rewardName, "^称号%[(.-)%]$")
        if type(oldTitleName) == "string" and oldTitleName ~= "" then
            rewardName = oldTitleName
        else
            rewardName = string.gsub(rewardName, "%[称号%]$", "")
        end
        return rewardName .. "[称号]"
    end

    local function _xyl_append_title_reward(outList, titleName, seenMap)
        local rewardName = _xyl_normalize_title_reward_name(titleName)
        if rewardName == "" then
            return
        end
        local pos = seenMap[rewardName]
        if pos then
            outList[pos][2] = math.max(tonumber(outList[pos][2]) or 0, 1)
        else
            table.insert(outList, {rewardName, 1})
            seenMap[rewardName] = #outList
        end
    end

    local function _xyl_is_title_reward_name(name)
        return type(name) == "string"
            and (string.find(name, "%[称号%]") ~= nil or string.match(name, "^称号%[.+%]$") ~= nil)
    end

    local function _xyl_trim_reward_display(rewardList)
        if type(rewardList) ~= "table" or #rewardList <= 0 then
            return {}
        end

        local titleRewards = {}
        local otherRewards = {}
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and _xyl_is_title_reward_name(entry[1]) then
                table.insert(titleRewards, entry)
            else
                table.insert(otherRewards, entry)
            end
        end

        local merged = {}
        for _, entry in ipairs(titleRewards) do
            table.insert(merged, entry)
        end
        for _, entry in ipairs(otherRewards) do
            table.insert(merged, entry)
        end

        local result = {}
        for i = 1, math.min(2, #merged) do
            result[i] = merged[i]
        end
        return result
    end

    local function _xyl_collect_task_reward_data(task)
        if type(task) ~= "table" then
            return {}
        end

        local rewardList = {}
        local seenMap = {}
        _xyl_append_reward_entries(rewardList, task.jl, seenMap)
        _xyl_append_reward_entries(rewardList, task.rwjl, seenMap)
        _xyl_append_reward_entries(rewardList, task.give, seenMap)
        _xyl_append_title_reward(rewardList, task.ch, seenMap)

        local relatedNpcIds = {}
        local function appendNpcId(npcId)
            npcId = tonumber(npcId)
            if npcId and npcId > 0 and not relatedNpcIds[npcId] then
                relatedNpcIds[npcId] = true
                local cfg = teshudata and teshudata["npc_" .. tostring(npcId)]
                if type(cfg) == "table" then
                    _xyl_append_reward_entries(rewardList, cfg.rwjl, seenMap)
                    _xyl_append_reward_entries(rewardList, cfg.jl, seenMap)
                    _xyl_append_reward_entries(rewardList, cfg.give, seenMap)
                    _xyl_append_title_reward(rewardList, cfg.ch, seenMap)
                end
            end
        end

        if type(task.tk) == "string" then
            appendNpcId(task.tk:match("^npc_(%d+)$"))
        end
        if type(task.yd) == "table" then
            appendNpcId(task.yd[3])
        end

        return _xyl_trim_reward_display(rewardList)
    end

    local function _close_current_xyl_detail()
        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            MainAssist._xylDetailPopupPos = GUI:getPosition(MainAssist._xylDetailPopup.root)
            GUI:removeFromParent(MainAssist._xylDetailPopup.root)
        end
        MainAssist._xylDetailPopup = nil
    end

    function _refresh_xyl_detail_popup_content()
        local popup = MainAssist._xylDetailPopup
        if not (popup and popup.root and popup.descHost) then
            return
        end

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            _close_current_xyl_detail()
            return
        end

        local taskDesc = _get_xyl_current_task_desc(info.task)
        local cacheKey = _get_xyl_current_task_cache_key(MainAssist._xylCurrentTask, info)
        if popup.descCacheKey == cacheKey and popup.descCacheText == taskDesc then
            return
        end

        GUI:removeAllChildren(popup.descHost)

        local okDesc, descNode = pcall(function()
            return GUI:RichText_Create(popup.descHost, "desc", 0, -6, taskDesc, 168, 14, "#f7f7de", 3, nil, nil)
        end)
        if okDesc and descNode then
            GUI:setAnchorPoint(descNode, 0, 1)
        else
            local plain = GUI:Text_Create(popup.descHost, "desc_plain", 0, -6, 16, "#f7f7de", taskDesc)
            GUI:setAnchorPoint(plain, 0, 1)
        end

        popup.descCacheKey = cacheKey
        popup.descCacheText = taskDesc
    end

    local function _open_current_xyl_detail()
        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            SL:ShowSystemTips("当前没有可查看的伏妖录任务")
            return
        end

        _close_current_xyl_detail()

        local parent = MainAssist._ui and MainAssist._ui["Panel_content"]
        if not parent then
            return
        end

        local root = GUI:Node_Create(parent, "Panel_ywl_detail_popup", DETAIL_POPUP_DEFAULT_POS.x, DETAIL_POPUP_DEFAULT_POS.y)
        GUI:setLocalZOrder(root, 99999)

        local bg = GUI:Image_Create(root, "bg", -10, 10, "res/wy/public/500-300.png")
        GUI:setContentSize(bg, 196, 182)
        GUI:setIgnoreContentAdaptWithSize(bg, false)
        GUI:setAnchorPoint(bg, 0, 1)
        bind_drag_popup_memory(bg, root, MainAssist, "_xylDetailPopupPos", DETAIL_POPUP_DEFAULT_POS)

        local desc = GUI:Text_Create(bg, "desc_wz", 12, 82 + 71, 18, "#FFFFFF", "任务简介")
        GUI:Text_enableUnderline(desc)
        GUI:Text_setFontName(desc, "fonts/font4.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)
        GUI:Text_Create(bg, "desc_wz_tip", 12 + 100, 82 + 71, 18, "#00FF00", "[可拖动]")


        MainAssist._xylDetailPopup = {
            root = root,
            bg = bg,
            descHost = desc,
            descCacheKey = nil,
            descCacheText = nil,
        }
        _refresh_xyl_detail_popup_content()
    end

    local function _ensure_xyl_current_widget()
        if MainAssist._xylCurrentWidget then
            return MainAssist._xylCurrentWidget
        end

        local assistUi = GUI:ui_delegate(MainAssist._ui["Panel_assist"])
        local parent = assistUi and assistUi.Panel_content or GUI:getChildByName(MainAssist._ui["Panel_assist"], "Panel_content")
        if not parent then
            return nil
        end

        local panel = GUI:Layout_Create(parent, "Panel_ywl_current", 1, 2, 200, 38, false)
        GUI:setLocalZOrder(panel, 999)
        GUI:setTouchEnabled(panel, true)

        local title = GUI:Text_Create(panel, "title", -5, 114, 16, "#F4E7B5", "当前任务：")
        GUI:setAnchorPoint(title, 0, 0.5)
        GUI:Text_enableOutline(title, "#110b05", 2)

        local nameText = GUI:Text_Create(panel, "name", 65, 114, 16, "#FFFFFF", "")
        GUI:setAnchorPoint(nameText, 0, 0.5)
        GUI:Text_enableOutline(nameText, "#110b05", 2)

        local rewardTitle = GUI:Text_Create(panel, "reward", 0, 70, 16, "#00FB00", "剧情\n奖励")
        GUI:setAnchorPoint(rewardTitle, 0, 0.5)
        GUI:Text_enableOutline(rewardTitle, "#110b05", 2)

        local rewardRoot = GUI:Node_Create(panel, "reward_root", 55, 45)

        local detailBtn = GUI:Button_Create(panel, "detail_btn", 5, 19, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(detailBtn, 0, 0.5)
        GUI:Button_setTitleText(detailBtn, "任务详情")
        GUI:Button_setTitleColor(detailBtn, "#F4E7B5")
        GUI:Button_setTitleFontSize(detailBtn, 14)
        GUI:Button_titleEnableOutline(detailBtn, "#110b05", 2)

        GUI:addOnClickEvent(detailBtn, function()
            if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
                _close_current_xyl_detail()
            else
                _open_current_xyl_detail()
            end
        end)

        local goBtn = GUI:Button_Create(panel, "go_btn", 145, 19, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(goBtn, 0.5, 0.5)
        GUI:Button_setTitleText(goBtn, "立即前往")
        GUI:Button_setTitleColor(goBtn, "#F4E7B5")
        GUI:Button_setTitleFontSize(goBtn, 14)
        GUI:Button_titleEnableOutline(goBtn, "#110b05", 2)
        GUI:addOnClickEvent(goBtn, function()
            _go_to_current_xyl_task()
        end)

        MainAssist._xylCurrentWidget = {
            panel = panel,
            nameText = nameText,
            rewardRoot = rewardRoot,
            rewardNode = nil,
            detailBtn = detailBtn,
            goBtn = goBtn,
        }
        return MainAssist._xylCurrentWidget
    end

    function MainAssist.UpdateCurrentXylTaskWidget()
        local widget = _ensure_xyl_current_widget()
        if not widget then
            return
        end

        MainAssist.UpdateGrayWorldTaskIcon()

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        local hasTask = info and info.name and info.name ~= ""
        GUI:setVisible(widget.panel, hasTask)
        if not hasTask then
            _close_current_xyl_detail()
            if widget.rewardNode then
                GUI:removeFromParent(widget.rewardNode)
                widget.rewardNode = nil
            end
            if MainAssist.ListView_mission then
                GUI:setContentSize(MainAssist.ListView_mission, 200, 185)
                GUI:setPosition(MainAssist.ListView_mission, 101, 94)
            end
            return
        end

        GUI:Text_setString(widget.nameText, tostring(info.name))
        GUI:Button_setTitleText(widget.goBtn, _get_xyl_current_task_action_text(info))
        if widget.rewardNode then
            GUI:removeFromParent(widget.rewardNode)
            widget.rewardNode = nil
        end

        local rewardData = _xyl_collect_task_reward_data(info.task)
        if #rewardData > 0 then
            local okReward, rewardNode = pcall(function()
                return ItemNumByTable_img_new(rewardData, nil, widget.rewardRoot)
            end)
            if okReward and rewardNode then
                GUI:setPosition(rewardNode, 0, 0)
                widget.rewardNode = rewardNode
            end
        end

        if MainAssist.ListView_mission then
            GUI:setContentSize(MainAssist.ListView_mission, 200, 145)
            GUI:setPosition(MainAssist.ListView_mission, 101, 114)
        end
    end

    function MainAssist.PrintXylTaskName(data)
        if type(data) ~= "table" or tonumber(data.taskid) ~= 22 then
            return
        end

        local xylNameMap, xylDqMap = _build_xyl_task_maps()
        local xylTaskId = _get_xyl_task_id(data)
        local xylTaskDq = _get_xyl_task_dq(data)
        local printKey = tostring(xylTaskId or "") .. "|" .. tostring(xylTaskDq or "")
        if MainAssist._xylLastPrintTaskKey == printKey then
            return
        end

        local taskName = xylTaskId and xylNameMap[xylTaskId] or nil
        if not taskName and xylTaskId then
            local cfg = teshudata and teshudata["npc_" .. tostring(xylTaskId)]
            taskName = cfg and cfg.name or ("npc_" .. tostring(xylTaskId))
        end

        if not taskName and xylTaskDq then
            taskName = xylDqMap[xylTaskDq]
        end

        if not taskName then
            return
        end

        MainAssist._xylLastPrintTaskKey = printKey

        return
    end

    function MainAssist.RefreshXylTaskOnCurrentChange(data)
        if type(data) ~= "table" then
            return
        end
        local oldKey = _get_xyl_current_task_cache_key(MainAssist._xylCurrentTask)
        MainAssist._xylCurrentTask = data
        _debug_xyl_trace("当前任务变更", data)
        MainAssist.UpdateCurrentXylTaskWidget()
        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            _refresh_xyl_detail_popup_content()
        end
        local newKey = _get_xyl_current_task_cache_key(MainAssist._xylCurrentTask)
        if oldKey ~= newKey then
            for _, cell in pairs(MainAssist._missionCells or {}) do
                if cell and type(cell.data) == "table" and tonumber(cell.data.taskid) == 22 then
                    MainAssist.PrintXylTaskName(cell.data)
                    break
                end
            end
        end
    end

    function MainAssist.RefreshXylDynamicContent()
        _request_xyl_dynamic_refresh()
    end

    function MainAssist.RefreshXylOnServerValueChange()
        MainAssist.RefreshXylDynamicContent()
        MainAssist.RequestGrayWorldTaskIconRefresh()
    end

    function MainAssist.RefreshXylOnBagItemChange()
        MainAssist.RefreshXylDynamicContent()
        MainAssist.RequestGrayWorldTaskIconRefresh()
    end
end

return MainAssistXylHelper
