---@class hattribute 属性系统
hattribute = {
    VAL_TYPE = {
        PLAYER = { "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" },
        INTEGER = {
            "life", "mana", "move", "attack_white", "attack_green",
            "attack_range", "attack_range_acquire",
            "defend_white", "defend_green",
            "str_white", "agi_white", "int_white", "str_green", "agi_green", "int_green"
        },
    },
    ---@private
    RELATION = {
        -- 每一点属性对另一个属性的影响
        -- 需要注意的是三围只能影响common内的大部分参数，natural及effect是无效的
        primary = 0, -- 每点主属性提升0点攻击
        -- 三围属性加成
        str = {
            life = 0, -- 每点力量提升0生命（比如）
        },
        agi = {},
        int = {},
    },
    CURE_FLOOR = 0.05, --生命魔法恢复绝对值小于此值时无效
}

--- 设置属性对应的其他属性的影响
--- 例如1点力量+10生命
---@param relation table
function hattribute.setRelation(relation)
    if (type(relation) == "table") then
        hattribute.RELATION = relation
    end
end

--- 设置单位属性
---@alias noteAttr {life,mana,move,defend,defend_white,defend_green,attack_speed,attack_space,attack_space_origin,attack,attack_white,attack_green,attack_range,attack_range_acquire,str,agi,int,str_green,agi_green,int_green,str_white,agi_white,int_white,life_back,mana_back,reborn,swim_oppose,broken_oppose,silent_oppose,unarm_oppose,lightning_chain_oppose,crack_fly_oppose,gold_ratio,lumber_ratio,exp_ratio,sell_ratio}
---@param whichUnit userdata
---@param during number 0表示无限
---@param data noteAttr
---@return nil|Timer[] 当持续时间大于0时，返回buffTimer[]
function hattribute.set(whichUnit, during, data)
    if (whichUnit == nil) then
        -- 例如有时造成伤害之前把单位删除就捕捉不到这个伤害来源了
        -- 虽然这里直接返回不执行即可，但是提示下可以帮助完善业务的构成~
        stack("whichUnit is nil")
        return
    end
    local attribute = hattribute.get(whichUnit)
    if (attribute == nil) then
        return
    end
    -- 处理data
    if (type(data) ~= "table") then
        err("data must be table")
        return
    end
    local timers = {}
    for _, arr in ipairs(table.obj2arr(data, CONST_ATTR_KEYS)) do
        local attr = arr.key
        local v = arr.value
        local t
        if (attribute[attr] == nil) then
            attribute[attr] = CONST_ATTR_VALUE[attr] or 0
        end
        if (type(v) == "number") then
            t = hattributeSetter.setHandle(whichUnit, attr, "=", v, during)
        elseif (type(v) == "string") then
            local opr = string.sub(v, 1, 1)
            v = string.sub(v, 2, string.len(v))
            local val = tonumber(v)
            if (val == nil) then
                val = v
            end
            t = hattributeSetter.setHandle(whichUnit, attr, opr, val, during)
        end
        if (t ~= nil) then
            table.insert(timers, t)
        end
    end
    return timers
end

--- 通用get
---@param whichUnit userdata
---@param attr string
---@param default any 默认值，默认为0
---@return any
function hattribute.get(whichUnit, attr, default)
    if (attr == nil) then
        default = default or {}
    else
        default = default or CONST_ATTR_VALUE[attr] or 0
    end
    if (whichUnit == nil) then
        return default
    end
    local attribute = hcache.get(whichUnit, CONST_CACHE.ATTR, nil)
    if (attribute == nil) then
        return default
    elseif (attribute == -1) then
        if (hattributeSetter.init(whichUnit) == false) then
            return default
        end
        attribute = hcache.get(whichUnit, CONST_CACHE.ATTR)
    end
    if (attr == nil) then
        return attribute or default
    end
    return attribute[attr] or default
end

--- 计算单位的属性浮动影响
---@private
function hattribute.caleAttribute(damageSrc, isAdd, whichUnit, attr, times)
    if (isAdd == nil) then
        isAdd = true
    end
    if (attr == nil) then
        return
    end
    if (attr.disabled == true) then
        return
    end
    damageSrc = damageSrc or CONST_DAMAGE_SRC.unknown
    if (times == nil or times < 1) then
        times = 1
    end
    local diff = {}
    local diffPlayer = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        local typev = type(v)
        local tempDiff
        if (typev == "string") then
            local opt = string.sub(v, 1, 1)
            local nv = times * tonumber(string.sub(v, 2))
            if (isAdd == false) then
                if (opt == "+") then
                    opt = "-"
                else
                    opt = "+"
                end
            end
            tempDiff = opt .. nv
        elseif (typev == "number") then
            if ((v > 0 and isAdd == true) or (v < 0 and isAdd == false)) then
                tempDiff = "+" .. (v * times)
            elseif (v < 0) then
                tempDiff = "-" .. (v * times)
            end
        elseif (typev == "table") then
            local tempTable = {}
            for _ = 1, times do
                for _, vv in ipairs(v) do
                    vv.damageSrc = damageSrc
                    table.insert(tempTable, vv)
                end
            end
            local opt = "add"
            if (isAdd == false) then
                opt = "sub"
            end
            tempDiff = {
                [opt] = tempTable
            }
        end
        if (hattributeSetter.isValType(k, hattribute.VAL_TYPE.PLAYER)) then
            table.insert(diffPlayer, { k, tonumber(tempDiff) })
        else
            diff[k] = tempDiff
        end
    end
    hattribute.set(whichUnit, 0, diff)
    if (#diffPlayer > 0) then
        local p = hunit.getOwner(whichUnit)
        for _, dp in ipairs(diffPlayer) do
            local pk = dp[1]
            local pv = dp[2]
            if (pv ~= 0) then
                if (pk == "gold_ratio") then
                    hplayer.addGoldRatio(p, pv, 0)
                elseif (pk == "lumber_ratio") then
                    hplayer.addLumberRatio(p, pv, 0)
                elseif (pk == "exp_ratio") then
                    hplayer.addExpRatio(p, pv, 0)
                elseif (pk == "sell_ratio") then
                    hplayer.addSellRatio(p, pv, 0)
                end
            end
        end
    end
end