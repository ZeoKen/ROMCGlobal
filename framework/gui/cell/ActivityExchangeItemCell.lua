autoImport("ItemCell")
ActivityExchangeItemCell = class("ActivityExchangeItemCell", ItemCell)

function ActivityExchangeItemCell:Init()
  ActivityExchangeItemCell.super.Init(self)
  self:FindObjs()
  self:SetSymbol()
end

function ActivityExchangeItemCell:FindObjs()
  self.numLabGO = self:FindGO("NumLabel", self.item)
  if self.numLabGO then
    self.numLabTrans = self.numLabGO.transform
    self.numLab = self.numLabGO:GetComponent(UILabel)
    self.numLabGO:SetActive(true)
  end
  self.symbol = self:FindComponent("Label", UILabel)
  self:AddCellClickEvent()
end

function ActivityExchangeItemCell:UpdateNumLabel(num)
  self.numLab.text = num
end

function ActivityExchangeItemCell:SetPic(itemType, staticData)
end

function ActivityExchangeItemCell:SetSymbol()
  self.symbol.text = "="
end
