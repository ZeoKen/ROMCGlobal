autoImport("WildMvpMonsterData")
autoImport("WildMvpAffixGroupData")
autoImport("WildMvpBuffGroupData")
WildMvpProxy = class("WildMvpProxy", pm.Proxy)
WildMvpProxy.Instance = nil
WildMvpProxy.NAME = "WildMvpProxy"
local EmptyTable = {}

function WildMvpProxy:ctor(proxyName, data)
  self.proxyName = proxyName or WildMvpProxy.NAME
  if WildMvpProxy.Instance == nil then
    WildMvpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function WildMvpProxy:Init()
  self.wildMvpAffixDatas = {}
  self.pveAffixDatas = {}
  self.pveAffixDatas2 = {}
  self:InitMonsterDatas()
  self:InitAffixDatas()
  self.buffDataInited = false
  self.cardDropData = {}
end

function WildMvpProxy:GetConfig()
  return GameConfig.StormBoss or EmptyTable
end

function WildMvpProxy:GetMonsterWorkTimeString()
  local config = self:GetConfig()
  return config and config.WorkTimeStr or ""
end

function WildMvpProxy:CanShow()
  local config = GameConfig.StormBoss
  if not config then
    return false
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(config.UnlockMenuId) then
    return false
  end
  local mapId = Game.MapManager:GetMapID()
  if not table.ContainsValue(config.MapIds, mapId) then
    return false
  end
  if not self.buffDataInited then
    self:QueryBuffs()
  end
  return true
end

function WildMvpProxy:InitAffixDatas()
  self:InitWildMvpAffixDatas(GameConfig.StormBoss and GameConfig.StormBoss.AffixTypes, self.wildMvpAffixDatas)
  self:InitWildMvpAffixDatas(GameConfig.StarArk and GameConfig.StarArk.AffixTypes, self.pveAffixDatas)
  self:InitWildMvpAffixDatas(GameConfig.SpaceTimeIllusion and GameConfig.SpaceTimeIllusion.PveAffixTypes, self.pveAffixDatas2)
end

function WildMvpProxy:InitWildMvpAffixDatas(game_config, cache_data)
  if not game_config then
    return
  end
  for typeId, typeName in pairs(game_config) do
    for _, affixConfig in pairs(Table_MonsterAffix) do
      if affixConfig.Type == typeId then
        self:AddAffixDataSorted(affixConfig, typeId, typeName, cache_data)
      end
    end
  end
end

function WildMvpProxy:AddAffixDataSorted(staticData, groupId, groupName, cache_data)
  local group = self:GetAffixGroupById(groupId, cache_data)
  group = group or self:AddAffixGroupSorted(groupId, groupName, cache_data)
  group:AddDataSorted(staticData)
end

function WildMvpProxy:AddAffixGroupSorted(groupId, groupName, cache_data)
  local insertIndex
  for i, v in ipairs(cache_data) do
    if groupId == v.id then
      return v
    elseif groupId < v.id then
      insertIndex = i
      break
    end
  end
  local newGroup = WildMvpAffixGroupData.new(groupId, groupName)
  if insertIndex then
    table.insert(cache_data, insertIndex, newGroup)
  else
    table.insert(cache_data, newGroup)
  end
  return newGroup
end

function WildMvpProxy:GetAffixGroupById(groupId, cache_data)
  if cache_data then
    for _, group in ipairs(cache_data) do
      if group.id == groupId then
        return group
      end
    end
  end
end

function WildMvpProxy:GetAffixDataById(affixId)
  for _, group in ipairs(self.wildMvpAffixDatas) do
    local affix = group:GetAffixDataById(affixId)
    if affix then
      return affix
    end
  end
end

function WildMvpProxy:GetAffixRefreshTimeLeft()
  if not self.nextAffixRefreshTime then
    return
  end
  local timeLeft = self.nextAffixRefreshTime - ServerTime.CurServerTime() / 1000
  if timeLeft < 0 then
    timeLeft = 0
  end
  return timeLeft
end

function WildMvpProxy:GetWildMvpAffixDatas()
  return self.wildMvpAffixDatas
end

function WildMvpProxy:GetPveAffixDatas()
  return self.pveAffixDatas
end

function WildMvpProxy:GetPveAffixDatas2()
  return self.pveAffixDatas2
end

function WildMvpProxy:GetActiveAffixDatas()
  return self.activeAffixDatas or EmptyTable
end

function WildMvpProxy:ClearActiveAffixDatas()
  if self.activeAffixDatas then
    TableUtility.ArrayClear(self.activeAffixDatas)
  end
end

function WildMvpProxy:InitMonsterDatas()
  if self.monsterDatas ~= nil or not GameConfig.StormBoss then
    return
  end
  local mapIds = GameConfig.StormBoss.MapIds
  self.monsterDatas = {}
  for id, v in pairs(Table_MonsterList) do
    local staticData = Table_Monster[id]
    if staticData and staticData.Type == "MVP" and table.ContainsValue(mapIds, v.MapID) then
      self:AddMonsterDataSorted(v)
    end
  end
end

function WildMvpProxy:AddMonsterDataSorted(staticData)
  if not self.monsterDatas then
    self.monsterDatas = {}
  end
  local insertIndex
  local newMonsterConfig = Table_Monster[staticData.id]
  for i, v in ipairs(self.monsterDatas) do
    if v.id == staticData.id then
      return v
    end
    local oldMonsterConfig = Table_Monster[v.id]
    if newMonsterConfig.Level < oldMonsterConfig.Level or staticData.Level == v.Level and staticData.id < v.id then
      insertIndex = i
      break
    end
  end
  local newData = WildMvpMonsterData.new(staticData)
  if insertIndex then
    table.insert(self.monsterDatas, insertIndex, newData)
  else
    table.insert(self.monsterDatas, newData)
  end
  return newData
end

function WildMvpProxy:GetMonsterDatas()
  return self.monsterDatas or EmptyTable
end

function WildMvpProxy:GetMonsterDataById(id)
  if self.monsterDatas then
    for _, v in ipairs(self.monsterDatas) do
      if v.id == id then
        return v
      end
    end
  end
end

function WildMvpProxy:AddMiniMapMonsterData(serverData)
  if not serverData then
    return
  end
  if not self.miniMapMonsterDatas then
    self.miniMapMonsterDatas = {}
  end
  local monsterId = serverData.npcid
  local staticData = Table_MonsterList[monsterId]
  if not staticData then
    return
  end
  local mapId = staticData.MapID
  local mapDatas = self.miniMapMonsterDatas[mapId]
  if not mapDatas then
    mapDatas = {}
    self.miniMapMonsterDatas[mapId] = mapDatas
  end
  local monsterData = mapDatas[monsterId]
  if not monsterData then
    monsterData = WildMvpMonsterData.new(staticData)
    mapDatas[monsterId] = monsterData
  end
  monsterData:SetServerData(serverData)
end

local tempMiniMapMonsterData = {}

function WildMvpProxy:GetCurMiniMapMonsterData()
  TableUtility.TableClear(tempMiniMapMonsterData)
  if not self:CanShow() and not Game.MapManager:IsCurBigWorld() then
    return EmptyTable
  end
  if not self.miniMapMonsterDatas then
    return EmptyTable
  end
  local curMapId = Game.MapManager:GetMapID()
  local datas = self.miniMapMonsterDatas[curMapId]
  if datas then
    for _, v in pairs(datas) do
      if v:IsUnlocked() then
        tempMiniMapMonsterData[v.id] = v
      end
    end
  end
  return tempMiniMapMonsterData
end

function WildMvpProxy:GetCurMiniMapMonsterDataById(id)
  if not self.miniMapMonsterDatas then
    return
  end
  local curMapId = Game.MapManager:GetMapID()
  local datas = self.miniMapMonsterDatas[curMapId]
  if datas then
    for _, v in pairs(datas) do
      if v.id == id then
        return v
      end
    end
  end
end

function WildMvpProxy:GetMiniMapMonsterDataByMap(mapid)
  if not self.miniMapMonsterDatas then
    return
  end
  local datas = self.miniMapMonsterDatas[mapid]
  if datas then
    return datas
  end
end

function WildMvpProxy:GetBuffDatas()
  return self.buffDatas or EmptyTable
end

function WildMvpProxy:ClearBuffDatas()
  if self.buffDatas then
    TableUtility.ArrayClear(self.buffDatas)
  end
end

function WildMvpProxy:ClearBuffDatasExcept(keepDatas)
  if not self.buffDatas then
    return
  end
  if not keepDatas then
    self:ClearBuffDatas()
    return
  end
  for groupIndex = #self.buffDatas, 1, -1 do
    local buffGroup = self.buffDatas[groupIndex]
    buffGroup:ClearBuffDatasExcept(keepDatas)
    if buffGroup:IsEmpty() then
      table.remove(self.buffDatas, groupIndex)
    end
  end
end

function WildMvpProxy:ClearBuffChangedStatus()
  if not self.buffDatas then
    return
  end
  for _, group in ipairs(self.buffDatas) do
    group:ClearBuffChangedStatus()
  end
end

function WildMvpProxy:AddBuffDataSorted(serverData)
  local buffId = serverData.id
  local staticData = Table_BuffReward[buffId]
  if not staticData then
    return
  end
  local categoryId = staticData.Category
  local categoryName = GameConfig.StormBoss.BuffCategories and GameConfig.StormBoss.BuffCategories[categoryId] or ""
  local group = self:GetBuffGroupById(categoryId)
  group = group or self:AddBuffGroupSorted(categoryId, categoryName)
  group:AddBuffDataSorted(staticData, serverData)
end

function WildMvpProxy:GetBuffGroupById(id)
  if self.buffDatas then
    for _, group in ipairs(self.buffDatas) do
      if group.id == id then
        return group
      end
    end
  end
end

function WildMvpProxy:AddBuffGroupSorted(groupId, groupName)
  local insertIndex
  if not self.buffDatas then
    self.buffDatas = {}
  end
  for i, v in ipairs(self.buffDatas) do
    if groupId == v.id then
      return v
    elseif groupId < v.id then
      insertIndex = i
      break
    end
  end
  local newGroup = WildMvpBuffGroupData.new(groupId, groupName)
  if insertIndex then
    table.insert(self.buffDatas, insertIndex, newGroup)
  else
    table.insert(self.buffDatas, newGroup)
  end
  return newGroup
end

function WildMvpProxy:ScheduleQueryMapRareElites()
  if self.queryMapRareElitesTimer then
    return
  end
  self.queryMapRareElitesTimer = TimeTickManager.Me():CreateOnceDelayTick(0, function()
    self:QueryMapRareElites()
    self.queryMapRareElitesTimer = nil
  end, self)
end

function WildMvpProxy:QueryMapRareElites()
  local mapIds = GameConfig.StormBoss and GameConfig.StormBoss.MapIds
  if mapIds then
    ServiceBossCmdProxy.Instance:CallQuerySpecMapRareEliteCmd(mapIds, EQUERYNPCTYPE.EQUERY_MVP)
  end
end

function WildMvpProxy:QueryStormBossAffix()
  if self.nextAffixRefreshTime and ServerTime.CurServerTime() / 1000 < self.nextAffixRefreshTime then
    return
  end
  ServiceMapProxy.Instance:CallStormBossAffixQueryCmd()
end

function WildMvpProxy:ScheduleQueryBuffs()
  if self.queryBuffTimer then
    return
  end
  self.queryBuffTimer = TimeTickManager.Me():CreateOnceDelayTick(0, function()
    self:QueryBuffs()
    self.queryBuffTimer = nil
  end, self)
end

function WildMvpProxy:QueryBuffs()
  ServiceMapProxy.Instance:CallBuffRewardQueryCmd()
end

function WildMvpProxy:CallCardRewardQueryCmd()
  local refreshTime = self.cardDropData and self.cardDropData.refresh_time
  if not refreshTime or refreshTime < ServerTime.CurServerTime() / 1000 then
    ServiceMapProxy.Instance:CallCardRewardQueryCmd()
  end
end

function WildMvpProxy:UpdateActiveAffixDatas(serverData)
  if not serverData or not serverData.affixs then
    return
  end
  if self.activeAffixDatas then
    TableUtility.ArrayClear(self.activeAffixDatas)
  else
    self.activeAffixDatas = {}
  end
  for _, affixId in ipairs(serverData.affixs) do
    local affix = self:GetAffixDataById(affixId)
    if affix then
      table.insert(self.activeAffixDatas, affix)
    end
  end
  self.nextAffixRefreshTime = serverData.refresh_time
  EventManager.Me():DispatchEvent(WildMvpEvent.OnAffixUpdated)
end

function WildMvpProxy:UpdateMiniMapMonsterDatas(serverData)
  if not serverData then
    return
  end
  local serverDatas = serverData.datas
  for _, sData in ipairs(serverData.datas) do
    self:AddMiniMapMonsterData(sData)
  end
  EventManager.Me():DispatchEvent(WildMvpEvent.OnMiniMapMonsterUpdated)
end

function WildMvpProxy:ManualForceUpdateDailyRewardStatus()
  if not self.miniMapMonsterDatas then
    return
  end
  local mapId = Game.MapManager:GetMapID()
  local mapDatas = self.miniMapMonsterDatas[mapId]
  if not mapDatas then
    return
  end
  for _, monsterData in pairs(mapDatas) do
    monsterData:GetIsGottenDailyReward()
  end
  EventManager.Me():DispatchEvent(WildMvpEvent.OnMiniMapMonsterUpdated)
end

function WildMvpProxy:RecvNewMenu(menueIds)
  if not self.miniMapMonsterDatas then
    return
  end
  for _, menuId in ipairs(menueIds) do
    for _, mapDatas in pairs(self.miniMapMonsterDatas) do
      for _, monsterData in pairs(mapDatas) do
        if monsterData.staticData and monsterData.staticData.IconShowMenu == menuId then
          EventManager.Me():DispatchEvent(WildMvpEvent.OnMiniMapMonsterUpdated)
          return
        end
      end
    end
  end
end

function WildMvpProxy:UpdateMonsterDatas(serverData)
  if not (serverData and serverData.datas) or serverData.query_type ~= EQUERYNPCTYPE.EQUERY_MVP then
    return
  end
  local serverDatas = serverData.datas
  local dirty = false
  local updatedDatas = ReusableTable.CreateArray()
  for _, sData in ipairs(serverDatas) do
    for _, localData in ipairs(self.monsterDatas) do
      if localData.id == sData.npcid then
        localData:SetServerData(sData)
        table.insert(updatedDatas, localData)
        dirty = true
        break
      end
    end
  end
  if dirty then
    EventManager.Me():DispatchEvent(WildMvpEvent.OnMonsterUpdated, updatedDatas)
  end
  ReusableTable.DestroyArray(updatedDatas)
end

function WildMvpProxy:UpdateActiveBuffDatas(serverData)
  if not serverData or not serverData.datas then
    return
  end
  self:ClearBuffDatasExcept(serverData.datas)
  for _, sData in ipairs(serverData.datas) do
    self:AddBuffDataSorted(sData)
  end
  if not self.buffDataInited then
    self.buffDataInited = true
    self:ClearBuffChangedStatus()
  end
  EventManager.Me():DispatchEvent(WildMvpEvent.OnBuffUpdated)
end

function WildMvpProxy:CanChangeLuckySetting()
  if not self.lockLuckyUntilTime or ServerTime.CurServerTime() / 1000 > self.lockLuckyUntilTime then
    return true
  end
  return false
end

function WildMvpProxy:HandleLuckySettingResult(data)
  self.lockLuckyUntilTime = data.lock_until_time
  if not data.success then
    self:ShowLuckySettingLockTip()
  end
  self:sendNotification(WildMvpEvent.OnLuckySettingChanged, data)
end

function WildMvpProxy:ShowLuckySettingLockTip()
  if not self.lockLuckyUntilTime then
    return
  end
  local timeLeft = self.lockLuckyUntilTime - ServerTime.CurServerTime() / 1000
  if timeLeft <= 0 then
    return
  end
  MsgManager.ShowMsgByID(43285, math.ceil(timeLeft / 60))
end

function WildMvpProxy:RecvCardRewardQueryCmd(data)
  local data = data.data
  local refreshTime = data and data.refresh_time
  self.cardDropData.refresh_time = refreshTime
  local items = data and data.items
  local groupItems = {}
  for i = 1, #items do
    local groupid = items[i].groupid
    groupItems[groupid] = items[i].index
    xdlog("卡组顺序", groupid, items[i].index)
  end
  self.cardDropData.items = groupItems
end

function WildMvpProxy:GetCardRefreshTime()
  if self.cardDropData.refresh_time then
    return self.cardDropData.refresh_time
  end
end

function WildMvpProxy:GetCardRewardByMonsterID(monsterid)
  local monsterData = Table_Monster[monsterid]
  if not monsterData then
    return
  end
  local cardReward = monsterData and monsterData.BattleTimeReward and monsterData.BattleTimeReward.card_reward
  if not cardReward then
    return
  end
  local rewardGroup = GameConfig.StormBoss and GameConfig.StormBoss.CardRewardGroup
  if not rewardGroup then
    return
  end
  local items = self.cardDropData and self.cardDropData.items
  if not items then
    return
  end
  local cardList = {}
  for i = 1, #cardReward do
    local index = items[cardReward[i]]
    if index then
      local cardid = rewardGroup[cardReward[i]][index]
      if cardid then
        table.insert(cardList, cardid)
      end
    end
  end
  return cardList
end
