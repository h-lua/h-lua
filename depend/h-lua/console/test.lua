--- 自启动调试
DEBUGGING = true
ydRuntime = require "jass.runtime"
ydRuntime.console = true
ydRuntime.sleep = false
ydRuntime.debugger = 4279
ydRuntime.error_handle = function(msg)
    print("========lua-err========")
    print(tostring(msg))
    print_stack()
    print("=========================")
end
ydDebug = require "jass.debug"
ydConsole = require "jass.console"

local hPrint = print
print = function(...)
    hPrint(...)
end

local types = { "all", "max" }
local typesLabel = {
    all = "总共",
    max = "最大值",
    ["+tmr"] = "计时器",
    ["+ply"] = "玩家",
    ["+frc"] = "玩家势力",
    ["+flt"] = "过滤器",
    ["+w3u"] = "单位",
    ["+grp"] = "单位组",
    ["+rct"] = "区域",
    ["+snd"] = "声音",
    ["+que"] = "任务",
    ["+trg"] = "触发器",
    ["+tac"] = "触发器动作",
    ["+EIP"] = "对点特效",
    ["+EIm"] = "附着特效",
    ["pcvt"] = "玩家聊天事件",
    ["pevt"] = "玩家事件",
    ["uevt"] = "单位事件",
    ["tcnd"] = "触发器条件",
}

handleDisplay = function()
    local count = { all = 0, max = ydDebug.handlemax() }
    for i = 1, count.max do
        local h = 0x100000 + i
        local info = ydDebug.handledef(h)
        if (info and info.type) then
            if (not table.includes(types, info.type)) then
                table.insert(types, info.type)
            end
            if (count[info.type] == nil) then
                count[info.type] = 0
            end
            count.all = count.all + 1
            count[info.type] = count[info.type] + 1
        end
    end
    print_mb("┌-----------------------------------")
    local show = {}
    for _, t in ipairs(types) do
        print_mb("├  " .. (typesLabel[t] or t) .. " : " .. (count[t] or 0))
    end
    print_mb("└-----------------------------------")
    return show
end

---
--- 记录运行时间rem方法。只有key1时为记录，有key2时会打印对应记录间的差值，如：
--- **rem("a") --1**
--- rem("b") --2
--- rem("c") --4
--- print rem("a","b") =1
--- print rem("a","c") =3
rem = function(key1, key2)
    if (type(key1) ~= "string") then
        return
    end
    if (key2 ~= nil and type(key2) ~= "string") then
        return
    end
    if (remStack == nil) then
        remStack = {}
    end
    remStack[key1] = os.clock()
    if (key2 ~= nil) then
        remStack[key2] = os.clock()
        print("[rem " .. key1 .. "->" .. key2 .. "]:" .. remStack[key2] - remStack[key1])
    end
end

--- 打印栈
print_stack = function(...)
    local out = { "[TRACE]" }
    local n = select("#", ...)
    for i = 1, n, 1 do
        local v = select(i, ...)
        out[#out + 1] = tostring(v)
    end
    out[#out + 1] = "\n"
    out[#out + 1] = debug.traceback("", 2)
    print(table.concat(out, " "))
end

--- 打印utf8->ansi编码,此方法可以打印出中文
print_mb = function(...)
    ydConsole.write(...)
end

--- 错误调试
print_err = function(val)
    print("========h-lua-err========")
    if (type(val) == "table") then
        print_mbr(val)
    else
        print_mb(val)
    end
    print_stack()
    print("=========================")
end

--- 打印对象table
---@param showDetail boolean
print_r = function(t, printMethod, showDetail)
    local print_r_cache = {}
    printMethod = printMethod or print
    if (showDetail == nil) then
        showDetail = true
    end
    local function sub_print_r(tt, indent)
        if (print_r_cache[tostring(tt)]) then
            printMethod(indent .. "*" .. tostring(tt))
        else
            print_r_cache[tostring(tt)] = true
            if (type(tt) == "table") then
                for pos, val in pairs(tt) do
                    if (type(pos) == "userdata") then
                        pos = "userdata"
                    end
                    if (type(val) == "table") then
                        printMethod(indent .. "[" .. pos .. "](" .. table.len(val) .. ") => " .. tostring(tt) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        printMethod(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (showDetail == true) then
                        if (type(val) == "string") then
                            printMethod(indent .. "[" .. pos .. '] => <string>"' .. val .. '"')
                        else
                            printMethod(indent .. "[" .. pos .. "] => " .. "<" .. type(val) .. ">" .. tostring(val))
                        end
                    end
                end
            else
                printMethod(indent .. "<" .. type(tt) .. ">" .. tostring(tt))
            end
        end
    end
    if (type(t) == "table") then
        printMethod(tostring(t) .. "(" .. table.len(t) .. ") {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

--- 打印对象table,此方法可以打印出中文
print_mbr = function(t)
    print_r(t, print_mb, true)
end
