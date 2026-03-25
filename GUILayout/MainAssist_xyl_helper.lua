local MainAssistXylHelper = {}

-- 备注：伏妖录当前任务变更事件名。
MainAssistXylHelper.EVENT_CURRENT_TASK_CHANGE = "伏妖录当前任务变更"

local DETAIL_POPUP_DEFAULT_POS = {x = 220, y = 0}

-- 备注：给任务栏挂载伏妖录当前任务的通用逻辑。
function MainAssistXylHelper.bind(MainAssist)
    if type(MainAssist) ~= "table" then
        return
    end
    if MainAssist._xylHelperBound then
        return
    end
    MainAssist._xylHelperBound = true

    MainAssist._xylTaskNameMap = nil
    MainAssist._xylTaskDqMap = nil
    MainAssist._xylTaskInfoMap = nil
    MainAssist._xylTaskData = nil
    MainAssist._xylCurrentTask = nil
    MainAssist._xylDetailPopupPos = nil

    -- 备注：伏妖录任务联调用日志，便于确认任务事件和服务端变量是否真正触发。
    local function _debug_xyl_trace(tag, data)
        local msg = {
            tag = tag,
            key = type(data) == "table" and tostring(data.key) or "nil",
            type = type(data) == "table" and tostring(data.type) or "nil",
            taskid = type(data) == "table" and tostring(data.taskid) or "nil",
            dq = type(data) == "table" and tostring(data.dq or (type(data.ywl) == "table" and data.ywl.dq) or "") or "",
            dq_id = type(data) == "table" and tostring(data.dq_id or "") or "",
        }
        SL:release_print(string.format(
            "[伏妖录调试] %s key=%s type=%s taskid=%s dq=%s dq_id=%s",
            msg.tag,
            msg.key,
            msg.type,
            msg.taskid,
            msg.dq,
            msg.dq_id
        ))
    end

    function MainAssist.DebugXylTrace(tag, data)
        _debug_xyl_trace(tag, data)
    end

    -- 备注：构建伏妖录任务映射。
    -- nameMap：任务 ID -> 伏妖录显示名。
    -- dqMap：服务端当前任务标记 dq(i_j_z) -> 伏妖录显示名。
    local function _build_xyl_task_maps()
        if MainAssist._xylTaskNameMap and MainAssist._xylTaskDqMap and MainAssist._xylTaskInfoMap then
            return MainAssist._xylTaskNameMap, MainAssist._xylTaskDqMap, MainAssist._xylTaskInfoMap
        end

        local nameMap = {}
        local dqMap = {}
        local infoMap = {}
        local ok, xyl = pcall(function()
            return SL:Require("GUILayout/Data/xyl.lua", true)
        end)
        if ok and type(xyl) == "table" then
            MainAssist._xylTaskData = xyl
            for i = 2, #xyl do
                local lCfg = xyl[i]
                if type(lCfg) == "table" then
                    for j = 1, #lCfg do
                        local chapter = lCfg[j]
                        local jq = chapter and chapter.jq
                        if type(jq) == "table" then
                            for z, task in ipairs(jq) do
                                if type(task) == "table" then
                                    local taskName = tostring(task[1] or "")
                                    local dqKey = string.format("%d_%d_%d", i, j, z)
                                    dqMap[dqKey] = taskName
                                    infoMap[dqKey] = {
                                        name = taskName,
                                        i = i,
                                        j = j,
                                        z = z,
                                        task = task,
                                    }
                                    local tk = type(task.tk) == "string" and task.tk:match("^npc_(%d+)$") or nil
                                    if tk then
                                        nameMap[tonumber(tk)] = taskName
                                    end
                                    local ydNpcId = task.yd and tonumber(task.yd[3]) or nil
                                    if ydNpcId and ydNpcId > 0 and not nameMap[ydNpcId] then
                                        nameMap[ydNpcId] = taskName
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        MainAssist._xylTaskNameMap = nameMap
        MainAssist._xylTaskDqMap = dqMap
        MainAssist._xylTaskInfoMap = infoMap
        return nameMap, dqMap, infoMap
    end

    -- 备注：读取服务端下发的当前伏妖录任务 dq 标记。
    -- 优先读取任务数据本身；若任务数据未携带，则读取最近一次 101,11,9 广播缓存。
    local function _get_xyl_task_dq(data)
        if type(data) ~= "table" then
            data = {}
        end

        local dq = data.dq
            or data.current_xyl_dq
            or data.currentXylDq
            or data.ywl_dq
            or data.ywlDq

        if not dq and type(data.ywl) == "table" then
            dq = data.ywl.dq
                or data.ywl.current_xyl_dq
                or data.ywl.currentXylDq
        end

        if not dq then
            local cached = MainAssist._xylCurrentTask
            dq = cached and (cached.dq or cached.current_xyl_dq or cached.currentXylDq) or nil
        end

        if type(dq) ~= "string" or dq == "" then
            return nil
        end
        return dq
    end

    -- 备注：读取当前伏妖录任务 ID。
    -- 优先使用任务数据本身；若任务数据里没有，则读取最近一次 101,11,9 广播缓存。
    local function _get_xyl_task_id(data)
        if type(data) ~= "table" then
            data = {}
        end

        local xylTaskId = tonumber(
            data.xyl_task_id
            or data.xylTaskId
            or data.current_xyl_task_id
            or data.currentXylTaskId
            or data.dq_id
            or data.ywl_task_id
            or data.ywlTaskId
        )
        if xylTaskId then
            return xylTaskId
        end

        local cached = MainAssist._xylCurrentTask or {}

        return tonumber(
            cached.xyl_task_id
            or cached.xylTaskId
            or cached.current_xyl_task_id
            or cached.currentXylTaskId
            or cached.dq_id
            or cached.ywl_task_id
            or cached.ywlTaskId
        )
    end

    -- 备注：解析当前伏妖录任务配置，供任务名显示与“立即前往”按钮复用。
    local function _get_xyl_current_task_info(data)
        local _, _, infoMap = _build_xyl_task_maps()
        local dq = _get_xyl_task_dq(data)
        if dq and infoMap[dq] then
            return infoMap[dq]
        end
        return nil
    end

    -- 备注：点击“立即前往”时复用伏妖录原本的前往逻辑。
    local function _go_to_current_xyl_task()
        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            SL:ShowSystemTips("当前没有可前往的伏妖录任务")
            return
        end

        local task = info.task or {}
        local enable = (task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
        SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
            string.format('{"i":%d,"j":%d,"k":0,"z":%d}', info.i, info.j, info.z))
    end

    -- 备注：获取当前伏妖录任务的简介文本，保持与伏妖录配置同源。
    local function _get_xyl_current_task_desc(task)
        if type(task) ~= "table" then
            return "暂无任务简介"
        end

        _build_xyl_task_maps()

        local xylData = MainAssist._xylTaskData
        if type(xylData) == "table" and type(xylData.build_task_desc) == "function" then
            local ok, builtDesc = pcall(xylData.build_task_desc, task)
            if ok and type(builtDesc) == "string" and builtDesc ~= "" then
                return builtDesc
            end
        end

        return tostring(task.desc or task.wz or "暂无任务简介")
    end

    -- 备注：关闭当前任务详情弹层。
    local function _close_current_xyl_detail()
        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            MainAssist._xylDetailPopupPos = GUI:getPosition(MainAssist._xylDetailPopup.root)
            GUI:removeFromParent(MainAssist._xylDetailPopup.root)
        end
        MainAssist._xylDetailPopup = nil
    end

    -- 备注：局部刷新当前伏妖录任务详情弹层内容，避免整层重建。
    local function _refresh_xyl_detail_popup_content()
        local popup = MainAssist._xylDetailPopup
        if not (popup and popup.root and popup.descHost) then
            return
        end

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            _close_current_xyl_detail()
            return
        end

        local taskDesc = _get_xyl_current_task_desc(info.task)
        GUI:removeAllChildren(popup.descHost)

        local okDesc, descNode = pcall(function()
            return GUI:RichText_Create(popup.descHost, "desc", 0, -6, taskDesc, 168, 14, "#f7f7de", 3, nil, nil)
        end)
        if okDesc and descNode then
            GUI:setAnchorPoint(descNode, 0, 1)
        else
            local plain = GUI:Text_Create(popup.descHost, "desc_plain", 0, -6, 16, "#f7f7de", taskDesc)
            GUI:setAnchorPoint(plain, 0, 1)
        end
    end

    -- 备注：点击“任务详情”时显示类似 ensure_cover 的任务介绍层。
    local function _open_current_xyl_detail()
        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        if not info then
            SL:ShowSystemTips("当前没有可查看的伏妖录任务")
            return
        end

        _close_current_xyl_detail()

        local parent = MainAssist._ui and MainAssist._ui["Panel_content"]
        if not parent then
            return
        end

        local root = GUI:Node_Create(parent, "Panel_ywl_detail_popup", DETAIL_POPUP_DEFAULT_POS.x, DETAIL_POPUP_DEFAULT_POS.y)
        GUI:setLocalZOrder(root, 99999)

        local bg = GUI:Image_Create(root, "bg", -10, 10, "res/wy/public/500-300.png")
        GUI:setContentSize(bg, 196, 182)
        GUI:setIgnoreContentAdaptWithSize(bg, false)
        GUI:setAnchorPoint(bg, 0, 1)
        bind_drag_popup_memory(bg, root, MainAssist, "_xylDetailPopupPos", DETAIL_POPUP_DEFAULT_POS)

        local desc = GUI:Text_Create(bg, "desc_wz", 12, 82 + 71, 18, "#FFFFFF", "任务简介")
        GUI:Text_enableUnderline(desc)
        GUI:Text_setFontName(desc, "fonts/448.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)
        GUI:Text_Create(bg, "desc_wz_tip", 12 + 100, 82 + 71, 18, "#00FF00", "(可拖动)")


        MainAssist._xylDetailPopup = {
            root = root,
            bg = bg,
            descHost = desc,
        }
        _refresh_xyl_detail_popup_content()
    end

    -- 备注：在任务栏底部显示当前伏妖录任务名、“任务详情”和“立即前往”按钮。
    local function _ensure_xyl_current_widget()
        if MainAssist._xylCurrentWidget then
            return MainAssist._xylCurrentWidget
        end

        local assistUi = GUI:ui_delegate(MainAssist._ui["Panel_assist"])
        local parent = assistUi and assistUi.Panel_content or GUI:getChildByName(MainAssist._ui["Panel_assist"], "Panel_content")
        if not parent then
            return nil
        end

        local panel = GUI:Layout_Create(parent, "Panel_ywl_current", 1, 2, 200, 38, false)
        GUI:setLocalZOrder(panel, 999)
        GUI:setTouchEnabled(panel, true)

        local title = GUI:Text_Create(panel, "title", -5, 114, 16, "#F4E7B5", "当前任务：")
        GUI:setAnchorPoint(title, 0, 0.5)
        GUI:Text_enableOutline(title, "#110b05", 2)

        local nameText = GUI:Text_Create(panel, "name", 65, 114, 16, "#FFFFFF", "")
        GUI:setAnchorPoint(nameText, 0, 0.5)
        GUI:Text_enableOutline(nameText, "#110b05", 2)

        local rewardTitle = GUI:Text_Create(panel, "reward", 0, 70, 16, "#FF00FF", "剧情\n奖励")
        GUI:setAnchorPoint(rewardTitle, 0, 0.5)
        GUI:Text_enableOutline(rewardTitle, "#110b05", 2)

        local rewardRoot = GUI:Node_Create(panel, "reward_root", 55, 45)

        local detailBtn = GUI:Button_Create(panel, "detail_btn", 5, 19, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(detailBtn, 0, 0.5)
        GUI:Button_setTitleText(detailBtn, "任务详情")
        GUI:Button_setTitleColor(detailBtn, "#F4E7B5")
        GUI:Button_setTitleFontSize(detailBtn, 14)
        GUI:Button_titleEnableOutline(detailBtn, "#110b05", 2)

        GUI:addOnClickEvent(detailBtn, function()
            if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
                _close_current_xyl_detail()
            else
                _open_current_xyl_detail()
            end
        end)

        local goBtn = GUI:Button_Create(panel, "go_btn", 145, 19, "res/wy/public/kb_btn.png")
        GUI:setAnchorPoint(goBtn, 0.5, 0.5)
        GUI:Button_setTitleText(goBtn, "立即前往")
        GUI:Button_setTitleColor(goBtn, "#F4E7B5")
        GUI:Button_setTitleFontSize(goBtn, 14)
        GUI:Button_titleEnableOutline(goBtn, "#110b05", 2)
        GUI:addOnClickEvent(goBtn, function()
            _go_to_current_xyl_task()
        end)

        MainAssist._xylCurrentWidget = {
            panel = panel,
            nameText = nameText,
            rewardRoot = rewardRoot,
            rewardNode = nil,
            detailBtn = detailBtn,
            goBtn = goBtn,
        }
        return MainAssist._xylCurrentWidget
    end

    -- 备注：刷新任务栏底部的当前伏妖录任务显示。
    function MainAssist.UpdateCurrentXylTaskWidget()
        local widget = _ensure_xyl_current_widget()
        if not widget then
            return
        end

        local info = _get_xyl_current_task_info(MainAssist._xylCurrentTask)
        local hasTask = info and info.name and info.name ~= ""
        GUI:setVisible(widget.panel, hasTask)
        if not hasTask then
            _close_current_xyl_detail()
            if widget.rewardNode then
                GUI:removeFromParent(widget.rewardNode)
                widget.rewardNode = nil
            end
            if MainAssist.ListView_mission then
                GUI:setContentSize(MainAssist.ListView_mission, 200, 185)
                GUI:setPosition(MainAssist.ListView_mission, 101, 94)
            end
            return
        end

        GUI:Text_setString(widget.nameText, tostring(info.name))
        if widget.rewardNode then
            GUI:removeFromParent(widget.rewardNode)
            widget.rewardNode = nil
        end

        local rewardData = (type(info.task) == "table" and type(info.task.jl) == "table") and info.task.jl or {}
        if #rewardData > 0 then
            local okReward, rewardNode = pcall(function()
                return ItemNumByTable_img_new(rewardData, nil, widget.rewardRoot)
            end)
            if okReward and rewardNode then
                GUI:setPosition(rewardNode, 0, 0)
                widget.rewardNode = rewardNode
            end
        end

        if MainAssist.ListView_mission then
            GUI:setContentSize(MainAssist.ListView_mission, 200, 145)
            GUI:setPosition(MainAssist.ListView_mission, 101, 114)
        end
    end

    -- 备注：主任务 22 为异闻录时，打印当前进行中的伏妖录任务名，方便联调。
    -- 判定顺序：优先读显式任务 ID；若服务端仍使用 dq，则按 dq 反查伏妖录配置。
    function MainAssist.PrintXylTaskName(data)
        if type(data) ~= "table" or tonumber(data.taskid) ~= 22 then
            return
        end

        _debug_xyl_trace("打印当前任务", data)
        local xylNameMap, xylDqMap = _build_xyl_task_maps()
        local xylTaskId = _get_xyl_task_id(data)

        local taskName = xylTaskId and xylNameMap[xylTaskId] or nil
        if not taskName and xylTaskId then
            local cfg = teshudata and teshudata["npc_" .. tostring(xylTaskId)]
            taskName = cfg and cfg.name or ("npc_" .. tostring(xylTaskId))
        end

        local xylTaskDq = _get_xyl_task_dq(data)
        if not taskName and xylTaskDq then
            taskName = xylDqMap[xylTaskDq]
        end

        if not taskName then
            SL:release_print(string.format("[伏妖录调试] 未匹配到任务名 taskId=%s dq=%s", tostring(xylTaskId), tostring(xylTaskDq)))
            return
        end

        if xylTaskId then
            SL:release_print(string.format("[伏妖录] 当前任务：%s（%d）", tostring(taskName), xylTaskId))
        elseif xylTaskDq then
            SL:release_print(string.format("[伏妖录] 当前任务：%s（%s）", tostring(taskName), xylTaskDq))
        end
    end

    -- 备注：收到服务端 101,11,9 下发的当前伏妖录任务后，缓存并刷新任务栏显示。
    function MainAssist.RefreshXylTaskOnCurrentChange(data)
        if type(data) ~= "table" then
            return
        end
        MainAssist._xylCurrentTask = data
        _close_current_xyl_detail()
        _debug_xyl_trace("当前任务变更", data)
        MainAssist.UpdateCurrentXylTaskWidget()
        for _, cell in pairs(MainAssist._missionCells or {}) do
            if cell and type(cell.data) == "table" and tonumber(cell.data.taskid) == 22 then
                SL:release_print("[伏妖录调试] 命中任务栏中的 taskid=22，开始刷新")
                MainAssist.PrintXylTaskName(cell.data)
                break
            end
        end
    end

    -- 备注：刷新伏妖录任务的动态展示。
    -- 用于处理服务端变量、背包道具变化后，任务描述和奖励需要实时重算的情况。
    function MainAssist.RefreshXylDynamicContent()
        if not MainAssist._xylCurrentTask then
            return
        end

        MainAssist.UpdateCurrentXylTaskWidget()

        if MainAssist._xylDetailPopup and MainAssist._xylDetailPopup.root then
            _refresh_xyl_detail_popup_content()
        end
    end

    -- 备注：服务端变量变化后，伏妖录任务描述可能发生变化，这里统一刷新。
    function MainAssist.RefreshXylOnServerValueChange()
        MainAssist.RefreshXylDynamicContent()
    end

    -- 备注：背包道具变化后，伏妖录任务描述和奖励条件可能发生变化，这里统一刷新。
    function MainAssist.RefreshXylOnBagItemChange()
        MainAssist.RefreshXylDynamicContent()
    end
end

return MainAssistXylHelper
