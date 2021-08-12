#ifndef DZAPIINCLUDE
#define DZAPIINCLUDE

#include "BlizzardAPI.j"

library DzAPI

	native DzAPI_Map_SaveServerValue        takes player whichPlayer, string key, string value returns boolean
	native DzAPI_Map_GetServerValue         takes player whichPlayer, string key returns string
	native DzAPI_Map_Ladder_SetStat         takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_IsRPGLadder            takes nothing returns boolean
	native DzAPI_Map_GetGameStartTime       takes nothing returns integer
	native DzAPI_Map_Stat_SetStat           takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_GetMatchType      		takes nothing returns integer
	native DzAPI_Map_Ladder_SetPlayerStat   takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_GetServerValueErrorCode takes player whichPlayer returns integer
	native DzAPI_Map_GetLadderLevel         takes player whichPlayer returns integer
	native DzAPI_Map_IsRedVIP               takes player whichPlayer returns boolean
	native DzAPI_Map_IsBlueVIP              takes player whichPlayer returns boolean
	native DzAPI_Map_GetLadderRank          takes player whichPlayer returns integer
	native DzAPI_Map_GetMapLevelRank        takes player whichPlayer returns integer
	native DzAPI_Map_GetGuildName           takes player whichPlayer returns string
	native DzAPI_Map_GetGuildRole           takes player whichPlayer returns integer
	native DzAPI_Map_IsRPGLobby             takes nothing returns boolean
	native DzAPI_Map_GetMapLevel            takes player whichPlayer returns integer
	native DzAPI_Map_MissionComplete        takes player whichPlayer, string key, string value returns nothing
	native DzAPI_Map_GetActivityData        takes nothing returns string
	native DzAPI_Map_GetMapConfig           takes string key returns string
	native DzAPI_Map_HasMallItem            takes player whichPlayer, string key returns boolean
	native DzAPI_Map_SavePublicArchive      takes player whichPlayer, string key, string value returns boolean
	native DzAPI_Map_GetPublicArchive       takes player whichPlayer, string key returns string
	native DzAPI_Map_UseConsumablesItem     takes player whichPlayer, string key returns nothing
	native DzAPI_Map_OrpgTrigger            takes player whichPlayer, string key returns nothing
	native DzAPI_Map_GetServerArchiveDrop   takes player whichPlayer, string key returns string
	native DzAPI_Map_GetServerArchiveEquip  takes player whichPlayer, string key returns integer
	native RequestExtraIntegerData          takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns integer
	native RequestExtraBooleanData          takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns boolean
	native RequestExtraStringData           takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns string
	native RequestExtraRealData             takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns real
	native DzAPI_Map_GetPlatformVIP         takes player whichPlayer returns integer

	function DzAPI_Map_IsPlatformVIP takes player whichPlayer returns boolean
		return DzAPI_Map_GetPlatformVIP(whichPlayer) > 0
	endfunction

	function DzAPI_Map_Global_GetStoreString takes string key returns string
		return RequestExtraStringData(36, GetLocalPlayer(), key, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_Global_StoreString takes string key, string value returns nothing
		call RequestExtraStringData(37, GetLocalPlayer(), key, value, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_Global_ChangeMsg takes trigger trig returns nothing
		call DzTriggerRegisterSyncData(trig, "DZGAU", true)
	endfunction

	function DzAPI_Map_ServerArchive takes player whichPlayer, string key returns string
	    return RequestExtraStringData(38, whichPlayer, key, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_SaveServerArchive takes player whichPlayer, string key, string value returns nothing
	    call RequestExtraBooleanData(39, whichPlayer, key, value, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_IsRPGQuickMatch takes nothing returns boolean
		return RequestExtraBooleanData(40, null, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_GetMallItemCount takes player whichPlayer, string key returns integer
		return RequestExtraIntegerData(41, whichPlayer, key, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_ConsumeMallItem takes player whichPlayer, string key, integer count returns boolean
		return RequestExtraBooleanData(42, whichPlayer, key, null, false, count, 0, 0)
	endfunction

	function DzAPI_Map_EnablePlatformSettings takes player whichPlayer, integer option, boolean enable returns boolean
		return RequestExtraBooleanData(43, whichPlayer, null, null, enable, option, 0, 0)
	endfunction

	function DzAPI_Map_IsBuyReforged takes player whichPlayer returns boolean
		return RequestExtraBooleanData(44, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function GetPlayerServerValueSuccess takes player whichPlayer returns boolean
		if(DzAPI_Map_GetServerValueErrorCode(whichPlayer)==0)then
			return true
		else
			return false
		endif
	endfunction

	function DzAPI_Map_StoreIntegerEX takes player whichPlayer, string key, integer value returns nothing
		set key="I"+key
		call RequestExtraBooleanData(39, whichPlayer, key, I2S(value), false, 0, 0, 0)
		set key=null
		set whichPlayer=null
	endfunction

	function DzAPI_Map_GetStoredIntegerEX takes player whichPlayer, string key returns integer
		local integer value
		set key="I"+key
		set value=S2I(RequestExtraStringData(38, whichPlayer, key, null, false, 0, 0, 0))
		set key=null
		set whichPlayer=null
		return value
	endfunction

	function DzAPI_Map_StoreInteger takes player whichPlayer, string key, integer value returns nothing
		set key="I"+key
		call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
		set key=null
		set whichPlayer=null
	endfunction

	function DzAPI_Map_GetStoredInteger takes player whichPlayer, string key returns integer
		local integer value
		set key="I"+key
		set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
		set key=null
		set whichPlayer=null
		return value
	endfunction

        function DzAPI_Map_CommentTotalCount1 takes player whichPlayer, integer id returns integer
    		return RequestExtraIntegerData(52, whichPlayer, null, null, false, id, 0, 0)
	endfunction

	function DzAPI_Map_StoreReal takes player whichPlayer, string key, real value returns nothing
		set key="R"+key
		call DzAPI_Map_SaveServerValue(whichPlayer,key,R2S(value))
		set key=null
		set whichPlayer=null
	endfunction
	function DzAPI_Map_GetStoredReal takes player whichPlayer, string key returns real
		local real value
		set key="R"+key
		set value=S2R(DzAPI_Map_GetServerValue(whichPlayer,key))
		set key=null
		set whichPlayer=null
		return value
	endfunction
	function DzAPI_Map_StoreBoolean takes player whichPlayer, string key, boolean value returns nothing
		set key="B"+key
		if(value)then
			call DzAPI_Map_SaveServerValue(whichPlayer,key,"1")
		else
			call DzAPI_Map_SaveServerValue(whichPlayer,key,"0")
		endif
		set key=null
		set whichPlayer=null
	endfunction
	function DzAPI_Map_GetStoredBoolean takes player whichPlayer, string key returns boolean
		local boolean value
		set key="B"+key
		set key=DzAPI_Map_GetServerValue(whichPlayer,key)
		if(key=="1")then
			set value=true
		else
			set value=false
		endif
		set key=null
		set whichPlayer=null
		return value
	endfunction
	function DzAPI_Map_StoreString takes player whichPlayer, string key, string value returns nothing
		set key="S"+key
		call DzAPI_Map_SaveServerValue(whichPlayer,key,value)
		set key=null
		set whichPlayer=null
	endfunction
	function DzAPI_Map_GetStoredString takes player whichPlayer, string key returns string
		return DzAPI_Map_GetServerValue(whichPlayer,"S"+key)
	endfunction
	function DzAPI_Map_StoreStringEX takes player whichPlayer, string key, string value returns nothing
		set key="S"+key
		call RequestExtraBooleanData(39, whichPlayer,key,value,false,0,0,0)
		set key=null
		set whichPlayer=null
	endfunction
	function DzAPI_Map_GetStoredStringEX takes player whichPlayer, string key returns string
		return RequestExtraStringData(38, whichPlayer,"S"+key,null,false,0,0,0)
	endfunction

	function DzAPI_Map_GetStoredUnitType takes player whichPlayer, string key returns integer
		local integer value
		set key="I"+key
		set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
		set key=null
		set whichPlayer=null
		return value
	endfunction

	function DzAPI_Map_GetStoredAbilityId takes player whichPlayer, string key returns integer
		local integer value
		set key="I"+key
		set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
		set key=null
		set whichPlayer=null
		return value
	endfunction




	function DzAPI_Map_FlushStoredMission takes player whichPlayer, string key returns nothing
		call DzAPI_Map_SaveServerValue(whichPlayer,key,null)
		set key=null
		set whichPlayer=null
	endfunction

	function DzAPI_Map_Ladder_SubmitIntegerData takes player whichPlayer, string key, integer value returns nothing
		call DzAPI_Map_Ladder_SetStat(whichPlayer,key,I2S(value))
	endfunction
	function DzAPI_Map_Stat_SubmitUnitIdData takes player whichPlayer, string key,integer value returns nothing
		if(value==0)then
			//call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"0")
		else
			call DzAPI_Map_Ladder_SetStat(whichPlayer,key,I2S(value))
		endif
	endfunction
	function DzAPI_Map_Stat_SubmitUnitData takes player whichPlayer, string key,unit value returns nothing
		call DzAPI_Map_Stat_SubmitUnitIdData(whichPlayer,key,GetUnitTypeId(value))
	endfunction
	function DzAPI_Map_Ladder_SubmitAblityIdData takes player whichPlayer, string key, integer value returns nothing
		if(value==0)then
			//call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"0")
		else
			call DzAPI_Map_Ladder_SetStat(whichPlayer,key,I2S(value))
		endif
	endfunction
	function DzAPI_Map_Ladder_SubmitItemIdData takes player whichPlayer, string key, integer value returns nothing
		local string S
		if(value==0)then
			set S="0"
		else
			set S=I2S(value)
			call DzAPI_Map_Ladder_SetStat(whichPlayer,key,S)
		endif
		//call DzAPI_Map_Ladder_SetStat(whichPlayer,key,S)
		set S=null
		set whichPlayer=null
	endfunction
	function DzAPI_Map_Ladder_SubmitItemData takes player whichPlayer, string key, item value returns nothing
		call DzAPI_Map_Ladder_SubmitItemIdData(whichPlayer,key,GetItemTypeId(value))
	endfunction
	function DzAPI_Map_Ladder_SubmitBooleanData takes player whichPlayer, string key,boolean value  returns nothing
		if(value)then
			call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"1")
		else
			call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"0")
		endif
	endfunction
	function DzAPI_Map_Ladder_SubmitTitle takes player whichPlayer, string value  returns nothing
		call DzAPI_Map_Ladder_SetStat(whichPlayer,value,"1")
	endfunction
	function DzAPI_Map_Ladder_SubmitPlayerRank takes player whichPlayer, integer value returns nothing
		call DzAPI_Map_Ladder_SetPlayerStat(whichPlayer,"RankIndex",I2S(value))
	endfunction

	function DzAPI_Map_Ladder_SubmitPlayerExtraExp takes player whichPlayer, integer value returns nothing
		call DzAPI_Map_Ladder_SetStat(whichPlayer,"ExtraExp",I2S(value))
	endfunction

	function DzAPI_Map_PlayedGames takes player whichPlayer returns integer
	    return RequestExtraIntegerData(45, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_CommentCount takes player whichPlayer returns integer
	    return RequestExtraIntegerData(46, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_FriendCount takes player whichPlayer returns integer
	    return RequestExtraIntegerData(47, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_IsConnoisseur takes player whichPlayer returns boolean
	    return RequestExtraBooleanData(48, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_IsBattleNetAccount takes player whichPlayer returns boolean
	    return RequestExtraBooleanData(49, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_IsAuthor takes player whichPlayer returns boolean
	    return RequestExtraBooleanData(50, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_CommentTotalCount takes nothing returns integer
	    return RequestExtraIntegerData(51, null, null, null, false, 0, 0, 0)
	endfunction

	function DzAPI_Map_Statistics takes player whichPlayer, string eventKey, string eventType, integer value returns nothing
	    call RequestExtraBooleanData(34, whichPlayer, eventKey, "", false, value, 0, 0)
	endfunction

	function DzAPI_Map_Returns takes player whichPlayer, integer label returns boolean
	    return RequestExtraBooleanData(53, whichPlayer, null, null, false, label, 0, 0)
	endfunction


	function DzAPI_Map_ContinuousCount takes player whichPlayer, integer id returns integer
	    return RequestExtraIntegerData(54, whichPlayer, null, null, false, id, 0, 0)
	endfunction

	// IsPlayer,                      //是否为玩家
	function DzAPI_Map_IsPlayer takes player whichPlayer returns boolean
	    return RequestExtraBooleanData(55, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	// MapsTotalPlayed,               //所有地图的总游戏时长
	function DzAPI_Map_MapsTotalPlayed takes player whichPlayer returns integer
	    return RequestExtraIntegerData(56, whichPlayer, null, null, false, 0, 0, 0)
	endfunction

	// MapsLevel,                    //指定地图的地图等级
	function DzAPI_Map_MapsLevel takes player whichPlayer, integer mapId returns integer
	    return RequestExtraIntegerData(57, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeGold,              //所有地图的金币消耗
	function DzAPI_Map_MapsConsumeGold takes player whichPlayer, integer mapId returns integer
	    return RequestExtraIntegerData(58, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeLumber,            //所有地图的木材消耗
	function DzAPI_Map_MapsConsumeLumber takes player whichPlayer, integer mapId returns integer
	    return RequestExtraIntegerData(59, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeLv1,               //消费 1-199
	function DzAPI_Map_MapsConsumeLv1 takes player whichPlayer, integer mapId returns boolean
	    return RequestExtraBooleanData(60, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeLv2,               //消费 200-499
	function DzAPI_Map_MapsConsumeLv2 takes player whichPlayer, integer mapId returns boolean
	    return RequestExtraBooleanData(61, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeLv3,               //消费 500~999
	function DzAPI_Map_MapsConsumeLv3 takes player whichPlayer, integer mapId returns boolean
	    return RequestExtraBooleanData(62, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction

	// MapsConsumeLv4,               //消费 1000+
	function DzAPI_Map_MapsConsumeLv4 takes player whichPlayer, integer mapId returns boolean
	    return RequestExtraBooleanData(63, whichPlayer, null, null, false, mapId, 0, 0)
	endfunction
	//获取论坛数据（0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量）
	function DzAPI_Map_GetForumData takes player whichPlayer, integer whichData returns integer
	    return RequestExtraIntegerData(65, whichPlayer, null, null, false, whichData, 0, 0)
	endfunction


	function DzAPI_Map_OpenMall takes player whichPlayer,string whichkey returns boolean
		return RequestExtraBooleanData(66, whichPlayer, whichkey, null, false, 0, 0, 0)
	endfunction

endlibrary

#endif
