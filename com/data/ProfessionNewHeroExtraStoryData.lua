ProfessionNewHeroExtraStoryData = class("ProfessionNewHeroExtraStoryData")

function ProfessionNewHeroExtraStoryData:ctor(storyDatas, serverData)
  self:SetServerData(storyDatas, serverData)
end

function ProfessionNewHeroExtraStoryData:SetServerData(storyDatas, serverData)
  if not storyDatas or not serverData then
    return
  end
  self.progress = 0
  self.goal = #storyDatas
  self.rewardData = {}
  for _, data in ipairs(storyDatas) do
    if data:IsCompleted() or data:IsRewarded() then
      self.progress = self.progress + 1
    end
    local extraReward = data.staticData and data.staticData.ExtraReward
    if extraReward and 0 < #extraReward then
      local rewardConfig = extraReward[1].Reward[1]
      self.rewardData[1] = rewardConfig and rewardConfig[1]
      self.rewardData[2] = rewardConfig and rewardConfig[2]
      self.questId = data.staticData.id
      self.completeNum = extraReward[1].complete_num
    end
  end
  self.isRewarded = self.completeNum and serverData.extra_rewarded_id and table.ContainsValue(serverData.extra_rewarded_id, self.completeNum)
end

function ProfessionNewHeroExtraStoryData:GetReward()
  return self.rewardData
end

function ProfessionNewHeroExtraStoryData:GetRewardItemId()
  return self.rewardData and self.rewardData[1]
end

function ProfessionNewHeroExtraStoryData:GetRewardItemIcon()
  local itemId = self:GetRewardItemId()
  local itemConfig = itemId and Table_Item[itemId]
  return itemConfig and itemConfig.Icon
end

function ProfessionNewHeroExtraStoryData:GetRewardItemNum()
  return self.rewardData and self.rewardData[2]
end

function ProfessionNewHeroExtraStoryData:IsCompleted()
  return self.progress and self.goal and self.goal > 0 and self.progress >= self.goal
end

function ProfessionNewHeroExtraStoryData:IsRewarded()
  return self.isRewarded
end

function ProfessionNewHeroExtraStoryData:IsAllComplete()
  if self:IsCompleted() then
    if not self.completeNum then
      return true
    else
      return self:IsRewarded()
    end
  end
end

function ProfessionNewHeroExtraStoryData:OnRewarded()
  if self:IsCompleted() then
    self.isRewarded = true
  end
end

function ProfessionNewHeroExtraStoryData:GetProgressStr()
  return self.progress and self.goal and string.format("%d/%d", self.progress, self.goal) or ""
end
