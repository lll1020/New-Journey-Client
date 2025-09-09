LeftTopOBJ = {}
LeftTopOBJ.__cname = "LeftTopOBJ"
-------------------------------↓↓↓ UI操作 ↓↓↓---------------------------------------
function LeftTopOBJ:main()

end


local function createLeftPanel()
    local parent = GUI:Win_FindParent(101)
    if parent then
        if GUI:getChildByName(parent, "ImageView") then
           GUI:removeChildByName(parent, "ImageView")
        end
        local ImageView = GUI:Image_Create(parent, "ImageView", -1.00, -34.00, "res/custom/LeftTop/bg.png")
        GUI:setLocalZOrder(ImageView,-1)
        local TextAtlas_1 = GUI:TextAtlas_Create(ImageView, "TextAtlas_1", 56.00, 4.00, "0", "res/custom/public/text1.png", 14, 30, ".")
    end
end

--重载初始化
function LeftTopOBJ:reloadInit()
    if not self.ui then
        local parent = GUI:Win_FindParent(101)
        self.ui = GUI:ui_delegate(parent)
    end
end

--显示战斗力
function LeftTopOBJ:ShowPower()
    self:reloadInit()
    local varValue =  Player:getServerVar("B2")
    local startValue = GUI:TextAtlas_getString(LeftTopOBJ.ui.TextAtlas_1)
    animateNumberTransition(tonumber(startValue),tonumber(varValue),0.2,20,function (value)
        GUI:TextAtlas_setString(LeftTopOBJ.ui.TextAtlas_1, tostring(value))
    end)
end

-- 优先加载界面
local function onEnterGameWorld()
    createLeftPanel()
end
--进入游戏触发
SL:RegisterLUAEvent(LUA_EVENT_ENTER_WORLD, "LeftTop", onEnterGameWorld)

-- 处理器映射表
local valueHandlers = {
    --战斗力
    ["B2"] = function(data)
        LeftTopOBJ:ShowPower()
    end,
}

local function onServerValueChange(data)
    local handler = valueHandlers[data.key]
    if handler then
        handler(data)
    end
end

SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "LeftTop", onServerValueChange)


-------------------------------↓↓↓ 网络消息 ↓↓↓---------------------------------------
--登录同步消息
--function LeftTopOBJ:SyncResponse(arg1, arg2, arg3, data)
--    self.data = data
--    if GUI:GetWindow(nil, self.__cname) then
--        --self:UpdateUI()
--    end
--end


return LeftTopOBJ