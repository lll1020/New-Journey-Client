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
    if not self:reloadInit() then
        return
    end
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

local function hasLeftAttrUI()
    return LeftAttrOBJ.ui
        and LeftAttrOBJ.ui.ImageView
        and LeftAttrOBJ.ui.HideButton
        and LeftAttrOBJ.ui.gongSu
        and LeftAttrOBJ.ui.qieGe
        and LeftAttrOBJ.ui.baoLv
        and LeftAttrOBJ.ui.beiGong
        and LeftAttrOBJ.ui.fuHuo
end

--buff改变触发
function LeftAttrOBJ:onBuffUpdate(t)
    if not self:reloadInit() then
        return
    end
    if t.buffID == 20060 or t.buffID == 20078 then
        if t.type == 0 or t.type == 1 then
            local rwid = SL:GetMetaValue("MAIN_ACTOR_ID")
            local hb16 = tonumber(SL:GetMetaValue("MONEY",16))
            local hb14 = tonumber(SL:GetMetaValue("MONEY",14))
            local hb15 = tonumber(SL:GetMetaValue("MONEY",15))
            local baoLv = ((SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060) and 0 or hb16) + hb15) > 0 and "[可复活]" or "[不可复活]"
            GUI:Text_setTextColor(self.ui.fuHuo, ((SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060) and 0 or hb16) + hb15) > 0 and "#00FF00" or "#FF0000")
            GUI:Text_setString(self.ui.fuHuo, baoLv)
        end
    end
end

function LeftAttrOBJ:onAttrChange()
    if not self:reloadInit() then
        return
    end
    local qieGe = math.floor(SL:GetMetaValue("ATT_BY_TYPE", 244)*(1 + SL:GetMetaValue("ATT_BY_TYPE", 253)/10000))
    local baoLv = SL:GetMetaValue("ATT_BY_TYPE", 242)/100
    local gongSu = SL:GetMetaValue("ATT_BY_TYPE", 200)/100
    local beiGong = SL:GetMetaValue("ATT_BY_TYPE", 67)/100
    GUI:Text_setString(self.ui.qieGe, qieGe)
    GUI:Text_setString(self.ui.baoLv, baoLv .. "%")
    GUI:Text_setString(self.ui.gongSu, gongSu .. "%")
    GUI:Text_setString(self.ui.beiGong, string.format("%.3f倍", (beiGong + 100) / 100))

    local rwid = SL:GetMetaValue("MAIN_ACTOR_ID")
    local hb16 = tonumber(SL:GetMetaValue("MONEY",16))
    local hb14 = tonumber(SL:GetMetaValue("MONEY",14))
    local hb15 = tonumber(SL:GetMetaValue("MONEY",15))

    local baoLv = ((SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060) and 0 or hb16) + hb15) > 0 and "[可复活]" or "[不可复活]"
    GUI:Text_setTextColor(self.ui.fuHuo, ((SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060) and 0 or hb16) + hb15) > 0 and "#00FF00" or "#FF0000")
    GUI:Text_setString(self.ui.fuHuo, baoLv)



end


-- 优先加载界面
--重载初始化
function LeftAttrOBJ:reloadInit()
    if hasLeftAttrUI() then
        return true
    end
    local parent = GUI:Win_FindParent(105)
    if not parent then
        self.ui = nil
        return false
    end
    if not GUI:getChildByName(parent, "ImageView") then
        createLeftPanel()
    else
        self.ui = GUI:ui_delegate(parent)
    end
    return hasLeftAttrUI()
end

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
