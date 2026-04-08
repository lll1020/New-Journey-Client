local npc = {}

---顶部图标显示
npc.iconpx = {
    {
        {15, "天天省钱",509,1}, {3, "福利大厅",511,2}, {17, "游戏攻略",512,3},{4, "活动大厅",507,4},{14, "首充礼包",501,5},{16, "仙途奇缘",515,515},{20, "护体光环",23,23},{21, "马上发财",31,31}
    },
    {
        {19, "在线充值", 502,11}, {5, "交易行",510,12},{2, "解绑特权",504,13},{7, "狂暴之力",513,14},{12, "世界地图",514,15},{10, "免费赞助",516,16},{6, "聚宝盆",517,17},
    }
}
npc.LeftTop = GUI:Attach_LeftTop() -- 左上
npc.RightTop = GUI:Attach_RightTop() -- 右上
npc.RightBottom = GUI:Attach_RightBottom() -- 右下
npc.qiehuan = GUI:Win_FindParent(109)--手机端切换
npc.xinjn = GUI:Win_FindParent(1104)--主界面最顶右下
npc.xinjn32 = GUI:Win_FindParent(1003)--主界面最顶右下

-- 顶部按钮缓存，用于红点/引导等后续逻辑
npc.db_anniu = {} --按钮
npc.db_shortcut_entries = {}
npc._shortcut_collapsed = false
local zbz = {}
---特殊任务描述
npc.rw = {

}  --任务描述

-- UIHelper 预设：统一管理不同窗口的默认皮肤 / 行为
local WINDOW_STYLE = {
    reward = {       -- 奖励展示
        windowName = "npc_jiangli",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/01.png"},
        closeButton = false,
    },
    recycle = {      -- 装备回收
        windowName = "npc_huishou",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {x = -100,skin = "res/wy/public/hs_bj.png"},
        closeButton = {x = 840 - 293, y = 490 - 150, skin = "res/wy/public/red_close.png"},
    },
    welfare = {      -- 福利大厅
        windowName = "npc_fldt",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/fulitating/title.png"},
    },
    strategy = {     -- 游戏攻略
        windowName = "npc_yxgl",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/strategy/bg_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/strategy/title.png"},
    },
    firstCharge = {  -- 首充礼包
        windowName = "npc_sclb",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/top/shochong/bg.png"},
        closeButton = {x = 740, y = 460 - 150, skin = "res/wy/public/close_red_big.png"},
    },
    onlineRecharge = { -- 在线充值
        windowName = "npc_zxcz",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/chongzhi/bg.png", eff = true},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/chongzhi/title.png"},
    },
    unbind = {       -- 解绑特权
        windowName = "npc_jbtq",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
    },
    patrol = {       -- 巡航挂机
        windowName = "npc_mrtq",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
    },
    chosen = {       -- 天选之人
        windowName = "npc_txzz",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/activity/tx.png"},
        closeButton = {x = 800, y = 400, skin = "res/wy/public/close_red_big.png"},
    },
    activity = {     -- 游戏活动
        windowName = "npc_hd",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/activity/bg.png"},
        closeButton = {x = 780, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/activity/title.png"},

    },
    recordStone = {  -- 记录石
        windowName = "npc_jilushi",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/jys_bj.png"},
        closeButton = {x = 467, y = 449, skin = "res/wy/public/close_red_big.png"},
    },
    storyLog = {     -- 异闻录
        windowName = "npc_ywl",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/ywl/bg.png"},
        closeButton = {x = 900, y = 500, skin = "res/wy/public/close_red_big.png"},
    },
    newbieGift = {   -- 新手礼包
        windowName = "npc_xslb",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/xinshoulibao/bg.png"},
        closeButton = {x = 740, y = 300, skin = "res/wy/public/close_red_big.png"},
    },
    worldMap = {     -- 世界地图
        windowName = "npc_sjdt",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/102.png"},
        closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
    },
    fairyFate = {    -- 仙途奇缘
        windowName = "npc_qy",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/fairyFate/bg.png", eff = true},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/fairyFate/title.png"},

    },
    freeSponsor = {  -- 免费赞助
        windowName = "npc_anniu_516",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/mfzz/bg.png"},
        closeButton = {x = 740 + 076, y = 410, skin = "res/wy/public/close_red_big.png"},
    },
    treasureBasin = { -- 聚宝盆
        windowName = "npc_anniu_517",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/*.png"},
        closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
    },
    bodyAura = { -- 护体光环
        windowName = "npc_23",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/htgh/bg.png"},
        closeButton = {x = 875, y = 500, skin = "res/wy/public/close_red_big.png"},
    },
}

-- windowCache[name]：保存 UIHelper 返回引用，避免重复创建
local windowCache = {}

-- 工具：深拷贝 table，避免直接修改 WINDOW_STYLE
local function cloneTable(src)
    local dst = {}
    for k, v in pairs(src or {}) do
        dst[k] = type(v) == "table" and cloneTable(v) or v
    end
    return dst
end

-- 工具：合并默认窗口配置 + 额外参数
local function mergeOptions(base, extra)
    local opts = cloneTable(base)
    for k, v in pairs(extra or {}) do
        if type(v) == "table" then
            opts[k] = cloneTable(v)
        else
            opts[k] = v
        end
    end
    return opts
end

-- 工具：封装 UIHelper.ensureWindow，内部维护缓存
local function ensureWindow(name, npcid, extraOpts)
    local opts = mergeOptions(WINDOW_STYLE[name], extraOpts)
    windowCache[name] = NPC_UI_HELPER.ensureWindow(windowCache[name], npcid or 0, opts)
    return windowCache[name]
end

-- 工具：创建顶部快捷按钮
local function createShortcutButton(container, cfg, order, prefix, opts)
    opts = opts or {}
    local btnName = string.format("%s_%d", prefix, order)
    local posX = tonumber(opts.x) or (498 - 80 * order)
    local posY = tonumber(opts.y) or 0
    local button = GUI:Button_Create(container, btnName, posX, posY, "res/wy/icon/top_" .. cfg[1] .. ".png")
    -- GUI:Text_Create(button, "tt", 0, 14, 14, "#ffffff", cfg[2])
    -- GUI:setScale(button, tonumber(opts.scale) or 0.9)
    GUI:addOnClickEvent(button, function()
        SL:SendLuaNetMsg(101, cfg[3], 0, 0, "")
        GUI:removeAllChildren(button)
    end)
    local cacheMap = opts.cacheMap or npc.db_anniu
    cacheMap[""..cfg[4]] = button
    return button
end

local function _shortcut_has_title(titleName)
    if not titleName or titleName == "" then
        return false
    end
    local idx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName)
    if not idx then
        return false
    end
    return SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil
end

local function _shortcut_is_freesponsor_completed()
    local cfg = teshudata and teshudata["anniu_516"]
    local details = cfg and cfg.details or {}
    if #details <= 0 then
        return false
    end

    if npc.data_516 and npc.data_516.T_data then
        local allDone = true
        for i = 1, #details do
            local flag = npc.data_516.T_data["zzlb_" .. i]
            if not (flag == true or tonumber(flag or 0) == 1) then
                allDone = false
                break
            end
        end
        if allDone then
            return true
        end
    end

    local finalTitle = details[#details] and details[#details].ch
    return _shortcut_has_title(finalTitle)
end

local function _shortcut_is_firstcharge_completed()
    local cfg = teshudata and teshudata["anniu_501"] or {}
    local details = cfg.details or {}
    local T_data = npc.data_501 and npc.data_501.T_data
    if type(T_data) ~= "table" then
        return false
    end
    local firstList = details["首充"] or {}
    local firstCount = #firstList
    local firstClaimed = tonumber(T_data["other_lb"] or T_data["_lb"] or 0) or 0
    return firstCount > 0 and firstClaimed >= firstCount
end

local function _shortcut_is_kuangbao_completed()
    local cfg = teshudata and teshudata["npc_15"]
    local titleName = cfg and cfg.give and cfg.give.ch or "狂暴之力"
    return _shortcut_has_title(titleName)
end

local function _feijian_has_main_buff(buffId)
    local actorId = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not actorId then
        return false
    end
    return SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", actorId, buffId) ~= nil
end

local function _feijian_get_buff_left_seconds(buffId)
    local actorId = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not actorId then
        return nil
    end
    local buffData = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", actorId, buffId)
    if type(buffData) ~= "table" then
        return nil
    end

    local now = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0

    local function _to_left_by_abs(ts)
        local t = tonumber(ts)
        if not t then
            return nil
        end
        if now > 0 and t > now then
            return math.max(math.floor(t - now), 0)
        end
        return nil
    end

    local function _to_left_by_sec(secOrTs)
        local v = tonumber(secOrTs)
        if not v then
            return nil
        end
        if now > 0 and v > now then
            return math.max(math.floor(v - now), 0)
        end
        if v > 0 then
            return math.max(math.floor(v), 0)
        end
        return nil
    end

    local absKeys = {"endTime", "end_time", "expireTime", "expire_time", "overTime"}
    for _, key in ipairs(absKeys) do
        local left = _to_left_by_abs(buffData[key])
        if left and left >= 0 then
            return left
        end
    end

    local secKeys = {"left", "leftTime", "left_time", "remain", "remainTime", "remain_time", "time", "duration"}
    for _, key in ipairs(secKeys) do
        local left = _to_left_by_sec(buffData[key])
        if left and left >= 0 then
            return left
        end
    end

    return nil
end

local function _feijian_format_left_seconds(seconds)
    local left = math.max(tonumber(seconds) or 0, 0)
    if SL.TimeFormatToStr then
        local ok, result = pcall(function()
            return SL:TimeFormatToStr(left)
        end)
        if ok and result and result ~= "" then
            return result
        end
    end
    local h = math.floor(left / 3600)
    local m = math.floor((left % 3600) / 60)
    local s = math.floor(left % 60)
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function _shortcut_is_unbind_completed()
    if npc.kryb and tonumber(npc.kryb.mztq or 0) == 1 then
        return true
    end
    local cfg = teshudata and teshudata["anniu_504"]
    local titleName = (cfg and cfg.ch) or "解绑特权"
    return _shortcut_has_title(titleName)
end

local HUTI_CARD_CFG = {
    [1] = {
        name = "攻击",
        effect = "每3刀额外造成1000伤害",
        need = "转生等级达到10级",
        lockedTip = "需要转生等级达到10级",
    },
    [2] = {
        name = "防御",
        effect = "每3刀额外造成888伤害",
        need = "领取首充礼包",
        lockedTip = "需要先领取首充礼包",
    },
    [3] = {
        name = "斩杀",
        effect = "每3刀额外造成1000伤害",
        need = "购买超级特权",
        lockedTip = "需要先激活解绑特权",
    },
}

-- 读取护体光环服务端数据，字段结构与服务端 npc[23] 回包保持一致。
local function _huti_get_server_data()
    return type(npc.data_23) == "table" and npc.data_23 or {}
end

-- 读取指定光环档位数据，兼容数组下标和字符串下标。
local function _huti_get_aura_info(idx)
    local data = _huti_get_server_data()
    local aura = type(data.aura) == "table" and data.aura or {}
    local info = aura[idx] or aura[tostring(idx)]
    return type(info) == "table" and info or {}
end

-- 护体光环解锁条件在未打开面板前也要可用，便于快捷入口直接判断是否完成。
local function _huti_get_local_open_flag(idx)
    if idx == 1 then
        return (tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0) >= 1
    end
    if idx == 2 then
        local firstChargeData = (npc.data_501 and npc.data_501.T_data) or {}
        return tonumber(firstChargeData["首充"] or 0) == 1
    end
    if idx == 3 then
        return _shortcut_is_unbind_completed()
    end
    return false
end

-- 优先使用服务端 open 状态；若该档尚未拉取到数据，则回退本地可判定条件。
local function _huti_is_open(idx)
    local info = _huti_get_aura_info(idx)
    if info.open ~= nil then
        return tonumber(info.open or 0) == 1
    end
    return _huti_get_local_open_flag(idx)
end

-- 当前激活档位由服务端直接下发，若 active 缺失则回退读各档 active 标记。
local function _huti_get_active_idx()
    local data = _huti_get_server_data()
    local active = tonumber(data.active or 0) or 0
    if active >= 1 and active <= 3 then
        return active
    end
    for idx = 1, 3 do
        local info = _huti_get_aura_info(idx)
        if tonumber(info.active or 0) == 1 then
            return idx
        end
    end
    return 0
end

-- 快捷入口隐藏条件：三个护体光环全部解锁后不再显示入口。
local function _shortcut_is_body_aura_completed()
    for idx = 1, 3 do
        if not _huti_is_open(idx) then
            return false
        end
    end
    return true
end

local function _huti_get_card_states()
    local result = {}
    local activeIdx = _huti_get_active_idx()
    for idx, cfg in ipairs(HUTI_CARD_CFG) do
        local info = _huti_get_aura_info(idx)
        local canActivate = _huti_is_open(idx)
        local active = activeIdx == idx or tonumber(info.active or 0) == 1
        result[idx] = {
            idx = idx,
            name = cfg.name,
            effect = cfg.effect,
            need = cfg.need,
            lockedTip = cfg.lockedTip,
            canActivate = canActivate,
            active = active == true,
            visible = active == true,
        }
    end
    return result
end

local function _shortcut_should_show(cfg)
    local npcid = tonumber(cfg and cfg[3] or 0)
    if npcid == 516 then
        return not _shortcut_is_freesponsor_completed()
    end
    if npcid == 501 then
        return not _shortcut_is_firstcharge_completed()
    end
    if npcid == 513 then
        return not _shortcut_is_kuangbao_completed()
    end
    if npcid == 23 then
        return not _shortcut_is_body_aura_completed()
    end
    if npcid == 504 then
        return not _shortcut_is_unbind_completed()
    end
    return true
end

-- 根据 iconpx 配置重建顶部两排按钮
local SHORTCUT_COLLAPSED_SHOW_COUNT = 4
local SHORTCUT_COLLAPSED_PREVIEW_NPC = {
    501, -- 首充礼包
    511, -- 福利大厅
    514, -- 世界地图
    502, -- 在线充值
}

local function _get_visible_shortcut_list()
    local result = {}
    for _, row in ipairs(npc.iconpx or {}) do
        for _, cfg in ipairs(row or {}) do
            if _shortcut_should_show(cfg) then
                table.insert(result, cfg)
            end
        end
    end
    return result
end

local function _get_collapsed_preview_shortcut_list()
    local preview = {}
    local used = {}

    for _, targetNpcId in ipairs(SHORTCUT_COLLAPSED_PREVIEW_NPC) do
        for _, row in ipairs(npc.iconpx or {}) do
            for _, cfg in ipairs(row or {}) do
                if tonumber(cfg and cfg[3]) == tonumber(targetNpcId) and not used[targetNpcId] then
                    table.insert(preview, cfg)
                    used[targetNpcId] = true
                    break
                end
            end
            if used[targetNpcId] then
                break
            end
        end
    end

    if #preview >= SHORTCUT_COLLAPSED_SHOW_COUNT then
        return preview
    end

    for _, cfg in ipairs(_get_visible_shortcut_list()) do
        local npcid = tonumber(cfg and cfg[3])
        if npcid and not used[npcid] then
            table.insert(preview, cfg)
            used[npcid] = true
            if #preview >= SHORTCUT_COLLAPSED_SHOW_COUNT then
                break
            end
        end
    end

    return preview
end

local function _get_collapsed_shortcut_target(index)
    return {
        x = 418 - (index - 1) * 80,
        y = 70,
    }
end

local function _set_shortcut_entry_visible(entry, visible)
    if not (entry and entry.button) then
        return
    end
    GUI:setVisible(entry.button, visible == true)
    GUI:setTouchEnabled(entry.button, visible == true)
end

local function _refresh_shortcut_collapsed_state(withAnim)
    if not npc.dbLayout or not npc.dbshousuo then
        return
    end

    GUI:setFlippedX(npc.dbshousuo, npc._shortcut_collapsed == true)
    GUI:setPosition(npc.dbLayout, zbz[1], zbz[2])

    if npc._shortcut_collapsed then
        local keepList = _get_collapsed_preview_shortcut_list()
        local keepMap = {}
        for index, cfg in ipairs(keepList) do
            local key = tostring(cfg and cfg[4] or "")
            if key ~= "" then
                keepMap[key] = index
            end
        end

        for _, entry in ipairs(npc.db_shortcut_entries or {}) do
            local key = tostring(entry and entry.key or "")
            local keepIndex = keepMap[key]
            if keepIndex then
                local target = _get_collapsed_shortcut_target(keepIndex)
                _set_shortcut_entry_visible(entry, true)
                GUI:stopAllActions(entry.button)
                if withAnim ~= false then
                    GUI:Timeline_EaseSineIn_MoveTo(entry.button, {x = target.x, y = target.y}, 0.2)
                    GUI:Timeline_FadeIn(entry.button, 0.2)
                else
                    GUI:setPosition(entry.button, target.x, target.y)
                    GUI:setOpacity(entry.button, 255)
                end
            else
                GUI:stopAllActions(entry.button)
                if withAnim ~= false then
                    GUI:Timeline_EaseSineIn_MoveTo(entry.button, {x = entry.originX + 50, y = entry.originY}, 0.18)
                    GUI:Timeline_FadeOut(entry.button, 0.18, function()
                        _set_shortcut_entry_visible(entry, false)
                        GUI:setPosition(entry.button, entry.originX, entry.originY)
                        GUI:setOpacity(entry.button, 255)
                    end)
                else
                    _set_shortcut_entry_visible(entry, false)
                    GUI:setPosition(entry.button, entry.originX, entry.originY)
                    GUI:setOpacity(entry.button, 255)
                end
            end
        end
    else
        for _, entry in ipairs(npc.db_shortcut_entries or {}) do
            _set_shortcut_entry_visible(entry, true)
            GUI:stopAllActions(entry.button)
            if withAnim ~= false then
                GUI:Timeline_EaseSineIn_MoveTo(entry.button, {x = entry.originX, y = entry.originY}, 0.2)
                GUI:Timeline_FadeIn(entry.button, 0.2)
            else
                GUI:setPosition(entry.button, entry.originX, entry.originY)
                GUI:setOpacity(entry.button, 255)
            end
        end
    end
end

local function rebuildShortcutButtons(filterKey)
    if not npc.dbLayout then
        return
    end
    GUI:removeAllChildren(npc.dbLayout)
    npc.db_anniu = {}
    npc.db_shortcut_entries = {}

    local function renderRow(list, rowY, prefix)
        local order = 1
        for _, cfg in ipairs(list) do
            if _shortcut_should_show(cfg) then
                local posX = 498 - 70 * order
                local posY = rowY
                local button = createShortcutButton(npc.dbLayout, cfg, order, prefix, {
                    x = posX,
                    y = posY,
                })
                table.insert(npc.db_shortcut_entries, {
                    key = cfg[4],
                    cfg = cfg,
                    button = button,
                    originX = posX,
                    originY = posY,
                })
                order = order + 1
            end
        end
    end

    renderRow(npc.iconpx[1], 70, "anniu_1")
    renderRow(npc.iconpx[2], -10, "anniu_2")

    _refresh_shortcut_collapsed_state(false)
end

local function registerShortcutTitleRefresh()
    if npc._shortcut_title_refresh_registered then
        return
    end
    npc._shortcut_title_refresh_registered = true

    local function _refresh_shortcut()
        if npc._shortcut_refresh_pending then
            return
        end
        npc._shortcut_refresh_pending = true
        -- SL:ScheduleOnce(function()
        --     npc._shortcut_refresh_pending = false
        --     rebuildShortcutButtons("")
        -- end, 0.1)
    end

    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "anniu_shortcut_title_refresh_prop", _refresh_shortcut)
    SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "anniu_shortcut_title_refresh_server", _refresh_shortcut)
    SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "anniu_shortcut_title_refresh_buff", _refresh_shortcut)
end

local UPGRADE_HELPER = SL:Require("GUILayout/npc/upgrade_helper", true)

if cogin.isWin32 then
    zbz = {-700, -150, 200, -180, -70}
else
    zbz = {-700, -150, 200, -170, -70}
end

-- ===== 指引/寻路相关工具 =====
local function ensureTopPanelExpanded()
    if npc.dbshousuo and npc._shortcut_collapsed then
        npc._shortcut_collapsed = false
        _refresh_shortcut_collapsed_state(false)
    end
end

local function startGuideOnButton(data)
    ensureTopPanelExpanded()
    local target = npc.db_anniu[tostring(data.an)]
    if not target then
        return
    end
    SL:release_print("startGuideOnButton", data.an, target and "found" or "not found")
    NPC_UI_HELPER.startGuide({
        dir = data.fx,
        guideWidget = target,
        guideParent = npc.dbLayout,
        guideDesc = data.ms,
        isForce = false,
        hideMask = true
    })
end

local function triggerNavigate(point, meta)
    local rwxx = SL:GetMetaValue("ACTOR_MAP_X", SL:GetMetaValue("MAIN_ACTOR_ID"))
    local safeX = (point.map == rwxx) and (point.x + 1) or point.x
    SL:release_print(point.map,safeX,point.y,SL:JsonEncode(meta))

    SL:SetMetaValue("BATTLE_MOVE_BEGIN", point.map, safeX+1, point.y+1, meta, 1)
end

local function openBagGuide(desc, pcWidget, mobileWidget)
    SL:RefreshBagPos()
    if cogin.isWin32 then
        NPC_UI_HELPER.startGuide({dir = 2, guideWidget = pcWidget, guideParent = MainProperty._ui.Panel_act, guideDesc = desc, isForce = false,hideMask = true})
        GUI:Timeline_FadeIn(pcWidget, 0.2)
    else
        NPC_UI_HELPER.startGuide({dir = 1, guideWidget = mobileWidget, guideParent = npc.RightTop, guideDesc = desc, isForce = false,hideMask = true})
    end
end

local function openRoleGuide()
    if cogin.isWin32 then
        NPC_UI_HELPER.startGuide({dir = 2, guideWidget = MainProperty._ui.Button_role, guideParent = MainProperty._ui.Panel_act, guideDesc = "打开人物界面", isForce = false,hideMask = true})
        GUI:Timeline_FadeIn(MainProperty._ui.Button_role, 0.2)
    else
        NPC_UI_HELPER.startGuide({dir = 1, guideWidget = npc.jueshe, guideParent = npc.RightTop, guideDesc = "打开人物界面", isForce = false,hideMask = true})
    end
end

local guideDispatch = {
    [1] = function(data)-- 指定引导上面按钮
        startGuideOnButton(data)
    end,
    [2] = function(data) -- 指定寻路
        SL:ScheduleOnce(function()
            -- local curMapName = SL:GetMetaValue("MAP_NAME")
            triggerNavigate({map = data.npcdt, x = tonumber(data.xx) or 0, y = tonumber(data.yy) or 0}, {type = 1, index = data.npcid})
        end, 0.2)
    end,
    [3] = function(data)--指定背包引导
        openBagGuide("打开背包", MainProperty._ui.Button_bag, npc.sjbeibao)
        if data.rwid then
            cogin.sjtb.zxrwid = data.rwid
        end
    end,
    [4] = function(data)-- 指定引路到指定位置
        SL:ScheduleOnce(function()
            -- local curMapName = SL:GetMetaValue("MAP_NAME")
            local yd = data and data.yd or {}
            triggerNavigate({map = data.npcdt, x = tonumber(yd[2]) or 0, y = tonumber(yd[3]) or 0}, {type = 0})
        end, 0.2)
    end,
    [14] = function() ---打开人物界面
        openRoleGuide()
    end,
}


npc[0] = function(p2, p3, msgData) -- 任务处理
    if p2 == 1 then
        local zysj = SL:JsonDecode(msgData,false)
        local handler = guideDispatch[zysj.lx]
        if handler then
            handler(zysj)
        end
    elseif p2 == 9 then
        local da = SL:JsonDecode(msgData,false)
        -- 使用 UIHelper 构建奖励弹窗（windowCache.reward  --不再使用）
        local rewardWindow = ensureWindow("reward", 0, {titleText = "奖励预览",background = {skin = "res/wy/public/0-"..(p3 == 1000 and 2 or 1)..".png"},})
        local parent = rewardWindow.bg
        GUI:removeAllChildren(parent)

        local Layout1 = GUI:Layout_Create(parent, "Layout1", 831.00/2, 170, #da.item * 71, 60.00, false)
        GUI:setAnchorPoint(Layout1, 0.5, 0)
        for k, v in ipairs(da.item) do
            local k = GUI:Image_Create(Layout1, "item"..k, 0.00, 0.00, "res/wy/public/555.png")
            GUI:ItemShow_Create(k, "kuang", 20, 20, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1]),look=true,count=v[2]})
        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=2,interval=1,gap = {x=20}})
        local Button = GUI:Button_Create(parent, "Button", 831.00/2, 80, "res/wy/public/0-1_an.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function() 
            GUI:Win_Close(rewardWindow.parent)  
        end)
        GUI:setScaleX(parent, 0)
        GUI:Timeline_ScaleTo(parent, 1, 0.2)
    end
end

npc[1] = function(p2, p3, msgData) -- 初始化按钮
    --预渲染
    if p2 == 0 then
        if p3 == 0 then
            local guaji = {}
            if cogin.isWin32 then
                guaji[1] = GUI:Button_Create(npc.RightBottom, "guaji", -80, 500, "res/wy/icon/base.png")
                -- local dalucs = GUI:Button_Create(npc.RightBottom, "dalucs", -120, 500, "res/wy/icon/sjdt.png")
                -- GUI:addOnClickEvent(dalucs, function()
                --     Npclib["anniu"][4](0)
                -- end)

                ---暂时隐藏一下
                -- GUI:setVisible(guaji[1],false)
                -- GUI:setVisible(dalucs,false)

                ---测试使用
                if SL:GetMetaValue("USER_NAME") == "玩家名字k" or SL:GetMetaValue("USER_NAME") == "玩家名字" then
                    local Button_1 = GUI:Button_Create(npc.RightBottom, "Button_1", -150, 340 + 100, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
                    GUI:Button_setTitleText(Button_1, "测试")
                    GUI:addOnClickEvent(Button_1, function()
                        SL:SendLuaNetMsg(105, 9999, 9999, 0, "")
                    end)
                end
                
                npc.an_cbl = GUI:Button_Create(npc.RightBottom, "an_cbl", -70, 320, "res/private/main/bottom/1900012580.png")
                -- GUI:Button_loadTexturePressed(npc.an_cbl, "res/private/main/bottom/1900012580.png")
                -- GUI:setAnchorPoint(GUI:Image_Create(npc.an_cbl, "ts", 86/2, 86/2, "res/private/main/bottom/1900012538.png")
                -- , 0.5, 0.5)
                GUI:addOnClickEvent(npc.an_cbl, function()
                    local parent = GUI:GetWindow(nil, "main_cbl")
                    if parent then
                        GUI:removeAllChildren(parent)
                    else
                        parent = GUI:Win_Create("main_cbl", 0, 0, 0, 0, false, false, true, true, true, idx, 1)
                    end
                    local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
                    GUI:setAnchorPoint(bjt, 0.5, 0.5)
                    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
                    GUI:setTouchEnabled(bjt, true)
                    ---侧边栏ui
                    local cbl = GUI:Image_Create(parent,"bj",cogin.w,0,"res/wy/public/main_cbl_bj.png")
                    GUI:setAnchorPoint(cbl, 1, 0)
                    GUI:setTouchEnabled(cbl, true)
                    GUI:addOnClickEvent(bjt, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w + 300, y = 0}, 0.5,function()
                            GUI:Win_Close(parent)
                        end)
                    end)
                    GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})


                    local width = GUI:getContentSize(cbl).width
                    GUI:setContentSize(cbl, width, cogin.h)
                    GUI:setPosition(cbl, cogin.w + width,0)

                    local close = GUI:Button_Create(cbl, 'close', width - 10, cogin.h - 10, 'res/wy/public/main_cbl_close.png')
                    GUI:setAnchorPoint(close, 1, 1)
                    GUI:addOnClickEvent(close, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w + 300, y = 0}, 0.5,function()
                            GUI:Win_Close(parent)
                        end)
                    end)

                    local hh = GUI:Button_Create(GUI:Image_Create(cbl,"hh",10, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_hh.png")
                    local sz = GUI:Button_Create(GUI:Image_Create(cbl,"sz",110, 50,"res/wy/public/main_cbl_kuang.png"), "img",39,34.5, "res/private/main/bottom/sj_sz.png")
                    local exit = GUI:Button_Create(GUI:Image_Create(cbl,"exit",210, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_exit.png")
                    local sj_xz = GUI:Button_Create(GUI:Image_Create(cbl,"paimai",210, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_xz.png")
                    local haoyou = GUI:Button_Create(GUI:Image_Create(cbl,"haoyou",110, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_haoyou.png")
                    local paihang = GUI:Button_Create(GUI:Image_Create(cbl,"paihang",10, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_paihang.png")
                    GUI:setAnchorPoint(hh, 0.5, 0.5)
                    GUI:setAnchorPoint(sz, 0.5, 0.5)
                    GUI:setAnchorPoint(exit, 0.5, 0.5)
                    GUI:setAnchorPoint(sj_xz, 0.5, 0.5)
                    GUI:setAnchorPoint(haoyou, 0.5, 0.5)
                    GUI:setAnchorPoint(paihang, 0.5, 0.5)
                    GUI:addOnClickEvent(hh, function()
                        SL:JumpTo(31)
                    end)
                    GUI:addOnClickEvent(sj_xz, function()
                        SL:SendLuaNetMsg(105, 1002, 1002, 0, "")
                    end)
                    GUI:addOnClickEvent(haoyou, function()
                        SL:JumpTo(28)
                    end)
                    GUI:addOnClickEvent(sz, function()
                        SL:JumpTo(23)
                    end)
                    GUI:addOnClickEvent(paihang, function()
                        SL:JumpTo(32)
                    end)
                    GUI:addOnClickEvent(exit, function()
                        SL:JumpTo(29)
                    end)
                    -- local zz = GUI:Button_Create(cbl, "lbg", width/2, cogin.h - 80, "res/wy/public/main_cbl_zz.png")
                    -- local syt = GUI:Button_Create(cbl, "sqt", width/2, cogin.h - 80 - 105, "res/wy/public/main_cbl_syt.png")
                    -- local ldl = GUI:Button_Create(cbl, "tj", width/2, cogin.h - 80 - 210, "res/wy/public/main_cbl_ldl.png")
                    -- GUI:setAnchorPoint(zz, 0.5, 1)
                    -- GUI:setAnchorPoint(syt, 0.5, 1)
                    -- GUI:setAnchorPoint(ldl, 0.5, 1)
                    -- GUI:addOnClickEvent(zz, function() SL:SendLuaNetMsg(105, 166, 166, 0, "") end)
                    -- GUI:addOnClickEvent(syt, function() SL:SendLuaNetMsg(105, 19, 19, 0, "") end)
                    -- GUI:addOnClickEvent(ldl, function()  SL:SendLuaNetMsg(105, 103, 103, 0, "") end)
                    GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w, y = 0}, 0.5)
                end)
                --客服
                if SL:GetMetaValue("IS_SHOW_MAUNAL_SERVICE") or true then
                    local kefu = GUI:Button_Create(npc.RightBottom, "kefu", -260 - 100, 90, "res/wy/icon/kefu_pc.png")
                    GUI:addOnClickEvent(kefu, function()
                        SL:RequestOpen996ManualService()
                    end)
                    ManualService = {}
                    function ManualService.OnUnReadMessage(data)
                        if data and data.unReadNums > 0 then
                            return
                        end
                    end

                    function ManualService.RegisterEvent()
                        SL:RegisterLUAEvent("LUA_EVENT_MANUAL_SERVICE_MESSAGE_UN_READ", "ManualService", ManualService.OnUnReadMessage)
                    end

                    function ManualService.UnRegisterEvent()
                        SL:UnRegisterLUAEvent("LUA_EVENT_MANUAL_SERVICE_MESSAGE_UN_READ", "ManualService")
                    end
                end

                local moji = GUI:Effect_Create(npc.RightBottom, "moji", -260, 40, 0, 7060, 0, 0, 0, 1)
                local Layout = GUI:Layout_Create(moji, "Layout", 0, 0, 48, 48, false)
                GUI:setTouchEnabled(Layout, true)
                GUI:addOnClickEvent(Layout, function()
                    SL:OpenChatExtendUI(2)
                end)

                --移动各位刺杀开关
                local gwcs = GUI:Button_Create(npc.RightBottom, "gwcs", -130, 210, "res/wy/icon/gwcs.png")
                GUI:Button_setGrey(gwcs,  SL:GetMetaValue("SETTING_VALUE", 56)[1] ~= 1)
                GUI:addOnClickEvent(gwcs, function()
                    if SL:GetMetaValue("SETTING_VALUE", 56)[1] == 1 then
                        SL:SetMetaValue("SETTING_VALUE", 56, {0})
                        GUI:Button_setGrey(gwcs, true)
                    else
                        SL:SetMetaValue("SETTING_VALUE", 56, {1})
                        GUI:Button_setGrey(gwcs, false)
                    end
                end)
                --醉酒狂魔舞
                local zjkmw = GUI:Button_Create(npc.RightBottom, "zjkmw", -80, 550 - 135, "res/custom/five_city/zjkmw/img.png")
                GUI:addOnClickEvent(zjkmw, function()

                    if GUI:getChildByName(zjkmw, "img_bj") then
                        GUI:removeChildByName(zjkmw, "img_bj")
                        return
                    end

                    npc.bg = GUI:Image_Create(zjkmw, "img_bj", 100, 0, "res/custom/five_city/zjkmw/bg.png")
                    GUI:setTouchEnabled(npc.bg, true)
                    GUI:setAnchorPoint(npc.bg, 1, 0.5)
                    GUI:setOpacity(npc.bg, 0)
                    GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, 0, 0), GUI:ActionFadeIn(0.3)))
                    npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)

                    local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",SL:GetMetaValue("MAIN_ACTOR_ID"),20103)

                    local Button = GUI:Button_Create(npc.node, "Button", 0, 10.00, "res/custom/five_city/zjkmw/btn_"..(buff and 2 or 1)..".png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, 70, 2, 0, "")
                        -- if buff then
                        --     GUI:Button_loadTextures(Button, "res/custom/five_city/zjkmw/btn_1.png")
                        -- end
                    end)

                    SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)
                        if data.buffID == 20103 then
                            local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",SL:GetMetaValue("MAIN_ACTOR_ID"),20103)
                            GUI:Button_loadTextures(Button, "res/custom/five_city/zjkmw/btn_"..(buff and 2 or 1)..".png")
                            if buff then
                                GUI:Frames_Create(zjkmw, "eff", 0, 0, "res/custom/five_city/zjkmw/eff/eff_", ".png", 1, 75,
                                { speed = 75, count = 75, loop = 0})
                            else
                                GUI:removeChildByName(zjkmw, "eff")
                            end
                            
                        end
                    end)

                end)
            else
                npc.sjbeibao = GUI:Button_Create(npc.RightTop, "beibao", -160, -230, "res/private/main/bottom/bag.png")
                npc.jueshe = GUI:Button_Create(npc.RightTop, "jueshe", -240, -230, "res/private/main/bottom/js.png")
                GUI:addOnClickEvent(npc.sjbeibao, function()
                    SL:OpenBagUI()
                end)
                GUI:addOnClickEvent(npc.jueshe, function()
                    SL:OpenMyPlayerUI()
                end)
                guaji[1] = GUI:Button_Create(npc.RightTop, "guaji", -80, -230, "res/wy/icon/base.png")

                --移动各位刺杀开关
                local gwcs = GUI:Button_Create(npc.RightTop, "gwcs", -160, -230 - 100, "res/wy/icon/gwcs.png")
                GUI:Button_setGrey(gwcs,  SL:GetMetaValue("SETTING_VALUE", 56)[1] ~= 1)
                GUI:addOnClickEvent(gwcs, function()
                    if SL:GetMetaValue("SETTING_VALUE", 56)[1] == 1 then
                        SL:SetMetaValue("SETTING_VALUE", 56, {0})
                        --GUI:Text_setString(gwcs_wz, "未开启")
                        GUI:Button_setGrey(gwcs, true)
                    else
                        SL:SetMetaValue("SETTING_VALUE", 56, {1})
                        --GUI:Text_setString(gwcs_wz, "已开启")
                        GUI:Button_setGrey(gwcs, false)
                    end
                end)
            end
            GUI:addOnClickEvent(guaji[1], function()
                if SL:GetMetaValue("BATTLE_IS_AFK") then
                    SL:SetMetaValue("BATTLE_AFK_END")
                else
                    SL:SetMetaValue("BATTLE_AFK_BEGIN")
                end
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKBEGIN, "开始自动挂机", function()
                guaji[3] = GUI:Effect_Create(guaji[1], "moji", 32, 32, 0, 4005, 0, 0, 0, 1)
                GUI:setScale(guaji[3], 0.6)
                SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用", function(data)
                    if SL:GetMetaValue("BATTLE_IS_AFK") then
                        if data.act == 25 then
                            if cogin.guajikawei[1] == 6 or cogin.guajikawei[1] == 1 then
                                if cogin.guajikawei[2] > 5 then
                                    cogin.guajikawei[2] = 0
                                    --TODO -- 怪物卡位
                                    --SL:UseItemByIndex(10001)
                                else
                                    cogin.guajikawei[1] = 0
                                    cogin.guajikawei[2] = cogin.guajikawei[2] + 1
                                end
                            else
                                if cogin.guajikawei[2] > 0 then
                                    cogin.guajikawei[2] = 0
                                end
                            end
                        else
                            cogin.guajikawei[1] = data.act
                        end
                    end
                end)
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKEND, "结束自动挂机", function()
                SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用")
                if guaji[3] then
                    GUI:removeFromParent(guaji[3])
                end
            end)

            npc.dbLayout = GUI:Layout_Create(npc.RightTop, "Layout1", zbz[1], zbz[2], 490, 160, false)
            npc.dbshousuo = GUI:Button_Create(npc.RightTop, "shousuo", zbz[4], zbz[5], "res/wy/icon/s.png")
            GUI:setAnchorPoint(npc.dbshousuo, 0.5, 0)
            GUI:addOnClickEvent(npc.dbshousuo, function(self)
                npc._shortcut_collapsed = not npc._shortcut_collapsed
                _refresh_shortcut_collapsed_state(true)
            end)
            rebuildShortcutButtons("")
            registerShortcutTitleRefresh()
            ---快捷打开按钮
            UPGRADE_HELPER.registerOpenNpcButtons()
            UPGRADE_HELPER.startEquipChangeRefresh()
            UPGRADE_HELPER.startAutoRefresh(20 * 1)
            

        elseif p3 == 1 then
            rebuildShortcutButtons(msgData or "")
            registerShortcutTitleRefresh()
            UPGRADE_HELPER.registerOpenNpcButtons()
            UPGRADE_HELPER.startEquipChangeRefresh()
            UPGRADE_HELPER.startAutoRefresh(20 * 1)
        end
    elseif p2 == 10 then -- 红点
        if npc.db_anniu[""..p3] and not GUI:ui_delegate(npc.db_anniu[""..p3]).redpoint then
            NPC_UI_HELPER.redpoint_create_eff(npc.db_anniu[""..p3], {x = 80,y = 60})
        end
    end
end
---回收面板
npc[2] = function(p2, p3, msgData) -- 回收面板
    if p2 == 2 then
        local shuju = SL:JsonDecode(msgData,false)
        shuju.xz = shuju.xz or {}
        shuju.kg = shuju.kg or {}

        -- 工具：重用/创建指定窗口，避免重复的 Win_Create
        local recycleWindow = ensureWindow("recycle", 2, {titleText = "装备回收"})
        local parent = recycleWindow.parent
        npc.bg = recycleWindow.bg
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Win_SetDrag(parent, npc.bg)
        GUI:Win_SetZPanel(parent, npc.bg)
        GUI:removeChildByName(parent, "bjt")

        -- 工具：同步勾选状态到服务器并记录本地表
        local function syncSelection(key, isSelected)
            shuju.xz[key] = isSelected and 1 or nil
            SL:SendLuaNetMsg(101, 2, 2, 0, key)
        end

        -- 工具：如果父级/分组处于选中，则清除并通知服务器
        local function clearSelectionIfNeeded(key)
            if key and shuju.xz[key] and shuju.xz[key] == 1 then
                syncSelection(key, false)
            end
        end


        local hs_tab_map = {
            [1] = "zzhs",
            [2] = "zsfj",
            [3] = "sqhs",
            [4] = "gwfj",
            [5] = "ssfj",
            [6] = "clfj",
            [7] = "teshuhuihsou",
        }
        local refresh_bulk_select_state

        local function setRecycleText(widget, color, size, outline)
            -- GUI:Text_setFontName(widget, "fonts/500.ttf")
            GUI:Text_enableOutline(widget, outline or "#110b05", 2)
            if color then
                GUI:Text_setTextColor(widget, color)
            end
            if size then
                GUI:Text_setFontSize(widget, size)
            end
        end

        local function getGroupNameColor(name)
            local text = tostring(name or "")
            local colorByTier = {
                "#72F26B",
                "#66F0A9",
                "#72E9D8",
                "#79D7FF",
                "#8CB9FF",
                "#A99BFF",
                "#C58CFF",
                "#E688FF",
                "#FF8EDC",
                "#FF9FB0",
                "#FFAE7A",
                "#FFC15F",
                "#FFD451",
                "#FFE46C",
                "#FFF08A",
            }

            local function clampTier(tier)
                tier = tonumber(tier or 1) or 1
                if tier < 1 then
                    tier = 1
                elseif tier > #colorByTier then
                    tier = #colorByTier
                end
                return tier
            end

            local startTier = string.match(text, "基础装备(%d+)%-%d+")
            if startTier then
                local tier = tonumber(startTier) or 1
                return colorByTier[clampTier(tier)]
            end

            local zishuTier = string.match(text, "专属附加(%d+)")
            if zishuTier then
                return colorByTier[clampTier(zishuTier)]
            end

            local shizhuangTier = string.match(text, "时装首饰(%d+)")
            if shizhuangTier then
                return colorByTier[clampTier((tonumber(shizhuangTier) or 1) + 5)]
            end

            local shengxiaoTier = string.match(text, "生肖(%d+)")
            if shengxiaoTier then
                return colorByTier[clampTier((tonumber(shengxiaoTier) or 1) + 1)]
            end

            local guwanTierMap = {
                ["唐代"] = 1,
                ["宋代"] = 3,
                ["元代"] = 5,
                ["明代"] = 7,
                ["清代"] = 9,
                ["近代"] = 11,
            }
            for key, tier in pairs(guwanTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end

            local shenshiTierMap = {
                ["稀有"] = 4,
                ["史诗"] = 7,
                ["神话"] = 11,
                ["传说"] = 14,
            }
            for key, tier in pairs(shenshiTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end

            local cailiaoTierMap = {
                ["常规材料"] = 1,
                ["主线材料"] = 5,
                ["海域材料"] = 9,
                ["西游材料"] = 13,
            }
            for key, tier in pairs(cailiaoTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end

            return "#F5E6B2"
        end

        -- 回收奖励显示与服务端/配置同源：
        -- 常规页签：{组别, 子组, 名称, 金币, 元宝}
        -- 专属附加：{组别, 子组, 名称, 数量, 辉耀水晶标记, 幻灵石标记}
        local function formatRecycleReward(cfg)
            if type(cfg) ~= "table" then
                return ""
            end

            local groupType = tonumber(cfg.gl or cfg[1] or 0) or 0
            local countA = tonumber(cfg[4] or 0) or 0
            local countB = tonumber(cfg[5] or 0) or 0
            local countC = tonumber(cfg[6] or 0) or 0

            if groupType == 2 then
                if countB == 1 then
                    return "辉耀水晶*" .. tostring(countA)
                end
                if countC == 1 then
                    return "幻灵石*" .. tostring(countA)
                end
                return "不返还"
            end

            local parts = {}
            if countA > 0 then
                parts[#parts + 1] = "金币*" .. tostring(countA)
            end
            if countB > 0 then
                parts[#parts + 1] = "元宝*" .. tostring(countB)
            end
            return #parts > 0 and table.concat(parts, " ") or "无"
        end

        -- 回收表里有一部分只是分段标题，占位展示用，不作为实际可勾选道具显示。
        local function isRecycleTitleItem(cfg)
            local itemName = tostring(cfg and cfg[3] or "")
            return string.find(itemName, "^·%-%-%-") ~= nil
        end

        local function collect_current_select_keys()
            local keyMap = {}
            local category_key = hs_tab_map[npc.s]
            if not category_key then
                return {}
            end

            local function add_key(key)
                if key ~= nil and key ~= "" then
                    keyMap[tostring(key)] = true
                end
            end

            local function normalize_category_data_for_bulk()
                local source = cogin.hs[category_key]
                if type(source) ~= "table" then
                    return {}
                end

                if category_key == "zzhs" then
                    local merged = {}
                    for k, v in pairs(source) do
                        merged[k] = v
                    end
                    for k, v in pairs(cogin.hs.fzfj or {}) do
                        merged[k] = v
                    end
                    return merged
                end

                local by_tab = source[npc.s]
                if type(by_tab) == "table" then
                    if by_tab.l then
                        return {[npc.s] = {by_tab}}
                    end
                    return {[npc.s] = by_tab}
                end

                if source.l then
                    return {[npc.s] = {source}}
                end

                if category_key == "teshuhuihsou" then
                    local group_idx = npc.s
                    for _, cfg in pairs(source) do
                        if type(cfg) == "table" and cfg[1] then
                            group_idx = cfg[1]
                            break
                        end
                    end
                    return {[group_idx] = {{name = "teshuhuihsou", l = source}}}
                end

                for k, v in pairs(source) do
                    if type(v) == "table" and type(v.l) == "table" then
                        return {[k] = {v}}
                    end
                end

                return source
            end

            local category_data = normalize_category_data_for_bulk()
            for v, group_data in pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local group_key = tostring(npc.s) .. "_" .. tostring(v)
                            local subgroup_key = group_key .. "_" .. tostring(vv)
                            add_key(group_key)
                            add_key(subgroup_key)
                        end
                    end
                end
            end

            local keys = {}
            for key, _ in pairs(keyMap) do
                keys[#keys + 1] = key
            end
            return keys
        end

        local function batch_set_current_select_state(isSelected)
            local keys = collect_current_select_keys()
            for _, key in ipairs(keys) do
                local current = shuju.xz[key] and shuju.xz[key] == 1 or false
                if current ~= isSelected then
                    syncSelection(key, isSelected)
                end
            end
        end

        local function hasGroupSelection(config)
            if not config or not config.gl or not config[1] then
                return false
            end
            local prefix = tostring(config.gl) .. "_" .. tostring(config[1])
            if shuju.xz[prefix] then
                return true
            end
            if config[2] and shuju.xz[prefix .. "_" .. tostring(config[2])] then
                return true
            end
            return false
        end


        -- 列表刷新：根据背包数据生成回收选择槽
        function xiaohui_update()
            if not npc.bbzs then
                return
            end
            GUI:removeAllChildren(npc.bbzs)
            local rowLayouts = {}
            local bagItems = SL:GetMetaValue("BAG_DATA") or {}
            npc.hs = {}
            local rowIndex = 0
            local slotIndex = 1
            local inRecycle = {}
            local itemWidgets = {}
            local huishou_jc_list = cogin.huishou_jc_list

            -- 移除指定道具索引，保持 npc.hs 与 UI 状态一致
            local function removeFromRecycleList(index)
                for idx = #npc.hs, 1, -1 do
                    if npc.hs[idx] == index then
                        table.remove(npc.hs, idx)
                        break
                    end
                end
            end

            -- 设置道具选中/取消状态，同时驱动高亮
            local function setRecycleSelection(index, shouldSelect)
                local widget = itemWidgets[index]
                if not widget then
                    return
                end
                GUI:ItemShow_setItemShowChooseState(widget, shouldSelect)
                if shouldSelect then
                    if not inRecycle[index] then
                        table.insert(npc.hs, index)
                    end
                    inRecycle[index] = true
                else
                    if inRecycle[index] then
                        removeFromRecycleList(index)
                    end
                    inRecycle[index] = false
                end
            end

            local function toggleRecycleSelection(index)
                setRecycleSelection(index, not inRecycle[index])
            end

            for bagIndex, bagItem in pairs(bagItems) do
                if slotIndex > 12 * rowIndex then
                    rowIndex = rowIndex + 1
                    rowLayouts[rowIndex] = GUI:Layout_Create(npc.bbzs, "h" .. rowIndex, 0, 0, 500, 41 ,false)
                end
                local config = huishou_jc_list[bagItem.Index]
                if config and not isRecycleTitleItem(config) then
                    local rowParent = rowLayouts[rowIndex]
                    if rowParent then
                        local slot = GUI:Image_Create(rowParent, "kuang" .. slotIndex, ((((slotIndex - 1) % 12)) * 41) + 4, 0, "res/wy/public/40-40.png")
                        if slot then
                            local itemShow = GUI:ItemShow_Create(slot, "item" .. slotIndex, 20, 20, {itemData = bagItem, count = bagItem.Count, look = true, bgVisible = false})
                            if itemShow then
                                if not cogin.isWin32 then
                                    GUI:setScale(itemShow, 0.7)
                                end
                                GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                                GUI:setTouchEnabled(slot, true)

                                itemWidgets[bagIndex] = itemShow
                                inRecycle[bagIndex] = false

                                GUI:addOnClickEvent(slot, function()
                                    toggleRecycleSelection(bagIndex)
                                end)
                                GUI:ItemShow_addReplaceClickEvent(itemShow, function()
                                    toggleRecycleSelection(bagIndex)
                                end)

                                local shouldSelect = hasGroupSelection(config) or shuju.xz["" .. bagItem.Index]
                                if shouldSelect then
                                    setRecycleSelection(bagIndex, true)
                                end
                            end
                        end
                    end
                    slotIndex = slotIndex + 1
                end
            end
        end
        local ty_node = GUI:Node_Create(recycleWindow.node,"ty_node",0,0)
        local jm_node = GUI:Node_Create(recycleWindow.node,"jm_node",0,0)
        npc.bbzs = GUI:ListView_Create(ty_node, "bbzs", 226, 140, 404, 98, 1)
        GUI:ListView_setItemsMargin(npc.bbzs, 2)
        GUI:ListView_setGravity(npc.bbzs, 2)

        


        -- 刷新分类区域（左侧标签 + 右侧选项）并重置悬浮窗口
        local function new_hs_update()
            GUI:removeAllChildren(jm_node)

            local category_key = hs_tab_map[npc.s]
            if not category_key then
                return
            end

            local function sorted_pairs(tbl)
                local keys = {}
                for key in pairs(tbl or {}) do
                    keys[#keys + 1] = key
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    end
                    return tostring(a) < tostring(b)
                end)
                local idx = 0
                return function()
                    idx = idx + 1
                    local key = keys[idx]
                    if key ~= nil then
                        return key, tbl[key]
                    end
                end
            end

            local function normalize_category_data()
                local source = cogin.hs[category_key]
                if type(source) ~= "table" then
                    return {}
                end

                if category_key == "zzhs" then
                    local merged = {}
                    for k, v in pairs(source) do
                        merged[k] = v
                    end
                    for k, v in pairs(cogin.hs.fzfj or {}) do
                        merged[k] = v
                    end
                    return merged
                end

                local by_tab = source[npc.s]
                if type(by_tab) == "table" then
                    if by_tab.l then
                        return {[npc.s] = {by_tab}}
                    end
                    return {[npc.s] = by_tab}
                end

                if source.l then
                    return {[npc.s] = {source}}
                end

                if category_key == "teshuhuihsou" then
                    local group_idx = npc.s
                    for _, cfg in pairs(source) do
                        if type(cfg) == "table" and cfg[1] then
                            group_idx = cfg[1]
                            break
                        end
                    end
                    return {[group_idx] = {{name = "teshuhuihsou", l = source}}}
                end

                for k, v in pairs(source) do
                    if type(v) == "table" and type(v.l) == "table" then
                        return {[k] = {v}}
                    end
                end

                return source
            end

            local category_data = normalize_category_data()
            local subgroup_count = 0
            for _, group_data in pairs(category_data) do
                if type(group_data) == "table" then
                    for _, subgroup in pairs(group_data) do
                        if type(subgroup) == "table" and type(subgroup.l) == "table" then
                            subgroup_count = subgroup_count + 1
                        end
                    end
                end
            end
            subgroup_count = math.max(subgroup_count, 1)

            local visible_width = 414
            local visible_height = 228
            local list_height = math.max(visible_height, 58 * math.ceil(subgroup_count / 2))
            local ScrollView = GUI:ScrollView_Create(jm_node, "ScrollView", 135.00, 112.00, visible_width, visible_height, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, visible_width, list_height)
            GUI:setTouchEnabled(ScrollView, true)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            local s_list = GUI:Layout_Create(ScrollView, "s_list", 0.00, 0.00, visible_width, list_height)

            local function open_subgroup_popup(anchor_btn, group_key, subgroup_key, subgroup_cfg)
                local xjm_parent = npc.hs_xbj
                if xjm_parent then
                    GUI:removeFromParent(xjm_parent)
                    npc.hs_xbj = nil
                end

                npc.hs_xbj = GUI:Image_Create(jm_node, "bj", 258 + 329, 318, "res/private/item_tips/bg_tipszy_05.png")
                GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                GUI:setTouchEnabled(npc.hs_xbj, true)
                GUI:setContentSize(npc.hs_xbj, 252, 300)
                GUI:Win_SetZPanel(jm_node, npc.hs_xbj)
                GUI:setLocalZOrder(npc.hs_xbj, 99)

                local titleText = GUI:Text_Create(npc.hs_xbj, "popup_title", 126, 268, 24, "#F4D879", subgroup_cfg.name or "回收分组")
                GUI:setAnchorPoint(titleText, 0.5, 0.5)
                setRecycleText(titleText, "#F4D879", 24, "#110b05")

                local x_close = GUI:Button_Create(npc.hs_xbj, "close", 252, 300, "res/public/1900000511.png")
                GUI:setAnchorPoint(x_close, 0, 1)
                GUI:addOnClickEvent(x_close, function()
                    GUI:removeFromParent(npc.hs_xbj)
                    npc.hs_xbj = nil
                end)

                local function popup_is_all_selected()
                    if (shuju.xz[group_key] and shuju.xz[group_key] == 1)
                        or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1) then
                        return true
                    end
                    local hasEntry = false
                    for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                        if not isRecycleTitleItem(item_cfg) then
                            hasEntry = true
                            if not (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1) then
                                return false
                            end
                        end
                    end
                    return hasEntry
                end

                local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 11, 46, 230, 198, 1)
                GUI:ListView_setGravity(s_s_s_list, 2)
                GUI:ListView_setItemsMargin(s_s_s_list, 6)

                for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                    if not isRecycleTitleItem(item_cfg) then
                        local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn" .. item_idx, 0, 0, "res/wy/public/new_kuang.png")
                        GUI:setContentSize(s_s_s_btn, 228, 50)
                        local iconBg = GUI:Image_Create(s_s_s_btn, "icon_bg", 8, 8, "res/wy/public/40-40.png")
                        local itemShow = GUI:ItemShow_Create(iconBg, "item", 20, 20, { index = item_idx, look = true, bgVisible = false })
                        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                        local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox", 186, 12, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                        GUI:CheckBox_setSelected(
                            s_s_s_CheckBox,
                            (shuju.xz[group_key] and shuju.xz[group_key] == 1)
                                or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1)
                                or (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1)
                        )
                        GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                            syncSelection(tostring(item_idx), GUI:CheckBox_isSelected(self))
                            clearSelectionIfNeeded(group_key)
                            clearSelectionIfNeeded(subgroup_key)
                        end)
                        local item_name = item_cfg and item_cfg[3] or tostring(item_idx)
                        local reward_desc = formatRecycleReward(item_cfg)
                        -- local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 110, 28, "<a href='jump#item_tips#" .. item_idx .. "'>" .. item_name .. "</a>", 120, 18, "#f0c14b", 1, nil, nil, {outlineSize = 2, outlineColor = SL:ConvertColorFromHexString("#100808")})
                        local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 120, 35, item_name, 200, 16, "#f0c14b", 1, nil, nil, {})
                        GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                        local rewardText = GUI:Text_Create(s_s_s_btn, "reward", 110, 17, 16, "#F3E8CE", reward_desc)
                        GUI:setAnchorPoint(rewardText, 0.5, 0.5)
                        setRecycleText(rewardText, "#F3E8CE", 16, "#110b05")
                    end
                end

                local allSelectBtn = GUI:Button_Create(npc.hs_xbj, "all_select", 126, 4, "res/public/1900000660.png")
                GUI:setAnchorPoint(allSelectBtn, 0.5, 0)
                GUI:Button_setTitleText(allSelectBtn, popup_is_all_selected() and "取消全选" or "全选")
                GUI:Button_setTitleColor(allSelectBtn, "#F4E7B5")
                GUI:Button_setTitleFontSize(allSelectBtn, 20)
                GUI:Button_titleEnableOutline(allSelectBtn, "#110b05", 2)
                GUI:addOnClickEvent(allSelectBtn, function()
                    local targetSelected = not popup_is_all_selected()
                    if targetSelected then
                        syncSelection(subgroup_key, true)
                        clearSelectionIfNeeded(group_key)
                    else
                        clearSelectionIfNeeded(group_key)
                        clearSelectionIfNeeded(subgroup_key)
                        for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                            if not isRecycleTitleItem(item_cfg) then
                                clearSelectionIfNeeded(tostring(item_idx))
                            end
                        end
                    end
                    new_hs_update()
                    if refresh_bulk_select_state then
                        refresh_bulk_select_state()
                    end
                    open_subgroup_popup(anchor_btn, group_key, subgroup_key, subgroup_cfg)
                end)
            end

            for v, group_data in sorted_pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in sorted_pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local s_s_btn = GUI:Image_Create(s_list, "s_s_btn" .. tostring(v) .. "_" .. tostring(vv), 0, 0, "res/wy/public/new_kuang.png")
                            GUI:setContentSize(s_s_btn, 198, 48)
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox", 164, 11, "res/wy/public/xz0.png", "res/wy/public/xz1.png")

                            local group_key = npc.s .. "_" .. tostring(v)
                            local subgroup_key = group_key .. "_" .. tostring(vv)

                            GUI:CheckBox_setSelected(
                                s_s_CheckBox,
                                (shuju.xz[group_key] and shuju.xz[group_key] == 1)
                                    or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1)
                            )
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                local selected = GUI:CheckBox_isSelected(self)
                                syncSelection(subgroup_key, selected)
                                if selected then
                                    clearSelectionIfNeeded(group_key)
                                end
                            end)

                            local group_name = subgroup_cfg.name or ("分组" .. tostring(vv))
                            local color = getGroupNameColor(group_name)
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 84, 26, 18, color, group_name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            setRecycleText(s_s_wz, color, 18, "#110b05")

                            GUI:setTouchEnabled(s_s_btn, true)
                            GUI:addOnClickEvent(s_s_btn, function()
                                open_subgroup_popup(s_s_btn, group_key, subgroup_key, subgroup_cfg)
                            end)
                        end
                    end
                end
            end

            GUI:UserUILayout(s_list, {dir = 3, addDir = 1, colnum = 2, gap = {x = 12, y = 10}})
        end

        npc.s = 1
        npc.s_s = 1
        npc.s_s_s = 1
        npc.hs_btn = {}
        
        
        local l_list = GUI:ListView_Create(ty_node, "ListView", 15.00, 15.00, 120.00, 325.00, 1)
        GUI:ListView_setItemsMargin(l_list, 8)
        GUI:ListView_setGravity(l_list, 2)
        for ii = 1,6 do
            GUI:Image_Create(l_list, "fgx"..ii, 0, 0, "res/wy/public/huishou/hsan_fgx.png")
            npc.hs_btn["s_"..ii] = GUI:Button_Create(l_list, "san"..ii, 0, 0, "res/wy/public/huishou/hsan_nsan_"..ii..".png")
            GUI:addOnClickEvent(npc.hs_btn["s_"..ii], function()
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_nsan_"..npc.s..".png")
                 GUI:removeChildByName(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang")
                npc.s = ii
                npc.s_s = 1
                npc.s_s_s = 1
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
                GUI:Image_Create(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
                new_hs_update()
                if refresh_bulk_select_state then
                    refresh_bulk_select_state()
                end
            end)
        end
        GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
        GUI:Image_Create(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
        local CheckBox_zdhs = GUI:CheckBox_Create(ty_node, "kaiguan1",380, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
        GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)

        local CheckBox2 = GUI:CheckBox_Create(ty_node, "kaiguan2",250, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox2, shuju.kg[3] == 1)
        GUI:CheckBox_addOnEvent(CheckBox2, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 3, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        local CheckBox3 = GUI:CheckBox_Create(ty_node, "kaiguan3",250, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox3, shuju.kg[2] == 1)
        GUI:CheckBox_addOnEvent(CheckBox3, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 1, GUI:CheckBox_isSelected(self) and 1 or 0)
            SL:SendLuaNetMsg(101, 2, 4, 2, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        --一键全选
        local CheckBox4 = GUI:CheckBox_Create(ty_node, "kaiguan4",380, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        local CheckBox5
        local bulk_checkbox_lock = false
        refresh_bulk_select_state = function()
            local keys = collect_current_select_keys()
            local allSelected = #keys > 0
            for _, key in ipairs(keys) do
                if not (shuju.xz[key] and shuju.xz[key] == 1) then
                    allSelected = false
                    break
                end
            end
            bulk_checkbox_lock = true
            GUI:CheckBox_setSelected(CheckBox4, allSelected)
            GUI:CheckBox_setSelected(CheckBox5, not allSelected)
            bulk_checkbox_lock = false
        end
        GUI:CheckBox_addOnEvent(CheckBox4, function(self)
            if bulk_checkbox_lock then
                return
            end
            batch_set_current_select_state(true)
            refresh_bulk_select_state()
            -- xiaohui_update()
            new_hs_update()
        end)
        --一键取消全选
        CheckBox5 = GUI:CheckBox_Create(ty_node, "kaiguan5",510, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_addOnEvent(CheckBox5, function(self)
            if bulk_checkbox_lock then
                return
            end
            batch_set_current_select_state(false)
            refresh_bulk_select_state()
            -- xiaohui_update()
            new_hs_update()
        end)

        npc.yjcz = GUI:Button_Create(ty_node, 'yjcz', 430, 15, 'res/wy/public/hsan_11.png')
        GUI:addOnClickEvent(npc.yjcz, function()
            if npc.s >= 1 and npc.s <= 7 then
                local item = SL:GetMetaValue("BAG_DATA")
                local hs = {}
                local huishou_jc_list = cogin.huishou_jc_list
                for k, v in pairs(item) do
                    if huishou_jc_list[v.Index] and (hasGroupSelection(huishou_jc_list[v.Index]) or shuju.xz["" .. v.Index]) then
                        table.insert(hs, k)
                    end
                end
                if #hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 5, 1, SL:JsonEncode(hs,false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未发现可分解物品</font>")
                end
            end
        end)
        local rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid) or 0
        if rwid == 10 then
            NPC_UI_HELPER.startGuide({dir = 5, guideWidget = npc.yjcz, guideParent = ty_node, guideDesc = "一键回收", isForce = false,hideMask = true})
        end

        new_hs_update()
        -- xiaohui_update()
        refresh_bulk_select_state()
    elseif p2 == 4 then  -- refresh
        if npc.bbzs then
            -- xiaohui_update()
        end
    end
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close", function(self)
        if self == "npc_huishou"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close")
            local xjm_parent = npc.hs_xbj
            if xjm_parent then
                GUI:removeFromParent(xjm_parent)
                npc.hs_xbj = nil
            end
        end
    end)
end
---伏妖录任务
----任务名,npcid,任务类型（1为主线任务,2为支线任务）,任务检测（1数字型,2数组型,3称号型）,任务结束标志和进度标志,任务传送地点,任务传送限制（{1,10}等级,{2,10}转生,{3,”称号“}所需称号）
npc.xyl = SL:Require("GUILayout/Data/xyl.lua", true)
local LUA_EVENT_YWL_CURRENT_TASK_CHANGE = "伏妖录当前任务变更"
---异闻录：章节任务界面（UIHelper 统一窗口）
npc[11] = function(p2, p3, Data)
    local AUTO_GUIDE_TASKS = {
        ["天书强化"] = true,
        ["开辟仙府"] = true,
        ["寻宝大师"] = true,
    }

    local function _ywl_get_task_name_from_current_task(currentTask)
        if type(currentTask) ~= "table" then
            return ""
        end
        local taskName = tostring(currentTask.name or currentTask.task_name or currentTask.taskName or "")
        if taskName ~= "" then
            return taskName
        end
        local dq = tostring(currentTask.dq or currentTask.current_xyl_dq or currentTask.currentXylDq or "")
        local i, j, z = string.match(dq, "^(%d+)_(%d+)_(%d+)$")
        i = tonumber(i)
        j = tonumber(j)
        z = tonumber(z)
        local task = i and j and z and npc.xyl and npc.xyl[i] and npc.xyl[i][j] and npc.xyl[i][j].jq and npc.xyl[i][j].jq[z]
        if type(task) == "table" then
            return tostring(task[1] or task.title or "")
        end
        return ""
    end

    local function _ywl_is_chapter_reward_ready(i, j)
        local lCfg = npc.xyl and npc.xyl[i]
        local zjCfg = type(lCfg) == "table" and lCfg[j] or nil
        local tasks = zjCfg and zjCfg.jq or nil
        if type(tasks) ~= "table" or #tasks <= 0 then
            return false
        end
        local ywlData = npc.data and npc.data.ywl or {}
        if ywlData["jl_" .. i .. "_" .. j] == 1 then
            return false
        end
        for idx = 1, #tasks do
            if ywlData["jl_" .. i .. "_" .. j .. "_" .. idx] ~= 1 then
                return false
            end
        end
        return true
    end

    local function _ywl_try_start_chapter_reward_guide(guideParent, force)
        if not npc.jl then
            return false
        end
        local i = tonumber(npc.l) or 0
        local j = tonumber(npc.zj) or 0
        if i <= 0 or j <= 0 then
            return false
        end
        if not _ywl_is_chapter_reward_ready(i, j) then
            return false
        end
        local guideKey = string.format("%s_%s_reward", tostring(i), tostring(j))
        if not force and npc._ywl_auto_guided_reward_key == guideKey then
            return false
        end
        npc._ywl_auto_guided_reward_key = guideKey
        NPC_UI_HELPER.startGuide({
            dir = 3,
            guideWidget = npc.jl,
            guideParent = guideParent or GUI:getParent(npc.jl),
            guideDesc = "点击领取章节奖励",
            isForce = false,
            hideMask = true
        })
        return true
    end

    local function _ywl_find_next_chapter(curL, curZj)
        local startL = tonumber(curL) or 2
        local startZj = tonumber(curZj) or 0
        for i = startL, #npc.xyl do
            local lCfg = npc.xyl[i]
            if type(lCfg) == "table" and #lCfg > 0 then
                local begin = 1
                if i == startL then
                    begin = math.max(1, startZj + 1)
                end
                for j = begin, #lCfg do
                    return i, j
                end
            end
        end
        return nil, nil
    end

    local function _ywl_is_valid_gui_node(node)
        if not node then
            return false
        end
        return not tolua.isnull(node)
    end

    local function _ywl_story_node_done(node)
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

    local function _ywl_story_node_started(node)
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

    local function _ywl_is_task_started_or_done_by_story(taskName, task)
        local raw = Player:getServerVar("T13")
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end

        local tk = task and task.tk
        if tk and _ywl_story_node_started(storyData[tk]) then
            return true
        end

        if taskName == "开辟仙府" then
            local xianfuRaw = Player:getServerVar("T47")
            if xianfuRaw and xianfuRaw ~= "" then
                local xianfuOk, xianfuData = pcall(function()
                    return Player:JsonToTbl(xianfuRaw)
                end)
                return xianfuOk and type(xianfuData) == "table" and next(xianfuData) ~= nil
            end
        end
        return false
    end

    local function _ywl_has_third_continent_full_entry()
        local raw = Player:getServerVar("T13")
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end
        return _ywl_story_node_done(storyData["npc_46"])
    end

    local function _ywl_has_third_continent_half_entry()
        local raw = Player:getServerVar("T13")
        if raw and raw ~= "" then
            local ok, storyData = pcall(function()
                return Player:JsonToTbl(raw)
            end)
            if ok and type(storyData) == "table" and _ywl_story_node_done(storyData["npc_46"]) then
                return true
            end
        end

        local xianfuRaw = Player:getServerVar("T47")
        if not xianfuRaw or xianfuRaw == "" then
            return false
        end
        local ok, xianfuData = pcall(function()
            return Player:JsonToTbl(xianfuRaw)
        end)
        return ok and type(xianfuData) == "table" and next(xianfuData) ~= nil
    end

    local function _ywl_is_third_continent_half_chapter(name)
        if not name or name == "" then
            return false
        end
        return name == "灰界开篇" or name == "仙府功能"
    end

    local function _ywl_append_reward_entries(outList, rewardList, seenMap)
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

    local function _ywl_normalize_title_reward_name(titleName)
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

    local function _ywl_append_title_reward(outList, titleName, seenMap)
        local rewardName = _ywl_normalize_title_reward_name(titleName)
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

    local function _ywl_is_title_reward_name(name)
        return type(name) == "string"
            and (string.find(name, "%[称号%]") ~= nil or string.match(name, "^称号%[.+%]$") ~= nil)
    end

    local function _ywl_trim_reward_display(rewardList)
        if type(rewardList) ~= "table" or #rewardList <= 0 then
            return {}
        end

        local titleRewards = {}
        local otherRewards = {}
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and _ywl_is_title_reward_name(entry[1]) then
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

    local function _ywl_collect_task_rewards(task)
        if type(task) ~= "table" then
            return {}
        end

        local rewardList = {}
        local seenMap = {}
        _ywl_append_reward_entries(rewardList, task.jl, seenMap)
        _ywl_append_reward_entries(rewardList, task.rwjl, seenMap)
        _ywl_append_reward_entries(rewardList, task.give, seenMap)
        _ywl_append_title_reward(rewardList, task.ch, seenMap)

        local handledNpcIds = {}
        local function appendNpcReward(npcId)
            npcId = tonumber(npcId)
            if not npcId or npcId <= 0 or handledNpcIds[npcId] then
                return
            end
            handledNpcIds[npcId] = true
            local cfg = teshudata and teshudata["npc_" .. tostring(npcId)]
            if type(cfg) == "table" then
                _ywl_append_reward_entries(rewardList, cfg.rwjl, seenMap)
                _ywl_append_reward_entries(rewardList, cfg.jl, seenMap)
                _ywl_append_reward_entries(rewardList, cfg.give, seenMap)
                _ywl_append_title_reward(rewardList, cfg.ch, seenMap)
            end
        end

        if type(task.tk) == "string" then
            appendNpcReward(task.tk:match("^npc_(%d+)$"))
        end
        if type(task.yd) == "table" then
            appendNpcReward(task.yd[3])
        end

        return _ywl_trim_reward_display(rewardList)
    end

    if p2 == 0 then
        npc.data = Data and SL:JsonDecode(Data, false) or {}
        npc._ywl_auto_guided_chapter = nil
        local function isChapterDone(i, j)
            return npc.data and npc.data.ywl and npc.data.ywl["jl_" .. i .. "_" .. j] == 1
        end
        local function findNearestUnfinished()
            for i = 2, #npc.xyl do
                local lCfg = npc.xyl[i]
                if type(lCfg) == "table" and #lCfg > 0 then
                    for j = 1, #lCfg do
                        if not isChapterDone(i, j) then
                            return i, j
                        end
                    end
                end
            end
            local li, zj = 2, 1
            for i = 2, #npc.xyl do
                local lCfg = npc.xyl[i]
                if type(lCfg) == "table" and #lCfg > 0 then
                    li = i
                    zj = #lCfg
                end
            end
            return li, zj
        end

        -- 有缓存进度就沿用；没有就自动定位到最近未完成章节
        if npc.l == nil or npc.zj == nil then
            npc.l, npc.zj = findNearestUnfinished()
        end
        local curCfg = npc.xyl[npc.l]
        if type(curCfg) ~= "table" or #curCfg == 0 then
            npc.l, npc.zj = findNearestUnfinished()
            curCfg = npc.xyl[npc.l]
        end
        if type(curCfg) == "table" and #curCfg > 0 then
            npc.zj = math.max(1, math.min(npc.zj, #curCfg))
        else
            npc.l, npc.zj = 2, 1
        end

        local win = ensureWindow("storyLog", 11, { titleText = "异闻录" })
        npc.bg = win.bg
        npc.node_11 = win.node

        -- local tipText = GUI:Text_Create(npc.bg, "lock_tip", 650,510, 20, "#EFAD21", "TIP:点击任务卡片可以查看具体的任务详情")
        -- GUI:Text_setFontName(tipText, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(tipText, "#000000", 2)
        -- GUI:setAnchorPoint(tipText, 0.5, 0.5)


        -- 左侧章节列表
        local chapterList = GUI:ListView_Create(npc.bg, "chapter_list", 25, 23, 230, 520 - 23, 1, false)
        GUI:ListView_setGravity(chapterList, 2)
        GUI:ListView_setItemsMargin(chapterList, 3)
        npc.ywl_list = chapterList

        -- 渲染右侧任务/奖励卡片
        local function renderTasks(node)
            GUI:removeAllChildren(node)

            local lCfg = npc.xyl[npc.l]
            if not lCfg then return end
            npc.zj = math.min(npc.zj, #lCfg)
            local zjCfg = lCfg[npc.zj]
            if not zjCfg then return end
            local tasks = zjCfg.jq or zjCfg
            local taskCount = #tasks
            local curJqd = tonumber(SL:GetMetaValue("TMONEY", "剧情点")) or 0
            local need = tonumber(zjCfg.jqd) or 0
            local lackJqd = zjCfg.jqd and curJqd < need
            local lockInfo = nil
            -- if npc.xyl and npc.xyl.get_chapter_lock_info then
            --     lockInfo = npc.xyl.get_chapter_lock_info(npc.l, npc.zj, curJqd)
            -- end
            local lockExtTips = {}
            if lockInfo then
                need = tonumber(lockInfo.need_jqd) or need
                lackJqd = lockInfo.lack_jqd and true or false
                lockExtTips = lockInfo.ext_tips or {}
            end
            local lockedByJqd = lockInfo and lockInfo.locked or lackJqd
            
            if lockedByJqd then
                GUI:Image_Create(node, "500-300", 250, 108, 'res/wy/public/500-300.png')
                GUI:Image_Create(node, "lock", 250, 100, 'res/wy/public/xz_img.png')
                GUI:setContentSize(GUI:ui_delegate(node)["lock"], 675, 414)
                GUI:setContentSize(GUI:ui_delegate(node)["500-300"], 675, 414)

                local tip = lockInfo and lockInfo.tip or nil
                if not tip or tip == "" then
                    tip = lackJqd and string.format("剧情点不足：%d/%d", curJqd, need) or "章节未解锁"
                end
                local tipText = GUI:Text_Create(node, "lock_tip", 588, 160, 24, "#FFFFFF", tip)
                GUI:Text_setFontName(tipText, "fonts/font4.ttf")
                GUI:Text_enableOutline(tipText, "#000000", 2)
                GUI:setAnchorPoint(tipText, 0.5, 0.5)
                for i, txt in ipairs(lockExtTips) do
                    local extTip = GUI:Text_Create(
                        node,
                        "lock_tip_ext_" .. i,
                        588,
                        128 - ((i - 1) * 30),
                        20,
                        "#FFE9A3",
                        txt
                    )
                    GUI:Text_setFontName(extTip, "fonts/500.ttf")
                    GUI:Text_enableOutline(extTip, "#000000", 2)
                    GUI:setAnchorPoint(extTip, 0.5, 0.5)
                end
            else
                
                local scroll = GUI:ScrollView_Create(node, "task_scroll", 250, 110, 675, 414, 2)
                GUI:ScrollView_setBounceEnabled(scroll, true)
                local taskCardWidth = 232
                local taskCardGapX = 0
                local taskCardStepX = taskCardWidth + taskCardGapX
                local layoutWidth = taskCount * taskCardStepX + taskCardStepX - 70
                GUI:ScrollView_setInnerContainerSize(scroll, layoutWidth, 414)
                local layout = GUI:Layout_Create(scroll, "task_layout", 0, 0, layoutWidth, 414, false)
                local autoGuideWidget = nil
                local autoGuideDesc = nil
                local taskSlots = {}
                local taskSlotState = {}

                -- 统一从独立状态表读取槽位状态，避免 ui_delegate 在不同调用点丢失字段。
                local function _slot_state(slot)
                    return taskSlotState[slot]
                end
                
                -- 手动重排任务卡片：不依赖 UserUILayout，支持展开时后续卡片位移动画。
                local function _relayout_task_cards(withAnim)
                    local x = 0
                    for _, slot in ipairs(taskSlots) do
                        local slotUi = _slot_state(slot)
                        local targetY = 0
                        if withAnim then
                            GUI:stopAllActions(slot)
                            GUI:runAction(slot, GUI:ActionMoveTo(0.12, x, targetY))
                        else
                            GUI:setPosition(slot, x, targetY)
                        end
                        local w = (slotUi and (slotUi.current_w or slotUi.base_w)) or taskCardWidth
                        x = x + w + taskCardGapX
                    end
                    local innerWidth = math.max(layoutWidth, x + taskCardGapX)
                    GUI:setContentSize(layout, innerWidth, 414)
                    -- GUI:ScrollView_setInnerContainerSize(scroll, innerWidth, 414)
                end


                local function _ywl_vertical_text(text)
                    if not text then
                        return ""
                    end
                    local s = tostring(text)
                    local out = {}
                    local i = 1
                    while i <= #s do
                        local c = string.byte(s, i)
                        local len = 1
                        if c >= 0xF0 then
                            len = 4
                        elseif c >= 0xE0 then
                            len = 3
                        elseif c >= 0xC0 then
                            len = 2
                        end
                        local ch = string.sub(s, i, i + len - 1)
                        if ch == "（" or ch == "(" then
                            local close = (ch == "（") and "）" or ")"
                            local j = i + len
                            while j <= #s do
                                local cb = string.byte(s, j)
                                local clen = 1
                                if cb >= 0xF0 then
                                    clen = 4
                                elseif cb >= 0xE0 then
                                    clen = 3
                                elseif cb >= 0xC0 then
                                    clen = 2
                                end
                                local cj = string.sub(s, j, j + clen - 1)
                                if cj == close then
                                    j = j + clen
                                    break
                                end
                                j = j + clen
                            end
                            i = j
                        else
                            table.insert(out, ch)
                            i = i + len
                        end
                    end
                    return table.concat(out, "\n")
                end

                local function _ywl_build_task_desc(task)
                    if npc.xyl and npc.xyl.build_task_desc then
                        local ok, built = pcall(npc.xyl.build_task_desc, task)
                        if ok and built and built ~= "" then
                            return built
                        end
                    end
                    return (type(task) == "table" and (task.desc or task.wz)) or "暂无任务简介"
                end

                local expandedSlot = nil

                -- 设置单个任务槽位的展开状态（宽度与层级）。
                local function _set_task_slot_open(slot, slotUi, isOpen)
                    local targetW = slotUi.base_w + (isOpen and slotUi.expand_w or 0)
                    slotUi.current_w = targetW
                    GUI:setContentSize(slot, targetW, slotUi.base_h)
                    GUI:setLocalZOrder(slot, isOpen and (10000 + slotUi.base_z) or slotUi.base_z)
                end

                -- 收起任务槽位；支持回调以串联“先收起旧项，再展开新项”。
                local function _collapse_task_slot(slot, onDone)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end
                    local cover = slotUi.cover
                    if not cover then
                        slotUi.cover_open = false
                        _set_task_slot_open(slot, slotUi, false)
                        _relayout_task_cards(true)
                        if expandedSlot == slot then
                            expandedSlot = nil
                        end
                        if onDone then
                            onDone()
                        end
                        return
                    end

                    slotUi.cover_anim = true
                    GUI:stopAllActions(cover)
                    GUI:runAction(cover, GUI:ActionSequence(
                            GUI:ActionMoveTo(0.12, slotUi.cover_start_x, slotUi.cover_y),
                            GUI:CallFunc(function()
                                GUI:setVisible(cover, false)
                                slotUi.cover_open = false
                                _set_task_slot_open(slot, slotUi, false)
                                _relayout_task_cards(true)
                                slotUi.cover_anim = false
                                if expandedSlot == slot then
                                    expandedSlot = nil
                                end
                                if onDone then
                                    onDone()
                                end
                            end)
                    ))
                end

                -- 展开任务槽位；展开前确保详情面板已创建。
                local function _expand_task_slot(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end
                    local cover = slotUi.ensure_cover and slotUi.ensure_cover() or slotUi.cover
                    if not cover then
                        return
                    end

                    slotUi.cover_anim = true
                    _set_task_slot_open(slot, slotUi, true)
                    _relayout_task_cards(true)
                    GUI:stopAllActions(cover)
                    GUI:setPosition(cover, slotUi.cover_start_x, slotUi.cover_y)
                    GUI:setVisible(cover, true)
                    GUI:runAction(cover, GUI:ActionSequence(
                            GUI:ActionMoveTo(0.12, slotUi.cover_end_x, slotUi.cover_y),
                            GUI:CallFunc(function()
                                slotUi.cover_open = true
                                slotUi.cover_anim = false
                                expandedSlot = slot
                            end)
                    ))
                end

                -- 默认展开首个任务卡片，避免首次进入时还需要额外点一次详情。
                local function _expand_task_slot_immediately(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi then
                        return
                    end
                    local cover = slotUi.ensure_cover and slotUi.ensure_cover() or slotUi.cover
                    if not cover then
                        return
                    end
                    _set_task_slot_open(slot, slotUi, true)
                    GUI:stopAllActions(cover)
                    GUI:setPosition(cover, slotUi.cover_end_x, slotUi.cover_y)
                    GUI:setVisible(cover, true)
                    slotUi.cover_open = true
                    slotUi.cover_anim = false
                    expandedSlot = slot
                end

                -- 任务槽位折叠/展开切换：同一时刻仅允许一个展开。
                local function _toggle_task_slot(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end

                    if expandedSlot and expandedSlot ~= slot then
                        local prevUi = _slot_state(expandedSlot)
                        if prevUi and prevUi.cover_anim then
                            return
                        end
                        local prevSlot = expandedSlot
                        _collapse_task_slot(prevSlot, function()
                            _expand_task_slot(slot)
                        end)
                        return
                    end

                    if slotUi.cover_open then
                        _collapse_task_slot(slot)
                    else
                        _expand_task_slot(slot)
                    end
                end

                for idx, task in ipairs(tasks) do
                    local taskName = task[1] or task.title or "任务"
                    local chapterDone = npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1
                    local taskDoneByReward = npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj .. "_" .. idx] == 1
                    local khdDone = (task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
                    local storyStarted = _ywl_is_task_started_or_done_by_story(taskName, task)
                    local taskProgressDone = chapterDone or taskDoneByReward or khdDone
                    local needReceive = task.need_receive == true
                    local rwjdSkin = "res/wy/public/rwjd_2.png"
                    if taskProgressDone then
                        rwjdSkin = "res/wy/public/rwjd_3.png"
                    elseif needReceive and not storyStarted then
                        rwjdSkin = "res/wy/public/rwjd_1.png"
                    end

                    local cardSlot = GUI:Layout_Create(layout, "card_slot" .. idx, 0, 0, taskCardWidth, 414, false)
                    GUI:setLocalZOrder(cardSlot, idx)
                    local slotUi = {
                        base_w = taskCardWidth,
                        base_h = 414,
                        base_z = idx,
                        expand_w = taskCardStepX,
                        current_w = taskCardWidth,
                        cover_open = false,
                        cover_anim = false,
                    }
                    taskSlotState[cardSlot] = slotUi
                    GUI:Layout_setClippingEnabled(cardSlot, false)
                    table.insert(taskSlots, cardSlot)
                    local card = GUI:Image_Create(cardSlot, "card" .. idx, 0, 0, 'res/custom/ywl/kuang.png')
                    local img = GUI:Image_Create(card, "img", 214/2, 410/2 - 20, 'res/custom/ywl/kuang1.png')
                    GUI:Image_Create(img, "rwjd", 25, 350, rwjdSkin)

                    GUI:setAnchorPoint(img, 0.5, 0.5)
                    -- 延迟创建详情面板，避免初始渲染过重。
                    local function ensure_cover()
                        if slotUi.cover then
                            return slotUi.cover
                        end
                        local taskTitle = task[1] or task.title or "任务"
                        local taskDesc = _ywl_build_task_desc(task)
                        local rewardData = _ywl_collect_task_rewards(task)
                        local size = GUI:getContentSize(img)
                        local imgPos = GUI:getPosition(img)
                        local coverWidth = size.width - 50
                        local coverHeight = size.height - 60
                        slotUi.cover_end_x = imgPos.x + size.width / 2 + coverWidth / 2
                        slotUi.cover_start_x = slotUi.cover_end_x + coverWidth / 2
                        slotUi.cover_y = imgPos.y + 25
                        local coverRightX = slotUi.cover_end_x + coverWidth / 2
                        local overflowRight = math.max(0, coverRightX - slotUi.base_w)
                        slotUi.expand_w = math.min(taskCardStepX, math.floor(overflowRight + 10))

                        local cover = GUI:Image_Create(cardSlot, "cover_" .. idx, slotUi.cover_start_x, slotUi.cover_y, "res/wy/public/500-300.png")
                        GUI:setContentSize(cover, coverWidth, coverHeight)
                        GUI:setAnchorPoint(cover, 0.5, 0.5)
                        GUI:setVisible(cover, false)
                        GUI:setLocalZOrder(cover, 99999)
                        GUI:setTouchEnabled(cover, true)
                        GUI:addOnClickEvent(cover, function()
                            _toggle_task_slot(cardSlot)
                        end)

                        local title = GUI:Text_Create(cover, "title_wz", 10, 310, 20, "#FF00FF", taskTitle)
                        GUI:Text_setFontName(title, "fonts/font4.ttf")
                        GUI:Text_enableOutline(title, "#000000", 2)
                        -- GUI:Text_Create(cover, "title", 10, 275, 18, "#FF00FF", taskTitle)

                        local jl = GUI:Text_Create(cover, "jl_wz", 10, 280, 20, "#10FF00", "完成奖励")
                        GUI:Text_enableUnderline(jl)
                        GUI:Text_setFontName(jl, "fonts/font4.ttf")
                        GUI:Text_enableOutline(jl, "#000000", 2)
                        local okReward, rewardNode = pcall(function()
                            return ItemNumByTable_img_new(rewardData, nil, jl)
                        end)
                        if okReward and rewardNode then
                            GUI:setPosition(rewardNode, 0, -60)
                        end

                        local desc = GUI:Text_Create(cover, "desc_wz", 10, 172, 20, "#FFFFFF", "任务简介")
                        GUI:Text_enableUnderline(desc)
                        GUI:Text_setFontName(desc, "fonts/font4.ttf")
                        GUI:Text_enableOutline(desc, "#000000", 2)
                        local okDesc, descNode = pcall(function()
                            return GUI:RichText_Create(desc, "desc", 0, -5, taskDesc, 160, 15, "#f7f7de", 3, nil, nil)

                        end)
                        if okDesc and descNode then
                            GUI:setAnchorPoint(descNode, 0, 1)
                        else
                            GUI:setAnchorPoint(GUI:Text_Create(desc, "desc_plain", 0, -5, 16, "#f7f7de", taskDesc), 0, 1)
                        end

                        slotUi.cover = cover
                        return cover
                    end
                    slotUi.ensure_cover = ensure_cover

                    GUI:setTouchEnabled(img, true)
                    GUI:addOnClickEvent(img, function()
                        _toggle_task_slot(cardSlot)
                    end)

                    -- 避免父节点吞掉点击事件，仅使用 img 作为折叠展开入口。
                    GUI:setTouchEnabled(card, false)

                    
                    
                    local title = GUI:Text_Create(GUI:Image_Create(img, "name_kuang", 150, 200, "res/custom/ywl/name_kuang.png"), "title",38, 190, 30, "#FFFFFF", _ywl_vertical_text(taskName))
                    GUI:setLocalZOrder(title, 100)
                    GUI:setAnchorPoint(title, 0.5, 1)
                    GUI:Text_setFontName(title, "fonts/font4.ttf")
                    GUI:Text_enableOutline(title, "#000000", 2)
                    -- GUI:setAnchorPoint(GUI:RichText_Create(card, "desc", 100, 180, "任务描述:" .. (task.desc or "可在任务界面查看"), 150, 16, "#00FFFF", 1, nil, nil, { outlineSize = 2, outlineColor = SL:ConvertColorFromHexString("#100808") }), 0.5, 1)

                    -- if task.jl then
                    --     local jlNode = ItemNumByTable_img(task.jl, nil, card)
                    --     GUI:setPosition(jlNode, 40, 55)
                    -- end

                    local enable = khdDone
                    -- enable = true
                    if taskDoneByReward or chapterDone then
                        GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232/2, 90, 'res/custom/ywl/ylq.png')
                        , 0.5, 0.5)
                    else
                        if lockedByJqd then
                            local lockText = GUI:Text_Create(img, "lock", 232/2, 90, 22, "#FF3B30", "未解锁")
                            GUI:setAnchorPoint(lockText, 0.5, 0.5)
                        else
                            local btnSkin = enable and 'res/custom/ywl/btn_1.png' or 'res/custom/ywl/btn_2.png'
                            local goBtn = GUI:Button_Create(img, "goBtn", 55, 90, btnSkin)
                            GUI:setScale(goBtn, 0.8)
                            GUI:setAnchorPoint(goBtn, 0, 0.5)
                            GUI:addOnClickEvent(goBtn, function()
                                SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
                                    string.format('{"i":%d,"j":%d,"k":0,"z":%d}', npc.l, npc.zj, idx))
                                if enable then
                                    GUI:removeFromParent(goBtn)
                                    GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232/2, 90, 'res/custom/ywl/ylq.png')
                                    , 0.5, 0.5)
                                end
                            end)
                            if AUTO_GUIDE_TASKS[taskName] and not autoGuideWidget then
                                if not chapterDone and not taskDoneByReward and not khdDone and not storyStarted then
                                    autoGuideWidget = goBtn
                                    autoGuideDesc = "点击前往" .. taskName
                                end
                            end
                        end
                    end
                    
                end
                if #taskSlots > 0 then
                    _expand_task_slot_immediately(taskSlots[1])
                end
                _relayout_task_cards(false)
                GUI:Image_Create(node, "wz1", 340, 100, 'res/custom/ywl/wz.png')

                if zjCfg.jl then
                    GUI:setPosition(ItemNumByTable_img(zjCfg.jl, nil, node), 560, 40)
                end

                if npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1 then
                    GUI:Image_Create(node, "done", 750, 40, 'res/wy/public/rwjd_3.png')
                else
                    npc.jl = GUI:Button_Create(node, "btn_reward", 710, 0, 'res/custom/ywl/btn_3.png')
                    GUI:addOnClickEvent(npc.jl, function()
                        SL:SendLuaNetMsg(101, 11, 2, 0, string.format('{"i":%d,"j":%d,"k":0}', npc.l, npc.zj))
                    end)
                    if not autoGuideWidget and _ywl_is_chapter_reward_ready(npc.l, npc.zj) then
                        autoGuideWidget = npc.jl
                        autoGuideDesc = "点击领取章节奖励"
                    end
                end

                local chapterKey = tostring(npc.l) .. "_" .. tostring(npc.zj)
                if npc._ywl_auto_guided_chapter ~= chapterKey then
                    npc._ywl_auto_guided_chapter = chapterKey
                    if autoGuideWidget then
                        local guideParent = GUI:getParent(autoGuideWidget) or node
                        NPC_UI_HELPER.startGuide({
                            dir = 3,
                            guideWidget = autoGuideWidget,
                            guideParent = guideParent,
                            guideDesc = "建议优先领取",
                            isForce = false,
                            hideMask = true
                        })
                    end
                end
                _ywl_try_start_chapter_reward_guide(node, false)
            end

            
            local TMONEY = GUI:Text_Create(node, "TMONEY",50 + 278,40 + 9, 25, "#FF0000", SL:GetMetaValue("TMONEY", "剧情点"))
            SL:release_print("当前剧情点", SL:GetMetaValue("TMONEY", "剧情点"))
            GUI:Text_setFontName(TMONEY, "fonts/font4.ttf")
            GUI:setAnchorPoint(TMONEY, 0.5, 0.5)

        end

        -- 渲染章节列表
        local function renderChapterList()
            GUI:removeAllChildren(chapterList)
            for i = 2, #npc.xyl do
                local btn = GUI:Button_Create(chapterList, "chap_" .. i, 0, 0, 'res/custom/ywl/list/dl_' .. i .. '.png')
                GUI:addOnClickEvent(btn, function()
                    if i == 3 then
                        if not _ywl_has_third_continent_half_entry() then
                            SL:ShowSystemTips("<font color='#FF0000'>灾厄还未消退，不能展开三大陆剧情任务</font>")
                            SL:SendLuaNetMsg(100, 503, 1, 0, "")
                            return
                        end
                    elseif dl_sz and not dl_sz(i) then
                        SL:ShowSystemTips("<font color='#FF0000'>还未解锁该大章节</font>")
                        return
                    end
                    npc.l = i
                    npc.zj = 1
                    renderChapterList()
                    renderTasks(npc.node_11)
                end)
                if i == npc.l then
                    for y = 1, #npc.xyl[npc.l] do
                        local x_chap = GUI:Layout_Create(chapterList, "x_chap_" .. y, 0, 0, 84, 40, false)
                        
                        local x_btn = GUI:Button_Create(x_chap, "x_chap", 84/2, 40/2, 'res/custom/ywl/list/xz.png')
                        GUI:setAnchorPoint(x_btn, 0.5, 0.5)
                        local zj_name = GUI:Text_Create(x_chap, "wz", 84/2, 40/2, 23, "#FFFFFF", npc.xyl[npc.l][y].name)
                        GUI:Text_setFontName(zj_name, "fonts/font4.ttf")
                        GUI:Text_enableOutline(zj_name, "#000000", 2)
                        GUI:setAnchorPoint(zj_name, 0.5, 0.5)
                        GUI:addOnClickEvent(x_btn, function()
                            if npc.l == 3 and not _ywl_is_third_continent_half_chapter(npc.xyl[npc.l][y].name) then
                                if not _ywl_has_third_continent_full_entry() then
                                    SL:ShowSystemTips("<font color='#FF0000'>需要完成灾厄入侵后才能进入该章节</font>")
                                    return
                                end
                            end
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FFFFFF")
                            npc.zj = y
                            -- renderChapterList()
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                            
                            -- GUI:setAnchorPoint(GUI:Image_Create(x_btn, "xz", 84/2, 20/2, 'res/custom/ywl/list/xz.png')
                            -- , 0.5, 0.5)
                            -- GUI:Image_Create(x_btn, "xz_wz", 0, 0, 'res/custom/ywl/list/x_1_' .. y .. '.png')
                            renderTasks(npc.node_11)
                        end)
                        if y == npc.zj then
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                            -- GUI:setAnchorPoint(GUI:Image_Create(x_btn, "xz", 84/2, 20/2, 'res/custom/ywl/list/xz.png')
                            -- , 0.5, 0.5)
                            -- GUI:Image_Create(x_btn, "xz_wz", 0, 0, 'res/custom/ywl/list/x_1_' .. y .. '.png')
                        end

                    end
                end
            end
        end

        renderChapterList()
        renderTasks(npc.node_11)

        SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
            if self == "npc_ywl" then
                SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            end
        end)

    elseif p2 == 2 then
        local data = SL:JsonDecode(Data, false) or {}
        if p3 == 1 then
        elseif p3 == 2 then
            npc.data = npc.data or {}
            npc.data.ywl = npc.data.ywl or {}
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j] = 1

            local nextL, nextZj = _ywl_find_next_chapter(data.i, data.j)
            if nextL and nextZj then
                npc.l, npc.zj = nextL, nextZj
            else
                npc.l = tonumber(data.i) or npc.l
                npc.zj = tonumber(data.j) or npc.zj
            end

            npc[11](0, 0, SL:JsonEncode(npc.data, false))
            return
        elseif p3 == 3 then
            -- 备注：服务端可能直接下发单任务领奖完成，这里先兜底初始化，避免 npc.data 为空时报错。
            npc.data = npc.data or {}
            npc.data.ywl = npc.data.ywl or {}
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j .. "_" .. data.z] = 1
            npc.l = tonumber(data.i) or npc.l
            npc.zj = tonumber(data.j) or npc.zj
            -- if _ywl_is_valid_gui_node(npc.node_11) then
            --     npc[11](0, 0, SL:JsonEncode(npc.data, false))
            --     SL:ScheduleOnce(function()
            --         _ywl_try_start_chapter_reward_guide(npc.node_11, true)
            --     end, 0.05)
            --     return
            -- end
            -- SL:ScheduleOnce(function()
            --     _ywl_try_start_chapter_reward_guide(npc.node_11, true)
            -- end, 0.05)
        end
        -- if npc.data and npc.data.ywl then
        --     npc.data.ywl["jl_" .. p3] = 1
        -- end
        -- if npc.jl then
        --     GUI:Image_Create(GUI:getParent(npc.jl), 'wc', 515, 5, 'res/wy/public/7_1.png')
        --     GUI:removeFromParent(npc.jl)
        -- end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        npc[11](0, 0, Data)
    elseif p2 == 9 then
        local currentTask = SL:JsonDecode(Data, false) or {}
        npc.current_ywl_task = currentTask
        -- 缓存当前异闻录任务名，给独立界面决定默认页签使用。
        rawset(_G, "XYL_CURRENT_TASK_NAME", _ywl_get_task_name_from_current_task(currentTask))
        SL:onLUAEvent(LUA_EVENT_YWL_CURRENT_TASK_CHANGE, currentTask)
    end
end
---活动提示
npc[12] = function(p2, p3, Data) -- 活动提示
    if p2 == 1 then
        npc.hd_data = SL:JsonDecode(Data, false)
        if npc.hdan then
            GUI:removeFromParent(npc.hdan)
            npc.hdan = nil
        end
        if cogin.isWin32 then
            npc.hdan = GUI:Button_Create(npc.RightTop, "hdan", -367, -300, "res/custom/activity/"..p3..".png")
            GUI:addOnClickEvent(npc.hdan, function()
                SL:SendLuaNetMsg(101, 507, 1, p3, "")
            end)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 32 + 130, 19, 16, "#F7F7DE", npc.hd_data.sk*60)
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:Text_COUNTDOWN(npc.djs, npc.hd_data.sk*60,function()
                if npc.hdan then
                    GUI:removeFromParent(npc.hdan)
                    local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                    npc.hdan = nil
                end
            end)
        else
            npc.hdan = GUI:Button_Create(npc.RightTop, "hdan", -390 - 125 + 226 - 55 - 160, -240  - 61 -31 + 50, "res/custom/activity/"..p3..".png")
            GUI:addOnClickEvent(npc.hdan, function()
                SL:SendLuaNetMsg(101, 507, npc.hd_data.kf, npc.hd_data.idx, "")
            end)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 32 + 130, 19, 16, "#F7F7DE", npc.hd_data.sk*60)
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:Text_COUNTDOWN(npc.djs, npc.hd_data.sk*60,function()
                if npc.hdan then
                    GUI:removeFromParent(npc.hdan)
                    local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                    npc.hdan = nil
                end
            end)
        end
        if p3 == 5 then
                local txt = GUI:Text_Create(npc.hdan, "Text", 10 + 60, -22, 14, "#ffffff","勾选自动跑酷")
                GUI:Text_enableOutline(txt, "#000000", 1)
                local CheckBox = GUI:CheckBox_Create(npc.hdan, "CheckBox", -20 + 60, -22, "res/public/1900000550.png", "res/public/1900000551.png")
                GUI:CheckBox_addOnEvent(CheckBox, function(self)
                    if GUI:CheckBox_isSelected(self) then
                        if SL:GetMetaValue("MAP_ID") == "xtc" then
                            SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                            SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束", function()
                                if not npc.hdan then
                                    SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                                end
                                SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                            end, txt)
                        else
                            GUI:CheckBox_setSelected(self, false)
                            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#ff0500'>只能在土城才能使用</font></outline>")
                        end
                    else
                        SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                        SL:SetMetaValue("BATTLE_MOVE_END")
                    end
                end)
            end
    elseif p2 == 4 then
        if npc.hdan then
            GUI:removeFromParent(npc.hdan)
            npc.hdan = nil
            local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
            if parent then
                GUI:Win_Close(parent)
            end
        end
    end
end
---记忆传送：记录石（使用 UIHelper 标准窗口）
npc[13] = function(p2, p3, msgData)
    if p2 == 0 then
        SL:SendLuaNetMsg(101, 13, 0, 0, "")
        return
    end

    local function renderRecordStone(records)
        local win = ensureWindow("recordStone", 13, { titleText = "记录石" })
        local node = win.node
        GUI:removeAllChildren(node)

        npc.recordStoneLabels = {}
        local scroll = GUI:ScrollView_Create(node, "scroll", 6, 57, 458, 341, 1)
        GUI:ScrollView_setInnerContainerSize(scroll, 458, 495)
        local content = GUI:Image_Create(scroll, "content", 0, 0.5, "res/wy/public/jys_wz.png")

        for i = 1, 10 do
            local slot = records and records["dtm" .. i]
            local text = slot and (slot[2] .. "(" .. slot[3] .. "," .. slot[4] .. ")") or "暂未记录"
            npc.recordStoneLabels[i] = GUI:Text_Create(content, "pos_" .. i, 164, 524 - i * 50, 16, "#ffffff", text)
            GUI:setAnchorPoint(npc.recordStoneLabels[i], 0.5, 0.5)
            GUI:Text_enableOutline(npc.recordStoneLabels[i], "#000000", 1)

            local idxLabel = GUI:Text_Create(content, "idx_" .. i, 40, 524 - i * 50, 16, "#ffffff", i)
            GUI:setAnchorPoint(idxLabel, 0.5, 0.5)
            GUI:Text_enableOutline(idxLabel, "#000000", 1)

            local saveBtn = GUI:Button_Create(content, "btn_save_" .. i, 271, 504 - i * 50, "res/wy/public/jys_jl.png")
            GUI:addOnClickEvent(saveBtn, function()
                SL:OpenCommonTipsPop({
                    str = "是否记录该地图点位？将覆盖原有记录。",
                    btnType = 2,
                    callback = function(atype)
                        if atype == 1 then
                            SL:SendLuaNetMsg(101, 13, 1, i, "")
                        end
                    end
                })
            end)

            local gotoBtn = GUI:Button_Create(content, "btn_goto_" .. i, 369, 504 - i * 50, "res/wy/public/jys_cs.png")
            GUI:addOnClickEvent(gotoBtn, function()
                if records and records["dtm" .. i] then
                    SL:SendLuaNetMsg(101, 13, 2, i, "")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未记录该位置，无法传送！</font>")
                end
            end)
        end
    end

    if p2 == 1 then
        npc.jls = SL:JsonDecode(msgData, false)
        renderRecordStone(npc.jls)
    elseif p2 == 2 then
        if p3 and p3 > 0 and p3 <= 10 then
            npc.jls = SL:JsonDecode(msgData, false)
            if npc.recordStoneLabels and npc.jls["dtm" .. p3] then
                GUI:Text_setString(
                    npc.recordStoneLabels[p3],
                    npc.jls["dtm" .. p3][2] .. "(" .. npc.jls["dtm" .. p3][3] .. "," .. npc.jls["dtm" .. p3][4] .. ")"
                )
            end
        end
    elseif p2 == 3 then
        GUI:Win_CloseByID("npc_jilushi")
    end
end
---实力提升
npc[17] = function(p2, p3, Data)  --实力提升

end
---新手礼包
npc[18] = function(p2, p3, Data)
    local function renderNewbieGift(node)
        GUI:removeAllChildren(node)

        local Layout1 = GUI:Layout_Create(node, "Layout1", 429, 186, 100, 60.00, false)
        for i = 1,4 do
            GUI:setContentSize(GUI:Image_Create(Layout1, "skill"..i, 0.00, 0.00, "res/custom/xinshoulibao/skill_"..i..".png")
            , 42, 42)

        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=1,gap = {x=23}})

        local jl_itme = {{"复活戒指",1},{"麻痹戒指",1},{"斗笠",1},{"攻速之镰[lv1]",1}, {"切割之斧[lv1]",1}}
        Layout1 = GUI:Layout_Create(node, "Layout2", 400, 100, 100, 60.00, false)
        for i = 1,5 do
            GUI:ItemShow_Create(Layout1, "itme"..i, 0, 0, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME", jl_itme[i][1]),look=true})
        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=1,gap = {x = 23 + 10}})



        -- 主按钮：申请领取新手礼包
        
        local btn = GUI:Button_Create(node, "btn_get_gift", 420, 0, "res/custom/xinshoulibao/btn.png")
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(101, 18, 1, 0, "")
        end)
        -- 主线任务 1：引导点击新手礼包领取按钮（仅触发一次）。
        NPC_UI_HELPER.startGuide({
            dir = 5,
            guideWidget = btn,
            guideParent = node,
            guideDesc = "点击领取",
            isForce = false,
            hideMask = true
        })
    end

    if p2 == 0 then
        npc.data_18 = Data and SL:JsonDecode(Data, false) or {}
        local win = ensureWindow("newbieGift", 18, { titleText = "新手礼包" })
        renderNewbieGift(win.node)
    end
end
---护体光环
npc[23] = function(p2, p3, Data)  --护体光环
    local cardPosX = {100, 360, 620}
    local UI_updata

    local function setCommonText(textObj, outlineColor)
        GUI:Text_setFontName(textObj, "fonts/502.ttf")
        GUI:Text_enableOutline(textObj, outlineColor or "#081800", 1)
        GUI:setAnchorPoint(textObj, 0.5, 0.5)
    end

    local function renderCard(node, state)
        local idx = state.idx
        local card = GUI:Image_Create(node, "huti_card_" .. idx, cardPosX[idx], 34, "res/custom/htgh/item_" .. idx .. ".png")
        GUI:setAnchorPoint(card, 0, 0)
        
        GUI:setScale(GUI:Effect_Create(card, "effect", 115, 320, 0, 11501 + idx, 0, 0, 0, 1), 1)
        GUI:Effect_Create(card, "rw1", 115, 320, 4, SL:GetMetaValue("EQUIP_DATA", 0) and SL:GetMetaValue("EQUIP_DATA", 0).Shape or 1300, 0, 0, 2, 0.8)

        -- local effectTitle = GUI:Text_Create(card, "effect_title_" .. idx, 133, 176, 24, "#FFE07D", "光环效果")
        -- setCommonText(effectTitle)
        -- local effectText = GUI:Text_Create(card, "effect_text_" .. idx, 133, 140, 23, "#F2F2F2", state.effect)
        -- setCommonText(effectText)

        -- local needTitle = GUI:Text_Create(card, "need_title_" .. idx, 133, 102, 24, "#FFE07D", "激活条件")
        -- setCommonText(needTitle)
        -- local needText = GUI:Text_Create(card, "need_text_" .. idx, 133, 66, 23, "#F2F2F2", state.need)
        -- setCommonText(needText)

        if state.canActivate then
            local activeText = GUI:Text_Create(card, "active_text_" .. idx, 78 + 60, 110, 26, "#7CFF7C", "已激活")
            GUI:setAnchorPoint(activeText, 0.5, 0.5)

            setCommonText(activeText, "#003300")
        else
            local btn = GUI:Image_Create(card, "activate_btn_" .. idx, 78 + 60, 110, "res/custom/htgh/btn_activate.png")
            GUI:setAnchorPoint(btn, 0.5, 0.5)

            GUI:setTouchEnabled(btn, true)
            GUI:addOnClickEvent(btn, function()
                if not state.canActivate then
                    SL:ShowSystemTips(state.lockedTip or "当前条件未满足")
                    return
                end
                SL:SendLuaNetMsg(101, 23, 1, idx, "")
            end)
        end

        -- 服务端现在用 active 同时控制效果和外显，这里开关直接映射为启用/关闭当前光环。
        local switchSkin = state.visible and "res/custom/htgh/open.png" or "res/custom/htgh/close.png"
        local switchBtn = GUI:Image_Create(card, "switch_btn_" .. idx, 204, 40, switchSkin)
        GUI:setAnchorPoint(switchBtn, 0.5, 0.5)
        GUI:setTouchEnabled(switchBtn, state.canActivate)
        if state.canActivate then
            GUI:addOnClickEvent(switchBtn, function()
                local nextIdx = state.active and 0 or idx
                SL:SendLuaNetMsg(101, 23, 1, nextIdx, "")
            end)
        else
            GUI:setGrey(switchBtn, true)
        end
    end

    UI_updata = function(node) --界面渲染
        GUI:removeAllChildren(node)
        local states = _huti_get_card_states()
        for idx = 1, 3 do
            renderCard(node, states[idx])
        end
    end

    if p2 == 0 then
        npc.data_23 = not Data and {} or SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        local win = ensureWindow("bodyAura", 23, {titleText = "护体光环"})
        npc.bg = win.bg
        npc.node = win.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_23 = not Data and {} or SL:JsonDecode(Data, false)
        if npc.node and not tolua.isnull(npc.node) then
            UI_updata(npc.node)
        end
        rebuildShortcutButtons("")
    end
end
---神石
npc[20] = function(p2, p3, Data)  --神石

   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)
        local dbLayout = GUI:Layout_Create(node, "dbLayout", 23, 13, 300, 150)
        for i = 1, 8 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow"..i, 0,0, 102 + i, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow"..i, 0,0, {itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 102 + i),look=true})
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=11, y=5}})
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 40, 0)
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=42, y=42}})
        end

    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>神石数据异常，请稍后再试...</font>")
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_shenshi.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -300, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)

    end
end

---古玩
npc[21] = function(p2, p3, Data)  --古玩

   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 33, 13, 300, 150)
        for i = 1, 6 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow"..i, 0,0, 110 + i, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow"..i, 0,0, {itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 110 + i),look=true})
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=19, y=5}})
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 50, 0)
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=50, y=42}})
        end


    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>古玩数据异常，请稍后再试...</font>")
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_guwan.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -270, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)

    end
end

---法宝
npc[22] = function(p2, p3, Data)  --法宝
-- 时光之杖[未激活]
-- 首切法宝[未激活]
-- 秘宝·万鬼啸【鬼】[未激活]
-- 秘宝·破龙吟【兵】[未激活]
-- 酒仙剑[未激活]


   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)

        local metaKey = idx == 1 and "L.M.EQUIP_DATA" or "EQUIP_DATA"
        local items = {
            {id = 71, x = 138, y = 131, name = "时光之杖[未激活]"},
            {id = 72, x = 246, y = 94, name = "首切法宝[未激活]"},
            {id = 73, x = 65, y = 60, name = "秘宝·万鬼啸【鬼】[未激活]"},
            {id = 74, x = 65, y = 131, name = "秘宝·破龙吟【兵】[未激活]"},
            {id = 75, x = 138, y = 60, name = "酒仙剑[未激活]"},
        }

        for _, cfg in ipairs(items) do
            local item = SL:GetMetaValue(metaKey, cfg.id)
            if item then
                local EquipShow = GUI:EquipShow_Create(node, "EquipShow"..cfg.id, cfg.x, cfg.y, cfg.id, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            else
                local EquipShow = GUI:ItemShow_Create(node, "EquipShow"..cfg.id, cfg.x, cfg.y, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", cfg.name), look = true})
                GUI:ItemShow_setIconGrey(EquipShow, true)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            end
        end
    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerEquip.gzd
        elseif p3 == 1 then
            logg = PlayerEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>法宝数据异常，请稍后再试...</font>") 
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_fabao.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -340, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node,p3)

    end
end

---砍树系统
npc[30] = function(p2, p3, Data)
    local function btn_updata_1_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/updata_1/bg.png"},
            closeButton = {x = 650, y = 320},
        })
        npc.xjm_node = npc.xjm_window.node

        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 210, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_"..npc.data_30.T_data.axe..".png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_1", 210, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_"..npc.data_30.T_data.axe..".png"), 0.5, 0.5)

        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[1].details[npc.data_30.T_data.axe].cost[1][2])
        , "fonts/501.ttf")
        if npc.data_30.T_data.axe >= config.updata[1].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_2", 488, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_"..(npc.data_30.T_data.axe + 1)..".png"), 0.5, 0.5)
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_2", 488, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_"..(npc.data_30.T_data.axe + 1)..".png"), 0.5, 0.5)

            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_1/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 1, 1, '')  end)
        end

        

    end
    local function btn_updata_2_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/updata_2/bg.png"},
            closeButton = {x = 650, y = 320},
        })
        npc.xjm_node = npc.xjm_window.node

        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 420, 350, "res/custom/three_city/xianfu/kanshu/updata_2/level_"..npc.data_30.T_data.auto..".png"), 0.5, 0.5)
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[2].details[npc.data_30.T_data.auto].cost[1][2])
        , "fonts/501.ttf")

        if npc.data_30.T_data.auto >= config.updata[2].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_2/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 1, 2, '')  end)
        end

        

    end
    local function btn_buy_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/buy/bg.png"},
            closeButton = {x = 600, y = 260},
        })
        npc.xjm_node = npc.xjm_window.node
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 422, 100, 30, "#FFFFFF", (npc.data_30.T_data.dh_num + 1) > #config.dh.details and config.dh.cost[1][2] or config.dh.details[npc.data_30.T_data.dh_num + 1].cost[1][2])
        , "fonts/501.ttf")
        GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item1", 250,196, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙府币"),count = 1,look= true}), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item2", 490,196, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME","砍树盲盒"),count = 1,look= true}), 0.5, 0.5)

        local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/buy/btn.png")
        GUI:setAnchorPoint(btn, 0.5, 0)
        GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 4, 0, '')  end)

    end
    if p2 == 0 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        local config = teshudata["anniu_30"]
        local parent = GUI:GetWindow(nil, "anniu_30")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("anniu_30", 0, 0, 0, 0, false, false, true, true, true, nil, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/xianfu/kanshu/bg_1/eff_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w, cogin.h)
        GUI:setTouchEnabled(bjt, true)
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

        local bg = GUI:Frames_Create(bjt, "bg", cogin.w/2,  cogin.h/2, "res/custom/three_city/xianfu/kanshu/bg_"..npc.data_30.T_data.axe.."/eff_", ".png", 1, 75,
                { speed = 75, count = 75, loop = -1})
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)

        

        local heidi = GUI:Image_Create(bg, "heidi", 0, cogin.h, "res/custom/three_city/xianfu/kanshu/heidi.png")
        GUI:setAnchorPoint(heidi, 0, 1)
        GUI:setContentSize(heidi, cogin.w, GUI:getContentSize(heidi).height)
        local tip_wz = GUI:Image_Create(heidi, "tip_wz", cogin.w / 2, 30, "res/custom/three_city/xianfu/kanshu/tip_wz.png")
        GUI:setAnchorPoint(tip_wz, 0.5, 0.5)
        local lz_wz = GUI:Image_Create(bg, "lz_wz", 0, cogin.h - 200, "res/custom/three_city/xianfu/kanshu/lz_wz.png")
        GUI:setAnchorPoint(lz_wz, 0, 1)

        local re_wz = GUI:Image_Create(bg, "re_wz", cogin.w, 0, "res/custom/three_city/xianfu/kanshu/re_wz.png")
        GUI:setAnchorPoint(re_wz, 1, 0)

        -- local btn_knashu = GUI:Frames_Create(bg, "eff1", 400,  450, "res/custom/three_city/xianfu/kanshu/btn/eff_", ".png", 1, 75,
        --         { speed = 75, count = 75, loop = -1})
        -- GUI:setAnchorPoint(btn_knashu, 0.5, 0.5)
        -- GUI:setTouchEnabled(btn_knashu, true)
        -- GUI:addOnClickEvent(btn_knashu, function()
        --     SL:SendLuaNetMsg(101, 30, 2, 2, '')
        -- end)

        npc.node = GUI:Node_Create(bg, "node", 0, 0)

        -- SL:dump((config.updata[1].details[npc.data_30.T_data.axe].ratio * config.updata[2].details[npc.data_30.T_data.auto].ratio * config.base_time))

        SL:schedule(npc.node, function() SL:SendLuaNetMsg(101, 30, 2, 1, '') end, (config.updata[1].details[npc.data_30.T_data.axe].ratio * config.updata[2].details[math.max(npc.data_30.T_data.auto,1)].ratio * config.base_time))
        npc.wz1 = GUI:Text_Create(re_wz, "wz1", 133, 483, 20, "#FFFFFF", npc.data_30.T_data.num)
        npc.wz2 = GUI:Text_Create(re_wz, "wz2", 133, 449, 20, "#FFFFFF", npc.data_30.T_data.dh_num)

        local btn_updata_2 = GUI:Button_Create(re_wz, "btn_updata_2", 278 / 2, 300 - 210, "res/custom/three_city/xianfu/kanshu/btn_updata_2.png")
        local btn_buy = GUI:Button_Create(re_wz, "btn_buy", 278 / 2, 300 - 70, "res/custom/three_city/xianfu/kanshu/btn_buy.png")
        local btn_tip = GUI:Button_Create(re_wz, "btn_tip", 278 / 2, 300, "res/custom/three_city/xianfu/kanshu/btn_tip.png")
        local btn_updata_1 = GUI:Button_Create(re_wz, "btn_updata_", 278 / 2, 300 - 140, "res/custom/three_city/xianfu/kanshu/btn_updata_1.png")
        GUI:setAnchorPoint(btn_updata_2, 0.5, 0.5)
        GUI:setAnchorPoint(btn_buy, 0.5, 0.5)
        GUI:setAnchorPoint(btn_tip, 0.5, 0.5)
        GUI:setAnchorPoint(btn_updata_1, 0.5, 0.5)

        GUI:addOnClickEvent(btn_updata_2, function()  btn_updata_2_xjm()  end)
        GUI:addOnClickEvent(btn_buy, function()  
            btn_buy_xjm()
        end)
        GUI:addOnClickEvent(btn_tip, function()  
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
                windowName = "npc_anniu_30_xjm",
                background = {skin = "res/custom/three_city/xianfu/kanshu/tip/bg.png"},
                closeButton = {x = 200, y = 10, skin = "res/custom/three_city/xianfu/kanshu/tip/btn.png"},
            })
        end)
        GUI:addOnClickEvent(btn_updata_1, function()  btn_updata_1_xjm()  end)

        if npc.data_30.T_data.auto == 0 then
            local open_auto = GUI:Button_Create(re_wz, "open_auto", 278 / 2, 300 - 210, "res/custom/three_city/xianfu/kanshu/btn_auto.png")
            GUI:setAnchorPoint(open_auto, 0.5, 0.5)
            NPC_UI_HELPER.redpoint_create(open_auto)
            GUI:addOnClickEvent(open_auto, function()  SL:SendLuaNetMsg(101, 30, 3, 1, '')  end)
            GUI:setVisible(btn_updata_2, false)
            NPC_UI_HELPER.tryStartXylGuide(npc, open_auto, re_wz, "woodcut_start", {
                taskName = "了解砍树",
                dir = 5,
                desc = "开启自动砍树",
            })
        end

        local closeBtn = GUI:Button_Create(bg, 'close', cogin.w - 100,  cogin.h - 70, 'res/wy/public/anniu_4_x_close.png')
        GUI:addOnClickEvent(closeBtn, function()
            GUI:Win_Close(parent)
        end)

       
       
       

        
    elseif p2 == 1 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        GUI:Text_setString(npc.wz1, npc.data_30.T_data.num)
        GUI:Text_setString(npc.wz2, npc.data_30.T_data.dh_num)
    elseif p2 == 2 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        if p3 == 1 then
            btn_updata_1_xjm()
        elseif p3 == 2 then
            btn_updata_2_xjm()
        end
    
    elseif p2 == 3 then
        npc.json = SL:JsonDecode(Data,false) or {}
        for i= 1, #npc.json do
            local btn = GUI:ItemShow_Create(npc.node, "item"..os.clock(), math.random(300, 400),math.random(300, 400), {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc.json[i][1]),count = 1,look= true})
            local endPos = GUI:p(math.random(100, 500),math.random(100, 50))
            local controlPoint_1 = GUI:p(300, 600)
            local controlPoint_2 = GUI:p(300, 600)
            local endPosition = endPos
            local bezier = GUI:ActionBezierTo(0.5, controlPoint_1, controlPoint_2, endPosition)
            GUI:runAction(btn,  GUI:ActionSequence(bezier,GUI:DelayTime(10),GUI:CallFunc(function()GUI:removeFromParent(btn)  end)))
            GUI:Timeline_DelayTime(btn, 100, function()
                GUI:removeFromParent(btn)
            end)
        end
    elseif p2 == 4 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        btn_buy_xjm()
    
    end
end



---天人之战面板
---天人之战
npc[498] = function(p2, p3, Data)
    -- 创建天人之战排行榜面板，并完成基本 UI 布局
    local function hasRankingWindow()
        return npc.tyec and GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
    end

    local function createRankingWindow()
        if hasRankingWindow() then
            return
        end
        npc.tyec = GUI:Image_Create(MainAssist._ui["Panel_hide"], "tyec_bj", 18, 0.00, "res/wy/public/tycccc.png")
        GUI:setContentSize(npc.tyec, 260, 185)
        local height = GUI:getContentSize(npc.tyec).height
        GUI:setPositionY(npc.tyec, height)
        GUI:runAction(npc.tyec, GUI:ActionMoveBy(0.3, 0, -height))
        local desc = GUI:Text_Create(npc.tyec, "Text", 70.00, 164.00, 14, "#d6a573", "排名数据/10s刷新")
        GUI:Text_enableOutline(desc, "#000000", 1)
        local scoreLabel = GUI:Text_Create(npc.tyec, "Text_1", 72.00, 6.00, 14, "#d6a573", "当前个人积分:")
        GUI:Text_enableOutline(scoreLabel, "#000000", 1)
        npc.tyecgr = GUI:Text_Create(scoreLabel, "Textxx", 92.00, 0.00, 14, "#d6a573", "0")
        GUI:Text_enableOutline(npc.tyecgr, "#000000", 1)
        local list = GUI:ListView_Create(npc.tyec, "ListView", 0.00, 29.00, 261.00, 135.00, 1)
        GUI:ListView_setItemsMargin(list, 2)
        npc.tyecpmm = {}
        npc.tyecpmf = {}
        for i = 1, 5 do
            local row = GUI:Image_Create(list, "rank_row_" .. i, 0, 0, "res/wy/public/guang.png")
            GUI:setContentSize(row, 260, 25)
            local prefix = GUI:Text_Create(row, "rank_prefix", 10.00, 3.00, 14, "#d6a573", string.format("NO.%d    ", i))
            GUI:Text_enableOutline(prefix, "#000000", 1)
            npc.tyecpmm[i] = GUI:Text_Create(row, "player_" .. i, 55.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmm[i], "#000000", 1)
            npc.tyecpmf[i] = GUI:Text_Create(row, "score_" .. i, 200.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmf[i], "#000000", 1)
        end
    end

    local function updateRankingWidgets(data)
        local mc = 1
        for i = 1, 5 do
            if data.pmsj and data.pmsj[i * 2] and data.pmsj[i * 2] > 0 then
                GUI:Text_setString(npc.tyecpmm[i], data.pmsj[mc])
                GUI:Text_setString(npc.tyecpmf[i], data.pmsj[i * 2])
                mc = mc + 2
            else
                GUI:Text_setString(npc.tyecpmm[i], "")
                GUI:Text_setString(npc.tyecpmf[i], "")
            end
        end
        GUI:Text_setString(npc.tyecgr, data.grjf or 0)
    end

    if p2 == 0 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if not hasRankingWindow() then
            createRankingWindow()
        end
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 1 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if not hasRankingWindow() then
            createRankingWindow()
        end
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 2 then
        if GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj") then
            GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
            npc.tyec = nil
        end

        
    end
end

---首冲礼包
npc[501] = function(p2, p3, Data) -- 首冲礼包
    local function get_501_state()
        local cfg = teshudata["anniu_501"] or {}
        local T_data = (npc.data_501 and npc.data_501.T_data) or {}
        local max = (cfg.details and cfg.details["首充"] and #cfg.details["首充"]) or 0
        local ok = tonumber(T_data["ok"] or 0) == 1
        local dl_progress = tonumber((npc.data_501 and (npc.data_501.dl_progress or npc.data_501.time_data)) or 1) or 1
        local claimed = tonumber(T_data["other_lb"] or T_data["_lb"] or 0) or 0
        if dl_progress < 1 then
            dl_progress = 1
        end
        if claimed < 0 then
            claimed = 0
        end
        if max > 0 and dl_progress > max then
            dl_progress = max
        end
        if max > 0 and claimed > max then
            claimed = max
        end
        local cur_idx = claimed + 1
        if cur_idx < 1 then
            cur_idx = 1
        end
        if max > 0 and cur_idx > max then
            cur_idx = max
        end
        return cfg, T_data, ok, max, dl_progress, claimed, cur_idx
    end

    local function create_501_item(parent, name, count, x, y)
        local kuang = GUI:Image_Create(parent, "kuang_" .. tostring(x) .. "_" .. tostring(y), x, y, "res/custom/top/shochong/kuang.png")
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
        if tonumber(itemIndex) and tonumber(itemIndex) > 0 then
            local show = GUI:ItemShow_Create(kuang, "item", 25, 24, {index = itemIndex, look = true})
            GUI:setAnchorPoint(show, 0.5, 0.5)
        end
        if tonumber(count or 0) > 1 then
            local num = GUI:Text_Create(kuang, "count", 25, 2, 13, "#FFFFFF", SL:GetSimpleNumber(count, 0))
            GUI:setAnchorPoint(num, 0.5, 0)
            GUI:Text_enableOutline(num, "#000000", 1)
        end
    end

    local function get_501_row_status(idx, ok, claimed, dl_progress)
        if idx <= claimed then
            return "已领取", "#33ff99", false
        end
        if not ok then
            return "未首充", "#ff7056", false
        end
        if idx == claimed + 1 and dl_progress >= idx then
            return "可领取", "#ffe07a", true
        end
        if idx == claimed + 1 then
            return "未解锁", "#ff7056", false
        end
        return "后续档位", "#b08a53", false
    end

    local function UI_updata(node) -- 界面渲染
        GUI:removeAllChildren(node)
        local cfg, T_data, ok, max, dl_progress, claimed, cur_idx = get_501_state()
        local rewardList = (cfg.details and cfg.details["首充"]) or {}
        local rowY = {262, 190, 118}
        local rowItemStartX = 215
        local rowItemStepX = 58

        GUI:Image_Create(node, "bg", 0, 0, "res/custom/top/shochong/bg.png")
        GUI:Effect_Create(node, "eff", 500, 260, 0, 60048)

        for i = 1, max do
            local rowRewards = rewardList[i] and (rewardList[i].show or rewardList[i].jl) or {}
            local statusText, statusColor = get_501_row_status(i, ok, claimed, dl_progress)
            for j = 1, math.min(#rowRewards, 4) do
                create_501_item(node, rowRewards[j][1], rowRewards[j][2], rowItemStartX + (j - 1) * rowItemStepX, rowY[i] - 20)
            end
            local stateLabel = GUI:Text_Create(node, "state_" .. i, 150, rowY[i] - 28, 18, statusColor, statusText)
            GUI:Text_setFontName(stateLabel, "fonts/500.ttf")
            GUI:Text_enableOutline(stateLabel, "#5a1d0c", 2)
        end

        local canClaim = ok and max > 0 and claimed < max and dl_progress >= cur_idx

        if not ok then
            local rechargeButton = GUI:Button_Create(node, "recharge", 600, 0, "res/custom/top/shochong/btn_1.png")
            GUI:setAnchorPoint(rechargeButton, 0.5, 0)
            GUI:addOnClickEvent(rechargeButton, function()
                SL:SendLuaNetMsg(101, 501, 1, 0, "")
            end)
            return
        end

        if canClaim then
            local claimButton = GUI:Button_Create(node, "claim", 600, 0, "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(claimButton, 0.5, 0)
            GUI:addOnClickEvent(claimButton, function()
                SL:SendLuaNetMsg(101, 501, 1, 0, "")
                npc.data_501 = npc.data_501 or {}
                npc.data_501.T_data = npc.data_501.T_data or {}
                npc.data_501.T_data["other_lb"] = cur_idx
                UI_updata(node)
            end)
            return
        end

        local tipText = "当前不可领取"
        if claimed >= max and max > 0 then
            tipText = "首充礼包已全部领取"
        elseif dl_progress < cur_idx then
            tipText = "对应大陆未解锁"
        elseif cur_idx <= claimed then
            tipText = "该档已领取"
        end
        local tip = GUI:Text_Create(node, "tip", 560, 34, 20, "#ff7056", tipText)
        GUI:setAnchorPoint(tip, 0.5, 0.5)
        GUI:Text_setFontName(tip, "fonts/500.ttf")
        GUI:Text_enableOutline(tip, "#5a1d0c", 2)

        
    end

    if p2 == 0 then
        npc.data_501 = not Data and {} or SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        local firstChargeWin = ensureWindow("firstCharge", 501, {titleText = "首充礼包"})
        npc.bg = firstChargeWin.bg
        npc.node = firstChargeWin.node
        UI_updata(npc.node)
    end
end
---在线充值
npc[502] = function(p2, p3, Data) -- 在线充值
    -- 界面渲染：自定义金额 + 多档快速充值按钮
    local function create_502_item(parent, itemName, itemCount, itemKey)
        local itemNode = GUI:Image_Create(parent, "itme" .. tostring(itemKey or itemName), 0, 0, "dev/res/wy/public/40-42.png")
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if tonumber(itemIndex) and tonumber(itemIndex) > 0 then
            local itemShow = GUI:ItemShow_Create(itemNode, "item", 40 / 2, 42 / 2, {index = itemIndex, look = true})
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        end
        if tonumber(itemCount or 0) > 1 then
            GUI:setAnchorPoint(GUI:Text_Create(itemNode, "count", 40 / 2, 5, 13, "#FFFFFF", SL:GetSimpleNumber(itemCount, 0)), 0.5, 0.5)
        end
        return itemNode
    end

    local function get_502_show_list(cfg)
        if type(cfg) ~= "table" then
            return {}
        end
        local list = {}
        for _, item in ipairs(cfg.give or {}) do
            list[#list + 1] = {item[1], item[2]}
        end
        if cfg.ch then
            list[#list + 1] = {cfg.ch .. "[称号]", 1}
        end
        if cfg.skill then
            list[#list + 1] = {cfg.skill, 1}
        end
        if type(cfg.show) == "table" and #cfg.show > 0 then
            for _, item in ipairs(cfg.show) do
                list[#list + 1] = {item[1], item[2]}
            end
        end

        if tonumber(cfg.token_count or 0) and tonumber(cfg.token_count or 0) > 0 then
            local tokenName = ((teshudata["npc_101"] or {}).token_name) or "锄子"
            list[#list + 1] = {tokenName, tonumber(cfg.token_count or 0)}
        end
        return list
    end

    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)


        local Input = GUI:TextInput_Create(node, "Input",180.00 + 324, 50.00 + 363, 50.00, 20.00, 13)
        GUI:TextInput_setPlaceHolder(Input, "最少10")
        GUI:setTouchEnabled(Input, true)

        local num = GUI:Text_Create(node, "num", 180.00 + 324 + 30, 80.00 + 363, 20, "#FFFFFF", SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "累计充值")))
        GUI:setAnchorPoint(num, 0.5, 0.5)

        num = GUI:TextAtlas_Create(npc.bg, "num1", 690,30, SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "真充积分")), "res/custom/public/text1.png", 14, 30, ".")
        GUI:setAnchorPoint(num, 0, 0.5)

        local cz_an = GUI:Button_Create(node, "cz_an", 300 + 274, 38 + 350, "res/custom/chongzhi/btn.png")
        GUI:addOnClickEvent(cz_an, function()
            local msg = tonumber(GUI:TextInput_getString(Input))
            if msg then
                SL:SendLuaNetMsg(101, 502, 0, 3, msg)
            end
        end)
        for i=1,3 do
            GUI:Image_Create(node, "way_"..i,  180 + (i-1)*30, 38 + 350 + 32, "res/custom/chongzhi/way_"..i..".png")
        end

        local ScrollView = GUI:ScrollView_Create(node, "ScrollView", 30, 50, 720, 350, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 720, 185 + (234 * 2))


        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,185, 108*4, (234 * 2))
        for i=1,8 do
            --
            local Button = GUI:Image_Create(dbLayout, "img_lf"..i,  0, 0, "res/custom/chongzhi/"..teshudata["anniu_502"].fj[i]..".png")
            GUI:setTouchEnabled(Button, true)
            if npc.data_502["cz502_"..teshudata["anniu_502"].fj[i]] and npc.data_502["cz502_"..teshudata["anniu_502"].fj[i]] == 1 then
                
            else
                GUI:Image_Create(Button, "double",  100, 100, "res/custom/chongzhi/double.png")
                local list = GUI:Layout_Create(Button, "list", 10,35, 40*4, 42)
                local rewardList = get_502_show_list(teshudata["anniu_502"].jl[i])
                for j = 1, math.min(#rewardList, 4) do
                    create_502_item(list, rewardList[j][1], rewardList[j][2], j)
                end
                GUI:UserUILayout(list, {dir=3,addDir=1,colnum = 4,gap = {x=0, y=0}})
            end
            
            
            -- GUI:Text_Create(Button, "wz",30,100, 20, "#FF0000", teshudata["anniu_502"].fj[i].."元")

            -- local richText = GUI:RichTextFCOLOR_Create(Button, "rich0", 10, 10, "<非绑灵石/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>   <绑定灵石/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>", 400, 13, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            -- --GUI:setAnchorPoint(richText, 0.5, 1)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 502, 0, 2, teshudata["anniu_502"].fj[i])
            end)

        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=0, y=0}})
        GUI:Image_Create(ScrollView, "k_1",  0, 0, "res/custom/chongzhi/k_1.png")
    end

    if p2 == 0 then
        npc.data_502 = not Data and {} or SL:JsonDecode(Data, false)
        local rechargeWin = ensureWindow("onlineRecharge", 502, {titleText = "在线充值"})
        npc.bg = rechargeWin.bg
        npc.node = rechargeWin.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_502 = not Data and {} or SL:JsonDecode(Data, false)
        UI_updata(npc.node)
    end
end
---小充值面板
npc[999] = function(p2, p3, Data) -- 小充值面板
    local parent = GUI:GetWindow(nil, "npc_czxz")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_czxz", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(bjt, true)
    GUI:addOnClickEvent(bjt, function()
        GUI:Win_Close(parent)
    end)
    local bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/anniu_999_bj.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setTouchEnabled(bg, true)
    GUI:Timeline_Window3(bg)
    local close = GUI:Button_Create(bg, 'close', 585, 290, 'res/wy/public/20.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    GUI:Image_Create(bg, "wz1", 160.00, 250.00, "res/wy/public/anniu_999_wz1.png")
    GUI:Image_Create(bg, "wz2", 160.00, 91.00, "res/wy/public/anniu_999_wz2.png")

    local txt = GUI:Text_Create(bg, "txt", 380.00, 91.00, 20, "#ffffff", p2)
    local Button = {}
    for i = 1, 3, 1 do
        Button[i] = GUI:Button_Create(bg, "Button_" .. i, 90 + (i - 1) * 160, 155.00, "res/wy/public/cz_" .. i .. "1.png")
        GUI:addOnClickEvent(Button[i], function()
            if Data == "1" then
                SL:RequestPay(i, p3, p2, 0)
            else
                SL:RequestPay(i, p3, p2, 0)
            end
            SL:SendLuaNetMsg(101, 502, i, 1, "")
        end)
    end
end
---解绑特权
npc[504] = function(p2, p3, Data) -- 解绑特权
    -- 界面渲染：展示奖励列表 + 开通按钮
    if p2 == 0 then
        npc.kryb =  SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
		local parent = GUI:GetWindow(nil, "npc_sclb")
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_sclb", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
		end
		local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
		GUI:setAnchorPoint(bjt, 0.5, 0.5)
		GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
		GUI:setTouchEnabled(bjt, true)
		GUI:addOnClickEvent(bjt, function()
			GUI:Win_Close(parent)
		end)
        npc.bg = GUI:Frames_Create(parent, "bg", 0, 0, "res/wy/eff/city/gm_bj", ".png", 1, 60, {speed = 50, count = 60, loop = -1})
		GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc.bg, true)

        GUI:Image_Create(npc.bg, "img_1", 150, 400, "res/custom/top/kryb/img_1.png")
        GUI:Image_Create(npc.bg, "img_2", 0, 300, "res/custom/top/kryb/img_2.png")
        GUI:Image_Create(npc.bg, "img_3", 0, 130, "res/custom/top/kryb/img_3.png")
        GUI:Image_Create(npc.bg, "img_4", 150, 20, "res/custom/top/kryb/img_4.png")
        -- GUI:Image_Create(npc.bg, "anniu_504_5", 800, 0, "res/wy/public/anniu_504_5.png")

        -- local jl_node = ItemNumByTable_img(npc.s_show[504].show,nil,npc.bg)
        -- GUI:setPosition(jl_node, 500, 130)

        local close = GUI:Button_Create(npc.bg, 'close', 850, 450, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        if npc.kryb.mztq == 0 then
            npc.Button = GUI:Button_Create(npc.bg, "Button", 470, 20, "res/custom/top/kryb/btn.png")
            GUI:addOnClickEvent(npc.Button, function()
                SL:SendLuaNetMsg(101, 504, 1, 0, "")
            end)
        else
            GUI:Image_Create(npc.bg, "img_bj1", 457, 46, "res/wy/public/6.png")
        end
	end
end

---巡航挂机
local guaji_ms = {"挂机时被攻击 自动随机传送（30秒冷却）", "挂机时未击杀 切换地图（120秒触发）", "挂机死亡或者回城后60秒随机下图","每10分钟自动切换地图"}
npc._patrolRefs = npc._patrolRefs or {}
local patrolRefs = npc._patrolRefs
npc[505] = function(p2, p3, Data) -- 巡航挂机
    local function buildPatrolUI(data)
        local win = ensureWindow("patrol", 505, {titleText = "巡航挂机"})
        local panel = win.node
        GUI:setPosition(panel, 150, 50)

        npc.ksgj = GUI:Button_Create(panel, "ksgj", 439.00, 22.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(npc.ksgj, data.gjkg and "停止挂机" or "开始挂机")
        GUI:Button_setTitleColor(npc.ksgj, "#ffffff")
        GUI:Button_setTitleFontSize(npc.ksgj, 14)
        GUI:Button_titleEnableOutline(npc.ksgj, "#000000", 1)
        GUI:addOnClickEvent(npc.ksgj, function()
            SL:SendLuaNetMsg(101, 505, 4, 0, "")
        end)

        local listView = GUI:ListView_Create(panel, "ListView", 26.00, 22.00, 300.00, 372.00, 1)
        GUI:ListView_setGravity(listView, 5)
        GUI:ListView_setItemsMargin(listView, 10)
        npc.fu_gx = {}
        npc.dtwb = {}
        for i = 1, 10 do
            local btn = GUI:Button_Create(listView, "Button" .. i, 0.00, 0.00, "res/public/bg_bti_07.png")
            GUI:setContentSize(btn, 300, 50)
            local check = GUI:CheckBox_Create(btn, "fu_gx" .. i, 4.00, 0, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(check, data["fgx" .. i])
            GUI:addOnClickEvent(btn, function() SL:SendLuaNetMsg(101, 505, 2, i, "") end)
            GUI:CheckBox_addOnEvent(check, function() SL:SendLuaNetMsg(101, 505, 3, i, "") end)
            npc.fu_gx[i] = check
            npc.dtwb[i] = GUI:Text_Create(check, "dtmz" .. i, 50.00, 15.00, 16, "#ffffff", "当前记录地图：" .. (data["dt" .. i] or "点击记录"))
        end

        for i, label in ipairs(guaji_ms) do
            local toggle = GUI:CheckBox_Create(panel, "zhu_gx" .. i, 345.00, 340 - (i - 1) * 80, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(toggle, data["zgx" .. (i == 3 and 4 or i == 4 and 5 or i)])
            GUI:Text_Create(toggle, "Text", 48.00, 15.00, 16, "#ffffff", label)
            GUI:CheckBox_addOnEvent(toggle, function()
                SL:SendLuaNetMsg(101, 505, 5, i == 3 and 4 or i == 4 and 5 or i, "")
            end)
        end
    end

    if p2 == 1 then
        npc.data = SL:JsonDecode(Data, false)
        buildPatrolUI(npc.data)
    elseif p2 == 2 then
        if npc.dtwb and npc.dtwb[p3] then
            GUI:Text_setString(npc.dtwb[p3], "当前记录地图：" .. (Data or ""))
        end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.fu_gx and npc.fu_gx[p3] then
            GUI:CheckBox_setSelected(npc.fu_gx[p3], npc.data["fgx" .. p3])
        end
    elseif p2 == 4 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.ksgj then
            GUI:Button_setTitleText(npc.ksgj, npc.data.gjkg and "停止挂机" or "开始挂机")
        end
    end
end

---天选之人
npc[506] = function(p2, p3, Data)
    local function renderChosenUI(payload)
        local win = ensureWindow("chosen", 506, {titleText = "天选之人"})
        npc.bg = win.bg
        npc.node = win.node
        GUI:removeAllChildren(npc.node)

        local bg = npc.bg

        local Node = GUI:Node_Create(bg, "Node", 0, 0)
        local function updatePage(dq)
            for i = 1, 10 do
                local name = (payload.A_txzz and payload.A_txzz["md"..dq] and payload.A_txzz["md"..dq][i] and payload.A_txzz["md"..dq][i][1]) or "未开奖"
                local value = (payload.A_txzz and payload.A_txzz["md"..dq] and payload.A_txzz["md"..dq][i] and payload.A_txzz["md"..dq][i][2]) or "0"
                local nameLabel = GUI:ScrollText_Create(Node, "name"..dq..""..i, 600 - 474 + ((dq - 1) * 185), 360 - 70-(i-1)*20, 90, 12, "#E317B3", name, 10, nil)
                GUI:setAnchorPoint(nameLabel, 0.5, 0.5)                
                local valLabel = GUI:Text_Create(Node, "value"..dq..""..i, 760 - 562 + ((dq - 1) * 185), 360 - 70-(i-1)*20, 12, "#E317B3", value)
                GUI:setAnchorPoint(valLabel, 0.5, 0.5)
                GUI:Text_enableOutline(valLabel, "#000000", 1)
            end
        end
        updatePage(1)
        updatePage(2)
        updatePage(3)
        updatePage(4)
        
        GUI:setPosition(ItemNumByTable_img_new({{"天选之子",1},{"光速起步",1},{"策划的手机",1},{"技术的电脑",1},}, nil,GUI:Node_Create(Node, "jl_show", 0, 0)), 400 + 111, 110 + 112 + 147)
    end

    if p3 == 0 then
        npc.txzz_data = not Data and {} or SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    elseif p3 == 1 and npc.txzz_data then
        npc.txzz_data = SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    end
end

---游戏活动
npc[507] = function(p2, p3, Data)
    local activity_cfg = teshudata["anniu_507"] or {}

    local function richText(label, name, x, y, width, size, html)
        local rich = GUI:RichText_Create(label, name, x, y, html, width, size, "#f7f7de", 0, nil, nil, {
            outlineSize = 2,
            outlineColor = SL:ConvertColorFromHexString("#100808")
        })
        GUI:setAnchorPoint(rich, 0, 1)
        return rich
    end

    local function makeRewardText(items)
        if type(items) ~= "table" or #items <= 0 then
            return "奖励以活动实际结算为准"
        end
        local parts = {}
        for _, one in ipairs(items) do
            local name = one[1] or one.item or ""
            local count = tonumber(one[2] or one.count or 0) or 0
            if name ~= "" then
                if count > 1 then
                    parts[#parts + 1] = tostring(name) .. "x" .. tostring(count)
                else
                    parts[#parts + 1] = tostring(name)
                end
            end
        end
        if #parts <= 0 then
            return "奖励以活动实际结算为准"
        end
        return table.concat(parts, "、")
    end

    local function getActivityDisplayCfg(i)
        local qmdt = activity_cfg.qmdt or {}
        local qmdk = activity_cfg.qmdk or {}
        local sjdb = activity_cfg.sjdb or {}
        local txzr = teshudata["anniu_506"] or {}
        local qmdtState = (npc.data_507 and npc.data_507.qmdt) or {}
        local qmdkState = (npc.data_507 and npc.data_507.qmdk) or {}
        local detailCfg = nil
        for _, one in ipairs(activity_cfg.details or {}) do
            if tonumber(one.idx) == tonumber(i) then
                detailCfg = one
                break
            end
        end

        local cfg = {
            title = detailCfg and detailCfg.name or ("活动" .. tostring(i)),
            time = "活动时间请关注游戏内公告",
            desc = "该活动正在整理中，具体规则以服务端实际开启内容为准。",
            reward = "奖励以活动实际结算为准",
            btnSkin = "res/custom/activity/btn.png",
        }

        if i == 1 then
            cfg.title = "保卫村庄"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后，村庄周围会刷新多波入侵怪物。守住村庄核心并尽快清理怪群，坚持到结算即可完成守卫。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 2 then
            cfg.title = "全民夺矿"
            cfg.time = string.format("开服第%s分钟开启，持续%s分钟", tostring(qmdk.start_minute or 26), tostring(qmdk.duration_min or 8))
            cfg.desc = string.format("进入【%s】地图后停留在矿区即可持续得分，每%s秒获得%s点积分；活动结束后按照积分排行发奖。当前个人积分：%s。",
                tostring(qmdk.map or "全民夺矿"),
                tostring(qmdk.score_tick_sec or 10),
                tostring(qmdk.score_per_tick or 1),
                tostring(tonumber(qmdkState.grjf or 0) or 0))
            cfg.reward = "参与奖励：" .. makeRewardText(qmdk.join_reward)
        elseif i == 3 then
            local open = tonumber(qmdtState.open or 0) or 0
            local currentIdx = tonumber(qmdtState.current_idx or 0) or 0
            local remain = tonumber(qmdtState.limit_sec or 0) or 0
            cfg.title = "全民答题"
            cfg.time = string.format("开服第%s分钟开启，持续%s分钟；共%s题，每题%s秒", tostring(qmdt.start_minute or 33), tostring(qmdt.duration_min or 5), tostring(qmdt.question_count or 5), tostring(qmdt.per_question_sec or 60))
            cfg.desc = "活动开启后通过当前入口参与答题，按题目序号提交答案。答对即可获得积分，最终按照总分排名发放奖励。"
            if open == 1 and currentIdx > 0 then
                cfg.desc = cfg.desc .. string.format("\n当前正在进行第%s/%s题，剩余%s秒。", tostring(currentIdx), tostring(qmdt.question_count or 5), tostring(remain))
            end
            cfg.reward = "参与奖励：" .. makeRewardText(qmdt.join_reward)
        elseif i == 4 then
            cfg.title = "勇夺镖车"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后护送或争夺镖车，安全将镖车送达终点即可获得高额收益，途中也可拦截其他玩家的镖车。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 5 then
            cfg.title = "土城跑酷"
            cfg.time = "活动入口直达土城地图，具体开启时段以游戏公告为准"
            cfg.desc = "活动开启后前往土城跑酷"
            cfg.reward = "奖励丰厚"
        elseif i == 6 then
            cfg.title = "天才地宝"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后地图内将刷新稀有材料与宝物点位，率先找到并成功采集的玩家可带走当轮核心奖励。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 7 then
            cfg.title = "天选之人"
            cfg.time = table.concat(txzr.notice or {"30分钟一轮，共四轮开启"}, "；")
            cfg.desc = "活动每轮会进行 roll 点排名，排名第一的玩家可获得额外奖励。"
            cfg.reward = "查看具体页面可以预览奖励"
        elseif i == 8 then
            cfg.title = "正邪大战"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后玩家将分为正邪两方进行阵营对抗，通过击杀、占点和团队推进累积优势，最终结算阵营胜负。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 9 then
            cfg.title = "武林盟主"
            cfg.time = "活动开启时可直接传送进入【比武大会】地图"
            cfg.desc = "进入比武大会后进行全场混战，活动期间尽可能击败更多对手并保持生存，最终胜者可争夺武林盟主之位。"
            cfg.reward = "胜者可获得盟主荣誉与活动结算奖励"
        elseif i == 10 then
            cfg.title = "敬请期待"
            cfg.time = "该分页当前未启用"
            cfg.desc = "该活动位目前仍为预留状态，后续有新活动接入时会直接补充到这里。"
            cfg.reward = "暂无奖励信息"
        elseif i == 11 then
            cfg.title = "沙巴克"
            cfg.time = "请通过沙巴克专属入口参与攻城"
            cfg.desc = "沙巴克为大型行会攻城玩法，需要通过专属入口进入战场。争夺皇宫归属、守住核心据点即可拿下城主荣耀。"
            cfg.reward = "行会奖励"
        elseif i == 12 then
            cfg.title = "讨伐BOSS"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后会投放特殊首领，玩家需要在限定时间内集火讨伐，按参与度与掉落归属结算奖励。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 13 then
            cfg.title = "随机夺宝"
            cfg.time = string.format("活动开启后在【%s】地图持续%s秒投放宝物", tostring(sjdb.map or "天降财宝"), tostring(sjdb.keep_sec or 300))
            cfg.desc = "宝物会以三圈形式投放：外圈覆盖范围最大、中圈奖励提升、内圈数量最少但价值最高，越靠近中心收益越高。"
            cfg.reward = "随机夺宝"
        elseif i == 14 then
            cfg.title = "黑暗禁地"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后可进入黑暗禁地探索高危区域，击败禁地怪物与首领，争夺更高阶的掉落与禁地专属收益。"
            cfg.reward = "开放后公布活动奖励"
        end

        return cfg
    end

    local function GUI_createLabel_507(label, i)
        GUI:removeAllChildren(label)
        local cfg = getActivityDisplayCfg(i)
        GUI:Image_Create(label, "img_bj", 6, 350, "res/custom/activity/img/img_" .. i .. ".png")

        local btn = GUI:Button_Create(label, "btn", 340, 14, cfg.btnSkin or "res/custom/activity/btn.png")
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(101, 507, 1, i, "")
        end)

        local title = GUI:Text_Create(label, "title", 22, 315, 24, "#F3E2B6", cfg.title or "")
        GUI:Text_setFontName(title, "fonts/500.ttf")
        GUI:Text_enableOutline(title, "#100808", 2)

        richText(label, "tip", 60, 252 + 40, 468, 18, "<font color='#f3e2b6' size='16'>" .. tostring(cfg.desc or "") .. "</font>")
        richText(label, "time", 60, 153 + 30, 468, 18, "<font color='#9ff06b' size='16'>" .. tostring(cfg.time or "") .. "</font>")
        richText(label, "reward", 86, 73, 468, 16, "<font color='#ffe07a' size='16'>" .. tostring(cfg.reward or "") .. "</font>")
    end

    local function renderActivity(node)
        GUI:removeAllChildren(node)

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -20, 50, 300, 420, 1)
        GUI:ListView_setGravity(npc.cbl_list, 2)
        npc.Label = GUI:Node_Create(node, "Label", 250, 15)

        npc.titles_sign = npc.titles_sign or 1
        for i = 1, 14 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/activity/list/"..(npc.titles_sign == i and "l" or "n").."/"..(npc.titles_sign == i and "l_" or "n_")..i..".png")
            GUI:setContentSize(cbl_item, GUI:getContentSize(cbl_item).width * 0.8, GUI:getContentSize(cbl_item).height * 0.8)
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/activity/list/n/n_"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel_507(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/activity/list/l/l_"..npc.titles_sign..".png")
            end)
        end
    end

    if p2 == 0 then
        npc.data_507 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("activity", 507, {titleText = "游戏活动"})
        npc.bg = win.bg
        npc.node = win.node
        npc.title = win.title
        -- GUI:setLocalZOrder(npc.title, 99)
        
        renderActivity(npc.node)
        GUI_createLabel_507(npc.Label, npc.titles_sign or 1)
    end
end

---福利大厅
npc[511] = function(p2, p3, Data) -- 福利大厅
    local fldt_data_cfg = teshudata["fldt"] or {}
    local fldt_cfg_table = fldt_data_cfg["fldt_cfg"]
    local fldt_seven_cfg = (fldt_cfg_table and fldt_cfg_table.seven_login) or {}
    local fldt_online_limit = fldt_seven_cfg.online_limit or 10
    local fldt_number_days = tonumber(fldt_seven_cfg.number_days or 4) or 4
    if fldt_number_days < 1 then
        fldt_number_days = 1
    elseif fldt_number_days > 7 then
        fldt_number_days = 7
    end

    local function fldt_decode_json(raw)
        if type(raw) == "table" then
            return raw
        end
        if not raw or raw == "" then
            return {}
        end
        return SL:JsonDecode(raw, false) or {}
    end

    local function fldt_get_state()
        npc.fldt_data = npc.fldt_data or {}
        npc.ts_data = npc.ts_data or {}
        npc.sign = npc.sign or 1
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {}
        return npc.fldt_data.T_qrbq
    end

    local function fldt_get_flip_digits()
        local fp = fldt_get_state()["7rqd_fp"]
        if type(fp) ~= "table" then
            fp = {}
        end
        return fp
    end

    local function fldt_get_mat_reward_by_day(day)
        local tqrbq = fldt_get_state()
        local matData = tqrbq and tqrbq["7rqd_mat"] or nil
        if type(matData) ~= "table" then
            return nil
        end
        local record = matData[day]
        if record == nil then
            record = matData[tostring(day)]
        end
        if record == nil then
            for _, one in ipairs(matData) do
                if type(one) == "table" and (tonumber(one.day) or 0) == (tonumber(day) or 0) then
                    record = one
                    break
                end
            end
        end
        if type(record) ~= "table" then
            return nil
        end
        if type(record.give) == "table" and #record.give > 0 then
            return record.give
        end
        return nil
    end
    
    local function fldt_calc_flip_value(fp)
        local total = 0
        if type(fp) ~= "table" then
            return total
        end
        for i = 1, 7 do
            local value = fp[i]
            if value == nil then
                value = fp[tostring(i)]
            end
            total = total + (tonumber(value) or 0) * (10 ^ (i - 1))
        end
        return total
    end

    local function fldt_format_digits(fp)
        local seq = {}
        for i = 7, 1, -1 do
            local v = fp[i] or fp[tostring(i)]
            seq[#seq + 1] = v ~= nil and tostring(v) or "?"
        end
        return table.concat(seq, " ")
    end

    local function sort_by_state(grss)
        table.sort(grss, function(a, b)
            -- 自定义 state 优先级
            local order = { [1] = 1, [0] = 2, [2] = 3 }

            local a_order = order[a.state] or 99
            local b_order = order[b.state] or 99

            if a_order == b_order then
                return a.idx < b.idx  -- 状态比较：state 优先级相同，按 idx 排
            else
                return a_order < b_order  -- 按 state 优先级排序
            end
        end)
    end

    local state_info = {
        [1] = {
            color = "#FF0000", -- 红色
            text = "可领取"
        },
        [0] = {
            color = "#FFFF00", -- 黄色
            text = "未达成"
        },
        [2] = {
            color = "#00FF00", -- 绿色
            text = "已领取"
        }
    }

    local fldt_section_key_map = {
        [4] = "grss",
        [5] = "grsb",
        [6] = "qqsb",
    }
    local fldt_section_flag_map = {
        [4] = "grss_can_claim",
        [5] = "grsb_can_claim",
        [6] = "qqsb_can_claim",
    }

    local function fldt_to_bool(v)
        if type(v) == "boolean" then
            return v
        end
        if type(v) == "number" then
            return v ~= 0
        end
        if type(v) == "string" then
            local lower = string.lower(v)
            return lower == "1" or lower == "true"
        end
        return false
    end

    -- 计算左侧每个分页是否存在“可领取”内容，用于列表红点。
    local function fldt_has_claimable_by_state_key(stateKey, stateTable)
        local cfg = fldt_data_cfg[stateKey] or {}
        local st = stateTable or npc.ts_data or {}
        for idx, _ in pairs(cfg) do
            if tonumber(st[tostring(idx)] or st[idx] or 0) == 1 then
                return true
            end
        end
        return false
    end

    local function fldt_get_reward_state(stateTable, idx)
        if type(stateTable) ~= "table" then
            return 0
        end
        return tonumber(stateTable[tostring(idx)] or stateTable[idx] or 0) or 0
    end

    local function fldt_build_state_rows(stateKey, stateTable)
        local cfg = fldt_data_cfg[stateKey] or {}
        local rows = {}
        for idx, entry in pairs(cfg) do
            rows[#rows + 1] = {
                idx = idx,
                state = fldt_get_reward_state(stateTable, idx),
                name = entry.name,
            }
        end
        sort_by_state(rows)
        return rows
    end

    local function fldt_apply_state_button(button, state)
        local info = state_info[state] or state_info[0]
        local canClick = state == 1
        GUI:Button_setTitleText(button, info.text)
        GUI:Button_setTitleColor(button, info.color)
        GUI:Button_setTitleFontSize(button, 14)
        GUI:setTouchEnabled(button, canClick)
        GUI:Button_setBright(button, canClick)
    end

    local function fldt_get_qqsb_owner_name(idx)
        if type(npc.T_qqsb) ~= "table" then
            return ""
        end
        return tostring(npc.T_qqsb[tostring(idx)] or npc.T_qqsb[idx] or "")
    end

    local function fldt_section_has_claimable(idx)
        if idx == 1 then
            local tqrbq = fldt_get_state()
            local loginDays = tonumber(npc.fldt_data and npc.fldt_data.U_dlts) or 0
            local claimed = tonumber(tqrbq["7rqd"]) or 0
            local rewards = fldt_data_cfg["7rqd"] or {}
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and loginDays >= nextIdx
        elseif idx == 2 then
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["zxjl"]) or 0
            local onlineMinutes = tonumber(npc.fldt_data and npc.fldt_data.J_zxsj) or 0
            local rewards = fldt_data_cfg["zxjl"] or {}
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and onlineMinutes >= (tonumber(nextCfg.time) or 0)
        elseif idx == 3 then
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["sgjl"]) or 0
            local killCount = tonumber(npc.fldt_data and npc.fldt_data.U_sgsl) or 0
            local rewards = fldt_data_cfg["sgjl"] or {}
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and killCount >= (tonumber(nextCfg.num) or 0)
        elseif idx >= 4 and idx <= 6 then
            local flagKey = fldt_section_flag_map[idx]
            local stateKey = fldt_section_key_map[idx]
            local hasClaimable = false
            if npc.fldt_data and flagKey and npc.fldt_data[flagKey] ~= nil then
                hasClaimable = fldt_to_bool(npc.fldt_data[flagKey])
            elseif npc.fldt_state_cache and type(npc.fldt_state_cache[stateKey]) == "table" then
                hasClaimable = fldt_has_claimable_by_state_key(stateKey, npc.fldt_state_cache[stateKey])
            end
            if npc.titles_sign == idx and type(npc.ts_data) == "table" then
                hasClaimable = fldt_has_claimable_by_state_key(stateKey, npc.ts_data)
                npc.fldt_state_cache = npc.fldt_state_cache or {}
                npc.fldt_state_cache[stateKey] = npc.ts_data
                if npc.fldt_data and flagKey then
                    npc.fldt_data[flagKey] = hasClaimable and 1 or 0
                end
            end
            return hasClaimable
        end
        return false
    end

    local function fldt_refresh_side_redpoints()
        if not npc.cbl_list then
            return
        end
        local ui = GUI:ui_delegate(npc.cbl_list)
        for i = 1, 6 do
            local btn = ui and ui["item" .. i] or nil
            if btn then
                local hasClaimable = fldt_section_has_claimable(i)
                if hasClaimable then
                    local btnUi = GUI:ui_delegate(btn)
                    if not (btnUi and btnUi.redpoint) then
                        NPC_UI_HELPER.redpoint_create(btn,{x = 180,y = 32})
                    end
                else
                    GUI:removeChildByName(btn, "redpoint")
                end
            end
        end
    end


    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        GUI:Image_Create(Label_node, "bg", 0, 0, "res/custom/fulitating/bg_"..idx..".png")
        npc.fldt_data = npc.fldt_data or {}
        if idx == 1 then
            local base = npc.fldt_data
            base.T_qrbq = base.T_qrbq or {}
            local tqrbq = base.T_qrbq
            local loginDays = tonumber(base.U_dlts) or 0
            local onlineMinutes = tonumber(base.J_zxsj) or 0
            local claimed = tonumber(tqrbq["7rqd"]) or 0
            local flipDigits = fldt_get_flip_digits()
            local digitDisplay = fldt_format_digits(flipDigits)
            local finalSum = tonumber(tqrbq["7rqd_final_yb"]) or fldt_calc_flip_value(flipDigits)
            local finalMultiple = tonumber(tqrbq["7rqd_final_mul"]) or 1
            local finalAward = tonumber(tqrbq["7rqd_final_award"]) or 0

            -- GUI:Text_Create(Label_node, "seven_login_days", 260 + 365, 440 - 290, 20, "#FFD56F",
            --     string.format("累计登录：%d天   已领取：%d/7天", loginDays, math.min(claimed, 7)))
            -- GUI:Text_Create(Label_node, "seven_online_minutes", 260 + 365, 415 - 290, 18, "#FFD56F",
            --     string.format("当前在线：%d分钟 / 每日领取需满%d分钟", onlineMinutes, fldt_online_limit))
            -- GUI:Text_Create(Label_node, "seven_digits", 260 + 365, 390 - 290, 18, "#00E4FF", "幸运号码：" .. digitDisplay)

            for i = 7, 1, -1 do
                local slotX = 47 - (i - 7) * 82
                local v = flipDigits[i] or flipDigits[tostring(i)]
                local isClaimedDay = claimed >= i
                if i > fldt_number_days and isClaimedDay then
                    local matGive = fldt_get_mat_reward_by_day(i)
                    local matRow = type(matGive) == "table" and matGive[1] or nil
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 308, "res/custom/fulitating/num/kongbai.png")
                        , 0.5, 0.5)
                    if type(matRow) == "table" and matRow[1] then
                        local matNode = ItemNumByTable_img({matRow}, nil, GUI:Node_Create(Label_node, "mat_node_" .. i, 0, 0))
                        GUI:setPosition(matNode, slotX - 25, 283)
                    end
                elseif i <= fldt_number_days and isClaimedDay and v ~= nil then
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 308, "res/custom/fulitating/num/"..v..".png")
                        , 0.5, 0.5)
                    local effwu = GUI:Frames_Create(Label_node, "effwu"..i, slotX, 328, "res/custom/fulitating/eff/"..i.."/y_", ".png", 1, 15,
                        { speed = 75, count = 15, loop = 1, finishhide = false })
                    GUI:setAnchorPoint(effwu, 0.5, 0.5)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 328, "res/custom/fulitating/eff/"..i.."/y_1.png")
                        , 0.5, 0.5)
                end
            end

            -- local finalText
            -- if claimed >= 7 then
            --     if finalAward > 0 then
            --         finalText = string.format("翻牌合计：%d  倍率：x%d  已发绑定金币：%d", finalSum, finalMultiple, finalAward)
            --     else
            --         finalText = string.format("翻牌合计：%d  倍率：x%d  奖励发放中", finalSum, finalMultiple)
            --     end
            -- else
            --     finalText = string.format("翻牌合计：%d  倍率：x%d  完成七日自动发放", finalSum, finalMultiple)
            -- end
            -- GUI:Text_Create(Label_node, "seven_final", 260 + 365, 365 - 290, 18, "#FFFFFF", finalText)
            -- GUI:Text_Create(Label_node, "seven_tip", 260 + 365, 340 - 290, 16, "#FFA043", "提示：需要按顺序领取并满足在线时间才可翻牌。")
            local sevenRewards = fldt_data_cfg["7rqd"] or {}
            local totalDays = #sevenRewards
            local todayIdx = claimed + 1
            local todayCfg = sevenRewards[math.min(todayIdx, totalDays)]
            local canShow = todayCfg ~= nil
            local canClaimToday = canShow and loginDays >= todayIdx and todayIdx <= totalDays

            local dayLayout = GUI:Layout_Create(Label_node, "seven_day_layout", 150, 0, 620, 200)
            local card = GUI:Node_Create(dayLayout, "seven_card_today", 0, 0)
            -- GUI:Text_Create(card, "day_title", 10, 60, 20, "#FFE076", string.format("第%d天", todayIdx))
            -- local digitValue = flipDigits[todayIdx] or flipDigits[tostring(todayIdx)]
            -- local digitText = digitValue ~= nil and tostring(digitValue) or "?"
            -- GUI:Text_Create(card, "digit_today", 180, 60, 22, "#00F0FF", "翻牌号：" .. digitText)
            -- GUI:Text_Create(card, "state_today", 65, 60, 18, "#00FF7F", "状态：可领取")
            local rewardNode = GUI:Node_Create(card, "give_today", 0, 0)
            ItemNumByTable_img(todayCfg.jl, nil, rewardNode)
            GUI:setPosition(rewardNode, 10, 10)
            if canClaimToday then
                local claimButton = GUI:Button_Create(card, "Button_today", 240, -10, "res/custom/fulitating/btn_2.png")
                GUI:addOnClickEvent(claimButton, function()
                    SL:SendLuaNetMsg(101, 511, 1, 1, string.format('{"7rqd":%d}', todayIdx))
                end)
                NPC_UI_HELPER.redpoint_create(claimButton)
            else
                local tipText
                if not canShow or todayIdx > totalDays then
                    tipText = "七日登录奖励已全部领取"
                elseif loginDays < todayIdx then
                    tipText = string.format("今日奖励已经领取完毕，达到第%d天可继续领取", todayIdx)
                elseif onlineMinutes < fldt_online_limit then
                    tipText = string.format("今日在线满%d分钟后可领取奖励", fldt_online_limit)
                else
                    tipText = "今日暂无可领取奖励"
                end
                GUI:Text_Create(Label_node, "seven_state_tip", 200, 63, 18, "#FFA043", tipText)
            end
        elseif idx == 2 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["zxjl"]) or 0
            local onlineMinutes = tonumber(npc.fldt_data and npc.fldt_data.J_zxsj) or 0

            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F",
                string.format("当前在线：%d分钟", onlineMinutes))

            local onlineRewards = fldt_data_cfg["zxjl"] or {}
            for v, k in ipairs(onlineRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_'..(v%2 == 1 and 1 or 2)..'.png')
                local canClaimNow = (v == (claimed + 1)) and (onlineMinutes >= (tonumber(k.time) or 0))

                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("在线满%d分钟", k.time))

                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)

                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false

                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if onlineMinutes >= (k.time or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d分钟", onlineMinutes, k.time or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end

                -- GUI:Text_Create(l, "state", 260, 40, 18, stateColor, stateDesc)

                -- GUI:Button_setTitleText(Button, btnText)
                -- GUI:Button_setTitleFontSize(Button, 14)
                --TODO：正式时候要改回enable
                if enable then 
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 2, '{"zxjl":' .. v .. '}')
                    end)
                    if canClaimNow then
                        NPC_UI_HELPER.redpoint_create(Button,{x = 110,y = 30})
                    end
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 3 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["sgjl"]) or 0
            local killCount = tonumber(npc.fldt_data and npc.fldt_data.U_sgsl) or 0

            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F",
            string.format("今日已击杀：%d只", killCount))
            local killRewards = fldt_data_cfg["sgjl"] or {}
            for v, k in ipairs(killRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_'..(v%2 == 1 and 1 or 2)..'.png')
                local canClaimNow = (v == (claimed + 1)) and (killCount >= (tonumber(k.num) or 0))

                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("击杀%d只怪物", k.num))

                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)

                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false

                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if killCount >= (k.num or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d只", killCount, k.num or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end

                -- GUI:Text_Create(l, "state", 260, 40, 18, stateColor, stateDesc)

                if enable then 
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 3, '{"sgjl":' .. v .. '}')                    
                        end)
                    if canClaimNow then
                        NPC_UI_HELPER.redpoint_create(Button,{x = 110,y = 30})
                    end
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 4 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grss = {}

            for v,k in pairs(teshudata["fldt"]["grss"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grss, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grss, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grss"][tonumber(v)].name})
                end
            end

            sort_by_state(grss)


            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not grss[i] then break end
                local v = grss[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)

                -- GUI:Text_Create(l, "state",300,5, 20, state_info[v.state].color, state_info[v.state].text)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(teshudata["fldt"]["grss"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


                local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 4, '{"grss":"'..(v.idx)..'"}')
                end)
            end

            local Button_all = GUI:Button_Create(Label_node, "grss_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 4, '{"isall":1}')
            end)

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == math.ceil(#grss/10) then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,math.ceil(#grss/10)))
            , 0.5, 0.5)


        elseif idx == 5 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grsb = {}

            for v,k in pairs(teshudata["fldt"]["grsb"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grsb, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grsb, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grsb"][tonumber(v)].name})
                end
            end

            sort_by_state(grsb)
            local totalPage = math.max(1, math.ceil(#grsb/7))

            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not grsb[i] then break end
                local v = grsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(teshudata["fldt"]["grsb"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

                local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 5, '{"grsb":"'..(v.idx)..'"}')
                end)
            end

            local Button_all = GUI:Button_Create(Label_node, "grsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 5, '{"isall":1}')
            end)

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,totalPage))
            , 0.5, 0.5)
        elseif idx == 6 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local qqsb = fldt_build_state_rows("qqsb", npc.ts_data)
            sort_by_state(qqsb)
            local totalPage = math.max(1, math.ceil(#qqsb/7))

            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not qqsb[i] then break end
                local v = qqsb[i]
                local cfg = teshudata["fldt"]["qqsb"][v.idx]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(cfg.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                local ownerName = fldt_get_qqsb_owner_name(v.idx)
                if v.state == 1 then
                    local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                    fldt_apply_state_button(Button, v.state)
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 6, '{"qqsb":"'..(v.idx)..'"}')
                    end)
                elseif ownerName ~= "" then
                    GUI:Text_Create(l, "owner_" .. i, 438, 8, 18, "#00FF00", ownerName)
                end
            end

            local Button_all = GUI:Button_Create(Label_node, "qqsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            local qqsbCanClaim = fldt_has_claimable_by_state_key("qqsb", npc.ts_data)
            GUI:setTouchEnabled(Button_all, qqsbCanClaim)
            GUI:Button_setBright(Button_all, qqsbCanClaim)
            if qqsbCanClaim then
                GUI:addOnClickEvent(Button_all, function()
                    SL:SendLuaNetMsg(101, 511, 1, 6, '{"isall":1}')
                end)
            end

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,totalPage))
            , 0.5, 0.5)

        end
    end

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        local titles = {"七日登录", "在线奖励", "杀怪奖励", "怪物首杀", "个人首爆", "全区首爆"}
        npc.titles_sign = 1
        for i = 1, #titles do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/fulitating/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                if i >= 4 then
                    SL:SendLuaNetMsg(101, 511, 2, i, "")
                    npc.sign = 1
                else
                    GUI_createLabel(npc.Label,i)
                end
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/l/"..npc.titles_sign..".png")
            end)
        end
        
        GUI:Image_Create(node, "bg_fgx", 0, 0, "res/custom/fulitating/bg_fgx.png")
        fldt_refresh_side_redpoints()

    end

    if p2 == 0 then
        npc.fldt_data = fldt_decode_json(Data)
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {}
        npc.ts_data = npc.ts_data or {}
        npc.fldt_state_cache = {}
        local welfareWindow = ensureWindow("welfare", 511, {titleText = "福利大厅"})
        npc.bg = welfareWindow.bg
        npc.node = welfareWindow.node
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    elseif p2 == 1 then
        if p3 == 1 then
            npc.fldt_data = npc.fldt_data or {}
            npc.fldt_data.T_qrbq = fldt_decode_json(Data)
            if npc.Label and (npc.titles_sign or 1) <= 3 then
                GUI_createLabel(npc.Label, npc.titles_sign or 1)
            end
            fldt_refresh_side_redpoints()
        end
    elseif p2 == 2 then
        npc.ts_data = fldt_decode_json(Data)
        npc.titles_sign = p3
        local stateKey = fldt_section_key_map[p3]
        local flagKey = fldt_section_flag_map[p3]
        if stateKey then
            npc.fldt_state_cache = npc.fldt_state_cache or {}
            npc.fldt_state_cache[stateKey] = npc.ts_data
        end
        if stateKey and flagKey and npc.fldt_data then
            npc.fldt_data[flagKey] = fldt_has_claimable_by_state_key(stateKey, npc.ts_data) and 1 or 0
        end
        GUI_createLabel(npc.Label,p3)
        fldt_refresh_side_redpoints()
    elseif p2 == 10 then
        npc.T_qqsb = fldt_decode_json(Data)
    end

end
---游戏攻略
npc[512] = function(p2, p3, Data) -- 游戏攻略
    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        if idx == 1 then
        end
    end
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = 1
        for i = 1, 6 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/strategy/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/strategy/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/strategy/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/strategy/list/l/"..npc.titles_sign..".png")
            end)
        end
        

    end

    if p2 == 0 then
        npc.data_512 = not Data and {} or SL:JsonDecode(Data, false)
        local strategyWindow = ensureWindow("strategy", 512, {titleText = "游戏攻略"})
        npc.bg = strategyWindow.bg
        npc.node = strategyWindow.node
        GUI:setContentSize(GUI:Frames_Create(npc.bg, "eff1", 0, 0, "res/wy/eff/city/tongyong_0_dx_1_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
            GUI:setContentSize( GUI:Frames_Create(npc.bg, "eff2", 0, 0, "res/wy/eff/city/tongyong_0_dx_2_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
        
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    end
end
---世界地图
---世界地图
npc[514] = function(p2, p3, Data)
    local pos = {
        {100 + 123,100 + 267},
        {200 + 211,100 + 354 - 90},
        {600 - 48,100 + 363 - 90},
        {300 - 196,100 + 91},
        {500 - 212,100 + 151},
        {400 + 79,100 + 268 - 128},
        
    }
    local function renderWorldMap(node)
        GUI:removeAllChildren(node)
        local bg = GUI:Frames_Create(node, "bg", 0, 0, "res/custom/sjdt/eff/eff_", ".png", 1, 8,
            { speed = 75, count = 8, loop = -1})
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        
        for i = 1, 6 do
            local btn = GUI:Button_Create(bg, 'btn' .. i, pos[i][1], pos[i][2], 'res/custom/sjdt/dl/l/'..i..'.png')
            -- GUI:Button_setTitleText(btn, teshudata["sjdt"][500 + i][1])
            -- GUI:Button_setTitleFontSize(btn, 14)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, 500 + i, 1, 0, "")
            end)
        end
        
    end

    if p2 == 0 then
        local win = ensureWindow("worldMap", 514, {titleText = "世界地图"})
        renderWorldMap(win.node)
    end
end
---仙途奇缘（成就）
npc[515] = function(p2, p3, Data) -- 仙途奇缘
    return Npclib["anniu_515"].main(515, p2, p3, Data)
end
--免费赞助
npc[516] = function(p2, p3, Data)
    local function mfzz_get_details()
        return (teshudata["anniu_516"] and teshudata["anniu_516"].details) or {}
    end

    local function mfzz_decode(data)
        if type(data) == "string" and data ~= "" then
            return SL:JsonDecode(data, false) or {}
        end
        return type(data) == "table" and data or {}
    end

    local function mfzz_get_data()
        npc.data_516 = npc.data_516 or {}
        npc.data_516.T_data = npc.data_516.T_data or {}
        return npc.data_516
    end

    local function mfzz_is_claimed(idx)
        local tData = mfzz_get_data().T_data or {}
        local v = tData["zzlb_" .. idx]
        return v == true or tonumber(v or 0) == 1
    end

    local function mfzz_is_cz502_claimed(amount)
        local tData = npc.data_502 and npc.data_502.T_data or {}
        local v = tData["cz502_" .. tostring(amount or 0)]
        return v == true or tonumber(v or 0) == 1
    end

    local function mfzz_get_reward_list(cfg)
        local ret = {}
        local function appendReward(src)
            if type(src) ~= "table" then
                return
            end
            if type(src[1]) == "table" then
                for _, item in ipairs(src) do
                    local itemName = tostring(item[1] or "")
                    local itemCount = tonumber(item[2] or 1) or 1
                    if itemName ~= "" then
                        ret[#ret + 1] = {itemName, itemCount}
                    end
                end
            elseif type(src[1]) == "string" then
                local itemName = tostring(src[1] or "")
                local itemCount = tonumber(src[2] or 1) or 1
                if itemName ~= "" then
                    ret[#ret + 1] = {itemName, itemCount}
                end
            end
        end

        local titleName = tostring((cfg or {}).ch or "")
        if titleName ~= "" then
            ret[#ret + 1] = {titleName .. "[称号]", 1}
        end
        appendReward(cfg and cfg.jl)
        return ret
    end

    local function mfzz_get_condition_info(cfg)
        cfg = cfg or {}
        local needCz502 = tonumber(cfg.need_cz502 or 0) or 0
        local needMoney23 = tonumber(cfg.need_money23 or 0) or 0
        local needCharge = tonumber(cfg.need_charge or cfg.sgsl or 0) or 0
        local curData = mfzz_get_data()
        local totalCharge = tonumber(curData.charge or curData.sgsl or 0) or 0
        local charge23 = tonumber(curData.money23 or 0) or 0

        if needCz502 > 0 then
            return string.format("需要：领取%s档在线充值礼包", tostring(needCz502)), mfzz_is_cz502_claimed(needCz502), true
        end
        if needMoney23 > 0 then
            return string.format("充值%s元", tostring(needMoney23)), charge23 >= needMoney23, false
        end
        if needCharge > 0 then
            return string.format("需要：累计充值%s元", tostring(needCharge)), totalCharge >= needCharge, false
        end
        return "免费领取", true, false
    end

    local function mfzz_can_claim(idx, cfg)
        if not cfg or mfzz_is_claimed(idx) then
            return false
        end
        if idx > 1 and not mfzz_is_claimed(idx - 1) then
            return false
        end
        local _, ok = mfzz_get_condition_info(cfg)
        return ok
    end

    local function mfzz_try_start_mainline_guide(button, guideParent, idx)
        local rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid) or 0
        if rwid ~= 2 or tonumber(idx) ~= 1 then
            return
        end
        NPC_UI_HELPER.startGuide({
            dir = 5,
            guideWidget = button,
            guideParent = guideParent,
            guideDesc = "点击领取",
            isForce = false,
            hideMask = true
        })
    end

    local function mfzz_render_item(parent, itemName, itemCount, posX, posY, key)
        local slot = GUI:Image_Create(parent, "slot_" .. tostring(key), posX, posY, "dev/res/wy/public/40-42.png")
        GUI:setAnchorPoint(slot, 0.5, 0.5)
        local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)) or 0
        if itemIndex <= 0 and not string.find(tostring(itemName), "%[称号%]") then
            itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(itemName) .. "[称号]")) or 0
        end
        if itemIndex > 0 then
            local itemShow = GUI:ItemShow_Create(slot, "item", 20, 21, {index = itemIndex, look = true})
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        end
        if tonumber(itemCount or 0) > 1 then
            local countText = GUI:Text_Create(slot, "count", 20, 3, 13, "#FFFFFF", SL:GetSimpleNumber(itemCount, 0))
            GUI:setAnchorPoint(countText, 0.5, 0)
            GUI:Text_enableOutline(countText, "#000000", 1)
        end
    end

    local function mfzz_render_card(node, idx, cfg)
        local posList = {
            [1] = {x = 107 + 25, y = 64 + 30},
            [2] = {x = 362, y = 64 + 30},
            [3] = {x = 616 - 24, y = 64 + 30},
        }
        local cardPos = posList[idx] or posList[1]
        local card = GUI:Layout_Create(node, "card_" .. idx, cardPos.x, cardPos.y, 165, 320)
        GUI:setAnchorPoint(card, 0, 0)

        local rewardList = mfzz_get_reward_list(cfg)
        local gridPos = {
            {35, 108}, {83, 108}, {131, 108},
            {35, 66}, {83, 66}, {131, 66},
        }
        for j = 1, math.min(#rewardList, #gridPos) do
            local pos = gridPos[j]
            mfzz_render_item(card, rewardList[j][1], rewardList[j][2], pos[1] + 23, pos[2] + 10, idx .. "_" .. j)
        end

        local conditionText, conditionOk, needQuestion = mfzz_get_condition_info(cfg)
        local conditionColor = conditionOk and "#57ff8d" or "#ff4636"
        local conditionRich = nil
        if idx == 2 then
            conditionRich = GUI:RichText_Create(card, "condition", 95, 70, string.format("<font color='%s'>%s</font>", conditionColor, conditionText), 150, 18, "#f7f7de", 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
            GUI:setAnchorPoint(conditionRich, 0.5, 0.5)
        end

        if needQuestion then
            local question = GUI:Button_Create(card, "question", 140, 70, "res/custom/mfzz/question.png")
            GUI:setAnchorPoint(question, 0.5, 0.5)
            GUI:addOnClickEvent(question, function()
                SL:SendLuaNetMsg(101, 502, 0, 0, "")
            end)
        end

        if mfzz_is_claimed(idx) then
            local stateImg = GUI:Image_Create(card, "Button", 84, 6, "res/wy/public/9.png")
            GUI:setAnchorPoint(stateImg, 0.5, 0)
        else
            local button = GUI:Button_Create(card, "Button", 84, 2, "res/custom/mfzz/claim.png")
            GUI:setAnchorPoint(button, 0.5, 0)
            GUI:addOnClickEvent(button, function()
                SL:SendLuaNetMsg(101, 516, 1, idx, "")
            end)
            mfzz_try_start_mainline_guide(button, node, idx)
            if mfzz_can_claim(idx, cfg) then
                NPC_UI_HELPER.redpoint_create(button, {x = 148, y = 35})
            end
        end
    end

    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)

        local curData = mfzz_get_data()
        local totalCharge = tonumber(curData.charge or curData.sgsl or 0) or 0
        local charge23 = tonumber(curData.money23 or 0) or 0
        -- local topText = string.format("当前累计充值：%s    直充：%s", tostring(totalCharge), tostring(charge23))
        -- local infoText = GUI:Text_Create(node, "info_text", 688, 18, 20, "#ffe7a8", topText)
        -- GUI:setAnchorPoint(infoText, 0.5, 0.5)
        -- GUI:Text_setFontName(infoText, "fonts/500.ttf")
        -- GUI:Text_enableOutline(infoText, "#000000", 2)

        local infoText = GUI:Text_Create(node, "info_text", 210, 18, 20, "#FFFFFF", "高级玩家档位可以使用真实充值卷积累")
        GUI:Text_enableOutline(infoText, "#100808", 2)
        GUI:Text_setFontName(infoText, "fonts/font4.ttf")

        for idx, cfg in ipairs(mfzz_get_details()) do
            mfzz_render_card(node, idx, cfg)
        end
    end

    if p2 == 0 then
        npc.data_516 = mfzz_decode(Data)
        npc.data_516.T_data = npc.data_516.T_data or {}
        local win = ensureWindow("freeSponsor", 516, {titleText = "至尊赞助"})
        npc.node_516 = win.node
        UI_updata(npc.node_516)
    elseif p2 == 1 then
        local newData = mfzz_decode(Data)
        if next(newData or {}) then
            npc.data_516 = newData
        else
            npc.data_516 = mfzz_get_data()
            npc.data_516.T_data["zzlb_" .. tostring(p3 or 0)] = 1
        end
        npc.data_516.T_data = npc.data_516.T_data or {}
        if npc.node_516 then
            UI_updata(npc.node_516)
        end
    end
end

--聚宝盆
npc[517] = function(p2, p3, Data)
    local function jbp_can_claim_reward()
        local data = npc.data_517 or {}
        local tData = data.T_data or {}
        local level = tonumber(tData.level) or 1
        local cfg = teshudata["anniu_517"] and teshudata["anniu_517"].details and teshudata["anniu_517"].details[level]
        if not cfg then
            return false
        end
        local jf = tonumber(data.jf) or 0
        local cs = tonumber(data.cs) or 0
        local needJf = tonumber(cfg.jf) or 0
        local maxCs = tonumber(cfg.maxcs) or 0
        return cs < maxCs and jf >= needJf
    end

    local function xjm_UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local no = GUI:Image_Create(node, "no", 20, 20, "res/custom/treasureBasin/itme_1.png")
        local config = teshudata["anniu_517"].details[npc.data_517.T_data.level]
       
        GUI:setAnchorPoint(GUI:RichText_Create(no, "jl", 205/2, 215,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        GUI:setAnchorPoint(GUI:RichText_Create(no, "tiaojian", 205/2, 127,  config.tiaojian, 500, 25, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        if npc.data_517.T_data.level >= #teshudata["anniu_517"].details then
            GUI:Text_Create(no, "wz1",400,50, 20, "#FF0000", "聚宝盆已满级")
            return
        end
        GUI:setAnchorPoint(GUI:Image_Create(node, "jt", 600/2, 398/2, "res/custom/treasureBasin/jt.png"), 0.5, 0.5)
        config = teshudata["anniu_517"].details[npc.data_517.T_data.level + 1]

        local nj = GUI:Image_Create(node, "nj", 375, 20, "res/custom/treasureBasin/itme_2.png")
        GUI:setAnchorPoint(GUI:RichText_Create(nj, "jl", 205/2, 215,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
         GUI:setAnchorPoint(GUI:RichText_Create(nj, "tiaojian", 205/2, 127,  config.tiaojian, 500, 25, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        local Button= GUI:Button_Create(node, "Button1", 600/2, 80, "res/custom/treasureBasin/bnt_2.png")
        GUI:setAnchorPoint(Button, 0.5, 0.5)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 1, 0, '')
        end)
       
    end

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        local config = teshudata["anniu_517"].details[npc.data_517.T_data.level]


        -- GUI:Text_Create(node, "wz1",200,400, 20, "#FF0000", "当前聚宝盆等级："..(npc.data_517.T_data.level or 0).."级")
        -- 
        -- GUI:Text_Create(node, "wz3",200,400 - 60, 20, "#FF0000", "当前积分："..(npc.data_517.jf or 0))
        -- GUI:Text_Create(node, "wz4",200,400 - 90, 20, "#FF0000", "当前领取所需积分"..(config.jf or 0))


        -- GUI:Text_Create(node, "wz5",200,400 - 120, 20, "#FF0000", "奖励:")
        -- local give_show = ItemNumByTable_img(config.give, nil,GUI:Node_Create(node, "give", 0, 0))
        -- GUI:setPosition(give_show, 200, 200)

        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_1", -350, 0, "res/custom/treasureBasin/wz_1.png"), 0.5, 0.5)
        -- GUI:setAnchorPoint(GUI:Image_Create(node, "wz_2", 350, 0, "res/custom/treasureBasin/wz_2.png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_3", -350, -100, "res/custom/treasureBasin/wz_3.png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_4", 0, -200, "res/custom/treasureBasin/wz_4.png"), 0.5, 0.5)

        

        GUI:Text_setFontName(GUI:Text_Create(node, "wz_3_num",-350 + 30, -100 - 19, 30, "#FF0000", config.maxcs - (npc.data_517.cs or 0))
        , "fonts/500.ttf")

        GUI:RichText_Create(node, "jl", -350 - 69, 0 - 38,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- if teshudata["anniu_517"].details[npc.data_517.T_data.level + 1] then
        --     GUI:RichText_Create(node, "jl_next", 350 - 69, 0 - 38,  ItemNumByTable(teshudata["anniu_517"].details[npc.data_517.T_data.level + 1].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- else
        --     GUI:Text_Create(node, "jl_next_wz", 220, 30, 18, "#FF0000", "已满级")
        -- end 


        local jdt_k = GUI:Image_Create(node, "jdt_k", 0,-230, "res/custom/treasureBasin/jdt_k.png")
        GUI:setAnchorPoint(jdt_k, 0.5, 0.5)
        GUI:LoadingBar_setPercent(GUI:LoadingBar_Create(jdt_k, "jdt", 0,0,"res/custom/treasureBasin/jdt_m.png", 0)
        , npc.data_517.jf / (config.jf or 1) * 100)
        
        GUI:setAnchorPoint(GUI:Text_Create(jdt_k, "wz",337,12, 18, "#FF0000", "当前积分："..(npc.data_517.jf or 0).."/"..(config.jf or 0))
        , 0.5, 0.5)
        local Button= GUI:Button_Create(node, "Button1", 330, -280.00, "res/custom/treasureBasin/btn_up.png")
        GUI:addOnClickEvent(Button, function()
            -- SL:SendLuaNetMsg(101, 517, 1, 0, '')
                npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                    windowName = "npc_anniu_517_xjm",
                    overlay = {skin = "res/custom/treasureBasin/x.png"},
                    background = {skin = "res/custom/treasureBasin/xjm_bg.png"},
                    closeButton = {x = 330 + 220, y = 180 + 180, skin = "res/wy/public/close_red_big.png"},
                })
                npc.xjm_node = npc.xjm_window.node
                xjm_UI_updata(npc.xjm_node)
        end)

        Button= GUI:Frames_Create(node, "Button2", 0, -50, "res/custom/treasureBasin/btn_eff/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(Button, 0.5, 0.5)
        GUI:setTouchEnabled(Button, true)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 2, 0, '')
        end)
        if jbp_can_claim_reward() then
            NPC_UI_HELPER.redpoint_create_eff(Button, {x = 200, y = 155})
        end


    end

    if p2 == 0 then
        npc.data_517 = not Data and {} or SL:JsonDecode(Data, false)
        npc.data_517.T_data = npc.data_517.T_data or {}
        npc.data_517.T_data.level = tonumber(npc.data_517.T_data.level) or 1
        local win = ensureWindow("treasureBasin", 517, {titleText = "聚宝盆"})
        npc.node_517 = win.node

        win.bg = GUI:Frames_Create(win.bg, "eff", 0, 0, "res/custom/treasureBasin/bg/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(win.bg, 0.5, 0.5)
        GUI:setTouchEnabled(win.bg, true)
        GUI:setAnchorPoint(GUI:Image_Create(win.bg, "title", 500, 520, "res/custom/treasureBasin/title.png")
        , 0.5, 0.5)
        UI_updata(win.node)
        GUI:setLocalZOrder(win.node, 99)
    elseif p2 == 1 then
        npc.data_517.T_data.level = npc.data_517.T_data.level + 1
        xjm_UI_updata(npc.xjm_node)
    elseif p2 == 2 then
        npc.data_517.jf = 0
        npc.data_517.cs = (npc.data_517.cs or 0) + 1
        UI_updata(npc.node_517)
    end
end


-- GM 面板配置：货币/礼包/变量/首充说明表
local xlxl = {
    {"金币","元宝","绑定金币","绑定元宝","灵石","绑定灵石","累计充值","礼包积分","一合充值","二合充值","三合后充值"},
    {"充值10","充值30","充值68","充值128","充值198","充值328","充值648","充值998"},
    {{"个人变量",105,178},{"个人标识",225,178},{"个人Buff",105,144},{"全局变量",225,144}},
    {"快人一步","前三天首充","三天后首充"},
}
npc[998] = function(p2, p3, Data)
    local parent = GUI:GetWindow(nil, "npc_hhhh")
    npc.data_998 = not Data and {} or SL:JsonDecode(Data, false)
	if parent then
		GUI:removeAllChildren(parent)
		GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
	else
		parent = GUI:Win_Create("npc_hhhh", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
	end
	npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/jiaozhu_0.png")
	GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
	GUI:setTouchEnabled(npc.bg, true)
	GUI:Timeline_Window3(npc.bg)
    local close = GUI:Button_Create(npc.bg, 'close', 970, 550, 'res/wy/public/close_red_big.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    local ImageView = GUI:Image_Create(npc.bg, "ImageView", 118.00, 495.00, "res/wy/public/input.png")
    local mingzi_sr = GUI:TextInput_Create(ImageView, "mingzi_sr", 0.00, 0.00, 155.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(mingzi_sr,"玩家名字")
    GUI:setTouchEnabled(mingzi_sr, true)
		local an_mz = GUI:Button_Create(npc.bg, "an_mz", 293.00, 493.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_mz, "是否在线")
	GUI:Button_setTitleColor(an_mz, "#28ef01")
	GUI:Button_setTitleFontSize(an_mz, 14)
	GUI:Button_titleEnableOutline(an_mz, "#000000", 1)

	local an_txx,han_zb = {},{{493,"踢下线"},{440,"加入列表"},{383,"去除列表"},{323,"显示列表"}}
	for i, v in ipairs(han_zb) do
	    an_txx[i] = GUI:Button_Create(npc.bg, "an_txx"..i, 410.00, v[1], "res/public/1900000660.png")
	    GUI:Button_setTitleText(an_txx[i], v[2])
	    GUI:Button_setTitleColor(an_txx[i], "#ff0500")
	    GUI:Button_setTitleFontSize(an_txx[i], 14)
	    GUI:Button_titleEnableOutline(an_txx[i], "#000000", 1)
	end

	local an_huobi = GUI:Image_Create(npc.bg, "an_huobi", 120.00, 445.00, "res/wy/public/input.png")
	local Text_huobi = GUI:Text_Create(an_huobi, "Text_huobi", 71.00, 14.00, 16, "#ffffff", [[货币种类]])
	GUI:setAnchorPoint(Text_huobi, 0.50, 0.50)
	GUI:Text_enableOutline(Text_huobi, "#000000", 1)

    GUI:setTouchEnabled(an_huobi, true)
    GUI:addOnClickEvent(an_huobi, function()
        local zb = GUI:getWorldPosition(an_huobi)
        SL:OpenSelectListUI(xlxl[1],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_huobi, xlxl[1][iiid])
        end)
    end)
	local ImageView_1 = GUI:Image_Create(npc.bg, "ImageView_1", 118.00, 355.00, "res/wy/public/input.png")
	local huobi_sr = GUI:TextInput_Create(ImageView_1, "huobi_sr", 0.00, 0.00, 155.00, 30.00, 16)
	GUI:TextInput_setPlaceHolder(huobi_sr,"修改数值")
	GUI:setTouchEnabled(huobi_sr, true)
	local an_huobicha = GUI:Button_Create(npc.bg, "an_huobicha", 293.00, 440.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_huobicha, "货币查询")
	GUI:Button_setTitleColor(an_huobicha, "#28ef01")
	GUI:Button_setTitleFontSize(an_huobicha, 14)
	GUI:Button_titleEnableOutline(an_huobicha, "#000000", 1)
	GUI:setTouchEnabled(an_huobicha, true)
	local an_huobigai = GUI:Button_Create(npc.bg, "an_huobigai", 293.00, 383.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_huobigai, "货币修改")
	GUI:Button_setTitleColor(an_huobigai, "#28ef01")
	GUI:Button_setTitleFontSize(an_huobigai, 14)
	GUI:Button_titleEnableOutline(an_huobigai, "#000000", 1)
	GUI:setTouchEnabled(an_huobigai, true)
	local an_hbzj = GUI:Button_Create(npc.bg, "an_hbzj", 293.00, 323.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_hbzj, "货币增加")
	GUI:Button_setTitleColor(an_hbzj, "#28ef01")
	GUI:Button_setTitleFontSize(an_hbzj, 14)
	GUI:Button_titleEnableOutline(an_hbzj, "#000000", 1)
	GUI:setTouchEnabled(an_hbzj, true)

	local an_libao = GUI:Image_Create(npc.bg, "an_libao", 550.00, 495.00, "res/wy/public/input.png")
	local Text_libao = GUI:Text_Create(an_libao, "Text_libao", 75.00, 15.00, 16, "#ffffff", [[礼包种类]])
	GUI:setAnchorPoint(Text_libao, 0.50, 0.50)
	GUI:Text_enableOutline(Text_libao, "#000000", 1)
    GUI:setTouchEnabled(an_libao, true)
    GUI:addOnClickEvent(an_libao, function()
        local zb = GUI:getWorldPosition(an_libao)
        SL:OpenSelectListUI(xlxl[2],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_libao, xlxl[2][iiid])
        end)
    end)
	local an_lb = GUI:Button_Create(npc.bg, "an_lb", 724.00, 491.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_lb, "增加礼包")
	GUI:Button_setTitleColor(an_lb, "#00ffff")
	GUI:Button_setTitleFontSize(an_lb, 14)
	GUI:Button_titleEnableOutline(an_lb, "#000000", 1)
	GUI:setTouchEnabled(an_lb, true)

    -- ===== GM 工具：输入校验 + 常用操作 =====
    local function showErrorTip(msg)
        SL:ShowSystemTips(string.format("<outline color='#000000' size='1'><font color='#FF0000'>%s</font></outline>", msg))
    end

    local function requirePlayerName()
        local name = GUI:TextInput_getString(mingzi_sr)
        if name == "" then
            showErrorTip("请正确输入玩家名字")
            return nil
        end
        return name
    end

    local function requireSelection(labelWidget, placeholder, tip)
        local text = GUI:Text_getString(labelWidget)
        if text == placeholder or text == "" then
            showErrorTip(tip)
            return nil
        end
        return text
    end

    local function requireNumber(inputWidget, tip)
        local value = tonumber(GUI:TextInput_getString(inputWidget))
        if not value then
            showErrorTip(tip or "请输入数字")
            return nil
        end
        return value
    end

    local function findIndexByLabel(list, label)
        for index, text in ipairs(list) do
            if text == label then
                return index
            end
        end
        return nil
    end

    local function handleCurrencyOp(opCode)
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local amount = requireNumber(huobi_sr, "请输入数量")
        if not amount then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, opCode, string.format('{"mz":"%s","hb":%d,"sl":%d}', name, currencyId, amount))
    end

    local function handleGiftAdd()
        local name = requirePlayerName()
        if not name then
            return
        end
        local giftName = requireSelection(Text_libao, "礼包种类", "请正确选择礼包种类")
        if not giftName then
            return
        end
        local giftId = findIndexByLabel(xlxl[2], giftName)
        SL:release_print(giftId)
        SL:release_print(giftName)
        if not giftId then
            showErrorTip("未知礼包类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, 4, string.format('{"mz":"%s","hb":%d}', name, giftId))
    end

    GUI:addOnClickEvent(an_mz, function()
        local name = requirePlayerName()
        if name then
            SL:SendLuaNetMsg(101,998, 1, 0, name)
        end
    end)

    for i, btn in ipairs(an_txx) do
        GUI:addOnClickEvent(btn, function()
            if i == 4 then
                SL:SendLuaNetMsg(101,998, 4, i, "")
                return
            end
            local name = requirePlayerName()
            if not name then
                return
            end
            SL:SendLuaNetMsg(101,998, 4, i, name)
        end)
    end

    GUI:addOnClickEvent(an_huobicha,function()
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, 1, string.format('{"mz":"%s","hb":%d}', name, currencyId))
    end)

    GUI:addOnClickEvent(an_huobigai,function()
        handleCurrencyOp(2)
    end)

    GUI:addOnClickEvent(an_hbzj,function()
        handleCurrencyOp(3)
    end)

    GUI:addOnClickEvent(an_lb,function()
        handleGiftAdd()
    end)

local an_libao_ts = GUI:Image_Create(npc.bg, "an_libao_ts", 550.00, 455.00, "res/wy/public/input.png")
    local Text_libao_ts = GUI:Text_Create(an_libao_ts, "Text_libao_ts", 75.00, 15.00, 16, "#ffffff", [[礼包种类]])
    GUI:setAnchorPoint(Text_libao_ts, 0.50, 0.50)
    GUI:Text_enableOutline(Text_libao_ts, "#000000", 1)
    GUI:setTouchEnabled(an_libao_ts, true)
    GUI:addOnClickEvent(an_libao_ts, function()
        local zb = GUI:getWorldPosition(an_libao_ts)
        SL:OpenSelectListUI(xlxl[4],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_libao_ts, xlxl[4][iiid])
        end)
    end)


    local huobi_sr_je = GUI:TextInput_Create(npc.bg, "huobi_sr_je", 550.00, 411.00, 115,30.00, 16)
    GUI:TextInput_setPlaceHolder(huobi_sr_je,"金额")
    GUI:setTouchEnabled(huobi_sr_je, true)

    local an_lb_ts_je = GUI:Button_Create(npc.bg, "an_lb_ts_je", 724.00, 411.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts_je, "金额充值")
    GUI:addOnClickEvent(an_lb_ts_je,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 5, 0,'{"mz":"'..mz..'","hb":'..GUI:TextInput_getString(huobi_sr_je)..'}')
        end
    end)


    local an_lb_ts = GUI:Button_Create(npc.bg, "an_lb_ts", 724.00, 451.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts, "增加礼包(特殊)")
    GUI:Button_setTitleColor(an_lb_ts, "#00ffff")
    GUI:Button_setTitleFontSize(an_lb_ts, 14)
    GUI:Button_titleEnableOutline(an_lb_ts, "#000000", 1)
    GUI:setTouchEnabled(an_lb_ts, true)
    GUI:addOnClickEvent(an_lb_ts,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            local hb = GUI:Text_getString(Text_libao_ts)
            if hb == "礼包种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择礼包种类</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[4]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 5,'{"mz":"'..mz..'","hb":'..id..'}')
            end
        end
    end)
    local ImageView_2_1 = GUI:Image_Create(npc.bg, "ImageView_2_1", 91.00, 261.00, "res/wy/public/input.png")
    local wpmz_sr = GUI:TextInput_Create(ImageView_2_1, "wpmz_sr", 0.00, 0.00, 155.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(wpmz_sr,"物品名称")
    local ImageView_2_1_1 = GUI:Image_Create(npc.bg, "ImageView_2_1_1", 258.00, 261.00, "res/wy/public/input.png")
    GUI:setContentSize(ImageView_2_1_1, 50, 31)
    local wpsl_sr = GUI:TextInput_Create(ImageView_2_1_1, "wpsl_sr", 0.00, 0.00, 50.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(wpsl_sr,"数量")
	local CheckBox_wp = GUI:CheckBox_Create(ImageView_2_1_1, "CheckBox_wp", 76.00, 4.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_wp, false)
	GUI:setTouchEnabled(CheckBox_wp, true)
	local Text = GUI:Text_Create(CheckBox_wp, "Text", 33.00, 3.00, 16, "#ffffff", [[勾选后绑定]])
	GUI:Text_enableOutline(Text, "#000000", 1)

    local an_wpk = GUI:Button_Create(npc.bg, "an_wpk", 95.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpk, "增加")
    GUI:Button_setTitleColor(an_wpk, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpk, 14)
    GUI:Button_titleEnableOutline(an_wpk, "#000000", 1)
    GUI:addOnClickEvent(an_wpk,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            local zt = 0
            if GUI:CheckBox_isSelected(CheckBox_wp) then
                zt = 1 
            else
                zt = 0
            end
            SL:SendLuaNetMsg(101,998, 2, 1,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..',"lx":'..zt..'}')
        end
    end)

    local an_wpj = GUI:Button_Create(npc.bg, "an_wpj", 232.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "扣除")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 2,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..'}')
        end
    end)

    local an_wpj = GUI:Button_Create(npc.bg, "an_wpfs", 369.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "发射")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 3,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..'}')
        end
    end)

    local an_ch = GUI:Button_Create(npc.bg, "an_chfs", 500.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_ch, "发送或者收回称号")
    GUI:Button_setTitleColor(an_ch, "#00ffff")
    GUI:Button_setTitleFontSize(an_ch, 14)
    GUI:Button_titleEnableOutline(an_ch, "#000000", 1)
    GUI:addOnClickEvent(an_ch,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入称号名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 4,'{"mz":"'..mz..'","ch":"'..wp..'"}')
        end
    end)
    local an_sbk = GUI:Button_Create(npc.bg, "an_sbk", 630.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_sbk, "设置沙巴克归属,名字处填入行会名")
    GUI:Button_setTitleColor(an_sbk, "#00ffff")
    GUI:Button_setTitleFontSize(an_sbk, 14)
    GUI:Button_titleEnableOutline(an_sbk, "#000000", 1)
    GUI:addOnClickEvent(an_sbk,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入行会名</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 5,'{"mz":"'..mz..'","wp":"'..wp..'"}')
        end
    end)

    local bl_fxk = {}
    for i, v in ipairs(xlxl[3]) do
        bl_fxk[i] = GUI:CheckBox_Create(npc.bg, "bl_fxk_"..i, v[2], v[3], "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:CheckBox_setSelected(bl_fxk[i], false)
        GUI:setTouchEnabled(bl_fxk[i], true)
        local Text = GUI:Text_Create(bl_fxk[i], "Text", 33.00, 3.00, 16, "#ffffff", v[1])
        GUI:Text_enableOutline(Text, "#000000", 1)
        GUI:CheckBox_addOnEvent(bl_fxk[i], function(self)
            GUI:CheckBox_setSelected(bl_fxk[1],i==1)
            GUI:CheckBox_setSelected(bl_fxk[2],i==2)
            GUI:CheckBox_setSelected(bl_fxk[3],i==3)
            GUI:CheckBox_setSelected(bl_fxk[4],i==4)
        end)
    end
    GUI:CheckBox_setSelected(bl_fxk[1],true)

	local blmz = GUI:Image_Create(npc.bg, "blmz", 99.00, 98.00, "res/wy/public/input.png")
    GUI:setContentSize(blmz, 100, 31)
	local bianliang_sr = GUI:TextInput_Create(blmz, "bianliang_sr", 0.00, 0.00, 100.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(bianliang_sr,"变量名")
	local bl_xg = GUI:Image_Create(npc.bg, "bl_xg", 236.00, 98.00, "res/wy/public/input.png")
	GUI:setContentSize(bl_xg, 100, 31)
	local bianliang_xg = GUI:TextInput_Create(bl_xg, "bianliang_xg", 0.00, 0.00, 100.00, 30.00, 16)
	GUI:TextInput_setPlaceHolder(bianliang_xg,"修改值")
	local an_blc = GUI:Button_Create(npc.bg, "an_blc", 95.00, 44.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_blc, "查询")
	GUI:Button_setTitleColor(an_blc, "#00ffff")
	GUI:Button_setTitleFontSize(an_blc, 14)
	GUI:Button_titleEnableOutline(an_blc, "#000000", 1)
    GUI:addOnClickEvent(an_blc,function()
        local mz,bl,lx = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(bianliang_sr),0
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 3,1,'{"mz":"'..mz..'","bl":"'..bl..'","lx":'..lx..'}')
        end
    end)
	local an_blg = GUI:Button_Create(npc.bg, "an_blg", 232.00, 44.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_blg, "修改")
	GUI:Button_setTitleColor(an_blg, "#00ffff")
	GUI:Button_setTitleFontSize(an_blg, 14)
	GUI:Button_titleEnableOutline(an_blg, "#000000", 1)
    GUI:addOnClickEvent(an_blg,function()
        local mz,bl,lx,zhi = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(bianliang_sr),0,GUI:Text_getString(bianliang_xg)
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        elseif zhi == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入修改值</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 3, 2,'{"mz":"'..mz..'","bl":"'..bl..'","lx":'..lx..',"zhi":'..zhi..'}')
        end
    end)
end

---主城跑酷面板
npc[1000] = function(p2, p3, Data) -- 跑酷
    -- if p2 == 1 then
    --     local parent = GUI:GetWindow(nil, "npc_pkxjm")
	-- 	if parent then
	-- 		GUI:removeAllChildren(parent)
	-- 		GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
	-- 	else
	-- 		parent = GUI:Win_Create("npc_pkxjm", cogin.w -350, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
	-- 	end
    --     npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/icon/hdtb_3.png")
	-- 	GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
	-- 	GUI:setTouchEnabled(npc.bg, true)
	-- 	GUI:Timeline_Window3(npc.bg)
        
    -- elseif p2 == 2 then
    --     GUI:Win_CloseByID("npc_pkxjm")
    -- end
end
---地图切换 --变暗
npc[1002] = function(p2, p3, msgData) -- 地图切换
    local parent = GUI:GetWindow(nil, "npc_qhdt")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_qhdt", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    local bg = GUI:Image_Create(bjt, "bg", cogin.w -200, cogin.h / 2+50, "res/wy/public/dtxs/"..msgData..".png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)

    GUI:Timeline_FadeOut(bjt, 1)
    GUI:Timeline_FadeOut(bg, 2)
end
npc[1004] = function(p2, p3, msgData) -- 查看他人
    cogin.onther_shuju = SL:JsonDecode(msgData,false)
    cogin.onther_zdl = cogin.onther_shuju.zdl
    SL:RequestLookPlayer(""..cogin.onther_shuju.userid, true)
end
npc[1005] = function(p2, p3, msgData) -- 查看他人
    UiTools.playSucAnimation(msgData)
end
npc[9999] = function(p2, p3, msgData) -- 通用关闭
    local parent = GUI:GetWindow(nil, msgData)
    if parent then
        GUI:Win_Close(parent)
    end
end
return npc






