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
local pfHealthTextWrapper = UI.CreateFrame("Frame", "pfHealthTextWrapper", playerFrame)
local pfHealthText = UI.CreateFrame("Text", "pfHealthText", pfHealth)
-- The "power" bar.  This will be mana or power or energy or whatever the class uses
local pfPower = UI.CreateFrame("Frame", "pfPower", playerFrame)
-- The "power" bar text.
local pfPowerTextWrapper = UI.CreateFrame("Frame", "pfPowerTextWrapper", playerFrame)
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
        -- create a power bar text wrapper frame to center anchor our text to.  this will be the same size as a full power bar
        pfHealthTextWrapper:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, (playerFrame:GetHeight()/3))
        pfHealthTextWrapper:SetHeight(playerFrame:GetHeight()/3)
        pfHealthTextWrapper:SetWidth(playerFrame:GetWidth())
        -- create the health bar text inner frame
        pfHealthText:SetPoint("CENTER", pfHealthTextWrapper, "CENTER", 2, 2)
        pfHealthText:SetHeight(pfHealthTextWrapper:GetHeight())
        pfHealthText:SetFont(NiftyUnitFrames.AddonName, NUFConst.Resources.fontPath .. "verdana.ttf")
        pfHealthText:SetText(tostring(percentHealth))

        -- create the power bar inner frame
        pfPower:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, (playerFrame:GetHeight()/3)*2)
        pfPower:SetHeight(playerFrame:GetHeight()/3)
        pfPower:SetWidth(playerFrame:GetWidth())
        -- set the background color based on the unit's calling
        pfPower:SetBackgroundColor(pbColor.r, pbColor.g, pbColor.b, playerFrame:GetAlpha())

        -- create a power bar text wrapper frame to center anchor our text to.  this will be the same size as a full power bar
        pfPowerTextWrapper:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, (playerFrame:GetHeight()/3)*2)
        pfPowerTextWrapper:SetHeight(playerFrame:GetHeight()/3)
        pfPowerTextWrapper:SetWidth(playerFrame:GetWidth())
        -- create our power text frame
        pfPowerText:SetPoint("CENTER", pfPowerTextWrapper, "CENTER", 2, 2)
        pfPowerText:SetHeight(pfPowerTextWrapper:GetHeight())
        pfPowerText:SetFont(NiftyUnitFrames.AddonName, NUFConst.Resources.fontPath .. "verdana.ttf")
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

local dragging = false
local dragOffset = {
    x = 0,
    y = 0,
}

function playerFrame.Event:LeftDown()
    local mouse = Inspect.Mouse()
    dragOffset.x = mouse.x - NiftyUnitFramesSettings.PlayerFrame.x
    dragOffset.y = mouse.y - NiftyUnitFramesSettings.PlayerFrame.y
    dragging = true
end

function playerFrame.Event:LeftUpoutside()
    dragOffset.x = 0
    dragOffset.y = 0
    dragging = false
end

function playerFrame.Event:LeftUp()
    dragOffset.x = 0
    dragOffset.y = 0
    dragging = false
end

function playerFrame.Event:MouseMove()
    if dragging then
        local mouse = Inspect.Mouse()
        NiftyUnitFramesSettings.PlayerFrame.x = mouse.x - dragOffset.x
        NiftyUnitFramesSettings.PlayerFrame.y = mouse.y - dragOffset.y
        playerFrame:SetPoint(NiftyUnitFramesSettings.PlayerFrame.align, UIParent, NiftyUnitFramesSettings.PlayerFrame.align, NiftyUnitFramesSettings.PlayerFrame.x, NiftyUnitFramesSettings.PlayerFrame.y)
    end
end

-- When Event.Unit.Available fires it signals the availability of Inspect.Unit.Detail.  This is necessary before we can get player info.  
-- When this event occurs, we'll fire our init method.  The init method is responsible for ensuring it only runs once.
table.insert(Event.Unit.Available, {NiftyUnitFrames.UI.Init, NiftyUnitFrames.AddonName, "UpdatePlayerInfo"})
-- When unit values change, lets update the corresponding frame information
table.insert(Event.Unit.Detail.Health, {NiftyUnitFrames.UI.UpdateUnitHealth, NiftyUnitFrames.AddonName, "UpdateUnitHealth"})
table.insert(Event.Unit.Detail.Power, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})
table.insert(Event.Unit.Detail.Mana, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})