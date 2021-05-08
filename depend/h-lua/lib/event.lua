hevent = {
    POOL = {},
    POOL_RED_LINE = 1000,
}

---@protected
hevent.free = function(handle)
    local poolRegister = hcache.get(handle, CONST_CACHE.EVENT_POOL)
    if (poolRegister ~= nil) then
        poolRegister:forEach(function(key, poolIndex)
            hevent.POOL[key][poolIndex].stock = hevent.POOL[key][poolIndex].stock - 1
            -- 起码利用红线1/4允许归零
            if (hevent.POOL[key][poolIndex].stock == 0 and hevent.POOL[key][poolIndex].count > 0.25 * hevent.POOL_RED_LINE) then
                cj.DisableTrigger(hevent.POOL[key][poolIndex].trigger)
                cj.DestroyTrigger(hevent.POOL[key][poolIndex].trigger)
                hevent.POOL[key][poolIndex] = -1
            end
            local e = 0
            for _, v in ipairs(hevent.POOL[key]) do
                if (v == -1) then
                    e = e + 1
                end
            end
            if (e == #hevent.POOL[key]) then
                hevent.POOL[key] = nil
            end
        end)
    end
end

--- 触发池
--- 使用一个handle，以不同的conditionAction累计计数
--- 分配触发到回调注册
--- 触发池的action是不会被同一个handle注册两次的，与on事件并不相同
---@protected
hevent.pool = function(handle, conditionAction, regEvent)
    if (type(regEvent) ~= 'function') then
        return
    end
    local key = cj.GetHandleId(conditionAction)
    -- 如果这个handle已经注册过此动作，则不重复注册
    local poolRegister = hcache.get(handle, CONST_CACHE.EVENT_POOL)
    if (poolRegister == nil) then
        poolRegister = Mapping:new()
        hcache.set(handle, CONST_CACHE.EVENT_POOL, poolRegister)
    end
    if (poolRegister:get(key) ~= nil) then
        return
    end
    if (hevent.POOL[key] == nil) then
        hevent.POOL[key] = {}
    end
    local poolIndex = #hevent.POOL[key]
    if (poolIndex <= 0 or hevent.POOL[key][poolIndex] == -1 or hevent.POOL[key][poolIndex].count >= hevent.POOL_RED_LINE) then
        local tgr = cj.CreateTrigger()
        table.insert(hevent.POOL[key], { stock = 0, count = 0, trigger = tgr })
        cj.TriggerAddCondition(tgr, conditionAction)
        poolIndex = #hevent.POOL[key]
    end
    poolRegister:set(key, poolIndex)
    hevent.POOL[key][poolIndex].count = hevent.POOL[key][poolIndex].count + 1
    hevent.POOL[key][poolIndex].stock = hevent.POOL[key][poolIndex].stock + 1
    regEvent(hevent.POOL[key][poolIndex].trigger)
end

--- set最后一位伤害的单位关系
---@protected
hevent.setLastDamage = function(sourceUnit, targetUnit)
    if (sourceUnit ~= nil) then
        hcache.set(sourceUnit, CONST_CACHE.EVENT_LAST_DMG_TARGET, targetUnit)
        hcache.set(hunit.getOwner(sourceUnit), CONST_CACHE.EVENT_LAST_DMG_TARGET_PLAYER, targetUnit)
        if (targetUnit ~= nil) then
            hcache.set(targetUnit, CONST_CACHE.EVENT_LAST_DMG_SRC, sourceUnit)
        end
    end
end

--- 最后一位伤害的单位
---@protected
hevent.getUnitLastDamageSource = function(whichUnit)
    return hcache.get(whichUnit, CONST_CACHE.EVENT_LAST_DMG_SRC)
end

--- 获取单位最后一次伤害的目标单位
---@protected
hevent.getUnitLastDamageTarget = function(whichUnit)
    return hcache.get(whichUnit, CONST_CACHE.EVENT_LAST_DMG_TARGET)
end

--- 获取玩家最后一次伤害的目标单位
---@protected
hevent.getPlayerLastDamageTarget = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.EVENT_LAST_DMG_TARGET_PLAYER)
end

--- 注册事件，会返回一个event_id（私有通用）
---@protected
hevent.registerEvent = function(handle, key, callFunc)
    local register = hcache.get(handle, CONST_CACHE.EVENT_REGISTER)
    if (register == nil) then
        register = {}
        hcache.set(handle, CONST_CACHE.EVENT_REGISTER, register)
    end
    if (register[key] == nil) then
        register[key] = {}
    end
    table.insert(register[key], callFunc)
    return #register[key]
end

--- 触发数据（私有通用）
---@protected
hevent.triggerData = function(triggerData)
    triggerData = triggerData or {}
    if (triggerData.triggerSkill ~= nil and type(triggerData.triggerSkill) == "number") then
        triggerData.triggerSkill = string.id2char(triggerData.triggerSkill)
    end
    if (triggerData.learnedSkillId ~= nil and type(triggerData.learnedSkillId) == "number") then
        triggerData.learnedSkillId = string.id2char(triggerData.learnedSkillId)
    end
    if (triggerData.triggerItem ~= nil) then
        triggerData.triggerItemId = hitem.getId(triggerData.triggerItem)
    end
    if (triggerData.targetLoc ~= nil) then
        triggerData.targetX = cj.GetLocationX(triggerData.targetLoc)
        triggerData.targetY = cj.GetLocationY(triggerData.targetLoc)
        triggerData.targetZ = cj.GetLocationZ(triggerData.targetLoc)
        cj.RemoveLocation(triggerData.targetLoc)
        triggerData.targetLoc = nil
    end
    return triggerData
end

--- 处理hslk事件（私有通用）
---@protected
hevent.hslk = function(key, triggerData)
    if (key == CONST_EVENT.skillStudy) then
        local _onSkillStudy = hslk.i2v(triggerData.learnedSkillId, "_onSkillStudy")
        if (type(_onSkillStudy) == "function") then
            _onSkillStudy(triggerData)
        end
    elseif (key == CONST_EVENT.skillEffect) then
        local _onSkillEffect = hslk.i2v(triggerData.triggerSkillId, "_onSkillEffect")
        if (type(_onSkillEffect) == "function") then
            _onSkillEffect(triggerData)
        end
    elseif (key == CONST_EVENT.itemUsed) then
        local _onItemUsed = hslk.i2v(triggerData.triggerItemId, "_onItemUsed")
        if (_onItemUsed ~= nil and type(_onItemUsed) == "function") then
            _onItemUsed(triggerData)
        end
    elseif (key == CONST_EVENT.itemGet) then
        local _onItemGet = hslk.i2v(triggerData.triggerItemId, "_onItemGet")
        if (type(_onItemGet) == "function") then
            _onItemGet(triggerData)
        end
    end
end

--- 触发事件（私有通用）
---@protected
hevent.triggerEvent = function(handle, key, triggerData)
    if (handle == nil or key == nil) then
        return
    end
    -- 数据
    triggerData = hevent.triggerData(triggerData)
    -- exec
    -- 判断事件注册执行与否
    local register = hcache.get(handle, CONST_CACHE.EVENT_REGISTER, {})
    if (register ~= nil and register[key] ~= nil and #register[key] > 0) then
        for _, callFunc in ipairs(register[key]) do
            callFunc(triggerData)
        end
    end
    -- 判断xtras执行与否
    if (hattribute.hasXtras(handle, key)) then
        hattribute.xtras(handle, key, triggerData)
    end
    -- hslk
    hevent.hslk(key, triggerData)
end

--- 删除事件（需要event_id）
---@param handle userdata
---@param key string
---@param eventId any
hevent.deleteEvent = function(handle, key, eventId)
    if (handle == nil or key == nil or eventId == nil) then
        print_stack()
        return
    end
    local register = hcache.get(handle, CONST_CACHE.EVENT_REGISTER)
    if (register == nil or register[key] == nil) then
        return
    end
    table.remove(register[key], eventId)
end

--- 注意到攻击目标
---@alias onAttackDetect fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位"}):void
---@param whichUnit userdata
---@param callFunc onAttackDetect | "function(evtData) end"
---@return any
hevent.onAttackDetect = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.attackDetect, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_ACQUIRED_TARGET)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attackDetect, callFunc)
end

--- 获取攻击目标
---@alias onAttackGetTarget fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位"}):void
---@param whichUnit userdata
---@param callFunc onAttackGetTarget | "function(evtData) end"
---@return any
hevent.onAttackGetTarget = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.attackGetTarget, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_TARGET_IN_RANGE)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attackGetTarget, callFunc)
end

--- 准备被攻击
---@alias onBeAttackReady fun(evtData: {triggerUnit:"被攻击单位",attackUnit:"攻击单位"}):void
---@param whichUnit userdata
---@param callFunc onBeAttackReady | "function(evtData) end"
---@return any
hevent.onBeAttackReady = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.beAttackReady, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_ATTACKED)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAttackReady, callFunc)
end

--- 造成攻击
---@alias onAttack fun(evtData: {triggerUnit:"攻击单位",targetUnit:"被攻击单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onAttack | "function(evtData) end"
---@return any
hevent.onAttack = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attack, callFunc)
end

--- 承受攻击
---@alias onBeAttack fun(evtData: {triggerUnit:"被攻击单位",attackUnit:"攻击单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeAttack | "function(evtData) end"
---@return any
hevent.onBeAttack = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAttack, callFunc)
end

--- 技能造成伤害
---@alias onSkill fun(evtData: {triggerUnit:"施法单位",targetUnit:"被伤害单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onSkill | "function(evtData) end"
---@return any
hevent.onSkill = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skill, callFunc)
end

--- 被技能伤害
---@alias onBeSkill fun(evtData: {triggerUnit:"被伤害单位",targetUnit:"被伤害单位",caster:"施法单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeSkill | "function(evtData) end"
---@return any
hevent.onBeSkill = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSkill, callFunc)
end

--- 学习技能
---@alias onSkillStudy fun(evtData: {triggerUnit:"学习单位",triggerSkill:"学习技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillStudy | "function(evtData) end"
---@return any
hevent.onSkillStudy = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillStudy, callFunc)
end

--- 准备施放技能
---@alias onSkillReady fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillReady | "function(evtData) end"
---@return any
hevent.onSkillReady = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillReady, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_CHANNEL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillReady, callFunc)
end

--- 开始施放技能
---@alias onSkillCast fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillCast | "function(evtData) end"
---@return any
hevent.onSkillCast = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillCast, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_CAST)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillCast, callFunc)
end

--- 停止施放技能
---@alias onSkillStop fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillStop | "function(evtData) end"
---@return any
hevent.onSkillStop = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillStop, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_ENDCAST)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillStop, callFunc)
end

--- 发动技能效果
---@alias onSkillEffect fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetItem:"获取目标物品",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillEffect | "function(evtData) end"
---@return any
hevent.onSkillEffect = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillEffect, callFunc)
end

--- 施放技能结束
---@alias onSkillFinish fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillFinish | "function(evtData) end"
---@return any
hevent.onSkillFinish = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillFinish, callFunc)
end

--- 物品造成伤害
---@alias onItem fun(evtData: {triggerUnit:"使用物品单位",targetUnit:"被伤害单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onItem | "function(evtData) end"
---@return any
hevent.onItem = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.item, callFunc)
end

--- 被物品伤害
---@alias onBeItem fun(evtData: {triggerUnit:"被伤害单位",useUnit:"使用物品单位",damage:"伤害",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeItem | "function(evtData) end"
---@return any
hevent.onBeItem = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beItem, callFunc)
end

--- 单位使用物品
---@alias onItemUsed fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onItemUsed | "function(evtData) end"
---@return any
hevent.onItemUsed = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemUsed, callFunc)
end

--- 丢弃(传递)物品
---@alias onItemDrop fun(evtData: {triggerUnit:"丢弃单位",targetUnit:"获得单位（如果有）",triggerItem:"触发物品"}):void
---@param whichUnit userdata
---@param callFunc onItemDrop | "function(evtData) end"
---@return any
hevent.onItemDrop = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemDrop, callFunc)
end

--- 获得物品
---@alias onItemGet fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品"}):void
---@param whichUnit userdata
---@param callFunc onItemGet | "function(evtData) end"
---@return any
hevent.onItemGet = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemGet, callFunc)
end

--- 抵押物品（玩家把物品扔给商店）
---@alias onItemPawn fun(evtData: {triggerUnit:"触发单位",soldItem:"抵押物品",buyingUnit:"抵押商店",soldGold:"抵押获得黄金",soldLumber:"抵押获得木头"}):void
---@param whichUnit userdata
---@param callFunc onItemPawn | "function(evtData) end"
---@return any
hevent.onItemPawn = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemPawn, callFunc)
end

--- 出售物品(商店卖给玩家)
---@alias onItemSell fun(evtData: {triggerUnit:"售卖单位",soldItem:"售卖物品",buyingUnit:"购买单位"}):void
---@param whichUnit userdata
---@param callFunc onItemSell | "function(evtData) end"
---@return any
hevent.onItemSell = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.item.sell, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SELL_ITEM)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemSell, callFunc)
end

--- 出售单位(商店卖给玩家)
---@alias onUnitSell fun(evtData: {triggerUnit:"商店单位",soldUnit:"被售卖单位",buyingUnit:"购买单位"}):void
---@param whichUnit userdata
---@param callFunc onUnitSell | "function(evtData) end"
---@return any
hevent.onUnitSell = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.sell, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SELL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.unitSell, callFunc)
end

--- 物品被破坏
---@alias onItemDestroy fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品"}):void
---@param whichItem userdata
---@param callFunc onItemDestroy | "function(evtData) end"
---@return any
hevent.onItemDestroy = function(whichItem, callFunc)
    hevent.pool(whichItem, hevent_default_actions.item.destroy, function(tgr)
        cj.TriggerRegisterDeathEvent(tgr, whichItem)
    end)
    return hevent.registerEvent(whichItem, CONST_EVENT.itemDestroy, callFunc)
end

--- 物品被拆分
---@alias onItemSeparate fun(evtData: {whichItem:"被拆分的物品",type:"拆分类型:single(单类多个)|formula(公式)",targetUnit:"绑定单位"}):void
---@param whichItem userdata
---@param callFunc onItemSeparate | "function(evtData) end"
---@return any
hevent.onItemSeparate = function(whichItem, callFunc)
    return hevent.registerEvent(whichItem, CONST_EVENT.itemSeparate, callFunc)
end

--- 物品被合成
---@alias onItemSynthesis fun(evtData: {triggerUnit:"触发单位",triggerItem:"合成物品"}):void
---@param whichUnit userdata
---@param callFunc onItemSynthesis | "function(evtData) end"
---@return any
hevent.onItemSynthesis = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemSynthesis, callFunc)
end

--- 物品超重
---@alias onItemOverWeight fun(evtData: {triggerUnit:"触发单位",triggerItem:"得到的物品",value:"超出的重量(kg)"}):void
---@param whichUnit userdata
---@param callFunc onItemOverWeight | "function(evtData) end"
---@return any
hevent.onItemOverWeight = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemOverWeight, callFunc)
end

--- 单位满格
---@alias onItemOverSlot fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发的物品"}):void
---@param whichUnit userdata
---@param callFunc onItemOverSlot | "function(evtData) end"
---@return any
hevent.onItemOverSlot = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemOverSlot, callFunc)
end

--- 造成伤害
---@alias onDamage fun(evtData: {triggerUnit:"伤害来自单位",targetUnit:"被伤害单位",damage:"伤害",damageSrc:"伤害来源",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onDamage | "function(evtData) end"
---@return any
hevent.onDamage = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.damage, callFunc)
end

--- 承受伤害
---@alias onBeDamage fun(evtData: {triggerUnit:"被伤害单位",sourceUnit:"伤害来自单位",damage:"伤害",damageSrc:"伤害来源",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeDamage | "function(evtData) end"
---@return any
hevent.onBeDamage = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beDamage, callFunc)
end

--- 极限减伤抵抗（完全减免）
---@alias onDamageResistance fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",resistance: "抵扣伤害值"}):void
---@param whichUnit userdata
---@param callFunc onDamageResistance | "function(evtData) end"
---@return any
hevent.onDamageResistance = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.damageResistance, callFunc)
end

--- 回避攻击成功
---@alias onAvoid fun(evtData: {triggerUnit:"回避的单位",attackUnit:"攻击单位"}):void
---@param whichUnit userdata
---@param callFunc onAvoid | "function(evtData) end"
---@return any
hevent.onAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.avoid, callFunc)
end

--- 攻击被回避
---@alias onBeAvoid fun(evtData: {triggerUnit:"攻击单位",avoidUnit:"回避的单位"}):void
---@param whichUnit userdata
---@param callFunc onBeAvoid | "function(evtData) end"
---@return any
hevent.onBeAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAvoid, callFunc)
end

--- 破防（护甲/魔抗）成功
---@alias onBreakArmor fun(evtData: {breakType:"无视类型",triggerUnit:"破防单位",targetUnit:"目标单位",value:"破防的数值"}):void
---@param whichUnit userdata
---@param callFunc onBreakArmor | "function(evtData) end"
---@return any
hevent.onBreakArmor = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.breakArmor, callFunc)
end

--- 被破防（护甲/魔抗）成功
---@alias onBeBreakArmor fun(evtData: {breakType:"无视类型",triggerUnit:"被破甲单位",sourceUnit:"破防单位",value:"破防的数值"}):void
---@param whichUnit userdata
---@param callFunc onBeBreakArmor | "function(evtData) end"
---@return any
hevent.onBeBreakArmor = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBreakArmor, callFunc)
end

--- 眩晕成功
---@alias onSwim fun(evtData: {triggerUnit:"触发单位",targetUnit:"被眩晕单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onSwim | "function(evtData) end"
---@return any
hevent.onSwim = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.swim, callFunc)
end

--- 被眩晕
---@alias onBeSwim fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeSwim | "function(evtData) end"
---@return any
hevent.onBeSwim = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSwim, callFunc)
end

--- 打断成功
---@alias onBroken fun(evtData: {triggerUnit:"触发单位",targetUnit:"被打断单位",odds:"几率百分比",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBroken | "function(evtData) end"
---@return any
hevent.onBroken = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.broken, callFunc)
end

--- 被打断
---@alias onBeBroken fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeBroken | "function(evtData) end"
---@return any
hevent.onBeBroken = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBroken, callFunc)
end

--- 沉默成功
---@alias onSilent fun(evtData: {triggerUnit:"触发单位",targetUnit:"被沉默单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onSilent | "function(evtData) end"
---@return any
hevent.onSilent = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.silent, callFunc)
end

--- 被沉默
---@alias onBeSilent fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeSilent | "function(evtData) end"
---@return any
hevent.onBeSilent = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSilent, callFunc)
end

--- 缴械成功
---@alias onUnarm fun(evtData: {triggerUnit:"触发单位",targetUnit:"被缴械单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onUnarm | "function(evtData) end"
---@return any
hevent.onUnarm = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.unarm, callFunc)
end

--- 被缴械
---@alias onBeUnarm fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeUnarm | "function(evtData) end"
---@return any
hevent.onBeUnarm = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beUnarm, callFunc)
end

--- 定身成功
---@alias onFetter fun(evtData: {triggerUnit:"触发单位",targetUnit:"被定身单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onFetter | "function(evtData) end"
---@return any
hevent.onFetter = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.fetter, callFunc)
end

--- 被定身
---@alias onBeFetter fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeFetter | "function(evtData) end"
---@return any
hevent.onBeFetter = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beFetter, callFunc)
end

--- 爆破成功
---@alias onBomb fun(evtData: {triggerUnit:"触发单位",targetUnit:"被爆破单位",odds:"几率百分比",radius:"爆破半径范围",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBomb | "function(evtData) end"
---@return any
hevent.onBomb = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.bomb, callFunc)
end

--- 被爆破
---@alias onBeBomb fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",radius:"爆破半径范围",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeBomb | "function(evtData) end"
---@return any
hevent.onBeBomb = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBomb, callFunc)
end

--- 闪电链成功
---@alias onLightningChain fun(evtData: {triggerUnit:"触发单位",targetUnit:"被闪电链单位",odds:"几率百分比",radius:"闪电链半径范围",damage:"伤害",index:"是第几个被电到的"}):void
---@param whichUnit userdata
---@param callFunc onLightningChain | "function(evtData) end"
---@return any
hevent.onLightningChain = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.lightningChain, callFunc)
end

--- 被闪电链
---@alias onBeLightningChain fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",radius:"闪电链半径范围",damage:"伤害",index:"是第几个被电到的"}):void
---@param whichUnit userdata
---@param callFunc onBeLightningChain | "function(evtData) end"
---@return any
hevent.onBeLightningChain = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beLightningChain, callFunc)
end

--- 击飞成功
---@alias onCrackFly fun(evtData: {triggerUnit:"触发单位",targetUnit:"被击飞单位",odds:"几率百分比",damage:"伤害",high:"击飞高度",distance:"击飞距离"}):void
---@param whichUnit userdata
---@param callFunc onCrackFly | "function(evtData) end"
---@return any
hevent.onCrackFly = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.crackFly, callFunc)
end

--- 被击飞
---@alias onBeCrackFly fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",damage:"伤害",high:"击飞高度",distance:"击飞距离"}):void
---@param whichUnit userdata
---@param callFunc onBeCrackFly | "function(evtData) end"
---@return any
hevent.onBeCrackFly = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beCrackFly, callFunc)
end

--- 反伤成功时
---@alias onRebound fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"反伤伤害"}):void
---@param whichUnit userdata
---@param callFunc onRebound | "function(evtData) end"
---@return any
hevent.onRebound = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.rebound, callFunc)
end

--- 被反伤伤害到时
---@alias onBeRebound fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"反伤伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeRebound | "function(evtData) end"
---@return any
hevent.onBeRebound = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beRebound, callFunc)
end

--- 暴击时
---@alias onKnocking fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onKnocking | "function(evtData) end"
---@return any
hevent.onKnocking = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.knocking, callFunc)
end

--- 承受暴击时
---@alias onBeKnocking fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeKnocking | "function(evtData) end"
---@return any
hevent.onBeKnocking = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beKnocking, callFunc)
end

--- 分裂时
---@alias onSplit fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害",radius:"分裂半径范围",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onSplit | "function(evtData) end"
---@return any
hevent.onSplit = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.split, callFunc)
end

--- 承受分裂时
---@alias onBeSplit fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害",radius:"分裂半径范围",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeSplit | "function(evtData) end"
---@return any
hevent.onBeSplit = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSplit, callFunc)
end

--- 吸血时
---@alias onHemophagia fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onHemophagia | "function(evtData) end"
---@return any
hevent.onHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.hemophagia, callFunc)
end

--- 被吸血时
---@alias onBeHemophagia fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeHemophagia | "function(evtData) end"
---@return any
hevent.onBeHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beHemophagia, callFunc)
end

--- 技能吸血时
---@alias onSkillHemophagia fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onSkillHemophagia | "function(evtData) end"
---@return any
hevent.onSkillHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillHemophagia, callFunc)
end

--- 被技能吸血时
---@alias onBeHemophagia fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeHemophagia | "function(evtData) end"
---@return any
hevent.onBeSkillHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSkillHemophagia, callFunc)
end

--- 硬直时
---@alias onPunish fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",during:"持续时间",percent:"硬直程度百分比"}):void
---@param whichUnit userdata
---@param callFunc onPunish | "function(evtData) end"
---@return any
hevent.onPunish = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, ONST_EVENT.punish, callFunc)
end

--- 死亡时
---@alias onDead fun(evtData: {triggerUnit:"死亡单位",killUnit:"凶手单位"}):void
---@param whichUnit userdata
---@param callFunc onDead | "function(evtData) end"
---@return any
hevent.onDead = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.dead, callFunc)
end

--- 杀敌时
---@alias onKill fun(evtData: {triggerUnit:"凶手单位",targetUnit:"死亡单位"}):void
---@param whichUnit userdata
---@param callFunc onKill | "function(evtData) end"
---@return any
hevent.onKill = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.kill, callFunc)
end

--- 复活时(必须使用 hunit.reborn 方法才能嵌入到事件系统)
---@alias onReborn fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onReborn | "function(evtData) end"
---@return any
hevent.onReborn = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.reborn, callFunc)
end

--- 获得经验时
---@alias onExp fun(evtData: {triggerUnit:"触发单位",value:"获取了多少经验值"}):void
---@param whichUnit userdata
---@param callFunc onLevelUp | "function(evtData) end"
---@return any
hevent.onExp = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.exp, callFunc)
end

--- 提升等级时
---@alias onLevelUp fun(evtData: {triggerUnit:"触发单位",value:"获取提升了多少级"}):void
---@param whichUnit userdata
---@param callFunc onLevelUp | "function(evtData) end"
---@return any
hevent.onLevelUp = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.levelUp, callFunc)
end

--- 建筑升级开始时
---@alias onUpgradeStart fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeStart | "function(evtData) end"
---@return any
hevent.onUpgradeStart = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeStart, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_START)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeStart, callFunc)
end

--- 建筑升级取消时
---@alias onUpgradeCancel fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeCancel | "function(evtData) end"
---@return any
hevent.onUpgradeCancel = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeCancel, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_CANCEL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeCancel, callFunc)
end

--- 建筑升级完成时
---@alias onUpgradeFinish fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeFinish | "function(evtData) end"
---@return any
hevent.onUpgradeFinish = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeFinish, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_FINISH)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeFinish, callFunc)
end

--- 进入某单位（whichUnit）半径范围内
---@alias onEnterUnitRange fun(evtData: {centerUnit:"被进入范围的中心单位",enterUnit:"进入范围的单位",radius:"设定的半径范围"}):void
---@param whichUnit userdata
---@param radius number
---@param callFunc onEnterUnitRange | "function(evtData) end"
---@return any
hevent.onEnterUnitRange = function(whichUnit, radius, callFunc)
    local key = CONST_EVENT.enterUnitRange
    local func = hcache.get(whichUnit, CONST_CACHE.EVENT_ON_ENTER_RANGE .. radius, nil)
    if (func == nil) then
        func = function()
            hevent.triggerEvent(whichUnit, key, {
                centerUnit = whichUnit,
                enterUnit = cj.GetTriggerUnit(),
                radius = radius
            })
        end
        hcache.set(whichUnit, CONST_CACHE.EVENT_ON_ENTER_RANGE .. radius, func)
    end
    hevent.pool(whichUnit, cj.Condition(func), function(tgr)
        cj.TriggerRegisterUnitInRange(tgr, whichUnit, radius, nil)
    end)
    return hevent.registerEvent(whichUnit, key, callFunc)
end

--- 进入某区域
---@alias onEnterRect fun(evtData: {triggerRect:"被进入的矩形区域",triggerUnit:"进入矩形区域的单位"}):void
---@param whichRect userdata
---@param callFunc onEnterRect | "function(evtData) end"
---@return any
hevent.onEnterRect = function(whichRect, callFunc)
    if (false == hcache.exist(whichRect)) then
        hcache.alloc(whichRect)
    end
    local key = CONST_EVENT.enterRect
    local onEnterRectAction = hcache.get(whichRect, CONST_CACHE.EVENT_ON_ENTER_RECT)
    if (onEnterRectAction == nil) then
        onEnterRectAction = function()
            hevent.triggerEvent(whichRect, key, {
                triggerRect = whichRect,
                triggerUnit = cj.GetTriggerUnit()
            })
        end
        hcache.set(whichRect, CONST_CACHE.EVENT_ON_ENTER_RECT, onEnterRectAction)
    end
    hevent.pool(whichRect, cj.Condition(onEnterRectAction), function(tgr)
        local rectRegion = cj.CreateRegion()
        cj.RegionAddRect(rectRegion, whichRect)
        cj.TriggerRegisterEnterRegion(tgr, rectRegion, nil)
    end)
    return hevent.registerEvent(whichRect, key, callFunc)
end

--- 离开某区域
---@alias onLeaveRect fun(evtData: {triggerRect:"被离开的矩形区域",triggerUnit:"离开矩形区域的单位"}):void
---@param whichRect userdata
---@param callFunc onLeaveRect | "function(evtData) end"
---@return any
hevent.onLeaveRect = function(whichRect, callFunc)
    if (false == hcache.exist(whichRect)) then
        hcache.alloc(whichRect)
    end
    local key = CONST_EVENT.leaveRect
    local onLeaveRectAction = hcache.get(whichRect, CONST_CACHE.EVENT_ON_LEAVE_RECT)
    if (onLeaveRectAction == nil) then
        onLeaveRectAction = function()
            hevent.triggerEvent(whichRect, key, {
                triggerRect = whichRect,
                triggerUnit = cj.GetTriggerUnit()
            })
        end
        hcache.set(whichRect, CONST_CACHE.EVENT_ON_LEAVE_RECT, onLeaveRectAction)
    end
    hevent.pool(whichRect, cj.Condition(onLeaveRectAction), function(tgr)
        local rectRegion = cj.CreateRegion()
        cj.RegionAddRect(rectRegion, whichRect)
        cj.TriggerRegisterLeaveRegion(tgr, rectRegion, nil)
    end)
    return hevent.registerEvent(whichRect, key, callFunc)
end

--- 任意建筑建造开始时
---@alias onConstructStart fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructStart | "function(evtData) end"
---@return any
hevent.onConstructStart = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructStart, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructStart, callFunc)
end

--- 任意建筑建造取消时
---@alias onConstructCancel fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructCancel | "function(evtData) end"
---@return any
hevent.onConstructCancel = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructCancel, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructCancel, callFunc)
end

--- 任意建筑建造完成时
---@alias onConstructFinish fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructFinish | "function(evtData) end"
---@return any
hevent.onConstructFinish = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructFinish, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructFinish, callFunc)
end

--- 当聊天时
---@alias onChat fun(evtData: {triggerPlayer:"聊天的玩家",chatString:"聊天的内容",matchedString:"匹配命中的内容"}):void
---@param whichPlayer userdata
---@param pattern string 支持正则
---@param callFunc onChat | "function(evtData) end"
---@return any
hevent.onChat = function(whichPlayer, pattern, callFunc)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.chat, function(evtData)
        local m = string.match(evtData.chatString, pattern)
        if (m ~= nil) then
            evtData.matchedString = m
            callFunc(evtData)
        end
    end)
end

--- 按ESC
---@alias onEsc fun(evtData: {triggerPlayer:"触发玩家"}):void
---@param whichPlayer userdata
---@param callFunc onEsc | "function(evtData) end"
---@return any
hevent.onEsc = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.esc, function(tgr)
        cj.TriggerRegisterPlayerEvent(tgr, whichPlayer, EVENT_PLAYER_END_CINEMATIC)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.esc, callFunc)
end

--- 玩家选择单位(点击了qty次)
---@alias onSelection fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param qty number
---@param callFunc onSelection | "function(evtData) end"
---@return any
hevent.onSelection = function(whichPlayer, qty, callFunc)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.selection .. "#" .. qty, callFunc)
end

--- 玩家取消选择单位
---@alias onDeSelection fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onDeSelection | "function(evtData) end"
---@return any
hevent.onDeSelection = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.deSelection, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.deSelection, callFunc)
end

--- 玩家离开游戏事件(注意这是全局事件)
---@alias onPlayerLeave fun(evtData: {triggerPlayer:"触发玩家"}):void
---@param callFunc onPlayerLeave | "function(evtData) end"
---@return any
hevent.onPlayerLeave = function(callFunc)
    return hevent.registerEvent("global", CONST_EVENT.playerLeave, callFunc)
end

--- 玩家资源变动
---@alias onPlayerResourceChange fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位",type:"资源类型",value:"变化值"}):void
---@param callFunc onPlayerResourceChange | "function(evtData) end"
---@return any
hevent.onPlayerResourceChange = function(callFunc)
    return hevent.registerEvent("global", CONST_EVENT.playerResourceChange, callFunc)
end

--- 任意单位经过hero方法被玩家所挑选为英雄时(注意这是全局事件)
---@alias onPickHero fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param callFunc onPickHero | "function(evtData) end"
---@return any
hevent.onPickHero = function(callFunc)
    return hevent.registerEvent("global", CONST_EVENT.pickHero, callFunc)
end

--- 可破坏物死亡
---@alias onDestructableDestroy fun(evtData: {triggerDestructable:"被破坏的可破坏物"}):void
---@param whichDestructable userdata
---@param callFunc onDestructableDestroy | "function(evtData) end"
---@return any
hevent.onDestructableDestroy = function(whichDestructable, callFunc)
    hevent.pool(whichDestructable, hevent_default_actions.destructable.destroy, function(tgr)
        cj.TriggerRegisterDeathEvent(tgr, whichDestructable)
    end)
    return hevent.registerEvent(whichDestructable, CONST_EVENT.destructableDestroy, callFunc)
end

--- 全图当前可破坏物死亡
---@alias onMapDestructableDestroy fun(evtData: {triggerDestructable:"被破坏的可破坏物"}):void
---@param callFunc onMapDestructableDestroy | "function(evtData) end"
---@return any
hevent.onMapDestructableDestroy = function(callFunc)
    local tgr = cj.CreateTrigger()
    cj.TriggerAddCondition(tgr, cj.Condition(function()
        callFunc({ triggerDestructable = cj.GetTriggerDestructable() })
    end))
    cj.EnumDestructablesInRect(hrect.playable(), nil, function()
        cj.TriggerRegisterDeathEvent(tgr, cj.GetEnumDestructable())
    end)
end

--- 信使闪烁时
---@alias onCourierBlink fun(evtData: {triggerUnit:"触发单位",triggerSkill:"施放技能ID字符串",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onCourierBlink | "function(evtData) end"
---@return any
hevent.onCourierBlink = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.courierBlink, callFunc)
end

--- 信使范围拾取时
---@alias onCourierRangePickUp fun(evtData: {triggerUnit:"触发单位",triggerSkill:"施放技能ID字符串",radius:"拾取范围半径"}):void
---@param whichUnit userdata
---@param callFunc onCourierRangePickUp | "function(evtData) end"
---@return any
hevent.onCourierRangePickUp = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.courierRangePickUp, callFunc)
end

--- 信使拆分时
---@alias onCourierSeparate fun(evtData: {triggerUnit:"触发单位",triggerSkill:"施放技能ID字符串",triggerItemId:"触发物品ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onCourierSeparate | "function(evtData) end"
---@return any
hevent.onCourierSeparate = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.courierSeparate, callFunc)
end

--- 信使批量传递时
---@alias onCourierDeliver fun(evtData: {triggerUnit:"触发单位",triggerSkill:"施放技能ID字符串",targetUnit:"目标单位"}):void
---@param whichUnit userdata
---@param callFunc onCourierDeliver | "function(evtData) end"
---@return any
hevent.onCourierDeliver = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.courierDeliver, callFunc)
end

--- 当单位移动开始捕获瞬间
---@alias onMoveStart fun(evtData: {triggerUnit:"触发单位",targetX:"移动目标X",targetY:"移动目标Y",targetZ:"移动目标Z"}):void
---@param whichUnit userdata
---@param callFunc onMoveStart | "function(evtData) end"
---@return any
hevent.onMoveStart = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.moveStart, callFunc)
end

--- 当单位移动中
--- 注意此事件在移动时每0.25秒都会触发1次，直到移动状态消失
---@alias onMoving fun(evtData: {triggerUnit:"触发单位",step:"移动步伐数"}):void
---@param whichUnit userdata
---@param callFunc onMoving | "function(evtData) end"
---@return any
hevent.onMoving = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.moving, callFunc)
end

--- 当单位移动停止捕获瞬间
--- 通过对命令的捕获和单位的坐标计算进行的推理型事件
--- 注意此事件有可能非实时，可能存有一定延迟
---@alias onMoveStop fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onMoveStop | "function(evtData) end"
---@return any
hevent.onMoveStop = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.moveStop, callFunc)
end

--- 当单位发布驻扎(H)命令
--- 只有真人玩家的单位有此事件
---@alias onHoldOn fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onHoldOn | "function(evtData) end"
---@return any
hevent.onHoldOn = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.holdOn, callFunc)
end

--- 当单位发布停止(S)命令
--- 只有真人玩家的单位有此事件
---@alias onStop fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onStop | "function(evtData) end"
---@return any
hevent.onStop = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.stop, callFunc)
end