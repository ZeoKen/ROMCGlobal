local BaseCell = autoImport("BaseCell")
RechargeRewardCell = class("RechargeRewardCell", BaseCell)

function RechargeRewardCell:Init()
  self:FindObjs()
end

function RechargeRewardCell:FindObjs()
  self.item = self:FindGO("Item")
  self.itemCell = ItemNewCell.new(self.item)
  self.icon = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self:AddCellClickEvent()
  self.finishSymbol = self:FindGO("FinishSymbol")
end

function RechargeRewardCell:SetData(data)
  self.data = data
  if data.staticData then
    self.itemCell:SetData(data)
  end
end

function RechargeRewardCell:SetFinishStatus(bool)
  if self.finishSymbol then
    self.finishSymbol:SetActive(bool)
  end
  self.icon.alpha = bool and 0.5 or 1
end
