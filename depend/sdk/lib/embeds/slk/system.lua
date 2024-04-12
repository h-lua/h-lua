--- #单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_UNIT_TOKEN",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = ".mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    movetp = "fly",
    moveHeight = 25.00,
    spd = 522,
    turnRate = 3.00,
    moveFloor = 25.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 0,
    nsight = 0,
    Builds = "",
    upgrades = "",
})

--- #冲击单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_UNIT_TOKEN_LEAP",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "hLua\\token.mdx",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 1.00,
    movetp = "fly",
    moveHeight = 0.00,
    moveFloor = 0.00,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
})

--- #模型漂浮字单位 token
hslk_unit({
    _parent = "ogru",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_UNIT_TOKEN_TTG",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "hLua\\token.mdx",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 1.00,
    movetp = "fly",
    moveHeight = 150,
    moveFloor = 150,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
    maxPitch = 0,
    maxRoll = 0,
})

--- #选择英雄技能
H_LUA_ABILITY_SELECT_HERO = hslk_ability({
    _parent = "Aneu",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_ABILITY_SELECT_HERO",
    DataA = { 1000.00 },
    DataB = { 4 },
    DataC = { 0 },
    DataD = { 0 },
    Rng = { 900.00 },
})._id

--- #英雄视野 view
hslk_unit({
    _parent = "ogru",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_HERO_VIEW_TOKEN",
    special = 1,
    abilList = "Avul,AInv",
    upgrade = "",
    collision = 0.00,
    file = ".mdl",
    unitShadow = "",
    Art = "",
    movetp = "fly",
    moveHeight = 25.00,
    spd = 522,
    turnRate = 3.00,
    moveFloor = 25.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 1250,
    nsight = 1250,
    Builds = "",
    upgrades = "",
})

--- #英雄酒馆演示 tavern
hslk_unit({
    _parent = "ntav",
    _type = "system",
    EditorSuffix = "#h-lua:H_LUA_HERO_TAVERN_TOKEN",
    Name = "　英雄酒馆　",
    Ubertip = "一间酒香四溢的酒馆，因而引来各路英雄",
    abilList = "Avul,Asud," .. H_LUA_ABILITY_SELECT_HERO,
    Sellunits = "",
    pathTex = "",
    collision = "",
    modelScale = 0.80,
    scale = 2.80,
    uberSplat = "",
    teamColor = 12,
})

--- #英雄死亡标志
hslk_unit({
    _parent = "nfrp",
    _type = "system",
    Name = "H_LUA_HERO_DEATH_TOKEN",
    tilesets = "*",
    special = 1,
    hostilePal = 0,
    abilList = "Avul,Aloc",
    upgrade = "",
    collision = 0.00,
    unitSound = 0.00,
    modelScale = 0.75,
    scale = 0.75,
    file = "hLua\\clock_rune.mdl",
    red = 255,
    blue = 255,
    green = 255,
    maxPitch = 0.00,
    maxRoll = 0.00,
    impactZ = 0.00,
    unitShadow = "",
    Art = "",
    movetp = "fly",
    spd = 0,
    turnRate = 3.00,
    moveFloor = -25,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
})

--- #JAPI_DELAY
hslk_ability({
    _parent = "Aamk",
    _type = "system",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_JAPI_DELAY",
    Art = "",
    hero = 0,
    race = "other",
    item = 1,
    levels = 1,
    DataA = { 0 },
    DataB = { 0 },
    DataC = { 0 },
    DataD = { 1 },
})

--- #属性系统
for i = 1, 9 do
    local val = math.floor(10 ^ (i - 1))
    local Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, 0)
        table.insert(Data.B, 0)
        table.insert(Data.C, 1 * val * j)
        table.insert(Data.D, 1)
    end
    -- #力量绿+
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_STR_G_ADD_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #力量绿-
    Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, 0)
        table.insert(Data.B, 0)
        table.insert(Data.C, -1 * val * j)
        table.insert(Data.D, 1)
    end
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_STR_G_SUB_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #敏捷绿+
    Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, 1 * val * j)
        table.insert(Data.B, 0)
        table.insert(Data.C, 0)
        table.insert(Data.D, 1)
    end
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_AGI_G_ADD_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #敏捷绿-
    Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, -1 * val * j)
        table.insert(Data.B, 0)
        table.insert(Data.C, 0)
        table.insert(Data.D, 1)
    end
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_AGI_G_SUB_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #智力绿+
    Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, 0)
        table.insert(Data.B, 1 * val * j)
        table.insert(Data.C, 0)
        table.insert(Data.D, 1)
    end
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_INT_G_ADD_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #智力绿-
    Data = { A = {}, B = {}, C = {}, D = {} }
    for j = 0, 9 do
        table.insert(Data.A, 0)
        table.insert(Data.B, -1 * val * j)
        table.insert(Data.C, 0)
        table.insert(Data.D, 1)
    end
    hslk_ability({
        _parent = "Aamk",
        _type = "system",
        Name = "H_LUA_A_INT_G_SUB_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        hero = 0,
        race = "other",
        item = 1,
        levels = 10,
        DataA = Data.A,
        DataB = Data.B,
        DataC = Data.C,
        DataD = Data.D,
    })
    -- #攻击力绿+
    Data = { A = {} }
    for j = 0, 9 do
        table.insert(Data.A, 1 * val * j)
    end
    hslk_ability({
        _parent = "AItg",
        _type = "system",
        Name = "H_LUA_A_ACK_G_ADD_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        levels = 10,
        DataA = Data.A,
    })
    Data = { A = {} }
    for j = 0, 9 do
        table.insert(Data.A, -1 * val * j)
    end
    hslk_ability({
        _parent = "AItg",
        _type = "system",
        Name = "H_LUA_A_ACK_G_SUB_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        levels = 10,
        DataA = Data.A,
    })
    -- #护甲绿+
    Data = { A = {} }
    for j = 0, 9 do
        table.insert(Data.A, 1 * val * j)
    end
    hslk_ability({
        _parent = "AId1",
        _type = "system",
        Name = "H_LUA_A_DEF_ADD_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        levels = 10,
        DataA = Data.A,
    })
    -- #护甲绿-
    Data = { A = {} }
    for j = 0, 9 do
        table.insert(Data.A, -1 * val * j)
    end
    hslk_ability({
        _parent = "AId1",
        _type = "system",
        Name = "H_LUA_A_DEF_SUB_" .. val,
        EditorSuffix = "#h-lua",
        Art = "",
        levels = 10,
        DataA = Data.A,
    })
end