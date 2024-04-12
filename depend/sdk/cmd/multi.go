package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"sdk/lib"
	"strconv"
	"time"
)

func runMulti(sdkData lib.SdkData, max int, cur int) {
	for i := cur; i <= max; i++ {
		cmd := exec.Command(sdkData.YDWE+"/bin/YDWEconfig.exe", "-launchwar3")
		_ = cmd.Run()
		fmt.Println("第" + strconv.Itoa(i) + "个魔兽尝试启动中")
	}
	ticker := time.NewTicker(time.Second)
	fmt.Println(<-ticker.C)
	exes := []string{"War3.exe", "war3.exe", "Frozen Throne.exe"}
	cur = lib.ExeRunningQty(exes)
	if cur >= max {
		fmt.Println("测试地图一般存放在 \\Warcraft III Frozen Throne\\Maps\\Test\\WorldEditTestMap.w3x ")
	} else {
		fmt.Println("部分启动失败，1秒后重试!!!")
		time.Sleep(time.Second)
		runMulti(sdkData, max, cur+1)
	}
}

func Multi(sdkData lib.SdkData) {
	max := 2
	if len(os.Args) == 3 {
		max, _ = strconv.Atoi(os.Args[2])
	}
	if max > 9 {
		max = 9
		fmt.Println("最大只支持9个客户端同时开启")
	}
	runMulti(sdkData, max, 1)
}
