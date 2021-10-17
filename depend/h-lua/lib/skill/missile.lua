--[[
    虚拟箭矢
    missile = nil, --[必须]虚拟箭矢的特效
    animateScale = 1.00, --虚拟箭矢的动画速度
    scale = 1.00, --虚拟箭矢的模型缩放
    hover = 0.00, --虚拟箭矢的初始离地高度
    speed = 500, --每秒冲击的距离（可选的，默认1秒500px)
    acceleration = 0, --冲击加速度（可选的，每个周期[0.02秒]都会增加一次)
    height = 0, --飞跃高度（可选的，默认0)
    shake = 0, --摇摆振幅程度度[0.00~1.00|rand]（可选的，默认0)
    sourceUnit, --[必须]伤害来源
    targetUnit, --[可选]目标单位（有单位目标，那么冲击跟踪到单位就结束）
    targetX, --[可选]冲击的目标x坐标（对点冲击）比targetUnit优先级高
    targetY, --[可选]冲击的目标y坐标
    startX = [sourceUnit.x], --强制设定初始创建的x坐标（可选的，同时设定 startY 时才有效）
    startY = [sourceUnit.y], --强制设定初始创建的y坐标（可选的，同时设定 startX 时才有效）
    onMove = [function], --每周期移动回调,return false时可强行中止循环
    onEnd = [function], --结束回调
]]
---@alias abilityMissileOnEvt fun(sourceUnit:userdata,targetUnit:userdata,x:number,y:number):nil|boolean
---@alias abilityMissileOptions {missile:string,animateScale:number,scale,hover,speed,acceleration,height,shake,sourceUnit:userdata,targetUnit:userdata,targetX,targetY,startX,startY,onMove:abilityMissileOnEvt,onEnd:abilityMissileOnEvt}
---@param options abilityMissileOptions
hskill.missile = function(options)
    if (options.missile == nil) then
        return print_err("missile")
    end
    if (options.sourceUnit == nil) then
        return print_err("sourceUnit")
    end
    if (options.targetX == nil or options.targetY == nil) then
        if (options.targetUnit == nil) then
            return print_err("targetUnit")
        end
    end
    local frequency = 0.02
    local speed = math.min(10000, math.max(50, options.speed or 500))
    local acceleration = options.acceleration or 0
    local height = options.height or 0
    local hover = options.hover or 0
    options.animateScale = options.animateScale or 1.00
    options.scale = options.scale or 1.00
    local fac0 = 0
    local dct0 = 0
    local sourceH = hover + hunit.z(options.sourceUnit)
    local targetH = 0
    if (options.startX == nil or options.startY == nil) then
        local collision = tonumber(hslk.i2v(hunit.getId(options.sourceUnit), "slk", "collision")) or 30
        local pp = math.polarProjection(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), collision, fac0)
        options.startX = pp.x
        options.startY = pp.y
    end
    if (options.targetX ~= nil and options.targetY ~= nil) then
        targetH = hover + japi.GetZ(options.targetX, options.targetY)
        fac0 = math.getDegBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), options.targetX, options.targetY)
        dct0 = math.getDistanceBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), options.targetX, options.targetY)
    else
        targetH = hover + hunit.z(options.targetUnit) + hunit.getFlyHeight(options.targetUnit)
        fac0 = math.getDegBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), hunit.x(options.targetUnit), hunit.y(options.targetUnit))
        dct0 = math.getDistanceBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), hunit.x(options.targetUnit), hunit.y(options.targetUnit))
    end
    if (dct0 < 300) then
        height = dct0 / 2
    end
    local arrowToken = cj.AddSpecialEffect(options.missile, options.startX, options.startY)
    hjapi.EXEffectMatRotateZ(arrowToken, fac0)
    hjapi.EXSetEffectSpeed(arrowToken, options.animateScale)
    hjapi.EXSetEffectSize(arrowToken, options.scale)
    local gsep = (dct0 / 2) / speed / frequency
    local topH
    local rotateY1 = 0
    local rotateY2 = 0
    local rotateY1i = 0
    local rotateY2i = 0
    local gravity1 = 0
    local gravity2 = 0
    local sd = (dct0 / speed / frequency / 2)
    if (sourceH >= targetH) then
        topH = sourceH + height
        rotateY1 = math_rad2deg * math.atan(height, dct0 / 2)
        rotateY1i = rotateY1 / sd
        rotateY2 = math_rad2deg * math.atan(topH, dct0 / 2)
        rotateY2i = rotateY2 / sd
        gravity1 = height / gsep
        gravity2 = (topH - 50) / gsep
    else
        topH = targetH + height
        rotateY1 = math_rad2deg * math.atan(topH, dct0 / 2)
        rotateY1i = rotateY1 / sd
        rotateY2 = math_rad2deg * math.atan(height, dct0 / 2)
        rotateY2i = rotateY2 / sd
        gravity1 = (topH + math.abs(hunit.z(options.sourceUnit) - hunit.z(options.targetUnit))) / gsep
        gravity2 = (height - 50) / gsep
    end

    local rotateY = -rotateY1
    if (fac0 > 90 and fac0 < 270) then
        rotateY = -rotateY
    end
    speed = frequency * speed
    hjapi.EXEffectMatRotateY(arrowToken, rotateY)
    hjapi.EXSetEffectZ(arrowToken, sourceH)
    local ending = function(endX, endY, isFinish)
        if (arrowToken ~= nil) then
            cj.DestroyEffect(arrowToken)
            arrowToken = nil
        end
        local res = isFinish
        if (res == true and type(options.onEnd) == "function") then
            res = options.onEnd(options.sourceUnit, options.targetUnit, endX, endY)
        end
    end
    local curH = sourceH
    local limit = 0
    local faraway = 0
    local prevDist
    local ax = hjapi.EXGetEffectX(arrowToken)
    local ay = hjapi.EXGetEffectY(arrowToken)
    local shake = options.shake
    local shakeDirect = 1
    if (shake == "rand") then
        shake = math.random(-1.00, 1.00)
    elseif (type(shake) == "number") then
        shake = math.min(1.00, math.max(0, shake))
    end
    if (math.random(1, 2) == 1) then
        shakeDirect = -1
    end
    htime.setInterval(frequency, function(curTimer)
        if (arrowToken == nil or his.deleted(options.sourceUnit) or (options.targetUnit ~= nil and his.deleted(options.targetUnit))) then
            htime.delTimer(curTimer)
            ending(ax, ay, false)
            return
        end
        local tx = 0
        local ty = 0
        local dct = 0
        if (options.targetX ~= nil and options.targetY ~= nil) then
            tx = options.targetX
            ty = options.targetY
            dct = dct0
        else
            tx = hunit.x(options.targetUnit)
            ty = hunit.y(options.targetUnit)
            dct = math.getDistanceBetweenXY(options.startX, options.startY, hunit.x(options.targetUnit), hunit.y(options.targetUnit))
        end
        local fac
        if (shake ~= nil and shake ~= 0) then
            fac = math.getDegBetweenXY(ax, ay, tx, ty) + shake * 75 * shakeDirect * math.getDistanceBetweenXY(ax, ay, tx, ty) / dct
        else
            fac = math.getDegBetweenXY(ax, ay, tx, ty)
        end
        local pp = math.polarProjection(ax, ay, speed, fac)
        local nx = pp.x
        local ny = pp.y
        if (acceleration ~= 0) then
            speed = speed + acceleration
        end
        if (his.borderMap(nx, ny)) then
            htime.delTimer(curTimer)
            ending(ax, ay, false)
            return
        end
        if (type(options.onMove) == "function") then
            local mRes = options.onMove(options.sourceUnit, options.targetUnit, nx, ny)
            if (mRes == false) then
                htime.delTimer(curTimer)
                ending(ax, ay, false)
                return
            end
        end
        hjapi.EXSetEffectXY(arrowToken, nx, ny)
        hjapi.EXEffectMatRotateZ(arrowToken, fac - fac0)
        ax = nx
        ay = ny
        fac0 = fac
        local curD = math.getDistanceBetweenXY(ax, ay, tx, ty)
        if (curD < dct) then
            local halfD = dct / 2
            local rot = 0
            local di = 2 * (math.disparity(curD, halfD) / halfD)
            if (curD >= halfD) then
                curH = curH + gravity1 * di
                rot = rotateY1i * (2 - di)
            else
                curH = curH - gravity2 * di
                rot = 1.3 * rotateY2i * (2 - di)
            end
            if (fac0 > 90 and fac0 < 270) then
                rot = -rot
            end
            hjapi.EXEffectMatRotateY(arrowToken, rot)
            hjapi.EXSetEffectZ(arrowToken, curH)
        end
        limit = limit + 1
        if (limit > 400 or his.deleted(options.sourceUnit)) then
            -- 超时消失
            htime.delTimer(curTimer)
            ending(nx, ny, false)
            return
        else
            -- 逃离消失
            if (prevDist ~= nil) then
                if (prevDist < curD) then
                    faraway = faraway + 1
                    if (faraway > 50 or (curD - prevDist > speed * 10)) then
                        htime.delTimer(curTimer)
                        ending(nx, ny, false)
                        return
                    end
                else
                    faraway = 0
                end
            end
            prevDist = curD
        end
        if (curD <= speed or speed <= 0) then
            htime.delTimer(curTimer)
            ending(nx, ny, true)
        end
    end)
end