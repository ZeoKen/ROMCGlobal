local BaseCell = autoImport("BaseCell")
AbyssRewardItemCell = class("AbyssRewardItemCell", BaseCell)
autoImport("UIUtil")

function AbyssRewardItemCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AbyssRewardItemCell:FindObjs()
  self.icon = self:FindChild("Icon_Sprite"):GetComponent(UISprite)
  self.bg = self:FindComponent("Background", UISprite)
  self.num = self:FindComponent("NumLabel", UILabel)
end

function AbyssRewardItemCell:SetData(data)
  self.data = data
  if data then
    if not IconManager:SetItemIcon(data.staticData.Icon, self.icon) then
      IconManager:SetItemIcon("item_45001", self.icon)
    end
    self.num.text = data.num
  end
end
