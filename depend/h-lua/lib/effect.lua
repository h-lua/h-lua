---@class heffect 特效
heffect = {}

--- 删除特效
---@param e userdata
function heffect.destroy(e)
    if (e ~= nil) then
        cj.DestroyEffect(e)
        e = nil
    end
end

--- 特效缩放
---@param e number
---@param x number
---@param y number
---@param z number
---@return void
function heffect.scale(e, x, y, z)
    if (e ~= nil and x ~= nil and y ~= nil and z ~= nil) then
        hjapi.EXEffectMatScale(e, x, y, z)
    end
end

--- 特效速度
---@param e number
---@param spd number
---@return void
function heffect.speed(e, spd)
    if (e ~= nil and spd ~= nil) then
        hjapi.EXSetEffectSpeed(e, spd)
    end
end

--- 在XY坐标创建特效
--- 有的模型用此方法不会播放，此时需要duration>0
---@param model string support:alias
---@param x number
---@param y number
---@param z number
---@param duration number 当小于0时不主动删除，等于0时为删除型播放，大于0时持续一段时间
---@return userdata|nil
function heffect.xyz(model, x, y, z, duration)
    if (model == nil) then
        return
    end
    z = z or 0
    duration = duration or 0
    local e = cj.AddSpecialEffect(model, x, y)
    if (duration == 0) then
        heffect.destroy(e)
        return
    end
    if (type(z) == "number") then
        hjapi.EXSetEffectZ(e, z)
    end
    if (duration > 0) then
        htime.setTimeout(duration, function(curTimer)
            curTimer.destroy()
            heffect.destroy(e)
        end)
    end
    return e
end

--- 创建特效绑定单位模型
---@param model string
---@param targetUnit userdata
---@param attach string | "'origin'" | "'head'" | "'chest'"
---@param duration number 当小于0时不主动删除，等于0时为删除型播放，大于0时持续一段时间
---@return userdata|nil
function heffect.attach(model, targetUnit, attach, duration)
    if (model == nil or targetUnit == nil or attach == nil) then
        return
    end
    duration = duration or 0
    local e = cj.AddSpecialEffectTarget(model, targetUnit, attach)
    if (duration == 0) then
        heffect.destroy(e)
        return
    end
    if (duration > 0) then
        htime.setTimeout(duration, function(t)
            t.destroy()
            cj.DestroyEffect(e)
        end)
    end
    return e
end
