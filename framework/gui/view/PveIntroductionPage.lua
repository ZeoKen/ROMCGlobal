PveIntroductionPage = class("PveIntroductionPage", SubView)

function PveIntroductionPage:Init()
  self:InitView()
end

function PveIntroductionPage:InitView()
  self.descLab = self:FindComponent("IntroductionLab", UILabel, self.container.togTargets[3])
end

function PveIntroductionPage:OnEnter()
  PveIntroductionPage.super.OnEnter(self)
  self:Reset()
end

function PveIntroductionPage:Reset()
  local previewData = self.container.previewData
  if previewData then
    local _IntroductionTab = Table_PveMonsterIntroduction[previewData.Introduction]
    if _IntroductionTab then
      self.descLab.text = _IntroductionTab.Content or ""
    else
      self.descLab.text = Table_Monster[previewData.id].Desc
    end
  end
end
