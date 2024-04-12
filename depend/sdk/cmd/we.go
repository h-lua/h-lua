package cmd

import (
	"fmt"
	"os/exec"
	"sdk/lib"
)

func WE(sdkData lib.SdkData) {
	projectName := ProjectName(sdkData)
	if !ProjectExist(sdkData) {
		lib.Panic("项目" + projectName + "不存在")
	}
	w3xDir := sdkData.Temp + "/" + projectName
	w3xFire := sdkData.Temp + "/" + projectName + ".w3x"
	buoyFire := sdkData.Temp + "/" + projectName + "/.ydwe"
	mtW := lib.GetModTime(w3xFire)
	mtB := lib.GetModTime(buoyFire)
	if mtW > mtB {
		// 如果地图文件比yd打开时新（说明有额外保存过）把保存后的文件拆包并同步
		cmd := exec.Command(sdkData.W3x2lni+"/w2l.exe", "lni", w3xFire)
		_, err := cmd.Output()
		if err != nil {
			lib.Panic(err)
		}
		lib.CopyFile(sdkData.Depend+"/lni/.ydwe", buoyFire)
		Backup(sdkData) // 以编辑器为主版本
		fmt.Println("同步完毕[检测到有新的地图保存行为，以‘YDWE’为主版本]")
	}
	//
	Pickup(sdkData)
	cmd := exec.Command(sdkData.W3x2lni+"/w2l.exe", "obj", w3xDir, w3xFire)
	_, err := cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	lib.CopyFile(sdkData.Depend+"/lni/.ydwe", buoyFire)
	exes := []string{"worldeditydwe.exe", "YDWE.exe", "ydwe.exe"}
	if lib.ExeRunningQty(exes) > 0 {
		fmt.Println(">>>>>>> 请先处理并关闭当前WE!!! <<<<<<<")
		return
	}
	cmd = exec.Command(sdkData.YDWE+"/YDWE.exe", "-loadfile", w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("YD编辑器正在配图并打开")
}
