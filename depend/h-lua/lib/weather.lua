hweather = {
    --天气ID
    sun = string.char2id("LRaa"), --日光
    moon = string.char2id("LRma"), --月光
    shield = string.char2id("MEds"), --紫光盾
    rain = string.char2id("RAlr"), --雨
    rainstorm = string.char2id("RAhr"), --大雨
    snow = string.char2id("SNls"), --雪
    snowstorm = string.char2id("SNhs"), --大雪
    wind = string.char2id("WOlw"), --风
    windstorm = string.char2id("WNcw"), --大风
    mistwhite = string.char2id("FDwh"), --白雾
    mistgreen = string.char2id("FDgh"), --绿雾
    mistblue = string.char2id("FDbh"), --蓝雾
    mistred = string.char2id("FDrh") --红雾
}

--- 删除天气
---@param w userdata
---@param delay number
hweather.del = function(w, delay)
    delay = delay or 0
    if (delay <= 0) then
        cj.EnableWeatherEffect(w, false)
        cj.RemoveWeatherEffect(w)
    else
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            cj.EnableWeatherEffect(w, false)
            cj.RemoveWeatherEffect(w)
        end)
    end
end

--- 创建天气
---@param bean table
hweather.create = function(bean)
    --[[
        bean = {
            x=0,y=0,w=0,h=0,
            whichRect=nil,
            type=hweather.sun 天气类型
            during=0 默认持续时间小于等于0:无限
        }
    ]]
    if (bean.whichRect == nil) then
        if (bean.w == nil or bean.h == nil or bean.w <= 0 or bean.h <= 0) then
            print_err("hweather.create -w-h")
            return nil
        end
        if (bean.x == nil or bean.y == nil) then
            print_err("hweather.create -x-y")
            return nil
        end
    end
    if (bean.type == nil) then
        print_err("hweather.create -type")
        return nil
    end
    bean.during = bean.during or 0
    local w
    if (bean.whichRect ~= nil) then
        w = cj.AddWeatherEffect(bean.whichRect, bean.type)
    else
        local r = hrect.create(bean.x, bean.y, bean.w, bean.h)
        w = cj.AddWeatherEffect(r, bean.type)
        if (bean.during > 0) then
            hrect.del(r, bean.during)
        end
    end
    cj.EnableWeatherEffect(w, true)
    if (bean.during > 0) then
        hweather.del(w, bean.during)
    end
end
