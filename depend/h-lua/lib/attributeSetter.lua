---@class hattributeSetter 属性配置法
hattributeSetter = {}

--- 转换
hattributeSetter.smart = {
    attack_space = "attack_space_origin",
    attack = "attack_green",
    defend = "defend_green",
    str = "str_green",
    agi = "agi_green",
    int = "int_green",
}

---@protected
function hattributeSetter.getDecimalTemporaryStorage(whichUnit, attr)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    return diff[attr] or 0
end

---@protected
function hattributeSetter.setDecimalTemporaryStorage(whichUnit, attr, value)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    diff[attr] = math.round(value)
    hcache.set(whichUnit, CONST_CACHE.ATTR_DEC_TEM, diff)
end

--- 为单位注册属性系统所需要的基础技能
---@protected
function hattributeSetter.relyRegister(whichUnit)
    for _, v in ipairs(HL_ID.ablis_gradient) do
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
end

--- hSlk形式的设置最大生命值
---@protected
function hattributeSetter.setUnitMaxLife(whichUnit, futureVal)
    if (futureVal >= 999999999) then
        futureVal = 999999999
    elseif (futureVal < 1) then
        futureVal = 1
    end
    local cur = math.max(0, hunit.getCurLife(whichUnit))
    local max = hunit.getMaxLife(whichUnit)
    if (max <= 0) then
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_LIFE, futureVal)
    else
        local percent = math.min(1, math.round(cur / max))
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_LIFE, futureVal * percent)
    end
end

--- hSlk形式的设置最大魔法值
---@protected
function hattributeSetter.setUnitMaxMana(whichUnit, futureVal)
    if (futureVal >= 999999999) then
        futureVal = 999999999
    elseif (futureVal < 1) then
        futureVal = 1
    end
    local cur = math.max(0, hunit.getCurMana(whichUnit))
    local max = hunit.getMaxMana(whichUnit)
    if (max <= 0) then
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MANA, futureVal)
    else
        local percent = math.min(1, math.round(cur / max))
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MANA, futureVal * percent)
    end
end

--- hSlk形式的设置白字攻击
---@protected
function hattributeSetter.setUnitAttackWhite(whichUnit, futureVal, diff)
    local max = 100000000
    if (futureVal > max) then
        futureVal = max
        diff = 0
    elseif (futureVal < -max) then
        futureVal = -max
        diff = 0
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_WHITE, futureVal)
end

--- hSlk形式的设置绿字攻击
---@protected
function hattributeSetter.setUnitAttackGreen(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[grad]) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[grad], 1)
        end
        if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[grad]) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[grad], 1)
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

--- JAPI形式的设置攻击范围
---@protected
function hattributeSetter.setUnitAttackRange(whichUnit, futureVal)
    if (futureVal < 0) then
        futureVal = 0
    elseif (futureVal > 9999) then
        futureVal = 9999
    end
    return hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_RANGE, futureVal)
end

--- JAPI形式的设置攻击间隔
---@protected
function hattributeSetter.setUnitAttackSpace(whichUnit, futureVal)
    if (futureVal > 30) then
        futureVal = 30.00
    elseif (futureVal < 0.1) then
        futureVal = 0.1
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_SPACE, futureVal)
end

--- JAPI+hSlk设置单位的攻击速度
---@protected
function hattributeSetter.setUnitAttackSpeed(whichUnit, futureVal)
    if (futureVal > 400) then
        futureVal = 400
    elseif (futureVal < -80) then
        futureVal = -80
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_SPEED, 1 + futureVal * 0.01)
end

--- JAPI形式的设置白字护甲
---@protected
function hattributeSetter.setUnitDefendWhite(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    local defend_green = hattribute.get(whichUnit, 'defend_green')
    hjapi.SetUnitState(whichUnit, UNIT_STATE_DEFEND_WHITE, futureVal + defend_green)
end

--- hSlk形式的设置绿字护甲
---@protected
function hattributeSetter.setUnitDefendGreen(whichUnit, futureVal)
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

--- hSlk形式的设置白绿三围属性
---@protected
function hattributeSetter.setUnitThree(whichUnit, futureVal, attr)
    if (false == hunit.isHero(whichUnit)) then
        return
    end
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
end

---@protected
function hattributeSetter.relation(whichUnit, attr, diff)
    local three --三围标志
    if (table.includes({ "str_white", "agi_white", "int_white", "str_green", "agi_green", "int_green" }, attr)) then
        three = string.sub(attr, 1, 3)
    end
    if (three ~= nil and hunit.isHero(whichUnit)) then
        -- 主属性影响(<= 0自动忽略)
        if ((hattribute.RELATION.primary or 0) > 0) then
            if (string.upper(three) == hhero.getPrimary(whichUnit)) then
                hattribute.set(whichUnit, 0, { attack_white = "+" .. diff * hattribute.RELATION.primary })
            end
        end
        -- 三围影响
        if (hattribute.RELATION[three] ~= nil) then
            for _, d in ipairs(table.obj2arr(hattribute.RELATION[three], CONST_ATTR_KEYS)) do
                local tempV = diff * d.value
                if (tempV < 0) then
                    hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
                elseif (tempV > 0) then
                    hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
                end
            end
        end
    end
    -- 自定义属性影响
    if (type(hattribute.RELATION[attr]) == "table") then
        for _, d in ipairs(table.obj2arr(hattribute.RELATION[attr], CONST_ATTR_KEYS)) do
            local tempV = diff * d.value
            if (tempV < 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
            elseif (tempV > 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
            end
        end
    end
end

--- 为单位初始化属性系统的对象数据
--- @private
function hattributeSetter.init(whichUnit)
    local uid = hunit.getId(whichUnit)
    if (uid == nil or hunit.isDestroyed(whichUnit)) then
        return false
    end
    -- init
    local uSlk = hslk.i2v(uid, "slk")
    local attribute = {
        primary = uSlk.Primary or "STR",
        life = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE),
        mana = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_MANA),
        move = cj.GetUnitDefaultMoveSpeed(whichUnit),
        defend_white = hjapi.GetUnitState(whichUnit, UNIT_STATE_DEFEND_WHITE),
        attack_range = 100,
        attack_range_acquire = 100,
        attack_sides = hunit.getAttackSides1(whichUnit),
    }
    if (uSlk.dmgplus1) then
        attribute.attack_white = math.floor(uSlk.dmgplus1)
    end
    if (uSlk.rangeN1) then
        attribute.attack_range = math.floor(uSlk.rangeN1)
    end
    if (uSlk.acquire) then
        attribute.attack_range_acquire = math.floor(uSlk.acquire)
    end
    if ((uSlk.weapsOn == "1" or uSlk.weapsOn == "3") and uSlk.cool1) then
        attribute.attack_space_origin = math.round(uSlk.cool1)
    elseif ((uSlk.weapsOn == "2") and uSlk.cool2) then
        attribute.attack_space_origin = math.round(uSlk.cool2)
    end
    attribute.attack = attribute.attack_white
    attribute.defend = attribute.defend_white
    attribute.attack_space = attribute.attack_space_origin
    for _, v in ipairs(CONST_ATTR_CONF) do
        if (attribute[v[1]] == nil) then
            if (type(v[3]) == "table") then
                attribute[v[1]] = table.clone(v[3])
            else
                attribute[v[1]] = v[3] or 0
            end
        end
    end
    -- 初始化数据
    hcache.set(whichUnit, CONST_CACHE.ATTR, attribute)
    return true
end

--- 判断是否某种类型的数值设定
---@param field string attribute
---@param valType table VAL_TYPE.?
---@return boolean
function hattributeSetter.isValType(field, valType)
    if (field == nil or valType == nil) then
        return false
    end
    if (table.includes(valType, field)) then
        return true
    end
    return false
end


-- 设定属性
--[[
    白字攻击 绿字攻击 攻击间隔
    攻速 攻击范围 主动攻击范围
    力敏智 力敏智(绿)
    白字护甲 绿字护甲
    生命 魔法 +恢复
    移动力 ?率
    type(data) == table
    data = { 支持 加/减/乘/除/等
        life = '+100',
        mana = '-100',
        life_back = '*100',
        mana_back = '/100',
        move = '=100',
    }
    during = 0.0 大于0生效；小于等于0时无限持续时间
]]
--- @private
--- @return Timer|nil
function hattributeSetter.setHandle(whichUnit, attr, opr, val, during)
    local valType = type(val)
    local params = hattribute.get(whichUnit)
    if (params == nil) then
        return
    end
    if (params[attr] == nil) then
        return
    end
    -- 机智转接 smart link~
    if (hattributeSetter.smart[attr] ~= nil) then
        attr = hattributeSetter.smart[attr]
    end
    local buffTimer
    local diff = 0
    if (valType == "number") then
        if (opr == "+") then
            diff = val
        elseif (opr == "-") then
            diff = -val
        elseif (opr == "*") then
            diff = params[attr] * val - params[attr]
        elseif (opr == "/" and val ~= 0) then
            diff = params[attr] / val - params[attr]
        elseif (opr == "=") then
            diff = val - params[attr]
        end
        --部分属性取整处理，否则失真
        if (hattributeSetter.isValType(attr, hattribute.VAL_TYPE.INTEGER) and diff ~= 0) then
            local dts = hattributeSetter.getDecimalTemporaryStorage(whichUnit, attr)
            local diffI, diffF = math.modf(diff)
            local dtsI, dtsF = math.modf(dts)
            diff = diffI + dtsI
            dts = dtsF + diffF
            if (dts < 0) then
                -- 归0补正
                dts = 1 + dts
                diff = diff - 1
            elseif (math.abs(dts) >= 1) then
                -- 破1退1
                dtsI, dtsF = math.modf(dts)
                diff = diffI + dtsI
                dts = dtsF
            end
            hattributeSetter.setDecimalTemporaryStorage(whichUnit, attr, dts)
        end
        if (diff ~= 0) then
            local currentVal = params[attr]
            local futureVal = currentVal + diff
            if (during > 0) then
                local groupKey = 'attr.' .. attr .. '+'
                if (diff < 0) then
                    groupKey = 'attr.' .. attr .. '-'
                end
                params[attr] = futureVal
                buffTimer = htime.setTimeout(during, function()
                    hattributeSetter.setHandle(whichUnit, attr, "-", diff, 0)
                end)
            else
                params[attr] = futureVal
            end
            -- 关联属性
            hattributeSetter.relation(whichUnit, attr, diff)
            if (attr == "life") then
                -- 最大生命值[JAPI+]
                hattributeSetter.setUnitMaxLife(whichUnit, futureVal)
            elseif (attr == "mana") then
                -- 最大魔法值[JAPI+]
                hattributeSetter.setUnitMaxMana(whichUnit, futureVal)
            elseif (attr == "move") then
                -- 移动
                local min = math.floor(hslk.misc("Misc", "MinUnitSpeed")) or 0
                local max = math.floor(hslk.misc("Misc", "MaxUnitSpeed")) or 522
                futureVal = math.min(max, math.max(min, math.floor(futureVal)))
                cj.SetUnitMoveSpeed(whichUnit, futureVal)
            elseif (attr == "attack_space_origin") then
                -- 攻击间隔[JAPI*]
                hattributeSetter.setUnitAttackSpace(whichUnit, futureVal)
                params.attack_space = math.round(math.max(0, params.attack_space_origin) / (1 + math.min(math.max(params.attack_speed, -80), 400) * 0.01))
            elseif (attr == "attack_white") then
                -- 白字攻击[JAPI+]
                hattributeSetter.setUnitAttackWhite(whichUnit, futureVal, diff)
                params.attack = (params.attack_white or 0) + (params.attack_green or 0)
            elseif (attr == "attack_green") then
                -- 绿字攻击
                hattributeSetter.setUnitAttackGreen(whichUnit, futureVal)
                params.attack = (params.attack_white or 0) + (params.attack_green or 0)
            elseif (attr == "attack_range") then
                -- 攻击范围[JAPI]
                if (true == hattributeSetter.setUnitAttackRange(whichUnit, futureVal)) then
                    local ar = cj.GetUnitAcquireRange(whichUnit)
                    if (ar < futureVal) then
                        hattributeSetter.setHandle(whichUnit, "attack_range_acquire", "+", futureVal - ar, during)
                    end
                end
            elseif (attr == "attack_range_acquire") then
                -- 主动攻击范围
                futureVal = math.min(9999, math.max(0, math.floor(futureVal)))
                cj.SetUnitAcquireRange(whichUnit, futureVal)
            elseif (attr == "attack_speed") then
                -- 攻击速度[JAPI+]
                hattributeSetter.setUnitAttackSpeed(whichUnit, futureVal)
                params.attack_space = math.round(math.max(0, params.attack_space_origin) / (1 + math.min(math.max(params.attack_speed, -80), 400) * 0.01))
            elseif (attr == "defend_white") then
                -- 白字护甲[JAPI*]
                hattributeSetter.setUnitDefendWhite(whichUnit, futureVal)
                params.defend = math.floor((params.defend_white or 0) + (params.defend_green or 0))
            elseif (attr == "defend_green") then
                -- 绿字护甲
                hattributeSetter.setUnitDefendGreen(whichUnit, futureVal)
                params.defend = math.floor((params.defend_white or 0) + (params.defend_green or 0))
            elseif (hunit.isHero(whichUnit) and table.includes({ "str_white", "agi_white", "int_white", "str_green", "agi_green", "int_green" }, attr)) then
                -- 白/绿字力敏智
                hattributeSetter.setUnitThree(whichUnit, futureVal, attr)
                local t = string.sub(attr, 1, 3)
                params[t] = (params[t .. "_white"] or 0) + (params[t .. "_green"] or 0)
            elseif (attr == "life_back" or attr == "mana_back") then
                -- 生命,魔法恢复
                if (math.abs(futureVal) > hattribute.CURE_FLOOR) then
                    hmonitor.listen(CONST_MONITOR[string.upper(attr)], whichUnit)
                else
                    hmonitor.ignore(CONST_MONITOR[string.upper(attr)], whichUnit)
                end
            end
        end
    elseif (valType == "string") then
        -- string类型只有+-=
        if (opr == "+") then
            local valArr = string.explode(",", val)
            if (during > 0) then
                params[attr] = table.merge(params[attr], valArr)
                buffTimer = htime.setTimeout(during, function()
                    hattributeSetter.setHandle(whichUnit, attr, "-", val, 0)
                end)
            else
                params[attr] = table.merge(params[attr], valArr)
            end
        elseif (opr == "-") then
            local valArr = string.explode(",", val)
            if (during > 0) then
                for _, v in ipairs(valArr) do
                    if (table.includes(params[attr], v)) then
                        table.delete(params[attr], v, 1)
                    end
                end
                buffTimer = htime.setTimeout(during, function()
                    hattributeSetter.setHandle(whichUnit, attr, "+", val, 0)
                end)
            else
                for _, v in ipairs(valArr) do
                    if (table.includes(params[attr], v)) then
                        table.delete(params[attr], v, 1)
                    end
                end
            end
        elseif (opr == "=") then
            local old = table.clone(params[attr])
            if (during > 0) then
                params[attr] = string.explode(",", val)
                buffTimer = htime.setTimeout(during, function()
                    hattributeSetter.setHandle(whichUnit, attr, "=", string.implode(",", old), 0)
                end)
            else
                params[attr] = string.explode(",", val)
            end
        end
    end
    return buffTimer
end