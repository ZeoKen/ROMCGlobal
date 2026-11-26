autoImport("PetDropItemData")
PetAdventureItemData = class("PetAdventureItemData")

function PetAdventureItemData:SetData(serviceItemData)
  self.id = serviceItemData.id
  self.specid = serviceItemData.specid
  self.staticData = Table_Pet_Adventure[self.id]
  self.startTime = serviceItemData.starttime
  self.status = serviceItemData.status
  self.activityStartTime = serviceItemData.limitstart or 0
  self.activityEndTime = serviceItemData.limitend or 0
  local isActivity = self.activityStartTime > 0 and 0 < self.activityEndTime
  if not isActivity and self.staticData then
    isActivity = self.staticData.DailyAdventureCount and 0 < self.staticData.DailyAdventureCount
  end
  if isActivity then
    self.statusSortID = PetAdventureProxy.QuestPhase.Activity
  else
    self.statusSortID = serviceItemData.status
  end
  self.rareReward = {}
  local raresreward = serviceItemData.raresreward
  if raresreward then
    for i = 1, #raresreward do
      local rareItem = raresreward[i]
      local rareBase = rareItem and rareItem.base
      if rareBase then
        local dropItemData = PetDropItemData.new(rareBase.guid, rareBase.id)
        dropItemData:SetCount(rareBase.count)
        self.rareReward[#self.rareReward + 1] = dropItemData
      end
    end
  end
  local rewardinfo = serviceItemData.rewardinfo
  local isSpecial = self.staticData and self.staticData.QuestType == 1
  self.rewardMap = {}
  self.multiMonsterReward = self.status == PetAdventureProxy.QuestPhase.MATCH and not isSpecial
  if rewardinfo and 0 < #rewardinfo then
    if self.multiMonsterReward then
      for i = 1, #rewardinfo do
        local reward = rewardinfo[i]
        local items = reward and reward.items
        if items then
          local monsID = reward.monsterid
          local petDropItem = {}
          for j = 1, #items do
            local itemBase = items[j] and items[j].base
            if itemBase then
              local dropItemData = PetDropItemData.new(itemBase.guid, itemBase.id)
              dropItemData:SetCount(itemBase.count)
              dropItemData.DynamicReward = true
              petDropItem[#petDropItem + 1] = dropItemData
            end
          end
          self.rewardMap[monsID] = petDropItem
        end
      end
    else
      local servItem = rewardinfo[1] and rewardinfo[1].items
      if servItem then
        local petDropItem = {}
        for i = 1, #servItem do
          local itemBase = servItem[i] and servItem[i].base
          if itemBase then
            local dropItemData = PetDropItemData.new(itemBase.guid, itemBase.id)
            dropItemData:SetCount(itemBase.count)
            dropItemData.DynamicReward = true
            petDropItem[#petDropItem + 1] = dropItemData
          end
        end
        self.rewardMap = petDropItem
      end
    end
  end
  self.petEggs = {}
  local serviceEggs = serviceItemData.eggs
  if serviceEggs then
    for i = 1, #serviceEggs do
      local itemInfo = serviceEggs[i].base
      if itemInfo and itemInfo.guid and "" ~= itemInfo.guid then
        local item = ItemData.new(itemInfo.guid, itemInfo.id)
        local PetInfo = PetEggInfo.new(item.staticData)
        PetInfo:Server_SetData(serviceEggs[i].egg)
        PetInfo.guid = itemInfo.guid
        table.insert(self.petEggs, PetInfo)
      else
        table.insert(self.petEggs, 0)
      end
    end
  end
end

function PetAdventureItemData:GetServerPet()
  local data = {}
  for k, v in pairs(self.petEggs) do
    if v ~= 0 then
      data[#data + 1] = v
    end
  end
  return data
end
