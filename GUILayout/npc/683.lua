local npc = {}

npc._config = teshudata["npc_683"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/683_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_683"
local btn_pos = {620, 80}
local reward_pos = {360, 120}
local cost_pos = {520, 200}

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

    local function getNeedSywName(task_cfg)
        local need_ls_name = task_cfg and task_cfg.need_lingshou_name or ""
        local ls_cfg = teshudata["npc_64"]
        local ls_list = ls_cfg and ls_cfg.config and ls_cfg.config.ls
        if type(ls_list) == "table" then
            for _, ls in ipairs(ls_list) do
                if ls and ls.name == need_ls_name then
                    return ls.syw or ""
                end
            end
        end
        return ""
    end
    local function createStateButton(node)
        local Button = GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/5/683_btn.png")
        GUI:setAnchorPoint(Button, 0.5, 0.5)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
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
        local need_syw_name = getNeedSywName(task_cfg)
        if need_syw_name ~= "" then
            local syw_item = ItemNumByTable_img_new({{need_syw_name, 1}}, nil, GUI:Node_Create(node, "need_syw_item", 0, 0))
            GUI:setPosition(syw_item, 560 - 160, 126 + 82)
        end

        createStateButton(node)
    end

    if p2 == 0 then
        npc._config = teshudata[key]
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc