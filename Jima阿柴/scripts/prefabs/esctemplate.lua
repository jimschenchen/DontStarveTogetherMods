local MakePlayerCharacter = require "prefabs/player_common"
local nightVision = false

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting inventory
local start_inv =
{
	"canex2",
	"backpack_blueprint",
	"twigs",
	"twigs",
	"twigs",
	"twigs",
	"cutgrass",
	"cutgrass",
	"cutgrass",
	"cutgrass",
}

-----------------


local function sanityfn(inst)  --靠近生物或物體回理智效果
    local x, y, z = inst.Transform:GetWorldPosition() 
    local delta = 0
    local max_rad = 8
    local ents = TheSim:FindEntities(x, y, z, max_rad, { "frog" }) --青蛙
	local ents1 = TheSim:FindEntities(x, y, z, max_rad, { "rabbit" }) --兔子
	local ents2 = TheSim:FindEntities(x, y, z, max_rad, { "mole" }) --地鼠
	local ents3 = TheSim:FindEntities(x, y, z, max_rad, { "catcoon" }) --狸貓
	local ents4 = TheSim:FindEntities(x, y, z, max_rad, { "fridge" }) --冰箱
	local ents5 = TheSim:FindEntities(x, y, z, max_rad, { "frozen" }) --冰岩
	local ents6 = TheSim:FindEntities(x, y, z, max_rad, { "penguin" }) --企鵝
	local ents7 = TheSim:FindEntities(x, y, z, max_rad, { "player" }) --玩家
	local ents8 = TheSim:FindEntities(x, y, z, max_rad, { "butterfly" }) --蝴蝶
	local ents9 = TheSim:FindEntities(x, y, z, max_rad, { "chester" }) --切斯特
	local ents10 = TheSim:FindEntities(x, y, z, max_rad, { "perd" }) --火雞
	local ents11 = TheSim:FindEntities(x, y, z, max_rad, { "hasemergencymode" }) --雪球機
	local ents12 = TheSim:FindEntities(x, y, z, max_rad, { "mushtree" }) --蘑菇樹
	local ents13 = TheSim:FindEntities(x, y, z, max_rad, { "grassgekko" }) --草鬣蜥
	local ents14 = TheSim:FindEntities(x, y, z, max_rad, { "hutch" }) --哈奇
	for i, v in ipairs(ents) do
        local rad = 1
        local sz = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sz - 0.4 / math.max(1, distsq)
    end
	for i, v in ipairs(ents1) do
        local rad = 1
        local sy = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sy - 0.4 / math.max(1, distsq)
    end
	for i, v in ipairs(ents2) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx - 0.4 / math.max(1, distsq)
    end
	for i, v in ipairs(ents3) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx - 0.8 / math.max(1, distsq)
    end
	for i, v in ipairs(ents4) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.7 / math.max(1, distsq)
    end
	for i, v in ipairs(ents5) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.2 / math.max(1, distsq)
    end
	for i, v in ipairs(ents6) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.2 / math.max(1, distsq)
    end
	for i, v in ipairs(ents7) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.7 / math.max(1, distsq)
    end
	for i, v in ipairs(ents8) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.2 / math.max(1, distsq)
    end
	for i, v in ipairs(ents9) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.2 / math.max(1, distsq)
    end
	for i, v in ipairs(ents10) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.8 / math.max(1, distsq)
    end
	for i, v in ipairs(ents11) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.9 / math.max(1, distsq)
    end
	for i, v in ipairs(ents12) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.5 / math.max(1, distsq)
    end
	for i, v in ipairs(ents13) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.8 / math.max(1, distsq)
    end
	for i, v in ipairs(ents14) do
        local rad = 1
        local sx = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
        local distsq = inst:GetDistanceSqToInst(v) - 6
        -- shift the value so that a distance of 3 is the minimum
        delta = delta + sx + 0.1 / math.max(1, distsq)
    end
    return delta
end

-----------------

-- 夜視能力
--local function onbecamehuman(inst)
	-- Set speed when loading or reviving from ghost (optional)
	--inst.Light:Enable(true)
	--inst.Light:SetRadius(4)
	--inst.Light:SetFalloff(.2)
	--inst.Light:SetIntensity(.2)
	--inst.AnimState:OverrideMultColour(1, 1, 1, 0.7)
--end

local function applyupgrades(inst) --吃東西等級

	local max_upgrades = 100
	local upgrades = math.min(inst.level, max_upgrades)

	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()

	inst.components.hunger.max = math.ceil (50 + upgrades * 4) --450
	inst.components.health.maxhealth = math.ceil (60 + upgrades * 6) --660
	inst.components.sanity.max = math.ceil (50 + upgrades * 2) --250
	
	inst.components.health:StartRegen(1, 21 - upgrades / 5) --1-5
	
	inst.components.combat.min_attack_period = (0.55 - upgrades * 0.03) --0.05
	inst.components.combat.damagemultiplier = (1.0 + upgrades * 0.02) --1.3
	inst.components.health.absorb = (upgrades * 0.003) --0.3
	inst.components.locomotor.walkspeed = (6 + upgrades * 0.04) --8
	inst.components.locomotor.runspeed = (10 + upgrades * 0.05) --11
	
	inst.components.talker:Say("Level : ".. (inst.level))
	
	if inst.level > 99 then
		inst.components.talker:Say("Level : Max!")
	end

	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)

end

local function oneat(inst, food) --食物限制
	
	--if food and food.components.edible and food.components.edible.foodtype == "HELLO" then
	if food and food.components.edible and food.components.edible.foodtype=="MEAT" and inst.level < 100 then

		--give an upgrade!
		inst.level = inst.level + 1
		applyupgrades(inst)	
		inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
		--inst.HUD.controls.status.heart:PulseGreen()
		--inst.HUD.controls.status.stomach:PulseGreen()
		--inst.HUD.controls.status.brain:PulseGreen()
		
		--inst.HUD.controls.status.brain:ScaleTo(1.3,1,.7)
		--inst.HUD.controls.status.heart:ScaleTo(1.3,1,.7)
		--inst.HUD.controls.status.stomach:ScaleTo(1.3,1,.7)
	end
end


local function NightVision(inst)
	if TheWorld.state.isnight or TheWorld:HasTag("cave") then
		inst.Light:Enable(true)
		inst.Light:SetRadius(30)
		inst.Light:SetFalloff(0.9)
		inst.Light:SetIntensity(0.7)
		inst.Light:SetColour(180/255,195/255,150/255)
		
		nightVision = true
		print("NightVision On")
	else
        inst.Light:Enable(false)
		nightVision = false
		print("NightVision Off")
	end
end

local function genius(inst)

	if inst.components.sanity.current >= (200) and inst.components.sanity.current <= (250) then 
	
		inst.components.builder.science_bonus = (3)
		inst.components.builder.magic_bonus = (3)
		inst.components.builder.ancient_bonus = (3)
		inst.components.builder.volcanic_bonus = (3)
		
    elseif inst.components.sanity.current >= (150) and inst.components.sanity.current < (200) then 
		
		inst.components.builder.science_bonus = (3)
		inst.components.builder.magic_bonus = (2)
		inst.components.builder.ancient_bonus = (0)
		inst.components.builder.volcanic_bonus = (0)
		
    elseif inst.components.sanity.current >= (60) and inst.components.sanity.current < (150)then 

		inst.components.builder.science_bonus = (2)
		inst.components.builder.magic_bonus = (1)
		inst.components.builder.ancient_bonus = (0)
		inst.components.builder.volcanic_bonus = (0)
		
	elseif inst.components.sanity.current > (0) and inst.components.sanity.current < (60) then 
		
		inst.components.builder.science_bonus = (1)
		inst.components.builder.magic_bonus = (0)
		inst.components.builder.ancient_bonus = (0)
		inst.components.builder.volcanic_bonus = (0)
	
	end
	
end


local function onpreload(inst, data)
	if data then
		if data.level then
			inst.level = data.level
			applyupgrades(inst)
			--re-set these from the save data, because of load-order clipping issues
			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
		end
	end

end

local function onsave(inst, data)
	data.level = inst.level
	data.charge_time = inst.charge_time
end

-----------------------------------

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "esctemplate_speed_mod", 1)
	inst.Light:Enable(true)
	inst.Light:SetRadius(5)
	inst.Light:SetFalloff(.2)
	inst.Light:SetIntensity(.2)
	inst.AnimState:OverrideMultColour(1, 1, 1, 0.7)
	inst.components.locomotor.walkspeed = 6--行走加快25%
	inst.components.locomotor.runspeed = 9--跑步加快25%
	inst.components.sanity.night_drain_mult = 0.5--夜晚時理智下降速度-50%
	inst.components.eater.strongstomach = true--可以吃下怪物肉
	inst.components.health.fire_damage_scale = 0.3 --著火傷害增加30%
	inst.components.hunger:SetRate(1.1)--飢餓加快10%
	inst.components.temperature.overheattemp = 100--過熱溫度55
	inst.components.temperature.mintemp = -20 --過冷溫度0
	inst.components.temperature.inherentinsulation = 20 --抗寒10倍
	inst.components.sanity.dapperness = (-0.4)--每秒流失理智
	inst.components.sanity.custom_rate_fn = sanityfn
	
	-- Sanity Aura
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = 3 * TUNING.SANITYAURA_MED --身旁的隊友理智提升+2
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1.0
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	
	if inst.components.moisture then
		inst.components.moisture.maxMoistureRate = inst.components.moisture.maxMoistureRate * 2
		inst.components.moisture.maxPlayerTempDrying = inst.components.moisture.maxPlayerTempDrying * 2
		inst.components.moisture.maxDryingRate = inst.components.moisture.maxDryingRate * 2
	end


end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "esctemplate_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "esctemplate.tex" )

	inst:WatchWorldState("startnight", NightVision)
	inst:WatchWorldState("startday", NightVision)

	inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(30)
    inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.7)
    inst.Light:SetColour(180/255,195/255,150/255)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	inst.level = 0
	inst.components.eater:SetOnEatFn(oneat)
	applyupgrades(inst)
	
	-- Stats	
	inst.components.health:SetMaxHealth(60)
	inst.components.hunger:SetMax(50)
	inst.components.sanity:SetMax(50)
	inst.components.locomotor.walkspeed = 5--行走加快25%
	inst.components.locomotor.runspeed = 8--跑步加快25%
	inst.components.sanity.night_drain_mult = 0.6--夜晚時理智下降速度-50%
	inst.components.eater.strongstomach = true--可以吃下怪物肉
	inst.components.health.fire_damage_scale = 0.5--著火傷害增加30%
	inst.components.hunger:SetRate(1.1)--飢餓加快10%
	inst.components.temperature.overheattemp = 100--過熱溫度55
	inst.components.temperature.mintemp = -20 --過冷溫度0
	inst.components.temperature.inherentinsulation = 20--抗寒10倍
	inst.components.sanity.dapperness = (-0.4)--每秒流失理智
	
	inst.components.sanity.custom_rate_fn = sanityfn
	
	-- Sanity Aura
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = 2.5 * TUNING.SANITYAURA_MED --身旁的隊友理智提升+2
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1.0
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	---
	inst:ListenForEvent("sanitydelta", function(inst) genius(inst) end)
	
	
	if inst.components.moisture then
		inst.components.moisture.maxMoistureRate = inst.components.moisture.maxMoistureRate * 2
		inst.components.moisture.maxPlayerTempDrying = inst.components.moisture.maxPlayerTempDrying * 2
		inst.components.moisture.maxDryingRate = inst.components.moisture.maxDryingRate * 2
	end

	
	inst.OnPreLoad = onpreload
	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end


return MakePlayerCharacter("esctemplate", prefabs, assets, common_postinit, master_postinit, start_inv)
