hlightning = {
    enable = true,
    type = {
        shan_dian_lian_zhu = "CLPB", -- 闪电效果 - 闪电链主
        shan_dian_lian_ci = "CLSB", -- 闪电效果 - 闪电链次
        ji_qu = "DRAB", -- 闪电效果 - 汲取
        sheng_ming_ji_qu = "DRAL", -- 闪电效果 - 生命汲取
        mo_fa_ji_qu = "DRAM", -- 闪电效果 - 魔法汲取
        si_wang_zhi_zhi = "AFOD", -- 闪电效果 - 死亡之指
        cha_zhuang_shan_dian = "FORK", -- 闪电效果 - 叉状闪电
        yi_liao_bo_zhu = "HWPB", -- 闪电效果 - 医疗波主
        yi_liao_bo_ci = "HWSB", -- 闪电效果 - 医疗波次
        shan_dian_gong_ji = "CHIM", -- 闪电效果 - 闪电攻击
        ma_fa_liao_kao = "LEAS", -- 闪电效果 - 魔法镣铐
        fa_li_ran_shao = "MBUR", -- 闪电效果 - 法力燃烧
        mo_li_zhi_yan = "MFPB", -- 闪电效果 - 魔力之焰
        ling_hun_suo_lian = "SPLK" -- 闪电效果 - 灵魂锁链
    }
}
--- 删除闪电
---@param lightning userdata
---@param delay number
function hlightning.destroy(lightning, delay)
    delay = delay or 0
    if (delay > 0) then
        htime.setTimeout(delay, function(t)
            t.destroy()
            cj.DestroyLightning(lightning)
        end)
    else
        cj.DestroyLightning(lightning)
    end
end

--- xyz对xyz创建闪电
---@param lightningType string
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param during number 大于0时延时删除
---@return userdata
function hlightning.xyz2xyz(lightningType, x1, y1, z1, x2, y2, z2, during)
    if (hlightning.enable ~= true) then
        return
    end
    local lightning = cj.AddLightningEx(lightningType, true, x1, y1, z1, x2, y2, z2)
    if (during > 0) then
        hlightning.destroy(lightning, during)
    end
    return lightning
end

--- 点对点创建闪电
---@param lightningType string
---@param loc1 userdata
---@param loc2 userdata
---@param during number 大于0时延时删除
---@return userdata
function hlightning.loc2loc(lightningType, loc1, loc2, during)
    return hlightning.xyz2xyz(
        lightningType,
        cj.GetLocationX(loc1),
        cj.GetLocationY(loc1),
        cj.GetLocationZ(loc1),
        cj.GetLocationX(loc2),
        cj.GetLocationY(loc2),
        cj.GetLocationZ(loc2),
        during
    )
end

--- 单位对单位创建闪电
---@param lightningType string
---@param unit1 userdata
---@param unit2 userdata
---@param during number 大于0时延时删除
---@return userdata
function hlightning.unit2unit(lightningType, unit1, unit2, during)
    local loc1 = cj.GetUnitLoc(unit1)
    local loc2 = cj.GetUnitLoc(unit2)
    local l = hlightning.loc2loc(lightningType, loc1, loc2, during)
    cj.RemoveLocation(loc1)
    cj.RemoveLocation(loc2)
    return l
end
