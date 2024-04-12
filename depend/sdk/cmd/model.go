package cmd

import (
	"fmt"
	"io/fs"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"sdk/lib"
	"strconv"
	"strings"
	"time"
)

var id int
var ids []string
var cvt36 string

func init() {
	id = 0
	cvt36 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

func modelID() string {
	numStr := ""
	if id == 0 {
		numStr = "0"
	} else {
		i := id
		for {
			ii := i % 36
			i = i / 36
			numStr = cvt36[ii:ii+1] + numStr
			if i == 0 {
				break
			}
		}
	}
	l := len(numStr)
	if l == 3 {
		numStr = "m" + numStr
	} else if l == 2 {
		numStr = "m0" + numStr
	} else if l == 1 {
		numStr = "m00" + numStr
	}
	id += 1
	ids = append(ids, numStr)
	return numStr
}

func Model(sdkData lib.SdkData) {
	tempDir := sdkData.Temp + "/_model"
	resourceDir := sdkData.Projects + "/" + ProjectName(sdkData) + "/map/resource"
	fmt.Println(resourceDir)
	page := 0
	filter := ""
	if len(os.Args) == 5 {
		filter = os.Args[3]
		p, ea := strconv.Atoi(os.Args[4])
		if ea != nil {
			page = 0
		} else {
			page = p
		}
	} else if len(os.Args) == 4 {
		p, ea := strconv.Atoi(os.Args[3])
		if ea != nil {
			filter = os.Args[3]
		} else {
			page = p
		}
	}
	fmt.Println("构建虚构第[" + strconv.Itoa(page) + "]批(每批最多289个模型)")
	if filter != "" {
		fmt.Println("只展示路径带有[" + filter + "]的模型")
	}
	// resourceDir
	_, err := lib.IsDir(resourceDir)
	if err != nil {
		lib.Panic(err)
	}
	_ = os.RemoveAll(tempDir)
	lib.CopyPath(sdkData.Depend+"/lni/map", tempDir+"/map")
	fmt.Println("构建临时区[map(w3x)->map]")
	lib.CopyPath(sdkData.Depend+"/lni/table", tempDir+"/table")
	fmt.Println("构建临时区[map(slk)->table]")
	lib.CopyPath(sdkData.Depend+"/lni/w3x2lni", tempDir+"/w3x2lni")
	fmt.Println("构建临时区[lni(w3x2lni)->w3x2lni]")
	lib.CopyFile(sdkData.Depend+"/lni/.w3x", tempDir+"/.w3x")
	fmt.Println("构建临时区[lni(.w3x)->.w3x]")
	lib.CopyFile(sdkData.Depend+"/models/w3i.ini", tempDir+"/table/w3i.ini")
	lib.CopyFile(sdkData.Depend+"/models/war3map.w3e", tempDir+"/map/war3map.w3e")
	lib.CopyFile(sdkData.Depend+"/models/war3map.mmp", tempDir+"/map/war3map.mmp")
	lib.CopyFile(sdkData.Depend+"/models/war3map.wmp", tempDir+"/map/war3map.wmp")
	lib.CopyFile(sdkData.Depend+"/models/war3map.shd", tempDir+"/map/war3map.shd")
	lib.CopyFile(sdkData.Depend+"/models/war3mapUnits.doo", tempDir+"/map/war3mapUnits.doo")

	resPath, _ := filepath.Abs(resourceDir)
	dstPath, _ := filepath.Abs(tempDir + "/resource")
	_ = os.RemoveAll(dstPath)

	unitIni := tempDir + "/table/unit.ini"
	unitIniContent := ""
	count := 0
	err = filepath.Walk(resourceDir, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".mdx" {
			// 过滤
			if filter != "" {
				if strings.Index(path, filter) == -1 {
					return nil
				}
			}
			if count >= page*289 && count < (page+1)*289 {
				mid := modelID()
				p := strings.Replace(path, resPath+"\\", "", -1)
				lib.CopyFile(path, dstPath+"/"+p)
				n := strings.Replace(p, ".mdx", "", -1)
				n = strings.Replace(n, "\\", "_", -1)
				p = strings.Replace(p, "\\", "\\\\", -1)
				unitIniContent += "\n\n[" + mid + "]\n_parent=\"nrwm\"\nfile=\"" + p
				unitIniContent += "\"\nName=\"" + mid + ":" + n + "\"\nTip=\"" + n + "\""
				unitIniContent += "\nfused=0\nunitShadow=\"\"\nfmade=0\nrace=\"human\"\nmoveHeight=70"
				if strings.Contains(n, "_item_") {
					unitIniContent += "\nmodelScale=2.0"
				} else if strings.Contains(n, "_eff_") {
					unitIniContent += "\nmodelScale=0.8"
				} else {
					unitIniContent += "\nmodelScale=1.0"
				}
				if id%17 == 0 {
					unitIniContent += "\nArt=\"ReplaceableTextures\\\\CommandButtons\\\\BTNFootman.blp\""
				}
			}
			count += 1
		} else if path[pLen-4:pLen] == ".blp" {
			p := strings.Replace(path, resPath+"\\", "", -1)
			lib.CopyFile(path, dstPath+"/"+p)
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}
	if id == 0 {
		fmt.Println("无模型符合要求，停止处理")
		return
	}
	t1 := time.Now()
	allP := strconv.FormatFloat(math.Ceil(float64(count)/289), 'f', 0, 64)
	fmt.Println("已处理 " + strconv.Itoa(id) + "[" + strconv.Itoa(page*289) + ":" + strconv.Itoa((page+1)*289-1) + "] 个模型，总共" + allP + "批")
	err = lib.FilePutContents(unitIni, unitIniContent, fs.ModePerm)
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("处理完成（" + time.Since(t1).String() + "）")

	t2 := time.Now()
	w3xFire := tempDir + "/model.w3x"
	cmd := exec.Command(sdkData.W3x2lni+"/w2l.exe", "obj", tempDir, w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	// 检查标志
	fmt.Println("模型图已生成（" + time.Since(t2).String() + "）")
	exes := []string{"worldeditydwe.exe", "YDWE.exe", "ydwe.exe"}
	if lib.ExeRunningQty(exes) > 0 {
		fmt.Println(">>>>>>> 请先处理并关闭当前YD编辑器!!! <<<<<<<")
		return
	}
	cmd = exec.Command(sdkData.YDWE+"/YDWE.exe", "-loadfile", w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("WE正在配图并打开:" + w3xFire)
}
