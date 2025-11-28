PlayerRefluxProxy = class("PlayerRefluxProxy", pm.Proxy)
PlayerRefluxProxy.Instance = nil
PlayerRefluxProxy.NAME = "PlayerRefluxProxy"
PlayerRefluxProxy.RedInvite = SceneTip_pb.EREDSYS_USERINVITE_INVITE_LOGIN
PlayerRefluxProxy.RedRECALL = SceneTip_pb.EREDSYS_USERINVITE_RECALL_LOGIN

function PlayerRefluxProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PlayerRefluxProxy.NAME
  if PlayerRefluxProxy.Instance == nil then
    PlayerRefluxProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.refluxData = {}
end

function PlayerRefluxProxy:AddActivity(serverData)
  if not serverData then
    redlog("has no server data")
    return
  end
  self.hasData = true
  self.actId = serverData.id
  self.starttime = serverData.starttime
  self.endTime = serverData.endtime
  self.RecellEndtime = serverData.params[1]
end

function PlayerRefluxProxy:GetConfigMap()
  if GameConfig.ReturnInvitation and self.hasData then
    return GameConfig.ReturnInvitation[self.actId]
  end
  return nil
end

function PlayerRefluxProxy:SetRefluxData(serverData)
  if not serverData then
    redlog("have no server data")
    return
  end
  self.refluxData.invitecode = serverData.invitecode
  self.refluxData.inviteuserid = serverData.inviteuserid
  self.refluxData.inviteusername = serverData.inviteusername
  self.refluxData.inviteawarded = serverData.inviteawarded
  self.refluxData.invitelogindays = serverData.invitelogindays
  self.refluxData.inviteawardid = serverData.inviteawardid
  self.refluxData.sharawarded = serverData.sharawarded
  self.refluxData.recalluser = serverData.recalluser
  self.refluxData.binduser = serverData.binduser
  self.refluxData.recalllogindays = serverData.recalllogindays
  self.refluxData.loginawarddid = serverData.loginawarddid
  TableUtil.Print(self.refluxData)
  if self.refluxData.recalluser then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlayerRefluxBackView
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlayerRefluxView
    })
  end
end

function PlayerRefluxProxy:CheckRefluxActivity()
  local cur = ServerTime.CurServerTime() / 1000
  return self.isOpen and cur <= self.endtime and cur >= self.starttime
end

function PlayerRefluxProxy:UpdateRedTip()
  if self.refluxData.recalluser then
    RedTipProxy.Instance:UpdateRedTip(PlayerRefluxProxy.RedRECALL)
  else
    RedTipProxy.Instance:UpdateRedTip(PlayerRefluxProxy.RedInvite)
  end
end

function PlayerRefluxProxy:IsActive()
  return FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_USER_INVITE) and self.hasData and true or false
end

function PlayerRefluxProxy:GetAcSatrtTime()
  return os.date("*t", self.starttime)
end

function PlayerRefluxProxy:GetAcEndTime()
  return os.date("*t", self.endTime)
end

function PlayerRefluxProxy:GetRecellEndTime()
  return os.date("*t", self.RecellEndtime)
end

function PlayerRefluxProxy:IsRecellTimeEnd()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.RecellEndtime then
    return true
  end
  return false
end

function PlayerRefluxProxy:GetRefluxData()
  if self.refluxData then
    return self.refluxData
  end
  return nil
end

function PlayerRefluxProxy:SetInviteawardId(data)
  if self.refluxData and data and data.id then
    if not self.refluxData.inviteawardid then
      self.refluxData.inviteawardid = {}
    end
    for k, v in pairs(data.id) do
      if not self:Is_include(v, self.refluxData.inviteawardid) then
        table.insert(self.refluxData.inviteawardid, v)
      end
    end
  end
end

function PlayerRefluxProxy:GetInviteawardId()
  if self.refluxData then
    return self.refluxData.inviteawardid
  end
  return 0
end

function PlayerRefluxProxy:SetInviteawarded(data)
  if not data and not data.sucess then
    return
  end
  if self.refluxData then
    self.refluxData.inviteawarded = true
  end
end

function PlayerRefluxProxy:Getinviteawarded()
  if self.refluxData then
    return self.refluxData.inviteawarded
  end
  return false
end

function PlayerRefluxProxy:GetRecalllogindays()
  if self.refluxData then
    return self.refluxData.recalllogindays or 0
  end
  return 0
end

function PlayerRefluxProxy:GetLoginawarddid()
  if self.refluxData then
    return self.refluxData.loginawarddid
  end
  return nil
end

function PlayerRefluxProxy:SetLoginawarddid(data)
  if data and data.id and self.refluxData then
    if not self.refluxData.loginawarddid then
      self.refluxData.loginawarddid = {}
    end
    for k, v in pairs(data.id) do
      if not self:Is_include(v, self.refluxData.loginawarddid) then
        table.insert(self.refluxData.loginawarddid, v)
      end
    end
  end
end

function PlayerRefluxProxy:Setsharawarded(data)
  self.refluxData.sharawarded = true
end

function PlayerRefluxProxy:Setbinduser(data)
  if data and data.sucess and self.refluxData then
    self.refluxData.binduser = true
  end
end

function PlayerRefluxProxy:Is_include(value, tab)
  if not tab then
    return false
  end
  for k, v in pairs(tab) do
    if v == value then
      return true
    end
  end
  return false
end

function PlayerRefluxProxy:CallUserInviteInfoCmd()
  ServiceActivityCmdProxy.Instance:CallUserInviteInfoCmd()
end

function PlayerRefluxProxy:CallUserInviteInviteLoginAwardCmd(id)
  ServiceActivityCmdProxy.Instance:CallUserInviteInviteLoginAwardCmd(id)
end

function PlayerRefluxProxy:CallUserInviteBindUserCmd(invitecode)
  ServiceActivityCmdProxy.Instance:CallUserInviteBindUserCmd(invitecode)
end

function PlayerRefluxProxy:CallUserInviteInviteAwardCmd()
  ServiceActivityCmdProxy.Instance:CallUserInviteInviteAwardCmd()
end

function PlayerRefluxProxy:CallUserInviteShareAwardCmd()
  ServiceActivityCmdProxy.Instance:CallUserInviteShareAwardCmd()
end

function PlayerRefluxProxy:CallUserInviteRecallLoginAwardCmd(day)
  ServiceActivityCmdProxy.Instance:CallUserInviteRecallLoginAwardCmd(day)
end
