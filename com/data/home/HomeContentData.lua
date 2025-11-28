HomeContentData = class("HomeContentData")
HomeContentData.Type = {Furniture = 1, Renovation = 2}
HomeContentData.DefaultDataType = "Default"
HomeContentData.PackageCheck = {
  BagProxy.BagType.Furniture,
  BagProxy.BagType.Home
}

function HomeContentData:ctor(data, type)
  self.type = type
  self.staticData = data
  self.staticID = data.id
  self.itemStaticData = Table_Item[self.staticID]
  self.itemType = self.itemStaticData and self.itemStaticData.Type or 0
  self.nameZh = data.NameZh
  self.dataType = data.Type or HomeContentData.DefaultDataType
  self.isContentData = true
  self.numInBag = 0
  self.sortValue = 0
  self.canMake = false
  self.isLocked = false
end

function HomeContentData:RefreshStatus()
  self.isUnlocked = FunctionUnLockFunc.Me():CheckCanOpen(self.staticData.MenuID)
  if self.type == HomeContentData.Type.Furniture then
    self.numInBag = BagProxy.Instance:GetItemNumByStaticID(self.staticID, HomeContentData.PackageCheck) or 0
    self.isMatUnlocked = false
    self.isUnlocked = self.numInBag > 0 or self.isUnlocked
  elseif self.type == HomeContentData.Type.Renovation then
    self.numInBag = 0
    self.isMatUnlocked = AdventureDataProxy.Instance:IsFurnitureUnlock(self.staticID, true)
    self.isUnlocked = self.isMatUnlocked or self.isUnlocked
  end
  self.canMake = self.isUnlocked and self.itemStaticData and BagProxy.Instance:CheckItemCanMakeByComposeID(self.itemStaticData.ComposeID, BagProxy.MaterialCheckBag_Type.Furniture)
  if self.numInBag > 0 or self.isMatUnlocked then
    self.sortValue = 4
  elseif self.canMake then
    self.sortValue = 3
  elseif self.isUnlocked then
    self.sortValue = 2
  else
    self.sortValue = 1
  end
end

function HomeContentData:IsUsable(refreshData)
  if HomeManager.ClientTest then
    return true
  end
  if refreshData then
    self:RefreshStatus()
  end
  if self.type == HomeContentData.Type.Furniture then
    return self.numInBag > 0 and self:GetUsableFurnitureID() ~= nil
  elseif self.type == HomeContentData.Type.Renovation then
    return self.isMatUnlocked == true
  end
  return false
end

local furnitureItems = {}

function HomeContentData:GetUsableFurnitureID()
  if self.type == HomeContentData.Type.Renovation then
    return
  end
  TableUtility.ArrayClear(furnitureItems)
  for _, bagType in pairs(HomeContentData.PackageCheck) do
    local items = BagProxy.Instance:GetItemsByStaticID(self.staticID, bagType)
    if items then
      for i = 1, #items do
        TableUtility.ArrayPushBack(furnitureItems, items[i])
      end
    end
  end
  for _, itemData in pairs(furnitureItems) do
    if not HomeManager.Me():FindFurniture(itemData.id, true) then
      return itemData.id
    end
  end
end

function HomeContentData:CanShowInBuildView(refreshData)
  if self.staticData.AreaForceLimit then
    local curHouseConfig = HomeManager.Me():GetCurHouseConfig()
    local curAreaType = curHouseConfig and curHouseConfig.Area
    if not curAreaType or self.staticData.AreaForceLimit & curAreaType < 1 then
      return false
    end
  end
  if refreshData then
    self:RefreshStatus()
  end
  return (self.staticData.HideInAdventure ~= 1 or AdventureDataProxy.Instance:IsFurnitureUnlock(self.staticID, true) or self.numInBag > 0) == true
end

function HomeContentData:GetDataType()
  return self.dataType
end

function HomeContentData:Select(isSelect)
  self.isSelect = isSelect
end

function HomeContentData:IsSelect()
  return self.isSelect == true
end

function HomeContentData:GetItemData()
  if not self.cachedItemData then
    for i = 1, #HomeContentData.PackageCheck do
      self.cachedItemData = BagProxy.Instance:GetItemByStaticID(self.staticID, HomeContentData.PackageCheck[i])
      if self.cachedItemData then
        break
      end
    end
    if not self.cachedItemData then
      self.cachedItemData = ItemData.new("HomeContent", self.staticID)
    end
  end
  return self.cachedItemData
end
