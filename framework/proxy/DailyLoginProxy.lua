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
end

function DailyLoginProxy:StartAct(data)
  local id = data.id
  if not self.globalActivityData[id] then
    self.globalActivityData[id] = {
      starttime = data.starttime,
      endtime = data.endtime
    }
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
  local config = GameConfig.FestivalSignin
  for k, v in pairs(self.hotPotIcon) do
    if config[k] and config[k].Newbie and config[k].Newbie == 1 then
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
  local config = GameConfig.FestivalSignin
  local redtipID
  for k, v in pairs(self.hotPotIcon) do
    if config[k] and config[k].Newbie and config[k].Newbie == 1 then
      redtipID = SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE
      if v.redtip then
        RedTipProxy.Instance:UpdateRedTip(redtipID)
      else
        RedTipProxy.Instance:RemoveWholeTip(redtipID)
      end
    end
  end
end

function DailyLoginProxy:TryCallSignInInfo()
  xdlog("申请签到消息")
  if not self.refreshValidTime or self.refreshValidTime < ServerTime.CurServerTime() / 1000 then
    self.refreshValidTime = ServerTime.CurServerTime() / 1000 + 5
    ServiceActivityCmdProxy.Instance:CallDaySigninInfoCmd()
  end
end
