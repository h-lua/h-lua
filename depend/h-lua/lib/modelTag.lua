hmtg_site = hmtg_site or {}
hmtg_site.char = hmtg_site.char or {}
hmtg_site.mdx = hmtg_site.mdx or {}

hmtg_limit = 100
hmtg_limiter = hmtg_limiter or 0
hmtg_char = hmtg_char or {}

---@class hmodelTag 模型漂浮字
hmodelTag = hmodelTag or {}

--- 注册字符对应的模型和位宽
---@param char string
---@param modelAlias string
---@param bit number
function hmodelTag.char(char, modelAlias, bit)
    hmtg_char[tostring(char)] = { modelAlias, bit }
end

--- 字串漂浮字
---@see str string 漂浮字信息
---@see width number 字间
---@see speed number 速度
---@see size number 尺寸
---@see scale {number,number} 缩放变化
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see height number 上升高度
---@see duration number 持续时间
---@param options {str:number,width:number,speed:number,size:number,scale:{number,number},x:number,y:number,z:number,height:number,duration:number}
function hmodelTag.word(options)
    if (hmtg_limiter > hmtg_limit) then
        return
    end
    local str = tostring(options.str) or ""
    local width = options.width or 10
    local speed = options.speed or 1
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local height = options.height or 200
    local duration = options.duration or 0.5
    local frequency = 0.05
    local spd = height / (duration / frequency)
    --
    local words = mbstring.split(str, 1)
    if (#words > 0) then
        x = math.floor(x)
        y = math.floor(y)
        local site = x .. y
        if (hmtg_site.char[site] == nil) then
            hmtg_site.char[site] = true
            htime.setTimeout(duration, function()
                hmtg_site.char[site] = nil
            end)
            hmtg_limiter = hmtg_limiter + 1
            local effs = {}
            for i, w in ipairs(words) do
                if (hmtg_char[w] == nil) then
                    error("char")
                    return
                end
                local mdl = hmtg_char[w][1]
                local bit = hmtg_char[w][2]
                effs[i] = heffect.xyz(mdl, x + ((i - 1) * width * bit), y, z, -1)
                heffect.speed(effs[i], speed)
                heffect.scale(effs[i], size, size, size)
            end
            local dur = 0
            local h = z
            local ani = 0
            htime.setInterval(frequency, function(curTimer)
                dur = dur + frequency
                if (dur >= duration) then
                    curTimer.destroy()
                    for i, _ in ipairs(words) do
                        heffect.destroy(effs[i])
                    end
                    hmtg_limiter = hmtg_limiter - 1
                    return
                end
                h = h + spd
                local s1
                local s2
                if (scale[1] ~= 1 or scale[2] ~= 1) then
                    ani = ani + frequency
                    if (ani >= 0.1) then
                        ani = 0
                        if (dur < duration * 0.5) then
                            s1 = scale[1]
                            width = width * s1
                        else
                            s2 = scale[2]
                            width = width * s2
                        end
                    end
                end
                for i, w in ipairs(words) do
                    hjapi.EXSetEffectZ(effs[i], h)
                    if (s1 ~= nil) then
                        hjapi.EXSetEffectXY(effs[i], x + ((i - 1) * width * hmtg_char[w][2]), y)
                        hjapi.EXEffectMatScale(effs[i], s1, s1, s1)
                    elseif (s2 ~= nil) then
                        hjapi.EXSetEffectXY(effs[i], x + ((i - 1) * width * hmtg_char[w][2]), y)
                        hjapi.EXEffectMatScale(effs[i], s2, s2, s2)
                    end
                end
            end)
        end
    end
end


-- 模型漂浮字
---@see model string 模型路径
---@see speed number 速度
---@see size number 尺寸
---@see scale number 缩放
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see offset number 偏移
---@see height number 上升高度
---@see duration number 持续时间
---@param options {model:string,speed:number,size:number,scale:number,x:number,y:number,z:number,offset:number,height:number,duration:number}
function hmodelTag.model(options)
    local model = options.model
    if (model == nil) then
        return
    end
    if (hmtg_limiter > hmtg_limit) then
        return
    end
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local offset = math.floor(options.offset or 0)
    local height = options.height or 1000
    local speed = options.speed or 1
    local duration = options.duration or 1
    local frequency = 0.05
    x = math.floor(x)
    y = math.floor(y)
    local site = x .. y
    if (hmtg_site.mdx[site] == nil) then
        hmtg_limiter = hmtg_limiter + 1
        hmtg_site.mdx[site] = true
        htime.setTimeout(duration, function()
            hmtg_site.mdx[site] = nil
        end)
        local spd = height / (duration / frequency)
        local eff = heffect.xyz(model, x, y, z, -1)
        heffect.speed(eff, speed)
        heffect.scale(eff, size, size, size)
        local dur = 0
        local h = z
        local randX = 0
        local randY = 0
        if (offset ~= 0) then
            randX = math.rand(-offset, offset)
            randY = math.rand(-offset, offset)
        end
        local ani = 0
        htime.setInterval(frequency, function(curTimer)
            dur = dur + frequency
            if (dur >= duration) then
                curTimer.destroy()
                heffect.destroy(eff)
                hmtg_limiter = hmtg_limiter - 1
                return
            end
            h = h + spd
            local s1
            local s2
            if (scale[1] ~= 1 or scale[2] ~= 1) then
                ani = ani + frequency
                if (ani >= 0.1) then
                    ani = 0
                    if (dur < duration * 0.5) then
                        s1 = scale[1]
                    else
                        s2 = scale[2]
                    end
                end
            end
            x = x + randX
            y = y + randY
            hjapi.EXSetEffectXY(eff, x, y)
            hjapi.EXSetEffectZ(eff, h)
            if (s1 ~= nil) then
                hjapi.EXEffectMatScale(eff, s1, s1, s1)
            elseif (s2 ~= nil) then
                hjapi.EXEffectMatScale(eff, s2, s2, s2)
            end
        end)
    end
end