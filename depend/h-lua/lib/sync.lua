hsyncCache = {
    syncIdx = 0,
    callback = {},
}
hsync = {}

---@private
function hsync.key()
    hsyncCache.syncIdx = hsyncCache.syncIdx + 1
    return "syk" .. hsyncCache.syncIdx
end

---@private
function hsync.mix(key, array)
    array = array or {}
    if (type(array) ~= "table") then
        array = {}
    end
    local data = table.merge({ key }, array)
    return string.implode("|", data)
end

---@private
function hsync.call(key, callback, array)
    hsyncCache.callback[key] = callback
    return hsync.mix(key, array)
end

---@private
function hsync.init()
    local trig = cj.CreateTrigger()
    hjapi.DzTriggerRegisterSyncData(trig, "hsync", false)
    cj.TriggerAddAction(trig, function()
        local syncData = hjapi.DzGetTriggerSyncData()
        syncData = string.explode("|", syncData)
        local key = syncData[1]
        if (type(hsyncCache.callback[key]) ~= "function") then
            return
        end
        table.remove(syncData, 1)
        local callbackData = {
            triggerPlayer = hjapi.DzGetTriggerSyncPlayer(),
            triggerKey = key,
            triggerData = syncData,
        }
        hsyncCache.callback[key](callbackData)
    end)
end

--- 发送执行一般消息同步操作
--- 与onSend配套，hsync.onSend 接数据
---@param key string 自定义回调key
---@param array table<string> 支持string、number
function hsync.send(key, array)
    if (key == nil) then
        return
    end
    hjapi.DzSyncData("hsync", hsync.mix(key, array))
end

--- [事件]注册一般消息同步操作
--- 与send配套，接 hsync.send
---@alias noteSyncData {triggerPlayer:"触发玩家",triggerKey:"触发索引",triggerData:"数组数据"}
---@param key string 自定义回调key
---@param callback fun(syncData:noteSyncData}) 同步响应回调
function hsync.onSend(key, callback)
    key = key or hsync.key()
    hsync.call(key, callback)
end