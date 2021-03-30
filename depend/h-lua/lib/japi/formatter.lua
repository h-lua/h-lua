local tobool = function(value)
    if (type(value) ~= "boolean") then
        return false
    end
    return value or false
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
        params[4] = math.tointeger(params[4]) or 0
    end,
    DzAPI_Map_UseConsumablesItem = function(params)
        params[2] = tostring(params[2])
    end,
    DzClickFrame = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzCreateFrame = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
    end,
    DzCreateFrameByTagName = function(params)
        params[1] = tostring(params[1])
        params[2] = tostring(params[2])
        params[3] = math.tointeger(params[3]) or 0
        params[4] = tostring(params[4])
        params[5] = math.tointeger(params[5]) or 0
    end,
    DzCreateSimpleFrame = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
    end,
    DzDestroyFrame = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzDestructablePosition = function(params)
        params[2] = math.round(params[2], 2)
        params[3] = math.round(params[3], 2)
    end,
    DzEnableWideScreen = function(params)
        params[1] = tobool(params[1])
    end,
    DzExecuteFunc = function(params)
        params[1] = tostring(params[1])
    end,
    DzFrameCageMouse = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tobool(params[2])
    end,
    DzFrameClearAllPoints = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameEditBlackBorders = function(params)
        params[1] = math.round(params[1], 3)
        params[2] = math.round(params[2], 3)
    end,
    DzFrameFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameGetAlpha = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetCommandBarButton = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameGetEnable = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetHeight = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetHeroBarButton = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetHeroHPBar = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetHeroManaBar = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetItemBarButton = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetMinimapButton = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetName = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetParent = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetText = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetTextSizeLimit = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetUpperButtonBarButton = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameGetValue = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    DzFrameSetAbsolutePoint = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.round(params[3], 3)
        params[4] = math.round(params[4], 3)
    end,
    DzFrameSetAllPoints = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetAlpha = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[2] = math.min(255, params[2])
        params[2] = math.max(0, params[2])
    end,
    DzFrameSetAnimate = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = tobool(params[3])
    end,
    DzFrameSetAnimateOffset = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 3)
    end,
    DzFrameSetEnable = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tobool(params[2])
    end,
    DzFrameSetFocus = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tobool(params[2])
    end,
    DzFrameSetFont = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tostring(params[2])
        params[3] = math.round(params[3], 5)
        params[4] = math.tointeger(params[4]) or 0
    end,
    DzFrameSetMinMaxValue = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 5)
        params[3] = math.round(params[3], 5)
    end,
    DzFrameSetModel = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tostring(params[2])
        params[3] = math.tointeger(params[3]) or 0
        params[4] = math.tointeger(params[4]) or 0
    end,
    DzFrameSetParent = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetPoint = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = math.tointeger(params[4]) or 0
        params[5] = math.round(params[5], 5)
        params[6] = math.round(params[6], 5)
    end,
    DzFrameSetPriority = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetScale = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 5)
    end,
    DzFrameSetScript = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = tostring(params[3])
        params[4] = tobool(params[4])
    end,
    DzFrameSetScriptByCode = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[4] = tobool(params[4])
    end,
    DzFrameSetSize = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 5)
        params[3] = math.round(params[3], 5)
    end,
    DzFrameSetStepValue = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 3)
    end,
    DzFrameSetText = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tostring(params[2])
    end,
    DzFrameSetTextAlignment = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or FRAME_ALIGN_LEFT_TOP
    end,
    DzFrameSetTextColor = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetTextSizeLimit = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetTexture = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tostring(params[2])
        params[3] = math.tointeger(params[3]) or 0
    end,
    DzFrameSetTooltip = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameSetUpdateCallback = function(params)
        params[1] = tostring(params[1])
    end,
    DzFrameSetValue = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 5)
    end,
    DzFrameSetVertexColor = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzFrameShow = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = tobool(params[2])
    end,
    DzGetColor = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = math.tointeger(params[4]) or 0
    end,
    DzGetUnitNeededXP = function(params)
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzIsKeyDown = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    tocFilePath = function(params)
        params[1] = tostring(params[1])
    end,
    DzOriginalUIAutoResetPoint = function(params)
        params[1] = tobool(params[1])
    end,
    DzSetCustomFovFix = function(params)
        params[1] = math.round(params[1], 5)
    end,
    DzSetMemory = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.round(params[2], 5)
    end,
    DzSetMousePos = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzSetUnitID = function(params)
        if (type(params[2]) == 'string') then
            params[2] = string.char2id(params[2])
        else
            params[2] = math.tointeger(params[2]) or 0
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
        params[3] = math.tointeger(params[3]) or 0
    end,
    DzSetWar3MapMap = function(params)
        params[1] = tostring(params[1])
    end,
    DzSimpleFontStringFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzSimpleFrameFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzSimpleTextureFindByName = function(params)
        params[1] = tostring(params[1])
        params[2] = math.tointeger(params[2]) or 0
    end,
    DzSyncData = function(params)
        params[1] = tostring(params[1])
        params[2] = tostring(params[2])
    end,
    DzTriggerRegisterKeyEvent = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = tobool(params[4])
        params[5] = tostring(params[5])
    end,
    DzTriggerRegisterKeyEventByCode = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = tobool(params[4])
    end,
    DzTriggerRegisterMouseEvent = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = tobool(params[4])
        params[5] = tostring(params[5])
    end,
    DzTriggerRegisterMouseEventByCode = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
        params[4] = tobool(params[4])
    end,
    DzTriggerRegisterMouseMoveEvent = function(params)
        params[2] = tobool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterMouseMoveEventByCode = function(params)
        params[2] = tobool(params[2])
    end,
    DzTriggerRegisterMouseWheelEvent = function(params)
        params[2] = tobool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterMouseWheelEventByCode = function(params)
        params[2] = tobool(params[2])
    end,
    DzTriggerRegisterSyncData = function(params)
        params[2] = tostring(params[2])
        params[3] = tobool(params[3])
    end,
    DzTriggerRegisterWindowResizeEvent = function(params)
        params[2] = tobool(params[2])
        params[3] = tostring(params[3])
    end,
    DzTriggerRegisterWindowResizeEventByCode = function(params)
        params[2] = tobool(params[2])
    end,
    EXEffectMatRotateX = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXEffectMatRotateY = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXEffectMatRotateZ = function(params)
        params[2] = math.round(params[2], 3)
    end,
    EXEffectMatScale = function(params)
        params[2] = math.round(params[2], 3)
        params[3] = math.round(params[3], 3)
        params[4] = math.round(params[4], 3)
    end,
    EXExecuteScript = function(params)
        params[1] = tostring(params[1])
    end,
    EXGetAbilityDataInteger = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
    end,
    EXGetAbilityDataReal = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
    end,
    EXGetAbilityDataString = function(params)
        params[2] = math.tointeger(params[2]) or 0
        params[3] = math.tointeger(params[3]) or 0
    end,
    EXGetAbilityState = function(params)
        params[2] = math.tointeger(params[2]) or 0
    end,
    EXGetBuffDataString = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    EXGetEventDamageData = function(params)
        params[1] = math.tointeger(params[1]) or 0
    end,
    EXGetItemDataString = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
    end,
    EXGetUnitAbility = function(params)
        if (type(params[2]) == 'string') then
            params[2] = string.char2id(params[2])
        end
    end,
    EXGetUnitAbilityByIndex = function(params)
        params[2] = math.tointeger(params[2]) or 0
    end,
    EXSetAbilityState = function(params)
        if (type(params[2]) == 'string') then
            params[2] = string.char2id(params[2])
        else
            params[2] = math.tointeger(params[2]) or 0
        end
        params[3] = math.tointeger(params[3]) or 0
        params[4] = math.round(params[4], 3)
    end,
    EXSetBuffDataString = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
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
        params[1] = math.tointeger(params[1]) or 0
        params[2] = math.tointeger(params[2]) or 0
        params[3] = tostring(params[3])
    end,
    EXSetUnitCollisionType = function(params)
        params[1] = tobool(params[1])
        params[3] = math.tointeger(params[3]) or COLLISION_TYPE_UNIT
    end,
    EXSetUnitFacing = function(params)
        params[2] = math.round(params[2], 2)
    end,
    EXSetUnitMoveType = function(params)
        params[2] = math.tointeger(params[2]) or MOVE_TYPE_NONE
    end,
    RequestExtraBooleanData = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = tobool(params[5])
        params[6] = math.tointeger(params[6]) or 0
        params[7] = math.tointeger(params[7]) or 0
        params[8] = math.tointeger(params[8]) or 0
    end,
    RequestExtraIntegerData = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = tobool(params[5])
        params[6] = math.tointeger(params[6]) or 0
        params[7] = math.tointeger(params[7]) or 0
        params[8] = math.tointeger(params[8]) or 0
    end,
    RequestExtraRealData = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = tobool(params[5])
        params[6] = math.tointeger(params[6]) or 0
        params[7] = math.tointeger(params[7]) or 0
        params[8] = math.tointeger(params[8]) or 0
    end,
    RequestExtraStringData = function(params)
        params[1] = math.tointeger(params[1]) or 0
        params[3] = tostring(params[3])
        params[4] = tostring(params[4])
        params[5] = tobool(params[5])
        params[6] = math.tointeger(params[6]) or 0
        params[7] = math.tointeger(params[7]) or 0
        params[8] = math.tointeger(params[8]) or 0
    end,
    SetUnitState = function(params)
        params[3] = math.round(params[3], 3)
    end,
}

return formatter