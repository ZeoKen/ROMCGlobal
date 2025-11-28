SupplyDepotData = class("SupplyDepotData")
local ArrayClear = TableUtility.ArrayClear
local ArrayPushBack = TableUtility.ArrayPushBack

function SupplyDepotData:ctor(serverData)
  self.actId = serverData.id or serverData.actid
  if GameConfig and GameConfig.TimeLimitShop then
    local config = GameConfig.TimeLimitShop[self.actId]
    if config then
      self.activityIcon = config.activityIcon
      self.activityName = config.activityName
    end
  end
  self.items = {}
  self:SetData(serverData)
end

function SupplyDepotData:SetData(serverData)
  if not serverData then
    return
  end
  if serverData.open ~= nil then
    self.open = serverData.open
  end
  if serverData.starttime then
    self.startDate = os.date("*t", serverData.starttime)
  end
  if serverData.endtime then
    self.endDate = os.date("*t", serverData.endtime)
  end
  if serverData.refreshat then
    self.refreshAt = serverData.refreshat
  end
  if serverData.refreshtimes then
    self.refreshTimes = serverData.refreshtimes
  end
  if serverData.rerefreshcost then
    self.refreshCost = serverData.rerefreshcost
  end
  if serverData.items then
    local resetItems = false
    if self.items and #self.items > 0 then
      for _, v in ipairs(serverData.items) do
        local foundItem = false
        for _, localItem in ipairs(self.items) do
          if v.item and v.item.id == localItem.id and v.idx == localItem.idx then
            localItem:SetData(v.item)
            localItem.bought = v.bought
            foundItem = true
            break
          end
        end
        if not foundItem then
          resetItems = true
          break
        end
      end
    else
      resetItems = true
    end
    if resetItems then
      ArrayClear(self.items)
      for _, v in ipairs(serverData.items) do
        local shopItemData = ShopItemData.new(v.item)
        shopItemData.idx = v.idx
        shopItemData.bought = v.bought
        ArrayPushBack(self.items, shopItemData)
      end
      self:SortItems()
    end
  end
end

function SupplyDepotData:SetBought(itemId, val)
  for _, v in ipairs(self.items) do
    if v.itemId == itemId then
      v.bought = val
      break
    end
  end
end

function SupplyDepotData.ItemSortFunc(a, b)
  if not a.bought and b.bought then
    return true
  elseif a.bought and not b.bought then
    return false
  else
    return a.idx < b.idx
  end
end

function SupplyDepotData:SortItems()
  if self.items then
    table.sort(self.items, SupplyDepotData.ItemSortFunc)
  end
end
