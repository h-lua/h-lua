-- 伤害漂浮字
local _damageTtgQty = 0
local _damageTtg = function(targetUnit, damage, fix, color)
    _damageTtgQty = _damageTtgQty + 1
    local during = 1.0
    local offx = -0.05 - _damageTtgQty * 0.013
    local offy = 0.05 + _damageTtgQty * 0.013
    htextTag.style(
        htextTag.create2Unit(targetUnit, fix .. math.floor(damage), 6.00, color, 1, during, 12.00),
        "toggle", offx, offy
    )
    htime.setTimeout(during, function(t)
        htime.delTimer(t)
        _damageTtgQty = _damageTtgQty - 1
    end)
end

--[[
    造成伤害
    options = {
        sourceUnit = nil, --伤害来源(可选)
        targetUnit = nil, --目标单位
        damage = 0, --实际伤害
        damageString = "", --伤害漂浮字颜色
        damageStringColor = "", --伤害漂浮字颜色
        effect = nil, --伤害特效
        damageSrc = "unknown", --伤害来源请查看 CONST_DAMAGE_SRC
        damageType = { "common" }, --伤害类型请查看 CONST_DAMAGE_TYPE
        breakArmorType = {} --破防(无视防御)类型请查看 CONST_BREAK_ARMOR_TYPE
        isFixed = false, --是否固定伤害，伤害在固定下(无视类型、魔抗、自然、增幅、减伤)不计算，而自然虽然不影响伤害，但会有自然效果
    }
]]
---@param options pilotDamage
hskill.damage = function(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    local damage = options.damage or 0
    if (damage < 0.125) then
        return
    end
    if (targetUnit == nil) then
        return
    end
    if (his.alive(options.targetUnit) == false or his.deleted(targetUnit)) then
        return
    end
    if (his.deleted(targetUnit)) then
        return
    end
    if (sourceUnit ~= nil and his.deleted(sourceUnit)) then
        return
    end
    if (options.damageSrc == nil) then
        options.damageSrc = CONST_DAMAGE_SRC.unknown
    end
    --双方attr get
    local targetUnitAttr = hattribute.get(targetUnit)
    local sourceUnitAttr = {}
    if (targetUnitAttr == nil) then
        return
    end
    if (sourceUnit ~= nil) then
        sourceUnitAttr = hattribute.get(sourceUnit)
        if (sourceUnitAttr == nil) then
            return
        end
    end
    local damageSrc = options.damageSrc
    local damageType = options.damageType
    -- 攻击者的攻击里各种类型的占比
    if (damageType == nil) then
        if (damageSrc == CONST_DAMAGE_SRC.attack and sourceUnit ~= nil) then
            damageType = {}
            for _, con in ipairs(CONST_ENCHANT) do
                if (sourceUnitAttr['e_' .. con.value .. '_attack'] > 0) then
                    for _ = 1, sourceUnitAttr['e_' .. con.value .. '_attack'], 1 do
                        table.insert(damageType, con.value)
                    end
                end
            end
        end
    end
    --常规伤害判定
    if (damageType == nil or #damageType <= 0) then
        damageType = { CONST_DAMAGE_TYPE.common } -- common是个通常设置，实际上并无特定效果
    end
    local damageTypeRatioPiece = 1 / #damageType
    local damageTypeRatio = {}
    for _, dt in ipairs(damageType) do
        if (damageTypeRatio[dt] == nil) then
            damageTypeRatio[dt] = 0
        end
        damageTypeRatio[dt] = damageTypeRatio[dt] + damageTypeRatioPiece
    end
    -- 最终伤害
    local lastDamage = 0
    local lastDamagePercent = 0.0
    -- 僵直计算
    local punishEffectRatio = 0
    -- 是否固伤
    local isFixed = false
    if (type(options.isFixed) == "boolean") then
        isFixed = options.isFixed
    end
    -- 文本显示
    local breakArmorType = options.breakArmorType or {}
    local damageString = options.damageString or ""
    local damageStringColor = options.damageStringColor or "d9d9d9"
    local effect = options.effect
    -- 判断伤害方式
    if (damageSrc == CONST_DAMAGE_SRC.attack) then
        if (his.unarm(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.skill) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.item) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    else
        damageSrc = CONST_DAMAGE_SRC.unknown
    end
    -- 计算单位是否无敌（无敌属性为百分比计算，被动触发抵挡一次）
    if (his.invincible(targetUnit) == true or math.random(1, 100) < targetUnitAttr.invincible) then
        if (table.includes(breakArmorType, CONST_BREAK_ARMOR_TYPE.invincible.value) == false) then
            return
        end
    end
    -- 计算硬直抵抗
    punishEffectRatio = 0.99
    if (targetUnitAttr.punish_oppose > 0) then
        punishEffectRatio = punishEffectRatio - targetUnitAttr.punish_oppose * 0.01
        if (punishEffectRatio < 0.100) then
            punishEffectRatio = 0.100
        end
    end
    if (isFixed == false) then
        -- 判断无视装甲类型
        if (breakArmorType ~= nil and #breakArmorType > 0) then
            damageString = damageString .. "无视"
            if (table.includes(breakArmorType, CONST_BREAK_ARMOR_TYPE.avoid.value)) then
                if (targetUnitAttr.avoid > 0) then
                    targetUnitAttr.avoid = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.avoid.label
                damageStringColor = "76a5af"
            end
            if (table.includes(breakArmorType, CONST_BREAK_ARMOR_TYPE.invincible.value)) then
                if (targetUnitAttr.avoid > 0) then
                    targetUnitAttr.avoid = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.invincible.label
                damageStringColor = "ff4500"
            end
            -- @触发无视防御事件
            hevent.triggerEvent(
                sourceUnit,
                CONST_EVENT.breakArmor,
                {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    breakType = breakArmorType
                }
            )
            -- @触发被无视防御事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beBreakArmor,
                {
                    triggerUnit = targetUnit,
                    sourceUnit = sourceUnit,
                    breakType = breakArmorType
                }
            )
        end
    end
    -- 开始神奇的伤害计算
    lastDamage = damage
    -- 自身暴击计算，自身暴击触发下，回避几率减少一半
    local isKnocking = false
    if (isFixed == false and lastDamage > 0 and sourceUnitAttr.knocking_odds > 0 and sourceUnitAttr.knocking_extent > 0) then
        local targetKnockingOppose = hattribute.get(targetUnit, "knocking_oppose")
        sourceUnitAttr.knocking_odds = sourceUnitAttr.knocking_odds - targetKnockingOppose
        if (math.random(1, 100) <= sourceUnitAttr.knocking_odds) then
            isKnocking = true
            damageString = "暴击!" .. damageString
            damageStringColor = "ff0000"
            lastDamagePercent = lastDamagePercent + sourceUnitAttr.knocking_extent * 0.01
            if (targetUnitAttr.avoid > 0) then
                targetUnitAttr.avoid = targetUnitAttr.avoid * 0.5
            end
            heffect.toUnit("war3mapImported\\eff_crit.mdl", targetUnit, 0.5)
        end
    end
    -- 计算回避 X 命中
    if (damageSrc == CONST_DAMAGE_SRC.attack and targetUnitAttr.avoid - (sourceUnitAttr.aim or 0) > 0 and math.random(1, 100) <= targetUnitAttr.avoid - (sourceUnitAttr.aim or 0)) then
        lastDamage = 0
        htextTag.style(htextTag.create2Unit(targetUnit, "回避", 6.00, "5ef78e", 10, 1.00, 10.00), "scale", 0, 0.2)
        -- @触发回避事件
        hevent.triggerEvent(
            targetUnit,
            CONST_EVENT.avoid,
            {
                triggerUnit = targetUnit,
                attackUnit = sourceUnit
            }
        )
        -- @触发被回避事件
        hevent.triggerEvent(
            sourceUnit,
            CONST_EVENT.beAvoid,
            {
                triggerUnit = sourceUnit,
                avoidUnit = targetUnit
            }
        )
    end
    if (lastDamage > 0) then
        -- 计算附魔属性
        local tempNatural = {}
        for _, enchant in ipairs(CONST_ENCHANT) do
            local ev = enchant.value
            if (damageTypeRatio[ev] ~= nil and damageTypeRatio[ev] > 0) then
                tempNatural[ev] = henchant.INTRINSIC_ADDITION + (sourceUnitAttr["e_" .. ev] or 0) - targetUnitAttr["e_" .. ev .. "_oppose"]
                if (tempNatural[ev] < -100) then
                    tempNatural[ev] = -100
                end
                if (tempNatural[ev] ~= 0) then
                    if (isFixed == false) then
                        lastDamagePercent = lastDamagePercent + damageTypeRatio[ev] * tempNatural[ev] * 0.01
                    end
                    damageString = damageString .. enchant.label
                    damageStringColor = enchant.color
                end
            end
        end
        if (isFixed == false) then
            -- 计算伤害增幅
            if (lastDamage > 0 and sourceUnit ~= nil and sourceUnitAttr.damage_extent ~= 0) then
                lastDamagePercent = lastDamagePercent + sourceUnitAttr.damage_extent * 0.01
            end
        end
        -- 合计 lastDamagePercent
        lastDamage = lastDamage * (1 + lastDamagePercent)
        if (isFixed == false) then
            -- 计算减伤
            local resistance = 0
            -- 固定值减少
            if (targetUnitAttr.damage_reduction > 0) then
                resistance = resistance + targetUnitAttr.damage_reduction
            end
            -- 百分比减少
            if (targetUnitAttr.damage_decrease > 0) then
                resistance = resistance + lastDamage * targetUnitAttr.damage_decrease * 0.01
            end
            if (resistance > 0) then
                if (resistance >= lastDamage) then
                    --@当减伤100%以上时触发事件,触发极限减伤抵抗事件
                    hevent.triggerEvent(
                        targetUnit,
                        CONST_EVENT.damageResistance,
                        {
                            triggerUnit = targetUnit,
                            sourceUnit = sourceUnit,
                            resistance = resistance,
                        }
                    )
                    lastDamage = 0
                else
                    lastDamage = lastDamage - resistance
                end
            end
        end
    end
    -- 上面都是先行计算
    if (lastDamage > 0.125 and his.deleted(targetUnit) == false) then
        -- 着身附魔
        henchant.append({
            targetUnit = targetUnit,
            sourceUnit = sourceUnit,
            enchants = damageType,
        })
        -- 设置单位正在受伤
        local isBeDamagingTimer = hcache.get(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        if (isBeDamagingTimer ~= nil) then
            htime.delTimer(isBeDamagingTimer)
            hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        end
        hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, true)
        hcache.set(
            targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER,
            htime.setTimeout(3.5, function(t)
                htime.delTimer(t)
                hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
                hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, false)
                if (hunit.isPunishing(targetUnit)) then
                    hmonitor.listen(CONST_MONITOR.PUNISH, targetUnit)
                end
            end)
        )
        if (sourceUnit ~= nil and his.deleted(sourceUnit) == false) then
            local isDamagingTimer = hcache.get(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            if (isDamagingTimer ~= nil) then
                htime.delTimer(isDamagingTimer)
                hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            end
            hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING, true)
            hcache.set(
                sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER,
                htime.setTimeout(3.5, function(t)
                    htime.delTimer(t)
                    hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
                    hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING, false)
                end)
            )
            hevent.setLastDamageUnit(targetUnit, sourceUnit)
            hplayer.addDamage(hunit.getOwner(sourceUnit), lastDamage)
        end
        -- 造成伤害及漂浮字
        _damageTtg(targetUnit, lastDamage, damageString, damageStringColor)
        --
        hplayer.addBeDamage(hunit.getOwner(targetUnit), lastDamage)
        hunit.subCurLife(targetUnit, lastDamage)
        if (type(effect) == "string" and string.len(effect) > 0) then
            heffect.toXY(effect, hunit.x(targetUnit), hunit.y(targetUnit), 0)
        end
        -- @触发伤害事件
        if (sourceUnit ~= nil) then
            hevent.triggerEvent(
                sourceUnit,
                CONST_EVENT.damage,
                {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    damage = lastDamage,
                    damageSrc = damageSrc,
                    damageType = damageType
                }
            )
        end
        -- @触发被伤害事件
        hevent.triggerEvent(
            targetUnit,
            CONST_EVENT.beDamage,
            {
                triggerUnit = targetUnit,
                sourceUnit = sourceUnit,
                damage = lastDamage,
                damageSrc = damageSrc,
                damageType = damageType
            }
        )
        if (damageSrc == CONST_DAMAGE_SRC.attack) then
            if (sourceUnit ~= nil) then
                -- @触发攻击事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.attack,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        damage = lastDamage,
                        damageType = damageType
                    }
                )
            end
            -- @触发被攻击事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beAttack,
                {
                    triggerUnit = targetUnit,
                    attackUnit = sourceUnit,
                    damage = lastDamage,
                    damageType = damageType
                }
            )
        elseif (damageSrc == CONST_DAMAGE_SRC.skill) then
            if (sourceUnit ~= nil) then
                -- @触发技能事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.skill,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        damage = lastDamage,
                        damageType = damageType
                    }
                )
            end
            -- @触发被技能击中事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beSkill,
                {
                    triggerUnit = targetUnit,
                    castUnit = sourceUnit,
                    damage = lastDamage,
                    damageType = damageType
                }
            )
        elseif (damageSrc == CONST_DAMAGE_SRC.item) then
            if (sourceUnit ~= nil) then
                -- @触发物品事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.item,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        damage = lastDamage,
                        damageType = damageType
                    }
                )
            end
            -- @触发被物品伤害事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beItem,
                {
                    triggerUnit = targetUnit,
                    useUnit = sourceUnit,
                    damage = lastDamage,
                    damageType = damageType
                }
            )
        end
        -- 本体暴击
        if (isKnocking == true) then
            --@触发物理暴击事件
            hevent.triggerEvent(sourceUnit, CONST_EVENT.knocking, {
                triggerUnit = sourceUnit,
                targetUnit = targetUnit,
                damage = lastDamage,
                odds = sourceUnitAttr.knocking_odds,
                percent = sourceUnitAttr.knocking_extent
            })
            --@触发被物理暴击事件
            hevent.triggerEvent(targetUnit, CONST_EVENT.beKnocking, {
                triggerUnit = sourceUnit,
                sourceUnit = targetUnit,
                damage = lastDamage,
                odds = sourceUnitAttr.knocking_odds,
                percent = sourceUnitAttr.knocking_extent
            })
        end
        -- 吸血
        if (sourceUnit ~= nil and damageSrc == CONST_DAMAGE_SRC.attack) then
            local hemophagia = sourceUnitAttr.hemophagia - targetUnitAttr.hemophagia_oppose
            if (hemophagia > 0) then
                hunit.addCurLife(sourceUnit, lastDamage * hemophagia * 0.01)
                heffect.bindUnit(
                    "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",
                    sourceUnit,
                    "origin",
                    1.00
                )
                -- @触发吸血事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.hemophagia,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        value = lastDamage * hemophagia * 0.01,
                        percent = hemophagia,
                    }
                )
                -- @触发被吸血事件
                hevent.triggerEvent(
                    targetUnit,
                    CONST_EVENT.beHemophagia,
                    {
                        triggerUnit = targetUnit,
                        sourceUnit = sourceUnit,
                        value = lastDamage * hemophagia * 0.01,
                        percent = hemophagia,
                    }
                )
            end
        end
        -- 技能吸血
        if (sourceUnit ~= nil and damageSrc == CONST_DAMAGE_SRC.skill) then
            local hemophagiaSkill = sourceUnitAttr.hemophagia_skill - targetUnitAttr.hemophagia_skill_oppose
            if (hemophagiaSkill > 0) then
                hunit.addCurLife(sourceUnit, lastDamage * hemophagiaSkill * 0.01)
                heffect.bindUnit(
                    "Abilities\\Spells\\Items\\HealingSalve\\HealingSalveTarget.mdl",
                    sourceUnit,
                    "origin",
                    1.80
                )
                -- @触发技能吸血事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.skillHemophagia,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        value = lastDamage * hemophagiaSkill * 0.01,
                        percent = hemophagiaSkill
                    }
                )
                -- @触发被技能吸血事件
                hevent.triggerEvent(
                    targetUnit,
                    CONST_EVENT.beSkillHemophagia,
                    {
                        triggerUnit = targetUnit,
                        sourceUnit = sourceUnit,
                        value = lastDamage * hemophagiaSkill * 0.01,
                        percent = hemophagiaSkill
                    }
                )
            end
        end
        -- 硬直
        local punishDuring = 5.00
        if (lastDamage > 1 and his.alive(targetUnit) and his.punish(targetUnit) == false and hunit.isPunishing(targetUnit)) then
            local cutVal = lastDamage * 1
            local isCut = (targetUnitAttr.punish_current - cutVal <= 0)
            hattribute.set(targetUnit, 0, {
                punish_current = "-" .. cutVal
            })
            if (isCut and his.deleted(targetUnit) == false) then
                hcache.set(targetUnit, CONST_CACHE.ATTR_PUNISHING, true)
                hunit.setRGBA(targetUnit, 77, 77, 77, 1, punishDuring)
                htime.setTimeout(punishDuring + 1, function(t)
                    htime.delTimer(t)
                    hcache.set(targetUnit, CONST_CACHE.ATTR_PUNISHING, false)
                end)
                local punishEffectAttackSpeed = (100 + targetUnitAttr.attack_speed) * punishEffectRatio
                local punishEffectMove = targetUnitAttr.move * punishEffectRatio
                if (punishEffectAttackSpeed < 1) then
                    punishEffectAttackSpeed = 1
                end
                if (punishEffectMove < 1) then
                    punishEffectMove = 1
                end
                hattribute.set(targetUnit, punishDuring, {
                    attack_speed = "-" .. punishEffectAttackSpeed,
                    move = "-" .. punishEffectMove
                })
                htextTag.style(
                    htextTag.create2Unit(targetUnit, "僵硬", 6.00, "c0c0c0", 0, punishDuring, 50.00),
                    "scale",
                    0,
                    0
                )
                -- @触发硬直事件
                hevent.triggerEvent(targetUnit, CONST_EVENT.punish, {
                    triggerUnit = targetUnit,
                    sourceUnit = sourceUnit,
                    percent = punishEffectRatio * 100,
                    during = punishDuring
                })
            end
        end
        -- 反伤
        if (sourceUnit ~= nil and his.invincible(sourceUnit) == false) then
            local targetUnitDamageRebound = targetUnitAttr.damage_rebound - sourceUnitAttr.damage_rebound_oppose
            if (targetUnitDamageRebound > 0) then
                local ldr = math.round(lastDamage * targetUnitDamageRebound * 0.01)
                if (ldr > 0.01) then
                    hevent.setLastDamageUnit(sourceUnit, targetUnit)
                    hunit.subCurLife(sourceUnit, ldr)
                    htextTag.style(
                        htextTag.create2Unit(sourceUnit, "反伤" .. ldr, 12.00, "f8aaeb", 10, 1.00, 10.00),
                        "shrink",
                        0.05,
                        0
                    )
                    -- @触发反伤事件
                    hevent.triggerEvent(
                        targetUnit,
                        CONST_EVENT.rebound,
                        {
                            triggerUnit = targetUnit,
                            sourceUnit = sourceUnit,
                            damage = ldr
                        }
                    )
                    -- @触发被反伤事件
                    hevent.triggerEvent(
                        sourceUnit,
                        CONST_EVENT.beRebound,
                        {
                            triggerUnit = sourceUnit,
                            sourceUnit = targetUnit,
                            damage = ldr
                        }
                    )
                end
            end
        end
    end
end

--[[
    多频多段伤害
    特别适用于例如中毒，灼烧等效果
    options = {
        targetUnit = [unit], --受伤单位（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        extraInfluence = [function],
        -- 其他的和伤害函数一致，例如：
        effect = "", --特效（可选）
        damage = 0, --单次伤害（大于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
        damageType = {CONST_DAMAGE_TYPE}, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
    }
]]
---@param options pilotDamageStep
hskill.damageStep = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    options.damage = options.damage or 0
    if (options.targetUnit == nil) then
        print_err("hskill.damageStep:-targetUnit")
        return
    end
    if (times <= 0 or options.damage <= 0) then
        print_err("hskill.damageStep:-times -damage")
        return
    end
    if (times > 1 and frequency <= 0) then
        print_err("hskill.damageStep:-frequency")
        return
    end
    if (times <= 1) then
        hskill.damage(options)
        if (type(options.extraInfluence) == "function") then
            options.extraInfluence(options.targetUnit)
        end
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                htime.delTimer(t)
                return
            end
            hskill.damage(options)
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(options.targetUnit)
            end
        end)
    end
end

--[[
    范围持续伤害
    options = {
        radius = 0, --半径范围（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --特效（可选）
        effectSingle = "", --单体特效（可选）
        filter = [function], --必须有
        whichUnit = [unit], --中心单位的位置（可选）
        x = [point], --目标坐标X（可选）
        y = [point], --目标坐标Y（可选）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
        damageType = {CONST_DAMAGE_TYPE}, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
        extraInfluence = [function],
    }
]]
---@param options pilotDamageRange
hskill.damageRange = function(options)
    local radius = options.radius or 0
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (radius <= 0 or times <= 0) then
        print_err("hskill.damageRange:-radius -times")
        return
    end
    if (times > 1 and frequency <= 0) then
        print_err("hskill.damageRange:-frequency")
        return
    end
    local x, y
    if (options.x ~= nil or options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    end
    if (x == nil or y == nil) then
        print_err("hskill.damageRange:-x -y")
        return
    end
    local filter = options.filter
    if (type(filter) ~= "function") then
        print_err("filter must be function")
        return
    end
    if (options.effect ~= nil) then
        heffect.toXY(options.effect, x, y, 0.25 + (times * frequency))
    end
    if (times <= 1) then
        local g = hgroup.createByXY(x, y, radius, filter)
        if (g == nil) then
            return
        end
        if (hgroup.count(g) <= 0) then
            return
        end
        hgroup.forEach(g, function(eu)
            hskill.damage({
                sourceUnit = options.sourceUnit,
                targetUnit = eu,
                effect = options.effectSingle,
                damage = damage,
                damageSrc = options.damageSrc,
                damageType = options.damageType,
                damageStringColor = options.damageStringColor,
                breakArmorType = options.breakArmorType,
                isFixed = options.isFixed,
            })
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(eu)
            end
        end)
        g = nil
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                htime.delTimer(t)
                return
            end
            local g = hgroup.createByXY(x, y, radius, filter)
            if (g == nil) then
                return
            end
            if (hgroup.count(g) <= 0) then
                return
            end
            hgroup.forEach(g, function(eu)
                hskill.damage({
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    effect = options.effectSingle,
                    damage = damage,
                    damageSrc = options.damageSrc,
                    damageType = options.damageType,
                    damageStringColor = options.damageStringColor,
                    breakArmorType = options.breakArmorType,
                    isFixed = options.isFixed,
                })
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end)
            g = nil
        end)
    end
end

--[[
    单位组持续伤害
    options = {
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --伤害特效（可选）
        whichGroup = [group], --单位组（必须有）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
        damageType = {CONST_DAMAGE_TYPE}, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
        extraInfluence = [function],
    }
]]
hskill.damageGroup = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (options.whichGroup == nil) then
        print_err("hskill.damageGroup:-whichGroup")
        return
    end
    if (times <= 0 or frequency < 0) then
        print_err("hskill.damageGroup:-times -frequency")
        return
    end
    if (times <= 1) then
        hgroup.forEach(options.whichGroup, function(eu)
            hskill.damage(
                {
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    effect = options.effect,
                    damage = damage,
                    damageSrc = options.damageSrc,
                    damageType = options.damageType,
                    isFixed = options.isFixed,
                }
            )
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(eu)
            end
        end)
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                htime.delTimer(t)
                return
            end
            hgroup.forEach(options.whichGroup, function(eu)
                hskill.damage(
                    {
                        sourceUnit = options.sourceUnit,
                        targetUnit = eu,
                        effect = options.effect,
                        damage = damage,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                    }
                )
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end)
        end)
    end
end
