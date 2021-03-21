---@class henv 环境
henv = {
    --- 删除可破坏物
    --- * 当可破坏物被破坏时删除会引起游戏崩溃
    delDestructable = function(whichDestructable, delay)
        delay = delay or 0.5
        if (delay == nil or delay <= 0) then
            cj.RemoveDestructable(whichDestructable)
            whichDestructable = nil
        else
            htime.setTimeout(delay, function(t)
                htime.delTimer(t)
                cj.RemoveDestructable(whichDestructable)
                whichDestructable = nil
            end)
        end
    end,
    --- 清理可破坏物
    _clearDestructable = function()
        cj.RemoveDestructable(cj.GetEnumDestructable())
    end
}

--- 设置迷雾状态
---@param enableFog boolean 战争迷雾
---@param enableMark boolean 黑色阴影
henv.setFogStatus = function(enableFog, enableMark)
    cj.FogEnable(enableFog)
    cj.FogMaskEnable(enableMark)
end

--- 清空一片区域的可破坏物
henv.clearDestructable = function(whichRect)
    cj.EnumDestructablesInRect(whichRect, nil, henv._clearDestructable)
end

--- 构建区域装饰
---@param whichRect userdata
---@param typeStr string
---@param isInvulnerable boolean 可破坏物是否无敌
---@param isDestroyRect boolean
---@param ground number
---@param doodad userdata
---@param units table
henv.build = function(whichRect, typeStr, isInvulnerable, isDestroyRect, ground, doodad, units)
    if (whichRect == nil or typeStr == nil) then
        return
    end
    if (doodad == nil or units == nil) then
        return
    end
    if (false == hcache.exist(whichRect)) then
        hcache.alloc(whichRect)
    end
    -- 清理装饰单位
    local rectUnits = hcache.get(whichRect, CONST_CACHE.ENV_RECT_UNITS)
    if (rectUnits == nil) then
        rectUnits = {}
        hcache.set(whichRect, CONST_CACHE.ENV_RECT_UNITS, rectUnits)
    end
    if (#rectUnits > 0) then
        for _, u in ipairs(rectUnits) do
            hunit.del(u)
        end
    end
    rectUnits = {}
    -- 清理装饰物
    henv.clearDestructable(whichRect)
    local rectMinX = hrect.getMinX(whichRect)
    local rectMinY = hrect.getMinY(whichRect)
    local rectMaxX = hrect.getMaxX(whichRect)
    local rectMaxY = hrect.getMaxY(whichRect)
    local indexX = 0
    local indexY = 0
    local doodads = {}
    for _, v in ipairs(doodad) do
        for _, vv in ipairs(v) do
            table.insert(doodads, vv)
        end
    end
    local randomM = 2
    htime.setInterval(0.01, function(t)
        local x = rectMinX + indexX * 80
        local y = rectMinY + indexY * 80
        local buildType = math.random(1, randomM)
        if (indexX == -1 or indexY == -1) then
            htime.delTimer(t)
            if (isDestroyRect) then
                hrect.del(whichRect)
            end
            return
        end
        randomM = randomM + math.random(1, 3)
        if (randomM > 180) then
            randomM = 2
        end
        if (x > rectMaxX) then
            indexY = 1 + indexY
            indexX = -1
        end
        if (y > rectMaxY) then
            indexY = -1
        end
        indexX = 1 + indexX
        --- 一些特殊的地形要处理一下
        if (typeStr == "sea") then
            --- 海洋 - 深水不处理
            if (cj.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == true) then
                return
            end
        end
        if (#units > 0 and (buildType == 1 or buildType == 40 or (#doodads <= 0 and buildType == 51))) then
            local tempUnit = cj.CreateUnit(
                cj.Player(PLAYER_NEUTRAL_PASSIVE),
                units[math.random(1, #units)],
                x,
                y,
                bj_UNIT_FACING
            )
            table.insert(rectUnits, tempUnit)
            if (ground ~= nil and math.random(1, 3) == 2) then
                cj.SetTerrainType(x, y, ground, -1, 1, 0)
            end
        elseif (#doodads > 0 and buildType == 16) then
            local dest = cj.CreateDestructable(
                doodads[math.random(1, #doodads)],
                x,
                y,
                math.random(0, 360),
                math.random(0.5, 1.1),
                0
            )
            if (isInvulnerable == true) then
                cj.SetDestructableInvulnerable(dest, true)
            end
            if (ground ~= nil) then
                cj.SetTerrainType(x, y, ground, -1, 1, 0)
            end
        end
    end)
end

--- 随机构建区域装饰
---@param whichRect userdata
---@param typeStr string
---@param isInvulnerable boolean 可破坏物是否无敌
---@param isDestroyRect boolean
henv.random = function(whichRect, typeStr, isInvulnerable, isDestroyRect)
    local ground
    local doodad = {}
    local unit = {}
    if (whichRect == nil or typeStr == nil) then
        return
    end
    if (typeStr == "summer") then
        ground = HL_ID.env.ground.summer
        doodad = {
            HL_ID.env.doodad.treeSummer,
            HL_ID.env.doodad.block,
            HL_ID.env.doodad.stone,
            HL_ID.env.doodad.bucket
        }
        unit = {
            HL_ID.env.unit_model.flower0,
            HL_ID.env.unit_model.flower1,
            HL_ID.env.unit_model.flower2,
            HL_ID.env.unit_model.flower3,
            HL_ID.env.unit_model.flower4,
            HL_ID.env.unit_model.bird
        }
    elseif (typeStr == "autumn") then
        ground = HL_ID.env.ground.autumn
        doodad = {
            HL_ID.env.doodad.treeAutumn,
            HL_ID.env.doodad.box,
            HL_ID.env.doodad.stoneRed,
            HL_ID.env.doodad.bucket,
            HL_ID.env.doodad.cage,
            HL_ID.env.doodad.supportColumn
        }
        unit = {
            HL_ID.env.unit_model.flower0,
            HL_ID.env.unit_model.typha0,
            HL_ID.env.unit_model.typha1
        }
    elseif (typeStr == "winter") then
        ground = HL_ID.env.ground.winter
        doodad = {
            HL_ID.env.doodad.treeWinter,
            HL_ID.env.doodad.treeWinterShow,
            HL_ID.env.doodad.stoneIce
        }
        unit = {
            HL_ID.env.unit_model.stone0,
            HL_ID.env.unit_model.stone1,
            HL_ID.env.unit_model.stone2,
            HL_ID.env.unit_model.stone3,
            HL_ID.env.unit_model.stone_show0,
            HL_ID.env.unit_model.stone_show1,
            HL_ID.env.unit_model.stone_show2,
            HL_ID.env.unit_model.stone_show3,
            HL_ID.env.unit_model.stone_show4
        }
    elseif (typeStr == "winterDeep") then
        ground = HL_ID.env.ground.winterDeep
        doodad = {
            HL_ID.env.doodad.treeWinterShow,
            HL_ID.env.doodad.stoneIce
        }
        unit = {
            HL_ID.env.unit_model.stone_show5,
            HL_ID.env.unit_model.stone_show6,
            HL_ID.env.unit_model.stone_show7,
            HL_ID.env.unit_model.stone_show8,
            HL_ID.env.unit_model.stone_show9,
            HL_ID.env.unit_model.ice0,
            HL_ID.env.unit_model.ice1,
            HL_ID.env.unit_model.ice2,
            HL_ID.env.unit_model.ice3,
            HL_ID.env.unit_model.bubble_geyser_steam,
            HL_ID.env.unit_model.snowman
        }
    elseif (typeStr == "dark") then
        ground = HL_ID.env.ground.dark
        doodad = {
            HL_ID.env.doodad.treeDark,
            HL_ID.env.doodad.treeDarkUmbrella,
            HL_ID.env.doodad.cage
        }
        unit = {
            HL_ID.env.unit_model.rune0,
            HL_ID.env.unit_model.rune1,
            HL_ID.env.unit_model.rune2,
            HL_ID.env.unit_model.rune3,
            HL_ID.env.unit_model.rune4,
            HL_ID.env.unit_model.rune5,
            HL_ID.env.unit_model.rune6,
            HL_ID.env.unit_model.impaled_body0,
            HL_ID.env.unit_model.impaled_body1
        }
    elseif (typeStr == "poor") then
        ground = HL_ID.env.ground.poor
        doodad = {
            HL_ID.env.doodad.treePoor,
            HL_ID.env.doodad.treePoorUmbrella,
            HL_ID.env.doodad.cage,
            HL_ID.env.doodad.box
        }
        unit = {
            HL_ID.env.unit_model.bone0,
            HL_ID.env.unit_model.bone1,
            HL_ID.env.unit_model.bone2,
            HL_ID.env.unit_model.bone3,
            HL_ID.env.unit_model.bone4,
            HL_ID.env.unit_model.bone5,
            HL_ID.env.unit_model.bone6,
            HL_ID.env.unit_model.bone7,
            HL_ID.env.unit_model.bone8,
            HL_ID.env.unit_model.bone9,
            HL_ID.env.unit_model.flies,
            HL_ID.env.unit_model.burn_body0,
            HL_ID.env.unit_model.burn_body1,
            HL_ID.env.unit_model.burn_body3,
            HL_ID.env.unit_model.bats
        }
    elseif (typeStr == "ruins") then
        ground = HL_ID.env.ground.ruins
        doodad = {
            HL_ID.env.doodad.treeRuins,
            HL_ID.env.doodad.treeRuinsUmbrella,
            HL_ID.env.doodad.cage
        }
        unit = {
            HL_ID.env.unit_model.break_column0,
            HL_ID.env.unit_model.break_column1,
            HL_ID.env.unit_model.break_column2,
            HL_ID.env.unit_model.break_column3,
            HL_ID.env.unit_model.skull_pile0,
            HL_ID.env.unit_model.skull_pile1,
            HL_ID.env.unit_model.skull_pile2,
            HL_ID.env.unit_model.skull_pile3
        }
    elseif (typeStr == "fire") then
        ground = HL_ID.env.ground.fire
        doodad = {
            HL_ID.env.doodad.volcano,
            HL_ID.env.doodad.stoneRed
        }
        unit = {
            HL_ID.env.unit_model.fire_hole,
            HL_ID.env.unit_model.burn_body0,
            HL_ID.env.unit_model.burn_body1,
            HL_ID.env.unit_model.burn_body2,
            HL_ID.env.unit_model.firetrap,
            HL_ID.env.unit_model.fire,
            HL_ID.env.unit_model.burn_build
        }
    elseif (typeStr == "underground") then
        ground = HL_ID.env.ground.underground
        doodad = {
            HL_ID.env.doodad.treeUnderground,
            HL_ID.env.doodad.spiderEggs
        }
        unit = {
            HL_ID.env.unit_model.mushroom0,
            HL_ID.env.unit_model.mushroom1,
            HL_ID.env.unit_model.mushroom2,
            HL_ID.env.unit_model.mushroom3,
            HL_ID.env.unit_model.mushroom4,
            HL_ID.env.unit_model.mushroom5,
            HL_ID.env.unit_model.mushroom6,
            HL_ID.env.unit_model.mushroom7,
            HL_ID.env.unit_model.mushroom8,
            HL_ID.env.unit_model.mushroom9,
            HL_ID.env.unit_model.mushroom10,
            HL_ID.env.unit_model.mushroom11
        }
    elseif (typeStr == "sea") then
        ground = HL_ID.env.ground.sea
        doodad = {}
        unit = {
            HL_ID.env.unit_model.seaweed0,
            HL_ID.env.unit_model.seaweed1,
            HL_ID.env.unit_model.seaweed2,
            HL_ID.env.unit_model.seaweed3,
            HL_ID.env.unit_model.seaweed4,
            HL_ID.env.unit_model.fish,
            HL_ID.env.unit_model.fish_school,
            HL_ID.env.unit_model.fish_green,
            HL_ID.env.unit_model.bubble_geyser,
            HL_ID.env.unit_model.bubble_geyser_steam,
            HL_ID.env.unit_model.coral0,
            HL_ID.env.unit_model.coral1,
            HL_ID.env.unit_model.coral2,
            HL_ID.env.unit_model.coral3,
            HL_ID.env.unit_model.coral4,
            HL_ID.env.unit_model.coral5,
            HL_ID.env.unit_model.coral6,
            HL_ID.env.unit_model.coral7,
            HL_ID.env.unit_model.coral8,
            HL_ID.env.unit_model.coral9,
            HL_ID.env.unit_model.shells0,
            HL_ID.env.unit_model.shells1,
            HL_ID.env.unit_model.shells2,
            HL_ID.env.unit_model.shells3,
            HL_ID.env.unit_model.shells4,
            HL_ID.env.unit_model.shells5,
            HL_ID.env.unit_model.shells6,
            HL_ID.env.unit_model.shells7,
            HL_ID.env.unit_model.shells8,
            HL_ID.env.unit_model.shells9
        }
    elseif (typeStr == "river") then
        ground = HL_ID.env.ground.river
        doodad = {
            HL_ID.env.doodad.stone
        }
        unit = {
            HL_ID.env.unit_model.fish,
            HL_ID.env.unit_model.fish_school,
            HL_ID.env.unit_model.fish_green,
            HL_ID.env.unit_model.lilypad0,
            HL_ID.env.unit_model.lilypad1,
            HL_ID.env.unit_model.lilypad2,
            HL_ID.env.unit_model.river_rushes0,
            HL_ID.env.unit_model.river_rushes1,
            HL_ID.env.unit_model.river_rushes2,
            HL_ID.env.unit_model.river_rushes3
        }
    else
        return
    end
    henv.build(whichRect, typeStr, isInvulnerable, isDestroyRect, ground, doodad, unit)
end
