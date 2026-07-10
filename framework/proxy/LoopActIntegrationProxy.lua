LoopActIntegrationProxy = class("LoopActIntegrationProxy", BaseProxy)
LoopActIntegrationProxy.Instance = nil
LoopActIntegrationProxy.NAME = "LoopActIntegrationProxy"
autoImport("FunctionActivity")

function LoopActIntegrationProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LoopActIntegrationProxy.NAME
  if LoopActIntegrationProxy.Instance == nil then
    LoopActIntegrationProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function LoopActIntegrationProxy:Init()
  self.activityGroups = {}
  self:InitActivityGroups()
end

function LoopActIntegrationProxy:GetAreaAndServerName()
  local branchName = BranchMgr.Get_EAREA()
  if branchName == "CH" and ISNoviceServerType then
    branchName = "NOCH"
  elseif branchName == "NOTW" then
    branchName = "NO"
  elseif branchName == "NOEN" then
    branchName = "NONA"
  end
  return branchName
end

function LoopActIntegrationProxy:CheckAreaAndServerValid(staticData, branchName)
  local areaAndServer = staticData and staticData.AreaAndServer
  if not areaAndServer or #areaAndServer <= 0 then
    return false
  end
  return 0 < TableUtility.ArrayFindIndex(areaAndServer, branchName or self:GetAreaAndServerName())
end

function LoopActIntegrationProxy:CheckRoleLevelValid(staticData)
  local roleLevel = staticData and staticData.RoleLevel
  if not roleLevel then
    return true
  end
  return roleLevel <= MyselfProxy.Instance:RoleLevel()
end

function LoopActIntegrationProxy:InitActivityGroups()
  if not Table_ActivityNew then
    return
  end
  self.activityGroups = {}
  for actID, config in pairs(Table_ActivityNew) do
    local groupID = config.Group
    if groupID then
      if not self.activityGroups[groupID] then
        self.activityGroups[groupID] = {
          activityIDs = {},
          config = config
        }
      end
      table.insert(self.activityGroups[groupID].activityIDs, actID)
    end
  end
end

function LoopActIntegrationProxy:GetGroupInfo(groupID)
  local groupInfo = self.activityGroups[groupID]
  if not groupInfo then
    return nil
  end
  local filteredActivityIDs = {}
  local bannerActivityID
  local currentTime = ServerTime.CurServerTime() / 1000
  local isTF = EnvChannel.IsTFBranch()
  local branchName = self:GetAreaAndServerName()
  for i = 1, #groupInfo.activityIDs do
    local activityID = groupInfo.activityIDs[i]
    local staticData = Table_ActivityNew[activityID]
    if staticData then
      local tfDayInAdvance = staticData.TfDayInAdvance or 0
      local currentTimeForBaseCompare = currentTime
      if isTF and 0 < tfDayInAdvance then
        currentTimeForBaseCompare = currentTime + tfDayInAdvance * 86400
      end
      local serverValid = self:CheckAreaAndServerValid(staticData, branchName)
      local roleLevelValid = self:CheckRoleLevelValid(staticData)
      if staticData.Type == "banner" and serverValid and roleLevelValid then
        local timeValid, realStartTime, realEndTime = self:CheckTimeValid(staticData)
        if timeValid then
          local baseStartTime = self:ParseDateTime(staticData.StartTime)
          local shouldUse = false
          if not bannerActivityID then
            shouldUse = true
          else
            local existingBanner = Table_ActivityNew[bannerActivityID]
            if existingBanner then
              local existingValid, existingStartTime, existingEndTime = self:CheckTimeValid(existingBanner)
              local existingBaseStartTime = self:ParseDateTime(existingBanner.StartTime)
              if baseStartTime and existingBaseStartTime and realStartTime and realEndTime and existingStartTime and existingEndTime then
                local currentInPeriod = currentTime >= realStartTime and currentTime <= realEndTime
                local existingInPeriod = currentTime >= existingStartTime and currentTime <= existingEndTime
                if currentInPeriod and not existingInPeriod then
                  shouldUse = true
                elseif not currentInPeriod and existingInPeriod then
                  shouldUse = false
                else
                  local currentIsFuture = currentTimeForBaseCompare <= baseStartTime
                  local existingIsFuture = currentTimeForBaseCompare <= existingBaseStartTime
                  if currentIsFuture and not existingIsFuture then
                    shouldUse = true
                  elseif not currentIsFuture and existingIsFuture then
                    shouldUse = false
                  elseif currentIsFuture and existingIsFuture then
                    shouldUse = realStartTime < existingStartTime
                  else
                    shouldUse = realStartTime < existingStartTime
                  end
                end
              else
                shouldUse = realStartTime and existingStartTime and realStartTime < existingStartTime
              end
            end
          end
          if shouldUse then
            bannerActivityID = activityID
          end
        end
      elseif serverValid and roleLevelValid then
        if staticData.Cycle and staticData.Cycle ~= "" then
          local timeValid, realStartTime, realEndTime = self:CheckTimeValid(staticData)
          if timeValid then
            table.insert(filteredActivityIDs, activityID)
          elseif self:CheckActivityValid(activityID) then
            table.insert(filteredActivityIDs, activityID)
          end
        else
          local startTime = staticData.StartTime
          startTime = KFCARCameraProxy.Instance:GetSelfCustomDate(startTime)
          if not startTime or currentTimeForBaseCompare >= startTime then
            table.insert(filteredActivityIDs, activityID)
          end
        end
      end
    end
  end
  return {
    activityIDs = filteredActivityIDs,
    bannerActivityID = bannerActivityID,
    config = groupInfo.config
  }
end

function LoopActIntegrationProxy:CheckGroupValid(groupID)
  local groupInfo = self:GetGroupInfo(groupID)
  if not groupInfo or not groupInfo.activityIDs then
    redlog("分组信息不存在", groupID)
    return false
  end
  local activityIDs = groupInfo.activityIDs or {}
  local hasValidActivity = 0 < #activityIDs
  return hasValidActivity
end

function LoopActIntegrationProxy:GetAllGroupShowInfo()
  if not Table_ActivityNew then
    return {}
  end
  local groupShowInfos = {}
  local currentTime = ServerTime.CurServerTime() / 1000
  local candidateBanners = {}
  for _id, _config in pairs(Table_ActivityNew) do
    if _config.Type == "banner" then
      local groupID = _config.Group
      if groupID then
        local serverValid = self:CheckAreaAndServerValid(_config)
        local roleLevelValid = self:CheckRoleLevelValid(_config)
        local timeValid, realStartTime, realEndTime = self:CheckTimeValid(_config)
        if serverValid and roleLevelValid and realStartTime then
          local paramsInte = _config.Params_Inte or {}
          if not candidateBanners[groupID] then
            candidateBanners[groupID] = {}
          end
          table.insert(candidateBanners[groupID], {
            config = _config,
            activityID = _id,
            realStartTime = realStartTime,
            realEndTime = realEndTime,
            activityName = paramsInte.ActivityName or "循环活动",
            activityIcon = paramsInte.ActivityIcon or "tab_icon_temp",
            baseStartTime = self:ParseDateTime(_config.StartTime)
          })
        end
      end
    end
  end
  for groupID, candidates in pairs(candidateBanners) do
    if 0 < #candidates then
      table.sort(candidates, function(a, b)
        if not (a.baseStartTime and b.baseStartTime and a.realStartTime and b.realStartTime and a.realEndTime) or not b.realEndTime then
          return false
        end
        local aInPeriod = currentTime >= a.realStartTime and currentTime <= a.realEndTime
        local bInPeriod = currentTime >= b.realStartTime and currentTime <= b.realEndTime
        if aInPeriod and not bInPeriod then
          return true
        elseif not aInPeriod and bInPeriod then
          return false
        end
        local aIsFuture = a.baseStartTime >= currentTime
        local bIsFuture = b.baseStartTime >= currentTime
        if aIsFuture and not bIsFuture then
          return true
        elseif not aIsFuture and bIsFuture then
          return false
        else
          return a.realStartTime < b.realStartTime
        end
      end)
      local best = candidates[1]
      groupShowInfos[groupID] = {
        config = best.config,
        activityID = best.activityID,
        realStartTime = best.realStartTime,
        realEndTime = best.realEndTime,
        activityName = best.activityName,
        activityIcon = best.activityIcon
      }
    end
  end
  return groupShowInfos
end

function LoopActIntegrationProxy:GetGroupShowInfo(groupID)
  if not groupID then
    return nil
  end
  local allShowInfos = self:GetAllGroupShowInfo()
  return allShowInfos[groupID]
end

function LoopActIntegrationProxy:ParseDateTime(dateTimeStr)
  if not dateTimeStr or dateTimeStr == "" then
    return nil
  end
  local year, month, day, hour, min, sec = string.match(dateTimeStr, "(%d+)%-(%d+)%-(%d+)%s+(%d+):(%d+):(%d+)")
  if not year then
    return nil
  end
  return os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec)
  })
end

function LoopActIntegrationProxy:GetMaxDayInMonth(year, month)
  local daysInMonth = {
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  }
  if month == 2 then
    if year % 4 == 0 and year % 100 ~= 0 or year % 400 == 0 then
      return 29
    else
      return 28
    end
  end
  return daysInMonth[month] or 31
end

function LoopActIntegrationProxy:ConvertToGameDay(timestamp)
  local refreshTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(timestamp)
  if timestamp >= refreshTime then
    return refreshTime
  end
  return refreshTime - 86400
end

function LoopActIntegrationProxy:CheckTimeValid(config)
  local isTF = EnvChannel.IsTFBranch()
  local startTimeStr = config.StartTime
  local endTimeStr = config.EndTime
  local cycle = config.Cycle
  local tfDayInAdvance = config.TfDayInAdvance or 0
  if not (startTimeStr and startTimeStr ~= "" and endTimeStr) or endTimeStr == "" then
    return false, nil, nil
  end
  local baseStartTime = self:ParseDateTime(startTimeStr)
  local baseEndTime = self:ParseDateTime(endTimeStr)
  if not baseStartTime or not baseEndTime then
    redlog("时间格式错误", config.id, startTimeStr, endTimeStr)
    return false, nil, nil
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  if isTF and 0 < tfDayInAdvance then
    baseStartTime = baseStartTime - tfDayInAdvance * 86400
    baseEndTime = baseEndTime - tfDayInAdvance * 86400
  end
  if not cycle or cycle == "" then
    if currentTime >= baseStartTime and currentTime <= baseEndTime then
      return true, baseStartTime, baseEndTime
    end
    return false, nil, nil
  end
  local baseStartDate = ServerTime.Ori_OsDate("*t", baseStartTime)
  local baseEndDate = ServerTime.Ori_OsDate("*t", baseEndTime)
  if cycle == "monthly" then
    local realStartTime, realEndTime = self:CalculateMonthlyTime(baseStartDate, baseEndDate, true, config, nil)
    if realStartTime and realEndTime then
      if currentTime < realStartTime then
        return false, realStartTime, realEndTime
      end
      if currentTime >= realStartTime and currentTime <= realEndTime then
        return true, realStartTime, realEndTime
      elseif baseStartTime <= realStartTime then
        return false, realStartTime, realEndTime
      end
    end
  elseif cycle == "yearly" then
    local realStartTime, realEndTime = self:CalculateYearlyTime(baseStartDate, baseEndDate, true, config, nil)
    if realStartTime and realEndTime then
      if currentTime < realStartTime then
        return false, realStartTime, realEndTime
      end
      if currentTime >= realStartTime and currentTime <= realEndTime then
        return true, realStartTime, realEndTime
      elseif baseStartTime <= realStartTime then
        return false, realStartTime, realEndTime
      end
    end
  elseif cycle == "seasonly" then
    local realStartTime, realEndTime = self:CalculateSeasonlyTime(baseStartDate, baseEndDate, true, config, nil)
    if realStartTime and realEndTime then
      if currentTime < realStartTime then
        return false, realStartTime, realEndTime
      end
      if currentTime >= realStartTime and currentTime <= realEndTime then
        return true, realStartTime, realEndTime
      elseif baseStartTime <= realStartTime then
        return false, realStartTime, realEndTime
      end
    end
  end
  return false, nil, nil
end

function LoopActIntegrationProxy:CalculateMonthlyTime(baseStartDate, baseEndDate, checkCurrentTime, config, targetDate)
  if checkCurrentTime == nil then
    checkCurrentTime = true
  end
  local currentDate = targetDate
  if currentDate == nil then
    local currentTime = ServerTime.CurServerTime() / 1000
    currentDate = ServerTime.Ori_OsDate("*t", currentTime)
  end
  local durationDays = baseEndDate.day - baseStartDate.day
  local durationMonths = (baseEndDate.year - baseStartDate.year) * 12 + (baseEndDate.month - baseStartDate.month)
  local targetYear = currentDate.year
  local targetMonth = currentDate.month
  if checkCurrentTime then
    local currentTimestamp = ServerTime.Ori_OsTime(currentDate)
    local bestStartTime, bestEndTime, bestStartTimeDiff
    local baseStartTime = ServerTime.Ori_OsTime(baseStartDate)
    local baseEndTime = ServerTime.Ori_OsTime(baseEndDate)
    local currentGameDay = self:ConvertToGameDay(currentTimestamp)
    local baseStartGameDay = self:ConvertToGameDay(baseStartTime)
    if currentGameDay < baseStartGameDay then
      return baseStartTime, baseEndTime
    end
    local testYear = baseStartDate.year
    local testMonth = baseStartDate.month
    while testYear < currentDate.year or testYear == currentDate.year and testMonth <= currentDate.month + 1 do
      local startDay = baseStartDate.day
      local endDay = baseEndDate.day
      local endMonth = testMonth + durationMonths
      local endYear = testYear
      while 12 < endMonth do
        endMonth = endMonth - 12
        endYear = endYear + 1
      end
      while endMonth < 1 do
        endMonth = endMonth + 12
        endYear = endYear - 1
      end
      local maxDayInStartMonth = self:GetMaxDayInMonth(testYear, testMonth)
      if startDay > maxDayInStartMonth then
        startDay = maxDayInStartMonth
      end
      local maxDayInEndMonth = self:GetMaxDayInMonth(endYear, endMonth)
      if endDay > maxDayInEndMonth then
        endDay = maxDayInEndMonth
      end
      local realStartTime = ServerTime.Ori_OsTime({
        year = testYear,
        month = testMonth,
        day = startDay,
        hour = baseStartDate.hour,
        min = baseStartDate.min,
        sec = baseStartDate.sec
      })
      local realEndTime = ServerTime.Ori_OsTime({
        year = endYear,
        month = endMonth,
        day = endDay,
        hour = baseEndDate.hour,
        min = baseEndDate.min,
        sec = baseEndDate.sec
      })
      local currentGameDay = self:ConvertToGameDay(currentTimestamp)
      local startGameDay = self:ConvertToGameDay(realStartTime)
      local endGameDay = self:ConvertToGameDay(realEndTime)
      if currentGameDay >= startGameDay and currentGameDay <= endGameDay then
        return realStartTime, realEndTime
      end
      if currentTimestamp < realStartTime and (bestStartTimeDiff == nil or bestStartTime > realStartTime) then
        bestStartTime = realStartTime
        bestEndTime = realEndTime
        bestStartTimeDiff = realStartTime - currentTimestamp
      end
      testMonth = testMonth + 1
      if 12 < testMonth then
        testMonth = 1
        testYear = testYear + 1
      end
      if testYear > currentDate.year + 10 then
        break
      end
    end
    if bestStartTime and bestEndTime then
      return bestStartTime, bestEndTime
    end
    return nil, nil
  else
    local startDay = baseStartDate.day
    local endDay = baseEndDate.day
    local testYear = baseStartDate.year
    local testMonth = baseStartDate.month
    while targetYear > testYear or testYear == targetYear and targetMonth >= testMonth do
      local endMonth = testMonth + durationMonths
      local endYear = testYear
      if 12 < endMonth then
        endMonth = endMonth - 12
        endYear = endYear + 1
      end
      local inCycle = false
      if testYear == targetYear and testMonth == targetMonth then
        inCycle = true
      elseif endYear == targetYear and endMonth == targetMonth then
        inCycle = true
      elseif targetYear > testYear and targetYear < endYear then
        inCycle = true
      elseif testYear == targetYear and endYear == targetYear then
        if targetMonth >= testMonth and targetMonth <= endMonth then
          inCycle = true
        end
      elseif testYear == targetYear and targetYear < endYear then
        if targetMonth >= testMonth then
          inCycle = true
        end
      elseif targetYear > testYear and endYear == targetYear and targetMonth <= endMonth then
        inCycle = true
      end
      if inCycle then
        local maxDayInStartMonth = self:GetMaxDayInMonth(testYear, testMonth)
        local actualStartDay = startDay
        if maxDayInStartMonth < actualStartDay then
          actualStartDay = maxDayInStartMonth
        end
        local maxDayInEndMonth = self:GetMaxDayInMonth(endYear, endMonth)
        local actualEndDay = endDay
        if maxDayInEndMonth < actualEndDay then
          actualEndDay = maxDayInEndMonth
        end
        local realStartTime = ServerTime.Ori_OsTime({
          year = testYear,
          month = testMonth,
          day = actualStartDay,
          hour = baseStartDate.hour,
          min = baseStartDate.min,
          sec = baseStartDate.sec
        })
        local realEndTime = ServerTime.Ori_OsTime({
          year = endYear,
          month = endMonth,
          day = actualEndDay,
          hour = baseEndDate.hour,
          min = baseEndDate.min,
          sec = baseEndDate.sec
        })
        return realStartTime, realEndTime
      end
      testMonth = testMonth + 1
      if 12 < testMonth then
        testMonth = 1
        testYear = testYear + 1
      end
      if testYear > targetYear + 1 then
        break
      end
    end
    return nil, nil
  end
end

function LoopActIntegrationProxy:CalculateYearlyTime(baseStartDate, baseEndDate, checkCurrentTime, config, targetDate)
  if checkCurrentTime == nil then
    checkCurrentTime = true
  end
  local actID = config and config.id or nil
  local currentDate = targetDate
  if currentDate == nil then
    local currentTime = ServerTime.CurServerTime() / 1000
    currentDate = ServerTime.Ori_OsDate("*t", currentTime)
  end
  local targetYear = currentDate.year
  local targetMonth = currentDate.month
  if checkCurrentTime then
    local currentTimestamp = ServerTime.Ori_OsTime(currentDate)
    local bestStartTime, bestEndTime, bestStartTimeDiff, baseYearPeriod
    local baseStartTime = ServerTime.Ori_OsTime(baseStartDate)
    local startYear = baseStartDate.year - 2
    local endYear = math.max(baseStartDate.year, currentDate.year) + 2
    for testYear = startYear, endYear do
      local startDay = baseStartDate.day
      local endDay = baseEndDate.day
      local startMonth = baseStartDate.month
      local endMonth = baseEndDate.month
      local endYearForPeriod = testYear
      if startMonth > endMonth then
        endYearForPeriod = testYear + 1
      end
      local maxDayInStartMonth = self:GetMaxDayInMonth(testYear, startMonth)
      if startDay > maxDayInStartMonth then
        startDay = maxDayInStartMonth
      end
      local maxDayInEndMonth = self:GetMaxDayInMonth(endYearForPeriod, endMonth)
      if endDay > maxDayInEndMonth then
        endDay = maxDayInEndMonth
      end
      local realStartTime = ServerTime.Ori_OsTime({
        year = testYear,
        month = startMonth,
        day = startDay,
        hour = baseStartDate.hour,
        min = baseStartDate.min,
        sec = baseStartDate.sec
      })
      local realEndTime = ServerTime.Ori_OsTime({
        year = endYearForPeriod,
        month = endMonth,
        day = endDay,
        hour = baseEndDate.hour,
        min = baseEndDate.min,
        sec = baseEndDate.sec
      })
      if testYear == baseStartDate.year then
        baseYearPeriod = {realStartTime, realEndTime}
      end
      if baseStartTime <= realStartTime then
        local currentGameDay = self:ConvertToGameDay(currentTimestamp)
        local startGameDay = self:ConvertToGameDay(realStartTime)
        local endGameDay = self:ConvertToGameDay(realEndTime)
        if currentGameDay >= startGameDay and currentGameDay <= endGameDay then
          if baseStartDate.year >= currentDate.year and baseYearPeriod then
            return baseYearPeriod[1], baseYearPeriod[2]
          end
          return realStartTime, realEndTime
        end
        if currentTimestamp > realEndTime and endYearForPeriod == currentDate.year then
          if not bestStartTime or bestStartTime and endYearForPeriod < ServerTime.Ori_OsDate("*t", bestStartTime).year then
            bestStartTime = realStartTime
            bestEndTime = realEndTime
            bestStartTimeDiff = currentTimestamp - realEndTime
          end
        elseif currentTimestamp < realStartTime and (not bestStartTime or bestStartTime and ServerTime.Ori_OsDate("*t", bestStartTime).year < currentDate.year) and (bestStartTimeDiff == nil or realStartTime < bestStartTime) then
          bestStartTime = realStartTime
          bestEndTime = realEndTime
          bestStartTimeDiff = realStartTime - currentTimestamp
        end
      end
    end
    if baseStartDate.year >= currentDate.year and baseYearPeriod and baseStartTime <= baseYearPeriod[1] then
      return baseYearPeriod[1], baseYearPeriod[2]
    end
    if bestStartTime and bestEndTime and baseStartTime <= bestStartTime then
      return bestStartTime, bestEndTime
    end
    return nil, nil
  else
    local baseStartTime = ServerTime.Ori_OsTime(baseStartDate)
    local startDay = baseStartDate.day
    local endDay = baseEndDate.day
    local startMonth = baseStartDate.month
    local endMonth = baseEndDate.month
    local inRange = false
    if startMonth <= endMonth then
      if targetMonth >= startMonth and targetMonth <= endMonth then
        inRange = true
      end
    elseif targetMonth >= startMonth or targetMonth <= endMonth then
      inRange = true
    end
    if not inRange then
      return nil, nil
    end
    local startYear = targetYear
    local endYear = targetYear
    if targetMonth < startMonth then
      startYear = targetYear - 1
    end
    if startMonth > endMonth then
      endYear = startYear + 1
    end
    local maxDayInStartMonth = self:GetMaxDayInMonth(startYear, startMonth)
    if startDay > maxDayInStartMonth then
      startDay = maxDayInStartMonth
    end
    local maxDayInEndMonth = self:GetMaxDayInMonth(endYear, endMonth)
    if endDay > maxDayInEndMonth then
      endDay = maxDayInEndMonth
    end
    local realStartTime = ServerTime.Ori_OsTime({
      year = startYear,
      month = startMonth,
      day = startDay,
      hour = baseStartDate.hour,
      min = baseStartDate.min,
      sec = baseStartDate.sec
    })
    local realEndTime = ServerTime.Ori_OsTime({
      year = endYear,
      month = endMonth,
      day = endDay,
      hour = baseEndDate.hour,
      min = baseEndDate.min,
      sec = baseEndDate.sec
    })
    if baseStartTime > realStartTime then
      return nil, nil
    end
    return realStartTime, realEndTime
  end
end

function LoopActIntegrationProxy:CalculateSeasonlyTime(baseStartDate, baseEndDate, checkCurrentTime, config, targetDate)
  if checkCurrentTime == nil then
    checkCurrentTime = true
  end
  local currentDate = targetDate
  if currentDate == nil then
    local currentTime = ServerTime.CurServerTime() / 1000
    currentDate = ServerTime.Ori_OsDate("*t", currentTime)
  end
  local durationDays = baseEndDate.day - baseStartDate.day
  local durationMonths = (baseEndDate.year - baseStartDate.year) * 12 + (baseEndDate.month - baseStartDate.month)
  local targetYear = currentDate.year
  local targetMonth = currentDate.month
  local testYear = baseStartDate.year
  local testMonth = baseStartDate.month
  if checkCurrentTime then
    local currentTimestamp = ServerTime.Ori_OsTime(currentDate)
    local bestStartTime, bestEndTime, bestEndYear
    while testYear < currentDate.year or testYear == currentDate.year and testMonth <= currentDate.month + 3 do
      local startDay = baseStartDate.day
      local endDay = baseEndDate.day
      local endMonth = testMonth + durationMonths
      local endYear = testYear
      while 12 < endMonth do
        endMonth = endMonth - 12
        endYear = endYear + 1
      end
      while endMonth < 1 do
        endMonth = endMonth + 12
        endYear = endYear - 1
      end
      local maxDayInStartMonth = self:GetMaxDayInMonth(testYear, testMonth)
      if startDay > maxDayInStartMonth then
        startDay = maxDayInStartMonth
      end
      local maxDayInEndMonth = self:GetMaxDayInMonth(endYear, endMonth)
      if endDay > maxDayInEndMonth then
        endDay = maxDayInEndMonth
      end
      local realStartTime = ServerTime.Ori_OsTime({
        year = testYear,
        month = testMonth,
        day = startDay,
        hour = baseStartDate.hour,
        min = baseStartDate.min,
        sec = baseStartDate.sec
      })
      local realEndTime = ServerTime.Ori_OsTime({
        year = endYear,
        month = endMonth,
        day = endDay,
        hour = baseEndDate.hour,
        min = baseEndDate.min,
        sec = baseEndDate.sec
      })
      local currentGameDay = self:ConvertToGameDay(currentTimestamp)
      local startGameDay = self:ConvertToGameDay(realStartTime)
      local endGameDay = self:ConvertToGameDay(realEndTime)
      if currentGameDay >= startGameDay and currentGameDay <= endGameDay then
        return realStartTime, realEndTime
      end
      if currentTimestamp > realEndTime and endYear == currentDate.year then
        if not bestStartTime or bestStartTime and bestEndYear > endYear then
          bestStartTime = realStartTime
          bestEndTime = realEndTime
          bestEndYear = endYear
        end
      elseif currentTimestamp < realStartTime and (not bestStartTime or bestStartTime and bestEndYear < currentDate.year) and (not bestStartTime or realStartTime < bestStartTime) then
        bestStartTime = realStartTime
        bestEndTime = realEndTime
        bestEndYear = endYear
      end
      testMonth = testMonth + 3
      if 12 < testMonth then
        testMonth = testMonth - 12
        testYear = testYear + 1
      end
      if testYear > currentDate.year + 20 then
        break
      end
    end
    if bestStartTime and bestEndTime and bestEndYear == currentDate.year then
      return bestStartTime, bestEndTime
    end
    if bestStartTime and bestEndTime then
      return bestStartTime, bestEndTime
    end
    return nil, nil
  else
    while testYear <= targetYear + 1 do
      local startDay = baseStartDate.day
      local endDay = baseEndDate.day
      local endMonth = testMonth + durationMonths
      local endYear = testYear
      while 12 < endMonth do
        endMonth = endMonth - 12
        endYear = endYear + 1
      end
      while endMonth < 1 do
        endMonth = endMonth + 12
        endYear = endYear - 1
      end
      local maxDayInStartMonth = self:GetMaxDayInMonth(testYear, testMonth)
      if startDay > maxDayInStartMonth then
        startDay = maxDayInStartMonth
      end
      local maxDayInEndMonth = self:GetMaxDayInMonth(endYear, endMonth)
      if endDay > maxDayInEndMonth then
        endDay = maxDayInEndMonth
      end
      if testYear == targetYear and testMonth == targetMonth then
        local realStartTime = ServerTime.Ori_OsTime({
          year = testYear,
          month = testMonth,
          day = startDay,
          hour = baseStartDate.hour,
          min = baseStartDate.min,
          sec = baseStartDate.sec
        })
        local realEndTime = ServerTime.Ori_OsTime({
          year = endYear,
          month = endMonth,
          day = endDay,
          hour = baseEndDate.hour,
          min = baseEndDate.min,
          sec = baseEndDate.sec
        })
        return realStartTime, realEndTime
      end
      testMonth = testMonth + 3
      if 12 < testMonth then
        testMonth = testMonth - 12
        testYear = testYear + 1
      end
      if testYear > targetYear + 20 then
        break
      end
    end
    return nil, nil
  end
end

function LoopActIntegrationProxy:GetMonthlyShowInfo(groupID)
  groupID = groupID or 1
  if not Table_ActivityNew then
    return {}
  end
  local currentMonthRewards = {}
  local originalTime = ServerTime.CurServerTime() / 1000
  local isTF = EnvChannel.IsTFBranch()
  local timeForMonth = originalTime
  if isTF then
    timeForMonth = originalTime + 604800
  end
  local gameDayTimestamp = self:ConvertToGameDay(timeForMonth)
  local targetDate = ServerTime.Ori_OsDate("*t", gameDayTimestamp)
  local targetMonth = targetDate.month
  local targetYear = targetDate.year
  local branchName = self:GetAreaAndServerName()
  for actID, config in pairs(Table_ActivityNew) do
    if config.Group == groupID and config.Params_Inte then
      local serverValid = self:CheckAreaAndServerValid(config, branchName)
      if serverValid then
        local cycle = config.Cycle
        if not cycle or cycle == "" then
        else
          local startTimeStr = config.StartTime
          local endTimeStr = config.EndTime
          if startTimeStr and startTimeStr ~= "" and endTimeStr and endTimeStr ~= "" then
            local baseStartTime = self:ParseDateTime(startTimeStr)
            local baseEndTime = self:ParseDateTime(endTimeStr)
            if baseStartTime and baseEndTime then
              local configTfDayInAdvance = config.TfDayInAdvance or 0
              if isTF and 0 < configTfDayInAdvance then
                baseStartTime = baseStartTime - configTfDayInAdvance * 86400
                baseEndTime = baseEndTime - configTfDayInAdvance * 86400
              end
              local baseStartDate = ServerTime.Ori_OsDate("*t", baseStartTime)
              local baseEndDate = ServerTime.Ori_OsDate("*t", baseEndTime)
              local targetMonthFirstDay = {
                year = targetYear,
                month = targetMonth,
                day = 1,
                hour = 5,
                min = 0,
                sec = 0
              }
              local realStartTime, realEndTime
              if cycle == "monthly" then
                realStartTime, realEndTime = self:CalculateMonthlyTime(baseStartDate, baseEndDate, false, config, targetMonthFirstDay)
              elseif cycle == "yearly" then
                realStartTime, realEndTime = self:CalculateYearlyTime(baseStartDate, baseEndDate, false, config, targetMonthFirstDay)
              elseif cycle == "seasonly" then
                realStartTime, realEndTime = self:CalculateSeasonlyTime(baseStartDate, baseEndDate, false, config, targetMonthFirstDay)
              end
              if realStartTime and realEndTime then
                local startDate = ServerTime.Ori_OsDate("*t", realStartTime)
                local endDate = ServerTime.Ori_OsDate("*t", realEndTime)
                local containsTargetMonth = false
                if startDate.year == targetYear and startDate.month == targetMonth then
                  containsTargetMonth = true
                elseif endDate.year == targetYear and endDate.month == targetMonth then
                  containsTargetMonth = true
                elseif targetYear > startDate.year and targetYear < endDate.year then
                  containsTargetMonth = true
                elseif startDate.year == targetYear and endDate.year == targetYear then
                  if targetMonth >= startDate.month and targetMonth <= endDate.month then
                    containsTargetMonth = true
                  end
                elseif startDate.year == targetYear and targetYear < endDate.year then
                  if targetMonth >= startDate.month then
                    containsTargetMonth = true
                  end
                elseif targetYear > startDate.year and endDate.year == targetYear and targetMonth <= endDate.month then
                  containsTargetMonth = true
                end
                if containsTargetMonth and config.Params_Inte[targetMonth] then
                  local rewards = config.Params_Inte[targetMonth]
                  for _, reward in ipairs(rewards) do
                    table.insert(currentMonthRewards, {
                      item = reward.item,
                      name = reward.name,
                      actID = actID,
                      realStartTime = realStartTime,
                      realEndTime = realEndTime
                    })
                  end
                end
              end
            end
          end
        end
      end
    else
    end
  end
  return currentMonthRewards
end

local SubTypeMap = {
  act_bp = 1,
  new_server_challenge = 2,
  flip_card = 3,
  act_bp_shop = 4,
  lottery_raid = 14,
  boss_scene_season = 12
}

function LoopActIntegrationProxy:GetSubTypeFromActType(actType)
  return SubTypeMap[actType]
end

function LoopActIntegrationProxy:GetSubType(staticData)
  if not staticData then
    redlog("GetSubType", "staticData is nil")
    return nil
  end
  if staticData.IsGlobalActivity ~= 1 then
    return self:GetSubTypeFromActType(staticData.Type)
  end
  return tonumber(staticData.Type)
end

function LoopActIntegrationProxy:GetActivityTime(staticData)
  if not staticData then
    return nil, nil
  end
  local isGlobalActivity = staticData.IsGlobalActivity
  local actType = tonumber(staticData.Type)
  local actID = staticData.id
  if isGlobalActivity == 1 then
    if actType == ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN then
      return ActivityPaySignProxy.Instance:GetGlobalActTime(actID)
    end
    return self:GetGlobalActivityTime(actType, actID)
  else
    return self:GetPersonalActivityTime(actID)
  end
end

function LoopActIntegrationProxy:GetGlobalActivityTime(actType, actID)
  local activityData = FunctionActivity.Me():GetActivityData(actType)
  if not activityData then
    return nil, nil
  end
  local params = FunctionActivity.Me():GetParams(actType)
  if params and params.id and params.id ~= actID then
    return nil, nil
  end
  local startTime = activityData.whole_starttime
  local endTime = activityData.whole_endtime
  return startTime, endTime
end

function LoopActIntegrationProxy:GetPersonalActivityTime(actID)
  if not ActivityIntegrationProxy or not ActivityIntegrationProxy.Instance then
    return nil, nil
  end
  local actInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(actID)
  if not actInfo then
    return nil, nil
  end
  return actInfo.starttime, actInfo.endtime
end

function LoopActIntegrationProxy:CheckActivityValid(activityID)
  local staticData = Table_ActivityNew[activityID]
  if not staticData then
    return false
  end
  if not self:CheckRoleLevelValid(staticData) then
    return false
  end
  if staticData.IsGlobalActivity == 1 then
    local type = staticData.Type
    if type == "act_bp" then
      return ActivityBattlePassProxy.Instance:IsBPAvailable(activityID)
    elseif type == tostring(ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN) then
      return ActivityPaySignProxy.Instance:IsPaySignAvailable(activityID)
    else
      return FunctionActivity.Me():IsActivityRunning(tonumber(type))
    end
  else
    return ActivityIntegrationProxy.Instance:CheckActPersinalActValid(activityID)
  end
  return true
end

function LoopActIntegrationProxy:GetValidActivityIDs(groupID)
  local groupInfo = self:GetGroupInfo(groupID)
  if not groupInfo or not groupInfo.activityIDs then
    return {}
  end
  local validIDs = {}
  for i = 1, #groupInfo.activityIDs do
    local activityID = groupInfo.activityIDs[i]
    if self:CheckActivityValid(activityID) then
      table.insert(validIDs, activityID)
    end
  end
  return validIDs
end

function LoopActIntegrationProxy:GetAllActivityIDsInGroup(groupID)
  local groupInfo = self.activityGroups[groupID]
  if not groupInfo or not groupInfo.activityIDs then
    return {}
  end
  local allIDs = {}
  for i = 1, #groupInfo.activityIDs do
    table.insert(allIDs, groupInfo.activityIDs[i])
  end
  return allIDs
end

function LoopActIntegrationProxy:GetBossSceneSeasonCardId(actID)
  if not ActivityIntegrationProxy or not ActivityIntegrationProxy.Instance then
    return nil
  end
  local actPersonalTime = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(actID)
  if not actPersonalTime or not actPersonalTime.starttime then
    return nil
  end
  local dateInfo = ServerTime.Ori_OsDate("*t", actPersonalTime.starttime)
  if not dateInfo then
    return nil
  end
  local yearMonth = dateInfo.year * 100 + dateInfo.month
  if not Table_BossSceneSeason then
    autoImport("Table_BossSceneSeason")
  end
  if Table_BossSceneSeason then
    for _, config in pairs(Table_BossSceneSeason) do
      if config.YearMonth == yearMonth then
        return config.UpCard
      end
    end
  end
  return nil
end

function LoopActIntegrationProxy:GetValidGroupIDs()
  local validGroups = {}
  for groupID, _ in pairs(self.activityGroups) do
    if self:CheckGroupValid(groupID) then
      table.insert(validGroups, groupID)
    end
  end
  return validGroups
end

return LoopActIntegrationProxy
