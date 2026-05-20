--功能:通天塔
local npc = {}

local RES = "res/custom/three_city/通天塔系列/"

local function _num(v, d)
    return tonumber(v or d or 0) or (d or 0)
end

local function _data()
    return (npc.sj or {}).data or {}
end

local function _cfg()
    return (npc.sj or {}).cfg or {}
end

local function _table_get(tbl, key)
    if type(tbl) ~= "table" then
        return nil
    end
    return tbl[key] or tbl[tostring(key)]
end

local function _points_text()
    return tostring(_num(_data().points))
end

local function _floor_text()
    local cfg = _cfg()
    local data = _data()
    local maxFloor = _num(cfg.max_floor, 10)
    local canResume = _num(data.in_run) == 1
        and _num(data.active_floor) <= 0
        and _num(data.run_floor) > 0
        and _num(data.run_floor) < maxFloor
    local nextFloor = canResume and (_num(data.run_floor) + 1) or 1
    return string.format("%d/%d", nextFloor, maxFloor)
end

local function _next_points()
    local data = _data()
    local cfg = _cfg()
    local canResume = _num(data.in_run) == 1 and _num(data.active_floor) <= 0 and _num(data.run_floor) > 0
    local nextFloor = canResume and (_num(data.run_floor) + 1) or 1
    nextFloor = math.min(nextFloor, _num(cfg.max_floor, 10))
    return _num(_table_get(cfg.floor_points, nextFloor))
end

local function _daily_left()
    local data = _data()
    local cfg = _cfg()
    local daily = data.daily or {}
    local freeLeft = math.max(_num(cfg.free_daily, 2) - _num(daily.free), 0)
    local paidLeft = math.max(_num(cfg.paid_daily, 1) - _num(daily.paid), 0)
    return freeLeft, paidLeft
end

local function _can_resume_run()
    local data = _data()
    local cfg = _cfg()
    return _num(data.in_run) == 1
        and _num(data.active_floor) <= 0
        and _num(data.run_floor) > 0
        and _num(data.run_floor) < _num(cfg.max_floor, 10)
end

local function _send_start_challenge(npcid, action)
    SL:SendLuaNetMsg(100, npcid, action or 1, 0, "")
    local parent = GUI:GetWindow(nil, "npc_" .. npcid)
    if parent then
        GUI:Win_Close(parent)
    end
end

local function _confirm_paid_start(npcid, action)
    SL:OpenCommonTipsPop({
        str = "免费挑战次数已用完，是否消耗500灵石额外挑战一次？",
        btnType = 2,
        callback = function(atype)
            if atype == 1 then
                _send_start_challenge(npcid, action)
            end
        end,
    })
end

local function _start_challenge_with_confirm(npcid)
    local freeLeft, paidLeft = _daily_left()
    if _can_resume_run() then
        local nextFloor = _num(_data().run_floor) + 1
        SL:OpenCommonTipsPop({
            str = "当前可从第" .. nextFloor .. "层继续挑战。确定继续？取消则从第1层重新开始并消耗一次挑战次数。",
            btnType = 2,
            callback = function(atype)
                if atype == 1 then
                    _send_start_challenge(npcid, 1)
                else
                    if freeLeft <= 0 and paidLeft > 0 then
                        _confirm_paid_start(npcid, 3)
                    else
                        _send_start_challenge(npcid, 3)
                    end
                end
            end,
        })
        return
    end
    if freeLeft <= 0 and paidLeft > 0 then
        _confirm_paid_start(npcid, 1)
        return
    end
    _send_start_challenge(npcid, 1)
end

local function _create_outline_text(parent, name, x, y, size, color, text)
    local node = GUI:Text_Create(parent, name, x, y, size, color, tostring(text or ""))
    GUI:Text_enableOutline(node, "#1B1008", 2)
    return node
end

local function _item_index(name)
    if not name or name == "" then
        return nil
    end
    return SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
end

local function _draw_item(parent, name, x, y, itemName, count)
    local box = GUI:Node_Create(parent, name, x, y)
    GUI:setAnchorPoint(box, 0.5, 0.5)
    local index = _item_index(itemName)
    if index then
        GUI:ItemShow_Create(box, name, 6, 6, {index = index, count = count or 1, look = true})
    else
        GUI:setAnchorPoint(_create_outline_text(box, name .. "_txt", 38, 36, 15, "#FFD37A", itemName or "称号"), 0.5, 0.5)
    end
    return box
end

local function _open_popup(npcid, idx)
    local parent = GUI:GetWindow(nil, "npc_xjm_" .. npcid)
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_xjm_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
    end
    local mask = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(mask, true)
    GUI:addOnClickEvent(mask, function()
        GUI:Win_Close(parent)
    end)

    local bj = nil
    if idx == 1 then
        bj = GUI:Image_Create(parent, "bj", 0, 0, RES .. "通天塔准则/通天塔准则.png")
        _create_outline_text(bj, "rule1", 430, 310, 22, "#F7E6B5", "每次挑战都从第1层开始，直到战败或通关为止")
        _create_outline_text(bj, "rule2", 430, 270, 22, "#F7E6B5", "每日免费爬塔2次，之后可花费500灵石额外挑战1次")
        _create_outline_text(bj, "rule3", 430, 230, 22, "#F7E6B5", "每次按本次爬到的层数结算通天积分，并记录历史最高层")
        local close = GUI:Button_Create(bj, "close", 430, 95, RES .. "通天塔准则/收下奖励.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
    elseif idx == 2 then
        bj = GUI:Image_Create(parent, "bj", 0, 0, RES .. "爬塔奖励/爬塔奖励.png")
        local cfg = _cfg()
        -- _create_outline_text(bj, "desc1", 450, 412, 22, "#3B1C0B", "通天塔每爬一层，奖励都会越来越丰富，同时怪物也会越强！")
        -- _create_outline_text(bj, "left_floor", 112, 342, 24, "#5B260B", "层数")
        -- _create_outline_text(bj, "left_reward", 112, 252, 24, "#5B260B", "奖励")
        for i = 1, _num(cfg.max_floor, 10) do
            local x = 178 + (i - 1) * 60 + 33
            -- _create_outline_text(bj, "floor_num" .. i, x, 342, 26 - 15, "#5B260B", i)
            _draw_item(bj, "point" .. i, x - 34, 255 - 15 -37, "通天\n积分", _num(_table_get(cfg.floor_points, i)))
            _create_outline_text(bj, "point_txt" .. i, x + 8, 205, 18, "#8A2100", "+" .. _num(_table_get(cfg.floor_points, i)))
        end
        -- _create_outline_text(bj, "tip_a", 240, 156, 20, "#3B1C0B", "每日可")
        -- _create_outline_text(bj, "tip_b", 302, 156, 20, "#FF0000", "免费爬塔两次")
        -- _create_outline_text(bj, "tip_c", 500, 156, 20, "#3B1C0B", "，两次之后可再次花费")
        -- _create_outline_text(bj, "tip_d", 646, 156, 20, "#FF0000", "500灵石")
        -- _create_outline_text(bj, "tip_e", 742, 156, 20, "#3B1C0B", "额外挑战一次！")
        -- _create_outline_text(bj, "tip_f", 450, 118, 20, "#3B1C0B", "每次爬塔按你所爬到的层数给你奖励")
        local close = GUI:Button_Create(bj, "close", 450, 42, RES .. "爬塔奖励/我知道了.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
    elseif idx == 3 then
        bj = GUI:Image_Create(parent, "bj", 0, 0, RES .. "奖励兑换/奖励兑换.png")
        local close = GUI:Button_Create(bj, "close", 800, 470, RES .. "关闭按钮.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        _create_outline_text(bj, "points", 450 + 160, 400, 22, "#00FF66", "当前通天积分：" .. _points_text())
        local list = GUI:ListView_Create(bj, "list", 86, 90 - 60, 760, 305, 1)
        local cfg = _cfg()
        local exchange = cfg.exchange or {}
        for i = 1, 5 do
            local e = _table_get(exchange, i)
            if e then
                local row = GUI:Layout_Create(list, "ex" .. i, 0, 0, 735, 60, 1)
                local rewardName = e.name or e.title or "奖励"
                local showItemName = e.title and (rewardName .. "[称号]") or rewardName
                _draw_item(row, "item" .. i, 48 - 24, 0, showItemName, e.count or 1)
                _create_outline_text(row, "name" .. i, 108 + 40, 0, 20, "#FFD37A", rewardName .. (e.count and ("×" .. e.count) or ""))
                _create_outline_text(row, "cost" .. i, 108 + 40, 25, 18, "#00FF66", "消耗通天积分：" .. tostring(e.cost or 0))
                local limitTxt = e.limit_type == "daily" and "每日限购：1" or "终身限购：1"
                _create_outline_text(row, "limit" .. i, 350 + 90, 10, 17, "#F7E6B5", limitTxt)
                -- if e.desc and e.desc ~= "" then
                --     _create_outline_text(row, "desc" .. i, 350, 25, 16, "#FFFFFF", e.desc)
                -- end
                local btn = GUI:Button_Create(row, "buy" .. i, 620 - 50, 2, RES .. "奖励兑换/兑换.png")
                GUI:addOnClickEvent(btn, function()
                    SL:SendLuaNetMsg(100, npcid, 2, i, "")
                    GUI:Win_Close(parent)
                end)
            end
        end
    end

    GUI:setAnchorPoint(bj, 0.5, 0.5)
    GUI:setTouchEnabled(bj, true)
end

function npc.main(npcid, link, msg, data)
    if link == 0 then
        npc.sj = SL:JsonDecode(data, false) or {}
        local parent = GUI:GetWindow(nil, "npc_" .. npcid)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_" .. npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, idx, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)

        npc.bj = GUI:Frames_Create(parent, "bg", 0, 0, RES .. "面板序列/通天塔序列/eff_", ".png", 1, 30, {count = 30, speed = 60, loop = 1})
        GUI:setAnchorPoint(npc.bj, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bj, true)
        -- GUI:Frames_Create(npc.bj, "start_eff", 0, 0, RES .. "面板序列/通天塔开头序列/eff_", ".png", 1, 75, {count = 75, speed = 45, loop = 0})

        local close = GUI:Button_Create(npc.bj, "close", 770, 443, RES .. "关闭按钮.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        local kstz = GUI:Button_Create(npc.bj, "kstz", 276, 5, RES .. "开始挑战.png")
        GUI:addOnClickEvent(kstz, function()
            _start_challenge_with_confirm(npcid)
        end)
        local freeLeft, paidLeft = _daily_left()

        local dq = GUI:Image_Create(npc.bj, "dq", 297, 215 + 60, "res/wy/public/npc_19_dq_wz.png")
        local jl = GUI:Image_Create(npc.bj, "jl", 297, 165 + 60, "res/wy/public/npc_19_jl_wz.png")
        local timesBg = GUI:Image_Create(npc.bj, "times", 297, 120, RES .. "挑战次数.png")
        
        GUI:setOpacity(dq, 0)
        GUI:setOpacity(jl, 0)
        GUI:setOpacity(timesBg, 0)
        
        GUI:Timeline_FadeIn(dq, 3, function()
            GUI:setAnchorPoint(_create_outline_text(dq, "floor", 218, 15, 20, "#F7F7DE", _floor_text()), 0.5, 0.5)
        end)
        GUI:Timeline_FadeIn(jl, 3, function()
            GUI:setAnchorPoint(_create_outline_text(jl, "reward", 218, 15, 20, "#00FF00", "+" .. _next_points() .. "积分"), 0.5, 0.5)
        end)
        GUI:Timeline_FadeIn(timesBg, 3, function()
            _create_outline_text(timesBg, "times_txt1", 135 + 108, 25 + 25, 22, "#FFFFFF", freeLeft)
            _create_outline_text(timesBg, "times_txt2", 135 + 108, 0, 22, "#FFFFFF",  paidLeft)
        end)

        
        
        -- _create_outline_text(npc.bj, "points", 430, 85, 20, "#00FF66", "通天积分：" .. _points_text())

        local btns = {
            {img = RES .. "通天塔奖励.png", idx = 2},
            {img = RES .. "奖励兑换.png", idx = 3},
        }
        for i, v in ipairs(btns) do
            local btn = GUI:Button_Create(npc.bj, "btn_" .. i, 628, 300 - (i - 1) * 80, v.img)
            GUI:addOnClickEvent(btn, function()
                _open_popup(npcid, v.idx)
            end)
        end
    end
end

return npc
