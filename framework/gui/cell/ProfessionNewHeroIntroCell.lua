local BaseCell = autoImport("BaseCell")
ProfessionNewHeroIntroCell = class("ProfessionNewHeroIntroCell", BaseCell)

function ProfessionNewHeroIntroCell:ctor(obj)
  ProfessionNewHeroIntroCell.super.ctor(self, obj)
  self:FindObjs()
  self:AddGameObjectComp()
end

function ProfessionNewHeroIntroCell:FindObjs()
  local container = self:FindGO("Container")
  self.introTitleLab = self:FindComponent("IntroTitle", UILabel)
  self.introScroll = self:FindComponent("IntroPanel", UIScrollView)
  self.introBgGO = self:FindGO("IntroBG")
  self.introLab = self:FindComponent("Intro", UILabel, self.introScroll.gameObject)
  self.autoScrollCtrl = UIAutoScrollCtrl.new(self.introScroll, self.introLab, 8, 40)
end

function ProfessionNewHeroIntroCell:SetData(data)
  self.data = data
  if data then
    self.introTitleLab.text = data:GetTitle()
    local intro = data:GetIntro()
    if intro and intro ~= "" then
      self.introBgGO:SetActive(true)
      self.introScroll.gameObject:SetActive(true)
      self.introLab.text = data:GetIntro()
      if self.gameObject.activeInHierarchy then
        self.introLab:ProcessText()
        if self.autoScrollCtrl then
          self.autoScrollCtrl:Start(false, true)
        end
      end
    else
      self.autoScrollCtrl:Stop(true)
      self.introBgGO:SetActive(false)
      self.introScroll.gameObject:SetActive(false)
    end
  end
end

function ProfessionNewHeroIntroCell:OnEnable()
  ProfessionNewHeroIntroCell.super.OnEnable(self)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Start(false, true)
  end
end

function ProfessionNewHeroIntroCell:OnDestroy()
  ProfessionNewHeroIntroCell.super.OnDestroy(self)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Destroy()
  end
end

function ProfessionNewHeroIntroCell:OnDisable()
  ProfessionNewHeroIntroCell.super.OnDisable(self)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Stop(true)
  end
end
