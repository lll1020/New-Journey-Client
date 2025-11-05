--飞剑效果
FeiJianSKill = {}

---飞剑状态
FeiJianSKill.SwordState = {
    Idle = 0, --待机
    Attack = 1, --攻击中
    Back = 2, --收回
    AttackCd1 = 3, --攻击等待飞行
    AttackCd2 = 4, --攻击等待旋转
}

local feiId = 10

local hitEffId = 133
---飞剑配置信息
local allSwordInfo = {
    [1] = { id = 1, color = 'd08400' },
    [2] = { id = 2, color = '1db100' },
    [3] = { id = 3, color = '0092cf' },
    [4] = { id = 4, color = 'd61200' },
    --[5] = { id = 99, color = 'd61200' },
}

local rootB = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_SKILL_BEHIND)
local rootF = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_SKILL)

local function getRootB()
    if rootB then
        return rootB
    end
    rootB = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_SKILL_BEHIND)
    return rootB
end

local function getRootF()
    if rootF then
        return rootF
    end
    rootF = global.sceneGraphCtl:GetSceneNode(global.MMO.NODE_SKILL)
    return rootF
end

local offset = cc.p(0, 30)

---当前怪物信息
local nowMonsters = {}

-- 飞剑节点初始化
---@class FlyingSword:cc.Node
---@field initAngle number 初始角度
---@field sword cc.Sprite
---@field swordInfo table
---@field itemSkillCfg ItemSkillCfg 绑定的被动技能
---@field particle cc.ParticleSystemQuad
---@field left number 当前动作剩余时间
---@field target string 目标id
---@field beizerPoints vec2_table[] 当前贝塞尔曲线信息
---@field state number 当前状态 0 待机 1 攻击中 2 返回中 3 攻击等待中
---@field stateDuration number 阶段持续时间
---@field nextAttack number 下次可攻击时间
local FlyingSword = class("FlyingSword", cc.Node)

function FlyingSword:ctor(swordInfo, player, radiusX, radiusY, speed, userPassiveSkillData)
    self.swordInfo = swordInfo
    --self.itemSkillCfg = userPassiveSkillData.itemSkillCfg
    self.sword = cc.Sprite:create()
    ---- 锚点设置为中心（确保旋转正确）
    self.sword:setAnchorPoint(0.5, 0.5)
    self.sword:initWithFile(string.format("res/custom/feijian/jian_%d.png", swordInfo.id)) -- 飞剑图片
    self:addChild(self.sword)
    self.player = player    -- 玩家引用
    self.radiusX = radiusX  -- 椭圆X轴半径
    self.radiusY = radiusY  -- 椭圆Y轴半径
    self.angle = 0          -- 当前角度
    self.speed = speed      -- 角速度（弧度/秒）
    --创建粒子
    self.particle = cc.ParticleSystemQuad:create("particle/tail.plist")
    self.particle:setName("tail")
    self.particle:setPosition(cc.p(0, 0))
    --设置颜色
    local color = UiTools.convertHexTo4B(swordInfo.color)
    color = UiTools.color4BTo4F(color)
    self.particle:setStartColor(color)
    self.particle:setEndColor(color)
    self:addChild(self.particle, 0)

    self:startIdle()
    self:setNextAttackTime(userPassiveSkillData.cd)
    self:setCD(userPassiveSkillData.cd)
    self:setAnchorPoint(0.5, 0.5)
end

function FlyingSword:setInitAngle(angle)
    self.initAngle = angle
    self.angle = angle
end

---获取下次可攻击时间
function FlyingSword:setNextAttackTime(time)
    time = time + 0.5
    self.nextAttack = time + Time.utcTime()
    if self.state == FeiJianSKill.SwordState.Idle or self.state == FeiJianSKill.SwordState.AttackCd2 then
        local now = Time.utcTime()
        if now < time then
            self.left = time - now
        else
            self.left = 0
        end
    end
end

---获取下次可攻击时间
function FlyingSword:setCD(time)
    SL:release_print("设置冷却时间:", time)
    self.cd = time
end

---索敌
function FlyingSword:seekEnemy()
    --SL:release_print("查找可攻击目标")
    --获取玩家周围怪物
    local nextTarget
    local canAttack = {}
    local monsters = FeiJianSKill.getCanAttackMonster()
    for i, v in ipairs(monsters) do
        if v:GetID() ~= self.target then
            --怪物存活且可以被攻击,放入可攻击列表
            table.insert(canAttack, v)
        end
    end
    if #canAttack > 0 then
        --随机一个怪物
        nextTarget = canAttack[math.random(#canAttack)]
        return nextTarget
    else
        --没有找到新目标
        return nil
    end
end

function FlyingSword:resetParent()
    local parent
    if self.state == FeiJianSKill.SwordState.Idle then
        if self.angle < 0 then
            parent = rootF
        else
            parent = rootB
        end
    else
        parent = rootF
    end
    local nowP = self:getParent()
    if nowP == nil then
        --UiTools.tips("self:getParent() is nil  new parentType " .. type(parent))
        parent:addChild(self)
    else
        self:retain()
        self:removeFromParent()
        parent:addChild(self)
        self:release()
    end
end

---进入返回模式
function FlyingSword:startBack(duration)
    self.angle = self.initAngle
    self.target = nil
    self.state = FeiJianSKill.SwordState.Back
    self.stateDuration = duration or 1
    self.left = self.stateDuration
    local p1 = cc.p(self:getPosition())
    local p2 = UiTools.calTargetByRotation(p1, self.sword:getRotation(), 300)
    local p3 = cc.pAdd(maptools.getActor(self.player):getPosition(), self:getIdlePos())
    local p4 = UiTools.calTargetByRotation(p3, self.sword:getRotation(), 200)
    self.beizerPoints = { p1, p2, p4, p3 }
end

---进入攻击模式
function FlyingSword:startAttackEnemy(newTarget)
    if self.state == FeiJianSKill.SwordState.Idle then
        --修改粒子信息
        if self.particle then
            self.particle:setTotalParticles(160)
            self.particle:setLife(0.8)
        end
    end
    self.target = newTarget:GetID()
    --SL:release_print("开始攻击敌人")
    self.state = FeiJianSKill.SwordState.Attack
    self.stateDuration = 0.3 + math.random(2) / 10
    self.left = self.stateDuration
    --根据当前的位置和朝向来确定贝塞尔曲线
    local p1 = cc.p(self:getPosition())
    local p2 = UiTools.calTargetByRotation(p1, self.sword:getRotation(), 300)
    local p3 = cc.pAdd(maptools.getActor(self.target):getPosition(), offset)
    local p4 = UiTools.calTargetByRotation(p3, self.sword:getRotation(), 200)
    self.beizerPoints = { p1, p2, p4, p3 }
end

---开始等待状态
function FlyingSword:startAttackWait()
    --攻击等待1
    self.state = FeiJianSKill.SwordState.AttackCd1
    --根据技能cd来确定
    self.stateDuration = 0.7
    self.left = self.stateDuration
    --根据当前的位置和朝向来确定贝塞尔曲线
    local p1 = cc.p(self:getPosition())
    local p2 = UiTools.calTargetByRotation(p1, self.sword:getRotation(), 300)
    local p3 = cc.pAdd(maptools.getActor(self.player):getPosition(), self:getIdlePos())
    local p4 = UiTools.calTargetByRotation(p3, self.sword:getRotation(), 200)
    self.beizerPoints = { p1, p2, p4, p3 }
end

---一个状态结束了
function FlyingSword:stateEnd()
    if self.state == FeiJianSKill.SwordState.Attack then
        --攻击结束，通知服务器
        if self.target then
            --播放特效
            maptools.addOrRefreshActorEffect(self.target, 138, 0, 0, 1, 1)
            FeiJianSKill.sendHitMonster(self.target, self.swordInfo.id)
        end
        --判断周围是否还有怪物，如果不存在怪物了，则攻击结束，否则进入攻击等待
        local monsters = FeiJianSKill.getCanAttackMonster()
        if #monsters == 0 then
            --没有怪物开始返回
            self:startBack()
        else
            --预定一个攻击怪物，这样不用每次都遍历所有怪物
            self.target = monsters[1]
            self:startAttackWait()
        end
    elseif self.state == FeiJianSKill.SwordState.Back then
        --返回模式，到达了玩家身边，开始进入待机模式
        self:startIdle()
        --刷新下下次索敌时间
        self:setNextAttackTime(self.cd)
    elseif self.state == FeiJianSKill.SwordState.AttackCd1 then
        --攻击冷却1结束，进入攻击模式下的巡航状态，判断攻击冷却
        local now = Time.utcTime()
        --SL:release_print("攻击冷却1结束，当前时间", now, "下次攻击时间", self.nextAttack, "剩余时间", self.left)
        if now >= self.nextAttack then
            --可以攻击了,查找可攻击目标，先清除一下预存储对象
            self.target = nil
            local monster = self:seekEnemy()
            if monster then
                self:startAttackEnemy(monster)
                self:setNextAttackTime(self.cd)
            else
                self:startBack()
            end
        else
            --还不能进行攻击，进行正常的巡航
            self.state = FeiJianSKill.SwordState.AttackCd2
            self.left = self.nextAttack - now
        end
    elseif self.state == FeiJianSKill.SwordState.AttackCd2 then
        --攻击冷却2结束，开始索敌
        local monster = self:seekEnemy()
        if monster then
            self:startAttackEnemy(monster)
            self:setNextAttackTime(self.cd)
        else
            --索敌失败，返回
            self:startBack()
        end
    else
        --待机模式等待结束，开始索敌
        local monster = self:seekEnemy()
        if monster then
            self:startAttackEnemy(monster)
        else
            --索敌失败，重新开始等待
            self:startIdle()
        end
    end
end

---进入待机模式
function FlyingSword:startIdle()
    if self.state ~= 0 then
        --修改粒子信息
        if self.particle then
            self.particle:setTotalParticles(40)
            self.particle:setLife(0.4)
        end
    end
    --SL:release_print("开启待机索敌等待")
    self.target = nil
    self.state = 0
    self.left = 1
end

function FlyingSword:getIdlePos()
    if self.state == FeiJianSKill.SwordState.Back or self.state == FeiJianSKill.SwordState.Idle then
        local x = self.radiusX * math.cos(self.angle) + offset.x
        local y = self.radiusY * math.sin(self.angle) + offset.y
        return cc.p(x, y)
    else
        local x = self.radiusX * 4 * math.cos(self.angle) + offset.x
        local y = self.radiusY * 4 * math.sin(self.angle) + offset.y
        return cc.p(x, y)
    end
end

---每个阶段的检查任务
function FlyingSword:stateCheck(actor)
    --if self.state ~= FeiJianSKill.SwordState.Idle and self.state ~= FeiJianSKill.SwordState.Back then
    if self.state ~= FeiJianSKill.SwordState.Back then
        --非待机状态，需要判断下距离，如果距离太远直接快速飞回玩家身边
        local nowPos = cc.p(self:getPosition())
        local playerPos = actor:getPosition()
        local dis = UiTools.getLength(nowPos, playerPos)
        if dis >= 1000 then
            --超过2000距离
            self:startBack(0.5)
            return
        end
    end
    if self.state == 1 then
        --攻击状态，判断怪物对象是否还存在
        local mon = maptools.getActor(self.target)
        if mon == nil or mon:GetHP() <= 0 then
            --怪物已经死亡，重新索敌
            local newTarget = self:seekEnemy()
            if newTarget then
                self:startAttackEnemy(newTarget)
            else
                --没有目标了,进入正常的飞回流程
                self:startBack()
            end
        end
    elseif self.state == 3 then
        --攻击冷却中，判断周围是否还有可以攻击的目标
        local mon = maptools.getActor(self.target)
        if mon == nil or mon:GetHP() < 0 then
            --一开始预设值的目标已经死亡，从小查看是否有可攻击的目标
            local mons = FeiJianSKill.getCanAttackMonster()
            if #mons > 0 then
                self.target = mons[1]
            else
                --没有可攻击的目标了
                self:startBack()
            end
        end
    end
end

---获取当前阶段应该在的位置
function FlyingSword:getStatePos(actor, dt)
    if self.state == FeiJianSKill.SwordState.Attack then
        return UiTools.calculateBezierPoint(self.beizerPoints, 1 - self.left / self.stateDuration)
    elseif self.state == FeiJianSKill.SwordState.Back or self.state == FeiJianSKill.SwordState.AttackCd1 then
        local p3 = cc.pAdd(maptools.getActor(self.player):getPosition(), self:getIdlePos())
        self.beizerPoints[4] = p3
        return UiTools.calculateBezierPoint(self.beizerPoints, 1 - self.left / self.stateDuration)
    else
        self.angle = self.angle + self.speed * dt
        if self.angle > math.pi then
            self.angle = self.angle - math.pi * 2
        end
        -- 位置计算
        local playerPos = actor:getPosition()
        return cc.pAdd(playerPos, self:getIdlePos())
    end
end

function FlyingSword:update(dt)
    local actor = maptools.getActor(self.player)
    if actor == nil then
        self:removeFromParent()
        --从node中移除
        local swordInfo = allSwordInfo[self.itemSkillCfg.SkillId]
        if swordInfo then
            swordInfo.node = nil
        end
        return
    end
    self:stateCheck(actor)
    --开始计算位置信息
    self.left = self.left - dt
    if self.left <= 0 then
        --阶段结束
        self:stateEnd()
    end
    --计算位置信息
    local targetPos = self:getStatePos(actor, dt)

    self:resetParent()
    local rotation
    local nowPos = cc.p(self:getPosition())
    self:setPosition(targetPos)
    if nowPos.x == 0 and nowPos.y == 0 then
        --初始化
        -- 方向修正核心代码
        local tangentX = -self.radiusX * math.sin(self.angle)
        local tangentY = -self.radiusY * math.cos(self.angle) -- Y分量取反
        -- 计算角度（弧度转角度）
        rotation = math.deg(math.atan2(tangentY, tangentX))
    else
        rotation = UiTools.calculateRotation(nowPos, targetPos)
    end
    --self:setRotation(rotation)
    self.sword:setRotation(rotation)
    local diff = math.abs(math.abs(rotation - 180) - 90)
    local scale = 1
    if diff < 60 then
        scale = diff / 60 * 0.5 + 0.5
    end
    --SL:release_print(scale)
    self.sword:setScale(scale * 0.3)
    nowMonsters = nil
end

function FeiJianSKill.getCanAttackMonster()
    if nowMonsters ~= nil then
        return nowMonsters
    else
        nowMonsters = {}
        local maxDis = 8
        local mainActor = maptools.getActor(SL:GetMetaValue("MAIN_ACTOR_ID"))
        local nowX = mainActor:GetMapX()
        local nowY = mainActor:GetMapY()
        for i, v in ipairs(SL:GetMetaValue("FIND_IN_VIEW_MONSTER_LIST")) do
            local monster = maptools.getActor(v)
            if monster:GetHP() > 0 and SL:GetMetaValue("TARGET_ATTACK_ENABLE", monster:GetID()) then
                --计算位置
                if math.abs(monster:GetMapX() - nowX) <= maxDis and math.abs(monster:GetMapY() - nowY) <= maxDis then
                    table.insert(nowMonsters, monster)
                end
            end
        end
    end
    return nowMonsters
end

---发送命中怪物 攻击击中触发伤害
---@param mID string 怪物id
---@param swordId number 飞剑id
function FeiJianSKill.sendHitMonster(mID, swordId)
    local mon = maptools.getActor(mID)
    if mon and mon:GetHP() > 0 then
        --验证距离
        local maxDis = 12
        if mon and mon:GetHP() > 0 and SL:GetMetaValue("TARGET_ATTACK_ENABLE", mon:GetID()) then
            --计算位置
            local mainActor = maptools.getActor(SL:GetMetaValue("MAIN_ACTOR_ID"))
            if math.abs(mon:GetMapX() - mainActor:GetMapX()) <= maxDis and math.abs(mon:GetMapY() - mainActor:GetMapY()) <= maxDis then
                --SL:Print( mID, swordId)
                --Message.send(ClientMsg.FeiJianHit, mID, swordId)
                SL:SubmitForm("飞剑_hit", mID, swordId)
            end
        end
    end
end

local function tryRemoveSwordNode(swordName)
    local node = getRootF():getChildByName(swordName)
    if node then
        node:removeFromParent()
    end
    node = getRootB():getChildByName(swordName)
    if node then
        node:removeFromParent()
    end
end

function FeiJianSKill.addSword(actorId, swordInfo, skillId,psData)
    --if swordInfo.id == 99 then
    --    --GM版本
    --    local count = 4
    --    if swordInfo.node then
    --        for i, v in ipairs(swordInfo.node) do
    --            v:removeFromParent()
    --        end
    --    end
    --    swordInfo.node = {}
    --    for i = 1, count do
    --        local nodeName = string.format("Sword_%d_%d", swordInfo.id, i)
    --        tryRemoveSwordNode(nodeName)
    --        --local psData = PassiveSkillManager.getUserSkillData(skillId)
    --        psData = psData or { cd=20 }
    --        if psData then
    --            --创建飞剑
    --            local sword = FlyingSword.new(swordInfo, actorId, 80, 40, math.pi / 1.5, psData)
    --            sword:setInitAngle(math.pi * 20 / i)
    --            sword:setName(nodeName)
    --            sword:setNextAttackTime(psData.cd)
    --            --手动执行一次update逻辑
    --            sword:update(0)
    --            table.insert(swordInfo.node, sword)
    --        end
    --    end
    --    return
    --end
    local nodeName = "Sword_" .. swordInfo.id
    tryRemoveSwordNode(nodeName)
    --local psData = PassiveSkillManager.getUserSkillData(skillId)
    psData = psData or { cd=5 }
    if psData then
        --创建飞剑
        local sword = FlyingSword.new(swordInfo, actorId, 80, 40, math.pi / 1.5, psData)
        --随机一个角度
        sword:setInitAngle(math.pi * swordInfo.id / 2)
        sword:setName(nodeName)
        sword:setNextAttackTime(psData.cd)
        sword:setCD(psData.cd)
        --手动执行一次update逻辑
        sword:setPosition(maptools.getActor(actorId):getPosition())
        sword:update(0)
        swordInfo.node = sword
    end
end

function FeiJianSKill.tick(dt)
    nowMonsters = nil
    for k, v in pairs(allSwordInfo) do
        if v.id == 99 then
            if v.node then
                for i, n in ipairs(v.node) do
                    if n and not tolua.isnull(n) then
                        n:update(dt)
                    end
                end
            end
        elseif v and v.node and not tolua.isnull(v.node) then
            v.node:update(dt)
        end

    end
    nowMonsters = nil
end

---初始化主玩家的飞剑状态
function FeiJianSKill.initMainActor(count,psData)
    --先删除所有飞剑
    local actor = SL:GetMetaValue("MAIN_ACTOR_ID")
    for skillId, v in pairs(count) do
        SL:release_print("添加飞剑:", skillId)
        FeiJianSKill.addSword(actor, allSwordInfo[tonumber(skillId)], tonumber(skillId),psData)
    end
end

function FeiJianSKill.removeAll()
    for skillId, swordInfo in pairs(allSwordInfo) do
        if swordInfo then
            if swordInfo.id == 99 then
                if swordInfo.node then
                    for i, v in ipairs(swordInfo.node) do
                        if v and not tolua.isnull(v) then
                            v:removeFromParent()
                        end
                    end
                end
                swordInfo.node = nil
            else
                local nodeName = "Sword_" .. swordInfo.id
                tryRemoveSwordNode(nodeName)
                swordInfo.node = nil
            end
        end
    end

end

local function onPassiveSkillData(data)
    if data.type == 0 then
        --初始化
        FeiJianSKill.initMainActor(data.count,data.psData)
    elseif data.type == 1 then
        --移除
        FeiJianSKill.removeAll()
    elseif data.type == 2 then -- 多飞剑再开
        --新增
        local swordInfo = allSwordInfo[data.skillId]
        if swordInfo then
            FeiJianSKill.addSword(SL:GetMetaValue("MAIN_ACTOR_ID"), swordInfo, data.skillId)
        end
    end
end

---场景内其他玩家命中
function FeiJianSKill.onFeiJianHit(p1, p2, p3, str)
    local data = SL:JsonDecode(str)
    local mainActor = SL:GetMetaValue("MAIN_ACTOR_ID")
    if mainActor == data.actor then
        --自身的效果，不用触发
        return
    end
    local actor = maptools.getActor(data.actor)
    if actor then
        local mId = tostring(data.target)
        local target = maptools.getActor(mId)
        if target == nil then
            SL:release_print("没有找到目标")
            return
        end
        --播放特效
        local sprite = cc.Sprite:create()
        SL:release_print("创建对象")
        sprite:initWithFile(string.format("res/custom/feijian/jian_%d.png", data.swordId)) -- 飞剑图片
        sprite:setAnchorPoint(0.5, 0.5)
        sprite:setScale(0.3)
        sprite:setOpacity(200)
        local from = cc.pAdd(actor:getPosition(), offset)
        local to = cc.pAdd(target:getPosition(), offset)
        sprite:setRotation(UiTools.calculateRotation(from, to))
        local effRoot = SkillEffectLogic.getEffectRoot()
        sprite:setPosition(from)
        effRoot:addChild(sprite)
        sprite:runAction(cc.Sequence:create({
            cc.EaseCubicActionIn:create(cc.MoveTo:create(0.2, to)),
            cc.CallFunc:create(function()
                maptools.addOrRefreshActorEffect(mId, hitEffId, 0, 0, 1, 1, true)
            end),
            cc.RemoveSelf:create()
        }))
    else
        SL:release_print("没有找到发射源")
    end
end


--添加一个空节点，主要是方便挂定时器
local taskNode = rootF:getChildByName("_task_node_")
if taskNode == nil then
    taskNode = cc.Node:create()
    taskNode:setName("_task_node_")
    rootF:addChild(taskNode)
    taskNode:scheduleUpdate(function(dt)
        FeiJianSKill.tick(dt)
    end)
end

SL:RegisterLUAEvent(LUA_EVENT_PASSIVE_SKILL_DATA, 'feiJian', function(data)
    onPassiveSkillData(data)
end)

return FeiJianSKill