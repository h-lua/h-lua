require "sys"
require "filesystem"
require "util"

cjass = {}

cjass.path     = fs.ydwe_path() / "plugin" / "AdicHelper"
cjass.exe_path = cjass.path / "AdicHelper.exe"

-- 使用cJass编译地图
-- map_path - 地图路径，fs.path对象
-- option - 附加编译选项, table，支持选项为：
--	enable_jasshelper_debug - 启用Debug模式，true/false
--	runtime_version - 魔兽版本
-- 返回：true编译成功，false编译失败
function cjass.do_compile(self, map_path, option)
	local parameter = option.runtime_version:is_new() and " /v24" or " /v23"
					.. (option.enable_jasshelper_debug and " /dbg" or "")

	local command_line = string.format('"%s"%s /mappars="%s"',
		self.exe_path:string(),
		parameter,
		map_path:string()
	)
    --[==[
require "util"
require "mpq_util"
local storm = require 'ffi.storm'
local stormlib = require 'ffi.stormlib'
    stormlib.create(fs.ydwe_path() / 'logs' / 'temp.xj',2)
    mpq_util:update_file(map_path, "war3map.j",
			-- 解压缩地图脚本，处理然后写回
			function (map_handle, in_script_path)
				-- 开始处理

				return compile_t.output
			
		end)
    ]==]
	return sys.spawn(command_line, self.path, true)
end

function cjass.compile(self, map_path, option)	
	log.trace("CJass compilation start.")	
	local result = self:do_compile(map_path, option)
	
	if result then
		log.debug("CJass compilation succeeded.")
	else
		log.error("CJass compilation failed.")
	end

	return result
end
