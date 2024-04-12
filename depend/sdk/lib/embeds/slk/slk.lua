function hslk_ability(_v)
    _v = F6V_A(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_ability_empty(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    _v.levels = _v.levels or 1
    _v.hero = _v.hero or 0
    local data = {}
    for _ = 1, _v.levels do
        table.insert(data, 0)
    end
    _v.DataA = data
    _v.DataB = data
    _v.DataC = data
    _v = F6V_A(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_unit(_v)
    _v = F6V_U(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_hero(_v)
    _v._parent = "Hpal"
    _v._type = "hero"
    _v = F6V_U(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_item(_v)
    _v = F6V_I(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_buff(_v)
    _v = F6V_B(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_upgrade(_v)
    _v = F6V_UP(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_destructable(_v)
    _v = F6V_DE(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function hslk_doodad(_v)
    _v = F6V_DO(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end
