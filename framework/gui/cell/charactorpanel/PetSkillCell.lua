local baseCell = autoImport("BaseCell")
PetSkillCell = class("PetSkillCell", baseCell)

function PetSkillCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.level = self:FindComponent("SkillLevel", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self:AddCellClickEvent()
end

function PetSkillCell:SetData(data)
  self.data = data
  if type(data) == "number" then
    local skill_sdata = Table_Skill[data]
    if skill_sdata then
      IconManager:SetSkillIcon(skill_sdata.Icon, self.icon)
      self.level.text = skill_sdata.Level
    end
  elseif type(data) == "table" then
    IconManager:SetSkillIcon(data.staticData.Icon, self.icon)
    self.level.text = data.Level
  end
end

function PetSkillCell:PlayResetEffect()
  self:PlayUIEffect(EffectMap.UI.Pet_SkillUp, self.effectContainer, true)
end

local scale = LuaVector3.One()

function PetSkillCell:SetScale(size)
  if self.gameObject then
    LuaVector3.Better_Set(scale, 1, 1, 1)
    LuaVector3.Mul(scale, size)
    self.gameObject.transform.localScale = scale
  end
end
