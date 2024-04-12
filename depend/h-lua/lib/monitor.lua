--- 监听器是一种工具，用于管理周期性操作
---@class hmonitor 监听器
hmonitor = {
    ---@type table<string,{arr:Array,timer:table}}>
    _monitors = {}
}

--- 创建一个监听器
---@param key string 唯一key
---@param frequency number 周期间隔，每个周期会把受监听对象回调
---@param action fun(object:any) 监听操作
---@param ignoreFilter nil|fun(object:any) 移除监听对象的适配条件
function hmonitor.create(key, frequency, action, ignoreFilter)
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
    local timer = htime.setInterval(frequency, function()
        arr.forEach(function(k, o)
            if (ignoreFilter == nil or ignoreFilter(o) ~= true) then
                action(o)
            else
                arr.set(k, nil)
            end
        end)
    end)
    hmonitor._monitors[key] = { arr = arr, timer = timer }
end

--- 毁灭一个监听器
---@param key string 唯一key
function hmonitor.destroy(key)
    if (hmonitor._monitors[key] ~= nil) then
        hmonitor._monitors[key].timer.destroy()
        hmonitor._monitors[key] = nil
    end
end

--- 检查一个对象是否正在受到监听
---@param key string 唯一key
---@param obj any 监听对象
---@return boolean
function hmonitor.isListening(key, obj)
    if (hmonitor._monitors[key] ~= nil) then
        return hmonitor._monitors[key].arr.keyExists(tostring(obj))
    end
    return false
end

--- 监听对象
---@param key string 唯一key
---@param obj any 监听对象
function hmonitor.listen(key, obj)
    local monitor = hmonitor._monitors[key]
    if (monitor ~= nil) then
        monitor.arr.set(tostring(obj), obj)
    end
end

--- 忽略对象
--- 由于监听器的特殊性和长效性
--- 不建议手动忽略，推荐在 create 时严谨地编写 ignoreFilter 中返回true从而自动忽略
---@protected
---@param key string 唯一key
---@param obj any 监听对象
function hmonitor.ignore(key, obj)
    local monitor = hmonitor._monitors[key]
    if (monitor ~= nil) then
        monitor.arr.set(tostring(obj), nil)
    end
end