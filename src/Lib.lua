NUFLib = {}

-- Gets the detail information for the current player.
function NUFLib.GetPlayerDetail()
    -- lookup the current player
    local player = Inspect.Unit.Lookup("player")
    -- get his detail info
    local playerDetail = Inspect.Unit.Detail(player)

    return playerDetail
end

-- Gets the current health percentage multiplier for the specified unit.
function NUFLib.GetCurrentHealthPercentMultiplier(unit)
    return unit.health / unit.healthMax
end

-- Gets the current health percent value for the specified unit
function NUFLib.GetCurrentHealthPercent(unit)
    return NUFLib.GetCurrentHealthPercentMultiplier(unit) * 100
end

-- Gets the "power" bar color for the unit specified
function NUFLib.GetPowerBarColor(unit)
    -- create a return value
    local retVal
  
    -- get the appropriate color RGB setting based on the unit's calling
    if unit.calling == "warrior" then
        retVal = NUFConst.Colors.PowerBar.Warrior
    elseif unit.calling == "rogue" then
        retVal = NUFConst.Colors.PowerBar.Rogue
    elseif unit.calling == "mage" then
        retVal = NUFConst.Colors.PowerBar.Mage
    elseif unit.calling == "cleric" then
        retVal = NUFConst.Colors.PowerBar.Cleric
    end
    
    return retVal
end

-- Gets the "power" bar value for the unit specified
function NUFLib.GetPowerValue(unit)
    -- create a return value
    local retVal
    
    -- get the appropriate power value based on the unit's calling
    if unit.calling == "warrior" then
        retVal = unit.power
    elseif unit.calling == "rogue" then
        retVal = unit.energy
    elseif unit.calling == "mage" then
        retVal = unit.mana
    elseif unit.calling == "cleric" then
        retVal = unit.mana
    end
    
    return retVal
end

-- Gets the current power percent multiplier for the unit specified
function NUFLib.GetCurrentPowerPercentMultiplier(unit)
    -- create a return value
    local retVal

    -- get the power value
    local powerValue = NUFLib.GetPowerValue(unit)
    
    -- do the appropriate math based on the unit's power type and power max
    if unit.calling == "warrior" then
        retVal = powerValue/100
    elseif unit.calling == "rogue" then
        retVal = powerValue/100
    elseif unit.calling == "mage" then
        retVal = powerValue/unit.manaMax
    elseif unit.calling == "cleric" then
        retVal = powerValue/unit.manaMax
    end
    
    return retVal
end

-- Gets the current power percent value for the specified unit
function NUFLib.GetCurrentPowerPercent(unit)
    return NUFLib.GetCurrentPowerPercentMultiplier(unit) * 100
end

-- Gets the percent value as a simple string, formatted to the specified precision
-- Precision simply defines how many decimal points to show
function NUFLib.PercentAsString(percentNumVal, precision)
    -- default to no decimal points
    if not precision then precision = 0 end
    
    local formatString = "%." .. tostring(precision) .. "f"
    
    return string.format(formatString, percentNumVal)
end