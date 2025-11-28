local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _HashToArray = TableUtil.HashToArray
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local _TableShallowCopy = TableUtility.TableShallowCopy
local _IsEmpty = StringUtil.IsEmpty
EquipSuitPreviewData = class("EquipSuitPreviewData")

function EquipSuitPreviewData:ctor(index)
  self.index = index
  self.posMap = {}
  self.suitList = {}
end

function EquipSuitPreviewData:Reset(name, suits)
  self:ResetName(name)
  self:ResetSuits(suits)
end

function EquipSuitPreviewData:ResetName(name)
  if nil ~= name and name ~= self.name then
    self.name = name
  end
end

function EquipSuitPreviewData:ResetSuits(suits)
  if not suits or not next(suits) then
    _ArrayClear(self.suitList)
    _TableClear(self.posMap)
    return
  end
  _TableClear(self.posMap)
  for i = 1, #suits do
    self:ResetSuit(suits[i])
  end
  _ArrayClear(self.suitList)
  _HashToArray(self.posMap, self.suitList)
end

function EquipSuitPreviewData:ResetSuit(suit, ischanged)
  local pos = suit.pos
  if _IsEmpty(suit.guid) and (not suit.itemid or 0 == suit.itemid) then
    self:RemovePosData(pos)
  else
    self:UpdatePosData(pos, suit.guid, suit.itemid)
  end
  if ischanged then
    _ArrayClear(self.suitList)
    _HashToArray(self.posMap, self.suitList)
  end
end

function EquipSuitPreviewData:GetName()
  if _IsEmpty(self.name) then
    return string.format(ZhString.RoleSuitEquipPreview_SuitName, self.index)
  else
    return self.name
  end
end

function EquipSuitPreviewData:UpdatePosData(pos, guid, itemid)
  local posData = EquipSuitPosData.new(pos, guid, itemid)
  self.posMap[pos] = posData
  return posData
end

function EquipSuitPreviewData:IsSame(pos, guid)
  local posData = self.posMap[pos]
  if not posData then
    return false
  else
    return posData.guid == guid
  end
end

function EquipSuitPreviewData:GetPosData(pos)
  return self.posMap[pos]
end

function EquipSuitPreviewData:IsEmpty()
  for _, posData in pairs(self.posMap) do
    if not StringUtil.IsEmpty(posData.guid) or posData.itemid then
      return false
    end
  end
  return true
end

function EquipSuitPreviewData:RemovePosData(pos)
  self.posMap[pos] = nil
end

EquipSuitPosData = class("EquipSuitPosData")

function EquipSuitPosData:ctor(epos, guid, itemid)
  self.pos = epos
  self.guid = guid
  self.item = BagProxy.Instance:GetItemByGuid(guid)
  if nil == self.item then
    self.item = ItemData.new("EquipSuitPosData", itemid)
  end
  self.item.index = epos
  self.itemid = itemid
end
