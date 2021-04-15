local triumph = {
    DzCreateFrameByTagName = function(_, result)
        return math.floor(result or 0)
    end,
    SetUnitState = function(params, result)
        local whichUnit = params[1]
        local state = params[2]
        if (whichUnit ~= nil and state == UNIT_STATE_ATTACK_WHITE or state == UNIT_STATE_DEFEND_WHITE) then
            cj.UnitAddAbility(whichUnit, HL_ID.japi_delay)
            cj.UnitRemoveAbility(whichUnit, HL_ID.japi_delay)
        end
        return result
    end
}

return triumph