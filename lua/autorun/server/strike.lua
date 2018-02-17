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
    local transitionTraceResult = util.TraceEntity({
        start = initPos,
        endpos = targetPos,
        filter = ents.GetAll()
    }, ply)

    --Trace for hurting objects
    local hurtTraceResult = util.TraceEntity({
        start = initPos,
        endpos = targetPos,
        filter = ply
    }, ply)

    if DEBUG then
        print("transitionTraceResult")
        PrintTable(transitionTraceResult)
        print("hurtTraceResult")
        PrintTable(hurtTraceResult)
    end

    debugoverlay.Line(initPos, transitionTraceResult.HitPos, 10, Color(0, 255, 0))
    debugoverlay.Line(transitionTraceResult.HitPos, targetPos, 10, Color(100, 100, 100))

    ply:Lock()
    timer.Create(ply:UserID().."swiftStrikeMove", TICK_DURATION, TIMER_REPETITIONS, function()
        ply:SetPos(LerpVector(lerpProgression, initPos, transitionTraceResult.HitPos))
        lerpProgression = lerpProgression + 1 / TIMER_REPETITIONS
    end)

    local hurtEntity = hurtTraceResult.Entity

    if not IsValid(hurtEntity) then return end
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
