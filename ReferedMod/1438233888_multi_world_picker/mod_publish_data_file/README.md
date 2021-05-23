# README

## 多层世界选择器

专门为多层世界（shard数量 >= 3）的专用服务器设计。
在使用落水洞、楼梯以及朋友传送门时，显示一个世界选择器。
玩家可以选择目标世界来迁移，同时提供以下功能：

- 玩家新出生时自动迁移至人数最少的世界，即所谓「自动分流」（默认开启，可关闭）
- 限制各个世界的人数上限
- 自定义每个世界的名称
- 阻止洞口生成蝙蝠（默认开启，可关闭）
- 将恶魔之门作为洞口使用（默认关闭）

注意：

- 使用此Mod无需特别设置洞口连接，若洞口数量不足可自行生成落水洞或朋友之门
- 世界名称和人数上限的配置，每个世界应当保持一致
- 受限于世界人数的获取方式，有可能出现超过世界人数上限的情况
- 如果当前只存在一个从世界，将不会显示选择器

P.S. 示例配置请直接参看 modinfo.lua

## 多層世界選擇器

此模組專為擁有多層世界（shard數量 >= 3）的伺服器設計。
在使用落水洞、樓梯以及朋友傳送門時，顯示一個世界選擇器。
玩家可以選擇目標世界來遷移，同時提供以下功能：

- 玩家新出生時自動遷移至人數最少的世界，即所謂「自動分流」（默認開啟，可關閉）
- 限制各個世界的人數上限
- 自定義每個世界的名稱
- 阻止洞口生成蝙蝠（默認開啟，可關閉）
- 將惡魔之門作為洞口使用（默認關閉）

注意：

- 使用此模組無需特別設置洞口連接，若洞口數量不足可自行生成落水洞或朋友傳送門
- 世界名稱和人數上限的配置，每個世界應當保持一致
- 受限於世界人數的獲取方式，有可能出現超過世界人數上限的情況
- 如果當前只存在一個從世界，將不會顯示選擇器

附：示例配置請直接參看 modinfo.lua，既然能開起多層世界，應該都能看懂 XD

## Multi-World Picker

This mod is designed for servers with multiple shards.
When using sinkholes, stairs and Friend-O-Matic Portals, display a world selector.
Players can select the target world to migrate.
The following features are also provided:

- Automatically assign players to the world with the fewest players when they are born (default is on, can be turned off)
- Limit the maximum number of players in each world
- Customize the name of each world
- Prevent bats from being generated at sinkholes (default is on, can be turned off)
- Use the Florid Postern as a sinkhole (disabled by default)

Note:

- There is no need to set connections between worlds when using this mod. If the number of sinkholes is insufficient, you can generate sinkholes or Friend-O-Matic Portals manually.
- Configurations of world name and maximum number of players should be consistent each world.
- Limited by the way to get the number of players, sometimes the number of players will exceed the upper limit.
- If there is only one slave world, the selector will not be displayed
- See modinfo.lua directly to get more detail

P.S. English is not my main language, so the translation may not be accurate.