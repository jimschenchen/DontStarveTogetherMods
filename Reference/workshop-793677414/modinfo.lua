name = "Painted Houses (DST)"
description = "A nice lick of paint for pig, merm and rabbit houses."
author = "justjasper"
version = "1.5"

forumthread = ""

api_version = 10

dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "pighouses",
		label = "Painted Pig Houses",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true},
		},											
		default = true,
	},
	{
		name = "mermhouses",
		label = "Painted Merm Houses",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true},
		},											
		default = true,
	},
	{
		name = "rabbithouses",
		label = "Painted Bunny Houses",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true},
		},											
		default = true,
	},
}