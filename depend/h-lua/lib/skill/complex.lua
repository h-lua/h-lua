--[[
    暴击
    options = {
        targetUnit = unit, --目标单位，必须
        odds = 0, --几率，必须
        damage = 0, --原始伤害，必须
        percent = 0, --暴击比例，必须
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE.common} --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
    }
]]
hskill.knocking = function(options)
    local odds = options.odds or 0
    local damage = options.damage or 0
    local percent = options.percent or 0
    if (odds <= 0 or damage <= 0 or percent <= 0) then
        print_err("knocking: -odds -damage -percent")
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local targetUnit = options.targetUnit
    local targetOppose = hattribute.get(targetUnit, "knocking_oppose")
    odds = odds - targetOppose
    if (odds <= 0) then
        return
    end
    if (math.random(1, 100) <= odds) then
        local effect = options.effect or "war3mapImported\\eff_crit.mdl"
        heffect.toUnit(effect, targetUnit, 0.5)
        --暴！
        local val = damage * percent * 0.01
        hskill.damage({
            sourceUnit = options.sourceUnit,
            targetUnit = targetUnit,
            damage = val,
            damageString = "暴击",
            damageStringColor = "ff0000",
            damageSrc = options.damageSrc,
            damageType = options.damageType,
            isFixed = options.isFixed,
        })
        --@触发暴击事件
        hevent.triggerEvent(options.sourceUnit, CONST_EVENT.knocking, {
            triggerUnit = options.sourceUnit,
            targetUnit = targetUnit,
            damage = val,
            odds = odds,
            percent = percent
        })
        --@触发被物暴击事件
        hevent.triggerEvent(targetUnit, CONST_EVENT.beKnocking, {
            triggerUnit = options.sourceUnit,
            sourceUnit = targetUnit,
            damage = val,
            odds = odds,
            percent = percent
        })
    end
end

--[[
    分裂
    options = {
        targetUnit = unit, --目标单位，必须
        sourceUnit = nil, --来源单位，可选
        odds = 100, --几率，必须
        damage = 0, --原始伤害，必须
        percent = 0, --几率比例，必须
        radius = 0, --分裂半径范围，必须
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC.skill --伤害的种类（可选）
        damageType = {} --伤害的类型,注意是table（可选）
    }
]]
hskill.split = function(options)
    local odds = options.odds or 0
    local damage = options.damage or 0
    local percent = options.percent or 0
    local radius = options.radius or 0
    if (odds <= 0 or damage <= 0 or percent <= 0 or radius <= 0) then
        print_err("split: -odds -damage -percent -radius")
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local targetUnit = options.targetUnit
    local targetOppose = hattribute.get(targetUnit, "split_oppose")
    odds = odds - targetOppose
    if (odds <= 0) then
        return
    end
    if (math.random(1, 100) <= odds) then
        local g = hgroup.createByUnit(targetUnit, radius, function(filterUnit)
            local flag = true
            if (his.dead(filterUnit)) then
                flag = false
            end
            if (his.enemy(filterUnit, targetUnit)) then
                flag = false
            end
            if (his.structure(filterUnit)) then
                flag = false
            end
            if (his.unit(filterUnit, targetUnit)) then
                flag = false
            end
            return flag
        end)
        local splitDamage = damage * percent * 0.01
        hgroup.forEach(g, function(eu)
            hskill.damage({
                sourceUnit = options.sourceUnit,
                targetUnit = eu,
                damage = splitDamage,
                damageString = "分裂",
                damageStringColor = "ffdead",
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
                effect = options.effect
            })
        end)
        g = nil
        -- @触发分裂事件
        if (options.sourceUnit) then
            hevent.triggerEvent(
                options.sourceUnit,
                CONST_EVENT.split,
                {
                    triggerUnit = options.sourceUnit,
                    targetUnit = targetUnit,
                    damage = splitDamage,
                    radius = radius,
                    percent = percent
                }
            )
        end
        -- @触发被分裂事件
        hevent.triggerEvent(
            targetUnit,
            CONST_EVENT.beSplit,
            {
                triggerUnit = targetUnit,
                sourceUnit = options.sourceUnit,
                damage = splitDamage,
                radius = radius,
                percent = percent
            }
        )
    end
end

--[[
    打断
    options = {
        targetUnit = unit, --目标单位，必须
        odds = 100, --几率，可选
        damage = 0, --伤害，可选
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC.skill --伤害的种类（可选）
        damageType = {} --伤害的类型,注意是table（可选）
    }
]]
hskill.broken = function(options)
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local u = options.targetUnit
    local odds = options.odds or 100
    local damage = options.damage or 0
    local sourceUnit = options.sourceUnit or nil
    --计算抵抗
    local oppose = hattribute.get(u, "broken_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        damage = damage * (1 - oppose * 0.01)
    end
    local cu = hunit.create({
        register = false,
        id = HL_ID.unit_token,
        whichPlayer = hplayer.player_passive,
        x = hunit.x(u),
        y = hunit.y(u)
    })
    cj.UnitAddAbility(cu, HL_ID.ability_break[0.05])
    cj.SetUnitAbilityLevel(cu, HL_ID.ability_break[0.05], 1)
    cj.IssueTargetOrder(cu, "thunderbolt", u)
    hunit.del(cu, 0.3)
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.toUnit(options.effect, u, 0)
    end
    if (damage > 0) then
        hskill.damage(
            {
                sourceUnit = sourceUnit,
                targetUnit = u,
                damage = damage,
                damageString = "打断",
                damageStringColor = "F0F8FF",
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
            }
        )
    end
    -- @触发打断事件
    hevent.triggerEvent(
        sourceUnit,
        CONST_EVENT.broken,
        {
            triggerUnit = sourceUnit,
            targetUnit = u,
            odds = odds,
            damage = damage
        }
    )
    -- @触发被打断事件
    hevent.triggerEvent(
        u,
        CONST_EVENT.beBroken,
        {
            triggerUnit = u,
            sourceUnit = sourceUnit,
            odds = odds,
            damage = damage
        }
    )
end

--[[
    眩晕! 注意这个方法对中立被动无效
    options = {
        targetUnit = unit, --目标单位，必须
        during = 0, --持续时间，必须
        odds = 100, --几率，可选
        damage = 0, --伤害，可选
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.swim = function(options)
    if (options.during == nil or options.during <= 0) then
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local u = options.targetUnit
    local during = options.during
    local odds = options.odds or 100
    local damage = options.damage or 0
    local sourceUnit = options.sourceUnit
    --计算抵抗
    local oppose = hattribute.get(u, "swim_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        during = during * (1 - oppose * 0.01)
        damage = damage * (1 - oppose * 0.01)
    end
    local damageString = "眩晕"
    local damageStringColor = "4169E1"
    local swimTimer = hcache.get(u, CONST_CACHE.SKILL_SWIM_TIMER)
    if (swimTimer ~= nil and htime.getRemainTime(swimTimer) > 0) then
        if (during <= htime.getRemainTime(swimTimer)) then
            return
        else
            htime.delTimer(swimTimer)
            hcache.set(u, CONST_CACHE.SKILL_SWIM_TIMER, nil)
            cj.UnitRemoveAbility(u, HL_ID.buff_swim)
            damageString = "劲眩"
            damageStringColor = "64e3f2"
        end
    end
    local cu = hunit.create({
        register = false,
        id = HL_ID.unit_token,
        whichPlayer = hplayer.player_passive,
        x = hunit.x(u),
        y = hunit.y(u)
    })
    --判断during的时候是否小于0.5秒，使用眩晕0.05-0.5的技能，大于0.5使用无限眩晕法
    if (during < 0.05) then
        during = 0.05
    end
    hcache.set(u, CONST_CACHE.SKILL_SWIM, true)
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.bindUnit(options.effect, u, "origin", during)
    end
    if (during <= 0.5) then
        during = 0.05 * math.floor(during / 0.05) --必须是0.05的倍数
        cj.UnitAddAbility(cu, HL_ID.ability_break[during])
        cj.SetUnitAbilityLevel(cu, HL_ID.ability_break[during], 1)
        cj.IssueTargetOrder(cu, "thunderbolt", u)
        hunit.del(cu, 0.4)
    else
        --无限法
        cj.UnitAddAbility(cu, HL_ID.ability_swim_un_limit)
        cj.SetUnitAbilityLevel(cu, HL_ID.ability_swim_un_limit, 1)
        cj.IssueTargetOrder(cu, "thunderbolt", u)
        hunit.del(cu, 0.4)
        hcache.set(
            u, CONST_CACHE.SKILL_SWIM_TIMER,
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                cj.UnitRemoveAbility(u, HL_ID.buff_swim)
                hcache.set(u, CONST_CACHE.SKILL_SWIM, false)
            end)
        )
    end
    -- @触发眩晕事件
    hevent.triggerEvent(
        sourceUnit,
        CONST_EVENT.swim,
        {
            triggerUnit = sourceUnit,
            targetUnit = u,
            odds = odds,
            damage = damage,
            during = during
        }
    )
    -- @触发被眩晕事件
    hevent.triggerEvent(
        u,
        CONST_EVENT.beSwim,
        {
            triggerUnit = u,
            sourceUnit = sourceUnit,
            odds = odds,
            damage = damage,
            during = during
        }
    )
    if (damage > 0) then
        hskill.damage(
            {
                sourceUnit = sourceUnit,
                targetUnit = u,
                damage = damage,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
                damageString = damageString,
                damageStringColor = damageStringColor
            }
        )
    end
end

--[[
    沉默
    options = {
        targetUnit = unit, --目标单位，必须
        during = 0, --持续时间，必须
        odds = 100, --几率，可选
        damage = 0, --伤害，可选
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.silent = function(options)
    if (options.during == nil or options.during <= 0) then
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local u = options.targetUnit
    local during = options.during
    local odds = options.odds or 100
    local damage = options.damage or 0
    local sourceUnit = options.sourceUnit
    --计算抵抗
    local oppose = hattribute.get(u, "silent_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        during = during * (1 - oppose * 0.01)
        damage = damage * (1 - oppose * 0.01)
    end
    local level = hcache.get(u, CONST_CACHE.SKILL_SILENT_LEVEL, 0) + 1
    if (level <= 1) then
        htextTag.style(htextTag.create2Unit(u, "沉默", 6.00, "ee82ee", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        htextTag.style(
            htextTag.create2Unit(u, math.floor(level) .. "重沉默", 6.00, "ee82ee", 10, 1.00, 10.00),
            "scale",
            0,
            0.2
        )
    end
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.bindUnit(options.effect, u, "origin", during)
    end
    hcache.set(u, CONST_CACHE.SKILL_SILENT_LEVEL, level)
    if (true == hcache.get(u, CONST_CACHE.SKILL_SILENT, false)) then
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "head", -1)
        hcache.set(u, CONST_CACHE.SKILL_SILENT_EFFECT, eff)
    end
    hcache.set(u, CONST_CACHE.SKILL_SILENT, true)
    if (damage > 0) then
        hskill.damage(
            {
                sourceUnit = sourceUnit,
                targetUnit = u,
                damage = damage,
                damageString = "沉默",
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
            }
        )
    end
    -- @触发沉默事件
    hevent.triggerEvent(
        sourceUnit,
        CONST_EVENT.silent,
        {
            triggerUnit = sourceUnit,
            targetUnit = u,
            odds = odds,
            damage = damage,
            during = during
        }
    )
    -- @触发被沉默事件
    hevent.triggerEvent(
        u,
        CONST_EVENT.beSilent,
        {
            triggerUnit = u,
            sourceUnit = sourceUnit,
            odds = odds,
            damage = damage,
            during = during
        }
    )
    htime.setTimeout(during, function(t)
        htime.delTimer(t)
        hcache.set(u, CONST_CACHE.SKILL_SILENT_LEVEL, hcache.get(u, CONST_CACHE.SKILL_SILENT_LEVEL, 0) - 1)
        if (hcache.get(u, CONST_CACHE.SKILL_SILENT_LEVEL, 0) <= 0) then
            heffect.del(hcache.get(u, CONST_CACHE.SKILL_SILENT_EFFECT))
            hcache.set(u, CONST_CACHE.SKILL_SILENT, false)
        end
    end)
end

--[[
    缴械
    options = {
        targetUnit = unit, --目标单位，必须
        during = 0, --持续时间，必须
        odds = 100, --几率，可选
        damage = 0, --伤害，可选
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.unarm = function(options)
    if (options.during == nil or options.during <= 0) then
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local u = options.targetUnit
    local during = options.during
    local odds = options.odds or 100
    local damage = options.damage or 0
    local sourceUnit = options.sourceUnit
    --计算抵抗
    local oppose = hattribute.get(u, "unarm_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        during = during * (1 - oppose * 0.01)
        damage = damage * (1 - oppose * 0.01)
    end
    local level = hcache.get(u, CONST_CACHE.SKILL_UN_ARM_LEVEL, 0) + 1
    if (level <= 1) then
        htextTag.style(htextTag.create2Unit(u, "缴械", 6.00, "ffe4e1", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        htextTag.style(
            htextTag.create2Unit(u, math.floor(level) .. "重缴械", 6.00, "ffe4e1", 10, 1.00, 10.00),
            "scale",
            0,
            0.2
        )
    end
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.bindUnit(options.effect, u, "origin", during)
    end
    hcache.set(u, CONST_CACHE.SKILL_UN_ARM_LEVEL, level)
    if (true == hcache.get(u, CONST_CACHE.SKILL_UN_ARM, false)) then
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "weapon", -1)
        hcache.set(u, CONST_CACHE.SKILL_UN_ARM_EFFECT, eff)
    end
    hcache.set(u, CONST_CACHE.SKILL_UN_ARM, true)
    if (damage > 0) then
        hskill.damage({
            sourceUnit = sourceUnit,
            targetUnit = u,
            damage = damage,
            damageString = "缴械",
            damageSrc = options.damageSrc,
            damageType = options.damageType,
            isFixed = options.isFixed,
        })
    end
    -- @触发缴械事件
    hevent.triggerEvent(sourceUnit, CONST_EVENT.unarm, {
        triggerUnit = sourceUnit,
        targetUnit = u,
        odds = odds,
        damage = damage,
        during = during
    })
    -- @触发被缴械事件
    hevent.triggerEvent(u, CONST_EVENT.beUnarm, {
        triggerUnit = u,
        sourceUnit = sourceUnit,
        odds = odds,
        damage = damage,
        during = during
    })
    htime.setTimeout(during, function(t)
        htime.delTimer(t)
        hcache.set(u, CONST_CACHE.SKILL_UN_ARM_LEVEL, hcache.get(u, CONST_CACHE.SKILL_UN_ARM_LEVEL, 0) - 1)
        if (hcache.get(u, CONST_CACHE.SKILL_UN_ARM_LEVEL, 0) <= 0) then
            heffect.del(hcache.get(u, CONST_CACHE.SKILL_UN_ARM_EFFECT))
            hcache.set(u, CONST_CACHE.SKILL_UN_ARM, false)
        end
    end)
end

--[[
    定身
    options = {
        targetUnit = unit, --目标单位，必须
        during = 0, --持续时间，必须
        odds = 100, --几率，可选
        damage = 0, --伤害，可选
        sourceUnit = nil, --来源单位，可选
        effect = nil, --特效，可选
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.fetter = function(options)
    if (options.during == nil or options.during <= 0) then
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local u = options.targetUnit
    local during = options.during
    local odds = options.odds or 100
    local damage = options.damage or 0
    local sourceUnit = options.sourceUnit or nil
    --计算抵抗
    local oppose = hattribute.get(u, "fetter_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        during = during * (1 - oppose * 0.01)
        damage = damage * (1 - oppose * 0.01)
    end
    htextTag.style(htextTag.create2Unit(u, "定身", 6.00, "ffa500", 10, 1.00, 10.00), "scale", 0, 0.2)
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.bindUnit(options.effect, u, "origin", during)
    end
    hattribute.set(u, during, { move = "-522" })
    if (damage > 0) then
        hskill.damage(
            {
                sourceUnit = sourceUnit,
                targetUnit = u,
                damage = damage,
                damageString = "定身",
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
            }
        )
    end
    -- @触发定身事件
    hevent.triggerEvent(
        sourceUnit,
        CONST_EVENT.fetter,
        {
            triggerUnit = sourceUnit,
            targetUnit = u,
            odds = odds,
            damage = damage,
            during = during
        }
    )
    -- @触发被定身事件
    hevent.triggerEvent(
        u,
        CONST_EVENT.beFetter,
        {
            triggerUnit = u,
            sourceUnit = sourceUnit,
            odds = odds,
            damage = damage,
            during = during
        }
    )
end

--[[
    爆破
    options = {
        damage = 0, --伤害（必须有，小于等于0直接无效）
        radius = 1, --半径范围（可选）
        targetUnit = nil, --目标单位（挑选，单位时会自动选择与此单位同盟的单位）
        whichGroup = nil, --目标单位组（挑选，优先级更高）
        sourceUnit = nil, --伤害来源单位（可选）
        odds = 100, --几率（可选）
        effect = nil --目标位置特效（可选）
        effectEnum = nil --选取个体的特效（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.bomb = function(options)
    if (options.damage == nil or options.damage <= 0) then
        return
    end
    local odds = options.odds or 100
    local radius = options.radius or 1
    local whichGroup
    if (options.whichGroup ~= nil) then
        whichGroup = options.whichGroup
    elseif (options.targetUnit ~= nil) then
        if (his.deleted(options.targetUnit)) then
            return
        end
        whichGroup = hgroup.createByUnit(
            options.targetUnit,
            radius,
            function(filterUnit)
                local flag = true
                if (his.enemy(options.targetUnit, filterUnit)) then
                    flag = false
                end
                if (his.dead(filterUnit)) then
                    flag = false
                end
                if (his.structure(filterUnit)) then
                    flag = false
                end
                return flag
            end
        )
    else
        print_err("lost bomb target")
        return
    end
    hgroup.forEach(whichGroup, function(eu)
        --计算抵抗
        local oppose = hattribute.get(eu, "bomb_oppose")
        local tempOdds = odds - oppose --(%)
        local damage = options.damage
        if (tempOdds <= 0) then
            return
        else
            if (math.random(1, 1000) > tempOdds * 10) then
                return
            end
            damage = damage * (1 - oppose * 0.01)
        end
        hskill.damage(
            {
                sourceUnit = options.sourceUnit,
                targetUnit = eu,
                damage = damage,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
                damageString = "爆破",
                damageStringColor = "FF6347",
                effect = options.effectEnum,
            }
        )
        -- @触发爆破事件
        hevent.triggerEvent(
            options.sourceUnit,
            CONST_EVENT.bomb,
            {
                triggerUnit = options.sourceUnit,
                targetUnit = eu,
                odds = odds,
                damage = options.damage,
                radius = radius
            }
        )
        -- @触发被爆破事件
        hevent.triggerEvent(
            eu,
            CONST_EVENT.beBomb,
            {
                triggerUnit = eu,
                sourceUnit = options.sourceUnit,
                odds = odds,
                damage = options.damage,
                radius = radius
            }
        )
    end)
    whichGroup = nil
end

--[[
    闪电链
    options = {
        damage = 0, --伤害（必须有，小于等于0直接无效）
        targetUnit = [unit], --第一个的目标单位（必须有）
        prevUnit = [unit], --上一个的目标单位（必须有，用于构建两点间闪电特效）
        sourceUnit = nil, --伤害来源单位（可选）
        lightningType = [hlightning.type], -- 闪电效果类型（可选 详情查看 hlightning.type
        odds = 100, --几率（可选）
        qty = 1, --传递的最大单位数（可选，默认1）
        rate = 0, --增减率（可选，默认不增不减为0，范围建议[-1.00，1.00]）
        radius = 300, --寻找下一目标的作用半径范围（可选，默认300）
        isRepeat = false, --是否允许同一个单位重复打击（临近2次不会同一个）
        effect = nil, --目标位置特效（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
        index = 1,--隐藏的参数，用于暗地里记录是第几个被电到的单位
        repeatGroup = [group],--隐藏的参数，用于暗地里记录单位是否被电过
    }
]]
hskill.lightningChain = function(options)
    if (options.damage == nil or options.damage <= 0) then
        print_err("lightningChain -damage")
        return
    end
    if (options.targetUnit == nil) then
        print_err("lightningChain -targetUnit")
        return
    end
    if (his.deleted(options.targetUnit)) then
        return
    end
    local odds = options.odds or 100
    local damage = options.damage
    --计算抵抗
    local oppose = hattribute.get(options.targetUnit, "lightning_chain_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        damage = damage * (1 - oppose * 0.01)
    end
    local targetUnit = options.targetUnit
    local prevUnit = options.prevUnit
    local lightningType = options.lightningType or hlightning.type.shan_dian_lian_ci
    local rate = options.rate or 0
    local radius = options.radius or 500
    local isRepeat = options.isRepeat or false
    options.qty = options.qty or 1
    options.qty = options.qty - 1
    if (options.qty < 0) then
        options.qty = 0
    end
    if (options.index == nil) then
        options.index = 1
    else
        options.index = options.index + 1
    end
    hlightning.unit2unit(lightningType, prevUnit, targetUnit, 0.25)
    if (options.effect ~= nil) then
        heffect.bindUnit(options.effect, targetUnit, "origin", 0.5)
    end
    hskill.damage(
        {
            sourceUnit = options.sourceUnit,
            targetUnit = targetUnit,
            damage = damage,
            damageSrc = options.damageSrc,
            damageType = options.damageType,
            isFixed = options.isFixed,
            damageString = "电链",
            damageStringColor = "87cefa"
        }
    )
    -- @触发闪电链成功事件
    hevent.triggerEvent(
        options.sourceUnit,
        CONST_EVENT.lightningChain,
        {
            triggerUnit = options.sourceUnit,
            targetUnit = targetUnit,
            odds = odds,
            damage = damage,
            radius = radius,
            index = options.index
        }
    )
    -- @触发被闪电链事件
    hevent.triggerEvent(
        targetUnit,
        CONST_EVENT.beLightningChain,
        {
            triggerUnit = targetUnit,
            sourceUnit = options.sourceUnit,
            odds = odds,
            damage = damage,
            radius = radius,
            index = options.index
        }
    )
    if (options.qty > 0) then
        if (isRepeat ~= true) then
            if (options.repeatGroup == nil) then
                options.repeatGroup = {}
            end
            hgroup.addUnit(options.repeatGroup, targetUnit)
        end
        local g = hgroup.createByUnit(
            targetUnit,
            radius,
            function(filterUnit)
                local flag = true
                if (his.dead(filterUnit)) then
                    flag = false
                end
                if (his.enemy(filterUnit, targetUnit)) then
                    flag = false
                end
                if (his.structure(filterUnit)) then
                    flag = false
                end
                if (his.unit(targetUnit, filterUnit)) then
                    flag = false
                end
                if (isRepeat ~= true and hgroup.includes(options.repeatGroup, filterUnit)) then
                    flag = false
                end
                return flag
            end
        )
        if (hgroup.isEmpty(g)) then
            return
        end
        options.targetUnit = hgroup.getClosest(g, hunit.x(targetUnit), hunit.y(targetUnit))
        options.damage = options.damage * (1 + rate)
        options.prevUnit = targetUnit
        options.odds = 9999 --闪电链只要开始能延续下去就是100%几率了
        hgroup.clear(g, true, false)
        if (options.damage > 0) then
            htime.setTimeout(0.35, function(t)
                htime.delTimer(t)
                hskill.lightningChain(options)
            end)
        end
    else
        if (options.repeatGroup ~= nil) then
            options.repeatGroup = nil
        end
    end
end

--[[
    击飞
    options = {
        damage = 0, --伤害（必须有，但是这里可以等于0）
        targetUnit = [unit], --目标单位（必须有）
        sourceUnit = [unit], --伤害来源单位（可选）
        odds = 100, --几率（可选,默认100）
        distance = 0, --击退距离，可选，默认0
        height = 100, --击飞高度，可选，默认100
        during = 0.5, --击飞过程持续时间，可选，默认0.5秒
        effect = nil, --特效（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.crackFly = function(options)
    if (options.damage == nil or options.damage < 0) then
        return
    end
    if (options.targetUnit == nil or his.deleted(options.targetUnit)) then
        return
    end
    local odds = options.odds or 100
    local damage = options.damage or 0
    --计算抵抗
    local oppose = hattribute.get(options.targetUnit, "crack_fly_oppose")
    odds = odds - oppose --(%)
    if (odds <= 0) then
        return
    else
        if (math.random(1, 1000) > odds * 10) then
            return
        end
        if (damage > 0) then
            damage = damage * (1 - oppose * 0.01)
        end
    end
    local distance = options.distance or 0
    local height = options.height or 100
    local during = options.during or 0.5
    if (during < 0.5) then
        during = 0.5
    end
    --不二次击飞
    if (hcache.get(options.targetUnit, CONST_CACHE.SKILL_CRACK_FLY, false) == true) then
        return
    end
    hcache.set(options.targetUnit, CONST_CACHE.SKILL_CRACK_FLY, true)
    local tempObj = {
        odds = 99999,
        targetUnit = options.targetUnit,
        during = during
    }
    hskill.unarm(tempObj)
    hskill.silent(tempObj)
    hattribute.set(options.targetUnit, during, { move = "-9999" })
    if (type(options.effect) == "string" and string.len(options.effect) > 0) then
        heffect.bindUnit(options.effect, options.targetUnit, "origin", during)
    end
    hunit.setCanFly(options.targetUnit)
    cj.SetUnitPathing(options.targetUnit, false)
    local originHigh = cj.GetUnitFlyHeight(options.targetUnit)
    local originFacing = hunit.getFacing(options.targetUnit)
    local originDeg
    if (options.sourceUnit ~= nil) then
        originDeg = math.getDegBetweenUnit(options.sourceUnit, options.targetUnit)
    else
        originDeg = math.random(0, 360)
    end
    local cost = 0
    -- @触发击飞事件
    hevent.triggerEvent(
        options.sourceUnit,
        CONST_EVENT.crackFly,
        {
            triggerUnit = options.sourceUnit,
            targetUnit = options.targetUnit,
            odds = odds,
            damage = damage,
            height = height,
            distance = distance
        }
    )
    -- @触发被击飞事件
    hevent.triggerEvent(
        options.targetUnit,
        CONST_EVENT.beCrackFly,
        {
            triggerUnit = options.targetUnit,
            sourceUnit = options.sourceUnit,
            odds = odds,
            damage = damage,
            height = height,
            distance = distance
        }
    )
    htime.setInterval(0.05, function(t)
        local dist = 0
        local z = 0
        local timerSetTime = htime.getSetTime(t)
        if (cost > during) then
            if (damage > 0) then
                hskill.damage(
                    {
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        effect = options.effect,
                        damage = damage,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                        damageString = "击飞",
                        damageStringColor = "808000"
                    }
                )
            end
            cj.SetUnitFlyHeight(options.targetUnit, originHigh, 10000)
            cj.SetUnitPathing(options.targetUnit, true)
            hcache.set(options.targetUnit, CONST_CACHE.SKILL_CRACK_FLY, false)
            -- 默认是地面，创建沙尘
            local tempEff = "Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl"
            if (his.water(options.targetUnit) == true) then
                -- 如果是水面，创建水花
                tempEff = "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl"
            end
            heffect.toUnit(tempEff, options.targetUnit, 0)
            htime.delTimer(t)
            return
        end
        cost = cost + timerSetTime
        if (cost < during * 0.35) then
            dist = distance / (during * 0.5 / timerSetTime)
            z = height / (during * 0.35 / timerSetTime)
            if (dist > 0) then
                local pxy = math.polarProjection(
                    hunit.x(options.targetUnit),
                    hunit.y(options.targetUnit),
                    dist,
                    originDeg
                )
                cj.SetUnitFacing(options.targetUnit, originFacing)
                if (his.borderMap(pxy.x, pxy.y) == false) then
                    hunit.portal(options.targetUnit, pxy.x, pxy.y)
                end
            end
            if (z > 0) then
                cj.SetUnitFlyHeight(options.targetUnit, cj.GetUnitFlyHeight(options.targetUnit) + z, z / timerSetTime)
            end
        else
            dist = distance / (during * 0.5 / timerSetTime)
            z = height / (during * 0.65 / timerSetTime)
            if (dist > 0) then
                local pxy = math.polarProjection(
                    hunit.x(options.targetUnit),
                    hunit.y(options.targetUnit),
                    dist,
                    originDeg
                )
                cj.SetUnitFacing(options.targetUnit, originFacing)
                if (his.borderMap(pxy.x, pxy.y) == false) then
                    hunit.portal(options.targetUnit, pxy.x, pxy.y)
                end
            end
            if (z > 0) then
                cj.SetUnitFlyHeight(options.targetUnit, cj.GetUnitFlyHeight(options.targetUnit) - z, z / timerSetTime)
            end
        end
    end)
end

--[[
    范围眩晕
    options = {
        radius = 0, --眩晕半径范围（必须有）
        during = 0, --眩晕持续时间（必须有）
        odds = 100, --对每个单位的独立几率（可选,默认100）
        effect = "", --特效（可选）
        targetUnit = [unit], --中心单位（可选）
        whichLoc = [location], --目标点（可选）
        x = [point], --目标坐标X（可选）
        y = [point], --目标坐标Y（可选）
        filter = [function], --必须有
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.rangeSwim = function(options)
    local radius = options.radius or 0
    local during = options.during or 0
    local damage = options.damage or 0
    if (radius <= 0 or during <= 0) then
        print_err("hskill.rangeSwim:-radius -during")
        return
    end
    local odds = options.odds or 100
    local effect = options.effect or "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    local x, y
    if (options.x ~= nil or options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.targetUnit ~= nil) then
        if (his.deleted(options.targetUnit)) then
            return
        end
        x = hunit.x(options.targetUnit)
        y = hunit.y(options.targetUnit)
    elseif (options.whichLoc ~= nil) then
        x = cj.GetLocatonX(options.whichLoc)
        y = cj.GetLocatonY(options.whichLoc)
    end
    if (x == nil or y == nil) then
        print_err("hskill.rangeSwim:-x -y")
        return
    end
    local filter = options.filter
    if (type(filter) ~= "function") then
        print_err("filter must be function")
        return
    end
    heffect.toXY(effect, x, y, 0)
    local g = hgroup.createByXY(x, y, radius, filter)
    if (g == nil) then
        print_err("rangeSwim has not target")
        return
    end
    if (hgroup.count(g) <= 0) then
        return
    end
    hgroup.forEach(g, function(eu)
        hskill.swim(
            {
                odds = odds,
                targetUnit = eu,
                during = during,
                damage = damage,
                sourceUnit = options.sourceUnit,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
            }
        )
    end)
    g = nil
end

--[[
    剑刃风暴
    options = {
        radius = 0, --半径范围（必须有）
        frequency = 0, --伤害频率（必须有）
        during = 0, --持续时间（必须有）
        filter = [function], --必须有
        damage = 0, --每次伤害（必须有）
        sourceUnit = [unit], --伤害来源单位（必须有）
        effect = "", --特效（可选）
        effectEnum = "", --单体砍中特效（可选）
        animation = "spin", --单位附加动作，常见的spin（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
    }
]]
hskill.whirlwind = function(options)
    local radius = options.radius or 0
    local frequency = options.frequency or 0
    local during = options.during or 0
    local damage = options.damage or 0
    if (radius <= 0 or during <= 0 or frequency <= 0) then
        print_err("hskill.whirlwind:-radius -during -frequency")
        return
    end
    if (during < frequency) then
        print_err("hskill.whirlwind:-during < frequency")
        return
    end
    if (damage < 0 or options.sourceUnit == nil) then
        print_err("hskill.whirlwind:-damage -sourceUnit")
        return
    end
    if (options.filter == nil) then
        print_err("hskill.whirlwind:-filter")
        return
    end
    local filter = options.filter
    if (type(filter) ~= "function") then
        print_err("filter must be function")
        return
    end
    --不二次
    if (hcache.get(options.sourceUnit, CONST_CACHE.SKILL_WHIRLWIND, false) == true) then
        return
    end
    hcache.set(options.sourceUnit, CONST_CACHE.SKILL_WHIRLWIND, true)
    if (options.effect ~= nil) then
        heffect.bindUnit(options.effect, options.sourceUnit, "origin", during)
    end
    if (options.animation) then
        cj.AddUnitAnimationProperties(options.sourceUnit, options.animation, true)
    end
    local time = 0
    htime.setInterval(frequency, function(t)
        time = time + frequency
        if (time > during) then
            htime.delTimer(t)
            if (options.animation) then
                cj.AddUnitAnimationProperties(options.sourceUnit, options.animation, false)
            end
            hcache.set(options.sourceUnit, CONST_CACHE.SKILL_WHIRLWIND, false)
            return
        end
        if (options.animation) then
            hunit.animate(options.sourceUnit, options.animation)
        end
        local g = hgroup.createByUnit(options.sourceUnit, radius, filter)
        if (g == nil) then
            return
        end
        if (hgroup.count(g) <= 0) then
            return
        end
        hgroup.forEach(g, function(eu)
            hskill.damage(
                {
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    effect = options.effectEnum,
                    damage = damage,
                    damageSrc = options.damageSrc,
                    damageType = options.damageType,
                    isFixed = options.isFixed,
                }
            )
        end)
        g = nil
    end)
end

--[[
    剃(前冲型直线攻击)
    options = {
        arrowUnit = nil, -- 前冲的单位（有就是自身冲击，没有就是马甲特效冲击）
        sourceUnit, --伤害来源（必须有！不管有没有伤害）
        targetUnit, --冲击的目标单位（可选的，有单位目标，那么冲击到单位就结束）
        x, --冲击的x坐标（可选的，对点冲击，与某目标无关）
        y, --冲击的y坐标（可选的，对点冲击，与某目标无关）
        speed = 10, --冲击的速度（可选的，默认10，0.02秒的移动距离,大概1秒500px)
        acceleration = 0, --冲击加速度（可选的，每个周期都会增加0.02秒一次)
        height = 0, --飞跃高度（可选的，默认0)
        shake = 0, --摇摆振幅角度[-90~+90|random]（可选的，默认0)
        filter = [function], --必须有
        tokenX, --强制设定token初始创建的x坐标（可选的，同时设定tokenY时才有效）
        tokenY, --强制设定token初始创建的y坐标（可选的，同时设定tokenX时才有效）
        tokenArrow = nil, --前冲的特效（arrowUnit=nil时认为必须！自身冲击就是bind，否则为马甲本身，如冲击波的波）
        tokenArrowScale = 1.00, --前冲的特效作为马甲冲击时的模型缩放
        tokenArrowOpacity = 1.00, --前冲的特效作为马甲冲击时的模型透明度[0-1]
        tokenArrowHeight = 0.00, --前冲的特效作为马甲冲击时的初始离地高度
        effectMovement = nil, --移动过程，每个间距的特效（可选的，采用的0秒删除法，请使用explode类型的特效）
        effectEnd = nil, --到达最后位置时的特效（可选的，采用的0秒删除法，请使用explode类型的特效）
        damageMovement = 0, --移动过程中的伤害（可选的，默认为0）
        damageMovementRadius = 0, --移动过程中的伤害（可选的，默认为0，易知0范围是无效的所以有伤害也无法体现）
        damageMovementRepeat = false, --移动过程中伤害是否可以重复造成（可选的，默认为不能）
        damageMovementDrag = false, --移动过程是否拖拽敌人（可选的，默认为不能）
        damageEnd = 0, --移动结束时对目标的伤害（可选的，默认为0）
        damageEndRadius = 0, --移动结束时对目标的伤害范围（可选的，默认为0，此处0范围是有效的，会只对targetUnit生效，除非unit不存在）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
        damageEffect = nil, --伤害特效（可选）
        oneHitOnly = false, --是否打击一次就立刻失效（类似格挡，这个一次和只攻击一个单位不是一回事）
        onEnding = [function], --结束时触发的动作
        extraInfluence = [function] --对选中的敌人的额外影响，会回调该敌人单位，可以对其做出自定义行为
    }
]]
hskill.leap = function(options)
    if (options.sourceUnit == nil) then
        print_err("leap: -sourceUnit")
        return
    end
    if (type(options.filter) ~= "function") then
        print_err("leap: -filter")
        return
    end
    if (options.arrowUnit == nil and options.tokenArrow == nil) then
        print_err("leap: -not arrow")
    end
    if (options.targetUnit == nil and options.x == nil and options.y == nil) then
        print_err("leap: -target")
        return
    end
    if (options.targetUnit ~= nil and his.deleted(options.targetUnit)) then
        return
    end
    local frequency = 0.02
    local acceleration = options.acceleration or 0
    local height = options.height or 0
    local shake = options.shake or 0
    if (type(shake) == 'number') then
        if (shake > 90) then
            shake = 90 -- 最大偏振角度
        elseif (shake < -90) then
            shake = -90 -- 最小偏振角度
        end
    end
    local speed = options.speed or 10
    if (speed > 150) then
        speed = 150 -- 最大速度
    elseif (speed <= 1) then
        speed = 1 -- 最小速度
    end
    local filter = options.filter
    local sourceUnit = options.sourceUnit
    local prevUnit = options.prevUnit or sourceUnit
    local damageMovement = options.damageMovement or 0
    local damageMovementRadius = options.damageMovementRadius or 0
    local damageMovementRepeat = options.damageMovementRepeat or false
    local damageMovementDrag = options.damageMovementDrag or false
    local damageEnd = options.damageEnd or 0
    local damageEndRadius = options.damageEndRadius or 0
    local extraInfluence = options.extraInfluence
    local arrowUnit = options.arrowUnit
    local tokenArrow = options.tokenArrow
    local tokenArrowScale = options.tokenArrowScale or 1.00
    local tokenArrowOpacity = options.tokenArrowOpacity or 1.00
    local tokenArrowHeight = options.tokenArrowHeight or 0
    local oneHitOnly = options.oneHitOnly or false
    local colorBuff
    local distanceOrigin
    --这里要注意：targetUnit比xy优先
    local leapType
    local initFacing = 0
    if (options.arrowUnit ~= nil) then
        leapType = "unit"
    else
        leapType = "point"
    end
    if (options.targetUnit ~= nil) then
        initFacing = math.getDegBetweenUnit(prevUnit, options.targetUnit)
        distanceOrigin = math.getDistanceBetweenUnit(prevUnit, options.targetUnit)
    elseif (options.x ~= nil and options.y ~= nil) then
        initFacing = math.getDegBetweenXY(hunit.x(prevUnit), hunit.y(prevUnit), options.x, options.y)
        distanceOrigin = math.getDistanceBetweenXY(hunit.x(prevUnit), hunit.y(prevUnit), options.x, options.y)
    else
        print_err("leapType: -unknow")
        return
    end
    local repeatGroup
    if (damageMovement > 0 and damageMovementRepeat ~= true) then
        repeatGroup = {}
    end
    if (arrowUnit == nil) then
        local cxy
        if (options.tokenX and options.tokenY) then
            cxy = { x = options.tokenX, y = options.tokenY }
        else
            cxy = math.polarProjection(hunit.x(prevUnit), hunit.y(prevUnit), 100, initFacing)
        end
        arrowUnit = hunit.create({
            register = false,
            whichPlayer = hunit.getOwner(sourceUnit),
            id = HL_ID.unit_token_leap,
            x = cxy.x,
            y = cxy.y,
            facing = initFacing,
            modelScale = tokenArrowScale,
            opacity = tokenArrowOpacity,
            qty = 1
        })
        cxy = nil
        if (tokenArrowHeight > 0) then
            hunit.setFlyHeight(arrowUnit, tokenArrowHeight, 9999)
        end
    end
    local heightOrigin = cj.GetUnitFlyHeight(arrowUnit)
    cj.SetUnitFacing(arrowUnit, initFacing)
    --绑定一个无限的effect
    local tempEffectArrow
    if (tokenArrow ~= nil) then
        tempEffectArrow = heffect.bindUnit(tokenArrow, arrowUnit, "origin", -1)
    end
    -- 无敌加无路径
    cj.SetUnitPathing(arrowUnit, false)
    if (leapType == "unit") then
        hunit.setInvulnerable(arrowUnit, true)
        colorBuff = hunit.setRGBA(arrowUnit, nil, nil, nil, tokenArrowOpacity)
    end
    -- 结束！
    local ending = function(endX, endY)
        if (tempEffectArrow ~= nil) then
            heffect.del(tempEffectArrow)
        end
        if (repeatGroup ~= nil) then
            repeatGroup = nil
        end
        if (tokenArrowHeight > 0) then
            hunit.setFlyHeight(arrowUnit, tokenArrowHeight, 9999)
        else
            hunit.setFlyHeight(arrowUnit, heightOrigin, 9999)
        end
        if (his.alive(arrowUnit)) then
            if (options.effectEnd ~= nil) then
                heffect.toXY(options.effectEnd, endX, endY, 0)
            end
            if (damageEndRadius == 0 and options.targetUnit ~= nil) then
                if (damageEnd > 0) then
                    hskill.damage({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        damage = damageEnd,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                        effect = options.damageEffect
                    })
                end
                if (type(extraInfluence) == "function") then
                    extraInfluence(options.targetUnit)
                end
            elseif (damageEndRadius > 0) then
                local g = hgroup.createByUnit(arrowUnit, damageEndRadius, filter)
                hgroup.forEach(g, function(eu)
                    if (damageEnd > 0) then
                        hskill.damage({
                            sourceUnit = options.sourceUnit,
                            targetUnit = eu,
                            damage = damageEnd,
                            damageSrc = options.damageSrc,
                            damageType = options.damageType,
                            isFixed = options.isFixed,
                            effect = options.damageEffect
                        })
                    end
                    if (type(extraInfluence) == "function") then
                        extraInfluence(eu)
                    end
                end)
                g = nil
            end
        end
        if (leapType == "unit") then
            hunit.setInvulnerable(arrowUnit, false)
            cj.SetUnitPathing(arrowUnit, true)
            if (colorBuff) then
                hunit.delRGBA(arrowUnit, colorBuff)
            end
            if (his.alive(arrowUnit)) then
                hunit.portal(arrowUnit, endX, endY)
            end
        else
            hunit.kill(arrowUnit, 0)
        end
        if (type(options.onEnding) == "function") then
            options.onEnding(endX, endY)
        end
    end
    --开始冲鸭
    htime.setInterval(frequency, function(t)
        local ax = hunit.x(arrowUnit)
        local ay = hunit.y(arrowUnit)
        if (his.dead(sourceUnit)) then
            htime.delTimer(t)
            ending(ax, ay)
            return
        end
        local tx = 0
        local ty = 0
        if (options.targetUnit ~= nil) then
            tx = hunit.x(options.targetUnit)
            ty = hunit.y(options.targetUnit)
        else
            tx = options.x
            ty = options.y
        end
        local sh = 0
        if (shake ~= 0) then
            if (shake == 'random') then
                shake = math.random(-90, 90)
            end
            local d = math.getDistanceBetweenXY(hunit.x(arrowUnit), hunit.y(arrowUnit), tx, ty)
            sh = shake * d / distanceOrigin
        end
        local fac = math.getDegBetweenXY(ax, ay, tx, ty) + sh
        local txy = math.polarProjection(ax, ay, speed, fac)
        if (acceleration ~= 0) then
            speed = speed + acceleration
        end
        if (his.borderMap(txy.x, txy.y) == false) then
            hunit.portal(arrowUnit, txy.x, txy.y)
        else
            speed = 0
        end
        cj.SetUnitFacing(arrowUnit, fac)
        if (options.effectMovement ~= nil) then
            heffect.toXY(options.effectMovement, txy.x, txy.y, 0)
        end
        if (damageMovementRadius > 0) then
            local g = hgroup.createByUnit(
                arrowUnit,
                damageMovementRadius,
                function(filterUnit)
                    local flag = filter(filterUnit)
                    if (damageMovementRepeat ~= true and hgroup.includes(repeatGroup, filterUnit)) then
                        flag = false
                    end
                    return flag
                end
            )
            if (hgroup.count(g) > 0) then
                if (oneHitOnly == true) then
                    hunit.kill(arrowUnit, 0)
                end
                hgroup.forEach(g, function(eu)
                    if (damageMovementRepeat ~= true and repeatGroup ~= nil) then
                        hgroup.addUnit(repeatGroup, eu)
                    end
                    if (damageMovement > 0) then
                        hskill.damage({
                            sourceUnit = sourceUnit,
                            targetUnit = eu,
                            damage = damageMovement,
                            damageSrc = options.damageSrc,
                            damageType = options.damageType,
                            isFixed = options.isFixed,
                            effect = options.damageEffect
                        })
                    end
                    if (damageMovementDrag == true) then
                        hunit.portal(eu, txy.x, txy.y)
                    end
                    if (type(extraInfluence) == "function") then
                        extraInfluence(eu)
                    end
                end)
                g = nil
            end
        end
        local distance = math.getDistanceBetweenXY(hunit.x(arrowUnit), hunit.y(arrowUnit), tx, ty)
        if (height > 0 and distance < distanceOrigin) then
            local ddh = 0.5 - distance / distanceOrigin
            ddh = (heightOrigin + height) * (1 - math.abs(ddh) * 2)
            hunit.setFlyHeight(arrowUnit, ddh, 9999)
        end
        if (distance <= speed or speed <= 0 or his.dead(arrowUnit) == true) then
            htime.delTimer(t)
            ending(txy.x, txy.y)
        end
    end)
end

--[[
    剃[爪子状]，参数与leap一致，额外有两个参数，设置角度
    * 需要注意一点的是，paw会自动将对单位跟踪的效果转为对坐标系(不建议使用unit)
    options = {
        qty = 0, --数量>=1
        deg = 15, --角度
        hskill.leap.options
    }
]]
hskill.leapPaw = function(options)
    local qty = options.qty or 0
    local deg = options.deg or 15
    if (qty < 1) then
        print_err("leapPaw: -qty")
        return
    end
    if (qty == 1) then
        hskill.leap(options)
        return
    end
    if (options.sourceUnit == nil) then
        print_err("leapPaw: -sourceUnit")
        return
    end
    if (type(options.filter) ~= "function") then
        print_err("leapPaw: -filter")
        return
    end
    if (options.tokenArrow == nil) then
        print_err("leapPaw: -not arrow")
    end
    if (options.targetUnit == nil and options.x == nil and options.y == nil) then
        print_err("leapPaw: -target")
        return
    end
    local x, y
    if (options.targetUnit ~= nil) then
        x = hunit.x(options.targetUnit)
        y = hunit.y(options.targetUnit)
    else
        x = options.x
        y = options.y
    end
    local sx = hunit.x(options.sourceUnit)
    local sy = hunit.y(options.sourceUnit)
    local facing = math.getDegBetweenXY(sx, sy, x, y)
    local distance = math.getDistanceBetweenXY(sx, sy, x, y)
    local firstDeg = facing + (deg * (qty - 1) * 0.5)
    for i = 1, qty, 1 do
        local angle = firstDeg - deg * (i - 1)
        local txy = math.polarProjection(sx, sy, distance, angle)
        hskill.leap(
            {
                arrowUnit = options.arrowUnit,
                sourceUnit = options.sourceUnit,
                targetUnit = nil,
                x = txy.x,
                y = txy.y,
                speed = options.speed,
                acceleration = options.acceleration,
                height = options.height,
                shake = options.shake,
                filter = options.filter,
                tokenX = options.tokenX,
                tokenY = options.tokenY,
                tokenArrow = options.tokenArrow,
                tokenArrowScale = options.tokenArrowScale,
                tokenArrowOpacity = options.tokenArrowOpacity,
                tokenArrowHeight = options.tokenArrowHeight,
                effectMovement = options.effectMovement,
                effectEnd = options.effectEnd,
                damageMovement = options.damageMovement,
                damageMovementRadius = options.damageMovementRadius,
                damageMovementRepeat = options.damageMovementRepeat,
                damageMovementDrag = options.damageMovementDrag,
                damageEnd = options.damageEnd,
                damageEndRadius = options.damageEndRadius,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
                damageEffect = options.damageEffect,
                oneHitOnly = options.oneHitOnly,
                onEnding = options.onEnding,
                extraInfluence = options.extraInfluence
            }
        )
    end
end

--[[
    剃[选区型]，参数与leap一致，额外有两个参数，设置范围
    * 需要注意一点的是，pow会自动将对单位跟踪的效果转为对坐标系(不建议使用unit)
    options = {
        targetRadius = 0, --以目标点为中心的选区半径范围
        hskill.leap.options
    }
]]
hskill.leapRange = function(options)
    local targetRadius = options.targetRadius or 0
    if (targetRadius <= 0) then
        print_err("leapRange: -targetRadius")
        return
    end
    if (options.sourceUnit == nil) then
        print_err("leapRange: -sourceUnit")
        return
    end
    if (type(options.filter) ~= "function") then
        print_err("leapRange: -filter")
        return
    end
    if (options.targetUnit == nil and options.x == nil and options.y == nil) then
        print_err("leapRange: -target")
        return
    end
    local filter = options.filter
    local x, y
    if (options.targetUnit ~= nil) then
        x = hunit.x(options.targetUnit)
        y = hunit.y(options.targetUnit)
        options.x = nil
        options.y = nil
    else
        x = options.x
        y = options.y
    end
    local g = hgroup.createByXY(x, y, targetRadius, filter)
    hgroup.forEach(g, function(eu)
        local tmp = {
            arrowUnit = options.arrowUnit,
            sourceUnit = options.sourceUnit,
            speed = options.speed,
            acceleration = options.acceleration,
            height = options.height,
            shake = options.shake,
            filter = options.filter,
            tokenX = options.tokenX,
            tokenY = options.tokenY,
            tokenArrow = options.tokenArrow,
            tokenArrowScale = options.tokenArrowScale,
            tokenArrowOpacity = options.tokenArrowOpacity,
            tokenArrowHeight = options.tokenArrowHeight,
            effectMovement = options.effectMovement,
            effectEnd = options.effectEnd,
            damageMovement = options.damageMovement,
            damageMovementRadius = options.damageMovementRadius,
            damageMovementRepeat = options.damageMovementRepeat,
            damageMovementDrag = options.damageMovementDrag,
            damageEnd = options.damageEnd,
            damageEndRadius = options.damageEndRadius,
            damageSrc = options.damageSrc,
            damageType = options.damageType,
            isFixed = options.isFixed,
            damageEffect = options.damageEffect,
            oneHitOnly = options.oneHitOnly,
            onEnding = options.onEnding,
            extraInfluence = options.extraInfluence
        }
        if (options.targetUnit ~= nil) then
            tmp.targetUnit = eu
        else
            tmp.x = hunit.x(eu)
            tmp.y = hunit.y(eu)
        end
        hskill.leap(tmp)
    end)
    g = nil
end

--[[
    反射弹跳
    options = {
        qty = 1, --（跳跃次数，默认1）
        radius = 0, --（选目标半径范围，默认0无效）
        hskill.leap.options
    }
]]
hskill.leapReflex = function(options)
    local qty = options.qty or 1
    local radius = options.radius or 0
    if (radius <= 0) then
        print_err("reflex: -radius")
        return
    end
    if (options.sourceUnit == nil) then
        print_err("reflex: -sourceUnit")
        return
    end
    if (type(options.filter) ~= "function") then
        print_err("reflex: -filter")
        return
    end
    if (options.arrowUnit == nil and options.tokenArrow == nil) then
        print_err("reflex: -not arrow")
    end
    if (options.targetUnit == nil) then
        print_err("reflex: -target")
        return
    end
    options.x = nil
    options.y = nil
    options.onEnding = function(x, y)
        qty = qty - 1
        if (qty >= 1) then
            local g = hgroup.createByXY(x, y, radius, options.filter)
            local closer = hgroup.getClosest(g, x, y)
            if (closer ~= nil) then
                options.prevUnit = options.targetUnit
                options.targetUnit = closer
                hskill.leap(options)
            end
        end
    end
    hskill.leap(options)
end

--[[
    矩形打击
    options = {
        damage = 0, --伤害（必须有，默认0无效）
        sourceUnit, --伤害来源（必须有！不管有没有伤害）
        x, --初始的x坐标（必须有，对点冲击，从该处开始打击）
        y, --初始的y坐标（必须有，对点冲击，从该处开始打击）
        deg, --方向（必须有）
        radius = 0, --打击半径范围（必须有，默认为0无效）
        distance = 0, --打击距离（必须有，默认为0无效）
        frequency = 0, --打击频率（必须有，默认0瞬间打击全部形状）
        filter = [function], --必须有
        effect = nil, --打击特效
        effectScale = 1.30, --打击特效缩放
        effectOffset = 0, --打击特效偏移量（distance+offset才是展示特效距离）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
        isFixed = false --是否固伤（可选）
        damageEffect = nil, --伤害特效（可选）
        oneHitOnly = true, --是否每个敌人只打击一次（可选,默认true）
        extraInfluence = [function] --对击中的敌人的额外影响，会回调该敌人单位，可以对其做出自定义行为
    }
]]
hskill.rectangleStrike = function(options)
    if (options.sourceUnit == nil) then
        print_err("rectangleStrike: -sourceUnit")
        return
    end
    if (options.x == nil or options.y == nil) then
        print_err("rectangleStrike: -xy")
        return
    end
    if (options.deg == nil) then
        print_err("rectangleStrike: -deg")
        return
    end
    if (options.filter == nil) then
        print_err("rectangleStrike: -filter")
        return
    end
    local damage = options.damage or 0
    local radius = options.radius or 0
    local distance = options.distance or 0
    if (damage <= 0 or radius <= 0 or distance <= 0) then
        print_err("rectangleStrike: -data")
        return
    end
    local frequency = options.frequency or 0
    local oneHitOnly = options.oneHitOnly
    local effectScale = options.effectScale or 1.30
    local effectOffset = options.effectOffset or 0
    if (oneHitOnly == nil) then
        oneHitOnly = true
    end
    if (frequency <= 0) then
        local i = 0
        local tg = {}
        while (true) do
            i = i + 1
            local d = i * radius * 0.33
            if (d >= distance) then
                break
            end
            local txy = math.polarProjection(options.x, options.y, d, options.deg)
            if (options.effect ~= nil and d - effectOffset < distance) then
                local effUnitDur = 0.6
                local effUnit = hunit.create({
                    register = false,
                    whichPlayer = hplayer.player_passive,
                    id = HL_ID.unit_token_leap,
                    x = txy.x,
                    y = txy.y,
                    facing = options.deg,
                    modelScale = effectScale,
                    opacity = 1.0,
                    qty = 1,
                    during = effUnitDur
                })
                heffect.bindUnit(options.effect, effUnit, "origin", effUnitDur)
            end
            local _g = hgroup.createByXY(txy.x, txy.y, radius, options.filter)
            hgroup.forEach(_g, function(eu)
                if (hgroup.includes(tg, eu) == false) then
                    hgroup.addUnit(tg, eu)
                end
            end)
            _g = nil
        end
        if (hgroup.count(tg) > 0) then
            hskill.damageGroup({
                frequency = 0,
                times = 1,
                effect = options.damageEffect,
                whichGroup = tg,
                damage = damage,
                sourceUnit = options.sourceUnit,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                isFixed = options.isFixed,
                extraInfluence = options.extraInfluence
            })
        end
        tg = nil
    else
        local i = 0
        htime.setInterval(frequency, function(t)
            i = i + 1
            local d = i * radius * 0.5
            if (d >= distance) then
                htime.delTimer(t)
                return
            end
            local txy = math.polarProjection(options.x, options.y, d, options.deg)
            if (options.effect ~= nil and d - effectOffset < distance) then
                local effUnitDur = 0.6
                local effUnit = hunit.create({
                    register = false,
                    whichPlayer = hplayer.player_passive,
                    id = HL_ID.unit_token_leap,
                    x = txy.x,
                    y = txy.y,
                    facing = options.deg,
                    modelScale = effectScale,
                    opacity = 1.0,
                    qty = 1,
                    during = effUnitDur
                })
                heffect.bindUnit(options.effect, effUnit, "origin", effUnitDur)
            end
            local g = hgroup.createByXY(txy.x, txy.y, radius, options.filter)
            if (hgroup.count(g) > 0) then
                hskill.damageGroup(
                    {
                        frequency = 0,
                        times = 1,
                        effect = options.damageEffect,
                        whichGroup = g,
                        damage = damage,
                        sourceUnit = options.sourceUnit,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                        extraInfluence = options.extraInfluence
                    }
                )
            end
            g = nil
        end)
    end
end
