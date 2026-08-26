local MainAssistXylHelper = {}

-- 备注：伏妖录当前任务变更事件名。
MainAssistXylHelper.EVENT_CURRENT_TASK_CHANGE = "伏妖录当前任务变更"

local DETAIL_POPUP_DEFAULT_POS = {x = 220, y = 130}
local XYL_DYNAMIC_REFRESH_DELAY = 0.2
local XYL_CURRENT_TASK_WIDGET_VISIBLE = false
local GRAY_WORLD_PANEL_POS = {x = 40, y = 0}
local GRAY_WORLD_BG_PATH = "res/wy/eff/npc_but_bj_1.png"
local GRAY_WORLD_BG_PATH_1 = "res/wy/public/45.png"
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
local GRAY_WORLD_SINGLE_TEXT_POS = {x = 6, y = 220}
local GRAY_WORLD_SINGLE_STEP_TEXT_Y = 170
local GRAY_WORLD_SINGLE_TAOFA_TEXT_Y = 170
local GRAY_WORLD_SINGLE_TEXT_SECONDARY_X = 30
local GRAY_WORLD_SINGLE_TEXT_FONT_SIZE = 20
local GRAY_WORLD_SINGLE_REDPOINT_POS = {x = 194, y = 184}
local GRAY_WORLD_SINGLE_FLOW_POS = {x = 56, y = 176}
local GRAY_WORLD_SINGLE_FLOW_WIDTH = 136
local GRAY_WORLD_SINGLE_FLOW_FONT_SIZE = 13
local GRAY_WORLD_FINAL_BTN_POS = {x = 100, y = 95}
local GRAY_WORLD_FINAL_BTN_TEXT = ""
local XYL_FINAL_ENTRY_RWID = 36
local XYL_FINAL_ENTRY_BTN_TEXT = "更多剧情"
local GRAY_WORLD_LINE_MAP_ALIASES = {
    ["虚妄山脉"] = 4,
    ["山脉入口"] = 4,
    ["叹息旷野"] = 2,
    ["恐怖裂隙"] = 2,
    ["鬼嘲深渊"] = 1,
    ["旷野之原"] = 1,
    ["禁忌之海"] = 3,
    ["海峰孤岛"] = 3,
    ["讨伐嘲灾"] = 1,
    ["讨伐息灾"] = 2,
    ["讨伐忌灾"] = 3,
    ["讨伐妄灾"] = 4,
}
local GRAY_WORLD_LINE_SUFFIX_ALIASES = {
    ["_npc625"] = 1,
    ["_npc626"] = 2,
    ["_npc627"] = 3,
    ["_npc628"] = 4,
}
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
    ["山脉入口"] = true,
    ["鬼嘲深渊"] = true,
    ["旷野之原"] = true,
    ["叹息旷野"] = true,
    ["恐怖裂隙"] = true,
    ["禁忌之海"] = true,
    ["海峰孤岛"] = true,
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
local GRAY_WORLD_MAP_KEYWORDS = {"灰界", "虚妄山脉", "山脉入口", "鬼嘲深渊", "旷野之原", "叹息旷野", "恐怖裂隙", "禁忌之海", "海峰孤岛", "讨伐嘲灾", "讨伐忌灾", "讨伐息灾", "讨伐妄灾"}
local GRAY_WORLD_MAP_SUFFIXES = {
    "_npc625",
    "_npc626",
    "_npc627",
    "_npc628",
}
local GRAY_WORLD_LINE_MAP_CACHE = nil
local REWARD_ITEM_EFFECT_13054 = 13054
local MAINLINE_CURRENT_TASK_REWARD_CONFIG = {
    [2] = {{"天书残卷一", 1}},
    [5] = {{"天书残卷二", 1}},
    [6] = {{"玫瑰花", 20}},
    [8] = {{"天书残卷三", 1}},
    [11] = {{"天书残卷四", 1}},
    [13] = {{"绑定金币", 100000},{"天书", 1}},
    [14] = {{"绑定金币", 100000}, {"一重转生石", 10}},
    [17] = {{"仙法卷轴", 1}},
    [19] = {{"野火燎原[称号]", 1}},
    [20] = {{"1元真实充值", 1}},
    [21] = {{"除魔卫道[称号]", 1}},
    [22] = {},
    [23] = {{"聚宝盆", 1}},
    [25] = {{"1元真实充值", 1}, {"绑定金币", 200000}, {"称号卷轴", 5}},
    [27] = {{"绑定金币", 300000}, {"千年玄铁", 30}},
    [29] = {{"绑定金币", 150000}, {"摸金校尉[称号]", 1}},
    [30] = {{"1元真实充值", 1}, {"轩辕剑传人[称号]", 1}},
    [31] = {{"绑定金币", 150000}, {"玫瑰花", 50}},
    [33] = {{"绑定金币", 150000}, {"古刹魔瓶", 1}},
    [34] = {{"1元真实充值", 1}, {"仙法卷轴", 1}},
}

local function _get_mainline_rwid_value()
    local rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid or 0) or 0
    if rwid <= 0 then
        rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.zxrwid or 0) or 0
    end
    if rwid > 0 then
        return rwid
    end
    if Player and type(Player.getServerVar) == "function" then
        rwid = tonumber(Player:getServerVar("U11") or 0) or 0
        if rwid <= 0 then
            rwid = tonumber(Player:getServerVar("U_zxrw") or 0) or 0
        end
    end
    return rwid
end

local function _is_mainline_final_entry_open_value()
    return _get_mainline_rwid_value() >= XYL_FINAL_ENTRY_RWID
end

local function _resolve_reward_effect_parent(parent)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local preferredNames = {"kuang", "box", "slot", "item_bg", "itemBg", "itembg", "frame", "bg"}
    for _, childName in ipairs(preferredNames) do
        local child = GUI:getChildByName(parent, childName)
        if child and not tolua.isnull(child) then
            return child
        end
    end
    return parent
end

local function _raise_reward_item_icon(parent)
    if not parent or tolua.isnull(parent) then
        return
    end
    local itemLayer = GUI:getChildByName(parent, "item_layer")
    if itemLayer and not tolua.isnull(itemLayer) then
        GUI:setLocalZOrder(itemLayer, 20)
        parent = itemLayer
    end
    local item = GUI:getChildByName(parent, "item")
    if item and not tolua.isnull(item) then
        GUI:setLocalZOrder(item, 20)
    end
    for i = 1, 20 do
        local itemN = GUI:getChildByName(parent, "item" .. i)
        if itemN and not tolua.isnull(itemN) then
            GUI:setLocalZOrder(itemN, 20)
        end
    end
end

local function _add_reward_item_effect(parent, name, x, y, scale, effectId)
    local effectParent = _resolve_reward_effect_parent(parent)
    if not effectParent then
        return nil
    end
    local effect = GUI:Effect_Create(effectParent, name or "reward_item_eff", x or 0, y or 0, 0, effectId or REWARD_ITEM_EFFECT_13054, 0, 0, 0, 1)
    GUI:setScale(effect, scale or 1)
    GUI:setLocalZOrder(effect, 5)
    _raise_reward_item_icon(effectParent)
    return effect
end

local function _add_reward_effect_for_table(node, effectName, x, y, scale, effectId)
    if not node or tolua.isnull(node) then
        return
    end
    local listView = GUI:getChildByName(node, "cllist")
    if not listView or tolua.isnull(listView) then
        return
    end
    local children = GUI:getChildren(listView) or {}
    for _, child in pairs(children) do
        if child and not tolua.isnull(child) then
            _add_reward_item_effect(child, effectName, x, y, scale, effectId)
        end
    end
end

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
    local function _safe_set_visible(target, visible)
        if target and not tolua.isnull(target) then
            GUI:setVisible(target, visible)
        end
    end

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
        local autoClaim = type(info) == "table" and tonumber(info.i or 0) == 2
        local task = type(info) == "table" and info.task or nil
        local canClaim = (not autoClaim and type(task) == "table" and task.need_receive ~= false and task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
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

    local _refresh_xyl_detail_popup_content

    local function _flush_xyl_dynamic_content()
        MainAssist._xylDynamicRefreshTimer = nil
        if not MainAssist._xylCurrentTask then
            return
        end

        MainAssist.UpdateCurrentXylTaskWidget()

        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root and _refresh_xyl_detail_popup_content then
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

    local function _gray_world_is_gray_map_id(mapId)
        mapId = tostring(mapId or "")
        if mapId == "" then
            return false
        end
        return GRAY_WORLD_MAP_IDS[mapId] == true
    end

    local function _gray_world_to_num(value, defaultValue)
        local num = tonumber(value)
        if num == nil then
            return defaultValue or 0
        end
        return num
    end
    local _gray_world_get_cfg

    local function _gray_world_get_current_map_name()
        local mapName = tostring(SL:GetMetaValue("MAP_NAME") or "")
        if mapName ~= "" then
            return mapName
        end
        local eventData = MainAssist._grayWorldLastMapEvent
        if type(eventData) == "table" and type(eventData.mapName) == "string" then
            return eventData.mapName
        end
        return ""
    end

    local function _gray_world_build_line_map_cache()
        if GRAY_WORLD_LINE_MAP_CACHE then
            return GRAY_WORLD_LINE_MAP_CACHE
        end
        local mapCache = {}
        for _, routeCfg in ipairs(GRAY_WORLD_ROUTE_CONFIGS) do
            local stepCfg = _gray_world_get_cfg(routeCfg.step)
            local mapName = stepCfg and stepCfg.map
            if type(mapName) == "string" and mapName ~= "" then
                mapCache[mapName] = routeCfg.idx
            end
        end
        GRAY_WORLD_LINE_MAP_CACHE = mapCache
        return mapCache
    end

    local function _gray_world_get_line_idx_by_map(mapName)
        mapName = tostring(mapName or "")
        if mapName == "" then
            return nil
        end
        local aliasIdx = GRAY_WORLD_LINE_MAP_ALIASES[mapName]
        if aliasIdx then
            return aliasIdx
        end
        for _, suffix in ipairs(GRAY_WORLD_MAP_SUFFIXES) do
            if string.find(mapName, suffix, 1, true) ~= nil then
                local alias = GRAY_WORLD_LINE_SUFFIX_ALIASES[suffix]
                if alias then
                    return alias
                end
                local npcKey = "npc_" .. string.sub(suffix, 5)
                for _, routeCfg in ipairs(GRAY_WORLD_ROUTE_CONFIGS) do
                    if routeCfg.boss == npcKey then
                        return routeCfg.idx
                    end
                end
            end
        end
        local mapCache = _gray_world_build_line_map_cache()
        local idx = mapCache[mapName]
        if idx then
            return idx
        end
        for key, value in pairs(mapCache) do
            if string.find(mapName, key, 1, true) ~= nil then
                return value
            end
        end
        return nil
    end

    local function _gray_world_is_suffix_map(mapName)
        mapName = tostring(mapName or "")
        if mapName == "" then
            return false
        end
        for _, suffix in ipairs(GRAY_WORLD_MAP_SUFFIXES) do
            if string.find(mapName, suffix, 1, true) ~= nil then
                return true
            end
        end
        return false
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

    _gray_world_get_cfg = function(key)
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

    local function _gray_world_build_route_state(routeCfg, jqData, sgData, mapName, mapFile)
        local stepCfg = _gray_world_get_cfg(routeCfg.step)
        local bossCfg = _gray_world_get_cfg(routeCfg.boss)
        local stepState = _gray_world_to_num(jqData[routeCfg.step], 0)
        local bossState = _gray_world_to_num(jqData[routeCfg.boss], 0)
        local prepState = _gray_world_to_num(jqData[routeCfg.boss .. "_rw"], 0)
        local prepCfg = type(bossCfg.prep_task) == "table" and bossCfg.prep_task or {}

        if bossState >= 2 then
            return {
                idx = routeCfg.idx,
                order = routeCfg.order,
                statusText = "已讨伐",
                canJump = false,
                showRedPoint = false,
                completed = true,
                stepTitle = tostring(stepCfg.name or routeCfg.step),
                stepState = stepState,
                stepCurrent = _gray_world_to_num(sgData[routeCfg.step], 0),
                stepNeed = _gray_world_to_num(stepCfg.num, 0),
                prepTitle = tostring(prepCfg.name or ""),
                prepState = prepState,
                bossTitle = tostring(bossCfg.name or routeCfg.boss),
                bossState = bossState,
            }
        end

        mapName = tostring(mapName or "")
        mapFile = tostring(mapFile or "")
        local fbMap = bossCfg and tostring(bossCfg.fb_map or "") or ""
        local inFbMap = fbMap ~= "" and (
            string.find(mapName, fbMap, 1, true) ~= nil
            or string.find(mapFile, fbMap, 1, true) ~= nil
        )

        if stepState < 2 then
            return {
                idx = routeCfg.idx,
                order = routeCfg.order,
                statusText = tostring(stepCfg.name or routeCfg.step),
                canJump = not inFbMap,
                showRedPoint = _gray_world_is_step_claimable(stepCfg, stepState, sgData, routeCfg.step),
                completed = false,
                stepTitle = tostring(stepCfg.name or routeCfg.step),
                stepState = stepState,
                stepCurrent = _gray_world_to_num(sgData[routeCfg.step], 0),
                stepNeed = _gray_world_to_num(stepCfg.num, 0),
                prepTitle = tostring(prepCfg.name or ""),
                prepState = prepState,
                bossTitle = tostring(bossCfg.name or routeCfg.boss),
                bossState = bossState,
                inBossMap = inFbMap,
            }
        end

        return {
            idx = routeCfg.idx,
            order = routeCfg.order,
            statusText = inFbMap and "[讨伐中]" or tostring(bossCfg.name or routeCfg.boss),
            canJump = not inFbMap,
            showRedPoint = _gray_world_is_boss_prep_claimable(bossCfg, prepState, sgData, routeCfg.boss),
            completed = false,
            stepTitle = tostring(stepCfg.name or routeCfg.step),
            stepState = stepState,
            stepCurrent = _gray_world_to_num(sgData[routeCfg.step], 0),
            stepNeed = _gray_world_to_num(stepCfg.num, 0),
            prepTitle = tostring(prepCfg.name or ""),
            prepState = prepState,
            bossTitle = tostring(bossCfg.name or routeCfg.boss),
            bossState = bossState,
            inBossMap = inFbMap,
        }
    end

    local function _gray_world_get_route_cfg_by_idx(routeIdx)
        for _, routeCfg in ipairs(GRAY_WORLD_ROUTE_CONFIGS) do
            if routeCfg.idx == routeIdx then
                return routeCfg
            end
        end
        return nil
    end

    local function _gray_world_get_prep_progress_desc(routeCfg, routeState, sgData)
        local bossCfg = _gray_world_get_cfg(routeCfg.boss)
        local prepCfg = type(bossCfg.prep_task) == "table" and bossCfg.prep_task or {}
        local prepDone = routeState.bossState >= 2 or routeState.prepState >= 2
        local baseName = tostring(prepCfg.name or routeState.prepTitle or "")

        if routeCfg.boss == "npc_625" then
            local progressName = tostring(prepCfg.progress_name or baseName)
            local current = _gray_world_to_num((sgData or {})[routeCfg.boss .. "_rw"], 0)
            local need = _gray_world_to_num(prepCfg.need, 0)
            return {
                title = baseName ~= "" and baseName or "关键任务",
                desc = string.format("完成%s", progressName ~= "" and progressName or baseName),
                progress = need > 0 and string.format("%d/%d", current, need) or tostring(current),
                completed = prepDone,
            }
        end

        if routeCfg.boss == "npc_626" or routeCfg.boss == "npc_627" then
            local itemName = tostring(prepCfg.item_name or baseName)
            local current = _gray_world_get_bag_count(itemName)
            local need = _gray_world_to_num(prepCfg.need, 0)
            return {
                title = baseName ~= "" and baseName or "关键任务",
                desc = string.format("收集%s", itemName ~= "" and itemName or baseName),
                progress = need > 0 and string.format("%d/%d", current, need) or tostring(current),
                completed = prepDone,
            }
        end

        if routeCfg.boss == "npc_628" then
            local leftName = tostring(prepCfg.left_name or "")
            local rightName = tostring(prepCfg.right_name or "")
            local leftCurrent = _gray_world_get_bag_count(leftName)
            local rightCurrent = _gray_world_get_bag_count(rightName)
            local leftNeed = _gray_world_to_num(prepCfg.left_need, 0)
            local rightNeed = _gray_world_to_num(prepCfg.right_need, 0)
            return {
                title = baseName ~= "" and baseName or "关键任务",
                desc = string.format("收集%s", baseName ~= "" and baseName or "关键任务"),
                progress = string.format("%s %d/1\n%s %d/1", leftName ~= "" and leftName or "真视之眼左", math.min(1, leftCurrent), rightName ~= "" and rightName or "真视之眼右", math.min(1, rightCurrent)),
                completed = prepDone,
            }
        end

        return {
            title = baseName ~= "" and baseName or "关键任务",
            desc = baseName ~= "" and baseName or "关键任务",
            progress = "",
            completed = prepDone,
        }
    end

    local function _gray_world_is_task46_done(jqData)
        local task46 = type(jqData) == "table" and jqData["npc_46"] or nil
        if type(task46) == "table" then
            return _gray_world_to_num(task46.wc, 0) >= 1
        end
        return _gray_world_to_num(task46, 0) >= 1
    end

    local function _gray_world_build_single_flow_html(routeState)
        local routeCfg = _gray_world_get_route_cfg_by_idx(routeState.idx)
        if not routeCfg then
            return ""
        end

        local _, sgData = _gray_world_get_runtime_data()
        local prepDesc = _gray_world_get_prep_progress_desc(routeCfg, routeState, sgData)

        local stepTitle = tostring(routeState.stepTitle or "")
        local stepNeed = _gray_world_to_num(routeState.stepNeed, 0)
        local stepCurrent = _gray_world_to_num(routeState.stepCurrent, 0)
        local stepCompleted = routeState.stepState >= 2
        local stepStatus
        if stepCompleted then
            stepStatus = "<font color='#00FF00'>[已完成]</font>"
        elseif _gray_world_to_num(routeState.stepState, 0) <= 0 then
            stepStatus = "<font color='#ff3030'>[未领取任务]</font>"
        else
            stepStatus = string.format("<font color='#f7f7de'>当前进度：</font><font color='#ffe066'>%d/%d</font>", stepCurrent, stepNeed)
        end

        local prepStatus
        if prepDesc.completed then
            prepStatus = "<font color='#00FF00'>[已完成]</font>"
        elseif _gray_world_to_num(routeState.prepState, 0) <= 0 then
            prepStatus = string.format("<font color='#f7f7de'>%s</font>\n<font color='#ff3030'>[未领取任务]</font>", tostring(prepDesc.desc or ""))
        elseif routeCfg.boss == "npc_628" then
            prepStatus = string.format("<font color='#ffe066'>%s</font>", tostring(prepDesc.progress or "0/0"))
        else
            prepStatus = string.format("<font color='#f7f7de'>%s</font>\n<font color='#f7f7de'>当前进度：</font><font color='#ffe066'>%s</font>", tostring(prepDesc.desc or ""), tostring(prepDesc.progress or "0/0"))
        end

        local bossTitle = tostring(routeState.bossTitle or routeState.statusText or "")
        local bossStatus = routeState.bossState >= 2
            and "<font color='#00FF00'>[已讨伐]</font>"
            or (routeState.inBossMap and "<font color='#FFFF00'>[讨伐中]</font>" or "<font color='#ff3030'>[未讨伐]</font>")

        return table.concat({
            string.format("<font color='#fff3a6'>[%s]</font>", stepTitle),
            stepStatus,
            "",
            "<font color='#FF00FF'>[关键任务]</font>",
            prepStatus,
            "",
            string.format("<font color='#00FFFF'>[%s]</font>", bossTitle),
            bossStatus,
        }, "\n")
    end

    local function _gray_world_build_route_state_key(routeState)
        return table.concat({
            tostring(routeState.idx or 0),
            tostring(routeState.statusText or ""),
            routeState.canJump and "1" or "0",
            routeState.showRedPoint and "1" or "0",
            routeState.completed and "1" or "0",
            tostring(routeState.stepTitle or ""),
            tostring(routeState.stepState or 0),
            tostring(routeState.stepCurrent or 0),
            tostring(routeState.stepNeed or 0),
            tostring(routeState.prepTitle or ""),
            tostring(routeState.prepState or 0),
            tostring(routeState.bossTitle or ""),
            tostring(routeState.bossState or 0),
            routeState.inBossMap and "1" or "0",
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
        return nil, text
    end

    local function _gray_world_get_text_color(routeState)
        local text = tostring(routeState and routeState.statusText or "")
        if routeState and routeState.completed then
            return "#00FF00"
        end
        if text == "[讨伐中]" then
            return "#FFFF00"
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
                primaryY = GRAY_WORLD_TOP_TEXT_POS.y,
                secondaryX = GRAY_WORLD_TOP_TEXT_SECONDARY_X,
                secondaryY = GRAY_WORLD_TOP_TEXT_POS.y - 10,
            }
        end

        return {
            primaryX = GRAY_WORLD_TEXT_POS.x,
            primaryY = GRAY_WORLD_TEXT_POS.y,
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

    local function _gray_world_update_panel_bg(panel, path)
        if not panel then
            return
        end
        local bg = GUI:getChildByName(panel, "bg")
        if not bg then
            return
        end
        path = tostring(path or "")
        if path == "" or panel._grayWorldBgPath == path then
            return
        end
        GUI:Image_loadTexture(bg, path)
        local bgSize = GUI:getContentSize(bg)
        if bgSize and bgSize.width > 0 and bgSize.height > 0 then
            GUI:setScaleX(bg, GRAY_WORLD_PANEL_SIZE.width / bgSize.width)
            GUI:setScaleY(bg, GRAY_WORLD_PANEL_SIZE.height / bgSize.height)
        end
        panel._grayWorldBgPath = path
    end

    local function _gray_world_update_single_text(panel, routeState)
        if not panel then
            return
        end
        local text1 = GUI:getChildByName(panel, "single_status_text")
        local text2 = GUI:getChildByName(panel, "single_status_text_2")
        local rich = GUI:getChildByName(panel, "single_flow_text")
        local html = _gray_world_build_single_flow_html(routeState)
        local prefixText, suffixText = _gray_world_split_step_text(routeState.statusText or "")
        local textColor = _gray_world_get_text_color(routeState)
        local titleY = string.match(tostring(routeState.statusText or ""), "^讨伐") and GRAY_WORLD_SINGLE_TAOFA_TEXT_Y or GRAY_WORLD_SINGLE_STEP_TEXT_Y

        if not text1 then
            text1 = GUI:Text_Create(panel, "single_status_text", GRAY_WORLD_SINGLE_TEXT_POS.x, titleY, GRAY_WORLD_SINGLE_TEXT_FONT_SIZE, "#FFFFFF", "")
            GUI:setAnchorPoint(text1, 0, 1)
            GUI:Text_setFontName(text1, "fonts/font4.ttf")
            GUI:Text_enableOutline(text1, "#000000", 2)
        end
        if not text2 then
            text2 = GUI:Text_Create(panel, "single_status_text_2", GRAY_WORLD_SINGLE_TEXT_SECONDARY_X, titleY, GRAY_WORLD_SINGLE_TEXT_FONT_SIZE, "#FFFFFF", "")
            GUI:setAnchorPoint(text2, 0, 1)
            GUI:Text_setFontName(text2, "fonts/font4.ttf")
            GUI:Text_enableOutline(text2, "#000000", 2)
        end

        if text1 then
            GUI:setPosition(text1, GRAY_WORLD_SINGLE_TEXT_POS.x, titleY)
            GUI:Text_setTextColor(text1, textColor)
            GUI:setVisible(text1, prefixText ~= nil)
        end
        if text2 then
            GUI:setPosition(text2, GRAY_WORLD_SINGLE_TEXT_SECONDARY_X, titleY)
            GUI:Text_setTextColor(text2, textColor)
            GUI:setVisible(text2, true)
        end

        if prefixText then
            GUI:Text_setString(text1, _gray_world_vertical_text(prefixText))
            GUI:Text_setString(text2, _gray_world_vertical_text(suffixText))
        else
            if text1 then
                GUI:Text_setString(text1, "")
            end
            GUI:Text_setString(text2, _gray_world_vertical_text(tostring(routeState.statusText or "")))
        end

        if rich then
            GUI:removeFromParent(rich)
        end

        rich = GUI:RichText_Create(
            panel,
            "single_flow_text",
            GRAY_WORLD_SINGLE_FLOW_POS.x,
            GRAY_WORLD_SINGLE_FLOW_POS.y,
            html,
            GRAY_WORLD_SINGLE_FLOW_WIDTH,
            GRAY_WORLD_SINGLE_FLOW_FONT_SIZE,
            "#f7f7de",
            4,
            nil,
            nil,
            -- "fonts/font4.ttf",
            {outlineSize = 2, outlineColor = "#000000"}
        )
        if rich then
            GUI:setAnchorPoint(rich, 0, 1)
        end
    end

    local function _gray_world_update_single_redpoint(panel, routeState)
        if not panel then
            return
        end
        local redPoint = GUI:getChildByName(panel, "single_redpoint")
        if routeState.showRedPoint then
            if not redPoint then
                redPoint = NPC_UI_HELPER.redpoint_create(panel, {
                    name = "single_redpoint",
                    x = GRAY_WORLD_SINGLE_REDPOINT_POS.x,
                    y = GRAY_WORLD_SINGLE_REDPOINT_POS.y,
                    anchorX = 1,
                    anchorY = 1,
                })
            end
            if redPoint then
                GUI:setVisible(redPoint, true)
                GUI:setPosition(redPoint, GRAY_WORLD_SINGLE_REDPOINT_POS.x, GRAY_WORLD_SINGLE_REDPOINT_POS.y)
            end
        elseif redPoint then
            GUI:setVisible(redPoint, false)
        end
    end

    local function _gray_world_update_final_guide_btn(panel, show)
        if not panel then
            return
        end
        local btn = GUI:getChildByName(panel, "gray_world_final_btn")
        if show then
            if not btn then
                btn = NPC_UI_HELPER.createPrimaryButton(panel, "gray_world_final_btn", GRAY_WORLD_FINAL_BTN_POS.x, GRAY_WORLD_FINAL_BTN_POS.y, GRAY_WORLD_FINAL_BTN_TEXT, function()
                    SL:SendLuaNetMsg(100, 46, 2, 5, "")
                end, {
                    skin = "res/custom/all_story_mission/5/689/list/l/4.png",
                    fontSize = 14,
                    color = "#F4E7B5",
                })
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                -- 去除迷雾前往苍云大陆
                local tipText = GUI:Text_Create(btn, "lock_tip", 162/2,164/2, 20, "#FF0000", "    去除迷雾\n前往苍云大陆")
                GUI:setAnchorPoint(tipText, 0.5, 0.5)
                GUI:Text_setFontName(tipText, "fonts/502.ttf")
                GUI:Text_enableOutline(tipText, "#000000", 2)
        
            end
            if btn then
                GUI:setVisible(btn, true)
                GUI:setPosition(btn, GRAY_WORLD_FINAL_BTN_POS.x, GRAY_WORLD_FINAL_BTN_POS.y)
            end
        elseif btn then
            GUI:setVisible(btn, false)
        end
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
        GUI:setVisible(lineText, true)

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

        local lineImg = GUI:getChildByName(line, "zg")
        if lineImg then
            GUI:Image_setGrey(lineImg, routeState.completed == true)
        end

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

    local function _gray_world_has_started_route(routeState)
        if type(routeState) ~= "table" or routeState.completed == true then
            return false
        end
        if _gray_world_to_num(routeState.stepState, 0) >= 1 and _gray_world_to_num(routeState.stepState, 0) < 2 then
            return true
        end
        if _gray_world_to_num(routeState.stepState, 0) >= 2 and _gray_world_to_num(routeState.bossState, 0) < 2 then
            return true
        end
        return false
    end

    local function _gray_world_request_guide(panel, routeStates, lineIdx, singleLineMode, finalGuideMode, firstRedPointIdx, isSuffixMap)
        if not panel then
            return false
        end

        if isSuffixMap then
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end

        if finalGuideMode then
            local finalBtn = GUI:getChildByName(panel, "gray_world_final_btn")
            if finalBtn and GUI:getVisible(finalBtn) then
                return NPC_UI_HELPER.requestGuide("gray_world", "gray_world_final_clear_fog", {
                    dir = 7,
                    guideWidget = finalBtn,
                    guideParent = panel,
                    guideDesc = "点击去除迷雾",
                    isForce = false,
                    hideMask = true,
                })
            end
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end

        if singleLineMode and lineIdx then
            local lineState = nil
            for _, routeState in ipairs(routeStates or {}) do
                if routeState.idx == lineIdx then
                    lineState = routeState
                    break
                end
            end
            if lineState and _gray_world_has_started_route(lineState) then
                return NPC_UI_HELPER.closeGuideByDomain("gray_world")
            end
            local singleBtn = GUI:getChildByName(panel, "single_touch_btn")
            if lineState and singleBtn and lineState.canJump == true and lineState.completed ~= true and MainAssist._grayWorldAllowOverviewGuide == true then
                local singleGuideKey = string.format("gray_world_line_%s_single", tostring(lineState.idx))
                return NPC_UI_HELPER.requestGuide("gray_world", singleGuideKey, {
                    dir = 7,
                    guideWidget = singleBtn,
                    guideParent = panel,
                    guideDesc = "当前任务",
                    isForce = false,
                    hideMask = true,
                })
            end
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end

        local targetIdx = firstRedPointIdx
        if not targetIdx then
            for _, routeState in ipairs(routeStates or {}) do
                if routeState.completed ~= true then
                    targetIdx = routeState.idx
                    break
                end
            end
        end
        if not targetIdx then
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end

        local lineNode = GUI:getChildByName(panel, "line_" .. tostring(targetIdx))
        local targetState = nil
        for _, routeState in ipairs(routeStates or {}) do
            if routeState.idx == targetIdx then
                targetState = routeState
                break
            end
        end
        if lineIdx and targetState and lineIdx == targetIdx and _gray_world_has_started_route(targetState) then
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end
        if MainAssist._grayWorldAllowOverviewGuide ~= true then
            return NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end
        local touchBtn = lineNode and GUI:getChildByName(lineNode, "touch_btn") or nil
        if touchBtn and GUI:getVisible(lineNode) then
            local overviewGuideKey = string.format("gray_world_line_%s_overview", tostring(targetIdx))
            return NPC_UI_HELPER.requestGuide("gray_world", overviewGuideKey, {
                dir = 7,
                guideWidget = touchBtn,
                guideParent = panel,
                guideDesc = "点击当前线任务",
                isForce = false,
                hideMask = true,
            })
        end
        return NPC_UI_HELPER.closeGuideByDomain("gray_world")
    end

    local function _gray_world_refresh_panel(panel)
        if not panel then
            return
        end
        local runtimeCacheKey = _gray_world_build_runtime_cache_key()
        local mapName = _gray_world_get_current_map_name()
        local lineIdx = _gray_world_get_line_idx_by_map(mapName)
        local viewKey = tostring(mapName) .. "|" .. tostring(lineIdx or "")
        if panel._grayWorldRuntimeCacheKey == runtimeCacheKey and panel._grayWorldViewKey == viewKey then
            return
        end

        local jqData, sgData = _gray_world_get_runtime_data()
        local mapFile = tostring(SL:GetMetaValue("MINIMAP_FILE") or "")
        local isSuffixMap = _gray_world_is_suffix_map(mapName)
        panel._grayWorldRouteStateCache = panel._grayWorldRouteStateCache or {}
        local routeStates = {}
        for _, routeCfg in ipairs(GRAY_WORLD_ROUTE_CONFIGS) do
            routeStates[#routeStates + 1] = _gray_world_build_route_state(routeCfg, jqData, sgData, mapName, mapFile)
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
            if isSuffixMap then
                routeState.canJump = false
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

        local allRoutesCompleted = true
        for _, routeState in ipairs(routeStates) do
            if not routeState.completed then
                allRoutesCompleted = false
                break
            end
        end
        panel._grayWorldAllRoutesCompleted = allRoutesCompleted == true
        local finalGuideMode = allRoutesCompleted and not _gray_world_is_task46_done(jqData)
        panel._grayWorldFinalGuideMode = finalGuideMode == true

        local singleLineMode = false
        if lineIdx then
            for _, routeState in ipairs(routeStates) do
                if routeState.idx == lineIdx then
                    singleLineMode = not routeState.completed
                    break
                end
            end
        end

        local zgNode = GUI:getChildByName(panel, "zg")
        if zgNode then
            GUI:setVisible(zgNode, (not singleLineMode) and (not finalGuideMode))
        end
        if finalGuideMode then
            _gray_world_update_panel_bg(panel, GRAY_WORLD_BG_PATH)
        elseif singleLineMode and lineIdx then
            _gray_world_update_panel_bg(panel, string.format("res/custom/three_city/zerq/x_%d.png", lineIdx))
        else
            _gray_world_update_panel_bg(panel, GRAY_WORLD_BG_PATH)
        end
        _gray_world_update_final_guide_btn(panel, finalGuideMode)
        if singleLineMode and lineIdx then
            local lineState = nil
            for _, routeState in ipairs(routeStates) do
                if routeState.idx == lineIdx then
                    lineState = routeState
                    break
                end
            end
            if lineState then
                local routeStateKey = _gray_world_build_route_state_key(lineState)
                local singleTextKey = routeStateKey .. "|" .. runtimeCacheKey
                if panel._grayWorldSingleTextKey ~= singleTextKey or panel._grayWorldViewKey ~= viewKey then
                    _gray_world_update_single_text(panel, lineState)
                    panel._grayWorldSingleTextKey = singleTextKey
                end
                _gray_world_update_single_redpoint(panel, lineState)
                local bgNode = GUI:getChildByName(panel, "bg")
                if bgNode then
                    GUI:Image_setGrey(bgNode, lineState.completed == true)
                end
                local singleBtn = GUI:getChildByName(panel, "single_touch_btn")
                if not singleBtn then
                    singleBtn = GUI:Button_Create(panel, "single_touch_btn", 0, 0, GRAY_WORLD_TOUCH_SKIN)
                    GUI:setAnchorPoint(singleBtn, 0, 0)
                    GUI:setContentSize(singleBtn, GRAY_WORLD_PANEL_SIZE.width, GRAY_WORLD_PANEL_SIZE.height)
                    GUI:addOnClickEvent(singleBtn, function()
                        if singleBtn._grayWorldCompleted then
                            return
                        end
                        SL:SendLuaNetMsg(100, 46, 2, singleBtn._grayWorldRouteIdx or 0, "")
                    end)
                end
                singleBtn._grayWorldRouteIdx = lineState.idx
                singleBtn._grayWorldCompleted = lineState.completed == true
                GUI:setTouchEnabled(singleBtn, lineState.canJump == true)
                GUI:Button_setBright(singleBtn, lineState.canJump == true)
                GUI:setVisible(singleBtn, true)
            end
        else
            local text1 = GUI:getChildByName(panel, "single_status_text")
            local text2 = GUI:getChildByName(panel, "single_status_text_2")
            if text1 then
                GUI:setVisible(text1, false)
            end
            if text2 then
                GUI:setVisible(text2, false)
            end
            local flowRich = GUI:getChildByName(panel, "single_flow_text")
            if flowRich then
                GUI:removeFromParent(flowRich)
            end
            local singleRed = GUI:getChildByName(panel, "single_redpoint")
            if singleRed then
                GUI:setVisible(singleRed, false)
            end
            local bgNode = GUI:getChildByName(panel, "bg")
            if bgNode then
                GUI:Image_setGrey(bgNode, false)
            end
            local singleBtn = GUI:getChildByName(panel, "single_touch_btn")
            if singleBtn then
                GUI:setVisible(singleBtn, false)
            end
            panel._grayWorldSingleTextKey = nil
        end

        for _, routeState in ipairs(routeStates) do
            local lineNode = GUI:getChildByName(panel, "line_" .. tostring(routeState.idx))
            if finalGuideMode then
                if lineNode then
                    GUI:setVisible(lineNode, false)
                end
            elseif singleLineMode and routeState.idx ~= lineIdx then
                if lineNode then
                    GUI:setVisible(lineNode, false)
                end
            else
                if lineNode then
                    GUI:setVisible(lineNode, true)
                end
                routeState.showRedPoint = routeState.showRedPoint and routeState.idx == firstRedPointIdx
                local routeStateKey = _gray_world_build_route_state_key(routeState)
                if panel._grayWorldRouteStateCache[routeState.idx] ~= routeStateKey or panel._grayWorldViewKey ~= viewKey then
                    _gray_world_update_line(panel, routeState)
                    panel._grayWorldRouteStateCache[routeState.idx] = routeStateKey
                end
                if lineNode then
                    local lineImg = GUI:getChildByName(lineNode, "zg")
                    if singleLineMode and routeState.idx == lineIdx then
                        if lineImg then
                            GUI:setVisible(lineImg, false)
                        end
                    elseif lineImg then
                        GUI:setVisible(lineImg, true)
                    end
                end
                if singleLineMode and routeState.idx == lineIdx and lineNode then
                    local lineText = GUI:getChildByName(lineNode, "status_text")
                    local lineText2 = GUI:getChildByName(lineNode, "status_text_2")
                    if lineText then
                        GUI:setVisible(lineText, false)
                    end
                    if lineText2 then
                        GUI:setVisible(lineText2, false)
                    end
                    local lineRed = GUI:getChildByName(lineNode, "redpoint")
                    if lineRed then
                        GUI:setVisible(lineRed, false)
                    end
                end
            end
        end
        _gray_world_request_guide(panel, routeStates, lineIdx, singleLineMode, finalGuideMode, firstRedPointIdx, isSuffixMap)
        panel._grayWorldRuntimeCacheKey = runtimeCacheKey
        panel._grayWorldViewKey = viewKey
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
        -- GUI:addMouseOverTips(bg, "", {x = 0, y = 0}, {x = 0, y = 0})
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

        GUI:setAnchorPoint(GUI:Image_Create(panel, "zg", 0, 0, "res/custom/three_city/zerq/line.png"), 0, 0)

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
        if _is_mainline_final_entry_open_value() then
            if MainAssist._grayWorldTaskIcon then
                GUI:setVisible(MainAssist._grayWorldTaskIcon, false)
            end
            NPC_UI_HELPER.closeGuideByDomain("gray_world")
            return
        end
        if type(eventData) == "table" then
            MainAssist._grayWorldLastMapEvent = {
                mapID = tostring(eventData.mapID or ""),
                lastMapID = tostring(eventData.lastMapID or ""),
            }
        end
        local currentEvent = eventData or MainAssist._grayWorldLastMapEvent
        local isGrayWorldMap = _is_gray_world_map(currentEvent)
        local currentMapName = _gray_world_get_current_map_name()
        local currentLineIdx = _gray_world_get_line_idx_by_map(currentMapName)
        local isOverviewMap = isGrayWorldMap and not currentLineIdx
        local lastIsGrayWorldMap = MainAssist._grayWorldPrevIsGrayMap == true
        if type(currentEvent) == "table" and tostring(currentEvent.lastMapID or "") ~= "" then
            lastIsGrayWorldMap = _gray_world_is_gray_map_id(currentEvent.lastMapID) or lastIsGrayWorldMap
        end
        MainAssist._grayWorldAllowOverviewGuide = type(eventData) == "table" and isOverviewMap and (not lastIsGrayWorldMap)

        local panel = _ensure_gray_world_icon()
        if not panel then
            MainAssist._grayWorldTaskIconPendingRefresh = true
            MainAssist._grayWorldPrevIsGrayMap = isGrayWorldMap
            return
        end
        MainAssist._grayWorldTaskIconPendingRefresh = false
        _gray_world_refresh_panel(panel)
        local shouldShowPanel = isGrayWorldMap and (panel._grayWorldAllRoutesCompleted ~= true or panel._grayWorldFinalGuideMode == true)
        GUI:setVisible(panel, shouldShowPanel)
        if not shouldShowPanel then
            NPC_UI_HELPER.closeGuideByDomain("gray_world")
        end
        MainAssist._grayWorldPrevIsGrayMap = isGrayWorldMap
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

        local autoClaim = tonumber(info.i or 0) == 2
        local task = info.task or {}
        local enable = (not autoClaim and task.need_receive ~= false and task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
        SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
            string.format('{"i":%d,"j":%d,"k":0,"z":%d}', info.i, info.j, info.z))
    end
    function MainAssist.HasCurrentXylTask()
        return _get_xyl_current_task_info(MainAssist._xylCurrentTask) ~= nil
    end
    MainAssist.GoToCurrentXylTask = _go_to_current_xyl_task

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

    local function _xyl_is_story_point_reward(name)
        return tostring(name or "") == "剧情点"
    end

    local function _xyl_is_unlock_linggen_reward(name)
        return type(name) == "string" and string.match(name, "^激活.+灵根$") ~= nil
    end

    local function _xyl_append_reward_entries(outList, rewardList, seenMap, opts)
        opts = opts or {}
        if type(rewardList) ~= "table" then
            return
        end
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and entry[1] ~= nil and entry[2] ~= nil then
                local key = tostring(entry[1])
                local count = tonumber(entry[2]) or 0
                if key ~= "" and count > 0 and not (opts.skipStoryPoint and _xyl_is_story_point_reward(key)) then
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

    local function _xyl_append_cfg_detail_rewards(outList, cfg, seenMap, opts)
        local details = type(cfg) == "table" and cfg.details or nil
        if type(details) ~= "table" then
            return
        end
        _xyl_append_reward_entries(outList, details.rwjl, seenMap, opts)
        _xyl_append_reward_entries(outList, details.give, seenMap, opts)
        _xyl_append_reward_entries(outList, details.jl, seenMap, opts)
        _xyl_append_title_reward(outList, details.ch, seenMap)
    end

    local function _xyl_is_title_reward_name(name)
        return type(name) == "string"
            and (string.find(name, "%[称号%]") ~= nil or string.match(name, "^称号%[.+%]$") ~= nil)
    end

    local function _xyl_trim_reward_display(rewardList)
        if type(rewardList) ~= "table" or #rewardList <= 0 then
            return {}
        end

        local result = {}
        for i = 1, math.min(2, #rewardList) do
            result[i] = rewardList[i]
        end
        return result
    end



    local function _xyl_prepare_reward_display_data(rewardList)
        if type(rewardList) ~= "table" then
            return {}
        end
        local result = {}
        for i, entry in ipairs(rewardList) do
            if type(entry) == "table" then
                local name = entry[1]
                if _xyl_is_unlock_linggen_reward(name) then
                    result[i] = {name}
                else
                    result[i] = entry
                end
            end
        end
        return result
    end

    local function _get_current_mainline_rwid()
        return _get_mainline_rwid_value()
    end

    local function _is_mainline_final_entry_open()
        return _is_mainline_final_entry_open_value()
    end

    local function _collect_mainline_reward_display_data()
        local rwid = _get_current_mainline_rwid()
        local rewardCfg = MAINLINE_CURRENT_TASK_REWARD_CONFIG[tonumber(rwid) or 0]
        if type(rewardCfg) ~= "table" or #rewardCfg <= 0 then
            return {}
        end
        local rewardList = {}
        for i, entry in ipairs(rewardCfg) do
            if type(entry) == "table" and entry[1] ~= nil then
                rewardList[i] = {entry[1], tonumber(entry[2]) or 1}
            end
        end
        return _xyl_prepare_reward_display_data(_xyl_trim_reward_display(rewardList))
    end

    local function _xyl_collect_task_reward_data(task, info)
        if type(task) ~= "table" then
            return {}
        end

        local rewardList = {}
        local seenMap = {}
        local rewardOpts = {skipStoryPoint = true}
        _xyl_append_reward_entries(rewardList, task.rwjl, seenMap, rewardOpts)
        _xyl_append_reward_entries(rewardList, task.give, seenMap, rewardOpts)
        _xyl_append_reward_entries(rewardList, task.jl, seenMap, rewardOpts)

        local relatedNpcIds = {}
        local function appendNpcId(npcId)
            npcId = tonumber(npcId)
            if npcId and npcId > 0 and not relatedNpcIds[npcId] then
                relatedNpcIds[npcId] = true
                local cfg = teshudata and teshudata["npc_" .. tostring(npcId)]
                if type(cfg) == "table" then
                    _xyl_append_reward_entries(rewardList, cfg.rwjl, seenMap, rewardOpts)
                    _xyl_append_reward_entries(rewardList, cfg.give, seenMap, rewardOpts)
                    _xyl_append_reward_entries(rewardList, cfg.jl, seenMap, rewardOpts)
                    _xyl_append_reward_entries(rewardList, cfg.artifact_reward, seenMap, rewardOpts)
                    _xyl_append_cfg_detail_rewards(rewardList, cfg, seenMap, rewardOpts)
                    _xyl_append_title_reward(rewardList, cfg.ch, seenMap)
                end
            end
        end

        if type(task.tk) == "string" then
            appendNpcId(task.tk:match("^npc_(%d+)$"))
        end
        if type(task.ydtk) == "string" then
            appendNpcId(task.ydtk:match("^npc_(%d+)$"))
        end
        if type(task.yd) == "table" then
            appendNpcId(task.yd[3])
        end

        _xyl_append_title_reward(rewardList, task.ch, seenMap)
        return _xyl_prepare_reward_display_data(_xyl_trim_reward_display(rewardList))
    end

    local function _close_current_xyl_detail()
        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            MainAssist._xylDetailPopupPos = GUI:getPosition(MainAssist._xylDetailPopup.root)
            GUI:removeFromParent(MainAssist._xylDetailPopup.root)
        end
        MainAssist._xylDetailPopup = nil
    end

    local function _should_hide_xyl_detail_popup()
        return _is_gray_world_map(MainAssist._grayWorldLastMapEvent) == true
    end

    _refresh_xyl_detail_popup_content = function()
        local popup = MainAssist._xylDetailPopup
        if not (popup and popup.root and popup.descHost) then
            return
        end

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
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
        if not XYL_CURRENT_TASK_WIDGET_VISIBLE then
            _close_current_xyl_detail()
            return
        end
        MainAssist._xylDetailPopupOpened = true
        MainAssist._xylDetailPopupAutoResume = true
        if _should_hide_xyl_detail_popup() then
            _close_current_xyl_detail()
            return
        end
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
        GUI:setLocalZOrder(panel, 998)
        -- GUI:setTouchEnabled(panel, true)

        local title = GUI:Text_Create(panel, "title", -5, 114, 16, "#F4E7B5", "当前任务：")
        GUI:setAnchorPoint(title, 0, 0.5)
        GUI:Text_enableOutline(title, "#110b05", 2)

        local nameText = GUI:Text_Create(panel, "name", 65, 114, 16, "#FFFFFF", "")
        GUI:setAnchorPoint(nameText, 0, 0.5)
        GUI:Text_enableOutline(nameText, "#110b05", 2)

        local rewardTitle = GUI:Text_Create(panel, "reward", 0 + 51 + 4 + 50, 30 + 56, 21, "#FFD45A", "---[任务奖励]---")
        GUI:setAnchorPoint(rewardTitle, 0.5, 0.5)
        GUI:Text_setFontName(rewardTitle, "fonts/502.ttf")
        GUI:Text_enableOutline(rewardTitle, "#100808", 3)

        local rewardRoot = GUI:Node_Create(panel, "reward_root", 40, 15)
        -- GUI:setLocalZOrder(rewardRoot, 999)


        local detailBtn = GUI:Button_Create(panel, "detail_btn", 5, 19, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(detailBtn, 0, 0.5)
        GUI:Button_setTitleText(detailBtn, "任务详情")
        GUI:Button_setTitleColor(detailBtn, "#F4E7B5")
        GUI:Button_setTitleFontSize(detailBtn, 14)
        GUI:Button_titleEnableOutline(detailBtn, "#110b05", 2)

        GUI:addOnClickEvent(detailBtn, function()
            if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
                MainAssist._xylDetailPopupOpened = false
                MainAssist._xylDetailPopupAutoResume = false
                _close_current_xyl_detail()
                GUI:Button_setTitleText(detailBtn, "任务详情")
            else
                _open_current_xyl_detail()
                GUI:Button_setTitleText(detailBtn, "关闭详情")
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
            title = title,
            nameText = nameText,
            rewardTitle = rewardTitle,
            rewardRoot = rewardRoot,
            rewardNode = nil,
            detailBtn = detailBtn,
            goBtn = goBtn,
        }
        return MainAssist._xylCurrentWidget
    end

    local function _close_xyl_final_entry_widget()
        if MainAssist._xylFinalEntryWidget and MainAssist._xylFinalEntryWidget.panel then
            GUI:setVisible(MainAssist._xylFinalEntryWidget.panel, false)
        end
    end

    local function _ensure_xyl_final_entry_widget()
        if MainAssist._xylFinalEntryWidget and MainAssist._xylFinalEntryWidget.panel then
            return MainAssist._xylFinalEntryWidget
        end

        local parent = MainAssist._ui and MainAssist._ui["Panel_assist"]
        if not parent then
            return nil
        end

        local panel = GUI:Layout_Create(parent, "Panel_ywl_final_entry", GRAY_WORLD_PANEL_POS.x, GRAY_WORLD_PANEL_POS.y, GRAY_WORLD_PANEL_SIZE.width, GRAY_WORLD_PANEL_SIZE.height, false)
        GUI:setLocalZOrder(panel, 1002)
        GUI:setTouchEnabled(panel, true)

        local bg = GUI:Image_Create(panel, "bg", 0, 0, GRAY_WORLD_BG_PATH_1)
        if bg then
            GUI:setAnchorPoint(bg, 0, 0)
            local bgSize = GUI:getContentSize(bg)
            if bgSize and bgSize.width > 0 and bgSize.height > 0 then
                GUI:setScaleX(bg, GRAY_WORLD_PANEL_SIZE.width / bgSize.width)
                GUI:setScaleY(bg, GRAY_WORLD_PANEL_SIZE.height / bgSize.height)
            end
        end

        local tipText = GUI:Text_Create(panel, "tip_text", GRAY_WORLD_FINAL_BTN_POS.x + 5, GRAY_WORLD_FINAL_BTN_POS.y + 20, 21, "#ffffff", "品牌游戏 值得信赖\n\n丰富剧情 精彩纷呈\n\n更多精彩 敬请期待")
        GUI:setAnchorPoint(tipText, 0.5, 0.5)
        GUI:Text_setFontName(tipText, "fonts/502.ttf")
        GUI:Text_enableOutline(tipText, "#000000", 2)
        -- GUI:Text_enableUnderline(tipText)

        local btn = NPC_UI_HELPER.createPrimaryButton(panel, "xyl_final_entry_btn", GRAY_WORLD_FINAL_BTN_POS.x + 10, GRAY_WORLD_FINAL_BTN_POS.y - 70, "", function()
            SL:SendLuaNetMsg(101, 11, 0, 0, "")
        end, {
            skin = "res/wy/public/an15.png",
            fontSize = 14,
            color = "#F4E7B5",
        })
        GUI:setAnchorPoint(btn, 0.5, 0.5)
        GUI:setContentSize(btn, 136, 38)
        
        GUI:setContentSize(GUI:Image_Create(btn, "btn_bg", 17, 3, "res/wy/public/rw_tb.png"), 20, 30)

        local entry_text = GUI:Text_Create(btn, "entry_text", 136/2 + 12, 38/2 - 2, 20, "#FFD45A", XYL_FINAL_ENTRY_BTN_TEXT)
        GUI:setAnchorPoint(entry_text, 0.5, 0.5)
        GUI:Text_setFontName(entry_text, "fonts/502.ttf")
        GUI:Text_enableOutline(entry_text, "#000000", 2)

        MainAssist._xylFinalEntryWidget = {
            panel = panel,
            bg = bg,
            btn = btn,
        }
        return MainAssist._xylFinalEntryWidget
    end

    local function _show_xyl_final_entry_widget()
        local widget = _ensure_xyl_final_entry_widget()
        if not widget then
            return false
        end
        _safe_set_visible(widget.panel, true)
        if MainAssist._grayWorldTaskIcon then
            _safe_set_visible(MainAssist._grayWorldTaskIcon, false)
        end
        NPC_UI_HELPER.closeGuideByDomain("gray_world")
        if MainAssist._xylCurrentWidget and MainAssist._xylCurrentWidget.panel then
            _safe_set_visible(MainAssist._xylCurrentWidget.panel, false)
        end
        _close_current_xyl_detail()
        if MainAssist.ListView_mission then
            GUI:setContentSize(MainAssist.ListView_mission, 200, 185)
            GUI:setPosition(MainAssist.ListView_mission, 101, 94)
        end
        return true
    end

    function MainAssist.UpdateCurrentXylTaskWidget()
        MainAssist.UpdateGrayWorldTaskIcon()
        if _is_mainline_final_entry_open() then
            _show_xyl_final_entry_widget()
            return
        end
        _close_xyl_final_entry_widget()
        local mainlineRewardData = _collect_mainline_reward_display_data()

        if not XYL_CURRENT_TASK_WIDGET_VISIBLE then
            if #mainlineRewardData > 0 then
                local widget = _ensure_xyl_current_widget()
                if not widget then
                    return
                end
                _safe_set_visible(widget.panel, true)
                _safe_set_visible(widget.title, false)
                _safe_set_visible(widget.nameText, false)
                _safe_set_visible(widget.rewardTitle, true)
                _safe_set_visible(widget.detailBtn, false)
                _safe_set_visible(widget.goBtn, false)
                if widget.rewardNode then
                    GUI:removeFromParent(widget.rewardNode)
                    widget.rewardNode = nil
                end
                local okReward, rewardNode = pcall(function()
                    return ItemNumByTable_img_new(mainlineRewardData, nil, widget.rewardRoot)
                end)
                if okReward and rewardNode then
                    GUI:setPosition(rewardNode, 0, 0)
                    _add_reward_effect_for_table(rewardNode, "mainline_reward_eff", 29, 30, 0.8, REWARD_ITEM_EFFECT_13054)
                    widget.rewardNode = rewardNode
                end
                if MainAssist.ListView_mission then
                    GUI:setContentSize(MainAssist.ListView_mission, 200, 145)
                    GUI:setPosition(MainAssist.ListView_mission, 101, 114)
                end
                if _get_current_mainline_rwid() == 23 then
                    local quickClaimText = GUI:Text_Create(rewardNode, "quick_claim_text", 142 - 40, 42 - 15, 20, "#66CCFF", "礼包\n购买")
                    GUI:setAnchorPoint(quickClaimText, 0, 0.5)
                    GUI:Text_setFontName(quickClaimText, "fonts/502.ttf")
                    GUI:Text_enableOutline(quickClaimText, "#000000", 2)
                    GUI:Text_enableUnderline(quickClaimText)
                    GUI:setLocalZOrder(quickClaimText, 1002)
                    GUI:setTouchEnabled(quickClaimText, true)
                    GUI:addOnClickEvent(quickClaimText, function()
                        SL:SendLuaNetMsg(100, 106, 10, 0, "")
                    end)
                end
                return
            end
            if MainAssist._xylCurrentWidget and MainAssist._xylCurrentWidget.panel then
                _safe_set_visible(MainAssist._xylCurrentWidget.panel, false)
            end
            _close_current_xyl_detail()
            if MainAssist.ListView_mission then
                GUI:setContentSize(MainAssist.ListView_mission, 200, 185)
                GUI:setPosition(MainAssist.ListView_mission, 101, 94)
            end
            return
        end

        local widget = _ensure_xyl_current_widget()
        if not widget then
            return
        end
        _safe_set_visible(widget.title, true)
        _safe_set_visible(widget.nameText, true)
        _safe_set_visible(widget.rewardTitle, true)
        _safe_set_visible(widget.detailBtn, true)
        _safe_set_visible(widget.goBtn, true)

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        local hasTask = info and info.name and info.name ~= ""
        _safe_set_visible(widget.panel, hasTask)
        if not hasTask then
            if widget.rewardNode then
                GUI:removeFromParent(widget.rewardNode)
                widget.rewardNode = nil
            end
            _close_current_xyl_detail()
            if MainAssist.ListView_mission then
                GUI:setContentSize(MainAssist.ListView_mission, 200, 185)
                GUI:setPosition(MainAssist.ListView_mission, 101, 94)
            end
            return
        end

        local taskKey = _get_xyl_current_task_cache_key(MainAssist._xylCurrentTask, info)
        if MainAssist._xylDetailDefaultOpenKey ~= taskKey then
            MainAssist._xylDetailPopupOpened = true
            MainAssist._xylDetailPopupAutoResume = true
            MainAssist._xylDetailDefaultOpenKey = taskKey
        end

        GUI:Text_setString(widget.nameText, tostring(info.name))
        local wz = _get_xyl_current_task_action_text(info)
        GUI:Button_setTitleText(widget.goBtn, wz)
        if wz == "领取奖励" then
            GUI:removeAllChildren(widget.goBtn)
            NPC_UI_HELPER.redpoint_create(widget.goBtn, {anchorX = 0.5, x = 180, y = 32})
        else
            GUI:removeAllChildren(widget.goBtn)
        end

        GUI:Button_setTitleText(widget.detailBtn, MainAssist._xylDetailPopupOpened and "关闭详情" or "任务详情")
        if widget.rewardNode then
            GUI:removeFromParent(widget.rewardNode)
            widget.rewardNode = nil
        end

        local rewardData = _xyl_collect_task_reward_data(info.task, info)
        if #rewardData > 0 then
            local okReward, rewardNode = pcall(function()
                return ItemNumByTable_img_new(rewardData, nil, widget.rewardRoot)
            end)
            if okReward and rewardNode then
                GUI:setPosition(rewardNode, 0, 0)
                _add_reward_effect_for_table(rewardNode, "xyl_current_reward_eff", 29, 30, 0.8, REWARD_ITEM_EFFECT_13054)
                widget.rewardNode = rewardNode
            end
        end

        if MainAssist.ListView_mission then
            GUI:setContentSize(MainAssist.ListView_mission, 200, 145)
            GUI:setPosition(MainAssist.ListView_mission, 101, 114)
        end

        if MainAssist._xylDetailPopupOpened then
            if _should_hide_xyl_detail_popup() then
                _close_current_xyl_detail()
            elseif not (MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root) then
                _open_current_xyl_detail()
            else
                _refresh_xyl_detail_popup_content()
            end
        elseif MainAssist._xylDetailPopupAutoResume then
            if _should_hide_xyl_detail_popup() then
                _close_current_xyl_detail()
            else
                _open_current_xyl_detail()
            end
        else
            _close_current_xyl_detail()
        end
        GUI:Button_setTitleText(widget.detailBtn, MainAssist._xylDetailPopupOpened and "关闭详情" or "任务详情")
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

