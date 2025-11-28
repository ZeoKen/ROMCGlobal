EquipMemoryData = class("EquipMemoryData")

function EquipMemoryData:ctor(guid, serverData)
  if guid and guid ~= "" then
    self.itemGuid = guid or nil
  end
  self.memoryAttrs = {}
  self.previewAttrs = {}
end

function EquipMemoryData:SetMyServerData(serverData)
  self.staticId = serverData.itemid
  self.level = serverData.lv
  local staticData = Table_ItemMemory[self.staticId]
  if not staticData then
    redlog("记忆载体错误", self.staticId)
    return
  end
  self.maxLevel = staticData.MaxLevel
  local randomAttrLv = staticData and staticData.RandomAttr
  local _attrCount = 0
  for _stepLv, _ in pairs(randomAttrLv) do
    _attrCount = _attrCount + 1
  end
  self.maxAttrCount = _attrCount
  TableUtility.TableClear(self.memoryAttrs)
  TableUtility.TableClear(self.previewAttrs)
  local effects = serverData.effects or {}
  for i = 1, #effects do
    local _singleAttr = effects[i]
    local _singleAttrData = {
      id = _singleAttr.id,
      level = _singleAttr.level,
      wax_level = _singleAttr.wax_level
    }
    _singleAttrData.previewid = {}
    TableUtility.ArrayShallowCopy(_singleAttrData.previewid, _singleAttr.previewid)
    local debugStr = string.format("装备记忆词条数据 id:%s， level:%s, wax_level: %s ", _singleAttrData.id, _singleAttrData.level, _singleAttrData.wax_level)
    if _singleAttrData.previewid and 0 < #_singleAttrData.previewid then
      debugStr = debugStr .. string.format(" 预览词条数量  %s 条", #_singleAttrData.previewid)
    end
    table.insert(self.memoryAttrs, _singleAttrData)
  end
  self.excess_lv = serverData.excess_lv or 0
end

function EquipMemoryData:HasCacheRefreshAttr()
  local hasCache = false
  local cacheIndex = 0
  if self.memoryAttrs and 0 < #self.memoryAttrs then
    for i = 1, #self.memoryAttrs do
      if self.memoryAttrs[i].previewid and 0 < #self.memoryAttrs[i].previewid then
        hasCache = true
        cacheIndex = i
        break
      end
    end
  end
  return hasCache, cacheIndex
end

function EquipMemoryData:CheckHasPreviewAttr(index)
  if self.memoryAttrs and self.memoryAttrs[index] and self.memoryAttrs[index].previewid and #self.memoryAttrs[index].previewid > 0 then
    return true
  end
  return false
end

function EquipMemoryData:IsRandomResult()
  if self.memoryAttrs and self.memoryAttrs[3] then
    local previewids = self.memoryAttrs[3].previewid
    if previewids and #previewids == 1 then
      return true
    end
  end
  return false
end

function EquipMemoryData:IsHighValue()
  local isHighValue = false
  local staticData = Table_Item[self.staticId]
  if staticData and staticData.Quality >= 4 then
    isHighValue = true
  end
  if not isHighValue and self.memoryAttrs and #self.memoryAttrs > 0 then
    for i = 1, #self.memoryAttrs do
      local attrId = self.memoryAttrs[i].id
      if attrId and Game.ItemMemoryEffect and Game.ItemMemoryEffect[attrId] then
        local effectType = Game.ItemMemoryEffect[attrId].Color
        if effectType == "special" then
          isHighValue = true
          break
        end
      end
    end
  end
  return isHighValue
end

function EquipMemoryData:GetValuePower()
  local finalValue = 0
  local staticData = Table_Item[self.staticId]
  if self.level and 0 < self.level then
    finalValue = finalValue + self.level * 100
  end
  if self.excess_lv and 0 < self.excess_lv then
    finalValue = finalValue + self.excess_lv * 10
  end
  if staticData and staticData.Quality then
    finalValue = finalValue + staticData.Quality * 1000
  end
  if self.memoryAttrs and 0 < #self.memoryAttrs then
    for i = 1, #self.memoryAttrs do
      local attrId = self.memoryAttrs[i].id
      if attrId and Game.ItemMemoryEffect and Game.ItemMemoryEffect[attrId] then
        local effectType = Game.ItemMemoryEffect[attrId].Color
        if effectType == "special" then
          finalValue = finalValue + 10000
        end
      end
    end
  end
  return finalValue
end

function EquipMemoryData:GetWaxCount()
  local count = 0
  if self.memoryAttrs and 0 < #self.memoryAttrs then
    for i = 1, #self.memoryAttrs do
      if self.memoryAttrs[i].wax_level and 0 < self.memoryAttrs[i].wax_level then
        count = count + 1
      end
    end
  end
  return count
end

function EquipMemoryData:GetAttrID(index)
  if self.memoryAttrs[index] then
    return self.memoryAttrs[index].id
  end
  return 0
end

function EquipMemoryData:CheckCanAdvance()
  local staticData = Table_ItemMemory[self.staticId]
  if staticData then
    local upgradeID = staticData.UpgradeID
    return upgradeID ~= nil
  end
  return false
end

function EquipMemoryData:Clone()
  local equipMemoryData = EquipMemoryData.new(self.itemGuid)
  equipMemoryData.staticId = self.staticId
  equipMemoryData.level = self.level
  equipMemoryData.maxLevel = self.maxLevel
  equipMemoryData.maxAttrCount = self.maxAttrCount
  equipMemoryData.excess_lv = self.excess_lv
  for i = 1, #self.memoryAttrs do
    local _singleAttrData = {}
    local _singleAttr = self.memoryAttrs[i]
    local _singleAttrData = {
      id = _singleAttr.id,
      level = _singleAttr.level,
      wax_level = _singleAttr.wax_level
    }
    _singleAttrData.previewid = {}
    TableUtility.ArrayShallowCopy(_singleAttrData.previewid, _singleAttr.previewid)
    equipMemoryData.memoryAttrs[i] = _singleAttrData
  end
  return equipMemoryData
end
