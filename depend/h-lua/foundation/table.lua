-- 不支持默认pairs

--- 生成整数段
---@param n1 number integer
---@param n2 number integer
---@return table
function table.section(n1, n2)
    n1 = math.floor(n1)
    n2 = math.floor(n2 or n1)
    local s = {}
    if (n1 == n2) then
        n2 = nil
    end
    if (n2 == nil) then
        for i = 1, n1 do
            table.insert(s, i)
        end
    else
        if (n1 < n2) then
            for i = n1, n2, 1 do
                table.insert(s, i)
            end
        else
            for i = n1, n2, -1 do
                table.insert(s, i)
            end
        end
    end
    return s
end

--- 随机在数组内取N个
--- 如果 n == 1, 则返回某值
--- 如果 n > 1, 则返回table
---@param arr table
---@return nil|any|any[]
function table.random(arr, n)
    if (type(arr) ~= "table") then
        return
    end
    n = n or 1
    if (n < 1) then
        return
    end
    if (n == 1) then
        return arr[math.random(1, #arr)]
    end
    local res = {}
    local l = #arr
    while (#res < n) do
        local rge = {}
        for i = 1, l do
            rge[i] = arr[i]
        end
        for i = 1, l do
            local j = math.random(i, #rge)
            table.insert(res, rge[j])
            if (#res >= n) then
                break
            end
            rge[i], rge[j] = rge[j], rge[i]
        end
    end
    return res
end

--- 洗牌
---@param arr table
---@return table
function table.shuffle(arr)
    local shuffle = table.clone(arr)
    local length = #shuffle
    local temp
    local random
    while (length > 1) do
        random = math.random(1, length)
        temp = shuffle[length]
        shuffle[length] = shuffle[random]
        shuffle[random] = temp
        length = length - 1
    end
    return shuffle
end

--- 倒序
---@param arr table
---@return table
function table.reverse(arr)
    local r = {}
    for i = #arr, 1, -1 do
        if (type(arr[i]) == "table") then
            table.insert(r, table.reverse(arr[i]))
        else
            table.insert(r, arr[i])
        end
    end
    return r
end

--- 重复table
---@param params any
---@param qty number integer
---@return table
function table.repeater(params, qty)
    qty = math.floor(qty or 1)
    local r = {}
    for _ = 1, qty do
        table.insert(r, params)
    end
    return r
end

--- 克隆table
---@param org table
---@return table
function table.clone(org)
    local function _cp(org1, res)
        local max = #org1
        for k = 1, max, 1 do
            if type(org1[k]) ~= "table" then
                res[k] = org1[k]
            else
                res[k] = {}
                _cp(org1[k], res[k])
            end
        end
    end
    local res = {}
    _cp(org, res)
    return res
end

--- 合并table
---@vararg table
---@return table
function table.merge(...)
    local tempTable = {}
    local tables = { ... }
    if (tables == nil) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            for _, v in ipairs(tn) do
                table.insert(tempTable, v)
            end
        end
    end
    return tempTable
end

--- 在数组内
---@param arr table
---@param val any
---@return boolean
function table.includes(arr, val)
    local isIn = false
    if (val == nil or #arr <= 0) then
        return isIn
    end
    for _, v in ipairs(arr) do
        if (v == val) then
            isIn = true
            break
        end
    end
    return isIn
end

--- 删除数组一次某个值(qty次,默认删除全部)
---@param arr table
---@param val any
---@param qty number
function table.delete(arr, val, qty)
    qty = qty or -1
    local q = 0
    for k, v in ipairs(arr) do
        if (v == val) then
            q = q + 1
            table.remove(arr, k)
            k = k - 1
            if (qty ~= -1 and q >= qty) then
                break
            end
        end
    end
end

--- 根据key从数组table返回一个对应值的数组
---@param arr table
---@param key string
---@return table
function table.value(arr, key)
    local values = {}
    if (arr ~= nil and key ~= nil and #arr > 0) then
        for _, v in ipairs(arr) do
            if (v[key] ~= nil) then
                table.insert(values, v[key])
            end
        end
    end
    return values
end

--- 将obj形式的attr数据转为有序数组{key=[key],value=[value]}
---@param obj table
---@param keyMap table
---@return table
function table.obj2arr(obj, keyMap)
    if (keyMap == nil or type(keyMap) ~= "table" or #keyMap <= 0) then
        return {}
    end
    local arr = {}
    for _, a in ipairs(keyMap) do
        if (obj[a] ~= nil) then
            table.insert(arr, { key = a, value = obj[a] })
        end
    end
    return arr
end

--- 计算数组平均数，如果某值不是number，会先强制转换，失败以0计算
---@param arr number[]
---@return number
function table.average(arr)
    if (arr == nil or type(arr) ~= "table" or #arr == 0) then
        return 0
    end
    local avg = 0
    local aci = 0
    for _, v in ipairs(arr) do
        if (type(v) ~= "number") then
            v = tonumber(v, 10)
            if (v == nil) then
                v = 0
            end
        end
        avg = avg + v
        aci = aci + 1
    end
    return avg / aci
end

--- 数组轮偏
---@param arr any[]
---@param offset number
---@return any[]
function table.wheel(arr, offset)
    offset = offset or 0
    if (type(arr) ~= "table") then
        return {}
    end
    local l = #arr
    if (l == 0) then
        return {}
    end
    local s = offset % l
    if (s < 0) then
        s = s + l
    end
    local new = {}
    for i = 1, l do
        s = s + 1
        if (s > l) then
            s = 1
        end
        new[i] = arr[s]
    end
    return new
end