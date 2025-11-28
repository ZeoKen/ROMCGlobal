local baseCell = autoImport("BaseCell")
CreateRoleEyeStyleCell = class("CreateRoleEyeStyleCell", baseCell)

function CreateRoleEyeStyleCell:Init()
  self.selectedGO = self:FindGO("Selected")
  self.icon = self:FindComponent("Icon", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CreateRoleEyeStyleCell:SetData(data)
  self.data = data
  if data and data.Icon then
    IconManager:SetHairStyleIcon(data.Icon, self.icon)
    local result, c = ColorUtil.TryParseFromNumber(data.Color)
    if result then
      self.icon.color = c
    end
  end
end

function CreateRoleEyeStyleCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
  else
    self.selectedGO:SetActive(false)
  end
end
