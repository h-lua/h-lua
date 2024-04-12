---@class hitem 物品
hitem = {}

--- 物品是否已被销毁
---@param whichItem userdata
---@return boolean
function hitem.isDestroyed(whichItem)
    return cj.GetItemTypeId(whichItem) == 0
end

--- 获取物品X坐标
---@param it userdata
---@return number
function hitem.x(it)
    return cj.GetItemX(it)
end

--- 获取物品Y坐标
---@param it userdata
---@return number
function hitem.y(it)
    return cj.GetItemY(it)
end

--- 获取物品Z坐标
---@param it userdata
---@return number
function hitem.z(it)
    return hjapi.Z(cj.GetItemX(it), cj.GetItemY(it))
end

-- 清理物品缓存数据
---@protected
function hitem.free(whichItem)
    hitemPool.free(whichItem)
    hevent.free(whichItem)
    hcache.free(whichItem)
end

--- match done
---@param whichUnit userdata
---@param whichItem userdata
---@param triggerData table
function hitem.used(whichUnit, whichItem, triggerData)
    triggerData = triggerData or {}
    triggerData.triggerUnit = whichUnit
    triggerData.triggerItem = whichItem
    hevent.trigger(whichUnit, CONST_EVENT.itemUsed, triggerData)
end

--- 删除物品，可延时
---@param it userdata
---@param delay number
function hitem.destroy(it, delay)
    if (hitem.isDestroyed(it)) then
        return
    end
    delay = delay or 0
    if (delay <= 0 and it ~= nil) then
        hitem.free(it)
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            if (hitem.isDestroyed(it)) then
                return
            end
            hitem.free(it)
            cj.SetWidgetLife(it, 1.00)
            cj.RemoveItem(it)
        end)
    end
end

---@protected
function hitem.destroyFromUnit(whichUnit)
    if (whichUnit ~= nil) then
        hitem.forEach(whichUnit, function(enumItem)
            if (enumItem ~= nil) then
                hitem.destroy(enumItem)
            end
        end)
    end
end

--- 获取物品ID字符串
---@param itOrId userdata|number|string
---@return string|nil
function hitem.getId(itOrId)
    local id
    if (type(itOrId) == "userdata") then
        id = cj.GetItemTypeId(itOrId)
        if (id == 0) then
            return
        end
        id = i2c(id)
    elseif (type(itOrId) == "number") then
        id = i2c(itOrId)
    elseif (type(itOrId) == "string") then
        id = itOrId
    end
    return id
end

--- 获取物品名称
---@param itOrId userdata|string|number
---@return string
function hitem.getName(itOrId)
    local n = ""
    if (type(itOrId) == "userdata") then
        n = cj.GetItemName(itOrId)
    elseif (type(itOrId) == "string" or type(itOrId) == "number") then
        n = hslk.i2v(itOrId, "slk", "Name")
    end
    return n
end

-- 获取物品的图标路径
---@param itOrId userdata|string|number
---@return string
function hitem.getArt(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "Art")
end

--- 获取物品的模型路径
---@param itOrId userdata|string|number
---@return string
function hitem.getFile(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "file")
end

--- 获取物品的分类
---@param itOrId userdata|string|number
---@return string
function hitem.getClass(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "class")
end

--- 获取物品所需的金币
---@param itOrId userdata|string|number
---@return number
function hitem.getGoldCost(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "goldcost") or 0)
end

--- 获取物品所需的木头
---@param itOrId userdata|string|number
---@return number
function hitem.getLumberCost(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "lumbercost") or 0)
end

--- 获取物品是否可以使用
---@param itOrId userdata|string|number
---@return boolean
function hitem.getIsUsable(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "usable")
end

--- 获取物品是否自动使用
---@param itOrId userdata|string|number
---@return boolean
function hitem.getIsPowerUp(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "powerup")
end

--- 获取物品是否使用后自动消失
---@param itOrId userdata|string|number
---@return boolean
function hitem.getIsPerishable(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "perishable")
end

--- 获取物品是否可卖
---@param itOrId userdata|string|number
---@return boolean
function hitem.getIsSellAble(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "sellable")
end

--- 获取物品的属性加成
---@param itOrId userdata|string|number
---@return table
function hitem.getAttribute(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "_attr") or {}
end

--- 获取物品的等级
---@param it userdata
---@return number
function hitem.getLevel(it)
    if (it ~= nil) then
        return cj.GetItemLevel(it)
    end
    return 0
end

--- 获取物品的件数（以物品右下标的使用次数作为“件”）
--- 框架会自动强制最低件数为1
---@param it userdata
---@return number
function hitem.getCharges(it)
    if (it == nil) then
        return 0
    end
    return cj.GetItemCharges(it)
end

--- 设置物品的使用次数
---@param it userdata
---@param charges number
function hitem.setCharges(it, charges)
    if (it ~= nil and charges >= 0) then
        cj.SetItemCharges(it, charges)
    end
end

--- 获取某单位身上空格物品栏数量
---@param whichUnit userdata
---@return number
function hitem.getEmptySlot(whichUnit)
    local qty = cj.UnitInventorySize(whichUnit)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil) then
            qty = qty - 1
        end
    end
    return qty
end

--- 循环获取某单位6格物品
--- 遍历过程中返回 false 则中断
---@param whichUnit userdata
---@param action fun(enumItem:userdata,slotIndex:number)
---@return number
function hitem.forEach(whichUnit, action)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        local res = action(it, i)
        if (type(res) == "boolean" and res == false) then
            break
        end
    end
end

--- 附加单位获得物品后的属性
---@protected
function hitem.addProperty(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil) then
        return
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, true, whichUnit, hitem.getAttribute(itId), charges)
end

--- 削减单位获得物品后的属性
---@protected
function hitem.subProperty(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil) then
        return
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, false, whichUnit, hitem.getAttribute(itId), charges)
end

--[[
    创建物品
    options = {
        id = "I001", --物品ID
        charges = 1, --物品可使用次数（可选，默认为1）
        whichUnit = nil, --哪个单位（可选）
        x = nil, --哪个坐标X（可选）
        y = nil, --哪个坐标Y（可选）
        during = -1, --持续时间（可选，小于0无限制，如果有whichUnit，此项无效）
    }
]]
---@alias noteItemCreate {id,charges,whichUnit,x,y,during}
---@param options noteItemCreate
---@return userdata|nil
function hitem.create(options)
    if (options.id == nil) then
        err("hitem create -it-id")
        return
    end
    if (options.charges == nil) then
        local slkCharges = hslk.i2v(options.id, "slk", "uses")
        if (slkCharges == "") then
            slkCharges = nil
        else
            slkCharges = math.floor(slkCharges)
        end
        options.charges = slkCharges or 1
    end
    if (options.charges < 0) then
        return
    end
    local charges = options.charges
    local during = options.during or -1
    -- 优先级 坐标 > 单位
    local x, y
    local id = options.id
    if (options.x ~= nil and options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    else
        err("hitem create -position")
        return
    end
    if (type(id) == "string") then
        id = c2i(id)
    end
    local it
    -- 如果不是创建给单位，又或者单位已经不存在了，直接返回
    if (options.whichUnit == nil or hunit.isDestroyed(options.whichUnit) or hunit.isDead(options.whichUnit)) then
        -- 掉在地上
        it = cj.CreateItem(id, x, y)
        cj.SetItemCharges(it, charges)
        hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
        if (options.whichUnit ~= nil and during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hitem.destroy(it, 0)
            end)
        end
    else
        -- 单位流程
        it = cj.CreateItem(id, x, y)
        cj.UnitAddItem(options.whichUnit, it)
    end
    return it
end

--- 使一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
function hitem.give(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create({
                id = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target
            })
        end
        hitem.destroy(it, 0)
    end
end

--- 操作物品给一个单位
---@param it userdata
---@param targetUnit userdata
function hitem.pick(it, targetUnit)
    if (it == nil or targetUnit == nil) then
        return
    end
    cj.UnitAddItem(targetUnit, it)
end

--- 复制一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
function hitem.copy(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create({
                id = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target,
            })
        end
    end
end

--- 令一个单位把物品扔在地上
---@param origin userdata
---@param slot nil|number 物品位置
function hitem.drop(origin, slot)
    if (origin == nil or hunit.isDestroyed(origin) or hunit.isDead(origin)) then
        return
    end
    if (slot == nil) then
        for i = 0, 5, 1 do
            local it = cj.UnitItemInSlot(origin, i)
            if (it ~= nil) then
                cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
            end
        end
    else
        local it = cj.UnitItemInSlot(origin, slot)
        if (it ~= nil) then
            cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
        end
    end
end

--- 一键拾取区域(x,y)长宽(w,h)
---@param u userdata
---@param x number
---@param y number
---@param w number
---@param h number
function hitem.pickRect(u, x, y, w, h)
    if (u == nil or hunit.isDestroyed(u) or hunit.isDead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        local xi = cj.GetItemX(enumItem)
        local yi = cj.GetItemY(enumItem)
        local d = math.distance(x, y, xi, yi)
        local deg = math.angle(x, y, xi, yi)
        local distance = math.getMaxDistanceInRect(w, h, deg)
        if (d <= distance) then
            table.insert(items, enumItem)
        end
    end)
end

-- 一键拾取圆(x,y)半径(r)
---@param u userdata
---@param x number
---@param y number
---@param r number
function hitem.pickRound(u, x, y, r)
    if (u == nil or hunit.isDestroyed(u) or hunit.isDead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        local xi = cj.GetItemX(enumItem)
        local yi = cj.GetItemY(enumItem)
        local d = math.distance(x, y, xi, yi)
        if (d <= r) then
            table.insert(items, enumItem)
        end
    end)
end