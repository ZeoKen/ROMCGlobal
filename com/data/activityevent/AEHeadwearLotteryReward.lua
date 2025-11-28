AEHeadwearLotteryReward = class("AEHeadwearLotteryReward")

function AEHeadwearLotteryReward:ctor(data)
  self.rewardlist = {}
  self:SetData(data)
end

function AEHeadwearLotteryReward:SetData(data)
  if nil ~= data and data.cfgs then
    TableUtility.TableClear(self.rewardlist)
    for i = 1, #data.cfgs do
      local single = {}
      single.edge = data.cfgs[i].edge
      local reward = data.cfgs[i].rewards and data.cfgs[i].rewards[1] or {}
      single.itemid = reward.id
      single.count = reward.count
      table.insert(self.rewardlist, single)
    end
  end
end

function AEHeadwearLotteryReward:SetTime(begintime, endtime)
  self.beginTime = begintime
  self.endTime = endtime
end

function AEHeadwearLotteryReward:IsInActivity()
  if self.beginTime ~= nil and self.endTime ~= nil then
    local server = ServerTime.CurServerTime() / 1000
    return server >= self.beginTime and server <= self.endTime
  else
    return true
  end
end

function AEHeadwearLotteryReward:GetRewardList()
  if self:IsInActivity() then
    return self.rewardlist
  else
    return nil
  end
end
