GainWayItemData = class("GainWayItemData")
autoImport("GainWayItemCellData")
GainWayItemData.TypeOrder = {
  [1] = 3,
  [2] = 4,
  [3] = 2,
  [4] = 5,
  [5] = 1
}
GainWayItemData.MonsterOrigin_ID = 1
GainWayItemData.DeadBossOrigin_ID = 4
GainWayItemData.GuildBossOrigin_ID = 1101
GainWayItemData.FoodOrigin_ID = 1120
GainWayItemData.MonsterList_ID = 6348

function GainWayItemData:ctor(staticID)
  self.staticID = staticID
  self.itemOriginData = Table_ItemOrigin[staticID]
  self.datas = {}
  self:ParseEquipComposeGainWay()
  self:ParseEquipUpgradeGainWay()
  self:ParseNormalGainWay()
  self:ParseMonsterGainWay()
  self:ParseGuildBossGainWay()
  self:ParseFoodGainWay()
  self:ParseMonsterListGainWay()
  self:LastSort()
end

function GainWayItemData:ParseEquipComposeGainWay()
  local data = Table_EquipCompose[self.staticID]
  if data ~= nil then
    local srcId = data.Material[1].id
    local cellData = GainWayItemCellData.new(self.staticID)
    local succ = cellData:ParseItemGainWay(srcId, 2)
    if succ then
      table.insert(self.datas, cellData)
    end
  end
end

local getMin = function(tbl)
  if type(tbl) ~= "table" then
    return
  end
  local min, e
  for i = 1, #tbl do
    e = tbl[i]
    min = min or e
    if e < min then
      min = e
    end
  end
  return min
end
local getMax = function(tbl)
  if type(tbl) ~= "table" then
    return
  end
  local max, e
  for i = 1, #tbl do
    e = tbl[i]
    max = max or e
    if e > max then
      max = e
    end
  end
  return max
end

function GainWayItemData:ParseEquipUpgradeGainWay()
  local srdIDs, srcType = BagProxy.GetSurceEquipIds(self.staticID)
  local newSrdIDs, newSrcType = BagProxy.GetSurceEquipIds(getMax(srdIDs))
  if newSrcType == 2 then
    local cellData = GainWayItemCellData.new(self.staticID)
    local inferior = getMin(newSrdIDs)
    local succ = inferior and cellData:ParseItemGainWay(inferior, 3)
    if succ then
      local origData = Table_ItemOrigin[inferior] and Table_ItemOrigin[inferior][1]
      if origData then
        for _, addWayId in pairs(origData) do
          if GainWayItemCellData.CheckAddWayDataIsManufacturer(addWayId) then
            cellData.addWayID = addWayId
            break
          end
        end
      end
      table.insert(self.datas, cellData)
    end
  elseif srcType == 2 and newSrcType == 0 then
    local inferior = getMin(srdIDs)
    local origData = Table_ItemOrigin[inferior] and Table_ItemOrigin[inferior][1]
    if origData then
      for _, addWayId in pairs(origData) do
        if GainWayItemCellData.CheckAddWayDataIsManufacturer(addWayId) then
          local cellData = GainWayItemCellData.new(self.staticID)
          cellData:ParseItemGainWay(inferior, addWayId)
          cellData.desc = ZhString.GainWayTip_FromReplacedMakeableEquipment
          table.insert(self.datas, cellData)
          break
        end
      end
    end
  end
end

function GainWayItemData:ParseNormalGainWay()
  local normalOrigins = self.itemOriginData and self.itemOriginData[1]
  if not normalOrigins then
    return
  end
  for i = 1, #normalOrigins do
    local addWayID = normalOrigins[i]
    if addWayID and addWayID ~= GainWayItemData.MonsterOrigin_ID and addWayID ~= GainWayItemData.DeadBossOrigin_ID and addWayID ~= GainWayItemData.GuildBossOrigin_ID and addWayID ~= GainWayItemData.MonsterList_ID and addWayID ~= GainWayItemData.FoodOrigin_ID then
      local cellData = GainWayItemCellData.new(self.staticID)
      local parseSuc = cellData:ParseSingleNormalGainWay(addWayID)
      if parseSuc and cellData.isOpen then
        if cellData:IsTradeOrigin() then
          if ItemData.CheckItemCanTrade(self.staticID) then
            table.insert(self.datas, cellData)
          end
        else
          table.insert(self.datas, cellData)
        end
      end
    end
  end
end

function GainWayItemData:ParseMonsterGainWay()
  local monsterOrigins = self.itemOriginData and self.itemOriginData[2]
  if not monsterOrigins then
    return
  end
  local monsterCellDatas, bossCellDatas, deadbossCellDatas = ReusableTable.CreateArray(), ReusableTable.CreateArray(), ReusableTable.CreateArray()
  local filterMap = {}
  for i = 1, #monsterOrigins do
    local mOriData = monsterOrigins[i]
    if mOriData then
      local cellData = GainWayItemCellData.new(self.staticID)
      local parseSuc = cellData:ParseSingleMonsterGainWay(mOriData)
      if parseSuc and not filterMap[cellData.monsterID] then
        filterMap[cellData.monsterID] = 1
        if cellData.monsterType == "Monster" then
          table.insert(monsterCellDatas, cellData)
        elseif cellData.monsterType == "MINI" or cellData.monsterType == "MVP" then
          table.insert(bossCellDatas, cellData)
        elseif cellData.monsterType == "Deadboss" then
          table.insert(deadbossCellDatas, cellData)
        end
      end
    end
  end
  local limitlv = MyselfProxy.Instance:RoleLevel() + 5
  local sortRules = function(a, b)
    local aDeltalv = limitlv - a.level
    local bDeltalv = limitlv - b.level
    local aUnderlv = 0 <= aDeltalv
    local bUnderLv = 0 <= bDeltalv
    if aUnderlv ~= bUnderLv then
      return aUnderlv
    elseif not aUnderlv and aDeltalv ~= bDeltalv then
      return aDeltalv > bDeltalv
    end
    return a.dropProbability > b.dropProbability
  end
  if 0 < #monsterCellDatas then
    if 1 < #monsterCellDatas then
      table.sort(monsterCellDatas, sortRules)
    end
    for i = 1, 4 do
      local mdata = monsterCellDatas[i]
      if mdata then
        table.insert(self.datas, mdata)
      end
    end
    self.firstMonsterCellData = monsterCellDatas[1]
  else
    if 0 < #bossCellDatas then
      table.sort(bossCellDatas, sortRules)
      table.insert(self.datas, bossCellDatas[1])
      self.firstMonsterCellData = bossCellDatas[1]
    end
    if 0 < #deadbossCellDatas then
      table.sort(deadbossCellDatas, sortRules)
      table.insert(self.datas, deadbossCellDatas[1])
      self.firstMonsterCellData = deadbossCellDatas[1]
    end
  end
  ReusableTable.DestroyAndClearArray(monsterCellDatas)
  ReusableTable.DestroyAndClearArray(bossCellDatas)
  ReusableTable.DestroyAndClearArray(deadbossCellDatas)
end

function GainWayItemData:ParseGuildBossGainWay()
  local guildBossOrigins = self.itemOriginData and self.itemOriginData[3]
  if not guildBossOrigins then
    return
  end
  local origin, cellData, succ
  for i = 1, #guildBossOrigins do
    origin = guildBossOrigins[i]
    cellData = GainWayItemCellData.new(self.addWayID)
    succ = cellData:ParseGuildBossGainWay(origin)
    if succ then
      table.insert(self.datas, cellData)
    end
  end
end

function GainWayItemData:ParseFoodGainWay()
  local foodOrigins = self.itemOriginData and self.itemOriginData[4]
  if not foodOrigins then
    return
  end
  for i = 1, #foodOrigins do
    local origin = foodOrigins[i]
    local cellData = GainWayItemCellData.new(self.staticID)
    cellData:ParseFoodGainWay(origin)
    table.insert(self.datas, cellData)
  end
end

function GainWayItemData:ParseMonsterListGainWay()
  local monsterListOrigins = self.itemOriginData and self.itemOriginData[5]
  if not monsterListOrigins then
    return
  end
  local origin, cellData, succ
  for i = 1, #monsterListOrigins do
    cellData = GainWayItemCellData.new(self.addWayID)
    succ = cellData:ParseMonsterListGainWay(monsterListOrigins[i])
    if succ then
      table.insert(self.datas, cellData)
    end
  end
end

function GainWayItemData:LastSort()
  local itemData = Table_Item[self.staticID]
  local orderTable = Table_ItemType[itemData.Type]
  orderTable = orderTable and orderTable.Order1
  local typeOrder = GainWayItemData.TypeOrder
  table.sort(self.datas, function(a, b)
    if a.isOpen ~= b.isOpen then
      return a.isOpen == true
    end
    if a.addWayType and b.addWayType and a.addWayType ~= b.addWayType then
      local aI = typeOrder[a.addWayType] or 10000
      local bI = typeOrder[b.addWayType] or 10000
      return aI < bI
    end
    if orderTable and a.addWayID and b.addWayID and a.addWayID ~= b.addWayID then
      local aIndex = TableUtil.FindKeyByValue(orderTable, a.addWayID) or 10000
      local bIndex = TableUtil.FindKeyByValue(orderTable, b.addWayID) or 10000
      return aIndex < bIndex
    end
    return false
  end)
end

function GainWayItemData:GetFirstMonsterOrigin()
  return self.firstMonsterCellData
end
