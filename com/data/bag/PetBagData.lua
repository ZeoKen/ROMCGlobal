autoImport("BagData")
PetBagData = class("PetBagData", BagData)

function PetBagData:AddItems(items, tabType)
  PetBagData.super.AddItems(self, items, tabType)
end

function PetBagData:AddItem(item)
  PetBagData.super.AddItem(self, item)
end

function PetBagData:RemoveItemByGuid(itemId)
  PetBagData.super.RemoveItemByGuid(self, itemId)
end

function PetBagData:UpdateItems(serverItems, recordMap)
  PetBagData.super.UpdateItems(self, serverItems, recordMap)
end

function PetBagData:Reset()
  PetBagData.super.Reset(self)
end

function PetBagData:RefreshPetEggQuickPackUsedCount()
  local items = self.wholeTab:GetItems()
  local n = 0
  if items then
    for i = 1, #items do
      local egg = items[i].petEggInfo
      if egg and egg.quick_pack_slot and 0 < egg.quick_pack_slot then
        n = n + 1
      end
    end
  end
  self.petEggQuickPackUsedCount = n
end

function PetBagData:GetItems(tabType)
  local items = PetBagData.super.GetItems(self, tabType)
  local packItems = {}
  for i = 1, #items do
    local egg = items[i].petEggInfo
    if not egg or egg.quick_pack_slot and egg.quick_pack_slot == 0 then
      table.insert(packItems, items[i])
    end
  end
  return packItems
end

function PetBagData:GetQuickItems()
  local items = self.wholeTab:GetItems()
  local quickItems = {}
  for i = 1, #items do
    local egg = items[i].petEggInfo
    local slot = egg and egg.quick_pack_slot
    if slot and 0 < slot then
      quickItems[slot] = items[i]
    end
  end
  for i = 1, 3 do
    if not quickItems[i] then
      quickItems[i] = BagItemEmptyType.Empty
    end
  end
  return quickItems
end

function PetBagData:GetPetEggQuickPackUsedCount()
  if self.petEggQuickPackUsedCount == nil then
    self:RefreshPetEggQuickPackUsedCount()
  end
  return self.petEggQuickPackUsedCount
end

function PetBagData:RefreshPetEggQuickPackUsedCount()
  if self.type ~= SceneItem_pb.EPACKTYPE_PET then
    return
  end
  local items = self.wholeTab:GetItems()
  local n = 0
  if items then
    for i = 1, #items do
      local egg = items[i].petEggInfo
      if egg and egg.quick_pack_slot and 0 < egg.quick_pack_slot then
        n = n + 1
      end
    end
  end
  self.petEggQuickPackUsedCount = n
end
