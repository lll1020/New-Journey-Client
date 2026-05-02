local npc = {}

npc._config = teshudata["npc_689"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/689/689_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_689"
local btn_pos = {620, 80}
local reward_pos = {360, 120}
local cost_pos = {520, 200}
local MAIN_BTN_SKIN = "res/custom/all_story_mission/5/689/689_btn.png"
local MAIN_BTN_SKIN_TAKE = "res/custom/all_story_mission/2/btn_take.png"
local MAIN_BTN_SKIN_DOING = nil
local EXTRA_BTN_DIR = "res/custom/all_story_mission/5/689/list"
local ACTIONS = {1, 2, 3, 4, 5}
local ACTION_LABEL = { [1] = "解锁", [2] = "大地禁墟", [3] = "天空禁墟", [4] = "海洋禁墟", [5] = "青铜禁墟" }

-- 合并任务奖励与称号奖励，确保称号在奖励区可见。
local function buildRewardWithTitle(cfg)
    local reward_cfg = nil
    if type(cfg and cfg.rwjl) == "table" and #(cfg.rwjl) > 0 then
        reward_cfg = cfg.rwjl
    elseif type(cfg and cfg.jl) == "table" and #(cfg.jl) > 0 then
        reward_cfg = cfg.jl
    end

    local merged = {}
    local seen = {}

    local function pushReward(entry)
        if type(entry) ~= "table" or type(entry[1]) ~= "string" then
            return
        end
        local name = entry[1]
        if seen[name] then
            return
        end
        seen[name] = true
        local count = tonumber(entry[2] or 1) or 1
        table.insert(merged, {name, count})
    end

    if type(reward_cfg) == "table" then
        for _, entry in ipairs(reward_cfg) do
            pushReward(entry)
        end
    end

    local function pushTitle(name)
        if type(name) ~= "string" or name == "" then
            return
        end
        local titleName = string.find(name, "%[称号%]") and name or (name .. "[称号]")
        pushReward({titleName, 1})
    end

    local ch = cfg and cfg.ch
    if type(ch) == "table" then
        for _, name in ipairs(ch) do
            pushTitle(name)
        end
    else
        pushTitle(ch)
    end

    if #merged > 0 then
        return merged
    end
    return nil
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
    -- 操作按钮渲染：主按钮按任务状态切换，副按钮按动作号映射。
    local function createActionButtons(node, state, progress, unlockMaps, dljqData)
        local function resolveMainSkin()
            if state <= 0 and MAIN_BTN_SKIN_TAKE then
                return MAIN_BTN_SKIN_TAKE
            end
            if state == 1 and MAIN_BTN_SKIN_DOING then
                return MAIN_BTN_SKIN_DOING
            end
            if MAIN_BTN_SKIN == "res/public/1900000660.png" then
                return (state <= 0) and "res/custom/all_story_mission/2/btn_take.png" or "res/custom/all_story_mission/2/btn_give.png"
            end
            return MAIN_BTN_SKIN
        end

        local function createExtraButton(nodeName, x, y, ew)
            --这个地方是已经解锁是l 没有解锁是n
            local unlockIndex = (tonumber(ew) or 0) - 1
            local mapCfg = type(unlockMaps) == "table" and unlockMaps[unlockIndex] or nil
            local fallbackSuffix = string.char(string.byte("a") + math.max(0, unlockIndex - 1))
            local suffix = mapCfg and mapCfg.key or fallbackSuffix
            local flagKey = key .. "_" .. tostring(suffix)
            local isUnlocked = (tonumber(state) or 0) >= 2 or (tonumber(dljqData and dljqData[flagKey] or 0) or 0) == 1
            local skin = string.format("%s/%s/%d.png", EXTRA_BTN_DIR, isUnlocked and "l" or "n", unlockIndex)
            local btn = GUI:Button_Create(node, nodeName, x, y, skin)
            if not isUnlocked then
                GUI:setAnchorPoint(GUI:Image_Create(btn, "lock", 162 / 2, 164 / 2, "res/custom/all_story_mission/5/689/lock.png"), 0.5, 0.5)
            end
            GUI:setAnchorPoint(GUI:Image_Create(btn, "name", 0, 164 / 2, "res/custom/all_story_mission/5/689/name/689_l_"..unlockIndex..".png"), 0.5, 0.5)
            GUI:setAnchorPoint(btn, 0.5, 0.5)
            if skin == "res/public/1900000660.png" then
                GUI:Button_setTitleText(btn, ACTION_LABEL[ew] or ("操作" .. tostring(ew)))
                GUI:Button_setTitleFontSize(btn, 16)
            end
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, npcid, ew, 0, "")
            end)
        end

        local ew1 = ACTIONS[1]
        if ew1 then
            if state >= 2 then
                GUI:Image_Create(node, "done", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
            else
                local skin = resolveMainSkin()
                local b1 = GUI:Button_Create(node, "btn_action_1", btn_pos[1], btn_pos[2], skin)
                GUI:setAnchorPoint(b1, 0.5, 0.5)
                if skin == "res/public/1900000660.png" then
                    GUI:Button_setTitleText(b1, ACTION_LABEL[ew1] or ("操作" .. tostring(ew1)))
                    GUI:Button_setTitleFontSize(b1, 16)
                end
                GUI:addOnClickEvent(b1, function()
                    SL:SendLuaNetMsg(100, npcid, ew1, 0, "")
                end)
            end
        end

        local extraStartX = 190
        local extraY = 240
        local extraStep = 150

        local ew2 = ACTIONS[2]
        if ew2 then
            createExtraButton("btn_action_2", extraStartX, extraY, ew2)
        end

        local ew3 = ACTIONS[3]
        if ew3 then
            createExtraButton("btn_action_3", extraStartX + extraStep, extraY, ew3)
        end

        local ew4 = ACTIONS[4]
        if ew4 then
            createExtraButton("btn_action_4", extraStartX + extraStep * 2, extraY, ew4)
        end

        local ew5 = ACTIONS[5]
        if ew5 then
            createExtraButton("btn_action_5", extraStartX + extraStep * 3, extraY, ew5)
        end
    end
    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq[key .. "_a"] = (npc.data.T_dljq and npc.data.T_dljq[key .. "_a"]) and npc.data.T_dljq[key .. "_a"] or 0

        local task_cfg = npc._config and npc._config.task_cfg or {}
        local unlock_count = (type(task_cfg.unlock_maps) == "table" and #task_cfg.unlock_maps) or 0
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or npc._config.max_num or unlock_count or 1) or 1
        if unlock_count > 0 then
            max_num = unlock_count
        end
        local state = tonumber(npc.data.T_dljq[key] or 0) or 0
        local progress = tonumber(npc.data.T_dljq[key .. "_a"] or 0) or 0
        local reward_cfg = buildRewardWithTitle(npc._config)
        if reward_cfg and #reward_cfg > 0 then
            local jl = ItemNumByTable_img_new(reward_cfg, nil, GUI:Node_Create(node, "jl", 0, 0))
            GUI:setPosition(jl, reward_pos[1], reward_pos[2])
        end

        local cost_cfg = nil
        if type(task_cfg.submit) == "table" and #task_cfg.submit > 0 then
            cost_cfg = task_cfg.submit
        elseif type(task_cfg.upgrade_submit) == "table" and #task_cfg.upgrade_submit > 0 then
            cost_cfg = task_cfg.upgrade_submit
        elseif type(npc._config and npc._config.cost) == "table" and #(npc._config.cost) > 0 then
            cost_cfg = npc._config.cost
        end
        -- if cost_cfg then
        --     local cost = checkItemNumByTable_img_kuang(cost_cfg, nil, GUI:Node_Create(node, "cost", 0, 0))
        --     GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        -- end
        local kill_cur = tonumber(npc.data.sg_data[key] or 0) or 0
        local kill_need = tonumber(task_cfg.kill_count or 0) or 0
        if kill_need > 0 then
            local next_step = progress + 1
            if next_step < 1 then
                next_step = 1
            end
            if next_step > max_num then
                next_step = max_num
            end
            local need_total = kill_need * next_step
            local t = GUI:Text_Create(node, "progress", 100, 50, 20, "#808080", string.format("击杀 %d/%d", kill_cur, need_total))
            GUI:Text_setFontName(t, "fonts/500.ttf")
            GUI:Text_enableOutline(t, "#00FFFF", 2)
        end
        if max_num > 1 then
            -- local t2 = GUI:Text_Create(node, "step", 470, 176, 18, "#808080", string.format("解锁 %d/%d", progress, max_num))
            -- GUI:Text_setFontName(t2, "fonts/500.ttf")
            -- GUI:Text_enableOutline(t2, "#00FFFF", 2)
        end

        createActionButtons(node, state, progress, task_cfg.unlock_maps, npc.data.T_dljq)
    end

    if p2 == 0 then
        npc._config = teshudata[key]
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc._config = teshudata[key]
        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        npc.data.T_dljq[key .. "_a"] = tonumber(p3 or 0) or 0

        local task_cfg = npc._config and npc._config.task_cfg or {}
        local unlock_count = (type(task_cfg.unlock_maps) == "table" and #task_cfg.unlock_maps) or 0
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or npc._config.max_num or unlock_count or 1) or 1
        if unlock_count > 0 then
            max_num = unlock_count
        end
        if npc.data.T_dljq[key .. "_a"] >= max_num then
            npc.data.T_dljq[key] = 2
        elseif (tonumber(npc.data.T_dljq[key] or 0) or 0) < 1 then
            npc.data.T_dljq[key] = 1
        end

        UI_updata(npc.node)
    end
end

return npc
