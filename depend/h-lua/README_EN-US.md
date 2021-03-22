# H-Lua

[![image](https://img.shields.io/badge/english-EN_US-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua/blob/main/README_EN-US.md)
![image](https://img.shields.io/badge/license-MIT-blue.svg)
[![image](https://img.shields.io/badge/doc-document-blue.svg)](http://wenku.hunzsig.org/?_=_6_34)
![image](https://img.shields.io/badge/version-2-blue.svg)
[![image](https://img.shields.io/badge/author-hunzsig-red.svg)](https://www.hunzsig.com)
![image](https://img.shields.io/badge/email-mzyhaohaoren@qq.com-green.svg)

[![image](https://img.shields.io/badge/demo-HelloWorld-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-h-lua-helloworld)
[![image](https://img.shields.io/badge/demo-MysteriousLand-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-mysterious-land)
[![image](https://img.shields.io/badge/test-DZAPI-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-dzapi)
[![image](https://img.shields.io/badge/test-Crash-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-breakdown)

```
This set of codes is free for trial by authors who understand Lua.
If you do n’t know Lua language, please use T to make maps or learn by yourself.
Teaching is not provided here. This tutorial uses YDWE as an example.
It is not guaranteed to be completely correct and bug free.
If necessary, please modify the source code to make the game.
```

## Version 2
> see [h-lua-sdk](https://github.com/hunzsig-warcraft3/h-lua-sdk)
```
git clone https://github.com/hunzsig-warcraft3/h-lua-sdk.git
```

## Project structure：
```
    ├── console - runtime debug
    │── const - Static value configuration
    ├── docs - some documents
    │── foundation
    │   ├── color.lua
    │   ├── json.lua
    │   ├── Mapping.lua
    │   ├── math.lua
    │   ├── string.lua
    │   └── table.lua
    ├── lib
    │   ├── skill
    │   ├── attrbute - Universal Property System
    │   ├── cache.lua
    │   ├── award.lua
    │   ├── buff.lua
    │   ├── camera.lua
    │   ├── cmd.lua
    │   ├── courier.lua
    │   ├── dialog.lua
    │   ├── dzapi.lua - Dzapi
    │   ├── dzui.lua - DzUI
    │   ├── effect.lua
    │   ├── enchant.lua
    │   ├── enemy.lua - Used to set enemy players, automatically assign units
    │   ├── env.lua
    │   ├── event.lua
    │   ├── eventDefaultActions.lua
    │   ├── group.lua - Unit Group
    │   ├── hero.lua
    │   ├── id.lua
    │   ├── initialization.lua - init scripts
    │   ├── is.lua
    │   ├── item.lua
    │   ├── itemPool.lua
    │   ├── japi.lua
    │   ├── itemPool.lua
    │   ├── leaderBoard.lua
    │   ├── lightning.lua
    │   ├── monitor.lua
    │   ├── multiBoard.lua
    │   ├── player.lua
    │   ├── quest.lua
    │   ├── rect.lua
    │   ├── shop.lua
    │   ├── sound.lua
    │   ├── textTag.lua
    │   ├── texture.lua
    │   ├── time.lua
    │   ├── unit.lua
    │   └── weather.lua
    ├── slk - hslk builder
    ├── blizzard_b.lua - Blizzard B global variables
    ├── blizzard_c.lua - Blizzard C global variables
    ├── echo.lua - Game message global function
    └── h-lua.lua - Enter
```
