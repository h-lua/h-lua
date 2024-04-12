-- 属性系统
-- fmt key,label,init
-- 格式 键值,名字,初始值
-- primary,life,mana,move,defend_white,attack_range,attack_range_acquire这些值会在初始化时强行覆盖为slk数据，初始值写了没用
CONST_ATTR_CONF = {}

--- 键值归档
CONST_ATTR_KEYS = {}

--- key=>label
CONST_ATTR_LABEL = {}

--- key=>defaultValue
CONST_ATTR_VALUE = {}

---@type fun(conf:table[])
ATTR_CONFIGURATOR = function(conf)
    for _, v in ipairs(conf) do
        if (CONST_ATTR_LABEL[v[1]] == nil) then
            table.insert(CONST_ATTR_CONF, v)
            table.insert(CONST_ATTR_KEYS, v[1])
        end
        CONST_ATTR_LABEL[v[1]] = v[2]
        CONST_ATTR_VALUE[v[1]] = v[3]
    end
end

--- 属性配置器
ATTR_CONFIGURATOR({
    { "life", "生命", 0 },
    { "mana", "魔法", 0 },
    { "move", "移动", 0 },
    { "defend", "护甲", 0 },
    { "defend_white", "基础护甲", 0 },
    { "defend_green", "附加护甲", 0 },
    { "attack_speed", "攻速", 0 },
    { "attack_space", "攻击间隔", 0 },
    { "attack_space_origin", "攻击间隔", 0 },
    { "attack", "攻击", 0 },
    { "attack_white", "基础攻击", 0 },
    { "attack_green", "附加攻击", 0 },
    { "attack_range", "攻击范围", 0 },
    { "attack_range_acquire", "主动攻击范围", 0 },
    { "str", "力量", 0 },
    { "agi", "敏捷", 0 },
    { "int", "智力", 0 },
    { "str_green", "附加力量", 0 },
    { "agi_green", "附加敏捷", 0 },
    { "int_green", "附加智力", 0 },
    { "str_white", "本体力量", 0 },
    { "agi_white", "本体敏捷", 0 },
    { "int_white", "本体智力", 0 },
    { "life_back", "生命恢复", 0 },
    { "mana_back", "魔法恢复", 0 },
    { "reborn", "复活时间", -999 },
    -- 本身是在player实现
    { "gold_ratio", "黄金获得率", 0 },
    { "lumber_ratio", "木头获得率", 0 },
    { "exp_ratio", "经验获得率", 0 },
    { "sell_ratio", "售卖比率", 0 },
})