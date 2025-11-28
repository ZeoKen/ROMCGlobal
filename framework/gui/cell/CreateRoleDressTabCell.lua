local baseCell = autoImport("BaseCell")
CreateRoleDressTabCell = class("CreateRoleDressTabCell", baseCell)

function CreateRoleDressTabCell:Init()
  self.arrow = self:FindGO("Arrow")
  self.content = self:FindGO("Content")
end

function CreateRoleDressTabCell:SetData(data)
  self.data = data
end

function CreateRoleDressTabCell:SetSelected(b)
end
