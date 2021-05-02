---@class heffect 特效
heffect = {
    ---@private
    _ttg = {},
}

--- 删除特效
---@param e userdata
heffect.del = function(e)
    if (e ~= nil) then
        cj.DestroyEffect(e)
    end
end

--- 在XY坐标创建特效
---@param effectModel string
---@param x number
---@param y number
---@param during number 0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
---@return userdata
heffect.toXY = function(effectModel, x, y, during)
    during = during or 0
    if (effectModel == nil or during < 0) then
        return
    end
    local eff
    if (during > 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffect(effectModel, x, y)
        cj.DestroyEffect(eff)
    end
    return eff
end

--- 在单位所处位置创建特效
---@param effectModel string
---@param targetUnit userdata
---@param during number 0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
---@return userdata
heffect.toUnit = function(effectModel, targetUnit, during)
    during = during or 0
    if (effectModel == nil or targetUnit == nil or during < 0) then
        return
    end
    local eff
    local x = hunit.x(targetUnit)
    local y = hunit.y(targetUnit)
    if (during > 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffect(effectModel, x, y)
        cj.DestroyEffect(eff)
    end
    return eff
end

--- 创建特效绑定单位模型
---@param effectModel string
---@param targetUnit userdata
---@param attach string | "'origin'" | "'head'" | "'chest'"
---@param during number 0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）-1为无限
---@return userdata
heffect.bindUnit = function(effectModel, targetUnit, attach, during)
    if (effectModel == nil or targetUnit == nil or attach == nil) then
        return
    end
    local eff
    during = during or 0
    if (during > 0) then
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    elseif (during == -1) then
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
    else
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
        cj.DestroyEffect(eff)
    end
    return eff
end
