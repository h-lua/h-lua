--- #单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
})

--- #冲击单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
})

--- #模型漂浮字单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
})

--- #选择英雄技能
H_LUA_ABILITY_SELECT_HERO = hslk_ability({
    _parent = "Aneu",
    _type = "system",
})._id

--- #英雄视野 view
hslk_unit({
    _parent = "ogru",
    _type = "system",
})

--- #英雄酒馆演示 tavern
hslk_unit({
    _parent = "ntav",
    _type = "system",
})

--- #英雄死亡标志
hslk_unit({
    _parent = "nban",
    _type = "system",
})

--- #JAPI_DELAY
hslk_ability({
    _parent = "Aamk",
    _type = "system",
})

--- #属性系统
for _ = 1, 9 do
    -- #力量绿+
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #力量绿-
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #敏捷绿+
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #敏捷绿-
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #智力绿+
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #智力绿-
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
    })
    -- #攻击力绿+
    hslk_ability({
        _parent = "AItg",
        _type = "system",
    })
    hslk_ability({
        _parent = "AItg",
        _type = "system",
    })
    -- #护甲绿+
    hslk_ability({
        _parent = "AId1",
        _type = "system",
    })
    -- #护甲绿-
    hslk_ability({
        _parent = "AId1",
        _type = "system",
    })
end