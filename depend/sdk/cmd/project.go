package cmd

import (
	"sdk/lib"
)

func ProjectExist(sdkData lib.SdkData) bool {
	if len(sdkData.Args) < 3 {
		return false
	}
	projectName := sdkData.Args[2]
	if projectName[:1] == "_" {
		lib.Panic("项目名不合法(下划线“_”开始的名称已被禁用)")
	}
	projectDir := sdkData.Projects + "/" + projectName
	checkProject, _ := lib.IsDir(projectDir)
	return checkProject
}

func ProjectName(sdkData lib.SdkData) string {
	if sdkData.ProjectName != "" {
		return sdkData.ProjectName
	}
	if len(sdkData.Args) >= 3 {
		return sdkData.Args[2]
	}
	return ""
}
