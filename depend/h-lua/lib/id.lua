HL_ID = {}
HL_ID_INIT = function()
    HL_ID = {
        buff_swim = string.char2id("BPSE"), -- 默认眩晕状态
        unit_token = string.char2id(hslk.n2i("H_LUA_UNIT_TOKEN")),
        unit_token_leap = string.char2id(hslk.n2i("H_LUA_UNIT_TOKEN_LEAP")), --leap的token模式，需导入模型：https://github.com/hunzsig-warcraft3/assets-models/blob/master/interface/interface_token.mdx
        ability_invulnerable = string.char2id("Avul"), -- 默认无敌技能
        ability_item_slot = string.char2id("AInv"), -- 默认物品栏技能（英雄6格那个）默认全部认定这个技能为物品栏，如有需要自行更改
        ability_locust = string.char2id("Aloc"), -- 蝗虫技能
        ability_break = {}, --眩晕[0.05~0.5]
        ability_swim_un_limit = string.char2id(hslk.n2i("H_LUA_ABILITY_SWIM_UN_LIMIT")),
        ability_invisible = string.char2id(hslk.n2i("H_LUA_ABILITY_INVISIBLE")),
        ability_select_hero = string.char2id(hslk.n2i("H_LUA_ABILITY_SELECT_HERO")),
        texture_alert_circle_exclamation = string.char2id(hslk.n2i("H_LUA_TEXTURE_ALERT_CIRCLE_EXCLAMATION")), --- 警示圈模型!
        texture_alert_circle_x = string.char2id(hslk.n2i("H_LUA_TEXTURE_ALERT_CIRCLE_X")), --- 警示圈模型X
        hero_view_token = string.char2id(hslk.n2i("H_LUA_HERO_VIEW_TOKEN")),
        hero_tavern_token = string.char2id(hslk.n2i("　英雄酒馆　")),
        hero_death_token = string.char2id(hslk.n2i("H_LUA_HERO_DEATH_TOKEN")),
        japi_delay = string.char2id(hslk.n2i("H_LUA_JAPI_DELAY")),
        item_fleeting = {
            gold = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_GOLD")), -- 默认金币（模型）
            lumber = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_LUMBER")), -- 默认木头
            book_yellow = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_BOOK_YELLOW")), -- 技能书系列
            book_green = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_BOOK_GREEN")),
            book_purple = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_BOOK_PURPLE")),
            book_blue = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_BOOK_BLUE")),
            book_red = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_BOOK_RED")),
            rune = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_RUNE")), -- 神符（紫色符文）
            relief = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_RELIEF")), -- 浮雕（橙色像块炭）
            egg = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_EGG")), -- 蛋
            fragment = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_FRAGMENT")), -- 碎片（蓝色石头）
            question = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_QUESTION")), -- 问号
            grass = string.char2id(hslk.n2i("H_LUA_ITEM_FLEETING_GRASS")), -- 荧光草
        },
        --- 环境装饰
        env = {
            --- 地表纹理
            ground = {
                summer = string.char2id("Lgrs"), -- 洛丹伦 - 夏 - 草地
                autumn = string.char2id("LTlt"), -- 洛丹伦 - 秋 - 草地
                winter = string.char2id("Iice"), -- 冰封王座 - 冰
                winterDeep = string.char2id("Iice"), -- 冰封王座 - 冰
                poor = string.char2id("Ldrt"), -- 洛丹伦 - 夏- 泥土
                ruins = string.char2id("Ldro"), -- 洛丹伦 - 夏- 烂泥土（坑洼的泥土）
                fire = string.char2id("Dlvc"), -- 地下城 - 岩浆碎片
                underground = string.char2id("Clvg"), -- 费尔伍德 - 叶子
                sea = nil, -- 无地表
                dark = nil, -- 无地表
                river = nil, -- 无地表
            },
            -- 可破坏物型
            doodad = {
                block = { string.char2id("LTba") },
                cage = { string.char2id("LOcg") },
                bucket = { string.char2id("LTbr"), string.char2id("LTbx"), string.char2id("LTbs") },
                bucketBrust = { string.char2id("LTex") },
                box = { string.char2id("LTcr") },
                supportColumn = { string.char2id("BTsc") },
                stone = { string.char2id("LTrc") },
                stoneRed = { string.char2id("DTrc") },
                stoneIce = { string.char2id("ITcr") },
                ice = { string.char2id("ITf1"), string.char2id("ITf2"), string.char2id("ITf3"), string.char2id("ITf4") },
                spiderEggs = { string.char2id("DTes") },
                volcano = { string.char2id("Volc") },
                treeSummer = { string.char2id("LTlt") },
                treeAutumn = { string.char2id("FTtw") },
                treeWinter = { string.char2id("WTtw") },
                treeWinterShow = { string.char2id("WTst") },
                treeDark = { string.char2id("NTtw") },
                treeDarkUmbrella = { string.char2id("NTtc") },
                treePoor = { string.char2id("BTtw") },
                treePoorUmbrella = { string.char2id("BTtc") },
                treeRuins = { string.char2id("ZTtw") },
                treeRuinsUmbrella = { string.char2id("ZTtc") },
                treeUnderground = { string.char2id("DTsh"), string.char2id("GTsh") }
            },
            -- 单位模型
            unit_model = {
                fire = string.char2id(hslk.n2i("H_LUA_ENV_FIRE")), -- 火焰
                fireblue = string.char2id(hslk.n2i("H_LUA_ENV_FIREBLUE")), --蓝色火焰
                firetrap = string.char2id(hslk.n2i("H_LUA_ENV_FIRETRAP")), -- 火焰陷阱
                firetrapblue = string.char2id(hslk.n2i("H_LUA_ENV_FIRETRAPBLUE")), -- 蓝色火焰陷阱
                lightningbolt = string.char2id(hslk.n2i("H_LUA_ENV_LIGHTNINGBOLT")), -- 季风闪电
                snowman = string.char2id(hslk.n2i("H_LUA_ENV_SNOWMAN")), -- 雪人
                bubble_geyser = string.char2id(hslk.n2i("H_LUA_ENV_BUBBLE_GEYSER")), -- 泡沫
                bubble_geyser_steam = string.char2id(hslk.n2i("H_LUA_ENV_BUBBLE_GEYSER_STEAM")), -- 带蒸汽泡沫
                fish_school = string.char2id(hslk.n2i("H_LUA_ENV_FISH_SCHOOL")), -- 小鱼群
                fish = string.char2id(hslk.n2i("H_LUA_ENV_FISH")), -- 鱼
                fish_green = string.char2id(hslk.n2i("H_LUA_ENV_FISH_GREEN")), -- 绿色的鱼
                fire_hole = string.char2id(hslk.n2i("H_LUA_ENV_FIRE_HOLE")), -- 火焰弹坑
                bird = string.char2id(hslk.n2i("H_LUA_ENV_BIRD")), -- 鸟
                bats = string.char2id(hslk.n2i("H_LUA_ENV_BATS")), -- 蝙蝠
                flies = string.char2id(hslk.n2i("H_LUA_ENV_FLIES")), -- 苍蝇
                burn_build = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BUILD")), --焚烧毁坏建筑
                ice0 = string.char2id(hslk.n2i("H_LUA_ENV_ICE0")), -- 冰块
                ice1 = string.char2id(hslk.n2i("H_LUA_ENV_ICE1")),
                ice2 = string.char2id(hslk.n2i("H_LUA_ENV_ICE2")),
                ice3 = string.char2id(hslk.n2i("H_LUA_ENV_ICE3")),
                seaweed0 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED0")), -- 海藻
                seaweed1 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED1")),
                seaweed2 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED2")),
                seaweed3 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED3")),
                seaweed4 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED4")),
                break_column0 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN0")), --断裂的圆柱
                break_column1 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN1")),
                break_column2 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN2")),
                break_column3 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN3")),
                burn_body0 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY0")), -- 焚烧尸体
                burn_body1 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY1")),
                burn_body2 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY2")),
                impaled_body0 = string.char2id(hslk.n2i("H_LUA_ENV_IMPALED_BODY0")), -- 叉着的尸体
                impaled_body1 = string.char2id(hslk.n2i("H_LUA_ENV_IMPALED_BODY1")),
                rune0 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE0")), --血色符文
                rune1 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE1")),
                rune2 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE2")),
                rune3 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE3")),
                rune4 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE4")),
                rune5 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE5")),
                rune6 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE6")),
                glowing_rune0 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE0")), --发光符文
                glowing_rune1 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE1")),
                glowing_rune2 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE2")),
                glowing_rune3 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE3")),
                glowing_rune4 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE4")),
                glowing_rune5 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE5")),
                glowing_rune6 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE6")),
                glowing_rune7 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE7")),
                glowing_rune8 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE8")),
                bone0 = string.char2id(hslk.n2i("H_LUA_ENV_BONE0")), -- 岩石
                bone1 = string.char2id(hslk.n2i("H_LUA_ENV_BONE1")),
                bone2 = string.char2id(hslk.n2i("H_LUA_ENV_BONE2")),
                bone3 = string.char2id(hslk.n2i("H_LUA_ENV_BONE3")),
                bone4 = string.char2id(hslk.n2i("H_LUA_ENV_BONE4")),
                bone5 = string.char2id(hslk.n2i("H_LUA_ENV_BONE5")),
                bone6 = string.char2id(hslk.n2i("H_LUA_ENV_BONE6")),
                bone7 = string.char2id(hslk.n2i("H_LUA_ENV_BONE7")),
                bone8 = string.char2id(hslk.n2i("H_LUA_ENV_BONE8")),
                bone9 = string.char2id(hslk.n2i("H_LUA_ENV_BONE9")),
                bone_ice0 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE0")), -- 冬天岩石
                bone_ice1 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE1")),
                bone_ice2 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE2")),
                bone_ice3 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE3")),
                bone_ice4 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE4")),
                bone_ice5 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE5")),
                bone_ice6 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE6")),
                bone_ice7 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE7")),
                bone_ice8 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE8")),
                bone_ice9 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE9")),
                stone0 = string.char2id(hslk.n2i("H_LUA_ENV_STONE0")), -- 岩石2
                stone1 = string.char2id(hslk.n2i("H_LUA_ENV_STONE1")),
                stone2 = string.char2id(hslk.n2i("H_LUA_ENV_STONE2")),
                stone3 = string.char2id(hslk.n2i("H_LUA_ENV_STONE3")),
                stone4 = string.char2id(hslk.n2i("H_LUA_ENV_STONE4")),
                stone5 = string.char2id(hslk.n2i("H_LUA_ENV_STONE5")),
                stone6 = string.char2id(hslk.n2i("H_LUA_ENV_STONE6")),
                stone7 = string.char2id(hslk.n2i("H_LUA_ENV_STONE7")),
                stone8 = string.char2id(hslk.n2i("H_LUA_ENV_STONE8")),
                stone9 = string.char2id(hslk.n2i("H_LUA_ENV_STONE9")),
                stone_show0 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW0")), -- 雪岩石
                stone_show1 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW1")),
                stone_show2 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW2")),
                stone_show3 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW3")),
                stone_show4 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW4")),
                stone_show5 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW5")),
                stone_show6 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW6")),
                stone_show7 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW7")),
                stone_show8 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW8")),
                stone_show9 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW9")),
                mushroom0 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM0")), -- 蘑菇
                mushroom1 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM1")),
                mushroom2 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM2")),
                mushroom3 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM3")),
                mushroom4 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM4")),
                mushroom5 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM5")),
                mushroom6 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM6")),
                mushroom7 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM7")),
                mushroom8 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM8")),
                mushroom9 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM9")),
                mushroom10 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM10")),
                mushroom11 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM11")),
                flower0 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER0")), -- 鲜花
                flower1 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER1")),
                flower2 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER2")),
                flower3 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER3")),
                flower4 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER4")),
                typha0 = string.char2id(hslk.n2i("H_LUA_ENV_TYPHA0")), -- 香蒲
                typha1 = string.char2id(hslk.n2i("H_LUA_ENV_TYPHA1")),
                lilypad0 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD0")), -- 睡莲
                lilypad1 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD1")),
                lilypad2 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD2")),
                coral0 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL0")), -- 珊瑚
                coral1 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL1")),
                coral2 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL2")),
                coral3 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL3")),
                coral4 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL4")),
                coral5 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL5")),
                coral6 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL6")),
                coral7 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL7")),
                coral8 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL8")),
                coral9 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL9")),
                shells0 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS0")), -- 贝壳
                shells1 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS1")),
                shells2 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS2")),
                shells3 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS3")),
                shells4 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS4")),
                shells5 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS5")),
                shells6 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS6")),
                shells7 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS7")),
                shells8 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS8")),
                shells9 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS9")),
                skull_pile0 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE0")), -- 头骨
                skull_pile1 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE1")),
                skull_pile2 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE2")),
                skull_pile3 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE3")),
                river_rushes0 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES0")), -- 河草
                river_rushes1 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES1")),
                river_rushes2 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES2")),
                river_rushes3 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES3")),
            },
        },
        str_green = {
            add = {},
            sub = {}
        },
        agi_green = {
            add = {},
            sub = {}
        },
        int_green = {
            add = {},
            sub = {}
        },
        attack_green = {
            add = {},
            sub = {}
        },
        attack_white = {
            add = {},
            sub = {}
        },
        item_attack_white = {
            add = {},
            sub = {},
            items = {},
        },
        attack_speed = {
            add = {},
            sub = {}
        },
        defend = {
            add = {},
            sub = {}
        },
        life = {
            add = {},
            sub = {}
        },
        mana = {
            add = {},
            sub = {}
        },
        avoid = {
            add = 0,
            sub = 0
        },
        sight = {
            add = {},
            sub = {}
        },
        ablis_gradient = {},
        sight_gradient = {}
    }

    -- 眩晕[0.05-0.5]
    for during = 1, 10, 1 do
        local swDur = during * 0.05
        HL_ID.ability_break[swDur] = string.char2id(hslk.n2i("H_LUA_ABILITY_BREAK_" .. swDur))
    end
    -- 属性系统
    for i = 1, 9 do
        local v = math.floor(10 ^ (i - 1))
        table.insert(HL_ID.ablis_gradient, v)
        HL_ID.str_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_ADD_" .. v))
        HL_ID.str_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_SUB_" .. v))
        HL_ID.agi_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_ADD_" .. v))
        HL_ID.agi_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_SUB_" .. v))
        HL_ID.int_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_ADD_" .. v))
        HL_ID.int_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_SUB_" .. v))
        HL_ID.attack_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_ADD_" .. v))
        HL_ID.attack_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_SUB_" .. v))
        HL_ID.attack_white.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_W_ADD_" .. v))
        HL_ID.attack_white.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_W_SUB_" .. v))
        HL_ID.item_attack_white.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_IT_W_ADD_" .. v))
        HL_ID.item_attack_white.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_IT_W_SUB_" .. v))
        table.insert(HL_ID.item_attack_white.items, HL_ID.item_attack_white.add[v])
        table.insert(HL_ID.item_attack_white.items, HL_ID.item_attack_white.sub[v])
        HL_ID.attack_speed.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_SPD_ADD_" .. v))
        HL_ID.attack_speed.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_SPD_SUB_" .. v))
        HL_ID.defend.add[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_ADD_" .. v))
        HL_ID.defend.sub[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_SUB_" .. v))
        HL_ID.life.add[v] = string.char2id(hslk.n2i("H_LUA_A_LIFE_ADD_" .. v))
        HL_ID.life.sub[v] = string.char2id(hslk.n2i("H_LUA_A_LIFE_SUB_" .. v))
        HL_ID.mana.add[v] = string.char2id(hslk.n2i("H_LUA_A_MANA_ADD_" .. v))
        HL_ID.mana.sub[v] = string.char2id(hslk.n2i("H_LUA_A_MANA_SUB_" .. v))
    end
    -- 属性系统 回避
    HL_ID.avoid.add = string.char2id(hslk.n2i("H_LUA_A_AVOID_ADD"))
    HL_ID.avoid.sub = string.char2id(hslk.n2i("H_LUA_A_AVOID_SUB"))
    -- 属性系统 视野
    local sightBase = { 1, 2, 3, 4, 5 }
    local si = 1
    while (si <= 10000) do
        for _, v in ipairs(sightBase) do
            v = math.floor(v * si)
            table.insert(HL_ID.sight_gradient, v)
            HL_ID.sight.add[v] = string.char2id(hslk.n2i("H_LUA_A_SIGHT_ADD_" .. v))
            HL_ID.sight.sub[v] = string.char2id(hslk.n2i("H_LUA_A_SIGHT_SUB_" .. v))
        end
        si = si * 10
    end
    table.sort(HL_ID.sight_gradient, function(a, b)
        return a > b
    end)
end