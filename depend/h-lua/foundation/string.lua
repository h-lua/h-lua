--[[
    允许使用方括号索引到字符串
    s = "hello"
    s[1] = "h"
]]
---@param str string
---@param i number
---@return string
getmetatable('').__index = function(str, i)
    if (type(i) == 'number') then
        return string.sub(str, i, i)
    end
    return string[i]
end

--[[
    允许使用前后两个索引执行括号法返回子字符串
    s = "hello"
    s(2,5) = "ello"

    如果只有单索引，则返回byte(unicode)
    s = "hello"
    s(2) = 101 (e)

    如果第二个索引为字符串，则进行替换
    s = "hello"
    s(2,'p') = "hpllo"
]]
---@param str string
---@param i number
---@param j number
---@return string
getmetatable('').__call = function(str, i, j)
    if (type(i) == 'number' and type(j) == 'number') then
        return string.sub(str, i, j)
    elseif (type(i) == 'number' and type(j) == 'string') then
        return table.concat { string.sub(str, 1, i - 1), j, string.sub(str, i + 1) }
    elseif (type(i) == 'number' and type(j) == 'nil') then
        return string.byte(str, i)
    end
    return string[i]
end

--- 根据值获取一个key
---@param t string
---@return string
function string.vkey(t)
    if (type(t) == "string") then
        return t
    elseif (type(t) == "table") then
        local j = ""
        if (#t > 0) then
            for _, v in ipairs(t) do
                if (type(v) == "table") then
                    v = "_T_"
                else
                    v = tostring(v)
                end
                j = j .. v
            end
        else
            j = "_"
        end
        return j
    end
end

--- 转义
---@param s string
---@return string
function string.addslashes(s)
    local in_char = { "\\", '"', "/", "\b", "\f", "\n", "\r", "\t" }
    local out_char = { "\\", '"', "/", "b", "f", "n", "r", "t" }
    for i, c in ipairs(in_char) do
        s = s:gsub(c, "\\" .. out_char[i])
    end
    return s
end

--- 反转义
---@param s string
---@return string
function string.stripslashes(s)
    local in_char = { "\\", '"', "/", "b", "f", "n", "r", "t" }
    local out_char = { "\\", '"', "/", "\b", "\f", "\n", "\r", "\t" }

    for i, c in ipairs(in_char) do
        s = s:gsub("\\" .. c, out_char[i])
    end
    return s
end

--- 把字符串以分隔符打散为数组
---@param delimeter string
---@param str string
---@return table
function string.explode(delimeter, str)
    local res = {}
    local start, start_pos, end_pos = 1, 1, 1
    while true do
        start_pos, end_pos = string.find(str, delimeter, start, true)
        if not start_pos then
            break
        end
        table.insert(res, string.sub(str, start, start_pos - 1))
        start = end_pos + 1
    end
    table.insert(res, string.sub(str, start))
    return res
end

--- 把数组以分隔符拼接回字符串
---@param delimeter string
---@param table table
---@return string
function string.implode(delimeter, table)
    local str
    for _, v in ipairs(table) do
        if (str == nil) then
            str = v
        else
            str = str .. delimeter .. v
        end
    end
    return str
end

--- 分隔字符串
---@param str string
---@param size number 每隔[size]字符切一次
---@return string
function string.split(str, size)
    local sp = {}
    local len = string.len(str)
    if (len <= 0) then
        return sp
    end
    size = size or 1
    local i = 1
    while (i <= len) do
        table.insert(sp, string.sub(str, i, i + size - 1))
        i = i + size
    end
    return sp
end

--- 统计某个子串出现的首位,不包含返回false
---@param str string
---@param pattern string
---@return number|boolean
function string.strpos(str, pattern)
    if (str == nil or pattern == nil) then
        return false
    end
    local s = string.find(str, pattern, 0)
    if (type(s) == "number") then
        return s
    else
        return false
    end
end

--- 找出某个子串出现的所有位置
---@param str string
---@param pattern string
---@return table
function string.findAllPos(str, pattern)
    if (str == nil or pattern == nil) then
        return
    end
    local s
    local e = 0
    local res = {}
    while (true) do
        s, e = string.find(str, pattern, e + 1)
        if (s == nil) then
            break
        end
        table.insert(res, { s, e })
        if (e == nil) then
            break
        end
    end
    return res
end

--- 统计某个子串出现的次数
---@param str string
---@param pattern string
---@return number
function string.findCount(str, pattern)
    if (str == nil or pattern == nil) then
        return
    end
    local s
    local e = 0
    local qty = 0
    while (true) do
        s, e = string.find(str, pattern, e + 1)
        if (s == nil) then
            break
        end
        qty = qty + 1
        if (e == nil) then
            break
        end
    end
    return qty
end

local randChars = {
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "~", "$", "#", "@", "!", "%", "^", "&", "*", "-", "+"
}

--- 随机字符串
---@param n number
---@return string
function string.random(n)
    n = math.floor(n or 0)
    if (n <= 0) then
        return ""
    end
    local s = ""
    for _ = 1, n do
        s = s .. randChars[math.random(1, #randChars)]
    end
    return s
end

--- 移除字符串两侧的空白字符或其他预定义字符
---@param str string
---@return string
function string.trim(str)
    local res = string.gsub(str, "^%s*(.-)%s*$", "%1")
    return res
end