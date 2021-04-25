hsyncCache = {
    syncIdx = 0,
    callback = {},
}
hsync = {}

---@private
hsync.key = function()
    hsyncCache.syncIdx = hsyncCache.syncIdx + 1
    return "syk" .. hsyncCache.syncIdx
end

---@private
hsync.mix = function(key, array)
    local data = table.merge({ key }, (array or {}))
    return string.implode("|", data)
end

---@private
hsync.call = function(key, callback, array)
    hsyncCache.callback[key] = callback
    return hsync.mix(key, array)
end

---@private
hsync.init = function()
    local trig = cj.CreateTrigger()
    hjapi.DzTriggerRegisterSyncData(trig, "hsync", false)
    cj.TriggerAddAction(trig, function()
        local syncData = hjapi.DzGetTriggerSyncData()
        syncData = string.explode("|", syncData)
        local key = syncData[1]
        if (type(hsyncCache.callback[key]) ~= "function") then
            return
        end
        local callbackData = {
            triggerPlayer = hjapi.DzGetTriggerSyncPlayer(),
            triggerKey = key,
            triggerData = syncData,
        }
        hsyncCache.callback[key](callbackData)
    end)
end

--- 发送执行一般消息同步操作
---@param key string 自定义回调key
---@param array table<string> 支持string、number
hsync.send = function(key, array)
    if (key == nil) then
        return
    end
    hjapi.HSync(hsync.mix(key, array))
end

--- [事件]注册一般消息同步操作，接 hsync.send
---@alias onHSync fun(syncData: {triggerPlayer:"触发玩家",triggerKey:"触发索引",triggerData:"数组数据"}):void
---@param key string 自定义回调key
---@param callback onHSync | "function(syncData) end" 同步响应回调
hsync.onSend = function(key, callback)
    key = key or hsync.key()
    hsync.call(key, callback)
end

--- [事件]注册frame鼠标操作
---@alias onFrameMouseSync fun(syncData: {triggerPlayer:"触发玩家",syncPlayer:"同步的玩家",triggerKey:"触发索引",triggerFrameId:"触发Frame",triggerMouseOrder:"触发鼠标事件ID"}):void
---@param frameId number
---@param mouseOrder number integer 参考blizzard:^MOUSE_ORDER
---@param callback onFrameMouseSync | "function(syncData) end" 同步响应回调
hsync.onFrameMouse = function(frameId, mouseOrder, callback)
    if (mouseOrder == nil and type(callback) ~= "function") then
        return
    end
    local callback2 = function(callbackData)
        local newData = {}
        newData.syncPlayer = callbackData.triggerPlayer
        newData.triggerKey = callbackData.triggerKey
        newData.triggerFrameId = math.floor(callbackData.triggerData[2])
        newData.triggerMouseOrder = math.floor(callbackData.triggerData[3])
        newData.triggerPlayer = cj.Player(math.floor(callbackData.triggerData[4]))
        callback(newData)
    end
    hjapi.HFrameSetScript(frameId, mouseOrder, hsync.call(hsync.key(), callback2, { frameId, mouseOrder }))
end