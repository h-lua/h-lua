function F6V_A(v)
    v._class = "ability"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "ANcl"
    end
    return v
end

function F6V_U(v)
    v._class = "unit"
    v._type = v._type or "common"
    if (v._parent == nil) then
        v._parent = "hpea"
    end
    return v
end

function F6V_I_CD(v)
    if (v._cooldown < 0) then
        v._cooldown = 0
    end
    local cdID
    local ad = {}
    if (v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

function F6V_I(v)
    v._class = "item"
    v._type = v._type or "common"
    if (v._cooldown ~= nil) then
        F6V_I_CD(v)
    end
    if (v._parent == nil) then
        if (v.class == "Charged") then
            v._parent = "hlst"
        elseif (v.class == "PowerUp") then
            v._parent = "gold"
        else
            v._parent = "rat9"
        end
    end
    return v
end

function F6V_B(v)
    v._class = "buff"
    v._type = v._type or "common"
    return v
end

function F6V_UP(v)
    v._class = "upgrade"
    v._type = v._type or "common"
    return v
end

function F6V_DE(v)
    v._class = "destructable"
    v._type = v._type or "common"
    return v
end

function F6V_DO(v)
    v._class = "doodad"
    v._type = v._type or "common"
    return v
end
