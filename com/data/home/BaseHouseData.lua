BaseHouseData = class("BaseHouseData")
BaseHouseData.HouseType = {
  Small = 1,
  Middle = 2,
  Large = 3,
  Marrage = 4
}
BaseHouseData.HouseOpenType = {
  All = HomeCmd_pb.EHOUSEOPEN_ALL or 1,
  Friend = HomeCmd_pb.EHOUSEOPEN_FRIEND or 2
}
BaseHouseData.MessageBoardOpenType = {
  Min = HomeCmd_pb.EBOARDOPEN_MIN or 0,
  All = HomeCmd_pb.EBOARDOPEN_ALL or 1,
  Friend = HomeCmd_pb.EBOARDOPEN_FRIEND or 2,
  Close = HomeCmd_pb.EBOARDOPEN_CLOSE or 3
}
BaseHouseData.EnumDataType = {
  Info = 1,
  Renovation = 2,
  PetHouse = 3,
  SoundList = 4,
  FireReward = 5,
  DiningTable_Food = 7
}
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
SetEnumProp(BaseHouseData.EnumDataType.Info, HomeCmd_pb.EHOUSEDATA_STATE, "TryUpdateNormalData", "houseState", "value")
SetEnumProp(BaseHouseData.EnumDataType.Renovation, HomeCmd_pb.EHOUSEDATA_DECORATE, "TryUpdateFloorRenovationData")
BaseHouseData.HouseOptType = {
  OpenType = HomeCmd_pb.EOPTDATA_OPEN or 1,
  ShowFurnitureName = HomeCmd_pb.EOPTDATA_FURNITURE_SHOW or 2,
  MasterShieldType = HomeCmd_pb.EOPTDATA_FORBID_SELF or 3,
  VisitorForbidType = HomeCmd_pb.EOPTDATA_FORBID_OTHER or 4,
  Name = HomeCmd_pb.EOPTDATA_NAME or 5,
  Sign = HomeCmd_pb.EOPTDATA_SIGN or 6,
  Lv = HomeCmd_pb.EOPTDATA_FURNITURE_LV or 7,
  Score = HomeCmd_pb.EOPTDATA_FURNITURE_SCORE or 8,
  GardenHouse = HomeCmd_pb.EOPTDATA_GARDENHOUSE or 10,
  BoardOpen = HomeCmd_pb.EOPTDATA_BOARDOPEN or 11,
  OwnerMsg = HomeCmd_pb.EOPTDATA_BOARDMSG or 13
}
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
SetOptEnumProp(BaseHouseData.HouseOptType.OpenType, "TryUpdateNormalData", "openType", "value")
SetOptEnumProp(BaseHouseData.HouseOptType.ShowFurnitureName, "TryUpdateNormalData", "showFurnitureNameStatus", "value")
SetOptEnumProp(BaseHouseData.HouseOptType.MasterShieldType, "TryUpdateArrayData", "masterShieldTypes", "ids")
SetOptEnumProp(BaseHouseData.HouseOptType.VisitorForbidType, "TryUpdateArrayData", "visitorForbidTypes", "ids")
SetOptEnumProp(BaseHouseData.HouseOptType.Name, "TryUpdateNormalData", "name", "str")
SetOptEnumProp(BaseHouseData.HouseOptType.Sign, "TryUpdateNormalData", "sign", "str")
SetOptEnumProp(BaseHouseData.HouseOptType.Lv, "TryUpdateScore", "lv", "value")
SetOptEnumProp(BaseHouseData.HouseOptType.Score, "TryUpdateScore", "score", "value")
SetOptEnumProp(BaseHouseData.HouseOptType.GardenHouse, "TryUpdateNormalData", "gardenHouseID", "value")
SetOptEnumProp(BaseHouseData.HouseOptType.BoardOpen, "TryUpdateNormalData", "messageBoardOpen", "value")

function BaseHouseData:ctor(serverData)
  self.renovationMap = {}
  self.masterShieldTypes = {}
  self.visitorForbidTypes = {}
  self:Init(serverData)
  self:ParseServerData(serverData)
end

function BaseHouseData:Init(serverData)
  self.serverInited = false
end

function BaseHouseData:ParseServerData(serverData)
  if not serverData then
    LogUtility.Error("BaseHouseData: Server Data Is Nil")
    return
  end
  TableUtility.TableClear(self.renovationMap)
  self.mapID = serverData.id
  self.houseConfig = GameConfig.Home.MapDatas[self.mapID]
  self.accid = serverData.accid
  self.houseType = serverData.ftype
  self.houseState = serverData.state
  self.name = serverData.name
  self.sign = serverData.sign
  self.lv = serverData.furniturelv or 0
  self.score = serverData.furniturescore or 0
  self.visitcount = serverData.visitcount or 0
  self.finishedGuide = serverData.guide
  self.ownerMsg = serverData.board
  helplog("serverData.board", serverData.board)
  self:RefreshScoreLvInfo()
  local serverDecorates = serverData.decorates
  if serverDecorates then
    local floorIDs, floorMap, matData
    for i = 1, #serverDecorates do
      floorIDs = serverDecorates[i].ids
      floorMap = {}
      self.renovationMap[serverDecorates[i].floor] = floorMap
      for j = 1, #floorIDs do
        matData = Table_HomeFurnitureMaterial[floorIDs[j]]
        if matData then
          floorMap[matData.Type] = matData
        else
          LogUtility.Error(string.format("未在表中找到装潢id：%s！", tostring(floorIDs[j])))
        end
      end
    end
  end
  local serveropts = serverData.opt
  if serveropts then
    if serveropts.open ~= nil then
      self.openType = serveropts.open
    end
    if serveropts.furniture_show ~= nil then
      self.showFurnitureNameStatus = serveropts.furniture_show
    end
    if serveropts.board_open ~= nil then
      self.messageBoardOpen = serveropts.board_open
    end
    TableUtility.TableClear(self.masterShieldTypes)
    local forbidList = serveropts.forbid_self
    if forbidList then
      for i = 1, #forbidList do
        self.masterShieldTypes[i] = forbidList[i]
      end
    end
    TableUtility.TableClear(self.visitorForbidTypes)
    forbidList = serveropts.forbid_other
    if forbidList then
      for i = 1, #forbidList do
        self.visitorForbidTypes[i] = forbidList[i]
      end
    end
    if serveropts.garden_house and 0 < serveropts.garden_house then
      self.gardenHouseID = serveropts.garden_house
    end
  end
  self:OnParseServerData(serverData)
end

function BaseHouseData:OnParseServerData(serverData)
  self.serverInited = true
end

function BaseHouseData:UpdateSingleData(serverData)
  local handlerData, handler
  for dataType, typeData in pairs(PropsMap) do
    handlerData = typeData[serverData.eData]
    if handlerData then
      handler = self[handlerData.handlerKey]
      return dataType, handler and handler(self, serverData, handlerData.clientKey, handlerData.serverKey)
    end
  end
  return self:OnUpdateSingleData(serverData)
end

function BaseHouseData:OnUpdateSingleData(serverData)
end

function BaseHouseData:UpdateHomeOptData(serverData)
  local handlerData = OptsMap[serverData.data]
  if handlerData then
    local handler = self[handlerData.handlerKey]
    return serverData.data, handler and handler(self, serverData, handlerData.clientKey, handlerData.serverKey)
  end
  return self:OnUpdateHomeOptData(serverData)
end

function BaseHouseData:OnUpdateHomeOptData(serverData)
end

function BaseHouseData:TryUpdateNormalData(serverData, clientKey, serverKey)
  helplog("BaseHouseData:TryUpdateScore", clientKey, serverKey)
  self[clientKey] = serverData[serverKey]
  return true
end

function BaseHouseData:TryUpdateArrayData(serverData, clientKey, serverKey)
  local clientList = self[clientKey]
  local serverList = serverData[serverKey]
  if not clientList or not serverKey then
    LogUtility.Error("Update Array Failed!")
    return false
  end
  TableUtility.TableClear(clientList)
  for i = 1, #serverList do
    clientList[i] = serverList[i]
  end
  return true
end

function BaseHouseData:TryUpdateFloorRenovationData(serverData, clientKey, serverKey)
  local floor = serverData.decorate.floor
  local floorIDs = serverData.decorate.ids
  local floorMap = self.renovationMap[floor]
  if not floorMap then
    floorMap = {}
    self.renovationMap[floor] = floorMap
  else
    TableUtility.TableClear(floorMap)
  end
  local matData
  for i = 1, #floorIDs do
    matData = Table_HomeFurnitureMaterial[floorIDs[i]]
    if matData then
      floorMap[matData.Type] = matData
    else
      LogUtility.Error(string.format("未在表中找到装潢id：%s！", tostring(floorIDs[i])))
    end
  end
  return floor
end

function BaseHouseData:TryUpdateScore(serverData, clientKey, serverKey)
  self:TryUpdateNormalData(serverData, clientKey, serverKey)
  self:RefreshScoreLvInfo()
end

function BaseHouseData:GetRenovationDataMap()
  return self.renovationMap
end

function BaseHouseData:GetRenovationDataMapByFloor(floor)
  return self.renovationMap[floor]
end

function BaseHouseData:GetRenovationMaterialID(floor, typeID)
  local floorMap = self.renovationMap[floor]
  local matStaticData = floorMap and floorMap[typeID]
  return matStaticData and matStaticData.id
end

function BaseHouseData:RefreshScoreLvInfo()
  self.lv = self.lv or 0
  local curLvData = Table_HomeBuff[math.clamp(self.lv, 0, #Table_HomeBuff)]
  if curLvData and self.score < curLvData.Score then
    self.curLvScore = 0
    return
  end
  local nextLvData = Table_HomeBuff[self.lv + 1]
  local curLvMinScore = curLvData and curLvData.Score or 0
  self.curLvScore = self.score - curLvMinScore
  if 0 > self.curLvScore then
    self.curLvScore = 0
  end
  self.curLvNeedTotalScore = nextLvData and nextLvData.Score or 0
  self.curLvNeedScore = self.curLvNeedTotalScore - curLvMinScore
  if 1 > self.curLvNeedScore then
    self.curLvNeedScore = 1
  end
end

function BaseHouseData:GetCurLvScore()
  return self.curLvScore or 0
end

function BaseHouseData:GetCurLvNeedScore()
  return self.curLvNeedScore or 1
end

function BaseHouseData:GetCurLvNeedTotalScore()
  return self.curLvNeedTotalScore or 1
end

function BaseHouseData:IsMaxLv()
  return self.lv >= #Table_HomeBuff
end

function BaseHouseData:GetOpenType()
  return self.openType
end

function BaseHouseData:IsShowFurnitureName()
  return self.showFurnitureNameStatus == 1
end

function BaseHouseData:GetMasterShieldTypes()
  return self.masterShieldTypes
end

function BaseHouseData:GetVisitorForbidTypes()
  return self.visitorForbidTypes
end

function BaseHouseData:GetVisitCount()
  return self.visitcount or 0
end

function BaseHouseData:IsFinishedGuide()
  return self.finishedGuide == true
end

function BaseHouseData:GuideFinished()
  self.finishedGuide = true
end

function BaseHouseData:GetOwnerMsg()
  return self.ownerMsg
end

function BaseHouseData:GetMessageBoardStatue()
  return self.messageBoardOpen
end

function BaseHouseData:GetGardenHouseID()
  if self.gardenHouseID then
    return self.gardenHouseID
  end
  local houseData = HomeProxy.Instance:GetMyHouseData()
  local houseConfig = houseData and houseData.houseConfig
  return houseConfig and houseConfig.DefaultGardenHouseID or 1
end
