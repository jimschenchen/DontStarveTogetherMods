local assets=
{
	Asset("ANIM", "anim/manrabbit_tail.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    inst.AnimState:SetBank("manrabbit_tail")
    inst.AnimState:SetBuild("manrabbit_tail")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
    
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    

    inst:AddComponent("tradable")    
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT*2
    
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "HORRIBLE"

    inst:AddTag("cattoy")
    

    return inst
end

return Prefab( "common/inventory/manrabbit_tail", fn, assets) 
