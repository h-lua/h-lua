hweather = {
    --天气ID
    sun = c2i("LRaa"), --日光
    moon = c2i("LRma"), --月光
    shield = c2i("MEds"), --紫光盾
    rain = c2i("RAlr"), --雨
    rainstorm = c2i("RAhr"), --大雨
    snow = c2i("SNls"), --雪
    snowstorm = c2i("SNhs"), --大雪
    wind = c2i("WOlw"), --风
    windstorm = c2i("WNcw"), --大风
    mistwhite = c2i("FDwh"), --白雾
    mistgreen = c2i("FDgh"), --绿雾
    mistblue = c2i("FDbh"), --蓝雾
    mistred = c2i("FDrh") --红雾
}

--- 删除天气
---@param w userdata
---@param delay number
function hweather.destroy(w, delay)
    delay = delay or 0
    if (delay <= 0) then
        cj.EnableWeatherEffect(w, false)
        cj.RemoveWeatherEffect(w)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            cj.EnableWeatherEffect(w, false)
            cj.RemoveWeatherEffect(w)
        end)
    end
end

--[[
    创建天气
    options = {
        x=0,y=0,
        w=0,h=0,
        whichRect=nil,
        type=hweather.sun, --天气类型
        during=0, --默认持续时间小于等于0:无限
    }
]]
---@alias noteWeatherCreate {x:number,y:number,w:number,h:number,whichRect:userdata,type:number,during:number}
---@param options noteWeatherCreate
---@return userdata
function hweather.create(options)
    if (options.whichRect == nil) then
        if (options.w == nil or options.h == nil or options.w <= 0 or options.h <= 0) then
            err("hweather.create -w-h")
            return nil
        end
        if (options.x == nil or options.y == nil) then
            err("hweather.create -x-y")
            return nil
        end
    end
    if (options.type == nil) then
        err("hweather.create -type")
        return nil
    end
    options.during = options.during or 0
    if (options.whichRect == nil) then
        options.whichRect = hrect.create(options.x, options.y, options.w, options.h)
        if (options.during > 0) then
            hrect.destroy(options.whichRect, options.during)
        end
    end
    local w = cj.AddWeatherEffect(options.whichRect, options.type)
    cj.EnableWeatherEffect(w, true)
    if (options.during > 0) then
        hweather.destroy(w, options.during)
    end
    return w
end
