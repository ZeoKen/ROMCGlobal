autoImport("ActivityPaySignRewardCell")
ActivityPaySignImportantRewardCell = class("ActivityPaySignImportantRewardCell", ActivityPaySignRewardCell)

function ActivityPaySignImportantRewardCell:FindObjs()
  ActivityPaySignImportantRewardCell.super.FindObjs(self)
  local basic = self:FindGO("Basic")
  self.basicTitle = self:FindComponent("title", UILabel, basic)
  self.basicTitleBg = self:FindGO("titleBg", basic)
  local adv = self:FindGO("Adv")
  self.advTitle = self:FindComponent("title", UILabel, adv)
  local super = self:FindGO("Super")
  self.superTitle = self:FindComponent("title", UILabel, super)
end

function ActivityPaySignImportantRewardCell:SetData(config)
  ActivityPaySignImportantRewardCell.super.SetData(self, config)
  if config and config.Params then
    if config.Params.BasicTitle then
      self.basicTitle.text = config.Params.BasicTitle
    end
    if config.Params.ProTitle then
      self.advTitle.text = config.Params.ProTitle
    end
    if config.Params.SuperTitle then
      self.superTitle.text = config.Params.SuperTitle
    end
  end
end

function ActivityPaySignImportantRewardCell:RefreshRecvState(level)
  ActivityPaySignImportantRewardCell.super.RefreshRecvState(self, level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  self.basicTitleBg:SetActive(not isBasicReceived)
end
