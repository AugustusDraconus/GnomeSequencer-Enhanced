local GNOME, _ = ...
-- Default error handler seems to be _ERRORMESSAGE defined in BasicControls.xml
local Errors = {
	["^attempt to index global 'Sequences'"] = 'Missing mandatory first line in Sequences file: "local _, Sequences = ..."',
	--["[��]"] = 'Invalid quotes detected, replace all quote symbols in the file with normal double or single-quotes.',
}

local function isempty(s)
  return s == nil or s == ''
end

seterrorhandler(function(message)
	local line, err = message:match('GS-%.lua:(%d+): (.+)')
	if err then
		for pattern, response in pairs(Errors) do
			if err:match(pattern) then
				err = response
				break
			end
		end
		C_Timer.After(2, function()
			print(format('|cffff0000[GNOME] syntax error on line %d of Sequences.lua:|r %s', line, err, debuglocals(4)))
		end)
		wipe(Sequences)
		--Sequences[GNOME .. 'DEFAULT'] = ''
	end
end)

local function determinationOutputDestination(message)
  if GSMasterOptions.sendDebugOutputGSDebugOutput then
    GSDebugOutput = GSDebugOutput .. message .. "\n"
	end
	if GSMasterOptions.sendDebugOutputToChat then
    print(message)
	end
end


function GSPrintDebugMessage(message, module)
    if GSMasterOptions.debugSequence == true and module == GSStaticSequenceDebug then
      determinationOutputDestination('|cffff0000' .. GNOME .. ':|r |cFF00FF00 <SEQUENCEDEBUG> |r ' .. message )
		elseif GSMasterOptions.debug and module ~= GSStaticSequenceDebug then
      determinationOutputDestination('|cffff0000' .. (isempty(module) and GNOME or module) .. ':|r |cFF00FF00 <DEBUG> |r ' .. message )
    end

end
