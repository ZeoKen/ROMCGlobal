NewPartnerActProxy = class("NewPartnerActProxy", pm.Proxy)
NewPartnerActProxy.Instance = nil
NewPartnerActProxy.NAME = "NewPartnerActProxy"

function NewPartnerActProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NewPartnerActProxy.NAME
  if NewPartnerActProxy.Instance == nil then
    NewPartnerActProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.newPartnerData = {}
end

function NewPartnerActProxy:NewPartnerData(serverData)
  if not serverData then
    redlog("has no server data")
    return
  end
  self.hasData = true
  self.actId = serverData.id
  self.starttime = serverData.starttime
  self.endTime = serverData.endtime
end

function NewPartnerActProxy:GetConfigMap()
  if GameConfig.NewPartnerAct and self.hasData then
    return GameConfig.NewPartnerAct[self.actId]
  end
  return nil
end

function NewPartnerActProxy:CallNewPartnerCmd()
  ServiceActivityCmdProxy.Instance:CallNewPartnerCmd()
end

function NewPartnerActProxy:IsRecellTimeEnd()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.endTime then
    return true
  end
  return false
end

function NewPartnerActProxy:GetAcSatrtTime()
  return os.date("*t", self.starttime)
end

function NewPartnerActProxy:GetAcEndTime()
  return os.date("*t", self.endTime)
end

function NewPartnerActProxy:GetRecellEndTime()
  return os.date("*t", self.RecellEndtime)
end

function NewPartnerActProxy:GetLoginawarddid()
  if self.newPartnerData then
    return self.newPartnerData.awardid
  end
  return nil
end

function NewPartnerActProxy:RecvUserInviteAwardCmd(data)
  if data.awardid then
    for i = 1, #data.awardid do
      self.newPartnerData.awardid[i] = {}
      self.newPartnerData.awardid[i] = data.awardid[i]
    end
  end
end

function NewPartnerActProxy:RecvNewPartnerCmd(data)
  if data.awardid then
    self.newPartnerData.awardid = {}
    for i = 1, #data.awardid do
      self.newPartnerData.awardid[i] = {}
      self.newPartnerData.awardid[i] = data.awardid[i]
    end
  end
end
