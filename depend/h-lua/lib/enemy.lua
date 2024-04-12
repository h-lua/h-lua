---@class henemy 敌人模块
henemy = {
    -- 配置项
    conf = {
        --[[{
            name 敌人队伍的名称，默认敌军
            color 敌人队伍的颜色 参考 PLAYER_COLOR_BLACK
            playerIndexes 归于此敌人的玩家索引 1-12
            isShareSight 是否与玩家共享视野
        }]]
    },
    --- 充当敌人的玩家调用次数，初始 0
    count = {},
    --- 充当敌人的玩家调用次数上限，达到就全体归0
    countLimit = 100,
}

--- 配置敌人
--- 此方法只能设置一次，不能多次设置覆盖，多次设置代表多个敌军势力
---@param name string 敌人势力队伍的名称，默认敌军No
---@param color any 敌人势力队伍的颜色,参考 PLAYER_COLOR_BLACK
---@param playerIndexes table 归于此敌人的玩家索引 1-12，如{1,2,3}
---@param isShareSight boolean 是否与玩家共享视野
---@return number 返回队伍序号，从1开始累加
function henemy.set(name, color, playerIndexes, isShareSight)
    name = name or ("enemy-" .. (1 + #henemy.conf))
    color = color or PLAYER_COLOR_BLACK
    playerIndexes = playerIndexes or {}
    if (type(isShareSight) ~= "boolean") then
        isShareSight = false
    end
    table.insert(henemy.conf, {
        name = name,
        color = color,
        playerIndexes = playerIndexes,
        isShareSight = isShareSight,
    })
    if (#playerIndexes > 0) then
        for _, pIdx in ipairs(playerIndexes) do
            henemy.count[pIdx] = 0
            cj.SetPlayerName(cj.Player(pIdx - 1), name)
            cj.SetPlayerColor(cj.Player(pIdx - 1), color)
        end
    end
    return #henemy.conf
end

--- 根据队伍号最优化自动获取一个敌人玩家,默认第一个队伍
---@param createQty number 可设定创建单位数，更精准调用，默认权重 1
---@return userdata 敌人玩家
function henemy.getPlayer(createQty, teamNo)
    teamNo = teamNo or 1
    if (henemy.conf[teamNo] == nil) then
        return
    end
    if (createQty == nil) then
        createQty = 1
    else
        createQty = math.floor(createQty)
    end
    local ti = 0
    for _, pIdx in ipairs(henemy.conf[teamNo].playerIndexes) do
        if (ti == 0) then
            ti = pIdx
        elseif (henemy.count[pIdx] < henemy.count[ti]) then
            ti = pIdx
        end
    end
    henemy.count[ti] = henemy.count[ti] + createQty
    if (henemy.count[ti] > henemy.countLimit) then
        for _, pIdx in ipairs(henemy.conf[teamNo].playerIndexes) do
            henemy.count[pIdx] = 0
        end
    end
    return hplayer.players[ti]
end

--- 设置敌人是否共享视野
---@param teamNo number
---@return boolean
function henemy.isShareSight(teamNo)
    teamNo = teamNo or 1
    if (henemy.conf[teamNo] == nil) then
        return false
    end
    return henemy.conf[teamNo].isShareSight
end

--[[
    创建敌人单位/单位组
    options = {
        teamNo = 1, -- 敌军队伍序号，默认1
        id = nil, --类型id,如 H001
        x = nil, --创建坐标X，可选
        y = nil, --创建坐标Y，可选
        loc = nil, --创建点，可选
        height = 高度，0，可选
        timeScale = 动作时间比例，0.0~N.N，可选
        modelScale = 模型缩放比例，0.0~N.N，可选
        red = 红色，0～255，可选
        green = 绿色，0～255，可选
        blue = 蓝色，0～255，可选
        opacity = 不透明度，0.0～1.0，可选,0不可见
        qty = 1, --数量，可选，可选
        period = nil, --生命周期，到期死亡，可选
        during = nil, --持续时间，到期删除，可选
        facing = nil, --面向角度，可选
        facingX = nil, --面向X，可选
        facingY = nil, --面向Y，可选
        facingUnit = nil, --面向单位，可选
        attackX = nil, --攻击X，可选
        attackY = nil, --攻击Y，可选
        attackUnit = nil, --攻击单位，可选
        isShadow = false, --是否影子，可选
        isUnSelectable = false, --是否可鼠标选中，可选
        isInvulnerable = false, --是否无敌，可选
        attr = nil, --自定义属性，可选
    }
]]
---@alias noteEnemyCreate {teamNo,register,registerOrderEvent,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@param options noteEnemyCreate
---@return userdata|userdata[] 最后创建单位|单位组
function henemy.create(options)
    if (#henemy.conf <= 0) then
        return
    end
    options.whichPlayer = henemy.getPlayer(options.qty or 1, options.teamNo)
    options.isShareSight = henemy.isShareSight(options.teamNo)
    return hunit.create(options)
end
