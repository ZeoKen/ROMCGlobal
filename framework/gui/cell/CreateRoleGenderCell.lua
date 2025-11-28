local baseCell = autoImport("BaseCell")
CreateRoleGenderCell = class("CreateRoleGenderCell", baseCell)

function CreateRoleGenderCell:Init()
  self.selectedGO = self:FindGO("selectedbg")
  self.unselectedGO = self:FindGO("unselectedbg")
end

function CreateRoleGenderCell:SetData(data)
  self.data = data
end

function CreateRoleGenderCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
    self.unselectedGO:SetActive(false)
    LuaGameObject.SetLocalScaleGO(self.gameObject, 1, 1, 1)
  else
    self.selectedGO:SetActive(false)
    self.unselectedGO:SetActive(true)
    LuaGameObject.SetLocalScaleGO(self.gameObject, 0.8, 0.8, 1)
  end
end
