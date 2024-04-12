package cmd

import (
	"fmt"
	"io/fs"
	"os"
	"sdk/lib"
)

func Pickup(sdkData lib.SdkData) {
	projectName := ProjectName(sdkData)
	tempDir := sdkData.Temp + "/" + projectName
	mapDir := sdkData.Projects + "/" + projectName + "/map"
	// 构建项目目录
	check, err := lib.IsDir(mapDir + "/slk")
	if !check {
		_ = os.Mkdir(mapDir+"/table", fs.ModePerm)
	}
	check, _ = lib.IsDir(mapDir + "/resource")
	if !check {
		_ = os.Mkdir(mapDir+"/resource", fs.ModePerm)
	}
	// 检查是否存在temp
	check, err = lib.IsDir(tempDir)
	if err != nil {
		check = false
	}
	if check == false {
		// 没有则构建新的temp
		check, err = lib.IsDir(mapDir + "/w3x")
		if err != nil {
			lib.Panic(err)
		}
		lib.CopyPath(mapDir+"/w3x", tempDir+"/map")
		fmt.Println("构建临时区[map(w3x)->map]")
		lib.CopyPath(mapDir+"/slk", tempDir+"/table")
		fmt.Println("构建临时区[map(slk)->table]")
		lib.CopyPath(mapDir+"/resource", tempDir+"/resource")
		fmt.Println("构建临时区[map(resource)->resource]")
		lib.CopyPath(sdkData.Depend+"/lni/w3x2lni", tempDir+"/w3x2lni")
		fmt.Println("构建临时区[lni(w3x2lni)->w3x2lni]")
		lib.CopyFile(sdkData.Depend+"/lni/.w3x", tempDir+"/.w3x")
		fmt.Println("构建临时区[lni(.w3x)->.w3x]")
		return
	}
	// map
	_ = os.RemoveAll(tempDir + "/map/")
	lib.CopyPath(mapDir+"/w3x", tempDir+"/map")
	fmt.Println("覆盖同步[map(w3x)->map]")
	// 有则不构建新的temp，检查项目的文件是否比temp的新，新则替换掉temp的
	if lib.GetModTime(mapDir+"/resource") > lib.GetModTime(tempDir+"/resource") {
		_ = os.RemoveAll(tempDir + "/resource")
		lib.CopyPath(mapDir+"/resource", tempDir+"/resource")
		fmt.Println("更新同步[map(resource)->resource]")
	}
	if lib.GetModTime(mapDir+"/slk") > lib.GetModTime(tempDir+"/table") {
		_ = os.RemoveAll(tempDir + "/table")
		lib.CopyPath(mapDir+"/slk", tempDir+"/table")
		fmt.Println("更新同步[map(slk)->table]")
	}
}
