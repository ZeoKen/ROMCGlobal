CardMakeMaterialData = class("CardMakeMaterialData")

function CardMakeMaterialData:ctor(data, slotId)
  self:SetData(data)
  self.slotId = slotId
end

function CardMakeMaterialData:SetData(data)
  self.data = data
  if data then
    self.id = data.id
    self.itemData = ItemData.new("CardMake", self.id)
    if data.num then
      self.itemData.num = data.num
      self.costNum = data.num
    end
    self:UpdateOwnNum()
    self.isExtra = data.isExtra
  end
end

function CardMakeMaterialData:UpdateOwnNum()
  if self.data and self.data.extraItems then
    local ownNum = 0
    for i = 1, #self.data.extraItems do
      local id = self.data.extraItems[i]
      local bagNum
      if id == GameConfig.MoneyId.Zeny then
        bagNum = MyselfProxy.Instance:GetROB()
      else
        bagNum = CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(id)
      end
      ownNum = ownNum + bagNum
    end
    self.ownNum = ownNum
  end
end
