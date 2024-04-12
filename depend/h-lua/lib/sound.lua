---@class hsound 声音
hsound = {
    BREAK_DELAY = 3.3
}

--- 创建音效(播放音效前都要创建的)
---@param path string 音频文件路径
---@param duration number 音频时长（单位：毫秒）
---@param is3D boolean 是否3D音效
---@param channel number 频道(可选)
---@param volume number 音量[0-127](可选)
---@param pitch number 音高[0.10~2.00](可选)
---@return userdata|nil
function hsound.voiceCreate(path, duration, is3D, channel, volume, pitch)
    if (duration == nil) then
        return
    end
    local voice
    if (path ~= nil) then
        is3D = is3D or false
        volume = volume or 127
        channel = channel or 0
        pitch = pitch or 1.0
        voice = cj.CreateSound(path, false, is3D, is3D, 10, 10, "")
        cj.SetSoundDuration(voice, duration)
        cj.SetSoundVolume(voice, volume)
        if (channel) then
            cj.SetSoundChannel(voice, channel)
        end
        if (pitch) then
            cj.SetSoundPitch(voice, pitch)
        end
    end
    return voice
end

--- 播放非3D音效(推荐使用hsound.create创造)
---@param s userdata F5设定音效
function hsound.voice(s)
    if (s ~= nil) then
        cj.StartSound(s)
    end
end
--- 播放3D音效对某个玩家
---@param s userdata
---@param whichPlayer userdata
function hsound.voice2Player(s, whichPlayer)
    if (s ~= nil and hplayer.loc() == whichPlayer) then
        cj.StartSound(s)
    end
end
--- 绑定单位音效|3D音效
---@param s userdata
---@param volumePercent number %
---@param u userdata
function hsound.voice2Unit(s, volumePercent, u)
    if (s ~= nil) then
        cj.AttachSoundToUnit(s, u)
        cj.SetSoundVolume(s, math.floor(volumePercent * 127 * 0.01))
        cj.StartSound(s)
    end
end
--- 绑定坐标3D音效
---@param s userdata
---@param x number
---@param y number
---@param z number
function hsound.voice2XYZ(s, x, y, z)
    if (s ~= nil) then
        cj.SetSoundPosition(s, x, y, z)
    end
end

--- 绑定区域3D音效
---@param s userdata
---@param whichRect userdata
---@param during number 0=unLimit
function hsound.voice2Rect(s, whichRect, during)
    if (s ~= nil) then
        during = during or 0
        local width = hrect.getWidth(whichRect)
        local height = hrect.getHeight(whichRect)
        cj.SetSoundPosition(s, hrect.getX(whichRect), hrect.getY(whichRect), 0)
        cj.RegisterStackedSound(s, true, width, height)
        if (during > 0) then
            htime.setTimeout(during, function(curTimer)
                curTimer.destroy()
                cj.UnregisterStackedSound(s, true, width, height)
            end)
        end
    end
end

--- 停止BGM
---@param whichPlayer userdata|nil
function hsound.bgmStop(whichPlayer)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYERS, 1 do
            hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_CURRENT, nil)
        end
        cj.StopMusic(true)
    else
        hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, nil)
        if (hplayer.loc() == whichPlayer) then
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
function hsound.bgm(musicFileName, whichPlayer)
    if (musicFileName ~= nil and string.len(musicFileName) > 0) then
        if (whichPlayer ~= nil) then
            local bgmDelayTimer = hcache.get(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
            if (musicFileName ~= hcache.get(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, nil)) then
                if (bgmDelayTimer ~= nil) then
                    bgmDelayTimer.destroy()
                    hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                end
                hsound.bgmStop(whichPlayer)
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_CURRENT, musicFileName)
                hcache.set(
                    whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER,
                    htime.setTimeout(hsound.BREAK_DELAY, function(t)
                        t.destroy()
                        hcache.set(whichPlayer, CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                        if (hplayer.loc() == whichPlayer) then
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
                        bgmDelayTimer.destroy()
                        hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                    end
                    hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_CURRENT, musicFileName)
                    hcache.set(
                        hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER,
                        htime.setTimeout(hsound.BREAK_DELAY, function(t)
                            t.destroy()
                            hcache.set(hplayer.players[i], CONST_CACHE.PLAYER_BGM_DELAY_TIMER, nil)
                            if (hplayer.loc() == hplayer.players[i]) then
                                cj.PlayMusic(musicFileName)
                            end
                        end)
                    )
                end
            end
        end
    end
end

--- 设置BGM音量
---@param percent number 0-100%
---@param whichPlayer userdata|nil player
function hsound.bgmVolume(percent, whichPlayer)
    percent = percent or 50
    if (whichPlayer ~= nil) then
        if (hplayer.loc() == whichPlayer) then
            cj.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, percent * 0.01)
        end
    else
        cj.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, percent * 0.01)
    end
end
