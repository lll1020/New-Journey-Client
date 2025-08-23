MainSkill = {}

MainSkill.imagePath = {
    [1] = {
        normal = "res/private/main/Skill/1900012706.png",
        bright = "res/private/main/Skill/1900012707.png"
    },
    [2] = {
        normal = "res/private/main/Skill/1900012704.png",
        bright = "res/private/main/Skill/1900012705.png"
    },
    [3] = {
        normal = "res/private/main/Skill/1900012710.png",
        bright = "res/private/main/Skill/1900012711.png"
    },
}
MainSkill.heroSfxParam = {7222, -48, 38}  -- {合击技能特效id, 坐标X, 坐标Y}
MainSkill.comboSfxParam = {7230, 3, 50}  -- {连击技能特效id, 坐标X, 坐标Y}
MainSkill._showIndex = 0
MainSkill._layoutActive = nil

function MainSkill.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/skill/main_skill")

    MainSkill._parent = parent
    MainSkill._ui = GUI:ui_delegate(parent)

    -- 内功开启
    MainSkill._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")

    local Panel_skill = MainSkill._ui["Panel_skill"]
    GUI:setVisible(Panel_skill, true)

    local Panel_active = MainSkill._ui["Panel_active"]
    MainSkill._layoutActive = Panel_active
    GUI:setVisible(Panel_active, false)

    MainSkill.InitPick()
    MainSkill.InitButton()
    MainSkill.InitQuickFind()

    MainSkill.ChangeShowIndex(1, true)

    MainSkill.RegisterEvent()    
end

function MainSkill.InitPick()
    local Button_pick = MainSkill._ui["Button_pick"]
    GUI:setVisible(Button_pick, false)
    GUI:addOnClickEvent(Button_pick, function()
        if not SL:GetMetaValue("BATTLE_IS_AUTO_PICK") then
            SL:SetMetaValue("BATTLE_PICK_BEGIN")
        else
            SL:SetMetaValue("BATTLE_PICK_END")
        end
    end)
end

function MainSkill.InitButton()
    -- 隐藏
    local Panel_hide = MainSkill._ui["Panel_hide"]
    GUI:setVisible(Panel_hide, false)
    GUI:setSwallowTouches(Panel_hide, false)
    GUI:addOnClickEvent(Panel_hide, function()
        MainSkill.ChangeShowIndex(1)
    end)
    local Image_change_act = MainSkill._ui["Image_change_act"]
    GUI:setPosition(Image_change_act, 44, 42)

    -- 切换
    local Button_change = MainSkill._ui["Button_change"]
    GUI:addOnClickEvent(Button_change, function()
        SL:PlaySound(50005)
        MainSkill.ChangeShowIndex(3 - MainSkill._showIndex)
        --SL:release_print("切换技能栏", MainSkill._showIndex, 3 - MainSkill._showIndex)
    end)

    -- 锁定
    local Button_Lock = MainSkill._ui["Button_Lock"]
    GUI:setVisible(Button_Lock, false)
    GUI:addOnClickEvent(Button_Lock, MainSkill.clickLockBtn)
end

function MainSkill.clickLockBtn()
    if SL:GetMetaValue("HERO_IS_ALIVE") then
        local selectID = MainSkill._selectID
        if selectID and selectID ~= -1 then
            local actorID = SL:GetMetaValue("ACTOR_ID", selectID)
            if actorID and SL:GetMetaValue("ACTOR_CAN_LOCK_BY_HERO", actorID) then
                local isPlayer = SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) and not SL:GetMetaValue("ACTOR_IS_HERO", actorID)
                SL:RequestLockTargetByHero(actorID, isPlayer)
            end
        else
            SL:RequestCancelLockByHero()
        end
    end
end

function MainSkill.InitQuickFind()
    local Panel_quick_find = MainSkill._ui["Panel_quick_find"]
    local imagePlayer      = MainSkill._ui["Image_player"]
    local imageMonster     = MainSkill._ui["Image_monster"]
    local imageHero        = MainSkill._ui["Image_hero"]

    local function getGUIPath(id, state)
        if MainSkill.imagePath and MainSkill.imagePath[id] then
            return MainSkill.imagePath[id][state == 1 and "normal" or "bright"]
        end
    end

    local items = {
        [1] = {
            image    = imagePlayer,
            actorType = 0,
            normalPath = getGUIPath(1, 1) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012706.png",
            brightPath = getGUIPath(1, 2) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012707.png",
        },
        [2] = {
            image    = imageMonster,
            actorType = 50,
            normalPath = getGUIPath(2, 1) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012704.png",
            brightPath = getGUIPath(2, 2) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012705.png",
        }
    }

    local heroOpen = SL:GetMetaValue("USEHERO") --英雄开关
    GUI:setVisible(imageHero, heroOpen)
    if heroOpen then
        items[3] = {
            image    = imageHero,
            actorType = 400,
            normalPath = getGUIPath(3, 1) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012710.png",
            brightPath = getGUIPath(3, 2) or SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012711.png",
        }
    end

    local function quickFind(index)
        local function callback()
            local item = items[index]
            GUI:Image_loadTexture(item.image, item.normalPath)
        end
        local item = items[index]
        GUI:Image_loadTexture(item.image, item.brightPath)
        GUI:runAction(item.image, GUI:ActionSequence(GUI:ActionScaleTo(0.1, 1.4), GUI:ActionScaleTo(0.1, 1), GUI:CallFunc(callback)))
        local data = {}
        data.type = item.actorType
        data.race = item.actorRace
        data.imgNotice = true
        SL:QuickSelectTarget(data)
    end

    GUI:setSwallowTouches(Panel_quick_find, false)
    GUI:addOnTouchEvent(Panel_quick_find, function(_, eventType)
        if eventType == 2 or eventType == 3 then
            local beganPos = GUI:getTouchBeganPosition(Panel_quick_find)
            local endedPos = GUI:getTouchEndPosition(Panel_quick_find)

            local dis = SL:GetPointDistanceSQ(beganPos, endedPos)
            if dis < 500 or dis >= 40000 then
                return
            end

            if endedPos.x > beganPos.x then
                quickFind(1)
            else
                if heroOpen and endedPos.y > beganPos.y then
                    quickFind(3)
                else
                    quickFind(2)
                end
            end
        end
    end)
end

function MainSkill.ChangeShowIndex(i, force)
    MainSkill._showIndex = i

    local Panel_skill = MainSkill._ui["Panel_skill"]
    GUI:stopAllActions(Panel_skill)

    local Panel_active = MainSkill._ui["Panel_active"]
    GUI:stopAllActions(Panel_active)

    local Panel_hide = MainSkill._ui["Panel_hide"]
    GUI:setVisible(Panel_hide, MainSkill._showIndex == 2)

    local Image_change_act = MainSkill._ui["Image_change_act"]

    local skillSize = GUI:getContentSize(Panel_skill)
    local skillPosY = GUI:getPositionY(Panel_skill)
    local activeSize = GUI:getContentSize(Panel_active)
    local activePosY = GUI:getPositionY(Panel_active)

    local acttime = (force and 0 or 0.2)
    if MainSkill._showIndex == 1 then
        local distance = SL:GetMetaValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SKILL_SHOW_DISTANCE) or 0
        GUI:runAction(Image_change_act, GUI:ActionRotateTo(acttime, 0))
        GUI:setVisible(Panel_skill, true)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_skill, {x = -distance, y = skillPosY}, acttime)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_active, {x = activeSize.width, y = activePosY}, acttime, function()
            GUI:setVisible(Panel_active, false)
            -- 109 按钮模块引导主ID
            SL:SetMetaValue("GUIDE_EVENT_END", 109)
            if MainSkill.cbl then
                GUI:Timeline_EaseSineIn_MoveTo(MainSkill.cbl, {x = cogin.w + GUI:getContentSize(MainSkill.cbl).width, y = 0}, 0.5,function()
                    local parent = GUI:GetWindow(nil, "main_cbl")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                end)
            end
        end)
    else
        GUI:runAction(Image_change_act, GUI:ActionRotateTo(acttime, 90))
        GUI:Timeline_EaseSineIn_MoveTo(Panel_skill, {x = skillSize.width, y = skillPosY}, acttime, function()
            GUI:setVisible(Panel_skill, false)
        end)
        GUI:setVisible(Panel_active, true)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_active, {x = 0, y = activePosY}, acttime, function()
            SL:SetMetaValue("GUIDE_EVENT_BEGAN", 109, true)
        end)

        local parent = GUI:GetWindow(nil, "main_cbl")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("main_cbl", 0, 0, 0, 0, false, false, true, true, true, idx, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        --GUI:setTouchEnabled(bjt, true)
        --GUI:addOnClickEvent(bjt, function()
        --    MainSkill.ChangeShowIndex(1)
        --end)
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

        MainSkill.cbl = GUI:Image_Create(parent,"bj",cogin.w,0,"res/wy/public/main_cbl_bj.png")
        GUI:setAnchorPoint(MainSkill.cbl, 1, 0)
        GUI:setTouchEnabled(MainSkill.cbl, true)
        local width = GUI:getContentSize(MainSkill.cbl).width
        GUI:setContentSize(MainSkill.cbl, width, cogin.h)
        GUI:setPosition(MainSkill.cbl, cogin.w + width,0)

        local close = GUI:Button_Create(MainSkill.cbl, 'close', width - 10, cogin.h - 10, 'res/wy/public/main_cbl_close.png')
        GUI:setAnchorPoint(close, 1, 1)
        GUI:addOnClickEvent(close, function()
            MainSkill.ChangeShowIndex(1)
        end)

        local hh = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"hh",10, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_hh.png")
        local sz = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"sz",110, 50,"res/wy/public/main_cbl_kuang.png"), "img",39,34.5, "res/private/main/bottom/sj_sz.png")
        local exit = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"exit",210, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_exit.png")
        local sj_xz = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"paimai",210, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_xz.png")
        local haoyou = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"haoyou",110, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_haoyou.png")
        local paihang = GUI:Button_Create(GUI:Image_Create(MainSkill.cbl,"paihang",10, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_paihang.png")
        GUI:setAnchorPoint(hh, 0.5, 0.5)
        GUI:setAnchorPoint(sz, 0.5, 0.5)
        GUI:setAnchorPoint(exit, 0.5, 0.5)
        GUI:setAnchorPoint(sj_xz, 0.5, 0.5)
        GUI:setAnchorPoint(haoyou, 0.5, 0.5)
        GUI:setAnchorPoint(paihang, 0.5, 0.5)
        GUI:addOnClickEvent(hh, function()
            SL:JumpTo(31)
        end)
        GUI:addOnClickEvent(sj_xz, function()
            SL:SendLuaNetMsg(105, 8, 8, 0, "")
        end)
        GUI:addOnClickEvent(haoyou, function()
            SL:JumpTo(28)
        end)
        GUI:addOnClickEvent(sz, function()
            SL:JumpTo(23)
        end)
        GUI:addOnClickEvent(paihang, function()
            SL:JumpTo(32)
        end)
        GUI:addOnClickEvent(exit, function()
            SL:JumpTo(29)
        end)
        MainSkill.zz = GUI:Button_Create(MainSkill.cbl, "zz", width/2, cogin.h - 80, "res/wy/public/main_cbl_zz.png")
        local syt = GUI:Button_Create(MainSkill.cbl, "sqt", width/2, cogin.h - 80 - 105, "res/wy/public/main_cbl_syt.png")
        local ldl = GUI:Button_Create(MainSkill.cbl, "tj", width/2, cogin.h - 80 - 210, "res/wy/public/main_cbl_ldl.png")
        GUI:setAnchorPoint(MainSkill.zz, 0.5, 1)
        GUI:setAnchorPoint(syt, 0.5, 1)
        GUI:setAnchorPoint(ldl, 0.5, 1)

        GUI:addOnClickEvent(MainSkill.zz, function() SL:SendLuaNetMsg(105, 166, 166, 0, "") end)
        GUI:addOnClickEvent(syt, function() SL:SendLuaNetMsg(105, 19, 19, 0, "") end)
        GUI:addOnClickEvent(ldl, function()  SL:SendLuaNetMsg(105, 103, 103, 0, "") end)


        GUI:Timeline_EaseSineIn_MoveTo(MainSkill.cbl, {x = cogin.w, y = 0}, 0.5)
    end
end

function MainSkill.createSkillCell(parent, data)
    GUI:LoadExport(parent, "main/skill/main_skill_cell")

    local layoutBG = GUI:getChildByName(parent, "Panel_bg")
    local imageBG = GUI:getChildByName(layoutBG, "Image_bg")
    local buttonIcon = GUI:getChildByName(layoutBG, "skill_icon")

    local path = SL:GetMetaValue("SKILL_ICON_PATH", data.MagicID)
    GUI:Button_loadTextureNormal(buttonIcon, path)
    GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    if data.id == 1018 then
        GUI:setContentSize(buttonIcon, 100, 100)
        local eff = GUI:Frames_Create(buttonIcon, "eff", 0, 0, "res/wy/eff/city/skill_1018_", ".png", 1, 15, {count=15,speed=50,loop=-1})
        GUI:setContentSize(eff, 100, 100)
    elseif data.Key == 1 then
        GUI:Image_loadTexture(imageBG, SLDefine.PATH_RES_PRIVATE .. "main/Skill/1900012018.png")
        GUI:setIgnoreContentAdaptWithSize(imageBG, true)
        GUI:setContentSize(buttonIcon, 75, 75)
    else
        GUI:setContentSize(buttonIcon, 55, 55)
    end

    local n = 0
    local anchorPoint   = GUI:getAnchorPoint(buttonIcon)
    local sizeButton    = GUI:getContentSize(buttonIcon)
    local rectButton    = {}
    local isInSideButton = false
    GUI:addOnTouchEvent(buttonIcon, function(sender, state)
        -- 开始
        if 0 == state then
            isInSideButton = true
            local spacePos      = GUI:convertToWorldSpace(buttonIcon, GUI:getPositionX(buttonIcon), GUI:getPositionY(buttonIcon))
            rectButton          = {
                x = spacePos.x - sizeButton.width * anchorPoint.x,
                y = spacePos.y - sizeButton.height * anchorPoint.y,
                width = sizeButton.width,
                height = sizeButton.height
            }
            -- 按下就有特效
            n = n + 1
            local size = GUI:getContentSize(buttonIcon)
            local sfx = GUI:Effect_Create(buttonIcon, "SFX_".. n, size.width / 2, size.height / 2, 0, data.Key == 1 and 4002 or 4001)
            GUI:Effect_addOnCompleteEvent(sfx, function()
                GUI:removeFromParent(sfx)
            end)

            GUI:schedule(buttonIcon, function()
                if not isInSideButton then
                    return false
                end

                if SL:GetMetaValue("USER_IS_DIE") then
                    return false
                end

                if SL:GetMetaValue("ACTOR_IS_MOVE", SL:GetMetaValue("USER_ID")) then
                    return false
                end

                -- 技能点击逻辑
                MainSkill.ClickSkillEvent(buttonIcon, data.MagicID)
                return true
            end, 0.1)
            return true
        -- 移动
        elseif 1 == state then
            isInSideButton = GUI:RectContainsPoint(rectButton, GUI:getTouchMovePosition(buttonIcon))
            return true
        -- 结束
        elseif 2 == state then
            GUI:unSchedule(buttonIcon)
            MainSkill.ClickSkillEvent(buttonIcon, data.MagicID)
        -- 取消
        elseif 3 == state then
            GUI:unSchedule(buttonIcon)
        end
    end)

    -- cd
    local cd_size = GUI:getContentSize(buttonIcon)
    local cd_pos = GUI:getPosition(buttonIcon)
    local progressCD = nil
    if data.id ~= 1018 then
        progressCD = GUI:ProgressTimer_Create(layoutBG, "progressCD", cd_pos.x, cd_pos.y, SLDefine.PATH_RES_PRIVATE .. "main/Skill/bg_lsxljm_05.png", cd_size.width, cd_size.height)
    else
        progressCD = GUI:ProgressTimer_Create(layoutBG, "progressCD", cd_pos.x, cd_pos.y, "res/wy/public/skill_1018_jdt.png", cd_size.width, cd_size.height)
    end
    GUI:setAnchorPoint(progressCD, 0.5, 0.5)
    GUI:ProgressTimer_setReverseDirection(progressCD, true)

    local CDTime = GUI:Text_Create(layoutBG, "CDTime", cd_pos.x, cd_pos.y, 12, "#FFFFFF", "")
    GUI:setAnchorPoint(CDTime, 0.5, 0.5)
    local show = tonumber(SL:GetMetaValue("GAME_DATA", "ShowSkillCDTime")) == 1
    GUI:setVisible(CDTime, show)

    --Effect
    local nodeON = GUI:getChildByName(layoutBG, "Node_on")
    local nodeSelect = GUI:getChildByName(layoutBG, "Node_select")

    if SL:GetMetaValue("SKILL_IS_ONOFF_SKILL", data.MagicID) and SL:GetMetaValue("SKILL_IS_ON_SKILL", data.MagicID) then
        local key = data.Key
        local sfx = GUI:Effect_Create(nodeON, "sfx", 0, 0, 0, 4005)
        GUI:setScale(sfx, key == 1 and 0.9 or 0.6)
        GUI:Effect_setGlobalElapseEnable(sfx, true)
    end

    local cell = {
        data = data,
        layoutBG = layoutBG,
        buttonIcon = buttonIcon,
        progressCD = progressCD,
        CDTime     = CDTime,
        nodeON     = nodeON,
        nodeSelect = nodeSelect,
    }
    return cell
end

function MainSkill.createHeroSkillCell(parent, data)
    GUI:LoadExport(parent, "main/skill/hero_skill_cell")

    local layoutBG = GUI:getChildByName(parent, "Panel_bg")
    local buttonIcon = GUI:getChildByName(layoutBG, "Button_icon")

    local path = SL:GetMetaValue("H.SKILL_ICON_PATH", data.MagicID)
    GUI:Button_loadTextureNormal(buttonIcon, path)
    GUI:setContentSize(buttonIcon, 60, 60)
    GUI:setLocalZOrder(buttonIcon, 1)
    GUI:Button_setGrey(buttonIcon,true)
    GUI:addOnClickEvent(buttonIcon, function()
        MainSkill.click_HeroSkill(true)
    end)

    -- effect
    local nodeSFX = GUI:getChildByName(layoutBG, "Node_sfx")
    local sfx = GUI:Effect_Create(nodeSFX, "sfx", MainSkill.heroSfxParam[2], MainSkill.heroSfxParam[3], 0, MainSkill.heroSfxParam[1])
    GUI:setVisible(nodeSFX, false)

    local cell = {
        data        = data,
        layoutBG    = layoutBG,
        buttonIcon  = buttonIcon,
        nodeSFX     = nodeSFX,
    }
    return cell
end

function MainSkill.createComboSkillCell(parent, data)
    GUI:LoadExport(parent, "main/skill/combo_skill_cell")

    local layoutBG = GUI:getChildByName(parent, "Panel_bg")
    local icon = GUI:getChildByName(layoutBG, "Button_icon")

    local path = SL:GetMetaValue("SKILL_ICON_PATH", data.MagicID, true)
    GUI:Button_loadTextureNormal(icon, path)
    GUI:setContentSize(icon, 60, 60)
    GUI:setLocalZOrder(icon, 1)
    GUI:addOnClickEvent(icon, function()
        MainSkill.ClickComboSkill(data.MagicID)
    end)

    -- effect
    local nodeSFX = GUI:getChildByName(layoutBG, "Node_sfx")
    local sfx = GUI:Effect_Create(nodeSFX, "sfx", MainSkill.comboSfxParam[2], MainSkill.comboSfxParam[3], 0, MainSkill.comboSfxParam[1])

    local cell = {
        data        = data,
        layoutBG    = layoutBG,
        icon        = icon,
        nodeSFX     = nodeSFX,
    }
    return cell
end

function MainSkill.OnSkillButton_Distance_Change()
    local SETTING_VALUE = SL:GetMetaValue("SETTING_VALUE",SLDefine.SETTINGID.SETTING_IDX_SKILL_SHOW_DISTANCE)
    local distance = SETTING_VALUE and SETTING_VALUE[1] or 0
    GUI:setPositionX(MainSkill._ui.Panel_skill, -distance)
end

function MainSkill.OnRefreshComboSkillShow()
    if MainSkill._NGShow then
        local selectSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
        GUI:removeAllChildren(MainSkill._ui.Node_combo_skill)
        MainSkill._comboSkillCell = nil
        if selectSkills[1] then
            local skillID = selectSkills[1]
            if skillID and skillID ~= 0 then
                local data = SL:GetMetaValue("COMBO_SKILL_DATA", skillID)
                if data then
                    MainSkill._comboSkillCell = MainSkill.createComboSkillCell(MainSkill._ui.Node_combo_skill, data)
                end
            end
        end
    end
end

function MainSkill.OnActiveComboSkill(state)
    if MainSkill._NGShow then
        if MainSkill._comboSkillCell then
            GUI:setGrey(MainSkill._comboSkillCell.icon, not state)
            GUI:setTouchEnabled(MainSkill._comboSkillCell.icon, state)
            GUI:setVisible(MainSkill._comboSkillCell.nodeSFX, state)
        end
    end
end

function MainSkill.OnRefreshNGShow()
    MainSkill._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")
    MainSkill.OnRefreshComboSkillShow()
end

function MainSkill.OnRefreshHeroLockIcon()
    local selectID = SL:GetMetaValue("SELECT_TARGET_ID")
    local lockWay = 0 -- 不显示
    if selectID and SL:GetMetaValue("HERO_IS_ALIVE") then
        local actorID = SL:GetMetaValue("ACTOR_ID", selectID)
        if actorID and SL:GetMetaValue("ACTOR_CAN_LOCK_BY_HERO", actorID) then
            if SL:GetMetaValue("H.LOCK_TARGET_ID") == actorID then
                lockWay = 1 -- 显示锁定
            else
                lockWay = 2 -- 显示未锁定
            end
        end
    end

    if lockWay == 0 then
        GUI:setVisible(MainSkill._ui.Button_Lock, false)
        GUI:removeAllChildren(MainSkill._ui.Button_Lock)
        MainSkill._selectID = nil
    elseif lockWay == 1 then
        GUI:setVisible(MainSkill._ui.Button_Lock, true)
        GUI:Button_loadTextureNormal(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05.png")
        GUI:Button_loadTexturePressed(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05.png")
        if not GUI:getChildByName(MainSkill._ui.Button_Lock, "lockAnim") then
            GUI:removeAllChildren(MainSkill._ui.Button_Lock)
            GUI:Effect_Create(MainSkill._ui.Button_Lock, "lockAnim", 7, 45, 0, 7223)
        end
        MainSkill._selectID = -1
    elseif lockWay == 2 then
        GUI:setVisible(MainSkill._ui.Button_Lock, true)
        GUI:Button_loadTextureNormal(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05_1.png")
        GUI:Button_loadTexturePressed(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05_1.png")
        GUI:removeAllChildren(MainSkill._ui.Button_Lock)
        MainSkill._selectID = selectID
    end
end

function MainSkill.RegisterEvent( ... )
    -- 技能边距调整
    SL:RegisterLUAEvent(LUA_EVENT_SKILLBUTTON_DISTANCE_CHANGE, "MainSkill", MainSkill.OnSkillButton_Distance_Change)
    -- 设置连击技能刷新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SET_COMBO_REFRESH, "MainSkill", MainSkill.OnRefreshComboSkillShow)
    -- 连击技能CD状态
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILLCD_STATE, "MainSkill", MainSkill.OnActiveComboSkill)
    -- 学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MainSkill", MainSkill.OnRefreshNGShow)
    -- 英雄锁定刷新
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOCK_CHANGE, "MainSkill", MainSkill.OnRefreshHeroLockIcon)
end
