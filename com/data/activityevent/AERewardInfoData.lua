AERewardInfoData = class("AERewardInfoData")

function AERewardInfoData:ctor(data, begintime, endtime)
  self:SetData(data)
  self:SetTime(begintime, endtime)
end

function AERewardInfoData:SetData(data)
  if data ~= nil then
    self.mode = data.mode
    self.multiple = data.multiplereward.multiple
    self.multipleDaylimit = data.multiplereward.daylimit
    self.multipleAcclimit = data.multiplereward.acclimit
    self.extratimes = data.extratimes
    local extraRewards = data.extrareward
    local rewards = extraRewards and extraRewards.rewards
    local rewardList = {}
    if rewards and 0 < #rewards then
      for i = 1, #rewards do
        local reward = {
          id = rewards[i].id,
          count = rewards[i].count
        }
        table.insert(rewardList, reward)
      end
    end
    self.extraRewards = rewardList
    self.extraDayLimit = extraRewards.daylimit
    self.extraAccLimit = extraRewards.acclimit
    self.extraFinishCnt = extraRewards.finishcount
  end
end

function AERewardInfoData:SetTime(begintime, endtime)
  self.beginTime = begintime
  self.endTime = endtime
end

function AERewardInfoData:IsInActivity()
  if self.beginTime ~= nil and self.endTime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.beginTime and server <= self.endTime
  else
    return true
  end
end

function AERewardInfoData:CheckMultipleReward()
  local _ActivityEventProxy = ActivityEventProxy.Instance
  local userData = _ActivityEventProxy:GetUserDataByType(self.mode)
  local multipledaycount = userData and userData:GetMultipleDayCount() or 0
  if self.multipleDaylimit ~= 0 and multipledaycount >= self.multipleDaylimit then
    return false
  end
  if self.multipleAcclimit then
    local multipleacclimitcharid = userData and userData:GetMultipleAcclimitCharid() or 0
    if multipleacclimitcharid ~= 0 and multipleacclimitcharid ~= Game.Myself.data.id then
      return false
    end
  end
  return true
end

function AERewardInfoData:GetMultiple()
  if self:CheckMultipleReward() then
    return self.multiple
  else
    return 0
  end
end

function AERewardInfoData:GetExtraTimes()
  return self.extratimes
end

function AERewardInfoData:CheckExtraRewardValid()
  local _ActivityEventProxy = ActivityEventProxy.Instance
  local userData = _ActivityEventProxy:GetUserDataByType(self.mode)
  local limitCharid = userData and userData:GetAccLimitCharID()
  if limitCharid and limitCharid ~= 0 and limitCharid ~= Game.Myself.data.id then
    return false
  end
  local extradaycount = userData and userData:GetExtraDayCount() or 0
  if self.extraDayLimit and self.extraDayLimit ~= 0 and extradaycount >= self.extraDayLimit then
    return false
  end
  return true
end

function AERewardInfoData:GetExtraRewardCount()
  local _ActivityEventProxy = ActivityEventProxy.Instance
  local userData = _ActivityEventProxy:GetUserDataByType(self.mode)
  local extradaycount = userData and userData:GetExtraDayCount() or 0
  local daylimit = self.extraDayLimit
  local acclimit = self.extraAccLimit
  return extradaycount, daylimit, acclimit
end

function AERewardInfoData:GetExtraRewards()
  return self.extraRewards
end
