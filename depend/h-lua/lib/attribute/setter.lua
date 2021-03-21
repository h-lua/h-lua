---@class hattributeSetter 属性配置法
hattributeSetter = {
    smart = {
        attack_space = "attack_space_origin",
        attack = "attack_green",
        defend = "defend_green",
        str = "str_green",
        agi = "agi_green",
        int = "int_green",
    },
}

--- @private
hattributeSetter.getDecimalTemporaryStorage = function(whichUnit, attr)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    return diff[attr] or 0
end

--- @private
hattributeSetter.setDecimalTemporaryStorage = function(whichUnit, attr, value)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    diff[attr] = math.round(value)
    hcache.set(whichUnit, CONST_CACHE.ATTR_DEC_TEM, diff)
end

--- 为单位注册属性系统所需要的基础技能
--- hslk.attr
---@private
hattributeSetter.relyRegister = function(whichUnit)
    for _, v in ipairs(HL_ID.ablis_gradient) do
        if (false == hjapi.check()) then
            -- 生命
            cj.UnitAddAbility(whichUnit, HL_ID.life.add[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.life.add[v])
            cj.UnitAddAbility(whichUnit, HL_ID.life.sub[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.life.sub[v])
            -- 魔法
            cj.UnitAddAbility(whichUnit, HL_ID.mana.add[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.mana.add[v])
            cj.UnitAddAbility(whichUnit, HL_ID.mana.sub[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.mana.sub[v])
            -- 攻击速度
            cj.UnitAddAbility(whichUnit, HL_ID.attack_speed.add[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.attack_speed.add[v])
            cj.UnitAddAbility(whichUnit, HL_ID.attack_speed.sub[v])
            cj.UnitRemoveAbility(whichUnit, HL_ID.attack_speed.sub[v])
        end
        -- 绿字攻击
        cj.UnitAddAbility(whichUnit, HL_ID.attack_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.attack_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.attack_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.attack_green.sub[v])
        -- 绿色属性
        cj.UnitAddAbility(whichUnit, HL_ID.str_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.str_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.str_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.str_green.sub[v])
        cj.UnitAddAbility(whichUnit, HL_ID.agi_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.agi_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.agi_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.agi_green.sub[v])
        cj.UnitAddAbility(whichUnit, HL_ID.int_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.int_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.int_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.int_green.sub[v])
        -- 防御
        cj.UnitAddAbility(whichUnit, HL_ID.defend.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.defend.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.defend.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.defend.sub[v])
    end
    for _, v in ipairs(HL_ID.sight_gradient) do
        -- 视野
        cj.UnitAddAbility(whichUnit, HL_ID.sight.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.sight.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.sub[v])
    end
end

--- 为单位添加N个同样的生命魔法技能 1级设0 2级设负 负减法（搜[卡血牌bug]，了解原理）
---@private
hattributeSetter.relyLifeMana = function(u, abilityId, qty)
    if (qty <= 0) then
        return
    end
    local i = 1
    while (i <= qty) do
        cj.UnitAddAbility(u, abilityId)
        cj.SetUnitAbilityLevel(u, abilityId, 2)
        cj.UnitRemoveAbility(u, abilityId)
        i = i + 1
    end
end

--- 为单位添加N个同样的攻击之书
---@private
hattributeSetter.relyAttackWhite = function(u, itemId, qty)
    if (u == nil or itemId == nil or qty <= 0) then
        return
    end
    if (his.alive(u) == true) then
        local i = 1
        local it
        local hasSlot = (cj.GetUnitAbilityLevel(u, HL_ID.ability_item_slot) >= 1)
        if (hasSlot == false) then
            cj.UnitAddAbility(u, HL_ID.ability_item_slot)
        end
        while (i <= qty) do
            it = cj.CreateItem(itemId, 0, 0)
            cj.UnitAddItem(u, it)
            cj.SetWidgetLife(it, 10.00)
            cj.RemoveItem(it)
            it = nil
            i = i + 1
        end
        if (hasSlot == false) then
            cj.UnitRemoveAbility(u, HL_ID.ability_item_slot)
        end
    else
        local per = 3.00
        local limit = 60.0 / per -- 一般不会超过1分钟复活
        htime.setInterval(per, function(t)
            limit = limit - 1
            if (limit < 0) then
                htime.delTimer(t)
            elseif (his.alive(u) == true) then
                htime.delTimer(t)
                local i = 1
                local it
                local hasSlot = (cj.GetUnitAbilityLevel(u, HL_ID.ability_item_slot) >= 1)
                if (hasSlot == false) then
                    cj.UnitAddAbility(u, HL_ID.ability_item_slot)
                end
                while (i <= qty) do
                    it = cj.CreateItem(itemId, 0, 0)
                    cj.UnitAddItem(u, it)
                    cj.SetWidgetLife(it, 10.00)
                    cj.RemoveItem(it)
                    i = i + 1
                end
                if (hasSlot == false) then
                    cj.UnitRemoveAbility(u, HL_ID.ability_item_slot)
                end
            end
        end)
    end
end

--- hSlk形式的设置最大生命值
---@private
hattributeSetter.setUnitMaxLife = function(whichUnit, currentVal, futureVal, diff)
    local level = 0
    if (futureVal >= 999999999) then
        if (currentVal >= 999999999) then
            diff = 0
        else
            diff = 999999999 - currentVal
        end
    elseif (futureVal <= 1) then
        if (currentVal <= 1) then
            diff = 0
        else
            diff = 1 - currentVal
        end
    end
    local tempVal = math.floor(math.abs(diff))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyLifeMana(whichUnit, HL_ID.life.add[max], level)
            else
                hattributeSetter.relyLifeMana(whichUnit, HL_ID.life.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置最大魔法值
---@private
hattributeSetter.setUnitMaxMana = function(whichUnit, currentVal, futureVal, diff)
    local level = 0
    if (futureVal >= 999999999) then
        if (currentVal >= 999999999) then
            diff = 0
        else
            diff = 999999999 - currentVal
        end
    elseif (futureVal <= 1) then
        if (currentVal <= 1) then
            diff = 0
        else
            diff = 1 - currentVal
        end
    end
    local tempVal = math.floor(math.abs(diff))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyLifeMana(whichUnit, HL_ID.mana.add[max], level)
            else
                hattributeSetter.relyLifeMana(whichUnit, HL_ID.mana.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置白字攻击
---@private
hattributeSetter.setUnitAttackWhite = function(whichUnit, futureVal, diff)
    local max = 100000000
    if (futureVal > max or futureVal < -max) then
        diff = 0
    end
    local tempVal = math.floor(math.abs(diff))
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyAttackWhite(whichUnit, HL_ID.item_attack_white.add[max], level)
            else
                hattributeSetter.relyAttackWhite(whichUnit, HL_ID.item_attack_white.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置绿字攻击
---@private
hattributeSetter.setUnitAttackGreen = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        local ab = HL_ID.attack_green.add[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
        ab = HL_ID.attack_green.sub[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
    end
    local tempVal = math.floor(math.abs(futureVal))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (futureVal > 0) then
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_green.add[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[max], level + 1)
            else
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_green.sub[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[max], level + 1)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置攻击速度
---@private
hattributeSetter.setUnitAttackSpeed = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        local ab = HL_ID.attack_speed.add[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
        ab = HL_ID.attack_speed.sub[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
    end
    local tempVal = math.floor(math.abs(futureVal))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (futureVal > 0) then
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_speed.add[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_speed.add[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_speed.add[max], level + 1)
            else
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_speed.sub[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_speed.sub[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_speed.sub[max], level + 1)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置绿字护甲
---@private
hattributeSetter.setUnitDefendGreen = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        local ab = HL_ID.defend.add[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
        ab = HL_ID.defend.sub[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
    end
    local tempVal = math.floor(math.abs(futureVal))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (futureVal > 0) then
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.defend.add[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.defend.add[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.defend.add[max], level + 1)
            else
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.defend.sub[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.defend.sub[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.defend.sub[max], level + 1)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置视野
---@private
hattributeSetter.setUnitSight = function(whichUnit, futureVal)
    for _, gradient in ipairs(HL_ID.sight_gradient) do
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.add[gradient])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.sub[gradient])
    end
    local tempVal = math.floor(math.abs(futureVal))
    local sight_gradient = table.clone(HL_ID.sight_gradient)
    if (tempVal ~= 0) then
        while (true) do
            local found = false
            for _, v in ipairs(sight_gradient) do
                if (tempVal >= v) then
                    tempVal = math.floor(tempVal - v)
                    table.delete(sight_gradient, v)
                    if (futureVal > 0) then
                        cj.UnitAddAbility(whichUnit, HL_ID.sight.add[v])
                    else
                        cj.UnitAddAbility(whichUnit, HL_ID.sight.sub[v])
                    end
                    found = true
                    break
                end
            end
            if (found == false) then
                break
            end
        end
    end
end

--- hSlk形式的设置白绿三围属性
---@private
hattributeSetter.setUnitThree = function(whichUnit, futureVal, attr, diff)
    if (false == his.hero(whichUnit)) then
        return
    end
    local thumb = string.sub(attr, 1, 3)
    if (attr == "str_white") then
        cj.SetHeroStr(whichUnit, math.floor(futureVal), true)
    elseif (attr == "agi_white") then
        cj.SetHeroAgi(whichUnit, math.floor(futureVal), true)
    elseif (attr == "int_white") then
        cj.SetHeroInt(whichUnit, math.floor(futureVal), true)
    else
        if (futureVal < -99999999) then
            futureVal = -99999999
        elseif (futureVal > 99999999) then
            futureVal = 99999999
        end
        for _, grad in ipairs(HL_ID.ablis_gradient) do
            local ab = HL_ID[attr].add[grad]
            if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                cj.SetUnitAbilityLevel(whichUnit, ab, 1)
            end
            ab = HL_ID[attr].sub[grad]
            if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                cj.SetUnitAbilityLevel(whichUnit, ab, 1)
            end
        end
        local tempVal = math.floor(math.abs(futureVal))
        local max = 100000000
        if (tempVal ~= 0) then
            while (max >= 1) do
                local level = math.floor(tempVal / max)
                tempVal = math.floor(tempVal - level * max)
                if (futureVal > 0) then
                    if (cj.GetUnitAbilityLevel(whichUnit, HL_ID[attr].add[max]) < 1) then
                        cj.UnitAddAbility(whichUnit, HL_ID[attr].add[max])
                    end
                    cj.SetUnitAbilityLevel(whichUnit, HL_ID[attr].add[max], level + 1)
                else
                    if (cj.GetUnitAbilityLevel(whichUnit, HL_ID[attr].sub[max]) < 1) then
                        cj.UnitAddAbility(whichUnit, HL_ID[attr].sub[max])
                    end
                    cj.SetUnitAbilityLevel(whichUnit, HL_ID[attr].sub[max], level + 1)
                end
                max = math.floor(max / 10)
            end
        end
    end
    -- 主属性影响(<= 0自动忽略)
    if (hattribute.THREE_BUFF.primary > 0) then
        if (string.upper(thumb) == hhero.getPrimary(whichUnit)) then
            hattribute.set(whichUnit, 0, { attack_white = "+" .. diff * hattribute.THREE_BUFF.primary })
        end
    end
    -- 三围影响
    if (hattribute.THREE_BUFF[thumb] ~= nil) then
        local three = table.obj2arr(hattribute.THREE_BUFF[thumb], CONST_ATTR_KEYS)
        for _, d in ipairs(three) do
            local tempV = diff * d.value
            if (tempV < 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
            elseif (tempV > 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
            end
        end
    end
end