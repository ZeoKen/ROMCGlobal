local BaseCell = autoImport("BaseCell")
SettingViewTitleCell = class("SettingViewTitleCell", BaseCell)

function SettingViewTitleCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
end

function SettingViewTitleCell:SetData(data)
  self.label.text = data.label
  IconManager:SetItemIcon(data.spriteName, self.icon)
end
