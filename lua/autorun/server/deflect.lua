local function createDeflectHitbox(player)
    local deflector = ents.Create("deflect_hitbox")
    deflector:SetOwner(player)
    deflector:Spawn()
end

function deflect(ply)
    local DEFLECT_DURATION = 2

    ply:SetNWBool("deflecting", true)
    debugoverlay.ScreenText(0.5, 0.5, "Deflecting", DEFLECT_DURATION)

	createDeflectHitbox(ply)

    timer.Simple(DEFLECT_DURATION, function()
        ply:SetNWBool("deflecting", false)
        deflector:Remove()
        AbilitySucceeded(ply, 1)
    end)
end

local function canDeflect(target, damageInfo)   -- TODO
    return target:GetNWString("hero") ~= "Genji"
            and target:GetNWBool("deflecting")
            and damageInfo:IsDamageType(DMG_BULLET)
            and damageInfo:IsDamageType(DMG_AIRBOAT)
            and damageInfo:IsDamageType(DMG_BUCKSHOT)
            and damageInfo:IsDamageType(DMG_DISSOLVE)
            and damageInfo:IsBulletDamage()
end

hook.Add("EntityTakeDamage", "Deflect bullets", function(target, damageInfo)
    if not target:IsPlayer() then return end
    if not canDeflect(target, damageInfo) then return end

    damageInfo:SetDamage(0)
    local ammo = damageInfo:GetAmmoType()
    local bullet = {
        Attacker = target,
        Damage = 20,
        AmmoType = ammo,
        Dir = target:GetAimVector(),
        Src = target:GetPos() + Vector(0, 0, 40),
        IgnoreEntity = target
    }

    target:FireBullets(bullet)
end)
