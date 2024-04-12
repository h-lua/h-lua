package cmd

import (
	"fmt"
	"os"
	"sdk/lib"
)

func Backup(sdkData lib.SdkData) {
	projectName := ProjectName(sdkData)
	// 生成备份w3x目录
	tempDir := sdkData.Temp + "/" + projectName
	w3xDir := sdkData.Projects + "/" + projectName + "/map/w3x"
	if lib.GetModTime(tempDir+"/map") > lib.GetModTime(w3xDir) {
		_ = os.RemoveAll(w3xDir)
		lib.CopyPath(tempDir+"/map", w3xDir)
		fmt.Println("备份完成[temp(地图备份)->map/w3x]")
	}
	resourceDir := sdkData.Projects + "/" + projectName + "/map/resource"
	if lib.GetModTime(tempDir+"/resource") > lib.GetModTime(resourceDir) {
		_ = os.RemoveAll(resourceDir)
		lib.CopyPath(tempDir+"/resource", resourceDir)
		fmt.Println("同步完成[temp(F12导入)->map/resource]")
	}
	slkDir := sdkData.Projects + "/" + projectName + "/map/slk"
	if lib.GetModTime(tempDir+"/table") > lib.GetModTime(slkDir) {
		_ = os.RemoveAll(slkDir)
		lib.CopyPath(tempDir+"/table", slkDir)
		fmt.Println("同步完成[temp(原生物编)->map/slk]")
	}
}
