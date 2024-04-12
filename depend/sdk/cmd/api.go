package cmd

import (
	"fmt"
	"io/fs"
	"path/filepath"
	"regexp"
	"sdk/lib"
	"strings"
)

func Api(sdkData lib.SdkData) {
	hLua, _ := filepath.Abs(sdkData.HLua)
	fmt.Println("正在生成hLuaApi文档：" + hLua)
	var apiStr []string
	err := filepath.Walk(hLua, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".lua" {
			fstr, _ := lib.FileGetContents(path)
			reg, _ := regexp.Compile("(.*?)=(.*)function\\((.*)\\)|function (.*)\\((.*)\\)")
			all := reg.FindAllString(fstr, -1)
			if len(all) > 0 {
				apiStr = append(apiStr, " * [L]**"+strings.Replace(path, hLua+"\\", "", -1)+"**")
				apiStr = append(apiStr, "```")
				for _, v := range all {
					if v[:1] == " " {
						continue
					}
					if v[:10] == "function |" {
						continue
					}
					if strings.Index(v, " = function") > -1 {
						v = strings.Replace(v, " = function", "", -1)
					} else if strings.Index(v, "function ") > -1 {
						v = strings.Replace(v, "function ", "", -1)
					}
					apiStr = append(apiStr, v)
				}
				apiStr = append(apiStr, "```")
			} else {
				apiStr = append(apiStr, " * [B]"+strings.Replace(path, hLua+"\\", "", -1))
			}
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}
	doc := sdkData.Pwd + "/API.md"
	err = lib.FilePutContents(doc, strings.Join(apiStr, "\n"), fs.ModePerm)
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("已生成hLuaApi文档：" + doc)
}
