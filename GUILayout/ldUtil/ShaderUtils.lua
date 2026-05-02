ShaderUtils = {}

local Name = {
    Default = 'custom_default',
    Gray = 'custom_gray', --置灰
    Dissolve = 'custom_dissolve', --溶解
    Silhouette = 'custom_silhouette_shader', --剪影
    Brightness = "custom_brightness_shader", --高亮
    Streamer = 'custom_streamer_shader', --流光
    DissolveByBright = 'custom_dissolve2', --根据亮度进行溶解
    DissolveByNoise = 'custom_dissolve', --根据亮度进行溶解
    BrightnessGradientY = 'custom_brightness_gradientY', --Y轴亮度渐变
    ColorGradient = 'custom_color_gradient', --颜色渐变
}

ShaderUtils.Name = Name

local shaderCfg = {
    [Name.Default] = { vert = 'shader/default.vert', frag = 'shader/default.frag' },
    [Name.Gray] = { vert = 'shader/default.vert', frag = 'shader/gray.frag' },
    [Name.Dissolve] = { vert = 'shader/default.vert', frag = 'shader/dissolve.frag' },
    [Name.Silhouette] = { vert = 'shader/default.vert', frag = 'shader/silhouette.frag' },
    [Name.Brightness] = { vert = 'shader/default.vert', frag = 'shader/brightness.frag' },
    [Name.Streamer] = { vert = 'shader/default.vert', frag = 'shader/streamer.frag' },
    [Name.DissolveByBright] = { vert = 'shader/default.vert', frag = 'shader/dissolve2.frag' },
    [Name.DissolveByNoise] = { vert = 'shader/default.vert', frag = 'shader/dissolve.frag' },
    [Name.BrightnessGradientY] = { vert = 'shader/default.vert', frag = 'shader/gradient2.frag' },
    [Name.ColorGradient] = { vert = 'shader/default.vert', frag = 'shader/gradient.frag' },
    ['test'] = { vert = 'shader/default.vert', frag = 'shader/noise.frag' },
}

local NameProperty = '_custom_gl_name_'

---获取shader
---@param name string ShaderName
---@param noCache boolean|nil 是否不走缓存
function ShaderUtils.getGLProgram(name, noCache)
    noCache = noCache or SL._DEBUG
    local cfg = shaderCfg[name]
    if cfg == nil then
        logger.stack("没有找到shader配置:" .. (name or ''))
        return nil
    end
    if noCache then
        local shader = cc.GLProgram:createWithFilenames(cfg.vert, cfg.frag)
        if shader then
            shader[NameProperty] = name
        end
        --SL:release_print("noCache", name, shader,cfg.vert, cfg.frag)
        return shader
    end
    local shader = cc.GLProgramCache:getInstance():getGLProgram(name)
    if shader == nil then
        shader = cc.GLProgram:createWithFilenames(cfg.vert, cfg.frag)
        SL:release_print("addGLProgram", name, shader)
        cc.GLProgramCache:getInstance():addGLProgram(shader, name)
    end
    shader[NameProperty] = name
    return shader
end

local uniformLocations = {}

---@param glProgram cc.GLProgram
function ShaderUtils.getUniformLocation(glProgram, uniformName)
    local name = glProgram[NameProperty]
    if name == nil then
        return gl.getUniformLocation(glProgram:getProgram(), uniformName)
    end
    local locations = uniformLocations[name]
    if locations == nil then
        locations = {}
        uniformLocations[name] = locations
    end
    local location = gl.getUniformLocation(glProgram:getProgram(), uniformName)
    --SL:release_print("getUniformLocation", name, uniformName, location)
    locations[uniformName] = location
    return location
end

function ShaderUtils.checkHasShader(node, shader)
    local glProgramState = node:getGLProgramState()
    if glProgramState then
        local glProgram = glProgramState:getGLProgram()
        if glProgram == shader then
            return true
        end
    end
    return false
end

function ShaderUtils.removeShader(node, checkShader)
    if checkShader and node:getGLProgram() ~= checkShader then
        return
    end
    node:setGLProgram(ShaderUtils.getGLProgram(Name.Default))
end

---更新shader值
---@param node cc.Node
---@param name string 参数名
---@param value number 参数值
function ShaderUtils.updateUniformFloat(node, name, value)
    local state = node:getGLProgramState()
    if state == nil or state:getGLProgram()[NameProperty] == Name.Default then
        return
    end
    local location = ShaderUtils.getUniformLocation(state:getGLProgram(), name)
    if location >= 0 then
        state:setUniformFloat(location, value)
    end
end

---@param node ccui.Widget
---@param gray boolean
function ShaderUtils.setGray(node, gray)
    local glProgram = ShaderUtils.getGLProgram(Name.Gray)
    if gray then
        --SL:release_print(node:getGLProgram(), node:getGLProgramState())
        node:setGLProgram(glProgram)
        --SL:release_print(node:getGLProgram(), node:getGLProgramState())
    elseif ShaderUtils.checkHasShader(node, glProgram) then
        node:setGLProgram(ShaderUtils.getGLProgram(Name.Default))
    end
    for i, v in ipairs(node:getChildren()) do
        ShaderUtils.setGray(v, gray)
    end
end

-- ==============剪影==================

---@param node cc.Node
---@param show boolean 是否启用
---@param gray number 灰度
function ShaderUtils.showSilhouette(node, show, gray)
    if not node then
        return
    end
    local shader = ShaderUtils.getGLProgram(Name.Silhouette)
    if shader == nil then
        SL:release_print("没有找到shader")
        return
    end
    if show then
        gray = gray or 1
        local nowState = node:getGLProgramState()
        if nowState == nil or nowState:getGLProgram() ~= shader then
            nowState = cc.GLProgramState:create(shader)
            node:setGLProgramState(nowState)
        end
        local location = ShaderUtils.getUniformLocation(shader, 'u_gray')
        nowState:setUniformFloat(location, gray)
    else
        local state = node:getGLProgramState()
        if state ~= nil and state:getGLProgram() == shader then
            node:setGLProgram(ShaderUtils.getGLProgram(Name.Default))
        end
    end
end


-- ==============高亮==================

---@param node cc.Node
---@param brightness number 增加亮度
function ShaderUtils.setBrightness(node, brightness)
    if not node then
        return
    end
    local shader = ShaderUtils.getGLProgram(Name.Brightness)
    if shader == nil then
        SL:release_print("没有找到shader")
        return
    end
    brightness = brightness or 0
    if brightness ~= 0 then
        node:setGLProgramState(cc.GLProgramState:create(shader))
        ShaderUtils.updateBrightness(node, brightness)
    else
        local state = node:getGLProgramState()
        if state ~= nil and state:getGLProgram() == shader then
            node:setGLProgram(ShaderUtils.getGLProgram(Name.Default))
        end
    end
end

function ShaderUtils.updateBrightness(node, brightness)
    ShaderUtils.updateUniformFloat(node, 'u_brightness', brightness)
end

--==============流光============
function ShaderUtils.setXStreamer(node, baseX, bright, slope)
    if not node then
        return
    end
    local glProgram = ShaderUtils.getGLProgram(Name.Streamer)
    if glProgram == nil then
        return nil
    end
    node:setGLProgramState(node, cc.GLProgramState:create(glProgram))
    ShaderUtils.updateStreamer(node, baseX, bright, slope)

end

function ShaderUtils.updateStreamer(node, baseX, bright, slope)
    baseX = baseX or 0
    slope = slope or 0.15
    bright = bright or 1
    ShaderUtils.updateUniformFloat(node, 'u_base_x', baseX)
    ShaderUtils.updateUniformFloat(node, 'u_max_bright', bright)
    ShaderUtils.updateUniformFloat(node, 'u_slope', slope)
end

function ShaderUtils.clearStreamer(node)
    if not node then
        return
    end
    ShaderUtils.removeShader(node, ShaderUtils.getGLProgram(Name.Streamer))
end

-- ==============透明==================
---设置根据亮度进行溶解
---@param node cc.Node
function ShaderUtils.setDissolveByBright(node, start)
    if not node then
        return
    end
    local shader = ShaderUtils.getGLProgram(Name.DissolveByBright)
    if shader == nil then
        SL:release_print("没有找到shader")
        return
    end
    start = start or 0
    node:setGLProgramState(cc.GLProgramState:create(shader))
    ShaderUtils.updateDissolveBright(node, start)
end

function ShaderUtils.updateDissolveBright(node, limit)
    ShaderUtils.updateUniformFloat(node, "u_limit_alpha", limit)
end

---@param node cc.Node
function ShaderUtils.setDissolveByNoise(node, noise, border, borderColor, borderColor2)
    --动态生成一张噪声纹理
    local glProgram = ShaderUtils.getGLProgram(Name.DissolveByNoise, true)
    if glProgram == nil then
        SL:release_print("没有找到shader")
        return
    end
    local state = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    state:setUniformFloat(ShaderUtils.getUniformLocation(glProgram, 'u_limit_alpha'), 0)
    state:setUniformFloat(ShaderUtils.getUniformLocation(glProgram, 'u_border'), border or 0)
    borderColor = borderColor or cc.c4b(0, 0, 0)
    borderColor2 = borderColor2 or cc.c4b(0, 0, 0)
    state:setUniformVec4(ShaderUtils.getUniformLocation(glProgram, 'u_border_color'), cc.vec3(borderColor.r / 255, borderColor.g / 255, borderColor.b / 255, (borderColor.a or 0) / 255))
    state:setUniformVec4(ShaderUtils.getUniformLocation(glProgram, 'u_border_color2'), cc.vec3(borderColor2.r / 255, borderColor2.g / 255, borderColor2.b / 255, (borderColor2.a or 0) / 255))
    local noiseL = ShaderUtils.getUniformLocation(glProgram, 'u_noise')
    if noiseL > 0 then
        local textureCache = cc.Director:getInstance():getTextureCache()

        if noise == nil or noise <= 0 or noise > 4 then
            noise = math.random(1, 4);
        end
        local key = 'res/custom/noise/' .. noise .. '.png'
        if SL._DEBUG then
            textureCache:reloadTexture(key)
            local t = textureCache:getTextureForKey(key)
            state:setUniformTexture(noiseL, t)
        else
            local t = textureCache:getTextureForKey(key)
            if t == nil then
                SL:release_print("加载", t)
                t = textureCache:addImage(key)
            end
            state:setUniformTexture(noiseL, t)
        end

    else
        --SL:release_print("没有找到u_noise_texture", noiseL)
    end
    node:setGLProgramState(state)
end

---@param node cc.Node
---@param progress number 进度 0~1
function ShaderUtils.updateDissolveLimit(node, progress)
    local state = node:getGLProgramState()
    if state and state:getGLProgram()[NameProperty] == Name.DissolveByNoise then
        --SL:release_print("updateDissolveLimit", progress)
        local al = ShaderUtils.getUniformLocation(state:getGLProgram(), 'u_limit_alpha')
        state:setUniformFloat(al, progress)
    end
end

-- ==============渐变==================
---@param node cc.Node
function ShaderUtils.setGradientColor(node, startColor, endColor, ox, oy)
    local glProgram = ShaderUtils.getGLProgram(Name.ColorGradient)
    if glProgram == nil then
        return
    end
    local nowState = node:getGLProgramState()
    if nowState == nil or nowState:getGLProgram() ~= glProgram then
        SL:release_print("cc.setGradientColor:create(glProgram)")
        nowState = cc.GLProgramState:create(glProgram)
        node:setGLProgramState(nowState)
    end
    local cl1 = ShaderUtils.getUniformLocation(glProgram, 'u_startColor')
    local cl2 = ShaderUtils.getUniformLocation(glProgram, 'u_endColor')
    local xl = ShaderUtils.getUniformLocation(glProgram, 'u_x_flag')
    local yl = ShaderUtils.getUniformLocation(glProgram, 'u_y_flag')
    nowState:setUniformVec3(cl1, cc.vec3(startColor.r / 255, startColor.g / 255, startColor.b / 255))
    nowState:setUniformVec3(cl2, cc.vec3(endColor.r / 255, endColor.g / 255, endColor.b / 255))
    nowState:setUniformFloat(xl, ox or 0.5)
    nowState:setUniformFloat(yl, oy or 0.5)
end