package lib

import (
	"embed"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

//go:embed embeds
var embedFS embed.FS

type SdkData struct {
	CWar3       string
	CWeBuild    string
	Pwd         string
	Depend      string
	Projects    string
	Temp        string
	HLua        string
	W3x2lni     string
	YDWE        string
	Args        []string
	ProjectName string
	Embeds      embed.FS
}

var (
	sdkData SdkData
)

func GetSdkData() SdkData {
	if sdkData.Pwd == "" {
		if IsFile("./sdk.conf") {
			c, err := os.ReadFile("./sdk.conf")
			if err != nil {
				Panic(err)
			}
			content := string(c)
			reg, _ := regexp.Compile("#(.*)")
			content = reg.ReplaceAllString(content, "")
			content = strings.Replace(content, "\r\n", "\n", -1)
			content = strings.Replace(content, "\r", "\n", -1)
			split := strings.Split(content, "\n")
			conf := make(map[string]string)
			for _, iniItem := range split {
				if len(iniItem) > 0 {
					itemSplit := strings.Split(iniItem, "=")
					itemKey := strings.Trim(itemSplit[0], " ")
					itemKey = strings.ToLower(strings.Trim(itemSplit[0], " "))
					conf[itemKey] = strings.Trim(itemSplit[1], " ")
				}
			}
			if conf["root"] != "" {
				sdkData.Pwd = conf["root"]
			}
			if conf["war3"] != "" {
				sdkData.CWar3 = conf["war3"]
			}
			if conf["we_build"] != "" {
				sdkData.CWeBuild = conf["we_build"]
			}
		}
		if sdkData.Pwd == "" {
			sdkData.Pwd, _ = os.Getwd()
		}
		sdkData.Pwd, _ = filepath.Abs(sdkData.Pwd)
		sdkData.Depend = sdkData.Pwd + "/depend"
		sdkData.Projects = sdkData.Pwd + "/projects"
		sdkData.Temp = sdkData.Pwd + "/temp"
		sdkData.HLua = sdkData.Depend + "/h-lua"
		sdkData.W3x2lni = sdkData.Depend + "/w3x2lni"
		if sdkData.YDWE == "" {
			sdkData.YDWE = sdkData.Depend + "/YDWE"
		}
		sdkData.Embeds = embedFS
		sdkData.Args = os.Args
	}
	return sdkData
}
