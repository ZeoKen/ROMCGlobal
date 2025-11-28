PaySignInfoData = class("PaySignInfoData")

function PaySignInfoData:ctor(data)
  self.activityID = data.activityid
  self.cfg = PaySignProxy.Instance:GetConfig_PaySign(self.activityID)
  if nil == self.cfg then
    local curServer = FunctionLogin.Me():getCurServerData()
    local serverID = curServer and curServer.linegroup or 1
    redlog("检查前后端配置是否一致  | 服务器同步activityID错误，未在PaySign表里配置 activityID | serverID : ", self.activityID, serverID)
  end
  self.isNovice = nil ~= GameConfig.PaySign[data.activityid] and GameConfig.PaySign[data.activityid].noviceMode == true
  self.rewardDay = data.rewardday
  self.unrewardDay = data.unrewardday
  if self.rewardDay >= #self.cfg then
    self.status = PaySignProxy.RECEIVE_REWARD_STATUS.FINISHED
  elseif self.unrewardDay > 0 then
    self.status = PaySignProxy.RECEIVE_REWARD_STATUS.CANRECEIVE
  else
    self.status = PaySignProxy.RECEIVE_REWARD_STATUS.WAIT
  end
  self.buyTime = data.buytime
  self.startTime = data.starttime
  self.freeReward = data.freereward
  self.isFree = GameConfig.PaySign[data.activityid] and GameConfig.PaySign[data.activityid].isfree == 1 or false
end

function PaySignInfoData:CheckPurchased()
  if self.isFree then
    return true
  end
  return nil ~= self.buyTime and self.buyTime > 0
end

function PaySignInfoData:HasFreeReward()
  return self.freeReward == false
end
