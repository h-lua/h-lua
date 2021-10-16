--- 监听器是一种工具，用于管理周期性操作
---@class hmonitor 监听器
hmonitor = {
    ---@type table<string,{arr:Array,timer:table}}>
    _monitors = {}
}

--- 创建一个监听器
---@alias monAction fun(object: any):void
---@alias monRemoveFilter fun(object: any):boolean
---@param key string 唯一key
---@param frequency number 周期间隔，每个周期会把受监听对象回调
---@param action monAction | "function(object) end" 监听操作
---@param ignoreFilter nil|monRemoveFilter | "function(object) end" 移除监听对象的适配条件
hmonitor.create = function(key, frequency, action, ignoreFilter)
    if (type(key) ~= "string" or type(frequency) ~= "number" or type(action) ~= "function") then
        return
    end
    if (ignoreFilter ~= nil and type(ignoreFilter) ~= "function") then
        return
    end
    if (hmonitor._monitors[key] ~= nil) then
        return
    end
    local arr = Array()
    local timer = htime.setInterval(frequency, function(_)
        arr.forEach(function(o, _)
            if (ignoreFilter == nil or ignoreFilter(o) ~= true) then
                action(o)
            else
                arr.splice(o)
            end
        end)
    end)
    hmonitor._monitors[key] = { arr = arr, timer = timer }
end

--- 毁灭一个监听器
---@param key string 唯一key
hmonitor.destroy = function(key)
    if (hmonitor._monitors[key] ~= nil) then
        htime.delTimer(hmonitor._monitors[key].timer)
        hmonitor._monitors[key] = nil
    end
end

--- 检查一个对象是否正在受到监听
---@param key string 唯一key
---@param obj any 监听对象
---@return boolean
hmonitor.isListening = function(key, obj)
    if (hmonitor._monitors[key] ~= nil) then
        return hmonitor._monitors[key].arr.keyExists(obj)
    end
    return false
end

--- 监听对象
---@param key string 唯一key
---@param obj any 监听对象
hmonitor.listen = function(key, obj)
    local monitor = hmonitor._monitors[key]
    if (monitor ~= nil) then
        monitor.arr.set(obj, 1)
    end
end

--- 忽略对象
--- 由于监听器的特殊性和长效性
--- 不建议手动忽略，推荐在 create 时严谨地编写 ignoreFilter 中返回true从而自动忽略
---@protected
---@param key string 唯一key
---@param obj any 监听对象
hmonitor.ignore = function(key, obj)
    local monitor = hmonitor._monitors[key]
    if (monitor ~= nil) then
        monitor.arr.splice(obj)
    end
end