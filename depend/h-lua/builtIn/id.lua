HL_ID = {}
HL_ID_INIT = function()
    HL_ID = {
        unit_token = c2i(hslk.n2i("H_LUA_UNIT_TOKEN")),
        unit_token_leap = c2i(hslk.n2i("H_LUA_UNIT_TOKEN_LEAP")), --leap的token模式，需导入模型：SDK/hLua/token.mdx
        unit_token_ttg = c2i(hslk.n2i("H_LUA_UNIT_TOKEN_TTG")), --leap的token模式，需导入模型：SDK/hLua/token.mdx
        ability_invulnerable = c2i("Avul"), -- 默认无敌技能
        ability_item_slot = c2i("AInv"), -- 默认物品栏技能（英雄6格那个）默认全部认定这个技能为物品栏，如有需要自行更改
        ability_locust = c2i("Aloc"), -- 蝗虫技能
        ability_select_hero = c2i(hslk.n2i("H_LUA_ABILITY_SELECT_HERO")),
        hero_view_token = c2i(hslk.n2i("H_LUA_HERO_VIEW_TOKEN")),
        hero_tavern_token = c2i(hslk.n2i("　英雄酒馆　")),
        hero_death_token = c2i(hslk.n2i("H_LUA_HERO_DEATH_TOKEN")),
        japi_delay = c2i(hslk.n2i("H_LUA_JAPI_DELAY")),
        --
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
        defend = {
            add = {},
            sub = {}
        },
        ablis_gradient = {},
    }
    -- 属性系统
    for i = 1, 9 do
        local v = math.floor(10 ^ (i - 1))
        table.insert(HL_ID.ablis_gradient, v)
        HL_ID.str_green.add[v] = c2i(hslk.n2i("H_LUA_A_STR_G_ADD_" .. v))
        HL_ID.str_green.sub[v] = c2i(hslk.n2i("H_LUA_A_STR_G_SUB_" .. v))
        HL_ID.agi_green.add[v] = c2i(hslk.n2i("H_LUA_A_AGI_G_ADD_" .. v))
        HL_ID.agi_green.sub[v] = c2i(hslk.n2i("H_LUA_A_AGI_G_SUB_" .. v))
        HL_ID.int_green.add[v] = c2i(hslk.n2i("H_LUA_A_INT_G_ADD_" .. v))
        HL_ID.int_green.sub[v] = c2i(hslk.n2i("H_LUA_A_INT_G_SUB_" .. v))
        HL_ID.attack_green.add[v] = c2i(hslk.n2i("H_LUA_A_ACK_G_ADD_" .. v))
        HL_ID.attack_green.sub[v] = c2i(hslk.n2i("H_LUA_A_ACK_G_SUB_" .. v))
        HL_ID.defend.add[v] = c2i(hslk.n2i("H_LUA_A_DEF_ADD_" .. v))
        HL_ID.defend.sub[v] = c2i(hslk.n2i("H_LUA_A_DEF_SUB_" .. v))
    end
end