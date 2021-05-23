name = "多层世界选择器"
description = [[
在使用落水洞、楼梯以及朋友传送门时，显示一个世界选择器。
玩家可以通过它选择目标世界来迁移。
]]

configuration_options = {
    {
        name = "language",
        label = "语言",
        hover = "支持繁中、简中和英文",
        --默认会尝试通过时区及中文语言Mod检测，建议直接设置需要的语言
        options = {
            {description = "自动", data = "auto"},
            {description = "English", data = "en"},
            {description = "繁體", data = "cht"},
            {description = "简体", data = "chs"}
        },
        default = "chs"
    },
    {
        name = "auto_balancing",
        label = "自动分流",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },
    {
        name = "no_bat",
        label = "防止洞口生成蝙蝠",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },
    {
        name = "world_prompt",
        label = "提示世界名称",
        hover = "当进入某个世界，告诉玩家当前所处世界名称",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },
    {
        name = "say_dest",
        label = "说出目的地",
        hover = "玩家在跳世界之前，将说出目的地，以提示其它玩家",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },
    {
        name = "migration_postern",
        label = "绚丽之门作为洞口",
        hover = "对幽灵不起作用",
        --有较小几率造成洞口ID的混乱
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = false
    },
    {
        name = "extra_worlds",
        label = "不参与分流的世界",
        --此项table为世界ID(字符串)的数组
        options = {
            {description = "无", data = {}, hover = "默认所有世界参与分流"},
            {description = "示例", data = {"3", "4"}, hover = "ID为3、4的世界不参与分流"}
        },
        default = {}
    },
    --world name
    {
        name = "world_name",
        label = "各世界的名称",
        --注意：此table的键为世界ID，键必须是字符串类型
        options = {
            {description = "默认", data = {}, hover = "默认以世界Id作为名称"},
            {description = "例1", data = {["1"] = "世界一", ["2"] = "世界二", ["3"] = "世界三"}, hover = "1：世界一，2：世界二，3：世界三"},
            {description = "例2", data = {["1"] = "地面1", ["2"] = "洞穴", ["3"] = "地面2"}, hover = "1：地面1，2：洞穴，3：地面2"}
        },
        default = {}
    },
    --population limit
    {
        name = "population_limit",
        label = "各世界的人数上限",
        --注意：此项table的键为世界ID，键必须是字符串类型
        --值设为0或nil则不限制该世界的人数
        --受限于获取世界人数的方式，某些情况下世界实际人数可能大于上限
        options = {
            {description = "不限制", data = {}, hover = "默认不限制人数"},
            {description = "统一设为6人", data = {["_other"] = 6}, hover = "仅设定_other的值则对所有世界生效"},
            {description = "示例配置", data = {["1"] = 8, ["3"] = 4, ["_other"] = 6}, hover = "世界1：8人，世界3：4人，其余均为6人"}
        },
        default = {}
    },
    --忽略落水洞
    {
        name = "ignore_sinkholes",
        label = "忽略落水洞",
        hover = "不在落水洞上启用选择器",
        --若您只想在朋友传送门或绚丽之门上打开世界选择器，则启用此选项
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false}
        },
        default = false
    },
    --隐藏世界
    {
        name = "invisible_worlds",
        label = "被隐藏的世界",
        hover = "设置不在选择器中显示的世界",
        --此项table为世界ID(字符串)的数组
        options = {
            {description = "无", data = {}, hover = "无被隐藏的世界"},
            {description = "示例", data = {"1"}, hover = "ID为1的世界被隐藏"}
        },
        default = {}
    }
}
