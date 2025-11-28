autoImport("BattleFundData")
BattleFundProxy = class("BattleFundProxy", pm.Proxy)
BattleFundProxy.Instance = nil
BattleFundProxy.NAME = "BattleFundProxy"
BattleFundProxy.RedTipID = 10723

function BattleFundProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BattleFundProxy.NAME
  if BattleFundProxy.Instance == nil then
    BattleFundProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function BattleFundProxy:Init()
  if GameConfig.SystemForbid.BattleFund then
    return
  end
end

function BattleFundProxy:SetGlobalAct(data)
  if not data then
    return
  end
  self.globalActData = {
    starttime = data.starttime,
    endtime = data.endtime
  }
  redlog("BattleFundProxy:SetGlobalAct() 设置globalActData", self.globalActData)
end

function BattleFundProxy:IsGlobalActActive()
  if not self.globalActData then
    redlog("BattleFundProxy:IsGlobalActActive() 没有globalActData")
    return false
  end
  if self.globalActData.starttime > ServerTime.CurServerTime() / 1000 then
    redlog("BattleFundProxy:IsGlobalActActive() 没有开始")
    return false
  end
  if self.globalActData.endtime < ServerTime.CurServerTime() / 1000 then
    redlog("BattleFundProxy:IsGlobalActActive() 已经结束")
    return false
  end
  return true
end

function BattleFundProxy:GetGlobalActEndLeftTime()
  if not self.globalActData then
    return 0
  end
  return self.globalActData.endtime - ServerTime.CurServerTime() / 1000
end

function BattleFundProxy:IsActive()
  if self.actData then
    return self.actData:IsActive()
  end
  return false
end

function BattleFundProxy:GetActData()
  return self.actData
end

function BattleFundProxy:GetConfig()
  if self.actData then
    return self.actData:GetConfig()
  end
  return nil
end

function BattleFundProxy:RecvBattleFundInfo(serverData)
  if not serverData then
    return
  end
  local info = serverData and serverData.info
  if self.actData and self.actData.actId == info.activityid then
    self.actData:SetData(info)
  else
    self.actData = BattleFundData.new(info)
    if self.actData:IsActive() and not self.actData:HasPurchased() then
      local config = self.actData:GetConfig()
      if config then
        ServiceUserEventProxy.Instance:CallChargeQueryCmd(config.DepositID)
      end
    end
  end
  if self.actData:HasUntakenReward() then
    local lastRedTipTime = PlayerPrefs.GetInt("LastBattleFundRedTip", 0)
    local curTimeStamp = ServerTime.CurServerTime() / 1000
    if not ClientTimeUtil.IsSameDay(lastRedTipTime, curTimeStamp) then
      RedTipProxy.Instance:UpdateRedTip(BattleFundProxy.RedTipID)
      PlayerPrefs.SetInt("LastBattleFundRedTip", curTimeStamp)
    end
  else
    RedTipProxy.Instance:RemoveWholeTip(BattleFundProxy.RedTipID)
  end
end

function BattleFundProxy:TakeReward(day, free, resetDepositReward)
  local actId = self.actData and self.actData:GetActId()
  if actId then
    ServiceActivityCmdProxy.Instance:CallBattleFundRewardActCmd(actId, day, free, resetDepositReward)
  end
end

function BattleFundProxy:HasPurchased()
  return self.actData and self.actData:HasPurchased()
end

function BattleFundProxy:CanPurchase()
  return self.actData and self.actData:CanPurchase()
end

function BattleFundProxy:GetLeftBuyTime()
  if not self.actData then
    return 0
  end
  return self.actData:GetLeftBuyTime()
end

function BattleFundProxy:GetRewardDatas()
  return self.actData and self.actData:GetRewardDatas() or {}
end

function BattleFundProxy:RecvQueryChargeCnt(serverData)
  if self.actData then
    self.actData:UpdatePurchaseCnt(serverData)
  end
end

function BattleFundProxy:RecvChargeQueryCmd(serverData)
  if self.actData then
    self.actData:RecvChargeQueryCmd(serverData)
  end
end

function BattleFundProxy:GetTakableRewards()
  if self.actData then
    return self.actData:GetTakableRewards()
  end
  return 0
end

function BattleFundProxy:GetResetDepositReward()
  if self.actData then
    return self.actData:GetResetDepositReward()
  end
  return false
end

function BattleFundProxy:HasResetDepositReward()
  if self.actData then
    return self.actData:HasResetDepositReward()
  end
  return false
end
