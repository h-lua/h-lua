---@class hdzapi DzApi
hdzapi = {
    _hasMallItem = {},
    _serverData = {},
    _roulette = nil,
}

--- 地图是否来自RPG大厅
---@return boolean
hdzapi.isRPGLobby = function()
    return cg.hdzapi_isRPGLobby or false
end

--- 地图是否在RPG天梯
---@return boolean
hdzapi.isRPGLadder = function()
    return cg.hdzapi_isRPGLadder or false
end

--- 是否红V
---@param whichPlayer userdata
---@return boolean
hdzapi.isRedVip = function(whichPlayer)
    return cg.hdzapi_isRedVip[hplayer.index(whichPlayer)] or false
end

--- 是否蓝V
---@param whichPlayer userdata
---@return boolean
hdzapi.isBlueVip = function(whichPlayer)
    return cg.hdzapi_isBlueVip[hplayer.index(whichPlayer)] or false
end

--- 获取地图等级
---@param whichPlayer userdata
---@return number
hdzapi.mapLevel = function(whichPlayer)
    return math.max(1, cg.hdzapi_mapLevel[hplayer.index(whichPlayer)])
end

--- 是否有商城道具,由于官方设置的key必须大写，所以这里自动转换
---@param whichPlayer userdata
---@param key string
---@return boolean
hdzapi.hasMallItem = function(whichPlayer, key)
    if (whichPlayer == nil or key == nil) then
        return false
    end
    key = string.upper(key)
    if (hdzapi._hasMallItem[key] == nil) then
        cg.hdzapi_mallItemKey = key
        cj.ExecuteFunc("hdzapi_mallItem")
        hdzapi._hasMallItem[key] = {}
        for i = 1, bj_MAX_PLAYERS, 1 do
            hdzapi._hasMallItem[key][i] = cg.hdzapi_hasMallItem[i]
        end
    end
    return hdzapi._hasMallItem[key][hplayer.index(whichPlayer)]
end

--- 获取服务器当前时间戳
--- * 此方法在本地不能准确获取当前时间
---@return number
hdzapi.timestamp = function()
    return cg.hdzapi_serverTimestamp + htime.count
end

--- 获取服务器当前时间对象
--- * 此方法在本地不能准确获取当前时间，将从UNIX元秒开始(1970年)
---@return table {Y:"年",m:"月",d:"日",H:"时",i:"分",s:"秒",w:"周[0-6]",W:"周[日-六]"}
hdzapi.date = function()
    return math.date(hdzapi.timestamp())
end

--- 获取服务器数据
---@param whichPlayer userdata
---@param key string
---@return string
hdzapi.loadServer = function(whichPlayer, key)
    if (whichPlayer == nil or key == nil) then
        return
    end
    if (hdzapi._serverData[key] == nil) then
        cg.hdzapi_serverDataKey = key
        cj.ExecuteFunc("hdzapi_loadServer")
        hdzapi._serverData[key] = {}
        for i = 1, bj_MAX_PLAYERS, 1 do
            hdzapi._serverData[key][i] = cg.hdzapi_serverData[i]
        end
    end
    return hdzapi._serverData[key][hplayer.index(whichPlayer)]
end
hdzapi.loadServerBool = function(whichPlayer, key)
    return "1" == (hdzapi.loadServer(whichPlayer, key) or "0")
end
hdzapi.loadServerNumber = function(whichPlayer, key)
    return tonumber(hdzapi.loadServer(whichPlayer, key) or 0)
end
hdzapi.loadServerInteger = function(whichPlayer, key)
    return math.floor(hdzapi.loadServerNumber(whichPlayer, key) or 0)
end

---@private
--- * 此方法自带有延迟策略，以减少服务器压力，而服务器实际上也不是实时存储，在本地只是模拟
hdzapi.roulette = function(func, whichPlayer, key, value)
    if (func == nil or whichPlayer == nil or key == nil or value == nil) then
        return
    end
    if (type(value) == "boolean") then
        if (value) then
            value = "1"
        else
            value = "0"
        end
    elseif (type(value) == "number") then
        value = tostring(value)
    end
    if (type(hdzapi._roulette) == "table") then
        table.insert(hdzapi._roulette, { func, hplayer.index(whichPlayer), key, value })
        return
    end
    hdzapi._roulette = {}
    table.insert(hdzapi._roulette, { func, hplayer.index(whichPlayer), key, value })
    htime.setInterval(2, function(curTimer)
        if (#hdzapi._roulette <= 0) then
            htime.delTimer(curTimer)
            hdzapi._roulette = nil
            return
        end
        local obj = hdzapi._roulette[1]
        cg.hdzapi_roulettePlayer = obj[2]
        cg.hdzapi_rouletteKey = obj[3]
        cg.hdzapi_rouletteValue = obj[4]
        cj.ExecuteFunc(obj[1])
        table.remove(hdzapi._roulette, 1)
    end)
end

--- 设置服务器数据
---@param whichPlayer userdata
---@param key string
---@param value string|number
hdzapi.saveServer = function(whichPlayer, key, value)
    hdzapi.roulette("hdzapi_saveServer", whichPlayer, key, value)
end

--- 清空服务器数据
---@param whichPlayer userdata
---@param key string
hdzapi.clearServer = function(whichPlayer, key)
    hdzapi.roulette("hdzapi_saveServer", whichPlayer, key, "")
end

--- 设置房间数据
---@param whichPlayer userdata
---@param key string
---@param value string
hdzapi.setRoomStat = function(whichPlayer, key, value)
    hdzapi.roulette("hdzapi_setRoomStat", whichPlayer, key, value)
end