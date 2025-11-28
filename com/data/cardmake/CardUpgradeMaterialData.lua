CardUpgradeMaterialData = class("CardUpgradeMaterialData")

function CardUpgradeMaterialData:ctor(data, num)
  self:SetData(data, num)
end

function CardUpgradeMaterialData:SetData(data, num)
  self.id = data[1]
  self.oriNum = data[2]
  num = num or self.oriNum
  self.itemData = ItemData.new("CardUpgrade", self.id)
  if num then
    self.itemData.num = num
  end
end
