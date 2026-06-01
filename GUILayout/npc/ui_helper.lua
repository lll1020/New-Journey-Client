-- 通用 NPC 窗口工具模块（兼容旧版界面）
-- 功能概述：
--   * 统一处理 Win_Create / 遮罩层 / 背景面板 / 关闭按钮等模板代码
--   * 支持通过 WINDOW_STYLE + ensureWindow 快速复用窗口
--   * 采用懒加载（NPC_UI_HELPER 全局单例），避免重复 require
local existingHelper = rawget(_G, "NPC_UI_HELPER")
if existingHelper then
    return existingHelper
end
local UIHelper = {}
-- ===== 默认素材配置 =====
local DEFAULT_OVERLAY = 'res/wy/public/40-40.png'  -- 全屏遮罩：点击关闭窗口
local DEFAULT_BG = 'res/wy/public/tongyong_0.png'              -- 背景面板：承载 UI 内容
local DEFAULT_CLOSE = 'res/wy/public/close_red_big.png'        -- 默认关闭按钮
local DEFAULT_BUTTON = 'res/public/1900000660.png'     -- 默认主按钮皮肤
local DEFAULT_OUTLINE = SL and SL:ConvertColorFromHexString('#100808') or '#100808'
local GUIDE_DOMAIN_PRIORITY = {
    mainline = 300,
    xyl = 200,
    gray_world = 100,
    default = 0,
}
-- 主线引导映射：提升类 NPC 界面对应的主线任务号。
local MAINLINE_TASK_BY_UPGRADE_NPC = {
    [32] = 15,
}
-- ===== 基础工具函数 =====
-- 空函数：用于 overlay / closeBtn 的默认 onClick，避免频繁创建匿名函数
local function noop() end
-- 规范化描边配置：
--   opts = false -> 不启用描边
--   opts = nil   -> 使用默认描边
--   opts = table -> {outlineSize, outlineColor}
local function ensureOutline(opts)
    if opts == false then
        return nil
    end
    opts = opts or {}
    return { outlineSize = opts.outlineSize or 2, outlineColor = opts.outlineColor or DEFAULT_OUTLINE }
end
-- 为遮罩或关闭按钮注册点击事件（若未传 handler，回落到 noop）
local function addCloseHandler(widget, handler)
    if not widget then
        return
    end
    GUI:addOnClickEvent(widget, handler or noop)
end
local function isValidGuideNode(node)
    if not node then
        return false
    end
    if tolua and tolua.isnull then
        return not tolua.isnull(node)
    end
    return true
end
-- 统一引导入口：便于后续排查 guideWidget / guideParent / 旧引导残留问题。
function UIHelper.startGuide(opts)
    opts = opts or {}
    local guideWidget = opts.guideWidget
    if not isValidGuideNode(guideWidget) then
        return nil
    end
    local guideParent = isValidGuideNode(opts.guideParent) and opts.guideParent or guideWidget
    local guideArgs = {
        dir = opts.dir or 3,
        guideWidget = guideWidget,
        guideParent = guideParent,
        guideDesc = opts.guideDesc or "点击继续",
        isForce = opts.isForce == true,
        hideMask = opts.hideMask
    }
    if guideArgs.hideMask == nil then
        guideArgs.hideMask = true
    end
    return SL:StartGuide(guideArgs)
end
local function getGuidePriority(domain, opts)
    if opts and opts.priority ~= nil then
        return tonumber(opts.priority) or 0
    end
    return GUIDE_DOMAIN_PRIORITY[tostring(domain or "default")] or GUIDE_DOMAIN_PRIORITY.default
end
local function isSameGuideRequest(activeDomain, activeKey, domain, guideKey)
    return tostring(activeDomain or "") == tostring(domain or "")
        and tostring(activeKey or "") == tostring(guideKey or "")
end
local function closeActiveGuide()
    if UIHelper._guideActiveHandle then
        UIHelper.closeGuide(UIHelper._guideActiveHandle)
    end
    UIHelper._guideActiveHandle = nil
    UIHelper._guideActiveDomain = nil
    UIHelper._guideActiveKey = nil
    UIHelper._guideActivePriority = nil
    UIHelper._guideActiveWidget = nil
    UIHelper._guideActiveParent = nil
end
local function pickBestGuideRequest()
    local requestMap = UIHelper._guideRequestMap
    if type(requestMap) ~= "table" then
        return nil, nil
    end
    local bestDomain = nil
    local bestRequest = nil
    for domain, request in pairs(requestMap) do
        if type(request) == "table" then
            local opts = request.opts or {}
            if isValidGuideNode(opts.guideWidget) then
                if (not bestRequest) or (request.priority > bestRequest.priority) then
                    bestDomain = domain
                    bestRequest = request
                end
            end
        end
    end
    return bestDomain, bestRequest
end
local function activateGuideRequest(domain, request)
    if type(request) ~= "table" then
        return false
    end
    local opts = request.opts or {}
    if not isValidGuideNode(opts.guideWidget) then
        return false
    end
    local guideParent = isValidGuideNode(opts.guideParent) and opts.guideParent or opts.guideWidget
    if isSameGuideRequest(UIHelper._guideActiveDomain, UIHelper._guideActiveKey, domain, request.key)
        and UIHelper._guideActiveHandle then
        local sameWidget = UIHelper._guideActiveWidget == opts.guideWidget
        local sameParent = UIHelper._guideActiveParent == guideParent
        local activeWidgetValid = isValidGuideNode(UIHelper._guideActiveWidget)
        local activeParentValid = isValidGuideNode(UIHelper._guideActiveParent)
        if sameWidget and sameParent and activeWidgetValid and activeParentValid then
            return UIHelper._guideActiveHandle
        end
    end
    closeActiveGuide()
    local guideHandle = UIHelper.startGuide(opts)
    if not guideHandle then
        return false
    end
    UIHelper._guideActiveDomain = domain
    UIHelper._guideActiveKey = request.key
    UIHelper._guideActivePriority = request.priority
    UIHelper._guideActiveHandle = guideHandle
    UIHelper._guideActiveWidget = opts.guideWidget
    UIHelper._guideActiveParent = guideParent
    return guideHandle
end
local function refreshGuideArbitration()
    local bestDomain, bestRequest = pickBestGuideRequest()
    if not bestRequest then
        closeActiveGuide()
        return false
    end
    return activateGuideRequest(bestDomain, bestRequest)
end
function UIHelper.requestGuide(domain, guideKey, opts)
    domain = tostring(domain or "default")
    opts = opts or {}
    if not isValidGuideNode(opts.guideWidget) then
        return false
    end
    UIHelper._guideRequestMap = UIHelper._guideRequestMap or {}
    UIHelper._guideRequestMap[domain] = {
        key = tostring(guideKey or ""),
        priority = getGuidePriority(domain, opts),
        opts = opts,
    }
    return refreshGuideArbitration()
end
function UIHelper.closeGuideByDomain(domain, guideKey)
    domain = tostring(domain or "default")
    local requestMap = UIHelper._guideRequestMap
    local request = type(requestMap) == "table" and requestMap[domain] or nil
    if request and guideKey ~= nil and tostring(request.key or "") ~= tostring(guideKey or "") then
        return false
    end
    if requestMap then
        requestMap[domain] = nil
    end
    if domain == UIHelper._guideActiveDomain and (guideKey == nil or tostring(UIHelper._guideActiveKey or "") == tostring(guideKey or "")) then
        closeActiveGuide()
        return refreshGuideArbitration()
    end
    return true
end
-- 统一关闭引导入口：避免各处直接 pcall + CloseGuide。
function UIHelper.closeGuide(guideHandle)
    if not guideHandle then
        return
    end
    pcall(function()
        SL:CloseGuide(guideHandle)
    end)
end
-- 登录期内第一次打开纯提交任务页时，若材料不足则先显示“领取任务”按钮。
-- repeatCount > 0 表示已提交过至少一次，此时不再走首次引导按钮逻辑。
function UIHelper.shouldShowFirstOpenTakeButton(taskKey, cost, repeatCount)
    if type(taskKey) ~= "string" or taskKey == "" then
        return false
    end
    if type(cost) ~= "table" or #cost <= 0 then
        return false
    end
    if (tonumber(repeatCount) or 0) > 0 then
        return false
    end
    UIHelper._firstOpenSubmitTaskMap = UIHelper._firstOpenSubmitTaskMap or {}
    local hasOpened = UIHelper._firstOpenSubmitTaskMap[taskKey] == true
    if not hasOpened then
        UIHelper._firstOpenSubmitTaskMap[taskKey] = true
    end
    if hasOpened then
        return false
    end
    local hasEnough = true
    if type(checkItemNum) == "function" then
        hasEnough = checkItemNum(cost) == true
    end
    return hasEnough ~= true
end
function UIHelper.handleFirstOpenTakeButton(windowCache)
    local parent = windowCache and windowCache.parent
    if parent then
        GUI:Win_Close(parent)
    end
    SL:SetMetaValue("BATTLE_AFK_BEGIN")
end
-- ===== 核心方法：窗口创建/复用 =====
-- cache  : windowCache[name]，复用时传入旧引用
-- npcid  : 当前 NPC ID，仅用于默认 windowName
-- opts   : 窗口配置
--          - windowName / position / zOrder
--          - overlay / background / closeButton（传 false 可关闭某一层）
--          - node（内容节点）
--          - titleText / subTitle / titleOptions（自动绘制标题）
function UIHelper.ensureWindow(cache, npcid, opts)
    cache = cache or {}
    opts = opts or {}
    local pos = opts.position or {}
    local overlayCfg = opts.overlay or {}
    local bgCfg = opts.background or {}
    local closeCfg = opts.closeButton
    local nodeCfg = opts.node or {}
    local title = opts.title or {}
    local name = opts.windowName or string.format('npc_%s', npcid or 'unknown')
    local x = pos.x or cogin.w / 2
    local y = pos.y or cogin.h / 2
    local parent = GUI:GetWindow(nil, name)
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, x, y)
    else
        parent = GUI:Win_Create(name, x, y, 0, 0, false, false, true, true, true, npcid or 0, opts.zOrder or 1)
    end
    local overlay = GUI:Image_Create(parent, overlayCfg.name or 'bjt', overlayCfg.x or 0, overlayCfg.y or 0, overlayCfg.skin or DEFAULT_OVERLAY)
    GUI:setAnchorPoint(overlay, overlayCfg.anchorX or 0.5, overlayCfg.anchorY or 0.5)
    GUI:setContentSize(overlay, overlayCfg.width or (cogin.w + 100), overlayCfg.height or (cogin.h + 100))
    GUI:setTouchEnabled(overlay, true)
    addCloseHandler(overlay, overlayCfg.onClick or function()
        GUI:Win_Close(parent)
    end)
    GUI:setOpacity(overlay, 0)
    -- GUI:Timeline_FadeIn(overlay, 0.3, nil)
    GUI:Timeline_FadeTo(overlay, 200, 0.5, nil)
    local bg = GUI:Image_Create(parent, bgCfg.name or 'img_bj', bgCfg.x or 0, bgCfg.y or 0, bgCfg.skin or DEFAULT_BG)
    GUI:setAnchorPoint(bg, bgCfg.anchorX or 0.5, bgCfg.anchorY or 0.5)
    GUI:setTouchEnabled(bg, true)
    if not opts.background or (bgCfg.skin == DEFAULT_BG) or bgCfg.eff then
        GUI:Frames_Create(bg, "eff1", 0, 0, "res/wy/eff/city/tongyong_0_dx_1_", ".png", 1, 45,
            { speed = 75, count = 45, loop = -1})
        GUI:Frames_Create(bg, "eff2", 0, 0, "res/wy/eff/city/tongyong_0_dx_2_", ".png", 1, 45,
            { speed = 75, count = 45, loop = -1})
    end
    if opts.title then
        cache.title = GUI:Image_Create(bg, title.name or 'title', title.x or 56, title.y or 464, title.skin)
        GUI:setAnchorPoint(cache.title, title.anchorX or 0, title.anchorY or 0)
    end
    if bgCfg.timeline == true then
        GUI:Timeline_Window1(bg)
    end
    --放置透传
    GUI:addMouseOverTips(overlay, "", {x = 0, y = 0}, {x = 0, y = 0})
    local node = GUI:Node_Create(bg, nodeCfg.name or 'node', nodeCfg.x or 0, nodeCfg.y or 0)
    GUI:setLocalZOrder(node, 99)

    local closeBtn = nil
    if closeCfg ~= false then
        closeCfg = closeCfg or {}
        closeBtn = GUI:Button_Create(bg, closeCfg.name or 'close', closeCfg.x or 740, closeCfg.y or 460, closeCfg.skin or DEFAULT_CLOSE)
        GUI:setTouchEnabled(closeBtn, true)
        GUI:setLocalZOrder(closeBtn, 100)
        addCloseHandler(closeBtn, closeCfg.onClick or function()
            GUI:Win_Close(parent)
        end)
    end
    cache.parent = parent
    cache.overlay = overlay
    cache.bg = bg
    cache.close = closeBtn
    cache.node = node
    cache.title = opts.title
    if opts.titleText then
        UIHelper.createTitle(bg, opts.titleText, opts.subTitle, opts.titleOptions,name)
    end
    return cache
end
-- ===== UI 构建工具 =====
-- 标题生成：支持主/副标题 + 描边效果
function UIHelper.createTitle(parent, text, subtitle, opts,name)
    if not parent or not text then
        return nil
    end
    opts = opts or {}
    local node = GUI:Node_Create(parent, opts.name or 'title_node', opts.x or 0, opts.y or 255)
    GUI:setAnchorPoint(node, 1, 0.5)
    local label = GUI:Text_Create(node, opts.labelName or 'title', 0, 0, opts.fontSize or 26, opts.color or '#ffe9c2', text)
    GUI:setAnchorPoint(label, 1, 0.5)
    local name = GUI:Text_Create(node, name or 'name', 0, -40, opts.fontSize or 26, opts.color or '#ffe9c2', name)
    GUI:setAnchorPoint(name, 1, 0.5)
    GUI:Text_enableOutline(label, opts.outlineColor or '#1d0f09', opts.outlineSize or 2)
    GUI:Text_enableOutline(name, opts.outlineColor or '#1d0f09', opts.outlineSize or 2)
    if subtitle then
        local sub = GUI:Text_Create(node, opts.subtitleName or 'subtitle', 0, -28, opts.subtitleFontSize or 20, opts.subtitleColor or '#a0d8ff', subtitle)
        GUI:setAnchorPoint(sub, 1, 0.5)
        GUI:Text_enableOutline(sub, opts.subtitleOutlineColor or '#0d1a24', opts.subtitleOutlineSize or 2)
        label._subtitle = sub
    end
    return label
end
-- 富文本封装：通过 opts 控制宽高 / 颜色 / 对齐 / 描边 / 锚点
function UIHelper.createRichText(parent, name, x, y, content, opts)
    opts = opts or {}
    local widget = GUI:RichText_Create(parent, name, x or 0, y or 0, content or '', opts.width or 500, opts.size or 20, opts.color or '#f7f7de', opts.align or 3, nil, nil, ensureOutline(opts.outline))
    if opts.anchor then
        GUI:setAnchorPoint(widget, opts.anchor.x or opts.anchor[1], opts.anchor.y or opts.anchor[2])
    end
    return widget
end
-- 主操作按钮：
--   * text 为空且 opts.icon=true 时只显示图片
--   * opts.sound=false 可禁用点击音效
function UIHelper.createPrimaryButton(parent, name, x, y, text, callback, opts)
    opts = opts or {}
    local btn = GUI:Button_Create(parent, name or 'btn', x or 0, y or 0, opts.skin or DEFAULT_BUTTON)
    if text then
        GUI:Button_setTitleText(btn, text or (opts.icon and '' or '确定'))
        GUI:Button_setTitleFontSize(btn, opts.fontSize or 18)
        if opts.color then
            GUI:Button_setTitleColor(btn, opts.color)
        end
    end
    if opts.Disabled_skin then
        -- SL:release_print('NPC_UI_HELPER: Button set disabled skin:', opts.Disabled_skin)
        GUI:Button_loadTextureDisabled(btn, opts.Disabled_skin)
    end
    GUI:addOnClickEvent(btn, function(widget)
        if opts.sound ~= false and SL and SL.PlaySound then
            SL:PlaySound(34)
        end
        if callback then
            callback(widget)
        end
    end)
    return btn
end
-- 分割线：常用于窗口内部分隔区块
function UIHelper.createDivider(parent, name, x, y, width, height, opts)
    opts = opts or {}
    local divider = GUI:Image_Create(parent, name or 'divider', x or 0, y or 0, opts.skin or 'res/wy/public/fgx.png')
    GUI:setAnchorPoint(divider, opts.anchorX or 0.5, opts.anchorY or 0.5)
    if width or height then
        GUI:setContentSize(divider, width or 400, height or 4)
    end
    GUI:setOpacity(divider, opts.opacity or 200)
    return divider
end
-- 当主线步骤匹配时，为提升按钮触发引导（同 key 只触发一次）。
-- guideCache 通常传 npc 表，用于缓存 `_guide_key` 防止重复弹窗。
local function _closeMainlineGuide()
    return UIHelper.closeGuideByDomain("mainline")
end
function UIHelper.tryStartMainlineUpgradeGuide(guideCache, button, guideParent, npcid, marker, opts)
    if not isValidGuideNode(button) then
        return false
    end
    opts = opts or {}
    local rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid) or 0
    local taskMap = opts.taskMap or MAINLINE_TASK_BY_UPGRADE_NPC
    local targetTask = taskMap[npcid]
    SL:release_print('NPC_UI_HELPER: tryStartMainlineUpgradeGuide', rwid, targetTask, npcid)
    if rwid ~= (tonumber(targetTask) or -1) then
        return false
    end
    local keyPrefix = opts.keyPrefix or "mainline_upgrade"
    local guideKey = string.format("%s_%s_%s_%s", keyPrefix, tostring(rwid), tostring(npcid), tostring(marker or 0))
    if guideCache then
        guideCache._guide_key = guideKey
    end
    SL:release_print('NPC_UI_HELPER: tryStartMainlineUpgradeGuide', guideKey)
    local guideResult = UIHelper.requestGuide("mainline", guideKey, {
        dir = opts.dir or 3,
        guideWidget = button,
        guideParent = guideParent,
        guideDesc = opts.desc or "点击提升",
        isForce = opts.isForce == true,
        hideMask = opts.hideMask,
        priority = opts.priority
    })
    if guideResult then
        return guideResult
    end
    SL:ScheduleOnce(function()
        if not isValidGuideNode(button) then
            return
        end
        local retryGuideResult = UIHelper.requestGuide("mainline", guideKey, {
            dir = opts.dir or 3,
            guideWidget = button,
            guideParent = guideParent,
            guideDesc = opts.desc or "点击提升",
            isForce = opts.isForce == true,
            hideMask = opts.hideMask,
            priority = opts.priority
        })
        SL:release_print('NPC_UI_HELPER: tryStartMainlineUpgradeGuide retry', guideKey, retryGuideResult and 1 or 0)
    end, tonumber(opts.delay) or 0)
    return false
end
local function _normalizeXylTaskName(name)
    local value = tostring(name or "")
    value = value:gsub("%s+", "")
    value = value:gsub("（.-）", "")
    value = value:gsub("%(.-%)", "")
    return value
end
local function _closeXylGuideList()
    return UIHelper.closeGuideByDomain("xyl")
end
-- 判断当前异闻录任务名是否匹配，支持单个任务或任务名列表。
function UIHelper.isCurrentXylTask(taskNameOrList)
    local currentTaskName = tostring(rawget(_G, "XYL_CURRENT_TASK_NAME") or "")
    if currentTaskName == "" then
        return false
    end
    local currentTaskNorm = _normalizeXylTaskName(currentTaskName)
    if type(taskNameOrList) == "table" then
        for _, taskName in ipairs(taskNameOrList) do
            if currentTaskNorm == _normalizeXylTaskName(taskName) then
                return true
            end
        end
        return false
    end
    return currentTaskNorm == _normalizeXylTaskName(taskNameOrList)
end
-- 统一关闭 NPC 弹窗，便于任务完成后自动收起界面。
function UIHelper.closeWindow(windowCache)
    local parent = windowCache and windowCache.parent or nil
    if parent and (not (tolua and tolua.isnull) or not tolua.isnull(parent)) then
        GUI:Win_Close(parent)
        return true
    end
    return false
end
-- 当 xyl 当前任务匹配时，为指定按钮触发引导。
-- opts:
--   taskName  = "查看仙法"
--   taskNames = {"查看仙法", "初识仙法"}
--   match     = function(currentTaskName) return true end
--   idx       = 1  -- 同任务下的引导步骤序号
--   once      = true -- 是否仅引导一次（按 task + idx 记录）
function UIHelper.tryStartXylGuide(guideCache, button, guideParent, marker, opts)
    if not isValidGuideNode(button) then
        return false
    end
    opts = opts or {}
    local currentTaskName = tostring(opts.currentTaskName or rawget(_G, "XYL_CURRENT_TASK_NAME") or "")
    if currentTaskName == "" then
        return false
    end
    local currentTaskNorm = _normalizeXylTaskName(currentTaskName)
    local matched = false
    if type(opts.match) == "function" then
        local ok, result = pcall(opts.match, currentTaskName, currentTaskNorm)
        matched = ok and result == true
    elseif type(opts.taskNames) == "table" then
        for _, taskName in ipairs(opts.taskNames) do
            if currentTaskNorm == _normalizeXylTaskName(taskName) then
                matched = true
                break
            end
        end
    elseif opts.taskName then
        matched = currentTaskNorm == _normalizeXylTaskName(opts.taskName)
    end
    if not matched then
        return false
    end
    if opts.once == true then
        local idx = tonumber(opts.idx) or 0
        local onceKey = string.format("%s_%s", currentTaskNorm, tostring(idx))
        guideCache = guideCache or UIHelper
        guideCache._xylGuideOnceMap = guideCache._xylGuideOnceMap or {}
        if guideCache._xylGuideOnceMap[onceKey] then
            return false
        end
        guideCache._xylGuideOnceMap[onceKey] = true
    end
    local guideKey = string.format("xyl_%s_%s", currentTaskNorm, tostring(marker or opts.idx or 0))
    local guideResult = UIHelper.requestGuide("xyl", guideKey, {
        dir = opts.dir or 3,
        guideWidget = button,
        guideParent = guideParent,
        guideDesc = opts.desc or ("点击" .. currentTaskName),
        isForce = opts.isForce == true,
        hideMask = opts.hideMask,
        priority = opts.priority
    })
    if not guideResult then
        return false
    end
    return guideResult
end
-- 格式化 NPC 标题，例如：NPC 17 (兑换使者)
function UIHelper.formatNpcTitle(npcid, config)
    local parts = { 'NPC', tostring(npcid or '?') }
    if config and config.name then
        parts[#parts + 1] = string.format('(%s)', config.name)
    end
    return table.concat(parts, ' ')
end
-- 红点标识名称生成，例如：NPC 17 (兑换使者)--特效类
function UIHelper.redpoint_create_eff(parent, opts)
    if not parent then
        return nil
    end
    opts = opts or {}
    local size = (GUI and GUI.getContentSize and GUI:getContentSize(parent)) or parent:getContentSize() or { width = 0, height = 0 }
    local width = tonumber(size.width) or 0
    local height = tonumber(size.height) or 0
    local minSide = math.max(1, math.min(width > 0 and width or 64, height > 0 and height or 64))
    -- 统一规则：红点默认右对齐 + 垂直居中，且保持在按钮框内
    local inset = opts.inset
    if inset == nil then
        inset = math.max(4, math.floor(minSide * 0.08))
    end
    local autoScale = opts.autoScale
    if autoScale == nil then
        autoScale = math.max(0.55, math.min(0.95, minSide / 110))
    end
    local posX = opts.x
    if posX == nil then
        posX = width - inset
    end
    local posY = opts.y
    if posY == nil then
        posY = height * 0.5
    end
    posX = math.max(0, math.min(width, posX))
    posY = math.max(0, math.min(height, posY))
    local eff = GUI:Frames_Create(parent, opts.name or "redpoint", posX, posY, "res/wy/icon/hongdian/eff_", ".png", 1, 15,
        { speed = 75, count = 15, loop = -1})
    GUI:setScale(eff, opts.scale or autoScale)
    GUI:setAnchorPoint(eff, opts.anchorX or 1, opts.anchorY or 0.5)
    return eff
end
-- 红点标识名称生成，例如：NPC 17 (兑换使者)--无特效类
function UIHelper.redpoint_create(parent, opts)
    if not parent then
        return nil
    end
    opts = opts or {}
    local size = (GUI and GUI.getContentSize and GUI:getContentSize(parent)) or parent:getContentSize() or { width = 0, height = 0 }
    local width = tonumber(size.width) or 0
    local height = tonumber(size.height) or 0
    local minSide = math.max(1, math.min(width > 0 and width or 64, height > 0 and height or 64))
    -- 统一规则：红点默认右对齐 + 垂直居中，且保持在按钮框内
    local inset = opts.inset
    if inset == nil then
        inset = math.max(30, math.floor(minSide * 0.20))
    end
    local posX = opts.x
    if posX == nil then
        posX = width - inset
    end
    local posY = opts.y
    if posY == nil then
        posY = height - 27
    end
    posX = math.max(0, math.min(width, posX))
    posY = math.max(0, math.min(height, posY))
    local eff = GUI:Image_Create(parent, opts.name or "redpoint", posX, posY, "res/public/ists_red.png")
    GUI:setAnchorPoint(eff, opts.anchorX or 1, opts.anchorY or 0.5)
    return eff
end
function UIHelper.guochang_3()
    local parent = GUI:GetWindow(nil, "guochang_3")
    if parent then
        GUI:removeAllChildren(parent)
    else
        parent = GUI:Win_Create("guochang_3", 0, 0, 0, 0, false, false, true, true, true, nil, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/wy/eff/3_guochang/bg_1/eff_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w, cogin.h)
    GUI:setTouchEnabled(bjt, true)
    GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})
    if not UIHelper._firstOpen3 then
        local x_bjt = GUI:Image_Create(parent, "x_bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/zerq/xx_bg2.png")
        GUI:setAnchorPoint(x_bjt, 0.5, 0.5)
        GUI:setContentSize(x_bjt, cogin.w, cogin.h)
        GUI:setTouchEnabled(x_bjt, true)
        local wz = GUI:Frames_Create(x_bjt, "wz", cogin.w/2,  cogin.h/2 -300, "res/custom/three_city/zerq/eff/eff_", ".png", 1, 30,
                { speed = 100, count = 30, loop = -1})
        GUI:setAnchorPoint(wz, 0.5, 0.5)
        GUI:addOnClickEvent(x_bjt, function(widget)
            local bg = GUI:Frames_Create(x_bjt, "bg", cogin.w/2,  cogin.h/2, "res/wy/eff/3_guochang/eff_", ".jpg", 1, 1092,
                { speed = 1, count = 1092, loop = 1,callback = function()
                    SL:SendLuaNetMsg(100, 503, 1, 0, "")
                    SL:ShowSystemTips("<font color='#FF0000'>灾厄还未消退，不能展开三大陆剧情任务</font>")
                    local xx_bjt = GUI:Image_Create(parent, "xx_bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/zerq/xx_bg1.png")
                    GUI:setAnchorPoint(xx_bjt, 0.5, 0.5)
                    GUI:setContentSize(xx_bjt, cogin.w, cogin.h)
                    GUI:setTouchEnabled(xx_bjt, true)
                    local wz = GUI:Frames_Create(xx_bjt, "wz", cogin.w/2,  cogin.h/2 -300, "res/custom/three_city/zerq/eff/eff_", ".png", 1, 30,
                        { speed = 100, count = 30, loop = -1})
                    GUI:setAnchorPoint(wz, 0.5, 0.5)
                    GUI:addOnClickEvent(xx_bjt, function(widget)
                        GUI:Win_Close(parent)
                    end)
                end})
            GUI:setContentSize(bg, cogin.w, cogin.h)
            GUI:setAnchorPoint(bg, 0.5, 0.5)
            GUI:setTouchEnabled(x_bjt, false)
        end)
        UIHelper._firstOpen3 = true
    else
        local x_bjt = GUI:Image_Create(parent, "x_bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/zerq/xx_bg3.png")
        GUI:setAnchorPoint(x_bjt, 0.5, 0.5)
        GUI:setContentSize(x_bjt, cogin.w, cogin.h)
        GUI:setTouchEnabled(x_bjt, true)
        GUI:addOnClickEvent(x_bjt, function(widget)
            SL:SendLuaNetMsg(100, 503, 1, 0, "")
            SL:ShowSystemTips("<font color='#FF0000'>灾厄还未消退，不能展开三大陆剧情任务</font>")
            GUI:Win_Close(parent)
        end)
        local wz = GUI:Frames_Create(x_bjt, "wz", cogin.w/2,  cogin.h/2 -300, "res/custom/three_city/zerq/eff/eff_", ".png", 1, 30,
            { speed = 100, count = 30, loop = -1})
        GUI:setAnchorPoint(wz, 0.5, 0.5)
    end
end
_G.NPC_UI_HELPER = UIHelper
return UIHelper
