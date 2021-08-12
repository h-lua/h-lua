#define Charge_Get_Source() Charge_Source
#define Charge_Get_Current() Charge_Current
#define Charge_Get_Target() Charge_Target
#define Charge_Get_DamageSource() Charge_DamSource
#define Xg_GetPercentOfReal(x) x*0.01
#define	Xg_GetRealOfPercent(x) x*100.00
#define XG_Int2HeroAttr(x) x
#define XG_HeroAttr2Int(x) x
#define XG_Int2GenBouns(x) x
#define XG_Normal_Expression(e) e
#define GetAttackedUnitBJ() GetTriggerUnit()
#define GetKillingUnitBJ() GetKillingUnit()
#define GetLoadedUnitBJ() GetLoadedUnit()
#define GetTransportUnitBJ() GetTransportUnit()
#define GetLastCreatedUnit() bj_lastCreatedUnit

#define XG_Task_CustomDemand_Add(u,a,m,v) XG_Task_CustomDemand_Set(u,a,XG_Task_CustomDemand_Get(u,a) m (v))
#define Xg_DamPlus_AddAttr(u,a,m,v) Xg_DamPlus_SetAttr(u,a,Xg_DamPlus_GetAttr(u,a) m (v))
#define GetHeroStat_HC(u,s,i) I2R(GetHeroStatBJ(u,s,i))
#define GetHeroStr_HC(u,i) I2R(GetHeroStr(u,i))
#define GetHeroAgi_HC(u,i) I2R(GetHeroAgi(u,i))
#define GetHeroInt_HC(u,i) I2R(GetHeroInt(u,i))
#define GetUnitLevel_HC(u) I2R(GetUnitLevel(u))
#define GetUnitAbilityLevel_HC(u,a) I2R(GetUnitAbilityLevel(u,a))
#define GetPlayerState_HC(p,s) I2R(GetPlayerState(p,s))
#define SetUnitXY_HC(u,x,y) SetUnitX(u,x)<?='\n'?>call SetUnitY(u,y)
#define XG_GetEnterGame_Unit() GetFilterUnit()
#define XG_TakeElement_RandomPool(p) XG_TakeElement_RandomPool_Ex(p,true)
#define XG_GetItemData_Cons_2(a) a"
#define XG_GetItemData_Cons(t,i,d) XG_GetItemData_Cons_2("<?= require('slk').t.i.d ?>)
#define XG_SingleGameExit_On DoNothing
#define XG_DamPlusAttr2Int(a) a
#define XG_Int2DamPlusAttr(a) a
#define XG_UnitInDegree(ue,us,r1,r2) XG_UnitInUnitDegree(ue, us, bj_RADTODEG * Atan2(GetUnitY(ue) - GetUnitY(us), GetUnitX(ue) - GetUnitX(us)), r1, r2)

#define XG_AutoAttr_SetClassA(str) <?=XG_AutoAttr_SetClass_Lua(str)?>
#define XG_AutoAttr_AddAttrA(str,attr,v,ss) <?=XG_AutoAttr_AddAttr_Lua(str,attr,v,ss)?>
#define XG_AutoAttr_StartA() <?=XG_AutoAttr_Start_Lua()?>
#define XG_Damplus_SetMk1(x) DoNothing()<? XG.damplus['mk#1']= x ?>
#define XG_Damplus_SetMk2(x) DoNothing()<? XG.damplus['mk#2']= x ?>

#define XG_Distance_UnL(a,b) SquareRoot((GetUnitX(a)-GetLocationX(b))*(GetUnitX(a)-GetLocationX(b))+(GetUnitY(a)-GetLocationY(b))*(GetUnitY(a)-GetLocationY(b)))
#ifndef Lua_Exec
    #define Lua_Exec Cheat
#endif

