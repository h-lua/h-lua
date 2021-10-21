---@param params nil|any[]
---@return Array
function Array(params)

    ---@class Array
    local this = {
        ---@private
        __NAME__ = "Array",
        ---@private
        __PROPERTIES__ = {
            keys = {},
            values = {},
        }
    }

    if (type(params) == "table") then
        if (instanceof(params, "Array")) then
            params.forEach(function(k, v)
                table.insert(this.__PROPERTIES__.keys, k)
                this.__PROPERTIES__.values[k] = v
            end)
        elseif (#params > 0) then
            for k, v in ipairs(params) do
                table.insert(this.__PROPERTIES__.keys, k)
                this.__PROPERTIES__.values[k] = v
            end
        end
    end

    --- 返回数组中元素的数目
    ---@return number integer
    this.count = function()
        return #this.__PROPERTIES__.keys
    end

    --- 返回数组中key索引的顺序；没有该key则返回-1
    this.index = function(key)
        local idx = -1
        for ki, k in ipairs(this.__PROPERTIES__.keys) do
            if (k == key) then
                idx = ki
                break
            end
        end
        return idx
    end

    --- 强行设置数组元素
    this.set = function(key, value)
        if (this.__PROPERTIES__.values[key] == nil) then
            table.insert(this.__PROPERTIES__.keys, key)
        end
        this.__PROPERTIES__.values[key] = value
    end

    --- 根据key获取数组value
    this.get = function(key)
        return this.__PROPERTIES__.values[key]
    end

    --- 返回数组中所有的键名
    this.keys = function()
        return this.__PROPERTIES__.keys
    end

    --- 返回数组中所有的值
    this.values = function()
        local values = {}
        for _, key in ipairs(this.__PROPERTIES__.keys) do
            table.insert(values, this.__PROPERTIES__.values[key])
        end
        return values
    end

    --- 检查指定的键名是否存在于数组中
    this.keyExists = function(key)
        return key ~= nil and table.includes(this.keys(), key)
    end

    --- 检查指定的值是否存在于数组中
    this.valueExists = function(value)
        return value ~= nil and table.includes(this.values(), value)
    end

    --- 遍历
    ---@alias noteArrayEach fun(key: "key", value: "value"):void
    ---@param action noteArrayEach | "function(key,value) end"
    this.forEach = function(action)
        if (type(action) == "function") then
            local keys = table.clone(this.__PROPERTIES__.keys)
            for _, key in ipairs(keys) do
                if (this.__PROPERTIES__.values[key] ~= nil) then
                    if (false == action(key, this.__PROPERTIES__.values[key])) then
                        break
                    end
                end
            end
            keys = nil
        end
    end

    --- 反向遍历
    ---@param action noteArrayEach | "function(key,value) end"
    this.backEach = function(action)
        if (type(action) == "function") then
            local keys = {}
            for i = #this.__PROPERTIES__.keys, 1, -1 do
                table.insert(keys, this.__PROPERTIES__.keys[i])
            end
            for _, key in ipairs(keys) do
                if (this.__PROPERTIES__.values[key] ~= nil) then
                    if (false == action(key, this.__PROPERTIES__.values[key])) then
                        break
                    end
                end
            end
            keys = nil
        end
    end

    --- 将一个元素插入数组的末尾（入栈）
    this.push = function(value, key)
        key = key or ("Ar:" .. (htime.inc or 0) .. string.random(5))
        if (this.__PROPERTIES__.values[key] == nil) then
            table.insert(this.__PROPERTIES__.keys, key)
        end
        this.__PROPERTIES__.values[key] = value
    end

    --- 删除数组的最后一个元素（出栈）
    this.pop = function()
        local value
        local last = this.count()
        if (last > 0) then
            local key = this.__PROPERTIES__.keys[last]
            value = this.__PROPERTIES__.values[key]
            this.__PROPERTIES__.values[key] = nil
            table.remove(this.__PROPERTIES__.keys, last)
        end
        return value
    end

    --- 删除数组中首个元素，并返回被删除元素的值
    this.shift = function()
        local value
        if (this.__PROPERTIES__.keys[1]) then
            local key = this.__PROPERTIES__.keys[1]
            value = this.__PROPERTIES__.values[key]
            this.__PROPERTIES__.values[key] = nil
            table.remove(this.__PROPERTIES__.keys, 1)
        end
        return value
    end

    --- 在数组开头插入一个元素
    this.unshift = function(value, key)
        local count = this.count()
        if (count <= 0) then
            this.push(value, key)
        else
            for i, k in ipairs(this.__PROPERTIES__.keys) do
                this.__PROPERTIES__.keys[i + 1] = k
            end
            key = key or ("Ar:" .. (htime.inc or 0) .. string.random(5))
            this.__PROPERTIES__.keys[1] = key
            this.__PROPERTIES__.values[key] = value
        end
    end

    --- 从数组中移除key索引的元素，并用新元素value取代它；没有value可替换则为删除
    this.splice = function(key, value)
        if (key == nil or not this.keyExists(key)) then
            return
        end
        if (value ~= nil) then
            this.__PROPERTIES__.values[key] = value
        else
            this.__PROPERTIES__.values[key] = nil
            table.remove(this.__PROPERTIES__.keys, this.index(key))
        end
        return this.__PROPERTIES__.values
    end

    --- 克隆一个副本
    ---@return Array
    this.clone = function()
        local copy = Array()
        this.forEach(function(key, value)
            if (instanceof(value, "Array")) then
                copy.push(value.clone(), key)
            else
                copy.push(value, key)
            end
        end)
        return copy
    end

    --- 合并另一个array
    ---@param arr Array
    this.merge = function(arr)
        if (instanceof(arr, "Array")) then
            arr.forEach(function(key, value)
                if (instanceof(value, "Array")) then
                    if (type(key) == "number") then
                        this.push(this.clone(value))
                    else
                        this.push(this.clone(value), key)
                    end
                else
                    if (type(key) == "number") then
                        this.push(value)
                    else
                        if (this.keyExists(key)) then
                            this.__PROPERTIES__.values[key] = value
                        else
                            this.push(value, key)
                        end
                    end
                end
            end)
        end
        return this
    end

    --- 键排序
    ---@param
    ---@return Array
    this.sort = function()
        local ks = table.clone(this.__PROPERTIES__.keys)
        table.sort(ks)
        local kArr = Array()
        for _, k in ipairs(ks) do
            kArr.set(k, this.__PROPERTIES__.values[k])
        end
        return kArr
    end

    return this
end
