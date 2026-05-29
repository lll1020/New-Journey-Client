local Renderer = {}

local BASE = "res/custom/all_story_mission/6/"
local DEFAULT_BUTTON = "res/public/1900000660.png"
local COMPLETE_SKIN = "res/wy/public/7_1.png"

local function _toint(v, d)
    local n = tonumber(v)
    if n == nil then
        return d or 0
    end
    return math.floor(n)
end

local function _valid(node)
    return node and not (tolua and tolua.isnull and tolua.isnull(node))
end

local function _skin(path)
    if path and path ~= "" and (not SL or not SL.IsFileExist or SL:IsFileExist(path)) then
        return path
    end
    return nil
end

local function _asset(folder, fileName)
    if not folder or folder == "" or not fileName or fileName == "" then
        return nil
    end
    return _skin(BASE .. folder .. "/" .. fileName)
end

local function _copy_pos(pos, defaults)
    defaults = defaults or {}
    pos = pos or {}
    return {
        x = pos.x or pos[1] or defaults.x or defaults[1] or 390,
        y = pos.y or pos[2] or defaults.y or defaults[2] or 82,
        w = pos.w or pos.width or defaults.w or defaults.width or 226,
        h = pos.h or pos.height or defaults.h or defaults.height or 70,
        scale = pos.scale or defaults.scale,
    }
end

local function _create_text(parent, name, x, y, size, color, text, opts)
    opts = opts or {}
    local label = GUI:Text_Create(parent, name, x, y, size or 20, color or "#FFFFFF", tostring(text or ""))
    GUI:setAnchorPoint(label, opts.ax or 0.5, opts.ay or 0.5)
    if opts.font then
        GUI:Text_setFontName(label, opts.font)
    else
        GUI:Text_setFontName(label, "fonts/font4.ttf")
    end
    if opts.outline ~= false then
        GUI:Text_enableOutline(label, opts.outlineColor or "#000000", opts.outlineSize or 2)
    end
    return label
end

local function _normalize_items(items)
    if type(items) ~= "table" or #items <= 0 then
        return nil
    end
    local result = {}
    for _, item in ipairs(items) do
        if type(item) == "table" then
            result[#result + 1] = item
        elseif item and item ~= "" then
            result[#result + 1] = {tostring(item), 1}
        end
    end
    return #result > 0 and result or nil
end

local function _pick_items(cfg, source)
    cfg = cfg or {}
    local task = cfg.task_cfg or {}
    if source == "cost" or source == "submit" then
        return _normalize_items(task.submit or task.craft_cost or cfg.cost)
    end
    if source == "craft_cost" then
        return _normalize_items(task.craft_cost or task.submit or cfg.cost)
    end
    if source == "craft_reward" then
        return _normalize_items(task.craft_reward)
    end
    if source == "draw_pool" then
        return _normalize_items(task.draw_pool)
    end
    if source == "burn_rewards" then
        return _normalize_items(task.burn_rewards)
    end
    if source == "rwjl" then
        return _normalize_items(cfg.rwjl)
    end
    if source == "jl" then
        return _normalize_items(cfg.jl)
    end
    return _normalize_items(cfg.rwjl or cfg.jl or task.reward or task.rewards or task.craft_reward)
end

local function _actions(cfg)
    local task = (cfg and cfg.task_cfg) or {}
    if type(task.actions) == "table" then
        return task.actions
    end
    if task.task_type == "craft" or task.task_type == "weapon_craft" then
        return {[1] = "提交任务", [2] = "立即合成"}
    end
    if task.task_type == "kill_player_lottery" then
        return {[1] = "查看契约", [2] = "开始抽奖"}
    end
    if task.task_type == "weakness_dungeon" then
        return {[1] = "提交任务", [2] = "揭示弱点", [3] = "进入副本"}
    end
    return {[1] = "提交任务"}
end

local function _sorted_actions(actions)
    local list = {}
    for ew, label in pairs(actions or {}) do
        list[#list + 1] = {ew = _toint(ew), label = tostring(label or "")}
    end
    table.sort(list, function(a, b) return a.ew < b.ew end)
    return list
end

local function _default_button_pos(index, total)
    if total <= 1 then
        return {x = 390, y = 84, w = 226, h = 70}
    end
    if total == 2 then
        return index == 1 and {x = 300, y = 84, w = 180, h = 64} or {x = 505, y = 84, w = 226, h = 70}
    end
    return {x = 220 + (index - 1) * 170, y = 84, w = 170, h = 62}
end

local SPECS = {
    [721] = {folder = "天机道长", reward = {x = 182, y = 82, scale = 0.85}, buttons = {[1] = {x = 540, y = 150, w = 270, h = 62, text = "我该怎么做？", forceText = true}}},
    [722] = {folder = "星儿的玉佩", reward = {x = 180, y = 84}, cost = {x = 286, y = 205}, buttons = {[1] = {x = 290, y = 82}, [2] = {x = 505, y = 82, skin = "合成玉佩.png"}}},
    [723] = {folder = "凌雪", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [724] = {folder = "守城士兵甲", reward = {x = 182, y = 88}, buttons = {[1] = {x = 502, y = 82}}},
    [725] = {folder = "赤焰", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [726] = {folder = "幽影", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [728] = {
        folder = "恶魔契约",
        itemGroups = {{name = "draw_pool", source = "draw_pool", kind = "reward", x = 190, y = 154, scale = 0.82}},
        buttons = {[1] = {x = 410, y = 250, w = 220, h = 60, text = "奖励预览", forceText = true}, [2] = {x = 410, y = 82, skin = "开始抽奖.png"}},
        progress = "lottery",
    },
    [729] = {folder = "雪域特使", cost = {x = 286, y = 196}, buttons = {[1] = {x = 502, y = 82, skin = "立即激活.png"}}},
    [730] = {folder = "魔域特使", cost = {x = 286, y = 196}, buttons = {[1] = {x = 502, y = 82, skin = "立即激活.png"}}},
    [731] = {folder = "边关特使", cost = {x = 286, y = 196}, buttons = {[1] = {x = 502, y = 82, skin = "立即激活.png"}}},
    [732] = {folder = "古城特使", cost = {x = 286, y = 196}, buttons = {[1] = {x = 502, y = 82, skin = "立即激活.png"}}},
    [733] = {
        folder = "盛世重游",
        close = {x = 750, y = 414},
        images = {
            {name = "city_changan", skin = "长安.png", x = 148, y = 235},
            {name = "city_luoyang", skin = "洛阳.png", x = 314, y = 235},
            {name = "city_bianjing", skin = "汴京.png", x = 480, y = 235},
            {name = "city_linan", skin = "临安.png", x = 646, y = 235},
            {name = "submit_1", skin = "提交.png", x = 148, y = 126},
            {name = "submit_2", skin = "提交.png", x = 314, y = 126},
            {name = "submit_3", skin = "提交.png", x = 480, y = 126},
            {name = "submit_4", skin = "提交.png", x = 646, y = 126},
        },
        itemGroups = {{name = "reward", source = "jl", kind = "reward", x = 286, y = 48, scale = 0.82}},
        buttons = {[1] = {x = 600, y = 48, w = 250, h = 70, text = "领取奖励", forceText = true}},
    },
    [734] = {folder = "万国之首", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [735] = {folder = "洛水杜康", reward = {x = 178, y = 88}, cost = {x = 250, y = 202}, buttons = {[1] = {x = 285, y = 82}, [2] = {x = 505, y = 82}}},
    [736] = {folder = "大宋的菜肴", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [737] = {folder = "天青色的秘密", rewardSource = "burn_rewards", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82, skin = "开始烧制.png", visible = true}}},
    [738] = {folder = "密令护灵旗", reward = {x = 178, y = 88}, cost = {x = 260, y = 202}, buttons = {[1] = {x = 502, y = 82}}},
    [739] = {
        folder = "幽影的分身",
        itemGroups = {
            {name = "cost", source = "reveal_cost", kind = "cost", x = 275, y = 226, scale = 0.86},
            {name = "reward", source = "reward", kind = "reward", x = 178, y = 86, scale = 0.86},
        },
        buttons = {[1] = {x = 245, y = 236, w = 140, h = 56}, [2] = {x = 425, y = 82, skin = "揭示弱点.png"}, [3] = {x = 650, y = 82, skin = "进入副本.png"}},
    },
    [740] = {
        folder = "上古寒冰剑",
        itemGroups = {
            {name = "weapon", source = "craft_reward", kind = "reward", x = 590, y = 268, scale = 0.88},
            {name = "material", source = "craft_cost", kind = "cost", x = 480, y = 198, scale = 0.82},
            {name = "title", source = "rwjl", kind = "reward", x = 665, y = 136, scale = 0.78},
        },
        buttons = {[1] = {x = 688, y = 136, w = 86, h = 56}, [2] = {x = 410, y = 82, skin = "立即合成.png"}},
    },
}

local function _resolve_bg(spec)
    local main = _asset(spec.folder, (spec.folder or "") .. ".png")
    if main then
        return main, false
    end
    local demo = _asset(spec.folder, "示意图.png")
    if demo then
        return demo, true
    end
    return "", false
end

local function _render_images(node, spec)
    if type(spec.images) ~= "table" then
        return
    end
    for _, imgCfg in ipairs(spec.images) do
        local skin = _asset(spec.folder, imgCfg.skin)
        if skin then
            local img = GUI:Image_Create(node, imgCfg.name or imgCfg.skin, imgCfg.x or 0, imgCfg.y or 0, skin)
            GUI:setAnchorPoint(img, imgCfg.ax or 0.5, imgCfg.ay or 0.5)
            if imgCfg.scale then
                GUI:setScale(img, imgCfg.scale)
            end
        end
    end
end

local function _render_item_group(node, cfg, group)
    local source = group.source or (group.kind == "cost" and "cost" or "reward")
    local items
    if source == "reveal_cost" then
        items = _normalize_items(((cfg.task_cfg or {}).reveal_cost))
    else
        items = _pick_items(cfg, source)
    end
    if not items then
        return
    end
    local root = GUI:Node_Create(node, group.name or source, 0, 0)
    local widget
    if group.kind == "cost" then
        widget = checkItemNumByTable_img_kuang(items, nil, root)
    else
        widget = ItemNumByTable_img_new(items, nil, root)
    end
    if widget then
        GUI:setPosition(widget, group.x or 180, group.y or 90)
        if group.scale then
            GUI:setScale(widget, group.scale)
        end
    end
end

local function _render_items(node, cfg, spec)
    if type(spec.itemGroups) == "table" then
        for _, group in ipairs(spec.itemGroups) do
            _render_item_group(node, cfg, group)
        end
        return
    end
    local rewardSource = spec.rewardSource or "reward"
    if spec.reward ~= false then
        local pos = spec.reward or {x = 178, y = 88}
        _render_item_group(node, cfg, {name = "reward", source = rewardSource, kind = "reward", x = pos.x or pos[1], y = pos.y or pos[2], scale = pos.scale})
    end
    if spec.cost ~= false then
        local pos = spec.cost or {x = 260, y = 202}
        _render_item_group(node, cfg, {name = "cost", source = "cost", kind = "cost", x = pos.x or pos[1], y = pos.y or pos[2], scale = pos.scale})
    end
end

local function _render_progress(node, key, data, cfg, spec)
    local task = cfg.task_cfg or {}
    if spec.progress == "lottery" then
        local story = data.T_dljq or {}
        local kill = _toint(story[key .. "_kill"])
        local draw = _toint(story[key .. "_draw"])
        _create_text(node, "lottery_kill", 392, 432, 20, "#FFE7B0", tostring(kill), {outlineColor = "#280000"})
        _create_text(node, "lottery_draw", 607, 432, 20, "#FFE7B0", tostring(draw), {outlineColor = "#280000"})
        return
    end
    local need = _toint(task.kill_count)
    if need <= 0 then
        return
    end
    local cur = _toint((data.sg_data or {})[key])
    local pos = spec.progressPos or {x = 500, y = 168}
    _create_text(node, "progress", pos.x or pos[1], pos.y or pos[2], 20, "#FFE7B0", string.format("%d/%d", cur, need), {outlineColor = "#190B05"})
end

local function _button_skin(spec, actionSpec, label)
    if actionSpec and actionSpec.skin then
        return _asset(spec.folder, actionSpec.skin) or _skin(actionSpec.skin)
    end
    local byLabel = _asset(spec.folder, tostring(label or "") .. ".png")
    if byLabel then
        return byLabel
    end
    return DEFAULT_BUTTON
end

local function _make_touch(parent, name, pos, callback)
    local touch = GUI:Layout_Create(parent, name, pos.x - pos.w / 2, pos.y - pos.h / 2, pos.w, pos.h, false)
    GUI:setTouchEnabled(touch, true)
    GUI:addOnClickEvent(touch, callback)
    return touch
end

local function _render_buttons(node, npcid, key, data, cfg, spec, useDemo)
    local state = _toint((data.T_dljq or {})[key])
    local list = _sorted_actions(_actions(cfg))
    for idx, action in ipairs(list) do
        local actionSpec = (spec.buttons or {})[action.ew] or {}
        if not actionSpec.hidden then
            local pos = _copy_pos(actionSpec, _default_button_pos(idx, #list))
            local function send()
                SL:SendLuaNetMsg(100, npcid, action.ew, 0, "")
            end
            if state >= 2 and action.ew == 1 then
                local completeSkin = _asset(spec.folder, "已提交.png") or COMPLETE_SKIN
                local done = GUI:Image_Create(node, "done_" .. action.ew, pos.x, pos.y, completeSkin)
                GUI:setAnchorPoint(done, 0.5, 0.5)
                _make_touch(node, "btn_done_" .. action.ew, pos, send)
            elseif (useDemo and actionSpec.visible ~= true) or actionSpec.transparent then
                _make_touch(node, "btn_" .. action.ew, pos, send)
            else
                local skin = _button_skin(spec, actionSpec, action.label)
                local btn = GUI:Button_Create(node, "btn_" .. action.ew, pos.x, pos.y, skin)
                GUI:setAnchorPoint(btn, 0.5, 0.5)
                if skin == DEFAULT_BUTTON or actionSpec.forceText then
                    GUI:Button_setTitleText(btn, actionSpec.text or action.label)
                    GUI:Button_setTitleFontSize(btn, actionSpec.fontSize or 18)
                end
                if pos.scale then
                    GUI:setScale(btn, pos.scale)
                end
                GUI:addOnClickEvent(btn, send)
            end
        end
    end
end

function Renderer.create(npcid)
    local id = _toint(npcid)
    local key = "npc_" .. tostring(id)
    local spec = SPECS[id] or {folder = tostring(id)}
    local npc = {_config = teshudata[key]}

    local function cfg()
        npc._config = teshudata[key] or npc._config or {}
        return npc._config
    end

    local function ensure_window()
        local bgSkin, useDemo = _resolve_bg(spec)
        npc._useDemo = useDemo
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, id, {
            background = {skin = bgSkin},
            closeButton = spec.close or {x = 747, y = 380},
        })
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function render()
        if not _valid(npc.node) then
            ensure_window()
        end
        local node = npc.node
        if not _valid(node) then
            return
        end
        GUI:removeAllChildren(node)
        local curCfg = cfg()
        npc.data = npc.data or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        _render_images(node, spec)
        _render_items(node, curCfg, spec)
        _render_progress(node, key, npc.data, curCfg, spec)
        _render_buttons(node, id, key, npc.data, curCfg, spec, npc._useDemo)
    end

    function npc.main(_npcid, p2, _p3, msgData)
        if p2 == 0 then
            npc.data = SL:JsonDecode(msgData, false) or {}
            npc.data.T_dljq = npc.data.T_dljq or {}
            npc.data.sg_data = npc.data.sg_data or {}
            ensure_window()
            render()
            return
        end
        local decoded = SL:JsonDecode(msgData, false)
        if type(decoded) == "table" then
            npc.data = decoded
        else
            npc.data = npc.data or {}
        end
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        render()
    end

    return npc
end

return Renderer
