--- buff系统
---buff是一种状态，可被创建和删除
---当buff被删除时，将会
hbuff = {
    UNIQUE_KEY = 0,
    DEFAULT_CONST_BUFF = '_h_lua',
}

---@private
hbuff.uniqueKey = function()
    hbuff.UNIQUE_KEY = hbuff.UNIQUE_KEY + 1
    return hbuff.UNIQUE_KEY
end

--- 统计group buff的个数
---@private
hbuff.count = function(handleUnit, groupKey)
    if (handleUnit == nil) then
        return 0
    end
    if (handleUnit == nil or groupKey == nil) then
        return 0
    end
    if (his.deleted(handleUnit)) then
        return 0
    end
    if (false == hcache.exist(handleUnit)) then
        return 0
    end
    local buffHandle = hcache.get(handleUnit, CONST_CACHE.BUFF, {})
    if (buffHandle[groupKey] == nil) then
        return 0
    end
    return #buffHandle[groupKey]._idx
end

--- 创建一个buff概念物
--- 成功创建时会返回一个key，用于删除buff
--- 失败会返回nil
---@param during number > 0
---@param handleUnit userdata
---@param groupKey string|'global' buff集合key，用于自主分类和搜索
---@param purpose function 目的期望的操作
---@param rollback function 回到原来状态的操作
---@return string|nil
hbuff.create = function(during, handleUnit, groupKey, purpose, rollback)
    if (handleUnit == nil or purpose == nil or rollback == nil) then
        return
    end
    during = during or 0
    if (during <= 0) then
        during = -1
    end
    if (his.deleted(handleUnit)) then
        return
    end
    if (false == hcache.exist(handleUnit)) then
        return
    end
    groupKey = groupKey or hbuff.DEFAULT_CONST_BUFF
    purpose()
    local buffHandle = hcache.get(handleUnit, CONST_CACHE.BUFF)
    if (buffHandle == nil) then
        buffHandle = {}
        hcache.set(handleUnit, CONST_CACHE.BUFF, buffHandle)
    end
    if (buffHandle[groupKey] == nil) then
        buffHandle[groupKey] = {}
    end
    if (buffHandle[groupKey]._idx == nil) then
        buffHandle[groupKey]._idx = {}
    end
    local uk = hbuff.uniqueKey()
    buffHandle[groupKey][uk] = { purpose = purpose, rollback = rollback }
    table.insert(buffHandle[groupKey]._idx, uk)
    if (during > 0) then
        htime.setTimeout(during, function(curTimer)
            htime.delTimer(curTimer)
            if (his.deleted(handleUnit)) then
                return
            end
            if (buffHandle ~= nil and buffHandle[groupKey] ~= nil) then
                if (buffHandle[groupKey]._idx ~= nil) then
                    table.delete(buffHandle[groupKey]._idx, uk)
                end
                if (buffHandle[groupKey][uk] ~= nil) then
                    rollback()
                    buffHandle[groupKey][uk] = nil
                end
            end
        end)
    end
    return string.implode('|', { groupKey, uk })
end

--- 使一个buff强制执行一次purpose
--- buff被删除时会回到原来的状态
---@param handleUnit userdata
---@param buffKey string 由 groupKey|uniqueKey 组成,如果没有uniqueKey则清空所有groupKey下的buff
hbuff.purpose = function(handleUnit, buffKey)
    if (handleUnit == nil or buffKey == nil) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    if (false == hcache.exist(handleUnit)) then
        return
    end
    local ebk = string.explode('|', buffKey)
    local groupKey = ebk[1] or nil
    local uk = math.floor(ebk[2] or 0)
    if (groupKey == nil or uk == 0) then
        return
    end
    local buffHandle = hcache.get(handleUnit, CONST_CACHE.BUFF, {})
    if (buffHandle[groupKey] ~= nil and buffHandle[groupKey][uk] ~= nil) then
        buffHandle[groupKey][uk].purpose()
    end
end

--- 删除一个buff
--- buff被删除时会回到原来的状态
---@param handleUnit userdata
---@param buffKey string 由 groupKey|uniqueKey 组成,如果没有uniqueKey则清空所有groupKey下的buff
hbuff.delete = function(handleUnit, buffKey)
    if (handleUnit == nil or buffKey == nil) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    if (false == hcache.exist(handleUnit)) then
        return
    end
    local ebk = string.explode('|', buffKey)
    local groupKey = ebk[1] or nil
    local uk = ebk[2] or nil
    if (groupKey == nil) then
        return
    end
    local buffHandle = hcache.get(handleUnit, CONST_CACHE.BUFF, {})
    if (buffHandle._idx ~= nil) then
        if (uk == nil) then
            -- 删除group下所有buff
            for _, _uk in ipairs(buffHandle._idx) do
                if (buffHandle[groupKey][_uk] ~= nil) then
                    buffHandle[groupKey][_uk].rollback() --rollback
                end
            end
            buffHandle[groupKey] = nil
        else
            -- 删除uk指向buff
            uk = math.floor(uk)
            if (buffHandle[groupKey][uk] ~= nil) then
                buffHandle[groupKey][uk].rollback() --rollback
                buffHandle[groupKey][uk] = nil
                table.delete(buffHandle[groupKey]._idx, uk)
            end
        end
    end
end