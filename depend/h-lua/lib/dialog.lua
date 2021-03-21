---@class hdialog 对话框
hdialog = {}

--- 自动根据key识别热键
---@param key string
hdialog.hotkey = function(key)
    if (key == nil) then
        return 0
    elseif (type(key) == "number") then
        return key
    elseif (type(key) == "string") then
        return string.byte(key, 1)
    else
        return 0
    end
end

--- 删除一个对话框
---@param whichDialog userdata
hdialog.del = function(whichDialog)
    hcache.free(whichDialog)
    cj.DialogClear(whichDialog)
    cj.DialogDestroy(whichDialog)
end

--- 创建一个新的对话框
---@alias dialogCreateAction fun(action: string):void
---@param whichPlayer userdata
---@param options table
---@param action dialogCreateAction | "function(btnValue) end"
---@return userdata
hdialog.create = function(whichPlayer, options, action)
    --[[
        options = {
            title = "h-lua对话框一个",
            buttons = {
                { value = "Q", label = "第1个" },
                { value = "W", label = "第2个" },
                { value = "D", label = "第3个" },
            }
        }
    ]]
    if (#options.buttons <= 0) then
        print_err("Dialog buttons is empty")
        return
    end
    local d = cj.DialogCreate()
    cj.DialogSetMessage(d, options.title)
    local buttons = {}
    for i = 1, #options.buttons, 1 do
        if (type(options.buttons[i]) == "table") then
            local b = cj.DialogAddButton(d, options.buttons[i].label, hdialog.hotkey(options.buttons[i].value))
            table.insert(buttons, {
                button = b,
                value = options.buttons[i].value
            })
        else
            local b = cj.DialogAddButton(d, options.buttons[i], hdialog.hotkey(options.buttons[i]))
            table.insert(buttons, {
                button = b,
                value = options.buttons[i]
            })
        end
    end
    hcache.alloc(d)
    hcache.set(d, CONST_CACHE.DIALOG_ACTION, action)
    hcache.set(d, CONST_CACHE.DIALOG_BUTTON, buttons)
    hevent.pool(d, hevent_default_actions.dialog.click, function(tgr)
        cj.TriggerRegisterDialogEvent(tgr, d)
    end)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYERS, 1 do
            if (cj.GetPlayerController(hplayer.players[i]) == MAP_CONTROL_USER and
                cj.GetPlayerSlotState(hplayer.players[i]) == PLAYER_SLOT_STATE_PLAYING) then
                whichPlayer = hplayer.players[i]
                break
            end
        end
    end
    cj.DialogDisplay(whichPlayer, d, true)
end
