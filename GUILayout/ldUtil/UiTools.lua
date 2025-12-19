UiTools = {}

SL:Require("GUILayout/lib/ease.lua", true)
local actionTag = 1000
local refreshActionTag = 1001
local touchTag = 100002
local tweenTag = 10000

---@param widget ccui.Widget
---@param path string 文件前缀
---@param startFrame number 开始帧
---@param endFrame number 结束帧
---@param ext {fileNameLen:number,loop:number,speed:number,size:{width:number,height:number},endCall:fun(widget:ccui.Widget),stepCall:fun(widget:ccui.Widget,now:number,max:number} 扩展参数
function UiTools.playFrame(widget, path, startFrame, endFrame, ext)
    --local interval = time / (endFrame - startFrame)
    local frame = startFrame
    local fileNameLen = ext.fileNameLen
    local loopLeft = ext.loop
    local speed = ext.speed
    local endCall = ext.endCall
    local stepCall = ext.stepCall
    local size = ext.size
    local step = (endFrame - startFrame) / math.abs(endFrame - startFrame)
    local loopInterval = ext.loopInterval or 0
    if step == 0 then
        return
    end
    local function play()
        local fileName = tostring(frame)
        if fileNameLen ~= nil then
            fileName = string.format('%0' .. fileNameLen .. 'd', frame)

        end
        local name = string.format("%s%s.png", path, fileName)
        --SL:release_print("widget",widget,"playFrame name",name)
        GUI:Image_loadTexture(widget, name)
        --widget:loadTexture(name)
        if size then
            GUI:setContentSize(widget, size.width, size.height)
            --widget:setContentSize(size)
        end
        frame = frame + step
        if (step > 0 and frame >= endFrame) or (step < 0 and frame <= endFrame) then
            if loopLeft > 0 then
                loopLeft = loopLeft - 1
                if loopLeft == 0 then
                    widget:stopActionByTag(actionTag)
                    if endCall then
                        endCall(widget)
                    end
                    return
                end
            end
            frame = startFrame
        elseif stepCall then
            stepCall(widget, frame, endFrame)
        end
        --SL:release_print("widget",GUI:getVisible(widget))
        --GUI:Timeline_CallFunc(widget, speed / 1000, play)
    end
    widget:stopActionByTag(actionTag)
    local action = cc.RepeatForever:create(
            cc.Sequence:create(
                    cc.CallFunc:create(play),
                    cc.DelayTime:create(speed / 1000))
    )
    action:setTag(actionTag)
    widget:runAction(action)
    --play()
end

function UiTools.stopFrame(image)
    image:stopActionByTag(actionTag)
end

---@param target cc.Node
---@param tweenData ui.tweenData
function UiTools.doTween(target, tweenData, interval)
    tweenData.target = target
    tweenData.lastCall = os.clock()
    interval = interval or 0.016
    target:stopActionByTag(tweenTag)
    target:runAction(cc.RepeatForever:create(cc.Sequence:create({
        cc.DelayTime:create(interval),
        cc.CallFunc:create(function()
            local now = os.clock()
            local dt = (now - tweenData.lastCall) or 0
            tweenData.now = (tweenData.now or 0) + dt
            UiTools.doTweenStep(tweenData)
            tweenData.lastCall = now
            if tweenData.now >= tweenData.d then
                target:stopActionByTag(tweenTag)
            end
            --SL:release_print("doTween step")
        end)
    }))                :setTag(tweenTag))

end

---@param tweenData ui.tweenData
function UiTools.doTweenStep(tweenData)
    tweenData.now = tweenData.now or 0
    local from = tweenData.from
    local to = tweenData.to
    if type(from) == 'number' then
        from = { from }
        to = { to }
    end
    local nowData = {}
    if tweenData.now < tweenData.d then
        local ease = tweenData.ease or Ease.linear
        for i, v in ipairs(from) do
            local endValue = to[i] or 0
            table.insert(nowData, ease(tweenData.now, v, endValue - v, tweenData.d))
        end
    else
        --已完成
        nowData = to
    end
    if tweenData.target then
        tweenData.changeCall(tweenData.target, unpack(nowData))
    else
        tweenData.changeCall(unpack(nowData))
    end
    if tweenData.endCall and tweenData.now >= tweenData.d then
        if tweenData.target then
            tweenData.endCall(tweenData.target, tweenData)
        else
            tweenData.endCall(tweenData)
        end
    end
end

function UiTools.addItemTipEvent(widget, itemData)
    if cogin.isWin32 then
        GUI:addMouseMoveEvent(widget, {
            onEnterFunc = function()
                local showData
                if type(itemData) == 'function' then
                    showData = itemData()
                else
                    showData = itemData
                end
                SL:OpenItemTips({
                    itemData = showData,
                    pos = SL:GetMetaValue("MOUSE_MOVE_POS")
                })
            end,
            onLeaveFunc = function()
                SL:CloseItemTips()
            end
        })
    else
        GUI:addOnClickEvent(widget, function()
            local showData
            if type(itemData) == 'function' then
                showData = itemData()
            else
                showData = itemData
            end
            SL:OpenItemTips({
                itemData = showData,
                pos = SL:GetMetaValue("MOUSE_MOVE_POS")
            })
        end)
    end
end

function UiTools.addMouseTips(widget, tips)
    if cogin.isWin32 then
        --SL:release_print("tips:", tips)
        GUI:addMouseMoveEvent(widget, {
            onEnterFunc = function()
                local pos = SL:GetMetaValue("MOUSE_MOVE_POS")
                GUI:ShowWorldTips(tips, pos, GUI:p(0, 0))
            end,
            onLeaveFunc = function()
                GUI:HideWorldTips()
            end
        })
    else
        widget:setTouchEnabled(true)
        GUI:addOnClickEvent(widget, function(sender)
            local pos = sender:getTouchEndPosition()
            GUI:ShowWorldTips(tips, pos, GUI:p(0, 0))
        end)
    end

end

function UiTools.tips(text)
    if text == nil or text == '' then
        return
    end
    SL:release_print('tips', text)
    SL:ShowSystemTips(text)
end

---获取小地图文件路径
function UiTools.getMiniMapPath(id)
    if id == nil then
        return ""
    end
    local fileName = tonumber(id) - 1
    return string.format("scene/uiminimap/%s.png", string.format('%0' .. 6 .. 'd', fileName))

end

local _cgImg = {
    --成功
    ['sjcg'] = { effType = 'effect', effId = 13007 },
    --领取成功
    ['lqcg'] = { effType = 'effect', effId = 13006 },
    --突破成功
    ['tpcg'] = { effType = 'effect', effId = 13005 },
    --强化成功
    ['qhcg'] = { effType = 'effect', effId = 13001 },
    --晋级成功
    ['jjcg'] = { effType = 'effect', effId = 13003 },
    --修炼成功
    ['xlcg'] = { effType = 'effect', effId = 13004 },
    --任务完成
    ['rwwc'] = { effType = 'effect', effId = 13003 },
    --任务领取
    ['rwjs'] = { effType = 'effect', effId = 13002 },
}

---播放全局的成功动画
function UiTools.playSucAnimation(key)
    local p = GUI:Attach_UITop()
    --SL:release_print("p", p,'pp',GUI:Attach_Parent())
    --为了浮动在对话框上层所以找父节点
    local sucAnimation = GUI:getChildByName(p, "__suc_ani_image__")
    if not sucAnimation then
        --不存在，动态创建
        SL:release_print("创建动画节点")
        sucAnimation = cc.Node:create()
        sucAnimation:setName("__suc_ani_image__")
        sucAnimation:setAnchorPoint(cc.p(0.5, 0.5))
        sucAnimation:setContentSize(cc.size(0, 0))
        --设置渲染层级
        --GUI:setLocalZOrder(sucAnimation, 9999)

        p:addChild(sucAnimation, 999)
        --sucAnimation = GUI:Image_Create(p, '__suc_ani_image__', 0, 0)
        --GUI:setAnchorPoint(sucAnimation, 0.5, 0.5)
    else
        sucAnimation:removeAllChildren()
    end
    local sw = cogin.w
    local sh = cogin.h
    local pos = GUI:convertToNodeSpace(p, sw / 2, sh / 2 + 80)
    --SL:release_print(p, sw, sh, pos.x, pos.y)
    sucAnimation:setPosition(cc.p(pos.x, pos.y))
    local effId
    if type(key) == 'number' then
        effId = key
    else
        local cfg = _cgImg[key] or _cgImg['cg']
        --GUI:setVisible(sucAnimation, true)
        if cfg.effType == 'frame' then
            local image = GUI:Image_Create(sucAnimation, 'image', 0, 0, '')
            image:setAnchorPoint(cc.p(0.5, 0.5))
            --播放动画
            UiTools.playFrame(image, cfg.path, cfg.startFrame, cfg.endFrame, {
                loop = 1,
                speed = cfg.speed or 100,
                endCall = function()
                    image:removeFromParent()
                    --GUI:setVisible(sucAnimation, false)
                end
            })
            return
        elseif cfg.effType == 'effect' then
            effId = cfg.effId
        end

    end
    if effId then
        local eff = GUI:Effect_Create(sucAnimation, 'eff', 0, 0, 3, effId, 0, 0, 0)
        GUI:Effect_addOnCompleteEvent(eff, function()
            eff:removeFromParent()
            --GUI:setVisible(sucAnimation, false)
        end)
    end
end

---获取两个点的方向位置
function UiTools.getDirection(p1, p2)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local angle = math.atan2(dy, dx)
    local direction = (math.floor((-angle + math.pi / 8) / (math.pi / 4)) + 2) % 8

    return direction
end

---获取两点之间的距离
function UiTools.getLength(p1, p2)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    return math.sqrt(dx * dx + dy * dy)
end

function UiTools.calculateRotation(pos1, pos2)
    local angle = cc.pToAngleSelf(cc.pSub(pos2, pos1))
    -- 旋转坐标为返的
    angle = -angle
    local rotate = math.deg(angle)
    if rotate < 0 then
        rotate = rotate + 360
    end
    --SL:release_print(angle, rotate)
    return rotate
end

function UiTools.calTargetByRotation(pos, rotation, distance)
    local angle = math.rad(rotation)
    local x = pos.x + distance * math.cos(-angle)
    local y = pos.y + distance * math.sin(-angle)
    return cc.p(x, y)
end

function UiTools.mapToWorld(x, y)
    return ssr.MapPos2WorldPos(cc.p(x, y))
end

-- 计算贝塞尔曲线上的点
-- points: 控制点坐标数组，每个点包含 x 和 y 坐标
-- t: 参数值，范围在 [0, 1] 之间
function UiTools.calculateBezierPoint(points, t)
    local n = #points
    if n < 2 then
        return points[1].x, points[1].y
    end

    local function calculateNextLevel(points, t)
        if #points == 1 then
            return points[1]
        end

        local nextPoints = {}
        for i = 1, #points - 1 do
            local x = (1 - t) * points[i].x + t * points[i + 1].x
            local y = (1 - t) * points[i].y + t * points[i + 1].y
            table.insert(nextPoints, { x = x, y = y })
        end

        return calculateNextLevel(nextPoints, t)
    end

    return calculateNextLevel(points, t)
end

--- 进行网格自动排版
---@param cfg GridLayoutCfg
function UiTools.gridLayout(widget, cfg)
    local items = {}
    for _, v in ipairs(widget:getChildren()) do
        if v:isVisible() then
            table.insert(items, v)
        end
    end
    -- 只获取可见的子节点
    if #items == 0 then
        -- 没有找到子节点
        return 0, 0
    end
    cfg = cfg or {}
    -- 确定滚动方向
    local scrollDir
    if widget.getDirection then
        scrollDir = widget:getDirection()
    elseif cfg.scrollDir ~= nil then
        scrollDir = cfg.scrollDir
    elseif cfg.colCount ~= nil and cfg.colCount > 0 then
        scrollDir = cc.SCROLLVIEW_DIRECTION_VERTICAL
    else
        scrollDir = cc.SCROLLVIEW_DIRECTION_HORIZONTAL
    end

    local contentSize = widget:getContentSize()
    -- 获取itemSize
    local itemSize = cfg.ignoreScale and items[1]:getContentSize() or items[1]:getBoundingBox()
    local offsetX = cfg.offsetX or 0
    local offsetY = cfg.offsetY or 0
    -- 计算行列数
    local colCount, rowCount
    if scrollDir == cc.SCROLLVIEW_DIRECTION_VERTICAL then
        --SL:release_print("垂直滚动")
        if cfg.colCount ~= nil and cfg.colCount > 0 then
            colCount = cfg.colCount
        else
            colCount = math.floor((contentSize.width + offsetX) / (itemSize.width + offsetX))
        end
        rowCount = math.ceil(#items / colCount)
    else
        --SL:release_print("水平滚动")
        if cfg.rowCount ~= nil and cfg.rowCount > 0 then
            rowCount = cfg.rowCount
        else
            rowCount = math.max(1, math.floor((contentSize.height + offsetY) / (itemSize.height + offsetY)))
        end
        colCount = math.ceil(#items / rowCount)
    end
    colCount = math.min(colCount, #items)
    --SL:release_print("colCount", colCount, "rowCount", rowCount)
    -- 计算出需要的大小
    local needSize = cc.size(
            colCount * (itemSize.width + offsetX) - offsetX,
            rowCount * (itemSize.height + offsetY) - offsetY
    )
    local innerSize = {}
    if widget.getInnerContainerSize then
        if scrollDir == 1 then
            -- 垂直滚动
            innerSize.width = contentSize.width
            if widget.setInnerContainerSize then
                innerSize.height = math.max(contentSize.height, needSize.height)
            else
                --SL:release_print("不存在滚动大小")
                innerSize.height = needSize.height
            end
        else
            -- 水平滚动
            if widget.setInnerContainerSize then
                innerSize.width = math.max(contentSize.width, needSize.width)
            else
                innerSize.width = needSize.width
            end
            innerSize.height = contentSize.height
        end
    else
        if cfg.resize then
            widget:setContentSize(needSize)
            innerSize = needSize
        else
            innerSize = contentSize
        end
    end

    local widthLeft = innerSize.width - needSize.width
    local heightLeft = innerSize.height - needSize.height
    --SL:release_print("innerSize", innerSize.width, innerSize.height, "needSize", needSize.width, needSize.height)
    --SL:release_print("widthLeft", widthLeft, "heightLeft", heightLeft)
    ---·0 1 2: 左对其，居中对其，右对齐
    local horizontalMode = cfg.horizontalMode
    if horizontalMode ~= 0 and horizontalMode ~= 2 then
        horizontalMode = 1
    end
    ---0 1 2 3: 上对齐，居中对齐，下对齐
    local verticalMode = cfg.verticalMode
    if verticalMode ~= 0 and verticalMode ~= 2 then
        verticalMode = 1
    end

    local startX, startY
    if horizontalMode == 0 then
        -- 左对齐
        startX = 0
        --if cfg.offsetX == nil and colCount > 1 then
        --    offsetX = widthLeft / (colCount - 1)
        --end
    elseif horizontalMode == 1 then
        --居中
        startX = widthLeft / 2
    elseif horizontalMode == 2 then
        -- 右对齐
        --if cfg.offsetX == nil and colCount > 1 then
        --    offsetX = widthLeft / (colCount - 1)
        --    startX = offsetX
        --else
        startX = widthLeft
        --end
    end
    if verticalMode == 0 then
        -- 上对齐
        startY = innerSize.height - itemSize.height - (cfg.top or 0)
        --if cfg.offsetY == nil and rowCount > 1 then
        --    offsetY = heightLeft / (rowCount - 1)
        --end
    elseif verticalMode == 1 then
        -- 居中
        --if cfg.offsetY == nil then
        --    offsetY = heightLeft / (rowCount + 1)
        --    startY = innerSize.height - offsetY
        --else
        startY = innerSize.height - heightLeft / 2 - itemSize.height
        --end
    elseif verticalMode == 2 then
        -- 下对齐
        --if cfg.offsetY == nil and rowCount > 1 then
        --    offsetY = heightLeft / (rowCount - 1)
        --    startY = innerSize.height - offsetY
        --else
        startY = innerSize.height - heightLeft - itemSize.height
        --end
    end

    if widget.setInnerContainerSize then
        widget:setInnerContainerSize(innerSize)
        --else
        --    widget:setContentSize(innerSize)
    end
    -- 开始调整子对象位置
    local x = startX
    local y = startY
    --SL:release_print(y,widget:getContentSize().height)
    for i = 1, #items do
        local item = items[i]
        itemSize = cfg.ignoreScale and item:getContentSize() or item:getBoundingBox()
        local ap = item:getAnchorPoint()
        --SL:release_print("ap:", ap.x, ap.y)
        local itemX = x + ap.x * itemSize.width
        local itemY = y + ap.y * itemSize.height
        --SL:release_print("itemY", itemY)
        GUI:setPosition(item, itemX, itemY)
        --item:setPosition(cc.p(x, y))
        x = x + itemSize.width + offsetX
        if i % colCount == 0 then
            x = startX
            y = y - itemSize.height - offsetY
        end
    end
    return rowCount, colCount
end

function UiTools.circleLayout(widget, round, startAngle, center)
    local itemNodes = {}
    for i, v in ipairs(widget:getChildren()) do
        if v:isVisible() then
            table.insert(itemNodes, v)
        end
    end
    if #itemNodes == 0 then
        return
    end
    local cSize = itemNodes[1]:getContentSize()
    local size = widget:getContentSize()
    center = center or cc.p(math.floor(size.width / 2), math.floor(size.height / 2))
    round = round or { math.floor((size.width - cSize.width) / 2), math.floor((size.height - cSize.height) / 2) }
    local horizontalRadius, verticalRadius
    if type(round) == 'table' then
        horizontalRadius = round.x or round[1]
        verticalRadius = round.y or round[2]
    else
        horizontalRadius = round
        verticalRadius = round
    end
    startAngle = startAngle or 90
    local angleStep = 360 / #itemNodes
    for i, v in ipairs(itemNodes) do
        local angle = math.rad(startAngle - (i - 1) * angleStep)  -- 计算当前元素的角度
        local x = center.x + horizontalRadius * math.cos(angle)  -- 计算元素的x坐标
        local y = center.y + verticalRadius * math.sin(angle)    -- 计算元素的y坐标
        --调整坐标
        local ap = v:getAnchorPoint()
        x = x + (ap.x - 0.5) * cSize.width
        y = y + (ap.y - 0.5) * cSize.height
        v:setPosition(cc.p(x, y))
    end
end

---单行排版
---@param parent userdata 父节点
---@param cfg {border:{left:number,right:number},offset:number,horizontalMode:number,verticalMode:number,reverse:boolean,resize:boolean}
function UiTools.gridSingleRow(parent, cfg)
    cfg = cfg or {}
    local sum = 0
    local widgetArray = {}
    local widthArray = {}
    local maxHeight = 0
    for i, v in ipairs(parent:getChildren()) do
        if v:isVisible() then
            local size = v:getBoundingBox()
            local width = size.width
            sum = sum + width
            table.insert(widgetArray, v)
            table.insert(widthArray, width)
            maxHeight = math.max(maxHeight, size.height)
        end
    end
    local baseAp = 0
    local pSize = parent:getContentSize()
    local border = cfg.border or {}
    local borderWidth = (border.left or 0) + (border.right or 0)
    sum = sum + borderWidth
    local offset = cfg.offset
    local horizontalMode = cfg.horizontalMode
    if horizontalMode == nil then
        --动态布局，忽略offset 只能居中对齐
        horizontalMode = 1
        offset = (pSize.width - borderWidth - sum) / (#widthArray + 1)
        border.left = (border.left or 0) + offset
        --SL:release_print("#widthArray", #widthArray, "border.left", border.left, "offset", offset, "sum", sum, 'pwidth', pSize.width)
        baseAp = 0.5
        sum = sum + offset * (#widthArray - 1)
    else
        offset = offset or 0
        horizontalMode = horizontalMode or 1
        sum = sum + offset * (#widthArray - 1)
    end
    if parent.getInnerContainerSize then
        local size = cc.size(math.max(pSize.width, sum), pSize.height)
        parent:setInnerContainerSize(size)
        --SL:release_print("innerSize", size.width, size.height)
        pSize = size
    elseif cfg.resize then
        --SL:release_print("resize", pSize.width, sum)
        local size = cc.size(math.max(pSize.width, sum), math.max(pSize.height, maxHeight))
        parent:setContentSize(size)
        pSize = size
    end
    local start = 0
    if horizontalMode == 0 then
        --左对齐
        start = border.left or 0
    elseif horizontalMode == 2 then
        --右对齐
        start = pSize.width - sum - (border.right or 0)
    else
        --居中
        start = (pSize.width - sum) / 2
    end
    local vMode = cfg.verticalMode or 1
    local count = #widgetArray
    local startIndex, endIndex, step = 1, count, 1
    if cfg.reverse then
        startIndex, endIndex, step = count, 1, -1
    end
    for i = startIndex, endIndex, step do
        local v = widgetArray[i]
        local x = start
        local w = widthArray[i]
        local ap = v:getAnchorPoint()
        x = x + ap.x * w
        --计算y
        local nH = v:getBoundingBox().height
        local y = 0
        if vMode == 0 then
            --上对齐
            y = pSize.height - nH
        elseif vMode == 2 then
            --下对齐
            y = 0
        else
            --居中
            y = (pSize.height - nH) / 2
        end
        y = y + ap.y * nH
        v:setPosition(cc.p(x, y))
        start = start + w + offset
    end
end

---单列排版
---@param parent userdata 父节点
---@param cfg {border:{top:number,bottom:number},offset:number,horizontalMode:number,verticalMode:number,resize:boolean}
function UiTools.gridSingleCol(parent, cfg)
    cfg = cfg or {}
    local sum = 0
    local heightArray = {}
    local maxWidth = 0
    for i, v in ipairs(parent:getChildren()) do
        if v:isVisible() then
            local size = v:getBoundingBox()
            local height = size.height
            sum = sum + height
            table.insert(heightArray, height)
            maxWidth = math.max(maxWidth, size.width)
        end
    end
    SL:release_print("UiTools.gridSingleCol need sum", sum, 'node count:', #heightArray)
    local baseAp = 1
    local pSize = parent:getContentSize()
    local border = cfg.border or {}
    border.bottom = border.bottom or 0
    border.top = border.top or 0
    local borderHeight = (border.top or 0) + (border.bottom or 0)
    sum = sum + borderHeight
    local offset = cfg.offset
    local verticalMode = cfg.verticalMode
    if verticalMode == nil then
        --动态布局，忽略offset 只能居中对齐
        offset = (pSize.height - borderHeight - sum) / (#heightArray - 1)
        --baseAp = 0.5
        verticalMode = 1
        sum = pSize.height - borderHeight
    else
        offset = offset or 0
        verticalMode = verticalMode or 1
        sum = sum + offset * (#heightArray - 1)
    end
    if parent.getInnerContainerSize then
        local size = cc.size(pSize.width, math.max(pSize.height, sum))
        parent:setInnerContainerSize(size)
        pSize = size
    elseif cfg.resize then
        local size = cc.size(math.max(maxWidth, pSize.width), math.max(pSize.height, sum))
        parent:setContentSize(size)
        pSize = size
    end
    local startY = 0
    if verticalMode == 0 then
        --上对齐
        startY = pSize.height - (border.top or 0)
    elseif verticalMode == 2 then
        --下对齐
        startY = border.bottom + sum
    else
        --居中
        startY = math.floor((pSize.height + sum) / 2)
    end
    SL:release_print(pSize.height, startY)
    local hMode = cfg.horizontalMode or 1
    local j = 1
    for i, v in ipairs(parent:getChildren()) do
        if v:isVisible() then
            local y = startY
            local h = heightArray[j]
            local ap = v:getAnchorPoint()
            y = y + (ap.y - baseAp) * h
            --计算y
            local nW = v:getBoundingBox().width
            local x = 0
            if hMode == 0 then
                --左对齐
                x = 0
            elseif hMode == 2 then
                --右对齐
                x = pSize.width - nW
            else
                --居中
                x = (pSize.width - nW) / 2
            end
            x = x + ap.x * nW
            v:setPosition(cc.p(x, y))
            startY = startY - h - offset
            j = j + 1
        end
    end
end


function UiTools.addImageClickEvent(image, callback)
    image:setTouchEnabled(true)
    image:addTouchEventListener(function(p1, p2)
        if p2 == ccui.TouchEventType.began then
            -- 处理触摸开始事件
            p1:setScale(0.9)
        elseif p2 == ccui.TouchEventType.moved then
            -- 处理触摸移动事件
        elseif p2 == ccui.TouchEventType.ended then
            -- 处理触摸结束事件
            p1:setScale(1)
            SL:PlayBtnClickAudio()
            callback()
            --SendLogic.buyStoreGoods(goodsCfg.id)
        elseif p2 == ccui.TouchEventType.canceled then
            -- 处理触摸取消事件
            p1:setScale(1)
        end
    end)
end

function UiTools.setObjRedPoint(obj, red, offset)
    local redPointNodeName = "_red_point_"
    local node = obj:getChildByName(redPointNodeName)
    if red then
        if node == nil then
            offset = offset or obj['_$redOffset'] or cc.p(0, 0)
            offset.x = offset.x or 0
            offset.y = offset.y or 0
            obj['_$redOffset'] = offset
            --local size = obj:getContentSize()
            --local pos = cc.p(size.width - 26, size.height + 16)
            --pos = cc.pSub(pos, offset)
            --node = GUI:Effect_Create(obj, redPointNodeName, pos.x, pos.y, 3, 11010, 0, 0, 0)
            node = SL:CreateRedPoint(obj, offset)
            node:setName(redPointNodeName)
        end
    elseif node then
        obj:removeChild(node)
    end
end

function UiTools.doRock(widget, amplitude, intervalMin, intervalMax)
    local duration = 0.05
    local rotation
    if type(amplitude) == 'table' and #amplitude == 2 then
        rotation = math.random(amplitude[1], amplitude[2])
    elseif type(amplitude) == 'number' and amplitude > 0 then
        rotation = amplitude
    else
        rotation = math.random(15, 30)
    end
    -- 创建一个动作序列
    local actions = {
        cc.RotateTo:create(duration, -rotation),
        cc.RotateTo:create(duration * 2, rotation),
        cc.RotateTo:create(duration, 0)
    }
    intervalMax = intervalMax or intervalMin or 4
    intervalMin = intervalMin or 2

    -- 创建一个重复动作，使图标不断地震动
    local r = cc.Repeat:create(cc.Sequence:create(actions), math.random(2, 4))
    local delay = math.random(intervalMin * 1000, intervalMax * 1000) / 1000
    -- 运行动作
    widget:runAction(cc.Sequence:create(
            r,
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function()
                UiTools.doRock(widget, amplitude, intervalMin, intervalMax)
            end)
    ))
end

function UiTools.color4BTo4F(color4B)
    local color4F = cc.c4f(color4B.r / 255, color4B.g / 255, color4B.b / 255, color4B.a / 255)
    return color4F
end

function UiTools.color4FTo4B(color4F)
    local color4B = cc.c4b(color4F.r * 255, color4F.g * 255, color4F.b * 255, color4F.a * 255)
    return color4B
end

function UiTools.convertHexTo4B(hex)
    if string.sub(hex, 1, 1) == "#" then
        hex = string.sub(hex, 2) -- 去除 "#" 字符
    end

    -- 转换为 c4b 类型颜色值
    local r = tonumber(string.sub(hex, 1, 2), 16)
    local g = tonumber(string.sub(hex, 3, 4), 16)
    local b = tonumber(string.sub(hex, 5, 6), 16)

    return cc.c4b(r, g, b, 255) -- 返回 c4b 类型颜色值，alpha 通道值为 255
end

function UiTools.btnClick(btnObj)
    SL:PlayBtnClickAudio()
    btnObj:setTouchEnabled(false)
    GUI:delayTouchEnabled(btnObj, 0.2)
end

---动态计算三次曲线贝塞尔的点
function UiTools.getBezierPoint(p1, p2)
    local center
    if p1.y == p2.y then
        --水平
        center = cc.p((p1.x + p2.x) / 2, p1.y + math.abs(p1.x - p2.x) / 2)
    elseif p1.x == p2.x then
        --垂直， 不进行贝塞尔曲线计算
        center = cc.p(p1.x, p1.y + math.abs(p1.y - p2.y) / 2)
    elseif p1.x > p2.x then
        center = cc.p(p1.x, p2.y)
    else
        center = cc.p(p2.x, p1.y)
    end
    return center
end

---重新创建itemShow对象
function UiTools.recreateItemShow(itemShow, data)
    local p = itemShow:getParent()
    local ap = itemShow:getAnchorPoint()
    local pos = cc.p(itemShow:getPosition())
    local scale = itemShow:getScale()
    local name = itemShow:getName()
    itemShow:removeFromParent()
    if data.look == nil then
        data.look = true
    end
    local newItemShow = GUI:ItemShow_Create(p, name, pos.x, pos.y, data)
    newItemShow:setAnchorPoint(ap)
    newItemShow:setScale(scale)
    return newItemShow
end

function UiTools.recreateRichText(richText, str, size, color, width, space)
    --SL:release_print(str)
    local p = richText:getParent()
    local ap = richText:getAnchorPoint()
    local pos = cc.p(richText:getPosition())
    local scale = richText:getScale()
    local name = richText:getName()
    richText:removeFromParent()
    local newText = GUI:RichText_Create(p, name, pos.x, pos.y, str, width, size, color, space)
    newText:setAnchorPoint(ap)
    newText:setScale(scale)
    return newText
end

---@param effectNode userdata
---@param effectShowCfg EffectShowCfg
---@param append boolean 是否为追加模式
function UiTools.showEffect(effectNode, effectShowCfg, append)
    if not append then
        effectNode:removeAllChildren()
    end
    SL:release_print("effectShowCfg.effType", effectShowCfg.effType, "effectShowCfg.effId", effectShowCfg.effId)
    if effectShowCfg.effId == nil then
        SL:release_print("无效的特效配置")
        return nil
    end
    local act = effectShowCfg.act or 0
    local dir = effectShowCfg.dir
    if dir == nil then
        --根据类型默认展示方向
        if effectShowCfg.effType == 4 then
            --玩家
            dir = 4
        elseif effectShowCfg.effType == 2 then
            dir = 3
        else
            dir = 0
        end
    end
    local effect = GUI:Effect_Create(effectNode, "effect_" .. effectNode:getChildrenCount(), effectShowCfg.ox or 0, effectShowCfg.oy or 0, effectShowCfg.effType or 0, effectShowCfg.effId, 0, act, dir)
    effect:setScale(effectShowCfg.scale or 1)
    return effect
end

---展示装备内观
---@param eff_node userdata 展示节点
---@param equipData table 装备数据
---@param cfg {scale:number, offsetX:number, offsetY:number,tipCfg:{x:number,y:number,width:number,height:number} 展示配置
function UiTools.showEquipNeiGuan(eff_node, equipData, cfg)
    eff_node:removeAllChildren()
    cfg = cfg or {}
    local offsetX = cfg.offsetX or 0
    local offsetY = cfg.offsetY or 0
    local effStr = equipData.sEffect
    if effStr == nil or effStr == '' then
        return nil
    else
        -- 未使用官方的因为无法隐藏item的图标资源
        --local itemShow = GUI:ItemShow_Create(eff_node, "item", offsetX, offsetY, { itemData = equipData, count = 1, look = true, showModelEffect = true,onlyShowSFX=false, bgVisible = false })
        --itemShow:setAnchorPoint(cc.p(0.5, 0.5))
        local effectList, _ = ParseModelEffect(effStr)
        for i, v in ipairs(effectList) do
            -- 添加个特效
            local effectID = v.effectId
            local x = (v.offX or 0) + offsetX
            local y = (v.offY or 0) + offsetY
            SL:release_print("effectID", effectID, x, y, v.zOrder or "")
            local anim = nil
            anim = GUI:Effect_Create(eff_node, i, x, y, 0, effectID)
            local scale = cfg.scale or v.scale or 1
            if scale ~= 1 then
                anim:setScale(scale)
            end
        end
        -- 添加一个layout作为tip展示
        if cfg.tipCfg then
            local tipLayout = GUI:Layout_Create(eff_node, 'tips_layout', cfg.tipCfg.x or 0, cfg.tipCfg.y or 0, cfg.tipCfg.width or 120, cfg.tipCfg.height or 250)
            tipLayout:setAnchorPoint(0.5, 0.5)
            --GUI:Layout_setBackGroundColorType(tipLayout, 1)
            --GUI:Layout_setBackGroundColor(tipLayout, "#00FF00")
            tipLayout:setTouchEnabled(true)
            UiTools.addItemTipEvent(tipLayout, equipData)
        end
        --return effectList
    end
end

---展示玩家可配置的特效信息
function UiTools.createUserEffect(effNode, effType, effId)
    local _type = 0
    local dir = 0
    return GUI:Effect_Create(effNode, "eff", 0, 0, _type, effId, 0, 0, dir, 1)
end

function UiTools.showItemData(effNode, itemData)
    effNode:removeAllChildren()
    local contentSize = effNode:getContentSize()
    --展示物品
    local itemShow = GUI:ItemShow_Create(effNode, "item", contentSize.width / 2, contentSize.height / 2, { itemData = itemData, look = true, bgVisible = false })
    itemShow:setAnchorPoint(cc.p(0.5, 0.5))
    return itemShow
end

function UiTools.showItemData_Index(effNode, item_index)
    effNode:removeAllChildren()
    local contentSize = effNode:getContentSize()
    --展示物品
    local itemShow = GUI:ItemShow_Create(effNode, "item", contentSize.width / 2, contentSize.height / 2, { index = item_index, look = true, bgVisible = false })
    itemShow:setAnchorPoint(cc.p(0.5, 0.5))
    return itemShow
end

local function pauseAll(node)
    node:pause()
    for i, v in ipairs(node:getChildren()) do
        pauseAll(v)
    end
end

local function resumeAll(node)
    node:resume()
    for i, v in ipairs(node:getChildren()) do
        resumeAll(v)
    end
end

---获取节点快照
function UiTools.createSnapshot(layout)
    -- 获取布局的尺寸
    local size = layout:getContentSize()

    pauseAll(layout)
    -- 创建 RenderTexture，尺寸与布局相同
    local renderTexture = cc.RenderTexture:create(size.width, size.height)

    -- 开始渲染
    renderTexture:begin()

    for i, v in ipairs(layout:getChildren()) do
        v:visit()
    end
    -- 将布局渲染到 RenderTexture 上
    --layout:visit()

    -- 结束渲染
    renderTexture:endToLua()
    resumeAll(layout)
    -- 返回渲染结果
    return renderTexture:getSprite()
end

---@generic T
---@param widget ccui.Widget
---@param obj T
---@return T
function UiTools.uiBindObj(widget, obj)
    widget._ui = widget._ui or GUI:ui_delegate(widget)
    if widget._bindObj_ then
        --已绑定到其他对象中了
        SL:release_print("已绑定到其他对象中了", widget._bindObj_)
        return nil
    end
    _setmetatableindex(widget, obj)

    widget._bindObj_ = obj
    if widget.onBindWidget then
        widget:onBindWidget()
    end
    widget:enableNodeEvents()
    return widget
end

---创建用户自定义对象
---@generic T
---@param parent userdata
---@param name string
---@param uiPath string
---@param uiObj T
---@return T
function UiTools.createCustomUi(parent, name, uiPath, uiObj)
    if parent == nil or tolua.isnull(parent) then
        logger.stack("parent is null")
        return nil
    end
    GUI:LoadExport(parent, uiPath)
    local root = parent:getChildByName("root")
    root:setName(name)
    UiTools.uiBindObj(root, uiObj)
    if root.onEnter then
        root:onEnter()
    end
    return root
end

---添加点击事件
---@param widget userdata
---@param clickEvent function 点击事件
---@param longTouchStart function 长按开始事件
---@param longTouchEnd function 长按结束事件
function UiTools.addClientEvent(widget, clickEvent, longTouchStart, longTouchEnd)
    GUI:addOnTouchEvent(widget, function(sender, type)
        -- sender: 传入控件自身
        -- type: 触摸类型 int 0 - 3
        if type == SLDefine.TouchEventType.began then
            -- 0 触摸开始
            if not sender._clicking then
                sender._clicking = true
                sender:runAction(cc.Sequence:create({
                    cc.DelayTime:create(0.32),
                    cc  .CallFunc:create(function()
                        if sender._clicking then
                            sender._clicking = false
                            if longTouchStart then
                                longTouchStart(sender)
                            end
                        end
                    end):setTag(touchTag) }))
            end
        elseif type == SLDefine.TouchEventType.moved then
            -- 1 触摸移动

        elseif type == SLDefine.TouchEventType.ended then
            -- 2 触摸结束
            if sender._clicking then
                sender._clicking = false
                sender:stopActionByTag(touchTag)
                if clickEvent then
                    clickEvent(sender)
                end
            elseif longTouchEnd then
                longTouchEnd(sender)
            end
        elseif type == SLDefine.TouchEventType.canceled then
            -- 3 触摸取消
            if not sender._clicking and longTouchEnd then
                longTouchEnd(sender)
            end
        end
    end)
end

function UiTools.doLayoutRefresh(layout, rebuildCall, animType, delay, duration, inDelay)
    local temp = layout:getChildByName("temp")
    if temp then
        layout:removeChild(temp)
    end
    layout:stopActionByTag(refreshActionTag)
    if animType then
        delay = delay or 0.1
        duration = duration or 0.2
        if animType.outAction then
            --存在离场动画
            temp = ccui.Layout:create()
            temp:setName("temp")
            --temp:setClippingEnabled(true)
            temp:setContentSize(layout:getContentSize())
            for i, v in ipairs(layout:getChildren()) do
                --为了不别马上回收，次数先加一次调用
                v:retain()
                layout:removeChild(v)
                temp:addChild(v)
                v:release()
                v:runAction(
                        animType.outAction(v, (i - 1) * delay, duration):setTag(refreshActionTag))
            end
            layout:addChild(temp)
            --SL:release_print("temp count", temp:getChildrenCount(), self:getChildrenCount())
            temp:runAction(cc.Sequence:create({
                cc.DelayTime:create((temp:getChildrenCount() - 1) * delay + duration + 0.01),
                cc.RemoveSelf:create(),
            })               :setTag(refreshActionTag))
        end
        if animType.inAction then
            --入场
            rebuildCall(layout)
            if inDelay == nil then
                local oldCount = temp:getChildrenCount()
                if oldCount == 0 then
                    inDelay = 0
                elseif layout:getChildrenCount() == 0 then
                    inDelay = (oldCount - 1) * delay + duration
                else
                    inDelay = inDelay or (delay + duration)
                end
            end
            for i, v in ipairs(layout:getChildren()) do
                if v ~= temp then
                    v:runAction(
                            animType.inAction(v, inDelay + (i - 1) * delay, duration):setTag(refreshActionTag))
                end
            end
        else
            layout:runAction(cc.Sequence:create({
                cc.DelayTime:create(inDelay),
                cc.CallFunc:create(function()
                    rebuildCall(layout)
                end)
            })                 :setTag(refreshActionTag))
        end
    else
        layout:removeAllChildren()
        rebuildCall(layout)
    end
end

---@param layout ccui.Layout
---@param rewards RewardItemCfg[]
function UiTools.resetRewardsLayout(layout, rewards)
    local temp = layout:getChildren()[1]
    temp:retain()
    layout:removeAllChildren()
    for i, v in ipairs(rewards) do
        local ui = temp:clone()
        ui:setName("reward_item_" .. i)
        local node = UiTools.showReward(ui, v)
        if node then
            ui:setVisible(true)
            layout:addChild(ui)
        end
    end
    if temp:getChildrenCount() == 0 then
        --重新加回去
        temp:setVisible(false)
        layout:addChild(temp)
    end
    temp:release()
end

---填充控件的子控件
---@param layout ccui.Widget
---@param count number 需要填充数量
---@param callBack fun(node,index)
function UiTools.fillLayout(layout, count, callBack)
    local temp = layout:getChildren()[1]
    temp:retain()
    layout:removeAllChildren()
    if count == 0 or not temp:isVisible() then
        layout:addChild(temp)
        temp:setVisible(false)
    end
    for i = 1, count do
        --SL:release_print("i", i )
        local node = temp:clone()
        node:setVisible(true)
        node:setName("sub_node_" .. i)
        GUI:addChild(layout, node)
        if callBack then
            callBack(node, i)
        end
    end

    temp:release()
    return layout
end

function UiTools.getCircleCenter(A, B, C)
    local x1, y1 = A.x, A.y
    local x2, y2 = B.x, B.y
    local x3, y3 = C.x, C.y

    local D = 2 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))

    if D == 0 then
        error("Points are collinear or invalid.")
    end

    local x = ((x1 ^ 2 + y1 ^ 2) * (y2 - y3) + (x2 ^ 2 + y2 ^ 2) * (y3 - y1) + (x3 ^ 2 + y3 ^ 2) * (y1 - y2)) / D
    local y = ((x1 ^ 2 + y1 ^ 2) * (x3 - x2) + (x2 ^ 2 + y2 ^ 2) * (x1 - x3) + (x3 ^ 2 + y3 ^ 2) * (x2 - x1)) / D

    return cc.p(x, y)
end

---设置窗口最前端展示
function UiTools.setNodeTop(node)
    local parent = node:getParent()
    if parent then
        local c = parent:getChildren()
        if #c <= 1 then
            return
        end
        node:setLocalZOrder(c[#c]:getLocalZOrder() + 1)
    end
end

---创建全屏操作遮罩
---@param uiObj UIObj
---@param callback function 点击后的回调
---@param removeWhenClick boolean 点击后是否自动删除
function UiTools.createFullMask(uiObj, callback, removeWhenClick)
    local root = uiObj._ui.root
    local mask = root:getChildByName("_full_mask_")
    if mask ~= nil then
        mask:removeFromParent()
    end
    mask = GUI:Layout_Create(root, "_full_mask_", 0, 0, SL:GetMetaValue("SCREEN_WIDTH"), SL:GetMetaValue("SCREEN_HEIGHT"))
    local p = mask:convertToNodeSpace(cc.p(0, 0))
    mask:setPosition(p)
    mask:setTouchEnabled(true)
    GUI:addOnClickEvent(mask, function()
        if removeWhenClick then
            mask:removeFromParent()
        end
        if callback then
            callback()
        end
    end)
    return mask
end

function UiTools.createNoiseTexture()
    local glProgram = ShaderUtils.getGLProgram('test')
    local renderTexture = cc.RenderTexture:create(256, 256)
    renderTexture:begin()
    local sprite = cc.Sprite:create('res/public/0.png')
    sprite:setAnchorPoint(0, 0)
    local scale = 256 / sprite:getContentSize().width
    SL:release_print('scale', scale)
    sprite:setScale(scale)
    sprite:setGLProgram(glProgram)
    sprite:visit()
    renderTexture:endToLua()
    sprite = renderTexture:getChildren()[1]
    return sprite
end

function UiTools.rgb2hsl(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, l = 0, 0, (max + min) / 2

    if max ~= min then
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, l
end

function UiTools.hsl2rgb(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l -- 灰色
    else
        local function hue2rgb(p, q, t)
            if t < 0 then
                t = t + 1
            end
            if t > 1 then
                t = t - 1
            end
            if t < 1 / 6 then
                return p + (q - p) * 6 * t
            end
            if t < 1 / 2 then
                return q
            end
            if t < 2 / 3 then
                return p + (q - p) * (2 / 3 - t) * 6
            end
            return p
        end
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1 / 3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1 / 3)
    end
    return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

---增加颜色亮度
function UiTools.adjustColorBrightness(color, brightPro)
    local h, s, l = UiTools.rgb2hsl(color.r, color.g, color.b)
    l = math.min(1, math.max(0, l * brightPro)) -- 限制亮度范围
    local r, g, b = UiTools.hsl2rgb(h, s, l)
    return cc.c4b(r, g, b, color.a)
end

---增加颜色饱和度
function UiTools.addColorSaturation(color, pro)
    local h, s, l = UiTools.rgb2hsl(color.r, color.g, color.b)
    s = math.min(1, math.max(0, s * pro)) -- 限制饱和度范围
    local r, g, b = UiTools.hsl2rgb(h, s, l)
    return cc.c4b(r, g, b, color.a)
end

function UiTools.adjustColorBrightnessAndSaturation(color, brightPro, saturationPro)
    local h, s, l = UiTools.rgb2hsl(color.r, color.g, color.b)
    l = math.min(1, math.max(0, l * brightPro)) -- 限制饱和度范围
    s = math.min(1, math.max(0, s * saturationPro)) -- 限制饱和度范围
    local r, g, b = UiTools.hsl2rgb(h, s, l)
    return cc.c4b(r, g, b, color.a)
end

return UiTools