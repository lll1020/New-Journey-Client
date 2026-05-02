local npc = {}
local SERVER_CFG = teshudata and teshudata["npc_103"] or {}
-- 103 的客户端私有配置只放在本文件中。
local CLIENT_CONFIG = {
    name = "天书试炼",
    title = "提交四种材料后解锁副本",
    tip_text = "",
    boss = "",
    reward = {},
    materials = {
        {idx = 1},
        {idx = 2},
        {idx = 3},
        {idx = 4},
    },
    ui = {
        background = "res/custom/one_city/103/bg.png",
        submit_button = "res/custom/one_city/103/submit.png",
        enter_button = "res/custom/one_city/103/enter.png",
        item_frame = "",
        tip = {x = 120, y = 398, width = 540, size = 18},
        boss = {x = 388, y = 220},
        status = {x = 388, y = 148},
        reward_label = {x = 388, y = 118},
        reward = {x = 360, y = 62},
        enter = {x = 266 + 16, y = 8},
        slots = {
            [1] = {
                icon = {x = 172 + 86, y = 283 + 60},
                name = {dx = -36, dy = 58 - 138},
                desc = {dx = -40, dy = -62},
                count = {dx = -10, dy = -96 + 50},
                button = {dx = -48 - 39, dy = -148 + 10},
            },
            [2] = {
                icon = {x = 603 + 24, y = 283 + 60},
                name = {dx = -36, dy = 58 - 138},
                desc = {dx = -40, dy = -62},
                count = {dx = -10, dy = -96 + 50},
                button = {dx = -48 - 39, dy = -148 + 10},
            },
            [3] = {
                icon = {x = 172 + 86, y = 155 + 49},
                name = {dx = -36, dy = 58 - 138},
                desc = {dx = -40, dy = -62},
                count = {dx = -10, dy = -96 + 50},
                button = {dx = -48 - 39, dy = -148 + 10},
            },
            [4] = {
                icon = {x = 603 + 24, y = 155 + 49},
                name = {dx = -36, dy = 58 - 138},
                desc = {dx = -40, dy = -62},
                count = {dx = -10, dy = -96 + 50},
                button = {dx = -48 - 39, dy = -148 + 10},
            },
        },
    },
}
local WINDOW_OPTS = {
    background = {eff = false},
}
local OUTLINE_COLOR = "#100808"
local MAINLINE_TASK_BY_SUBMIT_IDX = {
    [1] = 3,
    [2] = 6,
    [3] = 9,
    [4] = 12,
}
local CLAIM_BUTTON_SKIN = "res/public/1900000660.png"
-- 客户端只负责界面布局和默认展示，运行态数据全部来自服务端消息。
local function getConfig()
    return CLIENT_CONFIG
end
local function getServerConfig()
    return SERVER_CFG or {}
end
local function getUiConfig()
    local cfg = getConfig()
    local ui = cfg.ui or {}
    WINDOW_OPTS.background.skin = ui.background or "res/custom/one_city/103/bg.png"
    WINDOW_OPTS.closeButton = {x = 747, y = 320}
    return ui
end
local function ensureWindow(npcid)
    local cfg = getConfig()
    getUiConfig()
    local opts = {}
    for k, v in pairs(WINDOW_OPTS) do
        opts[k] = v
    end
    opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, cfg)
    opts.subTitle = cfg.title
    npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
    npc.bg = npc._window.bg
    npc.node = npc._window.node
    return npc.node
end
-- 兼容服务端不同刷新时机，保证缺字段时界面也能安全刷新。
local function normalizeData(data)
    data = data or {}
    data.T_data = type(data.T_data) == "table" and data.T_data or {}
    data.T_data.submit = type(data.T_data.submit) == "table" and data.T_data.submit or {}
    data.materials = type(data.materials) == "table" and data.materials or {}
    data.reward = type(data.reward) == "table" and data.reward or {}
    data.unlock = tonumber(data.unlock or data.T_data.unlock) or 0
    data.finish = tonumber(data.finish or data.T_data.finish) or 0
    data.claimed = tonumber(data.claimed or data.T_data.claimed) or 0
    data.in_fb = tonumber(data.in_fb) or 0
    return data
end
local getItemCountByName
local function getMaterialState(materialCfg, materialData, panelData)
    local serverCfg = getServerConfig()
    local serverMaterials = serverCfg.materials or {}
    local serverMaterial = serverMaterials[tonumber(materialCfg.idx) or 0] or {}
    local submitMap = ((panelData or {}).T_data or {}).submit or {}
    local materialIdx = tonumber((materialData and materialData.idx) or materialCfg.idx or 0) or 0
    local submitKey = tostring(materialIdx)
    local submitValue = (materialData and materialData.submit)
    if submitValue == nil then
        submitValue = submitMap[submitKey]
    end
    if submitValue == nil then
        submitValue = submitMap[materialIdx]
    end
    local state = {}
    state.idx = materialIdx
    state.name = (materialData and materialData.name) or materialCfg.name or serverMaterial.name or ("材料" .. tostring(state.idx))
    state.desc = (materialData and materialData.desc) or materialCfg.attr_desc or serverMaterial.attr_desc or ""
    state.need = tonumber((materialData and materialData.need) or (materialCfg.cost and materialCfg.cost[1] and materialCfg.cost[1][2]) or (serverMaterial.cost and serverMaterial.cost[1] and serverMaterial.cost[1][2]) or 0) or 0
    state.have = tonumber(materialData and materialData.have)
    if state.have == nil then
        state.have = getItemCountByName(state.name)
    end
    state.submit = tonumber(submitValue or 0) or 0
    return state
end
local function buildMaterialMap(data)
    local map = {}
    for _, material in ipairs(data.materials or {}) do
        map[tonumber(material.idx) or 0] = material
    end
    return map
end
-- 统一描边文字，避免同类文本样式散落各处。
local function createStrokeText(parent, name, x, y, size, color, text, anchorX, anchorY, fontName)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text or "")
    GUI:setAnchorPoint(label, anchorX or 0.5, anchorY or 0.5)
    GUI:Text_enableOutline(label, OUTLINE_COLOR, 2)
    if fontName then
        GUI:Text_setFontName(label, fontName)
    end
    return label
end
local function createCenterRich(parent, name, x, y, width, size, content, color)
    local rich = GUI:RichText_Create(parent, name, x, y, content or "", width or 160, size or 18, color or "#f7f7de", 1, nil, nil, {
        outlineSize = 2,
        outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),
    })
    GUI:setAnchorPoint(rich, 0.5, 0.5)
    return rich
end
local function buildAttrDescRich(desc)
    desc = tostring(desc or "")
    if desc == "" then
        return "<font color='#9fe7ff'>提交后激活属性</font>"
    end
    local prefix, suffix = string.match(desc, "^(.-)([+-].+)$")
    if not prefix or not suffix then
        return string.format("<font color='#f6e39a'>%s</font>", desc)
    end
    suffix = string.gsub(suffix, "^([+-])", "%1 ")
    return string.format("<font color='#f6e39a'>%s </font><font color='#7dff9b'>%s</font>", prefix, suffix)
end
local function getItemDataByName(name)
    if not name or name == "" then
        return nil
    end
    local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)) or 0
    if itemIndex <= 0 then
        return nil
    end
    return SL:GetMetaValue("ITEM_DATA", itemIndex)
end
getItemCountByName = function(name)
    if not name or name == "" then
        return 0
    end
    local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)) or 0
    if itemIndex > 0 then
        local count = tonumber(SL:GetMetaValue("ITEM_COUNT", itemIndex))
        if count ~= nil then
            return count
        end
    end
    local total = 0
    local bagItems = SL:GetMetaValue("BAG_DATA") or {}
    for _, item in pairs(bagItems) do
        if type(item) == "table" then
            local itemName = tostring(item.Name or item.name or "")
            local itemCount = tonumber(item.Overlap or item.count or item.Count or 1) or 1
            if itemName == name then
                total = total + itemCount
            elseif itemIndex > 0 and tonumber(item.Index or 0) == itemIndex then
                total = total + itemCount
            end
        end
    end
    return total
end
local function resolveSlotPos(iconPos, cfg)
    cfg = cfg or {}
    if cfg.x or cfg.y then
        return cfg.x or 0, cfg.y or 0
    end
    return (iconPos.x or 0) + (cfg.dx or 0), (iconPos.y or 0) + (cfg.dy or 0)
end
-- 中间状态文案只描述副本当前阶段，不参与玩法判断。
local function getStatusText(data)
    if tonumber(data.finish) == 1 and tonumber(data.claimed) ~= 1 then
        return "挑战完成，请领取天书", "#7dff9b"
    end
    if tonumber(data.finish) == 1 then
        return "本轮试炼已完成", "#7dff9b"
    end
    if tonumber(data.in_fb) == 1 then
        return "试炼进行中", "#ffd36e"
    end
    if tonumber(data.unlock) == 1 then
        return "已解锁副本，可进入挑战", "#7dff9b"
    end
    return "材料未提交完，暂时无法进入副本", "#ff7e7e"
end
local function renderTopTip(node, ui, cfg)
    local tipCfg = ui.tip or {}
    local tipText = cfg.tip_text or ""
    if tipText == "" then
        return
    end
    local rich = GUI:RichText_Create(node, "top_tip", tipCfg.x or 108, tipCfg.y or 398, tipText, tipCfg.width or 560, tipCfg.size or 18, "#f7f7de", 1, nil, nil, {outlineSize = 2,outlineColor = SL:ConvertColorFromHexString(OUTLINE_COLOR),})
    GUI:setAnchorPoint(rich, 0, 0.5)
end
-- 单个材料位：图标、名称、数量、属性描述、提交按钮都在这里绘制。
local function renderMaterial(node, npcid, ui, materialCfg, materialData)
    local slot = (ui.slots or {})[tonumber(materialCfg.idx) or 0] or {}
    local state = getMaterialState(materialCfg, materialData, npc.data)
    local iconPos = slot.icon or {}
    local nameX, nameY = resolveSlotPos(iconPos, slot.name)
    local countX, countY = resolveSlotPos(iconPos, slot.count)
    local descX, descY = resolveSlotPos(iconPos, slot.desc)
    local buttonX, buttonY = resolveSlotPos(iconPos, slot.button)
    local itemFrame = GUI:Image_Create(node, "item_frame_" .. state.idx, (iconPos.x or 0) - 35, (iconPos.y or 0) - 35, ui.item_frame or "res/wy/public/70_70_k.png")
    local itemData = getItemDataByName(state.name)
    if itemData then
        UiTools.showItemData(itemFrame, itemData)
        if state.desc ~= "" then
            tip_node(itemFrame, state.desc)
        end
    else
        createStrokeText(node, "item_missing_" .. state.idx, iconPos.x or 0, iconPos.y or 0, 18, "#ffe9c2", state.name, 0.5, 0.5, "fonts/500.ttf")
    end
    createStrokeText(node, "item_name_" .. state.idx, nameX, nameY, 18, "#fff3cf", state.name, 0.5, 0.5, "fonts/500.ttf")
    local haveColor = state.have >= state.need and "#7dff9b" or "#ff7e7e"
    local countText = string.format("<font color='%s'>%d</font><font color='#f7f7de'>/%d</font>", haveColor, state.have, state.need)
    if state.submit == 1 then
        countText = "<font color='#7dff9b'>已提交</font>"
    end
    local txt = createCenterRich(node, "item_count_" .. state.idx, countX, countY, 150, 18, countText, "#f7f7de")
    if state.submit == 1 then
    end
    createCenterRich(node, "item_desc_" .. state.idx, descX, descY, 190, 16, buildAttrDescRich(state.desc), "#f7f7de")
    if state.submit == 1 then
        GUI:setPosition(txt, buttonX + 50 , buttonY + 25)
    else
        local submitBtn = GUI:Button_Create(node, "submit_btn_" .. state.idx, buttonX, buttonY, ui.submit_button or "res/custom/one_city/103/submit.png")
        GUI:addOnClickEvent(submitBtn, function()
            SL:SendLuaNetMsg(100, npcid, 1, state.idx, "")
        end)
        NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, submitBtn, node, npcid, state.idx, {
            dir = 5,
            taskMap = {[npcid] = MAINLINE_TASK_BY_SUBMIT_IDX[state.idx]},
            desc = string.format("提交%s", state.name),
            isForce = false
        })
    end
end
-- 中心区域只处理副本状态、奖励展示和进入逻辑。
local function renderCenter(node, npcid, ui, cfg, data)
    local serverCfg = getServerConfig()
    local bossPos = ui.boss or {}
    local statusPos = ui.status or {}
    local rewardLabelPos = ui.reward_label or {}
    local rewardPos = ui.reward or {}
    local enterPos = ui.enter or {}
    GUI:setScale(GUI:Effect_Create(node, "eff", 400, 220, 0, 60449), 0.7)
    -- createCenterRich(node, "boss_text", bossPos.x or 388, bossPos.y or 220, 260, 18,
    --     string.format("<font color='#ffe4ae'>挑战目标：</font><font color='#ffb85c'>%s</font>", data.boss or cfg.boss or serverCfg.boss or ""),
    --     "#f7f7de")
    -- local statusText, statusColor = getStatusText(data)
    -- createStrokeText(node, "status_text", statusPos.x or 388, statusPos.y or 148, 19, statusColor, statusText, 0.5, 0.5, "fonts/500.ttf")
    -- createStrokeText(node, "reward_label", rewardLabelPos.x or 388, rewardLabelPos.y or 118, 18, "#ffe4ae", "通关奖励", 0.5, 0.5, "fonts/500.ttf")
    local rewardNode = GUI:Node_Create(node, "reward_node", rewardPos.x or 360, rewardPos.y or 62)
    ItemNumByTable_img((data.reward and #data.reward > 0) and data.reward or cfg.reward or serverCfg.reward or {}, nil, rewardNode)
    if tonumber(data.finish) == 1 then
        if tonumber(data.claimed) ~= 1 then
            local claimBtn= GUI:Frames_Create(node, "Button2", 284, -50 + 166, "res/custom/treasureBasin/btn_eff/eff_", ".png", 1, 75,
                { speed = 75, count = 75, loop = -1})
            GUI:setTouchEnabled(claimBtn, true)
            GUI:addOnClickEvent(claimBtn, function()
                SL:SendLuaNetMsg(100, npcid, 5, 0, "")
            end)
            NPC_UI_HELPER.startGuide({
                dir = 5,
                guideWidget = claimBtn,
                guideParent = node,
                guideDesc = "点击领取天书",
                isForce = false,
                hideMask = true
            })
        else
            GUI:Image_Create(node, "done_flag", enterPos.x or 266, enterPos.y or 18, "res/wy/public/7_1.png")
        end
        return
    end
    local enterBtn = GUI:Button_Create(node, "enter_btn", enterPos.x or 266, enterPos.y or 18, ui.enter_button or "res/custom/one_city/103/enter.png")
    GUI:addOnClickEvent(enterBtn, function()
        SL:SendLuaNetMsg(100, npcid, 2, 0, "")
    end)
    if tonumber(data.unlock) == 1 and tonumber(data.in_fb) ~= 1 then
        NPC_UI_HELPER.startGuide({
            dir = 5,
            guideWidget = enterBtn,
            guideParent = node,
            guideDesc = "点击进入副本",
            isForce = false,
            hideMask = true
        })
    end
end
-- 每次网络刷新都整屏重绘，避免旧节点残留状态。
local function UI_updata(node, npcid)
    if not node then
        return
    end
    GUI:removeAllChildren(node)
    local cfg = getConfig()
    local ui = getUiConfig()
    local data = normalizeData(npc.data)
    local materialMap = buildMaterialMap(data)
    renderTopTip(node, ui, cfg)
    for _, materialCfg in ipairs(cfg.materials or {}) do
        renderMaterial(node, npcid, ui, materialCfg, materialMap[tonumber(materialCfg.idx) or 0])
    end
    renderCenter(node, npcid, ui, cfg, data)
end
function npc.main(npcid, p2, p3, msgData)
    -- p2=0 首开，1/2 提交或进入后刷新，3/4 为完成或结束态刷新。
    if msgData and msgData ~= "" then
        npc.data = normalizeData(SL:JsonDecode(msgData, false))
    else
        npc.data = normalizeData(npc.data)
    end
    local node = ensureWindow(npcid)
    UI_updata(node, npcid)
    if p2 == 3 then
        SL:ShowSystemTips("天书试炼挑战完成")
    elseif p2 == 4 then
        SL:ShowSystemTips("天书试炼已结束")
    elseif p2 == 5 then
        SL:ShowSystemTips("已领取天书")
    end
end
return npc
