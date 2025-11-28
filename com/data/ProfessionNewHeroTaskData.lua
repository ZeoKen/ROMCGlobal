ProfessionNewHeroTaskData = class("ProfessionNewHeroTaskData")

function ProfessionNewHeroTaskData:ctor(serverData)
  local staticData = Table_HeroGrowthQuest[serverData.id]
  self:SetStaticData(staticData)
  self:SetServerData(serverData)
end

function ProfessionNewHeroTaskData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end

function ProfessionNewHeroTaskData:SetServerData(serverData)
  if serverData and serverData.id == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.process = serverData.process
    self.serverData.goal = serverData.goal
    self.serverData.isRewarded = serverData.is_reward
  end
end

function ProfessionNewHeroTaskData:IsCompleted()
  return self.serverData and self.serverData.process >= self.serverData.goal
end

function ProfessionNewHeroTaskData:IsRewarded()
  return self.serverData and self.serverData.isRewarded
end

function ProfessionNewHeroTaskData:GetProcess()
  return self.serverData and self.serverData.process or 0
end

function ProfessionNewHeroTaskData:GetGoal()
  return self.serverData and self.serverData.goal or 0
end

function ProfessionNewHeroTaskData:GetTraceInfo()
  local traceInfo = self.staticData and self.staticData.TraceInfo or ""
  return traceInfo
end

function ProfessionNewHeroTaskData:GetGoto()
  return self.staticData and self.staticData.Goto
end

function ProfessionNewHeroTaskData:GetProgressStr()
  local progress = self:GetProcess() or 0
  local goal = self:GetGoal() or 1
  if progress == 0 then
    return string.format("([c][f56556]%s[-][/c]/%s)", progress, goal)
  else
    return string.format("(%s/%s)", progress, goal)
  end
end

function ProfessionNewHeroTaskData:GetReward()
  return self.staticData and self.staticData.Reward and self.staticData.Reward[1]
end

function ProfessionNewHeroTaskData:GetRewardItemId()
  local reward = self:GetReward()
  return reward and reward[1]
end

function ProfessionNewHeroTaskData:GetRewardItemIcon()
  local itemId = self:GetRewardItemId()
  if itemId then
    local itemConfig = Table_Item[itemId]
    return itemConfig and itemConfig.Icon
  end
end

function ProfessionNewHeroTaskData:GetRewardItemNum()
  local reward = self:GetReward()
  return reward and reward[2]
end

function ProfessionNewHeroTaskData:OnRewarded()
  if self:IsCompleted() then
    self.serverData.isRewarded = true
  end
end
