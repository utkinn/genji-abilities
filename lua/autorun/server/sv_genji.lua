function deflect(ply)
	local DEFLECT_DURATION = 2

	debugoverlay.ScreenText(0.5, 0.5, "Deflecting", DEFLECT_TIME)
	--ply:SetNWBool("deflecting", true)
	local deflector = ents.Create("deflect_hitbox")
	deflector:SetOwner(ply)
	deflector:Spawn()
	
	timer.Simple(DEFLECT_TIME, function()
		--ply:SetNWBool("deflecting", false)
		deflector:Remove()
		abilityFinished(ply, 1, true)
	end)
end

function strike(ply)
	local STRIKE_LENGTH = 735 --14 meters
	local STRIKE_DURATION = 0.4
	local TICK_DURATION = engine.TickInterval()
	local lerpProgression = 0
	local initPos = ply:GetPos()
	local targetPos = ply:GetAimVector() * STRIKE_LENGTH
	local TIMER_REPETITIONS = STRIKE_DURATION / TICK_DURATION
	
	ply:Lock()
	timer.Create(ply:UserID() .. "swiftStrikeMove", TICK_DURATION, TIMER_REPETITIONS, function()
		ply:SetPos(lerpProgression, initPos, targetPos)
		lerpProgression = lerpProgression + 1 / TIMER_REPETITIONS
	end)
	timer.Simple(STRIKE_DURATION, function()
		ply:UnLock()
		abilityFinished(ply, 2, true)
	end)
end