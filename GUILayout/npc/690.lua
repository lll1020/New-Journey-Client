local npc = {}

npc._config = teshudata["npc_690"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/690_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_690"
local btn_pos = {620, 80}
local reward_pos = {360 - 70, 80}
local cost_pos = {520, 200}
local MAIN_BTN_SKIN = "res/public/1900000660.png"
local MAIN_BTN_SKIN_TAKE = nil
local MAIN_BTN_SKIN_DOING = nil
local EXTRA_BTN_SKIN = {}
local ACTIONS = {1}
local ACTION_LABEL = { [1] = "提交" }
local REQUIRED_TASKS = {
    {key = "npc_714", name = "屠龙宝刀"},
    {key = "npc_715", name = "围攻光明顶"},
    {key = "npc_716", name = "孤身战吕布"},
    {key = "npc_717", name = "火烧赤壁"},
    {key = "npc_718", name = "景阳冈打虎"},
    {key = "npc_719", name = "血溅狮子楼"},
}

local function createText(parent, name, x, y, size, color, text, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 22, color or "#FFFFFF", text or "")
    GUI:Text_setFontName(label, "fonts/502.ttf")
    GUI:Text_enableOutline(label, "#111111", 2)
    if ax ~= nil and ay ~= nil then
        GUI:setAnchorPoint(label, ax, ay)
    end
    return label
end

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

    local taskCfg = type(cfg and cfg.task_cfg) == "table" and cfg.task_cfg or {}
    if type(taskCfg.artifact_upgrade_item) == "string" and taskCfg.artifact_upgrade_item ~= "" then
        pushReward({taskCfg.artifact_upgrade_item, 1})
    elseif type(taskCfg.artifact_item) == "string" and taskCfg.artifact_item ~= "" then
        pushReward({taskCfg.artifact_item, 1})
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

local function buildTaskRewardText(cfg)
    local rewardList = buildRewardWithTitle(cfg)
    if type(rewardList) ~= "table" or #rewardList <= 0 then
        return ""
    end
    local parts = {}
    for _, entry in ipairs(rewardList) do
        local name = tostring(entry[1] or "")
        local count = tonumber(entry[2] or 1) or 1
        if name ~= "" then
            parts[#parts + 1] = string.format("%s*%d", name, count)
        end
    end
    return table.concat(parts, "  ")
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
    local function createActionButtons(node, state)
        local function resolveMainSkin()
            if state <= 0 and MAIN_BTN_SKIN_TAKE then
                return MAIN_BTN_SKIN_TAKE
            end
            if state == 1 and MAIN_BTN_SKIN_DOING then
                return MAIN_BTN_SKIN_DOING
            end
            if MAIN_BTN_SKIN == "res/public/1900000660.png" then
                return "res/custom/all_story_mission/2/btn_give.png"
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
                GUI:Button_setTitleFontName(btn, "fonts/502.ttf")
                GUI:Button_setTitleColor(btn, "#FFD685")
            end
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, npcid, ew, 0, "")
            end)
        end

        local ew1 = ACTIONS[1]
        if ew1 then
            if state >= 2 then
                GUI:Image_Create(node, "done", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
                createText(node, "done_text", btn_pos[1], btn_pos[2], 24, "#B8FFB8", "已完成", 0.5, 0.5)
            else
                local skin = resolveMainSkin()
                local b1 = GUI:Button_Create(node, "btn_action_1", btn_pos[1], btn_pos[2], skin)
                GUI:setAnchorPoint(b1, 0.5, 0.5)
                if skin == "res/public/1900000660.png" then
                    GUI:Button_setTitleText(b1, ACTION_LABEL[ew1] or ("操作" .. tostring(ew1)))
                    GUI:Button_setTitleFontSize(b1, 16)
                    GUI:Button_setTitleFontName(b1, "fonts/502.ttf")
                    GUI:Button_setTitleColor(b1, "#FFD685")
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
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or npc._config.max_num or 1) or 1
        local state = tonumber(npc.data.T_dljq[key] or 0) or 0
        local progress = tonumber(npc.data.T_dljq[key .. "_a"] or 0) or 0
        local reward_cfg = buildRewardWithTitle(npc._config)
        if reward_cfg and #reward_cfg > 0 then
            local jl = ItemNumByTable_img_new(reward_cfg, nil, GUI:Node_Create(node, "jl", 0, 0))
            GUI:setPosition(jl, reward_pos[1], reward_pos[2])
        end

        local list = GUI:ListView_Create(node, "task_list", 120, 145, 600, 240, 1)
        GUI:ListView_setItemsMargin(list, 54)
        GUI:ListView_setBounceEnabled(list, true)
        GUI:Image_Create(node, "fgx", 120, 145, "res/custom/all_story_mission/5/时空守护者/分割线-.png")

        GUI:Node_Create(list, "task_item_0", 0, 0)
        for i, info in ipairs(REQUIRED_TASKS) do
            local row = GUI:Node_Create(list, "task_item_" .. tostring(i), 0, 0)
            GUI:setContentSize(GUI:Image_Create(row, "box", 0, -10, "res/custom/five_city/sgshz/box.png"), 560, 62)

            local cfg = teshudata[info.key] or {}
            local taskName = cfg.name or info.name
            local rewardList = buildRewardWithTitle(cfg)
            local taskState = tonumber(npc.data.T_dljq[info.key] or 0) or 0
            local jdSkin = (taskState >= 2 and "rwjd_3") or (taskState >= 1 and "rwjd_2") or "rwjd_1"

            createText(row, "name", 15, 7, 24, "#63F7FF", taskName)
            if rewardList and #rewardList > 0 then
                local reward = ItemNumByTable_img_new(rewardList, nil, GUI:Node_Create(row, "reward", 195 + 70, 5))
                GUI:setScale(reward, 0.78)
            end
            GUI:Image_Create(row, "state", 430 + 30, 0, "res/wy/public/" .. jdSkin .. ".png")
        end

        createActionButtons(node, state)
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
        local max_num = tonumber(task_cfg.max_submit_times or task_cfg.max_reward_round or npc._config.max_num or 1) or 1
        if npc.data.T_dljq[key .. "_a"] >= max_num then
            npc.data.T_dljq[key] = 2
        elseif (tonumber(npc.data.T_dljq[key] or 0) or 0) < 1 then
            npc.data.T_dljq[key] = 1
        end

        UI_updata(npc.node)
    end
end

return npc
