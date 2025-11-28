PassItemData = class("PassItemData")
PassItemData.ItemType = {EQUIP = 1, CARD = 2}

function PassItemData:ctor(type, serverdata)
  self.type = type
  if serverdata then
    self:SetData(serverdata.itemid, serverdata.frequency)
  end
end

function PassItemData:SetData(itemid, frequency)
  self.itemId = itemid
  self.frequency = frequency
  self.itemData = ItemData.new("PassItemData", self.itemId)
  self.itemData:SetItemNum(1)
end
