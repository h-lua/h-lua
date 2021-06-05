-- 属性系统

CONST_ATTR = {
    life = "生命",
    mana = "魔法",
    move = "移动",
    defend = "护甲",
    defend_white = "基础护甲",
    defend_green = "附加护甲",
    attack_speed = "攻速",
    attack_space = "攻击间隔",
    attack_space_origin = "攻击间隔",
    attack = "攻击",
    attack_white = "基础攻击",
    attack_green = "附加攻击",
    attack_range = "攻击范围",
    attack_range_acquire = "主动攻击范围",
    sight = "视野范围",
    str = "力量",
    agi = "敏捷",
    int = "智力",
    str_green = "附加力量",
    agi_green = "附加敏捷",
    int_green = "附加智力",
    str_white = "本体力量",
    agi_white = "本体敏捷",
    int_white = "本体智力",
    life_back = "生命恢复",
    mana_back = "魔法恢复",
    avoid = "回避",
    aim = "命中",
    punish = "僵直",
    punish_current = "当前僵直",
    hemophagia = "吸血", --(%)
    hemophagia_skill = "技能吸血", --(%)
    siphon = "吸魔", --(%)
    siphon_skill = "技能吸魔", --(%)
    invincible = "无敌", --(%)
    weight = "负重",
    weight_current = "当前负重",
    damage_extent = "伤害增幅", --(%)
    damage_reduction = "减伤", --(固定)
    damage_decrease = "减伤", --(%)
    damage_rebound = "反弹伤害", --(%)
    damage_rebound_oppose = "反伤抵抗",
    cure = "治疗", --(%)
    reborn = "复活时间",
    knocking_odds = "暴击几率",
    knocking_extent = "暴击增伤", --(%)
    knocking_oppose = "暴击抵抗",
    hemophagia_oppose = "吸血抵抗",
    hemophagia_skill_oppose = "技能吸血抵抗",
    siphon_oppose = "吸魔抵抗",
    siphon_skill_oppose = "技能吸魔抵抗",
    buff_oppose = "强化阻碍",
    debuff_oppose = "负面抵抗",
    split_oppose = "分裂抵抗",
    punish_oppose = "僵直抵抗",
    swim_oppose = "眩晕抵抗",
    broken_oppose = "打断抵抗",
    silent_oppose = "沉默抵抗",
    unarm_oppose = "缴械抵抗",
    fetter_oppose = "定身抵抗",
    bomb_oppose = "爆破抵抗",
    lightning_chain_oppose = "闪电链抵抗",
    crack_fly_oppose = "击飞抵抗",
    --
    xtras = "附加特效",
    --
    knocking = "额外暴击",
    split = "分裂",
    swim = "眩晕",
    broken = "打断",
    silent = "沉默",
    unarm = "缴械",
    fetter = "定身",
    bomb = "爆破",
    lightning_chain = "闪电链",
    crack_fly = "击飞",
    paw = "冲击",
    --
    odds = "几率",
    percent = "比例",
    val = "数值",
    during = "持续时间",
    qty = "数量",
    radius = "范围",
    rate = "比率",
    distance = "距离",
    height = "高度",
    -- 本身是在player实现
    gold_ratio = "黄金获得率",
    lumber_ratio = "木头获得率",
    exp_ratio = "经验获得率",
    sell_ratio = "售卖比率",
}

CONST_ATTR_KEYS = {}

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

local otherKeys = {
    "reborn",
    "attack_speed",
    "attack_space",
    "attack_space_origin",
    "attack",
    "attack_white",
    "attack_green",
    "attack_range_acquire",
    "attack_range",
    "defend",
    "defend_white",
    "defend_green",
    "str",
    "agi",
    "int",
    "str_green",
    "agi_green",
    "int_green",
    "str_white",
    "agi_white",
    "int_white",
    "life",
    "mana",
    "life_back",
    "mana_back",
    "move",
    "sight",
    "avoid",
    "aim",
    "punish",
    "punish_current",
    "hemophagia",
    "hemophagia_skill",
    "siphon",
    "siphon_skill",
    "invincible",
    "weight",
    "weight_current",
    "damage_extent",
    "damage_reduction",
    "damage_decrease",
    "damage_rebound",
    "damage_rebound_oppose",
    "cure",
    "knocking_odds",
    "knocking_extent",
    "knocking_oppose",
    "hemophagia_oppose",
    "hemophagia_skill_oppose",
    "siphon_oppose",
    "siphon_skill_oppose",
    "split_oppose",
    "punish_oppose",
    "swim_oppose",
    "broken_oppose",
    "silent_oppose",
    "unarm_oppose",
    "fetter_oppose",
    "bomb_oppose",
    "lightning_chain_oppose",
    "crack_fly_oppose",
    "xtras",
    "gold_ratio",
    "lumber_ratio",
    "exp_ratio",
    "sell_ratio",
}

for _, v in ipairs(otherKeys) do
    table.insert(CONST_ATTR_KEYS, v)
end
