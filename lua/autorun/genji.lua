function OverwatchHero(infoTable)
	if HEROES ~= nil then
		HEROES[infoTable.name or "Mister X"] = infoTable
	else
		hook.Add("PreGamemodeLoaded", "addHero_genji", function()
			HEROES[infoTable.name or "Mister X"] = infoTable
		end)
	end
end

OverwatchHero({
	name = "Genji",
	description = "Genji flings precise and deadly Shuriken at his targets,\nand uses his technologically-advanced katana to deflect projectiles or deliver a Swift Strike that cuts down enemies.",
	abilities = {
		{
			name = "Deflect",
			description = "With lightning-quick swipes of his wakizashi, Genji reflects an oncoming projectile and sends it rebounding towards his opponent.",
			cooldown = 8,
			castFunction = deflect
		},
		{
			name = "Swift Strike",
			description = "Genji darts forward, slashing with his wakizashi and passing through foes in his path.\nIf Genji eliminates a target, he can instantly use this ability again.",
			cooldown = 8,
			castFunction = strike
		}
	},
	passiveAbilities = {
		{
			name = "Cyber-Agility",
			description = "Thanks to his cybernetic abilities, Genji can climb walls and perform jumps in mid-air."
		}
	},
	ultimate = {
		name = "Dragonblade",
		description = "Genji brandishes his katana for a brief period of time.\nUntil he sheathes his katana, Genji can deliver killing strikes to any targets within his reach.",
		castFunction = "releaseDragonBlade",
		pointsRequired = 1500
	},
	materials = {
		abilities = {
			Material("genji/deflect.png", "noclamp smooth"),
			Material("genji/strike.png", "noclamp smooth")
		}
	},
	health = 200
})