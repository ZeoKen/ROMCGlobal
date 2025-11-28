autoImport("ItemData")
BagTabData = class("BagTabData")

function BagTabData:ctor(tab)
  self.items = {}
  self.itemsMap = {}
  self.parsedItems = {}
  self.itemNumMap = {}
  self.itemTypeMap = {}
  self.tab = tab
  self.staticIdNumMap = {}
  self.dirty = false
end

function BagTabData:SetDirty(val)
  self.dirty = val or true
end

function BagTabData:IsDirty()
  return self.dirty
end

function BagTabData:AddItems(items)
  if items ~= nil then
    for i = 1, #items do
      self:AddItem(items[i])
    end
  end
end

function BagTabData:Add_StaticIdNum(item)
  local staticID = item.staticData and item.staticData.id
  if not staticID then
    return
  end
  if not self.staticIdNumMap[staticID] then
    self.staticIdNumMap[staticID] = item.num
  else
    self.staticIdNumMap[staticID] = self.staticIdNumMap[staticID] + item.num
  end
end

function BagTabData:Update_StaticIdNum(item, newNum)
  local staticID = item.staticData and item.staticData.id
  if not staticID then
    return
  end
  local dirtyNum = 0
  local dirtyItem = self:GetItemByGuid(item.id)
  if dirtyItem then
    dirtyNum = dirtyItem.num
  end
  local cacheNum = self.staticIdNumMap[staticID] or 1
  newNum = newNum or 0
  self.staticIdNumMap[staticID] = cacheNum - dirtyNum + newNum
end

function BagTabData:_delete_staticIdNum(item)
  local staticID = item.staticData and item.staticData.id
  local cacheNum = self:GetNumByStaticId(staticID)
  if not cacheNum then
    return
  end
  local dirtyNum = item.num
  self.staticIdNumMap[staticID] = cacheNum - dirtyNum
end

function BagTabData:GetNumByStaticId(id)
  return self.staticIdNumMap[id]
end

function BagTabData:AddItem(item)
  if item ~= nil then
    self.itemsMap[item.id] = item
    self.dirty = true
    self.items[#self.items + 1] = item
    self:Add_StaticIdNum(item)
  end
end

function BagTabData:RemoveItems(itemIds)
end

function BagTabData:RemoveItemByGuid(itemId)
  local item = self.itemsMap[itemId]
  self.itemsMap[itemId] = nil
  if item ~= nil then
    self.dirty = true
    self:_delete_staticIdNum(item)
    for _, o in pairs(self.items) do
      if o.id == itemId then
        table.remove(self.items, _)
        return o
      end
    end
  end
end

function BagTabData:ChangeGuid(oldID, newID)
  local item = self.itemsMap[oldID]
  if item ~= nil then
    self.dirty = true
    self.itemsMap[oldID] = nil
    self.itemsMap[newID] = item
    item.id = newID
  end
end

function BagTabData:UpdateItems()
end

function BagTabData:UpdateItem()
end

function BagTabData:GetItems()
  if self.dirty == true then
    TableUtility.ArrayClear(self.parsedItems)
    for i = 1, #self.items do
      table.insert(self.parsedItems, self.items[i])
    end
    table.sort(self.parsedItems, BagTabData.sortFunc)
    self.dirty = false
  end
  return self.parsedItems
end

function BagTabData:GetItemsWithoutNoPile()
  local wholeItems = self:GetItems()
  local items = {}
  for i = 1, #wholeItems do
    local item = wholeItems[i]
    if not item:IsNoPileSlot() then
      items[#items + 1] = item
    end
  end
  return items
end

function BagTabData.sortFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  local leftNoPile = left:IsNoPileSlot()
  local rightNoPile = right:IsNoPileSlot()
  if leftNoPile ~= rightNoPile then
    return leftNoPile
  end
  local leftOrder = left.staticData.ItemSort or 0
  local rightOrder = right.staticData.ItemSort or 0
  if leftOrder ~= rightOrder then
    return leftOrder > rightOrder
  end
  if left.staticData.Type ~= right.staticData.Type then
    return left.staticData.Type < right.staticData.Type
  end
  if left:IsCard() and right:IsCard() then
    local cardLvl = left.cardLv or 0
    local cardLvr = right.cardLv or 0
    if cardLvl ~= cardLvr then
      return cardLvl > cardLvr
    end
  end
  if left.staticData.Quality ~= right.staticData.Quality then
    return left.staticData.Quality > right.staticData.Quality
  end
  return left.staticData.id > right.staticData.id
end

function BagTabData:SortByQualityAscend(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  if left.staticData.Quality < right.staticData.Quality then
    return true
  elseif left.staticData.Quality > right.staticData.Quality then
    return false
  elseif left.staticData.id > right.staticData.id then
    return true
  elseif left.staticData.id < right.staticData.id then
    return false
  else
    return false
  end
end

function BagTabData:GetItemByGuid(guid)
  return self.itemsMap[guid]
end

function BagTabData:GetItemByStaticID(staticID)
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      return o
    end
  end
  return nil
end

function BagTabData:GetItemsByStaticID(staticID)
  local items
  for _, o in pairs(self.items) do
    if o.staticData ~= nil and o.staticData.id == staticID then
      items = items or {}
      items[#items + 1] = o
    end
  end
  return items
end

function BagTabData:GetItemNumByStaticID(staticID)
  return self:GetNumByStaticId(staticID) or 0
end

function BagTabData:GetItemNumByStaticIDs(staticIDs)
  local numMap = self.itemNumMap
  TableUtility.TableClear(numMap)
  local id
  for i = 1, #staticIDs do
    id = staticIDs[i]
    numMap[id] = self:GetItemNumByStaticID(id)
  end
  return numMap
end

function BagTabData:GetItemsByType(typeID, sortFunc)
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

function BagTabData:Reset()
  TableUtility.TableClear(self.items)
  TableUtility.TableClear(self.itemsMap)
  TableUtility.TableClear(self.parsedItems)
  TableUtility.TableClear(self.staticIdNumMap)
end

function BagTabData:Print()
  local items1 = self:GetItems()
  if items1 ~= nil then
    local count = table.maxn(items1)
    for i = 1, count do
      if items1[i] ~= nil then
      else
      end
    end
  end
end
