PassEquipAndCardData = class("PassEquipAndCardData")

function PassEquipAndCardData:ctor(pos)
  self.pos = pos
  self.equips = {}
  self.cards = {}
end

function PassEquipAndCardData:AddItemData(type, passItemData)
  if type == PassItemData.ItemType.EQUIP then
    self.equips[#self.equips + 1] = passItemData
  elseif type == PassItemData.ItemType.CARD then
    self.cards[#self.cards + 1] = passItemData
  end
end

function PassEquipAndCardData:ClearItemData(type)
  if type == PassItemData.ItemType.EQUIP then
    TableUtility.ArrayClear(self.equips)
  elseif type == PassItemData.ItemType.CARD then
    TableUtility.ArrayClear(self.cards)
  end
end

function PassEquipAndCardData:GetEquips()
  return self.equips
end

function PassEquipAndCardData:GetCards()
  return self.cards
end
