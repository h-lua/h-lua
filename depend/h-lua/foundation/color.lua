---@class hcolor
hcolor = {}

---@param str string
---@param color string hex 6位代码
---@return string
function hcolor.hex(str, color)
    if (str == nil or str == '' or color == nil) then
        return str
    end
    return "|cff" .. color .. str .. "|r"
end

---@param str string
---@param color string|function
---@return string
function hcolor.mixed(str, color)
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
---@param str string
---@return string
function hcolor.gold(str)
    return hcolor.hex(str, "ffcc00")
end

--- 纯白
---@param str string
---@return string
function hcolor.white(str)
    return hcolor.hex(str, "ffffff")
end

--- 纯黑
---@param str string
---@return string
function hcolor.black(str)
    return hcolor.hex(str, "000000")
end

--- 浅灰
---@param str string
---@return string
function hcolor.grey(str)
    return hcolor.hex(str, "c0c0c0")
end

--- 深灰
---@param str string
---@return string
function hcolor.greyDeep(str)
    return hcolor.hex(str, "969696")
end

--- 亮红
---@param str string
---@return string
function hcolor.redLight(str)
    return hcolor.hex(str, "ff8080")
end

--- 大红
---@param str string
---@return string
function hcolor.red(str)
    return hcolor.hex(str, "ff3939")
end

--- 浅绿
---@param str string
---@return string
function hcolor.greenLight(str)
    return hcolor.hex(str, "ccffcc")
end

--- 深绿
---@param str string
---@return string
function hcolor.green(str)
    return hcolor.hex(str, "80ff00")
end

--- 浅黄
---@param str string
---@return string
function hcolor.yellowLight(str)
    return hcolor.hex(str, "ffffcc")
end

--- 亮黄
---@param str string
---@return string
function hcolor.yellow(str)
    return hcolor.hex(str, "ffff00")
end

--- 浅橙
---@param str string
---@return string
function hcolor.orangeLight(str)
    return hcolor.hex(str, "ffd88c")
end

--- 橙色
---@param str string
---@return string
function hcolor.orange(str)
    return hcolor.hex(str, "ffc24b")
end

--- 天空蓝
---@param str string
---@return string
function hcolor.skyLight(str)
    return hcolor.hex(str, "ccffff")
end

--- 青空蓝
---@param str string
---@return string
function hcolor.sky(str)
    return hcolor.hex(str, "80ffff")
end

--- 浅海蓝
---@param str string
---@return string
function hcolor.seaLight(str)
    return hcolor.hex(str, "99ccff")
end

--- 深海蓝
---@param str string
---@return string
function hcolor.sea(str)
    return hcolor.hex(str, "00ccff")
end

--- 浅紫
---@param str string
---@return string
function hcolor.purpleLight(str)
    return hcolor.hex(str, "ee82ee")
end

--- 亮紫
---@param str string
---@return string
function hcolor.purple(str)
    return hcolor.hex(str, "ff59ff")
end


--- 插入组合
--[[
    str: 一个字符串，数值%s,%s,%s
    containColor: 总体hex颜色，包住字符串两端 string|nil|function
    options: {
        {"00ccff", "100"}, -- 按顺序替换
        {"ee82ee", "200"},
        {hcolor.purple, "300"}, -- 可使用函数进行颜色设定，自定义函数也可以只要返回string类型即可
    }
]]
---@param str string
---@param containColor nil|string|function
---@param options table
---@return string
function hcolor.format(str, containColor, options)
    local poses = string.findAllPos(str, '%%s')
    local builder = {}
    if (#poses > 0) then
        local idx = 1
        local cursor = 1
        for _, p in ipairs(poses) do
            if (p[1] > 1) then
                if (type(containColor) == "string") then
                    table.insert(builder, hcolor.hex(string.sub(str, cursor, p[1] - 1), containColor))
                elseif (type(containColor) == "function") then
                    table.insert(builder, containColor(string.sub(str, cursor, p[1] - 1)))
                else
                    table.insert(builder, string.sub(str, cursor, p[1] - 1), containColor)
                end
            end
            if (options ~= nil and options[idx] ~= nil) then
                if (type(options[idx][1]) == "string") then
                    table.insert(builder, hcolor.hex(tostring(options[idx][2]), options[idx][1]))
                elseif (type(options[idx][1]) == "function") then
                    table.insert(builder, options[idx][1](tostring(options[idx][2])))
                end
            end
            cursor = p[2] + 1
            idx = idx + 1
        end
        if (type(containColor) == "string") then
            table.insert(builder, hcolor.hex(string.sub(str, cursor), containColor))
        elseif (type(containColor) == "function") then
            table.insert(builder, containColor(string.sub(str, cursor)))
        else
            table.insert(builder, string.sub(str, cursor))
        end
    end
    return string.implode('', builder)
end
