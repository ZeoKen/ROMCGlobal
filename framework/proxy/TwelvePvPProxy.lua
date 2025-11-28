autoImport("TwelvePVPDetailData")
autoImport("WeeklyTaskData")
TwelvePvPProxy = class("TwelvePvPProxy", pm.Proxy)
TwelvePvPProxy.Instance = nil
TwelvePvPProxy.NAME = "TwelvePvPProxy"
local _MatchCCmd = MatchCCmd_pb
local _FubenCmd = FuBenCmd_pb
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _TableShadowCopy = TableUtility.TableShallowCopy
local _observeProxy
local _ConstFullHp = 100
local _TransPvpCampData = {}
local _TransferCampPvpData = function(enum, valueName)
  if enum then
    _TransPvpCampData[enum] = valueName
  else
    redlog("PvpObserveProxy----> TwelvePvpSyncCmd 12v12同步前后端枚举不一致！ 错误数据： ", valueName)
  end
end
local _TwelvePvpType = {
  [_MatchCCmd.EPVPTYPE_TWELVE] = 1,
  [_MatchCCmd.EPVPTYPE_TWELVE_RELAX] = 1,
  [_MatchCCmd.EPVPTYPE_TWELVE_CHAMPION] = 1,
  [_MatchCCmd.EPVPTYPE_TWELVE_GM] = 1
}
local _TypeDataEvents = {
  [_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_EXP] = TwelvePVPEvent.UpdateCrystalExp,
  [_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_LEVEL] = TwelvePVPEvent.UpdateCrystalLv,
  [_FubenCmd.ETWELVEPVP_DATA_KILL_NUM] = TwelvePVPEvent.UpdateKillNum,
  [_FubenCmd.ETWELVEPVP_DATA_GOLD] = TwelvePVPEvent.UpdateGold,
  [_FubenCmd.ETWELVEPVP_DATA_CAR_POINT] = TwelvePVPEvent.UpdateCarPoint,
  [_FubenCmd.ETWELVEPVP_DATA_PUSH_PLAYER_NUM] = TwelvePVPEvent.UpdatePushNum,
  [_FubenCmd.ETWELVEPVP_DATA_END_TIME] = TwelvePVPEvent.UpdateEndTime
}
local _TwelvePvp = GameConfig.TwelvePvp
local _CrystalExpConfig = _TwelvePvp.CrystalConfig.ExpLevel
local _CrystalExpLength = #_CrystalExpConfig
local _CampConfig = _TwelvePvp.CampConfig
local _CoinID = GameConfig.TwelvePvp.CoinID
local _CrystalLvProgress = function(exp)
  for i = 1, _CrystalExpLength do
    if exp < _CrystalExpConfig[i] then
      local total = _CrystalExpConfig[i]
      local pre = _CrystalExpConfig[i - 1] or 0
      return i, (exp - pre) / (total - pre), total
    end
  end
  return _CrystalExpLength + 1, 1, _CrystalExpConfig[_CrystalExpLength]
end
local _Debug_PvpDataType_Desc = {
  [_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_EXP] = "水晶经验",
  [_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_LEVEL] = "水晶等级",
  [_FubenCmd.ETWELVEPVP_DATA_GOLD] = "玩家金币数目",
  [_FubenCmd.ETWELVEPVP_DATA_CAR_POINT] = "炮车推车得分",
  [_FubenCmd.ETWELVEPVP_DATA_PUSH_PLAYER_NUM] = "推车玩家人数",
  [_FubenCmd.ETWELVEPVP_DATA_END_TIME] = "结束时间",
  [_FubenCmd.ETWELVEPVP_DATA_SHOP_CD] = "商店购买cd",
  [_FubenCmd.ETWELVEPVP_DATA_CAMP] = "阵营信息",
  [_FubenCmd.ETWELVEPVP_DATA_BARRACK_HP] = "兵营血量",
  [_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_HP] = "水晶血量",
  [_FubenCmd.ETWELVEPVP_DATA_PVP_TYPE] = "模式信息",
  [_FubenCmd.ETWELVEPVP_DATA_KILL_NUM] = "击杀数"
}
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_EXP, "crystalExp")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_CRYSTAL_LEVEL, "crystalLv")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_GOLD, "gold")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_CAR_POINT, "carPoint")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_PUSH_PLAYER_NUM, "pushPlayeNum")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_END_TIME, "endTime")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_SHOP_CD, "shopCD")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_CAMP, "camp")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_BARRACK_HP, "barrackHp")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_PVP_TYPE, "pvpType")
_TransferCampPvpData(_FubenCmd.ETWELVEPVP_DATA_KILL_NUM, "killNum")

function TwelvePvPProxy:ctor(proxyName, data)
  self.debugEnable = false
  self.proxyName = proxyName or TwelvePvPProxy.NAME
  if TwelvePvPProxy.Instance == nil then
    TwelvePvPProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function TwelvePvPProxy:Debug(...)
  if self.debugEnable then
    helplog(...)
  end
end

function TwelvePvPProxy:Init()
  _observeProxy = PvpObserveProxy.Instance
  self.playerInfoMap = {}
  self.playerList = {}
  self.campDataMap = {
    [_FubenCmd.EGROUPCAMP_MIN] = {},
    [_FubenCmd.EGROUPCAMP_RED] = {},
    [_FubenCmd.EGROUPCAMP_BLUE] = {}
  }
  self.pvpData = {}
  self.hpMap = {}
  self.frontline = {}
  self.frontlineMap = {}
  self.playerItemMap = {}
  self.playerItems = {}
  self.checkItemDirty = {}
  self.taskDataMap = {}
  self.taskDataList = {}
  self.staticTowerIds = {}
end

function TwelvePvPProxy:Reset()
  _ArrayClear(self.playerList)
  _TableClear(self.playerInfoMap)
  _TableClear(self.pvpData)
  for _, data in pairs(self.campDataMap) do
    _TableClear(data)
  end
  self.winCamp = nil
  self._userInfoDirty = false
  self:_ResetBuildingHp()
  self:_ResetItemMap()
  self:_ResetTaskData()
end

function TwelvePvPProxy:Reconnect()
  self:_ResetItemMap()
end

function TwelvePvPProxy:InitStatic()
  if self.staticInited then
    return
  end
  self.staticInited = true
  self.defaultHpMap = {}
  for i = 1, 2 do
    self.staticTowerIds[i] = {}
    self:_InitCampNpcHp(_CampConfig[i], i)
  end
  self:_ResetBuildingHp()
end

function TwelvePvPProxy:_ResetBuildingHp()
  if not next(self.defaultHpMap) then
    return
  end
  _ArrayClear(self.frontline)
  _TableClear(self.frontlineMap)
  _TableShadowCopy(self.frontlineMap, self.defaultHpMap)
end

function TwelvePvPProxy:_InitCampNpcHp(config, campIndex)
  if not config then
    return
  end
  local defenseTower = config.DefenseTower
  if defenseTower then
    for i = 1, #defenseTower do
      self.defaultHpMap[defenseTower[i]] = _ConstFullHp
      table.insert(self.staticTowerIds[campIndex], defenseTower[i])
    end
  end
  local barrackDeffenceNpc = config.BarrackID and config.BarrackID.defense
  if barrackDeffenceNpc then
    self.defaultHpMap[barrackDeffenceNpc] = _ConstFullHp
    table.insert(self.staticTowerIds[campIndex], barrackDeffenceNpc)
  end
  local crystalId = config.CrystalID
  if crystalId then
    self.defaultHpMap[crystalId] = _ConstFullHp
    table.insert(self.staticTowerIds[campIndex], crystalId)
  end
end

function TwelvePvPProxy:_InitTaskDatas()
  if not Table_TwelvePvpTask then
    return
  end
  self.taskDataMap = self.taskDataMap or {}
  for id, data in pairs(Table_TwelvePvpTask) do
    local entry = WeeklyTaskData.new(id)
    if data.CoinNum then
      entry:AddItemData(_CoinID, data.CoinNum)
    end
    if data.Reward then
      local itemList = ItemUtil.GetRewardItemIdsByTeamId(data.Reward)
      for i = 1, #itemList do
        local itemInfo = itemList[i]
        entry:AddItemData(itemInfo.id, itemInfo.num)
      end
    end
    self.taskDataMap[id] = entry
  end
end

function TwelvePvPProxy:_ResetTaskData()
  if nil == next(self.taskDataMap) then
    self:_InitTaskDatas()
  end
  for _, v in pairs(self.taskDataMap) do
    v:Reset()
  end
end

function TwelvePvPProxy:_ResetTask()
  _ArrayClear(self.taskDataList)
  _TableClear(self.taskDataMap)
end

function TwelvePvPProxy:HandleResult(winCamp)
  if winCamp and winCamp > FuBenCmd_pb.EGROUPCAMP_MIN then
    self.winCamp = winCamp
  end
end

function TwelvePvPProxy:SetGroups(groups)
  if not groups then
    return
  end
  self._userInfoDirty = true
  local debugStr = "12v12--------------服务器同步TwelvePvpGroupInfo |"
  for i = 1, #groups do
    local info = groups[i]
    for j = 1, #info.userinfos do
      local personalInfo = info.userinfos[j]
      local id = personalInfo.charid
      local data = self.playerInfoMap[id]
      if not data then
        debugStr = debugStr .. "新增 |"
        self.playerInfoMap[id] = TwelvePVPDetailData.new(info.color, personalInfo)
      else
        debugStr = debugStr .. "更新 |"
        data:Update(personalInfo)
      end
      debugStr = debugStr .. string.format("玩家：%s | 阵营：%s | 击杀数：%s | 死亡数： %s | 治疗量: %s | 总金币数: %s| 获得水晶经验: %s | 推车时间: %s | 击杀mvp数目: %s | 职业 %s ", personalInfo.name, tostring(info.color), tostring(personalInfo.killnum), tostring(personalInfo.dienum), tostring(personalInfo.heal), tostring(personalInfo.gold), tostring(personalInfo.crystal_exp), tostring(personalInfo.push_time), tostring(personalInfo.kill_mvp), tostring(personalInfo.profession))
    end
  end
  self:Debug(debugStr)
end

function TwelvePvPProxy:SetCampResult(results)
  if not results then
    return
  end
  if not self.campResult then
    self.campResult = {}
  else
    TableUtility.TableClear(self.campResult)
  end
  for i = 1, #results do
    local result = results[i]
    local single = {}
    single.camp = result.camp
    single.kill_num = result.kill_num
    single.exp = result.exp
    single.kill_mvp = result.kill_mvp
    self.campResult[result.camp] = single
  end
end

function TwelvePvPProxy:GetCampResult(camp)
  if not camp or not self.campResult then
    return
  end
  return self.campResult[camp]
end

local tempFrontline = {}

function TwelvePvPProxy:SetFrontlineData(camp, npcid, hp)
  if not (camp and npcid) or not hp then
    return
  end
  if not self.frontlineData then
    self.frontlineData = {}
  end
  tempFrontline = self.frontlineData[camp] or {}
  tempFrontline.id = npcid
  tempFrontline.currenthp = hp
  self.frontlineData[camp] = tempFrontline
end

function TwelvePvPProxy:GetFrontlineData(camp)
  return self.frontlineData and self.frontlineData[camp]
end

function TwelvePvPProxy:HandlePvpData(data)
  local camp = data.camp
  local datas = data.datas
  local charid = data.charid
  if not (camp and datas) or #datas < 1 then
    return
  end
  local cellCamp = self.campDataMap[camp]
  if nil == cellCamp then
    redlog("TwelvePvpSyncCmd同步错误阵营： ", camp)
    return
  end
  local debugStr = "12v12--------------服务器同步TwelvePvpSyncCmd   "
  local evt
  local evtArgs = ReusableTable.CreateArray()
  for i = 1, #datas do
    local cellData = datas[i]
    local debugType = _Debug_PvpDataType_Desc[cellData.type] or tostring(cellData.type)
    local debugValue = tostring(cellData.value)
    debugStr = debugStr .. string.format("%s:%s | ", debugType, debugValue)
    local cellDataType = cellData.type
    if cellDataType then
      local k = _TransPvpCampData[cellDataType]
      if k then
        local newValue = cellData.value
        if k == "gold" then
          if not _observeProxy:IsRunning() then
            local oldGold = cellCamp[k] or 0
            if newValue > oldGold then
              SceneUIManager.Instance:FloatGoldMsg(Game.Myself.data.id, newValue - oldGold)
            end
          end
          if charid then
            _observeProxy:SetObGoldMap(charid, newValue)
            _observeProxy:TryUpdateCheckPlayerGold(charid)
          end
        end
        cellCamp[k] = newValue
        if k == "crystalExp" then
          cellCamp.clientCrystalLv, cellCamp.crystalProgress, cellCamp.crystalTotalExp = _CrystalLvProgress(newValue)
        end
        if camp == _FubenCmd.EGROUPCAMP_MIN then
          self.pvpData = cellCamp
        end
        evt = _TypeDataEvents[cellDataType]
        if "string" == type(evt) then
          evtArgs[1] = camp
          evtArgs[2] = newValue
          GameFacade.Instance:sendNotification(evt, evtArgs)
          EventManager.Me():PassEvent(evt, evtArgs)
        end
      end
    end
  end
  self:Debug(debugStr)
  ReusableTable.DestroyArray(evtArgs)
end

function TwelvePvPProxy:HandleBuildingHpUpdate(data)
  local buildingHp = data and data.data
  if not buildingHp then
    return
  end
  local debugStr = "12v12--------------服务器同步TwelvePvpBuildingHpUpdateCmd:  "
  for i = 1, #buildingHp do
    local buildingId = buildingHp[i].building_id
    local hp = buildingHp[i].hp_per
    debugStr = debugStr .. string.format("buildingID: %s,血量： %s ", tostring(buildingId), tostring(hp))
    if buildingId then
      self.frontlineMap[buildingId] = hp
      if 0 <= hp then
        self.frontline[#self.frontline + 1] = buildingId
      end
    end
  end
  self:Debug(debugStr)
end

function TwelvePvPProxy:HandleItemSync(server_items, playerId)
  if not server_items then
    return
  end
  local debugStr = "12v12--------------服务器同步RaidItemSyncCmd  : playerId：  " .. tostring(playerId) .. " | "
  self.checkItemDirty[playerId] = true
  local items = self.playerItemMap[playerId]
  items = items or {}
  local serverItemId, serverItemCount, debugItemName
  for i = 1, #server_items do
    serverItemId = server_items[i].itemid
    serverItemCount = server_items[i].count
    debugItemName = Table_Item[serverItemId] and Table_Item[serverItemId].NameZh or "error serverid " .. tostring(serverItemId)
    debugStr = debugStr .. string.format("%s  数量： %s | ", debugItemName, tostring(serverItemCount))
    self:_updateItems(items, serverItemId, serverItemCount)
  end
  self.playerItemMap[playerId] = items
  self:Debug(debugStr)
end

function TwelvePvPProxy:HandleItemUpdate(itemid, count, playerId)
  if not itemid or not count then
    return
  end
  local debugStr = "12v12--------------服务器同步RaidItemUpdateCmd  : playerId：  " .. tostring(playerId) .. " | "
  self.checkItemDirty[playerId] = true
  local items = self.playerItemMap[playerId]
  if not items then
    items = {}
    self.playerItemMap[playerId] = items
  end
  local debugItemName = Table_Item[itemid] and Table_Item[itemid].NameZh or "error serverid " .. tostring(itemid)
  self:_updateItems(items, itemid, count)
  debugStr = debugStr .. string.format("%s  数量： %s | ", debugItemName, tostring(count))
  self:Debug(debugStr)
end

function TwelvePvPProxy:_updateItems(itemMap, itemid, count)
  if 0 == count then
    itemMap[itemid] = nil
  else
    itemMap[itemid] = count
  end
end

function TwelvePvPProxy:ClearItem()
  self:_ResetItemMap()
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationClearItem)
  EventManager.Me():PassEvent(MyselfEvent.ObservationClearItem)
end

function TwelvePvPProxy:_ResetItemMap()
  _TableClear(self.playerItemMap)
  _TableClear(self.playerItems)
  _TableClear(self.checkItemDirty)
end

function TwelvePvPProxy:HandleQueryQuest(data)
  local serverDatas = data and data.datas
  if not serverDatas then
    return
  end
  self:_ResetTaskData()
  for i = 1, #serverDatas do
    local id = serverDatas[i].questid
    if self.taskDataMap[id] then
      self.taskDataMap[id]:SetProgress(serverDatas[i].progress)
      self.taskDataMap[id]:SetStatus(serverDatas[i].finished)
    end
  end
end

function TwelvePvPProxy:GetUserList()
  if self._userInfoDirty then
    self._userInfoDirty = false
    TableUtility.ArrayClear(self.playerList)
    for id, info in pairs(self.playerInfoMap) do
      self.playerList[#self.playerList + 1] = info
    end
    table.sort(self.playerList, function(l, r)
      if l.campid == r.campid then
        return l.kill > r.kill
      else
        return l.campid < r.campid
      end
    end)
  end
  return self.playerList
end

function TwelvePvPProxy:GetCurPlayerItems()
  local playerId = _observeProxy:GetCheckingPlayerId() or Game.Myself.data.id
  if not playerId then
    return _EmptyTable
  end
  if self.checkItemDirty[playerId] then
    self.checkItemDirty[playerId] = false
    local itemMap = self.playerItemMap[playerId]
    local itemList = {}
    for id, count in pairs(itemMap) do
      local itemData = ItemData.new("twelveRaidItem" .. tostring(id), id)
      itemData:SetItemNum(count)
      itemList[#itemList + 1] = itemData
    end
    self.playerItems[playerId] = itemList
  end
  return self.playerItems[playerId] or _EmptyTable
end

function TwelvePvPProxy:GetRaidItemNum(id)
  local myId = Game.Myself.data.id
  local itemMap = self.playerItemMap[myId]
  if not itemMap then
    return 0
  end
  return id and itemMap[id] or 0
end

function TwelvePvPProxy:CheckCanUseRaidItem(staticId)
  return Game.MapManager:IsPvPMode_TeamTwelve() and self:GetRaidItemNum(staticId) > 0
end

function TwelvePvPProxy:GetUserInfoById(id)
  return self.playerInfoMap[id] or _EmptyTable
end

function TwelvePvPProxy:CheckFinalResult()
  if self.winCamp and self.winCamp > FuBenCmd_pb.EGROUPCAMP_MIN then
    return true, self.winCamp
  end
  return false
end

function TwelvePvPProxy:GetFrontline()
  return self.frontline
end

function TwelvePvPProxy:GetHPPercentByNPCID(id)
  return id and self.frontlineMap[id] or 0
end

function TwelvePvPProxy:GetCampData(camp)
  return self.campDataMap[camp]
end

function TwelvePvPProxy:GetCrystalExpByCamp(camp)
  local campData = self:GetCampData(camp)
  return campData and campData.crystalExp or 0
end

function TwelvePvPProxy:GetCrystalLv(camp)
  local campData = self:GetCampData(camp)
  local xx = campData and campData.crystalLv or 0
  return campData and campData.crystalLv or 0
end

function TwelvePvPProxy:GetCrystalProgress(camp)
  local campData = self:GetCampData(camp)
  if campData then
    return campData.crystalProgress or 0
  end
  return 0
end

function TwelvePvPProxy:GetCrystalTotalExp(camp)
  local campData = self:GetCampData(camp)
  if campData then
    return campData.crystalTotalExp or 0
  end
  return 0
end

function TwelvePvPProxy:GetCampKill(camp)
  local campData = self:GetCampData(camp)
  if campData then
    return campData.killNum or 0
  end
  return 0
end

function TwelvePvPProxy:GetGold()
  return self.pvpData and self.pvpData.gold or 0
end

function TwelvePvPProxy:GetEndTime()
  return self.pvpData and self.pvpData.endTime or 0
end

function TwelvePvPProxy:GetPvpType()
  return self.pvpData and self.pvpData.pvpType or nil
end

function TwelvePvPProxy:Check12pvp(typelist)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return false
  end
  local mode = self:GetPvpType()
  if mode == 0 then
    return true
  end
  for i = 1, #typelist do
    if typelist[i] == mode then
      return true
    end
  end
  return false
end

function TwelvePvPProxy:IsInNormalTwelvePvp()
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return false
  end
  local t = self:GetPvpType()
  if not t then
    return false
  end
  return t == _MatchCCmd.EPVPTYPE_TWELVE or t == _MatchCCmd.EPVPTYPE_TWELVE_RELAX
end

function TwelvePvPProxy:GetCampTowers()
  return self.staticTowerIds
end

function TwelvePvPProxy:Is12pvp(t)
  return nil ~= t and nil ~= _TwelvePvpType[t]
end

function TwelvePvPProxy:GetTaskDatas()
  if nil == next(self.taskDataMap) then
    self:_InitTaskDatas()
  end
  _ArrayClear(self.taskDataList)
  TableUtil.HashToArray(self.taskDataMap, self.taskDataList)
  table.sort(self.taskDataList, function(l, r)
    return l.id < r.id
  end)
  return self.taskDataList
end
