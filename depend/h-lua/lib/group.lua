---@class hgroup 单位组
hgroup = { GLOBAL = {} }

--- 遍历单位组
--- 遍历过程中返回 false 则中断
---@param whichGroup table
---@param action fun(enumUnit:userdata, idx:number)
---@return void
function hgroup.forEach(whichGroup, action)
    if (whichGroup == nil) then
        return
    end
    if (#whichGroup > 0) then
        if (type(action) == "function") then
            for idx, eu in ipairs(whichGroup) do
                if (hunit.isDestroyed(eu) == false) then
                    local res = action(eu, idx)
                    if (type(res) == "boolean" and res == false) then
                        break
                    end
                else
                    table.remove(whichGroup, idx)
                    idx = idx - 1
                end
            end
        end
    end
end

--- 统计单位组当前单位数
---@param whichGroup table
---@return number
function hgroup.count(whichGroup)
    if (whichGroup == nil) then
        return 0
    end
    return #whichGroup
end

--- 判断单位是否在单位组内
---@param whichGroup table
---@param whichUnit userdata
---@return boolean
function hgroup.includes(whichGroup, whichUnit)
    if (whichGroup == nil or whichUnit == nil) then
        return false
    end
    return table.includes(whichGroup, whichUnit)
end

--- 判断单位组是否为空
---@param whichGroup table
---@return boolean
function hgroup.isEmpty(whichGroup)
    if (whichGroup == nil or #whichGroup == 0) then
        return true
    end
    return false
end

--- 单位组添加单位
---@param whichGroup table
---@param whichUnit userdata
---@return void
function hgroup.addUnit(whichGroup, whichUnit)
    if (hgroup.includes(whichGroup, whichUnit) == false) then
        table.insert(whichGroup, whichUnit)
    end
end
--- 单位组删除单位
---@param whichGroup table
---@param whichUnit userdata
---@return void
function hgroup.removeUnit(whichGroup, whichUnit)
    if (hgroup.includes(whichGroup, whichUnit) == true) then
        table.delete(whichGroup, whichUnit)
    end
end

--- 创建单位组,以(x,y)点为中心radius距离
---@alias GroupFilter fun(filterUnit:userdata)
---@param x number
---@param y number
---@param radius number
---@param filterFunc GroupFilter
---@return userdata[]
function hgroup.createByXY(x, y, radius, filterFunc)
    if (#hgroup.GLOBAL == 0) then
        return {}
    end
    local g = {}
    for idx, filterUnit in ipairs(hgroup.GLOBAL) do
        if (hunit.isDestroyed(filterUnit)) then
            table.remove(hgroup.GLOBAL, idx)
            idx = idx - 1
        end
        -- 排除超过距离的单位
        if (radius >= math.distance(x, y, hunit.x(filterUnit), hunit.y(filterUnit))) then
            if (filterFunc ~= nil) then
                if (filterFunc(filterUnit) == true) then
                    table.insert(g, filterUnit)
                end
            else
                table.insert(g, filterUnit)
            end
        end
    end
    return g
end

--- 创建单位组,以某个单位为中心radius距离
---@param u userdata
---@param radius number
---@param filterFunc GroupFilter
---@return userdata[]
function hgroup.createByUnit(u, radius, filterFunc)
    return hgroup.createByXY(hunit.x(u), hunit.y(u), radius, filterFunc)
end

--- 创建单位组,以区域为范围选择
---@param r userdata
---@param filterFunc GroupFilter
---@return userdata[]
function hgroup.createByRect(r, filterFunc)
    if (#hgroup.GLOBAL == 0) then
        return {}
    end
    local g = {}
    for idx, filterUnit in ipairs(hgroup.GLOBAL) do
        if (hunit.isDestroyed(filterUnit)) then
            table.remove(hgroup.GLOBAL, idx)
            idx = idx - 1
        end
        -- 排除区域外
        if (hrect.isInner(r, hunit.x(filterUnit), hunit.y(filterUnit))) then
            if (filterFunc ~= nil) then
                if (filterFunc(filterUnit) == true) then
                    table.insert(g, filterUnit)
                end
            else
                table.insert(g, filterUnit)
            end
        end
    end
    return g
end

--- 获取单位组内离选定的(x,y)最近的单位
---@param whichGroup userdata
---@param x number
---@param y number
---@return userdata 单位
---@return void
function hgroup.getClosest(whichGroup, x, y)
    if (whichGroup == nil or x == nil or y == nil) then
        return
    end
    if (hgroup.count(whichGroup) == 0) then
        return
    end
    local closeDist = 99999
    local closeUnit
    hgroup.forEach(whichGroup, function(eu)
        local dist = math.distance(x, y, hunit.x(eu), hunit.y(eu))
        if (dist < closeDist) then
            closeUnit = eu
        end
    end)
    return closeUnit
end

--- 瞬间移动单位组
---@param whichGroup userdata
---@param x number
---@param y number
---@param eff string
---@param isFollow boolean
---@return void
function hgroup.portal(whichGroup, x, y, eff, isFollow)
    if (whichGroup == nil or x == nil or y == nil) then
        return
    end
    hgroup.forEach(whichGroup, function(eu)
        hunit.portal(eu, x, y)
        if (isFollow == true) then
            cj.PanCameraToTimedForPlayer(hunit.getOwner(eu), x, y, 0.00)
        end
        if (eff ~= nil) then
            heffect.xyz(eff, x, y, nil, 0)
        end
    end)
end

--- 指挥单位组所有单位做动作
---@param whichGroup userdata
---@param animate string | number
---@return void
function hgroup.animate(whichGroup, animate)
    if (whichGroup == nil or animate == nil) then
        return
    end
    hgroup.forEach(whichGroup, function(eu)
        if (hunit.isDead(eu) == false) then
            hunit.animate(eu, animate)
        end
    end)
end

--- 清空单位组
---@param whichGroup userdata
---@param isDestroyUnit boolean 是否同时删除单位组里面的单位
---@return void
function hgroup.clear(whichGroup, isDestroyUnit)
    if (whichGroup == nil) then
        return
    end
    if (isDestroyUnit == true) then
        hgroup.forEach(whichGroup, function(eu)
            hunit.destroy(eu)
        end)
    end
end
