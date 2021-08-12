local toBool = function(value)
    if (type(value) ~= "boolean") then
        return false
    end
    return value or false
end
local toInt = function(value, def)
    def = def or 0
    return math.floor(value or def) or def
end

local formatter = {
    DzAPI_Map_GetMapConfig = function(params)
        params[1] = tostring(params[1])
    end,
    DzAPI_Map_GetPublicArchive = function(params)
        params[2] = tostring(params[2])
    end,
    DzAPI_Map_GetServerArchiveDrop = function(params)
        params[2] = tostring(params[2])
    end,
    DzAPI_Map_GetServerArchiveEquip = function(params)
        params[2] = tostring(params[2])
    end,
    DzAPI_Map_GetServerValue = function(params)
        params[2] = tostring(params[2])
    end,
    DzAPI_Map_HasMallItem = function(params)
        params[2] = string.upper(tostring(params[2]))
    end,
    DzAPI_Map_Ladder_SetPlayerStat = function(params)
        params[2] = tostring(params[2])
        params[3] = tostring(params[3])
    end,
    DzAPI_Map_Ladder_SetStat = function(params)
        params[2] = tostring(params[2])
        params[3] = tostring(params[3])
    end,
    DzAPI_Map_MissionComplete = function(params)
        params[2] = tostring(params[2])
        params[3] = tostring(params[3])
    end,
    DzAPI_Map_OrpgTrigger = function(params)
        params[2] = tostring(params[2])
    end,
    DzAPI_Map_SavePublicArchive = function(params)
        params[2] = tostring(params[2])
        params[3] = tostring(params[3])
    end,
    DzAPI_Map_SaveServerValue = function(params)
        params[2] = tostring(params[2])
        if (params[3] == nil) then
            params[3] = ""
        elseif (type(params[3]) == "boolean") then
            if (params[3]) then
                params[3] = "1"
            else
                params[3] = "0"
            end
        elseif (type(params[3]) == "number") then
            params[3] = tostring(params[3])
        end
    end,
    DzAPI_Map_Stat_SetStat = function(params)
        params[2] = tostring(params[2])
        if (params[3] == nil) then
            params[3] = ""
        elseif (type(params[3]) == "boolean") then
            if (params[3]) then
                params[3] = "1"
            else
                params[3] = "0"
            end
        elseif (type(params[3]) == "number") then
            params[3] = tostring(params[3])
        end
    end,
    DzAPI_Map_Statistics = function(params)
        params[2] = tostring(params[2])
        params[3] = tostring(params[3])
        params[4] = toInt(params[4])
    end,
    DzAPI_Map_UseConsumablesItem = function(params)
        params[2] = tostring(params[2])
    end,
    DzClickFrame = function(params)
        params[1] = toInt(params[1])
    end,
    DzCreateFrame = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
    end,
    DzCreateFrameByTagName = function(params)
        params[1] = tostring(params[1])
        params[2] = tostring(params[2])
        params[3] = toInt(params[3])
        params[4] = tostring(params[4])
        params[5] = toInt(params[5])
    end,
    DzCreateSimpleFrame = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
    end,
    DzDestroyFrame = function(params)
        params[1] = toInt(params[1])
    end,
    DzDestructablePosition = function(params)
        params[2] = math.round(params[2], 2)
        params[3] = math.round(params[3], 2)
    end,
    DzEnableWideScreen = function(params)
        params[1] = toBool(params[1])
    end,
    DzExecuteFunc = function(params)
        params[1] = tostring(params[1])
    end,
    DzFrameCageMouse = function(params)
        params[1] = toInt(params[1])
        params[2] = toBool(params[2])
    end,
    DzFrameClearAllPoints = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameEditBlackBorders = function(params)
        params[1] = math.round(params[1], 3)
        params[2] = math.round(params[2], 3)
    end,
    DzFrameFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameGetAlpha = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetCommandBarButton = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameGetEnable = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetHeight = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetHeroBarButton = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetHeroHPBar = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetHeroManaBar = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetItemBarButton = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetMinimapButton = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetName = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetParent = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetText = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetTextSizeLimit = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetUpperButtonBarButton = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameGetValue = function(params)
        params[1] = toInt(params[1])
    end,
    DzFrameSetAbsolutePoint = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = math.round(params[3], 3)
        params[4] = math.round(params[4], 3)
    end,
    DzFrameSetAllPoints = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetAlpha = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[2] = math.min(255, params[2])
        params[2] = math.max(0, params[2])
    end,
    DzFrameSetAnimate = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = toBool(params[3])
    end,
    DzFrameSetAnimateOffset = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
    end,
    DzFrameSetEnable = function(params)
        params[1] = toInt(params[1])
        params[2] = toBool(params[2])
    end,
    DzFrameSetFocus = function(params)
        params[1] = toInt(params[1])
        params[2] = toBool(params[2])
    end,
    DzFrameSetFont = function(params)
        params[1] = toInt(params[1])
        params[2] = tostring(params[2])
        params[3] = math.round(params[3], 5)
        params[4] = toInt(params[4])
    end,
    DzFrameSetMinMaxValue = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
        params[3] = math.round(params[3], 5)
    end,
    DzFrameSetModel = function(params)
        params[1] = toInt(params[1])
        params[2] = tostring(params[2])
        params[3] = toInt(params[3])
        params[4] = toInt(params[4])
    end,
    DzFrameSetParent = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetPoint = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toInt(params[4])
        params[5] = math.round(params[5], 5)
        params[6] = math.round(params[6], 5)
    end,
    DzFrameSetPriority = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetScale = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
    end,
    DzFrameSetScript = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = tostring(params[3])
        params[4] = toBool(params[4])
    end,
    DzFrameSetScriptByCode = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[4] = toBool(params[4])
    end,
    DzFrameSetSize = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
        params[3] = math.round(params[3], 5)
    end,
    DzFrameSetStepValue = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 3)
    end,
    DzFrameSetText = function(params)
        params[1] = toInt(params[1])
        params[2] = tostring(params[2])
    end,
    DzFrameSetTextAlignment = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2], FRAME_ALIGN_LEFT_TOP)
    end,
    DzFrameSetTextColor = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetTextSizeLimit = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetTexture = function(params)
        params[1] = toInt(params[1])
        params[2] = tostring(params[2])
        params[3] = toInt(params[3])
    end,
    DzFrameSetTooltip = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameSetUpdateCallback = function(params)
        params[1] = tostring(params[1])
    end,
    DzFrameSetValue = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
    end,
    DzFrameSetVertexColor = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzFrameShow = function(params)
        params[1] = toInt(params[1])
        params[2] = toBool(params[2])
    end,
    DzGetColor = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toInt(params[4])
    end,
    DzGetUnitNeededXP = function(params)
        params[2] = toInt(params[2])
    end,
    DzIsKeyDown = function(params)
        params[1] = toInt(params[1])
    end,
    tocFilePath = function(params)
        params[1] = tostring(params[1])
    end,
    DzOriginalUIAutoResetPoint = function(params)
        params[1] = toBool(params[1])
    end,
    DzSetCustomFovFix = function(params)
        params[1] = math.round(params[1], 5)
    end,
    DzSetMemory = function(params)
        params[1] = toInt(params[1])
        params[2] = math.round(params[2], 5)
    end,
    DzSetMousePos = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    DzSetUnitID = function(params)
        if (type(params[2]) == 'string') then
            params[2] = string.char2id(params[2])
        else
            params[2] = toInt(params[2])
        end
    end,
    DzSetUnitModel = function(params)
        params[2] = tostring(params[2])
    end,
    DzSetUnitPosition = function(params)
        params[2] = math.round(params[2], 2)
        params[3] = math.round(params[3], 2)
    end,
    DzSetUnitTexture = function(params)
        params[2] = tostring(params[2])
        params[3] = toInt(params[3])
    end,
    DzSetWar3MapMap = function(params)
        params[1] = tostring(params[1])
    end,
    DzSimpleFontStringFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
    end,
    DzSimpleFrameFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
    end,
    DzSimpleTextureFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = toInt(params[2])
    end,
    DzSyncData = function(params)
        params[1] = tostring(params[1])
        params[2] = tostring(params[2])
    end,
    DzTriggerRegisterKeyEvent = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toBool(params[4])
        params[5] = tostring(params[5])
    end,
    DzTriggerRegisterKeyEventByCode = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toBool(params[4])
    end,
    DzTriggerRegisterMouseEvent = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toBool(params[4])
        params[5] = tostring(params[5])
    end,
    DzTriggerRegisterMouseEventByCode = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
        params[4] = toBool(params[4])
    end,
    DzTriggerRegisterMouseMoveEvent = function(params)
        params[2] = toBool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterMouseMoveEventByCode = function(params)
        params[2] = toBool(params[2])
    end,
    DzTriggerRegisterMouseWheelEvent = function(params)
        params[2] = toBool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterMouseWheelEventByCode = function(params)
        params[2] = toBool(params[2])
    end,
    DzTriggerRegisterSyncData = function(params)
        params[2] = tostring(params[2])
        params[3] = toBool(params[3])
    end,
    DzTriggerRegisterWindowResizeEvent = function(params)
        params[2] = toBool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterWindowResizeEventByCode = function(params)
        params[2] = toBool(params[2])
    end,
    EXEffectMatRotateX = function(params)
        params[2] = math.round(params[2], 5)
    end,
    EXEffectMatRotateY = function(params)
        params[2] = math.round(params[2], 5)
    end,
    EXEffectMatRotateZ = function(params)
        params[2] = math.round(params[2], 5)
    end,
    EXEffectMatScale = function(params)
        params[2] = math.round(params[2], 5)
        params[3] = math.round(params[3], 5)
        params[4] = math.round(params[4], 5)
    end,
    EXExecuteScript = function(params)
        params[1] = tostring(params[1])
    end,
    EXGetAbilityDataInteger = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
    end,
    EXGetAbilityDataReal = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
    end,
    EXGetAbilityDataString = function(params)
        params[2] = toInt(params[2])
        params[3] = toInt(params[3])
    end,
    EXGetAbilityState = function(params)
        params[2] = toInt(params[2])
    end,
    EXGetBuffDataString = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    EXGetEventDamageData = function(params)
        params[1] = toInt(params[1])
    end,
    EXGetItemDataString = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
    end,
    EXGetUnitAbility = function(params)
        if (type(params[2]) == 'string') then
            params[2] = string.char2id(params[2])
        end
    end,
    EXGetUnitAbilityByIndex = function(params)
        params[2] = toInt(params[2])
    end,
    EXPauseUnit = function(params)
        params[2] = toBool(params[2])
    end,
    EXSetAbilityState = function(params)
        params[2] = toInt(params[2])
        params[3] = math.round(params[3], 3)
    end,
    EXSetBuffDataString = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = tostring(params[3])
    end,
    EXSetEffectSize = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXSetEffectSpeed = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXSetEffectXY = function(params)
        params[2] = math.round(params[2], 3)
        params[3] = math.round(params[3], 3)
    end,
    EXSetEffectZ = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXSetEventDamage = function(params)
        params[1] = math.round(params[1], 3)
    end,
    EXSetItemDataString = function(params)
        params[1] = toInt(params[1])
        params[2] = toInt(params[2])
        params[3] = tostring(params[3])
    end,
    EXSetUnitCollisionType = function(params)
        params[1] = toBool(params[1])
        params[3] = toInt(params[3], COLLISION_TYPE_UNIT)
    end,
    EXSetUnitFacing = function(params)
        params[2] = math.round(params[2], 2)
    end,
    EXSetUnitMoveType = function(params)
        params[2] = toInt(params[2], MOVE_TYPE_NONE)
    end,
    RequestExtraBooleanData = function(params)
        params[1] = toInt(params[1])
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = toBool(params[5])
        params[6] = toInt(params[6])
        params[7] = toInt(params[7])
        params[8] = toInt(params[8])
    end,
    RequestExtraIntegerData = function(params)
        params[1] = toInt(params[1])
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = toBool(params[5])
        params[6] = toInt(params[6])
        params[7] = toInt(params[7])
        params[8] = toInt(params[8])
    end,
    RequestExtraRealData = function(params)
        params[1] = toInt(params[1])
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = toBool(params[5])
        params[6] = toInt(params[6])
        params[7] = toInt(params[7])
        params[8] = toInt(params[8])
    end,
    RequestExtraStringData = function(params)
        params[1] = toInt(params[1])
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = toBool(params[5])
        params[6] = toInt(params[6])
        params[7] = toInt(params[7])
        params[8] = toInt(params[8])
    end,
    SetUnitState = function(params)
        params[3] = math.round(params[3], 3)
    end,
}

return formatter