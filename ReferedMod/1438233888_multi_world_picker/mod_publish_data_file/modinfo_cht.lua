name = "多層世界選擇器"
description = [[
在使用落水洞、樓梯以及朋友傳送門時，顯示一個世界選擇器，
玩家可以選擇目標世界來遷移。
]]

configuration_options = {
    {
        name = "language",
        label = "語言",
        hover = "支援正體、簡體和英文",
        --默認會嘗試通過時區及中文語言模組檢測，建議直接設定為需要的語言
        options = {
            {description = "檢測", data = "auto"},
            {description = "English", data = "en"},
            {description = "繁體", data = "cht"},
            {description = "简体", data = "chs"}
        },
        default = "cht"
    },
    {
        name = "auto_balancing",
        label = "自動均衡玩家",
        --當玩家新出生時，自動將其分配至人數最少的世界
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = true
    },
    {
        name = "no_bat",
        label = "阻止洞口產生蝙蝠",
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = true
    },
    {
        name = "world_prompt",
        label = "告知所處世界名稱",
        hover = "當進入某個世界，告知玩家當前所處的世界名稱",
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = true
    },
    {
        name = "say_dest",
        label = "說出目的地",
        hover = "玩家跳轉前會說出目的地以提示其他人",
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = true
    },
    {
        name = "migration_postern",
        label = "惡魔門作洞口使用",
        hover = "對幽靈無效",
        --有較低概率導致洞口ID的混亂
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = false
    },
    {
        name = "extra_worlds",
        label = "不參與自動均衡的世界",
        --此項table為世界ID(字符串)的數組
        options = {
            {description = "無", data = {}, hover = "默認不設額外的世界"},
            {description = "示例", data = {"3", "4"}, hover = "ID為3、4的世界不參與"}
        },
        default = {}
    },
    --world name
    {
        name = "world_name",
        label = "各個世界的名稱",
        --注意：此table的鍵為世界ID，鍵必須是字符串類型
        options = {
            {description = "默認", data = {}, hover = "默認以世界ID作名稱"},
            {description = "例一", data = {["1"] = "世界一", ["2"] = "世界二", ["3"] = "世界三"}, hover = "1：世界一，2：世界二，3：世界三"},
            {description = "例二", data = {["1"] = "地面1", ["2"] = "洞穴", ["3"] = "地面2"}, hover = "1：地面1，2：洞穴，3：地面2"}
        },
        default = {}
    },
    --population limit
    {
        name = "population_limit",
        label = "各世界的人數上限",
        --注意：此項table的鍵為世界ID，鍵必須是字符串類型
        --其值設為0或nil則不限定該世界的人數
        --設定以_other為鍵名的值則作為人數上限的默認值
        --受限於取得世界人數之方式，某些情況下世界實際人數可能大於上限
        options = {
            {description = "不限", data = {}, hover = "默認不限定人數"},
            {description = "全部設為6人", data = {["_other"] = 6}, hover = "僅設定_other的值則對所有世界生效"},
            {description = "示例", data = {["1"] = 8, ["3"] = 4, ["_other"] = 6}, hover = "世界1：8人，世界3：4人，其餘6人"}
        },
        default = {}
    },
    --忽略落水洞
    {
        name = "ignore_sinkholes",
        label = "忽略落水洞",
        hover = "不在落水洞上啓用世界選擇器",
        --若您只想在朋友之門或惡魔門上開啓世界選擇器，則可啓用此項
        options = {
            {description = "開啓", data = true},
            {description = "關閉", data = false}
        },
        default = false
    },
    --隱藏世界
    {
        name = "invisible_worlds",
        label = "不可見的世界",
        hover = "設定不在選擇器中顯示的世界",
        --此項table為世界ID(字符串)的數組
        options = {
            {description = "無", data = {}, hover = "無被隱藏的世界"},
            {description = "示例", data = {"1"}, hover = "ID為1的世界被隱藏"}
        },
        default = {}
    }
}
