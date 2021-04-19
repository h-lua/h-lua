---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area,_id_force,_class,_type,_parent,_desc,_attr,_ring,_remarks,_lv,_onSkillEffect,_onRing}
_ability = function(_v)
    return _v
end

---@param _v{abiList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos_1,Buttonpos_2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,cooldownID,ignoreCD,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable,_id_force,_class,_type,_parent,_overlie,_weight,_attr,_ring,_remarks,_cooldown,_cooldownTarget,_shadow,_onItemUsed,_onRing}
_item = function(_v)
    return _v
end

---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
_unit = function(_v)
    return _v
end

---@param _v{Effectsound,Effectsoundlooped,EditorSuffix,EditorName,Bufftip,Buffubertip,Buffart,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,EffectArt,Effectattach,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,LightningEffect,Missilearc_1,MissileHoming_1,Spelldetail,isEffect,race,_id_force}
_buff = function(_v)
    return _v
end

---@param _v{Requires,Requiresamount,effect,EditorSuffix,Name,Hotkey,Tip,Ubertip,Buttonpos_1,Buttonpos_2,Art,maxlevel,race,goldbase,lumberbase,timebase,goldmod,lumbermod,timemod,class,inherit,global,_id_force}
_upgrade = function(_v)
    return _v
end

---@alias pilotAttr {disabled,life,mana,move,defend,defend_white,defend_green,attack_speed,attack_space,attack_space_origin,attack,attack_white,attack_green,attack_range,attack_range_acquire,sight,str,agi,int,str_green,agi_green,int_green,str_white,agi_white,int_white,life_back,mana_back,avoid,aim,punish,punish_current,hemophagia,hemophagia_skill,invincible,weight,weight_current,damage_extent,damage_reduction,damage_decrease,damage_rebound,damage_rebound_oppose,cure,reborn,knocking_odds,knocking_extent,knocking_oppose,hemophagia_oppose,hemophagia_skill_oppose,buff_oppose,debuff_oppose,split_oppose,punish_oppose,swim_oppose,broken_oppose,silent_oppose,unarm_oppose,fetter_oppose,bomb_oppose,lightning_chain_oppose,crack_fly_oppose,xtras,gold_ratio,lumber_ratio,exp_ratio,sell_ratio}
---@param _v pilotAttr
_attr = function(_v)
    return _v
end

---@param _v{on,action,val,odds,percent,during,qty,radius,rate,distance,height,lightning_type,effect,effectEnum,damageSrc,damageType}
_xtras = function(_v)
    return _v
end

---@param _v{disabled,effect,effectTarget,attachTarget,radius,target,attr}
_ring = function(_v)
    return _v
end

---@param _v onSkillEffect | "function(evtData) end"
_onSkillEffect = function(_v)
    return _v
end

---@param _v onItemUsed | "function(evtData) end"
_onItemUsed = function(_v)
    return _v
end

---@alias _onRing fun(evtData: {triggerUnit:"光环中心单位",enumUnit:"作用光环内选取单位"}):void
---@param _v _onRing | "function(evtData) end"
_onRing = function(_v)
    return _v
end

---@alias pilotUnitCreate {register,registerOrderEvent,whichPlayer,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isOpenPunish,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@alias pilotEnemyCreate {teamNo,register,registerOrderEvent,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isOpenPunish,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@alias pilotWeatherCreate {x,y,w,h,whichRect,type,during}
---@alias pilotRectLock {type,during,width,height,lockRect,lockUnit,lockX,lockY}
---@alias pilotQuestCreate {side:"位置",title:"标题",content:"内容",icon:"图标",during:"持续时间"}
---@alias pilotItemCreate {id,charges,whichUnit,x,y,during}
---@alias pilotHeroBuildSelector {heroes,during,type,buildX,buildY,buildDistance,buildRowQty,tavernId,tavernUnitQty,onUnitSell,direct}
---@alias pilotEnchantAppend {targetUnit,sourceUnit,enchants,during}
---@alias pilotDialogCreate {title,buttons}
---@alias pilotDamage {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,damageSrc,damageType,breakArmorType,isFixed}
---@alias pilotDamageStep {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,damageSrc,damageType,breakArmorType,isFixed,frequency,times,extraInfluence}
---@alias pilotDamageRange {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,effectSingle,damageSrc,damageType,breakArmorType,isFixed,radius,frequency,times,extraInfluence}
---@alias pilotKnocking {sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotSplit {radius,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotBroken {sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotSwim {sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotSilent {during,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotUnArm {during,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotFetter {during,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotBomb {radius,sourceUnit,whichGroup,targetUnit,damage,odds,percent,effect,damageSrc,damageType,isFixed}
---@alias pilotLightningChain {lightningType,prevUnit,sourceUnit,targetUnit,damage,odds,qty,rate,radius,isRepeat,effect,damageSrc,damageType,isFixed,index,repeatGroup}
---@alias pilotCrackFly {distance,height,during,sourceUnit,targetUnit,damage,odds,effect,damageSrc,damageType,isFixed}
---@alias pilotRangeSwim {radius,during,x,y,filter,sourceUnit,targetUnit,damage,odds,effect,damageSrc,damageType,isFixed}
---@alias pilotWhirlwind {radius,frequency,during,filter,sourceUnit,targetUnit,damage,odds,effect,effectEnum,damageSrc,damageType,isFixed,animation}
---@alias pilotLeap {arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageType,isFixed,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotLeapPaw {qty,deg,arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageType,isFixed,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotLeapRange {radius,arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageType,isFixed,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotLeapReflex {qty,radius,arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageType,isFixed,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotRectangleStrike {deg,radius,distance,frequency,filter,sourceUnit,targetUnit,x,y,effect,effectScale,effectOffset,damageSrc,damageType,isFixed,damageEffect,oneHitOnly,extraInfluence}
---@alias pilotEffectTTG {msg,width,scale,speed,whichUnit,x,y,red,green,blue}