name = "Multi-World Picker"
description =
    [[
When using sinkholes, stairs and friend portal, display a world selector.
Players can select the target world to migrate.
]]
author = "Flynn"
version = "1.0.6 hotfix"
forumthread = ""
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -10186.86 --must be unique
server_filter_tags = {"Multi-World"}

--中文使用者可參看 modinfo_cht.lua 或 modinfo_chs.lua
configuration_options = {
    {
        name = "language",
        label = "Language",
        hover = "Support Chinese and English",
        --For English users, you can keep this default
        options = {
            {description = "Auto", data = "auto"},
            {description = "English", data = "en"},
            {description = "繁體", data = "cht"},
            {description = "简体", data = "chs"}
        },
        default = "auto"
    },
    {
        name = "auto_balancing",
        label = "Auto Balancing",
        hover = "Assign players to the world with the fewest players when they are born",
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = true
    },
    {
        name = "no_bat",
        label = "No bat generated at sinkholes",
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = true
    },
    {
        name = "world_prompt",
        label = "Prompt World Name",
        hover = "When a player enters one world, tell him/her the world name",
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = true
    },
    {
        name = "say_dest",
        label = "Say Destination",
        hover = "Before a player migrates, he/she will say the destinantion.",
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = true
    },
    {
        name = "migration_postern",
        label = "Migrate through Florid Postern",
        hover = "Does not work for ghosts",
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = false
    },
    {
        name = "extra_worlds",
        label = "Extra Worlds",
        hover = "Worlds that ignored from Auto Balancing",
        --the table is an array of world ID (whose type is string)
        options = {
            {description = "None", data = {}, hover = "None"},
            {description = "Example", data = {"3", "4"}, hover = "World 3, World 4 are ignored"}
        },
        default = {}
    },
    --world name
    {
        name = "world_name",
        label = "World Name",
        --Note: the keys in this table are world ids, whose type is string.
        options = {
            {description = "Default", data = {}, hover = "make the world Id as the name"},
            {
                description = "Example 1",
                data = {["1"] = "World One", ["2"] = "World Two", ["3"] = "World Three"},
                hover = "1: World One, 2: World Two, 3: World Three"
            },
            {
                description = "Example 2",
                data = {["1"] = "Ground 1", ["2"] = "Cave", ["3"] = "Ground 2"},
                hover = "1: Ground 1, 2: Cave, 3: Ground 2 "
            }
        },
        default = {}
    },
    --population limit
    {
        name = "population_limit",
        label = "Population Limit",
        hover = "Limit the number of players for each world",
        --Note: the keys in this table are world ids, whose type is string.
        --      a value of 0 or nil means no limit.
        --      the value of key "_other" will be set to the default value.
        --      sometimes the number of players will exceed limit.
        options = {
            {description = "no limit", data = {}, hover = "no limit by default"},
            {description = "6 for all worlds", data = {["_other"] = 6}, hover = "set the default value as 6"},
            {
                description = "Example",
                data = {["1"] = 8, ["3"] = 4, ["_other"] = 6},
                hover = "World 1: 8 players, World 3: 4 players, Others: 6 players"
            }
        },
        default = {}
    },
    --ignore sinkholes
    {
        name = "ignore_sinkholes",
        label = "Ignore Sinkholes",
        hover = "Keep sinkholes behaving as game default.",
        --Enable this if you just want to open the world selector at friend portal or Florid Postern only.
        options = {
            {description = "Enable", data = true},
            {description = "Disable", data = false}
        },
        default = false
    },
    --invisible worlds
    {
        name = "invisible_worlds",
        label = "Invisible Worlds",
        hover = "Worlds that invisible in the selector",
        --the table is an array of world ID (whose type is string)
        options = {
            {description = "None", data = {}, hover = "None"},
            {description = "Example", data = {"1"}, hover = "World 1 is invisible"}
        },
        default = {}
    }
}
