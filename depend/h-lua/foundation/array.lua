---@return boolean
function isArray(this)
    if (type(this) ~= "table") then
        return false
    end
    return this._t == "Array"
end

---@return Array
function Array()

    ---@class Array
    local this = {
        ---@private
        _t = "Array",
        ---@private
        _d = {
            key = {},
            k2v = {},
        }
    }

    --- 返回数组中元素的数目
    ---@return number integer
    this.count = function()
        return #(this._d.key)
    end

    --- 返回数组中key索引的顺序；没有该key则返回-1
    this.index = function(key)
        local idx = -1
        for ki, k in ipairs(this._d.key) do
            if (k == key) then
                idx = ki
                break
            end
        end
        return idx
    end

    --- 强行设置数组元素
    this.set = function(key, val)
        if (type(key) == "number") then
            key = tostring(key)
        end
        if (type(key) ~= "string") then
            return
        end
        if (val == nil) then
            local i = this.index(key)
            if (i ~= -1) then
                table.remove(this._d.key, i)
            end
        else
            if (this._d.k2v[key] == nil) then
                this._d.key[#this._d.key + 1] = key
            end
        end
        this._d.k2v[key] = val
    end

    --- 根据key获取数组value
    this.get = function(key)
        if (type(key) == "number") then
            key = tostring(key)
        end
        if (type(key) ~= "string") then
            return
        end
        return this._d.k2v[key]
    end

    --- 返回数组中所有的键名
    this.keys = function()
        return this._d.key
    end

    --- 返回数组中所有的值
    this.values = function()
        local values = {}
        for _, key in ipairs(this._d.key) do
            values[#values + 1] = this._d.k2v[key]
        end
        return values
    end

    --- 检查指定的键名是否存在于数组中
    this.keyExists = function(key)
        return key ~= nil and this._d.k2v[key] ~= nil
    end

    --- 遍历
    ---@alias noteArrayEach fun(key:"string",value:"string")
    ---@param callFunc noteArrayEach
    ---@param safety boolean
    this.forEach = function(callFunc, safety)
        if (type(callFunc) == "function") then
            local keys
            if safety == true then
                keys = table.clone(this._d.key)
            else
                keys = this._d.key
            end
            local i = 1
            while i <= #keys do
                local key = keys[i]
                local val = this._d.k2v[key]
                if val == nil then
                    table.remove(this._d.key, i)
                    this._d.k2v[key] = nil
                else
                    if (false == callFunc(key, val)) then
                        break
                    end
                    i = i + 1
                end
            end
        end
    end

    --- 反向遍历
    ---@param callFunc noteArrayEach
    ---@param safety boolean
    this.backEach = function(callFunc)
        if (type(callFunc) == "function") then
            local keys
            if safety == true then
                keys = table.clone(this._d.key)
            else
                keys = this._d.key
            end
            local i = #keys
            while i >= 1 do
                local key = keys[i]
                local val = this._d.k2v[key]
                if val == nil then
                    table.remove(this._d.key, i)
                    this._d.k2v[key] = nil
                else
                    if (false == callFunc(key, val)) then
                        break
                    end
                end
                i = i - 1
            end
        end
    end

    --- 克隆一个副本
    ---@return Array
    this.clone = function()
        local copy = Array()
        this.forEach(function(key, val)
            if (isArray(val)) then
                copy.set(key, val.clone())
            else
                copy.set(key, val)
            end
        end)
        return copy
    end

    --- 合并另一个 Array
    ---@vararg Array
    this.merge = function(...)
        for _, arr in ipairs(...) do
            if (isArray(arr)) then
                arr.forEach(function(key, val)
                    if (isArray(val)) then
                        this.set(key, this.clone())
                    else
                        this.set(key, val)
                    end
                end)
            end
        end
    end

    --- 键排序
    ---@return Array
    this.sort = function()
        local sa = this.clone()
        table.sort(sa._d.key)
        return sa
    end

    return this
end