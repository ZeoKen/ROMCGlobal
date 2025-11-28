ProfessionNewHeroStoryData = class("ProfessionNewHeroStoryData")

function ProfessionNewHeroStoryData:ctor(serverData)
  local staticData = Table_HeroStoryQuest[serverData.id]
  self:SetStaticData(staticData)
  self:SetServerData(serverData)
end

function ProfessionNewHeroStoryData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end

function ProfessionNewHeroStoryData:SetServerData(serverData)
  if serverData and serverData.id == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.state = serverData.queststate
    local reward = serverData.reward
    if reward and 0 < #reward then
      if not self.rewards then
        self.rewards = {}
      else
        TableUtility.ArrayClear(self.rewards)
      end
      for i = 1, #reward do
        local questid = reward[i].questid
        local onceRewardMap = QuestProxy.Instance:GetOnceRewardByQuestID(questid)
        local pairReward = reward[i].reward
        for j = 1, #pairReward do
          if pairReward[j].origin_reward and pairReward[j].origin_reward ~= 0 then
            table.insert(self.rewards, pairReward[j].replace_reward)
            if onceRewardMap and onceRewardMap[pairReward[j].origin_reward] then
              table.insert(self.rewards, onceRewardMap[pairReward[j].origin_reward])
            else
              table.insert(self.rewards, pairReward[j].origin_reward)
            end
          end
        end
      end
    end
  end
end

function ProfessionNewHeroStoryData:IsLocked()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUEST_STATE_UNLOCK
end

function ProfessionNewHeroStoryData:IsWaitUnlock()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUEST_STATE_UNACCEPT
end

function ProfessionNewHeroStoryData:IsInProgress()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUEST_STATE_INPROCESS
end

function ProfessionNewHeroStoryData:IsCompleted()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUEST_STATE_COMPLETE
end

function ProfessionNewHeroStoryData:IsRewarded()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUEST_STATE_REWARD
end

function ProfessionNewHeroStoryData:UnlockByServer()
  if self:IsWaitUnlock() then
    self.serverData.state = SceneUser3_pb.HEROSTORY_QUEST_STATE_INPROCESS
  end
end

function ProfessionNewHeroStoryData:GetTitlePrefix()
  return self.staticData and self.staticData.StoryNamePrefix or ""
end

function ProfessionNewHeroStoryData:GetTitle()
  return self.staticData and self.staticData.StoryName or ""
end

function ProfessionNewHeroStoryData:GetDesc()
  return self.staticData and self.staticData.StoryContent or ""
end

function ProfessionNewHeroStoryData:GetUnlockDesc()
  return self.staticData and self.staticData.UnlockDesc or ""
end

function ProfessionNewHeroStoryData:GetQuestData()
  local firstQuestId = self.staticData and self.staticData.FirstQuestID
  if firstQuestId then
    return QuestProxy.Instance:getSameQuestID(firstQuestId)
  end
end

function ProfessionNewHeroStoryData:GetTaskDesc()
  local questData = self:GetQuestData()
  if questData then
    return questData:parseTranceInfo()
  end
  return ""
end

function ProfessionNewHeroStoryData:GetReward()
  return self.staticData and self.staticData.Reward and self.staticData.Reward[1]
end

function ProfessionNewHeroStoryData:GetRewardItemId()
  local reward = self:GetReward()
  return reward and reward[1]
end

function ProfessionNewHeroStoryData:GetRewardItemIcon()
  local itemId = self:GetRewardItemId()
  if itemId then
    local itemConfig = Table_Item[itemId]
    return itemConfig and itemConfig.Icon
  end
end

function ProfessionNewHeroStoryData:GetRewardItemNum()
  local reward = self:GetReward()
  return reward and reward[2]
end

function ProfessionNewHeroStoryData:OnRewarded()
  if self:IsCompleted() then
    self.serverData.state = SceneUser3_pb.HEROSTORY_QUEST_STATE_REWARD
  end
end

function ProfessionNewHeroStoryData:GetReplacedRewards()
  return self.rewards
end
