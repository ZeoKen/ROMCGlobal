autoImport("ActivityBattlePassLevelRewardCell")
ActivityPaySignRewardCell = class("ActivityPaySignRewardCell", ActivityBattlePassLevelRewardCell)

function ActivityPaySignRewardCell:FindObjs()
  ActivityPaySignRewardCell.super.FindObjs(self)
  self.advReceivedCheck = self:FindGO("AdvGet")
  self.superReceivedCheck = self:FindGO("SuperGet")
  self.superRewardGO = self:FindGO("Super")
  if self.superRewardGO then
    self.superHolder = self:FindGO("holder", self.superRewardGO)
    self.superMask = self:FindGO("SuperCover", self.superRewardGO)
    self:AddClickEvent(self.superRewardGO, function()
      self:HandleClickRewardIcon(self.superItemCell)
    end)
  end
end

function ActivityPaySignRewardCell:SetPaySignRewardIcon(itemCell, rewardItem, holder)
  if not holder then
    return itemCell
  end
  if not rewardItem or not rewardItem[1] then
    if itemCell and itemCell.gameObject then
      itemCell.gameObject:SetActive(false)
    end
    return itemCell
  end
  if itemCell then
    if itemCell.gameObject then
      itemCell.gameObject:SetActive(true)
    end
    local data = itemCell.data or ItemData.new(rewardItem[1], rewardItem[1])
    data:ResetData(rewardItem[1], rewardItem[1])
    data:SetItemNum(rewardItem[2])
    itemCell:SetData(data)
    return itemCell
  end
  return self:SetRewardIcon(rewardItem[1], rewardItem[2], holder)
end

function ActivityPaySignRewardCell:SetData(data)
  if data then
    self.gameObject:SetActive(true)
    self.data = data
    self.level = data.Day
    self.levelLabel.text = string.format(ZhString.ActivityPaySignView_Day, self.level)
    local basicRewardItem = data.RewardItems and data.RewardItems[1]
    local proRewardItem = data.ProRewardItems and data.ProRewardItems[1]
    local superRewardItem = data.SuperRewardItems and data.SuperRewardItems[1]
    self.basicItemCell = self:SetPaySignRewardIcon(self.basicItemCell, basicRewardItem, self.basicHolder)
    self.advItemCell = self:SetPaySignRewardIcon(self.advItemCell, proRewardItem, self.advHolder)
    self.superItemCell = self:SetPaySignRewardIcon(self.superItemCell, superRewardItem, self.superHolder)
    if self.superRewardGO then
      self.superRewardGO:SetActive(superRewardItem ~= nil)
    end
    self:RefreshRecvState(self.level)
  else
    self.gameObject:SetActive(false)
  end
end

function ActivityPaySignRewardCell:HasSuperReward()
  return self.data and self.data.SuperRewardItems and #self.data.SuperRewardItems > 0 and self.superRewardGO ~= nil or false
end

function ActivityPaySignRewardCell:RefreshRecvState(level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isBasicLocked = self:GetIsNormalRewardLocked(level)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  local isAdvLocked = self:GetIsProRewardLocked(level)
  local hasSuperReward = self:HasSuperReward()
  local isSuperReceived = not hasSuperReward or self:GetIsSuperRewardReceived(level)
  local isSuperLocked = hasSuperReward and self:GetIsSuperRewardLocked(level) or false
  local isRewardAvailable = not isBasicLocked and not isBasicReceived or not isAdvLocked and not isAdvReceived or hasSuperReward and not isSuperLocked and not isSuperReceived
  local hasLockedReward = isAdvLocked or hasSuperReward and isSuperLocked
  self.basicReceivedCheck:SetActive(isBasicReceived or false)
  if self.advReceivedCheck then
    self.advReceivedCheck:SetActive(isAdvReceived or false)
  end
  self.basicMask:SetActive(isBasicLocked)
  self.advMask:SetActive(isAdvLocked)
  if self.superMask then
    self.superMask:SetActive(hasSuperReward and isSuperLocked or false)
  end
  if self.superReceivedCheck then
    self.superReceivedCheck:SetActive(hasSuperReward and isSuperReceived or false)
  end
  self.receivedSp:SetActive(isBasicReceived and isAdvReceived and isSuperReceived or false)
  self.locker:SetActive(not isRewardAvailable and hasLockedReward and (isBasicLocked or isBasicReceived) or false)
  self.getLabel:SetActive(isRewardAvailable)
  self.buyBtn:SetActive(false)
  if isBasicReceived then
    self:UpdateBuyInfo()
  end
end

function ActivityPaySignRewardCell:GetIsNormalRewardReceived(day)
  return ActivityPaySignProxy.Instance:IsNormalRewardReceived(self.data.ActID, day)
end

function ActivityPaySignRewardCell:GetIsNormalRewardLocked(day)
  return ActivityPaySignProxy.Instance:IsNormalRewardLocked(self.data.ActID, day)
end

function ActivityPaySignRewardCell:GetIsProRewardReceived(day)
  return ActivityPaySignProxy.Instance:IsProRewardReceived(self.data.ActID, day)
end

function ActivityPaySignRewardCell:GetIsProRewardLocked(day)
  return ActivityPaySignProxy.Instance:IsProRewardLocked(self.data.ActID, day)
end

function ActivityPaySignRewardCell:GetIsSuperRewardReceived(day)
  return ActivityPaySignProxy.Instance:IsSuperRewardReceived(self.data.ActID, day)
end

function ActivityPaySignRewardCell:GetIsSuperRewardLocked(day)
  return ActivityPaySignProxy.Instance:IsSuperRewardLocked(self.data.ActID, day)
end

function ActivityPaySignRewardCell:UpdateBuyInfo()
end
