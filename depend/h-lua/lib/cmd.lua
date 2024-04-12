--- 配置这局游戏支持的框架指令
---@param pattern string 命令正则匹配规则
---@param callFunc fun(evtData:onChatData)
---@return void
function hcmd(pattern, callFunc)
    if (type(pattern) ~= "string" or type(callFunc) ~= "function") then
        return
    end
    for i = 1, bj_MAX_PLAYERS, 1 do
        local p = hplayer.players[i]
        if (p ~= nil and hplayer.isComputer(p) == false) then
            hevent.onChat(p, pattern, callFunc)
        end
    end
end