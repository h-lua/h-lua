package cmd

import (
	"fmt"
	"io/fs"
	"os"
	"sdk/lib"
)

func New(sdkData lib.SdkData) {
	projectName := ProjectName(sdkData)
	if projectName == "" {
		lib.Panic("不可使用空名称")
	}
	if ProjectExist(sdkData) {
		lib.Panic("已存在同名项目，你可以输入“test " + projectName + "”命令直接测试，或者请使用其他名称")
	}
	var err error
	check, _ := lib.IsDir(sdkData.Temp)
	// 检查临时目录是否已经创建，没有创建则生成
	if !check {
		err = os.Mkdir(sdkData.Temp, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
	tempProjectDir := sdkData.Temp + "/" + projectName
	check, _ = lib.IsDir(tempProjectDir)
	// 检查临时项目目录是否已经创建，有则删除，没有创建则生成
	if check {
		_ = os.RemoveAll(tempProjectDir)
	} else {
		err = os.Mkdir(tempProjectDir, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
	// 复制初始文件
	lib.CopyPath(sdkData.Depend+"/lni", tempProjectDir)
	// 如果没有 projects 目录则生成一个
	check, _ = lib.IsDir(sdkData.Projects)
	if !check {
		err = os.Mkdir(sdkData.Projects, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
	// 生成项目目录
	projectDir := sdkData.Projects + "/" + projectName
	err = os.Mkdir(projectDir, fs.ModePerm)
	lib.CopyPathEmbed(sdkData.Embeds, "embeds/new", projectDir)
	// 生成备份w3x目录
	Backup(sdkData)
	fmt.Println("项目创建完成！")
	fmt.Println("你可以输入“we " + projectName + "”编辑地图信息")
	fmt.Println("或可以输入“test " + projectName + "”命令直接测试")
}
