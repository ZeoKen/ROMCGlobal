autoImport("DailyDepositData")
DailyDepositProxy = class("DailyDepositProxy", pm.Proxy)
DailyDepositProxy.Instance = nil
DailyDepositProxy.NAME = "DailyDepositProxy"
DailyDepositProxy.RedTipID = 10727

function DailyDepositProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DailyDepositProxy.NAME
  if DailyDepositProxy.Instance == nil then
    DailyDepositProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function DailyDepositProxy:Init()
  if GameConfig.SystemForbid.DailyDeposit then
    return
  end
end

function DailyDepositProxy:IsActive()
  if self.actData then
    return self.actData:IsActive()
  end
  return false
end

function DailyDepositProxy:GetActData()
  return self.actData
end

function DailyDepositProxy:GetConfig()
  if self.actData then
    return self.actData:GetConfig()
  end
end

function DailyDepositProxy:RecvDailyDepositInfo(serverData)
  if not serverData then
    return
  end
  if self.actData and self.actData.id == serverData.version then
    self.actData:SetData(serverData)
  else
    self.actData = DailyDepositData.new(serverData)
  end
  if self.actData:HasUntakenReward() then
    RedTipProxy.Instance:UpdateRedTip(DailyDepositProxy.RedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(DailyDepositProxy.RedTipID)
  end
end

function DailyDepositProxy:TakeReward(index)
  local version = self.actData and self.actData:GetActId()
  if version then
    ServiceSceneUser3Proxy.Instance:CallDailyDepositGetReward(index, version)
  end
end

function DailyDepositProxy:GetRewardDatas()
  return self.actData and self.actData:GetRewardDatas() or {}
end

function DailyDepositProxy:GetTotalDeposit()
  return self.actData and self.actData:GetTotalDeposit() or 0
end

function DailyDepositProxy:GetActivityPeriodStr()
  return self.actData and self.actData:GetActivityPeriodStr() or ""
end

function DailyDepositProxy:HasUntakenReward()
  if self.actData then
    return self.actData:HasUntakenReward()
  end
  return false
end
