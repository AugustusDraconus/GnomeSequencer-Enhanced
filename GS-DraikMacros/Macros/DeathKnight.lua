local Sequences = GnomeSequencer_Sequences

------------------
----- Death Knight
------------------

Sequences['PTRBlood'] = {
specID = 250,
author = "John Mets",
helpTxt = "As for talents its not an issue but it does run real smooth if you have Heartbreaker, Soulgorge and Ossuary.",
StepFunction = [[
		limit = limit or 1
		if step == limit then
			limit = limit % #macros + 1
			step = 1
		else
			step = step % #macros + 1
		end
	]],
    PreMacro = [[
/Cast [combat] Vampiric Blood
/Cast [combat] Dancing Rune Weapon
    ]],
    '/cast Marrowrend',
      "/castsequence reset=combat Death's Caress, Blood Boil, Death Strike, blood Boil, Marrowrend",
      "/castsequence reset=combat Death's Caress, Blood Boil, Blood Boil, death strike, soulgorge",
      "/cast Heart Strike",
      "/cast Death Strike",

    PostMacro = [[
/cast [mod:alt] Anti-Magic Shell
/TargetEnemy [noharm][dead]
/Use [combat] 13
/Use [combat] 14
/script UIErrorsFrame:Hide();
]],
}

Sequences['Frost'] = {
specID = 251,
author = "Suiseiseki",
helpTxt = "Talents: 2132113",
StepFunction = [[
		limit = limit or 1
		if step == limit then
			limit = limit % #macros + 1
			step = 1
		else
			step = step % #macros + 1
		end
	]],
    PreMacro = [[
/use [combat] Obliteration
/use [combat] Pillar Of Frost
    ]],
	'/cast [combat] Glacial Advance',
	'/cast Frost Strike',
	"/cast [combat] Remorseless Winter",
	'/castsequence Howling Blast, Frostscythe, Howling Blast, Obliterate',
	'/castsequence Howling Blast, Howling Blast, Frostscythe, Howling Blast, Obliterate',
    PostMacro = [[
/script UIErrorsFrame:Hide();
    ]],
}

Sequences['FDK2'] = {
specID = 251,
author = "Tazkilla",
helpTxt = "Talents:1111131",
StepFunction = [[
limit = limit or 1
if step == limit then
limit = limit % #macros + 1
step = 1
else
step = step % #macros + 1
end
]],
PreMacro = [[
/cast [combat] Pillar of Frost
/cast [combat] Anti-Magic Shell
]],
'/castsequence reset=combat Frost Strike',
'/cast Obliterate',
'/cast Obliteration',
'/castsequence reset=combat Howling Blast, Howling Blast, Howling Blast, Obliterate',
'/castsequence reset=combat Howling Blast, Howling Blast, Howling Blast, Howling Blast',
PostMacro = [[
/targetenemy [noharm][dead]
/script UIErrorsFrame:Hide();
]],
}
Talents:1111131