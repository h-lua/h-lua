library cjLib75hJKJ374s4e597nba9o7w45gf
globals
group cj_tmpgr_copy_nw509ert7
endglobals
function cj_group_copy_75hJKJ3745gf takes nothing returns nothing
//# optional
call GroupAddUnit(cj_tmpgr_copy_nw509ert7,GetEnumUnit())
endfunction
endlibrary
library cjLibw560nbs9b8nse46703948 initializer init
globals
boolexpr cj_true_bool_4896bnao87
endglobals
function cj_true_a497bnsor7 takes nothing returns boolean
//# optional
return true
endfunction
private function init takes nothing returns nothing
set cj_true_bool_4896bnao87=Condition(function cj_true_a497bnsor7)
endfunction
endlibrary
globals
trigger gg_trg_______u=null
trigger gg_trg_______UI_______u=null
trigger gg_trg___________________u=null
endglobals
function InitGlobals takes nothing returns nothing
endfunction
function Trig_______uActions takes nothing returns nothing
endfunction
function InitTrig_______u takes nothing returns nothing
set gg_trg_______u=CreateTrigger()
call TriggerAddAction(gg_trg_______u,function Trig_______uActions)
endfunction
function Trig_______UI_______uActions takes nothing returns nothing
endfunction
function InitTrig_______UI_______u takes nothing returns nothing
set gg_trg_______UI_______u=CreateTrigger()
call TriggerAddAction(gg_trg_______UI_______u,function Trig_______UI_______uActions)
endfunction
function Trig___________________uActions takes nothing returns nothing
endfunction
function InitTrig___________________u takes nothing returns nothing
set gg_trg___________________u=CreateTrigger()
call TriggerAddAction(gg_trg___________________u,function Trig___________________uActions)
endfunction
function InitCustomTriggers takes nothing returns nothing
call InitTrig_______u()
call InitTrig_______UI_______u()
call InitTrig___________________u()
endfunction
function InitCustomPlayerSlots takes nothing returns nothing
call SetPlayerStartLocation(Player(0),0)
call SetPlayerColor(Player(0),ConvertPlayerColor(0))
call SetPlayerRacePreference(Player(0),RACE_PREF_HUMAN)
call SetPlayerRaceSelectable(Player(0),true)
call SetPlayerController(Player(0),MAP_CONTROL_USER)
endfunction
function InitCustomTeams takes nothing returns nothing
call SetPlayerTeam(Player(0),0)
endfunction
function main takes nothing returns nothing
call SetCameraBounds(-3328.0+GetCameraMargin(CAMERA_MARGIN_LEFT),-3584.0+GetCameraMargin(CAMERA_MARGIN_BOTTOM),3328.0-GetCameraMargin(CAMERA_MARGIN_RIGHT),3072.0-GetCameraMargin(CAMERA_MARGIN_TOP),-3328.0+GetCameraMargin(CAMERA_MARGIN_LEFT),3072.0-GetCameraMargin(CAMERA_MARGIN_TOP),3328.0-GetCameraMargin(CAMERA_MARGIN_RIGHT),-3584.0+GetCameraMargin(CAMERA_MARGIN_BOTTOM))
call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
call NewSoundEnvironment("Default")
call SetAmbientDaySound("LordaeronSummerDay")
call SetAmbientNightSound("LordaeronSummerNight")
call SetMapMusic("Music",true,0)
call InitBlizzard()
call InitGlobals()
call InitCustomTriggers()
endfunction
function config takes nothing returns nothing
call SetMapName("只是另外一张魔兽争霸的地图")
call SetMapDescription("没有说明")
call SetPlayers(1)
call SetTeams(1)
call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
call DefineStartLocation(0,-75.4,-210.0)
call InitCustomPlayerSlots()
call SetPlayerSlotAvailable(Player(0),MAP_CONTROL_USER)
call InitGenericPlayerSlots()
endfunction
