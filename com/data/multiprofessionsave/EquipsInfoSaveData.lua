EquipsInfoSaveData = class("EquipsInfoSaveData")

function EquipsInfoSaveData:ctor(serverequipinfo)
  if serverequipinfo then
    self.pos = serverequipinfo.pos
    self.type_id = serverequipinfo.type_id
    self.guid = serverequipinfo.guid
    self:ParseItemData(serverequipinfo)
  end
end

function EquipsInfoSaveData:IsPersonalArtifactPos()
  return self.pos == SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1
end

function EquipsInfoSaveData:ParseItemData(serverData)
  local itemData = ItemData.new("EquipTempData", self.type_id)
  if itemData.equipInfo and serverData.equip then
    itemData.equipInfo:Set(serverData.equip)
    itemData.cardSlotNum = itemData.equipInfo:GetCardSlot()
  end
  if serverData.card then
    itemData:SetEquipCards(serverData.card)
  end
  if serverData.enchant then
    itemData:SetEnchantInfo(serverData.enchant)
  end
  self.itemData = itemData
end
