---@class hcolor
hcolor = {}

---@private
---@param str string
---@param color string hex
---@return string
hcolor.hex = function(str, color)
    if (str == nil or str == '' or color == nil) then
        return str
    end
    return "|cff" .. color .. str .. "|r"
end

---@private
---@param str string
---@param color string|function
---@return string
hcolor.mixed = function(str, color)
    if (str == nil or str == '' or color == nil) then
        return str
    end
    if (type(color) == 'string') then
        return "|cff" .. color .. str .. "|r"
    elseif (type(color) == 'function') then
        return color(str)
    end
    return str
end

--- 耀金
---@public
---@param str string
---@return string
hcolor.gold = function(str)
    return hcolor.hex(str, "ffcc00")
end

--- 纯白
---@public
---@param str string
---@return string
hcolor.white = function(str)
    return hcolor.hex(str, "ffffff")
end

--- 纯黑
---@public
---@param str string
---@return string
hcolor.black = function(str)
    return hcolor.hex(str, "000000")
end

--- 浅灰
---@public
---@param str string
---@return string
hcolor.grey = function(str)
    return hcolor.hex(str, "c0c0c0")
end

--- 深灰
---@public
---@param str string
---@return string
hcolor.greyDeep = function(str)
    return hcolor.hex(str, "969696")
end

--- 亮红
---@public
---@param str string
---@return string
hcolor.redLight = function(str)
    return hcolor.hex(str, "ff8080")
end

--- 大红
---@public
---@param str string
---@return string
hcolor.red = function(str)
    return hcolor.hex(str, "ff3939")
end

--- 浅绿
---@public
---@param str string
---@return string
hcolor.greenLight = function(str)
    return hcolor.hex(str, "ccffcc")
end

--- 深绿
---@public
---@param str string
---@return string
hcolor.green = function(str)
    return hcolor.hex(str, "80ff00")
end

--- 浅黄
---@public
---@param str string
---@return string
hcolor.yellowLight = function(str)
    return hcolor.hex(str, "ffffcc")
end

--- 亮黄
---@public
---@param str string
---@return string
hcolor.yellow = function(str)
    return hcolor.hex(str, "ffff00")
end

--- 浅橙
---@public
---@param str string
---@return string
hcolor.orangeLight = function(str)
    return hcolor.hex(str, "ffd88c")
end

--- 橙色
---@public
---@param str string
---@return string
hcolor.orange = function(str)
    return hcolor.hex(str, "ffc24b")
end

--- 天空蓝
---@public
---@param str string
---@return string
hcolor.skyLight = function(str)
    return hcolor.hex(str, "ccffff")
end

--- 青空蓝
---@public
---@param str string
---@return string
hcolor.sky = function(str)
    return hcolor.hex(str, "80ffff")
end

--- 浅海蓝
---@public
---@param str string
---@return string
hcolor.seaLight = function(str)
    return hcolor.hex(str, "99ccff")
end

--- 深海蓝
---@public
---@param str string
---@return string
hcolor.sea = function(str)
    return hcolor.hex(str, "00ccff")
end

--- 浅紫
---@public
---@param str string
---@return string
hcolor.purpleLight = function(str)
    return hcolor.hex(str, "ee82ee")
end

--- 亮紫
---@public
---@param str string
---@return string
hcolor.purple = function(str)
    return hcolor.hex(str, "ff59ff")
end
