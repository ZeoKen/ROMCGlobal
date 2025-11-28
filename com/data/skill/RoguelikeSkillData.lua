RoguelikeSkillData = class("RoguelikeSkillData")

function RoguelikeSkillData:ctor(skillId, skillLevel, isRecommend, isNewSkill)
  self.levelConfigs = Game.SpaceTimeIllusionSkills and Game.SpaceTimeIllusionSkills[skillId]
  self:Reset(skillId, skillLevel, isRecommend, isNewSkill)
  self.maxLevel = self.levelConfigs and #self.levelConfigs or self.level
  self.desc = self.levelConfigs and self.levelConfigs[1] and self.levelConfigs[1].SkillAttrDesc or ""
end

function RoguelikeSkillData:Reset(skillId, skillLevel, isRecommend, isNewSkill)
  self.id = skillId
  self.level = skillLevel or 0
  self.staticData = self.levelConfigs and self.levelConfigs[self.level]
  self:SetAttrs()
  self.isRecommend = isRecommend or self.isRecommend
  self.isNew = isNewSkill or self.isNew
end

local ItemTipDefaultUiIconPrefix = "{roguelikeskillicon=rune_lb_drop_01}"

function RoguelikeSkillData:SetAttrs()
  if not self.attrs then
    self.attrs = {}
  end
  TableUtility.ArrayClear(self.attrs)
  if self.levelConfigs and self.staticData then
    for i = 2, self.level do
      local cfg = self.levelConfigs[i]
      table.insert(self.attrs, cfg)
    end
  end
end

function RoguelikeSkillData:GetAttrs()
  return self.attrs
end

function RoguelikeSkillData:GetDesc()
  return self.desc
end

function RoguelikeSkillData:GetShortDesc()
  return self.staticData and self.staticData.ShortDesc or ""
end

function RoguelikeSkillData:GetCurAttr()
  local str = ""
  if self.staticData then
    local curDesc = self:GetShortDesc()
    if self.staticData.CurDescVal and self.staticData.CurDescVal ~= _EmptyTable then
      str = string.format(curDesc, unpack(self.staticData.CurDescVal))
    else
      str = curDesc
    end
  end
  return str
end

function RoguelikeSkillData:GetName()
  return self.staticData and self.staticData.NameZh or ""
end

function RoguelikeSkillData:GetBuild()
  return self.staticData and self.staticData.Build or ""
end

function RoguelikeSkillData:GetType()
  return self.staticData and self.staticData.Type or 0
end

function RoguelikeSkillData:GetIcon()
  return self.staticData and self.staticData.Icon or ""
end

function RoguelikeSkillData:GetID()
  return self.id
end

function RoguelikeSkillData:GetLevel()
  return self.level
end

function RoguelikeSkillData:GetMaxLevel()
  return self.maxLevel
end

function RoguelikeSkillData:IsRecommend()
  return self.isRecommend
end

function RoguelikeSkillData:IsNew()
  return self.isNew
end

function RoguelikeSkillData:GetReturnPoint()
  return math.floor(self:GetLevel() / 2)
end
