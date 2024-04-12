package cmd

import (
	"fmt"
	"io/fs"
	"path/filepath"
	"regexp"
	"sdk/lib"
	"strings"
)

// 处理 war3map.j 文件
func war3mapJ(sdkData lib.SdkData, createSrc string) {
	war3mapJass := sdkData.Temp + "/" + createSrc + "/map/war3map.j"
	if lib.IsFile(war3mapJass) {
		war3mapContent, _ := lib.FileGetContents(war3mapJass)
		execContent := "call InitGlobals()\n    call Cheat(\"exec-lua:\\\"h-lua-cli\\\"\")"
		reg, _ := regexp.Compile("call InitGlobals\\(\\)")
		war3mapContent = reg.ReplaceAllString(war3mapContent, execContent)
		// merge
		err := lib.FilePutContents(war3mapJass, war3mapContent, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
}

func war3Lua(sdkData lib.SdkData, createSrc string) {
	projectName := ProjectName(sdkData)
	tmpMapDir := sdkData.Temp + "/" + createSrc + "/map"
	fmt.Println("请稍候...")
	if createSrc == "_test" {
		lib.CopyFile(sdkData.HLua+"/builtIn/console/test.lua", tmpMapDir+"/h-lua-console.lua")
	} else if createSrc == "_build" {
		lib.CopyFile(sdkData.HLua+"/builtIn/console/build.lua", tmpMapDir+"/h-lua-console.lua")
	} else if createSrc == "_dist" {
		lib.CopyFile(sdkData.HLua+"/builtIn/console/dist.lua", tmpMapDir+"/h-lua-console.lua")
	}
	cliFile := tmpMapDir + "/h-lua-cli.lua"
	lib.CopyEmbed(sdkData.Embeds, "embeds/slk/cli.lua", cliFile)
	cliLuaC, _ := lib.FileGetContents(cliFile)

	// <Require>
	var requireStr []string

	// hl-const\foundation
	hluaLibs := []string{"const", "foundation"}
	for _, l := range hluaLibs {
		lp := sdkData.HLua + "/" + l
		is, _ := lib.IsDir(lp)
		if is {
			lp, _ = filepath.Abs(lp)
			err := filepath.Walk(lp, func(path string, info fs.FileInfo, err error) error {
				if err != nil {
					return err
				}
				pLen := len(path)
				if path[pLen-4:pLen] == ".lua" {
					requireRelation := strings.Replace(path, lp, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireStr = append(requireStr, "require '"+l+"."+requireRelation+"'")
				}
				return nil
			})
			if err != nil {
				lib.Panic(err)
			}
		}
	}

	// hl-slk
	hlSlkDir := tmpMapDir + "/h-lua-slk"
	hlSlkDir, _ = filepath.Abs(hlSlkDir)
	lib.CopyPath(sdkData.HLua+"/slk", hlSlkDir)
	err := filepath.Walk(hlSlkDir, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".lua" {
			requireRelation := strings.Replace(path, hlSlkDir, "", 1)
			requireRelation = requireRelation[1:]
			requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
			requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
			requireRelation = strings.Replace(requireRelation, "/", ".", -1)
			requireStr = append(requireStr, "require 'h-lua-slk."+requireRelation+"'")
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}
	// project
	proDir := sdkData.Projects + "/" + projectName
	hasSlk, _ := lib.IsDir(proDir + "/hslk")
	if hasSlk {
		projectSlkDir := tmpMapDir + "/project-slk"
		projectSlkDir, _ = filepath.Abs(projectSlkDir)
		lib.CopyPath(proDir+"/hslk", projectSlkDir)
		err = filepath.Walk(projectSlkDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			pLen := len(path)
			if path[pLen-4:pLen] == ".lua" {
				requireRelation := strings.Replace(path, projectSlkDir, "", 1)
				requireRelation = requireRelation[1:]
				requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
				requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
				requireRelation = strings.Replace(requireRelation, "/", ".", -1)
				requireStr = append(requireStr, "require 'project-slk."+requireRelation+"'")
			}
			return nil
		})
		if err != nil {
			lib.Panic(err)
		}
	}
	cliLuaC = strings.Replace(cliLuaC, "HLUA_CLI_REQUIRE = 20220518", strings.Join(requireStr, "\n"), 1)
	if createSrc == "_test" {
		testHead := "package.path = package.path .. \";" + strings.Replace(sdkData.HLua, "\\", "/", -1) + "/?.lua\"\n"
		testHead += "package.path = package.path .. \";" + strings.Replace(sdkData.Projects, "\\", "/", -1) + "/" + projectName + "/?.lua\"\n"
		cliLuaC = testHead + cliLuaC
		_ = lib.FilePutContents(cliFile, cliLuaC, fs.ModePerm)
	} else if createSrc == "_build" || createSrc == "_dist" {
		_ = lib.FilePutContents(cliFile, cliLuaC, fs.ModePerm)
		lib.CopyFile(proDir+"/main.lua", tmpMapDir+"/main.lua")
		lib.CopyPath(proDir+"/scripts", tmpMapDir+"/scripts")
		fmt.Println("Lua(项目：" + projectName + ")已全部打包！")
		lib.CopyPath(sdkData.HLua+"/const", tmpMapDir+"/const")
		lib.CopyPath(sdkData.HLua+"/foundation", tmpMapDir+"/foundation")
		lib.CopyPath(sdkData.HLua+"/lib", tmpMapDir+"/lib")
		lib.CopyPath(sdkData.HLua+"/builtIn", tmpMapDir+"/builtIn")
		lib.CopyFile(sdkData.HLua+"/h-lua.lua", tmpMapDir+"/h-lua.lua")
		fmt.Println("Lua(框架：h-lua)已全部打包！")
	}
}

func War3(sdkData lib.SdkData, target string) {
	war3mapJ(sdkData, target)
	war3Lua(sdkData, target)
	Lua(sdkData, target)
}
