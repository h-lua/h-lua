require 'h-lua-console'
HLUA_CLI_REQUIRE = 20220518
require 'main'
if (cj ~= nil) then
    local t = cj.CreateTrigger()
    cj.TriggerRegisterTimerEvent(t, 0.1, false)
    cj.TriggerAddAction(t, function()
        cj.DisableTrigger(t)
        cj.DestroyTrigger(t)
        t = nil
        if (type(main) == "function") then
            main()
        end
    end)
else
    if (type(main) == "function") then
        main()
    end
end
