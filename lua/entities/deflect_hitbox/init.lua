AddCSLuaFile 'shared.lua'
include 'shared.lua'
include 'claf.lua'

function ENT:Initialize()
    --self:PhysicsInit(SOLID_CUSTOM)
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    -- self:PhysWake()
end

function ENT:removeIfGenjiDead()
    if not self:GetOwner():Alive() then
        self:Remove()
    end
end

local function updatePosition(hitbox)
    local owner = hitbox:GetOwner()
    local ownerPos = owner:GetPos()
    hitbox:SetPos(ownerPos + Vector(0, 0, 46) + owner:GetAimVector() * 18)
    hitbox:SetAngles(owner:EyeAngles())
end

function ENT:Think()
    self:removeIfGenjiDead()
    updatePosition(self)
end

function ENT:Touch(ent)
    if Any(ent:GetVelocity(), function(coord) return coord > 600 end) then
        ent:SetAngles(self:GetOwner():EyeAngles())    -- TODO
        debugoverlay.ScreenText(0.5, 0.7, 'DEFLECTED', 0.5)
    end
end
