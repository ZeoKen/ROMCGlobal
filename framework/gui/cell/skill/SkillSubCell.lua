local baseCell = autoImport("BaseCell")
SkillSubCell = class("SkillSubCell", baseCell)

function SkillSubCell:Init()
  self:FindObjs()
  self:InitShow()
end

function SkillSubCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.add = self:FindGO("Add")
  self.remove = self:FindGO("Remove")
end

function SkillSubCell:InitShow()
  self:SetEvent(self.add, function()
    self:PassEvent(SkillEvent.AddSubSkill, self)
  end)
  self:SetEvent(self.remove, function()
    self:PassEvent(SkillEvent.RemoveSubSkill, self)
  end)
end

function SkillSubCell:SetData(data)
  self.data = data and data.skillid
  self.valid = data and data.valid
  local readOnlyMode = SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkillsReadOnly) and not SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkills)
  if self.data ~= nil then
    if self.data == -1 then
      self.add:SetActive(not readOnlyMode)
      self.remove:SetActive(false)
      self.icon.spriteName = ""
    else
      self.add:SetActive(false)
      self.remove:SetActive(not readOnlyMode)
      self:UpdateCell(self.data)
      if data.valid then
        self.icon.color = SkillSubSelectCell.EnableColor
      else
        self.icon.color = SkillSubSelectCell.DisableColor
      end
    end
  end
end

function SkillSubCell:UpdateCell(data)
end
