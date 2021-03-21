--- 属性系统，事件密切的功能扩展支持的事件
hattribute.xtrasSupportEvents = {
    CONST_EVENT.attack, CONST_EVENT.beAttack,
    CONST_EVENT.skill, CONST_EVENT.beSkill,
    CONST_EVENT.item, CONST_EVENT.beItem,
    CONST_EVENT.damage, CONST_EVENT.beDamage,
    CONST_EVENT.attackDetect, CONST_EVENT.attackGetTarget, CONST_EVENT.beAttackReady,
    CONST_EVENT.skillStudy, CONST_EVENT.skillReady, CONST_EVENT.skillCast, CONST_EVENT.skillEffect, CONST_EVENT.skillStop, CONST_EVENT.skillFinish,
    CONST_EVENT.itemUsed, CONST_EVENT.itemSell, CONST_EVENT.unitSell, CONST_EVENT.itemDrop, CONST_EVENT.itemPawn, CONST_EVENT.itemGet,
    CONST_EVENT.itemSynthesis, CONST_EVENT.itemOverWeight, CONST_EVENT.itemOverSlot,
    CONST_EVENT.damageResistance,
    CONST_EVENT.avoid, CONST_EVENT.beAvoid, CONST_EVENT.breakArmor, CONST_EVENT.beBreakArmor,
    CONST_EVENT.swim, CONST_EVENT.beSwim, CONST_EVENT.broken, CONST_EVENT.beBroken,
    CONST_EVENT.silent, CONST_EVENT.beSilent, CONST_EVENT.unarm, CONST_EVENT.beUnarm, CONST_EVENT.fetter, CONST_EVENT.beFetter,
    CONST_EVENT.bomb, CONST_EVENT.beBomb,
    CONST_EVENT.lightningChain, CONST_EVENT.beLightningChain,
    CONST_EVENT.crackFly, CONST_EVENT.beCrackFly,
    CONST_EVENT.rebound, CONST_EVENT.beRebound,
    CONST_EVENT.knocking, CONST_EVENT.beKnocking,
    CONST_EVENT.split, CONST_EVENT.beSplit,
    CONST_EVENT.hemophagia, CONST_EVENT.beHemophagia, CONST_EVENT.skillHemophagia, CONST_EVENT.beSkillHemophagia,
    CONST_EVENT.punish, CONST_EVENT.dead, CONST_EVENT.kill, CONST_EVENT.reborn, CONST_EVENT.levelUp,
    CONST_EVENT.moveStart, CONST_EVENT.moving, CONST_EVENT.moveStop, CONST_EVENT.holdOn, CONST_EVENT.stop,
}

--- 属性系统，val数据支持的单位属性
hattribute.xtrasSupportVals = {
    "life", "mana", "move",
    "defend", "defend_white", "defend_green",
    "attack", "attack_white", "attack_green", "attack_range", "attack_range_acquire", "attack_space",
    "str", "agi", "int", "str_green", "agi_green", "int_green", "str_white", "agi_white", "int_white",
    "level",
    "gold", "lumber",
}

--- 是否允许死亡单位通过xtras效果验证
---@private
---@param targetUnit userdata 执行单位
---@param type string attr|spec
---@param field string any
---@return boolean
hattribute.xtrasPassAlive = function(targetUnit, type, field)
    if (his.alive(targetUnit)) then
        return true
    end
    if (type == 'attr') then
        return false
    elseif (type == 'spec') then
        if (field == 'split' or field == 'bomb' or field == 'paw') then
            return true
        end
    end
    return false
end

--- 快速取单位xtras的数据
---@param whichUnit userdata
---@param eventKey string
---@return table
hattribute.getXtras = function(whichUnit, eventKey)
    if (whichUnit == nil or eventKey == nil or type(whichUnit) ~= 'userdata') then
        return {}
    end
    if (hunit.getName(whichUnit) == nil) then
        return {}
    end
    local xtras = hattribute.get(whichUnit, 'xtras')
    if (xtras == nil or type(xtras) ~= 'table' or #xtras <= 0) then
        return {}
    end
    local xtrasInEvent = {}
    for _, x in ipairs(xtras) do
        if (eventKey == x._t.on) then
            table.insert(xtrasInEvent, x._t)
        end
    end
    return xtrasInEvent
end

--- 判断是否有xtras
---@param whichUnit userdata
---@param eventKey string
---@return table
hattribute.hasXtras = function(whichUnit, eventKey)
    return #(hattribute.getXtras(whichUnit, eventKey)) > 0
end

--- 属性系统，事件密切的功能扩展
--- 以事件的handle作为主引导，例如attack事件的引导就是攻击者，而beDamage事件的引导就是受伤者
--- action为字符串分三段：
--- triggerUnit.attr.attack_speed
--- [ 作用目标 ].[类型].[ 效果参数 ]
--- | - [作用目标] 范围是 hevent 回调时 evtData 相关单位
--- | - [类型] 暂分为 attr(属性改动，攻速攻击等) 和 spec(特别效果，暴击击飞等)
--- | - [效果参数] 如attr时，可以填attack_speed改攻速，而effect时可以填knocking触发暴击
--- | - [其他参数] 其他的参数有常规通用的也有固定搭配，请看说明：
---         odds 触发几率>0(%)
---         during 持续时间>0，这个时间在不同场景意义不同(*attr有效、spec里的眩晕、沉默、缴械、定身、击飞有效)
---         effect 特效字符串，主特效
---         effectEnum 特效字符串，选取单位的 (* 爆破有效)
---
---         val 数值或伤害~=0,这个字段可以填数字，在spec时也可填限定特殊的数据，详情如下：
---             1、数字型，如 100, 50.50
---             2、字符串 "damage"，会自动获取evtData里面的damage数据
---             3、字符串-目标单位属性段 "targetUnit.attack_white"
---                以点分隔，上例会自动获取evtData里面的targetUnit单位,并使用它的白字攻击作为数据
---                第二个属性不能随意调用任意属性，可查看 hattribute.valSupportAttribute
---             4、字符串-单位等级 "targetUnit.level"
---                以点分隔，上例会自动获取evtData里面的"targetUnit"单位的单位等级作为数据
---                这是运用 hhero.getCurLevel
---             5、字符串-目标玩家属性段 "targetUnit.gold"
---                以点分隔，上例会自动获取evtData里面的"targetUnit"单位的拥有者,并使用玩家属性作为数据
---                第二个属性是gold|lumber时自动切换
---
---         percent 程度>0(%) 对val的补充，默认100%,可大于100% (*attr有效、spec里的眩晕、沉默、缴械、定身、击飞有效)
---             也可填限定特殊的数据，详情如下：
---             1、数字型，如 100, 50
-----           2、范围型如一个table {10, 90} 表示随机 10%~90%
---         damageSrc 伤害来源（可选的，如果evtData有且无自定义，自动使用）
---         damageType 伤害类型（可选的，如果evtData有且无自定义，自动使用）
---         radius 半径范围>0 (* 分裂、爆破有效)
---         qty 数量>0 (* 只有闪电链有效)
---         rate 增长率(%) (* 只有闪电链有效，负数就是衰减)
---         lightning_type 闪电类型 (* 只有闪电链有效，参考 hlightning.type)
---         distance 距离 (* 只有击飞有效)
---         height 高度 (* 只有击飞有效)
--- 惯用例子：
--- hattribute.set(unit, 0, {
--    xtras = {
--      add = {
--        { on = CONST_EVENT.attack, action = "triggerUnit.attr.attack_speed", odds = 20.0, val = 1.5, during = 3.0, effect = nil },
--        { on = CONST_EVENT.attack, action = "attackUnit.attr.attack_speed", odds = 20.0, val = 1.5, during = 3.0, effect = nil },
--        { on = CONST_EVENT.skill, action = "castUnit.attr.attack_green", odds = 20.0, val = 2, during = 3.0, effect = nil },
--        { on = CONST_EVENT.item, action = "useUnit.attr.int_white", odds = 20.0, val = 2, during = 3.0, effect = nil },
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.knocking", odds = 100, percent = 100, effect = nil },
--        { on = CONST_EVENT.skill, action = "targetUnit.spec.violence", odds = 100, percent = 100, effect = nil },
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.split", odds = 100, percent = {30,50}, radius = 250 },
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.swim",odds = 0.0, val = 0.0, during = 0.0, effect = nil},
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.broken",odds = 0.0, val = 0.0, effect = nil},
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.silent",odds = 0.0, val = 0.0, during = 0.0, effect = nil},
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.unarm",odds = 0.0, val = 0.0, during = 0.0, effect = nil},
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.fetter",odds = 0.0, val = 0.0, during = 0.0, effect = nil},
--        { on = CONST_EVENT.attack, action = "targetUnit.spec.bomb",odds = 0.0, radius = 0.0, val = 0.0, effect = nil},
--        { on = CONST_EVENT.damage, action = "targetUnit.spec.lightning_chain", odds = 50, val = 100, qty = 0, rate = 0.0 },
--        { on = CONST_EVENT.beDamage, action = "sourceUnit.spec.crack_fly", odds = 50, val = 100, distance = 300, height = 200, during = 0.5 },
--        { on = CONST_EVENT.attack, action = "sourceUnit.spec.paw", odds = 50, val = 'damage', effect = 'Abilities\\Weapons\\GargoyleMissile\\GargoyleMissile.mdl', radius = 50, odds = 50, speed = 10, deg = 30, distance = 500, qty = 3 },
--      }
--    },
--  })
---@private
hattribute.xtras = function(triggerUnit, eventKey, evtData)
    if (triggerUnit == nil or eventKey == nil or evtData == nil) then
        return
    end
    -- 排除不支持的事件
    if (table.includes(hattribute.xtrasSupportEvents, eventKey) == false) then
        return
    end
    -- 排除非单位
    if (hunit.getName(triggerUnit) == nil) then
        return
    end
    -- 排除死亡单位，删除单位
    if (his.dead(triggerUnit) or his.deleted(triggerUnit)) then
        return
    end
    -- 获取属性
    local xtras = hattribute.getXtras(triggerUnit, eventKey)
    if (#xtras <= 0) then
        xtras = nil
        return
    end
    -- 分析默认伤害来源
    for _, x in ipairs(xtras) do
        local actions = string.explode('.', x.action)
        if (#actions == 3) then
            local target = actions[1]
            local actionType = actions[2]
            if (table.includes({ 'attr', 'spec' }, actionType) ~= false and evtData[target] ~= nil and hunit.getName(evtData[target]) ~= nil) then
                if (his.deleted(evtData[target]) == false and hattribute.xtrasPassAlive(evtData[target], actions[2], actions[3])) then
                    local targetUnit = evtData[target]
                    local actionField = actions[3]
                    local val = 0
                    local percent = x.percent or 100
                    -- 处理数值
                    if (type(x.val) == 'number') then
                        val = math.round(x.val)
                    elseif (type(x.val) == 'string') then
                        local xVal = x.val
                        local isNegative = (string.sub(xVal, 1, 1) == '-')
                        if (isNegative) then
                            xVal = string.sub(xVal, 2)
                        end
                        if (xVal == 'damage') then
                            val = evtData.damage or 0
                        else
                            local valAttr = string.explode('.', xVal)
                            if (#valAttr == 2) then
                                local au = evtData[valAttr[1]]
                                local aa = valAttr[2]
                                if (au and table.includes(hattribute.xtrasSupportVals, aa)) then
                                    if (aa == 'level') then
                                        val = hhero.getCurLevel(au)
                                    elseif (aa == 'gold') then
                                        val = hplayer.getGold(hunit.getOwner(au))
                                    elseif (aa == 'lumber') then
                                        val = hplayer.getLumber(hunit.getOwner(au))
                                    else
                                        val = hattribute.get(au, aa)
                                    end
                                end
                            end
                        end
                        if (isNegative) then
                            val = -val
                        end
                    end
                    -- 处理百分比
                    if (type(percent) == 'table') then
                        percent = math.random(percent[1] or 0, percent[2] or 0)
                    end
                    if (percent < 0) then
                        percent = 0
                    end
                    val = math.round(val * percent * 0.01)
                    if (actionType == 'attr') then
                        -- 属性改动
                        if (val ~= 0 and (x.during or 0) > 0 and math.random(1, 1000) <= (x.odds or 0) * 10) then
                            -- 判断是否buff/debuff(判断基准就是判断val是否大于/小于0)
                            -- buff时，要计算目标单位的buff阻碍（如:可以设计一个boss造成强化阻碍，影响玩家的被动加成）
                            -- debuff时，要计算目标单位的debuff抵抗（如:可以设计一个物品抵抗debuff，减少影响）
                            -- 以上两个都是大于0才有效
                            if (val > 0) then
                                -- buff; > 0
                                local buff_oppose = hattribute.get(targetUnit, 'buff_oppose')
                                if (buff_oppose > 0) then
                                    val = val * (1 - 0.01 * buff_oppose)
                                end
                                if (val > 0) then
                                    hattribute.set(targetUnit, x.during, { [actionField] = "+" .. val })
                                    if (type(x.effect) == "string" and string.len(x.effect) > 0) then
                                        heffect.bindUnit(x.effect, targetUnit, "origin", x.during)
                                    end
                                end
                            else
                                -- debuff; < 0
                                local debuff_oppose = hattribute.get(targetUnit, 'debuff_oppose')
                                if (debuff_oppose > 0) then
                                    val = val * (1 - 0.01 * debuff_oppose)
                                end
                                if (val < 0) then
                                    hattribute.set(targetUnit, x.during, { [actionField] = tostring(val) })
                                    if (type(x.effect) == "string" and string.len(x.effect) > 0) then
                                        heffect.bindUnit(x.effect, targetUnit, "origin", x.during)
                                    end
                                end
                            end
                        end
                    elseif (actionType == 'spec') then
                        -- 特殊效果
                        if ((x.odds or 0) > 0) then
                            local damageSrc = x.damageSrc or CONST_DAMAGE_SRC.unknown
                            local damageType = x.damageType or { CONST_DAMAGE_TYPE.common }
                            if (val >= 0) then
                                if (actionField == "knocking") then
                                    -- 额外暴击；已不分物理还是魔法，触发方式是自定义的
                                    hskill.knocking({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        percent = 100,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = x.damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "split") then
                                    --分裂
                                    hskill.split({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        percent = 100,
                                        radius = x.radius,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "broken") then
                                    --打断
                                    hskill.broken({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "swim") then
                                    --眩晕
                                    hskill.swim({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        during = x.during,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "silent") then
                                    --沉默
                                    hskill.silent({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        during = x.during,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "unarm") then
                                    --缴械
                                    hskill.unarm({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        during = x.during,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "fetter") then
                                    --定身
                                    hskill.fetter({
                                        targetUnit = targetUnit,
                                        odds = x.odds,
                                        damage = val,
                                        during = x.during,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "bomb") then
                                    --爆破
                                    hskill.bomb({
                                        odds = x.odds,
                                        damage = val,
                                        radius = x.radius,
                                        targetUnit = targetUnit,
                                        sourceUnit = triggerUnit,
                                        effect = x.effect,
                                        effectEnum = x.effectEnum,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "lightning_chain") then
                                    --闪电链
                                    hskill.lightningChain({
                                        odds = x.odds,
                                        damage = val,
                                        lightningType = x.lightning_type,
                                        qty = x.qty,
                                        rate = x.rate,
                                        radius = x.radius or 500,
                                        effect = x.effect,
                                        isRepeat = false,
                                        targetUnit = targetUnit,
                                        prevUnit = triggerUnit,
                                        sourceUnit = triggerUnit,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "crack_fly") then
                                    --击飞
                                    hskill.crackFly({
                                        odds = x.odds,
                                        damage = val,
                                        targetUnit = targetUnit,
                                        sourceUnit = triggerUnit,
                                        distance = x.distance,
                                        height = x.height,
                                        during = x.during,
                                        effect = x.effect,
                                        damageType = damageType,
                                        damageSrc = damageSrc,
                                        isFixed = true,
                                    })
                                elseif (actionField == "paw") then
                                    --支线冲击效果，只支持token箭矢对坐标形式
                                    if (math.random(1, 1000) <= x.odds * 10) then
                                        local pxy = math.polarProjection(
                                            hunit.x(triggerUnit), hunit.y(triggerUnit),
                                            x.distance or 300,
                                            math.getDegBetweenUnit(triggerUnit, targetUnit)
                                        )
                                        hskill.leapPaw({
                                            tokenArrow = x.effect,
                                            tokenArrowHeight = x.tokenArrowHeight or 0,
                                            qty = x.qty or 1,
                                            deg = x.deg or 15,
                                            speed = x.speed or 8,
                                            height = x.height or 0,
                                            shake = x.shake or 0,
                                            acceleration = x.acceleration or 0,
                                            damageMovementRadius = x.radius or 50,
                                            damageMovement = val,
                                            damageMovementRepeat = false,
                                            damageType = damageType,
                                            damageSrc = damageSrc,
                                            sourceUnit = triggerUnit,
                                            x = pxy.x,
                                            y = pxy.y,
                                            isFixed = true,
                                            filter = function(filterUnit)
                                                return (his.enemy(filterUnit, triggerUnit) and his.alive(filterUnit) and (false == his.structure(filterUnit)))
                                            end
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end