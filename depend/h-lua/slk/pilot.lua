---@alias noteHslk {_id_force:string,_class:string,_type:string,_parent:string}
---@alias noteHslkAbility {_desc,_attr,_remarks,_lv}
---@alias noteHslkItem {_attr:table,_remarks,_cooldown,_cooldownTarget}
---@alias noteHslkUnit {_attr:table}

---@alias note_Ability noteHslk|{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area}
---@param _v note_Ability
---@return table
function _ability(_v)
    return _v
end

---@alias note_Item noteHslk|noteHslkItem|{abilList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos_1,Buttonpos_2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,cooldownID,ignoreCD,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable}
---@param _v note_Item
---@return table
function _item(_v)
    return _v
end

---@alias note_Unit noteHslk|noteHslkUnit|{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep}
---@param _v note_Unit
---@return table
function _unit(_v)
    return _v
end

---@alias note_Buff noteHslk|{Effectsound,Effectsoundlooped,EditorSuffix,EditorName,Bufftip,Buffubertip,Buffart,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,EffectArt,Effectattach,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,LightningEffect,Missilearc_1,MissileHoming_1,Spelldetail,isEffect,race}
---@param _v note_Buff
---@return table
function _buff(_v)
    return _v
end

---@alias note_Upgrade {Requires,Requiresamount,effect,EditorSuffix,Name,Hotkey,Tip,Ubertip,Buttonpos_1,Buttonpos_2,Art,maxlevel,race,goldbase,lumberbase,timebase,goldmod,lumbermod,timemod,class,inherit,global}
---@param _v note_Upgrade
---@return table
function _upgrade(_v)
    return _v
end

---@alias note_Destructable {EditorSuffix,HP,InBeta,MMBlue,MMGreen,MMRed,Name,armor,buildTime,canPlaceDead,canPlaceRandScale,category,cliffHeight,code,colorB,colorG,colorR,comment,deathSnd,doodClass,fatLOS,file,fixedRot,flyH,fogRadius,fogVis,goldRep,lightweight,lumberRep,maxPitch,maxRoll,maxScale,minScale,numVar,occH,onCliffs,onWater,pathTex,pathTexDeath,portraitmodel,radius,repairTime,selSize,selcircsize,selectable,shadow,showInMM,targType,texFile,texID,tilesetSpecific,tilesets,useClickHelper,useMMColor,version,walkable}
---@param _v note_Destructable
---@return table
function _destructable(_v)
    return _v
end

---@alias note_Doodad {InBeta,MMBlue,MMGreen,MMRed,Name,animInFog,canPlaceRandScale,category,code,comment,defScale,doodClass,file,fixedRot,floats,ignoreModelClick,maxPitch,maxRoll,maxScale,minScale,numVar,onCliffs,onWater,pathTex,selSize,shadow,showInFog,showInMM,soundLoop,tilesetSpecific,tilesets,useClickHelper,useMMColor,version,vertB01,vertB02,vertB03,vertB04,vertB05,vertB06,vertB07,vertB08,vertB09,vertB10,vertG01,vertG02,vertG03,vertG04,vertG05,vertG06,vertG07,vertG08,vertG09,vertG10,vertR01,vertR02,vertR03,vertR04,vertR05,vertR06,vertR07,vertR08,vertR09,vertR10,visRadius,walkable}
---@param _v note_Doodad
---@return table
function _doodad(_v)
    return _v
end

---@alias note_Attr {disabled}|noteAttr
---@param _v note_Attr
---@return table
function _attr(_v)
    return _v
end