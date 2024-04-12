mbstring = mbstring or {}

--- 获取字符串真实长度
---@param inputStr string
---@return number
function mbstring.len(inputStr)
    local lenInByte = #inputStr
    local width = 0
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(inputStr, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        i = i + byteCount -- 重置下一字节的索引
        width = width + 1 -- 字符的个数（长度）
    end
    return width
end

--- 分隔字符串(支持中文)
---@param str string
---@param size number 每隔[size]个字切一次
---@return string[]
function mbstring.split(str, size)
    local sp = {}
    local lenInByte = #str
    if (lenInByte <= 0) then
        return sp
    end
    size = size or 1
    local count = 0
    local i0 = 1
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        count = count + 1 -- 字符的个数（长度）
        i = i + byteCount -- 重置下一字节的索引
        if (count >= size) then
            table.insert(sp, string.sub(str, i0, i - 1))
            i0 = i
            count = 0
        elseif (i > lenInByte) then
            table.insert(sp, string.sub(str, i0, lenInByte))
        end
    end
    return sp
end