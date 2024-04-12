---@class hhero 英雄相关
hhero = {
    player_allow_qty = {}, -- 玩家最大单位数量,默认1
    player_heroes = {}, -- 玩家当前英雄
    --- 英雄出生地
    bornX = 0,
    bornY = 0,
    --- 英雄选择池
    selectorPool = {},
    --- 英雄选择清理池
    selectorClearPool = {},
    --- 英雄种类酒馆记录
    selectorTavern = {},
}

--- 获取英雄的类型（STR AGI INT）
--- 没法获取则为UNK
---@param whichHero userdata
---@return string UNK|STR|AGI|INT
function hhero.getPrimary(whichHero)
    local primary = hslk.i2v(hunit.getId(whichHero), "slk", "Primary")
    if (primary == nil or primary == "_") then
        primary = "UNK"
    end
    return string.upper(primary)
end

--- 获取英雄的类型文本
---@param whichHero userdata
---@return string 力量|敏捷|智力
function hhero.getPrimaryLabel(whichHero)
    return CONST_HERO_PRIMARY[hhero.getPrimary(whichHero)]
end

--- 获取英雄力量成长
---@param whichHero
---@return string
function hhero.getStrPlus(whichHero)
    local val = hslk.i2v(hunit.getId(whichHero), "slk", "STRplus") or 0
    return math.round(val, 2)
end

--- 获取英雄敏捷成长
---@param whichHero
---@return string
function hhero.getAgiPlus(whichHero)
    local val = hslk.i2v(hunit.getId(whichHero), "slk", "AGIplus") or 0
    return math.round(val, 2)
end

--- 获取英雄智力成长
---@param whichHero
---@return string
function hhero.getIntPlus(whichHero)
    local val = hslk.i2v(hunit.getId(whichHero), "slk", "INTplus") or 0
    return math.round(val, 2)
end

--- 获取英雄谓称
---@param whichHero
---@return string
function hhero.getProperName(whichHero)
    return cj.GetHeroProperName(whichHero) or ""
end

--- 设置英雄之前的等级
---@protected
---@param whichHero userdata
---@param lv number
function hhero.setPrevLevel(whichHero, lv)
    hcache.set(whichHero, CONST_CACHE.HERO_PREV_LEVEL, lv)
end

--- 获取英雄之前的等级
---@protected
---@param whichHero userdata
---@return number
function hhero.getPrevLevel(whichHero)
    return hcache.get(whichHero, CONST_CACHE.HERO_PREV_LEVEL, 0)
end

--- 获取英雄当前等级
---@param whichHero userdata
---@return number
function hhero.getCurLevel(whichHero)
    return cj.GetHeroLevel(whichHero) or 1
end
--- 设置英雄当前的等级
---@paramu userdata
---@param newLevel number
---@param showEffect boolean
function hhero.setCurLevel(whichHero, newLevel, showEffect)
    if (type(showEffect) ~= "boolean") then
        showEffect = false
    end
    local oldLevel = cj.GetHeroLevel(whichHero)
    if (newLevel > oldLevel) then
        cj.SetHeroLevel(whichHero, newLevel, showEffect)
    elseif (newLevel < oldLevel) then
        cj.UnitStripHeroLevel(whichHero, oldLevel - newLevel)
    else
        return
    end
    hhero.setPrevLevel(whichHero, newLevel)
end

--- 获取英雄当前经验值
---@param whichHero userdata
---@return number integer
function hhero.getExp(whichHero)
    return cj.GetHeroXP(whichHero) or 0
end

--- 获取英雄升级到某等级需要的总经验
--- 根据地图的平衡常数计算[英雄EXP-需求|NeedHeroXP]项
---@return number integer
function hhero.getExpNeed(targetLevel)
    targetLevel = math.floor(targetLevel) or 1
    if (targetLevel <= 1) then
        return 0
    end
    local NeedHeroXP = hslk.misc("Misc", "NeedHeroXP") or { 200 }
    if (type(NeedHeroXP) == "string") then
        NeedHeroXP = string.explode(",", NeedHeroXP)
    end
    if ((targetLevel - 1) <= #NeedHeroXP) then
        return math.ceil(NeedHeroXP[targetLevel - 1])
    end
    local NeedHeroXPFormulaA = math.round(hslk.misc("Misc", "NeedHeroXPFormulaA"), 2) or 1
    local NeedHeroXPFormulaB = math.round(hslk.misc("Misc", "NeedHeroXPFormulaB"), 2) or 100
    local NeedHeroXPFormulaC = math.round(hslk.misc("Misc", "NeedHeroXPFormulaC"), 2) or 0
    local exp = NeedHeroXP[#NeedHeroXP]
    for lv = #NeedHeroXP + 2, targetLevel, 1 do
        exp = exp * NeedHeroXPFormulaA + lv * NeedHeroXPFormulaB + NeedHeroXPFormulaC
    end
    return math.ceil(exp)
end

--- 获取英雄的尚未分配的技能点数量
---@param whichHero userdata
---@return number integer
function hhero.getSkillPoints(whichHero)
    return cj.GetHeroSkillPoints(whichHero) or 0
end

--- 设置玩家最大英雄数量,支持1 - 7
--- 超过7会有很多魔兽原生问题，例如英雄不会复活，左侧图标无法查看等
---@param whichPlayer userdata
---@param max number
function hhero.setPlayerAllowQty(whichPlayer, max)
    max = math.floor(max)
    if (max < 1) then
        max = 1
    end
    if (max > 7) then
        max = 7
    end
    local index = hplayer.index(whichPlayer)
    hhero.player_allow_qty[index] = max
end
--- 获取玩家最大英雄数量
---@param whichPlayer userdata
---@return number
function hhero.getPlayerAllowQty(whichPlayer)
    local index = hplayer.index(whichPlayer)
    return hhero.player_allow_qty[index] or 0
end

-- 设定选择英雄的出生地
function hhero.setBornXY(x, y)
    hhero.bornX = x
    hhero.bornY = y
end

--- 在某XY坐标复活英雄,只有英雄能被复活,只有调用此方法会触发复活事件
---@param whichHero userdata
---@param delay number
---@param invulnerable number 复活后的无敌时间
---@param x number
---@param y number
function hhero.reborn(whichHero, delay, invulnerable, x, y)
    if (hunit.isHero(whichHero)) then
        if (delay < 0.3 and hunit.isDestroyed(whichHero) == false) then
            cj.ReviveHero(whichHero, x, y, true)
            hcache.set(whichHero, CONST_CACHE.UNIT_DEAD, nil)
            hmonitor.listen(CONST_MONITOR.LIFE_BACK, whichHero)
            hmonitor.listen(CONST_MONITOR.MANA_BACK, whichHero)
            if (invulnerable > 0) then
                hskill.invulnerable(whichHero, invulnerable)
            end
            -- @触发复活事件
            hevent.trigger(whichHero, CONST_EVENT.reborn, {
                triggerUnit = whichHero
            })
        else
            htime.setTimeout(delay, function(t)
                t.destroy()
                if (hunit.isDestroyed(whichHero) == false) then
                    if (hunit.isAlive(whichHero)) then
                        return
                    end
                    cj.ReviveHero(whichHero, x, y, true)
                    hcache.set(whichHero, CONST_CACHE.UNIT_DEAD, nil)
                    hmonitor.listen(CONST_MONITOR.LIFE_BACK, whichHero)
                    hmonitor.listen(CONST_MONITOR.MANA_BACK, whichHero)
                    if (invulnerable > 0) then
                        hskill.invulnerable(whichHero, invulnerable)
                    end
                    -- @触发复活事件
                    hevent.trigger(whichHero, CONST_EVENT.reborn, {
                        triggerUnit = whichHero
                    })
                end
            end, hunit.getName(whichHero))
        end
    end
end

--[[
    开始构建英雄选择
    options = {
        heroes = {"H001","H002"}, -- (可选)供选的单位ID数组，默认是全局的 hslk.typeIds({ "hero", "hero_custom" })
        during = -1, -- 选择持续时间，默认无限（特殊情况哦）;如果有持续时间但是小于30，会被设置为30秒，超过这段时间未选择的玩家会被剔除出游戏
        type = string, "tavern" | "click"
        buildX = 0, -- 构建点X
        buildY = 0, -- 构建点Y
        buildDistance = 256, -- 构建距离，例如两个酒馆间，两个单位间
        buildRowQty = 4, -- 每行构建的最大数目，例如一行最多4个酒馆
        tavernId = nil, -- 酒馆模式下，你可以自定义酒馆单位是哪一个(建议使用hslk创建酒馆，这样自动就有出售单位等必备技能)
        tavernUnitQty = 10, -- 酒馆模式下，一个酒馆最多拥有几种单位
        onUnitSell = function, -- 酒馆模式时，购买单位的动作，默认是系统pickHero事件，你可自定义
        direct = {1,1}, -- 生成方向，默认左下角开始到右上角结束
    }
]]
---@param options {heroes:string[],during:number,type:string|"tavern" | "click",buildX:number,buildY:number,buildDistance:number,buildRowQty:number,tavernId:number,tavernUnitQty:number,onUnitSell:function,direct:number[2]}
function hhero.buildSelector(options)
    local heroIds = options.heroes
    if (heroIds == nil or #heroIds <= 0) then
        heroIds = hslk.typeIds({ "hero", "hero_custom" })
    end
    if (#heroIds <= 0) then
        return
    end
    local during = options.during or -1
    local xType = options.type or "tavern"
    local buildX = options.buildX or 0
    local buildY = options.buildY or 0
    local direct = options.direct or { 1, 1 }
    local buildDistanceX = direct[1] * (options.buildDistance or 256)
    local buildDistanceY = direct[2] * (options.buildDistance or 256)
    local buildRowQty = options.buildRowQty or 4
    if (options.during ~= -1 and options.during < 30) then
        during = 30
    end
    local totalRow = 1
    local currentRowQty = 0
    local x = buildX
    local y = buildY
    if (xType == "click") then
        for _, heroId in ipairs(heroIds) do
            if (currentRowQty >= buildRowQty) then
                currentRowQty = 0
                totalRow = totalRow + 1
                x = buildX
                y = y + buildDistanceY
            else
                x = buildX + currentRowQty * buildDistanceX
            end
            local whichHero = hunit.create({
                whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                id = heroId,
                x = x,
                y = y,
                isInvulnerable = true,
                isPause = true
            })
            hcache.set(whichHero, CONST_CACHE.HERO_SELECTOR, { x, y })
            table.insert(hhero.selectorClearPool, whichHero)
            table.insert(hhero.selectorPool, whichHero)
            currentRowQty = currentRowQty + 1
        end
        for i = 1, hplayer.qty_max, 1 do
            hevent.onSelection(hplayer.players[i], 2, function(evtData)
                local p = evtData.triggerPlayer
                local whichHero = evtData.triggerUnit
                if (table.includes(hhero.selectorClearPool, whichHero) == false) then
                    return
                end
                if (hunit.getOwner(whichHero) ~= cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
                    return
                end
                local pIndex = hplayer.index(p)
                if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                    echo("|cffffff80你已经选够了|r", p)
                    return
                end
                table.delete(hhero.selectorPool, whichHero)
                table.delete(hhero.selectorClearPool, whichHero)
                hunit.setInvulnerable(whichHero, false)
                cj.SetUnitOwner(whichHero, p, true)
                hunit.portal(whichHero, hhero.bornX, hhero.bornY)
                cj.PauseUnit(whichHero, false)
                table.insert(hhero.player_heroes[pIndex], whichHero)
                -- 触发英雄被选择事件(全局)
                hevent.trigger(
                    "global",
                    CONST_EVENT.pickHero,
                    {
                        triggerPlayer = p,
                        triggerUnit = whichHero
                    }
                )
                if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                    echo("您选择了 " .. "|cffffff80" .. cj.GetUnitName(whichHero) .. "|r,已挑选完毕", p)
                else
                    echo("您选择了 |cffffff80" .. cj.GetUnitName(whichHero) .. "|r,还要选 " ..
                        math.floor(hhero.player_allow_qty[pIndex] - #hhero.player_heroes[pIndex]) .. " 个", p
                    )
                end
            end)
        end
    elseif (xType == "tavern") then
        local tavernUnitQty = options.tavernUnitQty or 10
        local currentTavernQty = 0
        local tavern
        for _, heroId in ipairs(heroIds) do
            if (tavern == nil or currentTavernQty >= tavernUnitQty) then
                currentTavernQty = 0
                if (currentRowQty >= buildRowQty) then
                    currentRowQty = 0
                    totalRow = totalRow + 1
                    x = buildX
                    y = y + buildDistanceY
                else
                    x = buildX + currentRowQty * buildDistanceX
                end
                tavern = hunit.create({
                    whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                    id = options.tavernId or HL_ID.hero_tavern_token,
                    x = x,
                    y = y,
                })
                table.insert(hhero.selectorClearPool, tavern)
                cj.SetUnitTypeSlots(tavern, tavernUnitQty)
                if (type(options.onUnitSell) == "function") then
                    hevent.onUnitSell(tavern, function(evtData)
                        options.onUnitSell(evtData)
                    end)
                else
                    hevent.onUnitSell(tavern, function(evtData)
                        local p = hunit.getOwner(evtData.buyingUnit)
                        local soldUnit = evtData.soldUnit
                        local soldUid = cj.GetUnitTypeId(soldUnit)
                        hunit.destroy(soldUnit, 0)
                        local pIndex = hplayer.index(p)
                        if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                            echo("|cffffff80你已经选够~|r", p)
                            cj.AddUnitToStock(tavern, soldUid, 1, 1)
                            return
                        end
                        cj.RemoveUnitFromStock(tavern, soldUid)
                        local whichHero = hunit.create({
                            whichPlayer = p,
                            id = soldUid,
                            x = hhero.bornX,
                            y = hhero.bornY,
                        })
                        table.insert(hhero.player_heroes[pIndex], whichHero)
                        table.delete(hhero.selectorPool, i2c(soldUid))
                        local tips = "您选择了 |cffffff80" .. cj.GetUnitName(whichHero) .. "|r"
                        if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                            echo(tips .. ",已挑选完毕", p)
                        else
                            echo(tips .. "还差 " .. (hhero.player_allow_qty[pIndex] - #hhero.player_heroes[pIndex]) .. " 个", p)
                        end
                        hcache.set(whichHero, CONST_CACHE.HERO_SELECTOR, evtData.triggerUnit)
                        -- 触发英雄被选择事件(全局)
                        hevent.trigger(
                            "global",
                            CONST_EVENT.pickHero,
                            {
                                triggerPlayer = p,
                                triggerUnit = whichHero
                            }
                        )
                    end)
                end
                currentRowQty = currentRowQty + 1
            end
            currentTavernQty = currentTavernQty + 1
            cj.AddUnitToStock(tavern, c2i(heroId), 1, 1)
            hhero.selectorTavern[heroId] = tavern
            table.insert(hhero.selectorPool, heroId)
        end
    end
    if (during > 0) then
        -- 视野token
        for i = 1, hplayer.qty_max, 1 do
            local p = cj.Player(i - 1)
            local whichHero = hunit.create(
                {
                    whichPlayer = p,
                    id = HL_ID.hero_view_token,
                    x = buildX + buildRowQty * buildDistanceX * 0.5,
                    y = buildY - math.floor(#heroIds / buildRowQty) * buildDistanceY * 0.5,
                    isInvulnerable = true,
                    isPause = true
                }
            )
            table.insert(hhero.selectorClearPool, whichHero)
        end
        -- 还剩10秒给个选英雄提示
        htime.setTimeout(during - 10.0, function(t)
            t.destroy()
            local x2 = buildX + buildRowQty * buildDistanceX * 0.5
            local y2 = buildY - math.floor(#heroIds / buildRowQty) * buildDistanceY * 0.5
            hhero.selectorPool = {}
            echo("还剩 10 秒，还未选择的玩家尽快啦～")
            cj.PingMinimapEx(x2, y2, 8, 255, 0, 0, true)
        end)
        -- 逾期不选赶出游戏
        -- 对于可以选择多个的玩家，有选即可，不要求全选
        htime.setTimeout(during - 0.5, function(t)
            t.destroy()
            for _, hero in ipairs(hhero.selectorClearPool) do
                hunit.destroy(hero)
            end
            hhero.selectorClearPool = {}
            for i = 1, hplayer.qty_max, 1 do
                if (hplayer.isPlaying(hplayer.players[i]) and #hhero.player_heroes[i] <= 0) then
                    hplayer.defeat(hplayer.players[i], "未选英雄")
                end
            end
        end, "英雄选择")
    end
end
