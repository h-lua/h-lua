package cmd

import (
	"fmt"
	"os/exec"
	"path/filepath"
	"sdk/lib"
)

func Kill(sdkData lib.SdkData) {
	bat, err := filepath.Abs(sdkData.YDWE + "/bin/kill.bat")
	if err != nil {
		lib.Panic(err)
	}
	cmd := exec.Command(bat)
	err = cmd.Run()
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("已尝试关闭所有魔兽客户端")
}
