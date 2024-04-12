--- 进制规则
local convertChars = {
    [2] = string.split("01", 1),
    [8] = string.split("01234567", 1),
    [10] = string.split("0123456789", 1),
    [16] = string.split("0123456789ABCDEF", 1),
    [36] = string.split("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 1),
}

--- 10进制数字转2/8/10/16/36进制
---@param dec number
---@param cvt number 2|8|10|16|36 默认16
---@return string
function string.convert(dec, cvt)
    if (dec == 0) then
        return "0"
    end
    cvt = cvt or 16
    if (convertChars[cvt] == nil) then
        return "0"
    end
    local numStr = ""
    while (dec ~= 0) do
        local yu = math.floor((dec % cvt) + 1)
        numStr = convertChars[cvt][yu] .. numStr
        dec = math.floor(dec / cvt)
    end
    return numStr
end