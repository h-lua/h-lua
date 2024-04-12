SLK_GO = {}
SLK_ID_ALREADY = {}

function SLK_GO_INI(ini)
    local iniJson = json.parse(ini)
    for _, v in pairs(iniJson) do
        SLK_ID_ALREADY[v] = true
    end
end

function SLK_GO_SET(data)
    for k, v in pairs(data) do
        if (type(v) == "function") then
            data[k] = nil
        end
    end
    table.insert(SLK_GO, data)
end

local idPrefix = {
    ability = "K",
    item = "I",
    unit = "V",
    buff = "B",
    upgrade = "U",
    destructable = "D",
    doodad = "O",
}

local idLimit = 46655 -- zzz

SLK_ID_COUNT = {}
function SLK_ID(_v)
    local _parent = _v._parent
    local _class = _v._class
    local _id_force = _v._id_force
    -- 如果自定义的ID可用，返回设定的ID
    if (_id_force ~= nil and string.len(_id_force) == 4 and true ~= SLK_ID_ALREADY[_id_force]) then
        local b = string.byte(_id_force, 1, 1)
        if (b >= 48 and b <= 57) then
            print("ID FORCE:<" .. _id_force .. "> The first character should not be a number!")
        else
            SLK_ID_ALREADY[_id_force] = true
            return _id_force
        end
    end
    local prefix = idPrefix[_class]
    if (prefix == nil) then
        prefix = "X"
    end
    if (SLK_ID_COUNT[prefix] == nil) then
        SLK_ID_COUNT[prefix] = 0
    end
    local sid
    while (true) do
        local id = string.convert(SLK_ID_COUNT[prefix], 36)
        SLK_ID_COUNT[prefix] = SLK_ID_COUNT[prefix] + 1
        if (SLK_ID_COUNT[prefix] > idLimit) then
            sid = "ZZZZ"
            break
        end
        if string.len(id) == 1 then
            id = "00" .. id
        elseif string.len(id) == 2 then
            id = "0" .. id
        end
        sid = prefix .. id
        if true ~= SLK_ID_ALREADY[sid] then
            SLK_ID_ALREADY[sid] = true
            break
        end
    end
    if (_class == "unit") then
        local p1st = string.sub(_parent, 1, 1)
        if (string.lower(p1st) == p1st) then
            sid = string.lower(sid)
        end
    end
    return sid
end

function SLK_GO_JSON()
    return json.stringify(SLK_GO)
end