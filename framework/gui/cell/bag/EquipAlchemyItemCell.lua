autoImport("BaseItemCell")
EquipAlchemyItemCell = class("EquipAlchemyItemCell", BaseItemCell)

function EquipAlchemyItemCell:Init()
  EquipAlchemyItemCell.super.Init(self)
  self.countRange = self:FindComponent("CountRange", UILabel)
end

function EquipAlchemyItemCell:SetMinDepth(minDepth)
  local widgets = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIWidget, true)
  for i = 1, #widgets do
    widgets[i].depth = minDepth + widgets[i].depth
  end
end

function EquipAlchemyItemCell:SetData(data)
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.itemData = self.itemData or ItemData.new()
    self.itemData:ResetData("Alchemy", data.ProductId)
    EquipAlchemyItemCell.super.SetData(self, self.itemData)
    self.data = data
    self.countRange.text = data.Count[1] .. "~" .. data.Count[2]
  end
end
