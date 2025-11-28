local BaseCell = autoImport("BaseCell")
PracticeFieldRewardCell = class("PracticeFieldRewardCell", BaseCell)

function PracticeFieldRewardCell:Init()
  self:FindObjs()
end

function PracticeFieldRewardCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
end

function PracticeFieldRewardCell:SetData(data)
  self.data = data.itemData
  self.gameObject:SetActive(true)
  if self.data.staticData then
    IconManager:SetItemIcon(self.data.staticData.Icon, self.icon)
  else
    redlog("Table_Item无道具")
  end
  self.count.text = data.num
end
