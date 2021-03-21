---@class htextTag 漂浮字
htextTag = {
    qty = 0,
    limit = 90
}

--- 删除漂浮字
---@param ttg userdata
---@param delay number
htextTag.del = function(ttg, delay)
    if (delay == nil or delay <= 0) then
        htextTag.qty = htextTag.qty - 1
        hcache.free(ttg)
        cj.DestroyTextTag(ttg)
    else
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            htextTag.qty = htextTag.qty - 1
            hcache.free(ttg)
            cj.DestroyTextTag(ttg)
        end)
    end
end
--- 创建漂浮字
---@param msg string
---@param size number
---@param color string hex 6位颜色代码 http://www.atool.org/colorpicker.php
---@param opacity number 不透明度，为0则不可见(0.0~1.0)
---@param during number 设置during为0则永久显示
---@return userdata
htextTag.create = function(msg, size, color, opacity, during)
    if (string.len(msg) <= 0 or during < 0) then
        return
    end
    if (htextTag.qty >= htextTag.limit) then
        return
    end
    if (opacity >= 1) then
        opacity = 1
    elseif (opacity < 0) then
        opacity = 0
    end
    local ttg = cj.CreateTextTag()
    if (ttg == nil) then
        --由于漂浮字有上限，所以有可能为nil，此时返回不创建即可
        return
    end
    htextTag.qty = htextTag.qty + 1
    if (color ~= nil and string.len(color) == 6) then
        msg = "|cff" .. color .. msg .. "|r"
    end
    hcache.alloc(ttg)
    hcache.set(ttg, CONST_CACHE.TTG_MSG, msg)
    hcache.set(ttg, CONST_CACHE.TTG_SIZE, size)
    hcache.set(ttg, CONST_CACHE.TTG_COLOR, color)
    hcache.set(ttg, CONST_CACHE.TTG_OPACITY, opacity)
    hcache.set(ttg, CONST_CACHE.TTG_DURING, during)
    cj.SetTextTagText(ttg, msg, size * 0.023 / 10)
    cj.SetTextTagColor(ttg, 255, 255, 255, math.floor(255 * opacity))
    if (during == 0) then
        cj.SetTextTagPermanent(ttg, true)
    else
        cj.SetTextTagPermanent(ttg, false)
        htextTag.del(ttg, during)
    end
    return ttg
end
--- 漂浮文字 - 默认 (在x,y)
---@param x number
---@param y number
---@param msg string
---@param size number
---@param color string hex 6位颜色代码 http://www.atool.org/colorpicker.php
---@param opacity number 不透明度，为0则不可见(0.0~1.0)
---@param during number 设置during为0则永久显示
---@param zOffset number z轴高度偏移量
---@return userdata
htextTag.create2XY = function(x, y, msg, size, color, opacity, during, zOffset)
    local ttg = htextTag.create(msg, size, color, opacity, during)
    cj.SetTextTagPos(ttg, x - cj.StringLength(msg) * size * 0.5, y, zOffset)
    return ttg
end
--- 漂浮文字 - 默认 (在某单位头上)
---@param u userdata
---@param msg string
---@param size number
---@param color string hex 6位颜色代码 http://www.atool.org/colorpicker.php
---@param opacity number 不透明度，为0则不可见(0.0~1.0)
---@param during number 设置during为0则永久显示
---@param zOffset number z轴高度偏移量
---@return userdata
htextTag.create2Unit = function(u, msg, size, color, opacity, during, zOffset)
    return htextTag.create2XY(hunit.x(u), hunit.y(u), msg, size, color, opacity, during, zOffset)
end
--- 漂浮文字 - 默认 (在某点上)
---@param loc userdata
---@param msg string
---@param size number
---@param color string hex 6位颜色代码 http://www.atool.org/colorpicker.php
---@param opacity number 不透明度，为0则不可见(0.0~1.0)
---@param during number 设置during为0则永久显示
---@param zOffset number z轴高度偏移量
---@return userdata
htextTag.create2Loc = function(loc, msg, size, color, opacity, during, zOffset)
    return htextTag.create2XY(cj.GetLocationX(loc), cj.GetLocationY(loc), msg, size, color, opacity, during, zOffset)
end
--- 漂浮文字 - 默认 (绑定在某单位头上，跟随移动)
---@param u userdata
---@param msg string
---@param size number
---@param color string hex 6位颜色代码 http://www.atool.org/colorpicker.php
---@param opacity number 不透明度，为0则不可见(0.0~1.0)
---@param during number 设置during为0则永久显示
---@param zOffset number z轴高度偏移量
---@return userdata
htextTag.createFollowUnit = function(u, msg, size, color, opacity, during, zOffset)
    local ttg = htextTag.create2Unit(u, msg, size, color, opacity, during, zOffset)
    if (ttg == nil) then
        htime.setTimeout(0.1, function(t)
            htime.delTimer(t)
            htextTag.createFollowUnit(u, msg, size, color, opacity, during, zOffset)
        end)
        return
    end
    local txt = htextTag.getMsg(ttg)
    local scale = 0.5
    htime.setInterval(0.03, function(t)
        if (txt == nil) then
            htime.delTimer(t)
            return
        end
        cj.SetTextTagPos(ttg, hunit.x(u) - cj.StringLength(txt) * size * scale, hunit.y(u), zOffset)
        if (his.alive(u) == true) then
            cj.SetTextTagVisibility(ttg, true)
        else
            cj.SetTextTagVisibility(ttg, false)
        end
    end)
    return ttg
end

--- 获取漂浮字大小
---@param ttg userdata
---@return number|nil
htextTag.getSize = function(ttg)
    return hcache.get(ttg, CONST_CACHE.TTG_SIZE)
end

--- 获取漂浮字颜色
---@param ttg userdata
---@return string|nil
htextTag.getColor = function(ttg)
    return hcache.get(ttg, CONST_CACHE.TTG_COLOR)
end

--- 获取漂浮字内容
---@param ttg userdata
---@return string|nil
htextTag.getMsg = function(ttg)
    return hcache.get(ttg, CONST_CACHE.TTG_MSG)
end

--- 获取漂浮字透明度
---@param ttg userdata
---@return number|nil
htextTag.getOpacity = function(ttg)
    return hcache.get(ttg, CONST_CACHE.TTG_OPACITY)
end

--- 获取漂浮字持续时间
---@param ttg userdata
---@return number|nil
htextTag.getDuring = function(ttg)
    return hcache.get(ttg, CONST_CACHE.TTG_DURING)
end

--- 设置漂浮字XY的偏移速度
---@param ttg userdata
---@return number|nil
htextTag.setVelocity = function(ttg, xSpeed, ySpeed)
    cj.SetTextTagVelocity(ttg, xSpeed, ySpeed)
end

--- 风格特效
---@param ttg userdata
---@param showType string | "'scale'" | "'shrink'" | "'toggle'"
---@param xSpeed number
---@param ySpeed number
htextTag.style = function(ttg, showType, xSpeed, ySpeed)
    if (ttg == nil) then
        return
    end
    cj.SetTextTagVelocity(ttg, xSpeed, ySpeed)
    local size = htextTag.getSize(ttg)
    local tend = htextTag.getDuring(ttg)
    if (tend <= 0) then
        tend = 0.5
    end
    if (showType == "scale") then
        -- 放大
        local tnow = 0
        htime.setInterval(0.03, function(t)
            tnow = tnow + htime.getSetTime(t)
            local msg = htextTag.getMsg(ttg)
            if (msg == nil or tnow >= tend) then
                htime.delTimer(t)
                return
            end
            cj.SetTextTagText(ttg, msg, (size * (1 + tnow * 0.5 / tend)) * 0.023 / 10)
        end)
    elseif (showType == "shrink") then
        -- 缩小
        local tnow = 0
        htime.setInterval(0.03, function(t)
            tnow = tnow + htime.getSetTime(t)
            local msg = htextTag.getMsg(ttg)
            if (msg == nil or tnow >= tend) then
                htime.delTimer(t)
                return
            end
            cj.SetTextTagText(ttg, msg, (size * (1 - tnow * 0.5 / tend)) * 0.023 / 10)
        end)
    elseif (showType == "toggle") then
        -- 放大再缩小
        local tnow = 0
        local tend1 = tend * 0.1
        local tend2 = tend * 0.25
        local tend3 = tend - tend1 - tend2
        local scale = tend * 0.002
        htime.setInterval(0.03, function(t)
            tnow = tnow + htime.getSetTime(t)
            local msg = htextTag.getMsg(ttg)
            if (msg == nil or tnow >= tend1 + tend2 + tend3) then
                htime.delTimer(t)
                return
            end
            if (tnow <= tend1) then
                cj.SetTextTagText(ttg, msg, (size * (1 + tnow / tend1)) * scale)
            elseif (tnow > tend1 + tend3) then
                cj.SetTextTagText(ttg, msg, (size * 2 - (5 * (tnow - tend1 - tend3) / tend2)) * scale)
            end
        end)
    end
end
