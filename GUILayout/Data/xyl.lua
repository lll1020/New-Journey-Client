-- 异闻录：剧情完成判定辅助
local _xyl_name_map
local function _xyl_norm_name(name)
    if not name then
        return ""
    end
    local v = tostring(name)
    v = v:gsub("（.-）", "")
    v = v:gsub("%s+", "")
    v = v:gsub("　", "")
    return v
end
local function _xyl_build_name_map()
    local map = {}
    local data = teshudata or {}
    for key, cfg in pairs(data) do
        if type(key) == "string" and key:match("^npc_%d+$") and type(cfg) == "table" and cfg.name then
            map[_xyl_norm_name(cfg.name)] = key
        end
    end
    return map
end
local function _xyl_get_npc_key(name)
    if not name then
        return nil
    end
    local v = tostring(name)
    if v:match("^npc_%d+$") then
        return v
    end
    return nil
end
local function _xyl_get_server_var(varName)
    return Player:getServerVar(varName)
end
local function _xyl_get_json(varName)
    return Player:JsonToTbl(_xyl_get_server_var(varName))
end
local function _xyl_get_num(varName)
    return tonumber(_xyl_get_server_var(varName)) or 0
end
-- 备注：是否已拥有指定称号
local function _xyl_has_title(title)
    if not title or title == "" then
        return false
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", title)
    if not idx then
        return false
    end
    return SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil
end
-- 备注：通用剧情完成判定（读取 T13，优先称号，其次次数/完成标记）
local function _xyl_check_story(name)
    local key = _xyl_get_npc_key(name)
    if not key then
        return false
    end
    local cfg = teshudata and teshudata[key]
    local max_num = cfg and cfg.max_num
    if cfg and cfg.ch and _xyl_has_title(cfg.ch) then
        return true
    end
    local jq_data = _xyl_get_json("T13")
    local node = jq_data[key]
    -- 特殊验证
    if key == "npc_633" then
        return (tonumber(node) or 0) >= 2
    end
    -- SL:release_print("check story", name, key, node, max_num)
    if type(node) == "number" then
        if max_num and max_num > 0 then
            return node >= max_num
        end
        return node >= 2
    end
    if type(node) == "table" then
        if max_num and max_num > 0 then
            local cnt = node.cnt or node.num
            if tonumber(cnt) then
                return tonumber(cnt) >= max_num
            end
        end
        if node.wc and node.wc >= 1 then
            return true
        end
        if node.finish and node.finish >= 1 then
            return true
        end
        if node.done and node.done >= 1 then
            return true
        end
        if node.ok and node.ok >= 1 then
            return true
        end
    end
    return false
end
-- 备注：背包道具数量是否满足
local function _xyl_has_item(name, count)
    if not name or name == "" then
        return false
    end
    local miss = Player:checkItemNumByTable({{name, count or 1}})
    return not miss
end
-- 备注：列表内任意道具满足即可
local function _xyl_has_any_item(list)
    if type(list) ~= "table" then
        return false
    end
    for _, name in ipairs(list) do
        if _xyl_has_item(name, 1) then
            return true
        end
    end
    return false
end
-- 备注：指定部位是否装备指定名称物品
local function _xyl_has_equip_named(where, name)
    if not where or not name then
        return false
    end
    local equipName = Player:getEquipNameByPos(where)
    return equipName == name
end
-- 备注：天书等级是否达到 1 级
local function _xyl_has_tianshu_level()
    local data = _xyl_get_json("T42")
    return (data.level or 0) >= 1
end
-- 备注：天书是否已配置任意仙法
local function _xyl_has_any_xianfa()
    local data = _xyl_get_json("T42")
    local caowei = data.caowei or {}
    for _, v in pairs(caowei) do
        if type(v) == "table" then
            return true
        end
    end
    if data.tj then
        for _ in pairs(data.tj) do
            return true
        end
    end
    return false
end
-- 备注：天书是否拥有红色仙法
local function _xyl_has_red_xianfa()
    local data = _xyl_get_json("T42")
    local caowei = data.caowei or {}
    for _, v in pairs(caowei) do
        if type(v) == "table" and tonumber(v[1]) and tonumber(v[1]) >= 5 then
            return true
        end
    end
    return false
end
local _xyl_equip_strength_vars = {
    ["衣服"] = "U32",
    ["武器"] = "U33",
    ["左手"] = "U34",
    ["左戒"] = "U35",
    ["腰带"] = "U36",
    ["头盔"] = "U37",
    ["项链"] = "U38",
    ["右手"] = "U39",
    ["右戒"] = "U40",
    ["靴子"] = "U41",
}
-- 备注：任意装备强化等级 > 0
local function _xyl_has_equip_strength()
    local cfg = teshudata and teshudata["npc_28"]
    if not (cfg and cfg.where) then
        return false
    end
    for _, info in pairs(cfg.where) do
        local part = info[1]
        if part then
            local key = _xyl_equip_strength_vars[part]
            if key then
                local lv = _xyl_get_num(key)
                if tonumber(lv) and tonumber(lv) > 0 then
                    return true
                end
            end
        end
    end
    return false
end
-- 备注：灵根喂养任意等级 > 0
local function _xyl_has_linggen_feed()
    local data = _xyl_get_json("T41")
    local levels = data.level or {}
    for _, v in pairs(levels) do
        if tonumber(v) and tonumber(v) > 0 then
            return true
        end
    end
    return false
end
-- 备注：是否已查看江湖称号
local function _xyl_has_jianghu_title()
    if rawget(_G, "XYL_VIEW_JH_TITLE") then
        return true
    end
    local cfg = teshudata and teshudata["npc_43"]
    local titleList = cfg and cfg.ch or {}
    for _, titleName in pairs(titleList) do
        if _xyl_has_title(titleName) then
            return true
        end
    end
    return false
end
-- 备注：是否已装配主灵根
local function _xyl_has_main_linggen()
    local data = _xyl_get_json("T41")
    return (tonumber(data.main or (data.T_data and data.T_data.main)) or 0) > 0
end
-- 备注：主灵根是否为指定下标（1=金 2=木 3=水 4=火 5=土）
local function _xyl_has_main_linggen_of(idx)
    local data = _xyl_get_json("T41")
    return (tonumber(data.main or (data.T_data and data.T_data.main)) or 0) == (tonumber(idx) or 0)
end
-- 备注：是否已装配副灵根
local function _xyl_has_other_linggen()
    local data = _xyl_get_json("T41")
    return (tonumber(data.other or (data.T_data and data.T_data.other)) or 0) > 0
end
-- 备注：副灵根是否为指定下标（1=金 2=木 3=水 4=火 5=土）
local function _xyl_has_other_linggen_of(idx)
    local data = _xyl_get_json("T41")
    return (tonumber(data.other or (data.T_data and data.T_data.other)) or 0) == (tonumber(idx) or 0)
end
-- 备注：气运占卜次数是否大于 0
local function _xyl_has_divination()
    return _xyl_get_num("U31") > 0
end
-- 备注：是否已打开过二大陆限时福利
local function _xyl_has_second_continent_welfare_open()
    return _xyl_get_num("N$XYL2_WELFARE_OPEN") > 0
end
-- 备注：是否已完成过一次天书使者洗炼
local function _xyl_has_second_continent_tianshu_refine()
    return _xyl_get_num("N$XYL2_TIANSHU_REFINE") > 0
end
-- 备注：是否已查看过幸运增幅界面
local function _xyl_has_second_continent_lucky_view()
    return _xyl_get_num("N$XYL2_LUCKY_VIEW") > 0
end
-- 备注：境界是否已达到筑基境（等级 10）
local function _xyl_has_foundation_realm()
    return _xyl_get_num("U28") >= 10
end
-- 备注：转生等级是否达到指定等级
local function _xyl_has_rebirth(level)
    return _xyl_get_num("U43") >= (level or 1)
end
-- 备注：判断斗笠低阶名称（低阶不算完成传说/更高）
local function _xyl_is_lower_hat_name(name)
    if not name or name == "" then
        return false
    end
    if name == "江湖·斗笠" then
        return true
    end
    return name:match("^斗笠%[lv%d+%]$") ~= nil
end
-- 备注：判断葫芦低阶名称（低阶不算完成神/更高）
local function _xyl_is_lower_gourd_name(name)
    if not name or name == "" then
        return false
    end
    if name == "真·酒葫芦" then
        return true
    end
    return name:match("^酒葫芦%[lv%d+%]$") ~= nil
end
-- 备注：是否拥有传说神石类道具
local function _xyl_has_legendary_stone()
    local cfg = teshudata and teshudata["npc_53"]
    local list = cfg and cfg.cost and cfg.cost[3]
    SL:dump(list, "legendary stone list")
    return _xyl_has_any_item(list)
end
-- 备注：传说斗笠（装备或背包）是否拥有（上位斗笠也视为完成）
local function _xyl_has_legendary_hat()
    local item = SL:GetMetaValue("EQUIP_DATA", 13)
    if item then
        local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
        equipLevel = tonumber(equipLevel)
        return equipLevel and equipLevel >= 13
    else
        return false
    end
end
-- 备注：神酒葫芦（装备或背包）是否拥有（上位葫芦也视为完成）
local function _xyl_has_god_gourd()
    local item = SL:GetMetaValue("EQUIP_DATA", 16)
    if item then
        local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
        equipLevel = tonumber(equipLevel)
        return equipLevel and equipLevel >= 13
    else
        return false
    end
end
-- 备注：高级淬体是否全完成（或已有称号）
local function _xyl_has_advanced_quench()
    local cfg = teshudata and teshudata["npc_54"]
    if cfg and cfg.title and _xyl_has_title(cfg.title) then
        return true
    end
    local maxLevel = (cfg and cfg.max_level) or 0
    if maxLevel <= 0 then
        return false
    end
    local data = _xyl_get_json("T36")
    for i = 1, 5 do
        if (data[tostring(i)] or 0) < maxLevel then
            return false
        end
    end
    return true
end
-- 备注：仙府是否已开启（有数据记录）
local function _xyl_has_xianfu_open()
    local data = _xyl_get_json("T47")
    return type(data) == "table" and tonumber(data.opened or 0) >= 1
end
-- 备注：仙府炼制是否有记录
local function _xyl_has_xianfu_refine()
    local data = _xyl_get_json("T47")
    local refine = data and data.refine and data.refine.collection
    if type(refine) == "table" then
        for _ in pairs(refine) do
            return true
        end
    end
    return false
end
-- 备注：仙府种植或药草是否有记录
local function _xyl_has_xianfu_plant()
    local data = _xyl_get_json("T47")
    local fields = data and data.fields
    if type(fields) == "table" then
        for _, plot in pairs(fields) do
            if type(plot) == "table" and plot.state and plot.state ~= "empty" then
                return true
            end
        end
    end
    local herbs = data and data.herbs
    if type(herbs) == "table" then
        for _, v in pairs(herbs) do
            if tonumber(v) and tonumber(v) > 0 then
                return true
            end
        end
    end
    return false
end
-- 备注：砍树系统是否有数据记录
local function _xyl_has_tree()
    local data = _xyl_get_json("T55")
    return next(data or {}) ~= nil
end
-- 备注：藏宝图累计完成次数 > 0
local function _xyl_has_treasure()
    return _xyl_get_num("U46") > 0
end
-- 备注：聚宝盆是否已修复/激活
local function _xyl_has_treasure_basin_fixed()
    local data = _xyl_get_json("T44")
    return (tonumber(data and data.rebuilt or 0) or 0) >= 1
end
-- 备注：灵兽全星级是否达到指定等级
local function _xyl_has_lingshou_star(star)
    local cfg = teshudata and teshudata["npc_64"]
    local count = 0
    if cfg and cfg.config and cfg.config.ls then
        count = #cfg.config.ls
    end
    if count <= 0 then
        return false
    end
    local data = _xyl_get_json("T50")
    local ls_sp = data.ls_sp or {}
    for i = 1, count do
        if (ls_sp[tostring(i)] or 0) < star then
            return false
        end
    end
    return true
end
-- 备注：是否拥有【唐代】古玩类道具
local function _xyl_has_tang_antique()
    local cfg = teshudata and teshudata["npc_65"]
    if not (cfg and cfg.config) then
        return false
    end
    local list = {}
    for _, it in ipairs(cfg.config) do
        for _, jl in ipairs(it.jl or {}) do
            if type(jl[1]) == "string" and jl[1]:find("【唐代】") then
                table.insert(list, jl[1])
            end
        end
    end
    return _xyl_has_any_item(list)
end
-- 备注：生肖守护是否全激活
local function _xyl_has_shengxiao_guard()
    local data = _xyl_get_json("T53")
    return (tonumber(data.level) or 0) >= 1
end
-- 备注：是否已激活全部圣遗物（灵兽圣遗物）
local function _xyl_has_all_syw()
    local data = _xyl_get_json("T50")
    if data.syw_all == 1 then
        return true
    end
    if _xyl_has_title("上古神兽掌控者") then
        return true
    end
    local syw = data.syw or {}
    for i = 1, 5 do
        if syw[tostring(i)] ~= 1 then
            return false
        end
    end
    return true
end
-- 备注：是否已激活全部天命装备（持有或穿戴）
local function _xyl_has_all_tianming()
    local list = {
        { name = "天命·复活", where = 12 },
        { name = "天命·麻痹", where = 14 },
        { name = "天命·神镰", where = 15 },
        { name = "天命·神斧", where = 9 },
    }
    for _, one in ipairs(list) do
        local ok = _xyl_has_item(one.name, 1)
        if not ok and one.where then
            ok = _xyl_has_equip_named(one.where, one.name)
        end
        if not ok then
            return false
        end
    end
    return true
end
-- 备注：剧情点验证入口（优先特殊逻辑，其次剧情完成）
local function _xyl_check_task(name)
    local key = _xyl_norm_name(name)
    local special = {
        ["天书强化"] = _xyl_has_tianshu_level,
        ["进行天书强化1次"] = _xyl_has_tianshu_level,
        ["初识仙法"] = _xyl_has_any_xianfa,
        ["进行天书仙法抽取"] = _xyl_has_any_xianfa,
        ["装备强化"] = _xyl_has_equip_strength,
        ["装备强化1次"] = _xyl_has_equip_strength,
        ["升级灵根"] = _xyl_has_linggen_feed,
        ["强化灵根"] = _xyl_has_linggen_feed,
        ["强化灵根1次"] = _xyl_has_linggen_feed,
        ["查看江湖称号"] = _xyl_has_jianghu_title,
        ["查看江湖称号1次"] = _xyl_has_jianghu_title,
        ["装配主灵根"] = _xyl_has_main_linggen,
        ["装配火灵根至主灵根"] = function() return _xyl_has_main_linggen_of(4) end,
        ["装配副灵根"] = _xyl_has_other_linggen,
        ["装配水灵根至副灵根"] = function() return _xyl_has_other_linggen_of(3) end,
        ["气运占卜"] = _xyl_has_divination,
        ["限时福利"] = _xyl_has_second_continent_welfare_open,
        ["引导点击限时福利NPC"] = _xyl_has_second_continent_welfare_open,
        ["洗炼天书"] = _xyl_has_second_continent_tianshu_refine,
        ["引导天书使者洗炼一次"] = _xyl_has_second_continent_tianshu_refine,
        ["查看幸运增幅"] = _xyl_has_second_continent_lucky_view,
        ["查看幸运增幅1次"] = _xyl_has_second_continent_lucky_view,
        ["筑基"] = _xyl_has_foundation_realm,
        ["提升修为至筑基境"] = _xyl_has_foundation_realm,
        ["转生·二"] = function() return _xyl_has_rebirth(20) end,
        ["完成转生"] = function() return _xyl_has_rebirth(20) end,
        ["完转生"] = function() return _xyl_has_rebirth(20) end,
        ["完成2大陆转生"] = function() return _xyl_has_rebirth(20) end,
        ["转生·三"] = function() return _xyl_has_rebirth(30) end,
        ["转生·四"] = function() return _xyl_has_rebirth(40) end,
        ["转生·五"] = function() return _xyl_has_rebirth(50) end,
        ["完成转生·五"] = function() return _xyl_has_rebirth(50) end,
        ["拥有1传说神石"] = _xyl_has_legendary_stone,
        ["传说·斗笠"] = _xyl_has_legendary_hat,
        ["神·酒葫芦"] = _xyl_has_god_gourd,
        ["高级淬体"] = _xyl_has_advanced_quench,
        ["开辟仙府"] = _xyl_has_xianfu_open,
        ["炼制丹药"] = _xyl_has_xianfu_refine,
        ["了解砍树"] = _xyl_has_tree,
        ["种植仙草"] = _xyl_has_xianfu_plant,
        ["寻宝大师"] = _xyl_has_treasure,
        ["修复聚宝盆"] = _xyl_has_treasure_basin_fixed,
        ["聚宝盆"] = _xyl_has_treasure_basin_fixed,
        ["聚宝盆任务"] = _xyl_has_treasure_basin_fixed,
        ["激活全部圣遗物"] = _xyl_has_all_syw,
        ["激活全部天命装备"] = _xyl_has_all_tianming,
        ["灵兽全一星"] = function() return _xyl_has_lingshou_star(2) end,
        ["灵兽全二星"] = function() return _xyl_has_lingshou_star(3) end,
        ["灵兽全三星"] = function() return _xyl_has_lingshou_star(4) end,
        ["唐代古玩"] = _xyl_has_tang_antique,
        ["红色仙法"] = _xyl_has_red_xianfa,
        ["生肖守护"] = _xyl_has_shengxiao_guard,
        ["修复轩辕剑"] = function()
            local cfg = teshudata and teshudata["npc_601"]
            return cfg and cfg.details and _xyl_has_title(cfg.details.ch)
        end,
        ["灾厄入侵"] = function()
            local cfg = teshudata and teshudata["npc_46"]
            return cfg and _xyl_has_title(cfg.ch)
        end,
    }
    if special[key] then
        return special[key]()
    end
    return _xyl_check_story(key)
end
-- 备注：客户端可见进度判定入口
local function _xyl_khdjy(task)
    if not task then
        return false
    end
    local tk = task.tk or task[1]
    if not tk or tk == "" then
        return false
    end
    return _xyl_check_task(tk)
end
local function _xyl_get_chapter_cfg(taskData, l, zj)
    local lCfg = taskData and taskData[l]
    if type(lCfg) ~= "table" then
        return nil
    end
    return lCfg[zj]
end
local function _xyl_get_task_reward_jqd(task)
    local total = 0
    local rewards = type(task) == "table" and task.jl or nil
    if type(rewards) ~= "table" then
        return 0
    end
    for _, reward in ipairs(rewards) do
        if type(reward) == "table" and reward[1] == "剧情点" then
            total = total + (tonumber(reward[2]) or 0)
        end
    end
    return total
end
local function _xyl_is_task_done_for_jqd(task)
    if type(task) ~= "table" then
        return false
    end
    local checker = task.khdjy
    if type(checker) ~= "function" then
        return false
    end
    local ok, done = pcall(checker, task)
    return ok and done == true
end
local function _xyl_get_completed_chapter_reward_jqd(taskData, l, zj)
    local cfg = _xyl_get_chapter_cfg(taskData, l, zj)
    local tasks = cfg and cfg.jq
    if type(tasks) ~= "table" then
        return 0
    end
    local total = 0
    local hasFinishedTask = false
    for _, task in ipairs(tasks) do
        if _xyl_is_task_done_for_jqd(task) then
            total = total + _xyl_get_task_reward_jqd(task)
            hasFinishedTask = true
        end
    end
    if not hasFinishedTask then
        return 0
    end
    return total
end
local function _xyl_should_ignore_ruoshui_jqd(l, zj)
    l = tonumber(l) or 0
    zj = tonumber(zj) or 0
    return l > 3 or (l == 3 and zj >= 2)
end
local function _xyl_adjust_unlock_jqd(taskData, l, zj, curJqd)
    local nowJqd = tonumber(curJqd) or 0
    if not _xyl_should_ignore_ruoshui_jqd(l, zj) then
        return nowJqd
    end
    local ruoshuiJqd = _xyl_get_completed_chapter_reward_jqd(taskData, 3, 1)
    if ruoshuiJqd <= 0 then
        return nowJqd
    end
    nowJqd = nowJqd - ruoshuiJqd
    if nowJqd < 0 then
        nowJqd = 0
    end
    return nowJqd
end
local function _xyl_to_pre_list(pre)
    if type(pre) ~= "table" then
        return nil
    end
    if pre[1] ~= nil then
        return pre
    end
    if pre.l or pre.i or pre.zj or pre.j or pre.idx or pre.k or pre.tip or pre.check then
        return { pre }
    end
    return nil
end
local function _xyl_check_chapter_pre(taskData, pre)
    if type(pre) ~= "table" then
        return true
    end
    if type(pre.check) == "function" then
        return pre.check() and true or false
    end
    local l = tonumber(pre.l or pre.i)
    local zj = tonumber(pre.zj or pre.j)
    local idx = tonumber(pre.idx or pre.k) or 1
    if not l or not zj then
        return false
    end
    local cfg = _xyl_get_chapter_cfg(taskData, l, zj)
    local task = cfg and cfg.jq and cfg.jq[idx]
    if not task then
        return false
    end
    if task.khdjy then
        return task.khdjy(task) and true or false
    end
    return false
end
local function _xyl_get_chapter_lock_info(taskData, l, zj, curJqd)
    local cfg = _xyl_get_chapter_cfg(taskData, l, zj)
    if not cfg then
        return { locked = false, tip = "", ext_tips = {}, cur_jqd = tonumber(curJqd) or 0, need_jqd = 0, lack_jqd = false }
    end
    local nowJqd = _xyl_adjust_unlock_jqd(taskData, l, zj, curJqd)
    local needJqd = tonumber(cfg.jqd) or 0
    local lackJqd = cfg.jqd and nowJqd < needJqd
    local locked = lackJqd and true or false
    local tip = lackJqd and string.format("剧情点不足：%d/%d", nowJqd, needJqd) or ""
    local extTips = {}
    local preList = _xyl_to_pre_list(cfg.pre) or _xyl_to_pre_list(cfg.unlock_pre)
    if preList then
        for _, pre in ipairs(preList) do
            local ok = _xyl_check_chapter_pre(taskData, pre)
            if not ok then
                locked = true
                if tip == "" then
                    tip = pre.lock_tip or pre.lockTip or "章节未解锁"
                end
                local ext = pre.tip or pre.desc
                if ext and ext ~= "" then
                    table.insert(extTips, tostring(ext))
                end
            end
        end
    end
    return {
        locked = locked,
        tip = tip,
        ext_tips = extTips,
        cur_jqd = nowJqd,
        need_jqd = needJqd,
        lack_jqd = lackJqd and true or false,
    }
end
local npc_xyl = {
    {},
    {
    {
        jq = {
            {
                "天书强化",
                id = 999,
                jl = { { "剧情点", 1 }, { "仙法卷轴", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "前往天书界面完成首次强化，让天书正式发挥作用。\n<font color='#F4D179'>目标：</font>将天书提升至1级\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "初识仙法",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "在天书中完成一次仙法抽取，正式掌握仙法力量。\n<font color='#F4D179'>目标：</font>已获得任意仙法\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "限时福利",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 105, 95, 106 },
                desc = "前往限时福利界面查看当前阶段奖励，熟悉前期补给来源。\n<font color='#F4D179'>目标：</font>成功打开限时福利\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "扫荡野火帮（剧）",
                tk = "npc_603",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = true,
                yd = { 1, "野火帮", 603, 100, 223 },
                desc = "深入野火帮外围清剿匪徒，用连续战斗打开剧情缺口。\n<font color='#F4D179'>目标：</font>击杀怪物30只\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "气运占卜",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 26, 110, 106 },
                desc = "进行一次气运占卜，开启命格与气运加成的第一步。\n<font color='#F4D179'>目标：</font>完成1次气运占卜\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "深入野火（剧）",
                tk = "npc_607",
                id = 999,
                jl = { { "剧情点", 1 }, { "激活火灵根", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "野火帮大营", 607, 60, 279 },
                desc = "清理现场后搜集罪证，将野火帮的恶行作为后续调查线索。\n<font color='#F4D179'>目标：</font>\n提交野火帮罪证×10\n<font color='#F4D179'>进度：</font>%s",
            },
        },
        name = "初入江湖",
        jqd = 0,
        jl = { { "1元真实充值", 1 }, { "激活火灵根", 1 } },
    },
    {
        jq = {
            {
                "装配主灵根",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "前往灵根界面将火灵根装配到主灵根位置，先建立核心灵根方向。\n<font color='#F4D179'>目标：</font>主灵根为火灵根\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "聚宝盆",
                tk = "npc_106",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "极光城郊", 106, 83, 166 },
                desc = "收集聚宝盆碎片×20并完成重铸，修复聚宝盆后可继续解锁后续成长内容。\n<font color='#F4D179'>目标：</font>修复聚宝盆\n<font color='#F4D179'>进度：</font>%s\n<font color='#FF0000'>首充礼包中赠送</font>",
            },
            {
                "洗炼天书",
                id = 999,
                jl = { { "剧情点", 1 }, { "激活水灵根", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 104, 100, 106 },
                desc = "前往天书使者完成一次洗炼，熟悉天书附魔强化路线。\n<font color='#F4D179'>目标：</font>完成1次天书使者洗炼\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "装配副灵根",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "返回灵根界面将水灵根装配到副灵根位置，补齐第二道灵根属性。\n<font color='#F4D179'>目标：</font>副灵根为水灵根\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "装备强化1次",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 28, 115, 106 },
                desc = "前往装备强化界面完成一次强化，让角色拥有更稳定的正向成长。\n<font color='#F4D179'>目标：</font>完成任意部位装备强化\n<font color='#F4D179'>进度：</font>%s",
            },
        },
        name = "小试牛刀",
        jqd = 4,
        jl = { { "1元真实充值", 1 }, { "激活木灵根", 1 } },
    },
    {
        jq = {
            {
                "守护森林（剧）",
                tk = "npc_608",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = true,
                yd = { 1, "神秘森林", 608, 52, 53 },
                desc = "持续肃清林地中的杂兵，稳定整片区域的安全局势。\n<font color='#F4D179'>目标：</font>击杀怪物50只\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "查看江湖称号",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 43, 119, 122 },
                desc = "前往江湖称号界面查看称号信息，熟悉当前江湖成长方向。\n<font color='#F4D179'>目标：</font>查看江湖称号\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "杀伐之路（剧）",
                tk = "npc_605",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = true,
                yd = { 1, "杀伐道场", 605, 103, 53 },
                desc = "在血战中证明自己，继续推进主线杀伐节奏。\n<font color='#F4D179'>目标：</font>击杀怪物30只\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "查看幸运增幅",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 25, 105, 106 },
                desc = "前往幸运增幅界面查看当前强化成长，了解幸运体系提升方向。\n<font color='#F4D179'>目标：</font>成功查看幸运增幅\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "掘墓人（剧）",
                tk = "npc_610",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "乱葬岗", 610, 170, 212 },
                desc = "从古墓线索中带回关键古物，推进墓地支线真相。\n<font color='#F4D179'>目标：</font>提交唐三彩×5\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "强化灵根",
                id = 999,
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "完成一次灵根培养，让修炼体系正式进入进阶阶段。\n<font color='#F4D179'>目标：</font>完成1次灵根升级\n<font color='#F4D179'>进度：</font>%s",
            },
        },
        name = "漫漫仙途",
        jqd = 8,
        jl = { { "1元真实充值", 1 }, { "激活水灵根", 1 } },
    },
    {
        jq = {
            {
                "讨伐夜魔（剧）",
                tk = "npc_606",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = true,
                yd = { 1, "夜魔洞", 606, 98, 95 },
                desc = "夜探夜魔洞深处，清剿潜伏在暗处的红名魔物。\n<font color='#F4D179'>目标：</font>击杀红名怪10只\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "古刹之谜（剧）",
                tk = "npc_609",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "洞穴秘境", 609, 143, 153 },
                desc = "收集古刹异变残留物，拼出幕后事件的关键线索。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>杀意碎片</font>   %s\n<font color='#F0B42A'>煞气</font>   %s",
            },
            {
                "修复轩辕剑（剧）",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 601, 91, 116 },
                desc = "沿着前置剧情完成轩辕剑修复，补足这一阶段的主线关键节点。\n<font color='#F4D179'>目标：</font>\n完成修复轩辕剑剧情\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "筑基",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 3, 14 },
                desc = "提升修为境界并跨入筑基境，完成二大陆阶段性的修炼突破。\n<font color='#F4D179'>目标：</font>境界达到筑基境\n<font color='#F4D179'>进度：</font>%s",
            },
            {
                "完成转生",
                id = 999,
                jl = { { "剧情点", 1 } },
                fwdjy = nil,
                khdjy = _xyl_khdjy,
                need_receive = false,
                yd = { 1, "二大陆主城", 33, 90, 127 },
                desc = "完成第二阶段转生突破，为下阶段大陆成长做好准备。\n<font color='#F4D179'>目标：</font>转生达到二阶要求\n<font color='#F4D179'>进度：</font>%s",
            },
        },
        name = "融会贯通",
        jqd = 11,
        jl = { { "1元真实充值", 1 }, { "仙法卷轴", 1 } },
    },
    },
    {
        {
            jq = {
                {
                    "开辟仙府",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 55, 146, 234 },
                    desc = "开辟仙府，正式踏入灰界后的修行之路。\n<font color='#F4D179'>目标：</font>成功开启仙府\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "讨伐嘲灾",
                    tk = "npc_625",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "鬼嘲深渊", 625, 174, 460 },
                    desc = "前往灾厄入口，进入嘲灾讨伐线。\n<font color='#F4D179'>目标：</font>完成讨伐嘲灾\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "讨伐息灾",
                    tk = "npc_627",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "叹息旷野", 627, 85, 126 },
                    desc = "前往灾厄入口，进入息灾讨伐线。\n<font color='#F4D179'>目标：</font>完成讨伐息灾\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "讨伐忌灾",
                    tk = "npc_626",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "禁忌之海", 626, 74, 67 },
                    desc = "前往灾厄入口，进入忌灾讨伐线。\n<font color='#F4D179'>目标：</font>完成讨伐忌灾\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "讨伐妄灾",
                    tk = "npc_628",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "虚妄山脉", 628, 107, 97 },
                    desc = "前往灾厄入口，进入妄灾讨伐线。\n<font color='#F4D179'>目标：</font>完成讨伐妄灾\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灾厄入侵",
                    tk = "npc_46",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "灰界", 46, 205, 196 },
                    desc = "完成四线讨伐后，回到灾厄入口提交总任务。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>讨伐嘲灾</font>   %s\n<font color='#F0B42A'>讨伐忌灾</font>   %s\n<font color='#F0B42A'>讨伐息灾</font>   %s\n<font color='#F0B42A'>讨伐妄灾</font>   %s",
                },
            },
            name = "灰界开篇",
            jqd = 11,
            jl = { { "1元真实充值", 1 }, { "仙法卷轴", 1 } },
        },
        {
            jq = {
                {
                    "种植仙草",
                    id = 999,
                    jl = { { "剧情点", 1 }, { "藏宝图碎片", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 3, 14 },
                    desc = "在仙府中亲手种下一次仙草，为后续炼丹线做准备。\n<font color='#F4D179'>目标：</font>完成1次仙草种植\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "了解砍树",
                    id = 999,
                    jl = { { "剧情点", 1 }, { "藏宝图碎片", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 3, 14 },
                    desc = "开启自动砍树功能，掌握仙府资源获取的另一条支线。\n<font color='#F4D179'>目标：</font>成功开启自动砍树\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "寻宝大师",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 47, 154, 223 },
                    desc = "在仙府中制作一次藏宝图，打通寻宝玩法入口。\n<font color='#F4D179'>目标：</font>完成1次藏宝图制作\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "仙府功能",
            jqd = 11,
            pre = {
                check = function()
                    return _xyl_check_task("开辟仙府")
                end,
                lock_tip = "需先解锁仙府",
                tip = "请先完成【开辟仙府】后再进入本章节",
            },
            jl = {{ "1元真实充值", 2 }, { "激活金灵根", 1 }},
        },
        {
            jq = {
                {
                    "杀戮的欲望",
                    tk = "npc_634",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "藏星外海", 634, 69, 132 },
                    desc = "在海域线前期进行大规模清怪，用持续战斗打开沉船支线。\n<font color='#F4D179'>目标：</font>击杀怪物300只\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "沉船之谜",
                    tk = "npc_629",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "千年沉船", 629, 44, 34 },
                    desc = "前往沉船残骸搜集两把关键钥匙。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>船长室钥匙</font>   %s\n<font color='#F0B42A'>水手舱钥匙</font>   %s",
                },
                {
                    "船长的宝藏",
                    tk = "npc_630",
                    ydtk = "npc_629",
                    ydtip = "沉船之谜",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "船长室", 630, 29, 34 },
                    desc = "收集宝藏碎片并反复提交，逐步拼出沉船最终宝藏的全貌。\n<font color='#F4D179'>目标：</font>宝藏碎片×10，累计提交3次\n<font color='#F4D179'>提交进度：</font>%s\n<font color='#F4D179'>背包拥有：</font>%s",
                },
                {
                    "谁是内鬼",
                    tk = "npc_631",
                    ydtk = "npc_629",
                    ydtip = "沉船之谜",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "水手舱", 631, 30, 36 },
                    desc = "通过多轮审问排查船上叛徒，确认真凶前需要反复调查。\n<font color='#F4D179'>目标：</font>\n累计完成4次审问/确认\n<font color='#F4D179'>确认进度：</font>%s",
                },
            },
            name = "外海之旅",
            jqd = 17,
            jl = {{ "1元真实充值", 2 }, { "激活土灵根", 1 }},
        },
        {
            jq = {
                {
                    "送葬者",
                    tk = "npc_635",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "藏星内海", 635, 81, 166 },
                    desc = "清理内海路线上的敌人，为后续海贼剧情腾出推进空间。\n<font color='#F4D179'>目标：</font>击杀怪物50只\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "热血的友情",
                    tk = "npc_636",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "七星岛", 636, 159, 408 },
                    desc = "收集友情信物并多次上交，逐步唤醒海贼同伴之间的羁绊。\n<font color='#F4D179'>目标：</font>热血的友情×10，累计提交3次\n<font color='#F4D179'>提交进度：</font>%s",
                },
                {
                    "真正的海贼王",
                    tk = "npc_637",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "葬星城", 637, 110, 96 },
                    desc = "集齐核心伙伴的象征物与海贼意志。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>路飞的帽子</font>   %s\n<font color='#F0B42A'>索隆的刀</font>   %s\n<font color='#F0B42A'>乌索普的弹弓</font>   %s\n<font color='#F0B42A'>海贼意志</font>   %s",
                },
                {
                    "海滩拾贝",
                    tk = "npc_632",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "在海域边缘搜集足量贝壳，作为海盗支线的基础材料。\n<font color='#F4D179'>目标：</font>提交贝壳×20\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "海盗宝藏",
                    tk = "npc_633",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "击败海盗头目后上交关键凭证，解锁后续更深层的藏宝线索。\n<font color='#F4D179'>目标：</font>提交海盗头目信物\n<font color='#F4D179'>状态：</font>完成后自动计入剧情",
                },
            },
            name = "内海探秘",
            jqd = 21,
            jl = {{ "1元真实充值", 2 }, { "神石宝箱钥匙", 1 }},
        },
        {
            jq = {
                {
                    "采仙草咯",
                    tk = "npc_638",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "草药古深处", 638, 31, 51 },
                    desc = "在草谷中反复采集任务仙草，为丹道线准备原料。\n<font color='#F4D179'>目标：</font>\n采集仙草[任务]×20\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "丹仙秘辛",
                    tk = "npc_639",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "丹道古藏", 639, 243, 97 },
                    desc = "搜集散落残页，拼凑丹仙一脉失传的秘辛真相。\n<font color='#F4D179'>目标：</font>\n提交丹仙秘辛残页×10\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "棋痴老王",
                    tk = "npc_640",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "苍云客栈", 640, 26, 58 },
                    desc = "与棋痴老王对局并赢下残局，用技巧而不是战力推动剧情。\n<font color='#F4D179'>目标：</font>赢得五子棋残局\n<font color='#F4D179'>状态：</font>完成后自动计入剧情",
                },
            },
            name = "草谷丹道",
            jqd = 26,
            jl = {{ "1元真实充值", 2 }, { "神石宝箱钥匙", 1 }},
        },
        {
            jq = {
                {
                    "拥有1传说神石",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 53, 161, 230 },
                    desc = "获取任意一枚传说品质神石，证明当前神石养成已达到更高层级。\n<font color='#F4D179'>目标：</font>持有1枚传说神石\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "传说·斗笠",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 51, 153, 230 },
                    desc = "将斗笠成长线推进到传说层级，补齐三大陆关键成长节点。\n<font color='#F4D179'>目标：</font>制作传说·斗笠\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "神·酒葫芦",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 52, 157, 230 },
                    desc = "把酒葫芦提升到神级品质，完成同阶段核心成长要求。\n<font color='#F4D179'>目标：</font>制作神·酒葫芦\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "高级淬体",
                    tk = "npc_53",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "三大陆主城", 53, 161, 230 },
                    desc = "完成高级淬体中的五行锻体，正式迈入更高阶体魄强化。\n<font color='#F4D179'>目标：</font>\n完成高级淬体五行锻体\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "转生·三",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "xtc", 34, 136, 121 },
                    desc = "继续推进转生系统，将角色突破到第三阶段。\n<font color='#F4D179'>目标：</font>转生达到三阶\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "三大陆毕业章",
            jqd = 11,
            jl = {{ "1元真实充值", 5 }, { "等级卷轴", 5 }},
        },
    },
    {
        {
            jq = {
                {
                    "灵兽全一星",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 64, 38, 27 },
                    desc = "让当前全部灵兽至少达到一星，完成灵兽系统的基础培育。\n<font color='#F4D179'>目标：</font>全部灵兽达到一星\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灵兽全二星",
                    id = 999,
                    jl = { { "剧情点", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 64, 38, 27 },
                    desc = "继续培养全部灵兽，让队伍整体迈入二星阶段。\n<font color='#F4D179'>目标：</font>全部灵兽达到二星\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灵兽全三星",
                    id = 999,
                    jl = { { "剧情点", 10 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 64, 38, 27 },
                    desc = "把全部灵兽提升至三星，完成更高一档的灵兽养成检定。\n<font color='#F4D179'>目标：</font>全部灵兽达到三星\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "唐代古玩",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 65, 28, 23 },
                    desc = "在古玩鉴定中成功获得一件唐代古玩，作为鉴宝线的阶段证明。\n<font color='#F4D179'>目标：</font>鉴定出唐代古玩\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "红色仙法",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "二大陆主城", 24, 100, 106 },
                    desc = "获得红色品质仙法，说明仙法系统已进入高阶阶段。\n<font color='#F4D179'>目标：</font>持有红色仙法\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "转生·四",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "xtc", 35, 140, 121 },
                    desc = "完成第四阶段转生，为后续高阶剧情做准备。\n<font color='#F4D179'>目标：</font>转生达到四阶\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "若水秘闻",
            jqd = 40,
            jl = { { "等级卷轴", 20 }, { "1元真实充值", 25 } },
        },
        {
            jq = {
                {
                    "捉鬼人",
                    tk = "npc_666",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "酆都鬼城", 666, 84, 50 },
                    desc = "在鬼城中一边超度亡魂一边收集灵魂残片，属于击杀与提交并行任务。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>击杀100只怪物</font>   %s\n<font color='#F0B42A'>提交亡者灵魂</font>   %s",
                },
                {
                    "买路钱",
                    tk = "npc_667",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "鬼门关", 667, 83, 95 },
                    desc = "前往鬼门关缴纳通关代价，既要令牌也要准备足额金币。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>鬼界令牌</font>   %s\n<font color='#F0B42A'>金币</font>   %s",
                },
                {
                    "思念之人",
                    tk = "npc_668",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "以彼岸花与金币寄托执念，完成这段偏情感向的地府支线。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>彼岸花</font>   %s\n<font color='#F0B42A'>金币</font>   %s",
                },
                {
                    "忘却前生情",
                    tk = "npc_669",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "收集孟婆汤并交付，让执念彻底放下并进入下一环。\n<font color='#F4D179'>目标：</font>提交孟婆汤×10\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "讨伐六天宫",
                    tk = "npc_670",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "收集六天宫残魂后进行交付，作为更深层地府线的前置任务。\n<font color='#F4D179'>目标：</font>\n提交六天宫残魂×10\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "地狱使者",
                    tk = "npc_671",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "通过地狱十八层的连续挑战，证明自己具备深入地狱的资格。\n<font color='#F4D179'>目标：</font>\n通过地狱十八层挑战\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "轮回之路",
                    tk = "npc_672",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "完成六道轮回试炼，这是地府篇的重要收束节点。\n<font color='#F4D179'>目标：</font>通过轮回六道试炼\n<font color='#F4D179'>状态：</font>完成后自动计入剧情",
                },
            },
            name = "地府探秘",
            jqd = 47,
            jl = { { "等级卷轴", 5 }, { "1元真实充值", 8 } },
        },
        {
            jq = {
                {
                    "资格考验",
                    tk = "npc_642",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "大唐·长安城", 642, 35, 57 },
                    desc = "西游篇起点任务，需要同时处理普通敌人与BOSS，缺一不可。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>怪物</font>   %s\n<font color='#F0B42A'>BOSS</font>   %s",
                },
                {
                    "龙王的噩梦",
                    tk = "npc_643",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "深入龙宫调查噩梦真相，先交齐虾兵与蟹将的头颅作为凭证。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>虾兵的头颅</font>   %s\n<font color='#F0B42A'>蟹将的头颅</font>   %s",
                },
                {
                    "我的袈裟！",
                    tk = "npc_644",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "先击败黑风大王，再交回师傅的袈裟，是典型的击杀+提交双线任务。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>击杀黑风大王</font>   %s\n<font color='#F0B42A'>提交师傅的袈裟</font>   %s",
                },
                {
                    "黄风大圣",
                    tk = "npc_645",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "挑战黄风大圣后再交付黄风谷特产，推进西行中的又一难关。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>击杀黄风大圣</font>   %s\n<font color='#F0B42A'>提交黄风谷特产</font>   %s",
                },
                {
                    "你竟是女王？",
                    tk = "npc_646",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "前往女儿国完成对应剧情事件，这一环更偏互动推进而非刷怪。\n<font color='#F4D179'>目标：</font>\n完成女儿国相关剧情\n<font color='#F4D179'>状态：</font>按任务提示推进即可",
                },
                {
                    "驮我过河",
                    tk = "npc_647",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "根据任务引导完成过河流程，这是路线型推进任务。\n<font color='#F4D179'>目标：</font>按指引通过驮我过河\n<font color='#F4D179'>状态：</font>跟随任务流程即可",
                },
                {
                    "大闹狮驼岭",
                    tk = "npc_648",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "狮驼岭三王需要分别击败，每一只都单独统计。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>★青狮★</font>   %s\n<font color='#F0B42A'>★白象★</font>   %s\n<font color='#F0B42A'>★大鹏★</font>   %s",
                },
                {
                    "真假经书",
                    tk = "npc_649",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "对经书进行鉴定与判定，完成真假辨别后才能拿到真正的西行成果。\n<font color='#F4D179'>目标：</font>完成经书鉴定\n<font color='#F4D179'>状态：</font>按任务流程推进",
                },
                {
                    "重走西游路",
                    tk = "npc_641",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 641, 37, 42 },
                    desc = "完成整条西游支线的最终收束，补齐西行篇全部关键节点。\n<font color='#F4D179'>目标：</font>完成重走西游路\n<font color='#F4D179'>状态：</font>完成后自动计入剧情",
                },
            },
            name = "重走西游",
            jqd = 46,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
        {
            jq = {
                {
                    "天鼠的游戏",
                    tk = "npc_651",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "进入子鼠灵域回答谜题，偏解谜与判定类型。\n<font color='#F4D179'>目标：</font>完成天鼠谜题回答\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天牛的游戏",
                    tk = "npc_652",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "在丑牛灵域满足试炼条件，更偏规则判定而非单纯战斗。\n<font color='#F4D179'>目标：</font>达成天牛试炼要求\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天虎的游戏",
                    tk = "npc_653",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "在寅虎灵域以纯战斗形式完成试炼要求。\n<font color='#F4D179'>目标：</font>击杀怪物300只\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天兔的游戏",
                    tk = "npc_654",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "在卯兔灵域于限制条件内抵达终点，考验路线与操作。\n<font color='#F4D179'>目标：</font>限时抵达终点\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灵域使者·一",
                    tk = "npc_663",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "完成灵域第一层全部四项试炼后，回到使者处进行总确认。\n<font color='#F4D179'>目标：</font>\n天鼠/天牛/天虎/天兔试炼全部通过\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "生肖守护[始]",
            jqd = 46,
            jl = { { "等级卷轴", 5 }, { "1元真实充值", 8 } },
        },
        {
            jq = {
                {
                    "天龙的游戏",
                    tk = "npc_655",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "准备好龙珠后提交，是生肖守护中偏收集型的任务节点。\n<font color='#F4D179'>目标：</font>提交龙珠\n<font color='#F4D179'>状态：</font>满足条件后自动计入剧情",
                },
                {
                    "天蛇的游戏",
                    tk = "npc_656",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "在巳蛇灵域提交蛇图腾碎片，完成收集验证。\n<font color='#F4D179'>目标：</font>提交蛇图腾碎片×1\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天马的游戏",
                    tk = "npc_657",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "准备足够的摸鱼能力卡后交付，完成午马试炼需求。\n<font color='#F4D179'>目标：</font>提交摸鱼能力卡×5\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天羊的游戏",
                    tk = "npc_658",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "未羊灵域的核心要求是持续清怪达标。\n<font color='#F4D179'>目标：</font>击杀333只怪物\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灵域使者·二",
                    tk = "npc_664",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "完成灵域第二层四项试炼后，再回使者处合并确认。\n<font color='#F4D179'>目标：</font>\n天龙/天蛇/天马/天羊试炼全部通过\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "生肖守护[转]",
            jqd = 46,
            jl = { { "等级卷轴", 5 }, { "1元真实充值", 8 } },
        },
        {
            jq = {
                {
                    "天猴的游戏",
                    tk = "npc_659",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "需要同时准备天猴的卡牌与元宝，是资源双重提交任务。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>天猴的卡牌</font>   %s\n<font color='#F0B42A'>元宝</font>   %s",
                },
                {
                    "天鸡的游戏",
                    tk = "npc_660",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "收集足够的凤凰羽毛后提交，完成酉鸡灵域试炼。\n<font color='#F4D179'>目标：</font>提交凤凰的羽毛×10\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天狗的游戏",
                    tk = "npc_661",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 0 },
                    desc = "戌狗灵域要求高强度战斗，坚持完成大量清怪。\n<font color='#F4D179'>目标：</font>击杀500只怪物\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天猪的游戏",
                    tk = "npc_662",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "亥猪灵域为条件判定类任务，按任务要求达成即可。\n<font color='#F4D179'>目标：</font>达成天猪试炼要求\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "灵域使者·三",
                    tk = "npc_665",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "灵域第三层四项试炼全部完成后，向最终使者汇总确认。\n<font color='#F4D179'>目标：</font>\n天猴/天鸡/天狗/天猪试炼全部通过\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "生肖守护",
                    tk = "npc_67",
                    id = 999,
                    jl = { { "剧情点", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "四大陆主城", 67, 36, 23 },
                    desc = "十二生肖全部试炼通过后，回到主城完成整条生肖守护收束。\n<font color='#F4D179'>目标：</font>通过十二生肖守护试炼\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "生肖守护[终]",
            jqd = 46,
            jl = { { "等级卷轴", 5 }, { "1元真实充值", 8 } },
        },
        {
            jq = {
                {
                    "传说修复局",
                    tk = "npc_673",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "盘古开天", 673, 67, 48 },
                    desc = "前往盘古场景唤醒盘古，开启传说修复局的第一则试炼。\n<font color='#F4D179'>目标：</font>叫醒盘古\n<font color='#F4D179'>状态：</font>按任务流程推进",
                },
                {
                    "盘古开天",
                    tk = "npc_674",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "羿射九日", 674, 355, 119 },
                    desc = "收集洪荒真气并交给盘古，助他重新挥斧开天，完成传说修复的关键一步。\n<font color='#F4D179'>目标：</font>提交洪荒真气×3\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "羿射九日",
                    tk = "npc_675",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "不周山", 675, 75, 77 },
                    desc = "备好逐日弓后不断收集箭矢，逐次完成射日，直到多余的太阳全部被射落。\n<font color='#F4D179'>目标：</font>持有逐日弓，并反复消耗箭矢完成九次射日\n当前箭矢：%s",
                },
                {
                    "共公怒触不周山",
                    tk = "npc_676",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "女娲补天", 676, 110, 58 },
                    desc = "前往不周山持续清剿目标，重现共公怒触不周山后的崩裂战场，完成本段讨伐试炼。\n<font color='#F4D179'>目标：</font>\n击败不周山怪物×500\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "女娲补天",
                    tk = "npc_677",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "女娲补天", 677, 102, 58 },
                    desc = "搜集五彩石反复上交，逐步修补破碎天幕，直至女娲补天的整段传说彻底完成。\n<font color='#F4D179'>目标：</font>提交五彩石并持续推进补天流程\n当前五彩石：%s",
                },
                {
                    "后土娘娘",
                    tk = "npc_678",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "黑白无常", 678, 101, 57 },
                    desc = "后土娘娘为多阶段传说试炼，需要依次准备判官笔、击败场景怪物、收集牛头鼻环与马面梳子\n<font color='#F4D179'>目标：</font>按阶段完成后土娘娘全部八步流程\n<font color='#F4D179'>状态：</font>%s",
                },
                {
                    "黑白无常",
                    tk = "npc_679",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "后土娘娘", 679, 152, 171 },
                    desc = "收集友情的力量后交给黑白无常，完成这一段关于阴阳往返的传说分支。\n<font color='#F4D179'>目标：</font>\n提交友情的力量×10\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "真假玉帝",
                    tk = "npc_680",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = true,
                    yd = { 1, "真假玉帝", 680, 84, 93 },
                    desc = "真假玉帝需要同时准备鱼竿与鱼饵，两项都满足才可推进。\n<font color='#F4D179'>目标：</font>\n<font color='#F0B42A'>鱼竿</font>   %s\n<font color='#F0B42A'>鱼饵</font>   %s",
                },
                {
                    "白蛇传说",
                    tk = "npc_681",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "白蛇传说", 681, 216, 167 },
                    desc = "白蛇传说是超长累计提交任务，需要不断重复提交礼物完成整段剧情。\n<font color='#F4D179'>目标：</font>白蛇的礼物×1，累计提交100次\n<font color='#F4D179'>提交进度：</font>%s\n<font color='#F4D179'>背包拥有：</font>%s",
                },
            },
            name = "修复传说",
            jqd = 70,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
    },
    {
        {
            jq = {
                {
                    "灵兽奥秘",
                    tk = "npc_682",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "灵兽谷", 682, 88, 91 },
                    desc = "踏入灵兽奥秘，探寻灵兽之源。\n<font color='#F4D179'>目标：</font>灵兽奥秘\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "激活全部圣遗物",
                    id = 999,
                    jl = { { "剧情点", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "为全部灵兽激活圣遗物。\n<font color='#F4D179'>目标：</font>激活全部圣遗物\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "激活全部天命装备",
                    id = 999,
                    jl = { { "剧情点", 5 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "集齐并激活全部天命装备。\n<font color='#F4D179'>目标：</font>激活全部天命装备\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "完成转生·五",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 0 },
                    desc = "完成转生·五，跨入更高境界。\n<font color='#F4D179'>目标：</font>完成转生·五\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "红尘秘闻",
            jqd = 80,
            jl = { { "等级卷轴", 20 }, { "1元真实充值", 25 } },
        },
        {
            jq = {
                {
                    "时空之门",
                    tk = "npc_688",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "时空裂隙", 688, 54, 277 },
                    desc = "开启时空之门，踏入裂隙。\n<font color='#F4D179'>目标：</font>时空之门\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "屠龙宝刀",
                    tk = "npc_714",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "冰火岛", 714, 34, 51 },
                    desc = "屠龙宝刀出世，拔刀破敌。\n<font color='#F4D179'>目标：</font>屠龙宝刀\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "围攻光明顶",
                    tk = "npc_715",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "光明顶", 715, 46, 42 },
                    desc = "围攻光明顶，夺取乾坤之力。\n<font color='#F4D179'>目标：</font>围攻光明顶\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "孤身战吕布",
                    tk = "npc_716",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "虎牢关", 716, 238, 238 },
                    desc = "孤身战吕布，破阵夺势。\n<font color='#F4D179'>目标：</font>孤身战吕布\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "火烧赤壁",
                    tk = "npc_717",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "赤壁", 717, 258, 53 },
                    desc = "火烧赤壁，胜局已定。\n<font color='#F4D179'>目标：</font>火烧赤壁\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "景阳冈打虎",
                    tk = "npc_718",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "景阳冈", 718, 52, 151 },
                    desc = "景阳冈打虎，名扬四方。\n<font color='#F4D179'>目标：</font>景阳冈打虎\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "血溅狮子楼",
                    tk = "npc_719",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "狮子楼", 719, 93, 44 },
                    desc = "血溅狮子楼，快意恩仇。\n<font color='#F4D179'>目标：</font>血溅狮子楼\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "时空守护者",
                    tk = "npc_690",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "五大陆主城", 690, 24, 13 },
                    desc = "直面时空守护者，守护时空秩序。\n<font color='#F4D179'>目标：</font>时空守护者\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "守护时空",
            jqd = 90,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
        {
            jq = {
                {
                    "神庙逃亡",
                    tk = "npc_696",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "白骨神庙", 696, 336, 153 },
                    desc = "神庙逃亡，避开杀机。\n<font color='#F4D179'>目标：</font>神庙逃亡\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "祭祀河神",
                    tk = "npc_698",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "诡冥墨河", 698, 120, 130 },
                    desc = "祭祀河神，平息河患。\n<font color='#F4D179'>目标：</font>祭祀河神\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "赤焰试炼",
                    tk = "npc_700",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "赤焰焚殿", 700, 28, 104 },
                    desc = "赤焰试炼，淬火成锋。\n<font color='#F4D179'>目标：</font>赤焰试炼\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "葬天试炼",
                    tk = "npc_701",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "葬天旧土", 701, 247, 244 },
                    desc = "葬天试炼，踏破旧土。\n<font color='#F4D179'>目标：</font>葬天试炼\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "生命边界之谜",
                    tk = "npc_692",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "五大陆主城", 692, 32, 13 },
                    desc = "破解生命边界之谜。\n<font color='#F4D179'>目标：</font>生命边界之谜\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "生命边界",
            jqd = 100,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
        {
            jq = {
                {
                    "倩女幽魂",
                    tk = "npc_702",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "兰若寺", 702, 88, 74 },
                    desc = "倩女幽魂，镇杀幽魂。\n<font color='#F4D179'>目标：</font>倩女幽魂\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "画中仙境",
                    tk = "npc_703",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "画壁", 703, 33, 57 },
                    desc = "画中仙境，探寻真相。\n<font color='#F4D179'>目标：</font>画中仙境\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "崂山学法",
                    tk = "npc_704",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "崂山", 704, 80, 33 },
                    desc = "崂山学法，道法自成。\n<font color='#F4D179'>目标：</font>崂山学法\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "是非难辨",
                    tk = "npc_720",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "罗刹海市", 705, 71, 31 },
                    desc = function(task, storyData, killData)
                        local intro = "罗刹海市疑云重重，先查明真相，再完成后续委托。\n"
                        local story = type(storyData) == "table" and storyData or {}
                        local state705 = tonumber(story["npc_705"] or 0) or 0
                        local state720 = tonumber(story["npc_720"] or 0) or 0
                        local step705 = tonumber(story["npc_705_step"] or 0) or 0
                        local small = _xyl_get_kill_progress_value(killData, "npc_705", {shaguai_id = 705}, "_small")
                        local boss = _xyl_get_kill_progress_value(killData, "npc_705", {shaguai_id = 705}, "_boss")
                        local killDone = small >= 200 and boss >= 2
                        if state720 >= 2 then
                            return intro .. "是非难辨，见证真相。\n<font color='#F4D179'>目标：</font>为村长安葬\n<font color='#F4D179'>进度：</font>" .. _xyl_status_rich_text("已完成")
                        end
                        if state705 >= 2 then
                            local now = _xyl_get_item_count_by_name("金币")
                            local _, _, txt = _xyl_progress_pair_text(now, 880000)
                            return intro .. "是非难辨，见证真相。\n<font color='#F4D179'>目标：</font>筹集安葬费并为村长安葬\n<font color='#F4D179'>进度：</font>" .. txt
                        end
                        if step705 >= 1 then
                            local _, _, flowerATxt = _xyl_progress_pair_text(_xyl_get_item_count_by_name("紫梦花"), 5)
                            local _, _, flowerBTxt = _xyl_progress_pair_text(_xyl_get_item_count_by_name("赤血花"), 5)
                            return intro .. "是非难辨，见证真相。\n<font color='#F4D179'>目标：</font>采集鲜花制作鲜花饼\n<font color='#F4D179'>紫梦花：</font>" .. flowerATxt .. "\n<font color='#F4D179'>赤血花：</font>" .. flowerBTxt
                        end
                        if killDone then
                            return intro .. "是非难辨，见证真相。\n<font color='#F4D179'>目标：</font>击杀完成后先提交委托\n<font color='#F4D179'>进度：</font>" .. _xyl_status_rich_text("待提交")
                        end
                        local _, _, smallTxt = _xyl_progress_pair_text(small, 200)
                        local _, _, bossTxt = _xyl_progress_pair_text(boss, 2)
                        return intro .. "是非难辨，见证真相。\n<font color='#F4D179'>目标：</font>击杀2只BOSS和200只小怪，并提交委托\n<font color='#F4D179'>进度：</font>BOSS " .. bossTxt .. "    \n小怪 " .. smallTxt
                    end,
                },
            },
            name = "聊斋志异",
            jqd = 100,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
        {
            jq = {
                {
                    "守护壁画",
                    tk = "npc_706",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "莫高窟", 706, 19, 25 },
                    desc = "守护壁画，护佑遗梦。\n<font color='#F4D179'>目标：</font>守护壁画\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "沙海明珠",
                    tk = "npc_707",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "月牙泉", 707, 81, 167 },
                    desc = "沙海明珠，寻回秘宝。\n<font color='#F4D179'>目标：</font>沙海明珠\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "丝路往事",
                    tk = "npc_708",
                    id = 999,
                    jl = { { "剧情点", 2 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "玉门关", 708, 35, 45 },
                    desc = "丝路往事，回溯旧影。\n<font color='#F4D179'>目标：</font>丝路往事\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "故人远行",
                    tk = "npc_709",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "阳关道", 709, 179, 207 },
                    desc = "故人远行，缘起缘落。\n<font color='#F4D179'>目标：</font>故人远行\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "敦煌遗梦",
            jqd = 100,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
        {
            jq = {
                {
                    "禁墟之门",
                    tk = "npc_689",
                    id = 999,
                    jl = { { "剧情点", 1 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "世界禁墟", 689, 95, 69 },
                    desc = "禁墟之门开启，步入禁墟。\n<font color='#F4D179'>目标：</font>禁墟之门\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "大地之王",
                    tk = "npc_710",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "大地禁墟三层", 710, 61, 57 },
                    desc = "挑战大地之王，夺取祝福。\n<font color='#F4D179'>目标：</font>大地之王\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "天空之王",
                    tk = "npc_711",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "天空禁墟三层", 711, 40, 31 },
                    desc = "挑战天空之王，夺取祝福。\n<font color='#F4D179'>目标：</font>天空之王\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "海洋之王",
                    tk = "npc_712",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "海洋禁墟三层", 712, 200, 210 },
                    desc = "挑战海洋之王，夺取祝福。\n<font color='#F4D179'>目标：</font>海洋之王\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "青铜之王",
                    tk = "npc_713",
                    id = 999,
                    jl = { { "剧情点", 3 } },
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "青铜禁墟三层", 713, 31, 49 },
                    desc = "挑战青铜之王，夺取祝福。\n<font color='#F4D179'>目标：</font>青铜之王\n<font color='#F4D179'>进度：</font>%s",
                },
                {
                    "重启世界",
                    tk = "npc_691",
                    id = 999,
                    jl = {},
                    fwdjy = nil,
                    khdjy = _xyl_khdjy,
                    need_receive = false,
                    yd = { 1, "五大陆主城", 691, 28, 13 },
                    desc = "完成重启世界，开启新篇。\n<font color='#F4D179'>目标：</font>重启世界\n<font color='#F4D179'>进度：</font>%s",
                },
            },
            name = "重启世界",
            jqd = 100,
            jl = { { "等级卷轴", 10 }, { "1元真实充值", 15 } },
        },
    },
}
-- 备注：扁平化 cost 配置，兼容 {{"道具",1}} 与 { [1]={{"道具",1}} } 两种写法。
local function _xyl_collect_cost_entries(cost, out)
    out = out or {}
    if type(cost) ~= "table" then
        return out
    end
    local function appendEntry(v)
        if type(v) == "table" then
            if type(v[1]) == "string" and tonumber(v[2]) then
                table.insert(out, { v[1], tonumber(v[2]) })
            else
                _xyl_collect_cost_entries(v, out)
            end
        end
    end
    for i, v in ipairs(cost) do
        appendEntry(v)
    end
    for k, v in pairs(cost) do
        if type(k) ~= "number" or k < 1 or k > #cost or k % 1 ~= 0 then
            appendEntry(v)
        end
    end
    return out
end
local function _xyl_count_placeholders(desc)
    local n = 0
    local s = tostring(desc or "")
    for _ in s:gmatch("%%s") do
        n = n + 1
    end
    return n
end
local XYL_DESC_COLOR = {
    ok = "#66FF66",
    fail = "#FF6B6B",
    doing = "#FFD166",
    item = "#F0B42A",
    system = "#63E6FF",
    action = "#FF9A6A",
}
local function _xyl_wrap_color(text, color)
    return string.format("<font color='%s'>%s</font>", tostring(color or "#FFFFFF"), tostring(text or ""))
end
local function _xyl_escape_pattern(text)
    return tostring(text or ""):gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end
local function _xyl_apply_keyword_color(text, words, color, staged)
    local content = tostring(text or "")
    for _, word in ipairs(words or {}) do
        local pattern = _xyl_escape_pattern(word)
        content = content:gsub(pattern, function()
            table.insert(staged, _xyl_wrap_color(word, color))
            return "\3" .. tostring(#staged) .. "\4"
        end)
    end
    return content
end
local function _xyl_beautify_desc_keywords(text)
    local content = tostring(text or "")
    if content == "" then
        return content
    end
    local protected = {}
    local staged = {}
    content = content:gsub("(<font.-</font>)", function(tag)
        table.insert(protected, tag)
        return "\1" .. tostring(#protected) .. "\2"
    end)
    local systemWords = {
        "天书界面", "装备强化界面", "幸运强化界面", "江湖称号界面", "灵根界面", "古玩鉴定", "气运占卜",
        "灵根培养", "自动砍树", "藏宝图", "仙府", "转生",
        "灵兽", "神石", "千年沉船", "四灾试炼", "西游篇",
    }
    local actionWords = {
        "前往", "完成", "击杀", "提交", "收集", "挑战",
        "调查", "开启", "制作", "提升", "通过", "击败", "装配", "领取",
    }
    content = _xyl_apply_keyword_color(content, systemWords, XYL_DESC_COLOR.system, staged)
    content = _xyl_apply_keyword_color(content, actionWords, XYL_DESC_COLOR.action, staged)
    content = content:gsub("\3(%d+)\4", function(idx)
        return staged[tonumber(idx) or 0] or ""
    end)
    content = content:gsub("\1(%d+)\2", function(idx)
        return protected[tonumber(idx) or 0] or ""
    end)
    return content
end
function _xyl_status_rich_text(text)
    local value = tostring(text or "")
    if value == "已全部提交" or value == "已完成" or value == "已提交" or value == "已拥有" or value == "已激活"
        or value == "已达成" or value == "已解锁" or value == "已通过" or value == "可领取" then
        return _xyl_wrap_color(value, XYL_DESC_COLOR.ok)
    end
    if value == "进行中" then
        return _xyl_wrap_color(value, XYL_DESC_COLOR.doing)
    end
    if value == "未完成" or value == "未提交" or value == "未拥有" or value == "未开始"
        or value == "未激活" or value == "未达成" or value == "未解锁" or value == "未通过" then
        return _xyl_wrap_color(value, XYL_DESC_COLOR.fail)
    end
    return value
end
local function _xyl_story_node_done(node)
    if node == nil then
        return false
    end
    if type(node) == "number" then
        return tonumber(node) >= 2
    end
    if type(node) == "table" then
        if tonumber(node[1] or node["1"] or 0) >= 2 then
            return true
        end
        if tonumber(node.wc or node.finish or node.done or node.ok or 0) >= 1 then
            return true
        end
        if tonumber(node.cnt or node.num or 0) >= 2 then
            return true
        end
    end
    return false
end
local function _xyl_story_node_started(node)
    if node == nil then
        return false
    end
    if type(node) == "number" then
        return tonumber(node) > 0
    end
    if type(node) == "table" then
        if tonumber(node[1] or node["1"] or 0) > 0 then
            return true
        end
        if tonumber(node.wc or node.finish or node.done or node.ok or 0) > 0 then
            return true
        end
        if tonumber(node.cnt or node.num or 0) > 0 then
            return true
        end
    end
    return false
end
local function _xyl_get_story_node_by_tk(tk, storyData)
    if not tk or tk == "" then
        return nil
    end
    local data = storyData or _xyl_get_json("T13")
    local node = data[tk]
    if node == nil then
        node = data[tostring(tk):gsub("_", "")]
    end
    return node
end
function _xyl_progress_pair_text(cur, need)
    local c = tonumber(cur) or 0
    local n = tonumber(need) or 0
    if n > 0 and c > n then
        c = n
    end
    local color = (n > 0 and c >= n) and XYL_DESC_COLOR.ok or XYL_DESC_COLOR.fail
    return c, n, _xyl_wrap_color(string.format("%d/%d", c, n), color)
end
-- 备注：统一将进度节点转为数值，兼容 number/string/table 三种结构。
local function _xyl_node_to_number(node)
    if type(node) == "number" then
        return tonumber(node) or 0
    end
    if type(node) == "string" then
        return tonumber(node) or 0
    end
    if type(node) == "table" then
        return tonumber(node.cnt or node.num or node.value or node[1] or node["1"] or 0) or 0
    end
    return 0
end
-- 备注：读取杀怪进度，兼容 tk / 去下划线 tk / shaguai_id 等不同存储键名。
function _xyl_get_kill_progress_value(sg, tk, cfg, suffix)
    if type(sg) ~= "table" then
        return 0
    end
    local suf = tostring(suffix or "")
    local sufNoUnder = suf:gsub("^_", "")
    local keyList = {}
    local function add_key(v)
        if v == nil then
            return
        end
        table.insert(keyList, v)
    end
    local tkStr = tk and tostring(tk) or nil
    if tkStr and tkStr ~= "" then
        add_key(tkStr .. suf)
        add_key(tkStr:gsub("_", "") .. suf)
        if sufNoUnder ~= "" then
            add_key(tkStr .. sufNoUnder)
            add_key(tkStr:gsub("_", "") .. sufNoUnder)
        end
    end
    local sid = cfg and tonumber(cfg.shaguai_id) or nil
    if sid then
        add_key(tostring(sid) .. suf)
        if sufNoUnder ~= "" then
            add_key(tostring(sid) .. sufNoUnder)
        end
        add_key(sid)
    end
    local sources = { sg }
    if type(sg.sg_data) == "table" then
        table.insert(sources, sg.sg_data)
    end
    local best = 0
    for _, src in ipairs(sources) do
        for _, k in ipairs(keyList) do
            local node = src[k]
            if node ~= nil then
                local n = _xyl_node_to_number(node)
                if n > best then
                    best = n
                end
            end
        end
    end
    return best
end
function _xyl_get_item_count_by_name(itemName)
    if not itemName or itemName == "" then
        return 0
    end
    local itemIdx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName))
    if not itemIdx then
        return 0
    end
    if Player.isCurrency and Player:isCurrency(itemIdx) then
        return tonumber(SL:GetMetaValue("MONEY_ASSOCIATED", itemIdx)) or 0
    end
    return tonumber(SL:GetMetaValue("ITEM_COUNT", itemIdx)) or 0
end
local function _xyl_has_item_exact(itemName, needCount)
    if not itemName or itemName == "" then
        return false
    end
    local miss = Player:checkItemNumByTable({{itemName, needCount or 1}})
    return not miss
end
-- 备注：读取“分项提交”状态（同源服务端 T_dljq 的 tk_a/tk_b/tk_c 标记）。
-- 未提交时补充显示“是否已拥有对应道具”。
local function _xyl_get_split_submit_state_text(storyData, tk, idx, entry)
    if type(storyData) ~= "table" or not tk then
        return nil
    end
    local suffixMap = { "_a", "_b", "_c" }
    local suffix = suffixMap[tonumber(idx) or 0]
    if not suffix then
        return nil
    end
    local v = storyData[tostring(tk) .. suffix]
    local submitted = (v == true or tonumber(v or 0) == 1)
    if submitted then
        return _xyl_status_rich_text("已提交")
    end
    if type(entry) == "table" and entry[1] then
        local itemName = entry[1]
        local need = tonumber(entry[2]) or 1
        if _xyl_has_item_exact(itemName, need) then
            return _xyl_status_rich_text("已拥有")
        end
        return _xyl_status_rich_text("未拥有")
    end
    if tostring(tk) == "npc_629" then
        return _xyl_status_rich_text("未拥有")
    end
    return nil
end
local function _xyl_get_task_progress_values(task, storyData)
    if type(task) ~= "table" then
        return nil, nil, nil
    end
    local tk = task.tk and tostring(task.tk) or nil
    if not tk or tk == "" then
        local checker = task.khdjy
        if type(checker) == "function" then
            local ok, done = pcall(checker, task)
            if ok then
                return nil, nil, _xyl_status_rich_text(done and "已完成" or "未完成")
            end
        end
        return nil, nil, _xyl_status_rich_text("未完成")
    end
    local node = _xyl_get_story_node_by_tk(tk, storyData)
    if node == nil then
        return nil, nil, nil
    end
    local cfg = teshudata and teshudata[tk]
    local need = tonumber(cfg and cfg.max_num)
    local cur = 0
    if type(node) == "number" then
        cur = tonumber(node) or 0
    elseif type(node) == "table" then
        cur = tonumber(node.cnt or node.num or node[1] or node["1"] or 0) or 0
        if cur <= 0 and tonumber(node.wc or node.finish or node.done or node.ok or 0) >= 1 then
            cur = need or 1
        end
    end
    if need and need > 0 then
        return _xyl_progress_pair_text(cur, need)
    end
    if _xyl_story_node_done(node) then
        return cur, need, _xyl_status_rich_text("已完成")
    end
    if _xyl_story_node_started(node) then
        return cur, need, _xyl_status_rich_text("进行中")
    end
    return cur, need, _xyl_status_rich_text("未开始")
end
-- 备注：重复提交类任务进度（同源 tk 计数 + cfg.max_num），如 npc_630。
local function _xyl_get_repeat_submit_progress_text(storyData, tk, cfg)
    if type(storyData) ~= "table" or not tk or type(cfg) ~= "table" then
        return nil
    end
    local need = tonumber(cfg.max_num) or 0
    if need <= 1 then
        return nil
    end
    local cur = _xyl_node_to_number(storyData[tk])
    local _, _, txt = _xyl_progress_pair_text(cur, need)
    return txt
end
-- 备注：多次确认/审问类任务进度（同源 tk_s 列表长度），如 npc_631。
local function _xyl_get_repeat_confirm_progress_text(storyData, tk, totalNeed)
    if type(storyData) ~= "table" or not tk then
        return nil
    end
    local need = tonumber(totalNeed) or 0
    if need <= 1 then
        return nil
    end
    local node = storyData[tostring(tk) .. "_s"]
    local cur = 0
    if type(node) == "table" then
        cur = #node
    elseif tonumber(node) then
        cur = tonumber(node) or 0
    end
    local _, _, txt = _xyl_progress_pair_text(cur, need)
    return txt
end
local function _xyl_get_task_progress_format_args(task, storyData, killData)
    local args = {}
    local tk = type(task) == "table" and task.tk and tostring(task.tk) or nil
    local cfg = tk and teshudata and teshudata[tk] or nil
    local sg = killData or _xyl_get_json("T35")
    if tk and cfg then
        -- 特殊任务：灾厄入侵（npc_46）要求四个前置讨伐任务全部完成。
        if tk == "npc_46" then
            local preTasks = { "npc_625", "npc_626", "npc_627", "npc_628" }
            for _, preTk in ipairs(preTasks) do
                local done = false
                local preCfg = teshudata and teshudata[preTk]
                if preCfg and preCfg.ch and _xyl_has_title(preCfg.ch) then
                    done = true
                else
                    local node = _xyl_get_story_node_by_tk(preTk, storyData)
                    if node ~= nil then
                        local need = tonumber(preCfg and preCfg.max_num) or 0
                        if need > 0 then
                            local cur = _xyl_node_to_number(node)
                            if cur >= need then
                                done = true
                            end
                        end
                        if not done and _xyl_story_node_done(node) then
                            done = true
                        end
                    end
                end
                table.insert(args, _xyl_status_rich_text(done and "已完成" or "未完成"))
            end
            return args
        end
        -- 特殊任务：船长的宝藏（npc_630）显示提交次数进度（0/3）+ 当前背包数量。
        if tk == "npc_630" then
            local submitText = _xyl_get_repeat_submit_progress_text(storyData, tk, cfg)
            if submitText then
                table.insert(args, submitText)
            end
            local costEntries = _xyl_collect_cost_entries(cfg.cost)
            local entry = costEntries[1]
            if type(entry) == "table" and entry[1] then
                local own = _xyl_get_item_count_by_name(entry[1])
                table.insert(args, _xyl_wrap_color(tostring(own), XYL_DESC_COLOR.item))
            else
                table.insert(args, _xyl_wrap_color("0", XYL_DESC_COLOR.item))
            end
            if #args == 1 then
                table.insert(args, _xyl_wrap_color("0", XYL_DESC_COLOR.item))
            end
            return args
        end
        -- 特殊任务：热血的友情（npc_636）显示提交次数进度（0/3）。
        if tk == "npc_636" then
            local submitText = _xyl_get_repeat_submit_progress_text(storyData, tk, cfg)
            table.insert(args, submitText or _xyl_wrap_color("0/3", XYL_DESC_COLOR.fail))
            return args
        end
        -- 特殊任务：谁是内鬼（npc_631）显示“审问/确认次数进度（0/4）”。
        if tk == "npc_631" then
            local confirmText = _xyl_get_repeat_confirm_progress_text(storyData, tk, 4)
            table.insert(args, confirmText or _xyl_wrap_color("0/4", XYL_DESC_COLOR.fail))
            return args
        end
        -- 特殊任务：白蛇传说（npc_681）显示累计提交进度（0/100）+ 背包拥有数量。
        if tk == "npc_681" then
            local submitText = _xyl_get_repeat_submit_progress_text(storyData, tk, cfg)
            table.insert(args, submitText or _xyl_wrap_color("0/100", XYL_DESC_COLOR.fail))
            local costEntries = _xyl_collect_cost_entries(cfg.cost)
            local entry = costEntries[1]
            if type(entry) == "table" and entry[1] then
                local own = _xyl_get_item_count_by_name(entry[1])
                table.insert(args, _xyl_wrap_color(tostring(own), XYL_DESC_COLOR.item))
            else
                table.insert(args, _xyl_wrap_color("0", XYL_DESC_COLOR.item))
            end
            return args
        end
        local hasABC = (tonumber(cfg.num_a) or 0) > 0 or (tonumber(cfg.num_b) or 0) > 0 or (tonumber(cfg.num_c) or 0) > 0
        if hasABC then
            local pairs = {
                {"_a", cfg.num_a},
                {"_b", cfg.num_b},
                {"_c", cfg.num_c},
            }
            for _, it in ipairs(pairs) do
                local need = tonumber(it[2]) or 0
                if need > 0 then
                    local cur = _xyl_get_kill_progress_value(sg, tk, cfg, it[1])
                    local _, _, txt = _xyl_progress_pair_text(cur, need)
                    table.insert(args, txt)
                end
            end
        else
            local need = tonumber(cfg.num) or 0
            if need > 0 then
                local cur = _xyl_get_kill_progress_value(sg, tk, cfg, "")
                local _, _, txt = _xyl_progress_pair_text(cur, need)
                table.insert(args, txt)
            end
        end
        local costEntries = _xyl_collect_cost_entries(cfg.cost)
        for i, entry in ipairs(costEntries) do
            -- 仅 npc_629 使用“分项提交状态”；其余任务保持原本背包数量进度逻辑。
            local handled = false
            if tk == "npc_629" then
                local splitState = _xyl_get_split_submit_state_text(storyData, tk, i, entry)
                if splitState then
                    table.insert(args, splitState)
                    handled = true
                end
            end
            if not handled then
                local name = entry[1]
                local need = tonumber(entry[2]) or 0
                if need > 0 then
                    local cur = _xyl_get_item_count_by_name(name)
                    local _, _, txt = _xyl_progress_pair_text(cur, need)
                    table.insert(args, txt)
                end
            end
        end
        if #args == 0 and type(cfg.details) == "table" then
            local aNeed, bNeed, cNeed = 0, 0, 0
            for _, d in ipairs(cfg.details) do
                aNeed = math.max(aNeed, tonumber(d and d.a_num) or 0)
                bNeed = math.max(bNeed, tonumber(d and d.b_num) or 0)
                cNeed = math.max(cNeed, tonumber(d and d.c_num) or 0)
            end
            if aNeed > 0 then
                local _, _, txt = _xyl_progress_pair_text(_xyl_get_kill_progress_value(sg, tk, cfg, "_a"), aNeed)
                table.insert(args, txt)
            end
            if bNeed > 0 then
                local _, _, txt = _xyl_progress_pair_text(_xyl_get_kill_progress_value(sg, tk, cfg, "_b"), bNeed)
                table.insert(args, txt)
            end
            if cNeed > 0 then
                local _, _, txt = _xyl_progress_pair_text(_xyl_get_kill_progress_value(sg, tk, cfg, "_c"), cNeed)
                table.insert(args, txt)
            end
        end
    end
    if #args == 0 then
        local _, _, progressText = _xyl_get_task_progress_values(task, storyData)
        table.insert(args, progressText or "未开始")
    end
    return args
end
local function _xyl_build_task_desc(task)
    local desc = (type(task) == "table" and (task.desc or task.wz)) or nil
    local storyData = _xyl_get_json("T13")
    local killData = _xyl_get_json("T35")
    if type(desc) == "function" then
        local ok, built = pcall(desc, task, storyData, killData)
        if ok and type(built) == "string" and built ~= "" then
            desc = built
        else
            desc = nil
        end
    end
    if not desc or desc == "" then
        desc = "暂无任务简介"
    end
    local args = _xyl_get_task_progress_format_args(task, storyData, killData)
    local summary = table.concat(args, " ")
    local unpack_fn = table.unpack or unpack
    local placeholderCount = _xyl_count_placeholders(desc)
    if placeholderCount > #args then
        for i = #args + 1, placeholderCount do
            args[i] = summary ~= "" and summary or _xyl_status_rich_text("未开始")
        end
    end
    local ok, formatted = pcall(function()
        return string.format(desc, unpack_fn(args))
    end)
    if ok and formatted then
        return _xyl_beautify_desc_keywords(formatted)
    end
    if string.find(desc, "进度：", 1, true) then
        local fallback = desc:gsub("进度：[^\n]*", "进度：" .. (summary ~= "" and summary or "未开始"), 1)
        return _xyl_beautify_desc_keywords(fallback)
    end
    return _xyl_beautify_desc_keywords(desc .. "\n进度：" .. (summary ~= "" and summary or _xyl_status_rich_text("未开始")))
end
-- 备注：统一补齐“需领取”字段，默认 false；可在单任务里显式改为 true。
local function _xyl_mark_accept_tasks(taskData)
    for _, continent in ipairs(taskData or {}) do
        if type(continent) == "table" then
            for _, chapter in ipairs(continent) do
                local jq = chapter and chapter.jq
                if type(jq) == "table" then
                    for _, task in ipairs(jq) do
                        if type(task) == "table" then
                            if task.need_receive == nil then
                                task.need_receive = false
                            end
                            task.need_accept = true
                        end
                    end
                end
            end
        end
    end
end

_xyl_mark_accept_tasks(npc_xyl)
npc_xyl.get_chapter_lock_info = function(l, zj, curJqd)
    return _xyl_get_chapter_lock_info(npc_xyl, l, zj, curJqd)
end
npc_xyl.build_task_desc = function(task)
    return _xyl_build_task_desc(task)
end
return npc_xyl
