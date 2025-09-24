maptools = {}

---根据id获取地图对象
function maptools.getActor(id)
    --SL:release_print("getActor:",id,global.actorManager:GetActor(id))
    return global.actorManager:GetActor(id)
end

---获取当前玩家主对象
function maptools.getMainActorObj()
    return global.gamePlayerController.mMainPlayerActor
end

---获取当前场景中的所有怪物
function maptools.getMonstersInCurrView()
    return global.monsterManager.mMonstersInCurrViewField
end

---获取怪物信息
function maptools.getMonsterById(id)
    return global.monsterManager:FindOneMonsterInCurrViewFieldById(tostring(id))
end

---获取玩家对象
function maptools.getPlayerById(id)
    return global.playerManager:FindOnePlayerInCurrViewFieldById(tostring(id))
end

---获取怪物地图坐标
function maptools.getObjMapPos(obj)
    return obj.mCurrMapX, obj.mCurrMapY
end

---获取怪物的ui对象
function maptools.getObjUi(obj)
    return obj.mCurrActorNode
end

function maptools.getActorPos(actorId)
    local actor = global.actorManager:GetActor(actorId)
    if actor == nil then
        return nil
    end
    local uiNode = actor.mCurrActorNode
    if uiNode == nil or tolua.isnull(uiNode) then
        return nil
    end
    --local offset = global.MMO.PLAYER_AVATAR_OFFSET
    local pos = cc.p(uiNode:getPosition())
    --SL:release_print(pos.x + offset.x, pos.y + offset.y)
    --SL:release_print("map", actor.mCurrMapX, actor.mCurrMapY)
    --目标获取到的xy 是右小角，所以此处进行一个偏移
    return pos
end



function maptools.getObjCenterPos(objUi)
    local x, y = objUi:getPosition()
    --目标获取到的xy 是右小角，所以此处进行一个偏移
    --return cc.p(x-global.MMO.MapGridWidth/2, y+global.MMO.MapGridHeight)

    return cc.p(x, y + global.MMO.MapGridHeight / 2)
end

---添加播放特效
function maptools.playActorEffect(actorId, effId, offsetX, offsetY, count, speed, front)
    if front == nil then
        front = true
    end
    global.ActorEffectManager:AddEffect({
        actorID = actorId,
        offsetX = offsetX,
        offsetY = offsetY,
        sfxID = effId,
        count = count or 1,
        front = front,
        speed = speed or 1,
    })
end

---添加特效如果存在，则刷新重新开始
function maptools.addOrRefreshActorEffect(actorId, effId, offsetX, offsetY, count, speed, front)
    --SL:release_print("播放特效",actorId,effId)
    local all = global.ActorEffectManager:GetItemsByActorID(actorId)
    local eff = all[effId]
    if eff then
        maptools.removeActorEffect(actorId, effId)
    end
    maptools.playActorEffect(actorId, effId, offsetX, offsetY, count, speed, front)
end

function maptools.removeActorEffect(actorId, effId)
    global.ActorEffectManager:RmvEffect({ actorID = actorId, sfxID = effId })
end

function maptools.createTempNpc()
    global.netNpcController:AddNetNpcToWorld()
end