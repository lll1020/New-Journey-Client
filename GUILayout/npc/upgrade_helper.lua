local UpgradeHelper = {}
local AUTO_REFRESH_INTERVAL = 1 * 60
local AUTO_REFRESH_TIMER_KEY = "__UPGRADE_BTN_AUTO_REFRESH_TIMER__"
local EQUIP_REFRESH_LISTENER_KEY = "__UPGRADE_BTN_EQUIP_REFRESH_LISTENER__"
local OPEN_BTN_STATE_KEY = "__UPGRADE_OPEN_BTN_STATE__"
local function _to_num(v, defaultValue)
    local n = tonumber(v)
    if n == nil then
        return defaultValue or 0
    end
    return n
end
local function _is_continent_open(continent)
    local need = _to_num(continent, 1)
    if need <= 1 then
        return true
    end
    if type(dl_unlock_check) == "function" then
        local ok = dl_unlock_check(need)
        return ok == true
    end
    if type(dl_sz) == "function" then
        local ok, opened = dl_sz(need)
        return ok
    end
    return false
end
local function _upgrade_to_num(v, defaultValue)
    local n = tonumber(v)
    if n == nil then
        return defaultValue or 0
    end
    return n
end
local function _upgrade_get_server_json(varName)
    if not varName or varName == "" then
        return {}
    end
    local raw = Player:getServerVar(varName)
    if not raw or raw == "" then
        return {}
    end
    local ok, data = pcall(function()
        return Player:JsonToTbl(raw)
    end)
    if ok and type(data) == "table" then
        return data
    end
    return {}
end
local function _upgrade_get_server_num(varName)
    return _upgrade_to_num(Player:getServerVar(varName), 0)
end
local function _upgrade_has_title(titleName)
    if not titleName or titleName == "" then
        return false
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName)
    if not idx then
        return false
    end
    return SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil
end
local function _upgrade_get_item_count_by_name(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if not idx then
        return 0
    end
    return _upgrade_to_num(SL:GetMetaValue("ITEM_COUNT", idx), 0)
end
local function _upgrade_can_pay(cost)
    return type(cost) == "table" and checkItemNum(cost)
end
local function _upgrade_check_simple_equip(npcid)
    local cfg = teshudata and teshudata["npc_" .. npcid]
    if not cfg then
        return true
    end
    local item = SL:GetMetaValue("EQUIP_DATA", cfg.where)
    if not item then
        return false
    end
    local equipLevel = _upgrade_to_num(Player:getEquipFieldByIndex(item.Index, 1), 0)
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    if maxLevel > 0 and equipLevel >= maxLevel then
        return false
    end
    local nextCfg = cfg.config and (cfg.config[equipLevel] or cfg.config[equipLevel + 1])
    if not nextCfg then
        return false
    end
    if not _upgrade_can_pay(nextCfg.cost) then
        return false
    end
    return true
end
local function _upgrade_check_tejie()
    local cfg = teshudata and teshudata["npc_9"]
    if not cfg then
        return true
    end
    local hasEquip = false
    for i, where in ipairs(cfg.where or {}) do
        local item = SL:GetMetaValue("EQUIP_DATA", where)
        if item then
            hasEquip = true
            local equipLevel = _upgrade_to_num(Player:getEquipFieldByIndex(item.Index, 1), 0)
            local maxLevel = _upgrade_to_num(cfg.max_level, 0)
            if maxLevel <= 0 or equipLevel < maxLevel then
                local nextCfg = cfg.config and cfg.config[i] and (cfg.config[i][equipLevel] or cfg.config[i][equipLevel + 1])
                if nextCfg and _upgrade_can_pay(nextCfg.cost) then
                    return true
                end
            end
        end
    end
    if not hasEquip then
        return false
    end
    return false
end
local function _upgrade_check_cuiti_11()
    local cfg = teshudata and teshudata["npc_11"]
    if not cfg then
        return true
    end
    if cfg.title and _upgrade_has_title(cfg.title) then
        return false
    end
    if not _upgrade_can_pay(cfg.cost) then
        return false
    end
    return true
end
local function _upgrade_check_cuiti_54()
    local cfg = teshudata and teshudata["npc_54"]
    if not cfg then
        return true
    end
    if cfg.title and _upgrade_has_title(cfg.title) then
        return false
    end
    if not _upgrade_can_pay(cfg.cost) then
        return false
    end
    local data = _upgrade_get_server_json("T36")
    if next(data) then
        local maxLevel = _upgrade_to_num(cfg.max_level, 0)
        if maxLevel > 0 then
            local allFull = true
            for i = 1, 5 do
                if _upgrade_to_num(data[tostring(i)], 0) < maxLevel then
                    allFull = false
                    break
                end
            end
            if allFull then
                return false
            end
        end
    end
    return true
end
local function _upgrade_check_tianshu()
    local cfg = teshudata and teshudata["npc_24"]
    local mainCfg = cfg and cfg.details and cfg.details[1]
    if not mainCfg then
        return true
    end
    -- 天书需要先穿戴到指定装备位，否则不显示入口
    local where = cfg and _upgrade_to_num(cfg.where, 0) or 0
    if where > 0 then
        local item = SL:GetMetaValue("EQUIP_DATA", where)
        if not item then
            return false
        end
    end
    local data = _upgrade_get_server_json("T42")
    local level = _upgrade_to_num(data.level, 0)
    local maxLevel = _upgrade_to_num(mainCfg.max_level, 0)
    if maxLevel > 0 and level >= maxLevel then
        return false
    end
    local nextCfg = mainCfg.details and mainCfg.details[level + 1]
    if not nextCfg then
        return false
    end
    if nextCfg.jf and _upgrade_to_num(data.jf, 0) < _upgrade_to_num(nextCfg.jf, 0) then
        return false
    end
    if nextCfg.cost and not _upgrade_can_pay(nextCfg.cost) then
        return false
    end
    return true
end
local function _upgrade_check_linggen()
    local cfg = teshudata and teshudata["npc_22"]
    local mainCfg = cfg and cfg.main_updata
    if not mainCfg then
        return true
    end
    local data = _upgrade_get_server_json("T41")
    local levels = data.level or (data.T_data and data.T_data.level) or {}
    local mainIdx = _upgrade_to_num(data.main or (data.T_data and data.T_data.main), 0)
    local otherIdx = _upgrade_to_num(data.other or (data.T_data and data.T_data.other), 0)
    local checkIdx = {}
    if mainIdx > 0 then
        checkIdx[#checkIdx + 1] = mainIdx
    end
    if otherIdx > 0 and otherIdx ~= mainIdx then
        checkIdx[#checkIdx + 1] = otherIdx
    end
    -- 未装配主/副灵根时，不显示灵根升级提示
    if #checkIdx <= 0 then
        return false
    end
    local maxLevel = _upgrade_to_num(mainCfg.max_level, 0)
    local hasAnySlot = false
    for _, i in ipairs(checkIdx) do
        local rawLv = levels[tostring(i)]
        if rawLv == nil then
            rawLv = levels[i]
        end
        -- 未激活（无等级数据）时，不参与可升级检测
        if rawLv ~= nil then
            local lv = _upgrade_to_num(rawLv, 0)
        if maxLevel <= 0 or lv < maxLevel then
            local det = mainCfg.details and ((i <= 5) and mainCfg.details.low or mainCfg.details.up)
            local nextCfg = det and det[lv + 1]
            if nextCfg then
                hasAnySlot = true
                if _upgrade_can_pay(nextCfg.cost) then
                    return true
                end
            end
        end
        end
    end
    if hasAnySlot then
        return false
    end
    return false
end
local function _upgrade_check_realm_21()
    local cfg = teshudata and teshudata["npc_21"]
    if not cfg then
        return true
    end
    local level = _upgrade_get_server_num("U28")
    local exp = _upgrade_get_server_num("U29")
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    if maxLevel > 0 and level >= maxLevel then
        return false
    end
    local nextCfg = cfg.details and cfg.details[level + 1]
    if not nextCfg then
        return false
    end
    if exp < _upgrade_to_num(nextCfg.need_xxz, 0) then
        return false
    end
    if nextCfg.cost and not _upgrade_can_pay(nextCfg.cost) then
        return false
    end
return true
end
local function _upgrade_check_haogandu()
    local cfg = teshudata and teshudata["npc_13"]
    if not cfg then
        return true
    end
    local lv = _upgrade_to_num(Player:getServerVar("U27"), -1)
    if lv < 0 then
        return false
    end
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    if maxLevel > 0 and lv >= maxLevel then
        return false
    end
    local nextCfg = cfg.config and cfg.config[lv + 1]
    if not nextCfg or type(nextCfg.cost) ~= "table" then
        return false
    end
return _upgrade_can_pay(nextCfg.cost)
end
local function _upgrade_check_xianshifang_14()
    local cfg = teshudata and teshudata["npc_14"]
    if not cfg or type(cfg.config) ~= "table" then
        return false
    end
    if cfg.title and _upgrade_has_title(cfg.title) then
        return false
    end
    local totalNeed = 10
    local totalCount = 0
    local visited = {}
    for _, detail in pairs(cfg.config) do
        local cost = detail and detail.cost
        if type(cost) == "table" then
            for _, item in ipairs(cost) do
                local itemName = item and item[1]
                if type(itemName) == "string" and itemName ~= "" and not visited[itemName] then
                    visited[itemName] = true
                    totalCount = totalCount + _upgrade_get_item_count_by_name(itemName)
                    if totalCount >= totalNeed then
                        return true
                    end
                end
            end
        end
    end
return false
end
local function _upgrade_check_title_43()
    local cfg = teshudata and teshudata["npc_43"]
    if not cfg then
        return true
    end
    local curLv = 0
    for i, titleName in ipairs(cfg.ch or {}) do
        if _upgrade_has_title(titleName) then
            curLv = i
        end
    end
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    if maxLevel > 0 and curLv >= maxLevel then
        return false
    end
    local nextCost = cfg.cost and cfg.cost[curLv + 1]
    if not nextCost then
        return false
    end
    if not _upgrade_can_pay(nextCost) then
        return false
    end
    return true
end
local function _upgrade_check_qiyun_26()
    local cfg = teshudata and teshudata["npc_26"]
    if not cfg then
        return true
    end
    local details = cfg.details or {}
    if #details > 0 and _upgrade_has_title(details[#details]) then
        return false
    end
    if _upgrade_get_server_num("U31") <= 0 then
        return true
    end
    if cfg.cost and not _upgrade_can_pay(cfg.cost) then
        return false
    end
    return true
end
local function _upgrade_check_skill_27()
    local cfg = teshudata and teshudata["npc_27"]
    if not cfg then
        return true
    end
    local data = _upgrade_get_server_json("T37")
    local levels = data.level or data
    local hasAnySkill = false
    for i, detail in ipairs(cfg.details or {}) do
        local lv = _upgrade_to_num(levels[tostring(i)] or levels[i], 0)
        local maxLv = _upgrade_to_num(detail.max_level, 0)
        if maxLv <= 0 or lv < maxLv then
            hasAnySkill = true
            if _upgrade_can_pay(detail.cost) then
                return true
            end
        end
    end
    if hasAnySkill then
        return false
    end
    return false
end
local function _upgrade_check_equip_28()
    local cfg = teshudata and teshudata["npc_28"]
    if not cfg then
        return true
    end
    local varByPos = {
        [1] = "U32",
        [0] = "U33",
        [6] = "U34",
        [8] = "U35",
        [10] = "U36",
        [4] = "U37",
        [3] = "U38",
        [5] = "U39",
        [7] = "U40",
        [11] = "U41",
    }
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    local hasAnyPart = false
    for pos in pairs(cfg.where or {}) do
        local varName = varByPos[pos]
        local lv = _upgrade_to_num(varName and _upgrade_get_server_num(varName), 0)
        if maxLevel <= 0 or lv < maxLevel then
            hasAnyPart = true
            local nextCfg = cfg.details and cfg.details[lv + 1]
            if nextCfg and _upgrade_can_pay(nextCfg.cost) then
                return true
            end
        end
    end
    if hasAnyPart then
        return false
    end
    return false
end
local function _upgrade_check_lucky_25()
    local cfg = teshudata and teshudata["npc_25"]
    if not cfg then
        return true
    end
    local lv = _upgrade_get_server_num("U30")
    local maxLevel = _upgrade_to_num(cfg.max_level, 0)
    if maxLevel > 0 and lv >= maxLevel then
        return false
    end
    local nextCfg = cfg.details and cfg.details[lv + 1]
    if not nextCfg then
        return false
    end
    if not _upgrade_can_pay(nextCfg.cost) then
        return false
    end
    return true
end
local function _upgrade_check_xianfu_mature()
    local data = _upgrade_get_server_json("T47")
    local fields = data.fields
    if type(fields) ~= "table" then
        return false
    end
    local now = _upgrade_to_num(SL:GetMetaValue("SERVER_TIME"), os.time())
    for _, plot in pairs(fields) do
        if type(plot) == "table" then
            local state = tostring(plot.state or "")
            if state == "mature" or state == "ready" then
                return true
            end
            local finishAt = _upgrade_to_num(plot.finishAt or plot.finish_at or plot.finish_time, 0)
            if finishAt > 0 and finishAt <= now then
                return true
            end
        end
    end
    return false
end
-- 限时福利：当前档位倒计时结束后，加入小提升入口。
local function _upgrade_check_limited_welfare_105()
    local cfg = teshudata and teshudata["anniu_501"]
    local welfare = cfg and cfg.details and cfg.details.welfare or nil
    if type(welfare) ~= "table" or #welfare <= 0 then
        return false
    end
    local data = _upgrade_get_server_json("T39")
    local claimed = _upgrade_to_num(data.welfare_claimed, 0)
    local nextIdx = claimed + 1
    if nextIdx < 1 or nextIdx > #welfare then
        return false
    end
    -- 已首充时，当前档位可直接领取，不再受倒计时限制。
    local hasFirstCharge = _upgrade_to_num(data.ok, 0) == 1 and (
        _upgrade_to_num(data["首充"], 0) == 1 or
        _upgrade_to_num(data.first_charge_ready, 0) == 1 or
        _upgrade_to_num(data.main_claimed or data.other_lb, 0) >= 1
    )
    if hasFirstCharge then
        return true
    end
    local openTs = _upgrade_to_num(data.welfare_open_time, 0)
    if openTs <= 0 then
        -- 二大陆限时福利需要玩家主动打开一次面板后才开始倒计时；未启动时也显示入口。
        return true
    end
    local waitSec = _upgrade_to_num(welfare[nextIdx] and welfare[nextIdx].wait_sec, 0)
    local now = _upgrade_to_num(SL:GetMetaValue("SERVER_TIME"), os.time())
    return openTs + waitSec <= now
end
local function _upgrade_check_lingshou_64()
    local cfg = teshudata and teshudata["npc_64"]
    if not cfg then
        return true
    end
    if _upgrade_can_pay(cfg.cost) then
        return true
    end
    local data = _upgrade_get_server_json("T50")
    local levels = data.ls or {}
    local lsCfg = cfg.config and cfg.config.ls or {}
    local wyCfg = cfg.config and cfg.config.wy
    if wyCfg and wyCfg.cost then
        local maxLevel = _upgrade_to_num(wyCfg.max_level, 0)
        for i = 1, #lsCfg do
            local lv = _upgrade_to_num(levels[tostring(i)] or levels[i], 0)
            if lv > 0 and (maxLevel <= 0 or lv < maxLevel) then
                local cost = wyCfg.cost[lv]
                if cost and _upgrade_can_pay(cost) then
                    return true
                end
            end
        end
    end
    return false
end
local function _upgrade_check_guwan_65()
    local cfg = teshudata and teshudata["npc_65"]
    if not cfg then
        return true
    end
    for _, detail in ipairs(cfg.config or {}) do
        if _upgrade_can_pay(detail.cost) then
            return true
        end
    end
    return false
end
local function _upgrade_check_emojiuguan_66()
    local data = _upgrade_get_server_json("T52")
    local usedCount = _upgrade_to_num(data.count or (data.T_data and data.T_data.count), 0)
    if usedCount >= 3 then
        return false
    end
    return true
end
local function _upgrade_is_story_done(storyKey)
    if not storyKey or storyKey == "" then
        return false
    end
    local data = _upgrade_get_server_json("T13")
    if type(data) ~= "table" then
        return false
    end
    local key1 = tostring(storyKey)
    local key2 = string.gsub(key1, "_", "")
    local node = data[key1]
    if node == nil then
        node = data[key2]
    end
    if node == nil then
        return false
    end
    if type(node) == "number" then
        return node >= 2
    end
    if type(node) == "table" then
        if _upgrade_to_num(node[1] or node["1"], 0) >= 2 then
            return true
        end
        if _upgrade_to_num(node.wc or node.finish or node.done or node.ok, 0) >= 1 then
            return true
        end
        if _upgrade_to_num(node.cnt or node.num, 0) >= 2 then
            return true
        end
    end
    return false
end
local function _upgrade_is_cuiti_11_completed()
    local cfg = teshudata and teshudata["npc_11"]
    if not cfg then
        return false
    end
    if cfg.title and _upgrade_has_title(cfg.title) then
        return true
    end
    local data = _upgrade_get_server_json("T36")
    if type(data) == "table" and next(data) ~= nil then
        local maxLevel = _upgrade_to_num(cfg.max_level, 0)
        if maxLevel > 0 then
            local allFull = true
            for i = 1, 5 do
                local lv = _upgrade_to_num(data[tostring(i)] or data[i], 0)
                if lv < maxLevel then
                    allFull = false
                    break
                end
            end
            if allFull then
                return true
            end
        end
    end
    return false
end
local function _upgrade_is_npc_46_completed()
    return _upgrade_is_story_done("npc_46")
end
local function _upgrade_has_third_continent_half_entry()
    return _upgrade_is_npc_46_completed()
end
local function _upgrade_has_third_continent_full_entry()
    return _upgrade_is_story_done("npc_46") or _upgrade_is_story_done("npc_46")
end
local function _upgrade_has_required_equip_for_70()
    local cfg = teshudata and teshudata["npc_70"]
    if not cfg then
        return false
    end
    local where = cfg.where
    local needName = cfg.now
    if not where or not needName or needName == "" then
        return false
    end
    local equip = SL:GetMetaValue("EQUIP_DATA", where)
    if not equip then
        return false
    end
    local needIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", needName)
    local equipIdx = tonumber(equip.Index)
    if needIdx and equipIdx and tonumber(needIdx) == equipIdx then
        return true
    end
return tostring(equip.Name or "") == tostring(needName)
end
local UPGRADE_CHECKERS = {
    [21] = _upgrade_check_realm_21,
    [6] = function() return _upgrade_check_simple_equip(6) end,
    [7] = function() return _upgrade_check_simple_equip(7) end,
    [8] = function() return _upgrade_check_simple_equip(8) end,
    [9] = _upgrade_check_tejie,
    [10] = function() return _upgrade_check_simple_equip(10) end,
    [11] = _upgrade_check_cuiti_11,
    [14] = _upgrade_check_xianshifang_14,
    [54] = _upgrade_check_cuiti_54,
    [24] = _upgrade_check_tianshu,
    [22] = _upgrade_check_linggen,
    [13] = _upgrade_check_haogandu,
    [43] = _upgrade_check_title_43,
    [26] = _upgrade_check_qiyun_26,
    [27] = _upgrade_check_skill_27,
    [28] = _upgrade_check_equip_28,
    [25] = _upgrade_check_lucky_25,
    [44] = _upgrade_check_xianfu_mature,
    [105] = _upgrade_check_limited_welfare_105,
    [64] = _upgrade_check_lingshou_64,
    [65] = _upgrade_check_guwan_65,
    [66] = _upgrade_check_emojiuguan_66,
    [70] = _upgrade_check_emojiuguan_66,
}
local OPEN_BTN_LIST = {
    {id = 1, label = "限时福利", npcid = 105, continent = 2},
    {id = 6, label = "切割之斧", npcid = 6, continent = 1},
    {id = 7, label = "攻速之镰[★]", npcid = 7, continent = 1},
    {id = 8, label = "斗笠[★]", npcid = 8, continent = 1},
    {id = 9, label = "特戒", npcid = 9, continent = 1},
    {id = 10, label = "酒葫芦[★]", npcid = 10, continent = 1},
    {id = 11, label = "基础淬体", npcid = 11, continent = 2},
    {id = 13, label = "小兰赠礼[★]", npcid = 13, continent = 1},
    {id = 14, label = "小二倒酒[★]", npcid = 14, continent = 1},
    {id = 24, label = "天书[★]", npcid = 24, continent = 2},
    {id = 22, label = "灵根[★]", npcid = 22, continent = 2},
    {id = 21, label = "境界修为[★]", npcid = 21, continent = 2},
    {id = 43, label = "江湖称号[★]", npcid = 43, continent = 2},
    {id = 26, label = "气运占卜", npcid = 26, continent = 2},
    {id = 28, label = "装备强化", npcid = 28, continent = 2},
    {id = 25, label = "幸运强化", npcid = 25, continent = 2},
    -- 三大陆现在区分半进入/真进入：
    -- 半进入：完成 npc_46 后进入灰界/仙府线，可使用 npc_44
    -- 真进入：完成 npc_46【灾厄入侵】后才算进入三大陆主城功能区
    {id = 54, label = "高级淬体[★]", npcid = 54, continent = 3, entryMode = "full", precondition = function()
        return _upgrade_is_cuiti_11_completed() and _upgrade_has_third_continent_full_entry()
    end},
    {id = 27, label = "技能强化", npcid = 27, continent = 3, entryMode = "full", precondition = _upgrade_has_third_continent_full_entry},
    {id = 4401, label = "仙草成熟", npcid = 44, continent = 3, entryMode = "half", precondition = _upgrade_has_third_continent_half_entry},
    {id = 64, label = "灵兽", npcid = 64, continent = 4},
    {id = 65, label = "古玩鉴定", npcid = 65, continent = 4},
    {id = 70, label = "恶魔酒馆", npcid = 70, continent = 5, precondition = _upgrade_has_required_equip_for_70},
}
-- 主线任务与功能入口解锁映射
-- key: 功能/NPC 标识（与服务端 rwcf 的 id 一致）
-- value: 解锁该功能所需的主线任务号 rwid
-- 同源：E:\新起航\服务端\Mir200\Envir\QuestDiary\task.lua -> rwcf
local MAINLINE_UNLOCK_MAP = {
    [32] = 15,    -- NPC 32（转生）：主线到 15 解锁
    [516] = 4,    -- NPC 516（免费赞助）：主线到 4 解锁
}
-- 获取主线进度：优先使用客户端缓存 rwid，不足时兜底读取服务端变量 U_zxrw/U11
local function _upgrade_get_mainline_rwid()
    local rwid = _upgrade_to_num(cogin and cogin.sjtb and cogin.sjtb.rwid, 0)
    if rwid > 0 then
        return rwid
    end
    if not Player or type(Player.getServerVar) ~= "function" then
        return rwid
    end
    rwid = _upgrade_to_num(Player:getServerVar("U_zxrw"), 0)
    if rwid > 0 then
        return rwid
    end
    return _upgrade_to_num(Player:getServerVar("U11"), 0)
end
-- 判断当前提升入口是否达到主线解锁要求
local function _upgrade_check_mainline_unlock(npcid)
    local needRwid = MAINLINE_UNLOCK_MAP[_upgrade_to_num(npcid, 0)]
    if not needRwid then
        return true
    end
    return _upgrade_get_mainline_rwid() >= needRwid
end
local function _check_precondition(cfg)
    if type(cfg) ~= "table" then
        return false
    end
    if _upgrade_to_num(cfg.continent, 0) == 3 then
        local entryMode = tostring(cfg.entryMode or "half")
        if entryMode == "full" then
            if not _upgrade_has_third_continent_full_entry() then
                return false
            end
        else
            if not _upgrade_has_third_continent_half_entry() then
                return false
            end
        end
    elseif not _is_continent_open(cfg.continent) then
        return false
    end
    if not _upgrade_check_mainline_unlock(cfg.npcid) then
        return false
    end
    if type(cfg.precondition) == "function" then
        local ok, pass = pcall(cfg.precondition)
        return ok and pass == true
    end
    return true
end
local function _can_add_button(cfg)
    if not _check_precondition(cfg) then
        return false
    end
    local checker = UPGRADE_CHECKERS[cfg.npcid]
    if not checker then
        return true
    end
    local ok, canUpgrade = pcall(checker)
    return ok and canUpgrade == true
end
-- 记录当前已经挂到提升栏里的按钮，避免每次刷新都先删后加。
local function _get_open_btn_state()
    local state = rawget(_G, OPEN_BTN_STATE_KEY)
    if type(state) ~= "table" then
        state = {}
        rawset(_G, OPEN_BTN_STATE_KEY, state)
    end
    return state
end
function UpgradeHelper.registerOpenNpcButtons()
    local btnState = _get_open_btn_state()
    for _, cfg in ipairs(OPEN_BTN_LIST) do
        local hasButton = btnState[cfg.id] == true
        local canAdd = _can_add_button(cfg)
        -- 当前条件不满足时直接移除；满足时再补挂，避免每次刷新都先删后加。
        if not canAdd then
            if hasButton then
                SL:RemoveUpgradeBtn(cfg.id)
                btnState[cfg.id] = nil
            end
        elseif not hasButton then
            SL:AddUpgradeBtn(cfg.id, cfg.label, function()
                SL:SendLuaNetMsg(105, cfg.npcid, cfg.npcid, 0, "")
            end)
            btnState[cfg.id] = true
        end
    end
end
function UpgradeHelper.startAutoRefresh(intervalSec)
    local oldTimer = rawget(_G, AUTO_REFRESH_TIMER_KEY)
    if oldTimer then
        SL:UnSchedule(oldTimer)
        rawset(_G, AUTO_REFRESH_TIMER_KEY, nil)
    end
    local interval = tonumber(intervalSec) or AUTO_REFRESH_INTERVAL
    local timer = SL:Schedule(function()
        UpgradeHelper.registerOpenNpcButtons()
    end, interval)
    rawset(_G, AUTO_REFRESH_TIMER_KEY, timer)
end
function UpgradeHelper.startEquipChangeRefresh()
SL:release_print("startEquipChangeRefresh")
    local function _refresh_on_equip_change(data)
        UpgradeHelper.registerOpenNpcButtons()
    end
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "upgrade_helper_equip_on", _refresh_on_equip_change)
end
-- 兼容旧调用名
function UpgradeHelper.treasureBasinRedState(data)
    if type(data) ~= "table" or next(data) == nil then
        local cached = rawget(_G, "__TREASURE_BASIN_517_DATA__")
        data = type(cached) == "table" and cached or _upgrade_get_server_json("T44")
    end
    data = type(data) == "table" and data or {}
    local stored = type(data.T_data) == "table" and data.T_data or data
    local active = _upgrade_to_num(data.activated, _upgrade_to_num(stored.activated, _upgrade_to_num(stored.rebuilt, 0))) >= 1
    local result = {
        energy = false,
        refine = false,
        refine_start = false,
        refine_claim = false,
        level = false,
        forbidden = false,
        forbidden_unlock = {},
        forbidden_upgrade = {},
        forbidden_skill = false,
        any = false,
    }
    if not active then
        return result
    end

    local energy = _upgrade_to_num(data.energy_sec, _upgrade_to_num(stored.energy_sec, 0))
    local reward = type(data.energy_reward) == "table" and data.energy_reward or {}
    result.energy = energy >= 60
        or _upgrade_to_num(reward.gold, 0) > 0
        or _upgrade_to_num(reward.iron, 0) > 0
        or _upgrade_to_num(reward.hat, 0) > 0

    local refine = type(data.refine) == "table" and data.refine or (type(stored.refine) == "table" and stored.refine or {})
    local refineActive = _upgrade_to_num(refine.active, 0) >= 1 or tostring(refine.stone or "") ~= ""
    result.refine_claim = refineActive and (
        _upgrade_to_num(refine.done, 0) >= 1
        or (_upgrade_to_num(refine.end_at, 0) > 0 and _upgrade_to_num(refine.end_at, 0) <= os.time())
    )
    if not refineActive then
        local basinCfg = teshudata and teshudata["npc_106"] or {}
        for _, stone in ipairs(basinCfg.stones or {}) do
            local continent = _upgrade_to_num(stone.continent, 0)
            if (continent <= 0 or _is_continent_open(continent)) and _upgrade_get_item_count_by_name(stone.name) > 0 then
                result.refine_start = true
                break
            end
        end
    end
    result.refine = result.refine_claim or result.refine_start

    local basinCfg = teshudata and teshudata["npc_106"] or {}
    local level = math.max(1, _upgrade_to_num(data.level, _upgrade_to_num(stored.level, 1)))
    local nextLevelCfg = (basinCfg.levels or {})[level + 1]
    local realCharge = math.max(
        _upgrade_to_num(data.charge, 0),
        _upgrade_to_num(data.real_charge, 0),
        _upgrade_to_num(SL:GetMetaValue("REAL_RECHARGE"), 0)
    )
    if nextLevelCfg and realCharge >= _upgrade_to_num(nextLevelCfg.charge, 0) then
        result.level = true
    end

    local rawForbidden = type(stored.forbidden) == "table" and stored.forbidden or {}
    local forbiddenList = type(data.forbidden) == "table" and data.forbidden or {}
    local rawList = type(rawForbidden.list) == "table" and rawForbidden.list or {}
    local point = _upgrade_to_num(data.forbidden_point, _upgrade_to_num(rawForbidden.point, 0))
    local money = _upgrade_to_num(SL:GetMetaValue("MONEY", 4), 0)
    local crystal = _upgrade_get_item_count_by_name("禁元神晶")
    local selectedId = _upgrade_to_num(rawForbidden.show, 0)
    for id, _ in ipairs(basinCfg.forbidden or {}) do
        local node = forbiddenList[id] or forbiddenList[tostring(id)] or rawList[id] or rawList[tostring(id)] or {}
        local lv = _upgrade_to_num(node.lv, 0)
        if _upgrade_to_num(node.show, 0) >= 1 then
            selectedId = id
        end
        if lv <= 0 then
            if point >= 8888 then
                result.forbidden_unlock[id] = true
            end
        elseif lv < 5 then
            local cost = (basinCfg.forbidden_cost or {})[lv + 1] or {}
            if level >= _upgrade_to_num(cost.need_level, 0)
                and money >= _upgrade_to_num(cost.yuanbao, 0)
                and crystal >= _upgrade_to_num(cost.crystal, 0) then
                result.forbidden_upgrade[id] = true
            end
        end
    end
    if selectedId > 0 then
        local node = forbiddenList[selectedId] or forbiddenList[tostring(selectedId)] or rawList[selectedId] or rawList[tostring(selectedId)] or {}
        local skillLeft = _upgrade_to_num(data.forbidden_skill_cd_left, math.max(0, _upgrade_to_num(rawForbidden.skill_cd_at, 0) - os.time()))
        result.forbidden_skill = _upgrade_to_num(node.lv, 0) >= 5 and skillLeft <= 0
    end
    result.forbidden = result.forbidden_skill or next(result.forbidden_unlock) ~= nil or next(result.forbidden_upgrade) ~= nil
    result.any = result.energy or result.refine or result.level or result.forbidden
    return result
end
UpgradeHelper.registerUpgradeButtons = UpgradeHelper.registerOpenNpcButtons
return UpgradeHelper
