-- 地形类型（这里只写默认的16个，如果你改动了地形，请自行补充）
TERRAIN = {
    LORDS_DIRT = c2i('Ldrt'), -- 洛丹伦(夏) 泥地 [泥土]
    LORDS_DIRTROUGH = c2i('Ldro'), -- 洛丹伦(夏) 坑洼的泥土 [遗迹地砖]
    LORDS_DIRTGRASS = c2i('Ldrg'), -- 洛丹伦(夏) 草色泥土 [沙地]
    LORDS_ROCK = c2i('Lrok'), -- 洛丹伦(夏) 岩石 [黑冰]
    LORDS_GRASS = c2i('Lgrs'), -- 洛丹伦(夏) 草地 [白雪]
    LORDS_GRASSDARK = c2i('Lgrd'), -- 洛丹伦(夏) 深色草地 [森林]
    CITY_DIRTROUGH = c2i('Ydtr'), -- 城邦 坑洼的泥土 [秋草]
    CITY_BLACKMARBLE = c2i('Yblm'), -- 城邦 黑色大理石 [黄土]
    CITY_BRICKTILES = c2i('Ybtl'), -- 城邦 砖 [红色地砖]
    CITY_ROUNDTILES = c2i('Yrtl'), -- 城邦 圆形地形 [火焰]
    CITY_GRASS = c2i('Ygsb'), -- 城邦 草地 [青草]
    CITY_GRASSTRIM = c2i('Yhdg'), -- 城邦 平整草地 [败草]
    CITY_WHITEMARBLE = c2i('Ywmb'), -- 城邦 白色大理石 [熔岩]
    DALARAN_DIRTROUGH = c2i('Xdtr'), -- 达拉然 坑洼的泥土 [荒地]
    DALARAN_BLACKMARBLE = c2i('Xblm'), -- 达拉然 黑色大理石 [藤蔓]
    DALARAN_BRICKTILES = c2i('Xbtl'), -- 达拉然 砖 [蓝冰]
}

--- 地形
hterrain = {}

--- 获取x，y坐标的地形地表贴图类型
---@see variable TERRAIN_?
---@param x number
---@param y number
---@return boolean
function hterrain.type(x, y)
    return cj.GetTerrainType(x, y)
end

--- 是否某类型
---@param x number
---@param y number
---@see variable TERRAIN_?
---@param whichType number
---@return boolean
function hterrain.isType(x, y, whichType)
    return whichType == hterrain.type(x, y)
end

--- 是否荒芜地表
---@param x number
---@param y number
---@return boolean
function hterrain.isBlighted(x, y)
    return cj.IsPointBlighted(x, y)
end

--- 是否可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkable(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end

--- 是否飞行可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkableFly(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_FLYABILITY)
end

--- 是否水(海)面可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkableWater(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end

--- 是否两栖可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkableAmphibious(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_AMPHIBIOUSPATHING)
end

--- 是否荒芜可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkableBlight(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_BLIGHTPATHING)
end

--- 是否建造可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkableBuild(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end

--- 是否采集时可通行
---@param x number
---@param y number
---@return boolean
function hterrain.isWalkablePeonHarvest(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_PEONHARVESTPATHING)
end

--- 是否处在水面
---@param x number
---@param y number
---@return boolean
function hterrain.isWater(x, y)
    return hterrain.isWalkableWater(x, y)
end

--- 是否处于地面
--- 这里实际上判断的是非水区域
---@param x number
---@param y number
---@return boolean
function hterrain.isGround(x, y)
    return not hterrain.isWalkableWater(x, y)
end