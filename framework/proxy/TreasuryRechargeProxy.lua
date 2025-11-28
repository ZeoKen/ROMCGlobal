TreasuryRechargeProxy = class("TreasuryRechargeProxy", pm.Proxy)
TreasuryRechargeProxy.Instance = nil
TreasuryRechargeProxy.NAME = "TreasuryRechargeProxy"
TreasuryRechargeProxy.RedTipID = SceneTip_pb.EREDSYS_BOLI_GOLD

function TreasuryRechargeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TreasuryRechargeProxy.NAME
  if TreasuryRechargeProxy.Instance == nil then
    TreasuryRechargeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function TreasuryRechargeProxy:Init()
  self.actId = 0
end

function TreasuryRechargeProxy:RecvBoliGoldInfoCmd(data)
  self.actId = data.act_id
  if not self.actId or self.actId == 0 then
    return
  end
  self.selected = {}
  TableUtility.ArrayShallowCopy(self.selected, data.selected)
  self.gotRewards = {}
  TableUtility.ArrayShallowCopy(self.gotRewards, data.gotten_rewards)
  self.restKeyCount = data.rest_key or 0
  self.hasGotFree = data.free_reward_gotten or false
  self.deposit = data.deposit_gold
  xdlog("充值数据", self.restKeyCount, self.hasGotFree, self.deposit)
  self:CheckRedTip()
end

function TreasuryRechargeProxy:RecvBoliGoldGetFreeReward(data)
  self.hasGotFree = true
  self:CheckRedTip()
end

function TreasuryRechargeProxy:RecvBoliGoldGetReward(data)
  local reward = data.reward
  local restKey = data.rest_key
  local select = data.select
  if not self.gotRewards then
    self.gotRewards = {}
  end
  if not self.selected then
    self.selected = {}
  end
  table.insert(self.gotRewards, reward)
  table.insert(self.selected, select)
  self.restKeyCount = restKey
  self:CheckRedTip()
end

function TreasuryRechargeProxy:IsActive()
  if not self.actId then
    return false
  end
  if not Table_BoliGold then
    return false
  end
  local actConfig = Table_BoliGold[self.actId]
  if not actConfig then
    return false
  end
  local actTime = EnvChannel.IsTFBranch() and actConfig.TfTime or actConfig.Time
  local startTime = actTime[1]
  local endTime = actTime[2]
  if not startTime or not endTime then
    return false
  end
  if KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) then
    return true
  else
    return false
  end
end

function TreasuryRechargeProxy:CheckRedTip()
  local hasRedtip = false
  if self.restKeyCount and self.restKeyCount > 0 then
    hasRedtip = true
  end
  if not self.hasGotFree then
    hasRedtip = true
  end
  if hasRedtip then
    RedTipProxy.Instance:UpdateRedTip(TreasuryRechargeProxy.RedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(TreasuryRechargeProxy.RedTipID)
  end
end

function TreasuryRechargeProxy:GetConfig()
  return GameConfig.BoliGold
end

function TreasuryRechargeProxy:CallBoliGoldGetReward(index)
  xdlog("申请拉宝箱", index)
  ServiceSceneUser3Proxy.Instance:CallBoliGoldGetReward(index)
end

function TreasuryRechargeProxy:CallBoliGoldGetFreeReward()
  ServiceSceneUser3Proxy.Instance:CallBoliGoldGetFreeReward()
end
