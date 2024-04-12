-- hslk 初始化
hslk_init()

-- 全局秒钟
cj.TimerStart(cj.CreateTimer(), 0.01, true, htime.clock)

-- 预读 preReadUnit
local preReadUnit = cj.CreateUnit(hplayer.player_passive, HL_ID.unit_token, 0, 0, 0)
hattributeSetter.relyRegister(preReadUnit)
hunit.destroy(preReadUnit)

-- 同步
hsync.init()

hcache.alloc("global")
hcache.protect("global")

for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    -- init
    hplayer.players[i] = cj.Player(i - 1)
    -- 英雄模块初始化
    hhero.player_allow_qty[i] = 1
    hhero.player_heroes[i] = {}

    cj.SetPlayerHandicapXP(hplayer.players[i], 0) -- 经验置0

    hcache.alloc(hplayer.players[i])
    hcache.protect(hplayer.players[i])
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_GOLD_PREV, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_GOLD_TOTAL, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_GOLD_COST, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_GOLD_RATIO, 100)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_LUMBER_PREV, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_LUMBER_TOTAL, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_LUMBER_COST, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_LUMBER_RATIO, 100)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_EXP_RATIO, 100)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_SELL_RATIO, 50)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_APM, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_DAMAGE, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BE_DAMAGE, 0)
    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_KILL, 0)
    if ((cj.GetPlayerController(hplayer.players[i]) == MAP_CONTROL_USER)
        and (cj.GetPlayerSlotState(hplayer.players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
        --
        hplayer.qty_current = hplayer.qty_current + 1
        hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_STATUS, hplayer.player_status.gaming)
    else
        hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_STATUS, hplayer.player_status.none)
    end
    --evt
    hevent.pool(hevent_binder.player.leave, function(tgr)
        cj.TriggerRegisterPlayerEvent(tgr, hplayer.players[i], EVENT_PLAYER_LEAVE)
    end)
    hevent.pool(hevent_binder.player.dead, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_DEATH, nil)
    end)
    hevent.pool(hevent_binder.player.beAttackReady, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_ATTACKED, nil)
    end)
    hevent.pool(hevent_binder.player.skillReady, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_CHANNEL, nil)
    end)
    hevent.pool(hevent_binder.player.skillCast, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_CAST, nil)
    end)
    hevent.pool(hevent_binder.player.skillEffect, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_EFFECT, nil)
    end)
    hevent.pool(hevent_binder.player.skillStop, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_ENDCAST, nil)
    end)
    hevent.pool(hevent_binder.player.skillFinish, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_FINISH, nil)
    end)
    hevent.pool(hevent_binder.player.changeOwner, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_CHANGE_OWNER, nil)
    end)
    hevent.pool(hevent_binder.player.levelUp, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_HERO_LEVEL, nil)
    end)
    hevent.pool(hevent_binder.player.skillStudy, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_HERO_SKILL, nil)
    end)
    hevent.pool(hevent_binder.player.upgradeStart, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_UPGRADE_START, nil)
    end)
    hevent.pool(hevent_binder.player.upgradeCancel, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_UPGRADE_CANCEL, nil)
    end)
    hevent.pool(hevent_binder.player.upgradeFinish, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_UPGRADE_FINISH, nil)
    end)
    hevent.pool(hevent_binder.player.constructStart, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
    end)
    hevent.pool(hevent_binder.player.constructCancel, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
    end)
    hevent.pool(hevent_binder.player.constructFinish, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, nil)
    end)
    hevent.pool(hevent_binder.player.sellUnit, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SELL, nil)
    end)
    hevent.pool(hevent_binder.player.sellItem, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SELL_ITEM, nil)
    end)
    hevent.pool(hevent_binder.player.pickupItem, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_PICKUP_ITEM, nil)
    end)
    hevent.pool(hevent_binder.player.dropItem, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_DROP_ITEM, nil)
    end)
    hevent.pool(hevent_binder.player.pawnItem, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_PAWN_ITEM, nil)
    end)
    hevent.pool(hevent_binder.player.useItem, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_USE_ITEM, nil)
    end)
    hevent.pool(hevent_binder.player.useItemX, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SPELL_EFFECT, nil)
    end)
    if (hplayer.isComputer(hplayer.players[i]) == false) then
        hevent.pool(hevent_binder.player.esc, function(tgr)
            cj.TriggerRegisterPlayerEvent(tgr, hplayer.players[i], EVENT_PLAYER_END_CINEMATIC)
        end)
        hevent.pool(hevent_binder.player.chat, function(tgr)
            cj.TriggerRegisterPlayerChatEvent(tgr, hplayer.players[i], "", false)
            hevent_chat_pattern[i] = Array()
            hevent.register(hplayer.players[i], CONST_EVENT.chat, function(evtData)
                ---@type Array
                hevent_chat_pattern[hplayer.index(evtData.triggerPlayer)].forEach(function(p, c)
                    local m = string.match(evtData.chatString, p)
                    if (m ~= nil) then
                        evtData.matchedString = m
                        c(evtData)
                    end
                end)
            end)
        end)
        hevent.pool(hevent_binder.player.selection, function(tgr)
            cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_SELECTED, nil)
        end)
        hevent.pool(hevent_binder.player.deSelection, function(tgr)
            cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_DESELECTED, nil)
        end)
        hevent.pool(hevent_binder.player.issued, function(tgr)
            cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
            cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
            cj.TriggerRegisterPlayerUnitEvent(tgr, hplayer.players[i], EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
        end)
        hevent.onSelection(hplayer.players[i], 1, function(evtData)
            hcache.set(evtData.triggerPlayer, CONST_CACHE.PLAYER_SELECTION, evtData.triggerUnit)
        end)
        hevent.onDeSelection(hplayer.players[i], function(evtData)
            hcache.set(evtData.triggerPlayer, CONST_CACHE.PLAYER_SELECTION, nil)
        end)
    end
end

--- debug
if (DEBUGGING) then
    local debugUI = hjapi.DzCreateFrameByTagName("TEXT", "StandardSmallTextTemplate", hjapi.DzGetGameUI(), "DEBUG-UI", 0)
    hjapi.DzFrameSetPoint(debugUI, FRAME_ALIGN_LEFT, hjapi.DzGetGameUI(), FRAME_ALIGN_LEFT, 0.001, 0.06)
    hjapi.DzFrameSetTextAlignment(debugUI, TEXT_ALIGN_LEFT)
    hjapi.DzFrameSetFont(debugUI, 'fonts.ttf', 8 * 0.001, 0)
    hjapi.DzFrameSetAlpha(debugUI, 210)
    local types = { "all", "max" }
    local typesLabel = {
        all = "总共",
        max = "最大值",
        ["+tmr"] = "计时器",
        ["+ply"] = "玩家",
        ["+frc"] = "玩家势力",
        ["+flt"] = "过滤器",
        ["+w3u"] = "单位",
        ["+w3d"] = "可破坏物",
        ["+grp"] = "单位组",
        ["+rct"] = "区域",
        ["+snd"] = "声音",
        ["+que"] = "任务",
        ["+trg"] = "触发器",
        ["+tac"] = "触发器动作",
        ["+EIP"] = "对点特效",
        ["+EIm"] = "附着特效",
        ["+loc"] = "点",
        ["pcvt"] = "玩家聊天事件",
        ["pevt"] = "玩家事件",
        ["uevt"] = "单位事件",
        ["tcnd"] = "触发器条件",
        ["wdvt"] = "可破坏物事件",
        ["item"] = "物品",
    }
    collectgarbage("collect")
    local rem0 = collectgarbage("count")
    local debugData = function()
        local count = { all = 0, max = JassDebug.handlemax() }
        for c = 1, count.max do
            local h = 0x100000 + c
            local info = JassDebug.handledef(h)
            if (info and info.type) then
                if (not table.includes(types, info.type)) then
                    table.insert(types, info.type)
                end
                if (count[info.type] == nil) then
                    count[info.type] = 0
                end
                count.all = count.all + 1
                count[info.type] = count[info.type] + 1
            end
        end
        local txts = {
            " ————————————————"
        }
        for _, t in ipairs(types) do
            table.insert(txts, "  " .. (typesLabel[t] or t) .. " : " .. (count[t] or 0))
        end
        table.insert(txts, " ————————————————")
        local i = 0
        for _, _ in pairs(htime.kernel) do
            i = i + 1
        end
        table.insert(txts, hcolor.sky("  计时内核 : " .. i))
        table.insert(txts, " ————————————————")
        table.insert(txts, hcolor.gold("  内存消耗 : " .. math.round((collectgarbage("count") - rem0) / 1024, 2) .. ' MB'))
        table.insert(txts, " ————————————————")
        return txts
    end
    htime.setInterval(2, function(_)
        hjapi.DzFrameSetText(debugUI, string.implode('|n', debugData()))
    end)
end

-- register APM
hevent.pool("global", hevent_binder.player.apm, function(tgr)
    hplayer.forEach(function(enumPlayer)
        cj.TriggerRegisterPlayerUnitEvent(tgr, enumPlayer, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
        cj.TriggerRegisterPlayerUnitEvent(tgr, enumPlayer, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
        cj.TriggerRegisterPlayerUnitEvent(tgr, enumPlayer, EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
    end)
end)

-- 恢复生命监听器
hmonitor.create(CONST_MONITOR.LIFE_BACK, 0.5,
    function(object)
        local val = hattribute.get(object, "life_back")
        hunit.addCurLife(object, val * 0.5)
    end,
    function(object)
        if (hunit.isDestroyed(object) or hunit.isDead(object)) then
            return true
        end
        local val = hattribute.get(object, "life_back")
        if (hunit.getMaxLife(object) <= 0 or val == 0) then
            return true
        end
        return false
    end
)

-- 恢复魔法监听器
hmonitor.create(CONST_MONITOR.MANA_BACK, 0.7,
    function(object)
        local val = hattribute.get(object, "mana_back")
        hunit.addCurMana(object, val * 0.7)
    end,
    function(object)
        if (hunit.isDestroyed(object) or hunit.isDead(object)) then
            return true
        end
        local val = hattribute.get(object, "mana_back")
        if (hunit.getMaxMana(object) <= 0 or val == 0) then
            return true
        end
        return false
    end
)
