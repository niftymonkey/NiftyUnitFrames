-- NiftyUnitFrames UI --
NiftyUnitFrames.UI = {}

-- Context
NiftyUnitFrames.UI.Context = UI.CreateContext("NiftyUnitFramesContext")
NiftyUnitFrames.UI.Context:SetPoint("TOPLEFT", UIParent, "TOPLEFT")

-- Player Frame
NiftyUnitFrames.UI.PlayerFrame = {}

-- Let's simplify player frame settings for code readability
local pfs = NiftyUnitFramesSettings.PlayerFrame;

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

function NiftyUnitFrames.UI.Init()
    if not NiftyUnitFrames.UI.initialized then
		-- get the player detail so we can get all the info
		local playerDetail = NUFLib.GetPlayerDetail()
		-- get some values from the player detail
		local pbColor = NUFLib.GetPowerBarColor(playerDetail)
		local percentHealth = playerDetail.health / playerDetail.healthMax
		local powerValue = NUFLib.GetPowerValue(playerDetail)

		-- create the player frame
		playerFrame:SetPoint(pfs.align, UIParent, pfs.align, pfs.x, pfs.y)
		playerFrame:SetHeight(pfs.height)
		playerFrame:SetWidth(pfs.width)
		playerFrame:SetAlpha(pfs.alpha/100)
		playerFrame:SetBackgroundColor(0, 0, 0, playerFrame:GetAlpha())

		-- create the player info inner frame
		pfPlayerInfo:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, 0)
		pfPlayerInfo:SetFont(NiftyUnitFrames.AddonName, "/resources/fonts/verdana.ttf")
		pfPlayerInfo:SetFontSize(18)
		pfPlayerInfo:SetText(playerDetail.name)
		pfPlayerInfo:SetHeight(playerFrame:GetHeight()/3)
		pfPlayerInfo:SetWidth(playerFrame:GetWidth())
		pfPlayerInfo:SetAlpha(playerFrame:GetAlpha())
		pfPlayerInfo:SetBackgroundColor(0, 0, 0, playerFrame:GetAlpha())

		-- create the health bar inner frame
		pfHealth:SetPoint("TOPLEFT", playerFrame, "TOPLEFT", 0, playerFrame:GetHeight()/3)
		pfHealth:SetHeight(playerFrame:GetHeight()/3)
		pfHealth:SetWidth(playerFrame:GetWidth())
		pfHealth:SetBackgroundColor(0, .8, 0, playerFrame:GetAlpha())
		-- create the health bar text inner frame
		pfHealthText:SetPoint("TOPLEFT", pfHealth, "TOPLEFT", 0, 0)
		pfHealthText:SetHeight(pfHealth:GetHeight())
		pfHealthText:SetWidth(pfHealth:GetWidth())
		local percent = (playerDetail.health/playerDetail.healthMax)*100
		pfHealthText:SetText(tostring(percent))

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
		local powerValue = NUFLib.GetPowerValue(playerDetail)
		local percentPV = NUFLib.GetPowerPercent(playerDetail, powerValue) * 100
		local formatted = string.format("%.0f", tostring(percentPV))
		pfPowerText:SetText(formatted)
		
		NiftyUnitFrames.UI.initialized = true
	end
end

-- Function that handles updating the health bar on health change
function NiftyUnitFrames.UI.UpdateUnitHealth(units)
	local playerDetail = NUFLib.GetPlayerDetail()
	local percentHealth = playerDetail.health / playerDetail.healthMax
	local percent = percentHealth*100
	local formatted = string.format("%.0f", percent)
	pfHealth:SetWidth(playerFrame:GetWidth() * percentHealth)
	pfHealthText:SetText(formatted)
end

-- Function that handles updating the power bar on power change
function NiftyUnitFrames.UI.UpdatePowerValue(units)
	local playerDetail = NUFLib.GetPlayerDetail()
	local powerValue = NUFLib.GetPowerValue(playerDetail)
	local powerPercent = NUFLib.GetPowerPercent(playerDetail, powerValue)
	pfPower:SetWidth(playerFrame:GetWidth() * powerPercent)
	pfPowerText:SetText(tostring(powerPercent*100))
end

table.insert(Event.Unit.Available, {NiftyUnitFrames.UI.Init, NiftyUnitFrames.AddonName, "UpdatePlayerInfo"})
table.insert(Event.Unit.Detail.Health, {NiftyUnitFrames.UI.UpdateUnitHealth, NiftyUnitFrames.AddonName, "UpdateUnitHealth"})
table.insert(Event.Unit.Detail.Power, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})
table.insert(Event.Unit.Detail.Mana, {NiftyUnitFrames.UI.UpdatePowerValue, NiftyUnitFrames.AddonName, "UpdatePowerValue"})