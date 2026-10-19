local npc = {}

local WINDOW = {background = {skin = "res/custom/transfer_1033/1033_bg.png"},}
local data = {}
local labels = {}

local function int(v)
    return math.max(0, math.floor(tonumber(v) or 0))
end

local function tip(text)
    if SL.ShowSystemTips then SL:ShowSystemTips(text) end
end

local function send(action, arg, payload)
    SL:SendLuaNetMsg(100, 1033, action, arg or 0, payload or "")
end

local function text(parent, name, x, y, size, color, value)
    local node = GUI:Text_Create(parent, name, x, y, size, color, value or "")
    GUI:setAnchorPoint(node, 0, 0.5)
    GUI:Text_enableOutline(node, "#120d0a", 2)
    return node
end

local function button(parent, name, title, x, y, callback)
    local node = GUI:Button_Create(parent, name, x, y, "res/public/1900000660.png")
    GUI:Button_setTitleText(node, title)
    GUI:Button_setTitleFontSize(node, 17)
    GUI:Button_setTitleColor(node, "#ffffff")
    GUI:addOnClickEvent(node, callback)
    return node
end

local function refreshValues()
    GUI:Text_setString(labels.recharge, tostring(int(data.real_recharge)) .. " 元")
    GUI:Text_setString(labels.exported, tostring(int(data.exported)) .. " 元")
    GUI:Text_setString(labels.remaining, tostring(int(data.remaining)) .. " 元")
    GUI:Text_setString(labels.claimed, tostring(int(data.claimed)) .. " 元")
    GUI:Text_setString(labels.claimable, tostring(int(data.claimable)) .. " 元")
    GUI:Text_setString(labels.server_age, tostring(int(data.open_days)) .. " 天（" .. (int(data.is_old_server) == 1 and "老区" or "新区") .. "）")
    if data.result and data.result ~= "" then
        local messages = {
            below_minimum = "真实充值需达到500元才可申请转区",
            already_locked = "该角色已申请转区并永久锁定",
            already_applied = "此账号已有转区记录",
            nothing_to_claim = "当前账号没有待领取的转区充值",
            over_claimable = "领取金额超过当前可领取额度",
            invalid_amount = "请输入有效的领取金额",
            claim_success = "转区充值领取成功",
            recharge_failed = "充值处理失败，转区余额已恢复",
            account_unavailable = "暂时无法读取账号转区记录",
            sync_failed = "转区记录同步失败，请稍后重试",
            recharge_unavailable = "充值服务暂不可用",
            transfer_locked = "转区申请成功，角色已永久锁定，请使用原账号前往目标区",
        }
        tip(messages[data.result] or tostring(data.result or "操作已完成"))
        data.result = ""
    end
end

local function createWindow(npcid)
    local opts = {}
    for k, v in pairs(WINDOW) do opts[k] = v end
    opts.titleText = "转区使者"
    opts.subTitle = "真实充值跨区转移"
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    GUI:removeAllChildren(npc.node)

    local panel = GUI:Layout_Create(npc.node, "panel", 61, 24, 678, 488, false)
    -- GUI:Image_Create(panel, "scene", 30, 47, "res/custom/transfer_1033/1033_bg.png")
    -- text(panel, "headline", 34, 454, 25, "#f4d681", "转区使者 · 充值迁移")
    -- text(panel, "rule1", 34, 410, 16, "#ffffff", "真实充值满500元可申请转区；申请成功后原角色永久禁止登录。")
    -- text(panel, "rule2", 34, 382, 16, "#ffffff", "新区使用相同账号创建角色，领取额度受新区真实充值额度限制。")
    -- text(panel, "rule3", 34, 354, 16, "#d8d8d8", "每次领取后会扣减转区余额；已领取金额不可重复领取。")
    GUI:Layout_Create(panel, "divider", 30, 330, 700, 2, false)

    local rows = {
        {"当前真实充值", "recharge", 286 - 50, 58},
        {"已转出充值", "exported", 286 - 50, 390 - 70},
        {"待领取转区充值", "remaining", 238 - 30, 58},
        {"已领取转区充值", "claimed", 238 - 30, 390 - 70},
        {"当前可领取额度", "claimable", 190 - 10, 58},
        {"当前区服", "server_age", 190 - 10, 390 - 70},
    }
    for i, row in ipairs(rows) do
        text(panel, "row_label_" .. i, row[4], row[3], 17, "#d8d2c5", row[1])
        labels[row[2]] = text(panel, "row_value_" .. i, row[4] + 165, row[3], 18, "#fff0b5", "0 元")
    end

    button(panel, "apply_transfer", "申请转区", 120, 100, function()
        SL:OpenCommonTipsPop({
            str = "为防止误操作，请输入“确认转区”",
            btnType = 2,
            showEdit = true,
            editParams = {inputMode = 6, maxLength = 8, str = ""},
            callback = function(atype, param)
                if atype ~= 1 then return end
                local value = tostring(param and param.editStr or "")
                if value ~= "确认转区" then
                    tip("输入内容不匹配，未提交申请")
                    return
                end
                send(1, 0, "CONFIRM_TRANSFER")
            end
        })
    end)
    button(panel, "claim_transfer", "提取充值", 398, 100, function()
        SL:OpenCommonTipsPop({
            str = "请输入要领取的转区充值金额",
            btnType = 2,
            showEdit = true,
            editParams = {inputMode = 2, maxLength = 10, str = ""},
            callback = function(atype, param)
                if atype ~= 1 then return end
                local value = tonumber(param and param.editStr)
                if not value or value < 1 or value ~= math.floor(value) then
                    tip("请输入正整数金额")
                    return
                end
                send(2, value, "CONFIRM_CLAIM")
            end
        })
    end)
    refreshValues()
end

function npc.main(npcid, p2, p3, msgData)
    if p2 == 0 then
        data = SL:JsonDecode(msgData, false) or {}
        createWindow(npcid)
    elseif p2 == 1 then
        data = SL:JsonDecode(msgData, false) or data
        if npc.node then refreshValues() end
    end
end

return npc
