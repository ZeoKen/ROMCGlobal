GuildTaskTraceData = class("GuildTaskTraceData")
GuildTaskTraceData.SortID = {
  Finished = 0,
  Going = 1,
  Reward = 2
}

function GuildTaskTraceData:ctor()
  self.addServerRewardNum = 0
end

function GuildTaskTraceData:SetChallengeData(data)
  self.id = data.id
  self.isChallenge = true
  self.reward = data.reward
  local sData = Table_GuildChallenge[self.id]
  if nil == sData then
    sData = Table_GuildBuilding[self.id]
  end
  if nil == sData then
    redlog("前后端配置不一致,检查GuildChallenge、GuildBuilding,error id:", self.id)
    return
  end
  self.target = sData.Target
  self.unlockID = sData.UnlockID
  self.name = sData.Name
  self:SetServerRewardItem(data.rewarditem)
  self.desc = sData.Traceinfo
  self.isFinished = data.progress >= self.target
  if self.reward then
    self.sortID = GuildTaskTraceData.SortID.Reward
  else
    self.sortID = self.isFinished and GuildTaskTraceData.SortID.Finished or GuildTaskTraceData.SortID.Going
  end
  self.progress = string.format(ZhString.GuildChallenge_Progress, data.progress, self.target)
end

function GuildTaskTraceData:SetBuildingData(id, refresh_time, reward)
  self.id = id
  self.isBuilding = true
  self.refreshTime = refresh_time
  self.reward = reward
  self.sortID = self.reward and GuildTaskTraceData.SortID.Reward or GuildTaskTraceData.SortID.Going
  local sData = Table_GuildBuilding[self.id]
  if nil == sData then
    return
  end
  self.name = sData.TraceTitle or ""
  self.buildingType = sData.Type
  self.progress = string.format(ZhString.GuildChallenge_BuildingProgress, sData.Level)
  self:SetStaticRewardItem(sData)
  if self.reward_item and sData.RewardCycle then
    local reward_name = self.reward_item:GetName()
    self.desc = string.format(sData.Traceinfo, math.floor(sData.RewardCycle / 3600), reward_name, self.reward_item.num)
  else
    self.desc = ""
  end
end

function GuildTaskTraceData:SetStaticRewardItem(sData)
  local rewardid = sData.Reward
  if rewardid then
    local rewardStaticData = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
    if rewardStaticData and 0 < #rewardStaticData then
      self.reward_item = ItemData.new("guild_guilding", rewardStaticData[1].id)
      self.reward_item:SetItemNum(rewardStaticData[1].num)
    end
  end
end

function GuildTaskTraceData:SetServerRewardItem(itemInfo)
  local itemid = itemInfo and itemInfo.id
  if itemid then
    self.reward_item = ItemData.new("guild_task", itemid)
    self.reward_item:SetItemNum(itemInfo.count)
  end
end
