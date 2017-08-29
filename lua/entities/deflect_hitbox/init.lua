AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	--self:PhysicsInit(SOLID_CUSTOM)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_CUSTOM)
	self:PhysWake()

	self:SetTrigger(true)
	self:SetCollisionBounds(Vector(90, -45, -45), Vector(0, 45, 45))
	--self:SetCustomCollisionCheck(true)
	
	self:SetParent(self:GetOwner())
end

function ENT:Think()
	if not self:GetOwner():Alive() then
		self:Remove()
	end
	local owner = self:GetOwner()
	local ownerPos = owner:GetPos()
	self:SetPos(ownerPos + Vector(0, 0, 46) + owner:GetAimVector() * 18)
	self:SetAngles(owner:EyeAngles())
	
	local mins, maxs = self:GetCollisionBounds()
	debugoverlay.BoxAngles(self:GetPos(), mins, maxs, self:GetAngles(), engine.TickInterval(), Color(200, 255, 200))
end

function ENT:Touch(ent)
	if ent:GetVelocity().x > 600 or ent:GetVelocity().y > 600 or ent:GetVelocity().z > 600 then
		ent:SetAngles(self:GetOwner():EyeAngles())
		debugoverlay.ScreenText(0.5, 0.7, "DEFLECTED", 0.5)
	end
end