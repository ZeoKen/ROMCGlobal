autoImport("CardMakeMaterialData")
CardMakeData = class("CardMakeData")

function CardMakeData:ctor(data)
  self:SetData(data)
end

function CardMakeData:SetData(data)
  if data then
    self.id = data
    local compose = Table_Compose[data]
    if compose then
      if compose.Product and compose.Product.id then
        self.itemData = ItemData.new("CardMake", compose.Product.id)
      end
      local beCostItem = compose.BeCostItem
      if beCostItem then
        self.materialItems = {}
        self.cardCount = {}
        self.materialSlotCount = {}
        for i = 1, #beCostItem do
          local data = CardMakeMaterialData.new(beCostItem[i], i)
          TableUtility.ArrayPushBack(self.materialItems, data)
          if not self.cardCount[data.id] then
            self.cardCount[data.id] = 0
          end
          self.cardCount[data.id] = self.cardCount[data.id] + data.itemData.num
          self.materialSlotCount[#self.materialSlotCount + 1] = self.cardCount[data.id]
        end
      end
    end
    self:SetChoose(false)
  end
end

function CardMakeData:IsLock()
  local compose = Table_Compose[self.id]
  if compose.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(compose.MenuID) then
    return true
  end
  return false
end

function CardMakeData:SetChoose(isChoose)
  self.isChoose = isChoose
end

function CardMakeData:CanMake()
  if self:IsLock() then
    return false
  end
  return true
end

function CardMakeData:CheckCanMake(materialData)
  if materialData then
    local id = materialData.id
    return CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(id) >= self.cardCount[id]
  end
  return false
end

function CardMakeData:CheckMaterialSlotCanMake(slotId)
  local material = self.materialItems[slotId]
  if not material then
    return false
  end
  return CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(material.id) >= self.materialSlotCount[slotId]
end

function CardMakeData:ClearCount()
  if self.cardCount then
    for k, v in pairs(self.cardCount) do
      self.cardCount[k] = 0
    end
  end
end

function CardMakeData:GetMaterials()
  return self.materialItems
end

function CardMakeData:GetNeedMaterialNumBySlotId(slotId)
  local material = self.materialItems[slotId]
  if not material then
    return 0
  end
  return math.max(material.itemData.num - CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(material.id), 1)
end

function CardMakeData:IsMakeable()
  for itemId, count in pairs(self.cardCount) do
    local bagNum = CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(itemId)
    if count > bagNum then
      return false
    end
  end
  return true
end
