seterrorhandler(_ERRORMESSAGE)

local GNOME, Sequences = ...

local ModifiedMacros = {} -- [macroName] = true if we've already modified this macro

local function isempty(s)
  return s == nil or s == ''
end

local CastCmds = { use = true, cast = true, spell = true }

local function UpdateIcon(self)
	local step = self:GetAttribute('step') or 1
	local button = self:GetName()
	local macro, foundSpell, notSpell = Sequences[button][step], false, ''
	for cmd, etc in gmatch(macro or '', '/(%w+)%s+([^\n]+)') do
		if CastCmds[strlower(cmd)] then
			local spell, target = SecureCmdOptionParse(etc)
			if spell then
				if GetSpellInfo(spell) then
					SetMacroSpell(button, spell, target)
					foundSpell = true
					break
				elseif notSpell == '' then
					notSpell = spell
				end
			end
		end
	end
	if not foundSpell then SetMacroItem(button, notSpell) end
end

		
local OnClick = [=[
	local step = self:GetAttribute('step')
	self:SetAttribute('macrotext', self:GetAttribute('PreMacro') .. macros[step] .. self:GetAttribute('PostMacro'))
	%s
	if not step or not macros[step] then -- User attempted to write a step method that doesn't work, reset to 1
		print('|cffff0000Invalid step assigned by custom step sequence', self:GetName(), step or 'nil')
		step = 1
	end
	self:SetAttribute('step', step)
	self:CallMethod('UpdateIcon')
]=]


for name, sequence in pairs(Sequences) do
	local button = CreateFrame('Button', name, nil, 'SecureActionButtonTemplate,SecureHandlerBaseTemplate')
	button:SetAttribute('type', 'macro')
	button:Execute('name, macros = self:GetName(), newtable([=======[' .. strjoin(']=======],[=======[', unpack(sequence)) .. ']=======])')
	button:SetAttribute('step', 1)
	button:SetAttribute('PreMacro', (sequence.PreMacro or '') .. '\n')
	button:SetAttribute('PostMacro', '\n' .. (sequence.PostMacro or ''))
	button:WrapScript(button, 'OnClick', format(OnClick, sequence.StepFunction or 'step = step % #macros + 1'))
	button.UpdateIcon = UpdateIcon
end


local IgnoreMacroUpdates = false
local f = CreateFrame('Frame')
f:SetScript('OnEvent', function(self, event)
    if (event == 'UPDATE_MACROS' or event == 'PLAYER_ENTERING_WORLD') and not IgnoreMacroUpdates then
        if not InCombatLockdown() then
	    IgnoreMacroUpdates = true
                for name, sequence in pairs(Sequences) do
                    local macroIndex = GetMacroIndexByName(name)
		    if macroIndex and macroIndex ~= 0 then
		        if not ModifiedMacros[name] then
			    ModifiedMacros[name] = true
			    EditMacro(macroIndex, nil, nil, '#showtooltip\n/click ' .. name)
		        end
                        _G[name]:UpdateIcon()
		    elseif ModifiedMacros[name] then
		        ModifiedMacros[name] = nil
		    end
	        end
	        IgnoreMacroUpdates = false
            else
	        self:RegisterEvent('PLAYER_REGEN_ENABLED')
            end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		self:GetScript('OnEvent')(self, 'UPDATE_MACROS')
	end
    end)
f:RegisterEvent('UPDATE_MACROS')
f:RegisterEvent('PLAYER_ENTERING_WORLD')

----------------------------
-- Draik's Mods
----------------------------

local function registerMacro(macroName, icon)
    local macroIndex = GetMacroIndexByName(name)
    If macroIndex and macroIndex ~= 0 then
        -- Macro exists do nothing
    else
	-- Create Macro as a player macro
        macroid = CreateMacro(macroName, icon, '#showtooltip\n/click ' .. macroName, 1)
        ModifiedMacros[macroName] = true
    end
end


local function ListMacros(txt)
	local currentSpec = GetSpecialization()
	local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec)) or "None"
	for name, sequence in pairs(Sequences) do
		if sequence.specID ~= 1000 then
                  local _, specname, specdescription, specicon, _, specrole, specclass = GetSpecializationInfoByID(sequence.specID)
		  if sequence.specID == currentSpecID or string.upper(txt) == specclass then
			print('|cffff0000' .. GNOME .. ':|r |cFF00FF00' .. name ..'|r ' .. sequence.helpTxt .. ' |cFFFFFF00' .. specclass .. ' ' .. specname .. ' |cFF0000FFContributed by: ' .. sequence.author ..'|r ' )
			registerMacro(name, (sequence.icon ~= nil and sequence.icon or icon))
		  elseif txt == "all" or sequence.specID == 0 then
                        print('|cffff0000' .. GNOME .. ':|r |cFF00FF00' .. name ..'|r ' .. sequence.helpTxt .. ' |cFFFFFF00' .. ' |cFF0000FFContributed by: ' .. sequence.author ..'|r ' )
                  end
                end
	end
end

local function PrintGnomeHelp()
	print('|cffff0000' .. GNOME .. ':|r GnomeSequencer was originally written by semlar of wowinterface.com.')
	print('|cffff0000' .. GNOME .. ':|r This is a small addon that allows you create a sequence of macros to be executed at the push of a button.')
	print('|cffff0000' .. GNOME .. ":|r Like a /castsequence macro, it cycles through a series of commands when the button is pushed. However, unlike castsequence, it uses macro text for the commands instead of spells, and it advances every time the button is pushed instead of stopping when it can't cast something.")
	print('|cffff0000' .. GNOME .. ':|r This version has been modified by Draik of Nagrand to serve as a collection of macros that will be updated over time. ')
	print('|cffff0000' .. GNOME .. ':|r To get started |cFF00FF00/gnome|r will list any macros available to your class.  This will also add any macros available for your current spec to the macro interface.')
        orint('|cffff0000' .. GNOME .. ':|r |cFF00FF00/gnome listall|r will produce a list of all available macros with some help information.')
	print('|cffff0000' .. GNOME .. ':|r To use a macro, open the macros interface and create a macro with the exact same name as one from the list.  A new macro with two lines will be created and place this on your action bar.')
	print('|cffff0000' .. GNOME .. ':|r The command |cFF00FF00/gnome showspec|r will show your current Specialisation and the SPECID needed to tag any existing macros.')

end

SLASH_GNOME1, SLASH_GNOME2, SLASH_GNOME3 = "/gnome", "/gs", "/gnomesequencer"
SlashCmdList["GNOME"] = function (msg, editbox)
	if msg == "listall" then
		ListMacros("all")
	elseif msg == "class" or msg == UnitClass("player") then
	    local _, englishclass = UnitClass("player")
	    ListMacros(englishclass)
	elseif msg == "showspec" then
            local currentSpec = GetSpecialization()
	    local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec)) or "None"
            local _, specname, specdescription, specicon, _, specrole, specclass = GetSpecializationInfoByID(currentSpecID)
            print('|cffff0000' .. GNOME .. ':|r Your current Specialisation is ', currentSpecID, ':', specname)
	elseif msg == "help" then
	    PrintGnomeHelp()
	elseif msg == "update" then
            updateMacros()
	else
	    ListMacros(GetSpecialization())
	end
end