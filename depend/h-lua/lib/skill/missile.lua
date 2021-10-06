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
    local speed = options.speed or 500
    speed = frequency * math.min(10000, math.max(50, speed))
    local acceleration = options.acceleration or 0
    local height = options.height or 0
    options.animateScale = options.animateScale or 1.00
    options.scale = options.scale or 1.00
    options.hover = options.hover or 0
    local dtcOri
    local facOri = 0
    if (options.startX == nil or options.startY == nil) then
        local pp = math.polarProjection(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), 70, facOri)
        options.startX = pp.x
        options.startY = pp.y
    end
    if (options.targetX ~= nil and options.targetY ~= nil) then
        facOri = math.getDegBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), options.targetX, options.targetY)
        dtcOri = math.getDistanceBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), options.targetX, options.targetY)
    else
        facOri = math.getDegBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), hunit.x(options.targetUnit), hunit.y(options.targetUnit))
        dtcOri = math.getDistanceBetweenXY(hunit.x(options.sourceUnit), hunit.y(options.sourceUnit), hunit.x(options.targetUnit), hunit.y(options.targetUnit))
    end
    local arrowToken = cj.AddSpecialEffect(options.missile, options.startX, options.startY)
    local rotateYOri = -math.min(90, height * 0.075)
    local rotateY = rotateYOri
    hjapi.EXEffectMatRotateY(arrowToken, rotateY)
    hjapi.EXEffectMatRotateZ(arrowToken, facOri)
    hjapi.EXSetEffectSpeed(arrowToken, options.animateScale)
    hjapi.EXSetEffectSize(arrowToken, options.scale)
    if (options.hover > 0) then
        hjapi.EXSetEffectZ(arrowToken, options.hover)
    end
    local ending = function(endX, endY, isFinish)
        if (options.hover > 0) then
            hjapi.EXSetEffectZ(arrowToken, options.hover)
        end
        if (arrowToken ~= nil) then
            cj.DestroyEffect(arrowToken)
            arrowToken = nil
        end
        local res = isFinish
        if (res == true and type(options.onEnd) == "function") then
            res = options.onEnd(options.sourceUnit, options.targetUnit, endX, endY)
        end
    end
    local dh = options.hover
    local limit = 0
    local faraway = 0
    local prevDist
    local ax = hjapi.EXGetEffectX(arrowToken)
    local ay = hjapi.EXGetEffectY(arrowToken)
    local shake = options.shake
    local shakeDirect = 1
    if (shake == "rand") then
        shake = math.rand(-1.00, 1.00)
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
        if (options.targetX ~= nil and options.targetY ~= nil) then
            tx = options.targetX
            ty = options.targetY
        else
            tx = hunit.x(options.targetUnit)
            ty = hunit.y(options.targetUnit)
            dtcOri = math.getDistanceBetweenXY(options.startX, options.startY, hunit.x(options.targetUnit), hunit.y(options.targetUnit))
        end
        local sh = 0
        if (shake ~= nil and shake ~= 0) then
            sh = shake * 75 * shakeDirect * math.getDistanceBetweenXY(ax, ay, tx, ty) / dtcOri
        end
        local fac = math.getDegBetweenXY(ax, ay, tx, ty) + sh
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
        hjapi.EXEffectMatRotateZ(arrowToken, fac - facOri)
        ax = nx
        ay = ny
        facOri = fac
        local curDist = math.getDistanceBetweenXY(ax, ay, tx, ty)
        if (height > 0 and curDist < dtcOri) then
            local gravity = options.height * frequency * speed * 0.35 * math.abs(0.5 - (curDist / dtcOri))
            local rotateYNew = rotateY
            if ((dtcOri - curDist) <= dtcOri / 2) then
                dh = dh + gravity
                local rateY = math.min(0.2, 0.3 / gravity)
                if (facOri > 90 and facOri < 270) then
                    rotateYNew = math.max(rotateYNew - rateY, -90)
                else
                    rotateYNew = math.min(rotateYNew + rateY, 0)
                end
            else
                dh = dh - gravity
                local rateY = -rotateYOri / 60
                if (facOri > 90 and facOri < 270) then
                    rotateYNew = math.max(rotateYNew - rateY, -105 + rotateYOri)
                else
                    rotateYNew = math.min(rotateYNew + rateY, -rotateYOri + 15)
                end
            end
            if (rotateYNew ~= rotateY) then
                hjapi.EXEffectMatRotateY(arrowToken, rotateYNew - rotateY)
                rotateY = rotateYNew
            end
            hjapi.EXSetEffectZ(arrowToken, math.max(dh, options.hover))
        end
        limit = limit + 1
        if (limit > 500 or his.deleted(options.sourceUnit)) then
            -- 超时消失
            htime.delTimer(curTimer)
            ending(nx, ny, false)
            return
        else
            -- 逃离消失
            if (prevDist ~= nil) then
                if (prevDist < curDist) then
                    faraway = faraway + 1
                    if (faraway > 50 or (curDist - prevDist > speed * 10)) then
                        htime.delTimer(curTimer)
                        ending(nx, ny, false)
                        return
                    end
                else
                    faraway = 0
                end
            end
            prevDist = curDist
        end
        if (curDist <= speed or speed <= 0) then
            htime.delTimer(curTimer)
            ending(nx, ny, true)
        end
    end)
end