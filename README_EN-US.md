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
> [h-lua-sdk-helloworld](https://github.com/hunzsig-warcraft3/h-lua-sdk-helloworld)

### The projects directory is used to place map projects
> A formal project should include the following structure.
```
    └── project_demo - root dir
        ├── hslk
        ├── jass - your custom jass(not real jass,just for defind. * look default example）
        │   ├── globals.jass
        │   └── function.jass
        ├── map
        │   ├── implant DZUI、CommandUI、BalanceUI、OriginUI、ttf
        │   ├── resource - F12
        │   │   ├── hLua -  h-lua required! Don't remove!
        │   │   ├── interface -  cooldown UI.No need to delete and modify implant/war3mapSkin.txt
        │   │   ├── ReplaceableTextures
        │   │   ├── TerrainArt - No need to delete directly.
        │   │   │   ├── Cliff - No need to delete directly.
        │   │   │   ├── CommandButtonsDisabled - Dark icons.
        │   │   │   └── selection - SelectionUI. No need to delete directly.
        │   │   ├── UI - SystemUI(Excluding dzui).No need to delete and modify implant/war3mapSkin.txt
        │   │   ├── war3mapImported - Common import.
        │   │   └── war3mapMap.blp - Small map file, which is not handled manually, is handed over to "-yd"
        │   ├── slk - ini
        │   └── w3x - ini
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
./h-lua-sdk> sdk.exe ydwe [:PROJECT_NAME] - open map by YDWE
./h-lua-sdk> sdk.exe model [*PROJECT_NAME] [~PAGE CUR:0] - view models by YDWE, one page support 289 models
./h-lua-sdk> sdk.exe clear [:PROJECT_NAME] - clear temp
./h-lua-sdk> sdk.exe test [:PROJECT_NAME] - test a project
./h-lua-sdk> sdk.exe build [:PROJECT_NAME] - build a project for launch
```

## CMD(Short for)
```
*required ~optional
./h-lua-sdk> sdk.exe -h
./h-lua-sdk> sdk.exe -n [:PROJECT_NAME] - new a project
./h-lua-sdk> sdk.exe -we|-yd [:PROJECT_NAME] - open map by YDWE
./h-lua-sdk> sdk.exe model [*PROJECT_NAME] [~PAGE CUR:0] - view models by YDWE, one page support 289 models
./h-lua-sdk> sdk.exe -c [:PROJECT_NAME] - clear temp
./h-lua-sdk> sdk.exe -t [:PROJECT_NAME] - test a project
./h-lua-sdk> sdk.exe -b [:PROJECT_NAME] - build a project for launch
```
