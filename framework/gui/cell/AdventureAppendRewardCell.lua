local baseCell = autoImport("BaseCell")
AdventureAppendRewardCell = class("AdventureAppendRewardCell", baseCell)
local originCountLabColor = Color(0.17254901960784313, 0.47843137254901963, 0.6980392156862745, 1)

function AdventureAppendRewardCell:Init()
  self:initView()
end

function AdventureAppendRewardCell:initView()
  self.RewardIcon = self:FindGO("RewardIcon"):GetComponent(UISprite)
  self.RewardCount = self:FindGO("RewardCount"):GetComponent(UILabel)
end

function AdventureAppendRewardCell:SetData(data)
  self.data = data
  if data.type ~= AdventureAppendData.RewardDataType.empty then
    self.RewardCount.text = data.text
    if data.type == AdventureAppendData.RewardDataType.normal then
      IconManager:SetItemIcon(data.icon, self.RewardIcon)
      self.RewardCount.color = originCountLabColor
    else
      if data.icon and not IconManager:SetUIIcon(data.icon, self.RewardIcon) then
        IconManager:SetItemIcon(data.icon, self.RewardIcon)
      end
      self.RewardCount.color = Color(0.4549019607843137, 0.4470588235294118, 0.4549019607843137, 1)
    end
    self:Show(self.RewardIcon.gameObject)
    self:Show(self.RewardCount.gameObject)
  else
    self:Hide(self.RewardIcon.gameObject)
    self:Hide(self.RewardCount.gameObject)
  end
end
