--- 伤害流
---@class damaging
damaging = damaging or {}

--- 附魔类型集
---@type Array
damaging.actions = Array()

--- 伤害过程流
--- 伤害过程自上而下运行，对接ability damage函数的过程
---@param key string
---@param callFunc fun(options:noteSkillDamage):void
function damaging.defined(key, callFunc)
    damaging.actions.set(key, callFunc)
end