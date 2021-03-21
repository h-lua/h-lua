---@class hleaderBoard 排行榜
hleaderBoard = { LBS = {} }

---@private
hleaderBoard.LeaderboardResize = function(whichLeaderBoard)
    local size = cj.LeaderboardGetItemCount(whichLeaderBoard)
    if cj.LeaderboardGetLabelText(whichLeaderBoard) == "" then
        size = size - 1
    end
    cj.LeaderboardSetSizeByItemCount(whichLeaderBoard, size)
end

--- 创建一个排行榜
--- 配置排行榜的周期性数据设定操作
--- 排行榜创建后并不会主动执行，需要使用 show 方法来开启；使用 hide 方法来关闭
---@alias hleaderBoard fun(leaderBoardKey: string):void
---@param key string 排行榜的唯一key
---@param title string 排行榜上方的标题
---@param refreshFrequency number 刷新频率
---@param response hleaderBoard | "function(leaderBoardKey) return {{playerIndex = 1,value = nil}} end" 设置数据的回调,会返回当前的排行榜；另外你需要设置数据传回到create中来，拼凑KV数据
hleaderBoard.create = function(key, title, refreshFrequency, response)
    if (hleaderBoard.LBS[key] ~= nil) then
        cj.DestroyLeaderboard(hleaderBoard.LBS[key].leaderBoard)
    end
    hleaderBoard.LBS[key] = {
        title = title,
        refreshFrequency = refreshFrequency,
        response = response,
        leaderBoard = cj.CreateLeaderboard()
    }
end

--- 展示拍行榜
---@param key string 设定的唯一Key
hleaderBoard.show = function(key)
    if (hleaderBoard.LBS[key] ~= nil) then
        if (hleaderBoard.CURRENT ~= nil) then
            cj.LeaderboardDisplay(hleaderBoard.LBS[key].leaderBoard, false)
        end
        hleaderBoard.CURRENT = key
        local title = hleaderBoard.LBS[key].title
        local refreshFrequency = hleaderBoard.LBS[key].refreshFrequency
        local response = hleaderBoard.LBS[key].response
        local lb = hleaderBoard.LBS[key].leaderBoard
        cj.LeaderboardSetLabel(lb, title or "leader board")
        cj.LeaderboardDisplay(lb, true)
        htime.setInterval(refreshFrequency, function(curTimer)
            if (hleaderBoard.CURRENT ~= key) then
                htime.delTimer(curTimer)
                if (hleaderBoard.CURRENT == nil) then
                    cj.LeaderboardDisplay(lb, false)
                end
                return
            end
            local data = response(key)
            for _, d in ipairs(data) do
                local playerIndex = d.playerIndex
                local value = d.value
                if cj.LeaderboardHasPlayerItem(lb, hplayer.players[playerIndex]) then
                    cj.LeaderboardRemovePlayerItem(lb, hplayer.players[playerIndex])
                end
                cj.PlayerSetLeaderboard(hplayer.players[playerIndex], lb)
                cj.LeaderboardAddItem(lb, cj.GetPlayerName(hplayer.players[playerIndex]), value, hplayer.players[playerIndex])
            end
            cj.LeaderboardSortItemsByValue(lb, false) --降序
            hleaderBoard.LeaderboardResize(lb)
        end)
    end
end

--- 隐藏拍行榜
hleaderBoard.hide = function()
    hleaderBoard.CURRENT = nil
end

--- 设置排行榜的标题
---@param key string 设定的唯一Key
---@param title string
hleaderBoard.setTitle = function(key, title)
    if (hleaderBoard.LBS[key] == nil or hleaderBoard.LBS[key].leaderBoard == nil) then
        return
    end
    cj.LeaderboardSetLabel(hleaderBoard.LBS[key].leaderBoard, title)
end

--- 获取排行第N的玩家
---@param key string 设定的唯一Key
---@param n number
---@return userdata 玩家
hleaderBoard.pos = function(key, n)
    if (hleaderBoard.LBS[key] == nil or hleaderBoard.LBS[key].leaderBoard == nil) then
        return
    end
    if (n < 1 or n > hplayer.qty_max) then
        return
    end
    local pos
    n = n - 1
    for i = 1, hplayer.qty_max, 1 do
        if (cj.LeaderboardGetPlayerIndex(hleaderBoard.LBS[key], hplayer.players[i]) == n) then
            pos = hplayer.players[i]
            break
        end
    end
    return pos
end

--- 获取排行第一的玩家
---@param key string 设定的唯一Key
---@return userdata 玩家
hleaderBoard.top = function(key)
    if (hleaderBoard.LBS[key] == nil or hleaderBoard.LBS[key].leaderBoard == nil) then
        return
    end
    return hleaderBoard.pos(hleaderBoard.LBS[key].leaderBoard, 1)
end

--- 获取排行最后的玩家
---@param key string 设定的唯一Key
---@return userdata 玩家
hleaderBoard.bottom = function(key)
    if (hleaderBoard.LBS[key] == nil or hleaderBoard.LBS[key].leaderBoard == nil) then
        return
    end
    return hleaderBoard.pos(hleaderBoard.LBS[key].leaderBoard, hplayer.qty_max)
end
