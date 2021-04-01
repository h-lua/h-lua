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


--[[
    特效漂浮字
    只支持部分字，参考 CONST_MODEL_TTG
    options = {
        msg = "", --漂浮字信息
        width = 10, --字间
        scale = 0.25, --缩放
        speed = 1.0, --速度[0.5~3.0]
        x = nil, --创建坐标X，可选
        y = nil, --创建坐标Y，可选
        whichUnit = nil, --创建单位坐标（可选，优先级高）
        red = 255,--红
        green = 255,--绿
        blue = 255,--蓝
    }
]]
---@param options pilotEffectTTG
htextTag.model = function(options)
    local msg = tostring(options.msg) or ""
    local width = options.width or 10
    local scale = options.scale or 0.25
    local speed = options.speed or CONST_MODEL_TTG_SPD
    local x = options.x or 0
    local y = options.y or 0
    local red = options.red or 255
    local green = options.green or 255
    local blue = options.blue or 255
    local z = 150
    local tz = 600
    if (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit) + width * 2
        y = hunit.y(options.whichUnit)
        z = math.max(z, hunit.z(options.whichUnit))
    end
    if (speed < 0.5) then
        speed = 0.5
    elseif (speed > 3) then
        speed = 3
    end
    local words = string.mb_split(msg, 1)
    if (#words > 0) then
        x = math.floor(x)
        y = math.floor(y)
        local site = x .. y .. red .. green .. blue
        if (heffect._ttg[site] == nil) then
            heffect._ttg[site] = true
            htime.setTimeout(0.12, function(curTimer)
                htime.delTimer(curTimer)
                heffect._ttg[site] = nil
            end)
            if (red == 255 and green == 255 and blue == 255) then
                tz = tz + 170
            end
            local e = 1.0 / speed
            local d = 20 / speed
            for _, w in ipairs(words) do
                if (CONST_MODEL_TTG[w] ~= nil) then
                    local mdl = CONST_MODEL_TTG[w].mdl
                    local bit = CONST_MODEL_TTG[w].bit
                    if (red == 255 and green == 255 and blue == 255) then
                        local eff = cj.AddSpecialEffect(mdl, x, y)
                        hjapi.EXSetEffectZ(eff, z)
                        hjapi.EXEffectMatScale(eff, scale, scale, scale)
                        local dur = 0
                        local h = z
                        htime.setInterval(0.03, function(curTimer)
                            dur = dur + 0.03
                            if (dur >= e) then
                                htime.delTimer(curTimer)
                                cj.DestroyEffect(eff)
                                return
                            end
                            if (h < tz) then
                                h = h + (tz - h) / d
                                hjapi.EXSetEffectZ(eff, h)
                            end
                        end)
                    else
                        local u = hunit.create({
                            register = false,
                            whichPlayer = hplayer.player_passive,
                            id = HL_ID.unit_token_ttg,
                            x = x,
                            y = y,
                            red = red,
                            green = green,
                            blue = blue,
                            opacity = 1,
                            facing = 270,
                            modelScale = scale,
                            qty = 1,
                        })
                        local eff = heffect.bindUnit(mdl, u, "origin", -1)
                        local dur = 0
                        local h = z
                        htime.setInterval(0.03, function(curTimer)
                            dur = dur + 0.03
                            if (dur >= e) then
                                htime.delTimer(curTimer)
                                cj.DestroyEffect(eff)
                                cj.RemoveUnit(u)
                                return
                            end
                            if (h < tz) then
                                h = h + (tz - h) / d
                                hunit.setFlyHeight(u, h, 9999)
                                cj.SetUnitPosition(u, hunit.x(u), hunit.y(u))
                            end
                        end)
                    end
                    x = x + width * bit
                end
            end
        end
    end
end