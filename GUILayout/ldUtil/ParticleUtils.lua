ParticleUtils = {}

local flashTexture = cc.Director:getInstance():getTextureCache():addImage("res/custom/particle/000001.png")

function ParticleUtils.createFlash(parent)
    --local particleSystem = cc.ParticleSystemQuad:create("res/custom/particle/rewardFlash.plist")
    local particleSystem = GUI:ParticleEffect_Create(parent, 'particle'..math.random(), 0, 0, "res/custom/particle/rewardFlash.plist")
    particleSystem:setTexture(flashTexture)
    particleSystem:setStartSize(180)
    --particleSystem:setName("particle")
    return particleSystem
end

local tailTexture

function ParticleUtils.createTail()
    if tailTexture == nil then
        tailTexture = cc.Director:getInstance():getTextureCache():addImage("res/custom/particle/guangdian.png")
    end
    local particleSystem = cc.ParticleSystemQuad:create("res/custom/particle/tail.plist")
    particleSystem:setTexture(tailTexture)
    particleSystem:setName("particle")
    return particleSystem
end