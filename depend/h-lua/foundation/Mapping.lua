--- 自定义值对
---@class Mapping
Mapping = {}

---@return self
function Mapping:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    instance.ks = {}
    instance.kv = {}
    return instance
end

function Mapping:length()
    return #self.ks
end

function Mapping:set(key, value)
    if (self.kv[key] == nil) then
        table.insert(self.ks, key)
    end
    self.kv[key] = value
end

function Mapping:get(key)
    return self.kv[key]
end

function Mapping:del(...)
    for _, key in ipairs({ ... }) do
        if (self.kv[key] ~= nil) then
            for i, k in ipairs(self.ks) do
                if (k == key) then
                    table.remove(self.ks, i)
                    break
                end
            end
            self.kv[key] = nil
        end
    end
end

--- forEach
---@alias MappingForEach fun(key: "key", value: "value"):void
---@param action MappingForEach | "function(key,value) end"
function Mapping:forEach(action)
    if (type(action) == 'function') then
        for _, key in ipairs(self.ks) do
            action(key, self.kv[key])
        end
    end
end
