--- cli 构造的数据
local jass_slk = nil
local hslk_cli_ids = {}
local hslk_cli_synthesis = {}
HSLK_CLI_H_IDI = 1
HSLK_CLI_H_IDS = {}
HSLK_CLI_DATA = {}
HSLK_I2V = {}
HSLK_N2V = {}
HSLK_N2I = {}
HSLK_ICD = {}
HSLK_CLASS_IDS = {}
HSLK_TYPE_IDS = {}
HSLK_SYNTHESIS = {
    profit = {},
    fragment = {},
    fragmentNeeds = {},
}

hslk_init = function()
    if (jass_slk == nil) then
        jass_slk = require "jass.slk"
    end
    -- 处理物编数据
    if (#hslk_cli_ids > 0) then
        for _, id in ipairs(hslk_cli_ids) do
            HSLK_I2V[id] = HSLK_CLI_DATA[id] or {}
            HSLK_I2V[id]._type = HSLK_I2V[id]._type or "slk"
            if (jass_slk.item[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "item"
                HSLK_I2V[id].slk = jass_slk.item[id]
                if (HSLK_I2V[id].slk.cooldownID) then
                    HSLK_ICD[HSLK_I2V[id].slk.cooldownID] = HSLK_I2V[id]._id
                end
            elseif (jass_slk.unit[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "unit"
                HSLK_I2V[id].slk = jass_slk.unit[id]
            elseif (jass_slk.ability[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "ability"
                HSLK_I2V[id].slk = jass_slk.ability[id]
            elseif (jass_slk.buff[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "buff"
                HSLK_I2V[id].slk = jass_slk.buff[id]
            elseif (jass_slk.upgrade[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "upgrade"
                HSLK_I2V[id].slk = jass_slk.upgrade[id]
            end
            -- 处理_class
            if (HSLK_I2V[id]._class) then
                if (HSLK_CLASS_IDS[HSLK_I2V[id]._class] == nil) then
                    HSLK_CLASS_IDS[HSLK_I2V[id]._class] = {}
                end
                table.insert(HSLK_CLASS_IDS[HSLK_I2V[id]._class], id)
            end
            -- 处理_type
            if (HSLK_I2V[id]._type) then
                if (HSLK_TYPE_IDS[HSLK_I2V[id]._type] == nil) then
                    HSLK_TYPE_IDS[HSLK_I2V[id]._type] = {}
                end
                table.insert(HSLK_TYPE_IDS[HSLK_I2V[id]._type], id)
            end
            -- 处理N2V
            if (HSLK_I2V[id].slk) then
                local n = HSLK_I2V[id].slk.Name
                if (n ~= nil) then
                    if (HSLK_N2V[n] == nil) then
                        HSLK_N2I[n] = {}
                        HSLK_N2V[n] = {}
                    end
                    table.insert(HSLK_N2I[n], id)
                    table.insert(HSLK_N2V[n], HSLK_I2V[id])
                end
            end
        end
    end
    -- 处理合成公式
    if (#hslk_cli_synthesis > 0) then
        for _, data in ipairs(hslk_cli_synthesis) do
            -- 数据格式化
            -- 碎片名称转ID
            local jsonFragment = {}
            for k, v in ipairs(data.fragment) do
                data.fragment[k][2] = math.floor(v[2])
                local fragmentId = HSLK_N2V[v[1]][1]._id or nil
                if (fragmentId ~= nil) then
                    table.insert(jsonFragment, { fragmentId, v[2] })
                end
            end
            local profitId = HSLK_N2V[data.profit[1]][1]._id or nil
            if (profitId == nil) then
                return
            end
            if (HSLK_SYNTHESIS.profit[profitId] == nil) then
                HSLK_SYNTHESIS.profit[profitId] = {}
            end
            table.insert(HSLK_SYNTHESIS.profit[profitId], {
                qty = data.profit[2],
                fragment = jsonFragment,
            })
            local profitIndex = #HSLK_SYNTHESIS.profit[profitId]
            for _, f in ipairs(jsonFragment) do
                if (HSLK_SYNTHESIS.fragment[f[1]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]] = {}
                end
                if (HSLK_SYNTHESIS.fragment[f[1]][f[2]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]][f[2]] = {}
                end
                table.insert(HSLK_SYNTHESIS.fragment[f[1]][f[2]], {
                    profit = profitId,
                    index = profitIndex,
                })
                if (table.includes(HSLK_SYNTHESIS.fragmentNeeds, f[2]) == false) then
                    table.insert(HSLK_SYNTHESIS.fragmentNeeds, f[2])
                end
            end
        end
    end
    HL_ID_INIT()
end

local hslk_cli_set = function(_v)
    _v._id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]
    HSLK_CLI_DATA[_v._id] = _v
    HSLK_CLI_H_IDI = HSLK_CLI_H_IDI + 1
    return _v
end

hslk_conf = function(conf)
end

hslk_ability = function(_v)
    return hslk_cli_set(F6V_A(_v))
end

hslk_ability_empty = function(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    return hslk_cli_set(F6V_A(_v))
end

hslk_ability_ring = function(_v)
    _v._parent = "Aamk"
    _v._type = "ring"
    return hslk_cli_set(F6V_A(_v))
end

hslk_unit = function(_v)
    return hslk_cli_set(F6V_U(_v))
end

hslk_hero = function(_v)
    _v._parent = "Hpal"
    _v._type = "hero"
    return hslk_cli_set(F6V_U(_v))
end

hslk_courier = function(_v)
    _v._parent = "ogru"
    _v._type = "courier"
    F6V_COURIER_SKILL()
    return hslk_cli_set(F6V_U(_v))
end

hslk_item_synthesis = function(formula)
    hslk_cli_synthesis = F6V_I_SYNTHESIS(formula)
end

hslk_item = function(_v)
    _v = F6V_I(_v)
    local res
    if (type(_v._shadow) == "boolean" and true == _v._shadow) then
        local _vs = F6V_I_SHADOW(table.clone(_v))
        _v._shadow_id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI + 1]
        _vs._shadow_id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]
        res = hslk_cli_set(_v)
        hslk_cli_set(_vs)
    else
        res = hslk_cli_set(_v)
    end
    return res
end

hslk_buff = function(_v)
    return hslk_cli_set(F6V_B(_v))
end

hslk_upgrade = function(_v)
    return hslk_cli_set(F6V_UP(_v))
end
