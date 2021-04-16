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

--- 设置frame绝对锚点
---@param frameId number
---@param align number
---@param x number 锚点X
---@param y number 锚点Y
hdzui.frameAbsolutePoint = function(frameId, align, x, y)
    align = align or FRAME_ALIGN_CENTER
    x = x or 0
    y = y or 0
    hjapi.DzFrameClearAllPoints(frameId)
    hjapi.DzFrameSetAbsolutePoint(frameId, align, x, y)
end

--- 设置frame尺寸
---@param frameId number
---@param width number 宽
---@param height number 高
hdzui.frameSize = function(frameId, width, height)
    hjapi.DzFrameSetSize(frameId, width or 0.1, height or 0.1)
end

--- 设置frame贴图
---@param frameId number
---@param blp string 贴图路径
hdzui.frameTexture = function(frameId, blp)
    hjapi.DzFrameSetTexture(frameId, blp or "", 0)
end

--- 锁定鼠标在frame内
---@param frameId number
---@param cage boolean
hdzui.frameCageMouse = function(frameId, cage)
    hjapi.DzFrameCageMouse(frameId, cage or false)
end

--- 启用|禁用 frame
---@param frameId number
---@param enable boolean
hdzui.frameEnable = function(frameId, enable)
    hjapi.DzFrameSetEnable(frameId, enable)
end

--- frame是否启用
---@param frameId number
hdzui.frameIsEnable = function(frameId)
    print(hjapi.DzFrameGetEnable(frameId))
    return hjapi.DzFrameGetEnable(frameId) or false
end

--- 显示|隐藏 frame
---@param frameId number
---@param enable boolean
---@param whichPlayer userdata 只作用于某位玩家
hdzui.frameToggle = function(frameId, enable, whichPlayer)
    if (whichPlayer == nil) then
        hjapi.DzFrameShow(frameId, enable)
    elseif (cj.GetLocalPlayer() == whichPlayer) then
        hjapi.DzFrameShow(frameId, enable)
    end
end

--- 设置frame文本内容
---@param frameId number
---@param txt string 内容
hdzui.frameSetText = function(frameId, txt)
    hjapi.DzFrameSetText(frameId, txt)
end

--- 注册鼠标事件
---@param frameId number
---@param mouseOrder number integer 参考blizzard:^MOUSE_ORDER
---@param whichPlayer userdata 玩家
---@param vjFunc string vjFunction
hdzui.onMouse = function(frameId, mouseOrder, whichPlayer, vjFunc)
    if (mouseOrder == nil) then
        return
    end
    if (cj.GetLocalPlayer() == whichPlayer) then
        hjapi.DzFrameSetScript(frameId, mouseOrder, vjFunc, false)
    end
end

--- 记录demo所有UI的全局变量
---@private
hdzui.DEMO_UI = {}

--- 框架自带的demo
--- !仅供参考，切勿乱用!
--- 玩家、选择单位的属性显示
--- 需要在main函数前 hideInterface()
--[[
    options = {
        target_hp_unit = 5000, --目标单位单条血量
    }
]]
---@param options pilotUIDEMO
hdzui.DEMO = function(options)
    options = options or {}
    options.target_hp_unit = options.target_hp_unit or 5000
    cj.FogMaskEnable(false)
    hdzui.loadToc("UI\\frame.toc")
    local width = 3200
    local height = 640
    local size_x = 0.8
    local size_y = height / width * size_x
    local _x = function(num)
        return num / width * size_x
    end
    local _y = function(num)
        return -(num - (1024 - height)) / height * size_y
    end
    local pxIt = 125
    local pxItx = 10.5
    local pxIty = 8.5
    local pxSk = 150
    local pxSkx = 14
    local pxSky = 10
    local px = {
        minMap = { w = _x(388), h = _x(388), x = _x(376.1892), y = _y(618.6245) },
        minMapBtn = {
            { w = _x(57.3751), h = _x(49.0004), x = _x(296.3765), y = _y(624.8737) },
            { w = _x(57.3751), h = _x(49.0004), x = _x(296.3765), y = _y(687.1362) },
            { w = _x(57.3751), h = _x(49.0004), x = _x(296.3765), y = _y(748.2268) },
            { w = _x(57.3751), h = _x(49.0004), x = _x(296.3765), y = _y(809.3958) },
            { w = _x(51.9997), h = _x(48.2053), x = _x(299.3033), y = _y(888) },
        },
        portrait = { w = _x(371.2194), h = _x(372.1813), x = _x(786.1427), y = _y(577.6204) },
        hp = { w = _x(238.11), h = _x(35.6226000000), x = _x(873.17), y = _y(925.0998) },
        mp = { w = _x(238.11), h = _x(35.6226000000), x = _x(873.17), y = _y(976.0349) },
        info = { w = _x(757.7399), h = _x(469.1952), x = _x(1183.6135), y = _y(553.8748) },
        sell = { w = _x(264.8083), h = _x(48.071), x = _x(1987.4771), y = _y(559.8199) },
        resource = { w = _x(640.4091), h = _x(47.9624), x = _x(2282.46), y = _y(487.3246) },
        item = {
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990), y = _y(617) },
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990 + (pxIt + pxItx)), y = _y(617) },
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990), y = _y(617 + (pxIt + pxIty)) },
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990 + (pxIt + pxItx)), y = _y(617 + (pxIt + pxIty)) },
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990), y = _y(617 + (pxIt + pxIty) * 2) },
            { w = _x(pxIt), h = _x(pxIt), x = _x(1990 + (pxIt + pxItx)), y = _y(617 + (pxIt + pxIty) * 2) },
        },
        skill = {
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281), y = _y(540) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx)), y = _y(540) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 2), y = _y(540) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 3), y = _y(540) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281), y = _y(540 + (pxSk + pxSky)) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx)), y = _y(540 + (pxSk + pxSky)) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 2), y = _y(540 + (pxSk + pxSky)) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 3), y = _y(540 + (pxSk + pxSky)) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281), y = _y(540 + (pxSk + pxSky) * 2) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx)), y = _y(540 + (pxSk + pxSky) * 2) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 2), y = _y(540 + (pxSk + pxSky) * 2) },
            { w = _x(pxSk), h = _x(pxSk), x = _x(2281 + (pxSk + pxSkx) * 3), y = _y(540 + (pxSk + pxSky) * 2) },
        },
    }
    --
    hdzui.DEMO_UI.game = hdzui.origin.game()
    -- 设置
    local txt = {
        { "F8", "F8  空闲信使" },
        { "F9", "F9  帮助" },
        { "F10", "F10 菜单" },
        { "F11", "F11 盟友" },
        { "F12", "F12 消息" },
    }
    for i, t in ipairs(txt) do
        hdzui.DEMO_UI[t[1]] = hdzui.frameTag("TEXT", "txt_10l", hdzui.DEMO_UI.game)
        hdzui.frameSize(hdzui.DEMO_UI[t[1]], 0.06, 0.016)
        hdzui.framePoint(hdzui.DEMO_UI[t[1]], hdzui.DEMO_UI.game, FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_RIGHT_BOTTOM, -0.052, 0.088 - (i - 1) * 0.016)
        hdzui.frameSetText(hdzui.DEMO_UI[t[1]], t[2])
    end
    -- 底部命令区
    hdzui.DEMO_UI.main = hdzui.frame("main", hdzui.DEMO_UI.game)
    hjapi.DzFrameSetAlpha(hdzui.DEMO_UI.main, 240)
    hdzui.frameSize(hdzui.DEMO_UI.main, size_x, size_x * (height / width))
    hdzui.framePoint(hdzui.DEMO_UI.main, hdzui.DEMO_UI.game, FRAME_ALIGN_BOTTOM, FRAME_ALIGN_BOTTOM, 0, 0)
    --- 系统消息框
    hdzui.DEMO_UI.unitMessage = hdzui.origin.unitMessage()
    hdzui.frameSize(hdzui.DEMO_UI.unitMessage, 0.2, 0.1)
    hdzui.framePoint(hdzui.DEMO_UI.unitMessage, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_LEFT_TOP, px.minMapBtn[1].x - 0.01, -0.018)
    hdzui.frameToggle(hdzui.DEMO_UI.unitMessage, true)
    --- 上方消息框
    hdzui.DEMO_UI.topMessage = hdzui.origin.topMessage()
    hdzui.framePoint(hdzui.DEMO_UI.topMessage, hdzui.DEMO_UI.game, FRAME_ALIGN_TOP, FRAME_ALIGN_TOP, 0, -0.04)
    hdzui.frameToggle(hdzui.DEMO_UI.topMessage, true)
    -- 小地图
    hdzui.DEMO_UI.minMap = hdzui.origin.miniMap()
    hdzui.frameToggle(hdzui.DEMO_UI.minMap, true)
    hdzui.frameSize(hdzui.DEMO_UI.minMap, px.minMap.w, px.minMap.h)
    hdzui.framePoint(hdzui.DEMO_UI.minMap, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.minMap.x, px.minMap.y)
    -- 小地图按钮
    hdzui.DEMO_UI.minMapBtn = hdzui.origin.miniMapBtn()
    for i, f in ipairs(hdzui.DEMO_UI.minMapBtn) do
        hdzui.frameToggle(f, true)
        hdzui.frameSize(f, px.minMapBtn[i].w, px.minMapBtn[i].h)
        hdzui.framePoint(f, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.minMapBtn[i].x, px.minMapBtn[i].y)
    end
    --- 单位大头像
    hdzui.DEMO_UI.portrait = hdzui.origin.portrait()
    hdzui.frameToggle(hdzui.DEMO_UI.portrait, true)
    hdzui.frameSize(hdzui.DEMO_UI.portrait, px.portrait.w, px.portrait.h)
    hdzui.framePoint(hdzui.DEMO_UI.portrait, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.portrait.x, px.portrait.y)
    --- 聊天消息
    hdzui.DEMO_UI.chatMessage = hdzui.origin.chatMessage()
    hdzui.frameSize(hdzui.DEMO_UI.chatMessage, 0.21, 0.2)
    hdzui.framePoint(hdzui.DEMO_UI.chatMessage, hdzui.DEMO_UI.main, FRAME_ALIGN_BOTTOM, FRAME_ALIGN_TOP, 0, 0.014)
    hdzui.frameToggle(hdzui.DEMO_UI.chatMessage, true)
    --- 物品栏
    hdzui.DEMO_UI.itemSlot = hdzui.origin.itemSlot()
    hdzui.DEMO_UI.itemSlotBlock = {}
    for i, f in ipairs(hdzui.DEMO_UI.itemSlot) do
        hdzui.frameSize(f, px.item[i].w, px.item[i].w)
        hdzui.framePoint(f, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.item[i].x, px.item[i].y)
        hdzui.frameToggle(f, true)
        local block = hdzui.frameTag("BACKDROP", "bg_block", hdzui.DEMO_UI.main)
        hdzui.framePoint(block, f, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
        hdzui.frameSize(block, px.item[i].w, px.item[i].w)
        hjapi.DzFrameSetAlpha(block, 127)
        table.insert(hdzui.DEMO_UI.itemSlotBlock, block)
    end
    --- 鼠标提示
    hdzui.DEMO_UI.tooltip = hdzui.origin.tooltip()
    hdzui.framePoint(hdzui.DEMO_UI.tooltip, hdzui.DEMO_UI.itemSlot[1], FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_LEFT_TOP, -0.002, 0.06)
    hdzui.frameToggle(hdzui.DEMO_UI.tooltip, true)
    --- 技能栏
    hdzui.DEMO_UI.skillSlot = hdzui.origin.skill()
    hdzui.DEMO_UI.skillSlotBlock = {}
    for i, sk in ipairs(hdzui.DEMO_UI.skillSlot) do
        hdzui.frameSize(sk, px.skill[i].w, px.skill[i].w)
        hdzui.framePoint(sk, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.skill[i].x, px.skill[i].y)
        hdzui.frameToggle(sk, true)
        local block = hdzui.frameTag("BACKDROP", "bg_block", hdzui.DEMO_UI.main)
        hdzui.framePoint(block, sk, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
        hdzui.frameSize(block, px.skill[i].w, px.skill[i].w)
        hjapi.DzFrameSetAlpha(block, 127)
        table.insert(hdzui.DEMO_UI.skillSlotBlock, block)
    end
    --- 英雄栏
    hdzui.DEMO_UI.hero = hdzui.origin.hero()
    local hx = px.info.x - 0.002
    local d = 0.024
    for _, h in ipairs(hdzui.DEMO_UI.hero) do
        hdzui.frameSize(h.avatar, d, d)
        hdzui.framePoint(h.avatar, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_LEFT_TOP, hx, -0.016)
        hdzui.frameSize(h.hp, d - 0.002, d * 0.06)
        hdzui.framePoint(h.hp, h.avatar, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0.001, 0)
        hdzui.frameSize(h.mp, d - 0.002, d * 0.06)
        hdzui.framePoint(h.mp, h.hp, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
        hx = hx + d + 0.002
    end
    -- 条:长度
    local bar_len = 0.074
    local moreBtns = { "more_x_tras", "more_x_oppose", "more_e_attack", "more_e_append", "more_e_oppose" }
    -- 之后下面是自定义UI
    -- 每个周期都更新UI
    hdzui.DEMO_UI.update = function()
        hplayer.forEach(function(enumPlayer, idx)
            if (cj.GetLocalPlayer() == enumPlayer) then
                hdzui.frameSetText(hdzui.DEMO_UI.gold, hcolor.mixed(hplayer.getGold(enumPlayer), "E7B730"))
                hdzui.frameSetText(hdzui.DEMO_UI.lumber, hcolor.mixed(hplayer.getLumber(enumPlayer), "C47A3A"))
                hdzui.frameSetText(hdzui.DEMO_UI.gold_ratio, hcolor.grey(hplayer.getGoldRatio(enumPlayer) .. "%"))
                hdzui.frameSetText(hdzui.DEMO_UI.lumber_ratio, hcolor.grey(hplayer.getLumberRatio(enumPlayer) .. "%"))
                hdzui.frameSetText(hdzui.DEMO_UI.sell_ratio, "售卖率:" .. hplayer.getSellRatio(enumPlayer) .. "%")
                hdzui.frameSetText(hdzui.DEMO_UI.exp_ratio, hcolor.mixed("经验率:" .. hplayer.getExpRatio(enumPlayer) .. "%", "78B5E4"))
            end
            local show = false
            local isHero = false
            local isPeriod = false
            local isOpenPunish = false
            local isBarE1 = false
            local isBarE2 = false
            local isBarExp = false
            local isBarPeriod = false
            local isBarPunish = false
            local primary
            local isStr = false
            local isAgi = false
            local isInt = false
            local selection
            local data = {}
            local lastTarget
            if (his.playing(enumPlayer)) then
                selection = hplayer.getSelection(enumPlayer)
                lastTarget = hevent.getPlayerLastDamageTarget(enumPlayer)
                if (selection ~= nil) then
                    local attr = hattribute.get(selection)
                    if (attr ~= nil and his.alive(selection) and false == his.deleted(selection)) then
                        show = true
                        isHero = his.hero(selection)
                        primary = hhero.getPrimary(selection)
                        isStr = (primary == "STR")
                        isAgi = (primary == "AGI")
                        isInt = (primary == "INT")
                        isPeriod = hunit.getPeriod(selection) > 0
                        isOpenPunish = hunit.isPunishing(selection)
                        isBarE1 = isPeriod or isHero
                        isBarE2 = isOpenPunish
                        isBarExp = isHero
                        isBarPeriod = isPeriod
                        isBarPunish = isOpenPunish
                        -- 生命
                        local hpc = math.floor(hunit.getCurLife(selection))
                        local hpm = math.floor(hunit.getMaxLife(selection))
                        if (hpm == 0 or hpc > hpm * 0.85) then
                            data.hp = hcolor.mixed(hpc, "32CD32") .. "/" .. hpm
                        elseif (hpc > hpm * 0.60) then
                            data.hp = hcolor.mixed(hpc, "7FFF00") .. "/" .. hpm
                        elseif (hpc > hpm * 0.45) then
                            data.hp = hcolor.mixed(hpc, "ADFF2F") .. "/" .. hpm
                        elseif (hpc > hpm * 0.25) then
                            data.hp = hcolor.mixed(hpc, "FFFF00") .. "/" .. hpm
                        else
                            data.hp = hcolor.red(hpc) .. "/" .. hpm
                        end
                        -- 魔法
                        local mpc = math.floor(hunit.getCurMana(selection))
                        local mpm = math.floor(hunit.getMaxMana(selection))
                        if (mpm == 0 or mpc > mpm * 0.6) then
                            data.mp = hcolor.mixed(mpc, "1E90FF") .. "/" .. mpm
                        elseif (mpc > mpm * 0.3) then
                            data.mp = hcolor.mixed(mpc, "87CEFA") .. "/" .. mpm
                        else
                            data.mp = hcolor.red(mpc) .. "/" .. mpm
                        end
                        -- 治疗加成
                        local cure = 1 + 0.01 * (attr.cure or 0)
                        -- 生命恢复
                        local life_back = math.round(attr.life_back * cure, 1)
                        if (life_back > hattr.CURE_FLOOR) then
                            data.life_back = hcolor.mixed("+" .. math.numberFormat(life_back, 1), "32CD32")
                        elseif (life_back < -hattr.CURE_FLOOR) then
                            data.life_back = hcolor.red(math.numberFormat(life_back, 1))
                        else
                            data.life_back = "+0.00"
                        end
                        -- 魔法恢复
                        local mana_back = math.round(attr.mana_back * cure, 1)
                        if (mana_back > hattr.CURE_FLOOR) then
                            data.mana_back = hcolor.mixed("+" .. math.numberFormat(mana_back, 1), "1E90FF")
                        elseif (mana_back < -hattr.CURE_FLOOR) then
                            data.mana_back = hcolor.red(math.numberFormat(mana_back, 1))
                        else
                            data.mana_back = "+0.00"
                        end
                        -- 名称
                        data.unit_name = hunit.getName(selection)
                        data.hero_name = hhero.getProperName(selection)
                        if (data.hero_name ~= "") then
                            data.hero_name = "·" .. data.hero_name
                        end
                        local attrBuilder = function(label, def, defCheck, buffs, isPositive, val, unit)
                            if (defCheck == true) then
                                return hcolor.grey(label .. ":" .. def)
                            end
                            local sUp = "+"
                            local sDown = "-"
                            if (isPositive == false) then
                                sUp = "-"
                                sDown = "+"
                            end
                            local up = 0
                            local down = 0
                            if (type(buffs) == "table") then
                                for _, bk in ipairs(buffs) do
                                    up = up + hbuff.count(selection, "attr." .. bk .. sUp)
                                    down = down + hbuff.count(selection, "attr." .. bk .. sDown)
                                end
                            end
                            local atr
                            if (up == down) then
                                atr = label .. ":" .. val .. unit
                            elseif (up > down) then
                                atr = label .. ":" .. hcolor.green(val .. unit)
                            else
                                atr = label .. ":" .. hcolor.red(val .. unit)
                            end
                            return atr
                        end
                        data.reborn = attrBuilder(
                            "复活", "不能", attr.reborn < 0,
                            { "reborn" }, false,
                            math.round(attr.reborn, 1), "秒"
                        )
                        local weapsOn = hslk.i2v(hunit.getId(selection), "slk", "weapsOn") or "0"
                        local can_attack = ("0" ~= weapsOn)
                        data.attack = attrBuilder(
                            "攻击", "无", not can_attack,
                            { "attack_white", "attack_green" }, true,
                            math.numberFormat(attr.attack_sides[1], 1) .. "~" .. math.numberFormat(attr.attack_sides[2], 1), "")
                        data.attack_speed = attrBuilder(
                            "攻速", "无", not can_attack,
                            { "attack_speed" }, true,
                            math.round(attr.attack_space, 1), "秒")
                        if (attr.attack_speed > 0) then
                            data.attack_speed = data.attack_speed .. hcolor.grey("(+" .. math.floor(attr.attack_speed) .. "%)")
                        elseif (attr.attack_speed < 0) then
                            data.attack_speed = data.attack_speed .. hcolor.redLight("(" .. math.floor(attr.attack_speed) .. "%)")
                        end
                        data.attack_range = attrBuilder(
                            "攻击范围", "无", not can_attack,
                            { "attack_range" }, true,
                            math.floor(attr.attack_range), "")
                        data.knocking_extent = attrBuilder(
                            "暴击加成", "无", not can_attack,
                            { "knocking_extent" }, true,
                            math.round(attr.knocking_extent, 2), "%")
                        data.knocking_odds = attrBuilder(
                            "暴击几率", "无", not can_attack,
                            { "knocking_odds" }, true,
                            math.round(attr.knocking_odds, 2), "%")
                        data.hemophagia = attrBuilder(
                            "攻击吸血", "无", not can_attack,
                            { "hemophagia" }, true,
                            math.round(attr.hemophagia, 2), "%")
                        data.hemophagia_skill = attrBuilder(
                            "技能吸血", "无", false,
                            { "hemophagia_skill" }, true,
                            math.round(attr.hemophagia_skill, 2), "%")
                        data.weight = attrBuilder(
                            "负重", "无", false == his.hasSlot(selection),
                            { "weight" }, true,
                            math.floor(attr.weight_current) .. "/" .. math.floor(attr.weight), "Kg")
                        data.move = attrBuilder(
                            "移动", "无", false,
                            { "move" }, true,
                            math.floor(attr.move), "")
                        if (his.invincible(selection)) then
                            data.defend = "护甲:" .. hcolor.gold("无敌")
                        else
                            data.defend = attrBuilder(
                                "护甲", "无", false,
                                { "attack_white", "attack_green" }, true,
                                math.floor(attr.defend), "")
                            if (his.invisible(selection)) then
                                data.defend = data.defend .. hcolor.grey("[隐身]")
                            elseif (his.immune(selection)) then
                                data.defend = data.defend .. hcolor.grey("[魔免]")
                            elseif (his.ethereal(selection)) then
                                data.defend = data.defend .. hcolor.grey("[虚无]")
                            else
                                data.defend = data.defend .. hcolor.grey("(-" .. math.round(hattribute.getArmorReducePercent(attr.defend) * 100, 1) .. "%)")
                            end
                        end
                        data.damage_reduce = attrBuilder(
                            "减伤", "无", false,
                            { "damage_reduction", "damage_decrease" }, true,
                            math.round(attr.damage_decrease, 2) .. "%+" .. math.floor(attr.damage_reduction), "")
                        data.cure = attrBuilder(
                            "治疗加成", "无", false,
                            { "cure" }, true,
                            math.round(attr.cure, 2), "%")
                        data.avoid = attrBuilder(
                            "回避几率", "无", false,
                            { "avoid" }, true,
                            math.round(attr.avoid, 2), "%")
                        data.aim = attrBuilder(
                            "命中加成", "无", false,
                            { "aim" }, true,
                            math.round(attr.aim, 2), "%")
                        data.damage_extent = attrBuilder(
                            "伤害增幅", "无", false,
                            { "damage_extent" }, true,
                            math.round(attr.damage_extent, 2), "%")
                        data.damage_rebound = attrBuilder(
                            "反弹伤害", "无", false,
                            { "damage_rebound" }, true,
                            math.round(attr.damage_rebound, 2), "%")
                        data.sight_day = attrBuilder(
                            "白天视野", "无", false,
                            { "sight" }, true,
                            math.floor(attr.sight_day), "")
                        data.sight_night = attrBuilder(
                            "黑夜视野", "无", false,
                            { "sight" }, true,
                            math.floor(attr.sight_night), "")
                        if (isHero) then
                            data.str = attrBuilder(
                                hcolor.mixed("力量", "FFA99F"), "无", false,
                                { "str_white", "str_green" }, true,
                                math.floor(attr.str), "")
                            data.agi = attrBuilder(
                                hcolor.mixed("敏捷", "CBFF9E"), "无", false,
                                { "agi_white", "agi_green" }, true,
                                math.floor(attr.agi), "")
                            data.int = attrBuilder(
                                hcolor.mixed("智力", "A0E1FF"), "无", false,
                                { "int_white", "int_green" }, true,
                                math.floor(attr.int), "")
                            data.str_plus = attrBuilder(
                                hcolor.mixed("成长", "FFA99F"), "无", false,
                                {}, true,
                                "+" .. hhero.getStrPlus(selection), "")
                            data.agi_plus = attrBuilder(
                                hcolor.mixed("成长", "CBFF9E"), "无", false,
                                {}, true,
                                "+" .. hhero.getAgiPlus(selection), "")
                            data.int_plus = attrBuilder(
                                hcolor.mixed("成长", "A0E1FF"), "无", false,
                                {}, true,
                                "+" .. hhero.getIntPlus(selection), "")
                        end
                        local e_attack = 0
                        local e_append = 0
                        local e_oppose = 0
                        for _, v in ipairs(CONST_ENCHANT) do
                            if ((attr["e_" .. v.value .. "_attack"] or 0) > 0.1) then
                                e_attack = e_attack + 1
                            end
                            if ((attr["e_" .. v.value .. "_append"] or 0) > 0.1) then
                                e_append = e_append + 1
                            end
                            if ((attr["e_" .. v.value .. "_oppose"] or 0) > 0.1) then
                                e_oppose = e_oppose + 1
                            end
                        end
                        data.e_attack = hcolor.mixed("附魔攻击", "D3B3FF") .. ":" .. e_attack .. "种"
                        data.e_append = hcolor.mixed("附魔附着", "D3B3FF") .. ":"
                        if (e_append > 0) then
                            data.e_append = data.e_append .. hcolor.red(e_append .. "种")
                        else
                            data.e_append = data.e_append .. e_append .. "种"
                        end
                        data.e_oppose = hcolor.mixed("附魔抗性", "D3B3FF") .. ":"
                        if (e_oppose > 0) then
                            data.e_oppose = data.e_oppose .. hcolor.green(e_oppose .. "种")
                        else
                            data.e_oppose = data.e_oppose .. e_oppose .. "种"
                        end
                        if (isPeriod) then
                            local pr = hunit.getPeriodRemain(selection)
                            local p = hunit.getPeriod(selection)
                            data.period_bar = bar_len * pr / p
                            data.period_val = pr .. "秒"
                        elseif (isHero) then
                            local lv = hhero.getCurLevel(selection)
                            local e = hhero.getExp(selection)
                            local en = hhero.getExpNeed(lv + 1)
                            data.exp_bar = bar_len * e / en
                            data.exp_val = "Lv" .. lv .. "   " .. math.min(e, en) .. "/" .. en
                        end
                        if (isOpenPunish) then
                            data.punish_bar = bar_len * attr.punish_current / attr.punish
                            data.punish_val = math.floor(math.max(0, attr.punish_current)) .. "/" .. math.floor(attr.punish)
                        end
                    end
                    for i, _ in ipairs(moreBtns) do
                        local s = {}
                        local maxLen = 0
                        local offsetLen = 0
                        local sIn = function(st, sColor)
                            maxLen = math.max(maxLen, string.mb_len(st))
                            if (sColor) then
                                st = hcolor.mixed(st, sColor)
                            end
                            table.insert(s, st)
                        end
                        if (i == 1) then
                            --more_x_tras
                            local xtras = attr.xtras or {}
                            if (#xtras > 0) then
                                offsetLen = -0.018
                                local xu = CONST_UBERTIP_ATTR_XTRAS(table.value(xtras, "_t"))
                                local mx = { str = {}, num = {} }
                                for _, xv in ipairs(xu) do
                                    if (mx.num[xv] == nil) then
                                        mx.num[xv] = 1
                                        table.insert(mx.str, xv)
                                    else
                                        mx.num[xv] = mx.num[xv] + 1
                                    end
                                end
                                for sti, str in ipairs(mx.str) do
                                    local color
                                    if (sti % 2 == 0) then
                                        color = "efef8f"
                                    end
                                    local split = string.mb_split(str, 32)
                                    for xvi, xvv in ipairs(split) do
                                        if (xvi == 1) then
                                            sIn(" - " .. "[" .. mx.num[str] .. "]" .. xvv, color)
                                        else
                                            sIn("     " .. xvv, color)
                                        end
                                    end
                                end
                            else
                                offsetLen = 0.03
                                sIn("无特殊效果", "c0c0c0")
                            end
                        elseif (i == 2) then
                            --more_x_oppose
                            offsetLen = 0.01
                            sIn("受伤无敌几率：" .. math.round(attr.invincible, 2) .. "%")
                            sIn("反弹伤害抵抗：" .. math.round(attr.damage_rebound_oppose, 2) .. "%")
                            sIn("攻击吸血抵抗：" .. math.round(attr.hemophagia_oppose, 2) .. "%")
                            sIn("技能吸血抵抗：" .. math.round(attr.hemophagia_skill_oppose, 2) .. "%")
                            sIn("强化阻碍：" .. math.round(attr.buff_oppose, 2) .. "%")
                            sIn("负面抵抗：" .. math.round(attr.debuff_oppose, 2) .. "%")
                            sIn("暴击抵抗：" .. math.round(attr.knocking_oppose, 2) .. "%")
                            sIn("分裂抵抗：" .. math.round(attr.split_oppose, 2) .. "%")
                            sIn("僵直抵抗：" .. math.round(attr.punish_oppose, 2) .. "%")
                            sIn("眩晕抵抗：" .. math.round(attr.swim_oppose, 2) .. "%")
                            sIn("打断抵抗：" .. math.round(attr.broken_oppose, 2) .. "%")
                            sIn("沉默抵抗：" .. math.round(attr.silent_oppose, 2) .. "%")
                            sIn("缴械抵抗：" .. math.round(attr.unarm_oppose, 2) .. "%")
                            sIn("定身抵抗：" .. math.round(attr.fetter_oppose, 2) .. "%")
                            sIn("爆破抵抗：" .. math.round(attr.bomb_oppose, 2) .. "%")
                            sIn("闪电链抵抗：" .. math.round(attr.lightning_chain_oppose, 2) .. "%")
                            sIn("击飞抵抗：" .. math.round(attr.crack_fly_oppose, 2) .. "%")
                        elseif (i == 3) then
                            --more_e_attack
                            offsetLen = -0.01
                            for _, v in ipairs(CONST_ENCHANT) do
                                sIn(v.label .. "攻击：" .. math.floor(attr["e_" .. v.value .. "_attack"]) .. "级，"
                                    .. "伤害加成：" .. math.floor(attr["e_" .. v.value]) .. "%", v.color)
                            end
                        elseif (i == 4) then
                            --more_e_append
                            offsetLen = 0.02
                            for _, v in ipairs(CONST_ENCHANT) do
                                sIn(v.label .. "附着：" .. math.floor(attr["e_" .. v.value .. "_append"]) .. "层", v.color)
                            end
                        elseif (i == 5) then
                            --more_e_oppose
                            offsetLen = 0.01
                            for _, v in ipairs(CONST_ENCHANT) do
                                sIn(v.label .. "抗性：" .. math.round(attr["e_" .. v.value .. "_oppose"], 2) .. "%", v.color)
                            end
                        end
                        local w = maxLen * 0.007 + offsetLen
                        local h = #s * 0.010 + 0.025
                        cj.SaveStr(cg.hLuaDemoHash, idx, i, string.implode("|n", s))
                        cj.SaveReal(cg.hLuaDemoHash, idx, 20 + i, w)
                        cj.SaveReal(cg.hLuaDemoHash, idx, 30 + i, h)
                    end
                end
                -- 目标数据
                if (lastTarget) then
                    if (his.dead(lastTarget) or his.deleted(lastTarget)) then
                        lastTarget = nil
                        if (selection) then
                            hevent.setLastDamage(selection, nil)
                        end
                    end
                    if (lastTarget ~= nil) then
                        local ml = math.floor(hunit.getMaxLife(lastTarget)) or 0
                        local cl = math.floor(hunit.getCurLife(lastTarget)) or 0
                        if (ml > 0 and cl > 0) then
                            local HPUnit = math.min(options.target_hp_unit, ml)
                            data.target_ava = hunit.getAvatar(lastTarget)
                            local tr = math.ceil(cl / HPUnit)
                            if (tr > 0) then
                                data.target_tl = "等级" .. cj.GetUnitLevel(lastTarget) .. " " .. hunit.getName(lastTarget) .. "      " .. cl .. "/" .. ml
                                data.target_tr = ""
                                data.target_val1 = nil
                                data.target_val2 = (tr - 1) % 10
                                if (hdzui.DEMO_UI.target_val2_prev ~= data.target_val2) then
                                    hdzui.DEMO_UI.target_val_prev = nil
                                end
                                hdzui.DEMO_UI.target_val2_prev = data.target_val2
                                if (tr > 1) then
                                    data.target_tr = "X " .. tr
                                    if (data.target_val2 == 0) then
                                        data.target_val1 = 9
                                    else
                                        data.target_val1 = data.target_val2 - 1
                                    end
                                end
                            end
                            data.target_val = (cl % HPUnit) / HPUnit
                        else
                            lastTarget = nil
                        end
                    end
                end
                if (show == false) then
                    hcache.set(enumPlayer, CONST_CACHE.PLAYER_SELECTION, nil)
                end
            end
            if (cj.GetLocalPlayer() == enumPlayer) then
                if (show == true) then
                    hdzui.frameSetText(hdzui.DEMO_UI.hp, data.hp)
                    hdzui.frameSetText(hdzui.DEMO_UI.mp, data.mp)
                    hdzui.frameSetText(hdzui.DEMO_UI.life_back, data.life_back)
                    hdzui.frameSetText(hdzui.DEMO_UI.mana_back, data.mana_back)
                    hdzui.frameSetText(hdzui.DEMO_UI.unit_name, data.unit_name)
                    hdzui.frameSetText(hdzui.DEMO_UI.hero_name, data.hero_name)
                    hdzui.frameSetText(hdzui.DEMO_UI.reborn, data.reborn)
                    hdzui.frameSetText(hdzui.DEMO_UI.attack, data.attack)
                    hdzui.frameSetText(hdzui.DEMO_UI.attack_speed, data.attack_speed)
                    hdzui.frameSetText(hdzui.DEMO_UI.attack_range, data.attack_range)
                    hdzui.frameSetText(hdzui.DEMO_UI.knocking_extent, data.knocking_extent)
                    hdzui.frameSetText(hdzui.DEMO_UI.knocking_odds, data.knocking_odds)
                    hdzui.frameSetText(hdzui.DEMO_UI.hemophagia, data.hemophagia)
                    hdzui.frameSetText(hdzui.DEMO_UI.hemophagia_skill, data.hemophagia_skill)
                    hdzui.frameSetText(hdzui.DEMO_UI.weight, data.weight)
                    hdzui.frameSetText(hdzui.DEMO_UI.move, data.move)
                    hdzui.frameSetText(hdzui.DEMO_UI.defend, data.defend)
                    hdzui.frameSetText(hdzui.DEMO_UI.damage_reduce, data.damage_reduce)
                    hdzui.frameSetText(hdzui.DEMO_UI.cure, data.cure)
                    hdzui.frameSetText(hdzui.DEMO_UI.avoid, data.avoid)
                    hdzui.frameSetText(hdzui.DEMO_UI.aim, data.aim)
                    hdzui.frameSetText(hdzui.DEMO_UI.damage_extent, data.damage_extent)
                    hdzui.frameSetText(hdzui.DEMO_UI.damage_rebound, data.damage_rebound)
                    hdzui.frameSetText(hdzui.DEMO_UI.sight_day, data.sight_day)
                    hdzui.frameSetText(hdzui.DEMO_UI.sight_night, data.sight_night)
                    if (isHero) then
                        hdzui.frameSetText(hdzui.DEMO_UI.str, data.str)
                        hdzui.frameSetText(hdzui.DEMO_UI.str_plus, data.str_plus)
                        hdzui.frameSetText(hdzui.DEMO_UI.agi, data.agi)
                        hdzui.frameSetText(hdzui.DEMO_UI.agi_plus, data.agi_plus)
                        hdzui.frameSetText(hdzui.DEMO_UI.int, data.int)
                        hdzui.frameSetText(hdzui.DEMO_UI.int_plus, data.int_plus)
                    end
                    hdzui.frameSetText(hdzui.DEMO_UI.e_attack, data.e_attack)
                    hdzui.frameSetText(hdzui.DEMO_UI.e_append, data.e_append)
                    hdzui.frameSetText(hdzui.DEMO_UI.e_oppose, data.e_oppose)
                    if (isPeriod) then
                        hdzui.frameSetText(hdzui.DEMO_UI.period_val, hcolor.mixed(data.period_val, "26BD08"))
                        if (data.period_bar > 0) then
                            hdzui.frameSize(hdzui.DEMO_UI.bar_period, data.period_bar, 0.002)
                        else
                            isBarPeriod = false
                        end
                    elseif (isHero) then
                        hdzui.frameSetText(hdzui.DEMO_UI.exp_val, hcolor.mixed(data.exp_val, "78B5E4"))
                        if (data.exp_bar > 0) then
                            hdzui.frameSize(hdzui.DEMO_UI.bar_exp, data.exp_bar, 0.002)
                        else
                            isBarExp = false
                        end
                    end
                    if (isOpenPunish) then
                        if (his.punish(selection)) then
                            hdzui.frameSetText(hdzui.DEMO_UI.punish, hcolor.red("僵住"))
                            hdzui.frameSetText(hdzui.DEMO_UI.punish_val, hcolor.red(data.punish_val))
                        else
                            hdzui.frameSetText(hdzui.DEMO_UI.punish, hcolor.mixed("硬直", "FFFF00"))
                            hdzui.frameSetText(hdzui.DEMO_UI.punish_val, hcolor.mixed(data.punish_val, "FFFF00"))
                        end
                        if (data.punish_bar > 0) then
                            hdzui.frameSize(hdzui.DEMO_UI.bar_punish, data.punish_bar, 0.002)
                        else
                            isBarPunish = false
                        end
                    end
                end
                for i, f in ipairs(hdzui.DEMO_UI.itemSlotBlock) do
                    hjapi.DzFrameShow(f, not (show and (cj.UnitItemInSlot(selection, i - 1) ~= nil)))
                end
                for _, f in ipairs(hdzui.DEMO_UI.skillSlotBlock) do
                    hjapi.DzFrameShow(f, not show)
                end
                hjapi.DzFrameShow(hdzui.DEMO_UI.hp, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.mp, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.life_back, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.mana_back, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.info_attr, show and (isHero == false))
                hjapi.DzFrameShow(hdzui.DEMO_UI.info_attr_hero, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sign_str, show and isHero and isStr)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sign_agi, show and isHero and isAgi)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sign_int, show and isHero and isInt)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sign_nor, show and (isHero == false))
                hjapi.DzFrameShow(hdzui.DEMO_UI.unit_name, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.hero_name, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.reborn, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.attack, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.attack_speed, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.attack_range, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.knocking_extent, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.knocking_odds, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.hemophagia, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.hemophagia_skill, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.weight, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.move, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.defend, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.damage_reduce, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.cure, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.avoid, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.aim, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.damage_extent, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.damage_rebound, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sight_day, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.sight_night, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.str, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.str_plus, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.agi, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.agi_plus, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.int, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.int_plus, show and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.e_attack, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.e_append, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.e_oppose, show)
                hjapi.DzFrameShow(hdzui.DEMO_UI.period, show and isPeriod)
                hjapi.DzFrameShow(hdzui.DEMO_UI.period_val, show and isPeriod)
                hjapi.DzFrameShow(hdzui.DEMO_UI.exp, show and (not isPeriod) and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.exp_val, show and (not isPeriod) and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.exp_ratio, show and (not isPeriod) and isHero)
                hjapi.DzFrameShow(hdzui.DEMO_UI.punish, show and isOpenPunish)
                hjapi.DzFrameShow(hdzui.DEMO_UI.punish_val, show and isOpenPunish)
                hjapi.DzFrameShow(hdzui.DEMO_UI.bar_e1, show and isBarE1)
                hjapi.DzFrameShow(hdzui.DEMO_UI.bar_e2, show and isBarE2)
                hjapi.DzFrameShow(hdzui.DEMO_UI.bar_period, show and isBarPeriod)
                hjapi.DzFrameShow(hdzui.DEMO_UI.bar_exp, show and (not isPeriod) and isBarExp)
                hjapi.DzFrameShow(hdzui.DEMO_UI.bar_punish, show and isBarPunish)
                if (lastTarget ~= nil) then
                    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.target_ava, data.target_ava)
                    hdzui.frameSetText(hdzui.DEMO_UI.target_tl, data.target_tl)
                    hdzui.frameSetText(hdzui.DEMO_UI.target_tr, data.target_tr)
                    local cur = data.target_val * 0.2126
                    local next = cur
                    local step = 0.2126 / 10
                    if (hdzui.DEMO_UI.target_val_prev ~= nil) then
                        if (cur < hdzui.DEMO_UI.target_val_prev and (hdzui.DEMO_UI.target_val_prev - cur) > step) then
                            next = hdzui.DEMO_UI.target_val_prev - step
                        elseif (cur > hdzui.DEMO_UI.target_val_prev and (cur - hdzui.DEMO_UI.target_val_prev) > step) then
                            next = hdzui.DEMO_UI.target_val_prev + step
                        end
                    end
                    hdzui.DEMO_UI.target_val_prev = next
                    hdzui.frameSize(hdzui.DEMO_UI.target_val2, next, 0.022)
                    hjapi.DzFrameSetAlpha(hdzui.DEMO_UI.target_val2, 400 * next / 0.2126)
                    if (data.target_val1 ~= nil) then
                        hjapi.DzFrameSetTexture(hdzui.DEMO_UI.target_val1, "ReplaceableTextures\\TeamColor\\TeamColor0" .. data.target_val1 .. ".blp")
                    end
                    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.target_val2, "ReplaceableTextures\\TeamColor\\TeamColor0" .. data.target_val2 .. ".blp")
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target, true)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_ava, true)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_tl, true)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_tr, true)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_val1, data.target_val1 ~= nil)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_val2, true)
                else
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target, false)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_ava, false)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_tl, false)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_tr, false)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_val1, false)
                    hjapi.DzFrameShow(hdzui.DEMO_UI.target_val2, false)
                end
                local btns = { "btn_more_x_tras", "btn_more_x_oppose", "btn_more_e_attack", "btn_more_e_append", "btn_more_e_oppose" }
                for _, bk in ipairs(btns) do
                    hjapi.DzFrameShow(hdzui.DEMO_UI[bk], show)
                end
            end
        end)
    end
    -- 黄金
    hdzui.DEMO_UI.gold = hdzui.frameTag("TEXT", "txt_10l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.gold, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT_TOP, px.resource.x + 0.014, px.resource.y - 0.0055)
    hdzui.frameSize(hdzui.DEMO_UI.gold, 0.05, 0.02)
    -- 黄金率
    hdzui.DEMO_UI.gold_ratio = hdzui.frameTag("TEXT", "txt_8l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.gold_ratio, hdzui.DEMO_UI.gold, FRAME_ALIGN_LEFT, FRAME_ALIGN_RIGHT, 0, 0)
    hdzui.frameSize(hdzui.DEMO_UI.gold_ratio, 0.08, 0.02)
    -- 木头
    hdzui.DEMO_UI.lumber = hdzui.frameTag("TEXT", "txt_10l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.lumber, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT_TOP, px.resource.x + 0.096, px.resource.y - 0.0055)
    hdzui.frameSize(hdzui.DEMO_UI.lumber, 0.05, 0.02)
    -- 木头率
    hdzui.DEMO_UI.lumber_ratio = hdzui.frameTag("TEXT", "txt_8l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.lumber_ratio, hdzui.DEMO_UI.lumber, FRAME_ALIGN_LEFT, FRAME_ALIGN_RIGHT, 0, 0)
    -- 售卖率
    hdzui.DEMO_UI.sell_ratio = hdzui.frameTag("TEXT", "txt_8l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.sell_ratio, hdzui.DEMO_UI.main, FRAME_ALIGN_CENTER, FRAME_ALIGN_LEFT_TOP, px.sell.x + 0.033, px.sell.y - 0.006)
    -- 生命
    hdzui.DEMO_UI.hp = hdzui.frameTag("TEXT", "txt_8l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.hp, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT_TOP, px.hp.x, px.hp.y - 0.0037)
    hdzui.frameSize(hdzui.DEMO_UI.hp, px.hp.w * 0.7, px.hp.h)
    -- 魔法
    hdzui.DEMO_UI.mp = hdzui.frameTag("TEXT", "txt_8l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.mp, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT_TOP, px.mp.x, px.mp.y - 0.0037)
    hdzui.frameSize(hdzui.DEMO_UI.mp, px.hp.w * 0.7, px.hp.h)
    -- 生命恢复
    hdzui.DEMO_UI.life_back = hdzui.frameTag("TEXT", "txt_8r", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.life_back, hdzui.DEMO_UI.main, FRAME_ALIGN_CENTER, FRAME_ALIGN_LEFT_TOP, px.hp.x + 0.055, px.hp.y - 0.0037)
    hdzui.frameSize(hdzui.DEMO_UI.life_back, px.hp.w * 0.3, px.hp.h)
    -- 魔法恢复
    hdzui.DEMO_UI.mana_back = hdzui.frameTag("TEXT", "txt_8r", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.mana_back, hdzui.DEMO_UI.main, FRAME_ALIGN_CENTER, FRAME_ALIGN_LEFT_TOP, px.mp.x + 0.055, px.mp.y - 0.0037)
    hdzui.frameSize(hdzui.DEMO_UI.mana_back, px.hp.w * 0.3, px.hp.h)
    -- 信息面板
    hdzui.DEMO_UI.info_attr = hdzui.frame("bg_info_attr", hdzui.DEMO_UI.main)
    hdzui.frameSize(hdzui.DEMO_UI.info_attr, px.info.w, px.info.h)
    hdzui.framePoint(hdzui.DEMO_UI.info_attr, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.info.x, px.info.y)
    hdzui.DEMO_UI.info_attr_hero = hdzui.frame("bg_info_attr_hero", hdzui.DEMO_UI.main)
    hdzui.frameSize(hdzui.DEMO_UI.info_attr_hero, px.info.w, px.info.h)
    hdzui.framePoint(hdzui.DEMO_UI.info_attr_hero, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.info.x, px.info.y)
    -- 单位标志
    hdzui.DEMO_UI.sign_str = hdzui.frame("bg_sign_str", hdzui.DEMO_UI.main)
    hdzui.DEMO_UI.sign_agi = hdzui.frame("bg_sign_agi", hdzui.DEMO_UI.main)
    hdzui.DEMO_UI.sign_int = hdzui.frame("bg_sign_int", hdzui.DEMO_UI.main)
    hdzui.DEMO_UI.sign_nor = hdzui.frame("bg_sign_nor", hdzui.DEMO_UI.main)
    hdzui.frameSize(hdzui.DEMO_UI.sign_str, 0.014, 0.018)
    hdzui.frameSize(hdzui.DEMO_UI.sign_agi, 0.014, 0.018)
    hdzui.frameSize(hdzui.DEMO_UI.sign_int, 0.014, 0.018)
    hdzui.frameSize(hdzui.DEMO_UI.sign_nor, 0.014, 0.018)
    hdzui.framePoint(hdzui.DEMO_UI.sign_str, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, px.info.x + 0.0035, px.info.y - 0.006)
    hdzui.framePoint(hdzui.DEMO_UI.sign_agi, hdzui.DEMO_UI.sign_str, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
    hdzui.framePoint(hdzui.DEMO_UI.sign_int, hdzui.DEMO_UI.sign_str, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
    hdzui.framePoint(hdzui.DEMO_UI.sign_nor, hdzui.DEMO_UI.sign_str, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
    -- 单位名称
    hdzui.DEMO_UI.unit_name = hdzui.frameTag("TEXT", "txt_10l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.unit_name, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT_TOP, px.info.x + 0.018, px.info.y - 0.01)
    -- 英雄名称
    hdzui.DEMO_UI.hero_name = hdzui.frameTag("TEXT", "txt_10l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.hero_name, hdzui.DEMO_UI.unit_name, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_RIGHT_TOP, 0, 0)
    -- 条:存在周期[字]
    hdzui.DEMO_UI.period = hdzui.frameTag("TEXT", "txt_76r", hdzui.DEMO_UI.main)
    hdzui.frameSetText(hdzui.DEMO_UI.period, hcolor.mixed("存在", "26BD08"))
    hdzui.framePoint(hdzui.DEMO_UI.period, hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_TOP, -0.024, -0.048)
    -- 条:存在周期[值]
    hdzui.DEMO_UI.period_val = hdzui.frameTag("TEXT", "txt_6l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.period_val, hdzui.DEMO_UI.period, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_RIGHT_TOP, 0.002, 0.002)
    -- 条:经验[字]
    hdzui.DEMO_UI.exp = hdzui.frameTag("TEXT", "txt_76r", hdzui.DEMO_UI.main)
    hdzui.frameSetText(hdzui.DEMO_UI.exp, hcolor.mixed("经验", "78B5E4"))
    hdzui.framePoint(hdzui.DEMO_UI.exp, hdzui.DEMO_UI.period, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, 0, 0)
    -- 条:经验[值]
    hdzui.DEMO_UI.exp_val = hdzui.frameTag("TEXT", "txt_6l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.exp_val, hdzui.DEMO_UI.exp, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_RIGHT_TOP, 0.002, 0.002)
    -- 条:硬直[字]
    hdzui.DEMO_UI.punish = hdzui.frameTag("TEXT", "txt_76r", hdzui.DEMO_UI.main)
    hdzui.frameSetText(hdzui.DEMO_UI.punish, hcolor.mixed("硬直", "FFFF00"))
    hdzui.framePoint(hdzui.DEMO_UI.punish, hdzui.DEMO_UI.exp, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_TOP, 0, -0.012)
    -- 条:硬直[值]
    hdzui.DEMO_UI.punish_val = hdzui.frameTag("TEXT", "txt_6l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.punish_val, hdzui.DEMO_UI.punish, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_RIGHT_TOP, 0.002, 0.002)
    -- 条:空1
    hdzui.DEMO_UI.bar_e1 = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.main)
    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.bar_e1, "ReplaceableTextures\\TeamColor\\TeamColor08.blp", false)
    hdzui.frameSize(hdzui.DEMO_UI.bar_e1, bar_len, 0.002)
    hdzui.framePoint(hdzui.DEMO_UI.bar_e1, hdzui.DEMO_UI.period, FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_RIGHT_BOTTOM, 0.002, 0)
    -- 条:空2
    hdzui.DEMO_UI.bar_e2 = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.main)
    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.bar_e2, "ReplaceableTextures\\TeamColor\\TeamColor08.blp", false)
    hdzui.frameSize(hdzui.DEMO_UI.bar_e2, bar_len, 0.002)
    hdzui.framePoint(hdzui.DEMO_UI.bar_e2, hdzui.DEMO_UI.punish, FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_RIGHT_BOTTOM, 0.002, 0)
    -- 条:存在周期
    hdzui.DEMO_UI.bar_period = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.main)
    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.bar_period, "ReplaceableTextures\\TeamColor\\TeamColor06.blp", false)
    hdzui.frameSize(hdzui.DEMO_UI.bar_period, bar_len, 0.002)
    hdzui.framePoint(hdzui.DEMO_UI.bar_period, hdzui.DEMO_UI.bar_e1, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0, 0)
    -- 条:经验
    hdzui.DEMO_UI.bar_exp = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.main)
    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.bar_exp, "ReplaceableTextures\\TeamColor\\TeamColor09.blp", false)
    hdzui.frameSize(hdzui.DEMO_UI.bar_exp, bar_len, 0.002)
    hdzui.framePoint(hdzui.DEMO_UI.bar_exp, hdzui.DEMO_UI.bar_e1, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0, 0)
    -- 条:经验率
    hdzui.DEMO_UI.exp_ratio = hdzui.frameTag("TEXT", "txt_6l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.exp_ratio, hdzui.DEMO_UI.bar_e1, FRAME_ALIGN_RIGHT_BOTTOM, FRAME_ALIGN_RIGHT_TOP, 0, 0.002)
    -- 条:硬直
    hdzui.DEMO_UI.bar_punish = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.main)
    hjapi.DzFrameSetTexture(hdzui.DEMO_UI.bar_punish, "ReplaceableTextures\\TeamColor\\TeamColor04.blp", false)
    hdzui.frameSize(hdzui.DEMO_UI.bar_punish, bar_len, 0.002)
    hdzui.framePoint(hdzui.DEMO_UI.bar_punish, hdzui.DEMO_UI.bar_e2, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0, 0)
    -- 属性:复活
    hdzui.DEMO_UI.reborn = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.reborn, hdzui.DEMO_UI.unit_name, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, -0.004)
    local attr_y = -0.005
    -- 属性:攻击
    hdzui.DEMO_UI.attack = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.attack, hdzui.DEMO_UI.reborn, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:攻击速度
    hdzui.DEMO_UI.attack_speed = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.attack_speed, hdzui.DEMO_UI.attack, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:攻击范围
    hdzui.DEMO_UI.attack_range = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.attack_range, hdzui.DEMO_UI.attack_speed, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:暴击加成
    hdzui.DEMO_UI.knocking_extent = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.knocking_extent, hdzui.DEMO_UI.attack_range, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:暴击几率
    hdzui.DEMO_UI.knocking_odds = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.knocking_odds, hdzui.DEMO_UI.knocking_extent, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:攻击吸血
    hdzui.DEMO_UI.hemophagia = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.hemophagia, hdzui.DEMO_UI.knocking_odds, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:技能吸血
    hdzui.DEMO_UI.hemophagia_skill = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.hemophagia_skill, hdzui.DEMO_UI.hemophagia, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:负重
    hdzui.DEMO_UI.weight = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.weight, hdzui.DEMO_UI.hemophagia_skill, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:移动
    hdzui.DEMO_UI.move = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.move, hdzui.DEMO_UI.weight, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:护甲
    hdzui.DEMO_UI.defend = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.defend, hdzui.DEMO_UI.reborn, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0.062, attr_y)
    -- 属性:减伤
    hdzui.DEMO_UI.damage_reduce = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.damage_reduce, hdzui.DEMO_UI.defend, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:治疗
    hdzui.DEMO_UI.cure = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.cure, hdzui.DEMO_UI.damage_reduce, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:回避
    hdzui.DEMO_UI.avoid = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.avoid, hdzui.DEMO_UI.cure, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:命中
    hdzui.DEMO_UI.aim = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.aim, hdzui.DEMO_UI.avoid, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:增伤
    hdzui.DEMO_UI.damage_extent = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.damage_extent, hdzui.DEMO_UI.aim, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:反伤
    hdzui.DEMO_UI.damage_rebound = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.damage_rebound, hdzui.DEMO_UI.damage_extent, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:白天视野
    hdzui.DEMO_UI.sight_day = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.sight_day, hdzui.DEMO_UI.damage_rebound, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:夜晚视野
    hdzui.DEMO_UI.sight_night = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.sight_night, hdzui.DEMO_UI.sight_day, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:力量
    hdzui.DEMO_UI.str = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.str, hdzui.DEMO_UI.reborn, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0.120, attr_y)
    -- 属性:力量成长
    hdzui.DEMO_UI.str_plus = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.str_plus, hdzui.DEMO_UI.str, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:敏捷
    hdzui.DEMO_UI.agi = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.agi, hdzui.DEMO_UI.str_plus, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:敏捷成长
    hdzui.DEMO_UI.agi_plus = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.agi_plus, hdzui.DEMO_UI.agi, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:智力
    hdzui.DEMO_UI.int = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.int, hdzui.DEMO_UI.agi_plus, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, attr_y)
    -- 属性:智力成长
    hdzui.DEMO_UI.int_plus = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.int_plus, hdzui.DEMO_UI.int, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:附魔攻击
    hdzui.DEMO_UI.e_attack = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.e_attack, hdzui.DEMO_UI.reborn, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0.120, -0.064)
    -- 属性:附魔附着
    hdzui.DEMO_UI.e_append = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.e_append, hdzui.DEMO_UI.e_attack, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 属性:附魔抗性
    hdzui.DEMO_UI.e_oppose = hdzui.frameTag("TEXT", "txt_76l", hdzui.DEMO_UI.main)
    hdzui.framePoint(hdzui.DEMO_UI.e_oppose, hdzui.DEMO_UI.e_append, FRAME_ALIGN_LEFT_TOP, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
    -- 上方目标血条
    hdzui.DEMO_UI.target = hdzui.frameTag("BACKDROP", "bg_bar_target", hdzui.DEMO_UI.game)
    hdzui.frameSize(hdzui.DEMO_UI.target, 0.24, 0.03)
    hdzui.framePoint(hdzui.DEMO_UI.target, hdzui.DEMO_UI.game, FRAME_ALIGN_CENTER, FRAME_ALIGN_TOP, 0, -0.04)
    hdzui.DEMO_UI.target_ava = hdzui.frameTag("BACKDROP", "bg_bar_avatar", hdzui.DEMO_UI.game)
    hdzui.frameSize(hdzui.DEMO_UI.target_ava, 0.02, 0.023)
    hdzui.framePoint(hdzui.DEMO_UI.target_ava, hdzui.DEMO_UI.target, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0.002, 0)
    hdzui.DEMO_UI.target_val1 = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.target)
    hdzui.frameSize(hdzui.DEMO_UI.target_val1, 0.2126, 0.022)
    hdzui.framePoint(hdzui.DEMO_UI.target_val1, hdzui.DEMO_UI.target, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0.0236, 0)
    hdzui.DEMO_UI.target_val2 = hdzui.frameTag("BACKDROP", "bg_bar", hdzui.DEMO_UI.target)
    hdzui.frameSize(hdzui.DEMO_UI.target_val2, 0.2126, 0.022)
    hdzui.framePoint(hdzui.DEMO_UI.target_val2, hdzui.DEMO_UI.target, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0.0236, 0)
    hdzui.DEMO_UI.target_tl = hdzui.frameTag("TEXT", "txt_12l", hdzui.DEMO_UI.game)
    hdzui.framePoint(hdzui.DEMO_UI.target_tl, hdzui.DEMO_UI.target, FRAME_ALIGN_LEFT, FRAME_ALIGN_LEFT, 0.025, 0)
    hdzui.DEMO_UI.target_tr = hdzui.frameTag("TEXT", "txt_12r", hdzui.DEMO_UI.game)
    hdzui.framePoint(hdzui.DEMO_UI.target_tr, hdzui.DEMO_UI.target, FRAME_ALIGN_RIGHT, FRAME_ALIGN_RIGHT, -0.006, 0)
    -- 按钮
    hdzui.DEMO_UI.more_tip = hdzui.frameTag("BACKDROP", "bg_tooltip", hdzui.origin.game())
    hdzui.framePoint(hdzui.DEMO_UI.more_tip, hdzui.origin.game(), FRAME_ALIGN_LEFT_BOTTOM, FRAME_ALIGN_BOTTOM, 0.088, 0.002)
    hdzui.frameSize(hdzui.DEMO_UI.more_tip, 0.1, 0.1)
    hdzui.frameToggle(hdzui.DEMO_UI.more_tip, false)
    hdzui.DEMO_UI.more_txt = hdzui.frameTag("TEXT", "txt_10l", hdzui.origin.game())
    hdzui.framePoint(hdzui.DEMO_UI.more_txt, hdzui.DEMO_UI.more_tip, FRAME_ALIGN_CENTER, FRAME_ALIGN_CENTER, 0, 0)
    hdzui.frameToggle(hdzui.DEMO_UI.more_txt, false)
    cg.hLuaDemoMoreTip = hdzui.DEMO_UI.more_tip
    cg.hLuaDemoMoreTxt = hdzui.DEMO_UI.more_txt
    for i, b in ipairs(moreBtns) do
        local bk = "btn_" .. b
        hdzui.DEMO_UI[bk] = hdzui.frameTag("BUTTON", bk, hdzui.origin.game())
        hdzui.framePoint(hdzui.DEMO_UI[bk], hdzui.DEMO_UI.main, FRAME_ALIGN_LEFT, FRAME_ALIGN_CENTER, 0.074, -(i - 1) * 0.015)
        hdzui.frameSize(hdzui.DEMO_UI[bk], 0.010, 0.012)
        hplayer.forEach(function(enumPlayer, idx)
            cj.SaveInteger(cg.hLuaDemoHash, hdzui.DEMO_UI[bk], idx, i)
            hdzui.onMouse(hdzui.DEMO_UI[bk], MOUSE_ORDER_ENTER, enumPlayer, "hLuaDemoMoreEnter")
            hdzui.onMouse(hdzui.DEMO_UI[bk], MOUSE_ORDER_LEAVE, enumPlayer, "hLuaDemoMoreLeave")
        end)
    end
    -- UI展示
    hdzui.DEMO_UI.update()
    hdzui.DEMO_UI.updateTimer = htime.setInterval(0.1, function(_)
        hdzui.DEMO_UI.update()
    end)
end