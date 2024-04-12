--- 克隆table
---@param org table
---@return table
function table.clone(org)
    local function copy(org1, res)
        for k, v in pairs(org1) do
            if type(v) ~= "table" then
                res[k] = v
            else
                res[k] = {}
                copy(v, res[k])
            end
        end
    end
    local res = {}
    copy(org, res)
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
            for k, v in pairs(tn) do
                tempTable[k] = v
            end
        end
    end
    return tempTable
end
