-- NiftyUnitFrames UI --
NiftyUnitFrames.UI = {}

-- Context
NiftyUnitFrames.UI.Context = UI.CreateContext("NiftyUnitFramesContext")
NiftyUnitFrames.UI.Context:SetPoint("TOPLEFT", UIParent, "TOPLEFT")

-- Player Frame
NiftyUnitFrames.UI.PlayerFrame = {}

-- The actual player frame
local playerFrame = UI.CreateFrame("Frame", "NiftyUnitFramesPlayerFrame", NiftyUnitFrames.UI.Context)
-- Player name and class info
local pfPlayerInfo = UI.CreateFrame("Text", "pfPlayerInfo", playerFrame)
-- The health bar
local pfHealth = UI.CreateFrame("Frame", "pfHealth", playerFrame)
-- The health bar text
local pfHealthText = UI.CreateFrame("Text", "pfHealthText", pfHealth)
-- The "power" bar.  This will be mana or power or energy or whatever the class uses
local pfPower = UI.CreateFrame("Frame", "pfPower", playerFrame)
-- The "power" bar text.
local pfPowerText = UI.CreateFrame("Text", "pfPowerText", pfPower)

-- Initialize the frames.  Use an initialized variable so that we only do this once
function NiftyUnitFrames.UI.Init()

    -- only if we haven't already initialized the frames
    if not NiftyUnitFrames.UI.initialized then
    
        -- get the player detail so we can get all the info
        local playerDetail = NUFLib.GetPlayerDetail()
        -- get some values from the player detail
        local pbColor = NUFLib.GetPowerBarColor(playerDetail)
        local percentHealth = NUFLib.GetCurrentHealthPercent(playerDetail)
        local percentPower = NUFLib.GetCurrentPowerPercent(playerDetail)

        -- create the player frame
        playerFrame:SetPoint(NiftyUnitFramesSettings.PlayerFrame.align, UIParent, NiftyUnitFramesSettings.PlayerFrame.align, NiftyUnitFramesSettings.PlayerFrame.x, NiftyUnitFramesSettings.PlayerFrame.y)
        playerFrame:SetHeight(NiftyUnitFramesSettings.PlayerFrame.height)
        playerFrame:SetWidth(NiftyUnitFramesSettings.PlayerFrame.width)
        playerFrame:SetAlpha(NiftyUnitFramesSettings.PlayerFrame.alpha/100)
        playerFrame:SetBackgroundColor(0, 0, 0, playerFrame:GetAlpha())

        -- create the player info inner frame
        pfPlayerInfo:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, 0)
        pfPlayerInfo:SetFont(NiftyUnitFrames.AddonName, NUFConst.Resources.fontPath .. "verdana.ttf")
        pfPlayerInfo:SetFontSize(18)
        pfPlayerInfo:SetText(playerDetail.name)
        pfPlayerInfo:SetHeight(playerFrame:GetHeight()/3)
        pfPlayerInfo:SetWidth(playerFrame:GetWidth())
        pfPlayerInfo:SetAlpha(playerFrame:GetAlpha())

        -- create the health bar inner frame
        pfHealth:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, playerFrame:GetHeight()/3)
        pfHealth:SetHeight(playerFrame:GetHeight()/3)
        pfHealth:SetWidth(playerFrame:GetWidth())
        pfHealth:SetBackgroundColor(0, .8, 0, playerFrame:GetAlpha())
        -- create the health bar text inner frame
        pfHealthText:SetPoint("TOPLEFT", pfHealth, "TOPLEFT", 0, 0)
        pfHealthText:SetHeight(pfHealth:GetHeight())
        pfHealthText:SetWidth(pfHealth:GetWidth())
        pfHealthText:SetText(tostring(percentHealth))

        -- create the power bar inner frame
        pfPower:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, (playerFrame:GetHeight()/3)*2)
        pfPower:SetHeight(playerFrame:GetHeight()/3)
        pfPower:SetWidth(playerFrame:GetWidth())
        -- set the background color based on the unit's calling
        pfPower:SetBackgroundColor(pbColor.r, pbColor.g, pbColor.b, playerFrame:GetAlpha())
        -- create the power bar text inner frame
        pfPowerText:SetPoint("TOPLEFT", pfPower, "TOPLEFT", 0, 0)
        pfPowerText:SetHeight(pfPower:GetHeight())
        pfPowerText:SetWidth(pfPower:GetWidth())
        pfPowerText:SetText(tostring(percentPower))

        NiftyUnitFrames.UI.initialized = true
    end

end

-- Function that handles updating the health bar on health change
function NiftyUnitFrames.UI.UpdateUnitHealth(units)
    -- get the current player info
    local playerDetail = NUFLib.GetPlayerDetail()
    -- get the percent health as a multiplier so we can modify the health bar width
    local percentHealthMultiplier = NUFLib.GetCurrentHealthPercentMultiplier(playerDetail)
    -- get the percent health value as a string to set in the text frame
    local percentHealth = NUFLib.GetCurrentHealthPercent(playerDetail)
    local formattedHealth = NUFLib.PercentAsString(percentHealth, 0)
    
    -- set the width and the text to the new values
    pfHealth:SetWidth(playerFrame:GetWidth() * percentHealthMultiplier)
    pfHealthText:SetText(formattedHealth)
end

-- Function that handles updating the power bar on power change
function NiftyUnitFrames.UI.UpdatePowerValue(units)
    -- get the current player info
    local playerDetail = NUFLib.GetPlayerDetail()
    -- get the power percent as a multiplier so we can modify the health bar width
    local percentPowerMultiplier = NUFLib.GetCurrentPowerPercentMultiplier(playerDetail)
    -- get the power percent value as a string to set in the text frame
    local percentPower = NUFLib.GetCurrentPowerPercent(playerDetail)
    local formattedPower = NUFLib.PercentAsString(percentPower, 0)
    
    -- set the width and text to the new values
    pfPower:SetWidth(playerFrame:GetWidth() * percentPowerMultiplier)
    pfPowerText:SetText(formattedPower)
end

-- When Event.Unit.Available fires it signals the availability of Inspect.Unit.Detail.  This is necessary before we can get player info.  
-- When this event occurs, we'll fire our init method.  The init method is responsible for ensuring it only runs once.
table.insert(Event.Unit.Available, {NiftyUnitFrames.UI.Init, NiftyUnitFrames.AddonName, "UpdatePlayerInfo"})
-- When unit values change, lets update the corresponding frame information
table.insert(Event.Unit.Detail.Health, {NiftyUnitFrames.UI.UpdateUnitHealth, NiftyUnitFrames.AddonName, "UpdateUnitHealth"})
table.insert(Event.Unit.Detail.Power, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})
table.insert(Event.Unit.Detail.Mana, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})