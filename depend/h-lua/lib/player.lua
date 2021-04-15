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
    convert_ratio = 1000000
}

---@private
hplayer.adjustPlayerState = function(delta, whichPlayer, whichPlayerState)
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
hplayer.setPlayerState = function(whichPlayer, whichPlayerState, value)
    local oldValue = cj.GetPlayerState(whichPlayer, whichPlayerState)
    hplayer.adjustPlayerState(value - oldValue, whichPlayer, whichPlayerState)
end

--- 遍历玩家
---@alias Handler fun(enumPlayer: userdata, idx: number):void
---@param action Handler | "function(enumPlayer, idx) end"
hplayer.forEach = function(action)
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
hplayer.index = function(whichPlayer)
    local idx
    if (hplayer.indexes[whichPlayer] ~= nil) then
        idx = hplayer.indexes[whichPlayer]
    else
        idx = cj.GetPlayerId(whichPlayer) + 1
        hplayer.indexes[whichPlayer] = idx
    end
    return idx
end

--- 设置换算比率，多少金换1木
---@param ratio number
hplayer.setConvertRatio = function(ratio)
    if (type(ratio) == "number") then
        hplayer.convert_ratio = math.floor(ratio)
    end
end

--- 获取换算比率
---@return number
hplayer.getConvertRatio = function()
    return hplayer.convert_ratio
end

--- 获取玩家名称
---@param whichPlayer userdata
---@return string
hplayer.getName = function(whichPlayer)
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
hplayer.setName = function(whichPlayer, name)
    cj.SetPlayerName(whichPlayer, name)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_NAME, name)
end

--- 获取玩家当前选中的单位
---@param whichPlayer userdata
---@return userdata unit
hplayer.getSelection = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELECTION, nil)
end

--- 获取玩家当前状态
---@param whichPlayer userdata
---@return string
hplayer.getStatus = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_STATUS, hplayer.player_status.none)
end
--- 设置玩家当前状态
---@param whichPlayer userdata
---@param status string
hplayer.setStatus = function(whichPlayer, status)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_STATUS, status)
end

--- 获取玩家当前称号
---@param whichPlayer userdata
---@return string
hplayer.getPrestige = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_PRESTIGE, " - ")
end
--- 设置玩家当前称号
---@param whichPlayer userdata
---@param status string
hplayer.setPrestige = function(whichPlayer, prestige)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_PRESTIGE, prestige)
end

--- 获取玩家APM
---@param whichPlayer userdata
---@return number
hplayer.getApm = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_APM, 0)
end

--- 设置玩家是否不可获取他人物品
---@param whichPlayer userdata
---@param isIsolated boolean
hplayer.setIsolated = function(whichPlayer, isIsolated)
    if (type(isIsolated) == "boolean") then
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_ISOLATED, isIsolated)
    end
end

--- 获取玩家是否不可获取他人物品
---@param whichPlayer userdata
---@return boolean
hplayer.isIsolated = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_ISOLATED, false)
end

--- 在所有玩家里获取一个随机的英雄
---@return userdata
hplayer.getRandomHero = function()
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
hplayer.hideUnit = function(whichPlayer)
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
hplayer.clearUnit = function(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(hrect.world(), function(filterUnit)
        return hunit.getOwner(filterUnit) == whichPlayer
    end)
    hgroup.clear(g, true, true)
end

--- 令玩家失败并退出
---@param whichPlayer userdata
---@param tips string
hplayer.defeat = function(whichPlayer, tips)
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
            buttons = { cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") }
        }, function()
            cj.EndGame(true)
        end)
    end
end
--- 令玩家胜利并退出
---@param whichPlayer userdata
---@param tips string
hplayer.victory = function(whichPlayer, tips)
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
        cg.bj_changeLevelShowScores = true
        hdialog.create(whichPlayer, {
            title = tips,
            buttons = { cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") }
        }, function()
            cj.EndGame(true)
        end)
    end
end

--- 玩家设置是否自动将{hAwardConvertRatio}黄金换1木头
---@param whichPlayer userdata
---@param b boolean
hplayer.setIsAutoConvert = function(whichPlayer, b)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_IS_AUTO_CONVERT, b)
end
--- 获取玩家是否自动将{hAwardConvertRatio}黄金换1木头
---@param whichPlayer userdata
---@return boolean
hplayer.getIsAutoConvert = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_AUTO_CONVERT, false)
end

--- 设置玩家镜头是否在震动
---@private
---@param whichPlayer userdata
---@param b boolean
hplayer.setIsShocking = function(whichPlayer, b)
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_IS_SHOCKING, b)
end
--- 获取玩家镜头是否在震动
---@param whichPlayer userdata
---@return boolean
hplayer.getIsShocking = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_IS_SHOCKING, false)
end

--- 获取玩家造成的总伤害
---@param whichPlayer userdata
---@return number
hplayer.getDamage = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_DAMAGE, 0)
end
--- 增加玩家造成的总伤害
---@param whichPlayer userdata
---@param val number
hplayer.addDamage = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_DAMAGE, hplayer.getDamage(whichPlayer) + val)
end
--- 获取玩家受到的总伤害
---@param whichPlayer userdata
---@return number
hplayer.getBeDamage = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_BE_DAMAGE, 0)
end
--- 增加玩家受到的总伤害
---@param whichPlayer userdata
---@param val number
hplayer.addBeDamage = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_BE_DAMAGE, hplayer.getBeDamage(whichPlayer) + val)
end
--- 获取玩家杀敌数
---@param whichPlayer userdata
---@return number
hplayer.getKill = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_KILL, 0)
end
-- 增加玩家杀敌数
---@param whichPlayer userdata
---@param val number
hplayer.addKill = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 1
    hcache.set(whichPlayer, CONST_CACHE.PLAYER_KILL, hplayer.getKill(whichPlayer) + val)
end

--- 黄金比率
---@private
hplayer.diffGoldRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getGoldRatio = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_RATIO) or 100
end

--- 木头比率
---@private
hplayer.diffLumberRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getLumberRatio = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_RATIO)
end

--- 经验比率
---@private
hplayer.diffExpRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        during = during or 0
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getExpRatio = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_EXP_RATIO)
end

--- 售卖比率
---@private
hplayer.diffSellRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO) + diff)
        if (during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO) - diff)
            end)
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val - hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getSellRatio = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_SELL_RATIO, 50)
end

--- 玩家总获金量
---@param whichPlayer userdata
---@return number
hplayer.getTotalGold = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_TOTAL)
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalGold = function(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_TOTAL, hplayer.getTotalGold(whichPlayer) + val)
end
--- 玩家总耗金量
---@param whichPlayer userdata
---@return number
hplayer.getTotalGoldCost = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_GOLD_COST)
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalGoldCost = function(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_GOLD_COST, hplayer.getTotalGoldCost(whichPlayer) + val)
end

--- 玩家总获木量
---@param whichPlayer userdata
---@return number
hplayer.getTotalLumber = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_TOTAL)
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalLumber = function(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_TOTAL, hplayer.getTotalLumber(whichPlayer) + val)
end
--- 玩家总耗木量
---@param whichPlayer userdata
---@return number
hplayer.getTotalLumberCost = function(whichPlayer)
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_LUMBER_COST)
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalLumberCost = function(whichPlayer, val)
    return hcache.set(whichPlayer, CONST_CACHE.PLAYER_LUMBER_COST, hplayer.getTotalLumberCost(whichPlayer) + val)
end

--- 核算玩家金钱
---@private
hplayer.adjustGold = function(whichPlayer)
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
hplayer.adjustLumber = function(whichPlayer)
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
hplayer.getGold = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
end
--- 设置玩家实时金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.setGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.triggerEvent("global", CONST_EVENT.playerResourceChange, {
        triggerPlayer = whichPlayer,
        triggerUnit = u,
        type = "gold",
        value = gold - hplayer.getGold(whichPlayer),
    })
    -- 满 100W 调用自动换算（至于换不换算，看玩家有没有开转换）
    local max = 1000000
    if (gold > max) then
        local curLumber = hplayer.getLumber(whichPlayer)
        if (hplayer.getIsAutoConvert(whichPlayer) and curLumber < max) then
            local playerConvertRatio = hplayer.getConvertRatio()
            local goldRemain = math.fmod(gold, playerConvertRatio)
            local exceedLumber = math.floor((gold - goldRemain) / playerConvertRatio)
            if (exceedLumber > 0) then
                if (exceedLumber + curLumber > max) then
                    goldRemain = goldRemain + playerConvertRatio * (exceedLumber + curLumber - max)
                    exceedLumber = max - curLumber
                end
                hplayer.adjustPlayerState(exceedLumber, whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
                hplayer.adjustLumber(whichPlayer)
                gold = goldRemain
            else
                gold = max
            end
        end
    end
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, gold)
    hplayer.adjustGold(whichPlayer)
end

--- 增加玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.addGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    gold = cj.R2I(gold * hplayer.getGoldRatio(whichPlayer) / 100)
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) + gold, u)
end
--- 减少玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.subGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) - gold, u)
end

--- 获取玩家实时木头
---@param whichPlayer userdata
---@return number
hplayer.getLumber = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
end
--- 设置玩家实时木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.setLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.triggerEvent("global", CONST_EVENT.playerResourceChange, {
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
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.addLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    lumber = cj.R2I(lumber * hplayer.getLumberRatio(whichPlayer) / 100)
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) + lumber, u)
end
--- 减少玩家木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.subLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) - lumber, u)
end

--- 获取玩家已使用人口数
---@param whichPlayer userdata
---@return number
hplayer.getFoodUsed = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_USED)
end

--- 设置玩家已使用人口数
---@param whichPlayer userdata
---@param value number integer
hplayer.setFoodUsed = function(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_USED, math.floor(value))
end

--- 获取玩家可用人口数
---@param whichPlayer userdata
---@return number
hplayer.getFoodCap = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_CAP)
end

--- 设置玩家可用人口数
---@param whichPlayer userdata
---@param value number integer
hplayer.setFoodCap = function(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_CAP, math.floor(value))
end

--- 获取玩家最大人口上限
---@param whichPlayer userdata
---@return number
hplayer.getFoodCapCeiling = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_FOOD_CAP_CEILING)
end

--- 设置玩家最大人口上限
---@param whichPlayer userdata
---@param value number integer
hplayer.setFoodCapCeiling = function(whichPlayer, value)
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_FOOD_CAP_CEILING, math.floor(value))
end
