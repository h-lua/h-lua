---@class hsound 声音
hsound = {
    BREAK_DELAY = 3.3
}

--- 创建音效(播放音效前都要创建的)
---@param path string 音频文件路径
---@param duration number 音频时长（单位：毫秒）
---@param channel number 频道(可选)
---@param volume number 音量[0-127](可选)
---@param pitch number 音高[0.10~2.00](可选)
---@return userdata|nil
hsound.voiceCreate = function(path, duration, channel, volume, pitch)
    if (duration == nil) then
        return
    end
    local voice
    if (path ~= nil) then
        channel = channel or 0
        volume = volume or 127
        pitch = pitch or 1.0
        voice = cj.CreateSound(path, false, true, true, 10, 10, "")
        cj.SetSoundDuration(voice, duration)
        cj.SetSoundChannel(voice, channel)
        cj.SetSoundVolume(voice, volume)
        cj.SetSoundPitch(voice, pitch)
    end
    return voice
end

--- 播放音效(推荐使用hsound.create创造)
---@param s userdata F5设定音效
hsound.voice = function(s)
    if (s ~= nil) then
        cj.StartSound(s)
    end
end
--- 播放音效对某个玩家
---@param s userdata
---@param whichPlayer userdata
hsound.voice2Player = function(s, whichPlayer)
    if (s ~= nil and cj.GetLocalPlayer() == whichPlayer) then
        cj.StartSound(s)
    end
end
--- 绑定单位音效
---@param s userdata
---@param volumePercent number %
---@param u userdata
hsound.voice2Unit = function(s, volumePercent, u)
    if (s ~= nil) then
        cj.AttachSoundToUnit(s, u)
        cj.SetSoundVolume(s, math.floor(volumePercent * 127 * 0.01))
        cj.StartSound(s)
    end
end
--- 绑定坐标音效
---@param s userdata
---@param x number
---@param y number
---@param z number
hsound.voice2XYZ = function(s, x, y, z)
    if (s ~= nil) then
        cj.SetSoundPosition(s, x, y, z)
    end
end

--- 绑定区域音效
---@param s userdata
---@param whichRect userdata
---@param during number 0=unLimit
hsound.voice2Rect = function(s, whichRect, during)
    if (s ~= nil) then
        during = during or 0
        local width = hrect.getWidth(whichRect)
        local height = hrect.getHeight(whichRect)
        cj.SetSoundPosition(s, hrect.getX(whichRect), hrect.getY(whichRect), 0)
        cj.RegisterStackedSound(s, true, width, height)
        if (during > 0) then
            htime.setTimeout(during, function(curTimer)
                htime.delTimer(curTimer)
                cj.UnregisterStackedSound(s, true, width, height)
            end)
        end
    end
end

--- 停止BGM
---@param whichPlayer userdata|nil
hsound.bgmStop = function(whichPlayer)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYERS, 1 do
            hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_CURRENT, nil)
        end
        cj.StopMusic(true)
    else
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, nil)
        if (cj.GetLocalPlayer() == whichPlayer) then
            cj.StopMusic(true)
        end
    end
end

--- 播放BGM
--- 当whichPlayer为nil时代表对全员操作
--- 如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
--- 由于音乐快速切换会卡顿，所以有[BREAK_DELAY]秒的延时（延时间切换BGM之前的会自动失效，只认延时后的最后一首）
--- 延时是每个玩家独立时间，当切换的BGM为同一首时，切换不会进行
---@param musicFileName string
---@param whichPlayer userdata|nil
hsound.bgm = function(musicFileName, whichPlayer)
    if (musicFileName ~= nil and string.len(musicFileName) > 0) then
        if (whichPlayer ~= nil) then
            local bgmDelayTimer = hcache.get(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
            if (musicFileName ~= hcache.get(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, nil)) then
                if (bgmDelayTimer ~= nil) then
                    htime.delTimer(bgmDelayTimer)
                    hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                end
                hsound.bgmStop(whichPlayer)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, musicFileName)
                hcache.set(
                    whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER,
                    htime.setTimeout(hsound.BREAK_DELAY, function(t)
                        htime.delTimer(t)
                        hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                        if (cj.GetLocalPlayer() == whichPlayer) then
                            cj.PlayMusic(musicFileName)
                        end
                    end)
                )
            end
        else
            hsound.bgmStop()
            for i = 1, bj_MAX_PLAYERS, 1 do
                local bgmDelayTimer = hcache.get(hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                if (musicFileName ~= hcache.get(hplayer.players[i], CONST_CACHE.PLAYER_BGM_CURRENT, nil)) then
                    if (bgmDelayTimer ~= nil) then
                        htime.delTimer(bgmDelayTimer)
                        hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                    end
                    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_CURRENT, musicFileName)
                    hcache.set(
                        hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER,
                        htime.setTimeout(hsound.BREAK_DELAY, function(t)
                            htime.delTimer(t)
                            hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                            if (cj.GetLocalPlayer() == hplayer.players[i]) then
                                cj.PlayMusic(musicFileName)
                            end
                        end)
                    )
                end
            end
        end
    end
end
