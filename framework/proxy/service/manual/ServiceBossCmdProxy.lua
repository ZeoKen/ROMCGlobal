autoImport("ServiceBossCmdAutoProxy")
ServiceBossCmdProxy = class("ServiceBossCmdProxy", ServiceBossCmdAutoProxy)
ServiceBossCmdProxy.Instance = nil
ServiceBossCmdProxy.NAME = "ServiceBossCmdProxy"
ServiceBossCmdProxy.BossType = {
  MVP = BossCmd_pb.ESETTYPE_BOSS,
  WORLD = BossCmd_pb.ESETTYPE_WORLD,
  DEATH = BossCmd_pb.ESETTYPE_DEAD
}

function ServiceBossCmdProxy:ctor(proxyName)
  if ServiceBossCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossCmdProxy.Instance = self
  end
  self.favoriteMap = {}
end

function ServiceBossCmdProxy:RecvBossListUserCmd(data)
  local mvplist, v, new, delta = {}
  if data.bosslist ~= nil then
    for i = 1, #data.bosslist do
      v = data.bosslist[i]
      if Table_Boss[v.id] then
        new = {}
        delta = ServerTime.ServerDeltaSecondTime(v.refreshTime * 1000)
        if v.settime ~= 0 then
          if 0 < delta or v.summontime <= v.dietime and delta <= 0 then
            if Table_Boss[v.id].MvpID then
              new.id = Table_Boss[v.id].MvpID
              new.priority = 1
            else
              new.id = v.id
              new.priority = 2
            end
          else
            new.id = v.id
            new.priority = 1
          end
        else
          new.id = v.id
          new.priority = 1
        end
        local bdata = Table_Boss[new.id]
        new.staticData = bdata
        new.time = v.refreshTime
        new.killerID = v.charid
        new.killer = v.lastKiller
        new.mapid = v.mapid
        new.dietime = v.dietime
        new.bosstype = bdata.Type
        new.settime = v.settime
        new.summontime = v.summontime
        new.isspecial = v.special
        if bdata.Type == 3 then
          new.lv = v.lv
        else
          new.lv = Table_Monster[new.id].Level
        end
        new.listtype = 1
        new.ispreference = self.favoriteMap[new.id] or 0
        table.insert(mvplist, new)
      else
        errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id))
      end
    end
  end
  local deathlist = {}
  if data.deadlist then
    local len, single, sdata = #data.deadlist
    for i = 1, len do
      single = {}
      v = data.deadlist[i]
      sdata = Table_Boss[v.id]
      single.staticData = sdata
      single.id = v.id
      single.lv = v.lv
      single.killerID = v.charid
      single.time = v.refreshTime
      single.settime = v.settime
      single.killer = v.lastKiller
      single.mapid = sdata.Map[1]
      single.bosstype = sdata.Type
      single.listtype = 2
      single.priority = 1
      single.dietime = v.dietime
      single.summontime = v.summontime
      single.isspecial = v.special
      single.ispreference = self.favoriteMap[v.id] or 0
      table.insert(deathlist, single)
    end
  end
  local minilist, mdata = {}
  if data.minilist ~= nil then
    for i = 1, #data.minilist do
      v = data.minilist[i]
      mdata = Table_Boss[v.id]
      if mdata then
        new = {}
        new.id = v.id
        new.staticData = mdata
        new.time = v.refreshTime
        new.killerID = v.charid
        new.killer = v.lastKiller
        new.mapid = v.mapid
        new.bosstype = mdata.Type
        new.summontime = v.summontime
        new.listtype = 1
        new.priority = 1
        new.isspecial = v.special
        new.ispreference = self.favoriteMap[v.id] or 0
        table.insert(minilist, new)
      else
        errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id))
      end
    end
  end
  self:Notify(ServiceEvent.BossCmdBossListUserCmd, {
    mvplist,
    minilist,
    deathlist
  })
end

function ServiceBossCmdProxy:RecvBossPosUserCmd(data)
  self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end

function ServiceBossCmdProxy:RecvKillBossUserCmd(data)
  self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end

function ServiceBossCmdAutoProxy:RecvStepSyncBossCmd(data)
  QuestProxy.Instance:RecvStepSyncBossCmd(data)
  self:Notify(ServiceEvent.BossCmdStepSyncBossCmd, data)
end

function ServiceBossCmdProxy:RecvQueryFavaouiteBossCmd(data)
  redlog("RecvQueryFavaouiteBossCmd")
  if self.favoriteMap then
    TableUtility.TableClear(self.favoriteMap)
  else
    self.favoriteMap = {}
  end
  if data and data.bossids then
    local list = data.bossids
    for i = 1, #list do
      redlog("list[i]")
      self.favoriteMap[list[i]] = 1
    end
  end
  self:Notify(ServiceEvent.BossCmdQueryFavaouiteBossCmd, data)
end

function ServiceBossCmdProxy:RecvModifyFavouriteBossCmd(data)
  self:Notify(ServiceEvent.BossCmdModifyFavouriteBossCmd, data)
end

function ServiceBossCmdProxy:RecvQueryRareEliteCmd(data)
  FunctionMonster.Me():RecvQueryRareElite(data.datas)
  ServiceBossCmdProxy.super.RecvQueryRareEliteCmd(self, data)
end

function ServiceBossCmdProxy:RecvQueryRareEliteCmd(data)
  FunctionMonster.Me():RecvQueryRareElite(data.datas)
  ServiceBossCmdProxy.super.RecvQueryRareEliteCmd(self, data)
end

function ServiceBossCmdProxy:RecvQuerySpecMapRareEliteCmd(data)
  FunctionMonster.Me():RecvQueryRareElite(data.datas)
  WildMvpProxy.Instance:UpdateMonsterDatas(data)
  ServiceBossCmdProxy.super.RecvQuerySpecMapRareEliteCmd(self, data)
end

function ServiceBossCmdProxy:RecvUpdateCurMapBossCmd(data)
  WildMvpProxy.Instance:UpdateMiniMapMonsterDatas(data)
  self:Notify(ServiceEvent.BossCmdUpdateCurMapBossCmd, data)
end

local getHourFromSecond = function(sec)
  return math.floor(sec / 3600)
end
local getMinuteFromSecond = function(sec)
  return math.floor((sec - getHourFromSecond(sec) * 3600) / 60)
end

function ServiceBossCmdProxy.GetBossCommuteTimeStr(format)
  local cfg = GameConfig.CommuteBoss and GameConfig.CommuteBoss.commute_time
  if cfg then
    format = format or "%02d:%02d-%02d:%02d"
    return string.format(format, getHourFromSecond(cfg[1]), getMinuteFromSecond(cfg[1]), getHourFromSecond(cfg[2]), getMinuteFromSecond(cfg[2]))
  end
  return ""
end
