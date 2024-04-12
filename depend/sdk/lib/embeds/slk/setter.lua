function F6V_A(v)
    v._class = "ability"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "ANcl"
    end
    if (v.Name == nil) then
        v.Name = description.abilityName(v)
    end
    if (v.levels == nil) then
        v.levels = 1
    end
    if (v.Hotkey ~= nil) then
        v.Buttonpos_1 = v.Buttonpos_1 or CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos_1 or 0
        v.Buttonpos_2 = v.Buttonpos_2 or CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos_2 or 0
        if (v.hero == 1) then
            v.ResearchArt = v.ResearchArt or v.Art
            v.ResearchHotkey = v.ResearchHotkey or v.Hotkey
            v.Researchbuttonpos_1 = v.Researchbuttonpos_1 or v.Buttonpos_1
            v.Researchbuttonpos_2 = v.Researchbuttonpos_2 or v.Buttonpos_2
        end
    end
    if (v.hero == 1) then
        v.Researchtip = description.abilityResearchtip(v)
        v.Researchubertip = description.abilityResearchubertip(v)
    end
    v.Tip = description.abilityTip(v)
    v.Ubertip = description.abilityUbertip(v)
    return v
end

function F6V_U(v)
    v._class = "unit"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "nfrp"
    end
    if (v._type == "hero") then
        v.Name = description.heroName(v)
    else
        v.Name = description.unitName(v)
    end
    if (v.Hotkey ~= nil) then
        v.Buttonpos_1 = v.Buttonpos_1 or CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos_1 or 0
        v.Buttonpos_2 = v.Buttonpos_2 or CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos_2 or 0
    else
        v.Buttonpos_1 = v.Buttonpos_1 or 0
        v.Buttonpos_2 = v.Buttonpos_2 or 0
    end
    v.goldcost = v.goldcost or 0
    v.lumbercost = v.lumbercost or 0
    v.fmade = v.fmade or 0
    v.fused = v.fused or 0
    v.regenMana = v.regenMana or 0
    v.regenHP = v.regenHP or 0
    v.regenType = v.regenType or "none"
    local targs1 = v.targs1 or "vulnerable,ground,ward,structure,organic,mechanical,debris,air" --攻击目标
    if (v.weapTp1 ~= nil) then
        if (v.weapTp1 ~= "normal") then
            v.weapType1 = "" --攻击声音
            v.Missileart_1 = v.Missileart_1 -- 箭矢模型
            v.Missilespeed_1 = v.Missilespeed_1 or 900 -- 箭矢速度
            v.Missilearc_1 = v.Missilearc_1 or 0.10
        end
        if (v.weapTp1 == "normal") then
            v.Missileart_1 = ""
            v.Missilespeed_1 = 0
            v.Missilearc_1 = 0
        elseif (v.weapTp1 == "msplash" or v.weapTp1 == "artillery") then
            --溅射/炮火
            v.Farea1 = v.Farea1 or 1
            v.Qfact1 = v.Qfact1 or 0.05
            v.Qarea1 = v.Qarea1 or 500
            v.Hfact1 = v.Hfact1 or 0.15
            v.Harea1 = v.Harea1 or 350
            v.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mbounce") then
            --弹射
            v.Farea1 = v.Farea1 or 450
            v.targCount1 = v.targCount1 or 4
            v.damageLoss1 = v.damageLoss1 or 0.3
            v.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mline") then
            --穿透
            v.spillRadius1 = v.spillRadius1 or 300
            v.spillDist1 = v.spillDist1 or 450
            v.damageLoss1 = v.damageLoss1 or 0.3
            v.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "aline") then
            --炮火穿透
            v.Farea1 = v.Farea1 or 1
            v.Qfact1 = v.Qfact1 or 0.05
            v.Qarea1 = v.Qarea1 or 500
            v.Hfact1 = v.Hfact1 or 0.15
            v.Harea1 = v.Harea1 or 350
            v.spillRadius1 = v.spillRadius1 or 300
            v.spillDist1 = v.spillDist1 or 450
            v.damageLoss1 = v.damageLoss1 or 0.3
            v.splashTargs1 = targs1 .. ",enemies"
        end
    end
    local targs2 = v.targs2 or "vulnerable,ground,ward,structure,organic,mechanical,debris,air" --攻击目标
    if (v.weapTp2 ~= nil) then
        if (v.weapTp2 ~= "normal") then
            v.weapType2 = "" --攻击声音
            v.Missileart_2 = v.Missileart_2 -- 箭矢模型
            v.Missilespeed_2 = v.Missilespeed_2 or 900 -- 箭矢速度
            v.Missilearc_2 = v.Missilearc_2 or 0.10
        end
        if (v.weapTp2 == "normal") then
            v.Missileart_2 = ""
            v.Missilespeed_2 = 0
            v.Missilearc_2 = 0
        elseif (v.weapTp2 == "msplash" or v.weapTp2 == "artillery") then
            --溅射/炮火
            v.Farea2 = v.Farea2 or 1
            v.Qfact2 = v.Qfact2 or 0.05
            v.Qarea2 = v.Qarea2 or 500
            v.Hfact2 = v.Hfact2 or 0.15
            v.Harea2 = v.Harea2 or 350
            v.splashTargs2 = targs2 .. ",enemies"
        elseif (v.weapTp2 == "mbounce") then
            --弹射
            v.Farea2 = v.Farea2 or 450
            v.targCount2 = v.targCount2 or 4
            v.damageLoss2 = v.damageLoss2 or 0.3
            v.splashTargs2 = targs2 .. ",enemies"
        elseif (v.weapTp2 == "mline") then
            --穿透
            v.spillRadius2 = v.spillRadius2 or 300
            v.spillDist2 = v.spillDist2 or 450
            v.damageLoss2 = v.damageLoss2 or 0.3
            v.splashTargs2 = targs2 .. ",enemies"
        elseif (v.weapTp2 == "aline") then
            --炮火穿透
            v.Farea2 = v.Farea2 or 1
            v.Qfact2 = v.Qfact2 or 0.05
            v.Qarea2 = v.Qarea2 or 500
            v.Hfact2 = v.Hfact2 or 0.15
            v.Harea2 = v.Harea2 or 350
            v.spillRadius2 = v.spillRadius2 or 300
            v.spillDist2 = v.spillDist2 or 450
            v.damageLoss2 = v.damageLoss2 or 0.3
            v.splashTargs2 = targs2 .. ",enemies"
        end
    end
    if (v.Propernames ~= nil) then
        v.nameCount = #string.explode(',', v.Propernames)
    end
    if (v._type == "hero") then
        v.Primary = v.Primary or "STR"
        v.STR = v.STR or 10
        v.AGI = v.AGI or 10
        v.INT = v.INT or 10
        v.STRplus = v.STRplus or 1
        v.AGIplus = v.AGIplus or 1
        v.INTplus = v.INTplus or 1
        v.Tip = description.heroTip(v)
        v.Ubertip = description.heroUbertip(v)
    else
        v.Tip = description.unitTip(v)
        v.Ubertip = description.unitUbertip(v)
    end
    return v
end

function F6V_I_CD(v)
    if (v._cooldown < 0) then
        v._cooldown = 0
    end
    local adTips = "H_LUA_ICD_" .. v.Name
    local cdID
    local ad = {
        Effectsound = "",
        Name = adTips,
        Tip = adTips,
        Ubertip = adTips,
        TargetArt = v.TargetArt or "",
        Targetattach = v.Targetattach or "",
        Animnames = v.Animnames or "spell",
        CasterArt = v.CasterArt or "",
        Art = "",
        unArt = "",
        item = 1,
        hero = 0,
        Requires = "",
        Hotkey = "",
        Buttonpos_1 = 0,
        Buttonpos_2 = 0,
        race = "other",
        Cast = v.Cast or { v._cast or 0 },
        Cost = v.Cost or { v._cost or 0 },
        Cool = { v._cooldown },
    }
    if (v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版 照明弹）
        ad._parent = "Afla"
        ad.DataA = { 0 }
        ad.EfctID = { "" }
        ad.Dur = { 0.01 }
        ad.HeroDur = { 0.01 }
        ad.Rng = v.Rng or { 600 }
        ad.Area = { 0 }
        ad.DataA = { 0 }
        ad.DataB = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版 暴风雪）
        ad._parent = "ACbz"
        ad.BuffID = { "" }
        ad.EfctID = { "" }
        ad.Rng = v.Rng or { 300 }
        ad.Area = v.Area or { 300 }
        ad.DataA = { 0 }
        ad.DataB = { 0 }
        ad.DataC = { 0 }
        ad.DataD = { 0 }
        ad.DataE = { 0 }
        ad.DataF = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版 残废）
        ad._parent = "ACcr"
        ad.levels = 1
        ad.targs = v.targs or { "air,ground,organic,enemy,neutral" }
        ad.Rng = v.Rng or { 800 }
        ad.Area = v.Area or { 0 }
        ad.BuffID = { "" }
        ad.Dur = { 0.01 }
        ad.HeroDur = { 0.01 }
        ad.DataA = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版 金箱子）
        ad._parent = "AIgo"
        ad.DataA = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

function F6V_I(v)
    v._class = "item"
    v._type = v._type or "common"
    if (v._cooldown ~= nil) then
        local cd = F6V_I_CD(v)
        v.abilList = cd
        v.cooldownID = cd
        v.usable = 1
        if (v.powerup == 1) then
            v.class = "PowerUp"
        elseif (v.perishable == 1) then
            v.class = "Charged"
        end
    end
    if (v._parent == nil) then
        v.abilList = v.abilList or ""
        if (v.class == "Charged") then
            v._parent = "hlst"
        elseif (v.class == "PowerUp") then
            v._parent = "gold"
        else
            v._parent = "rat9"
        end
    end
    v.Name = description.itemName(v)
    if (v.file == nil) then
        if (v.class == "PowerUp") then
            v.file = "Objects\\InventoryItems\\tomeRed\\tomeRed.mdl"
        else
            v.file = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        end
    end
    if (v.uses == nil) then
        v.uses = 0
    end
    if (v.goldcost == nil) then
        v.goldcost = 1000000
    end
    if (v.lumbercost == nil) then
        v.lumbercost = 0
    end
    if (v.Level == nil) then
        v.Level = math.floor((v.goldcost + v.lumbercost) / 500)
    end
    if (v.oldLevel == nil) then
        v.oldLevel = v.Level
    end
    if (v.Hotkey ~= nil) then
        v.Buttonpos_1 = v.Buttonpos_1 or CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos_1 or 0
        v.Buttonpos_2 = v.Buttonpos_2 or CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos_2 or 0
    else
        v.Buttonpos_1 = v.Buttonpos_1 or 0
        v.Buttonpos_2 = v.Buttonpos_2 or 0
    end
    v.Tip = description.itemTip(v)
    v.Description = description.itemDescription(v)
    v.Ubertip = description.itemUbertip(v)
    return v
end

function F6V_B(v)
    v._class = "buff"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "BHtc"
    end
    v.EditorName = description.buffEditorName(v)
    v.Bufftip = description.buffTip(v)
    v.Buffubertip = description.buffUbertip(v)
    return v
end

function F6V_UP(v)
    v._class = "upgrade"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "Rhme"
    end
    v.EditorName = description.upgradeName(v)
    v.Ubertip = description.upgradeUbertip(v)
    return v
end

function F6V_DE(v)
    v._class = "destructable"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "BTrs"
    end
    return v
end

function F6V_DO(v)
    v._class = "doodad"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "DOtp"
    end
    return v
end