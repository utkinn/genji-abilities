function deflect(ply)
	local DEFLECT_DURATION = 2

	debugoverlay.ScreenText(0.5, 0.5, "Deflecting", DEFLECT_DURATION)
	--ply:SetNWBool("deflecting", true)
	local deflector = ents.Create("deflect_hitbox")
	deflector:SetOwner(ply)
	deflector:Spawn()
	
	timer.Simple(DEFLECT_DURATION, function()
		--ply:SetNWBool("deflecting", false)
		deflector:Remove()
		abilitySucceeded(ply, 1)
	end)
end

function strike(ply)
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
		endpos = targetPos
	}, ply)
	
	debugoverlay.Line(initPos, tr.HitPos, 10, Color(0, 255, 0))
	debugoverlay.Line(tr.HitPos, targetPos, 10, Color(100, 100, 100))
	
	ply:Lock()
	timer.Create(ply:UserID() .. "swiftStrikeMove", TICK_DURATION, TIMER_REPETITIONS, function()
		ply:SetPos(LerpVector(lerpProgression, initPos, tr.HitPos))
		lerpProgression = lerpProgression + 1 / TIMER_REPETITIONS
	end)
	
	if hurtTr.Entity ~= nil then
		if hurtTr.Entity:IsNPC() or hurtTr.Entity:IsPlayer() then
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(50)
			dmgInfo:SetAttacker(ply)
			dmgInfo:SetDamageType(DMG_SLASH)
			hurtTr.Entity:TakeDamageInfo(dmgInfo)
		end
	end
	
	timer.Simple(STRIKE_DURATION, function()
		ply:UnLock()
		abilitySucceeded(ply, 2)
	end)
end

hook.Add("AbilityCasted", "genji_abilityExecution", function(ply, hero, abilityID)
	if hero.name == "Genji" then
		if abilityID == 1 then
			deflect(ply)
		elseif abilityID == 2 then
			strike(ply)
		end
	end
end)