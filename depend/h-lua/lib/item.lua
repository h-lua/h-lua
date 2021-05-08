--[[
    每个英雄最大支持使用6件物品
    支持满背包合成
    物品存在重量，背包有负重，超过负重即使存在合成关系，也会被暂时禁止合成
]]
---@class hitem 物品
hitem = {}

--- 获取物品X坐标
---@param it userdata
---@return number
hitem.x = function(it)
    return cj.GetItemX(it)
end

--- 获取物品Y坐标
---@param it userdata
---@return number
hitem.y = function(it)
    return cj.GetItemY(it)
end

--- 获取物品Z坐标
---@param it userdata
---@return number
hitem.z = function(it)
    local loc = cj.GetItemLoc(it)
    local z = cj.GetLocationZ(loc)
    cj.RemoveLocation(loc)
    return z
end


-- 单位嵌入到物品到框架系统
---@protected
hitem.embed = function(u)
    if (false == hcache.exist(u)) then
        -- 没有注册的单位直接跳过
        return
    end
    -- 如果单位的玩家是真人
    if (his.computer(hunit.getOwner(u)) == false) then
        -- 拾取
        hevent.pool(u, hevent_default_actions.item.pickup, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PICKUP_ITEM)
        end)
        -- 丢弃
        hevent.pool(u, hevent_default_actions.item.drop, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DROP_ITEM)
        end)
        -- 抵押
        hevent.pool(u, hevent_default_actions.item.pawn, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PAWN_ITEM)
        end)
        -- 使用
        hevent.pool(u, hevent_default_actions.item.use, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_USE_ITEM)
        end)
        hevent.pool(u, hevent_default_actions.item.use_s, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_SPELL_EFFECT)
        end)
    end
end

-- 清理物品缓存数据
---@protected
hitem.free = function(whichItem)
    hitemPool.free(whichItem)
    hevent.free(whichItem)
    local holder = hitem.getHolder(whichItem)
    if (holder ~= nil) then
        hitem.subProperty(holder, hitem.getId(whichItem), hitem.getCharges(whichItem))
    end
    hcache.free(whichItem)
end

--- 设置物品的持有单位
---@protected
---@param whichItem userdata
---@param holder userdata
hitem.setHolder = function(whichItem, holder)
    hcache.set(whichItem, CONST_CACHE.ITEM_HOLDER, holder)
    hitem.setLastHolder(whichItem, holder)
end

--- 获取物品的当前持有单位
---@param whichItem userdata
---@return userdata|nil
hitem.getHolder = function(whichItem)
    return hcache.get(whichItem, CONST_CACHE.ITEM_HOLDER)
end

--- 设置物品的最后持有单位
---@protected
---@param whichItem userdata
---@param holder userdata
hitem.setLastHolder = function(whichItem, holder)
    if (holder ~= nil and hitem.getLastHolder(whichItem) == nil) then
        hcache.set(whichItem, CONST_CACHE.ITEM_HOLDER_LAST, holder)
    end
end

--- 获取物品的最后持有单位
---@param whichItem userdata
---@return userdata|nil
hitem.getLastHolder = function(whichItem)
    return hcache.get(whichItem, CONST_CACHE.ITEM_HOLDER_LAST)
end

--- 把物品给回的最后持有单位
---@param whichItem userdata
---@return userdata|nil
hitem.backToLastHolder = function(whichItem)
    local lastHolder = hitem.getLastHolder(whichItem)
    cj.UnitAddItem(lastHolder, whichItem)
    htextTag.style(htextTag.create2Unit(lastHolder, "物品回来了", 8.00, "ffffff", 1, 1.1, 50.00), "scale", 0, 0.05)
end

--- 判断单位对于某件物品来说是否强取豪夺
---@param whichItem userdata
---@param robber userdata
---@return boolean
hitem.isRobber = function(whichItem, robber)
    if (whichItem == nil or robber == nil) then
        return false
    end
    local lastHolder = hitem.getLastHolder(whichItem)
    if (lastHolder == nil) then
        return false
    end
    local owner = hunit.getOwner(robber)
    if (hplayer.isIsolated(owner) == false) then
        return false
    end
    local lastOwner = hunit.getOwner(lastHolder)
    if (lastOwner == owner) then
        return false
    end
    return true
end

--- match done
---@param whichUnit userdata
---@param whichItem userdata
---@param triggerData table
hitem.used = function(whichUnit, whichItem, triggerData)
    triggerData = triggerData or {}
    triggerData.triggerUnit = whichUnit
    triggerData.triggerItem = whichItem
    hevent.triggerEvent(whichUnit, CONST_EVENT.itemUsed, triggerData)
end

--- 删除物品，可延时
---@param it userdata
---@param delay number
hitem.del = function(it, delay)
    if (his.destroy(it)) then
        return
    end
    delay = delay or 0
    if (delay <= 0 and it ~= nil) then
        hitem.free(it)
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
    else
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            if (his.destroy(it)) then
                return
            end
            hitem.free(it)
            cj.SetWidgetLife(it, 1.00)
            cj.RemoveItem(it)
        end)
    end
end

---@protected
hitem.delFromUnit = function(whichUnit)
    if (whichUnit ~= nil) then
        hitem.forEach(whichUnit, function(enumItem)
            if (enumItem ~= nil) then
                hitem.del(enumItem)
            end
        end)
    end
end

--- 获取物品ID字符串
---@param itOrId userdata|number|string
---@return string|nil
hitem.getId = function(itOrId)
    local id
    if (type(itOrId) == "userdata") then
        id = cj.GetItemTypeId(itOrId)
        if (id == 0) then
            return
        end
        id = string.id2char(id)
    elseif (type(itOrId) == "number") then
        id = string.id2char(itOrId)
    elseif (type(itOrId) == "string") then
        id = itOrId
    end
    return id
end

--- 获取物品名称
---@param itOrId userdata|string|number
---@return string
hitem.getName = function(itOrId)
    local n = ""
    if (type(itOrId) == "userdata") then
        n = cj.GetItemName(itOrId)
    elseif (type(itOrId) == "string" or type(itOrId) == "number") then
        n = hslk.i2v(itOrId, "slk", "Name")
    end
    return n
end

--- 判断一个物品是否影子物品的明面物品
---@param itOrId userdata|string|number
---@return boolean
hitem.isShadowFront = function(itOrId)
    local id = hitem.getId(itOrId)
    local iv = hslk.i2v(id)
    if (iv == nil) then
        return false
    end
    return (iv._shadow_id ~= nil and iv._type == "common")
end

--- 判断一个物品是否影子物品的暗面物品
---@param itOrId userdata|string|number
---@return boolean
hitem.isShadowBack = function(itOrId)
    local id = hitem.getId(itOrId)
    local iv = hslk.i2v(id)
    if (iv == nil) then
        return false
    end
    return (iv._shadow_id ~= nil and iv._type == "shadow")
end

--- 获取一个物品的影子ID
---@param itOrId userdata|string|number
---@return string
hitem.shadowID = function(itOrId)
    local id = hitem.getId(itOrId)
    local iv = hslk.i2v(id)
    if (iv == nil) then
        print_err("hitem.shadowID")
    end
    if (iv._shadow_id == nil) then
        print_err("hitem.shadowID not shadow item")
    end
    return iv._shadow_id
end

-- 获取物品的图标路径
---@param itOrId userdata|string|number
---@return string
hitem.getArt = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "Art")
end

--- 获取物品的模型路径
---@param itOrId userdata|string|number
---@return string
hitem.getFile = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "file")
end

--- 获取物品的分类
---@param itOrId userdata|string|number
---@return string
hitem.getClass = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "class")
end

--- 获取物品所需的金币
---@param itOrId userdata|string|number
---@return number
hitem.getGoldCost = function(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "goldcost") or 0)
end

--- 获取物品所需的木头
---@param itOrId userdata|string|number
---@return number
hitem.getLumberCost = function(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "lumbercost") or 0)
end

--- 获取物品是否可以使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsUsable = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "usable")
end

--- 获取物品是否自动使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPowerUp = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "powerup")
end

--- 获取物品是否使用后自动消失
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPerishable = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "perishable")
end

--- 获取物品是否可卖
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsSellAble = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "sellable")
end

--- 获取物品的最大叠加数(默认是1个,本框架以使用次数作为数量使用)
---@param itOrId userdata|string|number
---@return number
hitem.getOverlie = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "_overlie") or 1
end

--- 获取物品的重量（默认为0）
---@param itOrId userdata|string|number
---@return number
hitem.getWeight = function(itOrId, charges)
    local id = hitem.getId(itOrId)
    local _weight = hslk.i2v(id, "_weight") or 0
    _weight = math.round(_weight, 3)
    if (_weight > 0) then
        if (charges == nil and type(itOrId) == "userdata") then
            -- 如果没有传次数，并且传入的是物品对象，会直接获取物品的次数，请注意
            charges = hitem.getCharges(itOrId)
        elseif (charges == nil) then
            charges = 1
        end
        return _weight * charges
    else
        return 0
    end
end
--- 获取物品的属性加成
---@param itOrId userdata|string|number
---@return table
hitem.getAttribute = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "_attr") or {}
end

--- 获取物品的等级
---@param it userdata
---@return number
hitem.getLevel = function(it)
    if (it ~= nil) then
        return cj.GetItemLevel(it)
    end
    return 0
end

--- 获取物品的件数（以物品右下标的使用次数作为“件”）
--- 框架会自动强制最低件数为1
---@param it userdata
---@return number
hitem.getCharges = function(it)
    if (it == nil) then
        return 0
    end
    local c = cj.GetItemCharges(it)
    if (c < 1 and false == hitem.getIsPerishable(it)) then
        c = 1
        cj.SetItemCharges(it, 1)
    end
    return c
end

--- 设置物品的使用次数
---@param it userdata
---@param charges number
hitem.setCharges = function(it, charges)
    if (it ~= nil and charges >= 0) then
        cj.SetItemCharges(it, charges)
    end
end

--- 获取某单位身上某种物品的使用总次数
---@param itemId string|number
---@param whichUnit userdata
---@return number
hitem.getTotalCharges = function(itemId, whichUnit)
    local charges = 0
    local it
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil and cj.GetItemTypeId(it) == itemId) then
            charges = charges + hitem.getCharges(it)
        end
    end
    return charges
end

--- 获取某单位身上空格物品栏数量
---@param whichUnit userdata
---@return number
hitem.getEmptySlot = function(whichUnit)
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
---@alias SlotForEach fun(enumItem: userdata,slotIndex: number):void
---@param whichUnit userdata
---@param action SlotForEach | "function(enumItem, slotIndex) end"
---@return number
hitem.forEach = function(whichUnit, action)
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
hitem.addProperty = function(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil or charges < 1) then
        return
    end
    hattribute.set(whichUnit, 0, { weight_current = "+" .. hitem.getWeight(itId, charges) })
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, true, whichUnit, hitem.getAttribute(itId), charges)
    for _ = 1, charges, 1 do
        hring.insert(whichUnit, itId)
    end
end
--- 削减单位获得物品后的属性
---@protected
hitem.subProperty = function(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil or charges < 1) then
        return
    end
    hattribute.set(whichUnit, 0, { weight_current = "-" .. hitem.getWeight(itId, charges) })
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, false, whichUnit, hitem.getAttribute(itId), charges)
    for _ = 1, charges, 1 do
        hring.remove(whichUnit, itId)
    end
end
--- 临时处理虚假物品信息
---@private
hitem.overlyingSlot = function(itemSlot)
    for i = 1, (#itemSlot - 1), 1 do
        local id1 = itemSlot[i].id
        if (id1 ~= nil) then
            local charges1 = itemSlot[i].charges
            local overlie = hitem.getOverlie(id1)
            if (charges1 < overlie) then
                for j = i + 1, #itemSlot, 1 do
                    local id2 = itemSlot[j].id
                    if (id2 == nil) then
                        break
                    end
                    local charges2 = itemSlot[j].charges
                    if (id1 == id2 and charges2 < overlie) then
                        local allow = overlie - charges1
                        local addCharges = 0
                        if (charges2 <= allow) then
                            charges1 = charges1 + charges2
                            addCharges = charges2
                            charges2 = 0
                        else
                            charges1 = overlie
                            addCharges = allow
                            charges2 = charges2 - allow
                        end
                        itemSlot[i].charges = charges1
                        if (charges2 > 0) then
                            itemSlot[j].charges = charges2
                        else
                            itemSlot[j].id = nil
                            itemSlot[j].charges = 0
                        end
                        if (charges1 >= overlie) then
                            break
                        end
                    end
                end
            end
        end
    end
end

--- 单位合成物品
---@public
---@param whichUnit userdata 目标单位
---@param items nil|userdata|table<userdata> 空|物品|物品数组
hitem.synthesis = function(whichUnit, items)
    if (whichUnit == nil) then
        return
    end
    items = items or {}
    if (type(items) == "userdata") then
        items = { items }
    end
    -- 合成流程
    local itemKind = {}
    local itemSlot = {}
    local itemStat = {
        qty = {},
        sub = { kv = {}, id = {} },
        add = { kv = {}, id = {} },
        profit = {}
    }
    hitem.forEach(whichUnit, function(slotItem)
        if (slotItem ~= nil) then
            local itId = hitem.getId(slotItem)
            local charges = hitem.getCharges(slotItem)
            if (false == table.includes(itemKind, itId)) then
                table.insert(itemKind, itId)
            end
            table.insert(itemSlot, { id = itId, charges = charges })
            if (itemStat.qty[itId] == nil) then
                itemStat.qty[itId] = 0
            end
            itemStat.qty[itId] = itemStat.qty[itId] + charges
        else
            table.insert(itemSlot, { id = nil, charges = 0 })
        end
    end)
    if (#items > 0) then
        for _, it in ipairs(items) do
            if (hitem.isRobber(it, whichUnit) == false) then
                local itId = hitem.getId(it)
                local charges = hitem.getCharges(it)
                if (hitem.isShadowBack(itId)) then
                    itId = hitem.shadowID(itId)
                end
                if (false == table.includes(itemKind, itId)) then
                    table.insert(itemKind, itId)
                end
                table.insert(itemSlot, { id = itId, charges = charges })
                if (itemStat.qty[itId] == nil) then
                    itemStat.qty[itId] = 0
                end
                itemStat.qty[itId] = itemStat.qty[itId] + (hitem.getCharges(it))
                hitem.del(it)
            else
                hitem.backToLastHolder(it)
            end
        end
    end
    local matchStack = 1
    while (matchStack > 0) do
        matchStack = 0
        for _, itId in ipairs(itemKind) do
            if (HSLK_SYNTHESIS.fragment[itId] ~= nil) then
                for _, need in ipairs(HSLK_SYNTHESIS.fragmentNeeds) do
                    if ((itemStat.qty[itId] or 0) >= need) then
                        local maybeProfits = HSLK_SYNTHESIS.fragment[itId][need]
                        for _, mp in ipairs(maybeProfits) do
                            local profitId = mp.profit
                            local profitIndex = mp.index
                            local whichProfit = HSLK_SYNTHESIS.profit[profitId][profitIndex]
                            local needFragments = whichProfit.fragment
                            local match = true
                            for _, frag in ipairs(needFragments) do
                                if ((itemStat.qty[frag[1]] or 0) < frag[2]) then
                                    match = false
                                    break
                                end
                            end
                            if (match == true) then
                                matchStack = matchStack + 1
                                for _, frag in ipairs(needFragments) do
                                    itemStat.qty[frag[1]] = itemStat.qty[frag[1]] - frag[2]
                                    if (itemStat.qty[frag[1]] == 0) then
                                        itemStat.qty[frag[1]] = nil
                                        table.delete(itemKind, frag[1])
                                    end
                                    if (itemStat.sub.kv[frag[1]] == nil) then
                                        itemStat.sub.kv[frag[1]] = frag[2]
                                        table.insert(itemStat.sub.id, frag[1])
                                    else
                                        itemStat.sub.kv[frag[1]] = itemStat.sub.kv[frag[1]] + frag[2]
                                    end
                                end
                                if (itemStat.add.kv[profitId] == nil) then
                                    itemStat.add.kv[profitId] = whichProfit.qty
                                    table.insert(itemStat.add.id, profitId)
                                else
                                    itemStat.add.kv[profitId] = itemStat.add.kv[profitId] + whichProfit.qty
                                end
                                table.insert(itemStat.profit, profitId)
                            end
                        end
                    end
                end
            end
        end
    end
    hitem.overlyingSlot(itemSlot)
    if (#itemStat.sub.id > 0) then
        for _, subId in ipairs(itemStat.sub.id) do
            for _, sIt in ipairs(itemSlot) do
                if (itemStat.sub.kv[subId] <= 0) then
                    break
                end
                if (sIt.id ~= nil and sIt.id == subId) then
                    if (sIt.charges > itemStat.sub.kv[subId]) then
                        sIt.charges = sIt.charges - itemStat.sub.kv[subId]
                        itemStat.sub.kv[subId] = 0
                        if (sIt.charges == 0) then
                            sIt.id = nil
                        end
                    elseif (sIt.charges == itemStat.sub.kv[subId]) then
                        itemStat.sub.kv[subId] = 0
                        sIt.id = nil
                        sIt.charges = 0
                    elseif (sIt.charges < itemStat.sub.kv[subId]) then
                        itemStat.sub.kv[subId] = itemStat.sub.kv[subId] - sIt.charges
                        sIt.id = nil
                        sIt.charges = 0
                    end
                end
            end
        end
    end
    if (#itemStat.add.id > 0) then
        for _, addId in ipairs(itemStat.add.id) do
            for _, sIt in ipairs(itemSlot) do
                if (itemStat.add.kv[addId] <= 0) then
                    break
                end
                if (sIt.id == nil) then
                    local overlie = hitem.getOverlie(addId)
                    sIt.id = addId
                    if (overlie >= itemStat.add.kv[addId]) then
                        sIt.charges = itemStat.add.kv[addId]
                        itemStat.add.kv[addId] = 0
                    else
                        sIt.charges = overlie
                        itemStat.add.kv[addId] = itemStat.add.kv[addId] - overlie
                    end
                elseif (addId == sIt.id) then
                    local overlie = hitem.getOverlie(addId)
                    if (sIt.charges < overlie) then
                        local allow = (overlie - sIt.charges)
                        if (allow >= itemStat.add.kv[addId]) then
                            sIt.charges = sIt.charges + itemStat.add.kv[addId]
                            itemStat.add.kv[addId] = 0
                        else
                            sIt.charges = overlie
                            itemStat.add.kv[addId] = itemStat.add.kv[addId] - allow
                        end
                    end
                end
            end
        end
    end
    -- 处理结果,先删后加
    for i = 1, 6, 1 do
        local sIt = itemSlot[i]
        local it = cj.UnitItemInSlot(whichUnit, i - 1)
        if (it ~= nil) then
            local itId = hitem.getId(it)
            local charges = hitem.getCharges(it)
            if (sIt.id == nil) then
                hitem.del(it, 0)
            elseif (itId == sIt.id) then
                local diff = sIt.charges - charges
                if (diff > 0) then
                    cj.SetItemCharges(it, charges + diff)
                    hitem.addProperty(whichUnit, itId, diff)
                elseif (diff < 0) then
                    cj.SetItemCharges(it, charges + diff)
                    hitem.subProperty(whichUnit, itId, math.abs(diff))
                end
            end
        end
    end
    hitem.overlyingSlot(itemSlot)
    for i = 1, 6, 1 do
        local sIt = itemSlot[i]
        local isProfit = table.includes(itemStat.profit, sIt.id)
        local it = cj.UnitItemInSlot(whichUnit, i - 1)
        if (it ~= nil) then
            local itId = hitem.getId(it)
            if (sIt.id ~= nil and itId ~= sIt.id) then
                hitem.del(it, 0)
                local newIt = cj.CreateItem(string.char2id(sIt.id), hunit.x(whichUnit), hunit.y(whichUnit))
                if (isProfit) then
                    hevent.triggerEvent(whichUnit, CONST_EVENT.itemSynthesis, { triggerUnit = whichUnit, triggerItem = newIt }) -- 触发合成事件
                end
                cj.SetItemCharges(newIt, sIt.charges)
                cj.UnitAddItem(whichUnit, newIt)
            end
        elseif (sIt.id ~= nil) then
            local newIt = cj.CreateItem(string.char2id(sIt.id), hunit.x(whichUnit), hunit.y(whichUnit))
            if (isProfit) then
                hevent.triggerEvent(whichUnit, CONST_EVENT.itemSynthesis, { triggerUnit = whichUnit, triggerItem = newIt }) -- 触发合成事件
            end
            cj.SetItemCharges(newIt, sIt.charges)
            cj.UnitAddItem(whichUnit, newIt)
        end
    end
    if (#itemSlot > 6) then
        hitem.overlyingSlot(itemSlot)
        for i = 7, #itemSlot, 1 do
            local sIt = itemSlot[i]
            if (sIt.id ~= nil) then
                if (hitem.getEmptySlot(whichUnit) > 0) then
                    local newIt = cj.CreateItem(string.char2id(sIt.id), hunit.x(whichUnit), hunit.y(whichUnit))
                    cj.SetItemCharges(newIt, sIt.charges)
                    if (isProfit) then
                        hevent.triggerEvent(whichUnit, CONST_EVENT.itemSynthesis, { triggerUnit = whichUnit, triggerItem = newIt }) -- 触发合成事件
                    end
                    cj.UnitAddItem(whichUnit, newIt)
                else
                    -- 判断如果是真实物品并且有影子，转为影子物品
                    if (hitem.isShadowFront(sIt.id)) then
                        sIt.id = hitem.shadowID(sIt.id)
                    end
                    local newIt = cj.CreateItem(string.char2id(sIt.id), hunit.x(whichUnit), hunit.y(whichUnit))
                    cj.SetItemCharges(newIt, sIt.charges)
                    hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, newIt)
                end
            end
        end
    end
end

--- 拆分物品
--- 物品的xy指的是物品创建时的坐标
--- 当物品在单位身上时，物品的位置并不跟随单位移动，而是创建时候的位置，需要注意
---@public
---@param whichItem userdata 目标物品
---@param separateType string | "'single'" | "'formula'"
---@param whichUnit userdata 触发单位（可选）当拥有持有单位时，拆分的物品会在单位坐标处
---@return nil|string 错误时会返回一个字符串，反馈错误
hitem.separate = function(whichItem, separateType, formulaIndex, whichUnit)
    if (whichItem == nil) then
        return "物品不存在"
    end
    whichUnit = whichUnit or nil
    local x = 0
    local y = 0
    if (whichUnit ~= nil and cj.IsItemOwned(whichItem)) then
        x = cj.GetUnitX(whichUnit)
        y = cj.GetUnitY(whichUnit)
    else
        x = cj.GetItemX(whichItem)
        y = cj.GetItemY(whichItem)
    end
    local id = hitem.getId(whichItem)
    local charges = hitem.getCharges(whichItem)
    separateType = separateType or "single"
    formulaIndex = formulaIndex or 1 -- 默认获取第一条公式拆分
    if (charges <= 1) then
        -- 如果数目小于2，自动切换成公式模式
        separateType = "formula"
    end
    if (separateType == "single") then
        for _ = 1, charges, 1 do
            hitem.create({ id = id, charges = 1, x = x, y = y })
        end
    elseif (separateType == "formula") then
        if (hitem.isShadowBack(id)) then
            id = hitem.shadowID(id)
        end
        if (HSLK_SYNTHESIS.profit[id] == nil) then
            return "物品不存在公式，无法拆分"
        end
        local profit = HSLK_SYNTHESIS.profit[id][formulaIndex] or nil
        if (profit == nil) then
            return "物品找不到公式，无法拆分"
        end
        for _ = 1, charges, 1 do
            for _, frag in ipairs(profit.fragment) do
                local flagId = frag[1]
                if (#profit.fragment == 1) then
                    for _ = 1, frag[2], 1 do
                        hitem.create({ id = flagId, charges = 1, x = x, y = y })
                    end
                else
                    local qty = frag[2]
                    local hs = hslk.i2v(flagId)
                    if (hs ~= nil) then
                        local overlie = hs._overlie or 1
                        while (qty > 0) do
                            if (overlie >= qty) then
                                hitem.create({ id = flagId, charges = qty, x = x, y = y })
                                qty = 0
                            else
                                qty = qty - overlie
                                hitem.create({ id = flagId, charges = overlie, x = x, y = y })
                            end
                        end
                    else
                        hitem.create({ id = flagId, charges = qty, x = x, y = y })
                    end
                end
            end
        end
    end
    hevent.triggerEvent(whichItem, CONST_EVENT.itemSeparate, {
        triggerItem = whichItem,
        type = separateType,
        targetUnit = whichUnit,
    })
    hitem.del(whichItem, 0)
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
---@param options pilotItemCreate
---@return userdata|nil
hitem.create = function(options)
    if (options.id == nil) then
        print_err("hitem create -it-id")
        return
    end
    if (options.charges == nil) then
        options.charges = 1
    end
    if (options.charges < 1) then
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
        print_err("hitem create -position")
        return
    end
    if (type(id) == "string") then
        id = string.char2id(id)
    end
    local it
    -- 如果不是创建给单位，又或者单位已经不存在了，直接返回
    if (options.whichUnit == nil or his.deleted(options.whichUnit) or his.dead(options.whichUnit)) then
        -- 如果是shadow物品的明面物品，转成暗面物品再创建
        if (hitem.isShadowFront(id)) then
            id = string.char2id(hitem.shadowID(id))
        end
        -- 掉在地上
        it = cj.CreateItem(id, x, y)
        cj.SetItemCharges(it, charges)
        hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
        if (options.whichUnit ~= nil and during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hitem.del(it, 0)
            end)
        end
    else
        -- 单位流程
        it = cj.CreateItem(id, x, y)
        if (hitem.getIsPowerUp(id)) then
            -- 如果是powerUp类型，直接给予单位，后续流程交予[hevent_default_actions.item.pickup]事件
            -- 因为shadow物品的暗面物品一定是powerup，所以无需额外处理
            cj.SetItemCharges(it, charges)
            cj.UnitAddItem(options.whichUnit, it)
        elseif (hitem.getEmptySlot(options.whichUnit) > 0) then
            -- 没有满格,单位直接获得，后续流程交予[hevent_default_actions.item.pickup]事件
            cj.SetItemCharges(it, charges)
            cj.UnitAddItem(options.whichUnit, it)
        elseif (hitem.isShadowFront(id)) then
            -- 满格了，如果是shadow的明面物品；转shadow再给与单位，后续流程交予[hevent_default_actions.item.pickup]事件
            id = string.char2id(hitem.shadowID(id))
            hitem.del(it)
            -- 掉在地上
            it = cj.CreateItem(id, x, y)
            cj.SetItemCharges(it, charges)
            hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
        else
            -- 满格了，如果是一般物品；掉在地上
            cj.SetItemCharges(it, charges)
            hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
        end
    end
    return it
end

--- 创建[瞬逝物]物品
--- 是以单位模拟的物品，进入范围瞬间消失并生效
--- 可以增加玩家的反馈刺激感
--- [type]金币,木材,黄色书,绿色书,紫色书,蓝色书,红色书,神符,浮雕,蛋",碎片,问号,荧光草Dota2赏金符,Dota2伤害符,Dota2恢复符,Dota2极速符,Dota2幻象符,Dota2隐身符
---@param fleetingType number HL_ID.item_fleeting[n]
---@param x number 坐标X
---@param y number 坐标Y
---@param during number 持续时间（可选，默认30秒）
---@param yourFunc onEnterUnitRange | "function(evtData) end"
---@return userdata item-unit
hitem.fleeting = function(fleetingType, x, y, during, yourFunc)
    if (fleetingType == nil) then
        print_err("hitem fleeting -type")
        return
    end
    if (x == nil or y == nil) then
        return
    end
    during = during or 30
    if (during < 0) then
        return
    end
    local it = hunit.create({
        register = false,
        whichPlayer = hplayer.player_passive,
        id = fleetingType,
        x = x,
        y = y,
        during = during,
    })
    hcache.alloc(it)
    if (type(yourFunc) == "function") then
        hevent.onEnterUnitRange(it, 127, yourFunc)
    end
    return it
end

--- 使一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.give = function(origin, target)
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
        hitem.del(it, 0)
    end
end

--- 操作物品给一个单位
---@param it userdata
---@param targetUnit userdata
hitem.pick = function(it, targetUnit)
    if (it == nil or targetUnit == nil) then
        return
    end
    cj.UnitAddItem(targetUnit, it)
end

--- 复制一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.copy = function(origin, target)
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
hitem.drop = function(origin, slot)
    if (origin == nil or his.deleted(origin) or his.dead(origin)) then
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
hitem.pickRect = function(u, x, y, w, h)
    if (u == nil or his.deleted(u) or his.dead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        if (hitem.isRobber(enumItem, u) == false) then
            local xi = cj.GetItemX(enumItem)
            local yi = cj.GetItemY(enumItem)
            local d = math.getDistanceBetweenXY(x, y, xi, yi)
            local deg = math.getDegBetweenXY(x, y, xi, yi)
            local distance = math.getMaxDistanceInRect(w, h, deg)
            if (d <= distance) then
                table.insert(items, enumItem)
            end
        end
    end)
    if (#items > 0) then
        hitem.synthesis(u, items)
    end
end

-- 一键拾取圆(x,y)半径(r)
---@param u userdata
---@param x number
---@param y number
---@param r number
hitem.pickRound = function(u, x, y, r)
    if (u == nil or his.deleted(u) or his.dead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        if (hitem.isRobber(enumItem, u) == false) then
            local xi = cj.GetItemX(enumItem)
            local yi = cj.GetItemY(enumItem)
            local d = math.getDistanceBetweenXY(x, y, xi, yi)
            if (d <= r) then
                table.insert(items, enumItem)
            end
        end
    end)
    if (#items > 0) then
        hitem.synthesis(u, items)
    end
end