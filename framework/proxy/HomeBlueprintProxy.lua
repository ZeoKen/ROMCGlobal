autoImport("BlueprintRecommendItemData")
autoImport("HomeBluePrintData")
HomeBlueprintProxy = class("HomeBlueprintProxy", pm.Proxy)
HomeBlueprintProxy.Instance = nil
HomeBlueprintProxy.NAME = "HomeBlueprintProxy"

function HomeBlueprintProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HomeBlueprintProxy.NAME
  if HomeBlueprintProxy.Instance == nil then
    HomeBlueprintProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function HomeBlueprintProxy:Init()
  self.recommendListByType = {}
  self.collectionList = {}
  self.myList = {}
  self.officialServerDataMap = {}
  self.queryPrintItemDataMap = {}
  self.queryPrintItemPendingMap = {}
  self._curDisplayAccId = nil
  self._curDisplayCharId = nil
  self._curDisplayPhotoId = nil
end

function HomeBlueprintProxy:SetCurDisplayingItem(itemData)
  self._curDisplayAccId = itemData and itemData.accId
  self._curDisplayCharId = itemData and itemData.charId
  self._curDisplayPhotoId = itemData and itemData.photoId
end

function HomeBlueprintProxy:IsCurrentDisplayingItem(itemData)
  if not self._curDisplayAccId then
    return false
  end
  return self._curDisplayAccId == itemData.accId and self._curDisplayCharId == itemData.charId and self._curDisplayPhotoId == itemData.photoId
end

function HomeBlueprintProxy:IsValidPrintItem(printItem)
  if not printItem then
    return false
  end
  return printItem.id ~= nil and printItem.id ~= 0
end

function HomeBlueprintProxy:GetPrintItemKey(printItem)
  if not self:IsValidPrintItem(printItem) then
    return nil
  end
  local id = printItem.id
  local accid = printItem.accid
  local etype = printItem.etype
  return string.format("%s_%s_%s", tostring(id), tostring(accid), tostring(etype))
end

function HomeBlueprintProxy:GetQueryPrintItemData(printItem)
  local key = self:GetPrintItemKey(printItem)
  return key and self.queryPrintItemDataMap[key] or nil
end

function HomeBlueprintProxy:QueryPrintItem(printItem, forceQuery)
  local key = self:GetPrintItemKey(printItem)
  if not key then
    return nil
  end
  local itemData = self.queryPrintItemDataMap[key]
  if itemData and not forceQuery then
    return itemData
  end
  if self.queryPrintItemPendingMap[key] and not forceQuery then
    return nil
  end
  if forceQuery then
    self.queryPrintItemDataMap[key] = nil
  end
  ServiceChatCmdProxy.Instance:CallQueryPrintItem(printItem)
  self.queryPrintItemPendingMap[key] = true
  return nil
end

function HomeBlueprintProxy:CreateRecommendItemDataFromPrintItem(item, serverPath)
  if not item then
    return nil
  end
  local homeType = item.etype or HomeCmd_pb.EHOUSETYPE_PRIVATE
  local itemData = self:_CreateFlatListItemData(item, homeType, 0, serverPath, false)
  if itemData then
    itemData.timeStamp = item.timestamp or itemData.timeStamp
  end
  return itemData
end

function HomeBlueprintProxy:UpdateQueryPrintItem(data)
  local item = data and data.item
  if not item then
    return nil
  end
  local key = self:GetPrintItemKey(item)
  local itemData = self:CreateRecommendItemDataFromPrintItem(item, data.cdn_path)
  if key then
    self.queryPrintItemPendingMap[key] = nil
    if itemData then
      self.queryPrintItemDataMap[key] = itemData
    end
  end
  return itemData
end

function HomeBlueprintProxy:UpdateRecommendList(data)
  if not data then
    return
  end
  local items = data.items
  if not items or #items == 0 then
    self:_ClearRecommendList(data)
    return
  end
  redlog("UpdateBlueprintRecommendList action = " .. tostring(data.action), " count = " .. tostring(#items))
  local serverPath = data.cdn_path
  local seenTypes = {}
  local typeIndex = {}
  for i = 1, #items do
    local item = items[i]
    local homeType = item.etype or HomeCmd_pb.EHOUSETYPE_PRIVATE
    if not seenTypes[homeType] then
      seenTypes[homeType] = true
      typeIndex[homeType] = 0
      if not self.recommendListByType[homeType] then
        self.recommendListByType[homeType] = {}
      else
        TableUtility.ArrayClear(self.recommendListByType[homeType])
      end
    end
    typeIndex[homeType] = typeIndex[homeType] + 1
    local serverData = self:_ParsePrintItemServerData(item)
    local list = self.recommendListByType[homeType]
    local itemData = BlueprintRecommendItemData.new(serverData, homeType, typeIndex[homeType], serverPath)
    if item.furns and 0 < #item.furns then
      itemData:SetFurnitureProgress(HomeBluePrintData.CreateFromServerData(item, serverData.mapID))
    end
    list[#list + 1] = itemData
  end
end

function HomeBlueprintProxy:_ClearRecommendList(data)
  local homeType = data.etype
  if homeType then
    if self.recommendListByType[homeType] then
      TableUtility.ArrayClear(self.recommendListByType[homeType])
    end
    return
  end
  for _, list in pairs(self.recommendListByType) do
    TableUtility.ArrayClear(list)
  end
end

function HomeBlueprintProxy:_ParsePrintItemServerData(item)
  local serverData = {
    id = item.id,
    accid = item.accid,
    charid = item.charid
  }
  if item.is_offical ~= nil then
    serverData.is_official = item.is_offical == true
  end
  local datas = item.datas or {}
  for i = 1, #datas do
    local d = datas[i]
    if d.data == HomeCmd_pb.EPRINTDATA_PRAISECOUNT then
      serverData.like_num = d.value
    elseif d.data == HomeCmd_pb.EPRINTDATA_ISPRAISE then
      serverData.is_like = d.value ~= 0
    elseif d.data == HomeCmd_pb.EPRINTDATA_USERNAME then
      serverData.user_name = d.sdata
    elseif d.data == HomeCmd_pb.EPRINTDATA_HOT then
      serverData.visit_count = d.value
    elseif d.data == HomeCmd_pb.EPRINTDATA_NAME then
      serverData.home_name = d.sdata
    elseif d.data == HomeCmd_pb.EPRINTDATA_ILLEGAL then
      serverData.is_violation = d.value ~= 0
    elseif d.data == HomeCmd_pb.EPRINTDATA_ISCOLLECT then
      serverData.is_collection = d.value ~= 0
    elseif d.data == HomeCmd_pb.EPRINTDATA_MAPID then
      serverData.mapID = d.value
    end
  end
  return serverData
end

function HomeBlueprintProxy:_UpdateOfficialServerData(serverData)
  if not serverData or not serverData.id then
    return nil
  end
  local cacheData = self.officialServerDataMap[serverData.id]
  if not cacheData then
    self.officialServerDataMap[serverData.id] = serverData
    return serverData
  end
  if serverData.like_num ~= nil then
    cacheData.like_num = serverData.like_num
  end
  if serverData.is_like ~= nil then
    cacheData.is_like = serverData.is_like
  end
  if serverData.is_collection ~= nil then
    cacheData.is_collection = serverData.is_collection
  end
  if serverData.is_official ~= nil then
    cacheData.is_official = serverData.is_official
  end
  return cacheData
end

function HomeBlueprintProxy:_ApplyServerStateToItemData(itemData, serverData)
  if not itemData or not serverData then
    return
  end
  if serverData.like_num ~= nil then
    itemData.likeNum = serverData.like_num
  end
  if serverData.is_like ~= nil then
    itemData.isLike = serverData.is_like
  end
  if serverData.is_collection ~= nil then
    itemData.isCollection = serverData.is_collection
  end
end

function HomeBlueprintProxy:_CreateFlatListItemData(item, homeType, index, serverPath, forceCollection)
  local serverData = self:_ParsePrintItemServerData(item)
  if forceCollection and serverData.is_collection == nil then
    serverData.is_collection = true
  end
  if serverData.is_official == true then
    local staticData = Table_HomeOfficialBluePrint and Table_HomeOfficialBluePrint[serverData.id]
    if not staticData then
      redlog("[HomeBlueprintProxy] missing official blueprint config, id=", tostring(serverData.id))
      return nil
    end
    local itemData = BlueprintRecommendItemData.CreateFromOfficial(staticData, homeType, index)
    local officialServerData = self:_UpdateOfficialServerData(serverData)
    self:_ApplyServerStateToItemData(itemData, officialServerData)
    return itemData
  end
  local itemData = BlueprintRecommendItemData.new(serverData, homeType, index, serverPath)
  if item.furns and #item.furns > 0 then
    itemData:SetFurnitureProgress(HomeBluePrintData.CreateFromServerData(item, serverData.mapID))
  end
  return itemData
end

function HomeBlueprintProxy:GetRecommendList(homeType)
  if not homeType then
    return {}
  end
  return self.recommendListByType[homeType] or {}
end

function HomeBlueprintProxy:UpdateCollectionList(data)
  if not data then
    return
  end
  if not data.items or #data.items == 0 then
    TableUtility.ArrayClear(self.collectionList)
    return
  end
  self:_RebuildFlatList(self.collectionList, data.items, data.cdn_path, true)
end

function HomeBlueprintProxy:UpdateMyList(data)
  if not data then
    return
  end
  if not data.items or #data.items == 0 then
    TableUtility.ArrayClear(self.myList)
    return
  end
  self:_RebuildFlatList(self.myList, data.items, data.cdn_path, false)
end

function HomeBlueprintProxy:_RebuildFlatList(targetList, items, serverPath, forceCollection)
  TableUtility.ArrayClear(targetList)
  for i = 1, #items do
    local item = items[i]
    local homeType = item.etype or HomeCmd_pb.EHOUSETYPE_PRIVATE
    local itemData = self:_CreateFlatListItemData(item, homeType, #targetList + 1, serverPath, forceCollection)
    if itemData then
      itemData.collectedAt = item.timestamp or 0
      targetList[#targetList + 1] = itemData
      redlog("[_RebuildFlatList] photoId = ", itemData.photoId)
    end
  end
end

function HomeBlueprintProxy:_InsertOrReplaceFlatListItem(targetList, item, serverPath, forceCollection)
  if not targetList or not item then
    return
  end
  local serverData = self:_ParsePrintItemServerData(item)
  if not serverData.id then
    return
  end
  local homeType = item.etype or HomeCmd_pb.EHOUSETYPE_PRIVATE
  local index = #targetList + 1
  for i = 1, #targetList do
    if self:_IsSamePrintItem(targetList[i], serverData.id, serverData) then
      index = i
      break
    end
  end
  local itemData = self:_CreateFlatListItemData(item, homeType, index, serverPath, forceCollection)
  if not itemData then
    return
  end
  itemData.collectedAt = item.timestamp or 0
  targetList[index] = itemData
end

function HomeBlueprintProxy:GetCollectionList(curHouseType)
  local list = self.collectionList or {}
  if curHouseType then
    table.sort(list, function(a, b)
      local aMatch = a.houseType == curHouseType and 1 or 0
      local bMatch = b.houseType == curHouseType and 1 or 0
      if aMatch ~= bMatch then
        return aMatch > bMatch
      end
      return (a.collectedAt or 0) > (b.collectedAt or 0)
    end)
  end
  return list
end

function HomeBlueprintProxy:GetCollectionNum()
  return #self.collectionList
end

function HomeBlueprintProxy:GetMyList()
  return self.myList or {}
end

function HomeBlueprintProxy:GetMyBlueprintNum()
  return #self.myList
end

function HomeBlueprintProxy:UpdateItemDelete(data)
  if not data or not data.items then
    return
  end
  for _, item in ipairs(data.items) do
    local serverData = self:_ParsePrintItemServerData(item)
    local id = serverData.id
    if id then
      for i = #self.myList, 1, -1 do
        if self:_IsSamePrintItem(self.myList[i], id, serverData) then
          table.remove(self.myList, i)
        end
      end
    end
  end
end

function HomeBlueprintProxy:UpdateItemAction(data)
  if not data or not data.items then
    return
  end
  for _, item in ipairs(data.items) do
    local serverData = self:_ParsePrintItemServerData(item)
    local id = serverData.id
    redlog("UpdateItemAction", data.action, id, tostring(serverData.is_official))
    if id then
      self:_ApplyActionToList(self.recommendListByType, id, serverData, true)
      if data.action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
        self:_RemoveItemFromFlatList(self.collectionList, id, serverData)
      elseif data.action == HomeCmd_pb.EPRINTACTION_COLLECT_IN then
        self:_InsertOrReplaceFlatListItem(self.collectionList, item, data.cdn_path, true)
      elseif data.action == HomeCmd_pb.EPRINTACTION_SAVE then
        self:_InsertOrReplaceFlatListItem(self.myList, item, data.cdn_path, false)
      else
        self:_ApplyActionToList(self.collectionList, id, serverData, false)
      end
      self:_ApplyActionToList(self.myList, id, serverData, false)
      if serverData.is_official == true then
        self:_UpdateOfficialServerData(serverData)
      end
    end
  end
end

function HomeBlueprintProxy:_IsSamePrintItem(itemData, id, serverData)
  if not itemData then
    return false
  end
  if itemData.photoId ~= id then
    return false
  end
  if serverData then
    if serverData.is_official ~= nil and itemData.isOfficial ~= serverData.is_official then
      return false
    end
    if serverData.is_official ~= true and itemData.accId ~= serverData.accid then
      return false
    end
  end
  return true
end

function HomeBlueprintProxy:_RemoveItemFromFlatList(list, id, serverData)
  if not list then
    return
  end
  for i = #list, 1, -1 do
    if self:_IsSamePrintItem(list[i], id, serverData) then
      table.remove(list, i)
    end
  end
end

function HomeBlueprintProxy:_ApplyActionToList(listOrMap, id, serverData, isMap)
  local lists = isMap and listOrMap or {listOrMap}
  if isMap then
    lists = {}
    for _, v in pairs(listOrMap) do
      lists[#lists + 1] = v
    end
  end
  for _, list in ipairs(lists) do
    for _, itemData in ipairs(list) do
      if self:_IsSamePrintItem(itemData, id, serverData) then
        redlog("_IsSamePrintItem", id)
        self:_ApplyServerStateToItemData(itemData, serverData)
      end
    end
  end
end

function HomeBlueprintProxy:UpdateOfficialList(data)
  if not data or not data.items then
    return
  end
  for _, item in ipairs(data.items) do
    local serverData = self:_ParsePrintItemServerData(item)
    if serverData.id then
      self:_UpdateOfficialServerData(serverData)
    end
  end
end

function HomeBlueprintProxy:GetOfficialServerData(officialId)
  return self.officialServerDataMap[officialId]
end
