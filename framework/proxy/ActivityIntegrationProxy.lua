ActivityIntegrationProxy = class("ActivityIntegrationProxy", pm.Proxy)
ActivityIntegrationProxy.Instance = nil
ActivityIntegrationProxy.NAME = "ActivityIntegrationProxy"

function ActivityIntegrationProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityIntegrationProxy.NAME
  if ActivityIntegrationProxy.Instance == nil then
    ActivityIntegrationProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityIntegrationProxy:Init()
  self.activityIntegrationGroup = {}
  self.activitySignInInfo = {}
  self.activitySignInActMap = {}
  self.activityQuestInfo = {}
  self.inited = false
  self.createDay = 1
  self:InitGroupData()
end

function ActivityIntegrationProxy:InitGroupData()
  if not Table_ActivityIntegration then
    return
  end
  for k, v in pairs(Table_ActivityIntegration) do
    local groupID = v.Group
    if not self.activityIntegrationGroup[groupID] then
      self.activityIntegrationGroup[groupID] = {}
    end
    if not self.activityIntegrationGroup[groupID].activityIDs then
      self.activityIntegrationGroup[groupID].activityIDs = {}
    end
    table.insert(self.activityIntegrationGroup[groupID].activityIDs, k)
    if v.Type == 1 then
      if v.Params and v.Params.ActivityId then
        self.activityIntegrationGroup[groupID].BPID = v.Params.ActivityId
      end
    elseif v.Type == 5 then
      if v.Params then
        self.activityIntegrationGroup[groupID].FlipCardId = v.Params.ActivityId
      end
    elseif v.Type == 2 then
      if v.Params and v.Params.ActivityId then
        if not self.activityIntegrationGroup[groupID].SignInID then
          self.activityIntegrationGroup[groupID].SignInID = {}
        end
        table.insert(self.activityIntegrationGroup[groupID].SignInID, v.Params.ActivityId)
      end
    elseif v.Type == 6 then
      if v.Params and v.Params.ActivityId then
        if not self.activityIntegrationGroup[groupID].ChallengeActID then
          self.activityIntegrationGroup[groupID].ChallengeActID = {}
        end
        table.insert(self.activityIntegrationGroup[groupID].ChallengeActID, v.Params.ActivityId)
      end
    elseif v.Type == 8 then
      if v.Params and v.Params.ActivityId then
        self.activityIntegrationGroup[groupID].YearMemoryActID = v.Params.ActivityId
      end
    elseif v.Type == 10 then
      if v.Params then
        self.activityIntegrationGroup[groupID].SelfChooseActId = v.Params.ActivityId
      end
    elseif v.Type == 11 and v.Params and v.Params.ActivityId then
      if not self.activityIntegrationGroup[groupID].ExchangeActIds then
        self.activityIntegrationGroup[groupID].ExchangeActIds = {}
      end
      table.insert(self.activityIntegrationGroup[groupID].ExchangeActIds, v.Params.ActivityId)
    end
  end
end

function ActivityIntegrationProxy:GetGroupInfo(groupid)
  if self.activityIntegrationGroup[groupid] then
    return self.activityIntegrationGroup[groupid]
  end
end

function ActivityIntegrationProxy:GetActivitySignInData(actID)
  if not Table_ActivitySuperSign then
    redlog("表格不存在Table_ActivitySuperSign")
    return
  end
  local result = {}
  local serverValid = false
  for id, info in pairs(Table_ActivitySuperSign) do
    if info.ActID == actID then
      if not serverValid then
        local curServer = FunctionLogin.Me():getCurServerData()
        local curServerID = curServer.linegroup or 1
        if info.ServerID and TableUtility.ArrayFindIndex(info.ServerID, curServerID) > 0 then
          serverValid = true
        end
      end
      table.insert(result, info)
    end
  end
  table.sort(result, function(l, r)
    local l_sort = l.id or 0
    local r_sort = r.id or 0
    if l_sort ~= r_sort then
      return l_sort < r_sort
    end
  end)
  return result
end

function ActivityIntegrationProxy:GetBPActID(groupid)
  if self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].BPID then
    return self.activityIntegrationGroup[groupid].BPID
  end
end

function ActivityIntegrationProxy:GetFlipCardActID(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].FlipCardId
end

function ActivityIntegrationProxy:GetSuperSignInActID(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].SignInID
end

function ActivityIntegrationProxy:GetNewServerChallengeActID(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].ChallengeActID
end

function ActivityIntegrationProxy:GetYearMemoryActID(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].YearMemoryActID
end

function ActivityIntegrationProxy:GetSelfChooseActID(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].SelfChooseActId
end

function ActivityIntegrationProxy:GetExchangeActIDs(groupid)
  return self.activityIntegrationGroup[groupid] and self.activityIntegrationGroup[groupid].ExchangeActIds
end

function ActivityIntegrationProxy:AddSuperSignIn(actid, starttime, endtime)
  if not self.activitySignInActMap[actid] then
    self.activitySignInActMap[actid] = {}
  end
  self.activitySignInActMap[actid] = {starttime = starttime, endtime = endtime}
  self:UpdateSignInRedtip()
end

function ActivityIntegrationProxy:GetSuperSignInActInfo(actid)
  if self.activitySignInActMap[actid] then
    return self.activitySignInActMap[actid]
  end
end

function ActivityIntegrationProxy:RecvSuperSignInNtfUserCmd(data)
  local data = data.data
  if data and 0 < #data then
    for i = 1, #data do
      local single = data[i]
      local tempData = {}
      if not self.activitySignInInfo[single.actid] then
        self.activitySignInInfo[single.actid] = {}
      end
      self.activitySignInInfo[single.actid] = {
        day = single.day,
        last_sign_time = single.last_sign_time
      }
      xdlog("签到信息", single.actid, single.day, single.last_sign_time)
    end
  end
  self:UpdateSignInRedtip()
end

function ActivityIntegrationProxy:RecvSuperSignInUserCmd(data)
  local signInfo = data.sign
  if signInfo then
    if not self.activitySignInInfo[signInfo.actid] then
      self.activitySignInInfo[signInfo.actid] = {}
    end
    self.activitySignInInfo[signInfo.actid] = {
      day = signInfo.day,
      last_sign_time = signInfo.last_sign_time
    }
    xdlog("签到成功信息", signInfo.actid, signInfo.day, signInfo.last_sign_time)
  end
  self:UpdateSignInRedtip()
end

function ActivityIntegrationProxy:UpdateSignInRedtip()
  local redtipid = 10757
  local curTime = ServerTime.CurServerTime() / 1000
  local actList = {}
  for actid, actinfo in pairs(self.activitySignInActMap) do
    if not self.activitySignInInfo[actid] and curTime >= actinfo.starttime and curTime <= actinfo.endtime then
      local signInList = self:GetActivitySignInData(actid)
      if signInList and signInList[1] and signInList[1].DailyServantNum then
        local finishCount = ServantRecommendProxy.Instance:GetRecommendFinishCountByType(1)
        if finishCount >= signInList[1].DailyServantNum then
          table.insert(actList, actid)
        end
      else
        table.insert(actList, actid)
      end
    end
  end
  for actid, info in pairs(self.activitySignInInfo) do
    local entranceValid = false
    for groupid, info in pairs(self.activityIntegrationGroup) do
      if info.SignInID and TableUtility.ArrayFindIndex(info.SignInID, actid) > 0 and self:CheckGroupValid(groupid) and self:CheckSuperSignInCanSign(actid) then
        table.insert(actList, actid)
      end
    end
  end
  if 0 < #actList then
    RedTipProxy.Instance:UpdateRedTip(redtipid, actList)
  else
    RedTipProxy.Instance:RemoveWholeTip(redtipid)
  end
end

function ActivityIntegrationProxy:GetSuperSignInInfo(actid)
  if not self.activitySignInInfo[actid] then
    return
  end
  return self.activitySignInInfo[actid]
end

function ActivityIntegrationProxy:CheckSuperSignInFinish(actid)
  local signInInfo = self:GetSuperSignInInfo(actid)
  if not signInInfo then
    return false
  end
  local day = signInInfo.day or 0
  local signInList = self:GetActivitySignInData(actid) or {}
  if day >= #signInList then
    return true
  else
    return false
  end
end

ActivityIntegrationProxy.SignInStatus = {
  CanSign = 1,
  Signed = 2,
  DailyServantNum = 3
}

function ActivityIntegrationProxy:CheckSuperSignInCanSign(actid)
  local signInInfo = self:GetSuperSignInInfo(actid)
  local signInList = self:GetActivitySignInData(actid) or {}
  local day = signInInfo and signInInfo.day or 0
  if not signInInfo then
    local actInfo = self:GetSuperSignInActInfo(actid)
    if not actInfo then
      return false
    else
      local startTime = actInfo.starttime
      local endTime = actInfo.endtime
      local curTimeStamp = ServerTime.CurServerTime() / 1000
      if startTime <= curTimeStamp and endTime >= curTimeStamp then
        if signInList[day + 1] and signInList[day + 1].DailyServantNum then
          local finishCount = ServantRecommendProxy.Instance:GetRecommendFinishCountByType(1)
          if finishCount < signInList[day + 1].DailyServantNum then
            redlog("不成", signInList[day + 1].DailyServantNum)
            return false, ActivityIntegrationProxy.SignInStatus.DailyServantNum, finishCount, signInList[day + 1].DailyServantNum
          end
        end
        xdlog("可以签到")
        return true, ActivityIntegrationProxy.SignInStatus.CanSign
      end
    end
    redlog("false")
    return false
  end
  if day < #signInList then
    local lastSignTime = signInInfo.last_sign_time
    if lastSignTime then
      local curTimeStamp = ServerTime.CurServerTime() / 1000
      local lastDailyRefresh = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(lastSignTime)
      local newDailyRefresh = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(curTimeStamp)
      if lastDailyRefresh < newDailyRefresh then
        if signInList[day + 1] and signInList[day + 1].DailyServantNum then
          local finishCount = ServantRecommendProxy.Instance:GetRecommendFinishCountByType(1)
          if finishCount < signInList[day + 1].DailyServantNum then
            return false, ActivityIntegrationProxy.SignInStatus.DailyServantNum, finishCount, signInList[day + 1].DailyServantNum
          end
        end
        return true
      end
    end
  else
    return false, ActivityIntegrationProxy.SignInStatus.Signed
  end
end

function ActivityIntegrationProxy:CallSignInUserCmd(actid)
  if not actid then
    return
  end
  local curInfo = self:GetSuperSignInInfo(actid)
  local nextDay = curInfo and curInfo.day and curInfo.day + 1 or 1
  local data = {actid = actid, day = nextDay}
  xdlog("申请签到", data.actid, data.day)
  ServiceSceneUser3Proxy.Instance:CallSuperSignInUserCmd(data)
end

function ActivityIntegrationProxy:RecvActPersonalTimeSyncCmd(data)
  if not self.activityTaskActMap then
    self.activityTaskActMap = {}
  end
  local actTimes = data.act_times
  if actTimes and 0 < #actTimes then
    for i = 1, #actTimes do
      local single = actTimes[i]
      self.activityTaskActMap[single.act_id] = {
        starttime = single.start_time,
        endtime = single.end_time
      }
    end
  end
  local createDay = data.acc_create_char_day or 1
  self.createDay = createDay
  xdlog("玩家账号已建号时间", createDay)
end

function ActivityIntegrationProxy:GetActPersonalActInfo(actid)
  if self.activityTaskActMap and self.activityTaskActMap[actid] then
    return self.activityTaskActMap[actid]
  end
end

function ActivityIntegrationProxy:CheckActPersinalActValid(actid)
  local createDayValid = self:CheckActPersonalCreateDay(actid)
  if not createDayValid then
    return false
  end
  local actInfo = self:GetActPersonalActInfo(actid)
  if not actInfo then
    return false
  end
  local menuUnlock = self:CheckMenuUnlock(actid)
  if not menuUnlock then
    return false
  end
  local startTime = actInfo.starttime
  local endTime = actInfo.endtime
  if startTime and endTime then
    local curTime = ServerTime.CurServerTime() / 1000
    if startTime < curTime and endTime > curTime then
      return true
    else
      return false
    end
  end
  return false
end

function ActivityIntegrationProxy:CheckActPersonalCreateDay(actid)
  local actStaticData = Table_ActPersonalTimer[actid]
  if actStaticData and actStaticData.OpenOnAccDay then
    if actStaticData.OpenOnAccDay <= self.createDay then
      if actStaticData.CloseOnAccDay and actStaticData.CloseOnAccDay < self.createDay then
        return false
      else
        return true
      end
    end
  else
    return true
  end
end

function ActivityIntegrationProxy:IsActBasedOnCreateDay(actid)
  local actStaticData = Table_ActPersonalTimer[actid]
  if actStaticData and actStaticData.OpenOnAccDay then
    return true
  end
  return false
end

function ActivityIntegrationProxy:GetUnlockTime(openOnDay)
  local offsetDay = openOnDay - self.createDay
  local openTime = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(ServerTime.CurServerTime() / 1000 + 86400 * (offsetDay - 1))
  return openTime
end

function ActivityIntegrationProxy:CheckMenuUnlock(actid)
  local actStaticData = Table_ActPersonalTimer[actid]
  local menuID = actStaticData and actStaticData.OpenOnMenuUnlock
  if menuID and not FunctionUnLockFunc.Me():CheckCanOpen(menuID) then
    return false
  end
  return true
end

function ActivityIntegrationProxy:RecvNewServerChallengeSyncCmd(data)
  if not self.actChallengeInfo then
    self.actChallengeInfo = {}
  end
  local actId = data.act_id
  local list = self.actChallengeInfo[actId] or {}
  local targets = data.targets
  if targets and 0 < #targets then
    for i = 1, #targets do
      local single = targets[i]
      list[single.id] = {
        id = single.id,
        process = single.process,
        state = single.state
      }
    end
  end
  self.actChallengeInfo[actId] = list
end

function ActivityIntegrationProxy:GetChallengeProcessList(actid)
  if self.actChallengeInfo and self.actChallengeInfo[actid] then
    return self.actChallengeInfo[actid]
  end
end

function ActivityIntegrationProxy:IsChallengeAllFinish(actid)
  local actInfo = self:GetChallengeProcessList(actid)
  if actInfo then
    for k, v in pairs(actInfo) do
      local state = v.state
      if state == 0 or state == 1 then
        return false
      end
    end
  else
    return false
  end
  return true
end

function ActivityIntegrationProxy:RecvQueryQuestSignInfoUserCmd(data)
  local groupid = data.groupid
  if not self.activityQuestInfo[groupid] then
    self.activityQuestInfo[groupid] = {}
  end
  local datas = data.data
  if datas and 0 < #datas then
    for i = 1, #datas do
      local single = datas[i]
      self.activityQuestInfo[groupid][single.questid] = single.status
    end
  end
end

function ActivityIntegrationProxy:GetQuestSignInfo(groupid)
  if self.activityQuestInfo and self.activityQuestInfo[groupid] then
    return self.activityQuestInfo[groupid]
  end
end

function ActivityIntegrationProxy:CheckGroupValid(groupid)
  local groupInfo = self:GetGroupInfo(groupid)
  if not groupInfo then
    return false
  end
  local activityIDs = groupInfo and groupInfo.activityIDs
  local isTF = EnvChannel.IsTFBranch()
  local overallStartTime, overallEndTime, isValid
  local curServer = FunctionLogin.Me():getCurServerData()
  local curServerID = curServer.linegroup or 1
  for i = 1, #activityIDs do
    local activityID = activityIDs[i]
    local staticData = Table_ActivityIntegration[activityID]
    local type = staticData and staticData.Type
    if type == 1 then
      local activityId = staticData.Params.ActivityId
      local startTime = ActivityBattlePassProxy.Instance:GetStartTime(activityId)
      local endTime = ActivityBattlePassProxy.Instance:GetEndTime(activityId)
      if not overallStartTime or startTime and overallStartTime > startTime then
        overallStartTime = startTime
      end
      if not overallEndTime or endTime and overallEndTime < endTime then
        overallEndTime = endTime
      end
    elseif type == 2 then
      local actID = staticData.Params.ActivityId
      local isSignFinish = self:CheckSuperSignInFinish(actID)
      if not isSignFinish then
        local serverValid = true
        local serverList = staticData.ServerID
        if serverList and 0 < #serverList and TableUtility.ArrayFindIndex(serverList, curServerID) == 0 then
          serverValid = false
        end
        if serverValid then
          local actData = self:GetSuperSignInActInfo(actID)
          if actData then
            local activityStart = actData.starttime
            local activityEnd = actData.endtime
            if activityStart and activityEnd then
              if not overallStartTime or overallStartTime > activityStart then
                overallStartTime = activityStart
              end
              if not overallEndTime or overallEndTime < activityEnd then
                overallEndTime = activityEnd
              end
            end
          else
            local duration = isTF and staticData.TFDuration or staticData.Duration
            if duration and duration ~= _EmptyTable then
              local startTime, endTime
              startTime = duration[1]
              endTime = duration[2]
              startTime = startTime and startTime ~= "" and KFCARCameraProxy.Instance:GetSelfCustomDate(startTime)
              if endTime and endTime ~= "" then
                endTime = KFCARCameraProxy.Instance:GetSelfCustomDate(endTime)
              else
                local canSign = self:CheckSuperSignInCanSign(actid)
                if canSign then
                  endTime = ServerTime.CurServerTime() / 1000 + 86400
                else
                  endTime = startTime
                end
              end
              if not overallStartTime or overallStartTime > startTime then
                overallStartTime = startTime
              end
              if not overallEndTime or overallEndTime < endTime then
                overallEndTime = endTime
              end
            end
          end
        end
      end
    elseif type == 6 then
      local activityId = staticData.Params.ActivityId
      local timeValid = ActivityIntegrationProxy.Instance:CheckActPersinalActValid(activityId)
      if timeValid then
        local actPersonalData = Table_ActPersonalTimer[activityId]
        local createDayBase = self:IsActBasedOnCreateDay(activityId)
        if createDayBase and not actPersonalData.CloseDay then
          local allFinish = self:IsChallengeAllFinish(activityId)
          if not allFinish then
            local closeOnDay = actPersonalData and actPersonalData.CloseOnAccDay
            local openOnDay = actPersonalData and actPersonalData.OpenOnAccDay
            if openOnDay then
              local createDay = self.createDay or 1
              local startTime = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(ServerTime.CurServerTime() / 1000 - 86400 * (createDay - openOnDay + 1))
              if not overallStartTime or overallStartTime > startTime then
                overallStartTime = startTime
              end
              if closeOnDay then
                local endTime = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(ServerTime.CurServerTime() / 1000 + 86400 * (closeOnDay - createDay))
                if not overallEndTime or overallEndTime < endTime then
                  overallEndTime = endTime
                end
              elseif not overallEndTime or overallEndTime < ServerTime.CurServerTime() / 1000 + 86400 then
                overallEndTime = ServerTime.CurServerTime() / 1000 + 86400
              end
            else
              redlog("没有建号时间")
            end
          end
        else
          local actData = self:GetActPersonalActInfo(activityId)
          if actData then
            local activityStart = actData.starttime
            local activityEnd = actData.endtime
            if activityStart and activityEnd then
              if not overallStartTime or overallStartTime > activityStart then
                overallStartTime = activityStart
              end
              if not overallEndTime or overallEndTime < activityEnd then
                overallEndTime = activityEnd
              end
            end
          end
        end
      end
    elseif type == 10 then
      local activityId = staticData.Params.ActivityId
      local startTime = ActivitySelfChooseProxy.Instance:GetStartTime(activityId)
      local endTime = ActivitySelfChooseProxy.Instance:GetEndTime(activityId)
      local isAvailable = ActivitySelfChooseProxy.Instance:IsActivityAvailable(activityId)
      isValid = isValid or isAvailable
      if not overallStartTime or startTime and overallStartTime > startTime then
        overallStartTime = startTime
      end
      if not overallEndTime or endTime and overallEndTime < endTime then
        overallEndTime = endTime
      end
    else
      local serverValid = true
      local serverList = staticData.ServerID
      if serverList and 0 < #serverList and TableUtility.ArrayFindIndex(serverList, curServerID) == 0 then
        serverValid = false
      end
      if serverValid then
        local duration = isTF and staticData.TFDuration or staticData.Duration
        if duration then
          local startTime, endTime
          startTime = duration[1]
          endTime = duration[2]
          startTime = startTime and KFCARCameraProxy.Instance:GetSelfCustomDate(startTime)
          endTime = endTime and KFCARCameraProxy.Instance:GetSelfCustomDate(endTime)
          if not overallStartTime or overallStartTime > startTime then
            overallStartTime = startTime
          end
          if not overallEndTime or overallEndTime < endTime then
            overallEndTime = endTime
          end
        end
      end
    end
  end
  if overallStartTime and overallEndTime then
    local curTime = ServerTime.CurServerTime() / 1000
    if overallStartTime < curTime and overallEndTime > curTime then
      return true
    end
  else
    return isValid
  end
  return false
end

function ActivityIntegrationProxy:CheckSubTabValid(tabid)
  local staticData = Table_ActivityIntegration[tabid]
  if not staticData then
    return
  end
  local isTF = EnvChannel.IsTFBranch()
  local type = staticData.Type
  if type == 1 then
    local activityId = staticData.Params.ActivityId
    local timeValid = ActivityBattlePassProxy.Instance:IsBPAvailable(activityId)
    return timeValid
  elseif type == 2 then
    local activityId = staticData.Params.ActivityId
    local signInFinish = self:CheckSuperSignInFinish(activityId)
    if signInFinish then
      return false
    end
    local actData = self:GetSuperSignInActInfo(activityId)
    if actData then
      return true
    end
    local canSign = self:CheckSuperSignInCanSign(activityId)
    if not canSign then
      return false
    end
    return true
  elseif type == 5 then
    local activityId = staticData.Params.ActivityId
    local timeValid = ActivityFlipCardProxy.Instance:IsActivityAvailable(activityId)
    return timeValid
  elseif type == 6 then
    local activityId = staticData.Params.ActivityId
    local timeValid = self:CheckActPersinalActValid(activityId)
    local actPersonalData = Table_ActPersonalTimer[activityId]
    local createDayBase = self:IsActBasedOnCreateDay(activityId)
    if createDayBase then
      local allFinish = self:IsChallengeAllFinish(activityId)
      if allFinish then
        if actPersonalData.CloseDay then
          local actInfo = self:GetActPersonalActInfo(activityId)
          local endTime = actInfo.endtime
          local curTime = ServerTime.CurServerTime() / 1000
          if endTime < curTime then
            return false
          end
        end
        return false
      else
        local closeOnDay = actPersonalData and actPersonalData.CloseOnAccDay
        if closeOnDay then
          local startTime = self:GetUnlockTime(actPersonalData.OpenOnAccDay)
          local endTime = self:GetUnlockTime(closeOnDay)
          local curTime = ServerTime.CurServerTime() / 1000
          if endTime < curTime then
            return false
          end
        end
      end
    end
    return timeValid
  else
    return true
  end
end
