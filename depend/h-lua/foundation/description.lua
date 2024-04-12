---@class description
description = {}

---@type table 百分比key集合
description_KeysPercent = { "attack_speed", "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" }

---@type number integer
description_nameIdx = 0

--- 配置百分比键值
---@param keys string[]
---@return void
function description.setPercentKey(keys)
    for _, k in ipairs(keys) do
        if (table.includes(description_KeysPercent, k) == false) then
            table.insert(description_KeysPercent, k)
        end
    end
end

--- 键值是否百分比数据
---@param key string
---@return boolean
function description.isPercent(key)
    if (table.includes(description_KeysPercent, key)) then
        return true
    end
    local s = string.find(key, "_oppose")
    if (s ~= nil) then
        return true
    end
    return false
end

--- 无名氏
---@param key string
---@return boolean
function description.noName(name)
    description_nameIdx = description_nameIdx + 1
    return name .. "-" .. description_nameIdx
end

--- 属性 文本构建
---@param attr table<string,any>
---@param sep string 换行符|分隔符
---@param indent string 缩进
---@return string
function description.attribute(attr, sep, indent)
    sep = sep or "|n"
    indent = indent or ""
    local desc = {}
    local descTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. "秒"
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. "点/秒"
        end
        if (description.isPercent(k) == true) then
            v = v .. "%"
        end
        table.insert(desc, indent .. (CONST_ATTR_LABEL[k] or "") .. "：" .. v)
    end
    return string.implode(sep, table.merge(desc, descTable))
end

--- 属性学习时 文本构建
---@param attr table<string,any>
---@return string
function description.attributeResearch(attr)
    local desc = {}
    local descTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. "秒"
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. "点/秒"
        end
        if (description.isPercent(k) == true) then
            v = v .. "%"
        end
        table.insert(desc, v .. (CONST_ATTR_LABEL[k] or ""))
    end
    return string.implode(",", table.merge(desc, descTable))
end

--- 单位 Name 文本构建
---@param v table slk 设定数据
---@return string
function description.unitName(v)
    return v.Name or description.noName("不知名单位")
end

--- 单位 Tip 文本构建
---@param v table slk 设定数据
---@return string
function description.unitTip(v)
    local desc = "选择：" .. v.Name
    if (v.Hotkey) then
        desc = desc .. "(" .. hcolor.mixed(v.Hotkey, "ffcc00") .. ")"
    end
    return desc
end

--- 单位 Ubertip 文本构建
---@param v table slk 设定数据
---@return string
function description.unitUbertip(v)
    local desc = {}
    if (type(v.Ubertip) == "string" and v.Ubertip ~= "") then
        table.insert(desc, v.Ubertip)
    end
    if (v.weapTp1 and v.cool1) then
        table.insert(desc, hcolor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)", "ff3939"))
    end
    if (v.dmgplus1) then
        table.insert(desc, hcolor.mixed("基本攻击：" .. v.dmgplus1, "ff8080"))
    end
    if (v.rangeN1) then
        table.insert(desc, hcolor.mixed("攻击范围：" .. v.rangeN1, "99ccff"))
    end
    if (v.spd and v.movetp) then
        table.insert(desc, hcolor.mixed("移速：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label, "ccffcc"))
    end
    return string.implode("|n", desc)
end

--- 英雄 Name 文本构建
---@param v table slk 设定数据
---@return string
function description.heroName(v)
    return v.Name or description.noName("不知名英雄")
end

--- 英雄 Tip 文本构建
---@param v table slk 设定数据
---@return string
function description.heroTip(v)
    local desc = "选择：" .. v.Name
    if (v.Hotkey) then
        desc = desc .. "(" .. hcolor.mixed(v.Hotkey, "ffcc00") .. ")"
    end
    return desc
end

--- 英雄 Ubertip 文本构建
---@param v table slk 设定数据
---@return string
function description.heroUbertip(v)
    local desc = {}
    if (type(v.Ubertip) == "string" and v.Ubertip ~= "") then
        table.insert(desc, v.Ubertip)
    end
    if (v.weapTp1 and v.cool1) then
        table.insert(desc, hcolor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)", "ff3939"))
    end
    if (v.dmgplus1) then
        table.insert(desc, hcolor.mixed("基本攻击：" .. v.dmgplus1, "ff8080"))
    end
    if (v.rangeN1) then
        table.insert(desc, hcolor.mixed("攻击范围：" .. v.rangeN1, "99ccff"))
    end
    if (v.Primary == "STR") then
        table.insert(desc, hcolor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", "ffff00"))
    else
        table.insert(desc, hcolor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", "ffffcc"))
    end
    if (v.Primary == "AGI") then
        table.insert(desc, hcolor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", "ffff00"))
    else
        table.insert(desc, hcolor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", "ffffcc"))
    end
    if (v.Primary == "INT") then
        table.insert(desc, hcolor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", "ffff00"))
    else
        table.insert(desc, hcolor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", "ffffcc"))
    end
    if (v.spd and v.movetp) then
        table.insert(desc, hcolor.mixed("移速：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label, "ccffcc"))
    end
    return string.implode("|n", desc)
end

--- 技能 Name 文本构建
---@param v table slk 设定数据
---@return string
function description.abilityName(v)
    return v.Name or description.noName("不知名技能")
end

--- 技能 Tip 文本构建
--- 当技能多级时，返回字符串数组
---@param v table slk 设定数据
---@return string|string[]
function description.abilityTip(v)
    local prefix = v.Name
    if (v.Hotkey ~= nil) then
        prefix = prefix .. "[" .. hcolor.mixed(v.Hotkey, "ffcc00") .. "]"
    end
    if (v.levels <= 1) then
        return prefix
    end
    local desc = {}
    v.Tip = {}
    for i = 1, v.levels do
        table.insert(desc, prefix .. " - [|cffffcc00等级 " .. i .. "|r]")
    end
    return desc
end

--- 技能 Researchtip 文本构建
---@param v table slk 设定数据
---@return string
function description.abilityResearchtip(v)
    if (v.Researchtip ~= nil) then
        return v.Researchtip
    end
    local desc = "学习" .. v.Name
    if (v.Hotkey ~= nil) then
        desc = desc .. "(" .. hcolor.mixed(v.Hotkey, "ffcc00") .. ")"
    end
    desc = desc .. " - [|cffffcc00等级 %d|r]"
    return desc
end

--- 技能 Ubertip 文本构建
--- 当技能多级时，返回字符串数组
---@param v table slk 设定数据
---@return string
function description.abilityUbertip(v)
    if (type(v.Ubertip) == "table") then
        return v.Ubertip
    end
    local desc = {}
    if (v.Ubertip == nil) then
        table.insert(desc, "")
    elseif (type(v.Ubertip) == "string") then
        table.insert(desc, v.Ubertip)
    end
    if (v.levels > 1 and #desc < v.levels) then
        local lastUbertip = desc[#desc]
        for i = (#desc + 1), v.levels, 1 do
            desc[i] = lastUbertip
        end
    end
    local ux = {}
    for i = 1, v.levels, 1 do
        ux[i] = { desc[i] }
    end
    if (type(v.Cool) == "table") then
        local lastCool = v.Cool[#v.Cool]
        for i = (#v.Cool + 1), v.levels, 1 do
            v.Cool[i] = lastCool
        end
        for i = 1, v.levels, 1 do
            table.insert(ux[i], hcolor.mixed("冷却：" .. v.Cool[i] .. "秒", "ccffff"))
        end
    end
    if (v._attr ~= nil) then
        if (#v._attr == 0) then
            v._attr = { v._attr }
        end
        local lastAttr = v._attr[#v._attr]
        for i = (#v._attr + 1), v.levels, 1 do
            v._attr[i] = lastAttr
        end
        for i = 1, v.levels, 1 do
            table.insert(ux[i], hcolor.mixed(description.attribute(v._attr[i], "|n"), "b0f26e"))
        end
    end
    if (v._remarks ~= nil and v._remarks ~= "") then
        for i = 1, v.levels, 1 do
            table.insert(ux[i], hcolor.mixed(v._remarks, "969696"))
        end
    end
    for i = 1, v.levels, 1 do
        desc[i] = string.implode("|n", ux[i])
    end
    if (#desc == 1) then
        desc = desc[1]
    end
    return desc
end

--- 技能 Researchubertip 文本构建
--- 当技能多级时，返回字符串数组
---@param v table slk 设定数据
---@return string|string[]
function description.abilityResearchubertip(v)
    if (type(v.Researchubertip) == "table") then
        return v.Researchubertip
    end
    local desc = {}
    if (v.Ubertip == nil) then
        desc = {}
    elseif (type(v.Ubertip) == "string") then
        desc = { v.Ubertip }
    end
    local cd = {}
    local extent = {}
    for i = 1, v.levels, 1 do
        if (type(v.Cool) == "table") then
            table.insert(cd, v.Cool[i] or v.Cool[#v.Cool])
        end
        extent[i] = ""
        if (v._attr ~= nil) then
            if (#v._attr == 0) then
                extent[i] = extent[i] .. description.attributeResearch(v._attr)
            else
                extent[i] = extent[i] .. description.attributeResearch(v._attr[i] or v._attr[#v._attr])
            end
        end
    end
    if (#cd > 0) then
        table.insert(desc, hcolor.mixed("冷却：" .. string.implode("/", cd) .. "秒", "ccffff"))
    end
    local color = {
        [0] = "FFFFE0",
        [1] = "FFD700",
    }
    if (v.levels > 1) then
        for i = 1, v.levels, 1 do
            table.insert(desc, hcolor.mixed("等级" .. i .. "：" .. extent[i], color[i % 2]))
        end
    else
        table.insert(desc, hcolor.mixed(extent[1], color[1]))
    end
    if (v._remarks ~= nil and v._remarks ~= "") then
        table.insert(desc, hcolor.mixed(v._remarks, "969696"))
    end
    return string.implode("|n", desc)
end

--- 物品 Name 文本构建
---@param v table slk 设定数据
---@return string
function description.itemName(v)
    return v.Name or description.noName("不知名物品")
end

--- 物品 Tip 文本构建
---@param v table slk 设定数据
---@return string
function description.itemTip(v)
    local desc = "获得：" .. v.Name
    if (v.Hotkey) then
        desc = desc .. "(" .. hcolor.mixed(v.Hotkey, "ffcc00") .. ")"
    end
    return desc
end

--- 物品 Ubertip 文本构建
---@param v table slk 设定数据
---@return string
function description.itemUbertip(v)
    local desc = {}
    if (type(v.Ubertip) == "string" and v.Ubertip ~= "") then
        table.insert(desc, v.Ubertip)
    end
    if (v._cooldown ~= nil and v._cooldown > 0) then
        table.insert(desc, hcolor.mixed("冷却：" .. v._cooldown .. "秒", "ccffff"))
    end
    if (v._attr ~= nil) then
        table.insert(desc, hcolor.mixed(description.attribute(v._attr, "|n", nil), "b0f26e"))
    end
    if (v._remarks ~= nil and v._remarks ~= "") then
        table.insert(desc, hcolor.mixed(v._remarks, "969696"))
    end
    return string.implode("|n", desc)
end

--- 物品 Description 文本构建
---@param v table slk 设定数据
---@return string
function description.itemDescription(v)
    local desc = {}
    if (type(v.Description) == "string" and v.Description ~= "") then
        table.insert(desc, v.Description)
    end
    if (v._attr ~= nil) then
        table.insert(desc, description.attribute(v._attr, ","))
    end
    if (type(v._remarks) == "string" and v._remarks ~= "") then
        table.insert(desc, v._remarks)
    end
    return string.implode(";", desc)
end

--- 状态 EditorName 文本构建
---@param v table slk 设定数据
---@return string
function description.buffEditorName(v)
    return v.EditorName
end

--- 状态 Tip 文本构建
---@param v table slk 设定数据
---@return string
function description.buffTip(v)
    return v.Bufftip
end

--- 状态 Buffubertip 文本构建
---@param v table slk 设定数据
---@return string
function description.buffUbertip(v)
    return v.Buffubertip
end

--- 科技 Name 文本构建
---@param v table slk 设定数据
---@return string
function description.upgradeName(v)
    return v.Name
end

--- 科技 Ubertip 文本构建
---@param v table slk 设定数据
---@return string
function description.upgradeUbertip(v)
    return v.Ubertip
end