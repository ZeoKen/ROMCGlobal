SkillBaseContentPage = class("SkillBaseContentPage", SubView)

function SkillBaseContentPage:Init()
end

function SkillBaseContentPage:OnEnter()
  SkillBaseContentPage.super.OnEnter(self)
end

function SkillBaseContentPage:OnExit()
  self:Switch(false)
  self:SetEditMode(false)
  SkillBaseContentPage.super.OnExit(self)
end

function SkillBaseContentPage:ConfirmEditMode(toDo, owner, param)
  toDo(owner, param)
end

function SkillBaseContentPage:SetEditMode(val)
end

function SkillBaseContentPage:IsEditMode()
  return false
end

function SkillBaseContentPage:Switch(val)
  if self.switch ~= val then
    self.switch = val
    self:OnSwitch(val)
  end
end

function SkillBaseContentPage:OnSwitch(val)
  self.gameObject:SetActive(val == true)
end
