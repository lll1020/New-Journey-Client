local npc = {}

npc._config = teshudata["npc_682"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/682_bg.png"},
    closeButton = {x = 747, y = 420},
}

local key = "npc_682"
local btn_pos = {620, 80}
local reward_pos = {360, 120}
local cost_pos = {500, 220}

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

    local function createStateButton(node, state)
        if state == 0 then
            local Button = GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif state == 1 then
            local Button = GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        else
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
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
        local state = tonumber(npc.data.T_dljq[key] or 0) or 0

        local reward_cfg = nil
        if type(npc._config and npc._config.rwjl) == "table" and #(npc._config.rwjl) > 0 then
            reward_cfg = npc._config.rwjl
        elseif type(npc._config and npc._config.jl) == "table" and #(npc._config.jl) > 0 then
            reward_cfg = npc._config.jl
        end
        if reward_cfg then
            local jl = ItemNumByTable_img_new(reward_cfg, nil, GUI:Node_Create(node, "jl", 0, 0))
            GUI:setPosition(jl, reward_pos[1], reward_pos[2])
        end

        local kill_cur = tonumber(npc.data.sg_data[key] or 0) or 0
        local kill_need = tonumber(task_cfg.kill_count or 0) or 0
        if kill_need > 0 and state > 0 then
            local t = GUI:Text_Create(node, "progress", 620, 250, 23, "#000000", string.format("当前击杀进度 %d/%d", kill_cur, kill_need))
            GUI:Text_setFontName(t, "fonts/501.ttf")
            GUI:Text_enableOutline(t, "#FFFFFF", 2)
        end

        if type(npc._config and npc._config.cost) == "table" and #(npc._config.cost) > 0 then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil, GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        local tip = GUI:Text_Create(node, "jl_tip", 410, 150, 26, "#FF0000", "解锁进入各灵兽秘境的权限")
        GUI:Text_setFontName(tip, "fonts/502.ttf")
        GUI:Text_enableOutline(tip, "#182918", 1)

        createStateButton(node, state)
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
