local BaseCell = autoImport("BaseCell")
AdventureDropCell = class("AdventureDropCell", BaseCell)

function AdventureDropCell:Init()
  self:initView()
end

function AdventureDropCell:initView()
  self.Icon = self:FindComponent("Icon", UISprite)
  self.value = self:FindComponent("Value", UILabel)
end

function AdventureDropCell:SetData(data)
  local sdata = data.itemData
  IconManager:SetItemIcon(sdata.Icon, self.Icon)
  self.value.text = string.format("%s×%d", sdata.NameZh, data.num)
end
