-- 武器类型
CONST_WEAPON_TYPE = {
    missile = { value = "missile", label = "箭矢" },
    msplash = { value = "msplash", label = "箭矢(溅射)" },
    mbounce = { value = "mbounce", label = "箭矢(弹射)" },
    mline = { value = "mline", label = "箭矢(穿透)" },
    normal = { value = "normal", label = "近战" },
    instant = { value = "instant", label = "立即" },
    artillery = { value = "artillery", label = "炮火" },
    aline = { value = "aline", label = "炮火(穿透)" },
}

-- 武器声音
CONST_WEAPON_SOUND = {
    MetalHeavyBash = { value = "MetalHeavyBash", label = "金属重击" },
    MetalMediumBash = { value = "MetalMediumBash", label = "金属中击" },
    MetalHeavyChop = { value = "MetalHeavyChop", label = "金属重砍" },
    MetalMediumChop = { value = "MetalMediumChop", label = "金属中砍" },
    MetalLightChop = { value = "MetalLightChop", label = "金属轻砍" },
    MetalHeavySlice = { value = "MetalHeavySlice", label = "金属重切" },
    MetalMediumSlice = { value = "MetalMediumSlice", label = "金属中切" },
    MetalLightSlice = { value = "MetalLightSlice", label = "金属轻切" },
    AxeMediumChop = { value = "AxeMediumChop", label = "斧头中砍" },
    RockHeavyBash = { value = "RockHeavyBash", label = "岩石重击" },
    WoodHeavyBash = { value = "WoodHeavyBash", label = "木头重击" },
    WoodMediumBash = { value = "WoodMediumBash", label = "木头中击" },
    WoodLightBash = { value = "WoodLightBash", label = "木头轻击" },
}

-- 移动类型
CONST_MOVE_TYPE = {
    [""] = { value = "", label = "没有" },
    foot = { value = "foot", label = "步行" },
    horse = { value = "horse", label = "坐骑" },
    fly = { value = "fly", label = "飞行" },
    hover = { value = "hover", label = "浮空" },
    float = { value = "float", label = "漂浮" },
    amph = { value = "amph", label = "两栖" },
}


-- 装甲类型
CONST_ARMOR_TYPE = {
    Metal = { value = "Metal", label = "金属" },
    Ethereal = { value = "Ethereal", label = "气态" },
    Flesh = { value = "Flesh", label = "肉体" },
    Wood = { value = "Wood", label = "木头" },
    Stone = { value = "Stone", label = "石头" },
}