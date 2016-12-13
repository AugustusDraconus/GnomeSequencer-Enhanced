describe('API Translator', function()
  setup (function()
    require("../spec/mockGSE")
    require("../GSE/API/Statics")
    require("../GSE/API/InitialOptions")
    require("../GSE/Localization/enUS")
    require("../GSE/Localization/enUSHash")
    require("../GSE/Localization/enUSSHADOW")
    require("../GSE/API/StringFunctions")
    require("../GSE/API/CharacterFunctions")
    require("../GSE/API/Storage")
    require("../GSE/API/translator")

    L = GSE.L
    L["No Help Information Available"] = "No Help Information Available"
    L["A sequence collision has occured.  Extra versions of this macro have been loaded.  Manage the sequence to determine how to use them "] = "A sequence collision has occured.  Extra versions of this macro have been loaded.  Manage the sequence to determine how to use them "
    L[" was imported with the following errors."] = " was imported with the following errors."

  end)

  it("Adds a sequence to the Library", function()


    local Sequences = {}
    Sequences["Test1"] = {
      SpecID = 11,
      Author="UnitTest",
      MacroVersions = {
        {
          StepFunction = "Sequential",
          "/cast Spell1",
          "/cast Spell2",
        },
        {
          StepFunction = "Priority",
          "/cast Spell1",
          "/cast Spell2",
        }

      }
    }
    GSE.OOCAddSequenceToCollection("Test1", Sequences["Test1"], 11)
    assert.are.equal(11, GSELibrary[11]["Test1"].SpecID)

  end)

  it("Tests that old macros are converted to new macro format", function ()
    local Sequences = {}

    Sequences['DB_Prot_ST'] = {
      author="LNPV",
      specID=66,
      helpTxt = 'Talents: 2332223',
      icon=236264,
      PreMacro=[[
/targetenemy [noharm][dead]
]],
      "/cast Avenger's Shield",
      "/cast Judgment",
      "/cast Blessed Hammer",
      "/cast Consecration",
      "/cast Light of the Protector",
      "/cast Shield of the Righteous",
      PostMacro=[[
/cast Avenging Wrath
/startattack
      ]],
      }
    local newmacro =   GSE.ConvertLegacySequence(Sequences['DB_Prot_ST'])
    assert.are.equal(66, newmacro.SpecID)
    assert.falsy(newmacro.specID)
    assert.falsy(newmacro["MacroVersions"][1].specID)
    assert.falsy(newmacro["MacroVersions"][1].PreMacro)
  end)

  it("Tests that collisions work properly and that a macro imported twice is added as two MacroVersions", function ()
    local Sequences = {}

    Sequences['DB_Prot_ST'] = {
      author="LNPV",
      specID=66,
      helpTxt = 'Talents: 2332223',
      icon=236264,
      PreMacro=[[
/targetenemy [noharm][dead]
]],
      "/cast Avenger's Shield",
      "/cast Judgment",
      "/cast Blessed Hammer",
      "/cast Consecration",
      "/cast Light of the Protector",
      "/cast Shield of the Righteous",
      PostMacro=[[
/cast Avenging Wrath
/startattack
      ]],
      }
    local newmacro =   GSE.ConvertLegacySequence(Sequences['DB_Prot_ST'])

    GSE.OOCAddSequenceToCollection('DB_Prot_ST', newmacro, 11)
    GSE.OOCAddSequenceToCollection('DB_Prot_ST', newmacro, 11)

    assert.are.equal(66, newmacro.SpecID)
    assert.falsy(GSELibrary[11]['DB_Prot_ST'].specID)
    assert.falsy(GSELibrary[11]['DB_Prot_ST']["MacroVersions"][1].specID)
    assert.falsy(GSELibrary[11]['DB_Prot_ST']["MacroVersions"][1].PreMacro)
    assert.falsy(GSELibrary[11]['DB_Prot_ST']["MacroVersions"][2].specID)
    assert.falsy(GSELibrary[11]['DB_Prot_ST']["MacroVersions"][2].PreMacro)
    assert.are.equal("Sequential", GSELibrary[11]['DB_Prot_ST'].SpecID)
    assert.are.equal([[/targetenemy [noharm][dead]
]], GSELibrary[11]['DB_Prot_ST']["MacroVersions"][2]["KeyPress"][1])
    assert.are.equal("Talents: 2332223", GSELibrary[11]['DB_Prot_ST'].Talents)
    assert.falsy(GSELibrary[11]['DB_Prot_ST'].helpTxt)
  end)

end)
