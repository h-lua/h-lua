--- 框架默认事件动作
--- default event actions
hevent_binder = {
    player = {
        esc = cj.Condition(function()
            hevent.trigger(
                cj.GetTriggerPlayer(),
                CONST_EVENT.esc,
                {
                    triggerPlayer = cj.GetTriggerPlayer()
                }
            )
        end),
        deSelection = cj.Condition(function()
            hevent.trigger(
                cj.GetTriggerPlayer(),
                CONST_EVENT.deSelection,
                {
                    triggerPlayer = cj.GetTriggerPlayer(),
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructStart = cj.Condition(function()
            hevent.trigger(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructStart,
                {
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructCancel = cj.Condition(function()
            hevent.trigger(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructCancel,
                {
                    triggerUnit = cj.GetCancelledStructure()
                }
            )
        end),
        constructFinish = cj.Condition(function()
            hevent.trigger(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructFinish,
                {
                    triggerUnit = cj.GetConstructedStructure()
                }
            )
        end),
        apm = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            if (hunit.isLocust(u)) then
                return
            end
            local p = hunit.getOwner(u)
            if (hplayer.isPlaying(p) == true and hplayer.isUser(p) == true and hplayer.isComputer(p) == false) then
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
            hevent.trigger(
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
                ct.destroy()
                hcache.set(triggerPlayer, CONST_CACHE.PLAYER_CLICK, hcache.get(triggerPlayer, CONST_CACHE.PLAYER_CLICK) - 1)
            end)
            for qty = 1, 10 do
                if (hcache.get(triggerPlayer, CONST_CACHE.PLAYER_CLICK) >= qty) then
                    hevent.trigger(
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
            hevent.trigger(cj.GetTriggerPlayer(), CONST_EVENT.chat, {
                triggerPlayer = cj.GetTriggerPlayer(),
                chatString = cj.GetEventPlayerChatString()
            })
        end),
        changeOwner = cj.Condition(function()
            hevent.trigger(hunit.getOwner(cj.GetTriggerUnit()), CONST_EVENT.changeOwner, {
                triggerUnit = cj.GetChangingUnit(),
                prevOwner = cj.GetChangingUnitPrevOwner()
            })
        end),
        beAttackReady = cj.Condition(function()
            hevent.trigger(cj.GetTriggerUnit(), CONST_EVENT.beAttackReady, {
                triggerUnit = cj.GetTriggerUnit(),
                attackUnit = cj.GetAttacker()
            })
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
            hevent.trigger(u, CONST_EVENT.dead, {
                triggerUnit = u,
                killUnit = killer
            })
            -- @触发击杀事件
            hevent.trigger(killer, CONST_EVENT.kill, {
                triggerUnit = killer,
                targetUnit = u
            })
            -- 如果不是英雄，自动清理，在3秒后尝试删除单位
            -- 如果其他单位需要不备清理，可死亡后立即设置缓存 hcache.set(u,CONST_CACHE.UNIT_NOT_DEL,true)
            -- * 只有框架内运行单位有效
            if (hunit.isHero(u) == false) then
                htime.setTimeout(3, function(curTimer)
                    curTimer.destroy()
                    if (hunit.isDead(u) and true ~= hcache.get(u, CONST_CACHE.UNIT_NOT_DEL)) then
                        hunit.destroy(u, 0)
                    end
                end)
            else
                -- 如果是英雄，检测属性重生秒数
                local rebornSec = hattribute.get(u, "reborn", -999)
                if (rebornSec >= 0) then
                    hevent_binder.hero.reborn(u, rebornSec)
                end
            end
        end),
        issued = cj.Condition(function()
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
            elseif (orderTargetItem ~= nil and not (orderId >= 852002 and orderId <= 852007)) then
                loc = cj.Location(cj.GetItemX(orderTargetItem), cj.GetItemY(orderTargetItem))
                lx = cj.GetLocationX(loc)
                ly = cj.GetLocationY(loc)
                lz = cj.GetLocationZ(loc)
                cj.RemoveLocation(loc)
                loc = nil
            end
            if (orderId == 851993) then
                hevent.trigger(
                    triggerUnit,
                    CONST_EVENT.holdOn,
                    {
                        triggerUnit = triggerUnit,
                    }
                )
            elseif (orderId == 851972) then
                hevent.trigger(
                    triggerUnit,
                    CONST_EVENT.stop,
                    {
                        triggerUnit = triggerUnit,
                    }
                )
            end
        end),
        skillStudy = cj.Condition(function()
            local evtData = {
                triggerUnit = cj.GetTriggerUnit(),
                learnedSkill = cj.GetLearnedSkill(),
            }
            hevent.trigger(evtData.triggerUnit, CONST_EVENT.skillStudy, evtData)
            local lv = cj.GetUnitAbilityLevel(evtData.triggerUnit, c2i(evtData.learnedSkill))
            if (lv == 1) then
                hskill.addProperty(evtData.triggerUnit, evtData.learnedSkill, lv)
            elseif (lv > 1) then
                hskill.subProperty(evtData.triggerUnit, evtData.learnedSkill, lv - 1)
                hskill.addProperty(evtData.triggerUnit, evtData.learnedSkill, lv)
            end
        end),
        skillReady = cj.Condition(function()
            hevent.trigger(
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
            hevent.trigger(
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
            hevent.trigger(
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
                targetDestructable = cj.GetSpellTargetDestructable(),
            }
            hevent.trigger(evtData.triggerUnit, CONST_EVENT.skillEffect, evtData)
        end),
        skillFinish = cj.Condition(function()
            local evtData = {
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            }
            hevent.trigger(evtData.triggerUnit, CONST_EVENT.skillFinish, evtData)
        end),
        levelUp = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local diffLv = cj.GetHeroLevel(u) - hhero.getPrevLevel(u)
            if (diffLv < 1) then
                return
            end
            hhero.setPrevLevel(u, cj.GetHeroLevel(u))
            -- @触发升级事件
            hevent.trigger(u, CONST_EVENT.levelUp, {
                triggerUnit = u,
                value = diffLv
            })
            -- 重读部分属性（因为有些属性在物编可升级提升）
            hattribute.set(u, 0, {
                str_white = "=" .. cj.GetHeroStr(u, false),
                agi_white = "=" .. cj.GetHeroAgi(u, false),
                int_white = "=" .. cj.GetHeroInt(u, false),
            })
        end),
        upgradeStart = cj.Condition(function()
            hevent.trigger(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeStart,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeCancel = cj.Condition(function()
            hevent.trigger(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeCancel,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeFinish = cj.Condition(function()
            hevent.trigger(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeFinish,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        sellUnit = cj.Condition(function()
            local u = cj.GetSoldUnit()
            hunit.embed(u)
            hevent.trigger(
                cj.GetSellingUnit(),
                CONST_EVENT.unitSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldUnit = u,
                    buyingUnit = cj.GetBuyingUnit(),
                }
            )
        end),
        pickupItem = cj.Condition(function()
            local it = cj.GetManipulatedItem()
            local itId = cj.GetItemTypeId(it)
            if (itId == 0) then
                --过滤无效物品
                return
            end
            itId = i2c(itId)
            local u = cj.GetTriggerUnit()
            local charges = hitem.getCharges(it)
            -- 触发获得物品
            local evtData = { triggerUnit = u, triggerItem = it }
            hevent.trigger(u, CONST_EVENT.itemGet, evtData)
            if (false == hitem.isDestroyed(it)) then
                -- 如果是自动使用的，用一波
                if (hitem.getIsPowerUp(itId)) then
                    hitem.used(u, it)
                    if (hitem.getIsPerishable(itId)) then
                        hitem.destroy(it, 0)
                        return
                    end
                end
                -- cache
                if (false == hcache.exist(it)) then
                    hcache.alloc(it)
                end
                hitemPool.delete(CONST_CACHE.ITEM_POOL_PICK, it)
                -- 计算属性
                hitem.addProperty(u, itId, charges)
            end
        end),
        dropItem = cj.Condition(function()
            local it = cj.GetManipulatedItem()
            local itId = cj.GetItemTypeId(it)
            if (itId == 0) then
                --过滤无效物品
                return
            end
            itId = i2c(itId)
            local u = cj.GetTriggerUnit()
            if (cj.GetUnitCurrentOrder(u) == 852001) then
                -- dropitem:852001
                local charges = cj.GetItemCharges(it)
                hitem.subProperty(u, itId, charges)
                local xyk1 = math.round(cj.GetItemX(it)) .. "|" .. math.round(cj.GetItemY(it))
                htime.setTimeout(0.05, function(t)
                    t.destroy()
                    if (false == hitem.isDestroyed(it)) then
                        local x = cj.GetItemX(it)
                        local y = cj.GetItemY(it)
                        local xyk2 = math.round(x) .. "|" .. math.round(y)
                        if (xyk1 == xyk2) then
                            --坐标相同视为给予单位类型（几乎不可能坐标一致）
                            return
                        end
                        hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
                    end
                    --触发丢弃物品事件
                    hevent.trigger(u, CONST_EVENT.itemDrop, {
                        triggerUnit = u,
                        triggerItem = it,
                        targetUnit = nil,
                    })
                end)
            end
        end),
        pawnItem = cj.Condition(function()
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
            hevent.trigger(u, CONST_EVENT.itemPawn, {
                triggerUnit = u,
                soldItem = it,
                buyingUnit = cj.GetBuyingUnit(),
                soldGold = soldGold,
                soldLumber = soldLumber,
            })
        end),
        useItem = cj.Condition(function()
            local u = cj.GetTriggerUnit()
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
            if (perishable == true) then
                hitem.subProperty(u, itId, 1)
                if (cj.GetItemCharges(it) <= 0) then
                    hitem.destroy(it)
                end
            end
        end),
        useItemX = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local skillId = i2c(cj.GetSpellAbilityId())
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
        sellItem = cj.Condition(function()
            hevent.trigger(
                cj.GetSellingUnit(),
                CONST_EVENT.itemSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldItem = cj.GetSoldItem(),
                    buyingUnit = cj.GetBuyingUnit()
                }
            )
        end),
    },
    hero = {
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
            hhero.reborn(u, rebornSec, 1, x, y)
        end,
    },
    unit = {
        damaged = cj.Condition(function()
            local sourceUnit = cj.GetEventDamageSource()
            local targetUnit = cj.GetTriggerUnit()
            local damage = cj.GetEventDamage()
            hjapi.EXSetEventDamage(0)
            if (damage > 0.125) then
                local isAttack = hjapi.IsEventAttackDamage() or true
                htime.setTimeout(0, function()
                    local damageSrc = CONST_DAMAGE_SRC.attack
                    if (false == isAttack) then
                        --- [非攻击]->[技能伤害]
                        damageSrc = CONST_DAMAGE_SRC.skill
                    end
                    hskill.damage({
                        sourceUnit = sourceUnit,
                        targetUnit = targetUnit,
                        damage = damage,
                        damageSrc = damageSrc,
                    })
                end)
            end
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
            hcache.free(clickedDialog)
            cj.DialogClear(clickedDialog)
            cj.DialogDestroy(clickedDialog)
        end)
    },
    item = {
        destroy = cj.Condition(function()
            hevent.trigger(
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
            hevent.trigger(
                cj.GetTriggerDestructable(),
                CONST_EVENT.destructableDestroy,
                {
                    triggerDestructable = cj.GetTriggerDestructable()
                }
            )
        end)
    }
}
