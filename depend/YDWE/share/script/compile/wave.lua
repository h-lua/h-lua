require "sys"
require "filesystem"
require "util"

local root = fs.ydwe_path():parent_path():remove_filename():remove_filename() / "Component"
if not fs.exists(root) then
	root = fs.ydwe_path()
end

wave = {}
wave.path                = fs.ydwe_path() / "plugin" / "wave"
wave.exe_path            = wave.path / "Wave.exe"
wave.sys_include_path    = wave.path / "include"
wave.plugin_include_path = fs.ydwe_path() / "plugin"
wave.jass_include_path   = root / "jass"
wave.force_file_path     = wave.sys_include_path / "WaveForce.i"

local function pathstring(path)
	local str = path:string()
	if str:sub(-1) == '\\' then
		return '"' .. str .. ' "'
	else
		return '"' .. str .. '"'
	end
end
xT={} --可用字符集
for i=1,26 do
  table.insert(xT,string.char(64+i))
  table.insert(xT,string.char(123-i))
end
function Xg_char_true(c)
 local n = c:byte()
 return (n>64 and n<91) or (n>96 and n<123) or (n>47 and n<58) or c=='_'
end
function trim(s)   
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))  
end  
function Xg_GetNewUdg()
  local n =#xT
  local s,x,t=0,1,''
  for i=1,#xI do
    if x>0 then --进值数
      if xI[i]+x <= n then
        xI[i] = xI[i] + x
        x=0
      else
        s=(x+xI[i]) % n --余数
        x=math.floor((x+xI[i]) / n) --进位
        xI[i]=s
      end
    end
    t=t..xT[xI[i]]
  end
  return t
end
function XG_udg_chs(g)
   local v
   local i,w=0,{}
   while i<#g do
     i=i+1
     v=false
     g[i]=trim(g[i])
     for n=1,#g[i] do
       if not Xg_char_true(g[i]:sub(n,n)) then
         v=true --中文变量
         break
       end
     end
     if v then
       table.insert(w,'xgdg_'..Xg_GetNewUdg())
       log.trace(w[#w]..'>>replace>>'..g[i]..'')
     else
       table.remove(g,i)
       i=i-1
     end
   end
   for n=2,#g do
     for j=1,#g do
       if g[n]:len() > g[j]:len() and n>j then
         table.insert(g,j,g[n])
         table.remove(g,n+1)
         table.insert(w,j,w[n])
         table.remove(w,n+1)
         break
       end
     end
   end
   log.trace("Xueyue Udg chs done!!!.")		
   return g,w
end
function XG_Global_Deal(t)
 local str,s=''
 for i=1,#t do
   s=0
   str=t[i]
   t[i]=''
   for j=1,str:len() do
     if s~=0 then
       if str:sub(j,j)=='=' or str:sub(j,j)=='\r' or str:sub(j,j)=='\n' then
			t[i]=trim(t[i])
			break
       end
       t[i]=t[i]..str:sub(j,j)
     elseif str:sub(j,j+3)=='udg_' then
       s = j
       t[i]=t[i]..str:sub(j,j)
     end
   end
 end
 log.trace("Xueyue Global deal finish!!!")		
 return t
end
function Hc_GetGlobal(j)
  local t,i,w,id = {},0,false,1
  local max,s1,s2=j:len()-7
  local st,ed = false,false
  table.insert(t,'')
  while i<max do
    i = i + 1
    if st then --全局区域开始
		  if  j:sub(i,i+9) == 'endglobals' then --结束
				t[#t]=nil
				break
		  else
				s1=j:sub(i,i) 
				s2=j:sub(i,i+1)
				if s2 == '\r\n' or s1=='\r' or s1=='\n' then
					  if s2 == '\r\n' then
						i = i + 1
					  end
					  if w then
						
						table.insert(t,'')
						w=false
					  end
				else
					 w=true
					 t[#t]=t[#t]..s1
				end
		  end
    elseif j:sub(i,i+6) == 'globals' then
		  st = true
		  i=i+6
    end
  end
  log.trace("Xueyue Global Num: "..tostring(#t))
  return XG_Global_Deal(t)
end


function Hc_XG_BxL(jass)
	local g,w = Hc_GetGlobal(jass) --表
	xI={} --长度
	for i=1,tostring(#g):len() do 
		if i==1 then
			table.insert(xI,0)
		else
			table.insert(xI,1)
		end
	end
	g,w=XG_udg_chs(g)
	for i=1,#g do
		jass = jass:gsub(g[i],w[i])
	end
	return jass
end
-- 预处理代码
-- op.input - 输入文件路径
-- op.option - 预处理选项，table，支持的值有
-- 	runtime_version - 表示魔兽版本
-- 	enable_jasshelper_debug - 布尔值，是否是调试模式
--	enable_yd_trigger - 布尔值，是否启用YD触发器
-- 返回：number, info, path - 子进程返回值；预处理输出信息；输出文件路径
function wave:do_compile(op)
	local cmd = ''
	cmd = cmd .. '--autooutput '
	cmd = cmd .. string.format('--sysinclude=%s ', pathstring(self.sys_include_path))
	cmd = cmd .. string.format('--sysinclude=%s ', pathstring(self.plugin_include_path))
	cmd = cmd .. string.format('--include=%s ',    pathstring(op.map_path:parent_path()))
	cmd = cmd .. string.format('--include=%s ',    pathstring(self.jass_include_path))
    
	cmd = cmd .. string.format('--define=WARCRAFT_VERSION=%d ', 100 * op.option.runtime_version.major + op.option.runtime_version.minor)
	cmd = cmd .. string.format('--define=YDWE_VERSION_STRING=\\"%s\\" ', tostring(ydwe_version))
	if op.option.enable_jasshelper_debug then
		cmd = cmd .. '--define=DEBUG=1 '
	end
	if tonumber(global_config["ScriptInjection"]["Option"]) == 0 then
		cmd = cmd .. "--define=SCRIPT_INJECTION=1 "
	end
	if not op.option.enable_yd_trigger then
		cmd = cmd .. '--define=DISABLE_YDTRIGGER=1 '
	end
	if fs.exists(self.force_file_path) then
		cmd = cmd .. string.format('--forceinclude=%s ', self.force_file_path:filename():string())
	end
	cmd = cmd .. "--extended --c99 --preserve=2 --line=0 "
	----------------------
		local f=io.open(op.input,"a+b")
		local jass = Hc_XG_BxL(f:read("*a"))
		f:close()
		local t={
			"XG_AutoAttr_SetClassA",
			"XG_AutoAttr_AddAttrA",
			"XG_AutoAttr_StartA",
			"XG_AutoAttr_GetAttrNum",
			"XG_AutoAttr_GetAttrKey",
			"XG_AutoAttr_GetAttrVal"
		}
		for i=1,#t do
			local s,q =  jass:find(t[i])
			if s then
				s,q = jass:find("endglobals")
				j=io.open(wave.jass_include_path /"XueYue"/"SystemLibs"/"AutoGetAttr.j","a+b")
				jass = jass:sub(1,q).."\r\n"..j:read("*a")..jass:sub(q+1,jass:len())
				--jass = '#include "XueYue\\SystemLibs\\AutoGetAttr.j"\r\n'..jass
				j:close()
				break
			end
		end
		local t={
			"XG_GetHeroMainAttr"
		}
		for i=1,#t do
			local s,q =  jass:find(t[i])
			if s then
				s,q = jass:find("endglobals")
				j=io.open(wave.jass_include_path /"XueYue"/"Calls"/"GetHeroMainAttr.j","a+b")
				jass = jass:sub(1,q).."\r\n"..j:read("*a")..jass:sub(q+1,jass:len())
				j:close()
				break
			end
		end
		local t={
			"XG_StrFormat_Reg",
			"XG_StrFormat_Do"
		}
		for i=1,#t do
			local s,q =  jass:find(t[i])
			if s then
				s,q = jass:find("endglobals")
				require(  'compile.XGStrFormat' )
				--j=io.open(wave.jass_include_path /"XueYue"/"MiniSystem"/"StrFormat.j","a+b")
				--jass = jass:sub(1,q).."\r\n"..j:read("*a")..jass:sub(q+1,jass:len())
				jass = jass:gsub("XG_StrFormat_Reg%(%s*(.-)%s*,%s*(.-)%s*%)\r\n",
						function(x,y)
						local z = ",false"
						A=x
						B=y
						if y:sub(1,1)~='"' then y='"'..y..'"'  z=",true" end
						return load("return XG_StrFormat_Reg_Lua(A,B"..z..")")()..'\r\n'
				end)
				jass = jass:gsub("XG_StrFormat_Do%(%s*(.-)%s*,%s*(.-)%s*%)",
						function(x,y)
						A=x
						B=y
						return load("return XG_StrFormat_Do_Lua(A,B)")()
				end)
				--jass = jass:gsub('"'','"')
				--XG_StrFormat_Do_Lua
				--j:close()
				local strft = true
				break
			end
		end

	local command_line = string.format('%s %s %s', pathstring(self.exe_path), cmd, pathstring(op.input))
	-- 启动进程
	local proc, out_rd, err_rd, in_wr = sys.spawn_pipe(command_line, nil)
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
end

function wave:compile(op)
	log.trace("Wave compilation start.")		
	
	local map_script_file = io.open(op.input, "a+b")
	if map_script_file then
		map_script_file:write("/**/\r\n")
		map_script_file:close()
	end
	
	-- 输出路径
	op.output = op.input:parent_path() / (op.input:stem():string() .. ".i")
	
	local exit_code, out, err = self:do_compile(op)
	
	-- 退出码0代表成功
	if exit_code ~= 0 then
		if out and err then
			gui.error_message(nil, _("Preprocessor failed with message:\nstdout:%s\nstderr: %s"), out, err)
		else
			gui.error_message(nil, _("Cannot start preprocessor process."))
		end
		return false
	end

	return true
end
