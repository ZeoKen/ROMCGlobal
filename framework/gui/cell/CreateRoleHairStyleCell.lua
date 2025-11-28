local baseCell = autoImport("BaseCell")
CreateRoleHairStyleCell = class("CreateRoleHairStyleCell", baseCell)

function CreateRoleHairStyleCell:Init()
  self.selectedGO = self:FindGO("Selected")
  self.icon = self:FindComponent("Icon", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CreateRoleHairStyleCell:SetData(data)
  self.data = data
  if data and data.Icon then
    IconManager:SetHairStyleIcon(data.Icon, self.icon)
  end
end

function CreateRoleHairStyleCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
  else
    self.selectedGO:SetActive(false)
  end
end
