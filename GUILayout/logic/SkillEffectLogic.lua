SL:Require('GUILayout/skill/FeiJianSkill.lua', true)

---@class SkillEffectLogic 技能特效处理逻辑
SkillEffectLogic = {}


--闪电连线每帧刷新
local flashLineUpdate = function(effNode, dt)
    local fromObj = maptools.getActor(effNode.fromId)
    local toObj = maptools.getActor(effNode.toId)
    if fromObj == nil or toObj == nil then
        SL:release_print("没有找到目标")
        effNode.eff:unscheduleUpdate()
        effNode.eff:stopAllActions()
        effNode.eff:setScaleX(0)
        effNode.eff:removeFromParent()
        return
    end

    effNode.time = (effNode.time or 0) + dt
    local fromUi = maptools.getObjUi(fromObj)
    local toUi = maptools.getObjUi(toObj)
    local fromPos = maptools.getObjCenterPos(fromUi)
    local toPos = maptools.getObjCenterPos(toUi)
    --SL:release_print("fromPos", fromPos.x, fromPos.y, "toPos", toPos.x, toPos.y)
    local rotate = UiTools.calculateRotation(fromPos, toPos)
    --local angle = -cc.pToAngleSelf(cc.pSub(toPos,fromPos ))
    --local rotate = math.deg(angle)
    local eff = effNode.eff
    eff:setAnchorPoint(cc.p(0.15, 0.5))
    eff:setPosition(fromPos)
    eff:setRotation(rotate)
    -- 设置大小
    eff:setScale(0.5, 0.5)
    local length = UiTools.getLength(fromPos, toPos)
    if effNode.time == 0 then
        length = 0
    elseif effNode.time < effNode.duration[1] then
        length = length * effNode.time / effNode.duration[1]
    elseif effNode.time > effNode.duration[2] and effNode.time < effNode.duration[3] then
        --进行收缩
        --if effNode.duration - dt <= 0.1  then
        --    --local img = eff:getChildByName('img')
        --    --img:setRotation(180)
        --end
        eff:setAnchorPoint(cc.p(0.8, 0.5))
        eff:setPosition(toPos)
        --eff:setRotation(rotate - 180)
        length = length * (effNode.duration[3] - effNode.time) / (effNode.duration[3] - effNode.duration[2])
    end
    --effNode.ext.size.width = math.max(200, length * 2)
    local scale = length / effNode.size.width
    eff:setScaleX(scale)
end

--播放技能效果
---@param skillId number 技能ID
---@param data table 技能数据
---@param hurt number 伤害
function SkillEffectLogic.castSkill(skillId, data, skillLv, hurt)
    --SL:release_print("SkillEffectLogic.castSkill", skillId, data)
    if skillId == 1 then
        --螺旋特效
        SkillEffectLogic.caskSpiral(data, skillLv, hurt)
    elseif skillId == 3 then
        --闪电连接特效
        SkillEffectLogic.flashLine(data, skillLv, hurt)
    end
end

---螺旋切割移动到下一个目标
function SkillEffectLogic.spiralNext(eff, targetIds, index, skillLv, hurt)
    if index > 1 then
        -- 播放特效
        SL:StopSound(384)
        SL:PlaySound(384)
        maptools.addOrRefreshActorEffect(targetIds[index], 101)
        if hurt == nil or hurt == 0 then
            local qgCfg = ConfigManager.getQieGe1Cfg()
            if #qgCfg > 0 then
                local lv = GameLogic.getConfigItemValue(ConfigManager.ConfigItemType.Var, VarCfg.qie_ge_1_lv)
                local qg = GameLogic.getConfigItemValue(ConfigManager.ConfigItemType.Var, VarCfg.show_qg)
                lv = math.min(math.max(1, lv), #qgCfg)
                hurt = qgCfg[lv].hurt * qg / 100
            end
        end
        if hurt ~= nil and hurt > 0 then
            local throwData = {
                Id = 18,
                UserID = targetIds[index],
                Power = hurt
            }
            global.Facade:sendNotification(global.NoticeTable.ShowThrowDamage, throwData)
        end
        --SL:release_print("播放特效")
    end
    --SL:StopSound(383)
    SL:PlaySound(383)
    if index >= #targetIds then
        --SL:release_print("动画完成",index,执行飞回的动画)
        SkillEffectLogic.spiralEnd(eff, targetIds)
        return
    end
    -- 计算下一个位置
    index = index + 1
    local nextId = targetIds[index]
    local nodeObj = maptools.getActor(nextId)
    if not nodeObj then
        --SL:release_print("没找到怪物",nextId)
        SkillEffectLogic.spiralEnd(eff, targetIds)
        return
    end
    local objUI = nodeObj.mCurrActorNode
    if not objUI:getParent() then
        --SL:release_print("没找到界面对象",nextId)
        SkillEffectLogic.spiralEnd(eff, targetIds)
        return
    end
    -- 6001
    --local rotation = UiTools.calculateRotationAngle(nowPos, nodePos)
    --GUI:setRotation(eff, rotation - 115 + 90)

    GUI:runAction(eff, cc.Sequence:create(
    --cc.EaseSineOut:create(cc.MoveTo:create(0.2, maptools.getObjCenterPos(objUI))),
            cc.MoveTo:create(0.2, maptools.getObjCenterPos(objUI)),
            cc.CallFunc:create(function()
                SkillEffectLogic.spiralNext(eff, targetIds, index, skillLv, hurt)
            end)
    ))
end

--飞环特效映射关系
local _effMap = {
    [16501] = { effId = 16500, init = { scaleX = 0.58, scaleY = 0.34, offsetX = 11, offsetY = -55 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16503] = { effId = 16502, init = { scaleX = 0.55, scaleY = 0.3, offsetX = 18, offsetY = -59 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16505] = { effId = 16504, init = { scaleX = 0.70, scaleY = 0.32, offsetX = 11, offsetY = -59 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16507] = { effId = 16506, init = { scaleX = 0.70, scaleY = 0.32, offsetX = 11, offsetY = -59 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16509] = { effId = 16508, init = { scaleX = 0.65, scaleY = 0.32, offsetX = 8, offsetY = -59 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16511] = { effId = 16510, init = { scaleX = 0.55, scaleY = 0.28, offsetX = 9, offsetY = -57 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16513] = { effId = 16512, init = { scaleX = 0.58, scaleY = 0.3, offsetX = 12, offsetY = -53 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16515] = { effId = 16514, init = { scaleX = 0.68, scaleY = 0.3, offsetX = 12, offsetY = -54 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16517] = { effId = 16516, init = { scaleX = 0.55, scaleY = 0.25, offsetX = 15, offsetY = -46 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    [16520] = { effId = 16524, init = { scaleX = 1.14, scaleY = 0.58, offsetX = -2, offsetY = -57 }, scaleX = 0.8, scaleY = 0.4, rotation = 20 },
    [16523] = { effId = 16527, init = { scaleX = 0.78, scaleY = 0.42, offsetX = 8, offsetY = -60 }, scaleX = 0.5, scaleY = 0.25, rotation = 20 },
    --[16519] = { effId = 16518, init = { scaleX = 0.55, scaleY = 0.3, offsetX = 18, offsetY = -59 }, scaleX = 0.3, scaleY = 0.15, rotation = 20 },
    [16519] = { effId = 16519, init = { scaleX = 1, scaleY = 1, offsetX = 0, offsetY = -0 }, scaleX = 0.6, scaleY = 0.6, rotation = 20 },
}

local function setEffShow(effId, sourceId)
    local from = maptools.getActor(sourceId)
    if not from then
        -- 没有找到对象，直接返回
        return
    end
    --获取当前的光圈特效id 在来源身上查找特效信息
    local actorAllEffect = global.ActorEffectManager:GetItemsByActorID(sourceId)
    if not actorAllEffect then
        return
    end
    local nowJdGh = GameLogic.getUserEffType(GameConst.EffectType.JiaoDiGuangQuan)
    if nowJdGh == nil or nowJdGh.now == nil or nowJdGh.now == 0 then
        --没有特效返回
        return
    end
    local effInfo = actorAllEffect[effId]
    if not effInfo then
        return
    end
    local anim = effInfo.anim
    anim:setOpacity(255)
end

function SkillEffectLogic.spiralEnd(eff, targetIds)
    --SL:release_print("动画结束")
    local sourceId = targetIds[1]
    local from = maptools.getActor(sourceId)
    if not from then
        -- 没有找到对象，直接返回
        eff:removeFromParent()
        return
    end
    --获取当前的光圈特效id 在来源身上查找特效信息
    local actorAllEffect = global.ActorEffectManager:GetItemsByActorID(sourceId)
    if not actorAllEffect then
        eff:removeFromParent()
        return
    end
    local nowJdGh = GameLogic.getUserEffType(GameConst.EffectType.JiaoDiGuangQuan)
    if nowJdGh == nil or nowJdGh.now == nil or nowJdGh.now == 0 then
        --没有特效返回
        eff:removeFromParent()
        return
    end
    local effId = eff["_effId"]
    local effInfo = actorAllEffect[effId]
    if not effInfo then
        SL:release_print("没有找到特效节点信息，隐藏:", effId)
        eff:removeFromParent()
        return
    end

    local anim = effInfo.anim
    local d = 0.2
    anim:stopActionByTag(2)
    anim:runAction(cc.FadeIn:create(d * 2))
    local pos = cc.p(anim:getPosition())
    local effCfg = _effMap[effId]
    pos.x = pos.x + effCfg.init.offsetX
    pos.y = pos.y + effCfg.init.offsetY
    eff:runAction(cc.Sequence:create({
        cc.Spawn:create({
            cc.MoveTo:create(d, pos),
            cc.RotateTo:create(d, 0),
            cc.ScaleTo:create(d, effCfg.init.scaleX, effCfg.init.scaleY),
        }),
        cc.FadeOut:create(d),
        cc.RemoveSelf:create()
    }))
end

---播放螺旋切割特效
---@param targetIds string[] 目标id列表
function SkillEffectLogic.caskSpiral(targetIds, skillLv, hurt)
    local sourceId = targetIds[1]
    local from = maptools.getActor(sourceId)
    if not from then
        -- 没有找到对象，直接返回
        SL:release_print("没有找到施放对象，直接返回")
        return
    end
    --获取当前的光圈特效id 在来源身上查找特效信息
    local actorAllEffect = global.ActorEffectManager:GetItemsByActorID(sourceId)
    if not actorAllEffect then
        return
    end
    local nowJdGh = GameLogic.getUserEffType(GameConst.EffectType.JiaoDiGuangQuan)
    if nowJdGh == nil or nowJdGh.now == nil or nowJdGh.now == 0 then
        --没有特效返回
        return
    end
    local effId = nowJdGh.now
    local effInfo = actorAllEffect[effId]
    if not effInfo then
        SL:release_print("没有找到特效节点信息，隐藏:", effId)
        return
    end
    local effCfg = _effMap[effId]
    if effCfg == nil then
        return
    end
    local anim = effInfo.anim
    if anim == nil or anim:getOpacity() < 255 then
        SL:release_print("没有找到特效节点信息，隐藏")
        return
    end

    local pos = cc.p(anim:getPosition())
    --SL:release_print("play flash eff", pos.x, pos.y)
    local root = SkillEffectLogic.getEffectRoot()
    --创建节点,并初始化位置
    local initCfg = effCfg.init
    local eff = GUI:Effect_Create(root, 'eff' .. tostring(math.random()), pos.x + initCfg.offsetX, pos.y + initCfg.offsetY, 0, effCfg.effId, 0, 0, 0, 10)
    eff:setScaleX(initCfg.scaleX)
    eff:setScaleY(initCfg.scaleY)
    eff["_effId"] = effId
    eff:onNodeEvent('exit', function(event)
        setEffShow(effId, sourceId)
    end)
    --eff:setOnExitCallback(function()
    --    setEffShow(effId, sourceId)
    --end)
    --播放出现动画
    GUI:setChildrenCascadeOpacityEnabled(eff, true)
    eff:setOpacity(0)
    eff:runAction(cc.Sequence:create({
        cc.Spawn:create({
            cc.FadeIn:create(0.2),
            cc.ScaleTo:create(0.2, effCfg.scaleX, effCfg.scaleY),
        }),
        cc.Spawn:create({
            cc.RotateTo:create(0.2, effCfg.rotation),
            cc.CallFunc:create(function()
                SkillEffectLogic.spiralNext(eff, targetIds, 1, skillLv, hurt)
            end)
        })
    }))
    local delay = 0.4 + #targetIds * 0.2
    GUI:setChildrenCascadeOpacityEnabled(anim, true)
    anim:stopActionByTag(2)
    anim:runAction(cc.Sequence:create({
        cc.FadeOut:create(0.2),
        cc.DelayTime:create(delay),
        cc.FadeIn:create(0.2),
    })               :setTag(2))

    -- 开始播放动画
end

function SkillEffectLogic.getEffectRoot()
    local node = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_DAMAGE)
    local root = node:getChildByName("_animRoot")
    if root then
        return root
    end
    root = GUI:Node_Create(node, "_animRoot", 0, 0)
    return root
end

function SkillEffectLogic.getMaskRoot()
    SkillEffectLogic.getEffectRoot()
    local node = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_DAMAGE)
    local root = node:getChildByName("_maskRoot")
    if root then
        return root
    end
    root = GUI:Node_Create(node, "_maskRoot", 0, 0)
    return root
end

---切换地图，停止并移除所有动画效果
function SkillEffectLogic.onMapChange()
    local root = SkillEffectLogic.getEffectRoot()
    GUI:removeAllChildren(root)
    root = SkillEffectLogic.getMaskRoot()
    GUI:removeAllChildren(root)
end

---闪电链
function SkillEffectLogic.flashLine(targetIds, skillLv, hurt)
    if #targetIds < 2 then
        return
    end
    local root = SkillEffectLogic.getEffectRoot()
    local lastId = targetIds[1]
    for i = 2, #targetIds do
        local _lastId = lastId
        local now = targetIds[i]
        root:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.2 * (i - 1)),
                cc.CallFunc:create(function()
                    SkillEffectLogic.doFlashLine(_lastId, now, skillLv, hurt)
                end)
        ))
        lastId = now
    end
end

---连线
function SkillEffectLogic.doFlashLine(fromId, toId, skillLv, hurt)
    local fromObj = maptools.getActor(fromId)
    local toObj = maptools.getActor(toId)
    if fromObj == nil or toObj == nil then
        return
    end
    local effNode = {
        fromId = fromId,
        toId = toId,
        eff = nil,
        time = 0,
        duration = { 0.2, 0.2, 0.4 },
        startPos = cc.p(fromObj.mCurrActorNode:getPosition()),
    }
    --effNode.eff = GUI:Node_Create(SkillEffectLogic.getEffectRoot(), 'eff' .. tostring(math.random()), effNode.startPos.x, effNode.startPos.y)
    --local img = GUI:Image_Create(effNode.eff, 'img' .. tostring(math.random()), 0, 0, 'res/custom/tx//0001.png')
    effNode.eff = GUI:Image_Create(SkillEffectLogic.getEffectRoot(), 'eff' .. tostring(math.random()), 0, 0, 'res/custom/tx//0001.png')

    --img:setAnchorPoint(cc.p(0, 0.5))
    effNode.eff:setAnchorPoint(cc.p(0, 0.3))
    --effNode.eff:setScaleY(0.5)
    effNode.ext = {
        loop = 0, speed = 80, fileNameLen = 4,
        --size = effNode.eff:getContentSize()
    }
    effNode.size = effNode.eff:getContentSize()
    --effNode.ext.size.width = effNode.ext.size.width * 2
    --effNode.ext.size.height = 150
    UiTools.playFrame(effNode.eff, 'res/custom/tx/', 1, 11, effNode.ext)
    --GUI:Image_setScale9Slice(effNode.eff, 0, 200, 20, 20)
    effNode.eff:setScale(1, 0.5)
    effNode.eff:scheduleUpdateWithPriorityLua(function(dt)
        pcall(flashLineUpdate, effNode, dt)
    end, 0)
    flashLineUpdate(effNode, 0)
    effNode.eff:runAction(cc.Sequence:create(
            cc.DelayTime:create(effNode.duration[1]),
    --cc.CallFunc:create(function()
    --    maptools.playActorEffect(toId, 56)
    --end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                maptools.playActorEffect(toId, 33, 0, 0, 2)
            end),
            cc.DelayTime:create(effNode.duration[3] - effNode.duration[1]),
            cc.RemoveSelf:create()
    ))
    SL:PlaySound(50133, false)
    if hurt == nil or hurt == 0 then
        local qgCfg = ConfigManager.getQieGe2Cfg()
        if #qgCfg > 0 then
            local lv = GameLogic.getConfigItemValue(ConfigManager.ConfigItemType.Var, VarCfg.qie_ge_2_lv)
            lv = math.min(math.max(1, lv), #qgCfg)
            hurt = qgCfg[lv].hurt * toObj.mMaxHP / 100
        end
    else
        hurt = hurt * toObj.mMaxHP / 100
    end
    --播放飘字
    if hurt ~= nil and hurt > 0 then
        local throwData = {
            Id = 12,
            UserID = toId,
            Power = hurt
        }
        global.Facade:sendNotification(global.NoticeTable.ShowThrowDamage, throwData)
    end
end

---法宝追击洗过
---@param sourceId string 源id
---@param fbEffId number 法宝特效id
---@param mapX number 地图x
---@param mapY number 地图y
---@param targetIds string[] 目标id
local function fbFollowUpEffect(sourceId, fbEffId, mapX, mapY, targetIds)
    if #targetIds <= 1 then
        --没有其他的目标，第一个命中的目标不用播放特效
        return
    end
    local root = SkillEffectLogic.getEffectRoot()
    local formPos = ssr.MapPos2WorldPos(cc.p(mapX, mapY), false)
    for i = 2, #targetIds do
        local targetId = targetIds[i]
        --获取目标信息
        local targetActor = maptools.getActor(targetId)
        if targetActor and targetActor:GetNode() then
            local targetNode = targetActor:GetNode()
            local targetPos = cc.p(targetNode:getPosition())
            --计算好角度
            local rotation = UiTools.calculateRotation(formPos, targetPos)
            -- 添加图片效果
            local image = GUI:Image_Create(root, 'fb_follow_' .. sourceId .. math.random(), formPos.x, formPos.y, string.format('res/custom/tx/fb_%d.png', fbEffId - 20000))
            image:setScale(0.15)
            image:setAnchorPoint(cc.p(0.5, 0.5))
            image:setRotation(rotation)
            --播放移动动画
            image:runAction(cc.Sequence:create(
                    cc.EaseCircleActionIn:create(cc.MoveTo:create(0.2, targetPos)),
                    cc.CallFunc:create(function()
                        --播放命中特效
                        maptools.playActorEffect(targetId, 33, 0, 0, 1)
                        --播放飘字
                    end),
                    cc.RemoveSelf:create()
            ))
        end
    end
end

---法宝攻击爆裂地图特效
local function fbBoomMapEffect(sourceId, fbEffId, mapX, mapY)
    --在地图上播放特效
    local nodeId = sourceId .. '_' .. fbEffId
    local root = SkillEffectLogic.getEffectRoot()
    if root:getChildByName(nodeId) ~= nil then
        return
    end
    local pos = ssr.MapPos2WorldPos(cc.p(mapX, mapY), false)
    local eff = GUI:Effect_Create(root, nodeId, pos.x, pos.y, 3, fbEffId + 200)
    --eff:setScale(1.5)
    GUI:Effect_addOnCompleteEvent(eff, function()
        eff:removeFromParent()
    end)
end

---法宝掉下特效
---@param sourceId string 源id
---@param fbEffId number 法宝特效id
---@param mapX number 地图x
---@param mapY number 地图y
---@param duration number 动画持续时间
local function fbAttackDownAnim(sourceId, fbEffId, mapX, mapY, duration)
    local nodePid = sourceId .. '_' .. fbEffId
    -- 加入到 gameMapController 是为了能够进行层级的排序
    local addResult = global.gameMapController:addSpecialEffect({
        id = nodePid,
        type = global.MMO.EFFECT_TYPE_SFX,
        sfxId = fbEffId + 100,
        x = mapX,
        y = mapY,
    })
    if addResult == -1 then
        SL:release_print("add effect fail", nodePid)
        return
    end
    local eff = global.actorManager:GetActor(nodePid)
    local offsetY = 600
    if eff then
        eff:GetNode():runAction(cc.Sequence:create({
            --延迟0.03是因为addSpecialEffect中会有延迟
            cc.DelayTime:create(0.03),
            cc.CallFunc:create(function()
                local anima = eff:GetAnimation()
                GUI:setChildrenCascadeOpacityEnabled(anima, true)
                if anima then
                    anima:setPositionY(offsetY)
                    anima:runAction(cc.Sequence:create({
                        cc.Spawn:create({
                            cc.FadeIn:create(duration / 1.5),
                            cc.EaseExponentialIn:create(cc.MoveBy:create(duration, cc.p(0, -offsetY)))
                        }),
                        cc.CallFunc:create(function()
                            fbBoomMapEffect(sourceId, fbEffId, mapX, mapY)
                        end),
                        --延迟清除
                        cc.DelayTime:create(0.2),
                        cc.CallFunc:create(function()
                            --执行完，清除地图特效对象
                            SL:release_print("remove effect", nodePid)
                            global.gameMapController.mNetActorMap[nodePid] = nil
                            global.sceneEffectManager:RmvSceneEffect(nodePid)
                            global.actorManager:RemoveActor(nodePid)
                        end),
                        --cc.EaseQuinticActionIn:create(cc.MoveBy:create(0.5,cc.p(0,-80)))
                    }))
                end
            end)
        }))
    end
end

---法宝攻击特效
function SkillEffectLogic.faBaoAttack(fbEffId, sourceId, targetIds, skillLv, hurt)
    local source = maptools.getActor(sourceId)
    if not source then
        return
    end
    --在来源身上查找特效信息
    local actorAllEffect = global.ActorEffectManager:GetItemsByActorID(sourceId)
    if not actorAllEffect then
        return
    end
    local effInfo = actorAllEffect[fbEffId]
    if not effInfo then
        return
    end
    local anim = effInfo.anim
    local originPos = cc.p(anim:getPosition())
    --if originPos == nil then
    --    originPos =
    --end
    --local posx, posy = effInfo.anim:getPosition()
    --SL:release_print('effInfo pos ', anim['_originPos_'].x, anim['_originPos_'].y, effInfo)
    --local targetId = SL:GetMetaValue("SELECT_TARGET_ID")
    --SL:release_print("targetIds", SL:GetMetaValue("SELECT_TARGET_ID"))
    local targetId = targetIds[1]
    if not targetId then
        SL:release_print("没有找到target id")
        return
    end
    local target = maptools.getActor(targetId)
    if not target then
        SL:release_print("没有找到target", targetId)
        return
    end
    --挂件消失动画时间
    local downDuration = 1
    local followUpDelay = 0.1
    local targetPosX, targetPosY = maptools.getObjMapPos(target)
    SL:release_print("targetId", targetId, 'target', target, targetPosX, targetPosY)
    anim:runAction(cc.Sequence:create({
        --挂件消失
        cc.Spawn:create({
            cc.EaseQuinticActionOut:create(cc.MoveTo:create(0.3, cc.pAdd(originPos, cc.p(0, 200)))),
            cc.Sequence:create({
                cc.DelayTime:create(0.1),
                cc.FadeOut:create(0.2)
            })
        }),
        --大法宝出现
        cc.CallFunc:create(function()
            fbAttackDownAnim(sourceId, fbEffId, targetPosX, targetPosY, downDuration)
        end),
        -- 延迟0.1秒播放追击特效
        cc.DelayTime:create(downDuration + followUpDelay),
        -- 同时开始播放追击效果
        cc.CallFunc:create(function()
            fbFollowUpEffect(sourceId, fbEffId, targetPosX, targetPosY, targetIds)
        end),
        cc.FadeIn:create(0.1),
        cc.CallFunc:create(function()
            --重设法宝挂件位置
            local source1 = maptools.getActor(sourceId)
            if not source1 then
                return
            end
            local pos = ssr.MapPos2WorldPos(cc.p(maptools.getObjMapPos(source1)), true)
            global.ActorEffectManager:setPosition(sourceId, pos.x, pos.y)
        end)
    }))
end



SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, 'effect', SkillEffectLogic.onMapChange)
