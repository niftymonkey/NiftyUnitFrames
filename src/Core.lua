---------------------
-- Nifty Unit Frames 
-- Core.lua
---------------------
NiftyUnitFrames = {}

-- Version Information --
NiftyUnitFrames.Version = "0.1"
NiftyUnitFrames.AddonName = Inspect.Addon.Current()

-- Default Settings --
NiftyUnitFrames.DefaultSettings = {
    PlayerFrame = {
		align = "TOPLEFT",
		x = 800,
		y = 800,
		height = 75,
		width = 200,
		alpha = 75,
	}		
}
NiftyUnitFramesSettings = NiftyUnitFrames.DefaultSettings

-- Make sure saved variables are loaded, otherwise load default --
local function populateSettings(args)
	if args == NiftyUnitFrames.AddonName then
		if not NiftyUnitFramesSettings then NiftyUnitFramesSettings = NiftyUnitFrames.DefaultSettings end
	end
end

table.insert(Event.Addon.SavedVariables.Load.End, {populateSettings, NiftyUnitFrames.AddonName, "SavedVariablesLoaded"})
print("Nifty Unit Frames loaded.")