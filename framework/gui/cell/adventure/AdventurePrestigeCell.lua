local baseCell = autoImport("BaseCell")
AdventurePrestigeCell = class("AdventurePrestigeCell", baseCell)
local vecArrowFoldPos = LuaVector3(1.5, 1, 0)
local vecArrowOpenEuler = LuaVector3(0, 0, -90)
local tempZero = LuaVector3.Zero()

function AdventurePrestigeCell:Init()
  self:FindObjs()
  self:AddEvents()
end

function AdventurePrestigeCell:FindObjs()
  self.objTypeTag = self:FindGO("TypeTag")
  self.labTagName = self:FindComponent("labTagName", UILabel, self.objTypeTag)
  self.labTagAchievedText = self:FindComponent("labAchieved", UILabel, self.objTypeTag)
  self.labTagAchievedNum = self:FindComponent("labAchievedNum", UILabel, self.objTypeTag)
  self.objTagBtnSwitchFold = self:FindGO("BtnSwitchFold", self.objTypeTag)
  self.tsTagfBtnSwitchHoldArrow = self:FindGO("sprIconFold", self.objTagBtnSwitchFold).transform
  self.objOganizationTag = self:FindGO("OganizationTag")
  self.sprOganizationIcon = self:FindComponent("sprOganizationIcon", UISprite, self.objOganizationTag)
  self.labOganizationName = self:FindComponent("labOganizationName", UILabel, self.objOganizationTag)
  self.labOganizationPrestigeLv = self:FindComponent("labPrestigeLv", UILabel, self.objOganizationTag)
  self.sliderOganizationPrestige = self:FindComponent("sliderPrestige", UISlider, self.objOganizationTag)
  self.objSelectOganization = self:FindGO("objSelect", self.objOganizationTag)
  self.objOganizationMember = self:FindGO("OganizationMember")
  self.headOganizationMember = HeadIconCell.new()
  local headParent = self:FindGO("HeadParent", self.objOganizationMember)
  self.headOganizationMember:CreateSelf(headParent)
  self.headOganizationMember:SetMinDepth(2)
  self.objMemberHeadLock = self:FindGO("Lock", headParent)
  self.labMemberName = self:FindComponent("labMemberName", UILabel, self.objOganizationMember)
  self.labMemberDetail = self:FindComponent("labDetail", UILabel, self.objOganizationMember)
  self.objMemberBtnGoTo = self:FindGO("BtnGoTo", self.objOganizationMember)
  self.objMemberSplitLine = self:FindGO("splitLine", self.objOganizationMember)
  self.objPersonalPrestige = self:FindGO("PersonalPrestige")
  self.headPersonal = HeadIconCell.new()
  headParent = self:FindGO("HeadParent", self.objPersonalPrestige)
  self.headPersonal:CreateSelf(headParent)
  self.headPersonal:SetMinDepth(2)
  self.objPersonalHeadLock = self:FindGO("Lock", headParent)
  self.labPersonalName = self:FindComponent("labName", UILabel, self.objPersonalPrestige)
  self.labPersonalDetail = self:FindComponent("labDetail", UILabel, self.objPersonalPrestige)
  self.labPersonalPrestigeLv = self:FindComponent("labPrestigeLv", UILabel, self.objPersonalPrestige)
  self.sliderPersonalPrestige = self:FindComponent("sliderPrestige", UISlider, self.objPersonalPrestige)
  self.objPersonalBtnGoTo = self:FindGO("BtnGoTo", self.objPersonalPrestige)
  self.objSelectPersonal = self:FindGO("objSelect", self.objPersonalPrestige)
end

function AdventurePrestigeCell:AddEvents()
  self:AddClickEvent(self.objTagBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
  self:AddClickEvent(self.objMemberBtnGoTo, function()
    self:OnClickBtnGoTo()
  end)
  self:AddClickEvent(self.objPersonalBtnGoTo, function()
    self:OnClickBtnGoTo()
  end)
  self:SetEvent(self.gameObject, function()
    if self.canClick then
      self:PassEvent(MouseEvent.MouseClick, self)
      self:OnClickBtnSwitchFold()
    end
  end)
  
  function self.labTagAchievedText.onChange()
    if self.labTagAchievedNum then
      self.labTagAchievedNum:ResetAndUpdateAnchors()
    end
  end
end

function AdventurePrestigeCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  self.canClick = false
  if not haveData then
    return
  end
  self:setIsSelected(data.isSelected)
  self.shortcutPowerID = nil
  self.isTag = data.isTag
  self.objTypeTag:SetActive(data.isMainTag == true)
  if data.isMainTag then
    self.id = data.id
    self.tsTagfBtnSwitchHoldArrow.localPosition = data.isOpen and tempZero or vecArrowFoldPos
    self.tsTagfBtnSwitchHoldArrow.localEulerAngles = data.isOpen and vecArrowOpenEuler or tempZero
    self.labTagName.text = data.text
    self.labTagAchievedText.text = data.achievedText
    self.labTagAchievedNum.text = string.format("%d/%d", data.graduateNum or 0, data.maxPrestigeNum or 0)
    self.labTagAchievedNum:ResetAndUpdateAnchors()
  end
  local isOganization = data.staticData and data.staticData.Type == PrestigeProxy.PrestigeType.Camp
  self.objOganizationTag:SetActive(isOganization == true)
  if isOganization then
    self.canClick = true
    self.labOganizationName.text = data.staticData.Name
    IconManager:SetUIIcon(data.staticData.Emblem, self.sprOganizationIcon)
    self:UpdatePrestigeData(self.sliderOganizationPrestige, self.labOganizationPrestigeLv)
  end
  local isPersonal = data.staticData and data.staticData.Type == PrestigeProxy.PrestigeType.Personal
  self.objPersonalPrestige:SetActive(isPersonal == true)
  if isPersonal then
    self.canClick = true
    self.labPersonalName.text = data.staticData.Name
    local prestigeNpcSData = Table_PrestigeNpc[data.staticData.Member[1]]
    local npcSData = Table_Npc[data.staticData.Member[1]]
    self:SetHeadIcon(npcSData, self.headPersonal)
    self.labPersonalDetail.text = npcSData and npcSData.Position
    self.shortcutPowerID = prestigeNpcSData and prestigeNpcSData.ShortcutPowerID
    self.objPersonalBtnGoTo:SetActive(self.shortcutPowerID ~= nil)
    self:UpdatePrestigeData(self.sliderPersonalPrestige, self.labPersonalPrestigeLv)
  end
  local isOganizationMember = not data.isMainTag and not data.staticData
  self.objOganizationMember:SetActive(isOganizationMember == true)
  if isOganizationMember then
    self.shortcutPowerID = data.ShortcutPowerID
    self.objMemberBtnGoTo:SetActive(self.shortcutPowerID ~= nil)
    self.objMemberSplitLine:SetActive(not data.hideLine)
    local npcSData = Table_Npc[data.id]
    self:SetHeadIcon(npcSData, self.headOganizationMember)
    local isUnlock = not data.MenuID or FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID)
    self.objMemberHeadLock:SetActive(not isUnlock)
    self.labMemberName.text = npcSData.NameZh
    if isUnlock then
      self.labMemberDetail.text = npcSData and npcSData.Position
    else
      self.labMemberDetail.text = data.UnlockCondition
    end
  end
end

function AdventurePrestigeCell:UpdatePrestigeData(slider, labelLevel)
  local prestigeData = PrestigeProxy.Instance:GetPrestigeDataByCampID(self.data.staticId)
  labelLevel.text = prestigeData and prestigeData.level or 1
  if not prestigeData then
    slider.value = 0
  elseif prestigeData:IsGraduate() then
    slider.value = 1
  else
    slider.value = prestigeData.exp / prestigeData:GetMaxExpToNextLevel()
  end
end

function AdventurePrestigeCell:SetHeadIcon(npcSData, targetCell)
  if not npcSData then
    return
  end
  local data = ReusableTable.CreateTable()
  if npcSData.Icon == "" then
    data.bodyID = npcSData.Body or 0
    data.hairID = npcSData.Hair or 0
    data.haircolor = npcSData.HeadDefaultColor or 0
    data.gender = npcSData.Gender or -1
    data.eyeID = npcSData.Eye or 0
    targetCell:SetData(data)
  else
    targetCell:SetSimpleIcon(npcSData.Icon)
  end
  ReusableTable.DestroyTable(data)
end

function AdventurePrestigeCell:OnClickBtnSwitchFold()
  if self.isTag then
    self:PassEvent(AdventureTagItemList.ClickFoldTag, self)
  end
end

function AdventurePrestigeCell:OnClickBtnGoTo()
  if self.shortcutPowerID then
    FuncShortCutFunc.Me():CallByID(self.shortcutPowerID)
  end
end

function AdventurePrestigeCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    self.objSelectOganization:SetActive(isSelected == true)
    self.objSelectPersonal:SetActive(isSelected == true)
  end
end
