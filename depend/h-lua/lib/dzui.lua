---@class dzui DzUI
hdzui = { _t = 0 }

--- 启用宽屏
hdzui.wideScreen = function()
    cj.ExecuteFunc("hdzui_wideScreen")
end

--- 隐藏所有原生界面
hdzui.hideInterface = function()
    cj.ExecuteFunc("hdzui_hideInterface")
end

--- 加载toc文件
---@param tocFilePath string
hdzui.loadToc = function(tocFilePath)
    cg.hdzui_loadTocFile = tocFilePath
    cj.ExecuteFunc("hdzui_loadToc")
end

--- 获取游戏UI(一个整数)
---@return number
hdzui.gameUI = function()
    return cg.hdzui_frame_gameUI
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
    cg.hdzui_frame_creator_name = fdfName
    cg.hdzui_frame_creator_parent = parent or hdzui.gameUI()
    cg.hdzui_frame_creator_id = id or 0
    cj.ExecuteFunc("hdzui_frameCreate")
    return cg.hdzui_frame_creator
end

--- tag方式新建一个frame
---@param fdfType string frame类型 TEXT | BACKDROP等
---@param fdfName string frame名称
---@param parent number 父节点ID(def:GameUI)
---@param id number ID(def:0)
---@param tag string 自定义tag名称(def:_t)
---@return number|nil
hdzui.frameTag = function(fdfType, fdfName, parent, id, tag)
    if (fdfType == nil or fdfName == nil) then
        return
    end
    hdzui._t = hdzui._t + 1
    cg.hdzui_frame_creator_type = fdfType
    cg.hdzui_frame_creator_tag = tag or tostring(hdzui._t)
    cg.hdzui_frame_creator_parent = parent or hdzui.gameUI()
    cg.hdzui_frame_creator_name = fdfName
    cg.hdzui_frame_creator_id = id or 0
    cj.ExecuteFunc("hdzui_frameCreateTag")
    return cg.hdzui_frame_creator
end

--- 设置frame相对锚点
---@param frameId number
---@param relation number 相对节点ID(def:GameUI)
---@param align number
---@param alignRelation number 以 align-> alignParent 对齐
---@param x number 锚点X
---@param y number 锚点Y
hdzui.framePoint = function(frameId, relation, align, alignRelation, x, y)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_relation = relation or hdzui.gameUI()
    cg.hdzui_frame_align = align or CONST_DZUI_ALIGN.CENTER
    cg.hdzui_frame_alignRelation = alignRelation or CONST_DZUI_ALIGN.CENTER
    cg.hdzui_frame_x = x or 0
    cg.hdzui_frame_y = y or 0
    cj.ExecuteFunc("hdzui_framePoint")
end

--- 设置frame绝对锚点
---@param frameId number
---@param align number
---@param x number 锚点X
---@param y number 锚点Y
hdzui.frameAbsolutePoint = function(frameId, align, x, y)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_align = align or CONST_DZUI_ALIGN.CENTER
    cg.hdzui_frame_x = x or 0
    cg.hdzui_frame_y = y or 0
    cj.ExecuteFunc("hdzui_frameAbsolutePoint")
end

--- 设置frame尺寸
---@param frameId number
---@param width number 宽
---@param height number 高
hdzui.frameSize = function(frameId, width, height)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_width = width or 0.1
    cg.hdzui_frame_height = height or 0.1
    cj.ExecuteFunc("hdzui_frameSize")
end

--- 设置frame贴图
---@param frameId number
---@param blp string 贴图路径
hdzui.frameTexture = function(frameId, blp)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_texture = blp or ""
    cj.ExecuteFunc("hdzui_frameTexture")
end

--- 锁定鼠标在frame内
---@param frameId number
---@param cage boolean
hdzui.frameCageMouse = function(frameId, cage)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_cage = cage or false
    cj.ExecuteFunc("hdzui_frameCageMouse")
end

--- 启用frame
---@param frameId number
hdzui.frameEnable = function(frameId)
    cg.hdzui_frame_id = frameId
    cj.ExecuteFunc("hdzui_frameEnable")
end

--- 禁用frame
---@param frameId number
hdzui.frameDisable = function(frameId)
    cg.hdzui_frame_id = frameId
    cj.ExecuteFunc("hdzui_frameDisable")
end

--- frame是否启用
---@param frameId number
hdzui.frameIsEnable = function(frameId)
    cg.hdzui_frame_id = frameId
    cj.ExecuteFunc("hdzui_frameIsEnable")
    return cg.hdzui_frame_enable or false
end

--- 显示frame
---@param frameId number
---@param playerIndex userdata 只给某位玩家(索引)
hdzui.frameShow = function(frameId, playerIndex)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_player = playerIndex or 0
    cj.ExecuteFunc("hdzui_frameShow")
end

--- 隐藏frame
---@param frameId number
---@param playerIndex userdata 只给某位玩家(索引)
hdzui.frameHide = function(frameId, playerIndex)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_player = playerIndex or 0
    cj.ExecuteFunc("hdzui_frameHide")
end

--- 设置frame文本内容
---@param frameId number
---@param txt string 内容
hdzui.frameSetText = function(frameId, txt)
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_txt = tostring(txt)
    cj.ExecuteFunc("hdzui_frameSetText")
end

--- 注册鼠标事件
---@param frameId number
---@param event string | "'click'" | "'double_click'" | "'release'" | "'enter'" | "'leave'" | "'scroll'"
---@param playerIndex number 玩家索引
---@param vjFunctionName string VJ函数名，可读取项目下的 vj/function.jass的函数
hdzui.onMouse = function(frameId, event, playerIndex, vjFunctionName)
    local order = CONST_DZUI_MOUSE_ORDER[string.upper(event)]
    if (order == nil) then
        return
    end
    cg.hdzui_frame_id = frameId
    cg.hdzui_frame_player = playerIndex
    cg.hdzui_frame_order = order
    cg.hdzui_frame_vj = vjFunctionName
    cj.ExecuteFunc("hdzui_onMouse")
end
