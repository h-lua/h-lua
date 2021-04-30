local cache = require "lib.dzapi.cache"

---@class hdzapi DzApi
hdzapi = {}

--- 地图是否来自RPG大厅
---@return boolean
hdzapi.isRPGLobby = function()
    if (cache.isRPGLobby == nil) then
        cache.isRPGLobby = hjapi.DzAPI_Map_IsRPGLobby() or false
    end
    return cache.isRPGLobby
end

--- 地图是否在RPG天梯
---@return boolean
hdzapi.isRPGLadder = function()
    if (cache.isRPGLadder == nil) then
        cache.isRPGLadder = hjapi.DzAPI_Map_IsRPGLadder() or false
    end
    return cache.isRPGLadder
end

--- 是否红V
---@param whichPlayer userdata
---@return boolean
hdzapi.isRedVip = function(whichPlayer)
    if (cache.isRedVip[whichPlayer] == nil) then
        cache.isRedVip[whichPlayer] = hjapi.DzAPI_Map_IsRedVIP(whichPlayer) or false
    end
    return cache.isRedVip[whichPlayer]
end

--- 是否蓝V
---@param whichPlayer userdata
---@return boolean
hdzapi.isBlueVip = function(whichPlayer)
    if (cache.isBlueVip[whichPlayer] == nil) then
        cache.isBlueVip[whichPlayer] = hjapi.DzAPI_Map_IsBlueVIP(whichPlayer) or false
    end
    return cache.isBlueVip[whichPlayer]
end

--- 是否平台VIP
---@param whichPlayer userdata
---@return boolean
hdzapi.isPlatformVIP = function(whichPlayer)
    if (cache.isPlatformVIP[whichPlayer] == nil) then
        cache.isPlatformVIP[whichPlayer] = hjapi.DzAPI_Map_IsPlatformVIP(whichPlayer) or false
    end
    return cache.isPlatformVIP[whichPlayer]
end

--- 获取地图等级
---@param whichPlayer userdata
---@return number
hdzapi.mapLevel = function(whichPlayer)
    if (cache.mapLevel[whichPlayer] == nil) then
        cache.mapLevel[whichPlayer] = math.max(1, hjapi.DzAPI_Map_GetMapLevel(whichPlayer) or 1)
    end
    return cache.mapLevel[whichPlayer]
end

--- 是否有商城道具,由于官方设置的key必须大写，所以这里自动转换
---@param whichPlayer userdata
---@param key string
---@return boolean
hdzapi.hasMallItem = function(whichPlayer, key)
    if (whichPlayer == nil or key == nil) then
        return false
    end
    if (cache.hasMallItem[key] == nil) then
        cache.hasMallItem[key] = {}
        for i = 1, bj_MAX_PLAYERS, 1 do
            cache.hasMallItem[key][i] = hjapi.DzAPI_Map_HasMallItem(hplayer.players[i], key) or false
        end
    end
    return cache.hasMallItem[key][hplayer.index(whichPlayer)]
end

--- 获取服务器当前时间戳
--- * 此方法在本地不能准确获取当前时间
---@return number
hdzapi.timestamp = function()
    if (cache.gameStartTime == nil) then
        cache.gameStartTime = hjapi.DzAPI_Map_GetGameStartTime() or 0
    end
    return cache.gameStartTime + htime.count
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
    local idx = hplayer.index(whichPlayer)
    if (cache.serverData[key] == nil) then
        cache.serverData[key] = {}
        if (cache.serverData[key][idx] == nil) then
            if (true == hjapi.GetPlayerServerValueSuccess(whichPlayer)) then
                cache.serverData[key][idx] = hjapi.DzAPI_Map_GetServerValue(whichPlayer, key) or ""
            end
        end
    end
    return cache.serverData[key][idx]
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
hdzapi.roulette = function(whichPlayer, method, params)
    if (method == nil) then
        return
    end
    if (type(cache.roulette) == "table") then
        table.insert(cache.roulette, { whichPlayer = whichPlayer, method = method, params = params })
        return
    end
    cache.roulette = {}
    table.insert(cache.roulette, { whichPlayer = whichPlayer, method = method, params = params })
    htime.setInterval(2, function(curTimer)
        if (#cache.roulette <= 0) then
            htime.delTimer(curTimer)
            cache.roulette = nil
            return
        end
        local obj = cache.roulette[1]
        if (true == hjapi.GetPlayerServerValueSuccess(obj.whichPlayer)) then
            hjapi[obj.method](obj.whichPlayer, table.unpack(obj.params))
            table.remove(cache.roulette, 1)
        end
    end)
end

--- 设置服务器数据
---@param whichPlayer userdata
---@param key string
---@param value string|number
hdzapi.saveServer = function(whichPlayer, key, value)
    hdzapi.roulette(whichPlayer, "DzAPI_Map_SaveServerValue", { key, value })
end

--- 清空服务器数据
---@param whichPlayer userdata
---@param key string
hdzapi.clearServer = function(whichPlayer, key)
    hdzapi.roulette(whichPlayer, "DzAPI_Map_SaveServerValue", { key, nil })
end

--- 设置房间数据
---@param whichPlayer userdata
---@param key string
---@param value string
hdzapi.setRoomStat = function(whichPlayer, key, value)
    hdzapi.roulette(whichPlayer, "DzAPI_Map_Stat_SetStat", { key, value })
end