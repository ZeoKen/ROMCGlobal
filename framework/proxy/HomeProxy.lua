pcall(function()
  autoImport("Table_HomeOfficialBluePrint")
end)
autoImport("HomeContentData")
autoImport("NFurnitureData")
autoImport("HouseData")
autoImport("HomeBluePrintData")
HomeProxy = class("HomeProxy", pm.Proxy)
HomeProxy.Instance = nil
HomeProxy.NAME = "HomeProxy"
HomeProxy.BuildType = {
  Furniture = HomeContentData.Type.Furniture,
  Renovation = HomeContentData.Type.Renovation
}
HomeProxy.FurnitureSpecialCatagory = {All = 0, Theme = -1}
HomeProxy.Oper = {
  Interact = HomeCmd_pb.EFURNITUREOPER_SEAT,
  Stop = HomeCmd_pb.EFURNITUREOPER_STOP,
  On = HomeCmd_pb.EFURNITUREOPER_ON,
  Off = HomeCmd_pb.EFURNITUREOPER_OFF,
  Pray = HomeCmd_pb.EFURNITUREOPER_PRAY,
  Weather = HomeCmd_pb.EFURNITUREOPER_WEATHER,
  Mirror = HomeCmd_pb.EFURNITUREOPER_MIRROR,
  Reward = HomeCmd_pb.EFURNITUREOPER_REWARD,
  Photo = HomeCmd_pb.EFURNITUREOPER_PHOTO,
  Action = HomeCmd_pb.EFURNITUREOPER_ACTION,
  WoodQuery = HomeCmd_pb.EFURNITUREOPER_WOOD_QUERY,
  WoodSet = HomeCmd_pb.EFURNITUREOPER_WOOD_SET,
  WoodOver = HomeCmd_pb.EFURNITUREOPER_WOOD_OVER,
  WoodClear = HomeCmd_pb.EFURNITUREOPER_WOOD_CLEAR,
  AddMessage = HomeCmd_pb.EFURNITUREOPER_BOARD_ADDMSG,
  DelMessage = HomeCmd_pb.EFURNITUREOPER_BOARD_DELMSG
}
HomeProxy.HouseType = {
  Home = 1,
  Garden = 2,
  MarrageHouse = 4
}

function HomeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HomeProxy.NAME
  if HomeProxy.Instance == nil then
    HomeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:InitDataUpdateHandler()
  self:InitRenovationDataUpdateHandler()
  self:InitHouseOptDataUpdateHandler()
end

function HomeProxy:Init()
  self.buildingDatas = {}
  self.furnitureDatas = {}
  self.myHomeFurnitureSimpleDatas = {}
  self.myGardenFurnitureSimpleDatas = {}
  self.bpDataCache = {}
  self.giftCellMap = {}
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
    singleItem = HomeContentData.new(item, HomeProxy.BuildType.Furniture)
    for i = 1, #l_furnitureSeriesConfig do
      seriesType = l_furnitureSeriesConfig[i].seriesType
      if 0 < seriesType and 0 < item.Catagory & seriesType then
        self:SetDataToType(datas[seriesType], singleItem:GetDataType(), singleItem)
      end
    end
    self:SetDataToType(datas[HomeProxy.FurnitureSpecialCatagory.All], singleItem:GetDataType(), singleItem)
    if 0 < item.Theme then
      self:SetDataToType(datas[HomeProxy.FurnitureSpecialCatagory.Theme], item.Theme, singleItem)
    end
  end
  self.buildingDatas[HomeProxy.BuildType.Furniture] = datas
  datas = {}
  for id, item in pairs(Table_HomeFurnitureMaterial) do
    singleItem = HomeContentData.new(item, HomeProxy.BuildType.Renovation)
    self:SetDataToType(datas, singleItem:GetDataType(), singleItem)
  end
  self.buildingDatas[HomeProxy.BuildType.Renovation] = datas
end

function HomeProxy:SetDataToType(targetList, type, data)
  local typeDatas = targetList[type]
  if not typeDatas then
    typeDatas = {}
    targetList[type] = typeDatas
  end
  typeDatas[data.staticID] = data
end

function HomeProxy:GetBuidingDatas(buildType)
  return self.buildingDatas[buildType]
end

function HomeProxy:GetDatasByType(buildType, seriesType, dataType)
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

function HomeProxy:FindContentDataBySID(staticID, buildType)
  local staticData = Table_HomeFurniture[staticID]
  if staticData and buildType ~= HomeProxy.BuildType.Renovation then
    local datas = self:GetDatasByType(HomeProxy.BuildType.Furniture, HomeProxy.FurnitureSpecialCatagory.All, staticData.Type or HomeContentData.DefaultDataType)
    return datas and datas[staticID]
  end
  staticData = Table_HomeFurnitureMaterial[staticID]
  if staticData and buildType ~= HomeProxy.BuildType.Furniture then
    local datas = self:GetDatasByType(HomeProxy.BuildType.Renovation, staticData.Type or HomeContentData.DefaultDataType)
    return datas and datas[staticID]
  end
  redlog(tostring(staticID) .. " is not furniture or home material")
end

function HomeProxy:GetSimpleItemTypeName(typeID)
  local data = Table_ItemType[typeID]
  if not data then
    return "-"
  end
  local name = data.Name
  local startPos = string.find(name, "-")
  return startPos and string.sub(name, startPos + 1, string.len(name)) or name
end

function HomeProxy:CheckCategory(staticData, tarSeriesType)
  if not staticData then
    return false
  end
  if not tarSeriesType or tarSeriesType == HomeProxy.FurnitureSpecialCatagory.All then
    return true
  end
  if tarSeriesType == HomeProxy.FurnitureSpecialCatagory.Theme then
    return staticData.Theme ~= nil and staticData.Theme > 0
  end
  return (0 < tarSeriesType and staticData.Catagory and 0 < staticData.Catagory & tarSeriesType) == true
end

function HomeProxy:ClearDatas()
  self:ClearFeedingPets()
  self.curHouseData = nil
  self.isAtMyselfHome = false
  self:ClearFurnitureDatas()
  self:ClearSkadaData()
  self:ClearGiftBoxDatas()
  TimeTickManager.Me():ClearTick(self)
end

function HomeProxy:ClearFeedingPets()
  if self.curHouseData then
    self.curHouseData:ClearFeedingPet()
  end
end

function HomeProxy:GetCurFeedingPet()
  if self.curHouseData then
    return self.curHouseData:GetFeedingPetRole()
  end
end

function HomeProxy:ClearFurnitureDatas()
  TableUtility.TableClear(self.furnitureDatas)
  self.isMyHouseScoreDirty = true
end

function HomeProxy:GetFurnitureDatas()
  return self.furnitureDatas
end

function HomeProxy:FindFurnitureData(id)
  return self.furnitureDatas[id]
end

function HomeProxy:GetFurnitureData(id, staticID)
  local furnitureData = self:FindFurnitureData(id)
  if furnitureData and furnitureData.staticID == staticID then
    return furnitureData
  end
  furnitureData = NFurnitureData.new(id, staticID)
  self.furnitureDatas[id] = furnitureData
  return furnitureData
end

function HomeProxy:GetBluePrintData(bpStaticID)
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

function HomeProxy:IsILikeBluePrint(bpStaticID)
  local likeIDConfig = GameConfig.Home.BluePrintLikeID
  local singleBpLikeInfo = self.bpLikeInfo and self.bpLikeInfo[likeIDConfig and likeIDConfig[bpStaticID] or bpStaticID]
  return (singleBpLikeInfo and singleBpLikeInfo.iLiked) == true
end

function HomeProxy:GetBluePrintLikeNum(bpStaticID)
  local likeIDConfig = GameConfig.Home.BluePrintLikeID
  local singleBpLikeInfo = self.bpLikeInfo and self.bpLikeInfo[likeIDConfig and likeIDConfig[bpStaticID] or bpStaticID]
  return singleBpLikeInfo and singleBpLikeInfo.likeNum or 0
end

function HomeProxy:ClearBluePrintsInfoCache()
  TableUtility.TableClear(self.bpDataCache)
end

function HomeProxy:GetCurHouseData()
  return self.curHouseData
end

function HomeProxy:GetMyHouseData(houseType)
  if not houseType or houseType == HomeProxy.HouseType.Home then
    return self.myHouseData
  end
  if houseType == HomeProxy.HouseType.Garden then
    return self.myGardenData
  end
end

function HomeProxy:GetMyHouseDataByMapID(mapID)
  if self.myHouseData and (not mapID or mapID == self.myHouseData.mapID) then
    return self.myHouseData
  end
  if self.myGardenData and mapID == self.myGardenData.mapID then
    return self.myGardenData
  end
end

function HomeProxy:RecvRandHomeGiftBoxGridCmd(data)
  self.readyToChooseCount = data.rand_num or 0
  TableUtility.TableClear(self.giftCellMap)
  local curGrids = data.cur_box_grids
  if curGrids and 0 < #curGrids then
    for i = 1, #curGrids do
      local tempData = {}
      TableUtility.TableShallowCopy(tempData, curGrids[i])
      xdlog("已经被礼物占用的格子", curGrids[i].row, curGrids[i].col, curGrids[i].floor_index)
      table.insert(self.giftCellMap, tempData)
    end
  end
  if HomeManager.Me():IsAtHome() and self.curHouseData then
    HomeManager.Me():CreateRandomGiftCell()
  end
end

function HomeProxy:GetOccupyGiftCells()
  return self.giftCellMap
end

function HomeProxy:AddOccupyGiftCell(rol, col, floorIndex)
  local tempData = {
    row = rol,
    col = col,
    floor_index = floorIndex,
    isNew = true
  }
  xdlog("成功随机并添加", rol, col, floorIndex)
  table.insert(self.giftCellMap, tempData)
end

function HomeProxy:GetRandomCount()
  if self.readyToChooseCount then
    return self.readyToChooseCount
  end
  return 0
end

function HomeProxy:CallRandHomeGiftBoxGridCmd()
  local data = {}
  self.readyToChooseCount = 0
  for i = 1, #self.giftCellMap do
    if self.giftCellMap[i].isNew then
      table.insert(data, self.giftCellMap[i])
    end
  end
  if data and 0 < #data then
    xdlog("成功发送随机位置协议", #data)
    ServiceActivityCmdProxy.Instance:CallRandHomeGiftBoxGridCmd(nil, nil, data)
  end
end

function HomeProxy:ClearGiftBoxDatas()
  TableUtility.TableClear(self.giftCellMap)
  self.readyToChooseCount = 0
end

function HomeProxy:IsServerInEditMode()
  local curHouseData = self:GetCurHouseData()
  return (curHouseData and curHouseData.houseState == HomeCmd_pb.EHOUSESTATE_EDIT) == true
end

function HomeProxy:IsServerAtMyselfHome()
  return self.isAtMyselfHome == true
end

function HomeProxy:GetMyHomeScoreLv()
  local myHouseData = self:GetMyHouseData()
  return myHouseData and myHouseData.lv or 0
end

function HomeProxy:CanUseFurnitureBySID(furnitureSID)
  if HomeManager.ClientTest then
    return true
  end
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
  if self:IsServerAtMyselfHome() then
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

function HomeProxy:CheckFurnitureCanMakeBySID(furnitureSID)
  local itemSData = Table_Item[furnitureSID]
  return BagProxy.Instance:CheckItemCanMakeByComposeID(itemSData and itemSData.ComposeID, BagProxy.MaterialCheckBag_Type.Furniture)
end

function HomeProxy:GetMyFurnitureSimpleDatas(houseType)
  if not houseType or houseType == HomeProxy.HouseType.Home then
    return self.myHomeFurnitureSimpleDatas
  end
  if houseType == HomeProxy.HouseType.Garden then
    return self.myGardenFurnitureSimpleDatas
  end
end

function HomeProxy:GetMyFurnitureSimpleDatasByMapID(mapID)
  if self.myHouseData and self.myHouseData.mapID == mapID then
    return self.myHomeFurnitureSimpleDatas
  end
  if self.myGardenData and self.myGardenData.mapID == mapID then
    return self.myGardenFurnitureSimpleDatas
  end
end

function HomeProxy:GetPlacedFurnitureNum(furnitureSID)
  local placedNum = 0
  for k, v in pairs(HomeProxy.HouseType) do
    placedNum = placedNum + self:GetPlacedFurnitureNumByHouseType(furnitureSID, v)
  end
  return placedNum
end

function HomeProxy:GetPlacedFurnitureNumByHouseType(furnitureSID, houseType)
  local placedNum = 0
  local itemSData = Table_Item[furnitureSID]
  local simpleFurnitureMap = self:GetMyFurnitureSimpleDatas(houseType)
  if itemSData and simpleFurnitureMap then
    local typeDatas = simpleFurnitureMap[itemSData.Type]
    if typeDatas then
      for guid, furnitureSData in pairs(typeDatas) do
        if furnitureSData.id == furnitureSID then
          placedNum = placedNum + 1
        end
      end
    end
  end
  return placedNum
end

function HomeProxy:CalMyHouseScore_Client()
  if self.myHouseScore and not self.isMyHouseScoreDirty then
    return self.myHouseScore
  end
  self.isMyHouseScoreDirty = false
  self.myHouseScore = 0
  local tempTypeMap = ReusableTable.CreateTable()
  for k, v in pairs(HomeProxy.HouseType) do
    self:GenerateSingleHouseScoreMap_Client(v, tempTypeMap)
  end
  for typeID, furnitureSData in pairs(tempTypeMap) do
    self.myHouseScore = self.myHouseScore + furnitureSData.HomeScore
  end
  ReusableTable.DestroyAndClearTable(tempTypeMap)
  return self.myHouseScore
end

function HomeProxy:GenerateSingleHouseScoreMap_Client(houseType, targetMap, invalidMap)
  local simpleFurnitureMap = self:GetMyFurnitureSimpleDatas(houseType)
  if simpleFurnitureMap then
    local typeHighestItem, invalidHighestItem, areaLimit
    for itemType, typeDatas in pairs(simpleFurnitureMap) do
      typeHighestItem = targetMap[itemType]
      invalidHighestItem = nil
      for guid, staticData in pairs(typeDatas) do
        if not typeHighestItem or staticData.HomeScore > typeHighestItem.HomeScore then
          areaLimit = staticData.AreaForceLimit or staticData.AreaLimit
          if not areaLimit or 0 < areaLimit & houseType then
            typeHighestItem = staticData
          else
            invalidHighestItem = staticData
          end
        end
      end
      targetMap[itemType] = typeHighestItem
      if invalidMap and invalidHighestItem and (not typeHighestItem or invalidHighestItem.HomeScore > typeHighestItem.HomeScore) then
        invalidMap[itemType] = invalidHighestItem
      end
    end
  end
  local myHouseData = self:GetMyHouseData(houseType)
  local renovationMap = myHouseData and myHouseData:GetRenovationDataMap()
  if renovationMap then
    local tableItem = Table_Item
    local itemStaticData, itemType, typeHighestItem
    for floorIndex, floorMap in pairs(renovationMap) do
      for typeID, matStaticData in pairs(floorMap) do
        if matStaticData.HomeScore and matStaticData.HomeScore > 0 then
          itemStaticData = tableItem[matStaticData.id]
          itemType = itemStaticData and itemStaticData.Type
          typeHighestItem = targetMap[itemType]
          if itemType and (not typeHighestItem or matStaticData.HomeScore > typeHighestItem.HomeScore) then
            targetMap[itemType] = matStaticData
          end
        end
      end
    end
  end
  return targetMap
end

function HomeProxy:GetAreaLimitStr(limitType)
  if not limitType then
    return ZhString.HomeBuilding_None
  end
  local sb = LuaStringBuilder.CreateAsTable()
  local noLimit = true
  for k, v in pairs(HomeProxy.HouseType) do
    if 0 < limitType & v then
      if 0 < sb:GetCount() then
        sb:Append(ZhString.ItemTip_ChAnd)
      end
      sb:Append(ZhString["HomeBuilding_" .. k])
    elseif v ~= HomeProxy.HouseType.MarrageHouse then
      noLimit = false
    end
  end
  local limitStr = sb:ToString()
  sb:Destroy()
  if noLimit then
    return ZhString.HomeBuilding_None
  end
  return StringUtil.IsEmpty(limitStr) and ZhString.HomeBuilding_CannotPlace or limitStr
end

function HomeProxy:CalHouseScoreByItemIDs(itemIDs)
  local scoreTypeMap = ReusableTable.CreateTable()
  local tableItem = Table_Item
  local tableFurniture = Table_HomeFurniture
  local tableMaterial = Table_HomeFurnitureMaterial
  local singleID, singleItemData, singleHomeItemData
  for i = 1, #itemIDs do
    singleID = itemIDs[i]
    singleItemData = tableItem[singleID]
    singleHomeItemData = tableFurniture[singleID] or tableMaterial[singleID]
    if singleItemData and singleHomeItemData and singleItemData.Type and singleHomeItemData.HomeScore > (scoreTypeMap[singleItemData.Type] or 0) then
      scoreTypeMap[singleItemData.Type] = singleHomeItemData.HomeScore
    end
  end
  local totalScore = 0
  for typeID, typeHighestScore in pairs(scoreTypeMap) do
    totalScore = totalScore + typeHighestScore
  end
  ReusableTable.DestroyAndClearTable(scoreTypeMap)
  return totalScore
end

function HomeProxy:HandleQueryHomeDataHomeCmd(serverDatas)
  if not serverDatas.house then
    LogUtility.Error("Server House Data Is Nil!")
    return
  end
  if serverDatas.house then
    self.myHouseData = BaseHouseData.new(serverDatas.house)
  end
  if serverDatas.garden then
    self.myGardenData = BaseHouseData.new(serverDatas.garden)
  end
end

function HomeProxy:HandleRecvQueryHouseFurnitureHomeCmd(serverDatas)
  local sessionid = serverDatas.sessionid
  local furnitureType = serverDatas.type
  if self.sessionid and self.sessionid ~= sessionid then
    TableUtility.TableClear(self.myHomeFurnitureSimpleDatas)
    TableUtility.TableClear(self.myGardenFurnitureSimpleDatas)
  end
  if furnitureType == 1 then
    self:GenerateFurnitureSimpleDatas(self.myHomeFurnitureSimpleDatas, serverDatas.furnitures)
  elseif furnitureType == 2 then
    self:GenerateFurnitureSimpleDatas(self.myGardenFurnitureSimpleDatas, serverDatas.furnitures)
  end
end

function HomeProxy:GenerateFurnitureSimpleDatas(targetList, serverDatas)
  if not serverDatas then
    return
  end
  local tableFurniture = Table_HomeFurniture
  local tableItem = Table_Item
  local sFurniture, furnitureSData, itemSData, itemType, typeDatas
  for i = 1, #serverDatas do
    sFurniture = serverDatas[i]
    furnitureSData = tableFurniture[sFurniture.id]
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

function HomeProxy:RecvHouseDataUpdateHomeCmd(data)
  if self:IsServerAtMyselfHome() then
    local curMapID = Game.MapManager:GetMapID()
    local myHouseData = self:GetMyHouseData(HomeProxy.HouseType.Home)
    if myHouseData and myHouseData.mapID == curMapID then
      local datas = data.updates
      for i = 1, #datas do
        myHouseData:UpdateSingleData(datas[i])
      end
    end
    local myGardenData = self:GetMyHouseData(HomeProxy.HouseType.Garden)
    if myGardenData and myGardenData.mapID == curMapID then
      local datas = data.updates
      for i = 1, #datas do
        myGardenData:UpdateSingleData(datas[i])
      end
    end
  end
  if self.curHouseData then
    local datas = data.updates
    local dataType, value, handler
    for i = 1, #datas do
      dataType, value = self.curHouseData:UpdateSingleData(datas[i])
      if value then
        handler = self.houseDataUpdateHandler[dataType]
        if handler then
          handler(self, value)
        end
      end
    end
  end
end

function HomeProxy:InitRenovationDataUpdateHandler()
  self.houseDataUpdateHandler = {
    [HouseData.EnumDataType.Info] = self._HandleHouseInfoChange,
    [HouseData.EnumDataType.Renovation] = self._HandleRenovationDataUpdate,
    [HouseData.EnumDataType.SoundList] = self._HandleUpdateSoundList
  }
end

function HomeProxy:_HandleRenovationDataUpdate(floorIndex)
  if floorIndex then
    HomeManager.Me():UpdateRenovation(floorIndex)
  else
    HomeManager.Me():ResetRenovations()
  end
  self.isMyHouseScoreDirty = true
  self:sendNotification(HomeEvent.RenovationChanged)
  EventManager.Me():DispatchEvent(HomeEvent.RenovationChanged)
end

function HomeProxy:_HandleHouseInfoChange()
  if self:IsServerInEditMode() then
    HomeManager.Me():EnterEditMode_Server()
  end
end

function HomeProxy:_HandleUpdateSoundList()
  self.curSoundList = self.curHouseData.furnitureSoundList
  if self.curSoundList then
    self:PassSoundListUpdateEvent()
  end
end

function HomeProxy:HandleOptUpdateHomeCmd(serverDatas)
  helplog("HomeProxy:HandleOptUpdateHomeCmd:")
  local accid = serverDatas.accid
  local setsuc = false
  if self.myHouseData and accid == self.myHouseData.accid then
    self.myHouseData:UpdateHomeOptData(serverDatas)
    setsuc = true
  end
  if self.curHouseData and accid == self.curHouseData.accid then
    local dataType, value = self.curHouseData:UpdateHomeOptData(serverDatas)
    if self.houseOptDataUpdateHandler[dataType] then
      self.houseOptDataUpdateHandler[dataType](self, value)
    end
    setsuc = true
  end
  if not setsuc then
    LogUtility.Error(string.format("未找到accid: %s的房屋数据，更新失败！", accid))
  end
end

function HomeProxy:InitHouseOptDataUpdateHandler()
  self.houseOptDataUpdateHandler = {
    [HouseData.HouseOptType.GardenHouse] = self._HandleGardenHouseUpdate
  }
end

function HomeProxy:_HandleGardenHouseUpdate()
  HomeManager.Me():ReloadHouseModel()
end

function HomeProxy:HandleQueryFurnitureDatas(serverDatas)
  HomeManager.Me():ClearFurnitures()
  HomeManager.Me():ClearClientFurnitures()
  self:ClearFurnitureDatas()
  self.curHouseData = HouseData.new(serverDatas.house)
  self.isAtMyselfHome = self.curHouseData.accid == FunctionLogin.Me():getLoginData().accid
  self.isMyHouseScoreDirty = true
  local sFurnitureDatas = serverDatas.furniture
  local sFurniture, furnitureData
  for i = 1, #sFurnitureDatas do
    sFurniture = sFurnitureDatas[i]
    furnitureData = NFurnitureData.new(sFurniture.guid, sFurniture.id)
    furnitureData:ParseServerData(sFurniture)
    self.furnitureDatas[sFurniture.guid] = furnitureData
    HomeManager.Me():UpdateFurniture(furnitureData, function(self, nFurniture, nFurnitureData)
      self:_OnAddNewFurniture(nFurniture, nFurnitureData)
    end, self)
  end
  if HomeManager.Me():IsAtHome() then
    FloatingPanel.Instance:ShowMapName(self.curHouseData.name, self.curHouseData.sign)
  end
  for type, func in pairs(self.houseDataUpdateHandler) do
    func(self)
  end
  for type, func in pairs(self.houseOptDataUpdateHandler) do
    func(self)
  end
  if HomeManager.Me():IsAtHome() then
    self.giftRandomStamp = ServerTime.CurServerTime() / 1000 + 3
    TimeTickManager.Me():CreateTick(0, 200, self.handleReadyToRandomGift, self, 1)
  end
end

function HomeProxy:handleReadyToRandomGift()
  if not self.giftRandomStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
  local leftTime = self.giftRandomStamp - ServerTime.CurServerTime() / 1000
  if leftTime <= 0 then
    xdlog("家具全部加载完毕后随机礼物位置")
    HomeManager.Me():CreateRandomGiftCell()
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function HomeProxy:HandleFurnitureUpdate(serverDatas)
  local sFurniture, furnitureData, isNewFurniture
  for i = 1, #serverDatas.updates do
    sFurniture = serverDatas.updates[i]
    furnitureData = self.furnitureDatas[sFurniture.guid] or self.furnitureDatas[sFurniture.old_guid]
    self.furnitureDatas[sFurniture.old_guid] = nil
    furnitureData = furnitureData or NFurnitureData.new(sFurniture.guid, sFurniture.id)
    isNewFurniture = not furnitureData:IsServerInited()
    furnitureData:ParseServerData(sFurniture)
    self.furnitureDatas[sFurniture.guid] = furnitureData
    HomeManager.Me():UpdateFurniture(furnitureData, function(self, nFurniture, nFurnitureData)
      if isNewFurniture then
        self:_OnAddNewFurniture(nFurniture, nFurnitureData)
      end
    end, self)
  end
  for i = 1, #serverDatas.dels do
    self.furnitureDatas[serverDatas.dels[i]] = nil
    HomeManager.Me():RemoveFurnitureItem_Server(serverDatas.dels[i])
  end
  if not self:IsServerAtMyselfHome() then
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

function HomeProxy:_OnAddNewFurniture(nFurniture, orginData)
  if not nFurniture then
    return
  end
  for dataType, handler in pairs(self.dataUpdateHandler) do
    handler(self, orginData, nFurniture)
  end
  GameFacade.Instance:sendNotification(HomeEvent.AddFurniture, nFurniture)
  EventManager.Me():DispatchEvent(HomeEvent.AddFurniture, nFurniture)
  self.giftRandomStamp = ServerTime.CurServerTime() / 1000 + 1
end

function HomeProxy:RecvFurnitureDataUpdateHomeCmd(data)
  local furnitureData = self.furnitureDatas[data.guid]
  if furnitureData ~= nil then
    self:_FurnitureDataUpdate(furnitureData, data.updates)
  end
end

function HomeProxy:_FurnitureDataUpdate(orginData, datas)
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
    HomeManager.Me():UpdateFurniture(orginData, function(self, nFurniture, nFurnitureData)
      nFurniture = nFurniture or HomeManager.Me():FindFurniture(nFurnitureData.id)
      local handler
      for k, v in pairs(copy) do
        handler = self.dataUpdateHandler[k]
        if handler ~= nil then
          handler(self, nFurnitureData, nFurniture, v)
        end
      end
    end, self)
  else
    local nFurniture = HomeManager.Me():FindFurniture(orginData.id)
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

function HomeProxy:InitDataUpdateHandler()
  self.dataUpdateHandler = {
    [NFurnitureData.EnumDataType.State] = self._HandleStateDataUpdate,
    [NFurnitureData.EnumDataType.Seats] = self._HandleSeatsDataUpdate,
    [NFurnitureData.EnumDataType.Photo] = self._HandlePhotoDataUpdate,
    [NFurnitureData.EnumDataType.Skada] = self._HandleSkadaDataUpdate
  }
end

function HomeProxy:_HandleStateDataUpdate(data, nFurniture)
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

function HomeProxy:_HandleSeatsDataUpdate(data, nFurniture)
  if nFurniture ~= nil then
    nFurniture:UpdateSeats(data.seats)
  end
end

function HomeProxy:_HandlePhotoDataUpdate(data, nFurniture)
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

function HomeProxy:_HandleSkadaDataUpdate(data, nFurniture, serverSkadaData)
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

function HomeProxy:ParseServerDamageItem(singleTable, singleServerData)
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

function HomeProxy:GetSkadaHistoryMax()
  return self.skadaHistoryMax
end

function HomeProxy:GetSkadaTodayMax()
  return self.skadaTodayMax
end

function HomeProxy:ClearSkadaData()
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

function HomeProxy:HandlePrintUpdateHomeCmd(data)
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

function HomeProxy:ClearBPLikeInfo()
  if not self.bpLikeInfo then
    return
  end
  for id, bpLikeInfo in pairs(self.bpLikeInfo) do
    ReusableTable.DestroyAndClearTable(bpLikeInfo)
  end
  ReusableTable.DestroyAndClearTable(self.bpLikeInfo)
  self.bpLikeInfo = nil
end

function HomeProxy:RemoveOutOfDateSounds(nowTime)
  local isRemoved, soundData, staticData = false
  nowTime = nowTime or ServerTime.CurServerTime() / 1000
  for i = #self.curSoundList, 1, -1 do
    soundData = self.curSoundList[i]
    staticData = Table_MusicBox[soundData.musicid]
    if not staticData or nowTime > soundData.starttime + staticData.MusicTim then
      table.remove(self.curSoundList, i)
      isRemoved = true
    end
  end
  if isRemoved then
    self:PassSoundListUpdateEvent()
  end
end

function HomeProxy:PassSoundListUpdateEvent()
  self:sendNotification(HomeEvent.SoundListUpdate)
end

function HomeProxy:RecvFurnitureOperHomeCmd(data)
  local nfurniture = HomeManager.Me():FindFurniture(data.guid)
  if nfurniture == nil then
    return
  end
  if data.oper == self.Oper.Action then
    nfurniture:PlayActionByID(data.value, true)
  end
end
