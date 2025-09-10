LeftAttrOBJ = {}
LeftAttrOBJ.__cname = "LeftAttrOBJ"
LeftAttrOBJ.scheduleID = nil
if ssrConstCfg.isPc then
    LeftAttrOBJ.left_position_hide = { x = -200, y = -36 - 40 }
    LeftAttrOBJ.left_position_show = { x = 0, y = -36 - 40 }
else
    LeftAttrOBJ.left_position_hide = { x = -200, y = -96 - 40 }
    LeftAttrOBJ.left_position_show = { x = 0, y = -96 - 40 }
end
-------------------------------↓↓↓ UI操作 ↓↓↓---------------------------------------
function LeftAttrOBJ:main()

end

function LeftAttrOBJ:HideandShow(bool)
    local function visible()
        if self.IsShow then
            GUI:Timeline_EaseSineIn_MoveTo(self.ui.ImageView, self.left_position_hide, 0.1)
        else
            GUI:Timeline_EaseSineIn_MoveTo(self.ui.ImageView, self.left_position_show, 0.1)
        end
    end
    if bool then
        if self.IsShow then
            GUI:Timeline_RotateTo(self.ui.HideButton, 180, 0.1, visible)
        else
            GUI:Timeline_RotateTo(self.ui.HideButton, 0, 0.1, visible)
        end
    else
        visible()
    end
end

local function createLeftPanel()
    local parent = GUI:Win_FindParent(105)
    if parent then
        GUI:removeAllChildren(parent)
        local node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
        local ImageView = GUI:Image_Create(node, "ImageView", 0.00, LeftAttrOBJ.left_position_show.y, "res/custom/LeftAttr/bg.png")
        local defaultY = 137
        GUI:Text_Create(ImageView, "gongSu", 70, defaultY, 15, "#21faf2", "")
        defaultY = defaultY - 26
        GUI:Text_Create(ImageView, "qieGe", 70, defaultY, 15, "#21faf2", "")
        defaultY = defaultY - 26
        GUI:Text_Create(ImageView, "baoLv", 70, defaultY, 15, "#21faf2", "")
        defaultY = defaultY - 26
        GUI:Text_Create(ImageView, "beiGong", 70, defaultY, 15, "#21faf2", "")
        defaultY = defaultY - 26
        GUI:Text_Create(ImageView, "fuHuo", 70, defaultY, 15, "#FF0000", "")
        defaultY = defaultY - 26
        GUI:Text_Create(ImageView, "zhuangTai", 70, defaultY, 15, "#00FF00", "脱战状态")
        local HideButtonY = LeftAttrOBJ.left_position_show.y - 14
        local HideButton = GUI:Button_Create(node, "HideButton", 14, HideButtonY, "res/custom/LeftAttr/btn.png")
        GUI:setTouchEnabled(HideButton, true)
        GUI:setAnchorPoint(HideButton, 0.5, 0.5)
        LeftAttrOBJ.ui = GUI:ui_delegate(parent)
        GUI:addOnClickEvent(LeftAttrOBJ.ui.HideButton, function()
            LeftAttrOBJ.IsShow = not LeftAttrOBJ.IsShow
            LeftAttrOBJ:HideandShow(true)
        end)
    end
end
--buff改变触发
function LeftAttrOBJ:onBuffUpdate(t)
    self:reloadInit()
end

function LeftAttrOBJ:onAttrChange()
    self:reloadInit()
    local qieGe = SL:GetMetaValue("ATT_BY_TYPE", 200)
    local baoLv = SL:GetMetaValue("ATT_BY_TYPE", 204)
    local gongSu = SL:GetMetaValue("ATT_BY_TYPE", 228)
    GUI:Text_setString(self.ui.qieGe, qieGe)
    GUI:Text_setString(self.ui.baoLv, baoLv .. "%")
    GUI:Text_setString(self.ui.gongSu, gongSu + 100 .. "%")
end

--重载初始化
function LeftAttrOBJ:reloadInit()
    if not self.ui then
        local parent = GUI:Win_FindParent(105)
    end
end

-- 优先加载界面
local function onEnterGameWorld()
    LeftAttrOBJ.isInit = true
    createLeftPanel()
end
--进入游戏触发
SL:RegisterLUAEvent(LUA_EVENT_ENTER_WORLD, "LeftAttr", onEnterGameWorld)

-- BUFF触发
local function onBuffUpdate(t)
    LeftAttrOBJ:onBuffUpdate(t)
end
SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "LeftAttr", onBuffUpdate)

-- 属性触发
local function onAttrChange()
    LeftAttrOBJ:onAttrChange()
end
SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "LeftAttr", onAttrChange)

-------------------------------↓↓↓ 网络消息 ↓↓↓---------------------------------------

return LeftAttrOBJ
