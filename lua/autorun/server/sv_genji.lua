hook.Add("AbilityCasted", "Genji ability execution", function(ply, hero, abilityID)
	if hero.name == "Genji" then
		if abilityID == 1 then
			deflect(ply)
		elseif abilityID == 2 then
			strike(ply)
		end
	end
end)
