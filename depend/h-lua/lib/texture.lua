---@class htexture 纹理（遮罩/警示圈）
htexture = {
    --- 系统自带遮罩
    DEFAULT_MARKS = {
        WHITE = "ReplaceableTextures\\CameraMasks\\White_mask.blp", --白色迷雾
        BLACK = "ReplaceableTextures\\CameraMasks\\Black_mask.blp", --黑色迷雾
        HAZE = "ReplaceableTextures\\CameraMasks\\HazeFilter_mask.blp", --薄雾
        GROUND_FOG = "ReplaceableTextures\\CameraMasks\\GroundFog_mask.blp", --地面迷雾
        HAZE_AND_FOG = "ReplaceableTextures\\CameraMasks\\HazeAndFogFilter_Mask.blp", --薄雾和迷雾
        DIAGONAL_SLASH = "ReplaceableTextures\\CameraMasks\\DiagonalSlash_mask.blp", --对角线
        DREAM = "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", --梦境（四周模糊）
        SCOPE = "ReplaceableTextures\\CameraMasks\\Scope_Mask.blp", --范围
    },
}

---@private
function htexture.cinematicFilterGeneric(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    if JassGlobals.bj_cineFadeContinueTimer ~= nil then
        cj.DestroyTimer(JassGlobals.bj_cineFadeContinueTimer)
    end
    if JassGlobals.bj_cineFadeFinishTimer ~= nil then
        cj.DestroyTimer(JassGlobals.bj_cineFadeFinishTimer)
    end
    cj.SetCineFilterTexture(tex)
    cj.SetCineFilterBlendMode(bmode)
    cj.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    cj.SetCineFilterStartUV(0, 0, 1, 1)
    cj.SetCineFilterEndUV(0, 0, 1, 1)
    cj.SetCineFilterStartColor(
        red0,
        green0,
        blue0,
        255 - trans0
    )
    cj.SetCineFilterEndColor(
        red1,
        green1,
        blue1,
        255 - trans1
    )
    cj.SetCineFilterDuration(duration)
    cj.DisplayCineFilter(true)
end

--- 创建一个遮罩
---@param path string 贴图路径 512x256 png->blp
---@param during number 持续时间,默认3秒
---@param whichPlayer userdata|nil 玩家
---@param red number 0-255
---@param green number 0-255
---@param blue number 0-255
---@return void
function htexture.mark(path, during, whichPlayer, red, green, blue)
    if (path == nil) then
        return
    end
    red = red or 255
    green = green or 255
    blue = blue or 255
    during = during or 3
    if (whichPlayer == nil) then
        htexture.cinematicFilterGeneric(
            0.50,
            BLEND_MODE_ADDITIVE,
            path,
            red, green, blue, 255,
            red, green, blue, 0
        )
        htime.setTimeout(during, function(t)
            t.destroy()
            htexture.cinematicFilterGeneric(
                0.50,
                BLEND_MODE_ADDITIVE,
                path,
                red, green, blue, 0,
                red, green, blue, 255
            )
        end)
    elseif (whichPlayer ~= nil) then
        if (hcache.get(whichPlayer, CONST_CACHE.PLAYER_MARKING, false) ~= true) then
            hcache.set(whichPlayer, CONST_CACHE.PLAYER_MARKING, true)
            if (whichPlayer == hplayer.loc()) then
                htexture.cinematicFilterGeneric(
                    0.50,
                    BLEND_MODE_ADDITIVE,
                    path,
                    red, green, blue, 255,
                    red, green, blue, 0
                )
            end
            htime.setTimeout(during, function(t)
                t.destroy()
                hcache.set(whichPlayer, CONST_CACHE.PLAYER_MARKING, false)
                if (whichPlayer == hplayer.loc()) then
                    htexture.cinematicFilterGeneric(
                        0.50,
                        BLEND_MODE_ADDITIVE,
                        path,
                        red, green, blue, 0,
                        red, green, blue, 255
                    )
                end
            end)
        end
    end
end