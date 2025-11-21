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
local DEFAULT_OVERLAY = 'res/public/1900000651_1.png'  -- 全屏遮罩：点击关闭窗口
local DEFAULT_BG = 'res/wy/public/tongyong_0.png'              -- 背景面板：承载 UI 内容
local DEFAULT_CLOSE = 'res/wy/public/close_red_big.png'        -- 默认关闭按钮
local DEFAULT_BUTTON = 'res/public/1900000660.png'     -- 默认主按钮皮肤
local DEFAULT_OUTLINE = SL and SL:ConvertColorFromHexString('#100808') or '#100808'

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

    local bg = GUI:Image_Create(parent, bgCfg.name or 'img_bj', bgCfg.x or 0, bgCfg.y or 0, bgCfg.skin or DEFAULT_BG)
    GUI:setAnchorPoint(bg, bgCfg.anchorX or 0.5, bgCfg.anchorY or 0.5)
    GUI:setTouchEnabled(bg, true)
    if not opts.background or (bgCfg.skin == DEFAULT_BG) then
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

    -- if opts.titleText then
    --     cache.title = UIHelper.createTitle(bg, opts.titleText, opts.subTitle, opts.titleOptions)
    -- end

    return cache
end

-- ===== UI 构建工具 =====
-- 标题生成：支持主/副标题 + 描边效果
function UIHelper.createTitle(parent, text, subtitle, opts)
    if not parent or not text then
        return nil
    end
    opts = opts or {}
    local node = GUI:Node_Create(parent, opts.name or 'title_node', opts.x or 0, opts.y or 255)
    GUI:setAnchorPoint(node, 0.5, 0.5)
    local label = GUI:Text_Create(node, opts.labelName or 'title', 0, 0, opts.fontSize or 26, opts.color or '#ffe9c2', text)
    GUI:setAnchorPoint(label, 0.5, 0.5)
    GUI:Text_enableOutline(label, opts.outlineColor or '#1d0f09', opts.outlineSize or 2)
    if subtitle then
        local sub = GUI:Text_Create(node, opts.subtitleName or 'subtitle', 0, -28, opts.subtitleFontSize or 20, opts.subtitleColor or '#a0d8ff', subtitle)
        GUI:setAnchorPoint(sub, 0.5, 0.5)
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

-- 格式化 NPC 标题，例如：NPC 17 (兑换使者)
function UIHelper.formatNpcTitle(npcid, config)
    local parts = { 'NPC', tostring(npcid or '?') }
    if config and config.name then
        parts[#parts + 1] = string.format('(%s)', config.name)
    end
    return table.concat(parts, ' ')
end

_G.NPC_UI_HELPER = UIHelper
return UIHelper
