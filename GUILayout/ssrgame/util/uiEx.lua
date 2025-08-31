--- 游戏逻辑模块
-- @file uiEx.lua
-- @description 角色逻辑
-- @author an
-- @email 490719516@qq.com
-- @version 1.1
-- @date 2024-09-18
--加载策划表格
---*  path : 文件名
---@param path string
---@return any
function ssrRequireCsvCfg(path)
    return SL:Require("GUILayout/ssrgame/csvcfg/" .. path)
end
--加载官方表格
---*  path : 文件名
---@param path string
---@return any
function ssrRequireGameCfg(path)
    return SL:Require("scripts/game_config/" .. path)
end

--根据根节点查找树形结构控件对象
---*  root : 根控件对象
---*  name : 查找的控件名
---@param root userdata
---@param name string
---@return any
function ssrSeekWidgetByName(root, name)
    if GUI:getName(root) == name then
        return root
    end
    local children = GUI:getChildren(root)
    for k, v in pairs(children) do
        local res = ssrSeekWidgetByName(v, name)
        if res ~= nil then
            return res
        end
    end
    return nil
end
--根据根节点设置文本内容和颜色
---*  root : 根控件对象
---*  name : 查找的控件名
---*  str : 文本内容
---*  color : 颜色(16进制色)
---@param root userdata
---@param name string
---@param str string
---@param color string
---@return any
function ssrLabelString(root, name, str, color)
    local label = ssrSeekWidgetByName(root, name)
    if str then
        GUI:Text_setString(label, str)
    end
    if color then
        GUI:Text_setTextColor(label, color)
    end
    return label
end

--更新属性显示
function ssrUpdateAttrShow(cfg, index, field, root, num, nodename, attrname, valuename, chnum)
    local cattr = ssrAttrToClientEx(cfg, index, field, chnum)
    for i = 1, num do
        local attr = cattr[i]
        local nd_attr = ssrSeekWidgetByName(root, nodename .. i)
        GUI:setVisible(nd_attr, attr and true or false)
        if attr then
            ssrLabelString(nd_attr, attrname .. i, attr.name)
            ssrLabelString(nd_attr, valuename .. i, attr.value)
        end
    end
end


--itemshow 添加箭头
function ssrAddItemShowArrow(itemshow, x, y)
    x = x or 52
    y = y or 30
    return GUI:Effect_Create(itemshow, "effect", x, y, 0, 5004)
end
---设置窗口位置
---* parent：父级
---* Widget：控件对象
---* Position：显示位置 1左上角 2居中
---* x：偏移
---* y：偏移
---* isDrag：是否可以拖拽
---* isZPanel：是否浮起
function ssrSetWidgetPosition(Parent, Widget, Position, x, y, isDrag, isZPanel)
    if not Widget then
        return
    end
    Position = Position or 2
    x = x or 0
    y = y or 0
    isDrag = isDrag or true
    isZPanel = isZPanel or true
    if Position == 1 then
        GUI:setAnchorPoint(Widget, 0.00, 1.00)
        GUI:setPosition(Widget, 0 + x, ssrConstCfg.height - y)
    elseif Position == 2 then
        GUI:setAnchorPoint(Widget, 0.50, 0.50)
        GUI:setPosition(Widget, ssrConstCfg.cx + x, ssrConstCfg.cy - y)
    end
    if isDrag and Parent then
        GUI:Win_SetDrag(Parent, Widget)
    end
    if isZPanel and Parent then
        GUI:Win_SetZPanel(Parent, Widget)
    end

end
--数字滚动效果
---* startValue：起始值
---* endValue：结束值
---* duration：动画持续时间
---* numSteps：步长
---* onUpdate：回调函数
function animateNumberTransition(startValue, endValue, duration, numSteps, onUpdate)
    local currentValue = startValue
    local stepValue = math.abs(endValue - startValue) / numSteps  -- 步进值取绝对值
    local stepInterval = duration / numSteps

    local function animateNumber()
        -- 检查是否已经达到目标值
        if currentValue ~= endValue then
            -- 根据开始值和结束值的大小关系选择加法或减法操作
            if startValue < endValue then
                currentValue = currentValue + stepValue  -- 执行加法操作
                if currentValue >= endValue then
                    currentValue = endValue
                end
            else
                currentValue = currentValue - stepValue  -- 执行减法操作
                if currentValue <= endValue then
                    currentValue = endValue
                end
            end
            -- 调用更新回调函数
            onUpdate(math.floor(currentValue))
            -- 递归调用，在下一个时间段继续更新数字
            SL:ScheduleOnce(animateNumber, stepInterval)
        end
    end
    animateNumber()
end
--添加横向排列的物品列表
function ssrAddItemListX(parent, itemList, widgetName, data)
    GUI:removeAllChildren(parent)
    data = data or {}
    data["imgRes"] = data["imgRes"] or "res/custom/public/itemBG.png"  --底图
    data["imgX"] = data["imgX"] or 0                                --坐标X
    data["imgY"] = data["imgY"] or 0                                --坐标Y
    data["spacing"] = data["spacing"] or 0                          --间距
    data["imgScale"] = data["imgScale"] or 1                        --底图缩放
    data["effectId"] = data["effectId"] or 0                        --特效ID
    data["effectX"] = data["effectX"] or 0                          --特效X
    data["effectY"] = data["effectY"] or 0                          --特效Y
    data["effectScale"] = data["effectScale"] or 1                  --特效缩放
    data["ItemLook"] = data["ItemLook"] or true                     --物品数量显示
    data["itemScale"] = data["itemScale"] or 1                      --物品缩放
    local widgets = {}
    for i, v in ipairs(itemList) do
        local widget = GUI:Image_Create(parent, widgetName .. "Image" .. i, data["imgX"], data["imgY"], data["imgRes"])
        --GUI:setContentSize(widget,data["imgWidth"],data["imgHeight"])
        GUI:setScale(widget, data["imgScale"])
        local ImageSize = GUI:getContentSize(widget)
        if data["effectId"] > 0 then
            local effect = GUI:Effect_Create(widget, widgetName .. "effect" .. i, data["effectX"], data["effectY"], 0, data["effectId"])
            GUI:setScale(effect, data["effectScale"])
        end
        local itemIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1])
        local item = GUI:ItemShow_Create(widget, widgetName .. "Item" .. i, ImageSize.width / 2, ImageSize.height / 2, { index = itemIdx, count = v[2], look = data["ItemLook"], bgVisible = nil })
        GUI:setAnchorPoint(item, 0.50, 0.50)
        GUI:ItemShow_setItemTouchSwallow(item, true)
        GUI:setScale(item, data["itemScale"])
        table.insert(widgets, widget)
    end
    local x = data["imgX"]
    local y = data["imgY"]
    local spacing = data["spacing"]
    for _, widget in ipairs(widgets) do
        GUI:setPosition(widget, x, y)
        x = x + GUI:getContentSize(widget).width + spacing
    end
    return widgets
end
--添加横向排列的物品列表，增加是否显示tips
function ssrAddItemListXEX(parent, itemList, widgetName, data)
    GUI:removeAllChildren(parent)
    data = data or {}
    data["imgRes"] = data["imgRes"] or "res/custom/public/itemBG.png"  --底图
    data["imgX"] = data["imgX"] or 0                                --坐标X
    data["imgY"] = data["imgY"] or 0                                --坐标Y
    data["spacing"] = data["spacing"] or 0                          --间距
    data["imgScale"] = data["imgScale"] or 1                        --底图缩放
    data["effectId"] = data["effectId"] or 0                        --特效ID
    data["effectX"] = data["effectX"] or 0                          --特效X
    data["effectY"] = data["effectY"] or 0                          --特效Y
    data["effectScale"] = data["effectScale"] or 1                  --特效缩放
    data["ItemLook"] = data["ItemLook"] or true                     --物品数量显示
    data["itemScale"] = data["itemScale"] or 1                      --物品缩放
    local widgets = {}
    for i, v in ipairs(itemList) do
        local widget = GUI:Image_Create(parent, widgetName .. "Image" .. i, data["imgX"], data["imgY"], data["imgRes"])
        --GUI:setContentSize(widget,data["imgWidth"],data["imgHeight"])
        GUI:setScale(widget, data["imgScale"])
        local ImageSize = GUI:getContentSize(widget)
        if data["effectId"] > 0 then
            local effect = GUI:Effect_Create(widget, widgetName .. "effect" .. i, data["effectX"], data["effectY"], 0, data["effectId"])
            GUI:setScale(effect, data["effectScale"])
        end
        local itemIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1])
        local isLook = (v[3] == nil)
        local isNoMouseTips = (v[3] ~= nil)
        local item = GUI:ItemShow_Create(widget, widgetName .. "Item" .. i, ImageSize.width / 2, ImageSize.height / 2, { index = itemIdx, count = v[2], look = isLook, noMouseTips = isNoMouseTips, bgVisible = nil })
        GUI:setAnchorPoint(item, 0.50, 0.50)
        GUI:ItemShow_setItemTouchSwallow(item, true)
        GUI:setScale(item, data["itemScale"])
        table.insert(widgets, widget)
    end
    local x = data["imgX"]
    local y = data["imgY"]
    local spacing = data["spacing"]
    for _, widget in ipairs(widgets) do
        GUI:setPosition(widget, x, y)
        x = x + GUI:getContentSize(widget).width + spacing
    end
    return widgets
end

--创建多行富文本
---* parent：父级
---* ID：控件ID
---* x：坐标X
---* y：坐标Y
---* textData：文本内容(数组)
---* lineHeight：行高
---* width：宽度
---* fontSize：字体大小
---* fontColor：字体颜色
---* vspace：行间距
---* anchorx：锚点X
---* anchory：锚点Y
function createMultiLineRichText(parent, ID, x, y, textData, lineHeight, width, fontSize, fontColor, vspace, anchorx,anchory)
    if not parent then
        return
    end
    if #textData == 0 then
        return
    end
    ID = ID or "RichText"
    x = x or 0
    y = y or 0
    anchorx = anchorx or 0
    anchory = anchory or 0
    lineHeight = lineHeight or 22
    width = width or 500
    fontSize = fontSize or 16
    fontColor = fontColor or "#FFFFFF"
    vspace = vspace or 2
    GUI:removeAllChildren(parent)
    for i, v in ipairs(textData) do
        local content = ""
        local strArr = SL:Split(v, "|")
        for _, v2 in ipairs(strArr) do
            local str = SL:Split(v2, "#")
            local colorNum = tonumber(str[2])
            colorNum = colorNum or 255
            local hexColor = SL:GetHexColorByStyleId(colorNum)
            content = content .. "<font color='" .. hexColor .. "'>" .. str[1] .. "</font>"
        end
        local RText = GUI:RichText_Create(parent, ID .. i, x, y, content, width, fontSize, fontColor, vspace, nil, "fonts/font2.ttf")
        GUI:setAnchorPoint(RText, anchorx, anchory)
        y = y - lineHeight
    end
end


--添加红点，从右上角开始
function addRedPoint(widget, x, y)
    x = x or 24
    y = y or 5
    local redPointWidget = GUI:getChildByName(widget, "redPoint_")
    if redPointWidget then
        return
    end
    local parentSize = GUI:getContentSize(widget)
    --local redPoint = GUI:Image_Create(widget, "redPoint_", parentSize.width-x, parentSize.height-y,"res/public/btn_npcfh_04.png")
    local redPoint = GUI:Effect_Create(widget, "redPoint_", parentSize.width - x, parentSize.height - y, 0, 20000, 0, 0, 0, 0.8)
end

--删除红点
function delRedPoint(widget)
    local redPointWidget = GUI:getChildByName(widget, "redPoint_")
    if GUI:Win_IsNull(redPointWidget) then
        return
    end
    GUI:removeFromParent(redPointWidget)
end

--显示消耗
---* parent 父级节点
---* cost 消耗数组
function showCost(parent, cost, spacing, data)
    --SL:dump(cost)
    GUI:removeAllChildren(parent)
    data = data or {}
    data.width = data.width or 66
    data.height = data.height or 66
    data.itemBG = data.itemBG or "res/custom/public/itemBG.png"
    data.textX = data.textX or 34
    data.textY = data.textY or 4
    spacing = spacing or 15
    for i, value in ipairs(cost) do
        local itemIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", value[1])
        local ImageView = GUI:Image_Create(parent, "ImageView_" .. i, 10.00, 9.00, data.itemBG)
        GUI:setContentSize(ImageView, data.width, data.height)
        local bgSize = GUI:getContentSize(ImageView)
        local Item = GUI:ItemShow_Create(ImageView, "Item_" .. i, bgSize.width / 2, bgSize.height / 2,
                { index = tonumber(itemIdx), count = 1, look = true, bgVisible = nil })
        GUI:setAnchorPoint(Item, 0.5, 0.5)
        GUI:ItemShow_setItemTouchSwallow(Item, true)
        GUI:Win_SetParam(ImageView, i)
        --货币显示
        local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", value[1]))
        local myItemCount
        if Player:isCurrency(idx) then
            myItemCount = SL:GetMetaValue("MONEY_ASSOCIATED", idx)
        else
            myItemCount = SL:GetMetaValue("ITEM_COUNT", idx)
        end
        if value[3] then
            local bodyEquipName = Player:getEquipNameByPos(value[3])
            if bodyEquipName == value[1] then
                myItemCount = 1
            else
                myItemCount = 0
            end
        end
        myItemCount = tonumber(myItemCount)
        local needItemCount = value[2]
        local textColor = myItemCount >= needItemCount and "#00FF00" or "#FF0000"
        local textStr = SL:GetSimpleNumber(myItemCount, 2) .. "/" .. SL:GetSimpleNumber(needItemCount, 2)
        local textCount = GUI:Text_Create(ImageView, "MONEY_COUNT" .. i, data.textX, data.textY, 16, textColor, textStr)
        GUI:setAnchorPoint(textCount, 0.5, 0.5)
    end

    GUI:UserUILayout(parent, {
        dir = 2,
        autosize = 1,
        gap = { x = spacing },
        sortfunc = function(lists)
            table.sort(lists, function(a, b)
                return GUI:Win_GetParam(a) < GUI:Win_GetParam(b)
            end)
        end
    })
end

--显示消耗文字方式
---* parent 父级节点
---* cost 消耗数组
---
-----showCostFont(self.ui.itemlooks, cfg.cost,{dir=0,spacing=7,fontSize=14,fontColor="#FFFFFF"})  --挂载消耗显示
function showCostFont(parent, cost, data)
    GUI:removeAllChildren(parent)
    local isPc = SL:GetMetaValue("WINPLAYMODE")
    data = data or {}
    data.dir = data.dir or 1 --默认水平排列
    data.textX = data.textX or 10 --坐标便宜
    data.fontSize = data.fontSize or 18
    data.fontColor = data.fontColor or "#FFFFFF"
    data.spacing = data.spacing or 10
    data.hideName = data.hideName or false
    local x = 0
    local y = 0
    for i, value in ipairs(cost) do
        local moneyName = value[1]
        local itemIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", value[1])
        if data.hideName then
            moneyName = ""
        end
        local Text_Cost_Name = GUI:Text_Create(parent, "Text_Cost_Name_" .. i, 0, 0, data.fontSize, data.fontColor, moneyName)
        GUI:setTouchEnabled(Text_Cost_Name, true)
        local tipsData = {}
        tipsData.typeId = itemIdx
        if isPc then
            GUI:addMouseMoveEvent(Text_Cost_Name, { onEnterFunc = function(widget)
                local pos = GUI:getWorldPosition(Text_Cost_Name)
                tipsData.pos = pos
                ssr.OpenItemTips(tipsData)
            end,
                                                    onLeaveFunc = function()
                                                        ssr.CloseItemTips()
                                                    end })
        else
            GUI:addOnClickEvent(Text_Cost_Name, function(widget)
                local pos = GUI:getWorldPosition(widget)
                tipsData.pos = pos
                ssr.OpenItemTips(tipsData)
            end)
        end
        local Text_Cost_Name_BgSize = GUI:getContentSize(Text_Cost_Name)
        GUI:Win_SetParam(Text_Cost_Name, i)
        --货币显示
        local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", value[1]))
        local myItemCount
        if Player:isCurrency(idx) then
            myItemCount = SL:GetMetaValue("MONEY_ASSOCIATED", idx)
        else
            myItemCount = SL:GetMetaValue("ITEM_COUNT", idx)
        end
        if value[3] then
            myItemCount = 1
        end
        myItemCount = tonumber(myItemCount)
        local needItemCount = value[2]
        local textColor = myItemCount >= needItemCount and "#00FF00" or "#FF0000"
        local textStr = SL:GetSimpleNumber(myItemCount, 2) .. "/" .. SL:GetSimpleNumber(needItemCount, 2)
        local textCount = GUI:Text_Create(Text_Cost_Name, "MONEY_COUNT" .. i, Text_Cost_Name_BgSize.width + data.textX, 0, data.fontSize, textColor, textStr)
        local textCountSize = GUI:getContentSize(textCount)
        GUI:setPosition(Text_Cost_Name, x, y)
        if data.dir == 1 then
            x = i * (Text_Cost_Name_BgSize.width + textCountSize.width + data.textX + data.spacing)
        else
            y = -(i * (textCountSize.height + data.spacing))
        end
    end

end

--合成面板的属性显示
function attrListShow(parent, attrList)
    if not parent then
        return
    end
    GUI:removeAllChildren(parent)
    local parentHeight = GUI:getContentSize(parent).height or 0
    local parentWidth = GUI:getContentSize(parent).width or 0
    for i, value in ipairs(attrList) do
        local attrStr = value[1]
        local attrColor = value[2]
        local attrText = GUI:Text_Create(parent, "Text_" .. i, parentWidth, parentHeight - (i - 1) * 30, 16, attrColor, attrStr)
        GUI:Text_enableOutline(attrText, "#000000", 1)
        -- GUI:Text_setTextVerticalAlignment(attrText, 1)
        GUI:setAnchorPoint(attrText, 1, 0.5)
    end
end

-----------------动画相关-----------------
--播放左右移动动画
function playMoveAction(widget, moveX, time, delay, callBack)
    delay = delay or 0
    local OriginalPosition = GUI:getPosition(widget)
    local startPositionX = GUI:getPositionX(widget) + moveX
    GUI:setPositionX(widget, startPositionX)
    if delay > 0 then
        GUI:Timeline_Hide(widget, 0)
        GUI:Timeline_Show(widget, delay)
        GUI:Timeline_DelayTime(widget, delay, function()
            GUI:Timeline_EaseSineOut_MoveTo(widget, OriginalPosition, time, callBack)
        end)
    else
        GUI:Timeline_EaseSineOut_MoveTo(widget, OriginalPosition, time, callBack)
    end
end

--设置已领取状态
function SetClaimedStatus(widget, resPath, offset)
    if not widget or not resPath then
        return
    end
    offset.x = offset.x or 0
    offset.y = offset.y or 0
    local post = GUI:getPosition(widget)
    GUI:setPosition(widget,post.x + offset.x, post.y + offset.y)
    GUI:Button_loadTextureNormal(widget,resPath)
    GUI:Button_setBrightEx(widget, false)
    GUI:Button_setGrey(widget, false)
end

--显示完成未完成的状态
function SetCompletionStatus(bool)
    local str = ""
    if bool then
        str = "<font color='#00FF00' size='16' >(完成)</font>"
    else
       str = "<font color='#FF0000' size='16' >(未完成)</font>"
    end
    return str
end
--显示完成的进度
function SetCompletionProgress(num1, num2)
    local str = ""
    if num1 >= num2 then
        num1 = num2
        str = string.format("<font color='#00FF00' size='16' >(%d/%d)</font>",num1,num2)
    else
       str = string.format("<font color='#FF0000' size='16' >(%d/%d)</font>",num1,num2)
    end
    return str
end

--格式化字符串可变参数
function StringFormat(fmt,...)
    local args = {...}
    local argCount = select('#', ...)

    -- 计算格式字符串中的占位符数量
    local placeholderCount = select(2, fmt:gsub("%%s", ""))

    -- 只保留有效参数并替换为空字符串
    for i = 1, placeholderCount do
        if i > argCount or args[i] == nil then
            args[i] = "" -- 替换为空字符串
        end
    end

    -- 调用 string.format 只传递匹配数量的参数
    return string.format(fmt, unpack(args, 1, placeholderCount))
end

function CheckTaskIsFinishEx(taskData)
    for i, v in ipairs(taskData) do
        if not CheckTaskIsFinish(v) then
            return false
        end
    end
    return true
end