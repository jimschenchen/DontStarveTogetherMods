PrefabFiles = {
	"esctemplate",
	"esctemplate_none",
	"canex2",
}

Assets = {
	Asset("IMAGE", "images/inventoryimages/canex2.tex"),
	Asset("ATLAS", "images/inventoryimages/canex2.xml"),

    Asset( "IMAGE", "images/saveslot_portraits/esctemplate.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/esctemplate.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/esctemplate.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/esctemplate.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/esctemplate_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/esctemplate_silho.xml" ),

    Asset( "IMAGE", "bigportraits/esctemplate.tex" ),
    Asset( "ATLAS", "bigportraits/esctemplate.xml" ),
	
	Asset( "IMAGE", "images/map_icons/esctemplate.tex" ),
	Asset( "ATLAS", "images/map_icons/esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/names_esctemplate.tex" ),
    Asset( "ATLAS", "images/names_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/names_gold_esctemplate.tex" ),
    Asset( "ATLAS", "images/names_gold_esctemplate.xml" ),
	
    Asset( "IMAGE", "bigportraits/esctemplate_none.tex" ),
    Asset( "ATLAS", "bigportraits/esctemplate_none.xml" ),

}

AddMinimapAtlas("images/map_icons/esctemplate.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.esctemplate = "柴犬雷檬"
STRINGS.CHARACTER_NAMES.esctemplate = "Shiba Limon"
STRINGS.CHARACTER_DESCRIPTIONS.esctemplate = "*害怕孤單, 身旁無喜愛事物時理智些微下降\n*初始很弱小 需要持續進食變得強大\n*吃怪物肉無負面效果\n*敏捷的狩獵犬 夜晚可以看見身旁的東西\n*在雷檬附近的隊友恢復理智\n*不耐熱 著火時受傷增加\n*耐寒 可以承受低溫"
STRINGS.CHARACTER_QUOTES.esctemplate = "\"狩獵是本能,貪吃是原罪\""


local TECH = GLOBAL.TECH
local limontab = AddRecipeTab("Limon", 998, "images/map_icons/esctemplate.xml", "esctemplate.tex", "limon")


local canex2_recipe = AddRecipe("canex2", 
{  Ingredient("boneshard", 6), Ingredient("berries", 10), Ingredient("livinglog", 2)}, 
limontab, 
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
nil, 
"images/inventoryimages/canex2.xml",
"canex2.tex") 
STRINGS.NAMES.CANEX2 = "Combat Cane"
STRINGS.RECIPE_DESC.CANEX2 = "Double damage. Still not bad."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CANEX2 = "Double damage. Still not bad."

-- Custom speech strings
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_esctemplate"

-- The character's name as appears in-game 
STRINGS.NAMES.ESCTEMPLATE = "Esc"

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("esctemplate", "MALE")

