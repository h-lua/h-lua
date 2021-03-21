---@class hshop 中立商店相关
hshop = {
    license = {
        --- 许可证
        item = string.char2id("Asid"),
        unit = string.char2id("Asud"),
        --- 检查目标商店的物品/单位售卖资格(也就是出售物品、出售单位技能)
        --- 如果商店没有资格，给它个许可证
        grant = function(whichShop, license)
            if (hcache.exist(whichShop) == false) then
                hcache.alloc(whichShop)
            end
            local granted = hcache.get(whichShop, CONST_CACHE.SHOP_GRANTED, false)
            if (true == granted) then
                return
            end
            hcache.set(whichShop, CONST_CACHE.SHOP_GRANTED, true)
            if (hskill.has(whichShop, license) == false) then
                hskill.add(whichShop, license, 1)
            end
            local shopId = hunit.getId(whichShop)
            local s = hslk.i2v(shopId, "slk")
            if (license == hshop.license.item) then
                if (s and s.Sellitems ~= nil and s.Sellitems ~= "") then
                    print_mb("[!警告!]物编的[出售物品]会永久强占商店出售位，请清理空位供店铺使用！")
                end
                hevent.onItemSell(whichShop, function(evtData)
                    local itemId = cj.GetItemTypeId(evtData.soldItem)
                    htime.setTimeout(0, function(curTimer)
                        htime.delTimer(curTimer)
                        local c = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, 0) - 1
                        if (c > 0) then
                            hshop.item.set(evtData.triggerUnit, itemId, c)
                        else
                            hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, nil)
                            cj.RemoveItemFromStock(whichShop, itemId)
                        end
                    end)
                end)
            elseif (license == hshop.license.unit) then
                if (s and s.Sellunits ~= nil and s.Sellunits ~= "") then
                    print_mb("[!警告!]物编的[出售单位]会永久强占商店出售位，请清理空位供店铺使用！")
                end
                hevent.onUnitSell(whichShop, function(evtData)
                    local unitId = cj.GetUnitTypeId(evtData.soldUnit)
                    htime.setTimeout(0, function(curTimer)
                        htime.delTimer(curTimer)
                        local c = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, 0) - 1
                        if (c > 0) then
                            hshop.unit.set(evtData.triggerUnit, unitId, c)
                        else
                            hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, nil)
                            cj.RemoveUnitFromStock(whichShop, unitId)
                        end
                    end)
                end)
            end
        end,
    },
    stockId = function(id)
        if (type(id) == "string") then
            id = string.char2id(id)
        end
        if (type(id) ~= "number") then
            return 0
        end
        return id
    end
}

---@class item 商店卖物品
hshop.item = {
    --- 配置商店内的物品库存配置
    ---@param whichShop userdata
    ---@param itemId number|string
    ---@param currentStock number|nil 可选，nil=不改，小于0则删除
    set = function(whichShop, itemId, currentStock)
        itemId = hshop.stockId(itemId)
        if (itemId == 0) then
            return
        end
        hshop.license.grant(whichShop, hshop.license.item)
        currentStock = math.floor(currentStock or 0)
        if (currentStock == nil) then
            currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, 1)
        elseif (currentStock <= 0) then
            hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, nil)
            cj.RemoveItemFromStock(whichShop, itemId)
            return
        end
        hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, currentStock)
        cj.RemoveItemFromStock(whichShop, itemId)
        cj.AddItemToStock(whichShop, itemId, 1, currentStock)
    end,
    --- 商店进货某种物品 changeStock 个
    add = function(whichShop, itemId, changeStock)
        itemId = hshop.stockId(itemId)
        local _currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, 0)
        hshop.item.set(whichShop, itemId, _currentStock + math.floor(changeStock))
    end,
    --- 商店减少某种物品 changeStock 个
    ---@param whichShop userdata
    ---@param itemId number|string
    sub = function(whichShop, itemId, changeStock)
        itemId = hshop.stockId(itemId)
        local _currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, 0)
        hshop.item.set(whichShop, itemId, _currentStock - math.floor(changeStock))
    end,
    --- 商店不再卖某种物品
    ---@param whichShop userdata
    ---@param itemId number|string
    del = function(whichShop, itemId)
        itemId = hshop.stockId(itemId)
        hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, nil)
        cj.RemoveItemFromStock(whichShop, itemId)
    end,
    --- 判断商店是否有某种物品
    ---@param whichShop userdata
    ---@param itemId number|string
    ---@return boolean
    has = function(whichShop, itemId)
        return hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. itemId, 0) > 0
    end
}

---@class unit 商店卖单位
hshop.unit = {
    --- 配置商店内的单位库存配置
    ---@param whichShop userdata
    ---@param unitId number|string
    ---@param currentStock number|nil 可选，nil=不改，小于0则删除
    set = function(whichShop, unitId, currentStock)
        unitId = hshop.stockId(unitId)
        if (unitId == 0) then
            return
        end
        hshop.license.grant(whichShop, hshop.license.unit)
        currentStock = math.floor(currentStock or 0)
        if (currentStock == nil) then
            currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, 1)
        elseif (currentStock <= 0) then
            hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, nil)
            cj.RemoveUnitFromStock(whichShop, unitId)
            return
        end
        hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, currentStock)
        cj.RemoveUnitFromStock(whichShop, unitId)
        cj.AddUnitToStock(whichShop, unitId, 1, currentStock)
    end,
    --- 商店进货某种单位 changeStock 个
    add = function(whichShop, unitId, changeStock)
        unitId = hshop.stockId(unitId)
        local _currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, 0)
        hshop.unit.set(whichShop, unitId, _currentStock + math.floor(changeStock))
    end,
    --- 商店减少某种单位 changeStock 个
    ---@param whichShop userdata
    ---@param unitId number|string
    sub = function(whichShop, unitId, changeStock)
        unitId = hshop.stockId(unitId)
        local _currentStock = hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, 0)
        hshop.unit.set(whichShop, unitId, _currentStock - math.floor(changeStock))
    end,
    --- 商店不再卖某种单位
    ---@param whichShop userdata
    ---@param unitId number|string
    del = function(whichShop, unitId)
        unitId = hshop.stockId(unitId)
        hcache.set(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, nil)
        cj.RemoveUnitFromStock(whichShop, unitId)
    end,
    --- 判断商店是否有某种单位
    ---@param whichShop userdata
    ---@param unitId number|string
    ---@return boolean
    has = function(whichShop, unitId)
        return hcache.get(whichShop, CONST_CACHE.SHOP_STOCK .. unitId, 0) > 0
    end
}
