Team_RoleCell_Jojo = class("Team_RoleCell_Jojo", BaseCell)

function Team_RoleCell_Jojo:Init()
  self:FindObjs()
end

function Team_RoleCell_Jojo:FindObjs()
  self.role = self:FindGO("role")
end

function Team_RoleCell_Jojo:SetData(data)
  self.data = data
  self.role:SetActive(data and data ~= "Empty" or false)
end
