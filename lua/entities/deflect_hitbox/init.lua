AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'
include 'claf.lua'

local function updatePosition(hitbox)
    local owner = hitbox:GetOwner()
    local ownerPos = owner:GetPos()
    hitbox:SetPos(ownerPos + Vector(0, 0, 46) + owner:GetAimVector() * 48)
    hitbox:SetAngles(owner:EyeAngles() + Angle(90, 0, 0))
end

function ENT:Initialize()
    --self:PhysicsInit(SOLID_CUSTOM)
    self:SetModel('models/hunter/plates/plate2x2.mdl')
    self:SetColor(Color(255, 255, 255, 50))
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    updatePosition(self)
    -- self:PhysWake()
end

function ENT:removeIfGenjiDead()
    if not self:GetOwner():Alive() then
        self:Remove()
    end
end

function ENT:Think()
    self:removeIfGenjiDead()
    updatePosition(self)
end

function ENT:Touch(ent)
    local velocity = ent:GetVelocity()
    local coords = {velocity.x, velocity.y, velocity.z}
    if Any(coords, function(coord) return coord > 600 end) then
        ent:SetAngles(self:GetOwner():EyeAngles())    -- TODO
        debugoverlay.ScreenText(0.5, 0.7, 'DEFLECTED', 0.5)
    end
end

function ENT:OnTakeDamage(damage)
    if not damage:IsBulletDamage() then return end

    local owner = self:GetOwner()

    damage:SetDamage(0)
    local ammo = damage:GetAmmoType()
    local bullet = {
        Attacker = target,
        Damage = 20,
        AmmoType = ammo,
        Dir = owner:GetAimVector(),
        Src = owner:GetPos() + Vector(0, 0, 40) + owner:GetAimVector() * 10,
        IgnoreEntity = self
    }

    owner:FireBullets(bullet)  -- Crash here
end
