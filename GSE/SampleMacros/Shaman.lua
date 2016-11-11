------------------------------------------------------------------------------------------
-- Dont edit this file.  It is regularily update when GS-E is updated and any
-- changes you have made may be lost.  Instead either use the GS-myMacros
-- plugin from http://www.wowinterface.com/downloads/info24062-GS-EmyMacrosAddinPack.html
-- or see the wiki on creating Macro Plugins
-- https://github.com/TimothyLuke/GnomeSequenced-Enhanced/wiki/Creating-Addon-Packs
------------------------------------------------------------------------------------------

local GNOME, Sequences = ...

------------------
----- Shaman
------------------
-- Elemental 262


Sequences['SAM_EnhST'] = {
specID = 263,
author = "Suiseiseki - stan",
helpTxt = "Single Target",
KeyPress = [[
/targetenemy [noharm][dead]
]],
"/castsequence [combat] Crash Lightning, Lava Lash, Lava Lash",
"/cast Stormstrike",
"/castsequence Flametongue, Rockbiter, Rockbiter, Rockbiter, Rockbiter, Rockbiter",
'/cast Windsong',
KeyRelease = [[
/cast Feral Lunge
]],
}


Sequences['SAM_enhsingle'] = {
specID = 263,
author = "lloskka",
helpTxt = "Talents  3112112 - Artifact Order: Doom Winds �> Hammer of Storms �> Gathering Storms �> Wind Strikes �> Wind Surge �> Weapons of the elements �> Elemental Healing �> and all the way to Unleash Doom",
StepFunction = "Priority",
KeyPress = [[
/targetenemy [noharm][dead]
]],
"/castsequence Boulderfist, Crash Lightning, !Stormstrike;",
"/castsequence Boulderfist, Stormstrike, Crash Lightning",
"/castsequence [nochanneling] Boulderfist, Boulderfist, !Crash Lightning;",
"/castsequence Boulderfist, Boulderfist;",
"/cast Lightning Bolt",
KeyRelease = [[
/startattack
/cast [combat] Doom Winds
]],
}

Sequences['SAM_ENLegi'] = {
specID = 263,
author = "Andy",
helpTxt = "Talents  1313211",
KeyPress = [[
/targetenemy [noharm][dead]
/startattack
]],
'/castsequence [nochanneling]!Rockbiter,!Lava Lash,!frostbrand,!Lava Lash,!frostbrand',
'/castsequence [nochanneling]reset=6/target !Crash Lightning',
'/castsequence [nochanneling]reset=8.2/target Lightning Bolt',
'/castsequence [nochanneling]reset=11/target !Flametongue',
'/castsequence [nochanneling]reset=15/target !Stormstrike',
'/castsequence [nochanneling]reset=45/target !windsong',
'/castsequence [nochanneling]reset=120/target !Feral Spirit',
'/castsequence [nochanneling]reset=300/target !ascendance',
'/cast !stormstrike',
KeyRelease = [[
/cast [combat] Blood Fury
]],
}


Sequences['SAM_RestoDeeps'] = {
specID = 264,
author = "Draik",
helpTxt = "Talents - 3211233",
KeyPress = [[
/targetenemy [noharm][dead]
]],
'/cast Chain Lightning',
'/cast Flame Shock',
'/cast Earthen Shield Totem',
'/cast Lava Burst',
'/cast Lightning Bolt',
'/cast Lightning Surge Totem',
}

Sequences['SAM_ElemAoE'] = {
specID = 262,
author = "Nano",
helpTxt = 'Talents: 1213112',
StepFunction = "Priority",
KeyPress = [[
/targetenemy [noharm][dead]
]],
'/castsequence reset=target/combat Flame Shock, Chain Lightning, Chain Lightning, Chain Lightning',
'/cast [nochanneling] !Lava Burst',
KeyRelease = [[
/cast Elemental Mastery
/cast Blood Fury
]],
}


Sequences['SAM_Elem'] = {
specID = 262,
author = "Nano",
helpTxt = 'Talents: 1213112',
StepFunction = "Priority",
KeyPress = [[
/targetenemy [noharm][dead]
]],
'/castsequence reset=target/combat Flame Shock,Lightning Bolt,Lightning Bolt,Lightning Bolt',
'/castsequence reset=10 !Earth Shock',
'/cast [nochanneling] !Lava Burst',
KeyRelease = [[
/cast Elemental Mastery
/cast Blood Fury
]],
}

Sequences['SAM_MC_ElemST'] = {
author='Maalkomx',
specID=262,
helpTxt = 'Talents: 2112211',
KeyPress=
[[
/targetenemy [noharm][dead]
/petattack [@target,harm]
]],
"/castsequence reset=combat [nopet:Earth Elemental] Fire Elemental",
"/castsequence [nochanneling] reset=combat Lava Burst, Flame Shock, Lava Burst",
"/castsequence [nochanneling] Lightning Bolt, Lightning Bolt, Lightning Bolt, Lightning Bolt",
"/cast Lava Burst",
KeyRelease=[[
]],
}

Sequences['SAM_MC_ElemAoE'] = {
author='Maalkomx',
specID=262,
helpTxt = 'Talents: 2112211',
KeyPress=[[
/targetenemy [noharm][dead]
/petattack [@target,harm]
]],
"/castsequence reset=combat [nopet:Earth Elemental] Fire Elemental",
"/castsequence [nochanneling] reset=combat Lava Burst, Flame Shock, Lava Burst",
"/castsequence [nochanneling] Chain Lightning, Chain Lightning, Chain Lightning",
"/cast Lava Burst",
}

Sequences['SAM_MC_Surge'] = {
author='Maalkomx',
specID=264,
helpTxt = 'Talents: 3313313',
KeyPress=[[
]],
"/castsequence [nochanneling]reset=30 Healing Stream Totem",
"/castsequence [nochanneling,@mouseover,help,nodead]reset=5 !Riptide",
"/castsequence [nochanneling,@mouseover,help]Healing Surge, Healing Surge, Healing Surge, Healing Surge",
"/castsequence [nochanneling,@mouseover,help]Healing Surge",
KeyRelease=[[
]],
}

Sequences['SAM_MC_Wave'] = {
author='Maalkomx',
specID=264,
helpTxt = 'Talents: 3313313',
KeyPress=[[
]],
"/castsequence [nochanneling]reset=30 Healing Stream Totem",
"/castsequence [nochanneling,@mouseover,help]reset=5 !Riptide",
"/castsequence [nochanneling,@mouseover,help]Healing Wave, Healing Wave, Healing Wave, Healing Wave",
"/castsequence [nochanneling,@mouseover,help]Healing Wave",
KeyRelease=[[
]],
}

Sequences['SAM_MC_Chain'] = {
author='Maalkomx',
specID=264,
helpTxt = 'Talents: 3313313',
KeyPress=[[
]],
"/castsequence [nochanneling]reset=30 Healing Stream Totem",
"/castsequence [nochanneling,@mouseover,help,nodead]reset=5 !Riptide",
"/castsequence [nochanneling,@mouseover,help]Chain Heal, Chain Heal, Chain Heal, Chain Heal",
"/castsequence [nochanneling,@mouseover,help]Healing Surge",
KeyRelease=[[
]],
}
