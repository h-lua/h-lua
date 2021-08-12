---@class hjapi JAPI
hjapi = {
    _lib = nil,
    _tips = {},
    _formatter = {},
    _triumph = {},
}

---@private
hjapi.lib = function()
    if (hjapi._lib == -9394) then
        return false
    end
    if (hjapi._lib == nil) then
        hjapi._lib = require "jass.japi"
        if (hjapi._lib == nil) then
            hjapi._lib = -9394
            return false
        end
        hjapi._formatter = require "lib.japi.formatter"
        hjapi._triumph = require "lib.japi.triumph"
    end
    return hjapi._lib
end

---@private
hjapi.echo = function(msg)
    if (hjapi._tips[msg] == nil) then
        hjapi._tips[msg] = 1
        if (DEBUGGING) then
            print_mb("<JAPI> " .. msg)
        else
            echo("<JAPI> " .. msg)
        end
    end
end

---@private
---@param method string
---@return boolean
hjapi.has = function(method)
    local api = hjapi.lib()
    if (false == api) then
        return false
    end
    if (type(method) ~= 'string') then
        return false
    end
    if (type(api[method]) == "function") then
        return true
    end
    return false
end

---@private
---@param method string
---@param params table|nil
hjapi.formatter = function(method, params)
    if (type(params) == "table" and type(hjapi._formatter[method]) == 'function') then
        hjapi._formatter[method](params)
    end
end

---@private
---@param method string
---@param params table|nil
hjapi.triumph = function(method, params, result)
    if (type(hjapi._triumph[method]) == 'function') then
        return hjapi._triumph[method](params, result)
    end
    return result
end

---@private
---@param method string
---@param params table|nil
---@return any
hjapi.exec = function(method, params)
    local api = hjapi.lib()
    if (false == api) then
        return false
    end
    if (type(method) ~= 'string') then
        return false
    end
    if (type(api[method]) ~= "function") then
        hjapi.echo(method .. " function does not exist, please check the WE environment! You should make friends with 5382557(QQ)")
        return false
    end
    hjapi.formatter(method, params)
    if (params == nil) then
        res = api[method]()
    else
        res = api[method](table.unpack(params))
    end
    return hjapi.triumph(method, params, res)
end

------------------------------------------------------------------------------------------------------------------------

hjapi.DzAPI_CommonFunc_GetARGBColorValue = function(...)
    return hjapi.exec("DzAPI_CommonFunc_GetARGBColorValue", { ... })
end

hjapi.DzAPI_CommonFunc_GetARGBColorValuePercent = function(...)
    return hjapi.exec("DzAPI_CommonFunc_GetARGBColorValuePercent", { ... })
end

hjapi.DzAPI_CommonFunc_SetARGBColorValue = function(...)
    return hjapi.exec("DzAPI_CommonFunc_SetARGBColorValue", { ... })
end

hjapi.DzAPI_CommonFunc_SetARGBColorValuePercent = function(...)
    return hjapi.exec("DzAPI_CommonFunc_SetARGBColorValuePercent", { ... })
end

hjapi.DzAPI_Map_ChangeStoreItemCoolDown = function(...)
    return hjapi.exec("DzAPI_Map_ChangeStoreItemCoolDown", { ... })
end

hjapi.DzAPI_Map_ChangeStoreItemCount = function(...)
    return hjapi.exec("DzAPI_Map_ChangeStoreItemCount", { ... })
end

---@return string
hjapi.DzAPI_Map_GetActivityData = function()
    return hjapi.exec("DzAPI_Map_GetActivityData", nil)
end

--- 获取当前游戏时间
--- 获取创建地图的游戏时间
--- 时间换算为时间戳
---@return number
hjapi.DzAPI_Map_GetGameStartTime = function()
    return hjapi.exec("DzAPI_Map_GetGameStartTime", nil)
end

--- 获取公会名称
---@param whichPlayer userdata
---@return string
hjapi.DzAPI_Map_GetGuildName = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetGuildName", { whichPlayer })
end

--- 获取公会职责
--- 获取公会职责 Member=10 Admin=20 Leader=30
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetGuildRole = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetGuildRole", { whichPlayer })
end

--- 获取天梯等级
--- 取值1~25，青铜V是1级
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetLadderLevel = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetLadderLevel", { whichPlayer })
end

--- 获取天梯排名
--- 排名>1000的获取值为0
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetLadderRank = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetLadderRank", { whichPlayer })
end

--- 获取全局服务器存档值
---@param key string
---@return number
hjapi.DzAPI_Map_GetMapConfig = function(key)
    return hjapi.exec("DzAPI_Map_GetMapConfig", { key })
end

--- 获取玩家地图等级
--- 获取玩家地图等级【RPG大厅限定】
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetMapLevel = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetMapLevel", { whichPlayer })
end

--- 获取玩家地图等级排名
--- 排名>100的获取值为0
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetMapLevelRank = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetMapLevelRank", { whichPlayer })
end

--- 获取天梯和匹配的模式
--- 返回数值与作者之家设置对应
hjapi.DzAPI_Map_GetMatchType = function()
    return hjapi.exec("DzAPI_Map_GetMatchType", nil)
end

--- 获取玩家平台VIP标志
---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetPlatformVIP = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetPlatformVIP", { whichPlayer })
end

--- 玩家是否平台VIP
---@param whichPlayer userdata
---@return boolean
hjapi.DzAPI_Map_IsPlatformVIP = function(whichPlayer)
    local res = hjapi.DzAPI_Map_GetPlatformVIP(whichPlayer)
    if (type(res) == "number") then
        return math.floor(res) > 0
    end
    return false
end

--- 读取公共服务器存档组数据
--- 服务器存档组有100个KEY，每个KEY64个字符长度，可以多张地图读取和保存，使用前先在作者之家服务器存档组设置
---@param whichPlayer userdata
---@param key string
---@return string
hjapi.DzAPI_Map_GetPublicArchive = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetPublicArchive", { whichPlayer, key })
end

--- 读取服务器Boss掉落装备类型
---@param whichPlayer userdata
---@param key string
---@return string
hjapi.DzAPI_Map_GetServerArchiveDrop = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerArchiveDrop", { whichPlayer, key })
end

---@param whichPlayer userdata
---@param key string
---@return number
hjapi.DzAPI_Map_GetServerArchiveEquip = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerArchiveEquip", { whichPlayer, key })
end

---@param whichPlayer userdata
---@param key string
---@return string
hjapi.DzAPI_Map_GetServerValue = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerValue", { whichPlayer, key })
end

---@param whichPlayer userdata
---@return number
hjapi.DzAPI_Map_GetServerValueErrorCode = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetServerValueErrorCode", { whichPlayer })
end

--- 读取玩家服务器存档成功
--- 如果返回false代表读取失败,反之成功,之后游戏里平台不会再发送“服务器保存失败”的信息，所以希望地图作者在游戏开始给玩家发下信息服务器存档是否正确读取。
---@param whichPlayer userdata
---@return boolean
hjapi.GetPlayerServerValueSuccess = function(whichPlayer)
    local res = hjapi.DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    if (type(res) == "number") then
        return math.floor(res) == 0
    end
    return false
end

hjapi.DzAPI_Map_GetUserID = function(...)
    return hjapi.exec("DzAPI_Map_GetUserID", { ... })
end

--- 玩家是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer userdata
---@param key string
---@return boolean
hjapi.DzAPI_Map_HasMallItem = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_HasMallItem", { whichPlayer, key })
end

--- 判断是否是蓝V
---@param whichPlayer userdata
---@return boolean
hjapi.DzAPI_Map_IsBlueVIP = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_IsBlueVIP", { whichPlayer })
end

--- 判断地图是否在RPG天梯
---@return boolean
hjapi.DzAPI_Map_IsRPGLadder = function()
    return hjapi.exec("DzAPI_Map_IsRPGLadder", nil)
end

--- 判断当前地图是否rpg大厅来的
---@return boolean
hjapi.DzAPI_Map_IsRPGLobby = function()
    return hjapi.exec("DzAPI_Map_IsRPGLobby", nil)
end

--- 判断是否是红V
---@param whichPlayer userdata
---@return boolean
hjapi.DzAPI_Map_IsRedVIP = function(whichPlayer)
    return hjapi.exec("DzAPI_Map_IsRedVIP", { whichPlayer })
end

---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_Ladder_SetPlayerStat = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Ladder_SetPlayerStat", { whichPlayer, key, value })
end

--- 天梯提交玩家排名
---@param whichPlayer userdata
---@param value number
hjapi.DzAPI_Map_Ladder_SubmitPlayerRank = function(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

--- 天梯提交字符串数据
---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_Ladder_SetStat = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Ladder_SetStat", { whichPlayer, key, value })
end

--- 天梯提交获得称号
---@param whichPlayer userdata
---@param value string
hjapi.DzAPI_Map_Ladder_SubmitTitle = function(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, value, "1")
end

--- 设置玩家额外分
---@param whichPlayer userdata
---@param value string
hjapi.DzAPI_Map_Ladder_SubmitPlayerExtraExp = function(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

--- 活动完成
--- 完成平台活动[RPG大厅限定]
---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_MissionComplete = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_MissionComplete", { whichPlayer, key, value })
end

--- 触发boss击杀
---@param whichPlayer userdata
---@param key string
hjapi.DzAPI_Map_OrpgTrigger = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_OrpgTrigger", { whichPlayer, key })
end

--- 服务器公共存档组保存
--- 存储服务器存档组，服务器存档组有100个KEY，每个KEY64个字符串长度，使用前请在作者之家服务器存档组进行设置
---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_SavePublicArchive = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_SavePublicArchive", { whichPlayer, key, value })
end

--- 保存服务器存档
---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_SaveServerValue = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_SaveServerValue", { whichPlayer, key, value })
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer userdata
---@param key string
---@param value string
hjapi.DzAPI_Map_Stat_SetStat = function(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Stat_SetStat", { whichPlayer, key, value })
end

--- 平台统计
--- 一般用于统计游戏里某些事件的触发次数，可在作者之家查看。【第二个子key是以后备用暂时不要填】
---@param whichPlayer userdata
---@param eventKey string
---@param eventType string
---@param value number integer
hjapi.DzAPI_Map_Statistics = function(whichPlayer, eventKey, eventType, value)
    return hjapi.exec("DzAPI_Map_Statistics", { whichPlayer, eventKey, eventType, value })
end

hjapi.DzAPI_Map_ToggleStore = function(...)
    return hjapi.exec("DzAPI_Map_ToggleStore", { ... })
end

hjapi.DzAPI_Map_UpdatePlayerHero = function(...)
    return hjapi.exec("DzAPI_Map_UpdatePlayerHero", { ... })
end

--- 局数消耗商品调用
--- 仅对局数消耗型商品有效
---@param whichPlayer userdata
---@param key string
hjapi.DzAPI_Map_UseConsumablesItem = function(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_UseConsumablesItem", { whichPlayer, key })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayAbilID", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayBoolean", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayItemID = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayItemID", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayReal = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayReal", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayString = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayString", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayTechID = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayTechID", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataArrayUnitID = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataArrayUnitID", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataRequires = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataRequires", { ... })
end

hjapi.DzAPI_UnitType_CountUnitTypeDataRequiresamount = function(...)
    return hjapi.exec("DzAPI_UnitType_CountUnitTypeDataRequiresamount", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_PreventOrReguirePlace = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_PreventOrReguirePlace", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_PreventOrReguirePlaceCheck = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_PreventOrReguirePlaceCheck", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_Primary = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_Primary", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_TargetTypeCheck = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_TargetTypeCheck", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_TargetTypeSeries = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_TargetTypeSeries", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_armor = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_armor", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_atkType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_atkType", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_buffType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_buffType", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_deathType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_deathType", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_defType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_defType", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_movetp = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_movetp", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_race = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_race", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_regenType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_regenType", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_type = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_type", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_typeCheck = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_typeCheck", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_warpsOn = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_warpsOn", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_weapTp = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_weapTp", { ... })
end

hjapi.DzAPI_UnitType_GetEnum_weapType = function(...)
    return hjapi.exec("DzAPI_UnitType_GetEnum_weapType", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataAbilID", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayAbilID", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayBoolean", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayItemID = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayItemID", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayReal = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayReal", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayString = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayString", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayTechID = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayTechID", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataArrayUnitID = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataArrayUnitID", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataBoolean", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataInt = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataInt", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataReal = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataReal", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataRequires = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataRequires", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataRequiresamount = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataRequiresamount", { ... })
end

hjapi.DzAPI_UnitType_GetUnitTypeDataString = function(...)
    return hjapi.exec("DzAPI_UnitType_GetUnitTypeDataString", { ... })
end

hjapi.DzAPI_UnitType_GettUnitTypeDataRequirescount = function(...)
    return hjapi.exec("DzAPI_UnitType_GettUnitTypeDataRequirescount", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayAbilID", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayBoolean", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayItemID = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayItemID", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayReal = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayReal", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayString = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayString", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayTechID = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayTechID", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataArrayUnitID = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataArrayUnitID", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataRequires = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataRequires", { ... })
end

hjapi.DzAPI_UnitType_ResizeUnitTypeDataRequiresamount = function(...)
    return hjapi.exec("DzAPI_UnitType_ResizeUnitTypeDataRequiresamount", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_PreventOrReguirePlace = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_PreventOrReguirePlace", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_PreventOrReguirePlaceModify = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_PreventOrReguirePlaceModify", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_Primary = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_Primary", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_TargetTypeModify = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_TargetTypeModify", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_TargetTypeSeries = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_TargetTypeSeries", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_armor = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_armor", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_atkType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_atkType", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_buffType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_buffType", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_deathType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_deathType", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_defType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_defType", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_movetp = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_movetp", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_race = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_race", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_regenType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_regenType", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_type = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_type", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_typeModify = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_typeModify", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_warpsOn = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_warpsOn", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_weapTp = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_weapTp", { ... })
end

hjapi.DzAPI_UnitType_SetEnum_weapType = function(...)
    return hjapi.exec("DzAPI_UnitType_SetEnum_weapType", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataAbilID", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayAbilID = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayAbilID", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayBoolean", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayItemID = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayItemID", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayReal = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayReal", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayString = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayString", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayTechID = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayTechID", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataArrayUnitID = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataArrayUnitID", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataBoolean = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataBoolean", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataInt = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataInt", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataReal = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataReal", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataRequires = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataRequires", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataRequiresamount = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataRequiresamount", { ... })
end

hjapi.DzAPI_UnitType_SetUnitTypeDataString = function(...)
    return hjapi.exec("DzAPI_UnitType_SetUnitTypeDataString", { ... })
end

hjapi.DzAPI_UnitstateToInteger = function(...)
    return hjapi.exec("DzAPI_UnitstateToInteger", { ... })
end

--- 触发点击frame
---@param frameId number integer
hjapi.DzClickFrame = function(frameId)
    return hjapi.exec("DzClickFrame", { frameId })
end

hjapi.DzConvertWorldPosition = function(...)
    return hjapi.exec("DzConvertWorldPosition", { ... })
end

--- 新建Frame
--- 名字为fdf文件中的名字，ID默认填0。重复创建同名Frame会导致游戏退出时显示崩溃消息，如需避免可以使用Tag创建
---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
hjapi.DzCreateFrame = function(frame, parent, id)
    return hjapi.exec("DzCreateFrame", { frame, parent, id })
end

--- 新建Frame[Tag]
--- 此处名字可以自定义，类型和模版填写fdf文件中的内容。通过此函数创建的Frame无法获取到子Frame
---@param frameType string
---@param name string
---@param parent number integer
---@param template string
---@param id number integer
---@return number integer
hjapi.DzCreateFrameByTagName = function(frameType, name, parent, template, id)
    return hjapi.exec("DzCreateFrameByTagName", { frameType, name, parent, template, id })
end

---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
hjapi.DzCreateSimpleFrame = function(frame, parent, id)
    return hjapi.exec("DzCreateSimpleFrame", { frame, parent, id })
end

hjapi.DzDebugString = function(...)
    return hjapi.exec("DzDebugString", { ... })
end

--- 销毁
--- 销毁一个被重复创建过的Frame会导致游戏崩溃，重复创建同名Frame请使用Tag创建
---@param frameId number integer
hjapi.DzDestroyFrame = function(frameId)
    return hjapi.exec("DzDestroyFrame", { frameId })
end

--- 设置可破坏物位置
---@param d userdata destructable
---@param x number floor(2)
---@param y number floor(2)
hjapi.DzDestructablePosition = function(d, x, y)
    return hjapi.exec("DzDestructablePosition", { d, x, y })
end

hjapi.DzDotaInfo_IsPlayerRandom = function(...)
    return hjapi.exec("DzDotaInfo_IsPlayerRandom", { ... })
end

hjapi.DzDotaInfo_IsRepicked = function(...)
    return hjapi.exec("DzDotaInfo_IsRepicked", { ... })
end

hjapi.DzDotaInfo_Item = function(...)
    return hjapi.exec("DzDotaInfo_Item", { ... })
end

hjapi.DzDotaInfo_Item_HE = function(...)
    return hjapi.exec("DzDotaInfo_Item_HE", { ... })
end

hjapi.DzDotaInfo_Item_TM = function(...)
    return hjapi.exec("DzDotaInfo_Item_TM", { ... })
end

--- 原生 - 使用宽屏模式
---@param enable boolean
hjapi.DzEnableWideScreen = function(enable)
    return hjapi.exec("DzEnableWideScreen", { enable })
end

hjapi.DzEvent_Building_Cancel = function(...)
    return hjapi.exec("DzEvent_Building_Cancel", { ... })
end

hjapi.DzEvent_Building_Dead = function(...)
    return hjapi.exec("DzEvent_Building_Dead", { ... })
end

hjapi.DzEvent_Building_Finish = function(...)
    return hjapi.exec("DzEvent_Building_Finish", { ... })
end

hjapi.DzEvent_Building_Start = function(...)
    return hjapi.exec("DzEvent_Building_Start", { ... })
end

hjapi.DzEvent_Hero_Dead = function(...)
    return hjapi.exec("DzEvent_Hero_Dead", { ... })
end

hjapi.DzEvent_Hero_Level = function(...)
    return hjapi.exec("DzEvent_Hero_Level", { ... })
end

hjapi.DzEvent_Item_Drop = function(...)
    return hjapi.exec("DzEvent_Item_Drop", { ... })
end

hjapi.DzEvent_Item_Pickup = function(...)
    return hjapi.exec("DzEvent_Item_Pickup", { ... })
end

hjapi.DzEvent_Item_Sell = function(...)
    return hjapi.exec("DzEvent_Item_Sell", { ... })
end

hjapi.DzEvent_Item_Use = function(...)
    return hjapi.exec("DzEvent_Item_Use", { ... })
end

hjapi.DzEvent_Tech_Cancel = function(...)
    return hjapi.exec("DzEvent_Tech_Cancel", { ... })
end

hjapi.DzEvent_Tech_Finish = function(...)
    return hjapi.exec("DzEvent_Tech_Finish", { ... })
end

hjapi.DzEvent_Tech_Start = function(...)
    return hjapi.exec("DzEvent_Tech_Start", { ... })
end

hjapi.DzEvent_Unit_Cancel = function(...)
    return hjapi.exec("DzEvent_Unit_Cancel", { ... })
end

hjapi.DzEvent_Unit_ChangeOwner = function(...)
    return hjapi.exec("DzEvent_Unit_ChangeOwner", { ... })
end

hjapi.DzEvent_Unit_Dead = function(...)
    return hjapi.exec("DzEvent_Unit_Dead", { ... })
end

hjapi.DzEvent_Unit_Finish = function(...)
    return hjapi.exec("DzEvent_Unit_Finish", { ... })
end

hjapi.DzEvent_Unit_Hired = function(...)
    return hjapi.exec("DzEvent_Unit_Hired", { ... })
end

hjapi.DzEvent_Unit_Start = function(...)
    return hjapi.exec("DzEvent_Unit_Start", { ... })
end

--- 异步执行函数
---@param funcName string
hjapi.DzExecuteFunc = function(funcName)
    return hjapi.exec("DzExecuteFunc", { funcName })
end

--- 限制鼠标移动，在frame内
---@param frame number integer
---@param enable boolean
hjapi.DzFrameCageMouse = function(frame, enable)
    return hjapi.exec("DzFrameCageMouse", { frame, enable })
end

--- 清空frame所有锚点
---@param frame number integer
hjapi.DzFrameClearAllPoints = function(frame)
    return hjapi.exec("DzFrameClearAllPoints", { frame })
end

--- 修改游戏渲染黑边: 上方高度:upperHeight,下方高度:bottomHeight
---@param upperHeight number floor(3)
---@param bottomHeight number floor(3)
hjapi.DzFrameEditBlackBorders = function(upperHeight, bottomHeight)
    return hjapi.exec("DzFrameEditBlackBorders", { upperHeight, bottomHeight })
end

--- 获取名字为name的子FrameID:Id"
--- ID默认填0，同名时优先获取最后被创建的。非Simple类的Frame类型都用此函数来获取子Frame
---@param name string
---@param id number integer
---@return number integer
hjapi.DzFrameFindByName = function(name, id)
    return hjapi.exec("DzFrameFindByName", { name, id })
end

--- 获取Frame的透明度(0-255)
---@param frame number integer
---@return number integer
hjapi.DzFrameGetAlpha = function(frame)
    return hjapi.exec("DzFrameGetAlpha", { frame })
end

--- 原生 - 玩家聊天信息框
---@return number integer
hjapi.DzFrameGetChatMessage = function()
    return hjapi.exec("DzFrameGetChatMessage", nil)
end

--- 原生 - 技能按钮
--- 技能按钮:(row, column)
--- 参考物编中的技能按钮(x,y)坐标
--- (x,y)对应(column,row)反一下
---@param row number integer
---@param column number integer
---@return number integer
hjapi.DzFrameGetCommandBarButton = function(row, column)
    return hjapi.exec("DzFrameGetCommandBarButton", { row, column })
end

--- frame控件是否启用
---@param frame number integer
---@return boolean
hjapi.DzFrameGetEnable = function(frame)
    return hjapi.exec("DzFrameGetEnable", { frame })
end

--- 获取Frame的高度
---@param frame number integer
---@return number floor
hjapi.DzFrameGetHeight = function(frame)
    return hjapi.exec("DzFrameGetHeight", { frame })
end

--- 原生 - 英雄按钮
--- 左侧的英雄头像，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetHeroBarButton = function(buttonId)
    return hjapi.exec("DzFrameGetHeroBarButton", { buttonId })
end

--- 原生 - 英雄血条
--- 左侧的英雄头像下的血条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetHeroHPBar = function(buttonId)
    return hjapi.exec("DzFrameGetHeroHPBar", { buttonId })
end

--- 原生 - 英雄蓝条
--- 左侧的英雄头像下的蓝条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetHeroManaBar = function(buttonId)
    return hjapi.exec("DzFrameGetHeroManaBar", { buttonId })
end

--- 原生 - 物品栏按钮
--- 索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetItemBarButton = function(buttonId)
    return hjapi.exec("DzFrameGetItemBarButton", { buttonId })
end

--- 原生 - 小地图
---@return number integer
hjapi.DzFrameGetMinimap = function()
    return hjapi.exec("DzFrameGetMinimap", nil)
end

--- 原生 - 小地图按钮
--- 小地图右侧竖排按钮，索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetMinimapButton = function(buttonId)
    return hjapi.exec("DzFrameGetMinimapButton", { buttonId })
end

--- 获取 Frame 的名称
---@param frame number integer
---@return string
hjapi.DzFrameGetName = function(frame)
    return hjapi.exec("DzFrameGetName", { frame })
end

--- 获取 Frame 的 Parent
---@param frame number integer
---@return number integer
hjapi.DzFrameGetParent = function(frame)
    return hjapi.exec("DzFrameGetParent", { frame })
end

--- 原生 - 单位大头像
--- 小地图右侧的大头像
---@return number integer
hjapi.DzFrameGetPortrait = function()
    return hjapi.exec("DzFrameGetPortrait", nil)
end

--- 获取 Frame 内的文字
--- 支持EditBox, TextFrame, TextArea, SimpleFontString
---@param frame number integer
---@return string
hjapi.DzFrameGetText = function(frame)
    return hjapi.exec("DzFrameGetText", { frame })
end

--- 获取 Frame 的字数限制
--- 支持EditBox
---@param frame number integer
---@return number integer
hjapi.DzFrameGetTextSizeLimit = function(frame)
    return hjapi.exec("DzFrameGetTextSizeLimit", { frame })
end

--- 原生 - 鼠标提示
--- 鼠标移动到物品或技能按钮上显示的提示窗，初始位于技能栏上方
---@return number integer
hjapi.DzFrameGetTooltip = function()
    return hjapi.exec("DzFrameGetTooltip", nil)
end

--- 原生 - 上方消息框
--- 高维修费用 等消息
---@return number integer
hjapi.DzFrameGetTopMessage = function()
    return hjapi.exec("DzFrameGetTopMessage", nil)
end

--- 原生 - 系统消息框
--- 包含显示消息给玩家 及 显示Debug消息等
---@return number integer
hjapi.DzFrameGetUnitMessage = function()
    return hjapi.exec("DzFrameGetUnitMessage", nil)
end

--- 原生 - 界面按钮
--- 左上的菜单等按钮，索引从0开始
---@param buttonId number integer
---@return number integer
hjapi.DzFrameGetUpperButtonBarButton = function(buttonId)
    return hjapi.exec("DzFrameGetUpperButtonBarButton", { buttonId })
end

--- 获取frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@return number floor
hjapi.DzFrameGetValue = function(frame)
    return hjapi.exec("DzFrameGetValue", { frame })
end

--- 原生 - 隐藏界面元素
--- 不再在地图初始化时调用则会残留小地图和时钟模型
hjapi.DzFrameHideInterface = function()
    return hjapi.exec("DzFrameHideInterface", nil)
end

--- 设置绝对位置
--- 设置 frame 的 Point 锚点 在 (x, y)
---@param frame number integer
---@param point number integer
---@param x number floor(3)
---@param y number floor(3)
hjapi.DzFrameSetAbsolutePoint = function(frame, point, x, y)
    return hjapi.exec("DzFrameSetAbsolutePoint", { frame, point, x, y })
end

--- 移动所有锚点到Frame
--- 移动 frame 的 所有锚点 到 relativeFrame 上
---@param frame number integer
---@param relativeFrame number integer
---@return boolean
hjapi.DzFrameSetAllPoints = function(frame, relativeFrame)
    return hjapi.exec("DzFrameSetAllPoints", { frame, relativeFrame })
end

--- 设置frame的透明度(0-255)
---@param frame number integer
---@param alpha number integer
hjapi.DzFrameSetAlpha = function(frame, alpha)
    return hjapi.exec("DzFrameSetAlpha", { frame, alpha })
end

--- 设置动画
---@param frame number integer
---@param animId number integer 播放序号的动画
---@param autoCast boolean 自动播放
hjapi.DzFrameSetAnimate = function(frame, animId, autoCast)
    return hjapi.exec("DzFrameSetAnimate", { frame, animId, autoCast })
end

--- 设置动画进度
--- 自动播放为false时可用
---@param frame number integer
---@param offset number float(5) 进度
hjapi.DzFrameSetAnimateOffset = function(frame, offset)
    return hjapi.exec("DzFrameSetAnimateOffset", { frame, offset })
end

--- 启用/禁用 frame
---@param frame number integer
---@param enable boolean
hjapi.DzFrameSetEnable = function(frame, enable)
    return hjapi.exec("DzFrameSetEnable", { frame, enable })
end

--- 设置frame获取焦点
---@param frame number integer
---@param enable boolean
---@return boolean
hjapi.DzFrameSetFocus = function(frame, enable)
    return hjapi.exec("DzFrameSetFocus", { frame, enable })
end

--- 设置字体
--- 设置 frame 的字体为 font, 大小 height, flag flag
--- 支持EditBox、SimpleFontString、SimpleMessageFrame以及非SimpleFrame类型的例如TEXT，flag作用未知
---@param frame number integer
---@param fileName string
---@param height number float(5)
---@param flag number integer
hjapi.DzFrameSetFont = function(frame, fileName, height, flag)
    return hjapi.exec("DzFrameSetFont", { frame, fileName, height, flag })
end

--- 设置最大/最小值
--- 设置 frame 的 最小值为 Min 最大值为 Max
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param minValue number float(5)
---@param maxValue number float(5)
hjapi.DzFrameSetMinMaxValue = function(frame, minValue, maxValue)
    return hjapi.exec("DzFrameSetMinMaxValue", { frame, minValue, maxValue })
end

--- 设置模型
--- 设置 frame 的模型文件为 modelFile ModelType:modelType Flag:flag
---@param frame number integer
---@param modelFile string
---@param modelType number integer
---@param flag number integer
hjapi.DzFrameSetModel = function(frame, modelFile, modelType, flag)
    return hjapi.exec("DzFrameSetModel", { frame, modelFile, modelType, flag })
end

--- 设置父窗口
--- 设置 frame 的父窗口为 parent
---@param frame number integer
---@param parent number integer
hjapi.DzFrameSetParent = function(frame, parent)
    return hjapi.exec("DzFrameSetParent", { frame, parent })
end

--- 设置相对位置
--- 设置 frame 的 Point 锚点 (跟随relativeFrame 的 relativePoint 锚点) 偏移(x, y)
---@param frame number integer
---@param point number integer
---@param relativeFrame number integer
---@param relativePoint number integer
---@param x number float(5)
---@param y number float(5)
hjapi.DzFrameSetPoint = function(frame, point, relativeFrame, relativePoint, x, y)
    return hjapi.exec("DzFrameSetPoint", { frame, point, relativeFrame, relativePoint, x, y })
end

--- 设置优先级
--- 设置 frame 优先级:int
---@param frame number integer
---@param priority number integer
hjapi.DzFrameSetPriority = function(frame, priority)
    return hjapi.exec("DzFrameSetPriority", { frame, priority })
end

--- 设置缩放
--- 设置 frame 的缩放 scale
---@param frame number integer
---@param scale number float(5)
hjapi.DzFrameSetScale = function(frame, scale)
    return hjapi.exec("DzFrameSetScale", { frame, scale })
end

--- 注册UI事件回调(func name)
--- 注册 frame 的 eventId 事件 运行:funcName 是否同步:sync
---@param frame number integer
---@param eventId number integer
---@param funcName string
---@param sync boolean
hjapi.DzFrameSetScript = function(frame, eventId, funcName, sync)
    return hjapi.exec("DzFrameSetScript", { frame, eventId, funcName, sync })
end

--- 注册UI事件回调(func handle)
--- 注册 frame 的 eventId 事件 运行:funcHandle 是否同步:sync
--- 运行触发器时需要打开同步
---@param frame number integer
---@param eventId number integer
---@param funcHandle function
---@param sync boolean
hjapi.DzFrameSetScriptByCode = function(frame, eventId, funcHandle, sync)
    return hjapi.exec("DzFrameSetScriptByCode", { frame, eventId, funcHandle, sync })
end

--- 设置frame大小
---@param frame number integer
---@param w number float(5) 宽
---@param h number float(5) 高
hjapi.DzFrameSetSize = function(frame, w, h)
    return hjapi.exec("DzFrameSetSize", { frame, w, h })
end

--- 设置frame步进值
--- 支持Slider
---@param frame number integer
---@param step number float(3) 步进
hjapi.DzFrameSetStepValue = function(frame, step)
    return hjapi.exec("DzFrameSetStepValue", { frame, step })
end

--- 设置frame文本
--- 支持EditBox, TextFrame, TextArea, SimpleFontString、GlueEditBoxWar3、SlashChatBox、TimerTextFrame、TextButtonFrame、GlueTextButton
---@param frame number integer
---@param text string
hjapi.DzFrameSetText = function(frame, text)
    return hjapi.exec("DzFrameSetText", { frame, text })
end

--- 设置frame对齐方式
--- 支持TextFrame、SimpleFontString、SimpleMessageFrame
---@param frame number integer
---@param align number integer ，参考blizzard:^FRAME_ALIGN
hjapi.DzFrameSetTextAlignment = function(frame, align)
    return hjapi.exec("DzFrameSetTextAlignment", { frame, align })
end

---@param frame number integer
---@param color number integer
hjapi.DzFrameSetTextColor = function(frame, color)
    return hjapi.exec("DzFrameSetTextColor", { frame, color })
end

--- 设置frame字数限制
---@param frame number integer
---@param limit number integer
hjapi.DzFrameSetTextSizeLimit = function(frame, limit)
    return hjapi.exec("DzFrameSetTextSizeLimit", { frame, limit })
end

--- 设置frame贴图
--- 支持Backdrop、SimpleStatusBar
---@param frame number integer
---@param texture string 贴图路径
---@param flag number integer 是否平铺
hjapi.DzFrameSetTexture = function(frame, texture, flag)
    return hjapi.exec("DzFrameSetTexture", { frame, texture, flag })
end

--- 设置提示
--- 设置 frame 的提示Frame为 tooltip
--- 设置tooltip
---@param frame number integer
---@param tooltip number integer
hjapi.DzFrameSetTooltip = function(frame, tooltip)
    return hjapi.exec("DzFrameSetTooltip", { frame, tooltip })
end

---@param funcName string
hjapi.DzFrameSetUpdateCallback = function(funcName)
    return hjapi.exec("DzFrameSetUpdateCallback", { funcName })
end

---@param funcHandle function
hjapi.DzFrameSetUpdateCallbackByCode = function(funcHandle)
    return hjapi.exec("DzFrameSetUpdateCallbackByCode", { funcHandle })
end

--- 设置frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param value number float(5)
hjapi.DzFrameSetValue = function(frame, value)
    return hjapi.exec("DzFrameSetValue", { frame, value })
end

--- 设置frame颜色
---@param frame number integer
---@param vertexColor number integer
hjapi.DzFrameSetVertexColor = function(frame, vertexColor)
    return hjapi.exec("DzFrameSetVertexColor", { frame, vertexColor })
end

--- 设置frame显示与否
---@param frame number integer
---@param enable boolean
hjapi.DzFrameShow = function(frame, enable)
    return hjapi.exec("DzFrameShow", { frame, enable })
end

hjapi.DzGetClientHeight = function(...)
    return hjapi.exec("DzGetClientHeight", { ... })
end

hjapi.DzGetClientWidth = function(...)
    return hjapi.exec("DzGetClientWidth", { ... })
end

--- 取 RGBA 色值
--- 返回一个整数，用于设置Frame颜色
---@param r number integer
---@param g number integer
---@param b number integer
---@param a number integer
---@return number integer
hjapi.DzGetColor = function(r, g, b, a)
    return hjapi.exec("DzGetColor", { r, g, b, a })
end

hjapi.DzGetConvertWorldPositionX = function(...)
    return hjapi.exec("DzGetConvertWorldPositionX", { ... })
end

hjapi.DzGetConvertWorldPositionY = function(...)
    return hjapi.exec("DzGetConvertWorldPositionY", { ... })
end

hjapi.DzGetGameMode = function(...)
    return hjapi.exec("DzGetGameMode", { ... })
end

--- 原生 - 游戏UI
--- 一般用作创建自定义UI的父节点
---@return number integer
hjapi.DzGetGameUI = function()
    return hjapi.exec("DzGetGameUI", nil)
end

--- 获取客户端语言
--- 对不同语言客户端返回不同
---@return string
hjapi.DzGetLocale = function()
    return hjapi.exec("DzGetLocale", nil)
end

--- 鼠标所在的Frame控件指针
--- 不是所有类型的Frame都能响应鼠标，能响应的有BUTTON，TEXT等
---@return number integer
hjapi.DzGetMouseFocus = function()
    return hjapi.exec("DzGetMouseFocus", nil)
end

--- 获取鼠标在游戏内的坐标X
---@return number
hjapi.DzGetMouseTerrainX = function()
    return hjapi.exec("DzGetMouseTerrainX", nil)
end

--- 获取鼠标在游戏内的坐标Y
---@return number
hjapi.DzGetMouseTerrainY = function()
    return hjapi.exec("DzGetMouseTerrainY", nil)
end

--- 获取鼠标在游戏内的坐标Z
---@return number
hjapi.DzGetMouseTerrainZ = function()
    return hjapi.exec("DzGetMouseTerrainZ", nil)
end

--- 获取鼠标在屏幕的坐标X
---@return number
hjapi.DzGetMouseX = function()
    return hjapi.exec("DzGetMouseX", nil)
end

--- 获取鼠标游戏窗口坐标X
---@return number integer
hjapi.DzGetMouseXRelative = function()
    return hjapi.exec("DzGetMouseXRelative", nil)
end

--- 获取鼠标在屏幕的坐标Y
---@return number
hjapi.DzGetMouseY = function()
    return hjapi.exec("DzGetMouseY", nil)
end

--- 获取鼠标游戏窗口坐标Y
---@return number integer
hjapi.DzGetMouseYRelative = function()
    return hjapi.exec("DzGetMouseYRelative", nil)
end

hjapi.DzGetPlayerInitGold = function(...)
    return hjapi.exec("DzGetPlayerInitGold", { ... })
end

hjapi.DzGetPlayerName = function(...)
    return hjapi.exec("DzGetPlayerName", { ... })
end

hjapi.DzGetPlayerSelectedHero = function(...)
    return hjapi.exec("DzGetPlayerSelectedHero", { ... })
end

--- 事件响应 - 获取触发的按键
--- 响应 [硬件] - 按键事件
---@return number integer
hjapi.DzGetTriggerKey = function()
    return hjapi.exec("DzGetTriggerKey", nil)
end

--- 事件响应 - 获取触发硬件事件的玩家
--- 响应 [硬件] - 按键事件 滚轮事件 窗口大小变化事件
---@return userdata player
hjapi.DzGetTriggerKeyPlayer = function()
    return hjapi.exec("DzGetTriggerKeyPlayer", nil)
end

--- 事件响应 - 获取同步的数据
--- 响应 [同步] - 同步消息事件
---@return string
hjapi.DzGetTriggerSyncData = function()
    return hjapi.exec("DzGetTriggerSyncData", nil)
end

--- 事件响应 - 获取同步数据的玩家
--- 响应 [同步] - 同步消息事件
---@return userdata player
hjapi.DzGetTriggerSyncPlayer = function()
    return hjapi.exec("DzGetTriggerSyncPlayer", nil)
end

--- 事件响应 - 触发的Frame
---@return number integer
hjapi.DzGetTriggerUIEventFrame = function()
    return hjapi.exec("DzGetTriggerUIEventFrame", nil)
end

--- 事件响应 - 获取触发ui的玩家
---@return userdata player
hjapi.DzGetTriggerUIEventPlayer = function()
    return hjapi.exec("DzGetTriggerUIEventPlayer", nil)
end

--- 获取升级所需经验
--- 获取单位 unit 的 level级 升级所需经验
---@param whichUnit userdata
---@param level number integer
---@return number integer
hjapi.DzGetUnitNeededXP = function(whichUnit, level)
    return hjapi.exec("DzGetUnitNeededXP", { whichUnit, level })
end

--- 获取鼠标指向的单位
---@return userdata unit
hjapi.DzGetUnitUnderMouse = function()
    return hjapi.exec("DzGetUnitUnderMouse", nil)
end

--- 事件响应 - 获取滚轮变化值
--- 响应 [硬件] - 鼠标滚轮事件，正负区分上下
---@return number integer
hjapi.DzGetWheelDelta = function()
    return hjapi.exec("DzGetWheelDelta", nil)
end

--- 获取魔兽窗口高度
---@return number integer
hjapi.DzGetWindowHeight = function()
    return hjapi.exec("DzGetWindowHeight", nil)
end

--- 获取魔兽窗口宽度
---@return number integer
hjapi.DzGetWindowWidth = function()
    return hjapi.exec("DzGetWindowWidth", {})
end

--- 获取魔兽窗口X坐标
---@return number integer
hjapi.DzGetWindowX = function()
    return hjapi.exec("DzGetWindowX", nil)
end

--- 获取魔兽窗口Y坐标
---@return number integer
hjapi.DzGetWindowY = function()
    return hjapi.exec("DzGetWindowY", nil)
end

--- 判断按键是否按下
---@param iKey number integer 参考blizzard:^GAME_KEY
---@return boolean
hjapi.DzIsKeyDown = function(iKey)
    return hjapi.exec("DzIsKeyDown", { iKey })
end

--- 鼠标是否在游戏内
---@return boolean
hjapi.DzIsMouseOverUI = function()
    return hjapi.exec("DzIsMouseOverUI", nil)
end

--- 判断游戏窗口是否处于活动状态
---@return boolean
hjapi.DzIsWindowActive = function()
    return hjapi.exec("DzIsWindowActive", nil)
end

--- 加载Toc文件列表
--- 加载--> file.toc
--- 载入自己的fdf列表文件
---@return boolean
hjapi.DzLoadToc = function(tocFilePath)
    return hjapi.exec("DzLoadToc", { tocFilePath })
end

---@param enable boolean
hjapi.DzOriginalUIAutoResetPoint = function(enable)
    return hjapi.exec("DzOriginalUIAutoResetPoint", { enable })
end

hjapi.DzPlatform_GameStart = function(...)
    return hjapi.exec("DzPlatform_GameStart", { ... })
end

hjapi.DzPlatform_HasGameOver = function(...)
    return hjapi.exec("DzPlatform_HasGameOver", { ... })
end

hjapi.DzPlatform_HasGameOver_Player = function(...)
    return hjapi.exec("DzPlatform_HasGameOver_Player", { ... })
end

--- 原生 - 修改屏幕比例(FOV)
---@param value number float(5)
hjapi.DzSetCustomFovFix = function(value)
    return hjapi.exec("DzSetCustomFovFix", { value })
end

--- 设置内存数值
--- 设置内存数据 address=value
---@param address number integer
---@param value number float(5)
hjapi.DzSetMemory = function(address, value)
    return hjapi.exec("DzSetMemory", { address, value })
end

--- 设置鼠标的坐标
---@param x number integer
---@param y number integer
hjapi.DzSetMousePos = function(x, y)
    return hjapi.exec("DzSetMousePos", { x, y })
end

hjapi.DzSetParams = function(...)
    return hjapi.exec("DzSetParams", { ... })
end

--- 替换单位类型
--- 替换whichUnit的单位类型为:id
--- 不会替换大头像中的模型
---@param whichUnit userdata
---@param id number|string
hjapi.DzSetUnitID = function(whichUnit, id)
    return hjapi.exec("DzSetUnitID", { whichUnit, id })
end

--- 替换单位模型
--- 替换whichUnit的模型:path
--- 不会替换大头像中的模型
---@param whichUnit userdata
---@param model string
hjapi.DzSetUnitModel = function(whichUnit, model)
    return hjapi.exec("DzSetUnitModel", { whichUnit, model })
end

--- 设置单位位置 - 本地调用
---@param whichUnit userdata
---@param x number float(2)
---@param y number float(2)
hjapi.DzSetUnitPosition = function(whichUnit, x, y)
    return hjapi.exec("DzSetUnitPosition", { whichUnit, x, y })
end

--- 替换单位贴图
--- 只能替换模型中有Replaceable ID x 贴图的模型，ID为索引。不会替换大头像中的模型
---@param whichUnit userdata
---@param path string
---@param texId number integer
hjapi.DzSetUnitTexture = function(whichUnit, path, texId)
    return hjapi.exec("DzSetUnitTexture", { whichUnit, path, texId })
end

--- 原生 - 设置小地图背景贴图
---@param blp string
hjapi.DzSetWar3MapMap = function(blp)
    return hjapi.exec("DzSetWar3MapMap", { blp })
end

--- 获取子SimpleFontString
--- ID默认填0，同名时优先获取最后被创建的。SimpleFontString为fdf中的Frame类型
---@param name string
---@param id number integer
hjapi.DzSimpleFontStringFindByName = function(name, id)
    return hjapi.exec("DzSimpleFontStringFindByName", { name, id })
end

--- 获取子SimpleFrame
--- ID默认填0，同名时优先获取最后被创建的。SimpleFrame为fdf中的Frame类型
---@param name string
---@param id number integer
hjapi.DzSimpleFrameFindByName = function(name, id)
    return hjapi.exec("DzSimpleFrameFindByName", { name, id })
end

--- 获取子SimpleTexture
--- ID默认填0，同名时优先获取最后被创建的。SimpleTexture为fdf中的Frame类型
---@param name string
---@param id number integer
hjapi.DzSimpleTextureFindByName = function(name, id)
    return hjapi.exec("DzSimpleTextureFindByName", { name, id })
end

hjapi.DzSyncBuffer = function(...)
    return hjapi.exec("DzSyncBuffer", { ... })
end

--- 同步游戏数据
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
hjapi.DzSyncData = function(prefix, data)
    return hjapi.exec("DzSyncData", { prefix, data })
end

---@param trig userdata
---@param key number integer
---@param status number integer
---@param sync boolean
---@param funcName string
hjapi.DzTriggerRegisterKeyEvent = function(trig, key, status, sync, funcName)
    return hjapi.exec("DzTriggerRegisterKeyEvent", { trig, key, status, sync, funcName })
end

---@param trig userdata
---@param key number integer
---@param status number integer
---@param sync boolean
---@param funcHandle function
hjapi.DzTriggerRegisterKeyEventByCode = function(trig, key, status, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterKeyEventByCode", { trig, key, status, sync, funcHandle })
end

---@param trig userdata
---@param btn number integer
---@param status number integer
---@param sync boolean
---@param funcName string
hjapi.DzTriggerRegisterMouseEvent = function(trig, btn, status, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseEvent", { trig, btn, status, sync, funcName })
end

---@param trig userdata
---@param btn number integer
---@param status number integer
---@param sync boolean
---@param funcHandle function
hjapi.DzTriggerRegisterMouseEventByCode = function(trig, btn, status, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseEventByCode", { trig, btn, status, sync, funcHandle })
end

---@param trig userdata
---@param sync boolean
---@param funcName string
hjapi.DzTriggerRegisterMouseMoveEvent = function(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseMoveEvent", { trig, sync, funcName })
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
hjapi.DzTriggerRegisterMouseMoveEventByCode = function(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseMoveEventByCode", { trig, sync, funcHandle })
end

---@param trig userdata
---@param sync boolean
---@param funcName string
hjapi.DzTriggerRegisterMouseWheelEvent = function(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseWheelEvent", { trig, sync, funcName })
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
hjapi.DzTriggerRegisterMouseWheelEventByCode = function(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseWheelEventByCode", { trig, sync, funcHandle })
end

--- 数据同步
--- 标签为 prefix 的数据被同步 | 来自平台:server
--- 来自平台的参数填false
---@param trig userdata
---@param prefix string
---@param server boolean
hjapi.DzTriggerRegisterSyncData = function(trig, prefix, server)
    return hjapi.exec("DzTriggerRegisterSyncData", { trig, prefix, server })
end

---@param trig userdata
---@param sync boolean
---@param funcName string
hjapi.DzTriggerRegisterWindowResizeEvent = function(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterWindowResizeEvent", { trig, sync, funcName })
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
hjapi.DzTriggerRegisterWindowResizeEventByCode = function(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterWindowResizeEventByCode", { trig, sync, funcHandle })
end

hjapi.DzUnitDisableAttack = function(...)
    return hjapi.exec("DzUnitDisableAttack", { ... })
end

hjapi.DzUnitDisableInventory = function(...)
    return hjapi.exec("DzUnitDisableInventory", { ... })
end

hjapi.DzUnitLearningSkill = function(...)
    return hjapi.exec("DzUnitLearningSkill", { ... })
end

hjapi.DzUnitSilence = function(...)
    return hjapi.exec("DzUnitSilence", { ... })
end

hjapi.EXBlendButtonIcon = function(...)
    return hjapi.exec("EXBlendButtonIcon", { ... })
end

hjapi.EXDclareButtonIcon = function(...)
    return hjapi.exec("EXDclareButtonIcon", { ... })
end

hjapi.EXDisplayChat = function(...)
    return hjapi.exec("EXDisplayChat", { ... })
end

--- 重置特效变换
--- 重置 effect
--- 清空所有的旋转和缩放，重置为初始状态
---@param effect userdata
hjapi.EXEffectMatReset = function(effect)
    return hjapi.exec("EXEffectMatReset", { effect })
end

--- 特效绕X轴旋转
--- effect 绕X轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
hjapi.EXEffectMatRotateX = function(effect, angle)
    return hjapi.exec("EXEffectMatRotateX", { effect, angle })
end

--- 特效绕Y轴旋转
--- effect 绕Y轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
hjapi.EXEffectMatRotateY = function(effect, angle)
    return hjapi.exec("EXEffectMatRotateY", { effect, angle })
end

--- 特效绕Z轴旋转
--- effect 绕Z轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
hjapi.EXEffectMatRotateZ = function(effect, angle)
    return hjapi.exec("EXEffectMatRotateZ", { effect, angle })
end

--- 缩放特效
--- 设置 effect 的X轴缩放，Y轴缩放，Z轴缩放
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态。设置为2,2,2时相当于大小变为2倍。设置为负数时，就是镜像翻转
---@param effect userdata
---@param x number float(5)
---@param y number float(5)
---@param z number float(5)
hjapi.EXEffectMatScale = function(effect, x, y, z)
    return hjapi.exec("EXEffectMatScale", { effect, x, y, z })
end

---@param script string
hjapi.EXExecuteScript = function(script)
    return hjapi.exec("EXExecuteScript", { script })
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return number integer
hjapi.EXGetAbilityDataInteger = function(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataInteger", { abil, level, dataType })
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return number float
hjapi.EXGetAbilityDataReal = function(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataReal", { abil, level, dataType })
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return string
hjapi.EXGetAbilityDataString = function(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataString", { abil, level, dataType })
end

---@param abil userdata ability
---@return number integer
hjapi.EXGetAbilityId = function(abil)
    return hjapi.exec("EXGetAbilityId", { abil })
end

---@param abil userdata ability
---@param stateType number integer
---@return number float
hjapi.EXGetAbilityState = function(abil, stateType)
    return hjapi.exec("EXGetAbilityState", { abil, stateType })
end

hjapi.EXGetAbilityString = function(...)
    return hjapi.exec("EXGetAbilityString", { ... })
end

---@param buffCode number integer
---@param dataType number integer
---@return string
hjapi.EXGetBuffDataString = function(buffCode, dataType)
    return hjapi.exec("EXGetBuffDataString", { buffCode, dataType })
end

--- 获取特效大小
---@param effect userdata
---@return number float
hjapi.EXGetEffectSize = function(effect)
    return hjapi.exec("EXGetEffectSize", { effect })
end

--- 获取特效X轴坐标
---@param effect userdata
---@return number float
hjapi.EXGetEffectX = function(effect)
    return hjapi.exec("EXGetEffectX", { effect })
end

--- 获取特效Y轴坐标
---@param effect userdata
---@return number float
hjapi.EXGetEffectY = function(effect)
    return hjapi.exec("EXGetEffectY", { effect })
end

--- 获取特效Z轴坐标
---@param effect userdata
---@return number float
hjapi.EXGetEffectZ = function(effect)
    return hjapi.exec("EXGetEffectZ", { effect })
end

---@param eddType number integer
---@return number integer
hjapi.EXGetEventDamageData = function(eddType)
    return hjapi.exec("EXGetEventDamageData", { eddType })
end

--- 是物理伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
hjapi.isEventPhysicalDamage = function()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end

--- 是攻击伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
hjapi.isEventAttackDamage = function()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end

--- 是远程伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
hjapi.isEventRangedDamage = function()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end

--- 单位所受伤害的伤害类型是 damageType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param damageType userdata 参考 blizzard:^DAMAGE_TYPE
---@return boolean
hjapi.isEventDamageType = function(damageType)
    return damageType == cj.ConvertDamageType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end

--- 单位所受伤害的武器类型是 是 weaponType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param weaponType userdata 参考 blizzard:^WEAPON_TYPE
---@return boolean
hjapi.isEventWeaponType = function(weaponType)
    return weaponType == cj.ConvertWeaponType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end

--- 单位所受伤害的攻击类型是 是 attackType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param attackType userdata 参考 blizzard:^ATTACK_TYPE
---@return boolean
hjapi.isEventAttackType = function(attackType)
    return attackType == cj.ConvertAttackType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end

---@param itemCode number integer
---@param dataType number integer
---@return string
hjapi.EXGetItemDataString = function(itemCode, dataType)
    return hjapi.exec("EXGetItemDataString", { itemCode, dataType })
end

---@param whichUnit userdata
---@param abilityID number string|integer
hjapi.EXGetUnitAbility = function(whichUnit, abilityID)
    return hjapi.exec('EXGetUnitAbility', { whichUnit, abilityID })
end

---@param whichUnit userdata
---@param index number integer
hjapi.EXGetUnitAbilityByIndex = function(whichUnit, index)
    return hjapi.exec('EXGetUnitAbilityByIndex', { whichUnit, index })
end

hjapi.EXGetUnitArrayString = function(...)
    return hjapi.exec("EXGetUnitArrayString", { ... })
end

hjapi.EXGetUnitInteger = function(...)
    return hjapi.exec("EXGetUnitInteger", { ... })
end

hjapi.EXGetUnitReal = function(...)
    return hjapi.exec("EXGetUnitReal", { ... })
end

hjapi.EXGetUnitString = function(...)
    return hjapi.exec("EXGetUnitString", { ... })
end

---@param whichUnit userdata
---@param enable boolean
hjapi.EXPauseUnit = function(whichUnit, enable)
    return hjapi.exec("EXPauseUnit", { whichUnit, enable })
end

--- 单位添加晕眩
---@param whichUnit userdata
hjapi.UnitAddSwim = function(whichUnit)
    return hjapi.EXPauseUnit(whichUnit, true)
end

--- 单位移除晕眩
--- 别用来移风暴之锤之类的晕眩。因为它只会移除晕眩并不会移除晕眩的buff
---@param whichUnit userdata
hjapi.UnitRemoveSwim = function(whichUnit)
    return hjapi.EXPauseUnit(whichUnit, false)
end

hjapi.EXSetAbilityAEmeDataA = function(...)
    return hjapi.exec("EXSetAbilityAEmeDataA", { ... })
end

hjapi.EXSetAbilityDataInteger = function(...)
    return hjapi.exec("EXSetAbilityDataInteger", { ... })
end

hjapi.EXSetAbilityDataReal = function(...)
    return hjapi.exec("EXSetAbilityDataReal", { ... })
end

hjapi.EXSetAbilityDataString = function(...)
    return hjapi.exec("EXSetAbilityDataString", { ... })
end

---@param ability userdata
---@param stateType number integer
---@param value number floor(3)
hjapi.EXSetAbilityState = function(ability, stateType, value)
    return hjapi.exec('EXSetAbilityState', { ability, stateType, value })
end

hjapi.EXSetAbilityString = function(...)
    return hjapi.exec("EXSetAbilityString", { ... })
end

---@param buffCode number integer
---@param dataType number integer
---@param value string
hjapi.EXSetBuffDataString = function(buffCode, dataType, value)
    return hjapi.exec("EXSetBuffDataString", { buffCode, dataType, value })
end

--- 设置特效大小
---@param e userdata
---@param size number float(3)
hjapi.EXSetEffectSize = function(e, size)
    return hjapi.exec("EXSetEffectSize", { e, size })
end

--- 设置特效动画速度
---@param e userdata
---@param speed number float(3)
hjapi.EXSetEffectSpeed = function(e, speed)
    return hjapi.exec("EXSetEffectSpeed", { e, speed })
end

--- 移动特效到坐标
---@param e userdata
---@param x number float(3)
---@param y number float(3)
hjapi.EXSetEffectXY = function(e, x, y)
    return hjapi.exec("EXSetEffectXY", { e, x, y })
end

---设置特效高度
---@param e userdata
---@param z number float(3)
hjapi.EXSetEffectZ = function(e, z)
    return hjapi.exec("EXSetEffectZ", { e, z })
end

---@param amount number float(3)
---@return boolean
hjapi.EXSetEventDamage = function(amount)
    return hjapi.exec("EXSetEventDamage", { amount })
end

---@param itemCode number integer
---@param dataType number integer
---@param value string
---@return boolean
hjapi.EXSetItemDataString = function(itemCode, dataType, value)
    return hjapi.exec("EXSetItemDataString", { itemCode, dataType, value })
end

hjapi.EXSetUnitArrayString = function(...)
    return hjapi.exec("EXSetUnitArrayString", { ... })
end

--- 设置单位的碰撞类型
--- 启用/禁用 单位u 对 t 的碰撞
---@param enable boolean
---@param u userdata
---@param t number integer 碰撞类型，参考blizzard:^COLLISION_TYPE
hjapi.EXSetUnitCollisionType = function(enable, u, t)
    return hjapi.exec("EXSetUnitCollisionType", { enable, u, t })
end

--- 设置单位面向角度
--- 立即转身
---@param u userdata
---@param angle number float(2)
hjapi.EXSetUnitFacing = function(u, angle)
    return hjapi.exec("EXSetUnitFacing", { u, angle })
end

hjapi.EXSetUnitInteger = function(...)
    return hjapi.exec("EXSetUnitInteger", { ... })
end

--- 设置单位的移动类型
---@param u userdata
---@param t number integer 移动类型，参考blizzard:^MOVE_TYPE
hjapi.EXSetUnitMoveType = function(u, t)
    return hjapi.exec("EXSetUnitMoveType", { u, t })
end

hjapi.EXSetUnitReal = function(...)
    return hjapi.exec("EXSetUnitReal", { ... })
end

hjapi.EXSetUnitString = function(...)
    return hjapi.exec("EXSetUnitString", { ... })
end

--- 伤害值
---@return number
hjapi.GetEventDamage = function()
    return hjapi.exec("GetEventDamage", nil)
end

---@param whichUnit userdata
---@param state userdata unitstate
---@return number
hjapi.GetUnitState = function(whichUnit, state)
    return hjapi.exec('GetUnitState', { whichUnit, state })
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return boolean
hjapi.RequestExtraBooleanData = function(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraBooleanData", { dataType, whichPlayer, param1, param2, param3, param4, param5, param6 })
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number integer
hjapi.RequestExtraIntegerData = function(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraIntegerData", { dataType, whichPlayer, param1, param2, param3, param4, param5, param6 })
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number
hjapi.RequestExtraRealData = function(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraRealData", { dataType, whichPlayer, param1, param2, param3, param4, param5, param6 })
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return string
hjapi.RequestExtraStringData = function(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraStringData", { dataType, whichPlayer, param1, param2, param3, param4, param5, param6 })
end

--- 设置单位属性
---@param whichUnit userdata
---@param state userdata unitstate
---@param value number
hjapi.SetUnitState = function(whichUnit, state, value)
    hjapi.exec('SetUnitState', { whichUnit, state, value })
end