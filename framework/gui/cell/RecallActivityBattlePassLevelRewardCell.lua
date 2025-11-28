autoImport("ActivityBattlePassLevelRewardCell")
RecallActivityBattlePassLevelRewardCell = class("RecallActivityBattlePassLevelRewardCell", ActivityBattlePassLevelRewardCell)

function RecallActivityBattlePassLevelRewardCell:GetIsNormalRewardReceived(level)
  return RecallActivityBattlePassProxy.Instance:IsNormalRewardReceived(level)
end

function RecallActivityBattlePassLevelRewardCell:GetIsNormalRewardLocked(level)
  return RecallActivityBattlePassProxy.Instance:IsNormalRewardLocked(level)
end

function RecallActivityBattlePassLevelRewardCell:GetIsProRewardReceived(level)
  return RecallActivityBattlePassProxy.Instance:IsProRewardReceived(level)
end

function RecallActivityBattlePassLevelRewardCell:GetIsProRewardLocked(level)
  return RecallActivityBattlePassProxy.Instance:IsProRewardLocked(level)
end

function RecallActivityBattlePassLevelRewardCell:SetData(data)
  if data then
    self.data = data
    self.level = data.Level
    self.levelLabel.text = "Lv." .. self.level
    local basicRewardItem = data.NormalReward[1]
    local proRewardItem = data.AdvanceReward[1]
    if not self.basicItemCell then
      self.basicItemCell = self:SetRewardIcon(basicRewardItem, self.basicHolder)
    else
      local data = self.basicItemCell.data
      data:ResetData(basicRewardItem[1], basicRewardItem[1])
      data:SetItemNum(basicRewardItem[2])
      self.basicItemCell:SetData(data)
    end
    if not self.advItemCell then
      self.advItemCell = self:SetRewardIcon(proRewardItem, self.advHolder)
    else
      local data = self.advItemCell.data
      data:ResetData(proRewardItem[1], proRewardItem[1])
      data:SetItemNum(proRewardItem[2])
      self.advItemCell:SetData(data)
    end
    self:RefreshRecvState(self.level)
  end
end

function RecallActivityBattlePassLevelRewardCell:SetRewardIcon(data, holder)
  if not data then
    return
  end
  local itemCell = ActivityBattlePassItemCell.new(holder)
  itemCell:AddCellClickEvent()
  local itemData = ItemData.new(data[1], data[1])
  itemData:SetItemNum(data[2])
  itemCell:SetData(itemData)
  return itemCell
end

function RecallActivityBattlePassLevelRewardCell:UpdateBuyInfo()
end
