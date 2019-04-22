local assets=
{ 
    Asset("ANIM", "anim/canex2.zip"),
    Asset("ANIM", "anim/swap_canex2.zip"), 

    Asset("ATLAS", "images/inventoryimages/canex2.xml"),
    Asset("IMAGE", "images/inventoryimages/canex2.tex"),
}

local prefabs = 
{
    "cane",
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_canex2", "canex2") --3?
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
local function onunequip(inst,owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target, skipsanity)

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")

    if not target:IsValid() then
        --target killed or removed in combat damage phase
        return
    end

    if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
        if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then
            target.components.freezable:Unfreeze()
        elseif target.components.fueled == nil then
            target.components.burnable:Ignite(true)
        elseif target.components.fueled.fueltype == FUELTYPE.BURNABLE
            or target.components.fueled.secondaryfueltype == FUELTYPE.BURNABLE then
            local fuel = SpawnPrefab("cutgrass")
            if fuel ~= nil then
                if fuel.components.fuel ~= nil and
                    fuel.components.fuel.fueltype == FUELTYPE.BURNABLE then
                    target.components.fueled:TakeFuelItem(fuel)
                else
                    fuel:Remove()
                end
            end
        end
        --V2C: don't ignite if it doens't accespt burnable fuel!
    end

    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(-1) --Does this break ice staff?
        if target.components.freezable:IsFrozen() then
            target.components.freezable:Unfreeze()
        end
    end

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker)
    end

end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    --local sound = inst.entity:AddSoundEmitter()
    anim:SetBank("canex2")
    anim:SetBuild("canex2")
    anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)

    inst:AddTag("sharp")
    inst:AddTag("rangedweapon")
    inst:AddTag("firestaff")
    inst:AddTag("rangedlighter")


    --inst:AddTag("irreplaceable")
    inst.entity:AddNetwork() --+++

    inst.entity:SetPristine()
    
    inst.entity:SetPristine() --?
    if not TheWorld.ismastersim then
        return inst
    end
       


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE*3) --like Spear
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetProjectile("fire_projectile")
    inst.components.weapon:SetRange(15,20)

    --inst:AddComponent("finiteuses")
    --inst.components.finiteuses:SetMaxUses(150) --like Spear
    --inst.components.finiteuses:SetUses(150)
    --inst.components.finiteuses:SetOnFinished(onfinished)

    --inst:AddComponent("tradable")
    inst:AddComponent("inspectable")


    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/canex2.xml"
    -----------------------------------
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    -----------------------------------
    MakeHauntableLaunch(inst)
    
    return inst
end

return Prefab( "common/inventory/canex2", fn, assets, prefabs) 