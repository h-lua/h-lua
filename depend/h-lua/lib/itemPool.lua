-- 物品池
hitemPool = {
    name = {},
    data = {}
}

---@private
hitemPool.poolName = function(poolName)
    return '@' .. poolName
end

--- 将物品添加到物品池
---@param poolName string
---@param whichItem userdata
hitemPool.insert = function(poolName, whichItem)
    if (poolName == nil or whichItem == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hitemPool.data[poolName] == nil) then
        hitemPool.data[poolName] = {}
        table.insert(hitemPool.name, poolName)
    end
    if (false == table.includes(hitemPool.data[poolName], whichItem)) then
        table.insert(hitemPool.data[poolName], whichItem)
    end
end

--- 将物品从物品池删除
---@param poolName string
---@param whichItem userdata
hitemPool.delete = function(poolName, whichItem)
    if (poolName == nil or whichItem == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hitemPool.data[poolName] == nil) then
        return
    end
    table.delete(hitemPool.data[poolName], whichItem, 1)
end

--- 将物品从所有物品池删除
---@param whichItem userdata
hitemPool.free = function(whichItem)
    if (whichItem == nil) then
        return
    end
    if (#hitemPool.name <= 0) then
        return
    end
    for _, poolName in ipairs(hitemPool.name) do
        if (hitemPool.data[poolName] ~= nil and #hitemPool.data[poolName] > 0) then
            table.delete(hitemPool.data[poolName], whichItem)
        end
    end
end

--- 遍历物品池
---@alias ItemPoolForEach fun(enumItem: userdata, idx: number):void
---@param poolName string
---@param action ItemPoolForEach | "function(enumItem, idx) end"
hitemPool.forEach = function(poolName, action)
    if (poolName == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hitemPool.data[poolName] == nil) then
        return
    end
    if (type(action) == "function") then
        for idx, it in ipairs(hitemPool.data[poolName]) do
            local res = action(it, idx)
            if (type(res) == 'boolean' and res == false) then
                break
            end
        end
    end
end