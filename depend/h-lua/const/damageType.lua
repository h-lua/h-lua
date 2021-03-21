-- 伤害类型
-- 这里写预设是为了编程时的方便性，实际上可以不写
CONST_DAMAGE_TYPE = {
    common = "common",
    physical = nil,
    magic = nil,
    fire = nil,
    flame = nil,
    soil = nil,
    rock = nil,
    sand = nil,
    lava = nil,
    water = nil,
    ice = nil,
    storm = nil,
    wind = nil,
    light = nil,
    dark = nil,
    wood = nil,
    grass = nil,
    thunder = nil,
    electric = nil,
    metal = nil,
    iron = nil,
    steel = nil,
    dragon = nil,
    insect = nil,
    poison = nil,
    evil = nil,
    ghost = nil,
    god = nil,
    holy = nil,
}

for _, v in ipairs(CONST_ENCHANT) do
    CONST_DAMAGE_TYPE[v.value] = v.value
end
