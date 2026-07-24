SnowRealmActivityProxy = class("SnowRealmActivityProxy", pm.Proxy)
SnowRealmActivityProxy.Instance = nil
SnowRealmActivityProxy.NAME = "SnowRealmActivityProxy"

function SnowRealmActivityProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SnowRealmActivityProxy.NAME
  if SnowRealmActivityProxy.Instance == nil then
    SnowRealmActivityProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.activityInfo = {
    stage = 1,
    curPlayerNum = 0,
    maxPlayerNum = 0,
    maxMonsterNum = 0,
    killedMonsterNum = 0,
    bossGuid = 0,
    targetTime = nil,
    is_finish = false
  }
  self.damageRanks = {}
  self.isActive = false
end

function SnowRealmActivityProxy:SetActive(active)
  self.isActive = active and true or false
end

function SnowRealmActivityProxy:IsActive()
  return self.isActive == true
end

function SnowRealmActivityProxy:UpdateActivityInfo(data)
  if not data then
    return
  end
  redlog("SnowRealmActivityProxy:UpdateActivityInfo stage = " .. data.stage, "is_finish = " .. tostring(data.is_finish))
  local info = self.activityInfo
  info.stage = data.stage
  info.curPlayerNum = data.transformed_user
  info.maxPlayerNum = data.total_user
  info.maxMonsterNum = data.total_monster
  info.killedMonsterNum = data.killed_monster
  info.bossGuid = data.boss_guid
  info.targetTime = data.end_time
  if data.is_finish ~= nil then
    info.is_finish = data.is_finish
  end
end

function SnowRealmActivityProxy:GetActivityInfo()
  return self.activityInfo
end

function SnowRealmActivityProxy:GetStage()
  return self.activityInfo and self.activityInfo.stage or 1
end

function SnowRealmActivityProxy:GetCurPlayerNum()
  return self.activityInfo and self.activityInfo.curPlayerNum or 0
end

function SnowRealmActivityProxy:GetMaxPlayerNum()
  return self.activityInfo and self.activityInfo.maxPlayerNum or 0
end

function SnowRealmActivityProxy:GetMaxMonsterNum()
  return self.activityInfo and self.activityInfo.maxMonsterNum or 0
end

function SnowRealmActivityProxy:GetKilledMonsterNum()
  return self.activityInfo and self.activityInfo.killedMonsterNum or 0
end

function SnowRealmActivityProxy:GetBossGuid()
  return self.activityInfo and self.activityInfo.bossGuid or 0
end

function SnowRealmActivityProxy:GetTargetTime()
  return self.activityInfo and self.activityInfo.targetTime
end

function SnowRealmActivityProxy:GetCountDownTime()
  local targetTime = self:GetTargetTime()
  if not targetTime then
    return 0
  end
  return math.max(0, targetTime - ServerTime.CurServerTime() / 1000)
end

function SnowRealmActivityProxy:UpdateDamageRanks(rankData)
  TableUtility.ArrayClear(self.damageRanks)
  if not rankData then
    return
  end
  for i = 1, #rankData do
    local single = rankData[i]
    self.damageRanks[#self.damageRanks + 1] = {
      id = single.charid,
      rank = i,
      name = single.charname or ""
    }
  end
end

function SnowRealmActivityProxy:GetDamageRanks()
  return self.damageRanks
end
