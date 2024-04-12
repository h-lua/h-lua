package cmd

import (
	"fmt"
)

func Help() {
	fmt.Println("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("┃ *:带星号的是必须的")
	fmt.Println("┃ ~:带波浪的是可选的")
	fmt.Println("┃ sdk.exe new [:项目名] - 新建一个项目")
	fmt.Println("┃ sdk.exe we [:项目名] - 打开WE编辑地形")
	fmt.Println("┃ sdk.exe model [*项目名] [~页标:0] - 查看模型，289一页")
	fmt.Println("┃ sdk.exe clear [:项目名] - 清理缓存")
	fmt.Println("┃ sdk.exe multi [:数量] - 打开多个魔兽客户端")
	fmt.Println("┃ sdk.exe kill - 关闭所有魔兽客户端")
	fmt.Println("┃ sdk.exe test [:项目名] - 测试项目")
	fmt.Println("┃ sdk.exe build [:项目名] - 预编译项目")
	fmt.Println("┃ sdk.exe dist [:项目名] - 打包上线版本")
	fmt.Println("┃")
	fmt.Println("┃ @技术文档 https://h-lua.hunzsig.org")
	fmt.Println("┃ @支持作者 https://afdian.net/a/hunzsig")
	fmt.Println("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
}
