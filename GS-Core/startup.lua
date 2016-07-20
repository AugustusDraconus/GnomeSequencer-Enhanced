local GNOME, ns = ...
GSMasterSequences = ns



-- Sety defaults.  THese will be overriden once the addon is marked as loaded.
GSMasterOptions = {}
GSMasterOptions.AddInPacks = {}
GSMasterOptions.cleanTempMacro = true
GSMasterOptions.hideSoundErrors = false
GSMasterOptions.hideUIErrors = true
GSMasterOptions.clearUIErrors = false
GSMasterOptions.seedInitialMacro = false
GSMasterOptions.initialised = true
GSMasterOptions.AddInPacks = {}
GSMasterOptions.deleteOrphansOnLogout = false


-- Seed a first instance just to be sure an instance is loaded if we need to.
if GSMasterOptions.seedInitialMacro then
	GSMasterSequences["Draik01"] = {
	specID = 0,
	author = "Draik",
	helpTxt = "Sample GS Hellow World Macro.",
	'/run print("Hellow World!")',
	}
end

-------------------------------------------------------------------------------------
-- GSStaticPriority is a static step function that goes 1121231234123451234561234567
-- use this like StepFunction = GSStaticPriority, in a macro
-- This overides the sequential behaviour that is standard in GS
-------------------------------------------------------------------------------------
GSStaticPriority = [[
	limit = limit or 1
	if step == limit then
		limit = limit % #macros + 1
		step = 1
	else
		step = step % #macros + 1
	end
]]

local function isempty(s)
  return s == nil or s == ''
end


-- Load any Load on Demand addon packs.
-- Only load those beginning with GS-
for i=1,GetNumAddOns() do
    if not IsAddOnLoaded(i) and GetAddOnInfo(i):find("^GS%-") then
        local name, _, _, _, _, _ = GetAddOnInfo(i)
        if name ~= "GS-SequenceEditor" then
					LoadAddOn(i);
        end
				GSMasterOptions.AddInPacks[name] = true
    end

end
