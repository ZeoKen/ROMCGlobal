local BaseCell = autoImport("BaseCell")
DisneyRoleHeadCell = class("DisneyRoleHeadCell", BaseCell)

function DisneyRoleHeadCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.bg = self:FindComponent("bg", UISprite)
  self:AddButtonEvent("Icon", function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DisneyRoleHeadCell:SetData(data)
  self.data = data
  self.icon.spriteName = data.avatar
  local isSelected = data.isSelected
  self.icon.alpha = isSelected and 0.7 or 1
  self.bg.alpha = isSelected and 0.7 or 1
end
