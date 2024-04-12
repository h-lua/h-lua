---@class hslk slk专用管理
hslk = {}

--- 根据名称获取ID
--- 根据名称只对应一个ID，返回string
--- 根据名称如对应多个ID，返回table
---@param name string
---@return string|string[]|nil
function hslk.n2i(name)
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

--- 根据ID获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param id string|number
---@vararg string 可选，直接获取级层key的值，如 hslk.i2v("H001","slk","Primary") == "STR"
---@return table|any
function hslk.i2v(id, ...)
    if (id == nil) then
        return
    end
    if (type(id) == "number") then
        id = i2c(id)
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
--- 如果名称冲突重复，则获取到数据集
---@param name string
---@vararg string 可选，直接获取级层key的值，如 hslk.n2v("天选勇者","slk","Primary") == "STR"
---@return table|table[]|any
function hslk.n2v(name, ...)
    local id = hslk.n2i(name)
    if (type(id) == "string") then
        return hslk.i2v(id, ...)
    elseif (type(id) == "table") then
        local v = {}
        for _, i in ipairs(id) do
            table.insert(v, hslk.i2v(i, ...))
        end
        return v
    end
end

--- 根据 hslk._class 获取ID集
---@param class table | {'unit','item'} 输入多个类型自动合并ID
---@return table
function hslk.classIds(class)
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
function hslk.typeIds(t)
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

--- 根据ID获取misc数据（slk-misc.md）
--- misc一般指平衡常数，可查阅docs/md或编辑器内描述
---@vararg string 可选，直接获取级层key的值，如 hslk.misc("Misc","FadeBuffMinDuration") == "10"
---@return table|nil
function hslk.misc(...)
    local n = select("#", ...)
    if (n > 0) then
        local val = HSLK_MISC
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
    return HSLK_MISC
end
