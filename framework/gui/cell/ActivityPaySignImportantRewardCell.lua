autoImport("ActivityPaySignRewardCell")
ActivityPaySignImportantRewardCell = class("ActivityPaySignImportantRewardCell", ActivityPaySignRewardCell)

function ActivityPaySignImportantRewardCell:FindObjs()
  ActivityPaySignImportantRewardCell.super.FindObjs(self)
  local basic = self:FindGO("Basic")
  self.basicTitleBg = self:FindGO("titleBg", basic)
end

function ActivityPaySignImportantRewardCell:RefreshRecvState(level)
  ActivityPaySignImportantRewardCell.super.RefreshRecvState(self, level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  self.basicTitleBg:SetActive(not isBasicReceived or isAdvReceived)
end
