local baseCell = autoImport("BaseCell")
CreateRoleRaceCell = class("CreateRoleRaceCell", baseCell)

function CreateRoleRaceCell:Init()
  self.selectedGO = self:FindGO("Selected")
  self.icon = self:FindComponent("Icon", UISprite)
end

function CreateRoleRaceCell:SetData(data)
  self.data = data
end

local selectedColor = LuaColor.New(1, 1, 1, 1)
local unselectedColor = LuaColor.New(0.8039216, 0.9137255, 1, 0.7)

function CreateRoleRaceCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
    self.icon.color = selectedColor
    LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.8, 0.8, 1)
  else
    self.selectedGO:SetActive(false)
    self.icon.color = unselectedColor
    LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.7, 0.7, 1)
  end
end
