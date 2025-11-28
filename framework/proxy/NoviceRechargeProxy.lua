NoviceRechargeProxy = class("NoviceRechargeProxy", pm.Proxy)

function NoviceRechargeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "NoviceRechargeProxy"
  if NoviceRechargeProxy.Instance == nil then
    NoviceRechargeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

NoviceRechargeProxy.redtipID = SceneTip_pb.EREDSYS_NOVICE_CHARGE

function NoviceRechargeProxy:Init()
  self.loginStatus = {}
  self:InitCurrencyType()
end

function NoviceRechargeProxy:InitCurrencyType()
  if not Table_NoviceCharge then
    return
  end
  for _, config in pairs(Table_NoviceCharge) do
    local reward = config.Reward
    for i = 1, #reward do
      if reward[i].Deposit then
        local depositID
        if type(reward[i].Deposit) == "table" then
          depositID = reward[i].Deposit[1]
        elseif type(reward[i].Deposit) == "number" then
          depositID = reward[i].Deposit
        end
        local depositConfig = Table_Deposit[depositID]
        if not depositConfig then
          redlog("no deposit", reward[i].Deposit)
        elseif depositConfig.CurrencyType and depositConfig.CurrencyType ~= "" then
          self.currencyType = depositConfig.CurrencyType
          break
        end
      end
    end
  end
end

function NoviceRechargeProxy:GetEndDate()
  return self.end_time
end

function NoviceRechargeProxy:GetActValid()
  local endTime = self:GetEndDate()
  if endTime and endTime > ServerTime.CurServerTime() / 1000 then
    return true
  end
  return false
end

function NoviceRechargeProxy:GetCurrencyType()
  return self.currencyType
end

function NoviceRechargeProxy:GetLoginStatus(index)
  if not self.loginStatus then
    return
  end
  if self.loginStatus[index] then
    return self.loginStatus[index]
  end
end

function NoviceRechargeProxy:CheckRedtip()
  if not self.loginStatus then
    return
  end
  local hasRedtip = false
  for k, v in pairs(self.loginStatus) do
    if v.login_day > v.reward_day then
      hasRedtip = true
    end
  end
  if hasRedtip then
    RedTipProxy.Instance:UpdateRedTip(NoviceRechargeProxy.redtipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(NoviceRechargeProxy.redtipID)
  end
end

function NoviceRechargeProxy:RecvNoviceChargeSyncCmd(data)
  self.activityID = data.act_id
  self.end_time = data.end_time
  local items = data.items
  TableUtility.TableClear(self.loginStatus)
  if items and 0 < #items then
    for i = 1, #items do
      local single = items[i]
      local data = {
        login_day = single.login_day,
        reward_day = single.reward_day
      }
      if data.login_day > 3 then
        data.login_day = 3
      end
      table.insert(self.loginStatus, data)
      self.loginStatus[tostring(single.item_id)] = data
    end
  end
  self:CheckRedtip()
end

function NoviceRechargeProxy:RecvNoviceChargeReward(data)
  local itemid = data.item_id
  local status = self.loginStatus[tostring(itemid)]
  if not status then
    return
  end
  status.reward_day = status.login_day
  if status.reward_day > 3 then
    status.reward_day = 3
  end
  self:CheckRedtip()
end
