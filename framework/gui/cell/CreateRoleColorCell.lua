local baseCell = autoImport("BaseCell")
CreateRoleColorCell = class("CreateRoleColorCell", baseCell)

function CreateRoleColorCell:Init()
  self.selectedGO = self:FindGO("chooseImg")
  self.colorSprite = self:FindComponent("iconColor", UISprite)
  self.frameSprite = self:FindComponent("iconFrame", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CreateRoleColorCell:SetData(data)
  self.data = data
  if data then
    local colorHex = data.Color
    if colorHex then
      local result, c
      if type(colorHex) == "string" then
        result, c = ColorUtil.TryParseHexString(colorHex)
      elseif type(colorHex) == "number" then
        result, c = ColorUtil.TryParseFromNumber(colorHex)
      end
      if result then
        self.colorSprite.color = c
        self.frameSprite.color = c
      end
    end
  end
end

function CreateRoleColorCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
  else
    self.selectedGO:SetActive(false)
  end
end
