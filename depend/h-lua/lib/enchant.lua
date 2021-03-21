-- 附魔
henchant = {
    ---@private
    INTRINSIC_ADDITION = 10, -- (%)附魔属性存在时的固有加成如火攻击对无火抵抗的自带百分之10伤害
    ---@private
    STATUS = false, -- 是否开启着身附魔后果
    ---@private
    APPEND_DURING = 5.0, -- 开启着身附魔后默认附身时间(秒)
    ---@private
    ENV_APPEND_EFFECT = {}, -- 附魔环境特效配置
    ---@private
    ENV_REACTION = {}, -- 附魔环境反应
}

--- 设置附魔的底层固有加成
---@param percent number 加成比例(%)
henchant.setIntrinsicAddition = function(percent)
    if (type(percent) == 'number') then
        henchant.INTRINSIC_ADDITION = math.round(percent)
    end
end

--- 设置着身附魔
---@param status boolean 开关附魔
henchant.enableAppend = function(status)
    if (type(status) == 'boolean') then
        henchant.STATUS = status
    end
end

--- 设置单位附着附魔特效
---@param whichEnchant string CONST_ENCHANT 对应的附魔
---@param effects table|nil 特效绑定的多个位置，如 {{attach = 'origin',effect = 'Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl'}}
henchant.setAppendAttachEffect = function(whichEnchant, effects)
    if (type(whichEnchant) ~= 'string') then
        return
    end
    if (effects ~= nil and type(effects) ~= 'table') then
        return
    end
    henchant.ENV_APPEND_EFFECT[whichEnchant] = effects
end

--- 设置环境附魔反应
---@alias setReaction fun(evtData: {type:"附魔触发类型",level:"反应等级",sourceUnit:"来自单位",targetUnit:"目标单位"}):void
---@param onEnchant string CONST_ENCHANT [运行时]单位附着的新的附魔
---@param toEnchant string CONST_ENCHANT [运行时]单位已有的目标附着附魔
---@param reaction setReaction  | "function(evtData) end" 新->旧 [运行时]化学反应，反应后该两个类型的附魔都将消失
henchant.setEnvReaction = function(onEnchant, toEnchant, reaction)
    if (type(onEnchant) ~= 'string' or type(toEnchant) ~= 'string' or type(reaction) ~= 'function') then
        return
    end
    if (henchant.ENV_REACTION[onEnchant] == nil) then
        henchant.ENV_REACTION[onEnchant] = {}
    end
    henchant.ENV_REACTION[onEnchant][toEnchant] = reaction
end

--- 给目标单位添加附魔属性
---@param options table
henchant.append = function(options)
    --[[
        options = {
            targetUnit = userdata,
            sourceUnit = userdata,
            enchants = {'fire','water'} | "fire,water", 建议用table
            during = 5,
        }
    ]]
    local targetUnit = options.targetUnit
    local sourceUnit = options.sourceUnit
    local enchants = options.enchants
    local during = options.during or henchant.APPEND_DURING
    if (during < 0) then
        during = 0
    end
    if (henchant.STATUS ~= true) then
        return
    end
    if (targetUnit == nil or his.deleted(targetUnit)) then
        return
    end
    if (sourceUnit == nil or his.deleted(sourceUnit)) then
        return
    end
    if (type(enchants) == 'string') then
        enchants = string.explode(',', enchants)
    end
    if (type(enchants) ~= 'table' or #enchants <= 0) then
        return
    end
    -- 整合
    local newEnchant = {}
    local newEnchants = {}
    for _, e in ipairs(enchants) do
        if (e ~= "common") then
            local hasReaction = false -- 判断反应结果
            if (henchant.ENV_REACTION[e] ~= nil) then
                for _, con in ipairs(CONST_ENCHANT) do
                    -- 判断所有种类的附魔，如果之前有附魔过
                    local appendKey = 'e_' .. con.value .. '_append'
                    local level = hattribute.get(targetUnit, appendKey)
                    if (level > 0) then
                        if (henchant.ENV_REACTION[e][con.value] ~= nil) then
                            -- 如果有反应式，先消除旧附魔元素
                            hbuff.delete(targetUnit, 'attr.' .. appendKey .. '+')
                            -- 反应
                            henchant.ENV_REACTION[e][con.value]({
                                type = { e, con.value },
                                level = level,
                                sourceUnit = sourceUnit,
                                targetUnit = targetUnit,
                            })
                            hasReaction = true
                        end
                    end
                end
            end
            -- 如果有对应的反应，那么删除增添的附魔和身上的附魔状态
            -- 如果没有反应，那么增加1对应的身上附魔
            if (hasReaction == true) then
                -- 这里不需要删除新附魔，什么都不做就行了，消失了
            else
                if (newEnchant[e] == nil) then
                    newEnchant[e] = 0
                    table.insert(newEnchants, e)
                end
                newEnchant[e] = newEnchant[e] + 1
            end
        end
    end
    for _, e in ipairs(newEnchants) do
        if (newEnchant[e] ~= nil and newEnchant[e] > 0) then
            local appendKey = 'e_' .. e .. '_append'
            hattribute.set(targetUnit, during, {
                [appendKey] = "+" .. newEnchant[e]
            })
        end
    end
    -- 重置特效
    if (#newEnchants > 0) then
        for _, e in ipairs(newEnchants) do
            local prevEffs = hcache.get(targetUnit, CONST_CACHE.ENCHANT_EFFECT)
            if (prevEffs == nil) then
                hcache.set(targetUnit, CONST_CACHE.ENCHANT_EFFECT, {})
                prevEffs = hcache.get(targetUnit, CONST_CACHE.ENCHANT_EFFECT)
            else
                for i = #prevEffs, 1, -1 do
                    heffect.del(prevEffs[i])
                    table.remove(prevEffs, i)
                end
            end
            if (henchant.ENV_APPEND_EFFECT[e] ~= nil) then
                for _, o in ipairs(henchant.ENV_APPEND_EFFECT[e]) do
                    local e2 = heffect.bindUnit(o.effect, targetUnit, o.attach, during)
                    if (e2 ~= nil) then
                        table.insert(prevEffs, heffect.bindUnit(o.effect, targetUnit, o.attach, during))
                    end
                end
            end
        end
    end
    newEnchant = nil
    newEnchants = nil
end
