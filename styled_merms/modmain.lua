Assets = {
	Asset("ANIM", "anim/merm_guard_tower_styled.zip"),
	Asset("ANIM", "anim/merm_king_styled.zip"),
	Asset("ANIM", "anim/mermhouse_crafted_styled.zip")
}

local types = {
	mermwatchtower = "merm_guard_tower_styled",
	mermking = "merm_king_styled",
	mermhouse_crafted = "mermhouse_crafted_styled"

}

for type, building in pairs(types) do
	AddPrefabPostInit(type, function(inst)
		inst.AnimState:SetBuild(building)
		
		if inst.build then
			inst.build = chosenbuild
		end
		
		inst._OnSave = inst.OnSave --get the current save/load functions
		inst._OnLoad = inst.OnLoad --if they exist
		
		inst.OnSave = function(inst, data)
			data.build = chosenbuild
			if inst._OnSave then
				inst._OnSave(inst, data)
			end
		end
		
		inst.OnLoad = function(inst, data)
			if data and data.build then
				inst.AnimState:SetBuild(data.build)
				if inst.build then
					inst.build = data.build
				end
			end
			if inst._OnLoad then
				inst._OnLoad(inst, data)
			end
		end
	end)

end