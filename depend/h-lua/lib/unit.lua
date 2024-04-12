---@class hunit 单位
hunit = {}

--- 单位是否在某玩家真实视野内
---@param whichUnit userdata
---@return boolean
function hunit.isDetected(whichUnit, whichPlayer)
    if (whichUnit == nil or whichPlayer == nil) then
        return false
    end
    return cj.IsUnitDetected(whichUnit, whichPlayer) == true
end

--- 单位是否对某玩家不可见
---@param whichUnit userdata
---@return boolean
function hunit.isInvisible(whichUnit, whichPlayer)
    if (whichUnit == nil or whichPlayer == nil) then
        return false
    end
    return cj.IsUnitInvisible(whichUnit, whichPlayer) == true
end

--- 单位是否可攻击
---@param whichUnit userdata
---@return boolean
function hunit.isAttackAble(whichUnit)
    return "0" ~= (hslk.i2v(hunit.getId(whichUnit), "slk", "weapsOn") or "0")
end

--- 是否死亡
---@param whichUnit userdata
---@return boolean
function hunit.isDead(whichUnit)
    return (true == hcache.get(whichUnit, CONST_CACHE.UNIT_DEAD)) or cj.IsUnitType(whichUnit, UNIT_TYPE_DEAD) or (cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) <= 0)
end

--- 是否生存
---@param whichUnit userdata
---@return boolean
function hunit.isAlive(whichUnit)
    return false == hunit.isDead(whichUnit)
end

--- 是否暂停
---@param whichUnit userdata
---@return boolean
function hunit.isPaused(whichUnit)
    return cj.IsUnitPaused(whichUnit)
end

--- 是否隐藏
---@param whichUnit userdata
---@return boolean
function hunit.isHidden(whichUnit)
    return cj.IsUnitHidden(whichUnit)
end

--- 是否正在睡眠
---@param whichUnit userdata
---@return boolean
function hunit.isSleeping(whichUnit)
    return cj.UnitIsSleeping(whichUnit)
end

--- 单位是否已被删除
---@param whichUnit userdata
---@return boolean
function hunit.isDestroyed(whichUnit)
    return cj.GetUnitTypeId(whichUnit) == 0 or (hunit.isDead(whichUnit) and false == hcache.exist(whichUnit))
end

--- 是否无敌
---@param whichUnit userdata
---@return boolean
function hunit.isInvincible(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, HL_ID.ability_invulnerable) > 0
end

--- 是否英雄
--- UNIT_TYPE_HERO是对应平衡常数的英雄列表
--- hero对应hslk._type，是本框架固有用法
---@param whichUnit userdata
---@return boolean
function hunit.isHero(whichUnit)
    local uid = hunit.getId(whichUnit)
    if (uid == nil) then
        return false
    end
    return "hero" == (hslk.i2v(uid, "_type") or "common") or cj.IsUnitType(whichUnit, UNIT_TYPE_HERO)
end

--- 是否建筑
---@param whichUnit userdata
---@return boolean
function hunit.isStructure(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)
end

--- 是否镜像
---@param whichUnit userdata
---@return boolean
function hunit.isIllusion(whichUnit)
    return cj.IsUnitIllusion(whichUnit)
end

--- 是否地面单位
---@param whichUnit userdata
---@return boolean
function hunit.isGround(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_GROUND)
end

--- 是否空中单位
---@param whichUnit userdata
---@return boolean
function hunit.isAir(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_FLYING)
end

--- 是否近战
---@param whichUnit userdata
---@return boolean
function hunit.isMelee(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end

--- 是否远程
---@param whichUnit userdata
---@return boolean
function hunit.isRanged(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_RANGED_ATTACKER)
end

--- 是否召唤
---@param whichUnit userdata
---@return boolean
function hunit.isSummoned(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)
end

--- 是否机械
---@param whichUnit userdata
---@return boolean
function hunit.isMechanical(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)
end

--- 是否古树
---@param whichUnit userdata
---@return boolean
function hunit.isAncient(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)
end

--- 是否自爆工兵
---@param whichUnit userdata
---@return boolean
function hunit.isSapper(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SAPPER)
end

--- 是否虚无状态
---@param whichUnit userdata
---@return boolean
function hunit.isEthereal(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ETHEREAL)
end

--- 是否魔法免疫
---@param whichUnit userdata
---@return boolean
function hunit.isImmune(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MAGIC_IMMUNE)
end

--- 是否某个种族
---@param whichUnit userdata
---@param whichRace userdata 参考 blizzard:^RACE
---@return boolean
function hunit.isRace(whichUnit, whichRace)
    return cj.IsUnitRace(whichUnit, whichRace)
end

--- 是否蝗虫
---@param whichUnit userdata
---@return boolean
function hunit.isLocust(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, HL_ID.ability_locust) > 0
end

--- 是否正在受伤
---@param whichUnit userdata
---@return boolean
function hunit.isBeDamaging(whichUnit)
    return hcache.get(whichUnit, CONST_CACHE.ATTR_BE_DAMAGING, false)
end

--- 是否正在造成伤害
---@param whichUnit userdata
---@return boolean
function hunit.isDamaging(whichUnit)
    return hcache.get(whichUnit, CONST_CACHE.ATTR_DAMAGING, false)
end

--- 是否处在水面
---@param whichUnit userdata
---@return boolean
function hunit.isWater(whichUnit)
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == false
end

--- 是否处于地面
---@param whichUnit userdata
---@return boolean
function hunit.isFloor(whichUnit)
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == true
end

--- 是否某个特定单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function hunit.isUnit(whichUnit, otherUnit)
    return cj.IsUnit(whichUnit, otherUnit)
end

--- 是否敌人单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function hunit.isEnemy(whichUnit, otherUnit)
    return cj.IsUnitEnemy(whichUnit, hunit.getOwner(otherUnit))
end

--- 是否友军单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function hunit.isAlly(whichUnit, otherUnit)
    return cj.IsUnitAlly(whichUnit, hunit.getOwner(otherUnit))
end

--- 是否敌人玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
function hunit.isEnemyPlayer(whichUnit, whichPlayer)
    return cj.IsUnitEnemy(whichUnit, whichPlayer)
end

--- 是否友军玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
function hunit.isAllyPlayer(whichUnit, whichPlayer)
    return cj.IsUnitAlly(whichUnit, whichPlayer)
end

--- 单位是否拥有物品栏
--- 经测试(1.27a)单位物品栏（各族）等价物英雄物品栏，等级为1，即使没有科技
--- RPG应去除多余的物品栏，确保判定的准确性
---@param whichUnit userdata
---@param slotId number
---@return boolean
function hunit.hasSlot(whichUnit, slotId)
    if (slotId == nil) then
        slotId = HL_ID.ability_item_slot
    end
    return cj.GetUnitAbilityLevel(whichUnit, slotId) >= 1
end

--- 单位身上是否有某种物品
---@param whichUnit userdata
---@param whichItemId number|string
---@return boolean
function hunit.hasItem(whichUnit, whichItemId)
    local f = false
    if (type(whichItemId) == "string") then
        whichItemId = c2i(whichItemId)
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil and cj.GetItemTypeId(it) == whichItemId) then
            f = true
            break
        end
    end
    return f
end

--- 获取单位的头像
---@param uOrId userdata|string|number
---@return string
function hunit.getAvatar(uOrId)
    return hslk.i2v(hunit.getId(uOrId), "slk", "Art") or "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
end

--- 获取单位的物编白天视野
---@param uOrId userdata|string|number
---@return string
function hunit.getSight(uOrId)
    return math.floor(hslk.i2v(hunit.getId(uOrId), "slk", "sight")) or 0
end

--- 获取单位的物编黑夜视野
---@param uOrId userdata|string|number
---@return string
function hunit.getNSight(uOrId)
    return math.floor(hslk.i2v(hunit.getId(uOrId), "slk", "nsight")) or 0
end

--- 获取单位的攻击1浮动
--- 这是根据slk计算的浮动攻击上下限
---@param uOrId userdata|string|number
---@return number[2]
function hunit.getAttackSides1(uOrId)
    local s = hslk.i2v(hunit.getId(uOrId), "slk")
    if (s == nil) then
        return { 0, 0 }
    end
    local sides1 = s.sides1 or 1
    local dice1 = s.dice1 or 0
    sides1 = math.floor(sides1)
    dice1 = math.floor(dice1)
    if (sides1 < 1) then
        sides1 = 1
    end
    return { dice1 * 1, dice1 * sides1 }
end

--- 获取单位的最大生命值
---@param u userdata
---@return number
function hunit.getMaxLife(u)
    return cj.GetUnitState(u, UNIT_STATE_MAX_LIFE) or 0
end

--- 获取单位的当前生命
---@param u userdata
---@return number
function hunit.getCurLife(u)
    return cj.GetUnitState(u, UNIT_STATE_LIFE)
end

--- 设置单位的当前生命
---@param u userdata
---@param val number
function hunit.setCurLife(u, val)
    cj.SetUnitState(u, UNIT_STATE_LIFE, val)
end

--- 增加单位的当前生命
---@param u userdata
---@param val number
function hunit.addCurLife(u, val)
    val = math.round(val, 2)
    if (val > 0) then
        hunit.setCurLife(u, hunit.getCurLife(u) + val)
    end
end

--- 减少单位的当前生命
---@param u userdata
---@param val number
function hunit.subCurLife(u, val)
    hunit.setCurLife(u, hunit.getCurLife(u) - val)
end

--- 获取单位的最大魔法
---@param u userdata
---@return number
function hunit.getMaxMana(u)
    return cj.GetUnitState(u, UNIT_STATE_MAX_MANA) or 0
end

--- 获取单位的当前魔法
---@param u userdata
---@return number
function hunit.getCurMana(u)
    return cj.GetUnitState(u, UNIT_STATE_MANA)
end

--- 设置单位的当前魔法
---@param u userdata
---@param val number
function hunit.setCurMana(u, val)
    cj.SetUnitState(u, UNIT_STATE_MANA, val)
end

--- 增加单位的当前魔法
---@param u userdata
---@param val number
function hunit.addCurMana(u, val)
    val = math.round(val, 2)
    if (val > 0) then
        hunit.setCurMana(u, hunit.getCurMana(u) + val)
    end
end

--- 减少单位的当前魔法
---@param u userdata
---@param val number
function hunit.subCurMana(u, val)
    hunit.setCurMana(u, hunit.getCurMana(u) - val)
end

--- 获取单位百分比生命
---@param u userdata
---@return number %
function hunit.getCurLifePercent(u)
    return math.round(100 * (hunit.getCurLife(u) / hunit.getMaxLife(u)))
end

--- 设置单位百分比生命
---@param u userdata
---@param val number
function hunit.setCurLifePercent(u, val)
    local max = hunit.getMaxLife(u)
    local life = math.floor(max * val * 0.01)
    if (life < 0) then
        life = 0
    end
    hunit.setCurLife(u, life)
end

--- 获取单位百分比魔法
---@param u userdata
---@return number %
function hunit.getCurManaPercent(u)
    return math.round(100 * (hunit.getCurMana(u) / hunit.getMaxMana(u)))
end

--- 设置单位百分比魔法
---@param u userdata
---@param val number %
function hunit.setCurManaPercent(u, val)
    local max = hunit.getMaxMana(u)
    local mana = math.floor(max * val * 0.01)
    if (mana < 0) then
        mana = 0
    end
    hunit.setCurMana(u, mana)
end

--- 增加单位的经验值
---@param u userdata
---@param val number
function hunit.addExp(u, val, showEffect)
    if (u == nil or val == nil or val <= 0) then
        return
    end
    if (type(showEffect) ~= "boolean") then
        showEffect = false
    end
    val = math.ceil(val * hplayer.getExpRatio(hunit.getOwner(u)) / 100)
    cj.AddHeroXP(u, val, showEffect)
    -- @触发事件
    hevent.trigger(u, CONST_EVENT.exp, { triggerUnit = u, value = val })
end

--- 设置单位的生命周期
---@param u userdata
---@param life number
function hunit.setPeriod(u, life)
    if (life > 0) then
        cj.UnitApplyTimedLife(u, c2i("BTLF"), life)
        if (hcache.exist(u) == false) then
            hcache.alloc(u)
        end
        hcache.set(u, CONST_CACHE.UNIT_PERIOD_START_TIME, htime.count)
        hcache.set(u, CONST_CACHE.UNIT_PERIOD, life)
    end
end

--- 获取单位的生命周期
--- 无生命周期时为-1
---@param u userdata
---@return number
function hunit.getPeriod(u)
    return hcache.get(u, CONST_CACHE.UNIT_PERIOD, -1)
end

--- 获取单位的剩余生命周期
--- 无生命周期时为-1
---@param u userdata
---@return number
function hunit.getPeriodRemain(u)
    local st = hcache.get(u, CONST_CACHE.UNIT_PERIOD_START_TIME, htime.count)
    local p = hcache.get(u, CONST_CACHE.UNIT_PERIOD, -1)
    if (p == -1) then
        return -1
    end
    local remain = p - (htime.count - st)
    if (remain < 0) then
        return 0
    end
    return remain
end

--- 设置单位可飞，用于设置单位飞行高度之前
---@param u userdata
function hunit.setCanFly(u)
    cj.UnitAddAbility(u, c2i("Arav"))
    cj.UnitRemoveAbility(u, c2i("Arav"))
end

--- 获取单位飞行高度
---@param u userdata
---@return number
function hunit.getFlyHeight(u)
    return cj.GetUnitFlyHeight(u)
end

--- 设置单位飞行高度，用于设置单位可飞行之后
---@param u userdata
---@param height number
---@param speed number
function hunit.setFlyHeight(u, height, speed)
    cj.SetUnitFlyHeight(u, height, speed)
end

--- 设置单位面向角度
---@param u userdata
---@param facing number
function hunit.setFacing(u, facing)
    cj.SetUnitFacing(u, facing)
end

--- 获取单位面向角度
---@param u userdata
---@return number
function hunit.getFacing(u)
    return cj.GetUnitFacing(u)
end

--- 显示单位
---@param u userdata
function hunit.show(u)
    cj.ShowUnit(u, true)
end

--- 隐藏单位
---@param u userdata
function hunit.hide(u)
    cj.ShowUnit(u, false)
end

--- 暂停单位
---@param u userdata
function hunit.pause(u)
    cj.PauseUnit(u, true)
end

--- 恢复暂停单位
---@param u userdata
function hunit.resume(u)
    cj.PauseUnit(u, false)
end

--- 获取单位X坐标
---@param u userdata
---@return number
function hunit.x(u)
    return cj.GetUnitX(u)
end

--- 获取单位Y坐标
---@param u userdata
---@return number
function hunit.y(u)
    return cj.GetUnitY(u)
end

--- 获取单位Z坐标
---@param u userdata
---@return number
function hunit.z(u)
    return hjapi.Z(cj.GetUnitX(u), cj.GetUnitY(u))
end

--- 获取单位H坐标
---@param u userdata
---@return number
function hunit.h(u)
    return hunit.z(u) + hunit.getFlyHeight(u)
end

--- 设置单位无敌
---@param u userdata
---@param flag boolean
function hunit.setInvulnerable(u, flag)
    if (flag == nil) then
        flag = true
    end
    if (flag == true and cj.GetUnitAbilityLevel(u, HL_ID.ability_invulnerable) < 1) then
        cj.UnitAddAbility(u, HL_ID.ability_invulnerable)
    else
        cj.UnitRemoveAbility(u, HL_ID.ability_invulnerable)
    end
end

--- 设置单位的动画速度[比例尺1.00]
---@param whichUnit userdata
---@param speed number 0.00-1.00
---@param during number
function hunit.setAnimateSpeed(whichUnit, speed, during)
    if (whichUnit == nil or hunit.isDestroyed(whichUnit)) then
        return
    end
    during = during or 0
    local prevSpeed = hcache.get(whichUnit, CONST_CACHE.UNIT_ANIMATE_SPEED, 1.00)
    speed = speed or prevSpeed
    cj.SetUnitTimeScale(whichUnit, speed)
    hcache.set(whichUnit, CONST_CACHE.UNIT_ANIMATE_SPEED, speed)
    if (during > 0) then
        htime.setTimeout(during, function()
            cj.SetUnitTimeScale(whichUnit, prevSpeed)
            hcache.set(whichUnit, CONST_CACHE.UNIT_ANIMATE_SPEED, prevSpeed)
        end)
    end
end

--- 设置单位的三原色，rgb取值0-255
---@param whichUnit userdata
---@param red number 0-255
---@param green number 0-255
---@param blue number 0-255
---@param opacity number 不透明度 0.0-1.0
function hunit.setRGBA(whichUnit, red, green, blue, opacity)
    if (whichUnit == nil or hunit.isDestroyed(whichUnit)) then
        return
    end
    local uid = hunit.getId(whichUnit)
    if (uid == nil) then
        return
    end
    red = math.floor(math.max(0, math.min(255, red or 255)))
    green = math.floor(math.max(0, math.min(255, green or 255)))
    blue = math.floor(math.max(0, math.min(255, blue or 255)))
    opacity = math.floor(255 * math.max(0, math.min(1, opacity or 1)))
    cj.SetUnitVertexColor(whichUnit, red, green, blue, opacity)
end

--- 获取单位当前归属玩家
---@param whichUnit userdata
---@return userdata ownerPlayer
function hunit.getOwner(whichUnit)
    if (whichUnit == nil) then
        return
    end
    return cj.GetOwningPlayer(whichUnit)
end

--- 设置单位当前归属玩家
---@param whichUnit userdata
---@param ownerPlayer userdata
---@param changeColor boolean
---@return void
function hunit.setOwner(whichUnit, ownerPlayer, changeColor)
    if (whichUnit == nil or ownerPlayer == nil) then
        return
    end
    if (type(changeColor) ~= "boolean") then
        changeColor = true
    end
    cj.SetUnitOwner(whichUnit, ownerPlayer, changeColor)
end

--- 瞬间传送单位到X,Y坐标
---@param whichUnit userdata
---@param x number
---@param y number
---@param facing number|nil
function hunit.portal(whichUnit, x, y, facing)
    if (whichUnit == nil or x == nil or y == nil) then
        return
    end
    cj.SetUnitPosition(whichUnit, x, y)
    if (facing ~= nil) then
        cj.SetUnitFacing(whichUnit, facing)
    end
end

--- 命令单位做动画动作，如 "attack"
--- 当动作为整型序号时，自动播放对应的序号行为(每种模型的序号并不一致)
---@param whichUnit userdata
---@param animate number | string
function hunit.animate(whichUnit, animate)
    if (whichUnit == nil or animate == nil) then
        return
    end
    if (type(animate) == "string") then
        cj.SetUnitAnimation(whichUnit, animate)
    elseif (type(animate) == "number") then
        animate = math.floor(animate)
        cj.SetUnitAnimationByIndex(whichUnit, animate)
    end
end

--- 使得单位嵌入框架系统
--- 一般不需要主动使用
--- 但地图放置等这些单位就被忽略了，所以可以试用此方法补回
---@param u userdata
---@param options table
function hunit.embed(u, options)
    options = options or {}
    if (type(options.registerOrderEvent ~= "boolean")) then
        options.registerOrderEvent = false
    end
    -- 记入group选择器（不在框架系统内的单位，也不会被group选择到）
    hgroup.addUnit(hgroup.GLOBAL, u)
    -- 记入realtime
    local id = options.id
    if (type(id) == "number") then
        id = i2c(id)
    end
    hcache.alloc(u)
    hcache.set(u, CONST_CACHE.UNIT_ANIMATE_SPEED, options.timeScale or 1.00)
    hcache.set(u, CONST_CACHE.ATTR, -1)
    hevent.poolRed(u, hevent_binder.unit.damaged, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DAMAGED)
    end)
    -- 物品系统
    if (options.isOpenSlot == true) then
        hskill.add(u, HL_ID.ability_item_slot, 1)
    end
    -- 如果是英雄，注册事件和计算初次属性
    if (hunit.isHero(u) == true) then
        hhero.setPrevLevel(u, 1)
        hattribute.set(u, 0, {
            str_white = "=" .. cj.GetHeroStr(u, false),
            agi_white = "=" .. cj.GetHeroAgi(u, false),
            int_white = "=" .. cj.GetHeroInt(u, false),
        })
    end
    -- 属性 attr
    local _attr = hslk.i2v(id, "_attr")
    if (_attr ~= nil and type(_attr) == "table") then
        hattribute.set(u, 0, _attr)
    end
    if (options.attr ~= nil and type(options.attr) == "table") then
        hattribute.set(u, 0, options.attr)
    end
    -- 处理物编单位技能
    local abilList = hslk.i2v(id, "slk", "abilList") or ""
    abilList = string.explode(",", abilList)
    if (#abilList > 0) then
        for _, abid in ipairs(abilList) do
            hskill.addProperty(u, abid, 1)
        end
    end
end

--[[
    创建单位/单位组
    options = {
        register = true, --是否注册进系统
        registerOrderEvent = false, --是否注册系统指令事件，可选
        whichPlayer = nil, --归属玩家
        id = nil, --类型id,如 H001
        x = nil, --创建坐标X，可选
        y = nil, --创建坐标Y，可选
        height = 高度，0，可选
        timeScale = 动作时间比例，0.0~N.N，可选
        modelScale = 模型缩放比例，0.0~N.N，可选
        red = 红色，0～255，可选
        green = 绿色，0～255，可选
        blue = 蓝色，0～255，可选
        opacity = 不透明度，0.0～1.0，可选,0不可见
        qty = 1, --数量，可选，可选
        period = nil, --生命周期，到期死亡，可选
        during = nil, --持续时间，到期删除，可选
        facing = nil, --面向角度，可选
        facingX = nil, --面向X，可选
        facingY = nil, --面向Y，可选
        facingUnit = nil, --面向单位，可选
        attackX = nil, --攻击X，可选
        attackY = nil, --攻击Y，可选
        attackUnit = nil, --攻击单位，可选
        isOpenSlot = false, --是否开启物品栏(自动注册)可选
        isShadow = false, --是否影子，可选
        isUnSelectable = false, --是否不可鼠标选中，可选
        isPause = false, -- 是否暂停
        isInvulnerable = false, --是否无敌，可选
        isShareSight = false, --是否与所有玩家共享视野，可选
        attr = nil, --自定义属性，可选
    }
]]
---@alias noteUnitCreate {register,registerOrderEvent,whichPlayer,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@param options noteUnitCreate
---@return userdata|table 最后创建单位|单位组
function hunit.create(options)
    if (options.qty == nil) then
        options.qty = 1
    end
    if (options.whichPlayer == nil) then
        err("create unit fail -pl")
        return
    end
    if (options.id == nil) then
        err("create unit fail -id")
        return
    end
    if (options.qty <= 0) then
        err("create unit fail -qty")
        return
    end
    if (options.x == nil or options.y == nil) then
        err("create unit fail -place")
        return
    end
    if (options.id == nil) then
        err("create unit id")
        return
    end
    if (type(options.id) == "string") then
        options.id = c2i(options.id)
    end
    local u
    local facing
    local g
    local x = options.x
    local y = options.y
    if (options.facing ~= nil) then
        facing = options.facing
    elseif (options.facingX ~= nil and options.facingY ~= nil) then
        facing = math.angle(x, y, options.facingX, options.facingY)
    elseif (options.facingUnit ~= nil) then
        facing = math.angle(x, y, hunit.x(options.facingUnit), hunit.y(options.facingUnit))
    else
        facing = bj_UNIT_FACING
    end
    if (options.qty > 1) then
        g = {}
    end
    for _ = 1, options.qty, 1 do
        if (options.x ~= nil and options.y ~= nil) then
            u = cj.CreateUnit(options.whichPlayer, options.id, options.x, options.y, facing)
        end
        -- 高度
        if (options.height ~= nil and options.height ~= 0) then
            options.height = math.round(options.height)
            hunit.setCanFly(u)
            cj.SetUnitFlyHeight(u, options.height, 10000)
        end
        -- RBGA
        if (options.red ~= nil or options.green ~= nil or options.blue ~= nil or options.opacity ~= nil) then
            local red = math.floor(options.red or hslk.i2v(options.id, "slk", "red") or 255)
            local green = math.floor(options.green or hslk.i2v(options.id, "slk", "green") or 255)
            local blue = math.floor(options.blue or hslk.i2v(options.id, "slk", "blue") or 255)
            cj.SetUnitVertexColor(u, red, green, blue, math.floor(255 * options.opacity))
        end
        -- 动作时间比例
        if (options.timeScale ~= nil and options.timeScale >= 0) then
            options.timeScale = math.round(options.timeScale)
            cj.SetUnitTimeScale(u, options.timeScale)
        end
        -- 模型缩放比例
        if (options.modelScale ~= nil and options.modelScale > 0) then
            options.modelScale = math.round(options.modelScale)
            cj.SetUnitScale(u, options.modelScale, options.modelScale, options.modelScale)
        end
        if (options.attackX ~= nil and options.attackY ~= nil) then
            cj.IssuePointOrder(u, "attack", options.attackX, options.attackY)
        elseif (options.attackUnit ~= nil) then
            cj.IssueTargetOrder(u, "attack", options.attackUnit)
        end
        if (options.qty > 1) then
            hgroup.addUnit(g, u)
        end
        --是否可选
        if (options.isUnSelectable ~= nil and options.isUnSelectable == true) then
            cj.UnitAddAbility(u, HL_ID.ability_locust)
        end
        --是否暂停
        if (options.isPause ~= nil and options.isPause == true) then
            cj.PauseUnit(u, true)
        end
        --是否无敌
        if (options.isInvulnerable ~= nil and options.isInvulnerable == true) then
            cj.UnitAddAbility(u, HL_ID.ability_invulnerable)
        end
        --影子，无敌蝗虫暂停,且不注册系统
        if (options.isShadow ~= nil and options.isShadow == true) then
            cj.PauseUnit(u, true)
            cj.UnitAddAbility(u, HL_ID.ability_locust)
            cj.UnitAddAbility(u, HL_ID.ability_invulnerable)
            options.register = false
        end
        --是否与所有玩家共享视野
        if (options.isShareSight ~= nil and options.isShareSight == true) then
            for pi = 0, bj_MAX_PLAYERS - 1, 1 do
                cj.SetPlayerAlliance(options.whichPlayer, cj.Player(pi), ALLIANCE_SHARED_VISION, true)
            end
        end
        -- 注册系统(默认注册)
        if (type(options.register) ~= "boolean") then
            options.register = true
        end
        if (options.register == true) then
            hunit.embed(u, options)
        end
        -- 生命周期 dead
        if (options.period ~= nil and options.period > 0) then
            hunit.setPeriod(u, options.period)
            if (options.during == nil or options.during <= 0) then
                options.during = options.period + 1
            end
        end
        -- 持续时间 delete
        if (options.during ~= nil and options.during >= 0) then
            hunit.destroy(u, options.during)
        end
    end
    if (g ~= nil) then
        return g
    else
        return u
    end
end

--- 获取单位ID字符串
---@param uOrId userdata|number|string
---@return string|nil
function hunit.getId(uOrId)
    local id
    if (type(uOrId) == "userdata") then
        id = cj.GetUnitTypeId(uOrId)
        if (id == 0) then
            return
        end
        id = i2c(id)
    elseif (type(uOrId) == "number") then
        id = i2c(uOrId)
    elseif (type(uOrId) == "string") then
        id = uOrId
    end
    return id
end

--- 获取单位的名称
---@param u userdata
---@return string
function hunit.getName(u)
    return cj.GetUnitName(u)
end

--- 获取单位的自定义值
---@param u userdata
---@return number
function hunit.getUserData(u)
    return cj.GetUnitUserData(u)
end

--- 设置单位的自定义值
---@param u userdata
---@param val number
---@param during number
function hunit.setUserData(u, val, during)
    local oldData = hunit.getUserData(u)
    val = math.ceil(val)
    cj.SetUnitUserData(u, val)
    during = during or 0
    if (during > 0) then
        htime.setTimeout(during, function(t)
            t.destroy()
            cj.SetUnitUserData(u, oldData)
        end)
    end
end

--- 设置单位颜色,color可设置玩家索引[1-16],应用其对应的颜色 或 参考 PLAYER_COLOR_BLACK
---@param u userdata
---@param color any 阵营颜色
function hunit.setColor(u, color)
    if (type(color) == "number") then
        cj.SetUnitColor(u, cj.ConvertPlayerColor(color - 1))
    elseif (color ~= nil) then
        cj.SetUnitColor(u, color)
    end
end

--- 删除单位，延时<delay>秒
---@param targetUnit userdata
---@param delay number
function hunit.destroy(targetUnit, delay)
    if (hunit.isDestroyed(targetUnit)) then
        return
    end
    if (delay == nil or delay <= 0) then
        hgroup.removeUnit(hgroup.GLOBAL, targetUnit)
        hitem.destroyFromUnit(targetUnit)
        hevent.free(targetUnit)
        hcache.free(targetUnit)
        cj.RemoveUnit(targetUnit)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            if (hunit.isDestroyed(targetUnit)) then
                return
            end
            hgroup.removeUnit(hgroup.GLOBAL, targetUnit)
            hitem.destroyFromUnit(targetUnit)
            hevent.free(targetUnit)
            hcache.free(targetUnit)
            cj.RemoveUnit(targetUnit)
        end)
    end
end

--- 杀死单位，延时<delay>秒
---@param targetUnit userdata
---@param delay number
function hunit.kill(targetUnit, delay)
    if (delay == nil or delay <= 0) then
        cj.KillUnit(targetUnit)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            cj.KillUnit(targetUnit)
        end)
    end
end

--- 爆毁单位，延时<delay>秒
--- 当需要播放单位爆炸死亡动画时，使用此方法替代kill令其死亡
---@param targetUnit userdata
---@param delay number
function hunit.exploded(targetUnit, delay)
    if (delay == nil or delay <= 0) then
        cj.SetUnitExploded(targetUnit, true)
        cj.KillUnit(targetUnit)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            cj.SetUnitExploded(targetUnit, true)
            cj.KillUnit(targetUnit)
        end)
    end
end