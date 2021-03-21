---@class htime
htime = {
    -- 获取开始游戏后经过的总秒数
    count = 0,
    -- 时
    hour = 0,
    -- 分
    min = 0,
    -- 秒
    sec = 0,
    -- 池
    pool = {},
    -- 内核
    kernel = {},
    -- 反射
    reflect = {},
}
--- 时钟
---@private
htime.clock = function()
    htime.count = htime.count + 1
    htime.sec = htime.sec + 1
    if (htime.sec >= 60) then
        htime.sec = 0
        htime.min = htime.min + 1
        if (htime.min >= 60) then
            htime.hour = htime.hour + 1
            htime.min = 0
        end
    end
end
--- 获取时分秒
---@return string HH:ii:ss
htime.his = function()
    local str = ""
    if (htime.hour < 10) then
        str = str .. "0" .. htime.hour
    else
        str = str .. htime.hour
    end
    str = str .. ":"
    if (htime.min < 10) then
        str = str .. "0" .. htime.min
    else
        str = str .. htime.min
    end
    str = str .. ":"
    if (htime.sec < 10) then
        str = str .. "0" .. htime.sec
    else
        str = str .. htime.sec
    end
    return str
end
--- 从池中获取一个带窗口计时器
---@private
htime.timerInPool = function()
    local t
    local td
    for _, v in ipairs(htime.pool) do
        if (v.free == true) then
            v.free = false
            t = v.timer
            td = v.dialog
            break
        end
    end
    if (t == nil) then
        t = cj.CreateTimer()
        td = cj.CreateTimerDialog(t)
        table.insert(htime.pool, {
            free = false,
            timer = t,
            dialog = td
        })
    end
    return { t, td }
end
--- 从内核中获取一个计时器（实际上这里获得的是timer key）
---@private
htime.timerInKernel = function(time, yourFunc, isInterval)
    local space = 0
    if (time >= 500) then
        space = 1
    elseif (time >= 100) then
        space = 0.5
    elseif (time >= 10) then
        space = 0.2
    elseif (time >= 1) then
        space = 0.1
    elseif (time >= 0.1) then
        space = 0.05
    else
        space = 0.01
    end
    if (type(isInterval) ~= "boolean") then
        isInterval = false
    end
    if (htime.kernel[space] == nil) then
        htime.kernel[space] = {}
        local t = cj.CreateTimer()
        cj.TimerStart(
            t,
            space,
            true,
            function()
                for k, v in ipairs(htime.kernel[space]) do
                    if (v.running == true) then
                        v.remain = v.remain - space
                        if (v.remain <= 0) then
                            local status, sErr = xpcall(v.yourFunc, debug.traceback, string.implode("_", { space, k }))
                            if (status == true) then
                                if (v.isInterval == true) then
                                    v.remain = v.set
                                else
                                    --修改标志保留数据，可复用
                                    v.running = false
                                end
                            else
                                --执行出错时直接停跑，打印错误
                                v.running = false
                                print(sErr)
                            end
                        end
                    end
                end
            end
        )
    end
    local kernelClock = -1
    for k, v in ipairs(htime.kernel[space]) do
        if (v.running == false) then
            kernelClock = k
            break
        end
    end
    if (kernelClock == -1) then
        table.insert(htime.kernel[space], {
            running = true,
            isInterval = isInterval,
            set = time,
            remain = time,
            yourFunc = yourFunc,
        })
        kernelClock = #htime.kernel[space]
    else
        htime.kernel[space][kernelClock] = {
            running = true,
            isInterval = isInterval,
            set = time,
            remain = time,
            yourFunc = yourFunc
        }
    end
    return string.implode("_", { space, kernelClock })
end
--- 内核数据
---@private
htime.kernelInfo = function(t)
    local index = string.explode("_", t)
    local space = tonumber(index[1])
    local k = tonumber(index[2])
    return { space, k }
end

--- 获取计时器设置时间
---@param t string
---@return number
htime.getSetTime = function(t)
    local k = htime.kernelInfo(t)
    return htime.kernel[k[1]][k[2]].set
end

--- 获取计时器剩余时间
---@param t string
---@return number
htime.getRemainTime = function(t)
    local k = htime.kernelInfo(t)
    return htime.kernel[k[1]][k[2]].remain
end

--- 获取计时器已过去时间
---@param t string
---@return number
htime.getElapsedTime = function(t)
    local k = htime.kernelInfo(t)
    local set = htime.kernel[k[1]][k[2]].set
    local remain = htime.kernel[k[1]][k[2]].remain
    return set - remain
end

--- 删除计时器
---@param t string
htime.delTimer = function(t)
    if (t == nil) then
        return
    end
    -- 清理反射的隐藏计时器
    if (htime.reflect[t] ~= nil) then
        cj.PauseTimer(htime.reflect[t])
        for _, v in ipairs(htime.pool) do
            if (htime.reflect[t] == v.timer) then
                cj.TimerDialogDisplay(v.dialog, false)
                v.free = true
                break
            end
        end
        htime.reflect[t] = nil
    end
    local k = htime.kernelInfo(t)
    if (htime.kernel[k[1]] ~= nil and htime.kernel[k[1]][k[2]] ~= nil) then
        htime.kernel[k[1]][k[2]].running = false
    end
end
-- 设置一次性计时器
---@param frequency number
---@param yourFunc function | "function(curTimer) end"
---@param title string
---@return string
htime.setTimeout = function(frequency, yourFunc, title)
    local t = htime.timerInKernel(frequency, yourFunc, false)
    if (title ~= nil) then
        local pool = htime.timerInPool()
        local t2 = pool[1]
        local td = pool[2]
        cj.TimerDialogSetTitle(td, title)
        cj.TimerDialogDisplay(td, true)
        cj.TimerStart(t2, frequency, false, nil)
        htime.reflect[t] = t2
    end
    return t
end
--- 设置周期性计时器
---@param frequency number
---@param yourFunc function | "function(curTimer) end"
---@param title string
---@return string
htime.setInterval = function(frequency, yourFunc, title)
    local t = htime.timerInKernel(frequency, yourFunc, true)
    if (title ~= nil) then
        local pool = htime.timerInPool()
        local t2 = pool[1]
        local td = pool[2]
        cj.TimerDialogSetTitle(td, title)
        cj.TimerDialogDisplay(td, true)
        cj.TimerStart(t2, frequency, true, nil)
        htime.reflect[t] = t2
    end
    return t
end
