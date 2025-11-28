autoImport("AdventureItemData")
AdventureCollectionGroupData = class("AdventureCollectionGroupData", AdventureItemData)

function AdventureCollectionGroupData:ctor(staticId)
  self.staticId = staticId
  self:initData()
end

function AdventureCollectionGroupData:initData()
  self.collections = {}
  self.isUnlock = false
  self.rewardStatus = 0
  self:initStaticData()
end

function AdventureCollectionGroupData:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
  end
end

function AdventureCollectionGroupData:initStaticData()
  self.staticData = Table_Collection[self.staticId]
end

function AdventureCollectionGroupData:GetCollectionType()
  return self.staticData and self.staticData.Type
end

function AdventureCollectionGroupData:GetMapId()
  return self.staticData and self.staticData.mapID
end

function AdventureCollectionGroupData:addCollectionData(adventureData)
  if adventureData.IsValid and adventureData:IsValid() then
    self.collections[#self.collections + 1] = adventureData
  end
end

local temp = {}

function AdventureCollectionGroupData:getCollectionData()
  TableUtility.ArrayClear(temp)
  for i = 1, #self.collections do
    local single = self.collections[i]
    if single.IsValid and single:IsValid() then
      temp[#temp + 1] = single
    end
  end
  return temp
end

function AdventureCollectionGroupData:GetNextCollectionDataWithQuest()
  if self.collections then
    for _, collection in ipairs(self.collections) do
      local questData = collection:GetQuestData()
      if questData then
        return collection, questData
      end
    end
  end
end

function AdventureCollectionGroupData:hasToBeUnlockItem()
  if self:isRewardAvailable() then
    return true
  end
  if self.staticData.RedTip and not self:isTotalComplete() and not self:isTotalUnComplete() and self.collections and #self.collections > 0 then
    for j = 1, #self.collections do
      local singleColl = self.collections[j]
      if singleColl.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
        return true
      end
    end
  end
end

function AdventureCollectionGroupData:getCurrentUnlockNum()
  local count = 0
  for i = 1, #self.collections do
    local single = self.collections[i]
    if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK then
      count = count + 1
    end
  end
  return count
end

function AdventureCollectionGroupData:isTotalUnComplete()
  for i = 1, #self.collections do
    local single = self.collections[i]
    if single.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY then
      return false
    end
  end
  return true
end

function AdventureCollectionGroupData:IsUnlock()
  return self.isUnlock
end

function AdventureCollectionGroupData:setUnlock(unlock)
  self.isUnlock = unlock
end

function AdventureCollectionGroupData:isTotalComplete()
  for i = 1, #self.collections do
    local single = self.collections[i]
    if single.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK then
      return false
    end
  end
  return true
end

function AdventureCollectionGroupData:CheckReward(collectionManualList)
  local list = collectionManualList
  for i = 1, #list do
    local single = list[i]
    if single.id == self.staticId then
      self.rewardStatus = single.status
    end
  end
end

function AdventureCollectionGroupData:isRewardAvailable()
  local ManualData = AdventureDataProxy.Instance:GetCollectionRewardManualData(self.staticId)
  if ManualData then
    local status = ManualData.status
    if status and status == 1 then
      return true
    else
      return false
    end
  else
    return false
  end
end
