local npc = {}

npc._config = teshudata["npc_696"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/696_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_696"
local btn_pos = {620, 80}
local reward_pos = {360 + 136, 127}
local cost_pos = {520, 200}
local MAIN_BTN_SKIN = "res/custom/all_story_mission/5/696_btn.png"
local MAIN_BTN_SKIN_TAKE = nil
local MAIN_BTN_SKIN_DOING = nil
local EXTRA_BTN_SKIN = {}
local ACTIONS = {1}
local ACTION_LABEL = { [1] = "前进" }
local RUNNER_SKIN = "res/custom/all_story_mission/5/rw.png"
local GRID_POS = {
    [0] = {x = 119 + 30, y = 208 + 150},
    [1] = {x = 172 + 30, y = 149 + 150},
    [2] = {x = 266 + 30, y = 203 + 150},
    [3] = {x = 220 + 30, y = 257 + 150},
    [4] = {x = 300, y = 309 + 150},
    [5] = {x = 390, y = 286 + 150},
    [6] = {x = 462 - 10, y = 255 + 150},
    [7] = {x = 462 - 10, y = 185 + 150},
    [8] = {x = 390 - 20, y = 149 + 150},
    [9] = {x = 563 - 50, y = 149 + 150},
    [10] = {x = 635 - 40, y = 185 + 150},
    [11] = {x = 637 - 40, y = 252 + 150},
    [12] = {x = 560 - 40, y = 294 + 150},
}
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
    local function ensureLayers(node)
        if not node then
            return
        end
        npc.rewardLayer = npc.rewardLayer or GUI:Node_Create(node, "reward_layer", 0, 0)
        npc.infoLayer = npc.infoLayer or GUI:Node_Create(node, "info_layer", 0, 0)
        npc.runnerLayer = npc.runnerLayer or GUI:Node_Create(node, "runner_layer", 0, 0)
        npc.buttonLayer = npc.buttonLayer or GUI:Node_Create(node, "button_layer", 0, 0)
    end
    local function renderRewardLayer()
        if not npc.rewardLayer then
            return
        end
        GUI:removeAllChildren(npc.rewardLayer)
        local reward_cfg = buildRewardWithTitle(npc._config)
        if reward_cfg and #reward_cfg > 0 then
            local jl = ItemNumByTable_img_new(reward_cfg, nil, GUI:Node_Create(npc.rewardLayer, "jl", 0, 0))
            GUI:setPosition(jl, reward_pos[1], reward_pos[2])
        end
    end
    local function setRunnerPosition(grid_idx, animate_from_idx)
        if not npc.runnerLayer then
            return
        end
        local runner_pos = GRID_POS[grid_idx]
        if not runner_pos then
            return
        end
        if not npc.runner then
            GUI:removeAllChildren(npc.runnerLayer)
            npc.runner = GUI:Image_Create(npc.runnerLayer, "runner", runner_pos.x, runner_pos.y, RUNNER_SKIN)
            GUI:setAnchorPoint(npc.runner, 0.5, 0.5)
            return
        end
        if animate_from_idx ~= nil and animate_from_idx ~= grid_idx and GRID_POS[animate_from_idx] then
            local from_pos = GRID_POS[animate_from_idx]
            GUI:setPosition(npc.runner, from_pos.x, from_pos.y)
            GUI:runAction(npc.runner, GUI:ActionMoveTo(0.2, runner_pos.x, runner_pos.y))
            return
        end
        GUI:setPosition(npc.runner, runner_pos.x, runner_pos.y)
    end
    local function renderInfoLayer(progress, max_num, kill_cur, per)
        if not npc.infoLayer then
            return
        end
        GUI:removeAllChildren(npc.infoLayer)
        local need = per * (progress + 1)
        local total = per * max_num
        if need > total then
            need = total
        end
        if per > 0 then
            local t = GUI:Text_Create(npc.infoLayer, "progress", 470 + 170, 200 + 60, 20, "#081800", string.format("当前击杀： %d", kill_cur, need))
            GUI:Text_setFontName(t, "fonts/502.ttf")
            GUI:Text_enableOutline(t, "#FFFFFF", 2)
            local t2 = GUI:Text_Create(npc.infoLayer, "step", 470 + 170, 176 + 60, 18, "#081800", string.format("步数： %d/%d", progress, max_num))
            GUI:Text_setFontName(t2, "fonts/502.ttf")
            GUI:Text_enableOutline(t2, "#FFFFFF", 2)
        end
    end
    -- 操作按钮渲染：主按钮按任务状态切换，副按钮按动作号映射。
    local function createActionButtons(node, state)
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
            local skin = EXTRA_BTN_SKIN[ew] or "res/public/1900000660.png"
            local btn = GUI:Button_Create(node, nodeName, x, y, skin)
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

        local extraStartX = 260
        local extraY = 40
        local extraStep = 120

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
    local function UI_updata(node, animate_from_idx)
        if not node then
            return
        end

        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq[key .. "_a"] = (npc.data.T_dljq and npc.data.T_dljq[key .. "_a"]) and npc.data.T_dljq[key .. "_a"] or 0

        local task_cfg = npc._config and npc._config.task_cfg or {}
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or task_cfg.grid_goal or npc._config.max_num or 1) or 1
        local state = tonumber(npc.data.T_dljq[key] or 0) or 0
        local progress = tonumber(npc.data.T_dljq["npc696_pos"] or 0) or 0
        local grid_idx = progress
        if grid_idx < 0 then
            grid_idx = 0
        elseif grid_idx > max_num then
            grid_idx = max_num
        end

        local kill_cur = tonumber(npc.data.sg_data[key] or 0) or 0
        local per = tonumber(task_cfg.kill_per_step or 0) or 0

        renderInfoLayer(progress, max_num, kill_cur, per)
        setRunnerPosition(grid_idx, animate_from_idx)
        GUI:removeAllChildren(npc.buttonLayer)
        createActionButtons(npc.buttonLayer, state)
        npc._grid_idx = grid_idx
    end

    if p2 == 0 then
        npc._config = teshudata[key]
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        ensureWindow(npcid)
        GUI:removeAllChildren(npc.node)
        npc.rewardLayer = nil
        npc.infoLayer = nil
        npc.runnerLayer = nil
        npc.buttonLayer = nil
        npc.runner = nil
        ensureLayers(npc.node)
        renderRewardLayer()
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc._config = teshudata[key]
        local old_grid_idx = npc._grid_idx
        local patchData = SL:JsonDecode(msgData, false) or {}
        npc.data = npc.data or {}
        npc.data.T_dljq = patchData.T_dljq or npc.data.T_dljq or {}
        npc.data.sg_data = patchData.sg_data or npc.data.sg_data or {}
        if tonumber(p3 or 0) then
            npc.data.T_dljq["npc696_pos"] = tonumber(p3 or 0) or 0
        end

        local task_cfg = npc._config and npc._config.task_cfg or {}
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or task_cfg.grid_goal or npc._config.max_num or 1) or 1
        local moves = tonumber(npc.data.T_dljq["npc696_move"] or npc.data.T_dljq[key .. "_a"] or 0) or 0
        npc.data.T_dljq[key .. "_a"] = moves
        if moves >= max_num then
            npc.data.T_dljq[key] = 2
        elseif (tonumber(npc.data.T_dljq[key] or 0) or 0) < 1 then
            npc.data.T_dljq[key] = 1
        end

        ensureLayers(npc.node)
        UI_updata(npc.node, old_grid_idx)
    end
end

return npc
