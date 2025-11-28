ProfessionNewHeroIntroData = class("ProfessionNewHeroIntroData")

function ProfessionNewHeroIntroData:ctor(profession)
  local staticData = Table_Class[profession]
  self:SetStaticData(staticData)
end

function ProfessionNewHeroIntroData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end

function ProfessionNewHeroIntroData:GetTitle()
  return self.staticData and self.staticData.HeroTitle or ""
end

function ProfessionNewHeroIntroData:GetIntro()
  return self.staticData and self.staticData.Intro or ""
end
