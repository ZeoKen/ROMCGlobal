autoImport("HomeContentData")
autoImport("NFurnitureData")
autoImport("HouseData")
SnowRealmProxy = class("SnowRealmProxy", pm.Proxy)
SnowRealmProxy.Instance = nil
SnowRealmProxy.NAME = "SnowRealmProxy"
SnowRealmProxy.BuildType = {
  Furniture = HomeContentData.Type.Furniture,
  Renovation = HomeContentData.Type.Renovation
}
SnowRealmProxy.FurnitureSpecialCatagory = {All = 0, Theme = -1}
SnowRealmProxy.HouseType = {Home = 1}

function SnowRealmProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SnowRealmProxy.NAME
  if SnowRealmProxy.Instance == nil then
    SnowRealmProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:InitDataUpdateHandler()
  self:InitRenovationDataUpdateHandler()
end

function SnowRealmProxy:Init()
  self.mySelfHomeIndex = 0
  self.buildingDatas = {}
  self.furnitureDatas = {}
  self.myHouseFurnitureSimpleDatas = {}
  for i = 1, 6 do
    self.furnitureDatas[i] = {
      houseIndex = i,
      nFurnitureMap = {}
    }
  end
  self.bpDataCache = {}
  local datas = {}
  local l_furnitureSeriesConfig = GameConfig.Home.FurnitureSeries
  local singleSeriesConfig
  for i = 1, #l_furnitureSeriesConfig do
    singleSeriesConfig = l_furnitureSeriesConfig[i]
    datas[singleSeriesConfig.seriesType] = {}
    if singleSeriesConfig.extraSubTypes then
      for j = 1, #singleSeriesConfig.extraSubTypes do
        datas[singleSeriesConfig.seriesType][singleSeriesConfig.extraSubTypes[j]] = {}
      end
    end
  end
  local seriesType, singleItem
  for id, item in pairs(Table_HomeFurniture) do
    singleItem = HomeContentData.new(item, SnowRealmProxy.BuildType.Furniture)
    for i = 1, #l_furnitureSeriesConfig do
      seriesType = l_furnitureSeriesConfig[i].seriesType
      if 0 < seriesType and 0 < item.Catagory & seriesType then
        self:SetDataToType(datas[seriesType], singleItem:GetDataType(), singleItem)
      end
    end
    self:SetDataToType(datas[SnowRealmProxy.FurnitureSpecialCatagory.All], singleItem:GetDataType(), singleItem)
    if 0 < item.Theme then
      self:SetDataToType(datas[SnowRealmProxy.FurnitureSpecialCatagory.Theme], item.Theme, singleItem)
    end
  end
  self.buildingDatas[SnowRealmProxy.BuildType.Furniture] = datas
  datas = {}
  for id, item in pairs(Table_HomeFurnitureMaterial) do
    singleItem = HomeContentData.new(item, SnowRealmProxy.BuildType.Renovation)
    self:SetDataToType(datas, singleItem:GetDataType(), singleItem)
  end
  self.buildingDatas[SnowRealmProxy.BuildType.Renovation] = datas
end

function SnowRealmProxy:GetBuidingDatas(buildType)
  return self.buildingDatas[buildType]
end

function SnowRealmProxy:InitDataUpdateHandler()
  self.dataUpdateHandler = {
    [NFurnitureData.EnumDataType.State] = self._HandleStateDataUpdate,
    [NFurnitureData.EnumDataType.Seats] = self._HandleSeatsDataUpdate,
    [NFurnitureData.EnumDataType.Photo] = self._HandlePhotoDataUpdate,
    [NFurnitureData.EnumDataType.Skada] = self._HandleSkadaDataUpdate,
    [NFurnitureData.EnumDataType.Anim] = self._HandleAnimDataUpdate
  }
end

function SnowRealmProxy:_HandleAnimDataUpdate(data, nFurniture, animData)
  if nFurniture == nil then
    return
  end
  local animID = data.animID or 0
  redlog("SnowRealmProxy:_HandleAnimDataUpdate", animID)
  if animID ~= 0 then
    nFurniture:PlayActionByID(animID, true)
  end
end

function SnowRealmProxy:_HandleStateDataUpdate(data, nFurniture)
  if nFurniture == nil then
    return
  end
  local param = data.staticData.FurnitureFunction[1]
  if param == nil then
    return
  end
  param = param.param
  if param == nil then
    return
  end
  if data:IsStateOn() then
    nFurniture:PlayActionByID(param.OnAction, true)
  elseif data:IsStateOff() then
    nFurniture:PlayActionByID(param.OffAction, true)
  end
end

function SnowRealmProxy:_HandleSeatsDataUpdate(data, nFurniture)
  if nFurniture ~= nil then
    nFurniture:UpdateSeats(data.seats)
  end
end

function SnowRealmProxy:_HandlePhotoDataUpdate(data, nFurniture)
  if nFurniture ~= nil and data.photo ~= nil then
    if data.photo.source == 0 and data.photo.sourceid == 0 then
      nFurniture:UpdatePhoto()
    else
      local tex = Game.HomeWallPicManager:TryGetThumbnail(data.photo)
      if tex then
        nFurniture:UpdatePhoto(tex)
      end
    end
  end
end

function SnowRealmProxy:_HandleSkadaDataUpdate(data, nFurniture, serverSkadaData)
  if not serverSkadaData then
    return
  end
  self:ClearSkadaData()
  self.skadaHistoryMax = ReusableTable.CreateArray()
  local serverArray = serverSkadaData.history_max
  local singleTable
  for i = 1, #serverArray do
    singleTable = ReusableTable.CreateTable()
    self.skadaHistoryMax[#self.skadaHistoryMax + 1] = self:ParseServerDamageItem(singleTable, serverArray[i])
  end
  table.sort(self.skadaHistoryMax, function(a, b)
    if a.averageDamage ~= b.averageDamage then
      return a.averageDamage > b.averageDamage
    end
    if a.totalDamage ~= b.totalDamage then
      return a.totalDamage > b.totalDamage
    end
    if a.totalTime ~= b.totalTime then
      return a.totalTime > b.totalTime
    end
    return a.baselevel < b.baselevel
  end)
  self.skadaTodayMax = ReusableTable.CreateArray()
  serverArray = serverSkadaData.day_max
  local rounds, clientRounds, singleRound, singleServerData, profession
  for i = 1, #serverArray do
    singleServerData = serverArray[i]
    profession = singleServerData.user.profession
    singleTable = ReusableTable.CreateTable()
    clientRounds = ReusableTable.CreateArray()
    singleTable.rounds = clientRounds
    self.skadaTodayMax[#self.skadaTodayMax + 1] = self:ParseServerDamageItem(singleTable, singleServerData)
    rounds = singleServerData.rounds
    for j = 1, #rounds do
      singleRound = rounds[j]
      singleTable = ReusableTable.CreateTable()
      singleTable.skillID = singleRound.skillid
      singleTable.atkCount = math.max(singleRound.atkcount, 1)
      singleTable.totalDamage = singleRound.totaldamage
      singleTable.averageDamage = singleRound.totaldamage / singleRound.atkcount
      singleTable.percent = singleRound.totaldamage / singleServerData.totaldamage
      singleTable.profession = profession
      clientRounds[#clientRounds + 1] = singleTable
    end
  end
  table.sort(self.skadaTodayMax, function(a, b)
    if a.averageDamage ~= b.averageDamage then
      return a.averageDamage > b.averageDamage
    end
    if a.totalDamage ~= b.totalDamage then
      return a.totalDamage > b.totalDamage
    end
    if a.totalTime ~= b.totalTime then
      return a.totalTime > b.totalTime
    end
    return a.baselevel < b.baselevel
  end)
  EventManager.Me():DispatchEvent(HomeEvent.QuerySkadaData)
end

function SnowRealmProxy:ClearSkadaData()
  if self.skadaHistoryMax then
    for i = 1, #self.skadaHistoryMax do
      ReusableTable.DestroyAndClearTable(self.skadaHistoryMax[i])
    end
    ReusableTable.DestroyAndClearArray(self.skadaHistoryMax)
    self.skadaHistoryMax = nil
  end
  if self.skadaTodayMax then
    local rounds
    for i = 1, #self.skadaTodayMax do
      rounds = self.skadaTodayMax[i].rounds
      for j = 1, #rounds do
        ReusableTable.DestroyAndClearTable(rounds[j])
      end
      ReusableTable.DestroyAndClearArray(rounds)
      ReusableTable.DestroyAndClearTable(self.skadaTodayMax[i])
    end
    ReusableTable.DestroyAndClearArray(self.skadaTodayMax)
    self.skadaTodayMax = nil
  end
end

function SnowRealmProxy:ParseServerDamageItem(singleTable, singleServerData)
  local serverUser = singleServerData.user
  singleTable.charid = serverUser.charid
  singleTable.body = serverUser.body
  singleTable.eye = serverUser.eye
  singleTable.hair = serverUser.hair
  singleTable.haircolor = serverUser.haircolor
  singleTable.baselevel = serverUser.baselevel
  singleTable.blink = serverUser.blink
  singleTable.profession = serverUser.profession
  singleTable.gender = serverUser.gender
  singleTable.name = serverUser.name
  singleTable.guildname = serverUser.guildname
  singleTable.serverid = serverUser.serverid
  singleTable.woodRace = singleServerData.race
  singleTable.woodShape = singleServerData.shape
  singleTable.woodNature = singleServerData.nature
  singleTable.woodNatureLv = singleServerData.naturelv
  singleTable.woodDamageReduce = singleServerData.hpreduce
  singleTable.totalDamage = math.max(singleServerData.totaldamage, 1)
  singleTable.totalTime = math.max(singleServerData.totaltime, 1)
  singleTable.averageDamage = singleTable.totalDamage / singleTable.totalTime
  return singleTable
end

function SnowRealmProxy:InitRenovationDataUpdateHandler()
  self.houseDataUpdateHandler = {
    [HouseData.EnumDataType.Info] = self._HandleHouseInfoChange,
    [HouseData.EnumDataType.Renovation] = self._HandleRenovationDataUpdate,
    [HouseData.EnumDataType.SoundList] = self._HandleUpdateSoundList
  }
end

function SnowRealmProxy:_HandleHouseInfoChange(houseIndex)
  if houseIndex ~= self.mySelfHomeIndex then
    return
  end
  if self:IsServerInEditMode() then
    SnowRealmManager.Me():EnterEditMode_Server()
  end
end

function SnowRealmProxy:_HandleRenovationDataUpdate(houseIndex, floorIndex)
  if floorIndex then
    SnowRealmManager.Me():UpdateRenovation(floorIndex, houseIndex)
  else
    SnowRealmManager.Me():ResetRenovations(houseIndex)
  end
  if houseIndex == self.mySelfHomeIndex then
    self.isMyHouseScoreDirty = true
  end
  self:sendNotification(HomeEvent.RenovationChanged)
  EventManager.Me():DispatchEvent(HomeEvent.RenovationChanged)
end

function SnowRealmProxy:RecvSnowFurnitureUpdateHomeCmd(serverDatas)
  local houseIndex = serverDatas.house_index
  local furnitureDatas = self:GetFurnitureDatas(houseIndex)
  local sFurniture, furnitureData, isNewFurniture
  for i = 1, #serverDatas.updates do
    sFurniture = serverDatas.updates[i]
    furnitureData = furnitureDatas[sFurniture.guid] or furnitureDatas[sFurniture.old_guid]
    furnitureDatas[sFurniture.old_guid] = nil
    furnitureData = furnitureData or NFurnitureData.new(sFurniture.guid, sFurniture.id)
    isNewFurniture = not furnitureData:IsServerInited()
    furnitureData:ParseServerData(sFurniture)
    furnitureDatas[sFurniture.guid] = furnitureData
    SnowRealmManager.Me():UpdateFurniture(furnitureData, function(self, nFurniture, nFurnitureData)
      if isNewFurniture then
        self:_OnAddNewFurniture(nFurniture, nFurnitureData)
      end
    end, self, houseIndex)
  end
  for i = 1, #serverDatas.dels do
    furnitureDatas[serverDatas.dels[i]] = nil
    SnowRealmManager.Me():RemoveFurnitureItem_Server(serverDatas.dels[i], houseIndex)
  end
  if not self.mySelfHomeIndex or self.mySelfHomeIndex <= 0 or houseIndex ~= self.mySelfHomeIndex then
    return
  end
  local simpleFurnitureMap = self:GetMyFurnitureSimpleDatasByMapID(Game.MapManager:GetMapID())
  if not simpleFurnitureMap then
    LogUtility.Error("Cannot find myself house data by mapID: " .. tostring(Game.MapManager:GetMapID()))
    return
  end
  self.isMyHouseScoreDirty = true
  local tableFurniture = Table_HomeFurniture
  local tableItem = Table_Item
  local furnitureSData, itemSData, itemType, typeDatas
  for i = 1, #serverDatas.updates do
    sFurniture = serverDatas.updates[i]
    furnitureSData = tableFurniture[sFurniture.id]
    itemSData = tableItem[sFurniture.id]
    itemType = itemSData and itemSData.Type
    if itemType then
      typeDatas = simpleFurnitureMap[itemType]
      if not typeDatas then
        typeDatas = {}
        simpleFurnitureMap[itemType] = typeDatas
      end
      typeDatas[sFurniture.guid] = furnitureSData
    end
  end
  local guid
  for i = 1, #serverDatas.dels do
    guid = serverDatas.dels[i]
    for typeID, typeDatas in pairs(simpleFurnitureMap) do
      typeDatas[guid] = nil
    end
  end
end

function SnowRealmProxy:SetDataToType(targetList, type, data)
  local typeDatas = targetList[type]
  if not typeDatas then
    typeDatas = {}
    targetList[type] = typeDatas
  end
  typeDatas[data.staticID] = data
end

function SnowRealmProxy:ClearAllFurnitureDatas()
  for i = 1, 6 do
    self:ClearFeedingPets(i)
    self:ClearFurnitureDatas(i)
  end
end

function SnowRealmProxy:ClearFurnitureDatas(houseIndex)
  TableUtility.TableClear(self.furnitureDatas[houseIndex].nFurnitureMap)
  if houseIndex == self.mySelfHomeIndex then
    self.isMyHouseScoreDirty = true
  end
end

function SnowRealmProxy:GetFurnitureDatas(houseIndex)
  return self.furnitureDatas[houseIndex].nFurnitureMap
end

function SnowRealmProxy:GetFurnitureData(id, staticID, houseIndex)
  if nil == houseIndex then
    houseIndex = self.mySelfHomeIndex
  end
  local furnitureData = self:FindFurnitureData(id, houseIndex)
  if furnitureData and furnitureData.staticID == staticID then
    return furnitureData
  end
  furnitureData = NFurnitureData.new(id, staticID)
  self.furnitureDatas[houseIndex].nFurnitureMap[id] = furnitureData
  return furnitureData
end

function SnowRealmProxy:HandleQueryFurnitureDatas(serverDatas)
end

function SnowRealmProxy:RecvSnowHouseDataUpdateHomeCmd(data)
  local houseIndex = data.house_index
  local houseData = self:GetHouseData(houseIndex)
  if houseData then
    local datas = data.updates
    local dataType, value, handler
    for i = 1, #datas do
      dataType, value = houseData:UpdateSingleData(datas[i])
      if value then
        handler = self.houseDataUpdateHandler[dataType]
        if handler then
          handler(self, houseIndex, value)
        end
      end
    end
  end
  if houseIndex == self.mySelfHomeIndex and self.myHouseData then
    local datas = data.updates
    for i = 1, #datas do
      self.myHouseData:UpdateSingleData(datas[i])
    end
  end
end

function SnowRealmProxy:_OnAddNewFurniture(nFurniture, orginData)
  if not nFurniture then
    return
  end
  for dataType, handler in pairs(self.dataUpdateHandler) do
    handler(self, orginData, nFurniture)
  end
  GameFacade.Instance:sendNotification(HomeEvent.AddFurniture, nFurniture)
  EventManager.Me():DispatchEvent(HomeEvent.AddFurniture, nFurniture)
end

function SnowRealmProxy:GetMySelfHomeIndex()
  return self.mySelfHomeIndex
end

function SnowRealmProxy:ClearDatas()
  self:ClearAllFurnitureDatas()
end

function SnowRealmProxy:ClearFeedingPets(houseIndex)
  if houseIndex ~= nil then
    local houseData = self:GetHouseData(houseIndex)
    if houseData then
      houseData:ClearFeedingPet()
    end
    return
  end
  if self.myHouseData then
    self.myHouseData:ClearFeedingPet()
  end
  for i = 1, 6 do
    local houseData = self:GetHouseData(i)
    if houseData then
      houseData:ClearFeedingPet()
    end
  end
end

function SnowRealmProxy:GetHouseData(houseIndex)
  return self.furnitureDatas[houseIndex].houseData
end

function SnowRealmProxy:GetCurFeedingPet(houseIndex)
  if nil == houseIndex then
    houseIndex = self.mySelfHomeIndex
  end
  if self.furnitureDatas[houseIndex].houseData then
    return self.furnitureDatas[houseIndex].houseData:GetFeedingPetRole()
  end
end

function SnowRealmProxy:IsServerInEditMode()
  local curHouseData
  if self.mySelfHomeIndex and self.mySelfHomeIndex > 0 then
    curHouseData = self:GetHouseData(self.mySelfHomeIndex)
  end
  return (curHouseData and curHouseData.houseState == HomeCmd_pb.EHOUSESTATE_EDIT) == true
end

function SnowRealmProxy:GetDatasByType(buildType, seriesType, dataType)
  local datas = self.buildingDatas[buildType]
  if not seriesType then
    return datas
  end
  local seriesDatas = datas and datas[seriesType]
  if not dataType then
    return seriesDatas
  end
  return seriesDatas and seriesDatas[dataType]
end

function SnowRealmProxy:CheckCategory(staticData, tarSeriesType)
  if not staticData then
    return false
  end
  if not tarSeriesType or tarSeriesType == SnowRealmProxy.FurnitureSpecialCatagory.All then
    return true
  end
  if tarSeriesType == SnowRealmProxy.FurnitureSpecialCatagory.Theme then
    return staticData.Theme ~= nil and staticData.Theme > 0
  end
  return (0 < tarSeriesType and staticData.Catagory and 0 < staticData.Catagory & tarSeriesType) == true
end

function SnowRealmProxy:FindContentDataBySID(staticID, buildType)
  local staticData = Table_HomeFurniture[staticID]
  if staticData and buildType ~= SnowRealmProxy.BuildType.Renovation then
    local datas = self:GetDatasByType(SnowRealmProxy.BuildType.Furniture, SnowRealmProxy.FurnitureSpecialCatagory.All, staticData.Type or HomeContentData.DefaultDataType)
    return datas and datas[staticID]
  end
  staticData = Table_HomeFurnitureMaterial[staticID]
  if staticData and buildType ~= SnowRealmProxy.BuildType.Furniture then
    local datas = self:GetDatasByType(SnowRealmProxy.BuildType.Renovation, staticData.Type or HomeContentData.DefaultDataType)
    return datas and datas[staticID]
  end
  redlog(tostring(staticID) .. " is not furniture or home material")
end

function SnowRealmProxy:CalHouseScoreByItemIDs(itemIDs)
  LogUtility.Error("SnowRealmProxy:CalHouseScoreByItemIDs is not implemented")
end

function SnowRealmProxy:GetMyHouseData(houseType)
  redlog("SnowRealmProxy:GetMyHouseData houseType", tostring(houseType), "mySelfHomeIndex", tostring(self.mySelfHomeIndex))
  if not houseType or houseType == HomeProxy.HouseType.Snow then
    return self.myHouseData
  end
end

function SnowRealmProxy:GetMyHouseDataByMapID(mapID)
  if self.myHouseData and (not mapID or mapID == self.myHouseData.mapID) then
    return self.myHouseData
  end
end

function SnowRealmProxy:GetMyFurnitureSimpleDatasByMapID(mapID)
  if self.myHouseData and self.myHouseData.mapID == mapID then
    return self.myHouseFurnitureSimpleDatas
  end
end

function SnowRealmProxy:HandleQuerySnowHouseDataHomeCmd(serverDatas)
  local houseIndex = serverDatas.index
  redlog("HandleQuerySnowHouseDataHomeCmd", tostring(houseIndex), serverDatas.house == nil and "nil" or "not nil")
  if houseIndex and 0 < houseIndex then
    self:ClearFeedingPets(houseIndex)
    if serverDatas.house and serverDatas.house.accid ~= 0 then
      self.furnitureDatas[houseIndex].houseData = HouseData.new(serverDatas.house, houseIndex)
      if serverDatas.house.accid == FunctionLogin.Me():getLoginData().accid then
        self.mySelfHomeIndex = houseIndex
      end
      SnowRealmManager.Me():SetHomeState(houseIndex, false)
    else
      SnowRealmManager.Me():SetHomeState(houseIndex, true)
      self.furnitureDatas[houseIndex].houseData = nil
      self:ClearFurnitureDatas(houseIndex)
      SnowRealmManager.Me():ClearFurnituresByHouseIndex(true, houseIndex)
    end
  end
end

function SnowRealmProxy:FindFurnitureData(id, houseIndex)
  if nil == houseIndex then
    houseIndex = self.mySelfHomeIndex
  end
  local furnitureData = self.furnitureDatas[houseIndex].nFurnitureMap[id]
  return furnitureData
end

function SnowRealmProxy:GetPlacedFurnitureNum(furnitureSID)
  LogUtility.Error("SnowRealmProxy:GetPlacedFurnitureNum is not implemented")
end

function SnowRealmProxy:GetPlacedFurnitureNumByHouseType(furnitureSID, houseType)
  LogUtility.Error("SnowRealmProxy:GetPlacedFurnitureNumByHouseType is not implemented")
end

function SnowRealmProxy:GetAreaLimitStr(limitType)
  if not limitType then
    return ZhString.HomeBuilding_None
  end
  local sb = LuaStringBuilder.CreateAsTable()
  for k, v in pairs(SnowRealmProxy.HouseType) do
    if 0 < limitType & v then
      if 0 < sb:GetCount() then
        sb:Append(ZhString.ItemTip_ChAnd)
      end
      sb:Append(ZhString["HomeBuilding_" .. k])
    end
  end
  local limitStr = sb:ToString()
  sb:Destroy()
  return StringUtil.IsEmpty(limitStr) and ZhString.HomeBuilding_CannotPlace or limitStr
end

function SnowRealmProxy:GetCurHouseData(houseIndex)
  houseIndex = houseIndex or self.mySelfHomeIndex
  if houseIndex and 0 < houseIndex then
    return self.furnitureDatas[houseIndex].houseData
  end
  if houseIndex == self.mySelfHomeIndex then
    return self.myHouseData
  end
  return nil
end

function SnowRealmProxy:GetBluePrintData(bpStaticID)
  local data = self.bpDataCache[bpStaticID]
  if data then
    data:RefreshBagNum()
    return data
  end
  data = HomeBluePrintData.new(bpStaticID)
  if not data.inited then
    return nil
  end
  self.bpDataCache[bpStaticID] = data
  return data
end

function SnowRealmProxy:IsILikeBluePrint(bpStaticID)
  local likeIDConfig = GameConfig.Home.BluePrintLikeID
  local singleBpLikeInfo = self.bpLikeInfo and self.bpLikeInfo[likeIDConfig and likeIDConfig[bpStaticID] or bpStaticID]
  return (singleBpLikeInfo and singleBpLikeInfo.iLiked) == true
end

function SnowRealmProxy:GetBluePrintLikeNum(bpStaticID)
  local likeIDConfig = GameConfig.Home.BluePrintLikeID
  local singleBpLikeInfo = self.bpLikeInfo and self.bpLikeInfo[likeIDConfig and likeIDConfig[bpStaticID] or bpStaticID]
  return singleBpLikeInfo and singleBpLikeInfo.likeNum or 0
end

function SnowRealmProxy:GetSimpleItemTypeName(typeID)
  local data = Table_ItemType[typeID]
  if not data then
    return "-"
  end
  local name = data.Name
  local startPos = string.find(name, "-")
  return startPos and string.sub(name, startPos + 1, string.len(name)) or name
end

function SnowRealmProxy:ClearBluePrintsInfoCache()
  TableUtility.TableClear(self.bpDataCache)
end

function SnowRealmProxy:ClearBPLikeInfo()
  if not self.bpLikeInfo then
    return
  end
  for id, bpLikeInfo in pairs(self.bpLikeInfo) do
    ReusableTable.DestroyAndClearTable(bpLikeInfo)
  end
  ReusableTable.DestroyAndClearTable(self.bpLikeInfo)
  self.bpLikeInfo = nil
end

function SnowRealmProxy:HandlePrintUpdateHomeCmd(data)
  if not self.bpLikeInfo then
    self.bpLikeInfo = ReusableTable.CreateTable()
  end
  local serverItems = data.items
  if not serverItems then
    return
  end
  local singleItem, clientBPData, serverDatas, singleData
  for i = 1, #serverItems do
    singleItem = serverItems[i]
    clientBPData = self.bpLikeInfo[singleItem.id]
    if not clientBPData then
      clientBPData = ReusableTable.CreateTable()
      self.bpLikeInfo[singleItem.id] = clientBPData
    end
    serverDatas = singleItem.datas
    for j = 1, #serverDatas do
      singleData = serverDatas[j]
      if singleData.data == HomeCmd_pb.EPRINTDATA_PRAISECOUNT then
        clientBPData.likeNum = singleData.value
      elseif singleData.data == HomeCmd_pb.EPRINTDATA_ISPRAISE then
        clientBPData.iLiked = singleData.value ~= 0
      end
    end
  end
end

function SnowRealmProxy:CalMyHouseScore_Client()
  if self.myHouseScore and not self.isMyHouseScoreDirty then
    return self.myHouseScore
  end
  self.isMyHouseScoreDirty = false
  self.myHouseScore = 0
  local tempTypeMap = ReusableTable.CreateTable()
  HomeProxy.__RealInstance:GenerateSingleHouseScoreMap_Client(HomeProxy.HouseType.Snow, tempTypeMap)
  for typeID, furnitureSData in pairs(tempTypeMap) do
    self.myHouseScore = self.myHouseScore + furnitureSData.HomeScore
  end
  ReusableTable.DestroyAndClearTable(tempTypeMap)
  return self.myHouseScore
end

function SnowRealmProxy:GetSkadaHistoryMax()
  return self.skadaHistoryMax
end

function SnowRealmProxy:GetSkadaTodayMax()
  return self.skadaTodayMax
end

function SnowRealmProxy:RecvRandHomeGiftBoxGridCmd(data)
  LogUtility.Error("SnowRealmProxy:RecvRandHomeGiftBoxGridCmd is not implemented")
end

function SnowRealmProxy:RecvSnowFurnitureDataUpdateHomeCmd(data)
  local houseIndex = data.house_index
  local furnitureData = self.furnitureDatas[houseIndex].nFurnitureMap[data.guid]
  if furnitureData ~= nil then
    self:_FurnitureDataUpdate(furnitureData, data.updates, houseIndex)
  end
end

function SnowRealmProxy:_FurnitureDataUpdate(orginData, datas, houseIndex)
  local dirtys = ReusableTable.CreateTable()
  local dataType, returnData
  for i = 1, #datas do
    dataType, returnData = orginData:UpdateSingleData(datas[i])
    if dataType then
      dirtys[dataType] = returnData
    end
  end
  if dirtys[NFurnitureData.EnumDataType.Build] then
    local copy = {}
    TableUtility.TableShallowCopy(copy, dirtys)
    SnowRealmManager.Me():UpdateFurniture(orginData, function(self, nFurniture, nFurnitureData)
      nFurniture = nFurniture or SnowRealmManager.Me():FindFurniture(nFurnitureData.id, false, houseIndex)
      local handler
      for k, v in pairs(copy) do
        handler = self.dataUpdateHandler[k]
        if handler ~= nil then
          handler(self, nFurnitureData, nFurniture, v)
        end
      end
    end, self, houseIndex)
  else
    local nFurniture = SnowRealmManager.Me():FindFurniture(orginData.id, false, houseIndex)
    local handler
    for k, v in pairs(dirtys) do
      handler = self.dataUpdateHandler[k]
      if handler ~= nil then
        handler(self, orginData, nFurniture, v)
      end
    end
  end
  ReusableTable.DestroyAndClearTable(dirtys)
end

function SnowRealmProxy:RecvSnowFurnitureOperHomeCmd(data)
  local houseIndex = data.house_index
  local oper_cmd = data.oper_cmd
  local nfurniture = SnowRealmManager.Me():FindFurniture(oper_cmd.guid, nil, houseIndex)
  if nfurniture == nil then
    return
  end
  if oper_cmd.oper == self.Oper.Action then
    nfurniture:PlayActionByID(oper_cmd.value, true)
  end
end

function SnowRealmProxy:_HandleUpdateSoundList()
  local curHomeIdx = SnowRealmManager.Me():GetCurHomeIdx()
  local houseData = curHomeIdx and 0 < curHomeIdx and self.furnitureDatas[curHomeIdx].houseData
  local curSoundList = houseData and houseData.furnitureSoundList
  if curSoundList then
    self.furnitureDatas[curHomeIdx].curSoundList = curSoundList
    self:PassSoundListUpdateEvent()
  end
end

function SnowRealmProxy:PassSoundListUpdateEvent()
  self:sendNotification(HomeEvent.SoundListUpdate)
end

function SnowRealmProxy:RemoveOutOfDateSounds(nowTime)
  local isRemoved, soundData, staticData = false
  nowTime = nowTime or ServerTime.CurServerTime() / 1000
  for idx, furnitureData in pairs(self.furnitureDatas) do
    local curSoundList = furnitureData.curSoundList
    if curSoundList then
      for i = #curSoundList, 1, -1 do
        soundData = curSoundList[i]
        staticData = Table_MusicBox[soundData.musicid]
        if not staticData or nowTime > soundData.starttime + staticData.MusicTim then
          table.remove(curSoundList, i)
          isRemoved = true
        end
      end
    end
  end
  if isRemoved then
    self:PassSoundListUpdateEvent()
  end
end

function SnowRealmProxy:GetCurSoundList()
  local curHomeIdx = SnowRealmManager.Me():GetCurHomeIdx()
  local furnitureData = curHomeIdx and 0 < curHomeIdx and self.furnitureDatas[curHomeIdx]
  local curSoundList = furnitureData and furnitureData.curSoundList
  return curSoundList or _EmptyTable
end

function SnowRealmProxy:CanUseFurnitureBySID(furnitureSID)
  local itemData = Table_Item[furnitureSID]
  local itemType = itemData and itemData.Type
  if not itemType then
    return false
  end
  local myHouseData = self:GetMyHouseData()
  if myHouseData then
    local shieldList = myHouseData:GetMasterShieldTypes()
    if TableUtility.ArrayFindIndex(shieldList, itemType) > 0 then
      return false
    end
  end
  if SnowRealmManager.Me():IsAtMyselfHome() then
    return true
  end
  local forceForbidTypes = GameConfig.Home.force_forbid_furn_other
  if forceForbidTypes and TableUtility.ArrayFindIndex(forceForbidTypes, itemType) > 0 then
    return false
  end
  local forceForbidIDs = GameConfig.Home.force_forbid_furnid_other
  if forceForbidIDs and TableUtility.ArrayFindIndex(forceForbidIDs, furnitureSID) > 0 then
    return false
  end
  local curHouseData = self:GetCurHouseData()
  if curHouseData and 0 < TableUtility.ArrayFindIndex(curHouseData:GetVisitorForbidTypes(), itemType) then
    return false
  end
  local furnitureSData = Table_HomeFurniture[furnitureSID]
  if not furnitureSData then
    return false
  end
  local areaLimit = furnitureSData.AreaForceLimit or furnitureSData.AreaLimit
  if areaLimit then
    local houseConfig = curHouseData and curHouseData.houseConfig
    if not houseConfig or houseConfig.Area & areaLimit < 1 then
      return false
    end
  end
  return true
end

function SnowRealmProxy:HandleOptUpdateHomeCmd(serverData)
  redlog("SnowRealmProxy:HandleOptUpdateHomeCmd:", serverData.type)
  local accid = serverData.accid
  if self.furnitureDatas then
    for _, data in pairs(self.furnitureDatas) do
      if data.houseData and data.houseData.accid == accid then
        data.houseData:UpdateHomeOptData(serverData)
      end
    end
  end
  if accid == FunctionLogin.Me():getLoginData().accid and self.myHouseData then
    self.myHouseData:UpdateHomeOptData(serverData)
  end
end

function SnowRealmProxy:HandleQueryHomeDataHomeCmd(serverData)
  if serverData.house then
    if self.myHouseData then
      self.myHouseData:ClearFeedingPet()
    end
    self.myHouseData = HouseData.new(serverData.house)
  end
end

function SnowRealmProxy:HandleRecvQueryHouseFurnitureHomeCmd(serverData)
  local sessionid = serverData.sessionid
  if self.sessionid ~= sessionid then
    TableUtility.TableClear(self.myHouseFurnitureSimpleDatas)
  end
  self:GenerateFurnitureSimpleDatas(self.myHouseFurnitureSimpleDatas, serverData.furnitures)
  self.sessionid = sessionid
end

function SnowRealmProxy:GenerateFurnitureSimpleDatas(targetList, serverDatas)
  if not serverDatas then
    return
  end
  local tableFurniture = Table_HomeFurniture
  local tableItem = Table_Item
  local sFurniture, furnitureSData, itemSData, itemType, typeDatas
  for i = 1, #serverDatas do
    sFurniture = serverDatas[i]
    furnitureSData = tableFurniture[sFurniture.id]
    redlog("SnowRealmProxy:GenerateFurnitureSimpleDatas", tostring(sFurniture.id))
    itemSData = tableItem[sFurniture.id]
    itemType = itemSData and itemSData.Type
    if itemType then
      typeDatas = targetList[itemType]
      if not typeDatas then
        typeDatas = {}
        targetList[itemType] = typeDatas
      end
      typeDatas[sFurniture.guid] = furnitureSData
    end
  end
end

function SnowRealmProxy:GetMyFurnitureSimpleDatas()
  return self.myHouseFurnitureSimpleDatas
end
