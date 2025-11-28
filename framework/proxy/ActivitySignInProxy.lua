ActivitySignInProxy = class("ActivitySignInProxy", NewServerSignInProxy)
local nowConfig

function ActivitySignInProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ActivitySignInProxy"
  ActivitySignInProxy.Instance = self
  if data then
    self:setData(data)
  end
  self:Init()
end

function ActivitySignInProxy:CheckRewardDataValid(data)
  return ActivitySignInProxy.super.CheckRewardDataValid(self, data) and self:GetNowBatch() == data.Batch
end

function ActivitySignInProxy:GetNowConfigData()
  self:TryRefreshNowConfigData()
  return nowConfig
end

function ActivitySignInProxy:GetNowBatch()
  local cfg = self:GetNowConfigData()
  return cfg and cfg.Batch
end

function ActivitySignInProxy:CallSignIn()
  ServiceNUserProxy.Instance:CallSignInUserCmd(nil, SceneUser2_pb.ESIGNINTYPE_ACTIVITY)
end

function ActivitySignInProxy:RecvSignInResult(isSuccess)
  if isSuccess then
    LogUtility.Info("Activity SignIn Success.")
  else
    LogUtility.Warning("Activity SignIn Failed.")
  end
end

function ActivitySignInProxy:RecvSignInNotify(signedCount, todaySigned, catShowed)
  local exSignedCount, exReceived = self.signedCount, self.isSignInNotifyReceived
  ActivitySignInProxy.super.RecvSignInNotify(self, signedCount, todaySigned, catShowed)
  self:TryRefreshNowConfigData()
  if exReceived and self.signedCount - exSignedCount == 1 and not UIManagerProxy.Instance:HasUINode(PanelConfig.ActivitySignInMapView) then
    MsgManager.ShowMsgByID(40545)
  end
end

local branchTimeGetter = function(cfg)
  if type(cfg) ~= "table" then
    return
  end
  local fieldPrefix = EnvChannel.IsReleaseBranch() and "Release" or "Tf"
  return cfg[fieldPrefix .. "StartTime"], cfg[fieldPrefix .. "EndTime"]
end

function ActivitySignInProxy:TryRefreshNowConfigData()
  local nowTimeString = os.date("%Y-%m-%d %H:%M:%S", ServerTime.CurServerTime() / 1000)
  local _, nowCfgEndTime = branchTimeGetter(nowConfig)
  if not nowConfig or nowTimeString > nowCfgEndTime then
    if not GameConfig.ActivitySignIn then
      return
    end
    local startTime, endTime
    nowConfig = nil
    for _, data in pairs(GameConfig.ActivitySignIn) do
      if self.serverLineGroup == data.ServerID then
        startTime, endTime = branchTimeGetter(data)
        if nowTimeString > startTime and nowTimeString <= endTime then
          nowConfig = data
        end
      end
    end
  end
end

function ActivitySignInProxy:GetNowConfigPeriodTimeStrs()
  local cfg = self:GetNowConfigData()
  return branchTimeGetter(cfg)
end

function ActivitySignInProxy:GetNowConfigPeriodDateStrs()
  local startTime, endTime = self:GetNowConfigPeriodTimeStrs()
  return string.sub(startTime, 1, 10), string.sub(endTime, 1, 10)
end

function ActivitySignInProxy:InitStaticTables()
  self.staticRewardTable = _G.Table_ActivitySign
  self:InitRewardData()
end

function ActivitySignInProxy:IsSignInNotifyReceived()
  return self.isSignInNotifyReceived
end

function ActivitySignInProxy:GetRemainderOfDay(day, divisor)
  return day
end
