require "prefabutil"
require "recipe"
require "modutil"

local assets=
{
    Asset("ANIM", "anim/myprefab.zip"),
    Asset("ATLAS", "images/inventoryimages/myprefab.xml"),
    Asset("IMAGE", "images/inventoryimages/myprefab.tex"),
}

--------------------------------

local function onopen(inst) 
    inst.AnimState:PlayAnimation("open") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end 

local function onclose(inst) 
    inst.AnimState:PlayAnimation("idle") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")        
end 

----------------------------------

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)

    inst:AddTag("structure")

    inst:AddTag("chest")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "myprefab.tex" )

    inst.AnimState:SetBank("myprefab")
    inst.AnimState:SetBuild("myprefab")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYPREFAB = "It's a custom prefab!" --Examine 

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("treasurechest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

return Prefab( "common/myprefab", fn, assets, prefabs),
        MakePlacer( "common/myprefab_placer", "myprefab", "myprefab", "idle" ) 
