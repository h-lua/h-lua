# h-lua in SDK

[![image](https://img.shields.io/badge/简体中文-ZH_CN-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua-sdk/blob/main/README.md)
[![image](https://img.shields.io/badge/繁体中文-ZH_TW-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua-sdk/blob/main/README_ZH-TW.md)

![image](https://img.shields.io/badge/license-MIT-blue.svg)
[![image](https://img.shields.io/badge/doc-document-blue.svg)](http://wenku.hunzsig.org/?_=_6_34)
[![image](https://img.shields.io/badge/hLua-v2.alpha-orange.svg)](https://github.com/hunzsig-warcraft3/h-lua)
[![image](https://img.shields.io/badge/Author-hunzsig-red.svg)](https://www.hunzsig.com)
![image](https://img.shields.io/badge/Email-mzyhaohaoren@qq.com-yellow.svg)

## Structure

```
    ├── depend
    │   ├── h-lua - h-lua framework(v:latest)
    │   ├── w3x2lni - w3x2lni(v:2.7.2)
    │   └── YDWE - YDWE editor
    ├── projects - your maps, ex: h-lua-sdk-helloworld
    └── sdk.exe
```

* [docs]http://wenku.hunzsig.org/?_=_6_34
* [demo]HelloWorld https://github.com/hunzsig-warcraft3/h-lua-sdk-helloworld
* [demo]MysteriousLand https://github.com/hunzsig-warcraft3/h-lua-sdk-mysterious-land
* [test]Crash https://github.com/hunzsig-warcraft3/h-lua-sdk-crash

### The projects directory is used to place map projects

> A formal project should include the following structure.

```
    └── project_demo - root dir
        ├── hslk[Writing business code is not recommended]
        ├── map
        │   ├── resource - F12
        │   │   ├── hLua -  h-lua required! Don't remove!
        │   │   ├── ReplaceableTextures
        │   │   │   ├── Cliff - with TerrainArt,No need to delete directly.
        │   │   │   ├── CommandButtonsDisabled - DIS dark icons
        │   │   │   └── selection - No need to delete directly.
        │   │   ├── TerrainArt - No need to delete directly.
        │   │   ├── UI - SystemUI(Excluding dzui).No need to delete and modify implant/war3mapSkin.txt
        │   │   ├── war3mapImported - Common import.
        │   │   └── war3mapMap.blp - Small map file, which is not handled manually, is handed over to "-yd"
        │   ├── slk - ini
        │   └── w3x - 地图lni
        │       ├── UI - fdf UI files
        │       ├── units
        │       │   └── CommandFunc.txt - Buttons position, attack,stop,etc.(modifiable)
        │       ├── fonts.ttf - font file (modifiable with war3mapSkin.txt)
        │       ├── war3mapSkin.txt - game UI(modifiable)
        │       └── other(Don't modify them)
        ├── scripts - lua scripts(It's just a suggestion)
        └── main.lua - Enter
```

> If you are not sure about the accuracy of the project structure, use the new command to create a new project for reference.

```
./h-lua-sdk> sdk.exe new [:PROJECT_NAME]
```

## CMD

```
*required ~optional
./h-lua-sdk> sdk.exe help
./h-lua-sdk> sdk.exe new [:PROJECT_NAME] - new a project
./h-lua-sdk> sdk.exe we [:PROJECT_NAME] - open map by YDWE
./h-lua-sdk> sdk.exe model [*PROJECT_NAME] [~PAGE:0|~search:''] - view models in WE, one page support 289 models
./h-lua-sdk> sdk.exe clear [:PROJECT_NAME] - clear temp
./h-lua-sdk> sdk.exe test [:PROJECT_NAME] - test a project
./h-lua-sdk> sdk.exe build [:PROJECT_NAME] - build a project for launch
```

### Model command extension

```
./h-lua-sdk> sdk.exe model demo
./h-lua-sdk> sdk.exe model demo 2
./h-lua-sdk> sdk.exe model demo ttg
./h-lua-sdk> sdk.exe model demo abc 1
```