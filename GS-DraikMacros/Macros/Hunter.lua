local Sequences = GnomeSequencer_Sequences

------------------
----- Hunter
------------------
Sequences['BMsingle'] = {
	specID = 253,
	author = "Jimmy Boy Albrecht",
 	helpTxt = "Single Target - Talent: 3111323",
	StepFunction = [[
		limit = limit or 1
		if step == limit then
			limit = limit % #macros + 1
			step = 1
		else
			step = step % #macros + 1
		end
	]],   PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/petattack [@target,harm]
/petautocastoff [group] Growl
/petautocaston [nogroup] Growl
/cast [target=focus, exists, nodead],[target=pet, exists, nodead] Misdirection
/cast [nochanneling] Intimidation
]], 
 
'/cast [nochanneling] Cobra Shot',
'/cast [nochanneling] !Kill Command',
'/cast [nochanneling] Bestial Wrath',
'/cast [nochanneling] !Dire Beast',
'/cast [nochanneling] Barrage',

PostMacro = [[
/startattack
/petattack
/cast Aspect of the Wild
/use [combat]13
/use [combat]14
]],
}

Sequences['BMaoe'] = {
	specID = 253,
	author = "Jimmy Boy Albrecht",
	helpTxt = "AoE - Talent: 3111323",
	StepFunction = [[
		limit = limit or 1
		if step == limit then
			limit = limit % #macros + 1
			step = 1
		else
			step = step % #macros + 1
		end
	]],   PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/petattack [@target,harm]
/petautocastoff [group] Growl
/petautocaston [nogroup] Growl
/cast [target=focus, exists, nodead],[target=pet, exists, nodead] Misdirection
/cast [nochanneling] Intimidation
]], 
 
'/cast [nochanneling] Multi-Shot',
'/cast [nochanneling] !Kill Command',
'/cast [nochanneling] Bestial Wrath',
'/cast [nochanneling] !Dire Beast',
'/cast [nochanneling] Barrage',

PostMacro = [[
/startattack
/petattack
/cast Aspect of the Wild
/use [combat]13
/use [combat]14
]],
}