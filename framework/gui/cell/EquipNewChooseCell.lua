autoImport("ItemNewCell")
autoImport("EquipChooseCell")
EquipNewChooseCell = class("EquipNewChooseCell", EquipChooseCell)
EquipNewChooseCell.CellControl = ItemNewCell

function EquipNewChooseCell:Init()
  EquipNewChooseCell.super.Init(self)
  self.typeLabel = self:FindComponent("ItemType", UILabel)
  self.itemChooseSymbol = self:FindGO("ItemChooseSymbol")
end

function EquipNewChooseCell:SetData(data)
  EquipNewChooseCell.super.SetData(self, data)
  self:UpdateTypeLabel()
end

function EquipNewChooseCell:UpdateTypeLabel()
  if not self.typeLabel then
    return
  end
  self.typeLabel.text = self:GetTypeLabelText()
end

local defaultTypeLabelTextGetter = function(data)
  return data and data.staticData and ItemUtil.GetItemTypeName(data.staticData) or ""
end

function EquipNewChooseCell:GetTypeLabelText()
  local getter = self.typeLabelTextGetter or defaultTypeLabelTextGetter
  return getter(self.data) or ""
end

function EquipNewChooseCell:SetTypeLabelTextGetter(getter)
  if type(getter) == "function" then
    self.typeLabelTextGetter = getter
  end
end

function EquipNewChooseCell:SetItemIconChooseId(id)
  self.itemChooseId = id
  self:UpdateItemIconChoose()
end

function EquipNewChooseCell:UpdateItemIconChoose()
  if not self.itemChooseSymbol then
    return
  end
  self.itemChooseSymbol:SetActive(self.itemChooseId ~= nil and self.data ~= nil and self.data.id == self.itemChooseId)
end

EquipNewMultiChooseCell = class("EquipNewMultiChooseCell", EquipNewChooseCell)

function EquipNewMultiChooseCell:Init()
  EquipNewMultiChooseCell.super.Init(self)
  self.cancelButton = self:FindGO("CancelButton")
  if self.cancelButton then
    self.cancelButtonLabel = self:FindComponent("Label", UILabel, self.cancelButton)
    self:AddClickEvent(self.cancelButton, function()
      self:PassEvent(EquipChooseCellEvent.ClickCancel, self)
    end)
  end
end

function EquipNewMultiChooseCell:SetChooseId(id)
end

function EquipNewMultiChooseCell:SetChoose(reference)
  self.chooseReference = reference
  self:UpdateChoose()
end

local choosePredicate = function(element, id)
  return element.id == id
end

function EquipNewMultiChooseCell:UpdateChoose()
  if not self.cancelButton then
    return
  end
  local isChoose = self.chooseReference ~= nil and self.data ~= nil and TableUtility.ArrayFindByPredicate(self.chooseReference, choosePredicate, self.data.id) ~= nil
  self.cancelButton:SetActive(isChoose)
end

function EquipNewMultiChooseCell:CheckValid()
  EquipNewMultiChooseCell.super.CheckValid(self)
  if not self.data then
    return
  end
  if self.cancelButton.activeSelf then
    if self.chooseButton.activeSelf then
      self.chooseButton:SetActive(false)
    else
      self.cancelButton:SetActive(false)
    end
  end
end

function EquipNewMultiChooseCell:SetCancelButtonText(text)
  if not self.cancelButtonLabel then
    return
  end
  self.cancelButtonLabel.text = tostring(text) or ""
end
