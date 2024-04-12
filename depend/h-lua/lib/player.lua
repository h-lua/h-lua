---@class hplayer
hplayer = {
    --- 用户玩家
    players = {},
    --- 中立敌对
    player_aggressive = cj.Player(PLAYER_NEUTRAL_AGGRESSIVE),
    --- 中立受害
    player_victim = cj.Player(bj_PLAYER_NEUTRAL_VICTIM),
    --- 中立特殊
    player_extra = cj.Player(bj_PLAYER_NEUTRAL_EXTRA),
    --- 中立被动
    player_passive = cj.Player(PLAYER_NEUTRAL_PASSIVE),
    --- 玩家状态
    player_status = {
        none = "无参与",
        gaming = "游戏中",
        leave = "已离开"
    },
    --- 用户玩家最大数量
    qty_max = 12,
    --- 当前玩家数量
    qty_current = 0,
    --- 换算比率，默认：1000000金 -> 1木
    ---@private
    convert_ratio = 1000000
}

--- 是否电脑(如果位置为电脑玩家或无玩家，则为true)
--- 常用来判断电脑AI是否开启
---@param whichPlayer userdata
---@return boolean
function hplayer.isComputer(whichPlayer)
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER or cj.GetPlayerSlotState(whichPlayer) ~= PLAYER_SLOT_STATE_PLAYING
end

--- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)
--- 常用来判断该是否玩家可填补位置
---@param whichPlayer userdata
---@return boolean
function hplayer.isUser(whichPlayer)
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER
end

--- 是否正在游戏
---@param whichPlayer userdata
---@return boolean
function hplayer.isPlaying(whichPlayer)
    return cj.GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING
end

--- 是否中立玩家（包括中立敌对 中立被动 中立受害 中立特殊）
---@param whichPlayer userdata
---@return boolean
function hplayer.isNeutral(whichPlayer)
    return cj.GetPlayerId(whichPlayer) >= 12
end

--- 玩家是否正在受伤
---@param whichPlayer userdata
---@return boolean
function hplayer.isBeDamaging(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.ATTR_BE_DAMAGING, false)
end

--- 玩家是否正在造成伤害
---@param whichPlayer userdata
---@return boolean
function hplayer.isDamaging(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.ATTR_DAMAGING, false)
end

--- 玩家是否有贴图在展示
---@param whichPlayer userdata
---@return boolean
function hplayer.isMarking(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_MARKING) == true
end

---@private
function hplayer.adjustPlayerState(delta, whichPlayer, whichPlayerState)
    if delta > 0 then
        if whichPlayerState == PLAYER_STATE_RESOURCE_GOLD then
            cj.SetPlayerState(
                whichPlayer,
                PLAYER_STATE_GOLD_GATHERED,
                cj.GetPlayerState(whichPlayer, PLAYER_STATE_GOLD_GATHERED) + delta
            )
        elseif whichPlayerState == PLAYER_STATE_RESOURCE_LUMBER then
            cj.SetPlayerState(
                whichPlayer,
                PLAYER_STATE_LUMBER_GATHERED,
                cj.GetPlayerState(whichPlayer, PLAYER_STATE_LUMBER_GATHERED) + delta
            )
        end
    end
    cj.SetPlayerState(whichPlayer, whichPlayerState, cj.GetPlayerState(whichPlayer, whichPlayerState) + delta)
end

---@private
function hplayer.setPlayerState(whichPlayer, whichPlayerState, value)
    local oldValue = cj.GetPlayerState(whichPlayer, whichPlayerState)
    hplayer.adjustPlayerState(value - oldValue, whichPlayer, whichPlayerState)
end

--- 遍历玩家
--- 遍历过程中返回 false 则中断
---@param action fun(enumPlayer:userdata, idx:number)
function hplayer.forEach(action)
    if (action == nil) then
        return
    end
    if (type(action) == "function") then
        for idx = 1, hplayer.qty_max, 1 do
            local res = action(hplayer.players[idx], idx)
            if (type(res) == "boolean" and res == false) then
                break
            end
        end
    end
end

--- 玩家ID索引
---@protected
hplayer.indexes = {}

--- 获取玩家ID
--- 例如：玩家一等于1，玩家三等于3
---@param whichPlayer userdata
---@return number
function hplayer.index(whichPlayer)
    local idx
    if (hplayer.indexes[whichPlayer] ~= nil) then
        idx = hplayer.indexes[whichPlayer]
    else
        idx = cj.GetPlayerId(whichPlayer) + 1
        hplayer.indexes[whichPlayer] = idx
    end
    return idx
end

--- 获取本地玩家
---@return userdata player
function hplayer.loc()
    return cj.GetLocalPlayer()
end

--- 设置换算比率，多少金换1木
---@param ratio number
function hplayer.setConvertRatio(ratio)
    if (type(ratio) == "number") then
        hplayer.convert_ratio = math.floor(ratio)
    end
end

--- 获取换算比率
---@return number
function hplayer.getConvertRatio()
    return hplayer.convert_ratio
end

--- 获取玩家名称
---@param whichPlayer userdata
---@return string
function hplayer.getName(whichPlayer)
    local n = hcache.get(whichPlayer, CONST_CACHE.PLAYER_NAME)
    if (n == nil) then
        n = cj.GetPlayerName(whichPlayer)
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_NAME, n)
    end
    return n
end

--- 设置玩家名称
---@param whichPlayer userdata
---@param name string
function hplayer.setName(whichPlayer, name)
    cj.SetPlayerName(whichPlayer, name)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_NAME, name)
end

--- 获取玩家当前选中的单位
---@param whichPlayer userdata
---@return userdata unit
function hplayer.getSelection(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELECTION, nil)
end

--- 获取玩家当前状态
---@param whichPlayer userdata
---@return string
function hplayer.getStatus(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_STATUS, hplayer.player_status.none)
end
--- 设置玩家当前状态
---@param whichPlayer userdata
---@param status string
function hplayer.setStatus(whichPlayer, status)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_STATUS, status)
end

--- 获取玩家当前称号
---@param whichPlayer userdata
---@return string
function hplayer.getPrestige(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_PRESTIGE, " - ")
end
--- 设置玩家当前称号
---@param whichPlayer userdata
---@param prestige string
---@return void
function hplayer.setPrestige(whichPlayer, prestige)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_PRESTIGE, prestige)
end

--- 获取玩家APM
---@param whichPlayer userdata
---@return number
function hplayer.getApm(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_APM, 0)
end

--- 在所有玩家里获取一个随机的英雄
---@return userdata
function hplayer.getRandomHero()
    local pi = {}
    for k, v in ipairs(hplayer.players) do
        if (hplayer.setStatus(v) == hplayer.status.gaming) then
            table.insert(pi, k)
        end
    end
    if (#pi <= 0) then
        return nil
    end
    local ri = math.random(1, #pi)
    return hhero.getPlayerUnit(
        hplayer.players[pi[ri]],
        math.random(1, hhero.getPlayerAllowQty(hplayer.players[pi[ri]]))
    )
end

--- 令玩家单位全部隐藏
---@param whichPlayer userdata
function hplayer.hideUnit(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(hrect.world(), function(filterUnit)
        return hunit.getOwner(filterUnit) == whichPlayer
    end)
    hgroup.forEach(g, function(enumUnit)
        cj.ShowUnit(enumUnit, false)
    end)
    g = nil
end
--- 令玩家单位全部删除
---@param whichPlayer userdata
function hplayer.clearUnit(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(hrect.world(), function(filterUnit)
        return hunit.getOwner(filterUnit) == whichPlayer
    end)
    hgroup.clear(g, true)
end

--- 令玩家失败并退出
---@param whichPlayer userdata
---@param tips string
function hplayer.defeat(whichPlayer, tips)
    if (whichPlayer == nil) then
        return
    end
    if (tips == "" or tips == nil) then
        tips = "失败"
    end
    hplayer.clearUnit(whichPlayer)
    cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_DEFEAT)
    if hplayer.qty_current > 1 then
        cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_DEFEATED"))
    end
    if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
        hdialog.create(whichPlayer, {
            title = tips,
            buttons = { { value = "Q", label = cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") } }
        }, function()
            if (whichPlayer == hplayer.loc()) then
                cj.EndGame(true)
            end
        end)
    end
end
--- 令玩家胜利并退出
---@param whichPlayer userdata
---@param tips string
function hplayer.victory(whichPlayer, tips)
    if (whichPlayer == nil) then
        return
    end
    if (tips == "" or tips == nil) then
        tips = "胜利"
    end
    cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_VICTORY)
    if hplayer.qty_current > 1 then
        cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_VICTORIOUS"))
    end
    if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
        JassGlobals.bj_changeLevelShowScores = true
        hdialog.create(whichPlayer, {
            title = tips,
            buttons = { { value = "Q", label = cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") } }
        }, function()
            if (whichPlayer == hplayer.loc()) then
                cj.EndGame(true)
            end
        end)
    end
end

--- 设置玩家镜头摇晃判断
---@protected
---@param whichPlayer userdata
---@param b boolean
function hplayer.setCameraShaking(whichPlayer, n)
    local ing = hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_SHAKING, 0)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_SHAKING, ing + n)
end

--- 获取玩家镜头是否在摇晃
---@param whichPlayer userdata
---@return boolean
function hplayer.isCameraShaking(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_SHAKING, 0) > 0
end

--- 设置玩家镜头震动判断
---@protected
---@param whichPlayer userdata
---@param b boolean
function hplayer.setCameraQuaking(whichPlayer, n)
    local ing = hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_QUAKING, 0)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_QUAKING, ing + n)
end

--- 获取玩家镜头是否在震动
---@param whichPlayer userdata
---@return boolean
function hplayer.isCameraQuaking(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_CAMERA_QUAKING, 0) > 0
end

--- 获取玩家造成的总伤害
---@param whichPlayer userdata
---@return number
function hplayer.getDamage(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_DAMAGE, 0)
end
--- 增加玩家造成的总伤害
---@param whichPlayer userdata
---@param val number
function hplayer.addDamage(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_DAMAGE, hplayer.getDamage(whichPlayer) + val)
end
--- 获取玩家受到的总伤害
---@param whichPlayer userdata
---@return number
function hplayer.getBeDamage(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_BE_DAMAGE, 0)
end
--- 增加玩家受到的总伤害
---@param whichPlayer userdata
---@param val number
function hplayer.addBeDamage(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_BE_DAMAGE, hplayer.getBeDamage(whichPlayer) + val)
end
--- 获取玩家杀敌数
---@param whichPlayer userdata
---@return number
function hplayer.getKill(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_KILL, 0)
end
-- 增加玩家杀敌数
---@param whichPlayer userdata
---@param val number
function hplayer.addKill(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 1
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_KILL, hplayer.getKill(whichPlayer) + val)
end

--- 黄金比率
---@private
function hplayer.diffGoldRatio(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.setGoldRatio(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.addGoldRatio(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.subGoldRatio(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
function hplayer.getGoldRatio(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) or 100
end

--- 木头比率
---@private
function hplayer.diffLumberRatio(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.setLumberRatio(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.addLumberRatio(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.subLumberRatio(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
function hplayer.getLumberRatio(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO)
end

--- 经验比率
---@private
function hplayer.diffExpRatio(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.setExpRatio(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.addExpRatio(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.subExpRatio(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
function hplayer.getExpRatio(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO)
end

--- 售卖比率
---@private
function hplayer.diffSellRatio(whichPlayer, diff, during)
    if (diff ~= 0) then
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.setSellRatio(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.addSellRatio(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
function hplayer.subSellRatio(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
function hplayer.getSellRatio(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, 50)
end

--- 玩家总获金量
---@param whichPlayer userdata
---@return number
function hplayer.getTotalGold(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_TOTAL)
end
---@param whichPlayer userdata
---@param val number
function hplayer.addTotalGold(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_TOTAL, hplayer.getTotalGold(whichPlayer) + val)
end
--- 玩家总耗金量
---@param whichPlayer userdata
---@return number
function hplayer.getTotalGoldCost(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_COST)
end
---@param whichPlayer userdata
---@param val number
function hplayer.addTotalGoldCost(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_COST, hplayer.getTotalGoldCost(whichPlayer) + val)
end

--- 玩家总获木量
---@param whichPlayer userdata
---@return number
function hplayer.getTotalLumber(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_TOTAL)
end
---@param whichPlayer userdata
---@param val number
function hplayer.addTotalLumber(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_TOTAL, hplayer.getTotalLumber(whichPlayer) + val)
end
--- 玩家总耗木量
---@param whichPlayer userdata
---@return number
function hplayer.getTotalLumberCost(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_COST)
end
---@param whichPlayer userdata
---@param val number
function hplayer.addTotalLumberCost(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_COST, hplayer.getTotalLumberCost(whichPlayer) + val)
end

--- 核算玩家金钱
---@private
function hplayer.adjustGold(whichPlayer)
    local prvSys = hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_PREV)
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
    if (prvSys ~= nil) then
        if (prvSys > relSys) then
            hplayer.addTotalGoldCost(whichPlayer, prvSys - relSys)
        elseif (prvSys < relSys) then
            hplayer.addTotalGold(whichPlayer, relSys - prvSys)
        end
    end
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_PREV, relSys)
end
--- 核算玩家木头
---@private
function hplayer.adjustLumber(whichPlayer)
    local prvSys = hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_PREV)
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
    if (prvSys ~= nil) then
        if (prvSys > relSys) then
            hplayer.addTotalLumberCost(whichPlayer, prvSys - relSys)
        elseif (prvSys < relSys) then
            hplayer.addTotalLumber(whichPlayer, relSys - prvSys)
        end
    end
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_PREV, relSys)
end

--- 获取玩家实时金钱
---@param whichPlayer userdata
---@return number
function hplayer.getGold(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
end

--- 设置玩家实时金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.setGold(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.trigger("global", CONST_EVENT.playerResourceChange, {
        triggerPlayer = whichPlayer,
        triggerUnit = u,
        type = "gold",
        value = gold - hplayer.getGold(whichPlayer),
    })
    local max = 1000000
    if (gold > max) then
        gold = max
    end
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, gold)
    hplayer.adjustGold(whichPlayer)
end

--- 增加玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.addGold(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    gold = math.ceil(gold * hplayer.getGoldRatio(whichPlayer) / 100)
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) + gold, u)
end

--- 减少玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.subGold(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) - gold, u)
end

--- 获取玩家实时木头
---@param whichPlayer userdata
---@return number
function hplayer.getLumber(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
end
--- 设置玩家实时木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.setLumber(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.trigger("global", CONST_EVENT.playerResourceChange, {
        triggerPlayer = whichPlayer,
        triggerUnit = u,
        type = "lumber",
        value = lumber - hplayer.getLumber(whichPlayer),
    })
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER, lumber)
    hplayer.adjustLumber(whichPlayer)
end
--- 增加玩家木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.addLumber(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    lumber = math.ceil(lumber * hplayer.getLumberRatio(whichPlayer) / 100)
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) + lumber, u)
end
--- 减少玩家木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
function hplayer.subLumber(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) - lumber, u)
end

--- 获取玩家已使用人口数
---@param whichPlayer userdata
---@return number
function hplayer.getFoodUsed(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_USED)
end

--- 设置玩家已使用人口数
---@param whichPlayer userdata
---@param value number integer
function hplayer.setFoodUsed(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_USED, math.floor(value))
end

--- 获取玩家可用人口数
---@param whichPlayer userdata
---@return number
function hplayer.getFoodCap(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_CAP)
end

--- 设置玩家可用人口数
---@param whichPlayer userdata
---@param value number integer
function hplayer.setFoodCap(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_CAP, math.floor(value))
end

--- 获取玩家最大人口上限
---@param whichPlayer userdata
---@return number
function hplayer.getFoodCapCeiling(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_FOOD_CAP_CEILING)
end

--- 设置玩家最大人口上限
---@param whichPlayer userdata
---@param value number integer
function hplayer.setFoodCapCeiling(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_FOOD_CAP_CEILING, math.floor(value))
end
