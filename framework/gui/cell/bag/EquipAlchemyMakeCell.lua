autoImport("BaseItemCell")
EquipAlchemyMakeCell = class("EquipAlchemyMakeCell", BaseItemCell)

function EquipAlchemyMakeCell:Init()
  self.itemCell = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject)
  EquipAlchemyMakeCell.super.Init(self)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddCellClickEvent()
end

function EquipAlchemyMakeCell:SetMinDepth(minDepth)
  local widgets = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIWidget, true)
  for i = 1, #widgets do
    widgets[i].depth = minDepth + widgets[i].depth
  end
end

function EquipAlchemyMakeCell:SetData(data)
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.itemData = self.itemData or ItemData.new()
    self.itemData:ResetData("AlchemyMake", data.ProductId)
    EquipAlchemyMakeCell.super.SetData(self, self.itemData)
    self.data = data
    self:UpdateChoose()
  end
end

function EquipAlchemyMakeCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function EquipAlchemyMakeCell:UpdateChoose()
  local dataid = self.data and self.data.id
  self.chooseSymbol:SetActive(dataid ~= nil and dataid == self.chooseId)
end
