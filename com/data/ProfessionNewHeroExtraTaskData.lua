ProfessionNewHeroExtraTaskData = class("ProfessionNewHeroExtraTaskData")

function ProfessionNewHeroExtraTaskData:ctor(storyDatas, serverData)
  self:SetServerData(storyDatas, serverData)
end

function ProfessionNewHeroExtraTaskData:SetServerData(taskDatas, serverData)
  if not taskDatas or not serverData then
    return
  end
  self.progress = 0
  self.goal = #taskDatas
  self.rewardData = {}
  for _, data in ipairs(taskDatas) do
    if data:IsCompleted() or data:IsRewarded() then
      self.progress = self.progress + 1
    end
    local extraReward = data.staticData and data.staticData.ExtraReward
    if extraReward and 0 < #extraReward then
      local rewardConfig = extraReward[1].Reward[1]
      self.rewardData[1] = rewardConfig and rewardConfig[1]
      self.rewardData[2] = rewardConfig and rewardConfig[2]
      self.completeNum = extraReward[1].complete_num
    end
  end
  self.isRewarded = self.completeNum and serverData.extra_rewarded_id and table.ContainsValue(serverData.extra_rewarded_id, self.completeNum)
  xdlog("任务进展", self.progress, self.goal, self.isRewarded)
end

function ProfessionNewHeroExtraTaskData:GetReward()
  return self.rewardData
end

function ProfessionNewHeroExtraTaskData:GetRewardItemId()
  return self.rewardData and self.rewardData[1]
end

function ProfessionNewHeroExtraTaskData:GetRewardItemIcon()
  local itemId = self:GetRewardItemId()
  local itemConfig = itemId and Table_Item[itemId]
  return itemConfig and itemConfig.Icon
end

function ProfessionNewHeroExtraTaskData:GetRewardItemNum()
  return self.rewardData and self.rewardData[2]
end

function ProfessionNewHeroExtraTaskData:IsCompleted()
  return self.progress and self.goal and self.goal > 0 and self.progress >= self.goal
end

function ProfessionNewHeroExtraTaskData:IsRewarded()
  return self.isRewarded
end

function ProfessionNewHeroExtraTaskData:OnRewarded()
  if self:IsCompleted() then
    self.isRewarded = true
  end
end

function ProfessionNewHeroExtraTaskData:GetProgressStr()
  return self.progress and self.goal and string.format("%d/%d", self.progress, self.goal) or ""
end
