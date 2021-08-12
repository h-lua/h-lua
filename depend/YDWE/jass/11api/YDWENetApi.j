#ifndef PlatformAPIIncluded
#define PlatformAPIIncluded

#include "11Api/YDWERecordSystem.j"
library YDWENetApi initializer Init requires YDWE11Platform

globals
    private boolean is_11Platform = true
    gamecache array YY_Bill_m_table
    gamecache ctable = InitGameCache("11.s")
    gamecache ranktable = InitGameCache("11.rank")
    integer stSaveCnt = 0
endglobals

//消费
native EXNetConsume takes player p,integer consume returns boolean

//消费(一级货币)
native EXNetCommonConsume takes player p,integer consume returns boolean

//获取用户名
native EXGetPlayerRealName takes player p returns string

//道具扣除开始
native EXNetUseItem  takes player player_id,string itemid,integer amount returns boolean
//道具扣除结束


//时间函数需要引用的代码
native EXNetGetTime takes nothing returns string
//时间引用代码结束

//统计引用代码
native EXNetStatRemoteData takes integer player_id, string key ,string value returns boolean
//统计引用代码结束


//保存用户缓存数据
native EXNetSaveRemoteData takes integer player_id, string Key ,string value returns boolean


//重新加载用户缓存数据
native EXNetLoadRemoteData takes integer player_id, string Key returns boolean
//--------------------------------------------------------------------------------------------------------
private function YY_Bill_ToLetter takes integer i returns string
    return SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZ", i, i+1)
endfunction

function YDWEStatRemoteData takes player p, string key ,string value returns boolean
	return EXNetStatRemoteData(GetPlayerId(p), key, value)
endfunction

function YY_Bill_GetTable takes integer playerid returns gamecache
    if YY_Bill_m_table[playerid] == null then
        set YY_Bill_m_table[playerid] = InitGameCache("11billing@"+YY_Bill_ToLetter(playerid))
    endif
    	return YY_Bill_m_table[playerid]
endfunction
//获取玩家货币余额
function YDWERPGBillingGetCurrency takes player p returns integer
    return GetStoredInteger(YY_Bill_GetTable(GetPlayerId(p)), "货币", "currency")
endfunction
//玩家货币扣款
function YDWERPGBillingConsume takes player p,integer consume returns boolean
    return EXNetConsume(p, consume)
endfunction

//获取玩家货币余额(一级货币)
function YDWERPGBillingGetCommonCurrency takes player p returns integer
    return GetStoredInteger(YY_Bill_GetTable(GetPlayerId(p)), "货币", "bill")
endfunction

//玩家货币扣款(一级货币)
function YDWERPGBillingCommonConsume takes player p,integer consume returns boolean
    if consume>0 then
        return EXNetCommonConsume(p, consume)
    else
        return false
    endif
endfunction

//货币引用代码结束

//获取地图配置
function YDWERPGGetMapConfig takes string ckey returns string
    return GetStoredString(ctable, "config", ckey)
endfunction

//读取用户缓存数据
function YDWERPGGetRemoteData takes player p, string rKey returns string
    if EXNetLoadRemoteData(GetPlayerId(p), rKey) == true then
        return GetStoredString(ctable,EXGetPlayerRealName(p), rKey)
    else
        return ""
    endif
endfunction

//显示在排行榜中第rank位的玩家名，如果不存在则返回空字符串
function YDWEGetRPGTopName takes integer rank returns string
   return GetStoredString(ranktable, "TopsName" , I2S(rank))
endfunction

//显示在排行榜中第rank位的玩家分数，如果不存在则返回-1
function YDWEGetRPGTopScore takes integer rank returns integer
    return GetStoredInteger(ranktable, "TopsScore", I2S(rank) )
endfunction

//显示玩家的排行，如果不存在则返回-1
function YDWEGetPalyerRPGRank takes player p returns integer
     return GetStoredInteger(ranktable, "PlayerRank", I2S(GetPlayerId(p)) )
endfunction

//显示玩家的分数，如果不存在则返回-1
function YDWEGetPalyerRPGRankScore takes player p returns integer
    return GetStoredInteger(ranktable, "PlayerScore", I2S(GetPlayerId(p)) )
endfunction

//显示当前的排名种类名称
function YDWEGetRPGRankName takes nothing returns string
    return GetStoredString(ranktable, "RankKey", "0" )
endfunction

private function EXSaveRemoteData takes integer player_id, string Key ,string value returns boolean
    return StoreString(ctable,EXGetPlayerRealName(GetTriggerPlayer()), Key,value)
endfunction

function YDWESaveRemoteData takes player p, string Key ,string value returns boolean
    if is_11Platform == true then
        return EXNetSaveRemoteData(GetPlayerId(p), Key, value)
    else
        return EXSaveRemoteData(GetPlayerId(p), Key, value)
    endif
endfunction

function PlayerHighFreqScoreTest takes integer player_id, string value returns nothing
	local player p = Player(player_id)
    call YDWESaveRemoteData(p,"HFreqT1",value)
    call YDWESaveRemoteData(p,"HFreqT2",value)
    call YDWESaveRemoteData(p,"HFreqT3",value)
    call YDWESaveRemoteData(p,"HFreqT4",value)
    call YDWESaveRemoteData(p,"HFreqT5",value)
    call YDWESaveRemoteData(p,"HFreqT6",value)
    call YDWESaveRemoteData(p,"HFreqT7",value)
    call YDWESaveRemoteData(p,"HFreqT8",value)
    call YDWESaveRemoteData(p,"HFreqT9",value)
    call YDWESaveRemoteData(p,"HFreqT10",value)
endfunction

function YDWEHighFreqScorePrint takes nothing returns nothing
    call BJDebugMsg("st的触发者显示最大的数字，其余玩家显示最大数字-1")
    call BJDebugMsg("HFreqT1: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT1"))
    call BJDebugMsg("HFreqT2: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT2"))
    call BJDebugMsg("HFreqT3: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT3"))
    call BJDebugMsg("HFreqT4: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT4"))
    call BJDebugMsg("HFreqT5: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT5"))
    call BJDebugMsg("HFreqT6: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT6"))
    call BJDebugMsg("HFreqT7: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT7"))
    call BJDebugMsg("HFreqT8: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT8"))
    call BJDebugMsg("HFreqT9: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT9"))
    call BJDebugMsg("HFreqT10: "+YDWERPGGetRemoteData(GetLocalPlayer(),"HFreqT10"))
endfunction

function YDWEHighFreqScoreSave takes nothing returns nothing
    local integer localPlayer = GetPlayerId(GetLocalPlayer())
    local integer triggerPlayerId = GetPlayerId(GetTriggerPlayer())
    local integer idx = 0
    set stSaveCnt = stSaveCnt+1
    loop
        exitwhen(idx>12)
        if(triggerPlayerId == idx) then
            call PlayerHighFreqScoreTest(idx,I2S(stSaveCnt))
        else
            call PlayerHighFreqScoreTest(idx,I2S(stSaveCnt-1))
        endif

        set idx = idx+1
    endloop

endfunction

private function Init takes nothing returns nothing
	set is_11Platform = YDWEPlatformIsInPlatform()
endfunction

endlibrary

#endif /// PlatformAPI
