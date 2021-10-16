-- 属性系统
-- fmt key,label,init
-- 格式 键值,名字,初始值
-- primary,life,mana,move,defend_white,attack_range,attack_range_acquire这些值会在初始化时强行覆盖为slk数据，初始值写了没用
CONST_ATTR_CONF = {
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
    { "sight", "视野范围", 0 },
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
    { "avoid", "回避", 0 },
    { "aim", "命中", 0 },
    { "punish", "僵直", 0 },
    { "punish_current", "当前僵直", 0 },
    { "hemophagia", "吸血", 0 }, --(%)
    { "hemophagia_skill", "技能吸血", 0 }, --(%)
    { "siphon", "吸魔", 0 }, --(%)
    { "siphon_skill", "技能吸魔", 0 }, --(%)
    { "invincible", "无敌", 0 }, --(%)
    { "weight", "负重", 0 },
    { "weight_current", "当前负重", 0 },
    { "damage_extent", "伤害增幅", 0 }, --(%)
    { "damage_reduction", "减伤", 0 }, --(固定)
    { "damage_decrease", "减伤", 0 }, --(%)
    { "damage_rebound", "反弹伤害", 0 }, --(%)
    { "damage_rebound_oppose", "反伤抵抗", 0 },
    { "cure", "治疗", 0 }, --(%)
    { "reborn", "复活时间", -999 },
    { "knocking_odds", "暴击几率", 0 },
    { "knocking_extent", "暴击增伤", 0 }, --(%)
    { "knocking_oppose", "暴击抵抗", 0 },
    { "hemophagia_oppose", "吸血抵抗", 0 },
    { "hemophagia_skill_oppose", "技能吸血抵抗", 0 },
    { "siphon_oppose", "吸魔抵抗", 0 },
    { "siphon_skill_oppose", "技能吸魔抵抗", 0 },
    { "buff_oppose", "强化阻碍", 0 },
    { "debuff_oppose", "负面抵抗", 0 },
    { "split_oppose", "分裂抵抗", 0 },
    { "punish_oppose", "僵直抵抗", 0 },
    { "swim_oppose", "眩晕抵抗", 0 },
    { "broken_oppose", "打断抵抗", 0 },
    { "silent_oppose", "沉默抵抗", 0 },
    { "unarm_oppose", "缴械抵抗", 0 },
    { "fetter_oppose", "定身抵抗", 0 },
    { "bomb_oppose", "爆破抵抗", 0 },
    { "lightning_chain_oppose", "闪电链抵抗", 0 },
    { "crack_fly_oppose", "击飞抵抗", 0 },
    --
    { "xtras", "附加特效", {} },
    --
    { "knocking", "额外暴击", 0 },
    { "split", "分裂", 0 },
    { "swim", "眩晕", 0 },
    { "broken", "打断", 0 },
    { "silent", "沉默", 0 },
    { "unarm", "缴械", 0 },
    { "fetter", "定身", 0 },
    { "bomb", "爆破", 0 },
    { "lightning_chain", "闪电链", 0 },
    { "crack_fly", "击飞", 0 },
    { "paw", "冲击", 0 },
    --
    { "odds", "几率", 0 },
    { "percent", "比例", 0 },
    { "val", "数值", 0 },
    { "during", "持续时间", 0 },
    { "qty", "数量", 0 },
    { "radius", "范围", 0 },
    { "rate", "比率", 0 },
    { "distance", "距离", 0 },
    { "height", "高度", 0 },
    -- 本身是在player实现
    { "gold_ratio", "黄金获得率", 0 },
    { "lumber_ratio", "木头获得率", 0 },
    { "exp_ratio", "经验获得率", 0 },
    { "sell_ratio", "售卖比率", 0 },
}

--- 键值归档
CONST_ATTR_KEYS = {}

--- KV属性
CONST_ATTR = {}

for _, v in ipairs(CONST_ATTR_CONF) do
    table.insert(CONST_ATTR_KEYS, v[1])
    CONST_ATTR[v[1]] = v[2]
end

-- 附魔文本和key
for _, v in ipairs(CONST_ENCHANT) do
    CONST_ATTR["e_" .. v.value] = v.label .. '强化' -- e_fire = "火强化"
    CONST_ATTR["e_" .. v.value .. '_oppose'] = v.label .. '抗性' -- e_fire_oppose = "火抗性"
    CONST_ATTR["e_" .. v.value .. '_attack'] = v.label .. '攻击附魔' -- e_fire_attack = "火攻击附魔"
    CONST_ATTR["e_" .. v.value .. '_append'] = v.label .. '附魔状态' -- e_fire_append = "火附魔状态"
end

for _, v in ipairs(CONST_ENCHANT) do
    table.insert(CONST_ATTR_KEYS, "e_" .. v.value .. '_attack')
end
for _, v in ipairs(CONST_ENCHANT) do
    table.insert(CONST_ATTR_KEYS, "e_" .. v.value .. '_append')
end
for _, v in ipairs(CONST_ENCHANT) do
    table.insert(CONST_ATTR_KEYS, "e_" .. v.value)
    table.insert(CONST_ATTR_KEYS, "e_" .. v.value .. '_oppose')
end