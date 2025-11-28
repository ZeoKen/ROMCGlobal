RecoveryPreviewCell = class("RecoveryPreviewCell", BaseCell)

function RecoveryPreviewCell:Init()
  RecoveryPreviewCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function RecoveryPreviewCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Label"):GetComponent(UILabel)
end

function RecoveryPreviewCell:SetData(data)
  self.costItem = data.costItem
  self.totalCost = data.totalCost
  local staticData = Table_Item[self.costItem]
  if staticData then
    IconManager:SetItemIcon(staticData.Icon, self.icon)
  end
  self.count.text = self.totalCost
end
