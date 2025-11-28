local _ArrayClear = TableUtility.ArrayClear
autoImport("SuperGvgRankData")
autoImport("GvgStatData")
SuperGvgProxy = class("SuperGvgProxy", pm.Proxy)
SuperGvgProxy.Instance = nil
SuperGvgProxy.NAME = "SuperGvgProxy"
SuperGvgProxy.E_SuperGVGRank = {
  Sun = 1,
  Moon = 2,
  Star = 3,
  _count = 3
}

function SuperGvgProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SuperGvgProxy.NAME
  if SuperGvgProxy.Instance == nil then
    SuperGvgProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

function SuperGvgProxy:InitProxy()
  self:InitGvg()
end

function SuperGvgProxy:InitGvg()
  self.towersMap = {}
  self.towers = {}
  self.guildsMap = {}
  self.guildIndexMap = {}
  self.userDetailDatas = {}
  self.userDetailDatasIndexMap = {}
  self.lastUserDetailDatas = {}
  self.lastUserDetailDatasIndexMap = {}
  for k, v in pairs(GvgFinalFightTip.EGvgTowerType) do
    local towerData = {etype = k}
    towerData.info = {}
    twdata = ClientGvgTowerData.new(towerData)
    self.towersMap[towerData.etype] = twdata
    self.towers[#self.towers + 1] = twdata
  end
  self.isGvgNewInit = true
  self.rankMap = {}
  for i = 1, SuperGvgProxy.E_SuperGVGRank._count do
    self.rankMap[i] = {}
  end
  self.needResetRank = true
end

function SuperGvgProxy:GetGuildInfos()
  return self.guildIndexMap
end

ClientGvgTowerData = class("ClientGvgTowerData")

function ClientGvgTowerData:ctor(data)
  self:updata(data)
end

function ClientGvgTowerData:updata(data)
  self.etype = data.etype
  self.estate = data.estate
  self.owner_guild = data.owner_guild
  local info = data.info
  self.infos = {}
  for i = 1, #info do
    local single = info[i]
    self.infos[#self.infos + 1] = {
      guildid = single.guildid,
      value = single.value
    }
  end
end

UserDetailData = class("UserDetailData")

function UserDetailData:ctor(data, guildId)
  self:updata(data, guildId)
end

function UserDetailData:updata(data, guildId)
  if not self.detailData then
    self.detailData = {}
  end
  self.detailData[1] = data.username
  self.detailData[2] = data.killusernum
  self.detailData[3] = data.dienum
  self.detailData[4] = data.chipnum
  self.detailData[5] = data.towertime
  self.detailData[6] = data.healhp
  self.detailData[7] = data.relivenum
  self.detailData[8] = data.metaldamage
  self.detailData[9] = data.profession
  self.detailData[10] = guildId
end

ClientGvgGuildInfo = class("ClientGvgGuildInfo")

function ClientGvgGuildInfo:ctor(data)
  self:updata(data)
end

function ClientGvgGuildInfo:updata(data)
  self.index = data.index
  self.guildid = data.guildid
  self.guildname = data.guildname
  self.icon = data.icon
  self.metal_live = data.metal_live
  self:setCrystalData(data.crystal)
end

function ClientGvgGuildInfo:updateCrystalData(data)
  self.crystalData.rank = data.rank
  self.crystalData.guildid = data.guildid
  self.crystalData.crystalnum = data.crystalnum
  self.crystalData.chipnum = data.chipnum
end

function ClientGvgGuildInfo:getCrystalData(data)
  return self.crystalData
end

function ClientGvgGuildInfo:setCrystalData(data)
  if not self.crystalData then
    self.crystalData = {}
  end
  self:updateCrystalData(data)
end

function SuperGvgProxy:HandleRecvSuperGvgSyncFubenCmd(data)
  if not self.isGvgNewInit then
    self:InitGvg()
  end
  local guildinfo = data.guildinfo
  self.fireBeginTime = data.firebegintime
  self:HandleRecvGvgTowerUpdateFubenCmd(data)
  if guildinfo and 0 < #guildinfo then
    for i = 1, #guildinfo do
      local guild = guildinfo[i].crystal.guildid
      local gddata = self.guildsMap[guild]
      if not gddata then
        gddata = ClientGvgGuildInfo.new(guildinfo[i])
        self.guildsMap[guild] = gddata
        self.guildIndexMap[guildinfo[i].index] = gddata
      else
        gddata:updata(guildinfo[i])
      end
    end
  end
  self.isGvgNewInit = false
end

function SuperGvgProxy:HandleRecvGvgTowerUpdateFubenCmd(data)
  local towers = data.towers
  if towers and 0 < #towers then
    for i = 1, #towers do
      local twdata = self.towersMap[towers[i].etype]
      if not twdata then
        twdata = ClientGvgTowerData.new(towers[i])
        self.towersMap[towers[i].etype] = twdata
        self.towers[#self.towers + 1] = twdata
      else
        twdata:updata(towers[i])
      end
    end
  end
end

function SuperGvgProxy:HandleRecvGvgUserDetailFubenCmd(data)
  local guilduserdatas = data.guilduserdata
  if guilduserdatas and 0 < #guilduserdatas then
    for i = 1, #guilduserdatas do
      local oneGuildUserData = guilduserdatas[i]
      local userDatas = oneGuildUserData.userdatas
      for j = 1, #userDatas do
        local newData = userDatas[j]
        local oldData = self.userDetailDatas[newData.username]
        if not oldData then
          userdata = UserDetailData.new(newData, oneGuildUserData.guildid)
          self.userDetailDatas[newData.username] = userdata
          self.userDetailDatasIndexMap[#self.userDetailDatasIndexMap + 1] = userdata
        else
          oldData:updata(newData, oneGuildUserData.guildid)
        end
      end
    end
  end
end

function SuperGvgProxy:HandleRecvQuerySuperGvgStatCmd(data)
  local guilduserdatas = data.datas
  helplog("<<<======HandleRecvQuerySuperGvgStatCmd=======>>>", #guilduserdatas)
  if guilduserdatas and 0 < #guilduserdatas then
    for i = 1, #guilduserdatas do
      local oneGuildUserData = guilduserdatas[i]
      local userDatas = oneGuildUserData.userdatas
      for j = 1, #userDatas do
        local newData = userDatas[j]
        local oldData = self.lastUserDetailDatas[newData.username]
        if not oldData then
          userdata = UserDetailData.new(newData, oneGuildUserData.guildid)
          self.lastUserDetailDatas[newData.username] = userdata
          self.lastUserDetailDatasIndexMap[#self.lastUserDetailDatasIndexMap + 1] = userdata
        else
          oldData:updata(newData, oneGuildUserData.guildid)
        end
      end
    end
  end
end

function SuperGvgProxy:HandleRecvGvgMetalDieFubenCmd(data)
  local guildInfo = self.guildIndexMap[data.index]
  if guildInfo then
    guildInfo.metal_live = false
  end
end

function SuperGvgProxy:HandleRecvGvgCrystalUpdateFubenCmd(data)
  local crystals = data.crystals
  if not crystals or #crystals == 0 then
  end
  for i = 1, #crystals do
    local gldata = self.guildsMap[crystals[i].guildid]
    if gldata then
      gldata:setCrystalData(crystals[i])
    end
  end
end

function SuperGvgProxy:ShowGvgFinalFightTip(stick)
  TipManager.Instance:ShowGvgFinalFightTip(stick, NGUIUtil.AnchorSide.Right, {-450, 0})
end

function SuperGvgProxy:GetClientTowerData(index)
  return self.towersMap[index]
end

function SuperGvgProxy:GetGuildInfoByGuildId(guildid)
  return self.guildsMap[guildid]
end

function SuperGvgProxy:GetIndexByGuildId(guildid)
  local guildInfo = self.guildsMap[guildid]
  if guildInfo then
    return guildInfo.index
  end
end

function SuperGvgProxy:GetTowers()
  return self.towers
end

function SuperGvgProxy:GetGuildsMap()
  return self.guildsMap
end

function SuperGvgProxy:GetTowersMap()
  return self.towersMap
end

function SuperGvgProxy:GetUserDetails()
  return self.userDetailDatasIndexMap
end

function SuperGvgProxy:GetLastUserDetails()
  return self.lastUserDetailDatasIndexMap
end

local QueryTowerInfo_TagMap = {}

function SuperGvgProxy:Active_QueryTowerInfo(k, b)
  if QueryTowerInfo_TagMap[k] == nil then
    QueryTowerInfo_TagMap[k] = 0
  end
  local oldRef = QueryTowerInfo_TagMap[k]
  if b then
    if oldRef == 0 then
      ServiceFuBenCmdProxy.Instance:CallQueryGvgTowerInfoFubenCmd(k, b)
    end
    QueryTowerInfo_TagMap[k] = oldRef + 1
  else
    if 0 < oldRef then
      QueryTowerInfo_TagMap[k] = oldRef - 1
    end
    if oldRef == 1 then
      ServiceFuBenCmdProxy.Instance:CallQueryGvgTowerInfoFubenCmd(k, b)
    end
  end
end

function SuperGvgProxy:GetFinalFightTimeDiff()
  local nowtime = os.date("*t", ServerTime.CurServerTime() / 1000)
  local nowTimeSec = os.time(nowtime)
  local secDiff = 0
  if self.fireBeginTime then
    secDiff = self.fireBeginTime - nowTimeSec
  end
  return secDiff
end

function SuperGvgProxy:HandleSuperGvgRankData(server_datas, end_flag)
  if not server_datas then
    return
  end
  if self.needResetRank then
    for grade, datas in pairs(self.rankMap) do
      _ArrayClear(datas)
    end
    self.needResetRank = false
  end
  for i = 1, #server_datas do
    local gradeArray = self.rankMap[server_datas[i].grade]
    gradeArray[#gradeArray + 1] = SuperGvgRankData.new(server_datas[i])
  end
  if end_flag then
    self.needResetRank = true
    self:_SortSuperGvgRankData()
  end
end

function SuperGvgProxy:_SortSuperGvgRankData()
  for grade, rank_datas in pairs(self.rankMap) do
    table.sort(rank_datas, function(a, b)
      if a.serverId == b.serverId then
        return a.id < b.id
      end
      return a.serverId < b.serverId
    end)
  end
end

function SuperGvgProxy:GetRankDataByGrade(g)
  return self.rankMap[g]
end

function SuperGvgProxy:GetLastGvgStats()
  return self.lastGvgStats or {}
end

function SuperGvgProxy:SortLastGvgStatsByKey(key, asc)
  if not self.lastGvgStats then
    return
  end
  table.sort(self.lastGvgStats, function(a, b)
    if asc then
      return a[key] and b[key] and a[key] < b[key]
    else
      return a[key] and b[key] and a[key] > b[key]
    end
  end)
  return self.lastGvgStats
end

function SuperGvgProxy:GetMyLastGvgStats()
  if not self.myLastGvgStats then
    self.myLastGvgStats = GvgStatData.new()
  end
  if self.myLastGvgStats:IsEmpty() then
    self.myLastGvgStats:FillWithMyselfData()
  end
  return self.myLastGvgStats
end

function SuperGvgProxy:GetLastGvgStatsTime()
  return self.lastGvgStatsTime
end

function SuperGvgProxy:QueryLastGvgStats()
  ServiceGuildCmdProxy.Instance:CallGvgFireReportGuildCmd()
end

function SuperGvgProxy:RecvLastGvgStats(serverData)
  self.lastGvgStats = {}
  self.lastGvgStatsTime = serverData.firetime
  local starStats = {}
  local serverStats = serverData.datas
  if serverStats then
    for _, sData in ipairs(serverStats) do
      local statData = GvgStatData.new()
      statData:SetServerData(sData)
      for _, key in pairs(GvgStatData.SortableKeys) do
        local maxStat = starStats[key]
        if not maxStat then
          if statData[key] and 0 < statData[key] then
            statData:SetStar(key, true)
            starStats[key] = statData
          else
            statData:SetStar(key, false)
          end
        elseif statData[key] and statData[key] >= maxStat[key] then
          maxStat:SetStar(key, false)
          statData:SetStar(key, true)
          starStats[key] = statData
        end
      end
      table.insert(self.lastGvgStats, statData)
    end
  end
  if not self.myLastGvgStats then
    self.myLastGvgStats = GvgStatData.new()
  end
  self.myLastGvgStats:SetServerData(serverData.mydata)
end
