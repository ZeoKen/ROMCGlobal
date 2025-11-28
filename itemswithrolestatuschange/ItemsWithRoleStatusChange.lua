ItemsWithRoleStatusChange = class("ItemsWithRoleStatusChange")

function ItemsWithRoleStatusChange:Instance()
  if ItemsWithRoleStatusChange.instance == nil then
    ItemsWithRoleStatusChange.instance = ItemsWithRoleStatusChange.new()
  end
  return ItemsWithRoleStatusChange.instance
end

function ItemsWithRoleStatusChange:OnReceiveStatusChange(message)
  if message.propVO.name == "StateEffect" then
    local propertyValue = message:GetValue()
    local status = {}
    local bitCount = 32
    for i = 0, bitCount - 1 do
      local bitValue = BitUtil.band(propertyValue, i)
      if 0 < bitValue then
        table.insert(status, i + 1)
      end
    end
    local allItemTypes = {}
    self.itemTypesForbidden = {}
    for k, v in pairs(GameConfig.ItemsNoUseWhenRoleStates) do
      local statusBitIndex = k
      local itemTypes = v
      for _, v in pairs(itemTypes) do
        local itemType = v
        if not table.ContainsValue(allItemTypes, itemType) then
          table.insert(allItemTypes, itemType)
        end
        if table.ContainsValue(status, statusBitIndex) and not table.ContainsValue(self.itemTypesForbidden, itemType) then
          table.insert(self.itemTypesForbidden, itemType)
        end
      end
    end
    local itemTypesCouldUse = {}
    for _, v in pairs(allItemTypes) do
      local itemType = v
      if not table.ContainsValue(self.itemTypesForbidden, itemType) then
        table.insert(itemTypesCouldUse, itemType)
      end
    end
    for i, v in pairs(itemTypesCouldUse) do
      local itemType = v
      local itemsData = BagProxy.Instance:GetBagItemsByType(itemType)
      for _, v in pairs(itemsData) do
        local itemData = v
        itemData.couldUseWithRoleStatus = true
      end
    end
    for i, v in pairs(self.itemTypesForbidden) do
      local itemType = v
      local itemsData = BagProxy.Instance:GetBagItemsByType(itemType)
      for _, v in pairs(itemsData) do
        local itemData = v
        itemData.couldUseWithRoleStatus = false
      end
    end
    GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  end
end

function ItemsWithRoleStatusChange:AddBuffLimitUseItem(noUseTypes, canUseTypes, noUseIDs, canUseIDs, forbidAll)
  local dirty = false
  if noUseTypes ~= nil then
    if self.buffLimitItemTypes == nil then
      self.buffLimitItemTypes = {}
      self.buffLimitItemTypes.count = 0
    end
    for i = 1, #noUseTypes do
      self:_AddData(self.buffLimitItemTypes, noUseTypes[i], -1)
    end
    dirty = true
  end
  if canUseTypes ~= nil then
    if self.buffLimitItemTypes == nil then
      self.buffLimitItemTypes = {}
      self.buffLimitItemTypes.count = 0
    end
    for i = 1, #canUseTypes do
      self:_AddData(self.buffLimitItemTypes, canUseTypes[i])
    end
    dirty = true
  end
  if noUseIDs ~= nil then
    if self.buffLimitItemSIDs == nil then
      self.buffLimitItemSIDs = {}
      self.buffLimitItemSIDs.count = 0
    end
    for i = 1, #noUseIDs do
      self:_AddData(self.buffLimitItemSIDs, noUseIDs[i], -1)
    end
    dirty = true
  end
  if canUseIDs ~= nil then
    if self.buffLimitItemSIDs == nil then
      self.buffLimitItemSIDs = {}
      self.buffLimitItemSIDs.count = 0
    end
    for i = 1, #canUseIDs do
      self:_AddData(self.buffLimitItemSIDs, canUseIDs[i])
    end
    dirty = true
  end
  if forbidAll == 1 then
    if self.isForbidAll == nil then
      self.isForbidAll = 0
    end
    self.isForbidAll = self.isForbidAll + 1
    dirty = true
  end
  if dirty then
    GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  end
end

function ItemsWithRoleStatusChange:RemoveBuffLimitUseItem(noUseTypes, canUseTypes, noUseIDs, canUseIDs, forbidAll)
  local dirty = false
  if self.buffLimitItemTypes ~= nil then
    if noUseTypes ~= nil then
      for i = 1, #noUseTypes do
        self:_RemoveData(self.buffLimitItemTypes, noUseTypes[i], 1)
      end
      dirty = true
    end
    if canUseTypes ~= nil then
      for i = 1, #canUseTypes do
        self:_RemoveData(self.buffLimitItemTypes, canUseTypes[i])
      end
      dirty = true
    end
  end
  if self.buffLimitItemSIDs ~= nil then
    if noUseIDs ~= nil then
      for i = 1, #noUseIDs do
        self:_RemoveData(self.buffLimitItemSIDs, noUseIDs[i], 1)
      end
      dirty = true
    end
    if canUseIDs ~= nil then
      for i = 1, #canUseIDs do
        self:_RemoveData(self.buffLimitItemSIDs, canUseIDs[i])
      end
      dirty = true
    end
  end
  if forbidAll == 1 and self.isForbidAll ~= nil then
    self.isForbidAll = self.isForbidAll - 1
    dirty = true
  end
  if dirty then
    GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  end
end

function ItemsWithRoleStatusChange:ItemIsCouldUseWithCurrentStatus(item_type, item_sid)
  if self.isForbidAll ~= nil and self.isForbidAll > 0 then
    return false
  end
  local canUse = not table.ContainsValue(self.itemTypesForbidden, item_type)
  if canUse and self.buffLimitItemTypes ~= nil and 0 < self.buffLimitItemTypes.count then
    local count = self.buffLimitItemTypes[item_type]
    canUse = count ~= nil and 0 < count
  end
  if canUse and item_sid and self.buffLimitItemSIDs ~= nil and 0 < self.buffLimitItemSIDs.count then
    local count = self.buffLimitItemSIDs[item_sid]
    canUse = count == nil or 0 <= count
  end
  return canUse
end

function ItemsWithRoleStatusChange:AddBuffForbidEquip(buffEffect)
  local dirty = false
  if buffEffect ~= nil then
    for k, v in pairs(buffEffect) do
      if type(k) == "number" then
        local forbid_on_pos = v.forbid_on_pos
        if forbid_on_pos ~= nil then
          if self.buffForbidOnSites == nil then
            self.buffForbidOnSites = {}
          end
          local data = self.buffForbidOnSites[k]
          if data == nil then
            data = {}
            data.count = 0
            self.buffForbidOnSites[k] = data
          end
          for i = 1, #forbid_on_pos do
            self:_AddData(self.buffForbidOnSites[k], forbid_on_pos[i])
            dirty = true
          end
        end
        local forbid_off_pos = v.forbid_off_pos
        if forbid_off_pos ~= nil then
          if self.buffForbidOffSites == nil then
            self.buffForbidOffSites = {}
          end
          local data = self.buffForbidOffSites[k]
          if data == nil then
            data = {}
            data.count = 0
            self.buffForbidOffSites[k] = data
          end
          for i = 1, #forbid_off_pos do
            self:_AddData(self.buffForbidOffSites[k], forbid_off_pos[i])
            dirty = true
          end
        end
      end
    end
  end
  if dirty then
    GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  end
end

function ItemsWithRoleStatusChange:RemoveBuffForbidEquip(buffEffect)
  local dirty = false
  if buffEffect ~= nil then
    for k, v in pairs(buffEffect) do
      if type(k) == "number" then
        local forbid_on_pos = v.forbid_on_pos
        if forbid_on_pos ~= nil and self.buffForbidOnSites ~= nil and self.buffForbidOnSites[k] ~= nil then
          for i = 1, #forbid_on_pos do
            self:_RemoveData(self.buffForbidOnSites[k], forbid_on_pos[i])
            dirty = true
          end
        end
        local forbid_off_pos = v.forbid_off_pos
        if forbid_off_pos ~= nil and self.buffForbidOffSites ~= nil and self.buffForbidOffSites[k] ~= nil then
          for i = 1, #forbid_off_pos do
            self:_RemoveData(self.buffForbidOffSites[k], forbid_off_pos[i])
            dirty = true
          end
        end
      end
    end
  end
  if dirty then
    GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  end
end

function ItemsWithRoleStatusChange:CanEquipWithCurrentStatus(bagtype, sites)
  if self.buffForbidOnSites ~= nil then
    local data = self.buffForbidOnSites[bagtype]
    if data ~= nil and data.count > 0 then
      for i = 1, #sites do
        local count = data[sites[i]]
        if count ~= nil and 0 < count then
          return false
        end
      end
    end
  end
  return true
end

function ItemsWithRoleStatusChange:CanOffEquipWithCurrentStatus(bagtype, sites)
  if self.buffForbidOffSites ~= nil then
    local data = self.buffForbidOffSites[bagtype]
    if data ~= nil and data.count > 0 then
      for i = 1, #sites do
        local count = data[sites[i]]
        if count ~= nil and 0 < count then
          return false
        end
      end
    end
  end
  return true
end

function ItemsWithRoleStatusChange:_AddData(map, data, calc)
  local count = map[data]
  if count == nil then
    count = 0
    map[data] = count
    map.count = map.count + 1
  end
  calc = calc or 1
  map[data] = count + calc
end

function ItemsWithRoleStatusChange:_RemoveData(map, data, calc)
  local count = map[data]
  if count ~= nil then
    calc = calc or -1
    local result = count + calc
    if result == 0 then
      result = nil
      map.count = map.count - 1
    end
    map[data] = result
  end
end
