package cmd

import (
	"fmt"
	"os"
	"sdk/lib"
)

func Clear(sdkData lib.SdkData) {
	projectName := ProjectName(sdkData)
	distDir := sdkData.Temp + "/_dist"
	buildDir := sdkData.Temp + "/_build"
	testDir := sdkData.Temp + "/_test"
	modelDir := sdkData.Temp + "/_model"
	modelW3xDir := sdkData.Temp + "/_modelW3x"
	_ = os.RemoveAll(distDir)
	_ = os.RemoveAll(buildDir)
	_ = os.RemoveAll(testDir)
	_ = os.RemoveAll(modelDir)
	_ = os.RemoveAll(modelW3xDir)
	fmt.Println(`清理临时区完毕`)
	if projectName != "" {
		tempDir := sdkData.Temp + "/" + projectName
		_ = os.RemoveAll(tempDir)
		_ = os.Remove(tempDir + ".w3x")
		fmt.Println(`清理临时区完毕[` + projectName + `]`)
	}
}
