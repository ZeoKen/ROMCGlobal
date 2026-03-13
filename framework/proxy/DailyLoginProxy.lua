DailyLoginProxy = class("DailyLoginProxy", pm.Proxy)

function DailyLoginProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "DailyLoginProxy"
  if DailyLoginProxy.Instance == nil then
    DailyLoginProxy.Instance = self
  end
  if not data then
    self:setData(data)
  end
  self:Init()
end

function DailyLoginProxy:Init()
  self.hotPotIcon = {}
  self.activeSignIn = {}
  self.globalActivityData = {}
  self.activityMonthMap = {}
end

function DailyLoginProxy:GetFestivalSigninConfig(activityId)
  if Table_FestivalSignin then
    local month = self.activityMonthMap[activityId]
    if month then
      for id, config in pairs(Table_FestivalSignin) do
        if config.ActID == activityId and config.Month == month then
          return config, true
        end
      end
    else
      for id, config in pairs(Table_FestivalSignin) do
        if config.ActID == activityId and config.Month == nil then
          return config, true
        end
      end
    end
  end
  if GameConfig.FestivalSignin and GameConfig.FestivalSignin[activityId] then
    return GameConfig.FestivalSignin[activityId], false
  end
  return nil, false
end

function DailyLoginProxy:GetSigninReward(activityId, day, sex)
  local config, isNewConfig = self:GetFestivalSigninConfig(activityId)
  if not config or not config.SigninReward then
    return nil
  end
  local rewardData = config.SigninReward[day]
  if not rewardData then
    return nil
  end
  if isNewConfig then
    local rewards = rewardData
    if sex == 2 and config.SigninRewardFemale and config.SigninRewardFemale[day] then
      rewards = config.SigninRewardFemale[day]
    end
    return rewards
  elseif sex == 2 and rewardData.FemaleItem then
    return rewardData.FemaleItem
  else
    return rewardData.Item
  end
end

function DailyLoginProxy:GetAllFestivalSigninIds()
  local allIds = {}
  if Table_FestivalSignin then
    for id, config in pairs(Table_FestivalSignin) do
      if type(id) == "number" and config.ActID and config.Month then
        local month = self.activityMonthMap[config.ActID]
        if month and month == config.Month then
          allIds[id] = config.ActID
        end
      elseif config.Month == nil then
        allIds[id] = config.ActID
      end
    end
  end
  if GameConfig.FestivalSignin then
    for k, v in pairs(GameConfig.FestivalSignin) do
      if type(k) == "number" then
        allIds[k] = k
      end
    end
  end
  return allIds
end

function DailyLoginProxy:StartAct(data)
  local id = data.id
  if not self.globalActivityData[id] or self.globalActivityData[id].batch_id ~= data.batch_id then
    self.globalActivityData[id] = {
      starttime = data.starttime,
      endtime = data.endtime,
      batch_id = data.batch_id
    }
  end
  if data.batch_id then
    local batch_id_str = tostring(data.batch_id)
    if #batch_id_str == 8 then
      local month = tonumber(string.sub(batch_id_str, 5, 6))
      if month and 1 <= month and month <= 12 then
        self.activityMonthMap[id] = month
        xdlog("活动月份记录", id, month, batch_id_str)
      else
        redlog("无效的月份", id, batch_id_str, month)
      end
    else
      redlog("batch_id格式错误", id, batch_id_str)
    end
    self:UpdateRedtips()
  end
end

function DailyLoginProxy:GetGlobalActData(id)
  if self.globalActivityData[id] then
    return self.globalActivityData[id]
  end
end

function DailyLoginProxy:RecvDaySigninInfoCmd(data)
  local infos = data.infos
  if infos and 0 < #infos then
    for i = 1, #infos do
      local single = infos[i]
      if not self.activeSignIn[single.activityid] then
        self.activeSignIn[single.activityid] = {}
      end
      local data = {}
      data.novicetype = single.novicetype
      data.signindaynum = single.signindaynum
      local tempData = {}
      TableUtility.ArrayShallowCopy(tempData, single.awardeddays)
      data.awardeddays = tempData
      self.activeSignIn[single.activityid] = data
      xdlog("七日登录活动数据", single.activityid, single.signindaynum, #data.awardeddays)
    end
  end
  local tip = data.tip
  self.inited = data.tip
  xdlog("是否弹窗", self.inited)
end

function DailyLoginProxy:GetDaySignInfo(activityid)
  if not activityid then
    return
  end
  if self.activeSignIn and self.activeSignIn[activityid] then
    return self.activeSignIn[activityid]
  end
end

function DailyLoginProxy:RecvDaySigninLoginAwardCmd(data)
  local activityid = data.activityid
  local days = data.days
  if not self.activeSignIn[activityid] then
    redlog("无活动基础签到信息", activityid)
    return
  end
  if days and 0 < #days then
    for i = 1, #days do
      local day = days[i]
      table.insert(self.activeSignIn[activityid].awardeddays, day)
    end
  end
end

function DailyLoginProxy:RecvDaySigninActivityCmd(data)
  TableUtility.TableClear(self.hotPotIcon)
  local infos = data.infos
  if infos and 0 < #infos then
    for i = 1, #infos do
      local single = infos[i]
      self.hotPotIcon[single.activityid] = {
        activityid = single.activityid,
        redtip = single.redtip,
        endtime = single.end_time
      }
      xdlog("DaySigninActivityCm活动入口开启", single.activityid, single.redtip, single.end_time)
    end
  end
  self:UpdateRedtips()
end

function DailyLoginProxy:GetDaySignInActivity(activityid)
  if self.hotPotIcon and self.hotPotIcon[activityid] then
    return self.hotPotIcon[activityid]
  end
  return nil
end

function DailyLoginProxy:isNoviceLoginOpen()
  if not self.hotPotIcon then
    return false
  end
  for k, v in pairs(self.hotPotIcon) do
    local config = self:GetFestivalSigninConfig(k)
    if config and config.Newbie and config.Newbie == 1 then
      local endTime = v.endtime
      if endTime and endTime > ServerTime.CurServerTime() / 1000 then
        return true, v.activityid
      end
    end
  end
  return false
end

function DailyLoginProxy:UpdateRedtips()
  if not self.hotPotIcon then
    return
  end
  local redtipID = SceneTip_pb.EREDSYS_SIGNACTIVITY_NORMAL
  local addSubTipIDs = {}
  local removeSubTipIDs = {}
  local hasMainRedTip = false
  for k, v in pairs(self.hotPotIcon) do
    local config = self:GetFestivalSigninConfig(k)
    if config and (not config.Newbie or config.Newbie ~= 1) and v.redtip then
      table.insert(addSubTipIDs, k)
      hasMainRedTip = true
    else
      table.insert(removeSubTipIDs, k)
    end
  end
  if hasMainRedTip then
    if 0 < #removeSubTipIDs then
      RedTipProxy.Instance:RemoveRedTip(redtipID, removeSubTipIDs)
    end
    if 0 < #addSubTipIDs then
      RedTipProxy.Instance:UpdateRedTip(redtipID, addSubTipIDs)
    end
  else
    RedTipProxy.Instance:RemoveWholeTip(redtipID)
  end
end

function DailyLoginProxy:TryCallSignInInfo()
  xdlog("申请签到消息")
  if not self.refreshValidTime or self.refreshValidTime < ServerTime.CurServerTime() / 1000 then
    self.refreshValidTime = ServerTime.CurServerTime() / 1000 + 5
    ServiceActivityCmdProxy.Instance:CallDaySigninInfoCmd()
  end
end
