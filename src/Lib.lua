NUFLib = {}

-- Gets the detail information for the current player.
function NUFLib.GetPlayerDetail()
	local player = Inspect.Unit.Lookup("player")
	local playerDetail = Inspect.Unit.Detail(player)
	return playerDetail
end

-- Gets the "power" bar color for the unit specified
function NUFLib.GetPowerBarColor(unit)
	local pbColor
	
	if unit.calling == "warrior" then
		pbColor = NUFConst.Colors.PowerBar.Warrior
	elseif unit.calling == "rogue" then
		pbColor = NUFConst.Colors.PowerBar.Rogue
	elseif unit.calling == "mage" then
		pbColor = NUFConst.Colors.PowerBar.Mage
	elseif unit.calling == "cleric" then
		pbColor = NUFConst.Colors.PowerBar.Cleric
	end
	
	return pbColor
end

-- Gets the "power" bar value for the unit specified
function NUFLib.GetPowerValue(unit)
	local powerValue
	
	if unit.calling == "warrior" then
		powerValue = unit.power
	elseif unit.calling == "rogue" then
		powerValue = unit.energy
	elseif unit.calling == "mage" then
		powerValue = unit.mana
	elseif unit.calling == "cleric" then
		powerValue = unit.mana
	end
	
	return powerValue
end

-- Gets the "power" bar percent for the power value specified
function NUFLib.GetPowerPercent(unit, powerValue)
	local powerPercent
	
	if unit.calling == "warrior" then
		powerPercent = powerValue/100
	elseif unit.calling == "rogue" then
		powerPercent = powerValue/100
	elseif unit.calling == "mage" then
		powerPercent = powerValue/unit.manaMax
	elseif unit.calling == "cleric" then
		powerPercent = powerValue/unit.manaMax
	end
	
	return powerPercent
end
