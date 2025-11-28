local BaseCell = autoImport("BaseCell")
SelectRoleCell = class("SelectRoleCell", BaseCell)
local RoleConfig = GameConfig.TeamRole
local tempV3 = LuaVector3()

function SelectRoleCell:Init()
  self.icon = self:FindGO("icon"):GetComponent(UIMultiSprite)
  self.role = self:FindGO("role"):GetComponent(UIMultiSprite)
  self.toggleObj = self:FindGO("toggle")
  if self.toggleObj then
    self.toggle = self.toggleObj:GetComponent(UIToggle)
    self.toggle.optionCanBeNone = true
  end
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self:AddCellClickEvent()
  self:AddEvts()
end

function SelectRoleCell:AddEvts()
  if not self.toggle then
    return
  end
  EventDelegate.Add(self.toggle.onChange, function()
    if self.toggle.value then
      GameFacade.Instance:sendNotification(TeamEvent.TeamOption_SelectRole, self)
    end
  end)
end

function SelectRoleCell:SetData(data)
  self.data = data
  if data then
    self.role.gameObject:SetActive(true)
    if 0 < data then
      self.icon.CurrentState = data
      self.role.CurrentState = data
      self.name.text = RoleConfig[data].name
    else
      self.icon.CurrentState = 0
      if data == 0 then
        self.role.gameObject:SetActive(false)
      else
        self.role.CurrentState = data * -1
      end
    end
  else
    self.icon.CurrentState = 0
    self.role.gameObject:SetActive(false)
  end
end

function SelectRoleCell:SetSelected(isSelected)
  if not self.toggle then
    return
  end
  self.toggle.value = isSelected
end

function SelectRoleCell:SetScale(a, b)
  LuaVector3.Better_Set(tempV3, a, a, a)
  self.icon.transform.localScale = tempV3
  LuaVector3.Better_Set(tempV3, b, b, b)
  self.role.transform.localScale = tempV3
end
