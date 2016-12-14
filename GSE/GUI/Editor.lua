local GNOME,_ = ...
local Statics = GSE.Static
local GSE = GSE

local AceGUI = LibStub("AceGUI-3.0")
local L = GSE.L
local libS = LibStub:GetLibrary("AceSerializer-3.0")
local libC = LibStub:GetLibrary("LibCompress")
local libCE = libC:GetAddonEncodeTable()



local otherversionlistboxvalue = ""
local default = 1
local raid = 1
local pvp = 1
local mythic = 1
local classid = GSE.GetCurrentClassID()

local editframe = AceGUI:Create("Frame")
editframe:Hide()
GSE.GUIEditFrame = editframe
editframe.Sequence = {}
editframe.Sequence.MacroVersions = {}
editframe.SequenceName = ""
editframe.Default = 1
editframe.Raid = 1
editframe.PVP = 1
editframe.Mythic = 1
editframe.ClassID = classid
editframe.tempEdits = {}

editframe:SetTitle(L["Sequence Editor"])
--editframe:SetStatusText(L["Gnome Sequencer: Sequence Editor."])
editframe:SetCallback("OnClose", function (self) editframe:Hide();  GSE.GUIShowViewer(); end)
editframe:SetLayout("List")


local specdropdownvalue = editframe.SpecID


function GSE.GUICreateEditorTabs()
  local tabl = {
    {
      text=L["Configuration"],
      value="config"
    },
  }
  for k,v in ipairs(editframe.Sequence.MacroVersions) do
    local insline = {}
    insline.text = tostring(k)
    insline.value = tostring(k)
    table.insert(tabl, insline)
  end
  table.insert(tabl,   {
      text=L["New"],
      value="new"
    }  )
  return tabl
end

function GSE.GUIEditorPerformLayout(frame)
  frame:ReleaseChildren()
  editframe.tempEdits = {}
  local headerGroup = AceGUI:Create("SimpleGroup")
  headerGroup:SetFullWidth(true)
  headerGroup:SetLayout("Flow")


  local nameeditbox = AceGUI:Create("EditBox")
  nameeditbox:SetLabel(L["Sequence Name"])
  nameeditbox:SetWidth(250)
  nameeditbox:SetCallback("OnTextChanged", function() editframe.SequenceName = nameeditbox:GetText(); end)
  nameeditbox:DisableButton( true)
  nameeditbox:SetText(editframe.SequenceName)
  editframe.nameeditbox = nameeditbox
  headerGroup:AddChild(nameeditbox)

  local spacerlabel = AceGUI:Create("Label")
  spacerlabel:SetWidth(300)
  headerGroup:AddChild(spacerlabel)

  local iconpicker = AceGUI:Create("Icon")
  iconpicker:SetLabel(L["Macro Icon"])
  iconpicker.frame:RegisterForDrag("LeftButton")
  iconpicker.frame:SetScript("OnDragStart", function()
    if not GSE.isEmpty(editframe.SequenceName) then
      PickupMacro(editframe.SequenceName)
    end
  end)
  iconpicker:SetImage(GSEOptions.DefaultDisabledMacroIcon)
  headerGroup:AddChild(iconpicker)
  editframe.iconpicker = iconpicker

  frame:AddChild(headerGroup)

  local tabgrp =  AceGUI:Create("TabGroup")
  tabgrp:SetLayout("Flow")
  tabgrp:SetTabs(GSE.GUICreateEditorTabs())
  editframe.ContentContainer = tabgrp


  tabgrp:SetCallback("OnGroupSelected",  function (container, event, group) GSE.GUISelectEditorTab(container, event, group) end)
  tabgrp:SetFullWidth(true)
  tabgrp:SetFullHeight(true)

  tabgrp:SelectTab("config")
  frame:AddChild(tabgrp)



  local editOptionsbutton = AceGUI:Create("Button")
  editOptionsbutton:SetText(L["Options"])
  editOptionsbutton:SetWidth(150)
  editOptionsbutton:SetCallback("OnClick", function() GSE.OpenOptionsPanel() end)

  local transbutton = AceGUI:Create("Button")
  transbutton:SetText(L["Send"])
  transbutton:SetWidth(150)
  transbutton:SetCallback("OnClick", function() GSE.GUIShowTransmissionGui(editframe.ClassID.. "," ..editframe.SequenceName) end)

  local editButtonGroup = AceGUI:Create("SimpleGroup")
  editButtonGroup:SetWidth(602)
  editButtonGroup:SetLayout("Flow")
  editButtonGroup:SetHeight(15)

  local savebutton = AceGUI:Create("Button")
  savebutton:SetText(L["Save"])
  savebutton:SetWidth(150)
  savebutton:SetCallback("OnClick", function()
    editframe.Sequence.MacroVersions = editframe.tempEdits
    GSE.GUIUpdateSequenceDefinition(editframe.ClassID, editframe.SequenceName, editframe.Sequence)
  end)
  editButtonGroup:AddChild(savebutton)

  local delbutton = AceGUI:Create("Button")
  delbutton:SetText(L["Delete"])
  delbutton:SetWidth(150)
  delbutton:SetCallback("OnClick", function() GSE.GUIDeleteSequence(editframe.ClassID, editframe.SequenceName) end)
  editButtonGroup:AddChild(delbutton)

  editButtonGroup:AddChild(transbutton)
  editButtonGroup:AddChild(editOptionsbutton)
  frame:AddChild(editButtonGroup)

end

function GSE.GetVersionList()
  local tabl = {}
  for k,v in ipairs(editframe.Sequence.MacroVersions) do
    tabl[tostring(k)] = tostring(k)
  end
  return tabl
end

function GSE:GUIDrawMetadataEditor(container)
  editframe.iconpicker:SetImage(GSE.GetMacroIcon(editframe.ClassID, editframe.SequenceName))

  local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  scrollcontainer:SetFullWidth(true)
  scrollcontainer:SetHeight(260)
  scrollcontainer:SetLayout("Fill") -- important!

  local contentcontainer = AceGUI:Create("ScrollFrame")
  scrollcontainer:AddChild(contentcontainer)

  local metasimplegroup = AceGUI:Create("SimpleGroup")
  metasimplegroup:SetLayout("Flow")
  metasimplegroup:SetWidth(606)

  local speciddropdown = AceGUI:Create("Dropdown")
  speciddropdown:SetLabel(L["Specialisation / Class ID"])
  speciddropdown:SetWidth(200)
  speciddropdown:SetList(GSE.GetSpecNames())
  speciddropdown:SetCallback("OnValueChanged", function (obj,event,key)
    specdropdownvalue = key;
    editframe.SpecID = key
    editframe.Sequence.SpecID = key
    editFrame.ClassID = GSE.GetClassIDforSpec(key)
  end)
  metasimplegroup:AddChild(speciddropdown)
  speciddropdown:SetValue(Statics.SpecIDList[editframe.Sequence.SpecID])


  local spacerlabel1 = AceGUI:Create("Label")
  spacerlabel1:SetWidth(50)
  metasimplegroup:AddChild(spacerlabel1)

  local langeditbox = AceGUI:Create("EditBox")
  langeditbox:SetLabel(L["Language"])
  langeditbox:SetWidth(100)
  langeditbox:DisableButton( true)
  metasimplegroup:AddChild(langeditbox)
  local lang = editframe.Sequence.Lang
  if GSE.isEmpty(lang) then
    lang = "enUS"
  end
  langeditbox:SetText(lang)
  langeditbox:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Lang = key
  end)

  local spacerlabel2 = AceGUI:Create("Label")
  spacerlabel2:SetWidth(50)
  metasimplegroup:AddChild(spacerlabel2)

  local talentseditbox = AceGUI:Create("EditBox")
  talentseditbox:SetLabel(L["Talents"])
  talentseditbox:SetWidth(200)
  talentseditbox:DisableButton( true)
  metasimplegroup:AddChild(talentseditbox)
  contentcontainer:AddChild(metasimplegroup)
  talentseditbox:SetText(editframe.Sequence.Talents)
  talentseditbox:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Talents = key
  end)
  local helpeditbox = AceGUI:Create("MultiLineEditBox")
  helpeditbox:SetLabel(L["Help Information"])
  helpeditbox:SetWidth(250)
  helpeditbox:DisableButton( true)
  helpeditbox:SetNumLines(4)
  helpeditbox:SetFullWidth(true)
  if not GSE.isEmpty(editframe.Sequence.Help) then
    helpeditbox:SetText(editframe.Sequence.Help)
  end
  helpeditbox:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Help = key
  end)
  contentcontainer:AddChild(helpeditbox)

  local helpgroup1 = AceGUI:Create("SimpleGroup")
  helpgroup1:SetLayout("Flow")
  helpgroup1:SetWidth(606)


  local helplinkeditbox = AceGUI:Create("EditBox")
  helplinkeditbox:SetLabel(L["Help Link"])
  helplinkeditbox:SetWidth(250)
  helplinkeditbox:DisableButton( true)
  if not GSE.isEmpty(editframe.Sequence.Helplink) then
    helplinkeditbox:SetText(editframe.Sequence.Helplink)
  end
  helplinkeditbox:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Helplink = key
  end)
  helpgroup1:AddChild(helplinkeditbox)

  local spacerlabel3 = AceGUI:Create("Label")
  spacerlabel3:SetWidth(100)
  helpgroup1:AddChild(spacerlabel3)

  local authoreditbox = AceGUI:Create("EditBox")
  authoreditbox:SetLabel(L["Author"])
  authoreditbox:SetWidth(250)
  authoreditbox:DisableButton( true)
  if not GSE.isEmpty(editframe.Sequence.Author) then
    authoreditbox:SetText(editframe.Sequence.Author)
  end
  authoreditbox:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Author = key
  end)
  helpgroup1:AddChild(authoreditbox)

  contentcontainer:AddChild(helpgroup1)

  local defgroup1 = AceGUI:Create("SimpleGroup")
  defgroup1:SetLayout("Flow")
  defgroup1:SetWidth(606)


  local defaultdropdown = AceGUI:Create("Dropdown")
  defaultdropdown:SetLabel(L["Default Version"])
  defaultdropdown:SetWidth(250)
  defaultdropdown:SetList(GSE.GetVersionList())
  defaultdropdown:SetValue(tostring(editframe.Default))
  defgroup1:AddChild(defaultdropdown)
  defaultdropdown:SetCallback("OnValueChanged", function (obj,event,key)
    editframe.Sequence.Default = tonumber(key)
    editframe.Default = tonumber(key)
  end)

  local spacerlabel4 = AceGUI:Create("Label")
  spacerlabel4:SetWidth(100)
  defgroup1:AddChild(spacerlabel4)

  local raiddropdown = AceGUI:Create("Dropdown")
  raiddropdown:SetLabel(L["Raid"])
  raiddropdown:SetWidth(250)
  raiddropdown:SetList(GSE.GetVersionList())
  raiddropdown:SetValue(tostring(editframe.Raid))
  defgroup1:AddChild(raiddropdown)
  raiddropdown:SetCallback("OnValueChanged", function (obj,event,key)
    if editframe.Sequence.Default == tonumber(key) then
      editframe.Sequence.Raid = nil
    else
      editframe.Sequence.Raid = tonumber(key)
      editframe.Raid = tonumber(key)
    end
  end)

  contentcontainer:AddChild(defgroup1)

  local defgroup2 = AceGUI:Create("SimpleGroup")
  defgroup2:SetLayout("Flow")
  defgroup2:SetWidth(606)

  local mythicdropdown = AceGUI:Create("Dropdown")
  mythicdropdown:SetLabel(L["Mythic"])
  mythicdropdown:SetWidth(250)
  mythicdropdown:SetList(GSE.GetVersionList())
  mythicdropdown:SetValue(tostring(editframe.Mythic))
  mythicdropdown:SetCallback("OnValueChanged", function (obj,event,key)
    if editframe.Sequence.Default == tonumber(key) then
      editframe.Sequence.Mythic = nil
    else
      editframe.Sequence.Mythic = tonumber(key)
      editframe.Mythic = tonumber(key)
    end
  end)
  defgroup2:AddChild(mythicdropdown)

  local spacerlabel5 = AceGUI:Create("Label")
  spacerlabel5:SetWidth(100)
  defgroup2:AddChild(spacerlabel5)

  local pvpdropdown = AceGUI:Create("Dropdown")
  pvpdropdown:SetLabel(L["PVP"])
  pvpdropdown:SetWidth(250)
  pvpdropdown:SetList(GSE.GetVersionList())
  pvpdropdown:SetValue(tostring(editframe.PVP))
  defgroup2:AddChild(pvpdropdown)
  contentcontainer:AddChild(defgroup2)
  container:AddChild(scrollcontainer)
  pvpdropdown:SetCallback("OnValueChanged", function (obj,event,key)
    if editframe.Sequence.Default == tonumber(key) then
      editframe.Sequence.PVP = nil
    else
      editframe.Sequence.PVP = tonumber(key)
      editframe.PVP = tonumber(key)
    end
  end)
end

function GSE:GUIDrawMacroEditor(container, version)
  if GSE.isEmpty(version) then
    version = 1
    local editmacro = {}
    editmacro.PreMacro = {}
    editmacro.PostMacro = {}
    editmacro.KeyPress = {}
    editmacro.KeyRelease = {}
    editmacro.StepFunction = "Sequential"
    editmacro[1] = "/say Hello"
    editframe.tempEdits[version] = editmacro
  else
    editframe.tempEdits[version] = GSE.GUIEditFrame.Sequence.MacroVersions[tonumber(version)]
  end


  local layoutcontainer = AceGUI:Create("SimpleGroup")
  layoutcontainer:SetFullWidth(true)
  layoutcontainer:SetHeight(260)
  layoutcontainer:SetLayout("Flow") -- important!

  local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  --scrollcontainer:SetFullWidth(true)
  --scrollcontainer:SetFullHeight(true) -- probably?
  scrollcontainer:SetWidth(546)
  scrollcontainer:SetHeight(260)
  scrollcontainer:SetLayout("Fill") -- important!

  local contentcontainer = AceGUI:Create("ScrollFrame")
  scrollcontainer:AddChild(contentcontainer)


  local linegroup1 = AceGUI:Create("SimpleGroup")
  linegroup1:SetLayout("Flow")
  linegroup1:SetWidth(606)

  local stepdropdown = AceGUI:Create("Dropdown")
  stepdropdown:SetLabel(L["Step Function"])
  stepdropdown:SetWidth(250)
  stepdropdown:SetList({
    ["Sequential"] = L["Sequential (1 2 3 4)"],
    ["Priority"] = L["Priority List (1 12 123 1234)"],

  })
  stepdropdown:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].StepFunction = value
    GSE.PrintDebugMessage("StepValue Set: " .. stepvalue, GNOME)
  end)
  stepdropdown:SetValue(editframe.tempEdits[version].StepFunction)
  linegroup1:AddChild(stepdropdown)

  local spacerlabel1 = AceGUI:Create("Label")
  spacerlabel1:SetWidth(5)
  linegroup1:AddChild(spacerlabel1)

  local looplimit = AceGUI:Create("EditBox")
  looplimit:SetLabel(L["Inner Loop Limit"])
  looplimit:DisableButton(true)
  looplimit:SetMaxLetters(4)
  looplimit:SetWidth(100)
  looplimit.editbox:SetNumeric()
  linegroup1:AddChild(looplimit)
  if not GSE.isEmpty(editframe.tempEdits[version].LoopLimit) then
    looplimit.SetText(editframe.tempEdits[version].LoopLimit)
  end
  looplimit:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].LoopLimit = value
  end)

  local spacerlabel7 = AceGUI:Create("Label")
  spacerlabel7:SetWidth(5)
  linegroup1:AddChild(spacerlabel7)

  local delversionbutton = AceGUI:Create("Button")
  delversionbutton:SetText(L["Delete Version"])
  delversionbutton:SetWidth(150)
  delversionbutton:SetCallback("OnClick", function() GSE.GUIDeleteVersion(version) end)
  linegroup1:AddChild(delversionbutton)

  contentcontainer:AddChild(linegroup1)
  local linegroup2 = AceGUI:Create("SimpleGroup")
  linegroup2:SetLayout("Flow")
  linegroup2:SetWidth(606)

  local KeyPressbox = AceGUI:Create("MultiLineEditBox")
  KeyPressbox:SetLabel(L["KeyPress"])
  KeyPressbox:SetNumLines(2)
  KeyPressbox:DisableButton(true)
  KeyPressbox:SetWidth(270)
  KeyPressbox.editBox:SetScript( "OnLeave",  function() GSE.GUIParseText(KeyPressbox) end)
  if not GSE.isEmpty(editframe.tempEdits[version].KeyPress) then
    KeyPressbox:SetText(table.concat(editframe.tempEdits[version].KeyPress, "\n"))
  end
  KeyPressbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].KeyPress = GSE.SplitMeIntolines(value)
  end)
  linegroup2:AddChild(KeyPressbox)

  local spacerlabel2 = AceGUI:Create("Label")
  spacerlabel2:SetWidth(6)
  linegroup2:AddChild(spacerlabel2)

  local PreMacro = AceGUI:Create("MultiLineEditBox")
  PreMacro:SetLabel(L["PreMacro"])
  PreMacro:SetNumLines(2)
  PreMacro:DisableButton(true)
  PreMacro:SetWidth(270)
  PreMacro.editBox:SetScript( "OnLeave",  function() GSE.GUIParseText(PreMacro) end)
  if not GSE.isEmpty(editframe.tempEdits[version].PreMacro) then
    PreMacro:SetText(table.concat(editframe.tempEdits[version].PreMacro, "\n"))
  end
  PreMacro:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].PreMacro = GSE.SplitMeIntolines(value)
  end)
  linegroup2:AddChild(PreMacro)

  contentcontainer:AddChild(linegroup2)

  local spellbox = AceGUI:Create("MultiLineEditBox")
  spellbox:SetLabel(L["Sequence"])
  spellbox:SetNumLines(8)
  spellbox:DisableButton(true)
  spellbox:SetFullWidth(true)
  spellbox.editBox:SetScript( "OnLeave",  function() GSE.GUIParseText(KeyPressbox) end)
  spellbox.editBox:SetScript("OnTextChanged", function () end)
  spellbox:SetText(table.concat(editframe.tempEdits[version], "\n"))
  spellbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version] = GSE.SplitMeIntolines(value)
  end)
  contentcontainer:AddChild(spellbox)

  local linegroup3 = AceGUI:Create("SimpleGroup")
  linegroup3:SetLayout("Flow")
  linegroup3:SetWidth(606)

  local KeyReleasebox = AceGUI:Create("MultiLineEditBox")
  KeyReleasebox:SetLabel(L["KeyRelease"])
  KeyReleasebox:SetNumLines(2)
  KeyReleasebox:DisableButton(true)
  KeyReleasebox:SetWidth(270)
  KeyReleasebox.editBox:SetScript( "OnLeave",  function() GSE.GUIParseText(KeyPressbox) end)
  KeyReleasebox.editBox:SetScript("OnTextChanged", function () end)
  if not GSE.isEmpty(editframe.tempEdits[version].KeyRelease) then
    KeyReleasebox:SetText(table.concat(editframe.tempEdits[version].KeyRelease, "\n"))
  end
  KeyReleasebox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].KeyRelease = GSE.SplitMeIntolines(value)
  end)
  linegroup3:AddChild(KeyReleasebox)

  local spacerlabel3 = AceGUI:Create("Label")
  spacerlabel3:SetWidth(6)
  linegroup3:AddChild(spacerlabel3)

  local PostMacro = AceGUI:Create("MultiLineEditBox")
  PostMacro:SetLabel(L["PostMacro"])
  PostMacro:SetNumLines(2)
  PostMacro:DisableButton(true)
  PostMacro:SetWidth(270)
  PostMacro.editBox:SetScript( "OnLeave",  function() GSE.GUIParseText(PostMacro) end)
  linegroup3:AddChild(PostMacro)
  if not GSE.isEmpty(editframe.tempEdits[version].PostMacro) then
    PostMacro:SetText(table.concat(editframe.tempEdits[version].PostMacro, "\n"))
  end
  PostMacro:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].PostMacro = GSE.SplitMeIntolines(value)
  end)
  contentcontainer:AddChild(linegroup3)

  layoutcontainer:AddChild(scrollcontainer)

  local toolbarcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  toolbarcontainer:SetWidth(85)

  local heading2 = AceGUI:Create("Label")
  heading2:SetText(L["Resets"])
  toolbarcontainer:AddChild(heading2)

  local targetresetcheckbox = AceGUI:Create("CheckBox")
  targetresetcheckbox:SetType("checkbox")
  targetresetcheckbox:SetWidth(78)
  targetresetcheckbox:SetTriState(false)
  targetresetcheckbox:SetLabel(L["Target"])
  toolbarcontainer:AddChild(targetresetcheckbox)
  if editframe.tempEdits[version].Target then
    targetresetcheckbox:SetValue(true)
  end
  targetresetcheckbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Target = value
  end)

  local combatresetcheckbox = AceGUI:Create("CheckBox")
  combatresetcheckbox:SetType("checkbox")
  combatresetcheckbox:SetWidth(78)
  combatresetcheckbox:SetTriState(true)
  combatresetcheckbox:SetLabel(L["Combat"])
  toolbarcontainer:AddChild(combatresetcheckbox)
  combatresetcheckbox:SetValue(editframe.tempEdits[version].Combat)
  combatresetcheckbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Combat = value
  end)

  local headingspace1 = AceGUI:Create("Label")
  headingspace1:SetText(" ")
  toolbarcontainer:AddChild(headingspace1)

  local heading1 = AceGUI:Create("Label")
  heading1:SetText(L["Use"])
  toolbarcontainer:AddChild(heading1)

  local headcheckbox = AceGUI:Create("CheckBox")
  headcheckbox:SetType("checkbox")
  headcheckbox:SetWidth(78)
  headcheckbox:SetTriState(true)
  headcheckbox:SetLabel(L["Head"])
  headcheckbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Head = value
  end)
  headcheckbox:SetValue(editframe.tempEdits[version].Head)

  toolbarcontainer:AddChild(headcheckbox)

  local neckcheckbox = AceGUI:Create("CheckBox")
  neckcheckbox:SetType("checkbox")
  neckcheckbox:SetWidth(78)
  neckcheckbox:SetTriState(true)
  neckcheckbox:SetLabel(L["Neck"])
  neckcheckbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Neck = value
  end)
  neckcheckbox:SetValue(editframe.tempEdits[version].Neck)
  toolbarcontainer:AddChild(neckcheckbox)

  local beltcheckbox = AceGUI:Create("CheckBox")
  beltcheckbox:SetType("checkbox")
  beltcheckbox:SetWidth(78)
  beltcheckbox:SetTriState(true)
  beltcheckbox:SetLabel(L["Belt"])
  beltcheckbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Belt = value
  end)
  beltcheckbox:SetValue(editframe.tempEdits[version].Belt)
  toolbarcontainer:AddChild(beltcheckbox)

  local ring1checkbox = AceGUI:Create("CheckBox")
  ring1checkbox:SetType("checkbox")
  ring1checkbox:SetWidth(68)
  ring1checkbox:SetTriState(true)
  ring1checkbox:SetLabel(L["Ring 1"])
  ring1checkbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Ring1 = value
  end)
  ring1checkbox:SetValue(editframe.tempEdits[version].Ring1)
  toolbarcontainer:AddChild(ring1checkbox)

  local ring2checkbox = AceGUI:Create("CheckBox")
  ring2checkbox:SetType("checkbox")
  ring2checkbox:SetWidth(68)
  ring2checkbox:SetTriState(true)
  ring2checkbox:SetLabel(L["Ring 2"])
  ring2checkbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Ring2 = value
  end)
  ring2checkbox:SetValue(editframe.tempEdits[version].Ring2)
  toolbarcontainer:AddChild(ring2checkbox)

  local trinket1checkbox = AceGUI:Create("CheckBox")
  trinket1checkbox:SetType("checkbox")
  trinket1checkbox:SetWidth(78)
  trinket1checkbox:SetTriState(true)
  trinket1checkbox:SetLabel(L["Trinket 1"])
  trinket1checkbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Trinket1 = value
  end)
  trinket1checkbox:SetValue(editframe.tempEdits[version].Trinket1)
  toolbarcontainer:AddChild(trinket1checkbox)

  local trinket2checkbox = AceGUI:Create("CheckBox")
  trinket2checkbox:SetType("checkbox")
  trinket2checkbox:SetWidth(83)
  trinket2checkbox:SetTriState(true)
  trinket2checkbox:SetLabel(L["Trinket 2"])
  trinket2checkbox:SetCallback("OnValueChanged", function (sel, object, value)
    editframe.tempEdits[version].Trinket2 = value
  end)
  trinket2checkbox:SetValue(editframe.tempEdits[version].Trinket2)
  toolbarcontainer:AddChild(trinket2checkbox)

  layoutcontainer:AddChild(toolbarcontainer)
  container:AddChild(layoutcontainer)
end

function GSE.GUISelectEditorTab(container, event, group)
  container:ReleaseChildren()
  editframe.nameeditbox:SetText(GSE.GUIEditFrame.SequenceName)
  editframe.iconpicker:SetImage(GSE.GetMacroIcon(editframe.ClassID, editframe.SequenceName))
  if group == "config" then
    GSE:GUIDrawMetadataEditor(container)
  elseif group == "new" then
    -- Copy the Default to a new version
    table.insert(editframe.Sequence.MacroVersions, editframe.Sequence.MacroVersions[editframe.Sequence.Default])
    GSE.GUIEditorPerformLayout(editframe)
    GSE.GUISelectEditorTab(container, event, table.getn(editframe.Sequence.MacroVersions))
  else
    GSE:GUIDrawMacroEditor(container, group)
  end
end

function GSE.GUIDeleteVersion(version)
  version = tonumber(version)
  local sequence = editframe.Sequence
  if table.getn(sequence.MacroVersions) <= 1 then
    GSE.Print(L["This is the only version of this macro.  Delete the entire macro to delete this version."])
    return
  end
  if sequence.Default == version then
    GSE.Print(L["You cannot delete the Default version of this macro.  Please choose another version to be the Default on the Configuration tab."])
    return
  end
  local printtext = L["Macro Version %d deleted."]
  if sequence.PVP == version then
    sequence.PVP = sequence.Default
    printtext = printtext .. " " .. L["PVP setting changed to Default."]
  end
  if sequence.Raid == version then
    sequence.Raid = sequence.Default
    printtext = printtext .. " " .. L["Raid setting changed to Default."]
  end
  if sequence.Mythic == version then
    sequence.Mythic = sequence.Default
    printtext = printtext .. " " .. L["Mythic setting changed to Default."]
  end

  if sequence.Default > version then
    sequence.Default = tonumber(sequence.Default) - 1
  end
  if not GSE.isEmpty(sequence.PVP) and sequence.PVP > version then
    sequence.PVP = tonumber(sequence.PVP) - 1
  end
  if not GSE.isEmpty(sequence.Raid) and sequence.Raid > version then
    sequence.Raid = tonumber(sequence.Raid) - 1
  end
  if not GSE.isEmpty(sequence.Mythic) and sequence.Mythic > version then
    sequence.Mythic = tonumber(sequence.Mythic) - 1
  end
  table.remove(sequence.MacroVersions, version)
  printtext = printtext .. " " .. L["This change will not come into effect until you save this macro."]
  GSE.GUIEditorPerformLayout(editframe)
  GSE.GUIEditFrame.ContentContainer:SelectTab("config")
  GSE.GUIEditFrame:SetStatusText(string.format(printtext, version))
end
