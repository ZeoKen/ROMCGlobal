autoImport("ItemData")
AdventureTab = class("AdventureTab")

function AdventureTab:ctor(tab)
  self.items = {}
  self.itemsMap = {}
  self.parsedItems = {}
  self.itemNumMap = {}
  self.itemTypeMap = {}
  self.tab = tab
  self.dirty = false
  self.totalScore = 0
  self.totalCount = 0
  self.curUnlockCount = 0
  self.cacheStaticIdNumMap = {}
  if self.tab then
    self:setBagTypeData(tab.type)
  end
end

function AdventureTab:setBagTypeData(type)
  self.bagTypeData = Table_ItemTypeAdventureLog[type]
  self.type = type
  self.isDivideByZone = self.type == SceneManual_pb.EMANUALTYPE_MONSTER or self.type == SceneManual_pb.EMANUALTYPE_NPC
  self.isPrestige = self.type == SceneManual_pb.EMANUALTYPE_PRESTIGE
end

function AdventureTab:SetDirty(val)
  self.dirty = val or true
end

function AdventureTab:AddItems(items)
  if items ~= nil then
    for i = 1, #items do
      self:AddItem(items[i])
    end
  end
end

function AdventureTab:AddItem(item)
  if item ~= nil then
    self.dirty = true
    if self.isDivideByZone or self.isPrestige then
      local subID
      if self.isDivideByZone then
        subID = item.staticData.ManualMap
        if not subID or not Table_ManualZone[subID] then
          subID = GameConfig.AdventureDefaultTag.id
        end
      else
        subID = item.staticData.Type
      end
      if not self.itemsMap[subID] then
        self.itemsMap[subID] = {}
      end
      if not self.items[subID] then
        self.items[subID] = {}
      end
      self.itemsMap[subID][item.staticId] = item
      self.items[subID][#self.items[subID] + 1] = item
    else
      self.itemsMap[item.staticId] = item
      self.items[#self.items + 1] = item
    end
    self.cacheStaticIdNumMap[item.staticId] = nil
  end
end

function AdventureTab:RemoveItems(itemIds)
end

function AdventureTab:GetItems()
  TableUtility.TableClear(self.parsedItems)
  if self.isDivideByZone or self.isPrestige then
    for _, listItem in pairs(self.items) do
      for i = 1, #listItem do
        local single = listItem[i]
        if single:IsValid() then
          self.parsedItems[#self.parsedItems + 1] = single
        end
      end
    end
  else
    for i = 1, #self.items do
      local single = self.items[i]
      if single:IsValid() then
        self.parsedItems[#self.parsedItems + 1] = single
      end
    end
  end
  table.sort(self.parsedItems, function(l, r)
    return self:sortFunc(l, r)
  end)
  return self.parsedItems
end

function AdventureTab:GetItemsBySubID(subID)
  if not self.isDivideByZone and not self.isPrestige then
    redlog("Do Not Have SubID")
    return nil
  end
  TableUtility.TableClear(self.parsedItems)
  for id, listItem in pairs(self.items) do
    if id == subID then
      for i = 1, #listItem do
        local single = listItem[i]
        if single:IsValid() then
          self.parsedItems[#self.parsedItems + 1] = single
        end
      end
      table.sort(self.parsedItems, function(l, r)
        return self:sortFunc(l, r)
      end)
      break
    end
  end
  return self.parsedItems
end

function AdventureTab:sortFunc(left, right)
  local lAdSort = left.staticData.AdventureSort
  local rAdSort = right.staticData.AdventureSort
  if lAdSort == rAdSort then
    return left.staticId < right.staticId
  elseif lAdSort == nil then
    return false
  elseif rAdSort == nil then
    return true
  else
    return lAdSort < rAdSort
  end
end

function AdventureTab:GetItemByStaticID(staticID)
  if self.isDivideByZone or self.isPrestige then
    for _, listItem in pairs(self.itemsMap) do
      local item = listItem[staticID]
      if item and item.staticData ~= nil and item.staticData.id == staticID and item:IsValid() then
        return item
      end
    end
    for _, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
          return o
        end
      end
    end
    return nil
  end
  local item = self.itemsMap[staticID]
  if item then
    return item:IsValid() and item or nil
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
      return o
    end
  end
  return nil
end

function AdventureTab:GetItemNumByStaticID(staticID)
  local cache_num = staticID and self.cacheStaticIdNumMap[staticID]
  if nil ~= cache_num then
    return cache_num
  end
  local num = 0
  if self.isDivideByZone or self.isPrestige then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
          num = num + o.num
        end
      end
    end
    return num
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID and o:IsValid() then
      num = num + o.num
    end
  end
  self:SetCacheNum(staticID, num)
  return num
end

function AdventureTab:SetCacheNum(id, num)
  if not id then
    return
  end
  self.cacheStaticIdNumMap[id] = num
end

function AdventureTab:RemoveCacheNum(id)
  if not id then
    return
  end
  self.cacheStaticIdNumMap[id] = nil
end

function AdventureTab:GetItemNumByStaticIDs(staticIDs)
  local numMap = self.itemNumMap
  TableUtility.TableClear(numMap)
  for i = 1, #staticIDs do
    numMap[staticIDs[i]] = 0
  end
  local num
  if self.isDivideByZone or self.isPrestige then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o:IsValid() then
          num = numMap[o.staticData.id]
          if num ~= nil then
            num = num + o.num
            numMap[o.staticData.id] = num
          end
        end
      end
    end
    return numMap
  end
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o:IsValid() then
      num = numMap[o.staticData.id]
      if num ~= nil then
        num = num + o.num
        numMap[o.staticData.id] = num
      end
    end
  end
  return numMap
end

function AdventureTab:GetItemsByType(typeID, sortFunc)
  local res = self.itemTypeMap
  TableUtility.TableClear(res)
  if self.isDivideByZone or self.isPrestige then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o.staticData ~= nil and o.staticData.Type == typeID and o:IsValid() then
          res[#res + 1] = o
        end
      end
    end
  else
    for _, o in pairs(self.items) do
      if o.staticData ~= nil and o.staticData.Type == typeID and o:IsValid() then
        res[#res + 1] = o
      end
    end
  end
  if sortFunc ~= nil then
    table.sort(res, function(l, r)
      return sortFunc(self, l, r)
    end)
  end
  return res
end

function AdventureTab:IsEmpty()
  if self.isDivideByZone or self.isPrestige then
    for mapID, listItem in pairs(self.items) do
      for _, o in pairs(listItem) do
        if o:IsValid() then
          return false
        end
      end
    end
    return true
  end
  for _, o in pairs(self.items) do
    if o:IsValid() then
      return false
    end
  end
  return true
end

function AdventureTab:Reset()
  TableUtility.TableClear(self.items)
  TableUtility.TableClear(self.itemsMap)
  TableUtility.TableClear(self.parsedItems)
  TableUtility.TableClear(self.cacheStaticIdNumMap)
end
