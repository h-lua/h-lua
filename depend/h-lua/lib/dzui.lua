---@class dzui DzUI
---@deprecated

hdzui = { _t = 0 }

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
    hjapi.DzLoadToc(tocFilePath)
end

--- 获取游戏UI(一个整数)
---@return number integer
hdzui.gameUI = function()
    return hjapi.DzGetGameUI()
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
    parent = parent or hdzui.gameUI()
    id = id or 0
    return hjapi.DzCreateFrame(fdfName, parent, id)
end

--- tag方式新建一个frame
---@param fdfType string frame类型 TEXT | BACKDROP等
---@param fdfName string frame名称
---@param parent number 父节点ID(def:GameUI)
---@param tag string 自定义tag名称(def:_t)
---@param id number integer(def:0)
---@return number|nil
hdzui.frameTag = function(fdfType, fdfName, parent, tag, id)
    if (fdfType == nil or fdfName == nil) then
        return
    end
    hdzui._t = hdzui._t + 1
    tag = tag or "uit-" .. hdzui._t
    parent = parent or hdzui.gameUI()
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
    relation = relation or hdzui.gameUI()
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
