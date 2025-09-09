-- 玩家面板 外框
PlayerFrame = {}
PlayerFrame._ui = nil

-- 内部UI的映射关系
PlayerFrame._uiMap = {
    [1] = 3,
    [11] = 3,
    [2] = 1,
    [3] = 1,
    [4] = 1,
    [5] = 1,
    [6] = 1

}
-- 页签数组
PlayerFrame._pageIDarr = {}
PlayerFrame._lastPageidarr = {}
-- 页签ID
--[[
    MAIN_PLAYER_LAYER_EQUIP         = 1,
	MAIN_PLAYER_LAYER_BASE_ATTRI    = 2,
	MAIN_PLAYER_LAYER_EXTRA_ATTRO   = 3,
	MAIN_PLAYER_LAYER_SKILL         = 4,
	MAIN_PLAYER_LAYER_TITLE         = 6,
	MAIN_PLAYER_LAYER_SUPER_EQUIP   = 11,
]]
PlayerFrame._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF,
}
-- 打开页签 基础
PlayerFrame.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF]        =  SL.OpenPlayerBuffUI,
}

-- 内功
PlayerFrame._pageNGIDs = {1, 2, 3, 4}
-- 打开页签 内功
PlayerFrame.OpenNGFunc = {
    [1]         =  SL.OpenInternalStateUI,
    [2]         =  SL.OpenInternalSkillUI,
    [3]         =  SL.OpenInternalMerdianUI,
    [4]         =  SL.OpenInternalComboUI,
}

PlayerFrame.OpenType = {
    Self = 1 --自己
}

PlayerFrame._showType = 1    -- 1 基础 2 内功

function PlayerFrame.main(data)
    PlayerFrame._pageIDarr = {}
    PlayerFrame._lastPageidarr = {}
    local parent = GUI:Attach_Parent()
    PlayerFrame._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1
    if PlayerFrame._NGShow then
        GUI:LoadExport(parent, "player/player_layer_ng")
    else
        GUI:LoadExport(parent, "player/player_layer")
    end
    PlayerFrame._ui = GUI:ui_delegate(parent)
    PlayerFrame._parent = parent
    PlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._showType = data and data.type or 1
    if not PlayerFrame._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(PlayerFrame._ui.Panel_1, SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, PlayerFrame._ui.Panel_1)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, PlayerFrame._ui.Panel_1)

    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(PlayerFrame._ui.Text_Name, true)

    -- 关闭
    local closeButton = PlayerFrame._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton,function()
            SL:CloseMyPlayerUI()
        end)
    end
    --添加修仙红点
    local xiuXianFlag = getServerVar("{70}")
    if xiuXianFlag == "1" then
        local level = tonumber(Player:getEquipFieldByPos(43, 1))
        if level < 21 then
            addRedPoint(PlayerFrame._ui.Button_xiuXian,20,6)
        end
    end
    --检测引导
    PlayerFrame.StartGuide()
    -- 注册事件
    PlayerFrame.RegisterEvent()

    GUI:setTouchEnabled(PlayerFrame._ui.Panel_btnList, false)

    -- 刷新名字
    PlayerFrame.RefreshPlayerName()

    -- 切换内功显示
    PlayerFrame._initBtn = {}
    if PlayerFrame._NGShow then
        PlayerFrame.InitTopTypePanel()
        PlayerFrame.OnChangeTopShow()
    end
    -- 初始化页签
    PlayerFrame.InitPageChangeBtn()
    --PlayerFrame.OpenPage(PlayerFrame._pageid, {init = true, pageId = PlayerFrame._pageid})
    --先打开映射的页面
    local id = PlayerFrame._uiMap[PlayerFrame._pageid]
    PlayerFrame._pageIDarr[1] = id
    PlayerFrame.OpenPage(id, {init = true, pageId = id})

    --打开正常的页面
    PlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._pageIDarr[2] = PlayerFrame._pageid
    PlayerFrame.OpenPage(PlayerFrame._pageid, {init = true, pageId = PlayerFrame._pageid})
end

function PlayerFrame.StartGuide()

end

function PlayerFrame.InitTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(PlayerFrame._ui[name], PlayerFrame._showType ~= i)
        GUI:setLocalZOrder(PlayerFrame._ui[name], PlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(PlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, PlayerFrame._showType == i and "#f8e6c6" or "#807256")
        GUI:addOnClickEvent(PlayerFrame._ui[name], function()
            if PlayerFrame._showType == i then
                return
            end
            PlayerFrame.ChangeShowType(i)
            PlayerFrame.OpenPage(1, {pageId = 1})
        end)
    end
end

function PlayerFrame.RefreshTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(PlayerFrame._ui[name], PlayerFrame._showType ~= i)
        GUI:setLocalZOrder(PlayerFrame._ui[name], PlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(PlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, PlayerFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

function PlayerFrame.InitPageChangeBtn()
    local btnList = PlayerFrame._ui.Panel_btnList
    if PlayerFrame._NGShow then
        btnList = PlayerFrame._showType == 1 and PlayerFrame._ui.Panel_btnList or PlayerFrame._ui.Panel_btnList_ng
        GUI:setVisible(PlayerFrame._ui.Panel_btnList, PlayerFrame._showType == 1)
        GUI:setVisible(PlayerFrame._ui.Panel_btnList_ng, PlayerFrame._showType == 2)
        if PlayerFrame._ui.Panel_btnList_left then
            GUI:setVisible(PlayerFrame._ui.Panel_btnList_left, PlayerFrame._showType == 1)
        end
    end
    local menu_groupID = PlayerFrame._showType == 1 and 1 or 7
    local pageIDList = PlayerFrame._showType == 1 and PlayerFrame._pageIDs or PlayerFrame._pageNGIDs
    if not PlayerFrame._initBtn[PlayerFrame._showType] then
        for i, pageId in ipairs(pageIDList) do
            local configId = pageId + (100 * menu_groupID)
            if pageId == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP then
                configId = 1000 + SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
            end
            local btnName = "Button_" .. pageId
            local panelBtn = GUI:getChildByName(btnList, btnName)
            if not panelBtn and PlayerFrame._ui.Panel_btnList_left then
                panelBtn =  GUI:getChildByName(PlayerFrame._ui.Panel_btnList_left, btnName)
            end
            if panelBtn then
                local textName = GUI:getChildByName(panelBtn, "Text_name")
                GUI:setLocalZOrder(panelBtn, PlayerFrame._pageid == pageId and 1 or 0)
                GUI:addOnClickEvent(
                    panelBtn,
                    function()
                        if not SL:CheckMenuLayerConditionByID(configId) then
                            SL:ShowSystemTips("条件不满足!")
                            return
                        end
                        if PlayerFrame._pageid == pageId then
                            return
                        end
                        --点击切换
                        --打开映射的
                        local id = PlayerFrame._uiMap[pageId]
                        PlayerFrame.OpenPage(id, {pageId = id})
                        --打开正常的
                        PlayerFrame.OpenPage(pageId, {pageId = pageId})
                    end
                )
            end
        end
        PlayerFrame._initBtn[PlayerFrame._showType] = true
    end
end

function PlayerFrame.ChangeShowType(i)
    if PlayerFrame._showType == i then
        return
    end
    PlayerFrame._lastType = PlayerFrame._showType
    PlayerFrame._showType = i
    PlayerFrame.RefreshTopTypePanel()
    PlayerFrame.InitPageChangeBtn()
end

function PlayerFrame.RefreshPlayerName()
    local Text_Name = PlayerFrame._ui.Text_Name
    local Name = SL:GetMetaValue("USER_NAME")
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

function PlayerFrame.RefreshBtnState()
    local btnList = PlayerFrame._ui.Panel_btnList
    if PlayerFrame._NGShow then
        btnList = PlayerFrame._showType == 1 and PlayerFrame._ui.Panel_btnList or PlayerFrame._ui.Panel_btnList_ng
    end
    local childs = GUI:getChildren(btnList)
    if PlayerFrame._ui.Panel_btnList_left then
        for _, child in ipairs(GUI:getChildren(PlayerFrame._ui.Panel_btnList_left)) do
            table.insert(childs, child)
        end
    end
    for _, child in ipairs(childs) do
        local isSelected = GUI:getName(child) == ("Button_" .. PlayerFrame._pageid)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local Image_name = GUI:getChildByName(child, "Image_name")
        GUI:Image_setGrey(Image_name, not isSelected)
    end
end

-- 切页
function PlayerFrame.ChangePage(data)
    PlayerFrame._lastPageidarr = SL:CopyData(PlayerFrame._pageIDarr)
    PlayerFrame.addAndKeepTwo(PlayerFrame._pageIDarr, data.index)
    PlayerFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    PlayerFrame.RefreshBtnState()
    local function findUniqueElement(tbl1, tbl2)
        local isInTbl2 = {}  -- 用于标记 tbl2 中的元素
        for _, v in ipairs(tbl2) do
            isInTbl2[v] = true
        end

        for _, v in ipairs(tbl1) do
            if not isInTbl2[v] then
                return v  -- 返回不同的元素
            end
        end

        return nil
    end
    local delID = findUniqueElement(PlayerFrame._lastPageidarr, PlayerFrame._pageIDarr)
    if PlayerFrame._lastType == 1 then
        if delID then
            SL:CloseMyPlayerPageUI(delID)
        end
        PlayerFrame._lastType = false
    elseif PlayerFrame._lastType == 2 then
        if delID then
            SL:CloseMyPlayerInternalPageUI(delID)
        end
        PlayerFrame._lastType = false
    elseif not data.init then
        if data.isInternal then
            if delID then
                SL:CloseMyPlayerInternalPageUI(delID)
            end
        else
            if delID then
                SL:CloseMyPlayerPageUI(delID)
            end
        end
    end

    PlayerFrame.CreateLayerPanelChild(data)
end

-- 添加子页面到外框
function PlayerFrame.CreateLayerPanelChild(data)
    local panel = data.child
    local widgetObj
    if PlayerFrame.ShowPosition(data.index) == 1 then
        widgetObj = PlayerFrame._ui.Node_panel
    else
        widgetObj = PlayerFrame._ui.Node_attr
    end
    if panel then
        GUI:addChild(widgetObj, panel)
    end
end

-- 切换子页面
function PlayerFrame.ChangeOpenedPage(id, data)
    local map = PlayerFrame._uiMap[id]
    PlayerFrame.OpenPage(map)
    PlayerFrame.OpenPage(id)
end

-- 关闭外框
function PlayerFrame.OnCloseMainLayer()
    PlayerFrame.UnRegisterEvent()
    --关闭子页
    if PlayerFrame._showType == 1 then
        SL:CloseMyPlayerPageUI(PlayerFrame._pageIDarr[1])
        SL:CloseMyPlayerPageUI(PlayerFrame._pageIDarr[2])
    else
        SL:CloseMyPlayerInternalPageUI(PlayerFrame._pageIDarr[1])
        SL:CloseMyPlayerInternalPageUI(PlayerFrame._pageIDarr[2])
    end
end

-- 打开子页签
function PlayerFrame.OpenPage(id, data)
    local openFunc = PlayerFrame._showType == 1 and PlayerFrame.OpenFunc[id] or PlayerFrame.OpenNGFunc[id]
    local openType = PlayerFrame.OpenType.Self
    if openFunc then
        openFunc(SL, openType, data)
    end
end

-- 刷新内功顶部栏显示
function PlayerFrame.OnChangeTopShow()
    if PlayerFrame._NGShow then
        if SL:GetMetaValue("IS_LEARNED_INTERNAL") then
            GUI:setVisible(PlayerFrame._ui["topLayout"], true)
        else
            GUI:setVisible(PlayerFrame._ui["topLayout"], false)
        end
    end
end

--判断显示位置
function PlayerFrame.ShowPosition(index)
    if index == 1 then
        return 1
    elseif index == 11 then
        return 1
    else
        return 2
    end
end

function PlayerFrame.addAndKeepTwo(tbl, newItem)
    if tbl[#tbl] == newItem then
        return
    end
    table.insert(tbl, newItem)
    while #tbl > 2 do
        table.remove(tbl, 1)
    end
end

function PlayerFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame", PlayerFrame.ChangePage)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame", PlayerFrame.RefreshPlayerName)
    --学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame", PlayerFrame.OnChangeTopShow)
end

function PlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame")
end
