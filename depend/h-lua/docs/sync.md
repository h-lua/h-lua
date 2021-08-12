## 关于数据同步
 > 网易给我们提供的与同步数据有关的函数有4条：
```
DzSyncData
DzTriggerRegisterSyncData
DzGetTriggerSyncPlayer
DzGetTriggerSyncData
```
> 原理和服务器请求响应一样，简单易懂

> 教程：http://wenku.hunzsig.org/?_=_4_39

#### 若使用hsync库，例子

```lua

-- 通用型操作，两个配套
hsync.onSend("hzg", function(syncData)
    echo(syncData.triggerData[1] .. syncData.triggerData[2] .. "人类")
end)
local a = 0
htime.setInterval(2, function(curTimer)
    hsync.send("hzg", { "hunzsig", "是个" .. a .. "级" })
    a = a + 1
end)

```