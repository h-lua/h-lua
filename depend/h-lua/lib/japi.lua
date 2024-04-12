---@class hjapi JAPI
hjapi = {
    _lib = nil,
    _tips = {},
}

---@type table<string,any>
hjapi._cache = hjapi._cache or {
    ["DzLoadToc"] = {},
    ["Z"] = {},
    ["FrameTagIndex"] = 0,
    ["IsWideScreen"] = false,
    ["FrameBlackTop"] = 0.020,
    ["FrameBlackBottom"] = 0.130,
    ["FrameInnerHeight"] = 0.45,
}

---@private
function hjapi.echo(msg)
    if (hjapi._tips[msg] == nil) then
        hjapi._tips[msg] = 1
        if (DEBUGGING) then
            print("<JAPI> " .. msg)
        else
            echo("<JAPI> " .. msg)
        end
    end
end

---@private
---@param method string
---@return boolean
function hjapi.has(method)
    if (type(method) ~= 'string') then
        return false
    end
    if (type(JassJapi[method]) == "function") then
        return true
    end
    return false
end

---@private
---@param method string
---@vararg any
---@return any
function hjapi.exec(method, ...)
    if (type(method) ~= 'string') then
        return false
    end
    if (type(JassJapi[method]) ~= "function") then
        hjapi.echo(method .. " function does not exist!")
        return false
    end
    return JassJapi[method](...)
end

------------------------------------------------------------------------------------------------------------------------

function hjapi.DzAPI_Map_ChangeStoreItemCoolDown(...)
    return hjapi.exec("DzAPI_Map_ChangeStoreItemCoolDown", ...)
end

function hjapi.DzAPI_Map_ChangeStoreItemCount(...)
    return hjapi.exec("DzAPI_Map_ChangeStoreItemCount", ...)
end

---@return string
function hjapi.DzAPI_Map_GetActivityData()
    return hjapi.exec("DzAPI_Map_GetActivityData", nil)
end

--- 获取当前游戏时间
--- 获取创建地图的游戏时间
--- 时间换算为时间戳
---@return number
function hjapi.DzAPI_Map_GetGameStartTime()
    return hjapi.exec("DzAPI_Map_GetGameStartTime", nil)
end

--- 获取公会名称
---@param whichPlayer userdata
---@return string
function hjapi.DzAPI_Map_GetGuildName(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetGuildName", whichPlayer)
end

--- 获取公会职责
--- 获取公会职责 Member=10 Admin=20 Leader=30
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetGuildRole(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetGuildRole", whichPlayer)
end

--- 获取天梯等级
--- 取值1~25，青铜V是1级
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetLadderLevel(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetLadderLevel", whichPlayer)
end

--- 获取天梯排名
--- 排名>1000的获取值为0
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetLadderRank(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetLadderRank", whichPlayer)
end

--- 获取全局服务器存档值
---@param key string
---@return number
function hjapi.DzAPI_Map_GetMapConfig(key)
    return hjapi.exec("DzAPI_Map_GetMapConfig", key)
end

--- 获取玩家地图等级
--- 获取玩家地图等级【RPG大厅限定】
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetMapLevel(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetMapLevel", whichPlayer)
end

--- 获取玩家地图等级排名
--- 排名>100的获取值为0
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetMapLevelRank(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetMapLevelRank", whichPlayer)
end

--- 获取天梯和匹配的模式
--- 返回数值与作者之家设置对应
function hjapi.DzAPI_Map_GetMatchType()
    return hjapi.exec("DzAPI_Map_GetMatchType", nil)
end

--- 获取玩家平台VIP标志
---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetPlatformVIP(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetPlatformVIP", whichPlayer)
end

--- 读取公共服务器存档组数据
--- 服务器存档组有100个KEY，每个KEY64个字符长度，可以多张地图读取和保存，使用前先在作者之家服务器存档组设置
---@param whichPlayer userdata
---@param key string
---@return string
function hjapi.DzAPI_Map_GetPublicArchive(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetPublicArchive", whichPlayer, key)
end

--- 读取服务器Boss掉落装备类型
---@param whichPlayer userdata
---@param key string
---@return string
function hjapi.DzAPI_Map_GetServerArchiveDrop(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerArchiveDrop", whichPlayer, key)
end

---@param whichPlayer userdata
---@param key string
---@return number
function hjapi.DzAPI_Map_GetServerArchiveEquip(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerArchiveEquip", whichPlayer, key)
end

---@param whichPlayer userdata
---@param key string
---@return string
function hjapi.DzAPI_Map_GetServerValue(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_GetServerValue", whichPlayer, key)
end

---@param whichPlayer userdata
---@return number
function hjapi.DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    return hjapi.exec("DzAPI_Map_GetServerValueErrorCode", whichPlayer)
end

--- 读取玩家服务器存档成功
--- 如果返回false代表读取失败,反之成功,之后游戏里平台不会再发送“服务器保存失败”的信息，所以希望地图作者在游戏开始给玩家发下信息服务器存档是否正确读取。
---@param whichPlayer userdata
---@return boolean
function hjapi.GetPlayerServerValueSuccess(whichPlayer)
    local res = hjapi.DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    if (type(res) == "number") then
        return math.floor(res) == 0
    end
    return false
end

function hjapi.DzAPI_Map_GetUserID(...)
    return hjapi.exec("DzAPI_Map_GetUserID", ...)
end

--- 玩家是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer userdata
---@param key string
---@return boolean
function hjapi.DzAPI_Map_HasMallItem(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_HasMallItem", whichPlayer, key)
end

--- 判断是否是蓝V
---@param whichPlayer userdata
---@return boolean
function hjapi.DzAPI_Map_IsBlueVIP(whichPlayer)
    return hjapi.exec("DzAPI_Map_IsBlueVIP", whichPlayer)
end

--- 判断地图是否在RPG天梯
---@return boolean
function hjapi.DzAPI_Map_IsRPGLadder()
    return hjapi.exec("DzAPI_Map_IsRPGLadder", nil)
end

--- 判断当前地图是否rpg大厅来的
---@return boolean
function hjapi.DzAPI_Map_IsRPGLobby()
    return hjapi.exec("DzAPI_Map_IsRPGLobby", nil)
end

--- 判断是否是红V
---@param whichPlayer userdata
---@return boolean
function hjapi.DzAPI_Map_IsRedVIP(whichPlayer)
    return hjapi.exec("DzAPI_Map_IsRedVIP", whichPlayer)
end

---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Ladder_SetPlayerStat", whichPlayer, key, value)
end

--- 天梯提交玩家排名
---@param whichPlayer userdata
---@param value number
function hjapi.DzAPI_Map_Ladder_SubmitPlayerRank(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

--- 天梯提交字符串数据
---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Ladder_SetStat", whichPlayer, key, value)
end

--- 天梯提交获得称号
---@param whichPlayer userdata
---@param value string
function hjapi.DzAPI_Map_Ladder_SubmitTitle(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, value, "1")
end

--- 设置玩家额外分
---@param whichPlayer userdata
---@param value string
function hjapi.DzAPI_Map_Ladder_SubmitPlayerExtraExp(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

--- 活动完成
--- 完成平台活动[RPG大厅限定]
---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_MissionComplete(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_MissionComplete", whichPlayer, key, value)
end

--- 触发boss击杀
---@param whichPlayer userdata
---@param key string
function hjapi.DzAPI_Map_OrpgTrigger(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_OrpgTrigger", whichPlayer, key)
end

--- 服务器公共存档组保存
--- 存储服务器存档组，服务器存档组有100个KEY，每个KEY64个字符串长度，使用前请在作者之家服务器存档组进行设置
---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_SavePublicArchive(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_SavePublicArchive", whichPlayer, key, value)
end

--- 保存服务器存档
---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_SaveServerValue(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_SaveServerValue", whichPlayer, key, value)
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer userdata
---@param key string
---@param value string
function hjapi.DzAPI_Map_Stat_SetStat(whichPlayer, key, value)
    return hjapi.exec("DzAPI_Map_Stat_SetStat", whichPlayer, key, value)
end

--- 平台统计
--- 一般用于统计游戏里某些事件的触发次数，可在作者之家查看。【第二个子key是以后备用暂时不要填】
---@param whichPlayer userdata
---@param eventKey string
---@param eventType string
---@param value number integer
function hjapi.DzAPI_Map_Statistics(whichPlayer, eventKey, eventType, value)
    return hjapi.exec("DzAPI_Map_Statistics", whichPlayer, eventKey, eventType, value)
end

function hjapi.DzAPI_Map_ToggleStore(...)
    return hjapi.exec("DzAPI_Map_ToggleStore", ...)
end

function hjapi.DzAPI_Map_UpdatePlayerHero(...)
    return hjapi.exec("DzAPI_Map_UpdatePlayerHero", ...)
end

--- 局数消耗商品调用
--- 仅对局数消耗型商品有效
---@param whichPlayer userdata
---@param key string
function hjapi.DzAPI_Map_UseConsumablesItem(whichPlayer, key)
    return hjapi.exec("DzAPI_Map_UseConsumablesItem", whichPlayer, key)
end

--- 触发点击frame
---@param frameId number integer
function hjapi.DzClickFrame(frameId)
    return hjapi.exec("DzClickFrame", frameId)
end

function hjapi.DzConvertWorldPosition(...)
    return hjapi.exec("DzConvertWorldPosition", ...)
end

--- 新建Frame
--- 名字为fdf文件中的名字，ID默认填0。重复创建同名Frame会导致游戏退出时显示崩溃消息，如需避免可以使用Tag创建
---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function hjapi.DzCreateFrame(frame, parent, id)
    return hjapi.exec("DzCreateFrame", frame, parent, id)
end

--- 新建Frame[Tag]
--- 此处名字可以自定义，类型和模版填写fdf文件中的内容。通过此函数创建的Frame无法获取到子Frame
---@param frameType string
---@param name string
---@param parent number integer
---@param template string
---@param id number integer
---@return number integer
function hjapi.DzCreateFrameByTagName(frameType, name, parent, template, id)
    return math.floor(hjapi.exec("DzCreateFrameByTagName", frameType, name, parent, template, id) or 0)
end

--- tag方式新建一个frame
---@param fdfType string frame类型 TEXT | BACKDROP等
---@param fdfName string frame名称
---@param parent number 父节点ID(def:GameUI)
---@param tag string 自定义tag名称(def:cache.FrameTagIndex)
---@param id number integer(def:0)
---@return number|nil
function hjapi.FrameTag(fdfType, fdfName, parent)
    if (fdfType == nil or fdfName == nil) then
        return
    end
    hjapi._cache["FrameTagIndex"] = hjapi._cache["FrameTagIndex"] + 1
    local tag = "jft-" .. hjapi._cache["FrameTagIndex"]
    parent = parent or hjapi.DzGetGameUI()
    return hjapi.DzCreateFrameByTagName(fdfType, tag, parent, fdfName, 0)
end

---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function hjapi.DzCreateSimpleFrame(frame, parent, id)
    return hjapi.exec("DzCreateSimpleFrame", frame, parent, id)
end

--- 销毁
--- 销毁一个被重复创建过的Frame会导致游戏崩溃，重复创建同名Frame请使用Tag创建
---@param frameId number integer
function hjapi.DzDestroyFrame(frameId)
    return hjapi.exec("DzDestroyFrame", frameId)
end

--- 设置可破坏物位置
---@param d userdata destructable
---@param x number floor(2)
---@param y number floor(2)
function hjapi.DzDestructablePosition(d, x, y)
    return hjapi.exec("DzDestructablePosition", d, x, y)
end

--- 原生 - 使用宽屏模式
---@param enable boolean
function hjapi.DzEnableWideScreen(enable)
    hjapi._cache["IsWideScreen"] = enable
    return hjapi.exec("DzEnableWideScreen", enable)
end

--- 异步执行函数
---@param funcName string
function hjapi.DzExecuteFunc(funcName)
    return hjapi.exec("DzExecuteFunc", funcName)
end

--- 限制鼠标移动，在frame内
---@param frame number integer
---@param enable boolean
function hjapi.DzFrameCageMouse(frame, enable)
    return hjapi.exec("DzFrameCageMouse", frame, enable)
end

--- 清空frame所有锚点
---@param frame number integer
function hjapi.DzFrameClearAllPoints(frame)
    return hjapi.exec("DzFrameClearAllPoints", frame)
end

--- 修改游戏渲染黑边: 上方高度:upperHeight,下方高度:bottomHeight
---@param topHeight number floor(3)
---@param bottomHeight number floor(3)
function hjapi.DzFrameEditBlackBorders(topHeight, bottomHeight)
    hjapi._cache["FrameBlackTop"] = topHeight
    hjapi._cache["FrameBlackBottom"] = bottomHeight
    hjapi._cache["FrameInnerHeight"] = 0.6 - topHeight - bottomHeight
    return hjapi.exec("DzFrameEditBlackBorders", topHeight, bottomHeight)
end

--- 获取名字为name的子FrameID:Id"
--- ID默认填0，同名时优先获取最后被创建的。非Simple类的Frame类型都用此函数来获取子Frame
---@param name string
---@param id number integer
---@return number integer
function hjapi.DzFrameFindByName(name, id)
    return hjapi.exec("DzFrameFindByName", name, id)
end

--- 获取Frame的透明度(0-255)
---@param frame number integer
---@return number integer
function hjapi.DzFrameGetAlpha(frame)
    return hjapi.exec("DzFrameGetAlpha", frame)
end

--- 原生 - 玩家聊天信息框
---@return number integer
function hjapi.DzFrameGetChatMessage()
    return hjapi.exec("DzFrameGetChatMessage", nil)
end

--- 原生 - 技能按钮
--- 技能按钮:(row, column)
--- 参考物编中的技能按钮(x,y)坐标
--- (x,y)对应(column,row)反一下
---@param row number integer
---@param column number integer
---@return number integer
function hjapi.DzFrameGetCommandBarButton(row, column)
    return hjapi.exec("DzFrameGetCommandBarButton", row, column)
end

--- frame控件是否启用
---@param frame number integer
---@return boolean
function hjapi.DzFrameGetEnable(frame)
    return hjapi.exec("DzFrameGetEnable", frame)
end

--- 获取Frame的高度
---@param frame number integer
---@return number floor
function hjapi.DzFrameGetHeight(frame)
    return hjapi.exec("DzFrameGetHeight", frame)
end

--- 原生 - 英雄按钮
--- 左侧的英雄头像，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetHeroBarButton(buttonId)
    return hjapi.exec("DzFrameGetHeroBarButton", buttonId)
end

--- 原生 - 英雄血条
--- 左侧的英雄头像下的血条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetHeroHPBar(buttonId)
    return hjapi.exec("DzFrameGetHeroHPBar", buttonId)
end

--- 原生 - 英雄蓝条
--- 左侧的英雄头像下的蓝条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetHeroManaBar(buttonId)
    return hjapi.exec("DzFrameGetHeroManaBar", buttonId)
end

--- 原生 - 物品栏按钮
--- 索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetItemBarButton(buttonId)
    return hjapi.exec("DzFrameGetItemBarButton", buttonId)
end

--- 原生 - 小地图
---@return number integer
function hjapi.DzFrameGetMinimap()
    return hjapi.exec("DzFrameGetMinimap", nil)
end

--- 原生 - 小地图按钮
--- 小地图右侧竖排按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetMinimapButton(buttonId)
    return hjapi.exec("DzFrameGetMinimapButton", buttonId)
end

--- 获取 Frame 的名称
---@param frame number integer
---@return string
function hjapi.DzFrameGetName(frame)
    return hjapi.exec("DzFrameGetName", frame)
end

--- 获取 Frame 的 Parent
---@param frame number integer
---@return number integer
function hjapi.DzFrameGetParent(frame)
    return hjapi.exec("DzFrameGetParent", frame)
end

--- 原生 - 单位大头像
--- 小地图右侧的大头像
---@return number integer
function hjapi.DzFrameGetPortrait()
    return hjapi.exec("DzFrameGetPortrait", nil)
end

--- 获取 Frame 内的文字
--- 支持EditBox, TextFrame, TextArea, SimpleFontString
---@param frame number integer
---@return string
function hjapi.DzFrameGetText(frame)
    return hjapi.exec("DzFrameGetText", frame)
end

--- 获取 Frame 的字数限制
--- 支持EditBox
---@param frame number integer
---@return number integer
function hjapi.DzFrameGetTextSizeLimit(frame)
    return hjapi.exec("DzFrameGetTextSizeLimit", frame)
end

--- 原生 - 鼠标提示
--- 鼠标移动到物品或技能按钮上显示的提示窗，初始位于技能栏上方
---@return number integer
function hjapi.DzFrameGetTooltip()
    return hjapi.exec("DzFrameGetTooltip", nil)
end

--- 原生 - 上方消息框
--- 高维修费用 等消息
---@return number integer
function hjapi.DzFrameGetTopMessage()
    return hjapi.exec("DzFrameGetTopMessage", nil)
end

--- 原生 - 系统消息框
--- 包含显示消息给玩家 及 显示Debug消息等
---@return number integer
function hjapi.DzFrameGetUnitMessage()
    return hjapi.exec("DzFrameGetUnitMessage", nil)
end

--- 原生 - 界面按钮
--- 左上的菜单等按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function hjapi.DzFrameGetUpperButtonBarButton(buttonId)
    return hjapi.exec("DzFrameGetUpperButtonBarButton", buttonId)
end

--- 获取frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@return number floor
function hjapi.DzFrameGetValue(frame)
    return hjapi.exec("DzFrameGetValue", frame)
end

--- 原生 - 隐藏界面元素
--- 不再在地图初始化时调用则会残留小地图和时钟模型
function hjapi.DzFrameHideInterface()
    return hjapi.exec("DzFrameHideInterface", nil)
end

--- 设置绝对位置
--- 设置 frame 的 Point 锚点 在 (x, y)
---@param frame number integer
---@param point number integer
---@param x number floor(3)
---@param y number floor(3)
function hjapi.DzFrameSetAbsolutePoint(frame, point, x, y)
    return hjapi.exec("DzFrameSetAbsolutePoint", frame, point, x, y)
end

--- 移动所有锚点到Frame
--- 移动 frame 的 所有锚点 到 relativeFrame 上
---@param frame number integer
---@param relativeFrame number integer
---@return boolean
function hjapi.DzFrameSetAllPoints(frame, relativeFrame)
    return hjapi.exec("DzFrameSetAllPoints", frame, relativeFrame)
end

--- 设置frame的透明度(0-255)
---@param frame number integer
---@param alpha number integer
function hjapi.DzFrameSetAlpha(frame, alpha)
    return hjapi.exec("DzFrameSetAlpha", frame, alpha)
end

--- 设置动画
---@param frame number integer
---@param animId number integer 播放序号的动画
---@param autoCast boolean 自动播放
function hjapi.DzFrameSetAnimate(frame, animId, autoCast)
    return hjapi.exec("DzFrameSetAnimate", frame, animId, autoCast)
end

--- 设置动画进度
--- 自动播放为false时可用
---@param frame number integer
---@param offset number float(5) 进度
function hjapi.DzFrameSetAnimateOffset(frame, offset)
    return hjapi.exec("DzFrameSetAnimateOffset", frame, offset)
end

--- 启用/禁用 frame
---@param frame number integer
---@param enable boolean
function hjapi.DzFrameSetEnable(frame, enable)
    return hjapi.exec("DzFrameSetEnable", frame, enable)
end

--- 设置frame获取焦点
---@param frame number integer
---@param enable boolean
---@return boolean
function hjapi.DzFrameSetFocus(frame, enable)
    return hjapi.exec("DzFrameSetFocus", frame, enable)
end

--- 设置字体
--- 设置 frame 的字体为 font, 大小 height, flag flag
--- 支持EditBox、SimpleFontString、SimpleMessageFrame以及非SimpleFrame类型的例如TEXT，flag作用未知
---@param frame number integer
---@param fileName string
---@param height number float(5)
---@param flag number integer
function hjapi.DzFrameSetFont(frame, fileName, height, flag)
    return hjapi.exec("DzFrameSetFont", frame, fileName, height, flag)
end

--- 设置最大/最小值
--- 设置 frame 的 最小值为 Min 最大值为 Max
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param minValue number float(5)
---@param maxValue number float(5)
function hjapi.DzFrameSetMinMaxValue(frame, minValue, maxValue)
    return hjapi.exec("DzFrameSetMinMaxValue", frame, minValue, maxValue)
end

--- 设置模型
--- 设置 frame 的模型文件为 modelFile ModelType:modelType Flag:flag
---@param frame number integer
---@param modelFile string
---@param modelType number integer
---@param flag number integer
function hjapi.DzFrameSetModel(frame, modelFile, modelType, flag)
    return hjapi.exec("DzFrameSetModel", frame, modelFile, modelType, flag)
end

--- 设置父窗口
--- 设置 frame 的父窗口为 parent
---@param frame number integer
---@param parent number integer
function hjapi.DzFrameSetParent(frame, parent)
    return hjapi.exec("DzFrameSetParent", frame, parent)
end

--- 设置相对位置
--- 设置 frame 的 Point 锚点 (跟随relativeFrame 的 relativePoint 锚点) 偏移(x, y)
---@param frame number integer
---@param point number integer
---@param relativeFrame number integer
---@param relativePoint number integer
---@param x number float(5)
---@param y number float(5)
function hjapi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y)
    return hjapi.exec("DzFrameSetPoint", frame, point, relativeFrame, relativePoint, x, y)
end

--- 设置frame相对锚点
---@param frame number
---@param point number integer 参考blizzard:^FRAME_ALIGN
---@param relativeFrame number 相对节点ID(def:GameUI)
---@param relativePoint number 以 align-> alignParent 对齐
---@param x number 锚点X
---@param y number 锚点Y
function hjapi.FrameRelation(frame, point, relativeFrame, relativePoint, x, y)
    point = point or FRAME_ALIGN_CENTER
    relativeFrame = relativeFrame or hjapi.DzGetGameUI()
    relativePoint = relativePoint or FRAME_ALIGN_CENTER
    x = x or 0
    y = y or 0
    hjapi.DzFrameClearAllPoints(frame)
    hjapi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y)
end

--- 设置优先级
--- 设置 frame 优先级:int
---@param frame number integer
---@param priority number integer
function hjapi.DzFrameSetPriority(frame, priority)
    return hjapi.exec("DzFrameSetPriority", frame, priority)
end

--- 设置缩放
--- 设置 frame 的缩放 scale
---@param frame number integer
---@param scale number float(5)
function hjapi.DzFrameSetScale(frame, scale)
    return hjapi.exec("DzFrameSetScale", frame, scale)
end

--- 注册UI事件回调(func name)
--- 注册 frame 的 eventId 事件 运行:funcName 是否同步:sync
---@param frame number integer
---@param eventId number integer
---@param funcName string
---@param sync boolean
function hjapi.DzFrameSetScript(frame, eventId, funcName, sync)
    return hjapi.exec("DzFrameSetScript", frame, eventId, funcName, sync)
end

--- 注册UI事件回调(func handle)
--- 注册 frame 的 eventId 事件 运行:funcHandle 是否同步:sync
--- 运行触发器时需要打开同步
---@param frame number integer
---@param eventId number integer
---@param funcHandle function
---@param sync boolean
function hjapi.DzFrameSetScriptByCode(frame, eventId, funcHandle, sync)
    return hjapi.exec("DzFrameSetScriptByCode", frame, eventId, funcHandle, sync)
end

--- 设置frame大小
---@param frame number integer
---@param w number float(5) 宽
---@param h number float(5) 高
function hjapi.DzFrameSetSize(frame, w, h)
    return hjapi.exec("DzFrameSetSize", frame, w, h)
end

--- 设置frame步进值
--- 支持Slider
---@param frame number integer
---@param step number float(3) 步进
function hjapi.DzFrameSetStepValue(frame, step)
    return hjapi.exec("DzFrameSetStepValue", frame, step)
end

--- 设置frame文本
--- 支持EditBox, TextFrame, TextArea, SimpleFontString、GlueEditBoxWar3、SlashChatBox、TimerTextFrame、TextButtonFrame、GlueTextButton
---@param frame number integer
---@param text string
function hjapi.DzFrameSetText(frame, text)
    return hjapi.exec("DzFrameSetText", frame, text)
end

--- 设置frame对齐方式
--- 支持TextFrame、SimpleFontString、SimpleMessageFrame
---@param frame number integer
---@param align number integer ，参考blizzard:^FRAME_ALIGN
function hjapi.DzFrameSetTextAlignment(frame, align)
    return hjapi.exec("DzFrameSetTextAlignment", frame, align)
end

---@param frame number integer
---@param color number integer
function hjapi.DzFrameSetTextColor(frame, color)
    return hjapi.exec("DzFrameSetTextColor", frame, color)
end

--- 设置frame字数限制
---@param frame number integer
---@param limit number integer
function hjapi.DzFrameSetTextSizeLimit(frame, limit)
    return hjapi.exec("DzFrameSetTextSizeLimit", frame, limit)
end

--- 设置frame贴图
--- 支持Backdrop、SimpleStatusBar
---@param frame number integer
---@param texture string 贴图路径
---@param flag number integer 是否平铺
function hjapi.DzFrameSetTexture(frame, texture, flag)
    return hjapi.exec("DzFrameSetTexture", frame, texture, flag)
end

--- 设置提示
--- 设置 frame 的提示Frame为 tooltip
--- 设置tooltip
---@param frame number integer
---@param tooltip number integer
function hjapi.DzFrameSetTooltip(frame, tooltip)
    return hjapi.exec("DzFrameSetTooltip", frame, tooltip)
end

---@param funcName string
function hjapi.DzFrameSetUpdateCallback(funcName)
    return hjapi.exec("DzFrameSetUpdateCallback", funcName)
end

---@param funcHandle function
function hjapi.DzFrameSetUpdateCallbackByCode(funcHandle)
    return hjapi.exec("DzFrameSetUpdateCallbackByCode", funcHandle)
end

--- 设置frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param value number float(5)
function hjapi.DzFrameSetValue(frame, value)
    return hjapi.exec("DzFrameSetValue", frame, value)
end

--- 设置frame颜色
---@param frame number integer
---@param vertexColor number integer
function hjapi.DzFrameSetVertexColor(frame, vertexColor)
    return hjapi.exec("DzFrameSetVertexColor", frame, vertexColor)
end

--- 设置frame显示与否
---@param frame number integer
---@param enable boolean
function hjapi.DzFrameShow(frame, enable)
    return hjapi.exec("DzFrameShow", frame, enable)
end

function hjapi.DzGetClientHeight(...)
    return hjapi.exec("DzGetClientHeight", ...)
end

function hjapi.DzGetClientWidth(...)
    return hjapi.exec("DzGetClientWidth", ...)
end

--- 取 RGBA 色值
--- 返回一个整数，用于设置Frame颜色
---@param r number integer
---@param g number integer
---@param b number integer
---@param a number integer
---@return number integer
function hjapi.DzGetColor(r, g, b, a)
    return hjapi.exec("DzGetColor", r, g, b, a)
end

function hjapi.DzGetConvertWorldPositionX(...)
    return hjapi.exec("DzGetConvertWorldPositionX", ...)
end

function hjapi.DzGetConvertWorldPositionY(...)
    return hjapi.exec("DzGetConvertWorldPositionY", ...)
end

function hjapi.DzGetGameMode(...)
    return hjapi.exec("DzGetGameMode", ...)
end

--- 原生 - 游戏UI
--- 一般用作创建自定义UI的父节点
---@return number integer
function hjapi.DzGetGameUI()
    return hjapi.exec("DzGetGameUI", nil)
end

--- 获取客户端语言
--- 对不同语言客户端返回不同
---@return string
function hjapi.DzGetLocale()
    return hjapi.exec("DzGetLocale", nil)
end

--- 鼠标所在的Frame控件指针
--- 不是所有类型的Frame都能响应鼠标，能响应的有BUTTON，TEXT等
---@return number integer
function hjapi.DzGetMouseFocus()
    return hjapi.exec("DzGetMouseFocus", nil)
end

--- 获取鼠标在游戏内的坐标X
---@return number
function hjapi.DzGetMouseTerrainX()
    return hjapi.exec("DzGetMouseTerrainX", nil)
end

--- 获取鼠标在游戏内的坐标Y
---@return number
function hjapi.DzGetMouseTerrainY()
    return hjapi.exec("DzGetMouseTerrainY", nil)
end

--- 获取鼠标在游戏内的坐标Z
---@return number
function hjapi.DzGetMouseTerrainZ()
    return hjapi.exec("DzGetMouseTerrainZ", nil)
end

--- 获取鼠标在屏幕的坐标X
---@return number
function hjapi.DzGetMouseX()
    return hjapi.exec("DzGetMouseX", nil)
end

--- 获取鼠标游戏窗口坐标X
---@return number integer
function hjapi.DzGetMouseXRelative()
    return hjapi.exec("DzGetMouseXRelative", nil)
end

--- 获取鼠标在屏幕的坐标Y
---@return number
function hjapi.DzGetMouseY()
    return hjapi.exec("DzGetMouseY", nil)
end

--- 获取鼠标游戏窗口坐标Y
---@return number integer
function hjapi.DzGetMouseYRelative()
    return hjapi.exec("DzGetMouseYRelative", nil)
end

function hjapi.DzGetPlayerInitGold(...)
    return hjapi.exec("DzGetPlayerInitGold", ...)
end

function hjapi.DzGetPlayerName(...)
    return hjapi.exec("DzGetPlayerName", ...)
end

function hjapi.DzGetPlayerSelectedHero(...)
    return hjapi.exec("DzGetPlayerSelectedHero", ...)
end

--- 事件响应 - 获取触发的按键
--- 响应 [硬件] - 按键事件
---@return number integer
function hjapi.DzGetTriggerKey()
    return hjapi.exec("DzGetTriggerKey", nil)
end

--- 事件响应 - 获取触发硬件事件的玩家
--- 响应 [硬件] - 按键事件 滚轮事件 窗口大小变化事件
---@return userdata player
function hjapi.DzGetTriggerKeyPlayer()
    return hjapi.exec("DzGetTriggerKeyPlayer", nil)
end

--- 事件响应 - 获取同步的数据
--- 响应 [同步] - 同步消息事件
---@return string
function hjapi.DzGetTriggerSyncData()
    return hjapi.exec("DzGetTriggerSyncData", nil)
end

--- 事件响应 - 获取同步数据的玩家
--- 响应 [同步] - 同步消息事件
---@return userdata player
function hjapi.DzGetTriggerSyncPlayer()
    return hjapi.exec("DzGetTriggerSyncPlayer", nil)
end

--- 事件响应 - 触发的Frame
---@return number integer
function hjapi.DzGetTriggerUIEventFrame()
    return hjapi.exec("DzGetTriggerUIEventFrame", nil)
end

--- 事件响应 - 获取触发ui的玩家
---@return userdata player
function hjapi.DzGetTriggerUIEventPlayer()
    return hjapi.exec("DzGetTriggerUIEventPlayer", nil)
end

--- 获取升级所需经验
--- 获取单位 unit 的 level级 升级所需经验
---@param whichUnit userdata
---@param level number integer
---@return number integer
function hjapi.DzGetUnitNeededXP(whichUnit, level)
    return hjapi.exec("DzGetUnitNeededXP", whichUnit, level)
end

--- 获取鼠标指向的单位
---@return userdata unit
function hjapi.DzGetUnitUnderMouse()
    return hjapi.exec("DzGetUnitUnderMouse", nil)
end

--- 事件响应 - 获取滚轮变化值
--- 响应 [硬件] - 鼠标滚轮事件，正负区分上下
---@return number integer
function hjapi.DzGetWheelDelta()
    return hjapi.exec("DzGetWheelDelta", nil)
end

--- 获取魔兽窗口高度
---@return number integer
function hjapi.DzGetWindowHeight()
    return hjapi.exec("DzGetWindowHeight", nil)
end

--- 获取魔兽窗口宽度
---@return number integer
function hjapi.DzGetWindowWidth()
    return hjapi.exec("DzGetWindowWidth", {})
end

--- 获取魔兽窗口X坐标
---@return number integer
function hjapi.DzGetWindowX()
    return hjapi.exec("DzGetWindowX", nil)
end

--- 获取魔兽窗口Y坐标
---@return number integer
function hjapi.DzGetWindowY()
    return hjapi.exec("DzGetWindowY", nil)
end

--- 判断按键是否按下
---@param iKey number integer 参考blizzard:^GAME_KEY
---@return boolean
function hjapi.DzIsKeyDown(iKey)
    return hjapi.exec("DzIsKeyDown", iKey)
end

--- 鼠标是否在游戏内
---@return boolean
function hjapi.DzIsMouseOverUI()
    return hjapi.exec("DzIsMouseOverUI", nil)
end

--- 判断游戏窗口是否处于活动状态
---@return boolean
function hjapi.DzIsWindowActive()
    return hjapi.exec("DzIsWindowActive", nil)
end

--- 加载Toc文件列表
--- 加载--> file.toc
--- 载入自己的fdf列表文件
---@return boolean
function hjapi.DzLoadToc(tocFilePath)
    if (hjapi._cache["DzLoadToc"][tocFilePath] == true) then
        return true
    end
    hjapi._cache["DzLoadToc"][tocFilePath] = true
    return hjapi.exec("DzLoadToc", tocFilePath)
end

---@param enable boolean
function hjapi.DzOriginalUIAutoResetPoint(enable)
    return hjapi.exec("DzOriginalUIAutoResetPoint", enable)
end

--- 原生 - 修改屏幕比例(FOV)
---@param value number float(5)
function hjapi.DzSetCustomFovFix(value)
    return hjapi.exec("DzSetCustomFovFix", value)
end

--- 设置内存数值
--- 设置内存数据 address=value
---@param address number integer
---@param value number float(5)
function hjapi.DzSetMemory(address, value)
    return hjapi.exec("DzSetMemory", address, value)
end

--- 设置鼠标的坐标
---@param x number integer
---@param y number integer
function hjapi.DzSetMousePos(x, y)
    return hjapi.exec("DzSetMousePos", x, y)
end

--- 替换单位类型
--- 替换whichUnit的单位类型为:id
--- 不会替换大头像中的模型
---@param whichUnit userdata
---@param id number|string
function hjapi.DzSetUnitID(whichUnit, id)
    return hjapi.exec("DzSetUnitID", whichUnit, id)
end

--- 替换单位模型
--- 替换whichUnit的模型:path
--- 不会替换大头像中的模型
---@param whichUnit userdata
---@param model string
function hjapi.DzSetUnitModel(whichUnit, model)
    return hjapi.exec("DzSetUnitModel", whichUnit, model)
end

--- 设置单位位置 - 本地调用
---@param whichUnit userdata
---@param x number float(2)
---@param y number float(2)
function hjapi.DzSetUnitPosition(whichUnit, x, y)
    return hjapi.exec("DzSetUnitPosition", whichUnit, x, y)
end

--- 替换单位贴图
--- 只能替换模型中有Replaceable ID x 贴图的模型，ID为索引。不会替换大头像中的模型
---@param whichUnit userdata
---@param path string
---@param texId number integer
function hjapi.DzSetUnitTexture(whichUnit, path, texId)
    return hjapi.exec("DzSetUnitTexture", whichUnit, path, texId)
end

--- 原生 - 设置小地图背景贴图
---@param blp string
function hjapi.DzSetWar3MapMap(blp)
    return hjapi.exec("DzSetWar3MapMap", blp)
end

--- 获取子SimpleFontString
--- ID默认填0，同名时优先获取最后被创建的。SimpleFontString为fdf中的Frame类型
---@param name string
---@param id number integer
function hjapi.DzSimpleFontStringFindByName(name, id)
    return hjapi.exec("DzSimpleFontStringFindByName", name, id)
end

--- 获取子SimpleFrame
--- ID默认填0，同名时优先获取最后被创建的。SimpleFrame为fdf中的Frame类型
---@param name string
---@param id number integer
function hjapi.DzSimpleFrameFindByName(name, id)
    return hjapi.exec("DzSimpleFrameFindByName", name, id)
end

--- 获取子SimpleTexture
--- ID默认填0，同名时优先获取最后被创建的。SimpleTexture为fdf中的Frame类型
---@param name string
---@param id number integer
function hjapi.DzSimpleTextureFindByName(name, id)
    return hjapi.exec("DzSimpleTextureFindByName", name, id)
end

function hjapi.DzSyncBuffer(...)
    return hjapi.exec("DzSyncBuffer", ...)
end

--- 同步游戏数据
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function hjapi.DzSyncData(prefix, data)
    return hjapi.exec("DzSyncData", prefix, data)
end

--- 同步游戏数据（立刻）
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function hjapi.DzSyncDataImmediately(prefix, data)
    return hjapi.exec("DzSyncDataImmediately", prefix, data)
end

---@param trig userdata
---@param key number integer
---@param status number integer
---@param sync boolean
---@param funcName string
function hjapi.DzTriggerRegisterKeyEvent(trig, key, status, sync, funcName)
    return hjapi.exec("DzTriggerRegisterKeyEvent", trig, key, status, sync, funcName)
end

---@param trig userdata
---@param key number integer
---@param status number integer
---@param sync boolean
---@param funcHandle function
function hjapi.DzTriggerRegisterKeyEventByCode(trig, key, status, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterKeyEventByCode", trig, key, status, sync, funcHandle)
end

---@param trig userdata
---@param btn number integer
---@param status number integer
---@param sync boolean
---@param funcName string
function hjapi.DzTriggerRegisterMouseEvent(trig, btn, status, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseEvent", trig, btn, status, sync, funcName)
end

---@param trig userdata
---@param btn number integer
---@param status number integer
---@param sync boolean
---@param funcHandle function
function hjapi.DzTriggerRegisterMouseEventByCode(trig, btn, status, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseEventByCode", trig, btn, status, sync, funcHandle)
end

---@param trig userdata
---@param sync boolean
---@param funcName string
function hjapi.DzTriggerRegisterMouseMoveEvent(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseMoveEvent", trig, sync, funcName)
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
function hjapi.DzTriggerRegisterMouseMoveEventByCode(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseMoveEventByCode", trig, sync, funcHandle)
end

---@param trig userdata
---@param sync boolean
---@param funcName string
function hjapi.DzTriggerRegisterMouseWheelEvent(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterMouseWheelEvent", trig, sync, funcName)
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
function hjapi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterMouseWheelEventByCode", trig, sync, funcHandle)
end

--- 数据同步
--- 标签为 prefix 的数据被同步 | 来自平台:server
--- 来自平台的参数填false
---@param trig userdata
---@param prefix string
---@param server boolean
function hjapi.DzTriggerRegisterSyncData(trig, prefix, server)
    return hjapi.exec("DzTriggerRegisterSyncData", trig, prefix, server)
end

---@param trig userdata
---@param sync boolean
---@param funcName string
function hjapi.DzTriggerRegisterWindowResizeEvent(trig, sync, funcName)
    return hjapi.exec("DzTriggerRegisterWindowResizeEvent", trig, sync, funcName)
end

---@param trig userdata
---@param sync boolean
---@param funcHandle function
function hjapi.DzTriggerRegisterWindowResizeEventByCode(trig, sync, funcHandle)
    return hjapi.exec("DzTriggerRegisterWindowResizeEventByCode", trig, sync, funcHandle)
end

function hjapi.DzUnitDisableAttack(...)
    return hjapi.exec("DzUnitDisableAttack", ...)
end

function hjapi.DzUnitDisableInventory(...)
    return hjapi.exec("DzUnitDisableInventory", ...)
end

function hjapi.DzUnitLearningSkill(...)
    return hjapi.exec("DzUnitLearningSkill", ...)
end

function hjapi.DzUnitSilence(...)
    return hjapi.exec("DzUnitSilence", ...)
end

function hjapi.EXBlendButtonIcon(...)
    return hjapi.exec("EXBlendButtonIcon", ...)
end

function hjapi.EXDclareButtonIcon(...)
    return hjapi.exec("EXDclareButtonIcon", ...)
end

function hjapi.EXDisplayChat(...)
    return hjapi.exec("EXDisplayChat", ...)
end

--- 重置特效变换
--- 重置 effect
--- 清空所有的旋转和缩放，重置为初始状态
---@param effect userdata
function hjapi.EXEffectMatReset(effect)
    return hjapi.exec("EXEffectMatReset", effect)
end

--- 特效绕X轴旋转
--- effect 绕X轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
function hjapi.EXEffectMatRotateX(effect, angle)
    return hjapi.exec("EXEffectMatRotateX", effect, angle)
end

--- 特效绕Y轴旋转
--- effect 绕Y轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
function hjapi.EXEffectMatRotateY(effect, angle)
    return hjapi.exec("EXEffectMatRotateY", effect, angle)
end

--- 特效绕Z轴旋转
--- effect 绕Z轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect userdata
---@param angle number float(5)
function hjapi.EXEffectMatRotateZ(effect, angle)
    return hjapi.exec("EXEffectMatRotateZ", effect, angle)
end

--- 缩放特效
--- 设置 effect 的X轴缩放，Y轴缩放，Z轴缩放
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态。设置为2,2,2时相当于大小变为2倍。设置为负数时，就是镜像翻转
---@param effect userdata
---@param x number float(5)
---@param y number float(5)
---@param z number float(5)
function hjapi.EXEffectMatScale(effect, x, y, z)
    return hjapi.exec("EXEffectMatScale", effect, x, y, z)
end

---@param script string
function hjapi.EXExecuteScript(script)
    return hjapi.exec("EXExecuteScript", script)
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return number integer
function hjapi.EXGetAbilityDataInteger(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataInteger", abil, level, dataType)
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return number float
function hjapi.EXGetAbilityDataReal(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataReal", abil, level, dataType)
end

---@param abil userdata ability
---@param level number integer
---@param dataType number integer
---@return string
function hjapi.EXGetAbilityDataString(abil, level, dataType)
    return hjapi.exec("EXGetAbilityDataString", abil, level, dataType)
end

---@param abil userdata ability
---@return number integer
function hjapi.EXGetAbilityId(abil)
    return hjapi.exec("EXGetAbilityId", abil)
end

---@param abil userdata ability
---@param stateType number integer
---@return number float
function hjapi.EXGetAbilityState(abil, stateType)
    return hjapi.exec("EXGetAbilityState", abil, stateType)
end

function hjapi.EXGetAbilityString(...)
    return hjapi.exec("EXGetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@return string
function hjapi.EXGetBuffDataString(buffCode, dataType)
    return hjapi.exec("EXGetBuffDataString", buffCode, dataType)
end

--- 获取特效大小
---@param effect userdata
---@return number float
function hjapi.EXGetEffectSize(effect)
    return hjapi.exec("EXGetEffectSize", effect)
end

--- 获取特效X轴坐标
---@param effect userdata
---@return number float
function hjapi.EXGetEffectX(effect)
    return hjapi.exec("EXGetEffectX", effect)
end

--- 获取特效Y轴坐标
---@param effect userdata
---@return number float
function hjapi.EXGetEffectY(effect)
    return hjapi.exec("EXGetEffectY", effect)
end

--- 获取特效Z轴坐标
---@param effect userdata
---@return number float
function hjapi.EXGetEffectZ(effect)
    return hjapi.exec("EXGetEffectZ", effect)
end

---@param eddType number integer
---@return number integer
function hjapi.EXGetEventDamageData(eddType)
    return hjapi.exec("EXGetEventDamageData", eddType)
end

---@param itemCode number integer
---@param dataType number integer
---@return string
function hjapi.EXGetItemDataString(itemCode, dataType)
    return hjapi.exec("EXGetItemDataString", itemCode, dataType)
end

---@param whichUnit userdata
---@param abilityID number string|integer
function hjapi.EXGetUnitAbility(whichUnit, abilityID)
    if (type(abilityID) == "string") then
        abilityID = c2i(abilityID)
    end
    return hjapi.exec("EXGetUnitAbility", whichUnit, abilityID)
end

---@param whichUnit userdata
---@param index number integer
function hjapi.EXGetUnitAbilityByIndex(whichUnit, index)
    return hjapi.exec("EXGetUnitAbilityByIndex", whichUnit, index)
end

function hjapi.EXGetUnitArrayString(...)
    return hjapi.exec("EXGetUnitArrayString", ...)
end

function hjapi.EXGetUnitInteger(...)
    return hjapi.exec("EXGetUnitInteger", ...)
end

function hjapi.EXGetUnitReal(...)
    return hjapi.exec("EXGetUnitReal", ...)
end

function hjapi.EXGetUnitString(...)
    return hjapi.exec("EXGetUnitString", ...)
end

---@param whichUnit userdata
---@param enable boolean
function hjapi.EXPauseUnit(whichUnit, enable)
    return hjapi.exec("EXPauseUnit", whichUnit, enable)
end

--- 单位添加晕眩
---@param whichUnit userdata
function hjapi.UnitAddSwim(whichUnit)
    return hjapi.EXPauseUnit(whichUnit, true)
end

--- 单位移除晕眩
--- 别用来移风暴之锤之类的晕眩。因为它只会移除晕眩并不会移除晕眩的buff
---@param whichUnit userdata
function hjapi.UnitRemoveSwim(whichUnit)
    return hjapi.EXPauseUnit(whichUnit, false)
end

function hjapi.EXSetAbilityAEmeDataA(...)
    return hjapi.exec("EXSetAbilityAEmeDataA", ...)
end

function hjapi.EXSetAbilityDataInteger(...)
    return hjapi.exec("EXSetAbilityDataInteger", ...)
end

function hjapi.EXSetAbilityDataReal(...)
    return hjapi.exec("EXSetAbilityDataReal", ...)
end

function hjapi.EXSetAbilityDataString(...)
    return hjapi.exec("EXSetAbilityDataString", ...)
end

---@param ability userdata
---@param stateType number integer
---@param value number floor(3)
function hjapi.EXSetAbilityState(ability, stateType, value)
    return hjapi.exec("EXSetAbilityState", ability, stateType, value)
end

function hjapi.EXSetAbilityString(...)
    return hjapi.exec("EXSetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@param value string
function hjapi.EXSetBuffDataString(buffCode, dataType, value)
    return hjapi.exec("EXSetBuffDataString", buffCode, dataType, value)
end

--- 设置特效大小
---@param e userdata
---@param size number float(3)
function hjapi.EXSetEffectSize(e, size)
    return hjapi.exec("EXSetEffectSize", e, size)
end

--- 设置特效动画速度
---@param e userdata
---@param speed number float(3)
function hjapi.EXSetEffectSpeed(e, speed)
    return hjapi.exec("EXSetEffectSpeed", e, speed)
end

--- 移动特效到坐标
---@param e userdata
---@param x number float(3)
---@param y number float(3)
function hjapi.EXSetEffectXY(e, x, y)
    return hjapi.exec("EXSetEffectXY", e, x, y)
end

---设置特效高度
---@param e userdata
---@param z number float(3)
function hjapi.EXSetEffectZ(e, z)
    return hjapi.exec("EXSetEffectZ", e, z)
end

---@param amount number float(3)
---@return boolean
function hjapi.EXSetEventDamage(amount)
    return hjapi.exec("EXSetEventDamage", amount)
end

---@param itemCode number integer
---@param dataType number integer
---@param value string
---@return boolean
function hjapi.EXSetItemDataString(itemCode, dataType, value)
    return hjapi.exec("EXSetItemDataString", itemCode, dataType, value)
end

function hjapi.EXSetUnitArrayString(...)
    return hjapi.exec("EXSetUnitArrayString", ...)
end

--- 设置单位的碰撞类型
--- 启用/禁用 单位u 对 t 的碰撞
---@param enable boolean
---@param u userdata
---@param t number integer 碰撞类型，参考blizzard:^COLLISION_TYPE
function hjapi.EXSetUnitCollisionType(enable, u, t)
    return hjapi.exec("EXSetUnitCollisionType", enable, u, t)
end

--- 设置单位面向角度
--- 立即转身
---@param u userdata
---@param angle number float(2)
function hjapi.EXSetUnitFacing(u, angle)
    return hjapi.exec("EXSetUnitFacing", u, angle)
end

function hjapi.EXSetUnitInteger(...)
    return hjapi.exec("EXSetUnitInteger", ...)
end

--- 设置单位的移动类型
---@param u userdata
---@param t number integer 移动类型，参考blizzard:^MOVE_TYPE
function hjapi.EXSetUnitMoveType(u, t)
    return hjapi.exec("EXSetUnitMoveType", u, t)
end

function hjapi.EXSetUnitReal(...)
    return hjapi.exec("EXSetUnitReal", ...)
end

function hjapi.EXSetUnitString(...)
    return hjapi.exec("EXSetUnitString", ...)
end

--- 伤害值
---@return number
function hjapi.GetEventDamage()
    return hjapi.exec("GetEventDamage", nil)
end

---@param whichUnit userdata
---@param state userdata unitstate
---@return number
function hjapi.GetUnitState(whichUnit, state)
    return hjapi.exec("GetUnitState", whichUnit, state)
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return boolean
function hjapi.RequestExtraBooleanData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraBooleanData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number integer
function hjapi.RequestExtraIntegerData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraIntegerData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number
function hjapi.RequestExtraRealData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraRealData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer userdata
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return string
function hjapi.RequestExtraStringData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return hjapi.exec("RequestExtraStringData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

--- 设置单位属性
---@param whichUnit userdata
---@param state userdata unitstate
---@param value number
function hjapi.SetUnitState(whichUnit, state, value)
    hjapi.exec("SetUnitState", whichUnit, state, value)
    if (whichUnit ~= nil and state == UNIT_STATE_ATTACK_WHITE or state == UNIT_STATE_DEFEND_WHITE) then
        cj.UnitAddAbility(whichUnit, HL_ID.japi_delay)
        cj.UnitRemoveAbility(whichUnit, HL_ID.japi_delay)
    end
end

--------------------------------------------------------------------------

--- 玩家是否平台VIP
---@param whichPlayer userdata
---@return boolean
function hjapi.DzAPI_Map_IsPlatformVIP(whichPlayer)
    local res = hjapi.DzAPI_Map_GetPlatformVIP(whichPlayer)
    if (type(res) == "number") then
        return res > 0
    end
    return false
end

--- 天梯提交玩家排名
---@param whichPlayer number
---@param value number
function hjapi.DzAPI_Map_Ladder_SubmitPlayerRank(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

--- 天梯提交获得称号
---@param whichPlayer number
---@param value string
function hjapi.DzAPI_Map_Ladder_SubmitTitle(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, value, "1")
end

--- 设置玩家额外分
---@param whichPlayer number
---@param value string
function hjapi.DzAPI_Map_Ladder_SubmitPlayerExtraExp(whichPlayer, value)
    return hjapi.DzAPI_Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

--- 注册实时购买商品事件
--- 玩家在游戏中购买商城道具触发，可以配合打开商城界面使用，读取用实时购买玩家和实时购买商品
function hjapi.DzTriggerRegisterMallItemSyncData(trig)
    hjapi.DzTriggerRegisterSyncData(trig, "DZMIA", true)
end

--- 全局存档变化事件
--- 本局游戏或其他游戏保存的全局存档都会触发这个事件，请使用[同步]分类下的获取同步数据来获得发生变化的全局存档KEY值
function hjapi.DzAPI_Map_Global_ChangeMsg(trig)
    hjapi.DzTriggerRegisterSyncData(trig, "DZGAU", true)
end

--- 判断是否是匹配模式
--- 判断玩家是否是通过匹配模式进入游戏
--- 具体模式ID使用 获取天梯和匹配的模式 获取
---@return boolean
function hjapi.DzAPI_Map_IsRPGQuickMatch()
    return hjapi.RequestExtraBooleanData(40, nil, nil, nil, false, 0, 0, 0)
end

--- 获取商城道具数量
--- 获取玩家 key 商品剩余库存次数
--- 仅对次数消耗型商品有效
---@param whichPlayer number
---@param key string
---@return number integer
function hjapi.DzAPI_Map_GetMallItemCount(whichPlayer, key)
    return hjapi.RequestExtraIntegerData(41, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 使用商城道具（次数型）
--- 使用玩家 key 商城道具 value 次
--- 仅对次数消耗型商品有效，只能使用不能恢复，请谨慎使用
---@param whichPlayer number
---@param key string
---@param value number integer
---@return boolean
function hjapi.DzAPI_Map_ConsumeMallItem(whichPlayer, key, value)
    return hjapi.RequestExtraBooleanData(42, whichPlayer, key, nil, false, value, 0, 0)
end

--- 修改平台功能设置
---@param whichPlayer number
---@param option number integer;1为锁定镜头距离、2为显示血、蓝条、3为智能施法
---@param enable boolean
---@return boolean
function hjapi.DzAPI_Map_EnablePlatformSettings(whichPlayer, option, enable)
    return hjapi.RequestExtraBooleanData(43, whichPlayer, nil, nil, enable, option, 0, 0)
end

--- 玩家是否购买了重制版
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsBuyReforged(whichPlayer)
    return hjapi.RequestExtraBooleanData(44, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家中游戏局数
---@param whichPlayer number
---@return number
function hjapi.DzAPI_Map_PlayedGames(whichPlayer)
    return hjapi.RequestExtraIntegerData(45, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家的评论次数
--- 该功能已失效，始终返回1
---@param whichPlayer number
---@return number|1
function hjapi.DzAPI_Map_CommentCount(whichPlayer)
    return hjapi.RequestExtraIntegerData(46, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家平台好友数量
---@param whichPlayer number
---@return number
function hjapi.DzAPI_Map_FriendCount(whichPlayer)
    return hjapi.RequestExtraIntegerData(47, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是鉴赏家
--- 评论里的鉴赏家
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsConnoisseur(whichPlayer)
    return hjapi.RequestExtraBooleanData(48, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家登录的是战网账号
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsBattleNetAccount(whichPlayer)
    return hjapi.RequestExtraBooleanData(49, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是地图作者
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsAuthor(whichPlayer)
    return hjapi.RequestExtraBooleanData(50, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 地图评论次数
--- 获取该图总评论次数
---@return number integer
function hjapi.DzAPI_Map_CommentTotalCount()
    return hjapi.RequestExtraIntegerData(51, nil, nil, nil, false, 0, 0, 0)
end

--- 获取自定义排行榜玩家排名
--- 100名以外的玩家排名为0
--- 该功能适用于作者之家-服务器存档-自定义排行榜
--- 等同 DzAPI_Map_CommentTotalCount1
---@param whichPlayer number
---@param id number integer
---@return number integer
function hjapi.DzAPI_Map_CustomRanking(whichPlayer, id)
    return hjapi.RequestExtraIntegerData(52, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家当前是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsPlatformReturn(whichPlayer)
    return hjapi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 2, 0, 0)
end

--- 玩家当前是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsMapReturn(whichPlayer)
    return hjapi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 8, 0, 0)
end

--- 玩家曾经是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsPlatformReturnUsed(whichPlayer)
    return hjapi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 4, 0, 0)
end

--- 玩家曾经是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsMapReturnUsed(whichPlayer)
    return hjapi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 1, 0, 0)
end

--- 玩家收藏过地图
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsCollected(whichPlayer)
    return hjapi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 16, 0, 0)
end

--- 签到系统
--- 玩家每天登录游戏后，自动签到
---@param whichPlayer number
---@return number integer
function hjapi.DzAPI_Map_ContinuousCount(whichPlayer, id)
    return hjapi.RequestExtraIntegerData(54, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家是真实玩家
--- 用于区别平台AI玩家。现在平台已经添加虚拟电脑玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
---@param whichPlayer number
---@return boolean
function hjapi.DzAPI_Map_IsPlayer(whichPlayer)
    return hjapi.RequestExtraBooleanData(55, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 所有地图的总游戏时长
---@param whichPlayer number
---@return number
function hjapi.DzAPI_Map_MapsTotalPlayed(whichPlayer)
    return hjapi.RequestExtraIntegerData(56, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 指定地图的地图等级
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function hjapi.DzAPI_Map_MapsLevel(whichPlayer, mapId)
    return hjapi.RequestExtraIntegerData(57, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台金币消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function hjapi.DzAPI_Map_MapsConsumeGold(whichPlayer, mapId)
    return hjapi.RequestExtraIntegerData(58, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台木头消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function hjapi.DzAPI_Map_MapsConsumeLumber(whichPlayer, mapId)
    return hjapi.RequestExtraIntegerData(59, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（1~199）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function hjapi.DzAPI_Map_MapsConsume_1_199(whichPlayer, mapId)
    return hjapi.RequestExtraBooleanData(60, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（200~499）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function hjapi.DzAPI_Map_MapsConsume_200_499(whichPlayer, mapId)
    return hjapi.RequestExtraBooleanData(61, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（500~999）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function hjapi.DzAPI_Map_MapsConsume_500_999(whichPlayer, mapId)
    return hjapi.RequestExtraBooleanData(62, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（1000+）以上
---@param whichPlayer number
---@param mapId number
---@return boolean
function hjapi.DzAPI_Map_MapsConsume_1000(whichPlayer, mapId)
    return hjapi.RequestExtraBooleanData(63, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 获取论坛数据
--- 是否发过贴子,是否版主时，返回为1代表肯定
---@param whichPlayer number
---@param data number integer 0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量
---@return boolean
function hjapi.DzAPI_Map_GetForumData(whichPlayer, data)
    return hjapi.RequestExtraIntegerData(65, whichPlayer, nil, nil, false, data, 0, 0)
end

--- 游戏中弹出商城道具购买界面
--- 可以在游戏里打开指定商城道具购买界面（包括下架商品）,商品购买之后，请配合实时购买触发功能使用
---@param whichPlayer number
---@param key string
---@return boolean
function hjapi.DzAPI_Map_OpenMall(whichPlayer, key)
    return hjapi.RequestExtraIntegerData(66, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 获得游戏渲染的：离顶黑边高、离底黑边高、中间显示高、
---@return number,number,number
function hjapi.GetFrameBorders()
    return hjapi._cache["FrameBlackTop"], hjapi._cache["FrameBlackBottom"], hjapi._cache["FrameInnerHeight"]
end

--- 是否宽屏模式
---@return boolean
function hjapi.IsWideScreen()
    return hjapi._cache["IsWideScreen"]
end

--- 是物理伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function hjapi.IsEventPhysicalDamage()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end

--- 是攻击伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function hjapi.IsEventAttackDamage()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end

--- 是远程伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function hjapi.IsEventRangedDamage()
    return 0 ~= hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end

--- 单位所受伤害的伤害类型是 damageType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param damageType userdata 参考 blizzard:^DAMAGE_TYPE
---@return boolean
function hjapi.IsEventDamageType(damageType)
    return damageType == cj.ConvertDamageType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end

--- 单位所受伤害的武器类型是 是 weaponType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param weaponType userdata 参考 blizzard:^WEAPON_TYPE
---@return boolean
function hjapi.IsEventWeaponType(weaponType)
    return weaponType == cj.ConvertWeaponType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end

--- 单位所受伤害的攻击类型是 是 attackType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param attackType userdata 参考 blizzard:^ATTACK_TYPE
---@return boolean
function hjapi.IsEventAttackType(attackType)
    return attackType == cj.ConvertAttackType(hjapi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end

--- 获取某个坐标的Z轴高度
---@type fun(x:number,y:number):number
function hjapi.Z(x, y)
    if (type(x) == "number" and type(y) == "number") then
        x = math.floor(x)
        y = math.floor(y)
        local k = x .. '_' .. y
        if (hjapi._cache["Z"][k] == nil) then
            local loc = cj.Location(x, y)
            local z = cj.GetLocationZ(loc)
            cj.RemoveLocation(loc)
            hjapi._cache["Z"][k] = z
        end
        return hjapi._cache["Z"][k]
    end
    return 0
end

--- X比例 转 像素
---@type fun(x:number):number
function hjapi.PX(x)
    return hjapi.DzGetClientWidth() * x / 0.8
end

--- Y比例 转 像素
---@type fun(y:number):number
function hjapi.PY(y)
    return hjapi.DzGetClientHeight() * y / 0.6
end

--- X像素 转 比例
---@type fun(x:number):number
function hjapi.RX(x)
    return x / hjapi.DzGetClientWidth() * 0.8
end

--- Y像素 转 比例
---@type fun(y:number):number
function hjapi.RY(y)
    return y / hjapi.DzGetClientHeight() * 0.6
end

--- 鼠标客户端内X像素
---@type fun():number
function hjapi.MousePX()
    return hjapi.DzGetMouseXRelative()
end

--- 鼠标客户端内Y像素
---@type fun():number
function hjapi.MousePY()
    return hjapi.DzGetClientHeight() - hjapi.DzGetMouseYRelative()
end

--- 鼠标X像素 转 比例
---@type fun():number
function hjapi.MouseRX()
    return hjapi.RX(hjapi.MousePX())
end

--- 鼠标Y像素 转 比例
---@type fun():number
function hjapi.MouseRY()
    return hjapi.RY(hjapi.MousePY())
end

--- 判断XY是否在客户端内
---@type fun(rx:number,ry:number):boolean
function hjapi.InWindow(rx, ry)
    return rx > 0 and rx < 0.8 and ry > 0 and ry < 0.6
end

--- 判断鼠标是否在客户端内
---@type fun():boolean
function hjapi.InWindowMouse()
    return hjapi.InWindow(hjapi.MouseRX(), hjapi.MouseRY())
end