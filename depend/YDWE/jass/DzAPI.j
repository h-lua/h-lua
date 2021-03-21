#ifndef DZAPIINCLUDE
#define DZAPIINCLUDE

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

	function GetPlayerServerValueSuccess takes player whichPlayer returns boolean
		if(DzAPI_Map_GetServerValueErrorCode(whichPlayer)==0)then
			return true
		else
			return false
		endif
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










endlibrary

#endif
