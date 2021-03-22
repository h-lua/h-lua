# h-lua 魔獸地圖 開發集成環境

[![image](https://img.shields.io/badge/English-EN_US-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua-sdk/blob/main/README_EN-US.md)
[![image](https://img.shields.io/badge/正體中文-ZH_TW-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua-sdk/blob/main/README_ZH-TW.md)

![image](https://img.shields.io/badge/license-MIT-blue.svg)
[![image](https://img.shields.io/badge/doc-技術文檔-blue.svg)](http://wenku.hunzsig.org/?_=_6_34)
[![image](https://img.shields.io/badge/hLua-v2.alpha-orange.svg)](https://github.com/hunzsig-warcraft3/h-lua)
[![image](https://img.shields.io/badge/Author-hunzsig-red.svg)](https://www.hunzsig.com)
[![image](https://img.shields.io/badge/QQ-325338043-green.svg)](https://qm.qq.com/cgi-bin/qm/qr?k=NYlOpKUo9vEUQ3gN_UBvRUci9avq0tqB&jump_from=webapi)

### 結構
```
    ├── depend - 依賴的開發工具
    │   ├── h-lua - h-lua(v:latest，隨sdk更新的最新版)
    │   ├── w3x2lni - w3x2lni工具(v:2.7.2)
    │   └── YDWE - YDWE,附帶japi及部分dzapi
    ├── projects - 用來放置你的地圖項目目錄，如 h-lua-sdk-helloworld
    └── sdk.exe - 編譯好的開發命令工具
```
> [h-lua-sdk-helloworld](https://github.com/hunzsig-warcraft3/h-lua-sdk-helloworld)

### 項目目錄用來放置地圖項目
> 一個正規的項目應該包括以下結構
```
    └── project_demo - 項目目錄
        ├── hslk - 用來編寫 hslk lua 物編配置
        ├── jass - 自定義jass（不是完整的jass，僅供有限的片段定義，請看參考文件示例）
        │   ├── globals.jass
        │   └── function.jass
        ├── map - 地圖文件
        │   ├── implant - 用來強製更新替換【DZUI佈局、命令位置、平衡性常數、原生UI、字体】參數
        │   ├── resource - F12導入
        │   │   ├── hLua - h-lua需要的資源文件，請不要亂刪除
        │   │   ├── interface - 冷卻時間UI，不需要可刪除，然後需要修改 implant/war3mapSkin.txt
        │   │   ├── ReplaceableTextures
        │   │   ├── TerrainArt - 地形貼圖，不需要可直接刪除
        │   │   │   ├── Cliff - 懸崖貼圖，不需要可直接刪除
        │   │   │   ├── CommandButtonsDisabled - 暗圖示目錄
        │   │   │   └── selection - 選擇圈，不需要可直接刪除
        │   │   ├── UI - 命令等係統圖形的修改（不包括dzui）不需要可刪除，然後需要修改 implant/war3mapSkin.txt
        │   │   ├── war3mapImported - 通用目錄
        │   │   └── war3mapMap.blp - 小地圖文件，一般不會手動處理，交給 -yd
        │   ├── slk - ini式的物編
        │   └── w3x - 地圖lni
        ├── scripts - lua腳本（*此乃建議，實際上你的lua隻要在項目目錄內，都能按路徑訪問）
        └── main.lua - 項目代碼入口
```
> 如果你不確定項目結構的準確性，可使用new命令新建一個項目來參考
```
./h-lua-sdk> sdk.exe new [:PROJECT_NAME]
```

### 命令行
```
* 必填 ~ 選填
./h-lua-sdk> sdk.exe help  //提示cmd工具命令
./h-lua-sdk> sdk.exe new [*PROJECT_NAME]  //新建一個地圖項目
./h-lua-sdk> sdk.exe ydwe [*PROJECT_NAME]  //以YDWE打開地圖項目
./h-lua-sdk> sdk.exe clear [*PROJECT_NAME]  //清理構建的臨時文件
./h-lua-sdk> sdk.exe test [*PROJECT_NAME]  //構建測試版本並開啓遊戲進行調試
./h-lua-sdk> sdk.exe build [*PROJECT_NAME]  //構建上線版本並開啓遊戲進行調試
```

### 命令行的縮寫版
```
* 必填 ~ 選填
./h-lua-sdk> sdk.exe -h  //提示cmd工具命令
./h-lua-sdk> sdk.exe -n [*PROJECT_NAME]  //新建一個地圖項目
./h-lua-sdk> sdk.exe -we|-yd [*PROJECT_NAME]  //以YDWE打開地圖項目
./h-lua-sdk> sdk.exe -c [*PROJECT_NAME]  //清理構建的臨時文件
./h-lua-sdk> sdk.exe -t [*PROJECT_NAME]  //構建測試版本並開啓遊戲進行調試
./h-lua-sdk> sdk.exe -b [*PROJECT_NAME]  //構建上線版本並開啓遊戲進行調試
```
