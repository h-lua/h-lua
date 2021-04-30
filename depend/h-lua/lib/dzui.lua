local cache = require "lib.dzui.cache"

---@class dzui DzUI
hdzui = {}

hdzui.origin = {
    --- 窗口宽度
    ---@return number integer
    width = function()
        return hjapi.DzGetWindowWidth()
    end,
    --- 窗口高度
    ---@return number integer
    height = function()
        return hjapi.DzGetWindowHeight()
    end,
    --- 游戏
    ---@return number integer
    game = function()
        if (cache.uiGame == nil) then
            cache.uiGame = hjapi.DzGetGameUI()
        end
        return cache.uiGame
    end,
    --- 小地图
    ---@return number integer
    miniMap = function()
        if (cache.uiMiniMap == nil) then
            cache.uiMiniMap = hjapi.DzFrameGetMinimap()
        end
        return cache.uiMiniMap
    end,
    --- 小地图按钮
    ---@return number integer
    miniMapBtn = function()
        if (cache.uiMiniMapBtn == nil) then
            cache.uiMiniMapBtn = {}
            for i = 0, 4 do
                table.insert(cache.uiMiniMapBtn, hjapi.DzFrameGetMinimapButton(i))
            end
        end
        return cache.uiMiniMapBtn
    end,
    --- 单位大头像
    ---@return number integer
    portrait = function()
        if (cache.uiPortrait == nil) then
            cache.uiPortrait = hjapi.DzFrameGetPortrait()
        end
        return cache.uiPortrait
    end,
    --- 聊天消息
    ---@return number integer
    chatMessage = function()
        if (cache.uiChatMessage == nil) then
            cache.uiChatMessage = hjapi.DzFrameGetChatMessage()
        end
        return cache.uiChatMessage
    end,
    --- 鼠标提示
    ---@return number integer
    tooltip = function()
        if (cache.uiTooltip == nil) then
            cache.uiTooltip = hjapi.DzFrameGetTooltip()
        end
        return cache.uiTooltip
    end,
    --- 上方消息框
    ---@return number integer
    topMessage = function()
        if (cache.uiTopMessage == nil) then
            cache.uiTopMessage = hjapi.DzFrameGetTopMessage()
        end
        return cache.uiTopMessage
    end,
    --- 系统消息框
    ---@return number integer
    unitMessage = function()
        if (cache.uiUnitMessage == nil) then
            cache.uiUnitMessage = hjapi.DzFrameGetUnitMessage()
        end
        return cache.uiUnitMessage
    end,
    --- 上方菜单
    ---@return number integer
    menu = function()
        if (cache.uiMenus == nil) then
            cache.uiMenus = {}
            for i = 0, 3 do
                table.insert(cache.uiMenus, hjapi.DzFrameGetUpperButtonBarButton(i))
            end
        end
        return cache.uiMenus
    end,
    --- 物品栏
    ---@return number integer
    itemSlot = function()
        if (cache.uiItemSlot == nil) then
            cache.uiItemSlot = {}
            for i = 0, 5 do
                table.insert(cache.uiItemSlot, hjapi.DzFrameGetItemBarButton(i))
            end
        end
        return cache.uiItemSlot
    end,
    --- 英雄栏(最多7个)
    ---@return number integer
    hero = function()
        if (cache.uiHero == nil) then
            cache.uiHero = {}
            for i = 0, 6 do
                table.insert(cache.uiHero, {
                    avatar = hjapi.DzFrameGetHeroBarButton(i),
                    hp = hjapi.DzFrameGetHeroHPBar(i),
                    mp = hjapi.DzFrameGetHeroManaBar(i),
                })
            end
        end
        return cache.uiHero
    end,
    --- 单位信息栏
    ---@return number integer
    infoPanel = function()
        if (cache.uiInfoPanel == nil) then
            cache.uiInfoPanel = {
                exp = hjapi.DzSimpleFrameFindByName("SimpleHeroLevelBar", 0),
                progress = hjapi.DzSimpleFrameFindByName("SimpleProgressIndicator", 0),
                name = hjapi.DzSimpleFontStringFindByName("SimpleNameValue", 0),
            }
        end
        return cache.uiInfoPanel
    end,
    --- 技能栏
    ---@return number integer
    skill = function()
        if (cache.uiSkill == nil) then
            cache.uiSkill = {
                hjapi.DzFrameGetCommandBarButton(0, 0), -- (0,0)
                hjapi.DzFrameGetCommandBarButton(0, 1), -- (1,0)
                hjapi.DzFrameGetCommandBarButton(0, 2), -- (2,0)
                hjapi.DzFrameGetCommandBarButton(0, 3), -- (3,0)
                hjapi.DzFrameGetCommandBarButton(1, 0), -- (0,1)
                hjapi.DzFrameGetCommandBarButton(1, 1), -- (1,1)
                hjapi.DzFrameGetCommandBarButton(1, 2), -- (2,1)
                hjapi.DzFrameGetCommandBarButton(1, 3), -- (3,1)
                hjapi.DzFrameGetCommandBarButton(2, 0), -- (0,2)
                hjapi.DzFrameGetCommandBarButton(2, 1), -- (1,2)
                hjapi.DzFrameGetCommandBarButton(2, 2), -- (2,2)
                hjapi.DzFrameGetCommandBarButton(2, 3), -- (3,2)
            }
        end
        return cache.uiSkill
    end,
}

--- 启用宽屏
hdzui.wideScreen = function()
    hjapi.DzEnableWideScreen(true)
end

--- 隐藏所有原生界面
hdzui.hideInterface = function()
    hjapi.DzFrameHideInterface()
    hjapi.DzFrameEditBlackBorders(0, 0)
end

--- 加载toc文件
---@param tocFilePath string
hdzui.loadToc = function(tocFilePath)
    if (cache.toc[tocFilePath] == nil) then
        hjapi.DzLoadToc(tocFilePath)
    end
    cache.toc[tocFilePath] = true
end

--- 新建一个frame
---@param fdfName string frame名称
---@param parent number 父节点ID(def:GameUI)
---@param id number ID(def:0)
---@return number|nil
hdzui.frame = function(fdfName, parent, id)
    if (fdfName == nil) then
        return
    end
    parent = parent or hdzui.origin.game()
    id = id or 0
    return hjapi.DzCreateFrame(fdfName, parent, id)
end

--- tag方式新建一个frame
---@param fdfType string frame类型 TEXT | BACKDROP等
---@param fdfName string frame名称
---@param parent number 父节点ID(def:GameUI)
---@param tag string 自定义tag名称(def:cache.tagIdx)
---@param id number integer(def:0)
---@return number|nil
hdzui.frameTag = function(fdfType, fdfName, parent, tag, id)
    if (fdfType == nil or fdfName == nil) then
        return
    end
    cache.tagIdx = cache.tagIdx + 1
    tag = tag or "uit-" .. cache.tagIdx
    parent = parent or hdzui.origin.game()
    return hjapi.DzCreateFrameByTagName(fdfType, tag, parent, fdfName, id)
end

--- 设置frame相对锚点
---@param frameId number
---@param relation number 相对节点ID(def:GameUI)
---@param align number integer 参考blizzard:^FRAME_ALIGN
---@param alignRelation number 以 align-> alignParent 对齐
---@param x number 锚点X
---@param y number 锚点Y
hdzui.framePoint = function(frameId, relation, align, alignRelation, x, y)
    relation = relation or hdzui.origin.game()
    align = align or FRAME_ALIGN_CENTER
    alignRelation = alignRelation or FRAME_ALIGN_CENTER
    x = x or 0
    y = y or 0
    hjapi.DzFrameClearAllPoints(frameId)
    hjapi.DzFrameSetPoint(frameId, align, relation, alignRelation, x, y)
end

--[[
    绑定一个单位在"小地图"上显示你想要的贴图
    options = {
        whichUnit = nil, --某单位
        texture = {file="",w=0.1,h=0.12,opacity}, --是用的单位标志：贴图文件、宽、高、透明[0.0-1.0]
        miniMap = {frame=0,w=0,h=0}, -- 小地图大小位置参数：UI—id、宽、高
        action = function(trackOptions){}, -- 每周期行为
    }
]]
---@param options pilotDZUIMiniMapTrack
hdzui.miniMapTrack = function(options)
    if (options.whichUnit == nil or his.deleted(options.whichUnit)) then
        return
    end
    options.texture = options.texture or {}
    options.texture.file = options.texture.file or hunit.getAvatar(hunit.getId(options.whichUnit))
    options.texture.w = options.texture.w or 0.016
    options.texture.h = options.texture.h or 0.016
    options.texture.opacity = options.texture.opacity or 1.0
    options.miniMap = options.miniMap or {}
    options.miniMap.frame = options.miniMap.frame or hdzui.origin.miniMap()
    options.miniMap.w = options.miniMap.w or 0.13875
    options.miniMap.h = options.miniMap.h or 0.1375
    if (type(options.action) ~= "function") then
        options.action = function(_t)
            -- 设_t.deleted=true则中止追踪
            if (his.dead(_t.whichUnit)) then
                hjapi.DzFrameShow(_t.frame, false)
                return
            end
            hplayer.forEach(function(enumPlayer, _)
                if (enumPlayer == hplayer.loc()) then
                    hjapi.DzFrameShow(_t.frame, his.allyPlayer(_t.whichUnit, enumPlayer))
                end
            end)
        end
    end
    options.disabled = options.disabled or function(whichUnit)
        return his.deleted(whichUnit)
    end
    local track = hdzui.frameTag("BACKDROP", "StandardMenuTinyButtonBaseBackdrop", hdzui.origin.game())
    if (track <= 0) then
        return
    end
    hjapi.DzFrameSetTexture(track, options.texture.file)
    hjapi.DzFrameSetAlpha(track, 255 * options.texture.opacity)
    hjapi.DzFrameSetSize(track, options.texture.w, options.texture.h)
    hjapi.DzFrameShow(track, false)
    options.frame = track
    options.deleted = false
    table.insert(cache.miniMapTrack, options)
    if (cache.miniMapTrackTimer == nil) then
        cache.miniMapTrackTimer = htime.setInterval(0.03, function(curTimer)
            if (#cache.miniMapTrack <= 0) then
                htime.delTimer(curTimer)
                cache.miniMapTrackTimer = nil
                return
            end
            for ti, t in ipairs(cache.miniMapTrack) do
                if (t.deleted == true or his.deleted(t.whichUnit)) then
                    hjapi.DzFrameShow(t.frame, false)
                    hjapi.DzFrameSetEnable(t.frame, false)
                    table.remove(cache.miniMapTrack, ti)
                    ti = ti - 1
                else
                    local x = (hunit.x(t.whichUnit) - hrect.getMinX(hrect.world())) / hrect.getWidth(hrect.world()) * t.miniMap.w
                    local y = (hunit.y(t.whichUnit) - hrect.getMinY(hrect.world())) / hrect.getHeight(hrect.world()) * t.miniMap.h
                    hdzui.framePoint(t.frame, t.miniMap.frame, FRAME_ALIGN_CENTER, FRAME_ALIGN_LEFT_BOTTOM, x, y)
                    t.action(t)
                end
            end
        end)
    end
end

--- 注册鼠标事件
---@param frameId number
---@param mouseOrder number integer 参考blizzard:^MOUSE_ORDER
---@param vjFunc string vjFunction
---@param whichPlayer userdata 玩家
hdzui.onMouse = function(frameId, mouseOrder, vjFunc, whichPlayer)
    if (mouseOrder == nil) then
        return
    end
    if (whichPlayer ~= nil) then
        if (hplayer.loc() == whichPlayer) then
            hjapi.DzFrameSetScript(frameId, mouseOrder, vjFunc, false)
        end
    else
        for i = 1, bj_MAX_PLAYERS, 1 do
            if (hplayer.loc() == hplayer.players[i]) then
                hjapi.DzFrameSetScript(frameId, mouseOrder, vjFunc, false)
            end
        end
    end
end
