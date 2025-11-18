-- 通用NPC窗口工具模块（兼容旧版界面）
-- 采用懒加载方式，所有NPC脚本共享统一布局工具
local existingHelper = rawget(_G, "NPC_UI_HELPER")
if existingHelper then
    return existingHelper
end

local UIHelper = {}

local DEFAULT_OVERLAY = 'res/public/1900000651_1.png'
local DEFAULT_BG = 'res/wy/public/01.png'
local DEFAULT_CLOSE = 'res/wy/public/close.png'
local DEFAULT_BUTTON = 'res/public/1900000660.png'
local DEFAULT_OUTLINE = SL and SL:ConvertColorFromHexString('#100808') or '#100808'

-- 占位回调，避免频繁创建临时函数
local function noop() end

-- 归一化描边配置，支持 nil/false/表 参数
local function ensureOutline(opts)
    if opts == false then
        return nil
    end
    opts = opts or {}
    return { outlineSize = opts.outlineSize or 2, outlineColor = opts.outlineColor or DEFAULT_OUTLINE }
end

-- 统一绑定遮罩点击关闭
local function addCloseHandler(widget, handler)
    if not widget then
        return
    end
    GUI:addOnClickEvent(widget, handler or noop)
end

-- 各NPC脚本调用的入口，用于创建或复用弹窗
function UIHelper.ensureWindow(cache, npcid, opts)
    cache = cache or {}
    opts = opts or {}
    local pos = opts.position or {}
    local overlayCfg = opts.overlay or {}
    local bgCfg = opts.background or {}
    local closeCfg = opts.closeButton or {}
    local nodeCfg = opts.node or {}

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
    if bgCfg.timeline ~= false then
        GUI:Timeline_Window1(bg)
    end

    local closeBtn = GUI:Button_Create(bg, closeCfg.name or 'close', closeCfg.x or 930, closeCfg.y or 480, closeCfg.skin or DEFAULT_CLOSE)
    addCloseHandler(closeBtn, closeCfg.onClick or function()
        GUI:Win_Close(parent)
    end)

    local node = GUI:Node_Create(bg, nodeCfg.name or 'node', nodeCfg.x or 0, nodeCfg.y or 0)

    cache.parent = parent
    cache.overlay = overlay
    cache.bg = bg
    cache.close = closeBtn
    cache.node = node

    if opts.titleText then
        cache.title = UIHelper.createTitle(bg, opts.titleText, opts.subTitle, opts.titleOptions)
    end

    return cache
end

-- 构建带描边的主/副标题节点
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

-- 富文本（RichText_Create）包装，提供通用默认值
function UIHelper.createRichText(parent, name, x, y, content, opts)
    opts = opts or {}
    local widget = GUI:RichText_Create(parent, name, x or 0, y or 0, content or '', opts.width or 500, opts.height or 40, opts.color or '#f7f7de', opts.align or 3, nil, nil, ensureOutline(opts.outline))
    if opts.anchor then
        GUI:setAnchorPoint(widget, opts.anchor.x or opts.anchor[1], opts.anchor.y or opts.anchor[2])
    end
    return widget
end

-- 主操作按钮工厂，支持可选音效与回调
function UIHelper.createPrimaryButton(parent, name, x, y, text, callback, opts)
    opts = opts or {}
    local btn = GUI:Button_Create(parent, name or 'btn', x or 0, y or 0, opts.skin or DEFAULT_BUTTON)
    GUI:Button_setTitleText(btn, text or (opts.icon and '' or '确定'))
    GUI:Button_setTitleFontSize(btn, opts.fontSize or 18)
    if opts.color then
        GUI:Button_setTitleColor(btn, opts.color)
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

-- 水平分割线（可自定义材质与透明度
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

-- 生成形如 "NPC 9 (名称)" 的标题文本
function UIHelper.formatNpcTitle(npcid, config)
    local parts = { 'NPC', tostring(npcid or '?') }
    if config and config.name then
        parts[#parts + 1] = string.format('(%s)', config.name)
    end
    return table.concat(parts, ' ')
end

_G.NPC_UI_HELPER = UIHelper
return UIHelper
