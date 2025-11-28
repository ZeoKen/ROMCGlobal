PersonalArtifactFormulaCell = class("PersonalArtifactFormulaCell", CoreView)
local maxMatCount = 5
local _FramentColor = {
  Active = LuaColor.New(0.5019607843137255, 0.8352941176470589, 0.3176470588235294, 1),
  DeActive = LuaColor.New(0.7803921568627451, 0.7803921568627451, 0.7803921568627451, 1)
}

function PersonalArtifactFormulaCell:ctor(obj)
  PersonalArtifactFormulaCell.super.ctor(self, obj)
  self:Init()
end

function PersonalArtifactFormulaCell:Init()
  self.equiped = self:FindGO("Equiped")
  self.bg = self:FindComponent("Background", UISprite)
  self.saveMissingObj = self:FindGO("SaveMissingObj")
  self.icon = self:FindComponent("IconSprite", UISprite)
  self.itemLabel = self:FindComponent("ItemName", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.drag = self.gameObject:GetComponent(UIDragScrollView)
  self.chooseBtn = self:FindGO("ChooseBtn")
  self.chooseBtnLab = self:FindComponent("Label", UILabel, self.chooseBtn)
  self.chooseBtnLab.text = ZhString.PersonalArtifact_FormulaChoose
  self.matContainerTrans = self:FindGO("MatContainer").transform
  self.attrStateGo = self:FindGO("AttrState")
  self.activeStateGo = self:FindGO("ActiveState")
  self.matBgs, self.matSps, self.matItemIds, self.fragmentLines = {}, {}, {}, {}
  local matBg
  for i = 1, maxMatCount do
    matBg = self:FindGO("Mat" .. i)
    self.matBgs[i] = matBg:GetComponent(UISprite)
    self.matSps[i] = self:FindComponent("MatSp", UISprite, matBg)
    self:AddClickEvent(matBg, function()
      self:OnClickMat(i)
    end)
    self.fragmentLines[i] = self:FindComponent("Line" .. tostring(i), UISprite, self.attrStateGo)
  end
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.icon.gameObject, function()
    self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self.data)
  end)
  self:AddClickEvent(self.chooseBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  UIUtil.HandleDragScrollForObj(self.icon.gameObject, self.drag)
end

function PersonalArtifactFormulaCell:UpdateFragmentLine(fragmentCount)
  for k, v in pairs(self.fragmentLines) do
    v.color = k <= fragmentCount and _FramentColor.Active or _FramentColor.DeActive
  end
end

function PersonalArtifactFormulaCell:IsEquipSavedFormularCell()
  if self.data and self.data.id == PersonalArtifactProxy.Instance:GetSaveArtifactId() then
    return true
  end
  if self.itemid == PersonalArtifactProxy.Instance:GetSaveMissingArtifactItemId() then
    return true
  end
  return false
end

function PersonalArtifactFormulaCell:IsEquipedFormularCell()
  if self.data and self.data.id == PersonalArtifactProxy.Instance:GetCurEquipedPersonalArtifactGuid() then
    return true
  end
  return false
end

function PersonalArtifactFormulaCell:UpdateSaveMissingObj()
  if not self.saveMissingObj then
    return
  end
  if not self.itemid then
    self:Hide(self.saveMissingObj)
    return
  end
  local active = self.itemid == PersonalArtifactProxy.Instance:GetSaveMissingArtifactItemId()
  if active then
    self:Show(self.saveMissingObj)
  else
    self:Hide(self.saveMissingObj)
  end
end

function PersonalArtifactFormulaCell:UpdateState()
  self.icon.alpha = self.data:CheckPersonalArtifactInActive() and 0.3 or 1
  local valid = self.data:CheckPersonalArtifactValid()
  if not valid then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
    return
  end
  local state, fragmentCount = self.data:GetPersonalArtifactState(), self.data:GetFragmentCount()
  local isInactive = state == PersonalArtifactProxy.EArtifactState.InActivated
  if isInactive then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
  elseif state == PersonalArtifactProxy.EArtifactState.Fragments then
    self:Hide(self.activeStateGo)
    self:Show(self.attrStateGo)
    self:UpdateFragmentLine(fragmentCount)
  elseif state == PersonalArtifactProxy.EArtifactState.Activation then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
  elseif state == PersonalArtifactProxy.EArtifactState.Entery then
    self:Show(self.activeStateGo)
    self:Hide(self.attrStateGo)
  end
end

function PersonalArtifactFormulaCell:SetData(data)
  self.data = data
  local staticID = data and data.staticData and data.staticData.id
  if not staticID then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
    self:UpdateSaveMissingObj()
    return
  end
  self.itemid = staticID
  self:UpdateSaveMissingObj()
  IconManager:SetItemIcon(self.data.staticData and self.data.staticData.Icon, self.icon)
  self.itemLabel.text = self.data.staticData and self.data.staticData.NameZh or ""
  ItemCell.SetItemQualityBG(self, self.data.staticData.Quality)
  self:UpdateChoose()
  local formulaData = Table_PersonalArtifactCompose[staticID]
  local costData, fragment, hasFragment, id = formulaData and formulaData.CostFlagments or _EmptyTable
  TableUtility.TableClear(self.matItemIds)
  for i = 1, maxMatCount do
    fragment = costData[i]
    hasFragment = fragment ~= nil
    self.matBgs[i].alpha = hasFragment and 1 or 0.3
    self.matSps[i].gameObject:SetActive(hasFragment)
    if hasFragment then
      id = fragment[1]
      self.matItemIds[i] = id
      IconManager:SetItemIcon(Table_Item[id].Icon, self.matSps[i])
      local active = data:CheckFragmentActive(id)
      self.matSps[i].color = active and ColorUtil.NGUIWhite or ColorUtil.NGUIShaderGray
    end
  end
  self:UpdateState()
  self:UpdateEquiped()
end

function PersonalArtifactFormulaCell:UpdateEquiped()
  local guid = self.data and self.data.id
  if not guid then
    self:Hide(self.equiped)
  else
    local item = BagProxy.Instance.roleEquip:GetItemByGuid(guid)
    if not item then
      self:Hide(self.equiped)
    else
      self:Show(self.equiped)
    end
  end
end

function PersonalArtifactFormulaCell:SetChoose(chooseid)
  self.chooseid = chooseid
  self:UpdateChoose()
end

function PersonalArtifactFormulaCell:UpdateChoose()
  self.chooseSymbol:SetActive(self.data and self.data.id == self.chooseid)
end

function PersonalArtifactFormulaCell:GetBgSprite()
end

local tipOffset = {720, 0}

function PersonalArtifactFormulaCell:OnClickMat(index)
  if not index or not self.matItemIds[index] then
    TipManager.CloseTip()
    return
  end
  if not self.tipData then
    self.tipData = {
      funcConfig = _EmptyTable,
      hideGetPath = true
    }
  end
  if not self.fakeItemData then
    self.fakeItemData = ItemData.new()
  end
  self.fakeItemData:ResetData("TipData", self.matItemIds[index])
  self.tipData.itemdata = self.fakeItemData
  local tip = TipManager.Instance:ShowItemFloatTip(self.tipData, self.matBgs[index], NGUIUtil.AnchorSide.Right, tipOffset)
  tip:AddIgnoreBounds(self.matContainerTrans)
end
