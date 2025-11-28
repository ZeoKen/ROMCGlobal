autoImport("RecallActivityBattlePassLevelRewardCell")
RecallActivityBattlePassBasicLevelRewardCell = class("RecallActivityBattlePassBasicLevelRewardCell", RecallActivityBattlePassLevelRewardCell)

function RecallActivityBattlePassBasicLevelRewardCell:FindObjs()
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.receivedSp = self:FindGO("get")
  self.locker = self:FindGO("Locker")
  self.getLabel = self:FindGO("GetLabel")
  local basic = self:FindGO("Basic")
  self.basicHolder = self:FindGO("holder", basic)
  self:AddClickEvent(basic, function()
    self:HandleClickRewardIcon(self.basicItemCell)
  end)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function RecallActivityBattlePassBasicLevelRewardCell:SetData(data)
  self.data = data
  self.level = data.Level
  self.levelLabel.text = "Lv." .. self.level
  local basicRewardItem = data.RewardItems[1]
  if not self.basicItemCell then
    self.basicItemCell = self:SetRewardIcon(basicRewardItem, self.basicHolder)
  else
    local data = self.basicItemCell.data
    data:ResetData(basicRewardItem.itemid, basicRewardItem.itemid)
    data:SetItemNum(basicRewardItem.num)
    self.basicItemCell:SetData(data)
  end
  local config = Table_Item[basicRewardItem.itemid]
  self.nameLabel.text = config and config.NameZh or ""
  self:RefreshRecvState(self.level)
end

function RecallActivityBattlePassBasicLevelRewardCell:RefreshRecvState(level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isBasicLocked = self:GetIsNormalRewardLocked(level)
  local isRewardAvailable = not isBasicLocked and not isBasicReceived
  self.receivedSp:SetActive(isBasicReceived or false)
  self.locker:SetActive(isBasicLocked or false)
  self.getLabel:SetActive(isRewardAvailable)
end
