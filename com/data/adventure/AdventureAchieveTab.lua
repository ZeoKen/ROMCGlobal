autoImport("ItemData")
AdventureAchieveTab = class("AdventureAchieveTab")

function AdventureAchieveTab:ctor(tab)
  self.items = {}
  self.itemsMap = {}
  self.parsedItems = {}
  self.itemNumMap = {}
  self.itemTypeMap = {}
  self.tab = tab
  self.dirty = false
  if self.tab then
    self:setBagTypeData(tab.SubGroup)
  end
end

function AdventureAchieveTab:setBagTypeData(type)
  self.bagTypeData = Table_ItemTypeAdventureLog[type]
end

function AdventureAchieveTab:SetDirty(val)
  self.dirty = val or true
end

function AdventureAchieveTab:AddItems(items)
  if items ~= nil then
    for i = 1, #items do
      self:AddItem(items[i])
    end
  end
end

function AdventureAchieveTab:AddItem(item)
  if item ~= nil then
    self.itemsMap[item.id] = item
    self.dirty = true
    self.items[#self.items + 1] = item
  end
end

function AdventureAchieveTab:RemoveItems(itemIds)
end

function AdventureAchieveTab:IsValid(single)
  local timeLimitIsValid = ItemUtil.CheckDateValidByAchievementId(single.staticData.id)
  local visible = single.staticData.Visibility ~= 1 or single:getCompleteString()
  local valid = timeLimitIsValid and visible
  if not valid then
    return false
  end
  local preachievementId = single.staticData.preachievementId
  if not preachievementId then
    return true
  end
  local type = AdventureAchieveProxy.Instance:getTopCategoryIdByAchiveId(preachievementId)
  local bagData = AdventureAchieveProxy.Instance.bagMap[type]
  if not bagData then
    return true
  end
  local preAchData = bagData:GetItemByStaticID(preachievementId)
  if not preAchData then
    return true
  end
  return not preAchData:canGetReward()
end

function AdventureAchieveTab:GetItems()
  if self.dirty == true then
    TableUtility.TableClear(self.parsedItems)
    for _, single in pairs(self.items) do
      local isvalid = self:IsValid(single)
      if isvalid then
        self.parsedItems[#self.parsedItems + 1] = single
      end
    end
    table.sort(self.parsedItems, function(l, r)
      return self:sortFunc(l, r)
    end)
    self.dirty = false
  end
  return self.parsedItems
end

function AdventureAchieveTab:sortFunc(left, right)
  local lAdSort = left.staticData.AdventureSort
  local rAdSort = right.staticData.AdventureSort
  if left:canGetReward() == right:canGetReward() then
    if lAdSort == rAdSort then
      return left.id < right.id
    elseif lAdSort == nil then
      return false
    elseif rAdSort == nil then
      return true
    else
      return lAdSort < rAdSort
    end
  else
    return left:canGetReward()
  end
end

function AdventureAchieveTab:GetItemByStaticID(staticID)
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      return o
    end
  end
  return nil
end

function AdventureAchieveTab:GetItemNumByStaticID(staticID)
  local num = 0
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      num = num + o.num
    end
  end
  return num
end

function AdventureAchieveTab:GetItemNumByStaticIDs(staticIDs)
  local numMap = self.itemNumMap
  TableUtility.TableClear(numMap)
  for i = 1, #staticIDs do
    numMap[staticIDs[i]] = 0
  end
  local num
  for _, o in pairs(self.items) do
    if o.staticData ~= nil then
      num = numMap[o.staticData.id]
      if num ~= nil then
        num = num + o.num
        numMap[o.staticData.id] = num
      end
    end
  end
  return numMap
end

function AdventureAchieveTab:GetItemsByType(typeID, sortFunc)
  local res = self.itemTypeMap
  TableUtility.TableClear(res)
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.Type == typeID then
      res[#res + 1] = o
    end
  end
  if sortFunc ~= nil then
    table.sort(res, function(l, r)
      return sortFunc(self, l, r)
    end)
  end
  return res
end

function AdventureAchieveTab:Reset()
  TableUtility.TableClear(self.items)
  TableUtility.TableClear(self.itemsMap)
  TableUtility.TableClear(self.parsedItems)
end
