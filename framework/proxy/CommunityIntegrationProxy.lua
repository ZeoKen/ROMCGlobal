CommunityIntegrationProxy = class("CommunityIntegrationProxy", pm.Proxy)
CommunityIntegrationProxy.Instance = nil
CommunityIntegrationProxy.NAME = "CommunityIntegrationProxy"

function CommunityIntegrationProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CommunityIntegrationProxy.NAME
  if CommunityIntegrationProxy.Instance == nil then
    CommunityIntegrationProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function CommunityIntegrationProxy:Init()
  self.followActMap = {}
  self.followFinishedMap = {}
  self.followRewardedMap = {}
  self.communityActMap = {}
  self.communityFinishedMap = {}
  self.communityRewardedMap = {}
end

function CommunityIntegrationProxy:GetActs()
  local actMap = {}
  local curTime = ServerTime.CurServerTime() / 1000
  local events = ActivityEventProxy.Instance:GetEvents(ActivityEventType.Community)
  if events and 0 < #events then
    xdlog("Evts", #events)
    for i = 1, #events do
      local event = events[i]
      local startTime = event.beginTime
      local endTime = event.endTime
      if curTime > startTime and curTime < endTime then
        xdlog("满足时间范围内", event.id)
        local data = {
          id = event.id,
          type = 1,
          order = order,
          startTime = startTime,
          endTime = endTime,
          event = event
        }
        table.insert(actMap, data)
      else
        redlog("语言配置不存在或者时间不满足")
      end
    end
  end
  table.sort(actMap, function(a, b)
    local a_order = a.order or 0
    local b_order = b.order or 0
    if a_order ~= b_order then
      return a_order < b_order
    end
    return a.id < b.id
  end)
  for id, info in pairs(self.followActMap) do
    if curTime > info.startTime and curTime < info.endTime then
      local data = {
        id = id,
        startTime = info.startTime,
        endTime = info.endTime,
        type = 2
      }
      table.insert(actMap, data)
    end
  end
  local noRewardActConfig = GameConfig.CommunityIntegration and GameConfig.CommunityIntegration.NoRewardAct
  if noRewardActConfig then
    local isTF = EnvChannel.IsTFBranch()
    for id, info in pairs(noRewardActConfig) do
      local startTime = isTF and info.TfStartTime or info.StartTime
      local endTime = isTF and info.TfEndTime or info.EndTime
      if startTime and endTime then
        startTime = startTime and KFCARCameraProxy.Instance:GetSelfCustomDate(startTime)
        endTime = endTime and KFCARCameraProxy.Instance:GetSelfCustomDate(endTime)
        if curTime > startTime and curTime < endTime then
          local data = {
            id = id,
            type = 3,
            startTime = startTime,
            endTime = endTime
          }
          table.insert(actMap, data)
        end
      end
    end
  end
  return actMap
end

function CommunityIntegrationProxy:AddGlobalFollowAct(id, startTime, endTime)
  if not self.followActMap[id] then
    self.followActMap[id] = {}
  end
  self.followActMap[id].startTime = startTime
  self.followActMap[id].endTime = endTime
  self:RefreshRedtip()
end

function CommunityIntegrationProxy:RecvRewardInfoGlobalActivityCmd(rewardinfo)
  if not rewardinfo then
    return
  end
  local finishActIds = rewardinfo.finished_actids
  if finishActIds and 0 < #finishActIds then
    for i = 1, #finishActIds do
      if TableUtility.ArrayFindIndex(self.followFinishedMap, finishActIds[i]) == 0 then
        xdlog("已领取奖励")
        table.insert(self.followFinishedMap, finishActIds[i])
      end
    end
  end
  local rewardActIds = rewardinfo.rewarded_actids
  if rewardActIds and 0 < #rewardActIds then
    for i = 1, #rewardActIds do
      if TableUtility.ArrayFindIndex(self.followRewardedMap, rewardActIds[i]) == 0 then
        table.insert(self.followRewardedMap, rewardActIds[i])
      end
    end
  end
  self:RefreshRedtip()
end

function CommunityIntegrationProxy:CheckFollowIsFinished(id)
  return TableUtility.ArrayFindIndex(self.followFinishedMap, id) > 0
end

function CommunityIntegrationProxy:CheckFollowIsRewarded(id)
  return TableUtility.ArrayFindIndex(self.followRewardedMap, id) > 0
end

function CommunityIntegrationProxy:RecvActivityEventUserDataNtf(rewardinfo)
  if not rewardinfo then
    return
  end
  xdlog("社群奖励信息同步")
  local finishActIds = rewardinfo.finished_actids
  if finishActIds and 0 < #finishActIds then
    for i = 1, #finishActIds do
      if TableUtility.ArrayFindIndex(self.communityFinishedMap, finishActIds[i]) == 0 then
        table.insert(self.communityFinishedMap, finishActIds[i])
      end
    end
  end
  local rewardActIds = rewardinfo.rewarded_actids
  if rewardActIds and 0 < #rewardActIds then
    for i = 1, #rewardActIds do
      if TableUtility.ArrayFindIndex(self.communityRewardedMap, rewardActIds[i]) == 0 then
        table.insert(self.communityRewardedMap, rewardActIds[i])
      end
    end
  end
  self:RefreshRedtip()
end

function CommunityIntegrationProxy:CheckCommunityActIsFinished(id)
  return TableUtility.ArrayFindIndex(self.communityFinishedMap, id) > 0
end

function CommunityIntegrationProxy:CheckCommunityActIsRewarded(id)
  return TableUtility.ArrayFindIndex(self.communityRewardedMap, id) > 0
end

function CommunityIntegrationProxy:CheckEntranceValid()
  local actMap = self:GetActs()
  if actMap and 0 < #actMap then
    return true
  end
  return false
end

function CommunityIntegrationProxy:RefreshRedtip()
  local acts = self:GetActs()
  if acts and 0 < #acts then
    local followSubRedtip = {}
    local communitySubRedtip = {}
    for i = 1, #acts do
      local type = acts[i].type
      if type == 2 then
        local isFinish = self:CheckFollowIsFinished(acts[i].id)
        local isRewarded = self:CheckFollowIsRewarded(acts[i].id)
        if not isFinish and not isRewarded then
          table.insert(followSubRedtip, acts[i].id)
        elseif isFinish and not isRewarded then
          table.insert(followSubRedtip, acts[i].id)
        end
      elseif type == 1 then
        local isFinish = self:CheckCommunityActIsFinished(acts[i].id)
        local isRewarded = self:CheckCommunityActIsRewarded(acts[i].id)
        if not isFinish and not isRewarded then
          table.insert(communitySubRedtip, acts[i].id)
        elseif isFinish and not isRewarded then
          table.insert(communitySubRedtip, acts[i].id)
        end
      end
    end
    if followSubRedtip and 0 < #followSubRedtip then
      RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_GLOBAL_ACT_REWARD, followSubRedtip)
    else
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GLOBAL_ACT_REWARD)
    end
    if communitySubRedtip and 0 < #communitySubRedtip then
      RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_EVENT_ACT_REWARD, communitySubRedtip)
    else
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_EVENT_ACT_REWARD)
    end
  end
end
