hskill = {}

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
function hskill.getAttribute(abilityId)
    if (type(abilityId) == "number") then
        abilityId = i2c(abilityId)
    end
    return hslk.i2v(abilityId, "_attr")
end

--- 附加单位获得技能后的属性
---@protected
function hskill.addProperty(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr ~= nil) then
        if (#attr > 0) then
            level = level or 1
            attr = attr[level]
        end
        hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, true, whichUnit, attr, 1)
    end
end
--- 削减单位获得技能后的属性
---@protected
function hskill.subProperty(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr ~= nil) then
        if (#attr > 0) then
            level = level or 1
            attr = attr[level]
        end
        hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, false, whichUnit, attr, 1)
    end
end

--- 获取技能名称
---@param abilityId number|string
---@return string
function hskill.getName(abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    return cj.GetObjectName(id)
end

--- 获取技能等级
---@param whichUnit userdata
---@param abilityId number|string
---@return string
function hskill.getLevel(whichUnit, abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    return cj.GetUnitAbilityLevel(whichUnit, id)
end

--- 设置技能等级
---@param whichUnit userdata
---@param abilityId number|string
---@param level number
---@return string
function hskill.setLevel(whichUnit, abilityId, level)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    return cj.SetUnitAbilityLevel(whichUnit, id, level)
end

--- 添加技能
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
function hskill.add(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
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
            t.destroy()
            hskill.destroy(whichUnit, id)
        end)
    end
end

--- 设置技能等级
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
function hskill.set(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
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
                t.destroy()
                hskill.set(whichUnit, abilityId, prevLv, nil)
            end)
        end
    end
end

--- 删除技能
---@param whichUnit userdata
---@param abilityId string|number
---@param delay number
function hskill.destroy(whichUnit, abilityId, delay)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
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
            t.destroy()
            hskill.add(whichUnit, id, lv)
        end)
    end
end

--- 设置技能的永久使用性
---@param whichUnit userdata
---@param abilityId string|number
function hskill.forever(whichUnit, abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    cj.UnitMakeAbilityPermanent(whichUnit, true, id)
end

--- 是否拥有技能
---@param whichUnit userdata
---@param abilityId string|number
function hskill.has(whichUnit, abilityId)
    if (whichUnit == nil or abilityId == nil) then
        return false
    end
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    if (cj.GetUnitAbilityLevel(whichUnit, id) >= 1) then
        return true
    end
    return false
end

--- [JAPI]设置单位某个技能的冷却时间
---@param whichUnit userdata
---@param abilityId string|number
---@param coolDown number
function hskill.setCoolDown(whichUnit, abilityId, coolDown)
    if (coolDown >= 9999) then
        coolDown = 9999
    elseif (coolDown < 0) then
        coolDown = 0
    end
    hjapi.EXSetAbilityState(hjapi.EXGetUnitAbility(whichUnit, abilityId), 1, coolDown)
end

--[[
    造成伤害
    options = {
        sourceUnit = nil, --伤害来源(可选)
        targetUnit = nil, --目标单位
        damage = 0, --实际伤害
        damageSrc = "unknown", --伤害来源请查看 CONST_DAMAGE_SRC
        effect = string, --特效路径
    }
]]
---@alias noteSkillDamage {sourceUnit:userdata,targetUnit:userdata,damage:number,effect:string,damageSrc:string}
---@param options noteSkillDamage
function hskill.damage(options)
    options.damage = options.damage or 0
    if (options.damage < 0.125) then
        return
    end
    if (options.targetUnit == nil) then
        return
    end
    if (hunit.isDead(options.targetUnit) or hunit.isDestroyed(options.targetUnit)) then
        return
    end
    if (hunit.isDestroyed(options.targetUnit)) then
        return
    end
    if (options.sourceUnit ~= nil and hunit.isDestroyed(options.sourceUnit)) then
        return
    end
    if (options.damageSrc == nil) then
        options.damageSrc = CONST_DAMAGE_SRC.unknown
    end
    --双方attr get
    if (hattribute.get(options.targetUnit) == nil) then
        return
    end
    if (options.sourceUnit ~= nil and hattribute.get(options.sourceUnit) == nil) then
        return
    end
    --- 对接伤害过程
    damaging.actions.forEach(function(_, callFunc)
        callFunc(options)
        return options.damage > 0
    end)
    -- 最终伤害
    if (options.damage > 0.125 and hunit.isDestroyed(options.targetUnit) == false) then
        -- 设置单位|玩家正在受伤
        local isBeDamagingTimer = hcache.get(options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        if (isBeDamagingTimer ~= nil) then
            isBeDamagingTimer.destroy()
            hcache.set(options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        end
        hcache.set(options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, true)
        hcache.set(
            options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER,
            htime.setTimeout(3.5, function(t)
                t.destroy()
                hcache.set(options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
                hcache.set(options.targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, false)
            end)
        )
        local targetPlayer = hunit.getOwner(options.targetUnit)
        hplayer.addBeDamage(targetPlayer, options.damage)
        local isPlayerBeDamagingTimer = hcache.get(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        if (isPlayerBeDamagingTimer ~= nil) then
            isPlayerBeDamagingTimer.destroy()
            hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        end
        hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING, true)
        hcache.set(
            targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER,
            htime.setTimeout(3.5, function(t)
                t.destroy()
                hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
                hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING, false)
            end)
        )
        -- 设置单位|玩家正在造成伤害
        if (options.sourceUnit ~= nil and hunit.isDestroyed(options.sourceUnit) == false) then
            local isDamagingTimer = hcache.get(options.sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            if (isDamagingTimer ~= nil) then
                isDamagingTimer.destroy()
                hcache.set(options.sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            end
            hcache.set(options.sourceUnit, CONST_CACHE.ATTR_DAMAGING, true)
            hevent.setLastDamage(options.sourceUnit, options.targetUnit)
            hcache.set(
                options.sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER,
                htime.setTimeout(3.5, function(t)
                    t.destroy()
                    hcache.set(options.sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
                    hcache.set(options.sourceUnit, CONST_CACHE.ATTR_DAMAGING, false)
                    hevent.setLastDamage(options.sourceUnit, nil)
                end)
            )
            local sourcePlayer = hunit.getOwner(options.sourceUnit)
            hplayer.addDamage(sourcePlayer, options.damage)
            local isPlayerDamagingTimer = hcache.get(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            if (isPlayerDamagingTimer ~= nil) then
                isPlayerDamagingTimer.destroy()
                hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            end
            hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING, true)
            hcache.set(
                sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER,
                htime.setTimeout(3.5, function(t)
                    t.destroy()
                    hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
                    hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING, false)
                end)
            )
        end
        -- 扣血
        hunit.subCurLife(options.targetUnit, options.damage)
        if (type(options.effect) == "string") then
            heffect.xyz(options.effect, hunit.x(options.targetUnit), hunit.y(options.targetUnit), hunit.z(options.targetUnit), 0)
        end
        -- @触发伤害事件
        if (options.sourceUnit ~= nil) then
            hevent.trigger(options.sourceUnit, CONST_EVENT.damage, {
                triggerUnit = options.sourceUnit,
                targetUnit = options.targetUnit,
                damage = options.damage,
                damageSrc = options.damageSrc,
            })
        end
        -- @触发被伤害事件
        hevent.trigger(options.targetUnit, CONST_EVENT.beDamage, {
            triggerUnit = options.targetUnit,
            sourceUnit = options.sourceUnit,
            damage = options.damage,
            damageSrc = options.damageSrc,
        })
        if (options.damageSrc == CONST_DAMAGE_SRC.attack) then
            if (options.sourceUnit ~= nil) then
                -- @触发攻击事件
                hevent.trigger(options.sourceUnit, CONST_EVENT.attack, {
                    triggerUnit = options.sourceUnit,
                    targetUnit = options.targetUnit,
                    damage = options.damage,
                })
            end
            -- @触发被攻击事件
            hevent.trigger(options.targetUnit, CONST_EVENT.beAttack, {
                triggerUnit = options.targetUnit,
                attackUnit = options.sourceUnit,
                damage = options.damage,
            })
        end
    end
end

--- 无敌
---@param whichUnit userdata
---@param during number
---@param effect string
---@param attach string
---@return void
function hskill.invulnerable(whichUnit, during, effect, attach)
    if (whichUnit == nil) then
        return
    end
    if (during < 0) then
        during = 0.00 -- 如果设置持续时间错误，则0秒无敌
    end
    cj.UnitAddAbility(whichUnit, HL_ID.ability_invulnerable)
    if (during > 0 and effect ~= nil) then
        attach = attach or "origin"
        heffect.attach(effect, whichUnit, attach, during)
    end
    htime.setTimeout(during, function(t)
        t.destroy()
        cj.UnitRemoveAbility(whichUnit, HL_ID.ability_invulnerable)
    end)
end