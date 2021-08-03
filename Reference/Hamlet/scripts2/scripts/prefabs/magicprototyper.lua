require "prefabutil"

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation(inst.components.prototyper.on and "proximity_loop" or "idle", true)
	end
end

local function spawnpigs(inst)

end

local function spawnparrots(inst)
	if not inst:HasTag("burnt") then
		if math.random() <= 0.1 then
			local pt = inst:GetPosition()
			local parrot = SpawnPrefab("parrot_pirate")
			parrot.Transform:SetPosition(pt.x, pt.y, pt.z)
			-- this doesn't work right because parrots fly off since you're so close, so just drop a dubloon aswell
			--parrot.components.periodicspawner:SetPrefab("dubloon")
			local dubloon = SpawnPrefab("dubloon")
			dubloon.Transform:SetPosition(pt.x+1, pt.y, pt.z)
		end
	end
end

local function spawnrabbits(inst)
	if math.random() <= 0.1 then
		local pt = inst:GetPosition()
		local rabbit = SpawnPrefab("rabbit")
		rabbit.Transform:SetPosition(pt.x, pt.y, pt.z)
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end


local function onFloodedStart(inst)
	if inst.components.prototyper then
		inst.components.prototyper.disabled = true 
	end 
end 


local function onFloodedEnd(inst)
	if inst.components.prototyper then
		inst.components.prototyper.disabled = false 
	end 
end 

local function createmachine(level, name, soundprefix, sounddelay, techtree, mergeanims, onact)
	
	local function onturnon(inst)
		if not inst:HasTag("burnt") then
			if mergeanims then
				inst.AnimState:PlayAnimation("proximity_pre")
				inst.AnimState:PushAnimation("proximity_loop", true)
			else
				inst.AnimState:PlayAnimation("proximity_loop", true)
			end
			if inst:HasTag("hogusporkusator") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/hogusporkusator/idle_LP","idlesound")
			else
				inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_idle_LP","idlesound")
			end
		end
	end

	local function onturnoff(inst)
		if not inst:HasTag("burnt") then
			if mergeanims then
				inst.AnimState:PushAnimation("proximity_pst")
			    inst.AnimState:PushAnimation("idle", true)
			else
			    inst.AnimState:PlayAnimation("idle", true)
			end
			inst.SoundEmitter:KillSound("idlesound")
		end
	end

	local assets = 
	{
		Asset("ANIM", "anim/"..name..".zip"),
	}

	local prefabs =
	{
		"collapse_small",
	}

	local function onFloodedStart(inst)
		inst.components.prototyper.disabled = true 
	end 

	local function onFloodedEnd(inst)
		inst.components.prototyper.disabled = false 
	end 

	local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		local minimap = inst.entity:AddMiniMapEntity()
		inst.entity:AddSoundEmitter()
		minimap:SetPriority( 5 )
		minimap:SetIcon( name..".png" )
	    
		MakeObstaclePhysics(inst, .4)
	    
		anim:SetBank(name)
		anim:SetBuild(name)
		anim:PlayAnimation("idle")

		inst:AddTag(name)

		inst:AddTag("prototyper")
        inst:AddTag("structure")
        inst:AddTag("level"..level)
		
		inst:AddComponent("inspectable")
		inst:AddComponent("prototyper")
		inst.components.prototyper.onturnon = onturnon
		inst.components.prototyper.onturnoff = onturnoff

		inst:AddComponent("floodable")
		inst.components.floodable.onStartFlooded = onFloodedStart
		inst.components.floodable.onStopFlooded = onFloodedEnd
		inst.components.floodable.floodEffect = "shock_machines_fx"
		inst.components.floodable.floodSound = "dontstarve_DLC002/creatures/jellyfish/electric_land"
		
		inst.components.prototyper.trees = techtree
		inst.components.prototyper.onactivate = function()
			if not inst:HasTag("burnt") then
				inst.AnimState:PlayAnimation("use")
				inst.AnimState:PushAnimation("idle")
				inst.AnimState:PushAnimation("proximity_loop", true)
				inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_run","sound")

				inst:DoTaskInTime(1.5, function() 

					if onact then
						onact(inst)
					end

					--inst.SoundEmitter:KillSound("sound")
					inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_ding")		
				end)
			end
		end
		
		inst:ListenForEvent( "onbuilt", function()
			inst.components.prototyper.on = true
			anim:PlayAnimation("place")
			anim:PushAnimation("idle")
			anim:PushAnimation("proximity_loop", true)
			inst:DoTaskInTime(sounddelay, function()								
				if inst:HasTag("hogusporkusator") then
					inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/hogusporkusator/place")
					inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/hogusporkusator/idle_LP","idlesound")
				else
					inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_place")
					inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_idle_LP","idlesound")
				end				
			end)				
		end)		

		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)		
		MakeSnowCovered(inst, .01)

		MakeLargeBurnable(inst, nil, nil, true)
		MakeLargePropagator(inst)

		inst.OnSave = onsave 
        inst.OnLoad = onload

		return inst
	end
	return Prefab( "common/objects/"..name, fn, assets, prefabs)
end
--Using old prefab names
return createmachine(3, "researchlab3", "lvl3", 0.15, TUNING.PROTOTYPER_TREES.SHADOWMANIPULATOR, true),
createmachine(4, "piratihatitator", "lvl4", 0, TUNING.PROTOTYPER_TREES.PRESTIHATITATOR, false, spawnparrots ),
createmachine(4, "researchlab4", "lvl4", 0, TUNING.PROTOTYPER_TREES.PRESTIHATITATOR, false, spawnrabbits),
createmachine(4, "hogusporkusator", "lvl4", 0, TUNING.PROTOTYPER_TREES.HOGUSPORKUSATOR, false, spawnpigs),
MakePlacer( "common/researchlab3_placer", "researchlab3", "researchlab3", "idle" ),
MakePlacer( "common/piratihatitator_placer", "piratihatitator", "piratihatitator", "idle" ),
MakePlacer( "common/researchlab4_placer", "researchlab4", "researchlab4", "idle" ),
MakePlacer( "common/hogusporkusator_placer", "hogusporkusator", "hogusporkusator", "idle" )