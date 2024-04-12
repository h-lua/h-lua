package lib

import (
	"embed"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// GetFileInfo 判断文件或目录是否存在
func GetFileInfo(src string) os.FileInfo {
	if fileInfo, e := os.Stat(src); e != nil {
		if os.IsNotExist(e) {
			return nil
		}
		return nil
	} else {
		return fileInfo
	}
}

// CopyFile 拷贝文件
func CopyFile(src, dst string) bool {
	if len(src) == 0 || len(dst) == 0 {
		return false
	}
	if !IsFile(src) {
		return false
	}
	srcFile, e := os.OpenFile(src, os.O_RDONLY, fs.ModePerm)
	if e != nil {
		Panic(e.Error())
		return false
	}
	defer srcFile.Close()

	dst = strings.Replace(dst, "\\", "/", -1)
	dstPathArr := strings.Split(dst, "/")
	dstPathArr = dstPathArr[0 : len(dstPathArr)-1]
	dstPath := strings.Join(dstPathArr, "/")

	dstFileInfo := GetFileInfo(dstPath)
	if dstFileInfo == nil {
		if e := os.MkdirAll(dstPath, fs.ModePerm); e != nil {
			fmt.Print("\n" + dstPath + "\n")
			Panic(e.Error())
			return false
		}
	}
	// 这里要把O_TRUNC 加上，否则会出现新旧文件内容出现重叠现象
	dstFile, e := os.OpenFile(dst, os.O_CREATE|os.O_TRUNC|os.O_RDWR, fs.ModePerm)
	if e != nil {
		Panic(e.Error())
		return false
	}
	defer dstFile.Close()
	if _, e := io.Copy(dstFile, srcFile); e != nil {
		Panic(e.Error())
		return false
	} else {
		return true
	}

}

// CopyPath 拷贝目录
func CopyPath(src string, dst string) bool {
	srcFileInfo := GetFileInfo(src)
	if srcFileInfo == nil || !srcFileInfo.IsDir() {
		return false
	}
	var err error
	src, err = filepath.Abs(src)
	if err != nil {
		Panic(err)
	}
	err = filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		relationPath := strings.Replace(path, src, "/", -1)
		dstPath := strings.TrimRight(strings.TrimRight(dst, "/"), "\\") + relationPath
		if !info.IsDir() {
			if CopyFile(path, dstPath) {
				return nil
			} else {
				return errors.New(path + " copy fail")
			}
		} else {
			if _, err := os.Stat(dstPath); err != nil {
				if os.IsNotExist(err) {
					if err := os.MkdirAll(dstPath, fs.ModePerm); err != nil {
						return err
					} else {
						return nil
					}
				} else {
					return err
				}
			} else {
				return nil
			}
		}
	})
	if err != nil {
		Panic(err)
	}
	return true
}

func CopyEmbed(f embed.FS, src string, dst string) bool {
	b, err := f.ReadFile(src)
	if err != nil {
		return false
	}
	return nil == os.WriteFile(dst, b, fs.ModePerm)
}

// CopyPathEmbed 拷贝目录
// src有头无尾"/"
func CopyPathEmbed(f embed.FS, src string, dst string) bool {
	err := fs.WalkDir(f, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if strings.Index(path, src) == -1 {
			return nil
		}
		info, _ := d.Info()
		relationPath := strings.Replace(path, src, "/", -1)
		dstPath := strings.TrimRight(strings.TrimRight(dst, "/"), "\\") + relationPath
		if !info.IsDir() {
			b, fErr := f.ReadFile(path)
			if fErr != nil {
				return fErr
			}
			return os.WriteFile(dstPath, b, fs.ModePerm)
		} else {
			if _, err := os.Stat(dstPath); err != nil {
				if os.IsNotExist(err) {
					if err := os.MkdirAll(dstPath, fs.ModePerm); err != nil {
						return err
					} else {
						return nil
					}
				} else {
					return err
				}
			} else {
				return nil
			}
		}
	})
	if err != nil {
		Panic(err)
	}
	return true
}
