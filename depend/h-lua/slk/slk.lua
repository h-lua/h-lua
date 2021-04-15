--- cli 构造的数据
local jass_slk = nil
local hslk_cli_ids = {}
local hslk_cli_synthesis = {}
HSLK_CLI_H_IDI = 1
HSLK_CLI_H_IDS = {}
HSLK_CLI_DATA = {}
HSLK_I2V = {}
HSLK_N2V = {}
HSLK_N2I = {}
HSLK_ICD = {}
HSLK_CLASS_IDS = {}
HSLK_TYPE_IDS = {}
HSLK_SYNTHESIS = {
    profit = {},
    fragment = {},
    fragmentNeeds = {},
}
HSLK_MISC = {}

hslk_init = function()
    if (jass_slk == nil) then
        jass_slk = require "jass.slk"
    end
    -- 载入平衡常数数据
    HSLK_MISC = jass_slk.misc
    -- 处理物编数据
    if (#hslk_cli_ids > 0) then
        for _, id in ipairs(hslk_cli_ids) do
            HSLK_I2V[id] = HSLK_CLI_DATA[id] or {}
            HSLK_I2V[id]._type = HSLK_I2V[id]._type or "slk"
            if (jass_slk.item[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "item"
                HSLK_I2V[id].slk = jass_slk.item[id]
                if (HSLK_I2V[id].slk.cooldownID) then
                    HSLK_ICD[HSLK_I2V[id].slk.cooldownID] = HSLK_I2V[id]._id
                end
            elseif (jass_slk.unit[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "unit"
                HSLK_I2V[id].slk = jass_slk.unit[id]
            elseif (jass_slk.ability[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "ability"
                HSLK_I2V[id].slk = jass_slk.ability[id]
            elseif (jass_slk.buff[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "buff"
                HSLK_I2V[id].slk = jass_slk.buff[id]
            elseif (jass_slk.upgrade[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "upgrade"
                HSLK_I2V[id].slk = jass_slk.upgrade[id]
            end
            -- 处理_class
            if (HSLK_I2V[id]._class) then
                if (HSLK_CLASS_IDS[HSLK_I2V[id]._class] == nil) then
                    HSLK_CLASS_IDS[HSLK_I2V[id]._class] = {}
                end
                table.insert(HSLK_CLASS_IDS[HSLK_I2V[id]._class], id)
            end
            -- 处理_type
            if (HSLK_I2V[id]._type) then
                if (HSLK_TYPE_IDS[HSLK_I2V[id]._type] == nil) then
                    HSLK_TYPE_IDS[HSLK_I2V[id]._type] = {}
                end
                table.insert(HSLK_TYPE_IDS[HSLK_I2V[id]._type], id)
            end
            -- 处理N2V
            if (HSLK_I2V[id].slk) then
                local n = HSLK_I2V[id].slk.Name
                if (n ~= nil) then
                    if (HSLK_N2V[n] == nil) then
                        HSLK_N2I[n] = {}
                        HSLK_N2V[n] = {}
                    end
                    table.insert(HSLK_N2I[n], id)
                    table.insert(HSLK_N2V[n], HSLK_I2V[id])
                end
            end
        end
    end
    -- 处理合成公式
    if (#hslk_cli_synthesis > 0) then
        for _, data in ipairs(hslk_cli_synthesis) do
            -- 数据格式化
            -- 碎片名称转ID
            local jsonFragment = {}
            for k, v in ipairs(data.fragment) do
                data.fragment[k][2] = math.floor(v[2])
                local fragmentId = HSLK_N2V[v[1]][1]._id or nil
                if (fragmentId ~= nil) then
                    table.insert(jsonFragment, { fragmentId, v[2] })
                end
            end
            local profitId = HSLK_N2V[data.profit[1]][1]._id or nil
            if (profitId == nil) then
                return
            end
            if (HSLK_SYNTHESIS.profit[profitId] == nil) then
                HSLK_SYNTHESIS.profit[profitId] = {}
            end
            table.insert(HSLK_SYNTHESIS.profit[profitId], {
                qty = data.profit[2],
                fragment = jsonFragment,
            })
            local profitIndex = #HSLK_SYNTHESIS.profit[profitId]
            for _, f in ipairs(jsonFragment) do
                if (HSLK_SYNTHESIS.fragment[f[1]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]] = {}
                end
                if (HSLK_SYNTHESIS.fragment[f[1]][f[2]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]][f[2]] = {}
                end
                table.insert(HSLK_SYNTHESIS.fragment[f[1]][f[2]], {
                    profit = profitId,
                    index = profitIndex,
                })
                if (table.includes(HSLK_SYNTHESIS.fragmentNeeds, f[2]) == false) then
                    table.insert(HSLK_SYNTHESIS.fragmentNeeds, f[2])
                end
            end
        end
    end
    HL_ID_INIT()
end

local hslk_cli_set = function(_v)
    _v._id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]
    HSLK_CLI_DATA[_v._id] = _v
    HSLK_CLI_H_IDI = HSLK_CLI_H_IDI + 1
    return _v
end

--- 设定配置
---@param conf table 参考 F6_CONF
hslk_conf = function(conf)
end

---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area,_id_force,_class,_type,_parent,_desc,_attr,_ring,_remarks,_lv,_onSkillEffect,_onRing}
hslk_ability = function(_v)
    return hslk_cli_set(F6V_A(_v))
end

---@param _v{Name,Ubertip,Hotkey,Buttonpos_1,Buttonpos_2,Art,_id_force,_class,_type,_parent,_desc,_attr,_ring,_remarks,_lv,_onRing}
hslk_ability_empty = function(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    return hslk_cli_set(F6V_A(_v))
end

---@param _v{Name,Ubertip,Hotkey,Buttonpos_1,Buttonpos_2,Art,_id_force,_class,_type,_parent,_desc,_attr,_ring,_remarks,_lv,_onRing}
hslk_ability_ring = function(_v)
    _v._parent = "Aamk"
    _v._type = "ring"
    return hslk_cli_set(F6V_A(_v))
end

---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
hslk_unit = function(_v)
    return hslk_cli_set(F6V_U(_v))
end

-- 简易英雄
---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
hslk_hero = function(_v)
    _v._parent = "Hpal"
    _v._type = "hero"
    return hslk_cli_set(F6V_U(_v))
end

-- 简易信使
---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
hslk_courier = function(_v)
    _v._parent = "ogru"
    _v._type = "courier"
    F6V_COURIER_SKILL()
    return hslk_cli_set(F6V_U(_v))
end

--- 物品合成公式数组，只支持slkHelper创建的注册物品
---例子1 "小刀割大树=小刀+大树" 2个不一样的合1个
---例子2 "三头地狱犬的神识=地狱狗头x3" 3个一样的合1个
---例子3 "精灵神水x2=精灵的眼泪x50" 50个一样的合一种,但得到2个
---例子4 {{"小刀割大树",1},{"小刀",1},{"大树",1}} 对象型配置，第一项为结果物品(适合物品名称包含特殊字符的物品，如+/=影响公式的符号)
hslk_item_synthesis = function(formula)
    hslk_cli_synthesis = F6V_I_SYNTHESIS(formula)
end

---@param _v{abiList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos_1,Buttonpos_2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,cooldownID,ignoreCD,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable,_id_force,_class,_type,_parent,_overlie,_weight,_attr,_ring,_remarks,_cooldown,_cooldownTarget,_shadow,_onItemUsed,_onRing}
hslk_item = function(_v)
    _v = F6V_I(_v)
    local res
    if (type(_v._shadow) == "boolean" and true == _v._shadow) then
        local _vs = F6V_I_SHADOW(table.clone(_v))
        _v._shadow_id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI + 1]
        _vs._shadow_id = HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]
        res = hslk_cli_set(_v)
        hslk_cli_set(_vs)
    else
        res = hslk_cli_set(_v)
    end
    return res
end

---@param _v{Effectsound,Effectsoundlooped,EditorSuffix,EditorName,Bufftip,Buffubertip,Buffart,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,EffectArt,Effectattach,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,LightningEffect,Missilearc_1,MissileHoming_1,Spelldetail,isEffect,race,_id_force}
hslk_buff = function(_v)
    return hslk_cli_set(F6V_B(_v))
end

---@param _v{Requires,Requiresamount,effect,EditorSuffix,Name,Hotkey,Tip,Ubertip,Buttonpos_1,Buttonpos_2,Art,maxlevel,race,goldbase,lumberbase,timebase,goldmod,lumbermod,timemod,class,inherit,global,_id_force}
hslk_upgrade = function(_v)
    return hslk_cli_set(F6V_UP(_v))
end
