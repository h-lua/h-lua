CONST_UBERTIP_I18N = {
    colon = "：",
    def_passive = "未命名空被动",
    def_ring = "未命名空光环",
    def_skill = "未命名技能",
    def_hero = "未命名英雄",
    def_unit = "未命名单位",
    def_item = "未命名物品",
    def_buff = "未命名魔法效果",
    def_upgrade = "未命名科技",
    lv = "等级",
    learn = "学习",
    choose = "选择",
    get = "获得",
    cd = "冷却",
    sec = "秒",
    perSec = "每秒",
    layer = "层",
    ring = "光环",
    ringRadius = "光环范围",
    ringTarget = "光环目标",
    ringAttr = "光环效果",
    ringInRadius = "范围内的",
    overlie = "叠加",
    weight = "重量",
    kg = "KG",
    fragment = "可以合成",
    profit = "需要零件",
    weapTp1 = "攻击类型",
    cool1 = "秒/击",
    dmgplus1 = "基础攻击",
    rangeN1 = "攻击范围",
    STR = "力量",
    AGI = "敏捷",
    INT = "智力",
    spd = "移动",
    ally = "友军",
    enemies = "敌军",
    enemy = "敌人",
    self = "自己",
}

--- 属性系统目标文本修正
CONST_UBERTIP_TARGET_LABEL = function(target, actionType, actionField, isValue)
    if (actionType == 'spec' and isValue ~= true and table.includes({ 'split', 'bomb', 'lightning_chain' }, actionField)) then
        if (target == '己') then
            target = CONST_UBERTIP_I18N.ally
        else
            target = CONST_UBERTIP_I18N.enemies
        end
    else
        if (target == '己') then
            target = CONST_UBERTIP_I18N.self
        else
            target = CONST_UBERTIP_I18N.enemy
        end
    end
    return target
end

--- 键值是否百分比数据
CONST_UBERTIP_IS_PERCENT = function(key)
    if (table.includes({
        "attack_speed", "avoid", "aim",
        "hemophagia", "hemophagia_skill",
        "siphon","siphon_skill",
        "invincible",
        "knocking_odds", "knocking_extent",
        "damage_extent", "damage_decrease", "damage_rebound",
        "cure",
        "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio",
        "knocking", "split",
    }, key)) then
        return true
    end
    local s = string.find(key, "_oppose")
    local n = string.find(key, "e_")
    local a = string.find(key, "_attack")
    local p = string.find(key, "_append")
    if (a ~= nil or p ~= nil) then
        return false
    end
    if (s ~= nil or n == 1) then
        return true
    end
    return false
end

--- 键值是否层级数据
CONST_UBERTIP_IS_LEVEL = function(key)
    local a = string.find(key, "_attack")
    local p = string.find(key, "_append")
    local n = string.find(key, "e_")
    if ((a ~= nil or p ~= nil) and n == 1) then
        return true
    end
    return false
end

CONST_UBERTIP_ATTR_XTRAS = function(data, indent)
    indent = indent or ""
    local tempStr = {}
    for _, vv in ipairs(data) do
        local on = vv["on"]
        local actions = string.explode('.', vv["action"] or '')
        if (CONST_EVENT_LABELS[on] ~= nil and #actions == 3) then
            local target = CONST_EVENT_TARGET_LABELS[on][actions[1]]
            local actionType = actions[2]
            local actionField = actions[3]
            local actionFieldLabel = CONST_ATTR[actionField]
            local odds = vv["odds"] or 0
            local during = vv["during"] or 0
            local val = vv["val"] or 0
            local percent = vv["percent"] or 100
            local qty = vv["qty"] or 0
            local rate = vv["rate"] or 0
            local radius = vv["radius"] or 0
            local distance = vv["distance"] or 0
            local height = vv["height"] or 0
            --
            if (odds > 0 and percent ~= nil and val ~= nil) then
                -- 拼凑文本
                local temp2 = CONST_EVENT_LABELS[on] .. '时,'
                temp2 = temp2 .. "有"
                temp2 = temp2 .. odds .. "%几率"
                if (during > 0) then
                    temp2 = temp2 .. "在" .. during .. "秒内"
                end
                -- 拼凑值
                local valLabel
                local unitLabel = "%"
                local isNegative = false
                if (type(percent) == 'table') then
                    unitLabel = ''
                elseif (percent % 100 == 0) then
                    unitLabel = "倍"
                    percent = math.floor(percent / 100)
                end
                if (type(val) == 'number') then
                    if (unitLabel == "%") then
                        valLabel = math.round(percent * 0.01 * math.abs(val))
                    elseif (unitLabel == "倍") then
                        valLabel = math.round(percent * math.abs(val))
                    elseif (unitLabel == '') then
                        valLabel = '随机' .. math.round(percent[1] * math.abs(val)) .. '~' .. math.round(percent[2] * 0.01 * math.abs(val))
                    end
                    isNegative = val < 0
                elseif (type(val) == 'string') then
                    if (unitLabel == '') then
                        percent = '随机' .. percent[1] .. '%~' .. percent[2] .. '%'
                    end
                    isNegative = (string.sub(val, 1, 1) == '-')
                    if (isNegative) then
                        val = string.sub(val, 2)
                    end
                    if (val == 'damage') then
                        valLabel = percent .. unitLabel .. "当前伤害"
                    else
                        local valAttr = string.explode('.', val)
                        if (#valAttr == 2 and CONST_EVENT_TARGET_LABELS[on] and CONST_EVENT_TARGET_LABELS[on][valAttr[1]]) then
                            local au = CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                            au = CONST_UBERTIP_TARGET_LABEL(au, actionType, actionField, true)
                            local aa = valAttr[2]
                            if (aa == 'level') then
                                valLabel = percent .. unitLabel .. au .. "当前等级"
                            elseif (aa == 'gold') then
                                valLabel = percent .. unitLabel .. au .. "当前黄金量"
                            elseif (aa == 'lumber') then
                                valLabel = percent .. unitLabel .. au .. "当前木头量"
                            else
                                valLabel = percent .. unitLabel .. au .. (CONST_ATTR[aa] or '不明属性') .. ""
                            end
                        end
                    end
                end
                -- 补正百分号
                if (type(val) == 'number' and CONST_UBERTIP_IS_PERCENT(actionField) == true) then
                    valLabel = valLabel .. "%"
                end
                -- 对象名称修正
                target = CONST_UBERTIP_TARGET_LABEL(target, actionType, actionField, false)
                if (valLabel ~= nil) then
                    if (actionType == 'attr') then
                        if (isNegative) then
                            temp2 = temp2 .. "减少" .. target
                        else
                            temp2 = temp2 .. "提升" .. target
                        end
                        temp2 = temp2 .. valLabel .. "的" .. actionFieldLabel
                    elseif (actionType == 'spec') then
                        actionFieldLabel = vv["alias"] or actionFieldLabel
                        if (actionField == "knocking") then
                            temp2 = temp2
                                .. "对" .. target .. "造成" .. valLabel .. "的" .. actionFieldLabel .. "的伤害"
                        elseif (actionField == "split") then
                            temp2 = temp2
                                .. actionFieldLabel .. "攻击" .. radius .. "范围的"
                                .. target .. ",造成" .. valLabel .. "的伤害"
                        elseif (actionField == "bomb") then
                            temp2 = temp2
                                .. actionFieldLabel .. radius .. "范围的" .. target
                                .. ",造成" .. valLabel .. "的伤害"
                        elseif (table.includes({ "swim", "silent", "unarm", "fetter" }, actionField)) then
                            temp2 = temp2
                                .. actionFieldLabel .. "目标" .. during .. "秒"
                                .. ",并造成" .. valLabel .. "点伤害"
                        elseif (actionField == "broken") then
                            temp2 = temp2
                                .. actionFieldLabel .. "目标" .. ",并造成" .. valLabel .. "点伤害"
                        elseif (actionField == "lightning_chain") then
                            temp2 = temp2
                                .. "对最多" .. qty .. "个目标"
                                .. "发动" .. valLabel .. "的伤害的" .. actionFieldLabel
                            if (rate > 0) then
                                temp2 = temp2 .. ",每次跳跃渐强" .. rate .. "%"
                            elseif (rate < 0) then
                                temp2 = temp2 .. ",每次跳跃衰减" .. rate .. "%"
                            end
                        elseif (actionField == "crack_fly") then
                            temp2 = temp2
                                .. actionFieldLabel .. "目标达" .. height .. "高度并击退" .. distance .. "距离"
                                .. ",同时造成" .. valLabel .. "的伤害"
                        elseif (actionField == "paw") then
                            temp2 = temp2
                                .. "向前方击出" .. qty .. "道" .. actionFieldLabel
                                .. ",对直线" .. radius .. "范围的" .. target .. "造成" .. valLabel .. "的伤害"
                        end
                    end
                    table.insert(tempStr, indent .. temp2)
                end
            end
        end
    end
    table.sort(tempStr)
    return tempStr
end

--- _attr文本构建
CONST_UBERTIP_ATTR = function(attr, sep, indent)
    sep = sep or "|n"
    indent = indent or ""
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. CONST_UBERTIP_I18N.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_I18N.perSec
        end
        if (CONST_UBERTIP_IS_PERCENT(k) == true) then
            v = v .. "%"
        end
        if (CONST_UBERTIP_IS_LEVEL(k) == true) then
            v = v .. CONST_UBERTIP_I18N.layer
        end
        --
        if (k == "xtras") then
            table.insert(strTable, (CONST_ATTR[k] or "") .. "：")
            local xu = CONST_UBERTIP_ATTR_XTRAS(v)
            if (#xu > 0) then
                for xi, xv in ipairs(xu) do
                    xu[xi] = xi .. '、' .. xv
                end
            end
            table.insert(strTable, string.implode(sep, xu))
        else
            table.insert(str, indent .. (CONST_ATTR[k] or "") .. "：" .. v)
        end
    end
    return string.implode(sep, table.merge(str, strTable))
end

--- 技能光环文本构建
CONST_UBERTIP_RING_ABILITY = function(data)
    local d = {}
    if (data.radius ~= nil) then
        table.insert(d, CONST_UBERTIP_I18N.ringRadius .. CONST_UBERTIP_I18N.colon .. data.radius)
    end
    if (type(data.target) == 'table' and #data.target > 0) then
        local labels = {}
        for _, t in ipairs(data.target) do
            table.insert(labels, CONST_TARGET_LABEL[t])
        end
        table.insert(d, CONST_UBERTIP_I18N.ringTarget .. CONST_UBERTIP_I18N.colon .. string.implode(',', labels))
        labels = nil
    end
    if (data.attr ~= nil) then
        table.insert(d, CONST_UBERTIP_I18N.ringAttr .. CONST_UBERTIP_I18N.colon .. CONST_UBERTIP_ATTR(data.attr, "|n", '-'))
    end
    return d
end

--- 物品光环文本构建
CONST_UBERTIP_RING_ITEM = function(data)
    local txt = CONST_UBERTIP_I18N.ring .. CONST_UBERTIP_I18N.colon .. "[" .. data.radius .. "px]|n"
    return txt .. CONST_UBERTIP_ATTR(data.attr, "|n", '-')
end

--- _attr学习文本构建
CONST_RESEARCH_UBERTIP_ATTR = function(attr)
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. CONST_UBERTIP_I18N.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_I18N.perSec
        end
        if (CONST_UBERTIP_IS_PERCENT(k) == true) then
            v = v .. "%"
        end
        if (CONST_UBERTIP_IS_LEVEL(k) == true) then
            v = v .. CONST_UBERTIP_I18N.layer
        end
        --
        if (k == "xtras") then
            local xu = CONST_UBERTIP_ATTR_XTRAS(v)
            if (#xu > 0) then
                for xi, xv in ipairs(xu) do
                    xu[xi] = xv
                end
            end
            table.insert(strTable, string.implode(",", xu))
        else
            table.insert(str, v .. (CONST_ATTR[k] or ""))
        end
    end
    return string.implode(",", table.merge(str, strTable))
end

--- 技能学习光环文本构建
CONST_RESEARCH_UBERTIP_RING_ABILITY = function(data)
    local d = {}
    if (data.radius ~= nil) then
        table.insert(d, data.radius .. CONST_UBERTIP_I18N.ringInRadius)
    end
    if (type(data.target) == 'table' and #data.target > 0) then
        local labels = {}
        for _, t in ipairs(data.target) do
            table.insert(labels, CONST_TARGET_LABEL[t])
        end
        table.insert(d, "[" .. string.implode(',', labels) .. "]")
        labels = nil
    end
    if (data.attr ~= nil) then
        table.insert(d, CONST_RESEARCH_UBERTIP_ATTR(data.attr))
    end
    return d
end
