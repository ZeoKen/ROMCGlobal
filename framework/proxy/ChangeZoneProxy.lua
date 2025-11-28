autoImport("ZoneData")
autoImport("ServerZoneData")
ChangeZoneProxy = class("ChangeZoneProxy", pm.Proxy)
ChangeZoneProxy.Instance = nil
ChangeZoneProxy.NAME = "ChangeZoneProxy"
ChangeZoneProxy.TypeEnum = {
  ChangeLine = "ChangeLine",
  BackGuildLine = "BackGuildLine",
  ChangeGuildLine = "ChangeGuildLine"
}

function ChangeZoneProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ChangeZoneProxy.NAME
  if ChangeZoneProxy.Instance == nil then
    ChangeZoneProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ChangeZoneProxy:Init()
  self.infos = {}
  self.recents = {}
  self.serverInfos = {}
  self.pvpZoneIds = {}
  self.serverNames = {}
end

function ChangeZoneProxy:RecvQueryZoneStatus(data)
  self:RecvInfos(data)
  self:RecvRecents(data)
end

function ChangeZoneProxy:RecvInfos(data)
  TableUtility.TableClear(self.infos)
  if data.infos then
    for i = 1, #data.infos do
      local zoneData = ZoneData.new(data.infos[i])
      self.infos[zoneData.zoneid] = zoneData
    end
  end
end

local tempRecentZoneInfo = {}

function ChangeZoneProxy:RecvRecents(data)
  TableUtility.ArrayClear(self.recents)
  if data.recents then
    for i = 1, #data.recents do
      local recentData = ZoneData.new(data.recents[i])
      TableUtility.ArrayPushBack(self.recents, recentData)
    end
  end
  if GuildProxy.Instance:IHaveGuild() then
    TableUtility.TableClear(tempRecentZoneInfo)
    tempRecentZoneInfo.type = ZoneData.JumpZone.Guild
    tempRecentZoneInfo.zoneid = GuildProxy.Instance.myGuildData.zoneid
    local recentData = ZoneData.new(tempRecentZoneInfo)
    TableUtility.ArrayPushBack(self.recents, recentData)
  end
  if TeamProxy.Instance:IHaveTeam() then
    local leader = TeamProxy.Instance.myTeam:GetNowLeader()
    if leader then
      TableUtility.TableClear(tempRecentZoneInfo)
      tempRecentZoneInfo.type = ZoneData.JumpZone.Team
      tempRecentZoneInfo.zoneid = leader:GetZoneId()
      local recentData = ZoneData.new(tempRecentZoneInfo)
      TableUtility.ArrayPushBack(self.recents, recentData)
    end
  end
  table.sort(self.recents, function(l, r)
    if l.type == r.type then
      return false
    else
      return l.type < r.type
    end
  end)
end

function ChangeZoneProxy:RecvServerInfoNtf(data)
  TableUtility.TableClear(self.serverInfos)
  TableUtility.TableClear(self.serverNames)
  local nameList = {}
  local info
  local infos = data.serverinfo.serverinfos
  for i = 1, #infos do
    info = infos[i]
    self.serverInfos[info.serverid] = ServerZoneData.new(info)
    if info.zoneinfos and #info.zoneinfos > 0 then
      for j = 1, #info.zoneinfos do
        local serverName = info.zoneinfos[j].name
        local lang = string.sub(serverName, 1, 2)
        if not nameList[lang] and lang ~= "" then
          nameList[lang] = 1
          xdlog("serverZone", lang)
        end
      end
    end
  end
  self.mergeServerMap = {}
  local groupid
  for serverid, v in pairs(self.serverInfos) do
    groupid = v.groupid
    for k, v in pairs(self.serverInfos) do
      if serverid ~= k and groupid == v.groupid then
        self.mergeServerMap[serverid] = 1
      end
    end
  end
  xdlog("#namelist", #nameList)
  local config = GameConfig.ChangeZone.zone_name
  if nameList then
    for k, v in pairs(nameList) do
      if config and config[k] then
        local fullName = config[k].fullname or ""
        local data = {name_prefix = k, fullname = fullName}
        table.insert(self.serverNames, data)
      end
    end
  end
  local pvp
  local pvps = data.serverinfo.pvpzoneids
  for i = 1, #pvps do
    pvp = self:GetSimpleZoneId(pvps[i])
    self.pvpZoneIds[pvp] = pvp
  end
end

function ChangeZoneProxy:GetInfos(zoneid)
  return self.infos[zoneid]
end

function ChangeZoneProxy:GetRecents()
  return self.recents
end

function ChangeZoneProxy:GetDisplayZoneName(zoneid)
  local name
  for k, v in pairs(self.serverInfos) do
    name = v:GetDisplayZoneName(zoneid)
    if name ~= nil then
      return name
    end
  end
  return zoneid
end

function ChangeZoneProxy:GetServerId(zoneid)
  local name
  for k, v in pairs(self.serverInfos) do
    name = v:GetDisplayZoneName(zoneid)
    if name ~= nil then
      return k
    end
  end
  return 1
end

function ChangeZoneProxy:GetMyselfServerId()
  local myZoneId = MyselfProxy.Instance:GetZoneId()
  myZoneId = self:GetSimpleZoneId(myZoneId)
  return self:GetServerId(myZoneId)
end

function ChangeZoneProxy:GetZoneId(zoneid, realZoneid)
  if zoneid == nil then
    return
  end
  local num = self:GetSimpleZoneId(zoneid)
  if 9000 <= num and not self.pvpZoneIds[num] and not Game.MapManager:MapTeamNoNeedInPvpZone() then
    return realZoneid
  end
  return zoneid
end

function ChangeZoneProxy:GetSimpleZoneId(zoneid)
  if zoneid == nil then
    return
  end
  if 9999 <= zoneid then
    return math.fmod(zoneid, 10000)
  end
  return zoneid
end

function ChangeZoneProxy:ZoneNumToString(num, formatStr, realNum)
  if num then
    if type(num) ~= "number" then
      num = tonumber(num)
    end
    if realNum ~= nil then
      num = self:GetZoneId(num, realNum)
    end
    if num and 0 < num then
      num = self:GetSimpleZoneId(num)
      if 9000 <= num then
        if self.pvpZoneIds[num] then
          return ZhString.ChangeZoneProxy_PvpLine
        elseif Game.MapManager:MapTeamNoNeedInPvpZone() then
          return ZhString.ChangeZoneProxy_CommonRaidLine
        end
      end
      local name = self:GetDisplayZoneName(num)
      return formatStr and string.format(formatStr, name) or name
    end
  end
  errorLog(string.format("error when ZoneNumToString(%s)", tostring(num)))
  return ""
end

function ChangeZoneProxy:ZoneStringToNum(zoneStr)
  if zoneStr then
    local myServerId = self:GetMyselfServerId()
    if myServerId ~= nil then
      local data = self.serverInfos[myServerId]
      if data ~= nil then
        return data:GetZoneId(zoneStr) or 0
      end
    end
  end
  return 0
end

function ChangeZoneProxy:IsPvpZone(zoneid)
  if zoneid == nil then
    return false
  end
  zoneid = self:GetSimpleZoneId(zoneid)
  return self.pvpZoneIds[zoneid] ~= nil
end

function ChangeZoneProxy:IsCommonLine(zoneid)
  if zoneid and 9000 < zoneid then
    return true
  end
  return false
end

function ChangeZoneProxy:GetTradeGroupID(serverid)
  if not self.serverInfos[serverid] then
    redlog("交易通服记录不存在")
    return
  end
  return self.serverInfos[serverid].tradegroupid
end

function ChangeZoneProxy:Check2ServerCanMerge(serverid1, serverid2)
  local serverZoneData1 = self.serverInfos[serverid1]
  local serverZoneData2 = self.serverInfos[serverid2]
  if serverZoneData1 and serverZoneData2 then
    return serverZoneData1.groupid == serverZoneData2.groupid
  end
  return false
end

function ChangeZoneProxy:CheckIsMergeServer(serverid)
  return nil ~= serverid and nil ~= self.mergeServerMap[serverid]
end

function ChangeZoneProxy:CheckCurIsMergeServer()
  local curServer = FunctionLogin.Me():getCurServerData()
  local linegroup = curServer and curServer.linegroup or 1
  return self:CheckIsMergeServer(linegroup)
end

function ChangeZoneProxy:GetServerGroupId(serverid)
  local info = self.serverInfos[serverid]
  return info and info.groupid
end

function ChangeZoneProxy:GetCurServerGroupId()
  local serverid = self:GetMyselfServerId()
  return self:GetServerGroupId(serverid)
end

function ChangeZoneProxy:CheckServerCanQueryPrice()
  if not self.serverInfos then
    return false
  end
  local my_pretradegroupid = 0
  local my_serverid = self:GetMyselfServerId()
  if not my_serverid or not self.serverInfos[my_serverid] then
    return false
  end
  for serverid, v in pairs(self.serverInfos) do
    if serverid == my_serverid then
      my_pretradegroupid = v.pretradegroupid
      break
    end
  end
  if my_pretradegroupid == 0 then
    return false
  end
  for i, v in pairs(self.serverInfos) do
    if v.pretradegroupid == my_pretradegroupid and v.tradegroupid ~= v.pretradegroupid then
      return true
    end
  end
  return false
end
