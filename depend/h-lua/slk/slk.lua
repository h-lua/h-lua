--- cli 构造的数据
local hslk_cli_ids = {}
HSLK_CLI_H_IDI = 1
HSLK_CLI_H_IDS = {}
HSLK_CLI_DATA = {}
HSLK_I2V = {}
HSLK_N2V = {}
HSLK_N2I = {}
HSLK_ICD = {}
HSLK_CLASS_IDS = {}
HSLK_TYPE_IDS = {}
HSLK_MISC = {}

-- 用于反向补充slk优化造成的数据丢失问题
-- 如你遇到slk优化后（dist后）地图忽然报错问题，则有可能是优化丢失
HSLK_FIX = {
    unit = { "sight", "nsight" } -- 视野设“0”会被w2l优化干掉
}

function hslk_init()
    -- 载入平衡常数数据
    HSLK_MISC = JassSlk.misc
    -- 处理物编数据
    hslk_cli_ids = table.merge(hslk_cli_ids, HSLK_CLI_H_IDS)
    if (#hslk_cli_ids > 0) then
        for _, id in ipairs(hslk_cli_ids) do
            HSLK_I2V[id] = HSLK_CLI_DATA[id] or {}
            HSLK_I2V[id]._type = HSLK_I2V[id]._type or "slk"
            if (JassSlk.item[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "item"
                HSLK_I2V[id].slk = JassSlk.item[id]
                if (HSLK_I2V[id].slk.cooldownID) then
                    HSLK_ICD[HSLK_I2V[id].slk.cooldownID] = HSLK_I2V[id]._id
                end
            elseif (JassSlk.unit[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "unit"
                HSLK_I2V[id].slk = setmetatable({}, { __index = JassSlk.unit[id] })
                for _, f in ipairs(HSLK_FIX.unit) do
                    if (HSLK_I2V[id].slk[f] == nil) then
                        HSLK_I2V[id].slk[f] = HSLK_I2V[id][f] or 0
                    end
                end
            elseif (JassSlk.ability[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "ability"
                HSLK_I2V[id].slk = JassSlk.ability[id]
            elseif (JassSlk.buff[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "buff"
                HSLK_I2V[id].slk = JassSlk.buff[id]
            elseif (JassSlk.upgrade[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "upgrade"
                HSLK_I2V[id].slk = JassSlk.upgrade[id]
            elseif (JassSlk.destructable[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "destructable"
                HSLK_I2V[id].slk = JassSlk.destructable[id]
            elseif (JassSlk.doodad[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "doodad"
                HSLK_I2V[id].slk = JassSlk.doodad[id]
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
                local n
                if (HSLK_I2V[id]._class == "buff") then
                    n = HSLK_I2V[id].slk.EditorName
                else
                    n = HSLK_I2V[id].slk.Name
                end
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
    hslk_cli_ids = nil
    HL_ID_INIT()
end

local function hslk_cli_set(_v)
    _v._id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]
    HSLK_CLI_DATA[_v._id] = _v
    HSLK_CLI_H_IDI = HSLK_CLI_H_IDI + 1
    return _v
end

---@param _v note_Ability
---@return {_id}
function hslk_ability(_v)
    return hslk_cli_set(F6V_A(_v))
end

---@param _v note_Ability
---@return {_id}
function hslk_ability_empty(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    return hslk_cli_set(F6V_A(_v))
end

---@param _v note_Unit
---@return {_id}
function hslk_unit(_v)
    return hslk_cli_set(F6V_U(_v))
end

-- 简易英雄
---@param _v note_Unit
---@return {_id}
function hslk_hero(_v)
    _v._parent = "Hpal"
    _v._type = "hero"
    return hslk_cli_set(F6V_U(_v))
end

---@param _v note_Item
---@return {_id}
function hslk_item(_v)
    _v = F6V_I(_v)
    return hslk_cli_set(_v)
end

---@param _v note_Buff
---@return {_id}
function hslk_buff(_v)
    return hslk_cli_set(F6V_B(_v))
end

---@param _v note_Upgrade
---@return {_id}
function hslk_upgrade(_v)
    return hslk_cli_set(F6V_UP(_v))
end

---@param _v note_Destructable
---@return {_id}
function hslk_destructable(_v)
    return hslk_cli_set(F6V_DE(_v))
end

---@param _v note_Doodad
---@return {_id}
function hslk_doodad(_v)
    return hslk_cli_set(F6V_DO(_v))
end
