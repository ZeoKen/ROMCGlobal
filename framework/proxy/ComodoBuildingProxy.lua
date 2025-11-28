ComodoBuildingProxy = class("ComodoBuildingProxy", pm.Proxy)
local tempTable, tableClear, arrayPushBack = {}, TableUtility.TableClear, TableUtility.ArrayPushBack
local nullBuildingData = {
  dispatch = {},
  lottery = {},
  resource = {},
  forges = {}
}
local maxInt = math.huge
local globalCfg = GameConfig.Manor

function ComodoBuildingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ComodoBuildingProxy"
  if ComodoBuildingProxy.Instance == nil then
    ComodoBuildingProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ComodoBuildingProxy:Init()
  self.buildingDataMap = {}
  self.unlockedPartnerIdMap = {}
  self.unlockedEquipIdMap = {}
  self.unlockedDispatchAreaIdMap = {}
  self.unlockedSmithingPartMap = {}
  self:InitStaticData()
end

function ComodoBuildingProxy:InitStaticData()
  if self.buildingSDataMap then
    return
  end
  self.buildingSDataMap = {}
  local element, funcTypeMap
  for _, d in pairs(Table_ManorBuild) do
    element = self.buildingSDataMap[d.BuildId] or {}
    element.buildingId = d.BuildId
    funcTypeMap = element[d.FuncType] or {}
    funcTypeMap.funcType = d.FuncType
    funcTypeMap[d.Level] = d
    element[d.FuncType] = funcTypeMap
    self.buildingSDataMap[d.BuildId] = element
  end
  self:InitMaxResProduceVelocity()
  self:InitPartnerFavoredMap()
  self:InitSmithingPartIdList()
end

function ComodoBuildingProxy:InitMaxResProduceVelocity()
  self.buildingMaxResProduceVelocityMap = {}
  local maxResProduce, minResInterval
  for buildingId, _ in pairs(globalCfg.ManorResource) do
    maxResProduce, minResInterval = self:GetAllResourceProduceInfo(buildingId)
    if maxResProduce then
      self.buildingMaxResProduceVelocityMap[buildingId] = ComodoBuildingProxy.GetResourceProduceVelocity(maxResProduce, minResInterval)
    end
  end
end

function ComodoBuildingProxy:InitPartnerFavoredMap()
  self.partnerFavoredAreasMap = {}
  self.partnerFavoredItemsMap = {}
  self.partnerFavoredEquipMap = {}
  self.partnerMaxFavorMap = {}
  self.favoredItemPartnersMap = {}
  local partnerId, itemId, partnerList, max
  for _, d in pairs(Table_ManorPartner) do
    partnerId = d.PartnerId
    if d.Area then
      self.partnerFavoredAreasMap[partnerId] = d.Area
    end
    if d.Favors then
      max = 0
      for _, favor in pairs(d.Favors) do
        if favor > max then
          max = favor
        end
      end
      self.partnerMaxFavorMap[partnerId] = 0 < max and max or nil
    end
    if d.ItemFavor then
      self.partnerFavoredItemsMap[partnerId] = d.ItemFavor
      for _, item in pairs(d.ItemFavor) do
        itemId = item[1]
        partnerList = self.favoredItemPartnersMap[itemId] or {}
        TableUtility.ArrayPushBack(partnerList, partnerId)
        self.favoredItemPartnersMap[itemId] = partnerList
      end
    end
  end
  for _, d in pairs(Table_ManorSpecialReward) do
    self.partnerFavoredEquipMap[d.PetId] = d.EquipId
  end
end

function ComodoBuildingProxy:InitSmithingPartIdList()
  self.smithingPartIdList = {}
  for partId, _ in pairs(globalCfg.ManorForgeDesc) do
    TableUtility.ArrayPushBack(self.smithingPartIdList, partId)
  end
  table.sort(self.smithingPartIdList)
end

function ComodoBuildingProxy:GetStaticData(buildingId, funcType, level)
  if not buildingId then
    return
  end
  self:InitStaticData()
  local element = self.buildingSDataMap[buildingId]
  if funcType then
    local funcTypeMap = element and element[funcType]
    if level then
      return funcTypeMap and funcTypeMap[level]
    else
      return funcTypeMap
    end
  else
    return element
  end
end

function ComodoBuildingProxy:GetNameOfFuncType(buildingId, funcType)
  return self:GetStaticValueByKey(buildingId, funcType, 1, "Desc", "")
end

local makeFuncTypeCandidates = function(candidateArr, funcTypeParam, sDataFuncTypeMap)
  if funcTypeParam then
    if sDataFuncTypeMap[funcTypeParam] then
      arrayPushBack(candidateArr, funcTypeParam)
    end
  else
    for ftKey, _ in pairs(sDataFuncTypeMap) do
      if type(ftKey) == "number" then
        arrayPushBack(candidateArr, ftKey)
      end
    end
  end
  table.sort(candidateArr)
end

function ComodoBuildingProxy:GetFuncEffectIds(buildingId, funcType, level)
  tableClear(tempTable)
  local fMap = buildingId and self.buildingSDataMap[buildingId]
  if fMap then
    local funcTypes = ReusableTable.CreateArray()
    makeFuncTypeCandidates(funcTypes, funcType, fMap)
    local addFuncEffectIds = function(bId, ft, lv)
      local ids = self:GetStaticValueByKey(bId, ft, lv, "EffectId", _EmptyTable)
      if ids then
        for i = 1, #ids do
          arrayPushBack(tempTable, ids[i])
        end
      end
    end
    local lMap
    for i = 1, #funcTypes do
      if level then
        addFuncEffectIds(buildingId, funcTypes[i], level)
      else
        lMap = self.buildingSDataMap[buildingId][funcTypes[i]]
        if lMap then
          for lv, _ in pairs(lMap) do
            addFuncEffectIds(buildingId, funcTypes[i], lv)
          end
        end
      end
    end
    ReusableTable.DestroyAndClearArray(funcTypes)
  end
  return tempTable
end

function ComodoBuildingProxy:GetAssetEffectDescs(buildingId, funcType, level, delimiter)
  local effectIds = self:GetFuncEffectIds(buildingId, funcType, level)
  local sb, effData = LuaStringBuilder.CreateAsTable()
  for i = 1, #effectIds do
    if sb:GetCount() > 0 then
      sb:Append(delimiter or "\n")
    end
    effData = Table_AssetEffect[effectIds[i]]
    if effData then
      sb:Append(effData.Desc)
    end
  end
  local s = sb:ToString()
  sb:Destroy()
  return s
end

function ComodoBuildingProxy:GetStaticValueByKey(buildingId, funcType, level, key, defaultValue)
  if type(buildingId) ~= "number" or type(funcType) ~= "number" or type(level) ~= "number" then
    return
  end
  local data = self:GetStaticData(buildingId, funcType, level)
  return data and key and data[key] or defaultValue
end

local getResourceProduceInfo = function(buildingId, produceParamArr)
  local basicCfg = globalCfg.ManorResource[buildingId]
  if not basicCfg then
    return
  end
  local produce, interval, capacity, param = basicCfg.produce, basicCfg.interval, basicCfg.capacity
  for i = 1, #produceParamArr do
    param = produceParamArr[i]
    if param.npcid == buildingId then
      produce = produce + (param.produce or 0)
      interval = interval - (param.interval or 0)
      capacity = capacity + (param.capacity or 0)
    end
  end
  return produce, interval, capacity
end

function ComodoBuildingProxy:GetAllResourceProduceInfo(buildingId)
  return getResourceProduceInfo(buildingId, ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByType(self:GetFuncEffectIds(buildingId), "ManorResourceProduce"))
end

local updateBuildingFuncData = function(localData, serverDatas)
  local funcDataMap, t = localData.funcDataMap or {}
  tableClear(funcDataMap)
  for i = 1, #serverDatas do
    t = serverDatas[i].func_type
    if t then
      funcDataMap[t] = serverDatas[i].func_level
    end
  end
  localData.funcDataMap = funcDataMap
end
local updateDispatchData = function(localData, serverDatas)
  local dispatch, data, element, areaId = localData.dispatch or {}
  if serverDatas then
    local serverAreaIdMap = ReusableTable.CreateTable()
    for i = 1, #serverDatas do
      element = serverDatas[i]
      areaId = element.area_id
      data = dispatch[areaId] or {}
      data.areaId = areaId
      data.petId = element.pet_id
      data.equipId = element.equip_id
      data.beginTime = element.begin_time
      dispatch[areaId] = data
      serverAreaIdMap[areaId] = true
    end
    for area, _ in pairs(dispatch) do
      if not serverAreaIdMap[area] then
        dispatch[area] = nil
      end
    end
    ReusableTable.DestroyAndClearTable(serverAreaIdMap)
  else
    tableClear(dispatch)
  end
  localData.dispatch = dispatch
end
local updateDispatchRewardsData = function(localData, serverDatas)
  local rewardMap = localData.dispatchRewardCountMap or {}
  tableClear(rewardMap)
  if serverDatas then
    for i = 1, #serverDatas do
      rewardMap[serverDatas[i].reward_id] = serverDatas[i].reward_count
    end
  end
  localData.dispatchRewardCountMap = rewardMap
end
local updateLotteryData = function(localData, serverDatas)
  local lottery = localData.lottery or {}
  tableClear(lottery)
  if serverDatas then
    for i = 1, #serverDatas do
      lottery[serverDatas[i]] = true
    end
  end
  localData.lottery = lottery
end
local updateResourceData = function(localData, serverData)
  localData.resReserve = serverData and serverData.reserve
  localData.resRefreshTime = serverData and serverData.begin_time
end
local updateSmithingData = function(localData, serverDatas)
  local smithing = localData.smithingPartBeginTimeMap or {}
  tableClear(smithing)
  if serverDatas then
    for i = 1, #serverDatas do
      smithing[serverDatas[i].part] = serverDatas[i].begin_time
    end
  end
  localData.smithingPartBeginTimeMap = smithing
end
local updateBuildingData = function(localMap, serverData)
  local id = serverData.build_id
  local localData = localMap[id] or {}
  localData.id = id
  localData.openTime = serverData.open_time
  localData.isForbid = serverData.isforbid
  updateBuildingFuncData(localData, serverData.funcs)
  updateDispatchData(localData, serverData.dispatch and serverData.dispatch.groups)
  updateDispatchRewardsData(localData, serverData.dispatch and serverData.dispatch.rewards)
  updateLotteryData(localData, serverData.lottery and serverData.lottery.ids)
  updateResourceData(localData, serverData.resource)
  updateSmithingData(localData, serverData.forges)
  localMap[id] = localData
end

function ComodoBuildingProxy:RecvBuildingDatas(datas)
  if not datas then
    return
  end
  for i = 1, #datas do
    self:RecvBuildingData(datas[i])
  end
end

function ComodoBuildingProxy:RecvBuildingData(data)
  if not data then
    return
  end
  self:InitStaticData()
  updateBuildingData(self.buildingDataMap, data)
  self:TryUpdateUnlocked(data.build_id)
end

function ComodoBuildingProxy:RecvPartnerInfos(datas)
  if not datas then
    return
  end
  for i = 1, #datas do
    self.unlockedPartnerIdMap[datas[i].id] = true
  end
  local partnerUnlockedEffectIds, ids = ManorPartnerProxy.Instance:GetAllUnlockedEffectIdsOfComposes(), ReusableTable.CreateArray()
  for i = 1, #partnerUnlockedEffectIds do
    arrayPushBack(ids, partnerUnlockedEffectIds[i])
  end
  local arr, areaIds = ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByType(ids, "ManorAreaOpen")
  for i = 1, #arr do
    areaIds = arr[i].areaid
    for j = 1, #areaIds do
      self.unlockedDispatchAreaIdMap[areaIds[j]] = true
    end
  end
  ReusableTable.DestroyAndClearArray(ids)
end

local tryUpdateUnlockedIdMap = function(ids, map)
  for i = 1, #ids do
    map[ids[i]] = true
  end
end

function ComodoBuildingProxy:TryUpdateUnlocked(buildingId)
  self:_ForEachParamValueFromUnlockedFuncEffect(buildingId, "ManorEquipOpen", "equipid", tryUpdateUnlockedIdMap, self.unlockedEquipIdMap)
  self:_ForEachParamValueFromUnlockedFuncEffect(buildingId, "ManorAreaOpen", "areaid", tryUpdateUnlockedIdMap, self.unlockedDispatchAreaIdMap)
  self:_ForEachParamValueFromUnlockedFuncEffect(buildingId, "ManorEquipForge", "part", tryUpdateUnlockedIdMap, self.unlockedSmithingPartMap)
end

function ComodoBuildingProxy:_ForEachParamValueFromUnlockedFuncEffect(buildingId, effectTypeStr, paramKey, action, ...)
  local paramArr, v = self:SelectParamsFromUnlockedEffectByType(buildingId, nil, effectTypeStr)
  for i = 1, #paramArr do
    v = paramArr[i][paramKey]
    if v then
      action(v, ...)
    end
  end
end

function ComodoBuildingProxy:CheckLotteryGot(id)
  local lottery
  for _, data in pairs(self.buildingDataMap) do
    lottery = data.lottery
    if lottery and lottery[id] then
      return true
    end
  end
  return false
end

function ComodoBuildingProxy:CheckBuildingForbid(buildingId)
  local data = self:GetBuildingData(buildingId)
  if data then
    return data.isForbid
  end
end

function ComodoBuildingProxy:CheckFavoredItemCanBuy(itemId)
  if not itemId then
    return false
  end
  local partners = self.favoredItemPartnersMap[itemId]
  if partners then
    local manorIns, isAllFullFavorability, info = ManorPartnerProxy.Instance, true
    for _, partner in pairs(partners) do
      info = manorIns:GetPartnerInfo(partner)
      if not info or info.favor < (self.partnerMaxFavorMap[info.id] or math.huge) then
        isAllFullFavorability = false
        break
      end
    end
    if isAllFullFavorability then
      local cfg, isQuestAllComplete = globalCfg.ShopAddSoldOut, true
      if cfg and cfg[itemId] then
        local questList = QuestProxy.Instance.questList[SceneQuest_pb.EQUESTLIST_SUBMIT]
        if questList then
          local questIdMap = ReusableTable.CreateTable()
          for i = 1, #questList do
            questIdMap[questList[i].id] = true
          end
          for _, questId in pairs(cfg[itemId]) do
            if not questIdMap[questId] then
              isQuestAllComplete = false
              break
            end
          end
          ReusableTable.DestroyAndClearTable(questIdMap)
          if isQuestAllComplete then
            return false
          end
        end
      else
        return false
      end
    end
  end
  return true
end

function ComodoBuildingProxy:GetDisplayIconNameOfReservedProduce(buildingId)
  if not buildingId then
    return
  end
  local displayIconCfg = globalCfg.BuildOutputRate[buildingId]
  local curProduce, capacity = self:GetCurrentProduce(buildingId)
  local flag = displayIconCfg and 0 < curProduce
  if flag then
    local ratio = capacity and 0 < capacity and curProduce / capacity or 0
    local displayPercent = 1000
    for percent, _ in pairs(displayIconCfg) do
      if percent < displayPercent and ratio < percent / 100 + math.Epsilon then
        displayPercent = percent
      end
    end
    return displayIconCfg[displayPercent]
  end
end

function ComodoBuildingProxy:GetDisplayIconNameOfSmithing(npcId)
  if not npcId then
    return
  end
  local displayIcon, countdown = globalCfg.ManorForgeComplete[npcId]
  for _, partId in pairs(self.smithingPartIdList) do
    countdown = self:GetSmithingCountdownByPartId(partId)
    if countdown == 0 then
      return displayIcon
    end
  end
end

function ComodoBuildingProxy:GetBuildingData(buildingId)
  return self.buildingDataMap and buildingId and self.buildingDataMap[buildingId]
end

function ComodoBuildingProxy:GetBuildingFuncLevelByType(buildingId, funcType)
  local data = self:GetBuildingData(buildingId)
  local map = data and data.funcDataMap
  return map and map[funcType] or 0
end

function ComodoBuildingProxy:GetReservedProduce(buildingId)
  local data = self:GetBuildingData(buildingId)
  if data then
    return data.resReserve, data.resRefreshTime
  end
end

function ComodoBuildingProxy:GetCurrentProduce(buildingId)
  local produce, produceInterval, produceCapacity = self:GetUnlockedResourceProduceInfo(buildingId)
  if not produce then
    return 0
  end
  local reserve, refreshTime = self:GetReservedProduce(buildingId)
  local totalInterval = refreshTime and math.clamp(ServerTime.CurServerTime() / 1000 - refreshTime, 0, maxInt) or 0
  local velocity = ComodoBuildingProxy.GetResourceProduceVelocity(produce, produceInterval)
  local curProduce = math.clamp((reserve or 0) + totalInterval * velocity / 60, 0, produceCapacity)
  return math.floor(curProduce), produceCapacity
end

function ComodoBuildingProxy:GetCurrentProduceVelocity(buildingId)
  local produce, produceInterval = self:GetUnlockedResourceProduceInfo(buildingId)
  if not produce then
    return 0
  end
  return ComodoBuildingProxy.GetResourceProduceVelocity(produce, produceInterval)
end

function ComodoBuildingProxy:GetDispatchDataByAreaId(areaId)
  local dispatch
  for _, data in pairs(self.buildingDataMap) do
    dispatch = data.dispatch
    if dispatch and dispatch[areaId] then
      return dispatch[areaId]
    end
  end
  return
end

function ComodoBuildingProxy:GetDispatchCountdownByAreaId(areaId)
  local d, totalTime = self:GetDispatchDataByAreaId(areaId), globalCfg.ManorDispatchInterval
  if not d then
    return -1
  end
  local interval = ServerTime.CurServerTime() / 1000 - d.beginTime
  return math.clamp(math.ceil(totalTime - interval), 0, totalTime)
end

function ComodoBuildingProxy:GetFinishedDispatchTimesOfToday()
  return MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MANOR_DISPATCH_TIMES) or 0
end

function ComodoBuildingProxy:GetAvailableDispatchPartnerIdMap()
  tableClear(tempTable)
  TableUtility.TableShallowCopy(tempTable, self.unlockedPartnerIdMap)
  local dispatch
  for _, data in pairs(self.buildingDataMap) do
    dispatch = data.dispatch
    if dispatch then
      for _, d in pairs(dispatch) do
        if d.petId then
          tempTable[d.petId] = nil
        end
      end
    end
  end
  return tempTable
end

function ComodoBuildingProxy:GetAvailableDispatchEquipIdMap()
  tableClear(tempTable)
  TableUtility.TableShallowCopy(tempTable, self.unlockedEquipIdMap)
  local dispatch
  for _, data in pairs(self.buildingDataMap) do
    dispatch = data.dispatch
    if dispatch then
      for _, d in pairs(dispatch) do
        if d.equipId then
          tempTable[d.equipId] = nil
        end
      end
    end
  end
  return tempTable
end

function ComodoBuildingProxy:GetAreaSpecialRewardReceiveCount(specialRewardId)
  local sum, countMap = 0
  for _, data in pairs(self.buildingDataMap) do
    countMap = data.dispatchRewardCountMap
    if countMap then
      sum = sum + (countMap[specialRewardId] or 0)
    end
  end
  return sum
end

function ComodoBuildingProxy:GetSmithingCountdownByPartId(partId)
  local map, beginTime, buildingId
  if partId then
    for _, data in pairs(self.buildingDataMap) do
      map = data.smithingPartBeginTimeMap
      if map and map[partId] then
        beginTime = map[partId]
        buildingId = data.id
        break
      end
    end
  end
  if beginTime then
    local totalTime = self:GetSmithingTotalTime(buildingId)
    local interval = ServerTime.CurServerTime() / 1000 - beginTime
    return math.clamp(math.ceil(totalTime - interval), 0, totalTime)
  end
  return -1
end

function ComodoBuildingProxy:GetSmithingTotalTime(buildingId)
  local time = globalCfg.ManorForgeIntervalInit
  local arr = self:SelectParamsFromUnlockedEffectByType(buildingId, nil, "ManorEquipForge")
  for i = 1, #arr do
    time = time - (arr[i].interval or 0)
  end
  return time
end

function ComodoBuildingProxy:GetUnlockedEffectIds(buildingId, funcType, ignoreCompose)
  tableClear(tempTable)
  local data = self:GetBuildingData(buildingId)
  local map = data and data.funcDataMap
  if map then
    local funcTypes = ReusableTable.CreateArray()
    makeFuncTypeCandidates(funcTypes, funcType, map)
    local curLv, effectIds
    for i = 1, #funcTypes do
      curLv = map[funcTypes[i]]
      if curLv then
        for j = 1, curLv do
          effectIds = self:GetStaticValueByKey(buildingId, funcTypes[i], j, "EffectId", _EmptyTable)
          for k = 1, #effectIds do
            arrayPushBack(tempTable, effectIds[k])
          end
        end
      end
    end
    ReusableTable.DestroyAndClearArray(funcTypes)
  end
  if not ignoreCompose then
    local partnerUnlockedEffectIds = ManorPartnerProxy.Instance:GetAllUnlockedEffectIdsOfComposes()
    for i = 1, #partnerUnlockedEffectIds do
      arrayPushBack(tempTable, partnerUnlockedEffectIds[i])
    end
  end
  return tempTable
end

function ComodoBuildingProxy:GetUnlockedResourceProduceInfo(buildingId)
  return getResourceProduceInfo(buildingId, self:SelectParamsFromUnlockedEffectByType(buildingId, nil, "ManorResourceProduce"))
end

function ComodoBuildingProxy:GetUnlockedMaxDispatchTimes(buildingId)
  local times = globalCfg.ManorDispatchTimes
  local arr = self:SelectParamsFromUnlockedEffectByType(buildingId, nil, "ManorDispatchTimesAdd")
  for i = 1, #arr do
    times = times + (arr[i].count or 0)
  end
  return times
end

function ComodoBuildingProxy:SelectParamsFromUnlockedEffectByType(buildingId, funcType, effectTypeStr)
  return ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByType(self:GetUnlockedEffectIds(buildingId, funcType), effectTypeStr)
end

local paramArr = {}

function ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByPredicate(effectIds, predicate, args)
  if not effectIds then
    return _EmptyTable
  end
  tableClear(paramArr)
  local data
  for i = 1, #effectIds do
    data = Table_AssetEffect[effectIds[i]]
    if data and (not predicate or predicate(data, args)) then
      arrayPushBack(paramArr, data.Params)
    end
  end
  return paramArr
end

local typePredicate = function(data, typeStr)
  return StringUtil.IsEmpty(typeStr) or typeStr == data.Type
end

function ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByType(effectIds, typeStr)
  return ComodoBuildingProxy.SelectParamsFromAssetEffectIdsByPredicate(effectIds, typePredicate, typeStr)
end

function ComodoBuildingProxy.GetBuildingName(buildingId)
  return Table_Npc[buildingId] and Table_Npc[buildingId].NameZh
end

function ComodoBuildingProxy.GetResourceProduceVelocity(produce, interval)
  if not produce or not interval then
    return 0
  end
  return produce / interval * 60
end

function ComodoBuildingProxy.CheckHasProduceTopUi(buildingId)
  return globalCfg.BuildBodyShowRate[buildingId] ~= nil or globalCfg.ManorForgeComplete[buildingId] ~= nil
end

function ComodoBuildingProxy.RefreshFurniture()
  local shopDatas = ShopProxy.Instance:GetConfigByType(globalCfg.BuildingFurnitureShopType)
  for _, shop in pairs(shopDatas) do
    shop:SetNextValidTime(0)
  end
end

function ComodoBuildingProxy.Query()
  ServiceSceneManorProxy.Instance:CallBuildQueryManorCmd(nullBuildingData)
end

function ComodoBuildingProxy.Upgrade(funcType)
  ServiceSceneManorProxy.Instance:CallBuildLevelUpManorCmd(funcType or 1, nullBuildingData)
end

function ComodoBuildingProxy.Dispatch(petId, areaId, equipId, isRecvReward)
  ServiceSceneManorProxy.Instance:CallBuildDispatchManorCmd(petId, areaId, equipId, isRecvReward and true or false, nullBuildingData)
end

function ComodoBuildingProxy.Lottery()
  ServiceSceneManorProxy.Instance:CallBuildLotteryManorCmd(nullBuildingData)
end

function ComodoBuildingProxy.Collect()
  ServiceSceneManorProxy.Instance:CallBuildCollectManorCmd(nullBuildingData)
end

function ComodoBuildingProxy.Smithing(partId, isRecvReward)
  ServiceSceneManorProxy.Instance:CallBuildForgeManorCmd(partId, isRecvReward and true or false, nullBuildingData)
end

function ComodoBuildingProxy:GetUnlockedBuildingEffectByTypes(effectType)
  if self.buildingDataMap then
    local result = {}
    for k, v in pairs(self.buildingDataMap) do
      local attrData = ReusableTable.CreateTable()
      local buildingId = k
      local effectIds = self:GetUnlockedEffectIds(buildingId)
      for j = 1, #effectIds do
        local config = Table_AssetEffect[effectIds[j]]
        if TableUtility.ArrayFindIndex(effectType, config.Type) > 0 then
          arrayPushBack(array, effectIds[j])
          if config.Type == "Attr" then
            local params = config.Params
            for m, n in pairs(params) do
              if not attrData[m] then
                attrData[m] = 0
              end
              attrData[m] = attrData[m] + n
            end
          end
        end
      end
      for m, n in pairs(attrData) do
        local unit = ""
        local attrNum = 0
        if CommonFun.checkIsNoNeedPercent(m) then
          attrNum = n
        else
          attrNum = n * 100
          unit = "%"
        end
        local attrNameEn = Game.Config_PropName[k].PropName
        local data = {
          buildingId = buildingId,
          attrNameEn = attrNameEn,
          attrNum = attrNum,
          unit = unit
        }
        table.insert(result, data)
      end
      ReusableTable.DestroyAndClearTable(attrData)
    end
    return result
  end
end

function ComodoBuildingProxy:GetAllBuildingEffect()
  local result = {}
  if self.buildingDataMap then
    for k, v in pairs(self.buildingDataMap) do
      local buildingId = v.id
      local effectIds = self:GetUnlockedEffectIds(buildingId, nil, true)
      local effectList = ReusableTable.CreateTable()
      for i = 1, #effectIds do
        local effectConfig = Table_AssetEffect[effectIds[i]]
        local group = effectConfig and effectConfig.Group
        if group and not effectList[group] then
          local groupConfig = globalCfg.BuildingEffectGroup
          local attrName = groupConfig and groupConfig[group] or "group" .. group .. "没有配置Attr"
          effectList[group] = {count = 0, attrName = attrName}
        end
        local params = effectConfig.Params
        local diff = 0
        local unit = ""
        if effectConfig.Type == "ManorResourceProduce" then
          if params and params.capacity then
            diff = params.capacity
          elseif params and params.rate then
            diff = params.rate
            unit = "%"
          elseif params and params.interval then
            diff = params.interval * -1 / 60
            unit = ZhString.MainViewInfoPage_Min
          end
        elseif effectConfig.Type == "ManorPetMaxAdd" or effectConfig.Type == "ManorDispatchTimesAdd" then
          diff = params and params.count
        elseif effectConfig.Type == "ManorAreaOpen" or effectConfig.Type == "ManorEquipOpen" then
          diff = 1
        elseif effectConfig.Type == "MapDeadReward" then
          diff = params and params.ratio and params.ratio * 100
          unit = "%"
        elseif effectConfig.Type == "MapItemRatio" then
          diff = params and params.items and params.items[1].ratio * 100
          unit = "%"
        else
          diff = 0
        end
        if effectList[group] then
          effectList[group].count = effectList[group].count + diff
          effectList[group].unit = unit
        end
      end
      local buildingInfo = Table_Npc[buildingId]
      if buildingInfo then
        local buildingName = buildingInfo.NameZh or "?????"
        for k, v in pairs(effectList) do
          xdlog("加入列表", buildingId, v.attrName, v.count)
          local data = {
            Name = buildingName,
            attrNameEn = v.attrName,
            attrNum = v.count,
            unit = v.unit
          }
          table.insert(result, data)
        end
      end
      ReusableTable.DestroyAndClearTable(effectList)
    end
  end
  return result
end

function ComodoBuildingProxy:GetAllBuildingMapEffect()
  local result = {}
  for k, v in pairs(self.buildingDataMap) do
    local buildingId = k
    local buildingInfo = Table_Npc[buildingId]
    if buildingInfo then
      local buildingName = buildingInfo.NameZh or "?????"
      local effectIds = self:GetUnlockedEffectIds(buildingId, nil, true)
      local effectList = ReusableTable.CreateTable()
      for i = 1, #effectIds do
        local effectConfig = Table_AssetEffect[effectIds[i]]
        if effectConfig and effectConfig.Type == "MapBuff" then
          local params = effectConfig.Params
          local buffid = params.buffid and params.buffid[1]
          local buffData = Table_Buffer[buffid]
          if buffData and buffData.BuffEffect.type == "AttrChange" then
            for m, n in pairs(buffData.BuffEffect) do
              local prop = Game.Config_PropName[m]
              if prop then
                if not effectList[m] then
                  effectList[m] = 0
                end
                effectList[m] = effectList[m] + n
              end
            end
          end
        end
      end
      for m, n in pairs(effectList) do
        local unit = ""
        local attrNum = 0
        local prop = Game.Config_PropName[m]
        if prop and prop.IsPercent == 1 then
          attrNum = n * 100
          unit = "%"
        else
          attrNum = n
        end
        local attrNameEn = Game.Config_PropName[m].PropName
        local data = {
          Name = buildingName,
          attrNameEn = attrNameEn,
          attrNum = attrNum,
          unit = unit
        }
        table.insert(result, data)
      end
      ReusableTable.DestroyAndClearTable(effectList)
    end
  end
  return result
end
