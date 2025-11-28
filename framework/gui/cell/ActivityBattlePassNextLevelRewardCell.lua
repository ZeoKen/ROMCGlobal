autoImport("ActivityBattlePassLevelRewardCell")
ActivityBattlePassNextLevelRewardCell = class("ActivityBattlePassNextLevelRewardCell", ActivityBattlePassLevelRewardCell)

function ActivityBattlePassNextLevelRewardCell:FindObjs()
  ActivityBattlePassNextLevelRewardCell.super.FindObjs(self)
  local basic = self:FindGO("Basic")
  self.basicTitleBg = self:FindGO("titleBg", basic)
end

function ActivityBattlePassNextLevelRewardCell:RefreshRecvState(level)
  ActivityBattlePassNextLevelRewardCell.super.RefreshRecvState(self, level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  self.basicTitleBg:SetActive(not isBasicReceived or isAdvReceived)
end
