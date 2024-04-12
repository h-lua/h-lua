hcamera = {}

--- 重置镜头
---@param whichPlayer userdata
---@param during number
---@return void
function hcamera.reset(whichPlayer, during)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.ResetToGameCamera(during)
    end
end

--- 应用镜头
---@param whichPlayer userdata
---@param during number
---@param cameraSetup userdata
---@return void
function hcamera.apply(whichPlayer, during, cameraSetup)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.CameraSetupApplyForceDuration(cameraSetup, true, during)
    end
end

--- 移动到XY
---@param whichPlayer userdata
---@param during number
---@param x number
---@param y number
---@return void
function hcamera.toXY(whichPlayer, during, x, y)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.PanCameraToTimed(x, y, during)
    end
end

--- 移动到单位位置
---@param whichPlayer userdata
---@param during number
---@param whichUnit userdata
---@return void
function hcamera.toUnit(whichPlayer, during, whichUnit)
    if (whichUnit == nil) then
        return
    end
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.PanCameraToTimed(hunit.x(whichUnit), hunit.y(whichUnit), during)
    end
end

--- 锁定镜头
---@param whichPlayer userdata
---@param whichUnit userdata
---@return void
function hcamera.lock(whichPlayer, whichUnit)
    if (whichPlayer ~= nil or hplayer.loc() == whichPlayer) then
        if (hunit.isAlive(whichUnit) == true) then
            cj.SetCameraTargetController(whichUnit, 0, 0, false)
        else
            hcamera.reset(whichPlayer, 0)
        end
    end
end

--- 更改镜头距离
---@param whichPlayer userdata
---@param diffDistance number
---@return void
function hcamera.changeDistance(whichPlayer, diffDistance)
    if (type(diffDistance) ~= "number") then
        diffDistance = 0
    end
    if (diffDistance ~= 0 and whichPlayer ~= nil and hplayer.loc() == whichPlayer) then
        local oldDistance = cj.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
        local toDistance = math.floor(oldDistance + diffDistance)
        if (toDistance < 500) then
            toDistance = 500
        elseif (toDistance > 5000) then
            toDistance = 5000
        end
        echo("视距已设定为：" .. toDistance, whichPlayer)
        if (oldDistance == toDistance) then
            return
        else
            cj.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, toDistance, 0)
        end
    end
end

--- 镜头摇晃
---@param whichPlayer userdata 玩家
---@param magnitude number 幅度
---@param velocity number 速率
---@param duration number 持续时间
---@return void
function hcamera.shake(whichPlayer, magnitude, velocity, duration)
    magnitude = magnitude or 0
    velocity = velocity or 0
    duration = duration or 0
    if (magnitude <= 0 or velocity <= 0 or duration <= 0) then
        return
    end
    hplayer.setCameraShaking(whichPlayer, 1)
    if (hplayer.loc() == whichPlayer) then
        cj.CameraSetTargetNoise(magnitude, velocity)
    end
    htime.setTimeout(duration, function()
        hplayer.setCameraShaking(whichPlayer, -1)
        if (false == hplayer.isCameraShaking(whichPlayer)) then
            if (hplayer.loc() == whichPlayer) then
                cj.CameraSetTargetNoise(0, 0)
            end
        end
    end)
end

--- 镜头震动
---@param magnitude number 幅度
---@param duration number 持续时间
---@return void
function hcamera.quake(whichPlayer, magnitude, duration)
    magnitude = magnitude or 0
    duration = duration or 0
    if (magnitude <= 0 or duration <= 0) then
        return
    end
    local richter = magnitude
    if (richter > 5) then
        richter = 5
    end
    if (richter < 2) then
        richter = 2
    end
    hplayer.setCameraQuaking(whichPlayer, 1)
    cj.CameraSetTargetNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
    cj.CameraSetSourceNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
    htime.setTimeout(duration, function()
        hplayer.setCameraQuaking(whichPlayer, -1)
        if (hplayer.loc() == whichPlayer) then
            if (false == hplayer.isCameraQuaking(whichPlayer)) then
                cj.CameraSetSourceNoise(0, 0)
                if (false == hplayer.isCameraShaking(whichPlayer)) then
                    cj.CameraSetTargetNoise(0, 0)
                end
            end
        end
    end)
end
