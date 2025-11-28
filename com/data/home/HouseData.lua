autoImport("BaseHouseData")
HouseData = class("HouseData", BaseHouseData)
local PropsMap = {}
local SetEnumProp = function(dataType, enum, handlerKey, clientKey, serverKey)
  if not enum then
    Debug.LogError("enum is nil! propName is " .. tostring(clientKey))
    return
  end
  local typeDatas = PropsMap[dataType]
  if not typeDatas then
    typeDatas = {}
    PropsMap[dataType] = typeDatas
  end
  typeDatas[enum] = {
    handlerKey = handlerKey,
    clientKey = clientKey,
    serverKey = serverKey
  }
end
SetEnumProp(BaseHouseData.EnumDataType.PetHouse, HomeCmd_pb.EHOUSEDATA_PET, "TryUpdatePetHouseData")
SetEnumProp(BaseHouseData.EnumDataType.SoundList, HomeCmd_pb.EHOUSEDATA_RADIO, "TryUpdateSoundList")
SetEnumProp(BaseHouseData.EnumDataType.FireReward, HomeCmd_pb.EHOUSEDATA_FIREREWARDTIME, "TryUpdateFirereward", "firerewardtime", "value")
SetEnumProp(BaseHouseData.EnumDataType.DiningTable_Food, HomeCmd_pb.EHOUSEDATA_DININGTABLE_FOOD, "TryUpdateDiningTableFood", "value")
local OptsMap = {}
local SetOptEnumProp = function(enum, handlerKey, clientKey, serverKey)
  if not enum then
    Debug.LogError("enum is nil! optName is " .. tostring(clientKey))
    return
  end
  OptsMap[enum] = {
    handlerKey = handlerKey,
    clientKey = clientKey,
    serverKey = serverKey
  }
end
SetOptEnumProp(BaseHouseData.HouseOptType.OwnerMsg, "TryUpdateNormalData", "ownerMsg", "str")

function HouseData:Init(serverData)
  HouseData.super.Init(self, serverData)
end

function HouseData:OnParseServerData(serverData)
  if not serverData then
    LogUtility.Error("HouseData: Server Data Is Nil")
    return
  end
  self.firerewardtime = serverData.firerewardtime
  self:SetCanReward()
  local serverpets = serverData.pets
  self.furniturePets = {}
  if serverpets then
    for i = 1, #serverpets do
      local data = PetHouseData.new(serverpets[i])
      self.furniturePets[data.index] = data
    end
  end
  local serverSoundList = serverData.radios
  if serverSoundList then
    self:_UpdateSoundList(serverSoundList)
  end
  HouseData.super.OnParseServerData(self, serverData)
end

function HouseData:OnUpdateSingleData(serverData)
  local handlerData, handler
  for dataType, typeData in pairs(PropsMap) do
    handlerData = typeData[serverData.eData]
    if handlerData then
      handler = self[handlerData.handlerKey]
      return dataType, handler and handler(self, serverData, handlerData.clientKey, handlerData.serverKey)
    end
  end
end

function HouseData:OnUpdateHomeOptData(serverData)
  local handlerData = OptsMap[serverData.data]
  if handlerData then
    local handler = self[handlerData.handlerKey]
    return serverData.data, handler and handler(self, serverData, handlerData.clientKey, handlerData.serverKey)
  end
end

function HouseData:GetFeedingPetRole()
  local data = {}
  if self.furniturePets then
    for _, v in pairs(self.furniturePets) do
      if v.petCreature then
        data[#data + 1] = v.petCreature
      end
    end
  end
  return data
end

function HouseData:FindPriorityPetPos()
  if self.furniturePets then
    local finded = false
    for index, data in pairs(self.furniturePets) do
      if not data.petEgg and data.unlock then
        finded = true
        return index
      end
    end
    if not finded then
      for _, data in pairs(self.furniturePets) do
        if data.unlock == false then
          return 0
        end
      end
    end
  end
end

function HouseData:GetPetHouse()
  local pets = {}
  if self.furniturePets then
    for k, v in pairs(self.furniturePets) do
      local index = #pets + 1
      pets[index] = v
    end
  end
  return pets
end

function HouseData:GetFeedingPets()
  local data = {}
  local pets = self:GetPetHouse()
  for i = 1, #pets do
    if pets[i].petEgg then
      pets[i].petEgg.isEat = 1
      data[#data + 1] = pets[i].petEgg
    end
  end
  return data
end

function HouseData:GetAllPetEggs()
  local eggs = self:GetFeedingPets()
  local bagEggs = BagProxy.Instance:GetMyPetEggs()
  for i = 1, #bagEggs do
    bagEggs[i].petEggInfo.isEat = 0
    eggs[#eggs + 1] = bagEggs[i].petEggInfo
  end
  return eggs
end

function HouseData:TryUpdatePetHouseData(serverData)
  if self.furniturePets and serverData and serverData.pet and self.furniturePets[serverData.pet.index + 1] then
    self.furniturePets[serverData.pet.index + 1]:Server_SetData(serverData.pet)
    return true
  end
  return false
end

function HouseData:TryUpdateSoundList(serverData)
  if serverData and serverData.radios then
    self:_UpdateSoundList(serverData.radios)
    return true
  end
  return false
end

function HouseData:TryUpdateFirereward(serverData)
  if serverData then
    local firerewardtime = serverData.firerewardtime or serverData.value
    if firerewardtime ~= nil then
      self.firerewardtime = firerewardtime
      self:SetCanReward()
      if not self:GetCanReward() then
        HomeManager.Me():ClearFurnitureRewards()
      end
    else
      HomeManager.Me():ClearFurnitureRewards()
    end
  else
    HomeManager.Me():ClearFurnitureRewards()
  end
end

function HouseData:TryUpdateDiningTableFood(value)
  self.m_isHasDiningTableFood = value.value > 0
end

function HouseData:isHasDiningTableFood()
  return self.m_isHasDiningTableFood and self.m_isHasDiningTableFood == true
end

local _soundListSortFunc = function(l, r)
  return l.starttime < r.starttime
end

function HouseData:_UpdateSoundList(serverSoundList)
  self.furnitureSoundList = self.furnitureSoundList or {}
  local data
  for i = 1, #serverSoundList do
    data = self.furnitureSoundList[i] or {}
    data.name = serverSoundList[i].name
    data.starttime = serverSoundList[i].starttime
    data.musicid = serverSoundList[i].musicid
    self.furnitureSoundList[i] = data
  end
  local len = #self.furnitureSoundList
  for i = #serverSoundList + 1, len do
    self.furnitureSoundList[i] = nil
  end
  table.sort(self.furnitureSoundList, _soundListSortFunc)
end

function HouseData:ClearFeedingPet()
  if self.furniturePets then
    for _, v in pairs(self.furniturePets) do
      v:ClearPetRole()
    end
  end
end

function HouseData:SetCanReward()
  self.haveReward = false
  if self.firerewardtime and GameConfig.Home.FireFurniture then
    local deltaTime = ServerTime.CurServerTime() / 1000 - self.firerewardtime
    local staticTime = GameConfig.Home.FireFurniture.Time
    if self.firerewardtime > 0 then
      self.haveReward = deltaTime >= staticTime
    end
  end
  if not self.haveReward then
    HomeManager.Me():ClearFurnitureRewards()
  end
end

function HouseData:GetCanReward()
  return self.haveReward
end

function HouseData:GetFurnitureSoundList()
  return self.furnitureSoundList
end

function HouseData:IsMarriageHouse()
  return false
end
