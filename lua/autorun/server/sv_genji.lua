function Deflect(ply)
	local DEFLECT_DURATION = 2

	ply:SetNWBool("deflecting", true)
	debugoverlay.ScreenText(0.5, 0.5, "Deflecting", DEFLECT_DURATION)
	local deflector = ents.Create("deflect_hitbox")
	deflector:SetOwner(ply)
	deflector:Spawn()
	
	timer.Simple(DEFLECT_DURATION, function()
		ply:SetNWBool("deflecting", false)
		deflector:Remove()
		AbilitySucceeded(ply, 1)
	end)
end

function Strike(ply)
	local STRIKE_LENGTH = 735 --14 meters
	local STRIKE_DURATION = 0.2
	local TICK_DURATION = engine.TickInterval()
	local lerpProgression = 0
	local initPos = ply:GetPos()
	local targetPos = ply:GetPos() + Vector(0, 0, 64) + ply:GetAimVector() * STRIKE_LENGTH
	
	local TIMER_REPETITIONS = STRIKE_DURATION / TICK_DURATION
	
	-- local transitionTraceFilter = player.GetAll()
	-- for _, ent in ents.GetAll()
		-- if ent:IsNPC() then
			-- table.insert(transitionTraceFilter, ent)
		-- end
	-- end
	-- table.Add(transitionTraceFilter, ents.FindByClass("prop_dynamic")
	
	--Trace for Genji transition
	local tr = util.TraceEntity({
		start = initPos,
		endpos = targetPos,
		filter = ents.GetAll()
	}, ply)
	
	--Trace for hurting objects
	local hurtTr = util.TraceEntity({
		start = initPos,
		endpos = targetPos,
		filter = ply
	}, ply)
	
	if DEBUG then
		print("tr")
		PrintTable(tr)
		print("hurtTr")
		PrintTable(hurtTr)
	end
	
	debugoverlay.Line(initPos, tr.HitPos, 10, Color(0, 255, 0))
	debugoverlay.Line(tr.HitPos, targetPos, 10, Color(100, 100, 100))
	
	ply:Lock()
	timer.Create(ply:UserID() .. "swiftStrikeMove", TICK_DURATION, TIMER_REPETITIONS, function()
		ply:SetPos(LerpVector(lerpProgression, initPos, tr.HitPos))
		lerpProgression = lerpProgression + 1 / TIMER_REPETITIONS
	end)
	
	local hurtEntity = hurtTr.Entity
	
	if hurtEntity == nil then return end
	-- if not (hurtEntity:IsNPC() or hurtEntity:IsPlayer()) then return end
	
	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(50)
	dmgInfo:SetAttacker(ply)
	dmgInfo:SetDamageType(DMG_SLASH)
	hurtEntity:TakeDamageInfo(dmgInfo)
	
	timer.Simple(STRIKE_DURATION, function()
		ply:UnLock()
		AbilitySucceeded(ply, 2)
	end)
end

hook.Add("AbilityCasted", "genji_abilityExecution", function(ply, hero, abilityID)
	if hero.name == "Genji" then
		if abilityID == 1 then
			Deflect(ply)
		elseif abilityID == 2 then
			Strike(ply)
		end
	end
end)

local function CanDeflect(target, damageInfo)
    return target:GetNWString("hero") ~= "Genji"
            and target:GetNWBool("deflecting")
            and damageInfo:IsDamageType(DMG_BULLET)
            and damageInfo:IsDamageType(DMG_AIRBOAT)
            and damageInfo:IsDamageType(DMG_BUCKSHOT)
            and damageInfo:IsDamageType(DMG_DISSOLVE)
            and damageInfo:IsBulletDamage()
end

hook.Add("EntityTakeDamage", "deflectBullets", function(target, damageInfo)
	if not target:IsPlayer() then return end
	if not CanDeflect(target, damageInfo) then return end
	
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