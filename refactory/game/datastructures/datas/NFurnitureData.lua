autoImport("HomeContentData")
autoImport("PetHouseData")
NFurnitureData = class("NFurnitureData")
NFurnitureData.PropsMap = {}
local SetFurnitureEnumProp = function(dataType, enum, handlerKey, clientKey, serverKey)
  if not enum then
    helplog("enum is nil! propName is", propName)
    return
  end
  local typeDatas = NFurnitureData.PropsMap[dataType]
  if not typeDatas then
    typeDatas = {}
    NFurnitureData.PropsMap[dataType] = typeDatas
  end
  typeDatas[enum] = {
    handlerKey = handlerKey,
    clientKey = clientKey,
    serverKey = serverKey
  }
end
NFurnitureData.EnumDataType = {
  Build = 1,
  Info = 2,
  State = 3,
  Pet = 4,
  Seats = 5,
  Photo = 6,
  Skada = 7
}
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Build, HomeCmd_pb.EFURNITUREDATA_ANGLE, "TryUpdateNormalData", "angle", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Build, HomeCmd_pb.EFURNITUREDATA_ROW, "TryUpdateNormalData", "row", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Build, HomeCmd_pb.EFURNITUREDATA_COL, "TryUpdateNormalData", "col", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Build, HomeCmd_pb.EFURNITUREDATA_FLOOR, "TryUpdateNormalData", "floor", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Build, HomeCmd_pb.EFURNITUREDATA_REWARDTIME, "TryUpdateNormalData", "rewardtime", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Info, HomeCmd_pb.EFURNITUREDATA_LV, "TryUpdateNormalData", "lv", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.State, HomeCmd_pb.EFURNITUREDATA_STATE, "TryUpdateNormalData", "state", "value")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_1, "TryUpdatePetData", 1)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_2, "TryUpdatePetData", 2)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_3, "TryUpdatePetData", 3)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_4, "TryUpdatePetData", 4)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_5, "TryUpdatePetData", 5)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_6, "TryUpdatePetData", 6)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_7, "TryUpdatePetData", 7)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_8, "TryUpdatePetData", 8)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_9, "TryUpdatePetData", 9)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Pet, HomeCmd_pb.EFURNITUREDATA_PET_INDEX_10, "TryUpdatePetData", 10)
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Seats, HomeCmd_pb.EFURNITUREDATA_SEATS, "TryUpdateSeats", "seats")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Photo, HomeCmd_pb.EFURNITUREDATA_PHOTO, "TryUpdatePhoto", "photos")
SetFurnitureEnumProp(NFurnitureData.EnumDataType.Skada, HomeCmd_pb.EFURNITUREDATA_NPC, "TryUpdateSkada")
local StateEnum = {
  On = SceneItem_pb.EFURNITURESTATE_ON,
  Off = SceneItem_pb.EFURNITURESTATE_OFF
}

function NFurnitureData:ctor(id, staticID)
  self.id = id
  self.staticID = staticID
  self.staticData = Table_HomeFurniture[staticID]
  if not self.staticData then
    LogUtility.Error(string.format("未在HomeFurniture表中找到家具id：%s", staticID))
  end
  self.itemStaticData = Table_Item[staticID]
  if not self.itemStaticData then
    LogUtility.Error(string.format("未在Item表中找到物品id：%s", staticID))
  end
  self.furnitureType = self.staticData and self.staticData.Type or HomeContentData.DefaultDataType
  self.accessRange = self.staticData and self.staticData.AccessRange or GameConfig.Home.DefaultAccessRange
  self.serverInited = false
  self.seats = {}
  self.photo = nil
end

function NFurnitureData:GetFurnitureType()
  return self.furnitureType
end

function NFurnitureData:GetItemType()
  return self.itemStaticData and self.itemStaticData.Type
end

function NFurnitureData:GetAccessRange()
  if not self.accessRange then
    redlog(string.format("家具：%s没有配置AccessRange，也没有找到GameConfig.Home.DefaultAccessRange，使用默认值：2", tostring(self.staticID)))
    return 2
  end
  return self.accessRange
end

function NFurnitureData:NoAccessable()
  return false
end

function NFurnitureData:IsServerInited()
  return self.serverInited == true
end

function NFurnitureData:ParseServerData(serverData)
  if self.staticID ~= serverData.id then
    self.staticID = serverData.id
    self.staticData = Table_HomeFurniture[self.staticID]
    self.furnitureType = self.staticData.Type or HomeContentData.DefaultDataType
    self.accessRange = self.staticData.AccessRange or GameConfig.Home.DefaultAccessRange
  end
  self.id = serverData.guid
  self.lv = serverData.lv
  self.angle = serverData.angle
  self.row = serverData.row
  self.col = serverData.col
  self.floor = serverData.floor
  self.rewardtime = serverData.rewardtime
  self.state = serverData.state
  self.oldID = serverData.old_guid or 0
  self:SetSeats(serverData.seats)
  self:TryUpdatePhoto(serverData)
  self:TryUpdateSkada(serverData)
  self.serverInited = true
end

function NFurnitureData:UpdateSingleData(serverData)
  local handlerData, handler
  for dataType, typeData in pairs(NFurnitureData.PropsMap) do
    handlerData = typeData[serverData.ftype]
    if handlerData then
      handler = self[handlerData.handlerKey]
      return dataType, handler and handler(self, serverData, handlerData.clientKey, handlerData.serverKey)
    end
  end
end

function NFurnitureData:TryUpdateNormalData(serverData, clientKey, serverKey)
  self[clientKey] = serverData[serverKey]
  return true
end

function NFurnitureData:TryUpdatePetData(serverData, clientKey, serverKey)
  if 0 < clientKey and self.furniturePets and self.furniturePets[clientKey] then
    self.furniturePets[clientKey]:Server_SetData(serverData.pet)
    return true
  end
  return false
end

function NFurnitureData:TryUpdateSeats(serverData, clientKey, serverKey)
  self:SetSeats(serverData.seats)
  return true
end

function NFurnitureData:TryUpdateSkada(serverData)
  local serverSkadaData = serverData.npc
  if not serverSkadaData then
    return false
  end
  self.woodRace = serverSkadaData.race
  self.woodNature = serverSkadaData.nature
  self.woodNatureLv = serverSkadaData.naturelv
  self.woodShape = serverSkadaData.shape
  self.woodDamageReduce = serverSkadaData.hpreduce
  self.woodBossType = serverSkadaData.bosstype
  self.woodType = serverSkadaData.wood_type
  self.woodMonsterId = serverSkadaData.monster_id or 0
  return serverSkadaData
end

function NFurnitureData:SetSeats(serverData)
  TableUtility.TableClear(self.seats)
  local seat
  for i = 1, #serverData do
    seat = serverData[i]
    self.seats[seat.point] = seat.charid
  end
end

function NFurnitureData:TryUpdatePhoto(serverData, clientKey, serverKey)
  if serverData.photos and #serverData.photos > 0 then
    local sourceid = serverData.photos[1].id
    local source = serverData.photos[1].source
    local time = serverData.photos[1].time
    local accid = source == ProtoCommon_pb.ESOURCE_PHOTO_SELF and 0 or serverData.photos[1].accid
    local charid = source == ProtoCommon_pb.ESOURCE_PHOTO_SELF and serverData.photos[1].charid or serverData.photos[1].accid
    self.photo = {
      sourceid = sourceid,
      source = source,
      charid = charid,
      time = time,
      accid = accid,
      loaded = false
    }
    return true
  end
  return false
end

function NFurnitureData:SetStateTimeStamp()
  if self:IsStateOn() then
    self.stateTimeStamp = ServerTime.CurServerTime() / 1000
  end
end

function NFurnitureData:IsStateOn()
  return self.state == StateEnum.On
end

function NFurnitureData:IsStateOff()
  return self.state == StateEnum.Off
end

function NFurnitureData:SetCanReward()
  if self.rewardtime then
    if GameConfig.Home.FireFurniture then
      self.haveReward = ServerTime.CurServerTime() / 1000 - self.rewardtime >= GameConfig.Home.FireFurniture.Time
    else
      self.haveReward = false
    end
  end
end
