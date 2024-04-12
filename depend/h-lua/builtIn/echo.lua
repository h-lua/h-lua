--- 在屏幕打印信息给所有玩家
---@param msg string
---@param whichPlayer userdata 可选，打印给某玩家
---@param duration number
---@param x number 可选，屏幕x处
---@param y number 可选，屏幕y处
---@return void
echo = function(msg, whichPlayer, duration, x, y)
    duration = duration or 0
    x = x or 0
    y = y or 0
    if (whichPlayer == nil) then
        for i = 0, bj_MAX_PLAYERS - 1, 1 do
            if (duration == nil or duration < 5) then
                cj.DisplayTextToPlayer(cj.Player(i), x, y, msg)
            else
                cj.DisplayTimedTextToPlayer(cj.Player(i), x, y, duration, msg)
            end
        end
    else
        if (duration < 5) then
            cj.DisplayTextToPlayer(whichPlayer, x, y, msg)
        else
            cj.DisplayTimedTextToPlayer(whichPlayer, x, y, duration, msg)
        end
    end
end