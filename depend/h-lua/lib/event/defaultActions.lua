--- 框架默认事件动作
--- default event actions
hevent_default_actions = {
    player = {
        esc = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerPlayer(),
                CONST_EVENT.esc,
                {
                    triggerPlayer = cj.GetTriggerPlayer()
                }
            )
        end),
        deSelection = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerPlayer(),
                CONST_EVENT.deSelection,
                {
                    triggerPlayer = cj.GetTriggerPlayer(),
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructStart = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructStart,
                {
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructCancel = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructCancel,
                {
                    triggerUnit = cj.GetCancelledStructure()
                }
            )
        end),
        constructFinish = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructFinish,
                {
                    triggerUnit = cj.GetConstructedStructure()
                }
            )
        end),
        apm = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            if (his.locust(u)) then
                return
            end
            local p = hunit.getOwner(u)
            if (his.playing(p) == true and his.playerSite(p) == true and his.computer(p) == false) then
                hcache.set(p, CONST_CACHE.PLAYER_APM, hcache.get(p, CONST_CACHE.PLAYER_APM, 0) + 1)
            end
        end),
        leave = cj.Condition(function()
            local p = cj.GetTriggerPlayer()
            hcache.set(p, CONST_CACHE.PLAYER_STATUS, hplayer.player_status.leave)
            echo(cj.GetPlayerName(p) .. "离开了游戏～")
            hplayer.clearUnit(p)
            hplayer.qty_current = hplayer.qty_current - 1
            -- 触发玩家离开事件(全局)
            hevent.triggerEvent(
                "global",
                CONST_EVENT.playerLeave,
                {
                    triggerPlayer = p
                }
            )
        end),
        selection = cj.Condition(function()
            local triggerPlayer = cj.GetTriggerPlayer()
            local triggerUnit = cj.GetTriggerUnit()
            local click = hcache.get(triggerPlayer, CONST_CACHE.PLAYER_CLICK, nil)
            if (click == nil) then
                click = 0
            end
            hcache.set(triggerPlayer, CONST_CACHE.PLAYER_CLICK, click + 1)
            htime.setTimeout(0.3, function(ct)
                htime.delTimer(ct)
                hcache.set(triggerPlayer, CONST_CACHE.PLAYER_CLICK, hcache.get(triggerPlayer, CONST_CACHE.PLAYER_CLICK) - 1)
            end)
            for qty = 1, 10 do
                if (hcache.get(triggerPlayer, CONST_CACHE.PLAYER_CLICK) >= qty) then
                    hevent.triggerEvent(
                        triggerPlayer,
                        CONST_EVENT.selection .. "#" .. qty,
                        {
                            triggerPlayer = triggerPlayer,
                            triggerUnit = triggerUnit,
                            qty = qty
                        }
                    )
                end
            end
        end),
        chat = cj.Condition(function()
            hevent.triggerEvent(cj.GetTriggerPlayer(), CONST_EVENT.chat, {
                triggerPlayer = cj.GetTriggerPlayer(),
                chatString = cj.GetEventPlayerChatString()
            })
        end),
    },
    hero = {
        levelUp = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local diffLv = cj.GetHeroLevel(u) - hhero.getPrevLevel(u)
            if (diffLv < 1) then
                return
            end
            hhero.setPrevLevel(u, cj.GetHeroLevel(u))
            -- @触发升级事件
            hevent.triggerEvent(u, CONST_EVENT.levelUp, {
                triggerUnit = u,
                value = diffLv
            })
            -- 重读部分属性（因为有些属性在物编可升级提升）
            hattribute.set(u, 0, {
                str_white = "=" .. cj.GetHeroStr(u, false),
                agi_white = "=" .. cj.GetHeroAgi(u, false),
                int_white = "=" .. cj.GetHeroInt(u, false),
            })
            if (his.enablePunish(u)) then
                hmonitor.listen(CONST_MONITOR.PUNISH, u)
            end
        end),
        reborn = function(u, rebornSec)
            local x = hunit.x(u)
            local y = hunit.y(u)
            if (rebornSec > 0) then
                local p = hunit.getOwner(u)
                htexture.mark(htexture.DEFAULT_MARKS.DREAM, rebornSec, p, 255, 0, 0)
                local ghost = hunit.create({
                    register = false,
                    whichPlayer = hplayer.player_passive,
                    id = hunit.getId(u),
                    x = x,
                    y = y,
                    facing = 270,
                    height = 40,
                    modelScale = 0.9,
                    opacity = 0.6,
                    isShadow = true,
                    isInvulnerable = true,
                    during = rebornSec,
                })
                hunit.setColor(ghost, hplayer.index(p))
                hunit.create({
                    register = false,
                    whichPlayer = p,
                    id = HL_ID.hero_death_token,
                    x = x,
                    y = y,
                    opacity = 0.8,
                    isShadow = true,
                    isInvulnerable = true,
                    during = rebornSec,
                    timeScale = 10 / rebornSec,
                })
            end
            hhero.reborn(u, rebornSec, 1, x, y, true)
        end,
    },
    unit = {
        attackDetect = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.attackDetect,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    targetUnit = cj.GetEventTargetUnit()
                }
            )
        end),
        attackGetTarget = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.attackGetTarget,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    targetUnit = cj.GetEventTargetUnit()
                }
            )
        end),
        beAttackReady = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.beAttackReady,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    attackUnit = cj.GetAttacker()
                }
            )
        end),
        skillStudy = cj.Condition(function()
            local evtData = {
                triggerUnit = cj.GetTriggerUnit(),
                learnedSkill = cj.GetLearnedSkill(),
            }
            hevent.triggerEvent(evtData.triggerUnit, CONST_EVENT.skillStudy, evtData)
            local lv = cj.GetUnitAbilityLevel(evtData.triggerUnit, evtData.learnedSkill)
            if (lv == 1) then
                hskill.addProperty(evtData.triggerUnit, evtData.learnedSkill, lv)
            elseif (lv > 1) then
                hskill.subProperty(evtData.triggerUnit, evtData.learnedSkill, lv - 1)
                hskill.addProperty(evtData.triggerUnit, evtData.learnedSkill, lv)
            end
        end),
        skillReady = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillReady,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId(),
                    targetUnit = cj.GetSpellTargetUnit(),
                    targetLoc = cj.GetSpellTargetLoc()
                }
            )
        end),
        skillCast = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillCast,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId(),
                    targetUnit = cj.GetSpellTargetUnit(),
                    targetLoc = cj.GetSpellTargetLoc()
                }
            )
        end),
        skillStop = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillStop,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId()
                }
            )
        end),
        skillEffect = cj.Condition(function()
            local evtData = {
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
                targetUnit = cj.GetSpellTargetUnit(),
                targetItem = cj.GetSpellTargetItem(),
                targetLoc = cj.GetSpellTargetLoc(),
            }
            hevent.triggerEvent(evtData.triggerUnit, CONST_EVENT.skillEffect, evtData)
        end),
        skillFinish = cj.Condition(function()
            local evtData = {
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            }
            hevent.triggerEvent(evtData.triggerUnit, CONST_EVENT.skillFinish, evtData)
        end),
        upgradeStart = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeStart,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeCancel = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeCancel,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeFinish = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeFinish,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        damaged = cj.Condition(function()
            local sourceUnit = cj.GetEventDamageSource()
            local targetUnit = cj.GetTriggerUnit()
            local damage = cj.GetEventDamage()
            local curLife = hunit.getCurLife(targetUnit)
            local isLethal = curLife <= damage
            if (damage > 0.125) then
                local changeLife = math.floor(damage) + 1
                if (isLethal == true) then
                    cj.SetUnitInvulnerable(targetUnit, true)
                else
                    hattribute.set(targetUnit, 0, { life = "+" .. changeLife })
                end
                local isAttack = hjapi.isEventAttackDamage() or true
                local isPhysical = hjapi.isEventPhysicalDamage() or true
                local DType = cj.ConvertAttackType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
                htime.setTimeout(0, function(t)
                    htime.delTimer(t)
                    if (isLethal == true) then
                        cj.SetUnitInvulnerable(targetUnit, false)
                    else
                        hattribute.set(targetUnit, 0, { life = "-" .. changeLife })
                        hunit.setCurLife(targetUnit, curLife)
                    end
                    local damageSrc = CONST_DAMAGE_SRC.attack
                    local damageType
                    local breakArmorType = {}
                    local isFixed = false
                    if (false == isAttack) then
                        --- [非攻击]->[技能伤害]
                        damageSrc = CONST_DAMAGE_SRC.skill
                        --- [物理技能]->[物理伤害只判断技能]
                        if (isPhysical) then
                            damageType = { CONST_DAMAGE_TYPE.physical }
                        end
                    end
                    if (DType == DAMAGE_TYPE_ENHANCED) then
                        --- [强化]->[固伤]
                        isFixed = true
                    elseif (DType == DAMAGE_TYPE_DEMOLITION) then
                        --- [破坏]->[破防:无视回避]
                        breakArmorType = { CONST_BREAK_ARMOR_TYPE.avoid }
                    elseif (DType == DAMAGE_TYPE_MAGIC) then
                        --- [魔法]->[魔法]
                        damageType = { CONST_DAMAGE_TYPE.magic }
                    elseif (DType == DAMAGE_TYPE_POISON or DType == DAMAGE_TYPE_SLOW_POISON or DType == DAMAGE_TYPE_SHADOW_STRIKE or DType == DAMAGE_TYPE_ACID) then
                        --- [毒药|慢性毒药|暗影突袭|酸性]->[毒]
                        damageType = { CONST_DAMAGE_TYPE.poison }
                    elseif (DType == DAMAGE_TYPE_FIRE) then
                        --- [火焰]->[火]
                        damageType = { CONST_DAMAGE_TYPE.fire }
                    elseif (DType == DAMAGE_TYPE_COLD) then
                        --- [冰冻]->[冰]
                        damageType = { CONST_DAMAGE_TYPE.ice }
                    elseif (DType == DAMAGE_TYPE_LIGHTNING) then
                        --- [闪电]->[雷]
                        damageType = { CONST_DAMAGE_TYPE.thunder }
                    elseif (DType == DAMAGE_TYPE_PLANT) then
                        --- [植物]->[木]
                        damageType = { CONST_DAMAGE_TYPE.wood }
                    elseif (DType == DAMAGE_TYPE_DISEASE) then
                        --- [疾病]->[邪]
                        damageType = { CONST_DAMAGE_TYPE.evil }
                    elseif (DType == DAMAGE_TYPE_DEATH) then
                        --- [死亡]->[鬼]
                        damageType = { CONST_DAMAGE_TYPE.ghost }
                    elseif (DType == DAMAGE_TYPE_DIVINE) then
                        --- [神圣]->[圣]
                        damageType = { CONST_DAMAGE_TYPE.holy }
                    end
                    hskill.damage({
                        sourceUnit = sourceUnit,
                        targetUnit = targetUnit,
                        damage = damage,
                        damageSrc = damageSrc,
                        damageType = damageType,
                        breakArmorType = breakArmorType,
                        isFixed = isFixed,
                    })
                end)
            end
        end),
        dead = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local killer = hevent.getUnitLastDamageSource(u)
            if (killer ~= nil) then
                hplayer.addKill(hunit.getOwner(killer), 1)
            end
            -- 死亡标志
            hcache.set(u, CONST_CACHE.UNIT_DEAD, true)
            -- @触发死亡事件
            hevent.triggerEvent(u, CONST_EVENT.dead, {
                triggerUnit = u,
                killUnit = killer
            })
            -- @触发击杀事件
            hevent.triggerEvent(killer, CONST_EVENT.kill, {
                triggerUnit = killer,
                targetUnit = u
            })
            -- 如果不是英雄，自动清理，在3秒后尝试删除单位
            -- 如果其他单位需要不备清理，可死亡后立即设置缓存 hcache.set(u,CONST_CACHE.UNIT_NOT_DEL,true)
            -- * 只有框架内运行单位有效
            if (his.hero(u) == false) then
                htime.setTimeout(3, function(curTimer)
                    htime.delTimer(curTimer)
                    if (his.dead(u) and true ~= hcache.get(u, CONST_CACHE.UNIT_NOT_DEL)) then
                        hunit.del(u, 0)
                    end
                end)
            else
                -- 如果是英雄，检测属性重生秒数
                local rebornSec = hattribute.get(u, "reborn", -999)
                if (rebornSec >= 0) then
                    hevent_default_actions.hero.reborn(u, rebornSec)
                end
            end
        end),
        order = cj.Condition(function()
            --[[
                851983:ATTACK 攻击
                851971:SMART
                851986:MOVE 移动
                851993:HOLD 保持原位
                851972:STOP 停止
                852002~852007:移动物品栏
            ]]
            local triggerUnit = cj.GetTriggerUnit()
            local orderId = cj.GetIssuedOrderId()
            local orderTargetUnit = cj.GetOrderTargetUnit()
            local orderTargetItem = cj.GetOrderTargetItem()
            local loc = cj.GetOrderPointLoc()
            local lx = 1.11
            local ly = 2.22
            local lz = 3.33
            if (loc ~= nil) then
                lx = cj.GetLocationX(loc)
                ly = cj.GetLocationY(loc)
                lz = cj.GetLocationZ(loc)
                cj.RemoveLocation(loc)
                loc = nil
            elseif (orderTargetUnit ~= nil) then
                loc = cj.GetUnitLoc(orderTargetUnit)
                lx = cj.GetLocationX(loc)
                ly = cj.GetLocationY(loc)
                lz = cj.GetLocationZ(loc)
                cj.RemoveLocation(loc)
                loc = nil
            elseif (orderTargetItem ~= nil and not(orderId >= 852002 and orderId <= 852007)) then
                loc = cj.Location(cj.GetItemX(orderTargetItem), cj.GetItemY(orderTargetItem))
                lx = cj.GetLocationX(loc)
                ly = cj.GetLocationY(loc)
                lz = cj.GetLocationZ(loc)
                cj.RemoveLocation(loc)
                loc = nil
            end
            if (orderId == 851983 or orderId == 851971 or orderId == 851986
                or (lx ~= 1.11 and ly ~= 2.22 and lz ~= 3.33)) then
                local mov1 = hcache.get(triggerUnit, CONST_CACHE.MOVING, 0)
                if (mov1 == 0) then
                    hcache.set(triggerUnit, CONST_CACHE.MOVING, 1)
                    local x = math.floor(cj.GetUnitX(triggerUnit))
                    local y = math.floor(cj.GetUnitY(triggerUnit))
                    local step = 0
                    htime.setInterval(0.25, function(curTimer)
                        local mov2 = hcache.get(triggerUnit, CONST_CACHE.MOVING, 0)
                        if (mov2 == 0) then
                            htime.delTimer(curTimer)
                            return
                        end
                        local tx = math.floor(cj.GetUnitX(triggerUnit))
                        local ty = math.floor(cj.GetUnitY(triggerUnit))
                        if (mov2 == 1) then
                            -- 移动开始
                            if (tx ~= x or ty ~= y) then
                                hcache.set(triggerUnit, CONST_CACHE.MOVING, 2)
                                hevent.triggerEvent(
                                    triggerUnit,
                                    CONST_EVENT.moveStart,
                                    {
                                        triggerUnit = triggerUnit,
                                        targetLoc = cj.GetOrderPointLoc(),
                                    }
                                )
                            else
                                hcache.set(triggerUnit, CONST_CACHE.MOVING, 0)
                            end
                        elseif (mov2 == 2) then
                            -- 移动ing
                            step = step + 1
                            hevent.triggerEvent(
                                triggerUnit,
                                CONST_EVENT.moving,
                                {
                                    triggerUnit = triggerUnit,
                                    step = step,
                                }
                            )
                            if (tx == x and ty == y) then
                                -- 没位移，移动停止
                                hcache.set(triggerUnit, CONST_CACHE.MOVING, 0)
                                hevent.triggerEvent(
                                    triggerUnit,
                                    CONST_EVENT.moveStop,
                                    {
                                        triggerUnit = triggerUnit,
                                    }
                                )
                            end
                        end
                        x = tx
                        y = ty
                    end)
                end
            elseif (orderId == 851993) then
                hcache.set(triggerUnit, CONST_CACHE.MOVING, 0)
                hevent.triggerEvent(
                    triggerUnit,
                    CONST_EVENT.holdOn,
                    {
                        triggerUnit = triggerUnit,
                    }
                )
            elseif (orderId == 851972) then
                hcache.set(triggerUnit, CONST_CACHE.MOVING, 0)
                hevent.triggerEvent(
                    triggerUnit,
                    CONST_EVENT.stop,
                    {
                        triggerUnit = triggerUnit,
                    }
                )
            end
        end),
        sell = cj.Condition(function()
            local u = cj.GetSoldUnit()
            hunit.embed(u)
            hevent.triggerEvent(
                cj.GetSellingUnit(),
                CONST_EVENT.unitSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldUnit = u,
                    buyingUnit = cj.GetBuyingUnit(),
                }
            )
        end),
    },
    dialog = {
        click = cj.Condition(function()
            local clickedDialog = cj.GetClickedDialog()
            local clickedButton = cj.GetClickedButton()
            local buttons = hcache.get(clickedDialog, CONST_CACHE.DIALOG_BUTTON, nil)
            if (buttons == nil) then
                return
            end
            local val
            for _, b in ipairs(buttons) do
                if (b.button == clickedButton) then
                    val = b.value
                end
            end
            local action = hcache.get(clickedDialog, CONST_CACHE.DIALOG_ACTION, nil)
            if (type(action) == 'function') then
                action(val)
            end
            hdialog.del(clickedDialog)
        end)
    },
    item = {
        pickup = cj.Condition(function()
            local it = cj.GetManipulatedItem()
            local itId = cj.GetItemTypeId(it)
            if (itId == 0 or table.includes(HL_ID.item_attack_white.items, itId)) then
                --过滤无效物品
                return
            end
            itId = string.id2char(itId)
            local u = cj.GetTriggerUnit()
            local charges = hitem.getCharges(it)
            -- 反向检测丢弃物品事件
            local holder = hitem.getHolder(it)
            if (nil ~= holder and holder ~= u) then
                hevent.triggerEvent(holder, CONST_EVENT.itemDrop, { triggerUnit = holder, triggerItem = it, targetUnit = u })
            end
            -- 判断玩家是否不能获取他人物品
            local lastHolder = hitem.getLastHolder(it)
            if (hitem.isRobber(it, u)) then
                -- 得到了别人先获得过的物品，不准拿
                htextTag.style(
                    htextTag.create2Unit(u, "不是你的不要捡", 8.00, "e04240", 1, 1.1, 50.00),
                    "scale", 0, 0.05
                )
                hitem.backToLastHolder(it)
                return
            end
            -- 判断超重
            local newWeight = hattribute.get(u, "weight_current") + hitem.getWeight(itId, charges)
            if (newWeight > hattribute.get(u, "weight")) then
                local exWeight = math.round(newWeight - hattribute.get(u, "weight"))
                httg.model({
                    msg = "超重" .. exWeight .. "KG",
                    width = 10,
                    scale = 0.25,
                    speed = 0.5,
                    whichUnit = u,
                    red = 255,
                    green = 0,
                    blue = 0,
                })
                -- 判断如果是真实物品并且有影子，转为影子物品
                if (hitem.isShadowFront(itId)) then
                    itId = hitem.shadowID(itId)
                end
                hitem.del(it)
                it = cj.CreateItem(string.char2id(itId), hunit.x(u), hunit.y(u))
                cj.SetItemCharges(it, charges)
                hcache.alloc(it)
                hitem.setLastHolder(it, lastHolder)
                -- 触发超重事件
                hevent.triggerEvent(u, CONST_EVENT.itemOverWeight, {
                    triggerUnit = u,
                    triggerItem = it,
                    value = exWeight
                })
                return
            end
            -- 如果是影子物品
            if (hitem.isShadowBack(itId)) then
                itId = hitem.shadowID(itId)
                hitem.del(it)
                it = cj.CreateItem(string.char2id(itId), hunit.x(u), hunit.y(u))
                cj.SetItemCharges(it, charges)
                hitem.setLastHolder(it, lastHolder)
                if (hitem.getEmptySlot(u) <= 0) then
                    hitem.synthesis(u, it) -- 看看有没有合成，可能这个实体物品有合成可以收到物品栏
                else
                    cj.UnitAddItem(u, it)
                end
                return
            end
            -- 触发获得物品
            local evtData = { triggerUnit = u, triggerItem = it }
            hevent.triggerEvent(u, CONST_EVENT.itemGet, evtData)
            if (false == his.destroy(it)) then
                -- 如果是自动使用的，用一波
                if (hitem.getIsPowerUp(itId)) then
                    hitem.used(u, it)
                    if (hitem.getIsPerishable(itId)) then
                        hitem.del(it, 0)
                        return
                    end
                end
                -- cache
                if (false == hcache.exist(it)) then
                    hcache.alloc(it)
                end
                -- 设置持有单位
                hitem.setHolder(it, u)
                hitemPool.delete(CONST_CACHE.ITEM_POOL_PICK, it)
                -- 计算属性
                hitem.addProperty(u, itId, charges)
                -- 检查合成
                hitem.synthesis(u)
            end
        end),
        drop = cj.Condition(function()
            local it = cj.GetManipulatedItem()
            local itId = cj.GetItemTypeId(it)
            if (itId == 0 or table.includes(HL_ID.item_attack_white.items, itId)) then
                --过滤无效物品
                return
            end
            itId = string.id2char(itId)
            local u = cj.GetTriggerUnit()
            if (cj.GetUnitCurrentOrder(u) == 852001) then
                -- dropitem:852001
                local charges = cj.GetItemCharges(it)
                hitem.subProperty(u, itId, charges)
                local xyk1 = math.round(cj.GetItemX(it)) .. "|" .. math.round(cj.GetItemY(it))
                htime.setTimeout(0.05, function(t)
                    htime.delTimer(t)
                    if (false == his.destroy(it)) then
                        local x = cj.GetItemX(it)
                        local y = cj.GetItemY(it)
                        local xyk2 = math.round(x) .. "|" .. math.round(y)
                        if (xyk1 == xyk2) then
                            --坐标相同视为给予单位类型（几乎不可能坐标一致）
                            return
                        end
                        hitem.setHolder(it, nil)
                        hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
                        if (hitem.isShadowFront(itId)) then
                            local lastHolder = hitem.getLastHolder(it)
                            hitem.del(it, 0)
                            -- 影子物品替换
                            it = hitem.create({
                                id = hitem.shadowID(itId),
                                x = x,
                                y = y,
                                charges = charges,
                            })
                            hcache.alloc(it)
                            hitem.setLastHolder(it, lastHolder)
                        end
                    end
                    --触发丢弃物品事件
                    hevent.triggerEvent(u, CONST_EVENT.itemDrop, {
                        triggerUnit = u,
                        triggerItem = it,
                        targetUnit = nil,
                    })
                end)
            end
        end),
        pawn = cj.Condition(function()
            --[[
                抵押物品的原理，首先默认是设定：物品售卖为50%，也就是地图的默认设置
                根据玩家的sellRatio，额外的减少或增加玩家的收入
                从而实现玩家的售卖率提升，至于物品的价格是根据slk获取
                所以如果无法获取slk的属性时，此方法自动无效
            ]]
            local u = cj.GetTriggerUnit()
            local it = cj.GetSoldItem()
            local goldcost = hitem.getGoldCost(it)
            local lumbercost = hitem.getLumberCost(it)
            local soldGold = 0
            local soldLumber = 0
            if (goldcost ~= 0 or lumbercost ~= 0) then
                local p = hunit.getOwner(u)
                local sellRatio = hplayer.getSellRatio(u)
                if (sellRatio ~= 50) then
                    if (sellRatio < 0) then
                        sellRatio = 0
                    elseif (sellRatio > 1000) then
                        sellRatio = 1000
                    end
                    local tempRatio = sellRatio - 50.0
                    soldGold = math.floor(goldcost * tempRatio * 0.01)
                    soldLumber = math.floor(lumbercost * tempRatio * 0.01)
                    if (goldcost ~= 0 and soldGold ~= 0) then
                        hplayer.addGold(p, soldGold)
                    end
                    if (lumbercost ~= 0 and soldLumber ~= 0) then
                        hplayer.addLumber(p, soldLumber)
                    end
                end
            end
            --触发抵押物品事件
            hevent.triggerEvent(u, CONST_EVENT.itemPawn, {
                triggerUnit = u,
                soldItem = it,
                buyingUnit = cj.GetBuyingUnit(),
                soldGold = soldGold,
                soldLumber = soldLumber,
            })
        end),
        use = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            if (his.silent(u)) then
                return
            end
            local it = cj.GetManipulatedItem()
            local itId = hitem.getId(it)
            local perishable = hitem.getIsPerishable(itId)
            --检测是否有匹配使用
            local triggerData = hcache.get(u, CONST_CACHE.ITEM_USED .. itId)
            if (triggerData ~= nil) then
                hitem.used(u, it, triggerData)
            end
            hcache.set(u, CONST_CACHE.ITEM_USED .. itId, nil)
            --检测是否使用后自动消失，如果不是，次数补回1
            if (perishable == false) then
                hitem.setCharges(it, cj.GetItemCharges(it) + 1)
            else
                hitem.subProperty(u, itId, 1)
                if (cj.GetItemCharges(it) <= 0) then
                    hitem.del(it)
                end
            end
        end),
        use_s = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            if (his.silent(u)) then
                return
            end
            local skillId = string.id2char(cj.GetSpellAbilityId())
            local itId = HSLK_ICD[skillId] or nil
            if (itId == nil) then
                return
            end
            hcache.set(u, CONST_CACHE.ITEM_USED .. itId, {
                triggerSkill = skillId,
                targetUnit = cj.GetSpellTargetUnit(),
                targetLoc = cj.GetSpellTargetLoc(),
            })
        end),
        sell = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetSellingUnit(),
                CONST_EVENT.itemSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldItem = cj.GetSoldItem(),
                    buyingUnit = cj.GetBuyingUnit()
                }
            )
        end),
        destroy = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetManipulatedItem(),
                CONST_EVENT.itemDestroy,
                {
                    triggerItem = cj.GetManipulatedItem(),
                    triggerUnit = cj.GetKillingUnit()
                }
            )
        end),
    },
    destructable = {
        destroy = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerDestructable(),
                CONST_EVENT.destructableDestroy,
                {
                    triggerDestructable = cj.GetTriggerDestructable()
                }
            )
        end)
    }
}
