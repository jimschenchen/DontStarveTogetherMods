local toggles = {
	pighouse = (GetModConfigData("pighouses")),
	mermhouse = (GetModConfigData("mermhouses")),
	rabbithouse = (GetModConfigData("rabbithouses"))
}

Assets = {
	--pig
	Asset("ANIM", "anim/pig_house_blue.zip"),
	Asset("ANIM", "anim/pig_house_green.zip"),
	Asset("ANIM", "anim/pig_house_purple.zip"),
	Asset("ANIM", "anim/pig_house_grey.zip"),
	Asset("ANIM", "anim/pig_house_red.zip"),
	Asset("ANIM", "anim/pig_house_yellow.zip"),
	--merm
	Asset("ANIM", "anim/merm_house_blue.zip"),
	Asset("ANIM", "anim/merm_house_green.zip"),
	Asset("ANIM", "anim/merm_house_purple.zip"),
	Asset("ANIM", "anim/merm_house_grey.zip"),
	Asset("ANIM", "anim/merm_house_red.zip"),
	Asset("ANIM", "anim/merm_house_yellow.zip"),
	--rabbit
	Asset("ANIM", "anim/rabbit_house_orange.zip"),
	Asset("ANIM", "anim/rabbit_house_red.zip"),
	Asset("ANIM", "anim/rabbit_house_green.zip"),
	Asset("ANIM", "anim/rabbit_house_purple.zip"),
	Asset("ANIM", "anim/rabbit_house_brown.zip")
}

local varietyhouses = {
	pighouse = {"pig_house","pig_house_blue","pig_house_green","pig_house_purple","pig_house_grey","pig_house_red","pig_house_yellow"},
	mermhouse = {"merm_house","merm_house_blue","merm_house_green","merm_house_purple","merm_house_grey","merm_house_red","merm_house_yellow"},
	rabbithouse = {"rabbit_house","rabbit_house_red","rabbit_house_orange","rabbit_house_green","rabbit_house_brown","rabbit_house_purple"},
}

for houses, builds in pairs(varietyhouses) do
	if toggles[houses] then
        AddPrefabPostInit(houses, function(inst)
            local chosenbuild = builds[math.random(#builds)]
            inst.AnimState:SetBuild(chosenbuild)
           
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
end