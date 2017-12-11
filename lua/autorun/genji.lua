function addHero(infoTable)
	HEROES[infoTable.name or "Mister X"] = infoTable
	table.insert(adminConVars, CreateConVar("owa_hero." .. removeSpaces(infoTable.name) .. ".adminsOnly", 0, flags, "Restrict " .. infoTable.name .. " for regular players."))
	for _, ability in pairs(infoTable.abilities) do
		table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(infoTable.name) .. ".ability." .. removeSpaces(ability.name) .. ".cooldown", ability.cooldown, flags, "Change the cooldown of the " .. infoTable.name .. "'s \"" .. ability.name .. "\" ability."))
	end
	if infoTable.customSettings ~= nil then
		for _, customSetting in pairs(infoTable.customSettings) do
			table.insert(adminConVars, CreateConVar("owa_hero_customisation." .. removeSpaces(infoTable.name) .. "." .. customSetting.convar, customSetting.default, flags, customSetting.help))
		end
	end
	table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(infoTable.name) .. ".ultimate.mult", 1, flags, "The charge speed multiplier of ultimate ability \"" .. infoTable.ultimate.name .. "\"."))
end

function OverwatchHero(infoTable)
	if HEROES ~= nil then
		addHero(infoTable)
	else
		hook.Add("PreGamemodeLoaded", "addHero_genji", function()
			addHero(infoTable)
		end)
	end
end

OverwatchHero({
	name = "Genji",
	description = "Genji flings precise and deadly Shuriken at his targets,\nand uses his technologically-advanced katana to Deflect projectiles or deliver a Swift Strike that cuts down enemies.",
	abilities = {
		{
			name = "Deflect",
			description = "With lightning-quick swipes of his wakizashi, Genji reflects an oncoming projectile and sends it rebounding towards his opponent.",
			cooldown = 8,
			castFunction = Deflect
		},
		{
			name = "Swift Strike",
			description = "Genji darts forward, slashing with his wakizashi and passing through foes in his path.\nIf Genji eliminates a target, he can instantly use this ability again.",
			cooldown = 8,
			castFunction = Strike
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
			Material("genji/Deflect.png", "noclamp smooth"),
			Material("genji/Strike.png", "noclamp smooth")
		}
	},
	health = 200
})