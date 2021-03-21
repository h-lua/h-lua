---@class haward 奖励
haward = {
    shareRange = 1000.00
}

--- 设置共享范围
---@param range number
haward.setShareRange = function(range)
    haward.shareRange = math.round(range)
end

--- 奖励单位（经验黄金木头）
---@param whichUnit userdata
---@param exp number
---@param gold number
---@param lumber number
haward.forUnit = function(whichUnit, exp, gold, lumber)
    if (whichUnit == nil) then
        return
    end
    local p = hunit.getOwner(whichUnit)
    local realGold = cj.R2I(gold)
    local realLumber = cj.R2I(lumber)
    local realExp = cj.R2I(exp)
    if (realExp >= 1 and his.hero(whichUnit)) then
        hunit.addExp(whichUnit, realExp, true)
    end
    local ttgColorLen = 0
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
haward.forUnitExp = function(whichUnit, exp)
    return haward.forUnit(whichUnit, exp, 0, 0)
end

--- 奖励单位黄金
---@param whichUnit userdata
---@param gold number
haward.forUnitGold = function(whichUnit, gold)
    return haward.forUnit(whichUnit, 0, gold, 0)
end

--- 奖励单位木头
---@param whichUnit userdata
---@param lumber number
haward.forUnitLumber = function(whichUnit, lumber)
    return haward.forUnit(whichUnit, 0, 0, lumber)
end

--- 平分奖励英雄组（经验黄金木头）
---@param whichUnit userdata
---@param exp number
---@param gold number
---@param lumber number
haward.forGroup = function(whichUnit, exp, gold, lumber)
    local g = hgroup.createByUnit(
        whichUnit,
        haward.shareRange,
        function(filterUnit)
            local flag = true
            if (his.hero(filterUnit) == false) then
                flag = false
            end
            if (his.ally(whichUnit, filterUnit) == false) then
                flag = false
            end
            if (his.alive(filterUnit) == false) then
                flag = false
            end
            if (his.structure(filterUnit) == true) then
                flag = false
            end
            return flag
        end
    )
    local gCount = hgroup.count(g)
    if (gCount <= 0) then
        return
    end
    local cutExp = cj.R2I(exp / gCount)
    local cutGold = cj.R2I(gold / gCount)
    local cutLumber = cj.R2I(lumber / gCount)
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
haward.forGroupExp = function(whichUnit, exp)
    haward.forGroup(whichUnit, exp, 0, 0)
end

--- 平分奖励英雄组（黄金）
---@param whichUnit userdata
---@param gold number
haward.forGroupGold = function(whichUnit, gold)
    haward.forGroup(whichUnit, 0, gold, 0)
end

--- 平分奖励英雄组（木头）
---@param whichUnit userdata
---@param lumber number
haward.forGroupLumber = function(whichUnit, lumber)
    haward.forGroup(whichUnit, 0, 0, lumber)
end

--- 平分奖励玩家组（黄金木头）
---@param gold number
---@param lumber number
haward.forPlayer = function(gold, lumber)
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
haward.forPlayerGold = function(gold)
    haward.forPlayer(gold, 0)
end

--- 平分奖励玩家组（木头）
---@param lumber number
haward.forPlayerLumber = function(lumber)
    haward.forPlayer(0, lumber)
end
