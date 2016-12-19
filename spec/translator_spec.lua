describe('API Translator', function()
  setup (function()
    require("../spec/mockGSE")
    require("../GSE/API/Statics")
    require("../GSE/API/InitialOptions")
    require("../GSE/Localization/enUS")
    require("../GSE/Localization/enUSHash")
    require("../GSE/Localization/enUSSHADOW")
    require("../GSE/API/StringFunctions")
    require("../GSE/API/translator")
  end)

  it("Passes through non spell commands ", function()
    assert.are.equal("/targetenemy", GSE.TranslateString("/targetenemy", "enUS", "enUS"))

  end)

end)
