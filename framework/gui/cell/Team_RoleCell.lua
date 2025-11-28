local BaseCell = autoImport("BaseCell")
Team_RoleCell = class("Team_RoleCell", BaseCell)
local tempV3 = LuaVector3()

function Team_RoleCell:Init()
  self.icon = self:FindGO("icon"):GetComponent(UIMultiSprite)
  self.role = self:FindGO("role"):GetComponent(UIMultiSprite)
  self.delBtn = self:FindGO("delBtn")
  if self.delBtn then
    self:AddClickEvent(self.delBtn, function(cell)
      GameFacade.Instance:sendNotification(TeamEvent.TeamOption_DeleteRole, self)
    end)
    self.delBtn:SetActive(false)
  end
  self.choose = self:FindGO("choose")
  if self.choose then
    self.choose:SetActive(false)
  end
  self:AddCellClickEvent()
end

function Team_RoleCell:SetData(data)
  self.data = data
  if data then
    self.role.gameObject:SetActive(true)
    if 0 < data then
      self.icon.CurrentState = data
      self.role.CurrentState = data
      self.role.alpha = 1
    else
      self.icon.CurrentState = 0
      if data == 0 then
        self.role.gameObject:SetActive(false)
      else
        self.role.CurrentState = data * -1
        self.role.alpha = 0.5
      end
    end
  else
    self.icon.CurrentState = 0
    self.role.gameObject:SetActive(false)
  end
end

function Team_RoleCell:SetScale(a, b)
  LuaVector3.Better_Set(tempV3, a, a, a)
  self.icon.transform.localScale = tempV3
  LuaVector3.Better_Set(tempV3, b, b, b)
  self.role.transform.localScale = tempV3
end

function Team_RoleCell:SetSelected(isSelected)
  self.choose:SetActive(isSelected)
  self.delBtn:SetActive(isSelected)
end

function Team_RoleCell:SetDisable(v)
end
