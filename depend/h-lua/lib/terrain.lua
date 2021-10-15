-- 地形类型（这里只写默认的16个，如果你改动了地形，请自行补充）
TERRAIN = {
    LORDS_DIRT = string.char2id('Ldrt'), -- 洛丹伦(夏) 泥地 [泥土]
    LORDS_DIRTROUGH = string.char2id('Ldro'), -- 洛丹伦(夏) 坑洼的泥土 [遗迹地砖]
    LORDS_DIRTGRASS = string.char2id('Ldrg'), -- 洛丹伦(夏) 草色泥土 [沙地]
    LORDS_ROCK = string.char2id('Lrok'), -- 洛丹伦(夏) 岩石 [黑冰]
    LORDS_GRASS = string.char2id('Lgrs'), -- 洛丹伦(夏) 草地 [白雪]
    LORDS_GRASSDARK = string.char2id('Lgrd'), -- 洛丹伦(夏) 深色草地 [森林]
    CITY_DIRTROUGH = string.char2id('Ydtr'), -- 城邦 坑洼的泥土 [秋草]
    CITY_BLACKMARBLE = string.char2id('Yblm'), -- 城邦 黑色大理石 [黄土]
    CITY_BRICKTILES = string.char2id('Ybtl'), -- 城邦 砖 [红色地砖]
    CITY_ROUNDTILES = string.char2id('Yrtl'), -- 城邦 圆形地形 [火焰]
    CITY_GRASS = string.char2id('Ygsb'), -- 城邦 草地 [青草]
    CITY_GRASSTRIM = string.char2id('Yhdg'), -- 城邦 平整草地 [败草]
    CITY_WHITEMARBLE = string.char2id('Ywmb'), -- 城邦 白色大理石 [熔岩]
    DALARAN_DIRTROUGH = string.char2id('Xdtr'), -- 达拉然 坑洼的泥土 [荒地]
    DALARAN_BLACKMARBLE = string.char2id('Xblm'), -- 达拉然 黑色大理石 [藤蔓]
    DALARAN_BRICKTILES = string.char2id('Xbtl'), -- 达拉然 砖 [蓝冰]
}

--- 地形
hterrain = {}

--- 获取x，y坐标的地形地表贴图类型
---@see variable TERRAIN_?
---@param x number
---@param y number
---@return boolean
hterrain.type = function(x, y)
    return cj.GetTerrainType(x, y)
end

--- 是否某类型
---@param x number
---@param y number
---@see variable TERRAIN_?
---@param whichType number
---@return boolean
hterrain.isType = function(x, y, whichType)
    return whichType == hterrain.type(x, y)
end

--- 是否荒芜地表
---@param x number
---@param y number
---@return boolean
hterrain.isBlighted = function(x, y)
    return cj.IsPointBlighted(x, y)
end

--- 是否可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkable = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end

--- 是否飞行可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkableFly = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_FLYABILITY)
end

--- 是否水(海)面可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkableWater = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end

--- 是否两栖可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkableAmphibious = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_AMPHIBIOUSPATHING)
end

--- 是否荒芜可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkableBlight = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_BLIGHTPATHING)
end

--- 是否建造可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkableBuild = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end

--- 是否采集时可通行
---@param x number
---@param y number
---@return boolean
hterrain.isWalkablePeonHarvest = function(x, y)
    return not cj.IsTerrainPathable(x, y, PATHING_TYPE_PEONHARVESTPATHING)
end

--- 是否处在水面
---@param x number
---@param y number
---@return boolean
hterrain.isWater = function(x, y)
    return hterrain.isWalkableWater(x, y)
end

--- 是否处于地面
--- 这里实际上判断的是非水区域
---@param x number
---@param y number
---@return boolean
hterrain.isGround = function(x, y)
    return not hterrain.isWalkableWater(x, y)
end