autoImport("ActivityBattlePassLevelRewardCell")
ActivityPaySignRewardCell = class("ActivityPaySignRewardCell", ActivityBattlePassLevelRewardCell)

function ActivityPaySignRewardCell:SetData(data)
  if data then
    self.gameObject:SetActive(true)
    self.data = data
    self.level = data.Day
    self.levelLabel.text = string.format(ZhString.ActivityPaySignView_Day, self.level)
    local basicRewardItem = data.RewardItems[1]
    local proRewardItem = data.ProRewardItems[1]
    if not self.basicItemCell then
      self.basicItemCell = self:SetRewardIcon(basicRewardItem and basicRewardItem[1], basicRewardItem and basicRewardItem[2], self.basicHolder)
    else
      local data = self.basicItemCell.data
      data:ResetData(basicRewardItem[1], basicRewardItem[1])
      data:SetItemNum(basicRewardItem[2])
      self.basicItemCell:SetData(data)
    end
    if not self.advItemCell then
      self.advItemCell = self:SetRewardIcon(proRewardItem and proRewardItem[1], proRewardItem and proRewardItem[2], self.advHolder)
    else
      local data = self.advItemCell.data
      data:ResetData(proRewardItem[1], proRewardItem[1])
      data:SetItemNum(proRewardItem[2])
      self.advItemCell:SetData(data)
    end
    self:RefreshRecvState(self.level)
  else
    self.gameObject:SetActive(false)
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

function ActivityPaySignRewardCell:UpdateBuyInfo()
end
