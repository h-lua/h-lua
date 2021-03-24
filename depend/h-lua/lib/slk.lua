---@class hslk slk专用管理
hslk = {}

--- 根据ID获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param id string|number
---@vararg string 可选，直接获取该key的值
---@return table|nil
hslk.i2v = function(id, ...)
    if (id == nil) then
        return
    end
    if (type(id) == "number") then
        id = string.id2char(id)
    end
    if (HSLK_I2V[id] == nil) then
        return
    end
    local n = select("#", ...)
    if (n > 0) then
        local val = HSLK_I2V[id]
        for i = 1, n, 1 do
            local k = select(i, ...)
            if (val[k] ~= nil) then
                val = val[k]
            else
                val = nil
            end
            if (val == nil) then
                break
            end
        end
        return val
    end
    return HSLK_I2V[id]
end

--- 根据名称获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
--- 如果名称冲突，则只能获取到最后设定的数据
---@param name string
---@return table|nil
hslk.n2v = function(name)
    if (type(name) ~= "string") then
        return
    end
    if (HSLK_N2V[name] == nil or type(HSLK_N2V[name]) ~= "table") then
        return
    end
    if (#HSLK_N2V[name] == 1) then
        return HSLK_N2V[name][1]
    end
    return HSLK_N2V[name]
end

--- 根据名称获取ID
--- 根据名称只对应一个ID，返回string
--- 根据名称如对应多个ID，返回table
---@param name string
---@return string|table|nil
hslk.n2i = function(name)
    if (type(name) ~= "string") then
        return
    end
    if (HSLK_N2I[name] == nil or type(HSLK_N2I[name]) ~= "table") then
        return
    end
    if (#HSLK_N2I[name] == 1) then
        return HSLK_N2I[name][1]
    end
    return HSLK_N2I[name]
end

--- 根据 hslk._class 获取ID集
---@param class table | {'unit','item'} 输入多个类型自动合并ID
---@return table
hslk.classIds = function(class)
    if (type(class) == "string") then
        class = { class }
    end
    if (type(class) ~= "table") then
        return {}
    end
    local ids = {}
    for _, c in ipairs(class) do
        if (HSLK_CLASS_IDS[c] ~= nil) then
            for _, id in ipairs(HSLK_CLASS_IDS[c]) do
                table.insert(ids, id)
            end
        end
    end
    return ids
end

--- 根据 hslk._type 获取ID集
---@param t table | {'hero'} 输入多个类型自动合并ID
---@return table
hslk.typeIds = function(t)
    if (type(t) == "string") then
        t = { t }
    end
    if (type(t) ~= "table") then
        return {}
    end
    local ids = {}
    for _, c in ipairs(t) do
        if (HSLK_TYPE_IDS[c] ~= nil) then
            for _, id in ipairs(HSLK_TYPE_IDS[c]) do
                table.insert(ids, id)
            end
        end
    end
    return ids
end
