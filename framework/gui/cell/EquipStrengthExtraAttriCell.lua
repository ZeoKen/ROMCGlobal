local BaseCell = autoImport("BaseCell")
EquipStrengthExtraAttriCell = class("EquipStrengthExtraAttriCell", BaseCell)

function EquipStrengthExtraAttriCell:Init()
  self.cellContent = self:FindGO("CellContent")
  self.cellContent_w = self.cellContent:GetComponent(UIWidget)
  self.progress1 = self:FindComponent("Progress1", UILabel, self.cellContent)
  self.progress2 = self:FindComponent("Progress2", UILabel, self.cellContent)
  self.attri = self:FindComponent("AttriText", UILabel, self.cellContent)
  self.active = self:FindGO("Active")
end

function EquipStrengthExtraAttriCell:SetData(data)
  self.data = data
  local maxLv = StrengthProxy.Instance:GetMaxLevel()
  self.progress1.text = maxLv
  self.progress2.text = data.level
  self.attri.text = data.buffsDesc
  self:Active(maxLv >= data.level)
end

function EquipStrengthExtraAttriCell:Active(b)
  self.active:SetActive(b)
  self.cellContent_w.alpha = b and 0.5 or 1
end
