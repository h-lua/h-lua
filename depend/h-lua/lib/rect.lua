---@class hrect
hrect = {
    _world = nil,
    _camera = nil,
    _playable = nil,
}

---@private
hrect.alloc = function(r, name)
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

--- 获取地图世界区域
---@return userdata
hrect.world = function()
    if (hrect._world == nil) then
        hrect._world = cj.GetWorldBounds()
        hrect.alloc(hrect._world)
    end
    return hrect._world
end

--- 获取地图镜头区域
---@return userdata
hrect.camera = function()
    if (hrect._camera == nil) then
        hrect._camera = cj.Rect(cj.GetCameraBoundMinX(), cj.GetCameraBoundMinY(), cj.GetCameraBoundMaxX(), cj.GetCameraBoundMaxY())
        hrect.alloc(hrect._camera)
    end
    return hrect._camera
end

--- 获取地图可玩区域
---@return userdata
hrect.playable = function()
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
hrect.create = function(x, y, w, h, name)
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
hrect.getName = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_NAME, '')
end

--- 获取区域中心坐标x
---@param whichRect userdata
---@return number
hrect.getX = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X, 0)
end

--- 获取区域中心坐标y
---@param whichRect userdata
---@return number
hrect.getY = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y, 0)
end

--- 获取区域的长
---@param whichRect userdata
---@return number
hrect.getWidth = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_WIDTH, 0)
end

--- 获取区域的宽
---@param whichRect userdata
---@return number
hrect.getHeight = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_HEIGHT, 0)
end

--- 获取区域的起点坐标x(左下角)
---@param whichRect userdata
---@return number
hrect.getMinX = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X_MIN, 0)
end

--- 获取区域的起点坐标y(左下角)
---@param whichRect userdata
---@return number
hrect.getMinY = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y_MIN, 0)
end

--- 获取区域的结束坐标x(右上角)
---@param whichRect userdata
---@return number
hrect.getMaxX = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_X_MAX, 0)
end

--- 获取区域的结束坐标y(右上角)
---@param whichRect userdata
---@return number
hrect.getMaxY = function(whichRect)
    hrect.alloc(whichRect)
    return hcache.get(whichRect, CONST_CACHE.RECT_Y_MAX, 0)
end

--- 删除区域
---@param whichRect userdata
---@param delay number|nil 延时
hrect.del = function(whichRect, delay)
    delay = delay or 0
    if (delay == nil or delay <= 0) then
        hevent.free(whichRect)
        hcache.free(whichRect)
        cj.RemoveRect(whichRect)
    else
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            hevent.free(whichRect)
            hcache.free(whichRect)
            cj.RemoveRect(whichRect)
        end)
    end
end

--- 区域单位锁定
---@param bean table
hrect.lock = function(bean)
    --[[
        bean = {
            type 类型有：square|circle // 矩形(默)|圆形
            during 持续时间 必须大于0
            width 锁定活动范围长，大于0
            height 锁定活动范围宽，大于0
            whichRect 锁定区域时设置，可选
            whichUnit 锁定某个单位时设置，可选
            whichLoc 锁定某个点时设置，可选
            whichX 锁定某个坐标X时设置，可选
            whichY 锁定某个坐标Y时设置，可选
        }
    ]]
    bean.during = bean.during or 0
    if (bean.during <= 0 or (bean.whichRect == nil and (bean.width <= 0 or bean.height <= 0))) then
        return
    end
    if (bean.whichRect == nil and bean.whichUnit == nil and bean.whichLoc == nil
        and (bean.whichX == nil or bean.whichY == nil)) then
        return
    end
    if (bean.type == nil) then
        bean.type = "square"
    end
    if (bean.type ~= "square" and bean.type ~= "circle") then
        return
    end
    local inc = 0
    local lockGroup = {}
    htime.setInterval(0.1, function(t)
        inc = inc + 1
        if (inc > (bean.during / 0.10)) then
            htime.delTimer(t)
            hgroup.clear(lockGroup, true, false)
            return
        end
        local x = bean.whichX
        local y = bean.whichY
        local w = bean.width
        local h = bean.height
        --点优先
        if (bean.whichLoc) then
            x = cj.GetLocationX(bean.whichLoc)
            y = cj.GetLocationY(bean.whichLoc)
        end
        --单位优先
        if (bean.whichUnit) then
            if (his.dead(bean.whichUnit)) then
                htime.delTimer(t)
                return
            end
            x = hunit.x(bean.whichUnit)
            y = hunit.y(bean.whichUnit)
        end
        --区域优先
        if (bean.whichRect) then
            x = cj.GetRectCenterX(bean.whichRect)
            y = cj.GetRectCenterY(bean.whichRect)
            if (w == nil) then
                w = hrect.getWidth(bean.whichRect)
            end
            if (h == nil) then
                h = hrect.getHeight(bean.whichRect)
            end
        end
        local lockRect
        local tempGroup
        if (bean.type == "square") then
            lockRect = cj.Rect(x - (w * 0.5), y - (h * 0.5), x + (w * 0.5), y + (h * 0.5))
            tempGroup = hgroup.createByRect(lockRect)
        elseif (bean.type == "circle") then
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
            if (bean.type == "square") then
                if (his.borderRect(lockRect, xx, yy) == true) then
                    deg = math.getDegBetweenXY(x, y, xx, yy)
                    distance = math.getMaxDistanceInRect(w, h, deg)
                end
            elseif (bean.type == "circle") then
                if (math.getDistanceBetweenXY(x, y, xx, yy) > math.min(w / 2, h / 2)) then
                    deg = math.getDegBetweenXY(x, y, xx, yy)
                    distance = math.min(w / 2, h / 2)
                end
            end
            if (distance > 0.0) then
                local polar = math.polarProjection(x, y, distance, deg)
                hunit.portal(u, polar.x, polar.y)
                heffect.bindUnit("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl", u, "origin", 0.2)
            end
        end)
        if (lockRect ~= nil) then
            hrect.del(lockRect)
        end
    end)
end
