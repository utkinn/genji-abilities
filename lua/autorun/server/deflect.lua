local DEFLECT_DURATION = 2

local function createDeflectHitbox(player)
    local deflector = ents.Create("deflect_hitbox")
    deflector:SetOwner(player)
    deflector:Spawn()
    return deflector
end

function deflect(ply)
    if ply:GetNWBool('deflecting') then return end
    ply:SetNWBool("deflecting", true)
    debugoverlay.ScreenText(0.5, 0.5, "Deflecting", DEFLECT_DURATION)

    local deflector = createDeflectHitbox(ply)

    timer.Simple(DEFLECT_DURATION, function()
        ply:SetNWBool("deflecting", false)
        deflector:Remove()
        abilitySucceeded(ply, 1)
    end)
end
