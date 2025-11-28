GroupShowData = class("GroupShowData")

function GroupShowData:ctor(data)
  self:SetData(data)
end

local groupShowDataFields = {
  "charid",
  "profession",
  "name",
  "damage",
  "bedamage",
  "heal",
  "dienum",
  "hatetime"
}

function GroupShowData:SetData(data)
  for _, field in pairs(groupShowDataFields) do
    self[field] = data and data[field]
  end
end

function GroupShowData:SetPercentage(weightMap, filter)
  if weightMap then
    self.total = weightMap[filter]
  else
    redlog("GroupShowData: weightMap nil")
  end
end

function GroupShowData:SetValue(filter)
  if filter == 1 then
    self.value = self.damage
  elseif filter == 2 then
    self.value = self.bedamage
  elseif filter == 3 then
    self.value = self.heal
  elseif filter == 4 then
    self.value = self.dienum
  elseif filter == 5 then
    self.value = self.hatetime
  end
end

function GroupShowData:Clone()
  return GroupShowData.new(self)
end

function GroupShowData:MergeWith(other)
  if type(other) ~= "table" then
    LogUtility.Error("Cannot merge GroupShowData with invalid data")
    return
  end
  if other.charid ~= self.charid then
    LogUtility.WarningFormat("***Cannot merge GroupShowData with different charids:{0}, {1}", self.charid, other.charid)
    return
  end
  self.damage = self.damage + other.damage
  self.bedamage = self.bedamage + other.bedamage
  self.heal = self.heal + other.heal
  self.dienum = self.dienum + other.dienum
  self.hatetime = (self.hatetime or 0) + (other.hatetime or 0)
end

function GroupShowData.Merge(data1, data2)
  if type(data1) ~= "table" or type(data2) ~= "table" or not data1.charid then
    LogUtility.Error("Cannot merge GroupShowData with invalid data")
    return
  end
  local newData = data1:Clone()
  newData:MergeWith(data2)
  return newData
end

GroupRaidTeamShowData = class("GroupRaidTeamShowData")
GroupRaidTeamShowData.ElementTotalIndex = 100000

function GroupRaidTeamShowData:ctor(serverdata)
  self.showdataMap = {}
  self.weightMap = {
    0,
    0,
    0,
    0
  }
  if not serverdata then
    return
  end
  self.raidid = serverdata.raidid
  self.boss_index = serverdata.boss_index
  self:SetData(serverdata.datas)
end

function GroupRaidTeamShowData:SetData(datas)
  for i = 1, 5 do
    self.weightMap[i] = 0
  end
  local dataCount, single = datas and #datas or 0
  for i = 1, dataCount do
    single = self.showdataMap[i] or GroupShowData.new()
    single:SetData(datas[i])
    self.showdataMap[i] = single
    self.weightMap[1] = self.weightMap[1] + single.damage
    self.weightMap[2] = self.weightMap[2] + single.bedamage
    self.weightMap[3] = self.weightMap[3] + single.heal
    self.weightMap[4] = self.weightMap[4] + single.dienum
    self.weightMap[5] = self.weightMap[5] + (single.hatetime or 0)
  end
  for i = dataCount + 1, #self.showdataMap do
    self.showdataMap[i] = nil
  end
end

function GroupRaidTeamShowData:SetValue(filter)
  if self.showdataMap then
    for k, v in pairs(self.showdataMap) do
      v:SetValue(filter)
    end
  end
end

GroupRaidProxy = class("GroupRaidProxy", pm.Proxy)
GroupRaidProxy.Instance = nil
GroupRaidProxy.NAME = "GroupRaidProxy"

function GroupRaidProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GroupRaidProxy.NAME
  if GroupRaidProxy.Instance == nil then
    GroupRaidProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitRecord()
  self.onMarkReplayMap = {}
  self.canRevive = true
  self.groupOnmarkStatus = nil
end

function GroupRaidProxy:InitRecord()
  self.recordMap = {}
  self.comodoRecord = {}
end

function GroupRaidProxy:RecvQueryTeamGroupRaidUserInfo(serverdata)
  if self.recordMap then
    TableUtility.TableClear(self.recordMap)
  end
  if serverdata and serverdata.current then
    if serverdata.current.raidid then
      local cdata = serverdata.current
      local raidid = SceneProxy.Instance:GetCurRaidID()
      self.recordMap[0] = GroupRaidTeamShowData.new(cdata)
      self.recordMap[0].raidid = raidid
    else
      redlog("nil")
    end
  end
  if serverdata and serverdata.history then
    local historys = serverdata.history
    for i = 1, #historys do
      local hdata = historys[i]
      local single = GroupRaidTeamShowData.new(hdata)
      self.recordMap[i] = single
    end
  end
end

function GroupRaidProxy:GetDataByIndex(index, filter)
  if self.recordMap and self.recordMap[index] then
    self.recordMap[index]:SetValue(filter)
    return self.recordMap[index].showdataMap
  end
end

function GroupRaidProxy:GetWeightMapByTime(index)
  if self.recordMap and self.recordMap[index] then
    return self.recordMap[index].weightMap
  end
end

local filterformat = "%d.%s"

function GroupRaidProxy:GetRecordFilter()
  local filterconfig = {}
  local name = ""
  if self.recordMap then
    for k, v in pairs(self.recordMap) do
      name = Table_TeamGroupRaid[v.raidid] and Table_TeamGroupRaid[v.raidid].NameZh or ""
      filterconfig[k] = string.format(filterformat, k + 1, name)
    end
  end
  return filterconfig
end

function GroupRaidProxy:CheckLevellimit(level)
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam then
    local mymemberList = myTeam:GetMembersList()
    for i = 1, #mymemberList do
      if level > mymemberList[i].baselv then
        MsgManager.ShowMsgByID(7305, level)
        return false
      end
    end
    return true
  else
    local lv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if level > lv then
      MsgManager.ShowMsgByID(7301, level)
    end
    return level <= lv
  end
end

function GroupRaidProxy:SaveCanRevive(a)
  self.canRevive = a
end

function GroupRaidProxy:CheckCanRevive()
  return self.canRevive
end

function GroupRaidProxy:ClearOnMarkReply()
  TableUtility.TableClear(self.onMarkReplayMap)
end

function GroupRaidProxy:SetOnMarkReply(charid, reply)
  self.onMarkReplayMap[charid] = reply
end

function GroupRaidProxy:GetOnMarkReplyMap()
  return self.onMarkReplayMap
end

function GroupRaidProxy:CheckShowOnMark()
  if FunctionPve.Me():IsServerThanatosInviting() then
    return false
  end
  if TeamProxy.Instance:IHaveGroup() and TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return true
  end
  return false
end

function GroupRaidProxy:RecvGroupOnMarkStatus(serverdata, time)
  self.groupOnmarkStatus = serverdata.cancel
  self.startPrepareTime = time
end

function GroupRaidProxy:IsWaitOnMark()
  return self.groupOnmarkStatus == false
end

function GroupRaidProxy:ResetGroupOnMarkStatus()
  self.groupOnmarkStatus = nil
end

function GroupRaidProxy:GetOnMarkStarttime()
  return self.startPrepareTime
end

function GroupRaidProxy:IsUnlock(raidid)
end

function GroupRaidProxy:IsCleared(raidid)
end

function GroupRaidProxy:RecvQueryElementRaidStat(serverdata)
  if self.elementRecord then
    TableUtility.TableClear(self.elementRecord)
  else
    self.elementRecord = {}
  end
  local count = 0
  if serverdata and serverdata.current and serverdata.current.raidid and serverdata.current.boss_index and serverdata.current.boss_index ~= 0 then
    local cdata = serverdata.current
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.elementRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.elementRecord[count].raidid = raidid
    self.elementRecord[count].boss_index = serverdata.current.boss_index
  end
  if serverdata and serverdata.history then
    local historys = serverdata.history
    for i = 1, #historys do
      local hdata = historys[i]
      count = count + 1
      local single = GroupRaidTeamShowData.new(hdata)
      self.elementRecord[count] = single
      self.elementRecord[count].boss_index = hdata.boss_index
    end
  end
  if serverdata and serverdata.total and serverdata.total.raidid then
    local cdata = serverdata.total
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.elementRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.elementRecord[count].raidid = raidid
    self.elementRecord[count].boss_index = GroupRaidTeamShowData.ElementTotalIndex
  end
end

function GroupRaidProxy:RecvQueryComodoTeamRaidStat(serverdata)
  if self.comodoRecord then
    TableUtility.TableClear(self.comodoRecord)
  else
    self.comodoRecord = {}
  end
  local count = 0
  if serverdata and serverdata.current and serverdata.current.raidid and serverdata.current.boss_index ~= 0 then
    local cdata = serverdata.current
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.comodoRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.comodoRecord[count].raidid = raidid
    self.comodoRecord[count].boss_index = serverdata.current.boss_index
  end
  if serverdata and serverdata.history then
    local historys = serverdata.history
    for i = 1, #historys do
      local hdata = historys[i]
      count = count + 1
      local single = GroupRaidTeamShowData.new(hdata)
      self.comodoRecord[count] = single
      self.comodoRecord[count].boss_index = hdata.boss_index
    end
  end
  if serverdata and serverdata.total and serverdata.total.raidid then
    local cdata = serverdata.total
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.comodoRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.comodoRecord[count].raidid = raidid
    self.comodoRecord[count].boss_index = 4
  end
end

function GroupRaidProxy:GetComodoDataByIndex(index, filter)
  if self.comodoRecord and self.comodoRecord[index] then
    self.comodoRecord[index]:SetValue(filter)
    return self.comodoRecord[index].showdataMap
  end
end

function GroupRaidProxy:GetComodoWeightMapByTime(index)
  if self.comodoRecord and self.comodoRecord[index] then
    return self.comodoRecord[index].weightMap
  end
end

function GroupRaidProxy:GetComodoRecordFilter()
  local filterconfig = {}
  local name = ""
  local BossFilterConfig = GameConfig.ComodoRaid.BossFilterConfig
  if self.comodoRecord then
    for k, v in pairs(self.comodoRecord) do
      name = BossFilterConfig[v.boss_index]
      filterconfig[k] = string.format(filterformat, k, name)
    end
  end
  return filterconfig
end

function GroupRaidProxy:GetElementRecordFilter()
  local ElementRaidConfig = GameConfig.ElementRaid and GameConfig.ElementRaid.BossFilterConfig
  if not ElementRaidConfig then
    return
  end
  local filterconfig = {}
  if self.elementRecord then
    for i = 1, #self.elementRecord do
      if GroupRaidTeamShowData.ElementTotalIndex == self.elementRecord[i].boss_index then
        table.insert(filterconfig, ZhString.GroupRaidProxy_Total)
      elseif GroupRaidTeamShowData.ElementCurrentIndex == self.elementRecord[i].boss_index then
        table.insert(filterconfig, ZhString.GroupRaidProxy_Current)
      else
        table.insert(filterconfig, ElementRaidConfig[self.elementRecord[i].boss_index or ""] or "")
      end
    end
  end
  return filterconfig
end

function GroupRaidProxy:GetElementDataByIndex(index, filter)
  if self.elementRecord and self.elementRecord[index] then
    self.elementRecord[index]:SetValue(filter)
    return self.elementRecord[index].showdataMap
  end
end

function GroupRaidProxy:GetElementWeightMapByTime(index)
  if self.elementRecord and self.elementRecord[index] then
    return self.elementRecord[index].weightMap
  end
end

function GroupRaidProxy:SetComodoRaidPhase(phase)
  redlog("SetComodoRaidPhase", phase)
  self.currentPhase = phase or 0
end

function GroupRaidProxy:GetComodoRaidPhase(phase)
  return self.currentPhase
end

function GroupRaidProxy:RecvQueryMultiBossRaidStat(serverdata)
  if self.multiBossRecord then
    TableUtility.TableClear(self.multiBossRecord)
  else
    self.multiBossRecord = {}
  end
  local count = 0
  if serverdata and serverdata.current and serverdata.current.raidid and serverdata.current.boss_index ~= 0 then
    local cdata = serverdata.current
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.multiBossRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.multiBossRecord[count].raidid = raidid
    self.multiBossRecord[count].boss_index = serverdata.current.boss_index
  end
  if serverdata and serverdata.history then
    local historys = serverdata.history
    for i = 1, #historys do
      local hdata = historys[i]
      count = count + 1
      local single = GroupRaidTeamShowData.new(hdata)
      self.multiBossRecord[count] = single
      self.multiBossRecord[count].boss_index = hdata.boss_index
    end
  end
  if serverdata and serverdata.total and serverdata.total.raidid then
    local cdata = serverdata.total
    local raidid = SceneProxy.Instance:GetCurRaidID()
    self.currentRaidID = raidid
    count = count + 1
    self.multiBossRecord[count] = GroupRaidTeamShowData.new(cdata)
    self.multiBossRecord[count].raidid = raidid
    self.multiBossRecord[count].boss_index = 4
  end
end

function GroupRaidProxy:GeMultiBossDataByIndex(index, filter)
  if self.multiBossRecord and self.multiBossRecord[index] then
    self.multiBossRecord[index]:SetValue(filter)
    return self.multiBossRecord[index].showdataMap
  end
end

function GroupRaidProxy:GetMultiBossWeightMapByTime(index)
  if self.multiBossRecord and self.multiBossRecord[index] then
    return self.multiBossRecord[index].weightMap
  end
end

function GroupRaidProxy:GetMultiBossRecordFilter()
  local mapid = SceneProxy.Instance:GetCurMapID() or 0
  local MultiBossConfig = GameConfig.MultiBoss
  local raidtype = Table_MapRaid[mapid].Type or 0
  local raidConfig = MultiBossConfig.Raid[raidtype]
  if not raidConfig then
    return
  end
  local filterconfig = {}
  if raidtype ~= PveRaidType.MemoryRaid then
    BossFilterConfig = raidConfig.BossFilterConfig
    local name = ""
    if self.multiBossRecord then
      for k, v in pairs(self.multiBossRecord) do
        name = BossFilterConfig[v.boss_index]
        filterconfig[k] = string.format(filterformat, k, name)
      end
    end
  else
    local name = ""
    local bossConfig = MultiBossConfig.Map[mapid]
    if self.multiBossRecord then
      for k, v in pairs(self.multiBossRecord) do
        local bossindex = v.boss_index
        if bossindex ~= 4 then
          local bossConfig = bossConfig.Stages[bossindex]
          name = Table_Monster[bossConfig.bossid[1]].NameZh
          filterconfig[k] = string.format(filterformat, k, name)
        else
          filterconfig[k] = string.format(filterformat, k, ZhString.GroupRaidProxy_Total)
        end
      end
    end
  end
  return filterconfig
end

function GroupRaidProxy:SetMultiBossRaidPhase(phase)
  self.currentPhase = phase or 0
end

function GroupRaidProxy:GetMultiBossRaidPhase()
  return self.currentPhase
end

local DifficultyNameConfig = GameConfig.CardRaid.cardraid_DifficultyName

function GroupRaidProxy:GetStarArkRecordFilter()
  local nowMapId = Game.MapManager:GetMapID()
  local mapdata = nowMapId and Table_Map[nowMapId]
  local mapName = mapdata and mapdata.NameZh
  local filterconfig = {}
  if self.elementRecord then
    for i = 1, #self.elementRecord do
      local bossIndex = self.elementRecord[i].boss_index
      if GroupRaidTeamShowData.ElementTotalIndex == bossIndex then
        table.insert(filterconfig, string.format(filterformat, i, ZhString.GroupRaidProxy_Total))
      elseif bossIndex then
        table.insert(filterconfig, string.format(filterformat, i, mapName .. (DifficultyNameConfig[bossIndex] or "")))
      end
    end
  end
  return filterconfig
end

function GroupRaidProxy:GetAstralRecordFilter()
  local nameConfig = GameConfig.Astral and GameConfig.Astral.StatFilterConfig
  local filterconfig = {}
  if self.elementRecord then
    for i = 1, #self.elementRecord do
      local bossIndex = self.elementRecord[i].boss_index
      if GroupRaidTeamShowData.ElementTotalIndex == bossIndex then
        table.insert(filterconfig, string.format(filterformat, i, ZhString.GroupRaidProxy_Total))
      elseif bossIndex then
        table.insert(filterconfig, string.format(filterformat, i, nameConfig and nameConfig[bossIndex] or ""))
      end
    end
  end
  return filterconfig
end

function GroupRaidProxy:GetFairyTaleRecordFilter()
  local raidId = Game.MapManager:GetRaidID()
  local raidConfig = Table_MapRaid[raidId]
  local name = raidConfig and raidConfig.NameZh or ""
  local filterconfig = {}
  if self.elementRecord then
    for i = 1, #self.elementRecord do
      local bossIndex = self.elementRecord[i].boss_index
      if GroupRaidTeamShowData.ElementTotalIndex == bossIndex then
        table.insert(filterconfig, string.format(filterformat, i, ZhString.GroupRaidProxy_Total))
      else
        table.insert(filterconfig, string.format(filterformat, i, name))
      end
    end
  end
  return filterconfig
end
