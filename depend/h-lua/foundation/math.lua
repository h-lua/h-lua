math_random = math.random
math_pi = 3.14159265358979323846
math_rad2deg = 180 / math_pi
math_deg2rad = math_pi / 180

--- 随机数
---@param n number
---@param m number
---@return number
function math.random(n, m)
    if (cj == nil) then
        if (m < n) then
            return math_random(m, n)
        end
        return math_random(n, m)
    end
    local func = cj.GetRandomReal
    if (n == nil or m == nil) then
        -- 0.00 ~ 1.00
        return math.floor((func(0.000, 1.000) * 100) + 0.5) * 0.01
    end
    if (n == m) then
        return n
    end
    local fn = string.find(tostring(n), "[.]", 0)
    local fm = string.find(tostring(m), "[.]", 0)
    if (type(fn) ~= "number" and type(fm) ~= "number") then
        func = cj.GetRandomInt
        n = math.floor(n)
        m = math.floor(m)
    end
    if (m < n) then
        return func(m, n)
    end
    return func(n, m)
end

--- 极坐标位移
---@param x number
---@param y number
---@param dist number
---@param angle number
---@return number,number
function math.polarProjection(x, y, dist, angle)
    local tx = x + dist * math.cos(angle * math_deg2rad)
    local ty = y + dist * math.sin(angle * math_deg2rad)
    if (tx < hrect.getMinX(hrect.playable())) then
        tx = hrect.getMinX(hrect.playable())
    elseif (tx > hrect.getMaxX(hrect.playable())) then
        tx = hrect.getMaxX(hrect.playable())
    end
    if (ty < hrect.getMinY(hrect.playable())) then
        ty = hrect.getMinY(hrect.playable())
    elseif (ty > hrect.getMaxY(hrect.playable())) then
        ty = hrect.getMaxY(hrect.playable())
    end
    return tx, ty
end

--- 数字四舍五入
---@param decimal number
---@param n number 小数最大截断位，默认2位
---@return number
function math.round(decimal, n)
    n = math.floor(n or 2)
    if (n < 1) then
        return math.floor(decimal)
    end
    return tonumber(string.format('%.' .. n .. 'f', decimal))
end

--- 两数正差额
---@param value1 number 数字1
---@param value2 number 数字2
---@return number
function math.disparity(value1, value2)
    if (value1 >= value2) then
        return value1 - value2
    end
    return value2 - value1
end

--- 数字格式化
---@param value number
---@param n number 小数最大截断位，默认2位
---@return string
function math.numberFormat(value, n)
    n = math.floor(n or 2)
    if (n < 1) then
        n = 2
    end
    if (value > 10000 * 100000000) then
        return string.format("%." .. n .. "f", value / (10000 * 100000000)) .. "T"
    elseif (value > 10 * 100000000) then
        return string.format("%." .. n .. "f", value / (10 * 100000000)) .. "B"
    elseif (value > 100 * 10000) then
        return string.format("%." .. n .. "f", value / (100 * 10000)) .. "M"
    elseif (value > 1000) then
        return string.format("%." .. n .. "f", value / 1000) .. "K"
    else
        return string.format("%." .. n .. "f", value)
    end
end

--- 整型格式化
---@param value number
---@return string
function math.integerFormat(value)
    if (value > 10000 * 100000000) then
        return math.floor(value / (10000 * 100000000)) .. "T"
    elseif (value > 10 * 100000000) then
        return math.floor(value / (10 * 100000000)) .. "B"
    elseif (value > 100 * 10000) then
        return math.floor(value / (100 * 10000)) .. "M"
    elseif (value > 1000) then
        return math.floor(value / 1000) .. "K"
    else
        return tostring(math.floor(value))
    end
end

--- 获取两个坐标间角度，如果其中一个单位为空 返回0
--- 返回的范围是[0-360(0)]
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.angle(x1, y1, x2, y2)
    return math.round((math_rad2deg * math.atan(y2 - y1, x2 - x1) + 360) % 360, 4)
end

--- 获取两个坐标距离
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

--- 获取矩形区域内某角度距离边缘最大距离
---@param w number 区域长
---@param h number 区域宽
---@param deg number 角度
---@return number
function math.getMaxDistanceInRect(w, h, deg)
    w = w or 0
    h = h or 0
    if (w <= 0 or h <= 0) then
        return
    end
    local distance = 0
    local lockDegA = (180 * math.atan(h, w)) / math_pi
    local lockDegB = 90 - lockDegA
    if (deg == 0 or deg == 180 or deg == -180) then
        -- 横
        distance = w
    elseif (deg == 90 or deg == -90) then
        -- 竖
        distance = h
    elseif (deg > 0 and deg <= lockDegA) then
        -- 第1三角区间
        distance = w / 2 / math.cos(deg * math_deg2rad)
    elseif (deg > lockDegA and deg < 90) then
        -- 第2三角区间
        distance = h / 2 / math.cos(90 - deg * math_deg2rad)
    elseif (deg > 90 and deg <= 90 + lockDegB) then
        -- 第3三角区间
        distance = h / 2 / math.cos((deg - 90) * math_deg2rad)
    elseif (deg > 90 + lockDegB and deg < 180) then
        -- 第4三角区间
        distance = w / 2 / math.cos((180 - deg) * math_deg2rad)
    elseif (deg < 0 and deg >= -lockDegA) then
        -- 第5三角区间
        distance = w / 2 / math.cos(deg * math_deg2rad)
    elseif (deg < lockDegA and deg > -90) then
        -- 第6三角区间
        distance = h / 2 / math.cos((90 + deg) * math_deg2rad)
    elseif (deg < -90 and deg >= -90 - lockDegB) then
        -- 第7三角区间
        distance = h / 2 / math.cos((-deg - 90) * math_deg2rad)
    elseif (deg < -90 - lockDegB and deg > -180) then
        -- 第8三角区间
        distance = w / 2 / math.cos((180 + deg) * math_deg2rad)
    end
    return distance
end

--- 时间戳转日期对象
---@param timestamp number Unix时间戳
---@return table {Y:"年",m:"月",d:"日",H:"时",i:"分",s:"秒",w:"周[0-6]",W:"周[日-六]"}
function math.date(timestamp)
    local d = os.date("%Y|%m|%d|%H|%M|%S|%w", timestamp)
    d = string.explode("|", d)
    local W = { "日", "一", "二", "三", "四", "五", "六" }
    return {
        Y = d[1],
        m = d[2],
        d = d[3],
        H = d[4],
        i = d[5],
        s = d[6],
        w = d[7],
        W = W[d[7] + 1],
    }
end