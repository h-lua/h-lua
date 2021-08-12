--local process = require 'process'
local root = fs.ydwe_path()
local dev = root --fs.ydwe_devpath()

local function trans_command(cmd)
    local str = cmd:gsub([[(\\?)$]], function (str)
        if str == [[\]] then
            return [[\\]]
        end
    end)
    return '"' .. str .. '"'
end

return function (mode, map_path, target_path)
    local current_dir = dev / 'plugin' / 'w3x2lni' / 'script'
    local command_line = ([=[
"%s" -E -e "package.cpath=[[%s]];package.path=[[%s;%s]]" "%s" "%s" %s %s]=]
    ):format(
        (root / 'bin' / 'lua.exe'):string(),
        (root / 'bin' / 'modules' / '?.dll'):string(),
        (current_dir / '?.lua'):string(),
        (current_dir / '?' / 'init.lua'):string(),
        (current_dir / 'gui' / 'mini.lua'):string(),
        mode,
        trans_command(map_path:string()),
        trans_command(target_path:string())
    )
    
    local proc, out_rd, err_rd, in_wr = sys.spawn_pipe('"'..(root / 'bin' / 'lua.exe '):string()..'"'..command_line, current_dir)
    if proc then
		local out = out_rd:read("*a")
		local err = err_rd:read("*a")
		local exit_code = proc:wait()
		proc:close()
		proc = nil
		return exit_code, out, err
	else
		return -1, nil, nil
	end
    
    --[==[
    local p = process()
    p:set_console 'disable'
    local stdout, stderr = p:std_output(), p:std_error()
    if not p:create(root / 'bin' / 'lua.exe', command_line, current_dir) then
        log.error(string.format("Executed %s failed", command_line))
        return false
    end
    log.trace(string.format("Executed %s.", command_line))
    local out = stdout:read 'a'
    local err = stderr:read 'a'
    local exit_code = p:wait()
    p:close()
    if err == '' then
        return true
    else
        log.error(err)
        return false
    end
    ]==]
end
