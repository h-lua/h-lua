---@class haward 奖励
haward = {
    shareRange = hslk.misc("Misc", "HeroExpRange") or 1000.00
}

--- 设置共享范围
---@param range number
---@return void
function haward.setShareRange(range)
    haward.shareRange = math.round(range)
end

--- 奖励单位（经验黄金木头）
---@param whichUnit userdata
---@param exp number
---@param gold number
---@param lumber number
---@return void
function haward.forUnit(whichUnit, exp, gold, lumber)
    if (whichUnit == nil) then
        return
    end
    local p = hunit.getOwner(whichUnit)
    local realGold = math.ceil(gold)
    local realLumber = math.ceil(lumber)
    local realExp = math.ceil(exp)
    if (realExp >= 1 and hunit.isHero(whichUnit)) then
        hunit.addExp(whichUnit, realExp, true)
    end
    if (realGold >= 1) then
        hplayer.addGold(p, realGold, whichUnit)
    end
    if (realLumber >= 1) then
        hplayer.addLumber(p, realLumber, whichUnit)
    end
end

--- 奖励单位经验
---@param whichUnit userdata
---@param exp number
---@return void
function haward.forUnitExp(whichUnit, exp)
    return haward.forUnit(whichUnit, exp, 0, 0)
end

--- 奖励单位黄金
---@param whichUnit userdata
---@param gold number
---@return void
function haward.forUnitGold(whichUnit, gold)
    return haward.forUnit(whichUnit, 0, gold, 0)
end

--- 奖励单位木头
---@param whichUnit userdata
---@param lumber number
---@return void
function haward.forUnitLumber(whichUnit, lumber)
    return haward.forUnit(whichUnit, 0, 0, lumber)
end

--- 平分奖励英雄组（经验黄金木头）
---@param whichUnit userdata
---@param exp number
---@param gold number
---@param lumber number
---@return void
function haward.forGroup(whichUnit, exp, gold, lumber)
    local g = hgroup.createByUnit(
        whichUnit,
        haward.shareRange,
        function(filterUnit)
            local flag = true
            if (hunit.isHero(filterUnit) == false) then
                flag = false
            end
            if (hunit.isAlly(whichUnit, filterUnit) == false) then
                flag = false
            end
            if (hunit.isAlive(filterUnit) == false) then
                flag = false
            end
            if (hunit.isStructure(filterUnit) == true) then
                flag = false
            end
            return flag
        end
    )
    local gCount = hgroup.count(g)
    if (gCount <= 0) then
        return
    end
    local cutExp = math.ceil(exp / gCount)
    local cutGold = math.ceil(gold / gCount)
    local cutLumber = math.ceil(lumber / gCount)
    if (exp > 0 and cutExp < 1) then
        cutExp = 1
    end
    hgroup.forEach(g, function(u)
        haward.forUnit(u, cutExp, cutGold, cutLumber)
    end)
    g = nil
end

--- 平分奖励英雄组（经验）
---@param whichUnit userdata
---@param exp number
---@return void
function haward.forGroupExp(whichUnit, exp)
    haward.forGroup(whichUnit, exp, 0, 0)
end

--- 平分奖励英雄组（黄金）
---@param whichUnit userdata
---@param gold number
---@return void
function haward.forGroupGold(whichUnit, gold)
    haward.forGroup(whichUnit, 0, gold, 0)
end

--- 平分奖励英雄组（木头）
---@param whichUnit userdata
---@param lumber number
---@return void
function haward.forGroupLumber(whichUnit, lumber)
    haward.forGroup(whichUnit, 0, 0, lumber)
end

--- 平分奖励玩家组（黄金木头）
---@param gold number
---@param lumber number
---@return void
function haward.forPlayer(gold, lumber)
    if (hplayer.qty_current <= 0) then
        return
    end
    local cutGold = math.floor(gold / hplayer.qty_current)
    local cutLumber = math.floor(lumber / hplayer.qty_current)
    for i = 1, hplayer.qty_max, 1 do
        if (hplayer.getStatus(hplayer.players[i]) == hplayer.player_status.gaming) then
            if (cutGold > 0) then
                hplayer.addGold(hplayer.players[i], cutGold)
            end
            if (cutLumber > 0) then
                hplayer.addLumber(hplayer.players[i], cutLumber)
            end
        end
    end
end

--- 平分奖励玩家组（黄金）
---@param gold number
---@return void
function haward.forPlayerGold(gold)
    haward.forPlayer(gold, 0)
end

--- 平分奖励玩家组（木头）
---@param lumber number
---@return void
function haward.forPlayerLumber(lumber)
    haward.forPlayer(0, lumber)
end
