---@private
F6V_I_SYNTHESIS = function(formula)
    local formulas = {}
    for _, v in ipairs(formula) do
        local profit = ''
        local fragment = {}
        if (type(v) == 'string') then
            local f1 = string.explode('=', v)
            if (string.strpos(f1[1], 'x') == false) then
                profit = { f1[1], 1 }
            else
                local temp = string.explode('x', f1[1])
                temp[2] = math.floor(temp[2])
                profit = temp
            end
            local f2 = string.explode('+', f1[2])
            for _, vv in ipairs(f2) do
                if (string.strpos(vv, 'x') == false) then
                    table.insert(fragment, { vv, 1 })
                else
                    local temp = string.explode('x', vv)
                    temp[2] = math.floor(temp[2])
                    table.insert(fragment, temp)
                end
            end
        elseif (type(v) == 'table') then
            profit = v[1]
            for vi = 2, #v, 1 do
                table.insert(fragment, v[vi])
            end
        end
        table.insert(formulas, { profit = profit, fragment = fragment })
    end
    return formulas
end

local F6_RING = function(_v)
    if (_v._ring ~= nil) then
        _v._ring.effect = _v._ring.effect or nil
        _v._ring.effectTarget = _v._ring.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
        _v._ring.attach = _v._ring.attach or "origin"
        _v._ring.attachTarget = _v._ring.attachTarget or "origin"
        _v._ring.radius = _v._ring.radius or 600
        -- target请参考物编的目标允许
        local target
        if (type(_v._ring.target) == 'table' and #_v._ring.target > 0) then
            target = _v._ring.target
        elseif (type(_v._ring.target) == 'string' and string.len(_v._ring.target) > 0) then
            target = string.explode(',', _v._ring.target)
        else
            target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
        end
        _v._ring.target = target
    end
end

F6V_A = function(_v)
    _v._class = "ability"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    -- 处理 _ring光环
    F6_RING(_v)
    return _v
end

F6V_U = function(_v)
    _v._class = "unit"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    return _v
end

local courier_skill_ids
F6V_COURIER_SKILL = function()
    if (courier_skill_ids == nil) then
        courier_skill_ids = {}
        hslk_ability({
            _parent = "AEbl",
            _type = "courier",
            _onSkillEffect = _onSkillEffect(function(evtData)
                hevent.triggerEvent(evtData.triggerUnit, CONST_EVENT.courierBlink, evtData)
            end)
        })
        hslk_ability({
            _parent = "ANcl",
            _type = "courier",
            _onSkillEffect = _onSkillEffect(function(evtData)
                local radius = 400 --半径
                hitem.pickRound(evtData.triggerUnit, hunit.x(evtData.triggerUnit), hunit.y(evtData.triggerUnit), radius)
                hevent.triggerEvent(evtData.triggerUnit, CONST_EVENT.courierRangePickUp, {
                    triggerUnit = evtData.triggerUnit,
                    triggerSkill = evtData.triggerSkill,
                    radius = radius
                })
            end)
        })
        hslk_ability({
            _parent = "ANtm",
            _type = "courier",
            _onSkillEffect = _onSkillEffect(function(evtData)
                local it = evtData.targetItem
                local triggerUnit = evtData.triggerUnit
                local p = hunit.getOwner(triggerUnit)
                if (it == nil) then
                    echo("物品不存在", p)
                    return
                end
                if (hitem.isRobber(it, triggerUnit)) then
                    echo("物品不属于你", p)
                    return
                end
                local itemId = hitem.getId(it)
                if (hitem.isShadowBack(itemId)) then
                    itemId = hitem.shadowID(itemId)
                end
                local charges = hitem.getCharges(it)
                local formulas = HSLK_SYNTHESIS.profit[itemId]
                local allowFormulaIndex = {}
                if (formulas ~= nil) then
                    for fi, f in ipairs(formulas) do
                        if (charges >= f.qty) then
                            table.insert(allowFormulaIndex, fi)
                        end
                    end
                end
                local buttons = {}
                if (charges > 1) then
                    table.insert(buttons, { value = 0, label = hcolor.gold(hitem.getName(it) .. "x" .. charges) })
                end
                if (#allowFormulaIndex > 0) then
                    for ai, a in ipairs(allowFormulaIndex) do
                        local txt = {}
                        for _, frag in ipairs(formulas[a].fragment) do
                            table.insert(txt, hitem.getName(it) .. 'x' .. frag[2] * charges)
                        end
                        table.insert(buttons, { value = ai, label = hcolor.gold(string.implode('+', txt)) })
                    end
                end
                if (#buttons < 1) then
                    echo("物品无法拆分", p)
                    return
                end
                if (#buttons == 1) then
                    local err
                    local btnValue = buttons[1].value
                    if (btnValue == 0) then
                        err = hitem.separate(it, 'single', 0, triggerUnit)
                    else
                        err = hitem.separate(it, 'formula', btnValue, triggerUnit)
                    end
                    if (err ~= nil) then
                        echo(err, p)
                        return
                    end
                    hevent.triggerEvent(triggerUnit, CONST_EVENT.courierSeparate, {
                        triggerUnit = triggerUnit,
                        triggerSkill = evtData.triggerSkill,
                        triggerItemId = itemId,
                    })
                else
                    hdialog.create(p, { title = "拆分成", buttons = buttons }, function(btnValue)
                        local err
                        if (btnValue == 0) then
                            err = hitem.separate(it, 'single', 0, triggerUnit)
                        else
                            err = hitem.separate(it, 'formula', btnValue, triggerUnit)
                        end
                        if (err ~= nil) then
                            echo(err, p)
                            return
                        end
                        hevent.triggerEvent(triggerUnit, CONST_EVENT.courierSeparate, {
                            triggerUnit = triggerUnit,
                            triggerSkill = evtData.triggerSkill,
                            triggerItemId = itemId,
                        })
                    end)
                end
            end)
        })
        hslk_ability({
            _parent = "ANcl",
            _type = "courier",
            _onSkillEffect = _onSkillEffect(function(evtData)
                local triggerUnit = evtData.triggerUnit
                local p = hunit.getOwner(triggerUnit)
                local pIndex = hplayer.index(p)
                if (hhero.player_heroes[pIndex] == nil or #hhero.player_heroes[pIndex] <= 0) then
                    echo("你没有英雄", p)
                    return
                end
                local items = {}
                hitem.forEach(triggerUnit, function(slotItem)
                    table.insert(items, slotItem)
                end)
                if (#items <= 0) then
                    echo("没有物品可传递", p)
                    return
                end
                if (#hhero.player_heroes[pIndex] == 1) then
                    local hero = hhero.player_heroes[pIndex][1] or nil
                    if (hero == nil or false == his.alive(hero) or true == his.deleted(hero)) then
                        echo("英雄不存在", p)
                        return
                    end
                    hitem.synthesis(hero, items)
                    hevent.triggerEvent(triggerUnit, CONST_EVENT.courierDeliver, {
                        triggerUnit = triggerUnit,
                        triggerSkill = evtData.triggerSkill,
                        targetUnit = hero,
                    })
                else
                    local buttons = {}
                    for hi, h in ipairs(hhero.player_heroes[pIndex]) do
                        table.insert(buttons, { value = hi, label = hunit.getName(h) })
                    end
                    hdialog.create(p, { title = "给谁?", buttons = buttons }, function(btnValue)
                        local hero = hhero.player_heroes[pIndex][btnValue] or nil
                        if (hero == nil or false == his.alive(hero) or true == his.deleted(hero)) then
                            echo("英雄不存在", p)
                            return
                        end
                        hitem.synthesis(hero, items)
                        hevent.triggerEvent(triggerUnit, CONST_EVENT.courierDeliver, {
                            triggerUnit = triggerUnit,
                            triggerSkill = evtData.triggerSkill,
                            targetUnit = hero,
                        })
                    end)
                end
            end)
        })
    end
    return courier_skill_ids
end

F6V_I_CD = function(_v)
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    local cdID
    local ad = {}
    if (_v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

F6V_I_SHADOW = function(_v)
    _v._parent = "gold"
    _v._class = "item"
    _v._type = "shadow"
    return _v
end

F6V_I = function(_v)
    _v._class = "item"
    _v._type = _v._type or "common"
    if (_v._cooldown ~= nil) then
        F6V_I_CD(_v)
    end
    if (_v._parent == nil) then
        if (_v.class == "Charged") then
            _v._parent = "hlst"
        elseif (_v.class == "PowerUp") then
            _v._parent = "gold"
        else
            _v._parent = "rat9"
        end
    end
    -- 处理 _ring光环
    F6_RING(_v)
    if (_v._overlie == nil or _v._overlie < (_v.uses or 1)) then
        _v._overlie = _v.uses or 1
    end
    return _v
end

F6V_B = function(_v)
    _v._class = "buff"
    _v._type = _v._type or "common"
    return _v
end

F6V_UP = function(_v)
    _v._class = "upgrade"
    _v._type = _v._type or "common"
    return _v
end
