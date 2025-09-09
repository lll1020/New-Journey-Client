MainTarget = {}
MainTarget.config = ssrRequireCsvCfg("cfg_TouShi")
MainTarget.jobIconPath = {
    "res/private/main/Target/1900012533.png",
    "res/private/main/Target/1900012534.png",
    "res/private/main/Target/1900012535.png"
}
MainTarget.heroJobIconPath = {
    "res/private/main/Target/1900012537.png",
    "res/private/main/Target/1900012538.png",
    "res/private/main/Target/1900012539.png"
}
MainTarget.monsterIconPath = "res/private/main/Target/1900012536.png"

MainTarget._targetID = nil
--物品展示
MainTarget.ListViewIsShow = false

function MainTarget.main(...)
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end
    GUI:LoadExport(parent, "main/main_target")
    MainTarget.UI = GUI:ui_delegate(parent)
    GUI:setPositionY(MainTarget.UI.Node, SL:GetMetaValue("WINPLAYMODE") and -222 or -219)
    GUI:setPositionX(MainTarget.UI.Node, SL:GetMetaValue("WINPLAYMODE") and -2 or -2)

    MainTarget._panel = MainTarget.UI.Panel_1
    GUI:setVisible(MainTarget.UI.Node, false)
    GUI:addOnClickEvent(MainTarget._panel, MainTarget.OnClickTargetPanel)

    GUI:Text_setString(MainTarget.UI.nameText, "")
    local size = SL:GetMetaValue("WINPLAYMODE") and 13 or 16
    local scrollText = GUI:ScrollText_Create(MainTarget.UI.nameText, "scrollText", 0, 0, 115, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    MainTarget._scrollNameText = scrollText

    -- 目标是否显示  PC不显示
    MainTarget._isShowTargetPanel = true
	
	if MainTarget._LockUIState == nil and MainTarget.UI.LockPanel then
        MainTarget._LockUIState = GUI:getVisible(MainTarget.UI.LockPanel)
    end

    -- 宠物锁定
    GUI:addOnClickEvent(MainTarget.UI.LockPanel, MainTarget.OnClickLockPanel)

    -- 取消目标选择
    GUI:addOnClickEvent(MainTarget.UI.cleanBtn, MainTarget.OnClickCleanBtn)

    --显示透视
    GUI:addOnClickEvent(MainTarget.UI.Button_eye, MainTarget.ShowTargetTouShi)

    -- 注册事件
    MainTarget.RegisterEvent()
end

function MainTarget.RegisterEvent()
    -- 选中目标改变
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CAHNGE, "MainTarget", MainTarget.OnTargetChange)
    -- 召唤物存活状态改变
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "MainTarget", MainTarget.OnUpdateLockBtn)
    -- 归属改变
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE, "MainTarget", MainTarget.OnActorOwnerChange)
    -- 目标血量变化
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_HP_CHANGE, "MainTarget", MainTarget.OnRefreshActorHP)
end

-- 点击查看菜单
function MainTarget.OnClickTargetPanel()
    local actor = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not actor then
        return
    end
    if SL:GetMetaValue("ACTOR_IS_PLAYER", actor) then
        SL:OpenFuncDockTips({
            type = SL:GetMetaValue("ACTOR_IS_HUMAN", actor) and SL:GetMetaValue("DOCKTYPE_NENUM").Func_Monster_Head or SL:GetMetaValue("DOCKTYPE_NENUM").Func_Player_Head,
            targetId = SL:GetMetaValue("ACTOR_ID", actor),
            targetName = SL:GetMetaValue("ACTOR_NAME", actor),
            isHero = SL:GetMetaValue("ACTOR_IS_HERO", actor),
            pos = { x = GUI:getTouchEndPosition(MainTarget._panel).x + 15, y = GUI:getTouchEndPosition(MainTarget._panel).y }
        })
    end
end

function MainTarget.OnClickLockPanel()
    local actor = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not actor then
        return
    end

    -- 未存活
    if not SL:GetMetaValue("PET_ALIVE") then
        return
    end
	
	-- F9关闭了
    if MainTarget._LockUIState == false then
        return
    end

    local lockID = SL:GetMetaValue("PET_LOCK_ID")
    if lockID == MainTarget._targetID then
        --已锁定
        GUI:Button_setBright(MainTarget.UI.LockBtn, false)
        SL:RequestUnLockPetID(MainTarget._targetID)
    else
        GUI:Button_setBright(MainTarget.UI.LockBtn, true)
        SL:RequestLockPetID(MainTarget._targetID)
    end
    GUI:delayTouchEnabled(MainTarget.UI.LockPanel)
end

function MainTarget.OnClickCleanBtn()
    -- 取消锁定
    if SL:GetMetaValue("PET_ALIVE") and SL:GetMetaValue("PET_LOCK_ID") == MainTarget._targetID then
        SL:RequestUnLockPetID(MainTarget._targetID)
    end

    SL:SetMetaValue("SELECT_TARGET_ID", nil)
end

function MainTarget.OnTargetChange(targetID)
    local actor = SL:GetMetaValue("ACTOR_DATA", targetID)
    if not targetID or not actor then
        MainTarget.SelectTarget(nil)
    end
    if SL:GetMetaValue("ACTOR_IS_PLAYER", actor) or SL:GetMetaValue("ACTOR_IS_MONSTER", actor) then
    --if SL:GetMetaValue("ACTOR_IS_PLAYER", actor) or (SL:GetMetaValue("ACTOR_IS_MONSTER", actor) and not SL:GetMetaValue("ACTOR_BIGICON_ID", actor)) then
        MainTarget.SelectTarget(targetID)
    else
        MainTarget.SelectTarget(nil)
    end
end

--选择目标
function MainTarget.SelectTarget(targetID)
    MainTarget._targetID = targetID
    local target = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not MainTarget._targetID or not target then
        GUI:setVisible(MainTarget.UI.Node, false)
        return
    end

    if not MainTarget._isShowTargetPanel then
        GUI:setVisible(MainTarget.UI.Node, false)
        return
    end

    GUI:setVisible(MainTarget.UI.Node, true)
    -- icon
    if SL:GetMetaValue("ACTOR_IS_PLAYER", target) then
        local job = SL:GetMetaValue("ACTOR_JOB_ID", target)
        local jobPath = {}
        if SL:GetMetaValue("ACTOR_IS_HERO", target) then
            jobPath = MainTarget.heroJobIconPath
        else
            jobPath = MainTarget.jobIconPath
        end
        if jobPath[job + 1] then
            GUI:Image_loadTexture(MainTarget.UI.icon, jobPath[job + 1])
        end
    elseif SL:GetMetaValue("ACTOR_IS_MONSTER", target) then
        if MainTarget.monsterIconPath then
            GUI:Image_loadTexture(MainTarget.UI.icon, MainTarget.monsterIconPath)
        end
    end
    --切换隐藏
    --local isShow = GUI:getVisible(MainTarget.UI.ListView)
    --if isShow then
    --    GUI:setVisible(MainTarget.UI.ListView, false)
    --end

    --切换隐藏
    local isShowBtn = GUI:getVisible(MainTarget.UI.Button_eye)
    if isShowBtn then
        GUI:setVisible(MainTarget.UI.Button_eye, false)
    end

    MainTarget.UpdateTargetHP()
    MainTarget.UpdateTargetName()
    MainTarget.OnUpdateLockBtn()
    MainTarget.UpdateTargetTouShi()
end

function MainTarget.OnRefreshActorHP(data)
    if not (data.actorID and MainTarget._targetID == data.actorID) then
        return nil
    end

    MainTarget.UpdateTargetHP()
end

function MainTarget.UpdateTargetHP()
    if not MainTarget._isShowTargetPanel then
        return
    end
    local target = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not target then
        return
    end

    -- 血量刷新
    local curHP = SL:GetMetaValue("ACTOR_HP", target)
    local maxHP = SL:GetMetaValue("ACTOR_MAXHP", target)
    local percent = math.ceil(curHP / maxHP * 100)
    GUI:LoadingBar_setPercent(MainTarget.UI.hpLoadingBar, percent)
    GUI:Text_setString(MainTarget.UI.hpText, percent .. "%")
end

function MainTarget.OnActorOwnerChange(data)
    if not (data.actorID and MainTarget._targetID == data.actorID) then
        return nil
    end

    MainTarget.UpdateTargetName()
end

function MainTarget.UpdateTargetName()
    if not MainTarget._isShowTargetPanel then
        return
    end
    local target = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not target then
        return
    end

    -- name
    local ownerName = SL:GetMetaValue("ACTOR_OWNER_NAME", target) or ""
    local name = SL:GetMetaValue("ACTOR_NAME", target) .. (ownerName ~= "" and string.format("(%s)", ownerName) or "")

    if (tonumber(SL:GetMetaValue("GAME_DATA", "Monsterlevel")) or 0) >= 1 and SL:GetMetaValue("SETTING_ENABLED", 34) == 1 and not SL:GetMetaValue("MAP_FORBID_LEVEL_AND_JOB") then
        name = name .. "/J" .. (SL:GetMetaValue("ACTOR_LEVEL", target) or "")
    end
    GUI:ScrollText_setString(MainTarget._scrollNameText, name)
end
--更新透视
function MainTarget.UpdateTargetTouShi()
    GUI:removeAllChildren(MainTarget.UI.ListView)
    local target = SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID)
    if not target then
        return
    end
    if SL:GetMetaValue("ACTOR_IS_MONSTER", target) then
        local name = SL:GetMetaValue("ACTOR_NAME", target)
        MainTarget.touShiMonsterName = name
        local cfg = MainTarget.config[name]
        if cfg then
            GUI:setVisible(MainTarget.UI.Button_eye, true)
            GUI:setPositionX(MainTarget.UI.cleanBtn, 222)
            for i, v in ipairs(cfg.value) do
                local image = GUI:Image_Create(MainTarget.UI.ListView, "Image_" .. i, 0, 0, "res/custom/TouShi/itembg.png")
                GUI:setContentSize(image, 40, 40)
                GUI:setOpacity(image, 150)
                local itemIdx = SL:GetMetaValue("ITEM_INDEX_BY_NAME", v)
                local ImageSize = GUI:getContentSize(image)
                local item = GUI:ItemShow_Create(image, "Item_" .. i, ImageSize.width / 2, ImageSize.height / 2, { index = itemIdx, count = 1, look = true, bgVisible = nil })
                GUI:setAnchorPoint(item, 0.5, 0.5)
                GUI:setScale(item, 0.7)
            end
        else
            GUI:setVisible(MainTarget.UI.Button_eye, false)
        end
    end
end



--显示透视
function MainTarget.ShowTargetTouShi()
    if MainTarget.touShiMonsterName then
        local name = MainTarget.touShiMonsterName
        local cfg = MainTarget.config[name]
        if cfg then
            MainTarget.ListViewIsShow = not MainTarget.ListViewIsShow
            GUI:Timeline_StopAll(MainTarget.UI.ListView)
            if MainTarget.ListViewIsShow then
                GUI:Timeline_MoveTo(MainTarget.UI.ListView, { x = 0, y = 0 }, 0.2)
            else
                GUI:Timeline_MoveTo(MainTarget.UI.ListView, { x = 0, y = 40 }, 0.2)
            end
        end
    end
end

function MainTarget.OnUpdateLockBtn()
    if not MainTarget._isShowTargetPanel then
        return
    end
    if not MainTarget._targetID or not SL:GetMetaValue("ACTOR_DATA", MainTarget._targetID) then
        return
    end

    if SL:GetMetaValue("PET_ALIVE") and MainTarget._LockUIState ~= false then
        GUI:setVisible(MainTarget.UI.LockPanel, true)
        GUI:setPositionX(MainTarget.UI.cleanBtn, 235)
        local lockID = SL:GetMetaValue("PET_LOCK_ID")
        GUI:Button_setBright(MainTarget.UI.LockBtn, lockID == MainTarget._targetID)
    else
        GUI:setVisible(MainTarget.UI.LockPanel, false)
        GUI:setPositionX(MainTarget.UI.cleanBtn, 190)
    end
end
