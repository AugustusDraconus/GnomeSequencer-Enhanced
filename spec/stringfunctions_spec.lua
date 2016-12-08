describe('API StringFunctions', function()
  setup (function()

    require("../spec/mockGSE")
    require("../GSE/API/Statics")
    require("../GSE/API/InitialOptions")
    require("../GSE/API/StringFunctions")

  end)

  it("tests positive assertions", function()
    assert.is_true(true)
    assert.are.equal(1, 1)
    assert.has.errors(function() error("this should fail") end)
  end)

  it("tests isEmpty", function()
    assert.is_true(GSE.isEmpty(nil))
    assert.is_true(GSE.isEmpty(''))
    assert.is_false(GSE.isEmpty("String"))
  end)

  -- note these are all different implementations of the same thing
  it ("tests GSE.SplitMeIntolines(str)", function ()
    assert.are.same({[1] = "a", [2] = "b"}, GSE.SplitMeIntolines("a\nb"))
  end)

  it ("tests GSE.lines", function ()
    local tabl = {}
    GSE.lines(tabl, "a\nb")
    assert.are.same({[1] = "a", [2] = "b"}, tabl)
  end)

  it ("tests GSE.split", function ()
    local testring = "a,b"
    local tab1 = GSE.split(testring, ",")
    assert.are.equal(tab1[1], "a")
    assert.are.equal(tab1[2], "b")
  end)

  it ("Tests GSE.FixQuotes", function()
    local teststring = [[Sequences[‘Druid_FeralST’] = {
author=”Aaralak@Nagrand”,
specID=103,
helpTxt = ‘Talents: 3331222’,]]
    local returnstring = [[Sequences['Druid_FeralST'] = {
author="Aaralak@Nagrand",
specID=103,
helpTxt = 'Talents: 3331222',]]
    assert.are.equal(returnstring, GSE.FixQuotes(teststring))
  end)
end)
