# H-Lua

[![image](https://img.shields.io/badge/english-EN_US-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua/blob/main/README_EN-US.md)
![image](https://img.shields.io/badge/license-MIT-blue.svg)
[![image](https://img.shields.io/badge/doc-技术文档-blue.svg)](http://wenku.hunzsig.org/?_=_1_5)
![image](https://img.shields.io/badge/version-2-blue.svg)
[![image](https://img.shields.io/badge/author-hunzsig-red.svg)](https://www.hunzsig.com)
[![image](https://img.shields.io/badge/QQ-325338043-green.svg)](https://qm.qq.com/cgi-bin/qm/qr?k=NYlOpKUo9vEUQ3gN_UBvRUci9avq0tqB&jump_from=webapi)

[![image](https://img.shields.io/badge/demo-你好世界-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-h-lua-helloworld)
[![image](https://img.shields.io/badge/demo-秘地探奇-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-mysterious-land)
[![image](https://img.shields.io/badge/test-DZAPI-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-dzapi)
[![image](https://img.shields.io/badge/test-崩溃压力-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-breakdown)

```
本套代码免费提供给了解lua的魔兽地图作者试用
如果不了解地图制作，不了解lua语言请自行学习，作者不提供教学
不定时更新，提供思路与帮助，提供一些功能函数协助做图作者更加轻松制作地图
不保证完全正确且无bug，如有需要，请自行修改源码进行游戏制作
```

## V2版本
新版本必须结合sdk项目才能运行，sdk为主，h-lua为辅
> 详情请看 [h-lua-sdk](https://github.com/hunzsig-warcraft3/h-lua-sdk)
```
git clone https://github.com/hunzsig-warcraft3/h-lua-sdk.git
```

## 框架结构如下：
```
    ├── console - lua运行时的调试
    │── const - 静态值配置
    ├── docs 一些文档
    │── foundation - 基础文件
    │   ├── color.lua - 颜色
    │   ├── json.lua - json库
    │   ├── Mapping.lua - 值对库
    │   ├── math.lua - 计算库
    │   ├── string.lua - 字符串库
    │   └── table.lua - 表库
    ├── lib
    │   ├── attrbute - 基础/拓展/伤害特效/自然/单位关联，万能属性系统，自由、强大
    │   ├── skill - 技能库
    │   ├── cache.lua - 缓存
    │   ├── award.lua - 奖励模块，用于控制玩家的黄金木头经验
    │   ├── buff.lua - buff模块，可控状态管理
    │   ├── camera.lua - 镜头模块，用于控制玩家镜头
    │   ├── cmd.lua - 框架自带命令管理
    │   ├── dialog.lua - 对话框模块，用于显示对话框
    │   ├── dzapi.lua - Dzapi
    │   ├── dzui.lua - DzUI
    │   ├── effect.lua - 特效模块
    │   ├── enchant.lua - 附魔模块
    │   ├── enemy.lua - 敌人模块，用于设定敌人玩家，自动分配单位
    │   ├── env.lua - 环境模块，可随机为区域生成装饰物及地表纹理
    │   ├── event.lua - 事件模块，自定义事件，包括物品合成分拆/暴击，精确攻击捕捉等
    │   ├── eventDefaultActions.lua - 框架默认事件函数
    │   ├── group.lua - 单位组
    │   ├── hero.lua - 英雄/选英雄模块，包含点击/酒馆选择，repick/random功能等
    │   ├── id.lua - h-lua id配置
    │   ├── initialization.lua - 初始化脚本
    │   ├── is.lua - 判断模块 * 常用
    │   ├── item.lua - 物品模块，与属性系统无缝结合，合成/分拆等功能
    │   ├── itemPool.lua - 物品池
    │   ├── japi.lua - JAPI
    │   ├── leaderBoard.lua 排行榜模块，用于简易构建排行榜
    │   ├── lightning.lua - 闪电链
    │   ├── monitor.lua - 监听器
    │   ├── multiBoard.lua - 多面板
    │   ├── player.lua - 玩家
    │   ├── quest.lua - 任务
    │   ├── rect.lua - 区域
    │   ├── shop.lua - 商店模块
    │   ├── slk.lua - slk模块
    │   ├── sound.lua - 声音模块
    │   ├── textTag.lua - 漂浮字
    │   ├── texture.lua - 遮罩、贴图
    │   ├── time.lua - 时间/计时器 * 常用
    │   ├── unit.lua - 单位
    │   └── weather.lua - 天气
    ├── slk - hslk 构建法
    ├── blizzard_b.lua - 暴雪B全局变量
    ├── blizzard_c.lua - 暴雪C全局变量
    ├── echo.lua - 游戏消息全局函数
    └── h-lua.lua - 入口文件
```
