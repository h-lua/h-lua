---@param _v{life,mana,move,defend,defend_white,defend_green,attack_speed,attack_space,attack_space_origin,attack,attack_white,attack_green,attack_range,attack_range_acquire,sight,str,agi,int,str_green,agi_green,int_green,str_white,agi_white,int_white,life_back,mana_back,avoid,aim,punish,punish_current,hemophagia,hemophagia_skill,invincible,weight,weight_current,damage_extent,damage_reduction,damage_decrease,damage_rebound,damage_rebound_oppose,cure,reborn,knocking_odds,knocking_extent,knocking_oppose,hemophagia_oppose,hemophagia_skill_oppose,buff_oppose,debuff_oppose,split_oppose,punish_oppose,swim_oppose,broken_oppose,silent_oppose,unarm_oppose,fetter_oppose,bomb_oppose,lightning_chain_oppose,crack_fly_oppose,xtras,gold_ratio,lumber_ratio,exp_ratio,sell_ratio}
_attr = function(_v)
    return _v
end

---@param _v{on,action,val,odds,percent,during,qty,radius,rate,distance,height,lightning_type,effect,effectEnum,damageSrc,damageType}
_xtras = function(_v)
    return _v
end

---@param _v{effect,effectTarget,attachTarget,radius,target,attr}
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
