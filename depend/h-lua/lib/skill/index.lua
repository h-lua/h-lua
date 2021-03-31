hskill = {}

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
hskill.getAttribute = function(abilityId)
    if (type(abilityId) == "number") then
        abilityId = string.id2char(abilityId)
    end
    return hslk.i2v(abilityId, "_attr")
end

--- 附加单位获得技能后的属性
---@protected
hskill.addProperty = function(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr == nil) then
        return
    end
    if (#attr > 0) then
        level = level or 1
        attr = attr[level]
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, true, whichUnit, attr, 1)
    hring.insert(whichUnit, abilityId, level)
end
--- 削减单位获得技能后的属性
---@protected
hskill.subProperty = function(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr == nil) then
        return
    end
    if (#attr > 0) then
        level = level or 1
        attr = attr[level]
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, false, whichUnit, attr, 1)
    hring.remove(whichUnit, abilityId, level)
end

--- 添加技能
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
hskill.add = function(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    level = level or 1
    if (during == nil or during <= 0) then
        cj.UnitAddAbility(whichUnit, id)
        cj.UnitMakeAbilityPermanent(whichUnit, true, id)
        if (level > 1) then
            cj.SetUnitAbilityLevel(whichUnit, id, level)
        end
        hskill.addProperty(whichUnit, id, level)
    else
        cj.UnitAddAbility(whichUnit, id)
        if (level > 1) then
            cj.SetUnitAbilityLevel(whichUnit, id, level)
        end
        hskill.addProperty(whichUnit, id, level)
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            hskill.del(whichUnit, id)
        end)
    end
end

--- 设置技能等级
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
hskill.set = function(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    local prevLv = cj.GetUnitAbilityLevel(whichUnit, id)
    if (level == nil or level == prevLv) then
        return
    end
    if (prevLv < 1) then
        hskill.add(whichUnit, abilityId, level, during)
    else
        if (during == nil or during <= 0) then
            hskill.subProperty(whichUnit, id, prevLv)
            cj.SetUnitAbilityLevel(whichUnit, id, level)
            hskill.addProperty(whichUnit, id, level)
        else
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hskill.set(whichUnit, abilityId, prevLv, nil)
            end)
        end
    end
end

--- 删除技能
---@param whichUnit userdata
---@param abilityId string|number
---@param delay number
hskill.del = function(whichUnit, abilityId, delay)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    local lv = cj.GetUnitAbilityLevel(whichUnit, id)
    if (lv < 1) then
        return
    end
    if (delay == nil or delay <= 0) then
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id, lv)
    else
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id, lv)
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            hskill.add(whichUnit, id, lv)
        end)
    end
end

--- 设置技能的永久使用性
---@param whichUnit userdata
---@param abilityId string|number
hskill.forever = function(whichUnit, abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    cj.UnitMakeAbilityPermanent(whichUnit, true, id)
end

--- 是否拥有技能
---@param whichUnit userdata
---@param abilityId string|number
hskill.has = function(whichUnit, abilityId)
    if (whichUnit == nil or abilityId == nil) then
        return false
    end
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    if (cj.GetUnitAbilityLevel(whichUnit, id) >= 1) then
        return true
    end
    return false
end

--- [JAPI]设置单位某个技能的冷却时间
---@param whichUnit userdata
---@param abilityID string|number
---@param coolDown number
hskill.setCoolDown = function(whichUnit, abilityID, coolDown)
    if (coolDown >= 9999) then
        coolDown = 9999
    elseif (coolDown < 0) then
        coolDown = 0
    end
    hjapi.EXSetAbilityState(hjapi.EXGetUnitAbility(whichUnit, abilityID), 1, coolDown)
end
