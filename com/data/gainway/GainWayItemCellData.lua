GainWayItemCellData = class("GainWayItemCellData")
GainWayItemCellType = {
  Normal = "GainWayItemCellType_Normal",
  Monster = "GainWayItemCellType_Monster",
  Item = "GainWayItemCellType_Item"
}
GainWayItemCellData.TradeOrigin_ID = 1000
GainWayItemCellData.Collection_ID = {
  [4102] = 1,
  [6112] = 1
}
local lotteryOriginAddWayTypeMap

function GainWayItemCellData:ctor(staticID)
  self.staticID = staticID
end

function GainWayItemCellData:CheckOpenByAddWayData(addWayData)
  local open = true
  if not lotteryOriginAddWayTypeMap and GameConfig.Lotteryorigin then
    lotteryOriginAddWayTypeMap = {}
    for lType, addWayList in pairs(GameConfig.Lotteryorigin) do
      for _, addWay in pairs(addWayList) do
        lotteryOriginAddWayTypeMap[addWay] = lType
      end
    end
  end
  if lotteryOriginAddWayTypeMap and lotteryOriginAddWayTypeMap[addWayData.id] then
    local t = lotteryOriginAddWayTypeMap[addWayData.id]
    open = open and LotteryProxy.Instance:CheckLotteryOpen(t)
  end
  if addWayData.menu and open then
    open = FunctionUnLockFunc.Me():CheckCanOpen(addWayData.menu)
  end
  return open
end

function GainWayItemCellData:ParseSingleNormalGainWay(addWayID)
  if not GainWayItemCellData.CheckAddWayDataValid(addWayID) then
    return false
  end
  local d = Table_AddWay[addWayID]
  self.itemID = self.staticID
  self.addWayID = addWayID
  self.name = d.NameEn
  self.icon = d.Icon
  self.type = GainWayItemCellType.Normal
  self.addWayType = d.Type
  self.desc = d.Desc
  local shortid = d.GotoMode and d.GotoMode[1]
  local shortData = shortid and Table_ShortcutPower[shortid]
  if shortData and shortData.Event and shortData.Event.mapid then
    local mapData = Table_Map[shortData.Event.mapid]
    if not mapData then
      return false
    end
  end
  if shortData and shortData.Event.npcid then
    local npcData = Table_Npc[shortData.Event.npcid]
    if npcData then
      self.desc = string.format(self.desc, npcData.NameZh) or ""
      if self.icon == "" then
        self.npcFace = npcData.Icon
      end
    end
  end
  self.isOpen = self:CheckOpenByAddWayData(d)
  self.dropProbability = 0
  self.level = 0
  if GainWayItemCellData.Collection_ID[addWayID] then
    local cName = ItemUtil.GetCollectionNameByItemId(self.itemID)
    if not StringUtil.IsEmpty(cName) then
      self.desc = string.format(d.Desc, cName)
    end
  end
  return true
end

function GainWayItemCellData:ParseSingleMonsterGainWay(mOriData)
  local monsterId, dropProbability = mOriData[1], mOriData[2]
  local monsterData = Table_Monster[monsterId]
  if monsterData and monsterData.Zone == "Field" then
    self:ParseByMonsterData(monsterData, dropProbability)
    return true
  end
  return false
end

function GainWayItemCellData:ParseMonsterListGainWay(monsterId)
  local monsterData = Table_Monster[monsterId]
  if monsterData then
    self:ParseByMonsterData(monsterData, 1)
    local monsterListData = Table_MonsterList and Table_MonsterList[monsterId]
    self.tracePos = monsterListData and monsterListData.RespawnPos
    if not GainWayItemCellData.CheckAddWayDataValid(GainWayItemData.MonsterList_ID) then
      return false
    end
    return true
  end
  return false
end

function GainWayItemCellData:ParseByMonsterData(monsterData, dropProbability)
  self.itemID = self.staticID
  self.type = GainWayItemCellType.Monster
  self.addWayID = GainWayTipProxy.MonsterAddWayID
  self.addWayType = Table_AddWay[self.addWayID].Type
  self.dropProbability = dropProbability
  self.isOpen = true
  self.monsterID = monsterData.id
  self.name = monsterData.NameZh
  self.icon = monsterData.Icon
  self.level = monsterData.Level
  self.monsterType = monsterData.Type
  if Game.Config_Deadboss[self.monsterID] then
    self.monsterType = "Deadboss"
  end
  self.desc = ""
  local manualMap = Table_Monster[monsterData.id].ManualMap
  if manualMap and Table_Map[manualMap] then
    self.shortCutMapParam = manualMap
    if Table_Map[manualMap] then
      self.desc = Table_Map[manualMap].CallZh
    end
    self.isOpen = true
  else
    self.isOpen = false
  end
end

function GainWayItemCellData:CheckMonsterCanBeTraced()
  return (self.addWayID == GainWayTipProxy.MonsterAddWayID or self.addWayID == GainWayItemData.MonsterList_ID) and nil ~= self.shortCutMapParam
end

function GainWayItemCellData:ParseGuildBossGainWay(mOriData)
  local monsterId, dropProbability = mOriData[1], mOriData[2]
  local monsterData = Table_Monster[monsterId]
  if monsterData then
    self:ParseByMonsterData(monsterData, dropProbability)
    if not GainWayItemCellData.CheckAddWayDataValid(GainWayItemData.GuildBossOrigin_ID) then
      return false
    end
    self.desc = Table_AddWay[GainWayItemData.GuildBossOrigin_ID].Desc
    return true
  end
  return false
end

function GainWayItemCellData:ParseFoodGainWay(foodOriData)
  local monsterId, dropProbability = foodOriData[1], foodOriData[2]
  local monsterData = Table_Monster[monsterId]
  if monsterData then
    self:ParseByMonsterData(monsterData, dropProbability)
    return true
  end
end

function GainWayItemCellData:ParseItemGainWay(itemId, addWayID)
  local sData = Table_Item[itemId]
  if sData == nil then
    return false
  end
  if not GainWayItemCellData.CheckAddWayDataValid(addWayID) then
    return false
  end
  local addWayData = Table_AddWay[addWayID]
  self.itemID = self.staticID
  self.type = GainWayItemCellType.Item
  self.addWayID = addWayID
  self.addWayType = addWayData and addWayData.Type or 5
  self.dropProbability = nil
  self.isOpen = true
  self.name = sData.NameZh
  self.icon = sData.Icon
  self.desc = addWayData and addWayData.Desc or "No Config"
  return true
end

function GainWayItemCellData:IsTradeOrigin()
  if self.addWayID and self.addWayID == GainWayItemCellData.TradeOrigin_ID then
    return true
  end
  return false
end

function GainWayItemCellData.CheckAddWayDataValid(id)
  if not id then
    LogUtility.Error("ArgumentNilException while checking static data of AddWay")
    return false
  end
  local sData = Table_AddWay[id]
  if not sData then
    return false
  end
  local nowTimeString = os.date("%Y-%m-%d %H:%M:%S", (ServerTime.CurServerTime() or os.time()) / 1000)
  local beginTime = sData.BeginTime or ""
  local endTime = sData.EndTime or ""
  return (beginTime == "" or nowTimeString > beginTime) and (endTime == "" or nowTimeString <= endTime)
end

function GainWayItemCellData.CheckAddWayDataIsManufacturer(id)
  if not GainWayItemCellData.CheckAddWayDataValid(id) then
    return false
  end
  local sData = Table_AddWay[id]
  return sData.Search1[1] == "Table_Compose" and next(sData.GotoMode) ~= nil
end

function GainWayItemCellData:SetContext(context)
  self.context = context
end

function GainWayItemCellData:ShouldGotoUnlock()
  if self:ShouldShowUnlockDesc() and self.context.lockType == ShopItemData.LockType.AdventureAppend then
    return true
  end
  return false
end

function GainWayItemCellData:ShouldShowUnlockDesc()
  local staticData = self.addWayID and Table_AddWay[self.addWayID]
  local lockTypes = staticData and staticData.LockTypes
  return self.context and lockTypes and table.ContainsValue(lockTypes, self.context.lockType) or false
end

function GainWayItemCellData:GetDesc()
  if self:ShouldShowUnlockDesc() and self.context.lockDesc then
    return self.context.lockDesc
  end
  return self.desc
end
