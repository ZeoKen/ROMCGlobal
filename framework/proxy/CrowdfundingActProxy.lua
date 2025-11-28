autoImport("GlobalActivityProxy")
CrowdfundingActProxy = class("CrowdfundingActProxy", GlobalActivityProxy)
CrowdfundingActProxy.NAME = "CrowdfundingActProxy"
CrowdfundingActProxy.Config = GameConfig.DonationActivity
local tempTable = {}

function CrowdfundingActProxy:AddActivity(id, startTime, endTime, participateEndTimeCfg)
  CrowdfundingActProxy.super.AddActivity(self, id, startTime, endTime)
  self.participateEndTimeMap = self.participateEndTimeMap or {}
  self.participateEndTimeMap[id] = participateEndTimeCfg[EnvChannel.IsTFBranch() and 1 or 2]
end

function CrowdfundingActProxy:RecvInfo(serverData)
  self.info = self.info or {}
  self.info.stage = serverData.stage
  self.info.showComplete = serverData.showcommpletetext
  self.info.personalDonate = serverData.donateval
  self.info.globalProgress = serverData.globalprocess
  self.info.personalAwardedIdMap = self.info.personalAwardedIdMap or {}
  self.info.globalCompleteTime = serverData.globalcompletetime
  TableUtility.TableClear(self.info.personalAwardedIdMap)
  for i = 1, #serverData.awardedpersonalid do
    self:RecordAwardedId(serverData.awardedpersonalid[i], false)
  end
  self.info.globalAwardedIdMap = self.info.globalAwardedIdMap or {}
  TableUtility.TableClear(self.info.globalAwardedIdMap)
  for i = 1, #serverData.awardedglobalid do
    self:RecordAwardedId(serverData.awardedglobalid[i], true)
  end
end

function CrowdfundingActProxy:RecordSelfDonate(num)
  if not self.info then
    LogUtility.Warning("Cannot find self.info. Is there sth wrong?")
    return
  end
  if num then
    self.info.personalDonate = self.info.personalDonate + num
  end
end

function CrowdfundingActProxy:RecordAwardedId(id, isGlobal)
  if not id then
    return
  end
  if not self.info then
    LogUtility.Warning("Cannot find self.info. Is there sth wrong?")
    return
  end
  local map = isGlobal and self.info.globalAwardedIdMap or self.info.personalAwardedIdMap
  map[id] = true
end

function CrowdfundingActProxy:GetInfo(key)
  return key and self.info and self.info[key]
end

function CrowdfundingActProxy:GetGlobalProgress()
  return self:GetInfo("globalProgress") or 0
end

function CrowdfundingActProxy:GetPersonalDonate()
  return self:GetInfo("personalDonate") or 0
end

function CrowdfundingActProxy:GetShowComplete()
  return self:GetInfo("showComplete") or false
end

function CrowdfundingActProxy:GetGlobalCompleteTime()
  return self:GetInfo("globalCompleteTime") or 0
end

function CrowdfundingActProxy:GetParticipateTimeText(id)
  local text = ""
  self:_TryActionByActId(id, function(actId, self)
    local actData = self.activityMap[actId]
    if actData then
      local startTime, endTime = actData:GetDuringTime()
      local participateEndTime = self.participateEndTimeMap and self.participateEndTimeMap[actId]
      if participateEndTime then
        endTime = participateEndTime
      else
        LogUtility.WarningFormat("Cannot get participate end time with id = {0}. Real end time will replace.", actId)
      end
      text = ServantCalendarProxy.GetTimeDate(startTime, endTime, ZhString.CrowdfundingAct_ParticipateTime)
    end
  end, self)
  return text
end

function CrowdfundingActProxy:ParticipatePredicate(id)
  local rslt = false
  self:_TryActionByActId(id, function(actId, self)
    local actData = self.activityMap[actId]
    if actData then
      local startTime = actData:GetDuringTime()
      local endTime = self.participateEndTimeMap and self.participateEndTimeMap[actId]
      if endTime then
        local nowTime = ServerTime.CurServerTime() / 1000
        rslt = startTime < nowTime and endTime >= nowTime
      else
        LogUtility.WarningFormat("Cannot get participate end time with id = {0}!!!", actId)
      end
    end
  end, self)
  return rslt
end

function CrowdfundingActProxy:ClearShowComplete()
  if self.info then
    self.info.showComplete = false
  end
end

function CrowdfundingActProxy:GetNowAvailableRewardIdMap(isGlobal)
  TableUtility.TableClear(tempTable)
  if self.showingActId then
    local cfg = GameConfig.DonationActivity[self.showingActId]
    if cfg and self.info then
      local awardedMap = isGlobal and self.info.globalAwardedIdMap or self.info.personalAwardedIdMap
      local predicate = isGlobal and function(data)
        return data.processpct <= self.info.globalProgress
      end or function(data)
        return data.processnum <= self.info.personalDonate
      end
      cfg = isGlobal and cfg.globalreward or cfg.personalreward
      for id, data in pairs(cfg) do
        if not awardedMap[id] and predicate(data) then
          tempTable[id] = true
        end
      end
    end
  end
  return tempTable
end

local queryAction = function()
  ServiceActivityCmdProxy.Instance:CallGlobalDonationActivityInfoCmd()
end

function CrowdfundingActProxy:Query(id)
  self:_TryActionByActId(id, queryAction)
end
