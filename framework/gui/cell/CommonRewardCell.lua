local BaseCell = autoImport("BaseCell")
CommonRewardCell = class("CommonRewardCell", BaseCell)

function CommonRewardCell:Init()
  self.rewardIcon = self:FindComponent("RewardIcon", UISprite)
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
end

function CommonRewardCell:SetData(data)
  self.data = data
  if data.multiRewardMark then
    self.rewardLabel.gameObject:SetActive(false)
    self.rewardIcon.gameObject:SetActive(false)
  else
    self.rewardLabel.gameObject:SetActive(true)
    self.rewardIcon.gameObject:SetActive(true)
    self.rewardLabel.text = data.NameZh .. "x" .. data.num
    IconManager:SetItemIcon(data.Icon, self.rewardIcon)
    if data.Icon == "item_300" or data.Icon == "item_400" then
      self.rewardIcon.width = 42
      self.rewardIcon.height = 42
    else
      self.rewardIcon.width = 35
      self.rewardIcon.height = 35
    end
  end
end
