PreorderItemData = class("PreorderItemData")

function PreorderItemData:ctor(data)
  self.id = 0
  self.status = 0
end

function PreorderItemData:SetData(data)
  self.id = data.id
  self.itemid = data.itemid
  self.refinelvmin = data.refinelvmin
  self.refinelvmax = data.refinelvmax
  self.buffid = data.buffid
  self.damage = data.damage
  self.count = data.count
  self.buycount = data.buycount
  self.pubbuycount = data.pubbuycount
  self.price = data.price
  self.buyprice = data.buyprice
  self.status = data.status or 0
  self.expiretime = data.expiretime
  self.pricemin = data.pricemin or 0
  self.cardlvmin = data.cardlvmin or 0
  self.cardlvmax = data.cardlvmax or 0
end

function PreorderItemData:ResetData()
  self.id = 0
  self.status = 0
  self.itemid = nil
  self.refinelvmin = nil
  self.refinelvmax = nil
  self.buffid = nil
  self.damage = nil
  self.count = nil
  self.buycount = nil
  self.pubbuycount = nil
  self.price = nil
  self.buyprice = nil
  self.expiretime = nil
  self.pricemin = nil
  self.cardlvmin = nil
  self.cardlvmax = nil
end

function PreorderItemData:GetItemData()
  local itemData = ItemData.new("PreorderItem", self.itemid)
  itemData:SetItemNum(self.count)
  return itemData
end
