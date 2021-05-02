---@class hcmd 框架指令
hcmd = { _c = nil, _cds = {} }

-- Command: -gg 投降
hcmd._cds["-gg"] = {
    pattern = "^-gg$",
    action = function(evtData)
        hplayer.defeat(evtData.triggerPlayer, "GG")
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "主动投降",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = "-gg 投降并退出"
        })
    end
}

-- Command: -apm 查看玩家分钟操作数
hcmd._cds["-apm"] = {
    pattern = "^-apm$",
    action = function(evtData)
        echo("您的apm为:" .. hplayer.getApm(evtData.triggerPlayer), evtData.triggerPlayer)
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "查看你的APM数值",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = "-apm 查看你的APM数值"
        })
    end
}

-- Command: -apc 开关自动转金为木
hcmd._cds["-apc"] = {
    pattern = "^-apc$",
    action = function(evtData)
        if (hplayer.getIsAutoConvert(evtData.triggerPlayer) == true) then
            hplayer.setIsAutoConvert(evtData.triggerPlayer, false)
            echo("|cffffcc00已关闭|r自动换算", evtData.triggerPlayer)
        else
            hplayer.setIsAutoConvert(evtData.triggerPlayer, true)
            echo("|cffffcc00已开启|r自动换算", evtData.triggerPlayer)
        end
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "设定自动转金为木",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-apc 设定是否自动转换黄金为木头",
                "开启后，当黄金达到100万时，自动按照比例把黄金转换为木头",
            }
        })
    end
}

-- Command: -random 随机选择英雄（必须使用hhero的选取法）
hcmd._cds["-random"] = {
    pattern = "^-random$",
    action = function(evtData)
        local p = evtData.triggerPlayer
        if (#hhero.selectorPool <= 0) then
            echo("-random 指令无效", p)
            return
        end
        local pIndex = hplayer.index(p)
        if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
            echo("|cffffff80你已经选够了|r", p)
            return
        end
        local txt = ""
        local qty = 0
        while (true) do
            local one = table.random(hhero.selectorPool)
            table.delete(hhero.selectorPool, one)
            local u = one
            if (type(one) == "string") then
                u = hunit.create({
                    whichPlayer = p,
                    id = one,
                    x = hhero.bornX,
                    y = hhero.bornY
                })
                hcache.set(u, CONST_CACHE.HERO_SELECTOR, hhero.selectorTavern[one])
                cj.RemoveUnitFromStock(hhero.selectorTavern[one], string.char2id(one))
            else
                table.delete(hhero.selectorClearPool, one)
                hunit.setInvulnerable(u, false)
                cj.SetUnitOwner(u, p, true)
                hunit.portal(u, hhero.bornX, hhero.bornY)
                cj.PauseUnit(u, false)
            end
            table.insert(hhero.player_heroes[pIndex], u)
            -- 触发英雄被选择事件(全局)
            hevent.triggerEvent("global", CONST_EVENT.pickHero, {
                triggerPlayer = p,
                triggerUnit = u
            })
            txt = txt .. " " .. cj.GetUnitName(u)
            qty = qty + 1
            if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                break
            end
        end
        echo("已为您 |cffffff80random|r 挑选了 " .. "|cffffff80" .. math.floor(qty) .. "|r 个：|cffffff80" .. txt .. "|r", p)
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "选择英雄指令",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-random 随机选择英雄",
            }
        })
    end
}

-- Command: -repick 重新选择英雄（必须使用hhero的选取法）
hcmd._cds["-repick"] = {
    pattern = "^-repick$",
    action = function(evtData)
        local p = evtData.triggerPlayer
        if (#hhero.selectorPool <= 0) then
            echo("-repick 指令无效", p)
            return
        end
        local pIndex = hplayer.index(p)
        if (#hhero.player_heroes[pIndex] <= 0) then
            echo("|cffffff80你还没有选过任何单位|r", p)
            return
        end
        local qty = #hhero.player_heroes[pIndex]
        for _, u in ipairs(hhero.player_heroes[pIndex]) do
            local heroSelector = hcache.get(u, CONST_CACHE.HERO_SELECTOR)
            if (type(heroSelector) == "userdata") then
                table.insert(hhero.selectorPool, hunit.getId(u))
                cj.AddUnitToStock(heroSelector, cj.GetUnitTypeId(u), 1, 1)
            else
                local new = hunit.create({
                    whichPlayer = hplayer.player_passive,
                    id = cj.GetUnitTypeId(u),
                    x = heroSelector[1],
                    y = heroSelector[2],
                    isInvulnerable = true,
                    isPause = true
                })
                hcache.set(new, CONST_CACHE.HERO_SELECTOR, { heroSelector[1], heroSelector[2] })
                table.insert(hhero.selectorClearPool, new)
                table.insert(hhero.selectorPool, new)
            end
            hunit.del(u, 0)
        end
        hhero.player_heroes[pIndex] = {}
        echo("已为您 |cffffff80repick|r 了 " .. "|cffffff80" .. qty .. "|r 个单位", p)
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "重选英雄指令",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-repick 重新选择英雄",
            }
        })
    end
}

-- Command: -d [+|-][NUMBER]视距减少/增加
hcmd._cds["-d"] = {
    pattern = "^-d [-+]%d+$",
    action = function(evtData)
        local cds = string.explode(" ", string.lower(evtData.chatString))
        local first = string.sub(cds[2], 1, 1)
        if (first == "+" or first == "-") then
            --视距
            local v = string.sub(cds[2], 2, string.len(cds[2]))
            v = math.abs(tonumber(v))
            if (v > 0) then
                local val = math.abs(v)
                if (first == "+") then
                    hcamera.changeDistance(evtData.triggerPlayer, val)
                elseif (first == "-") then
                    hcamera.changeDistance(evtData.triggerPlayer, -val)
                end
            end
        end
    end,
    quest = function()
        hquest.create({
            side = "right",
            title = "调整你的视距",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-d +[number] 增加视距",
                "-d -[number] 减少视距",
                " ! 视距自动设置上下限，请放心设置"
            }
        })
    end
}

--- 配置这局游戏支持的框架指令，只能设置一次
--- commands一览:
--- -gg 投降
--- -apm 显示每分钟操作数
--- -apc 开关金自动转木
--- -random 随机选择英雄
--- -repick 重新选择英雄
--- -d [+|-][NUMBER] 升降视距；例：-d +100 / -d -50
---@param commands table<string> 例 {"-apm","-gg"}
---@param playerIndexes table<number> 例 {1,2,3}
hcmd.conf = function(commands, playerIndexes)
    if (type(commands) ~= "table" or type(playerIndexes) ~= "table") then
        return
    end
    if (hcmd._c ~= nil) then
        return
    end
    hcmd._c = { commands = commands, playerIndexes = playerIndexes }
    for _, c in ipairs(commands) do
        local cd = hcmd._cds[c]
        if (cd ~= nil) then
            cd.quest()
            for _, pIdx in ipairs(playerIndexes) do
                local p = hplayer.players[pIdx]
                if (p ~= nil and his.computer(p) == false) then
                    hevent.onChat(p, cd.pattern, cd.action)
                end
            end
        end
    end
end
