local GSE = GSE
local Statics = GSE.Static

Statics.SampleMacros[4] = {}

local Sequences = Statics.SampleMacros[4]

------------------
----- Rogue
------------------
-- Outlaw 260
-- Assination 259



Sequences['SAM_Outlaw'] = {
specID = 260,
author = "Suiseiseki - www.wowlazymacros.com",
helpTxt = "Outlaw - 1223122",
StepFunction = "Priority",
KeyPress = [[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat]Stealth
/cast [combat] Marked for Death
]],
'/castsequence Ghostly Strike, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Saber Slash',
'/castsequence Saber Slash, Run Through, Saber Slash, Pistol Shot',
'/castsequence [talent:7/1] Slice and Dice; [talent:7/2][talent:7/3] Roll the Bones, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot, Run Through, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot',
'/castsequence Ghostly Strike, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot',
'/cast [@focus] Tricks of the Trade',
}

Sequences['SAM_Assassin'] = {
author='TimothyLuke',
specID=259,
helpTxt = 'Talents: 3113231',
KeyPress=[[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat]Stealth
]],
icon='Ability_Rogue_DeadlyBrew',
"/cast [@focus] Tricks of the Trade",
"/cast Rupture",
"/cast Vendetta",
"/cast Vanish",
"/cast Hemorrhage",
"/cast Garrote",
"/cast Exsanguinate",
"/cast Envenom",
"/cast Mutilate",
}

Sequences['SAM_Subtle'] = {
author='TimothyLuke',
specID=261,
helpTxt = 'Talents: 1233212',
KeyPress=[[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat]Stealth
/cast [combat] Marked for Death
]],
icon='Ability_Stealth',
"/cast [@focus] Tricks of the Trade",
"/cast Symbols of Death",
"/cast Shadowstrike",
"/cast Shadow Blades",
"/cast Vanish",
"/cast Nightblade",
"/cast Shadow Dance",
"/cast Shuriken Storm",
"/cast Eviscerate",
"/cast Backstab",
}

Sequences['SAM_DRoutlaw'] = {
StepFunction = "Priority",
author="Druccy",
specID=260,
helpTxt="Talents - 1232232",
KeyPress = [[
/startattack
/cast [nostealth,nocombat] Stealth
/cast [stealth] ambush
/cast [stealth] cheap shot
/cast Marked for Death
/cast Adrenaline Rush
]],
'/castsequence reset=target Ghostly Strike, Saber Slash, Saber Slash, Pistol Shot, Roll the Bones,feint',
'/cast [nochanneling] Run Through',
'/cast [nochanneling] Between the Eyes',
'/cast [nochanneling] Killing Spree',
'/cast [nochanneling] Crimson Vial',
KeyRelease = [[
/cast [combat] Riposte
]],
}

Sequences['SAM_TLAssassin'] = {
author="Todd Livengood - wowlazymacros.com",
specID=259,
helpTxt = 'Talents: 3233332',
StepFunction = "Priority",
KeyPress=[[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat]Stealth
/cast [stealth] Cheap Shot
]],
"/cast Mutilate",
"/cast Garrote",
"/cast Exsanguinate",
"/cast Mutilate",
"/castsequence reset=5 Rupture,Envenom",
"/cast Hemorrhage",
KeyRelease=[[
/stopattack [stealth]
]],
}


Sequences['SAM_CalliynOutlaw'] = {
author="Ambergreen",
specID=260,
helpTxt = 'Talents: 1333131',
KeyPress=[[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat]Stealth
/cast [combat] Marked for Death
]],
icon='INV_Sword_30',
"/castsequence Ghostly Strike, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Saber Slash",
"/castsequence [mod:alt] Blade Flurry",
"/castsequence Saber Slash, Run Through, Saber Slash, Pistol Shot",
"/castsequence [talent:7/1] Slice and Dice; [talent:7/2][talent:7/3] Roll the Bones, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot, Run Through, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot",
"/castsequence [mod:alt] Blade Flurry",
"/castsequence Ghostly Strike, Saber Slash, Saber Slash, Saber Slash, Saber Slash, Pistol Shot",
"/castsequence [mod:alt] Blade Flurry",
"/cast [@focus] Tricks of the Trade",
"/cast Crimson Vial",
}
