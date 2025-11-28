autoImport("RecallActivityBattlePassLevelRewardCell")
RecallActivityBattlePassNextLevelRewardCell = class("RecallActivityBattlePassNextLevelRewardCell", RecallActivityBattlePassLevelRewardCell)

function RecallActivityBattlePassNextLevelRewardCell:FindObjs()
  RecallActivityBattlePassNextLevelRewardCell.super.FindObjs(self)
  local basic = self:FindGO("Basic")
  self.basicTitleBg = self:FindGO("titleBg", basic)
end

function RecallActivityBattlePassNextLevelRewardCell:RefreshRecvState(level)
  RecallActivityBattlePassNextLevelRewardCell.super.RefreshRecvState(self, level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  self.basicTitleBg:SetActive(not isBasicReceived or isAdvReceived)
end
