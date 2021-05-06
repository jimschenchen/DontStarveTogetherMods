PrefabFiles = {
	"myprefab",
}
local assets=
{
    Asset("ATLAS", "images/inventoryimages/myprefab.xml"),
    Asset("IMAGE", "images/inventoryimages/myprefab.tex"),
}
AddMinimapAtlas("images/inventoryimages/myprefab.xml")

local myrecipe = AddRecipe("myprefab", -- name
{Ingredient("boards", 1)}, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
GLOBAL.RECIPETABS.FARM, -- tab ( FARM, WAR, DRESS etc)
GLOBAL.TECH.NONE, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
"myprefab_placer", -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/myprefab.xml", -- atlas
"myprefab.tex") -- image

GLOBAL.STRINGS.NAMES.MYPREFAB = "My Prefab" --It's name in-game
GLOBAL.STRINGS.RECIPE_DESC.MYPREFAB = "It's a custom prefab!" --recipe description