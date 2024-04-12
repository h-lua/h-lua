---@class hrect
hrect = {
    _world = nil,
    _camera = nil,
    _playable = nil,
}

---@private
function hrect.alloc(r, name)
    if (hcache.exist(r) == false) then
        hcache.alloc(r)
        hcache.set(r, CONST_CACHE.RECT_NAME, name)
        hcache.set(r, CONST_CACHE.RECT_WIDTH, cj.GetRectMaxX(r) - cj.GetRectMinX(r))
        hcache.set(r, CONST_CACHE.RECT_HEIGHT, cj.GetRectMaxY(r) - cj.GetRectMinY(r))
        hcache.set(r, CONST_CACHE.RECT_X, cj.GetRectCenterX(r))
        hcache.set(r, CONST_CACHE.RECT_Y, cj.GetRectCenterY(r))
        hcache.set(r, CONST_CACHE.RECT_X_MIN, cj.GetRectMinX(r))
        hcache.set(r, CONST_CACHE.RECT_Y_MIN, cj.GetRectMinY(r))
        hcache.set(r, CONST_CACHE.RECT_X_MAX, cj.GetRectMaxX(r))
        hcache.set(r, CONST_CACHE.RECT_Y_MAX, cj.GetRectMaxY(r))
    end
end

--- 是否在区域内
function hrect.isInner(whichRect, x, y)
    return (x < hrect.getMaxX(whichRect) and x > hrect.getMinX(whichRect) and y < hrect.getMaxY(whichRect) and y > hrect.getMinY(whichRect))
end

--- 是否超出区域边界
---@param whichRect userdata
---@param x number
---@param y number
---@return boolean
function hrect.isBorder(whichRect, x, y)
    local flag = false
    if (x >= hrect.getMaxX(whichRect) or x <= hrect.getMinX(whichRect)) then
        flag = true
    end
    if (y >= hrect.getMaxY(whichRect) or y <= hrect.getMinY(whichRect)) then
        return true
    end
    return flag
end

--- 是否超出可玩区域
---@param x number
---@param y number
---@return boolean
function hrect.isBorderPlayable(x, y)
    return hrect.isBorder(hrect.playable(), x, y)
end

--- 是否超出镜头区域
---@param x number
---@param y number
---@return boolean
function hrect.isBorderCamera(x, y)
    return hrect.isBorder(hrect.camera(), x, y)
end

--- 获取地图世界区域
---@return userdata
function hrect.world()
    if (hrect._world == nil) then
        hrect._world = cj.GetWorldBounds()
        hrect.alloc(hrect._world)
    end
    return hrect._world
end

--- 获取地图镜头区域
---@return userdata
function hrect.camera()
    if (hrect._camera == nil) then
        hrect._camera = cj.Rect(cj.GetCameraBoundMinX(), cj.GetCameraBoundMinY(), cj.GetCameraBoundMaxX(), cj.GetCameraBoundMaxY())
        hrect.alloc(hrect._camera)
    end
    return hrect._camera
end

--- 获取地图可玩区域
---@return userdata
function hrect.playable()
    if (hrect._playable == nil) then
        hrect._playable = cj.Rect(
            cj.GetCameraBoundMinX() - cj.GetCameraMargin(CAMERA_MARGIN_LEFT),
            cj.GetCameraBoundMinY() - cj.GetCameraMargin(CAMERA_MARGIN_BOTTOM),
            cj.GetCameraBoundMaxX() + cj.GetCameraMargin(CAMERA_MARGIN_RIGHT),
            cj.GetCameraBoundMaxY() + cj.GetCameraMargin(CAMERA_MARGIN_TOP)
        )
        hrect.alloc(hrect._playable)
    end
    return hrect._playable
end

--- 创建一个设定中心（x,y）创建一个长w宽h的矩形区域
---@param x number
---@param y number
---@param w number
---@param h number
---@param name string
---@return userdata
function hrect.create(x, y, w, h, name)
    local minX = x - (w * 0.5)
    local minY = y - (h * 0.5)
    local maxX = x + (w * 0.5)
    local maxY = y + (h * 0.5)
    local r = cj.Rect(minX, minY, maxX, maxY)
    hrect.alloc(r, name or "")
    return r
end

--- 获取区域名称
---@param whichRect userdata
---@return string
function hrect.getName(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_NAME, '')
end

--- 获取区域中心坐标x
---@param whichRect userdata
---@return number
function hrect.getX(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X, 0)
end

--- 获取区域中心坐标y
---@param whichRect userdata
---@return number
function hrect.getY(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y, 0)
end

--- 获取区域的长
---@param whichRect userdata
---@return number
function hrect.getWidth(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_WIDTH, 0)
end

--- 获取区域的宽
---@param whichRect userdata
---@return number
function hrect.getHeight(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_HEIGHT, 0)
end

--- 获取区域的起点坐标x(左下角)
---@param whichRect userdata
---@return number
function hrect.getMinX(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X_MIN, 0)
end

--- 获取区域的起点坐标y(左下角)
---@param whichRect userdata
---@return number
function hrect.getMinY(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y_MIN, 0)
end

--- 获取区域的结束坐标x(右上角)
---@param whichRect userdata
---@return number
function hrect.getMaxX(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X_MAX, 0)
end

--- 获取区域的结束坐标y(右上角)
---@param whichRect userdata
---@return number
function hrect.getMaxY(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y_MAX, 0)
end

--- 删除区域
---@param whichRect userdata
---@param delay number|nil 延时
function hrect.destroy(whichRect, delay)
    delay = delay or 0
    if (delay == nil or delay <= 0) then
        hevent.free(whichRect)
        hcache.free(whichRect)
        cj.RemoveRect(whichRect)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            hevent.free(whichRect)
            hcache.free(whichRect)
            cj.RemoveRect(whichRect)
        end)
    end
end

--[[
   区域单位锁定
   options = {
        type 类型有：square|circle // 矩形(默)|圆形
        during 持续时间 必须大于0
        width 锁定活动范围长，大于0
        height 锁定活动范围宽，大于0
        lockRect 锁定区域时设置，可选
        lockUnit 锁定某个单位时设置，可选
        lockX 锁定某个坐标X时设置，可选
        lockY 锁定某个坐标Y时设置，可选
    }
]]
---@alias noteRectLock {type,during,width,height,lockRect,lockUnit,lockX,lockY}
---@param options noteRectLock
function hrect.lock(options)
    options.during = options.during or 0
    if (options.during <= 0 or (options.lockRect == nil and (options.width <= 0 or options.height <= 0))) then
        return
    end
    if (options.lockRect == nil and options.lockUnit == nil and (options.lockX == nil or options.lockY == nil)) then
        return
    end
    if (options.type == nil) then
        options.type = "square"
    end
    if (options.type ~= "square" and options.type ~= "circle") then
        return
    end
    local inc = 0
    local lockGroup = {}
    htime.setInterval(0.1, function(t)
        inc = inc + 1
        if (inc > (options.during / 0.10)) then
            t.destroy()
            hgroup.clear(lockGroup, false)
            return
        end
        local x = options.lockX
        local y = options.lockY
        local w = options.width
        local h = options.height
        --单位优先
        if (options.lockUnit) then
            if (hunit.isDead(options.lockUnit)) then
                t.destroy()
                return
            end
            x = hunit.x(options.lockUnit)
            y = hunit.y(options.lockUnit)
        end
        --区域优先
        if (options.lockRect) then
            x = cj.GetRectCenterX(options.lockRect)
            y = cj.GetRectCenterY(options.lockRect)
            if (w == nil) then
                w = hrect.getWidth(options.lockRect)
            end
            if (h == nil) then
                h = hrect.getHeight(options.lockRect)
            end
        end
        local lockRect
        local tempGroup
        if (options.type == "square") then
            lockRect = cj.Rect(x - (w * 0.5), y - (h * 0.5), x + (w * 0.5), y + (h * 0.5))
            tempGroup = hgroup.createByRect(lockRect)
        elseif (options.type == "circle") then
            tempGroup = hgroup.createByXY(x, y, math.min(w / 2, h / 2))
        end
        hgroup.forEach(tempGroup, function(u)
            hgroup.addUnit(lockGroup, u)
        end)
        tempGroup = nil
        hgroup.forEach(lockGroup, function(u)
            local distance = 0.000
            local deg = 0
            local xx = hunit.x(u)
            local yy = hunit.y(u)
            if (options.type == "square") then
                if (hrect.isBorder(lockRect, xx, yy) == true) then
                    deg = math.angle(x, y, xx, yy)
                    distance = math.getMaxDistanceInRect(w, h, deg)
                end
            elseif (options.type == "circle") then
                if (math.distance(x, y, xx, yy) > math.min(w / 2, h / 2)) then
                    deg = math.angle(x, y, xx, yy)
                    distance = math.min(w / 2, h / 2)
                end
            end
            if (distance > 0.0) then
                local px, py = math.polarProjection(x, y, distance, deg)
                hunit.portal(u, px, py)
                heffect.attach("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl", u, "origin", 0.2)
            end
        end)
        if (lockRect ~= nil) then
            hrect.destroy(lockRect)
        end
    end)
end
