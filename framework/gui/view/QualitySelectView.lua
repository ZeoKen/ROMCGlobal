QualitySelectView = class("QualitySelectView", ContainerView)
QualitySelectView.ViewType = UIViewType.PerformanceLayer

function QualitySelectView.CanShow()
  return FunctionPerformanceSetting.Me():GetSetting().isFirstTimeSigned
end

function QualitySelectView:Init()
  self:FindObjs()
  self:AddButtonEvents()
  self:DefaultChoose()
end

function QualitySelectView.HandleMapChange(note)
end

ChosenToggle = {Commonly = 0, Good = 1}

function QualitySelectView:DefaultChoose()
  self:ClickGoodToggle(g)
end

function QualitySelectView:FindObjs()
  self.InnerBG = self:FindGO("InnerBG")
  self.TipsTexture = self:FindComponent("TipsTexture", UITexture)
  self.ChoosePerformance = self:FindComponent("ChoosePerformance", UISprite, self.InnerBG)
  self.ChooseExperience = self:FindComponent("ChooseExperience", UISprite, self.InnerBG)
  self.ConfirmButton = self:FindGO("ConfirmButton"):GetComponent(UIButton)
  self.CommonToggle = self:FindComponent("PreviewCommonTexture", UIToggle, self.InnerBG)
  self.GoodToggle = self:FindComponent("PreviewGoodTexture", UIToggle, self.InnerBG)
  self.PreviousCommonTexture = self:FindComponent("PreviewCommonTexture", UITexture, self.InnerBG)
  if self.PreviousCommonTexture then
    PictureManager.Instance:SetUI("picture_commonly", self.PreviousCommonTexture)
  end
  self.PreviousGoodTexture = self:FindComponent("PreviewGoodTexture", UITexture, self.InnerBG)
  if self.PreviousGoodTexture then
    PictureManager.Instance:SetUI("picture_good", self.PreviousGoodTexture)
  end
end

function QualitySelectView:AddButtonEvents()
  self:AddClickEvent(self:FindGO("PreviewCommonTexture", self.InnerBG), function(g)
    self:ClickCommonToggle(g)
  end)
  self:AddClickEvent(self:FindGO("PreviewGoodTexture", self.InnerBG), function(g)
    self:ClickGoodToggle(g)
  end)
  self:AddClickEvent(self:FindGO("ConfirmButton"), function(g)
    self:ApplySetting(g)
  end)
end

function QualitySelectView:ClickCommonToggle(g)
  self.CommonToggle.value = true
  self.GoodToggle.value = false
  self.QualityChosen = ChosenToggle.Commonly
end

function QualitySelectView:ClickGoodToggle(g)
  self.CommonToggle.value = false
  self.GoodToggle.value = true
  self.QualityChosen = ChosenToggle.Good
end

function QualitySelectView:ApplySetting()
  if self.QualityChosen == ChosenToggle.Commonly then
    self:SetCommonlySetting()
  else
    self:SetGoodSetting()
  end
  self:CloseSelf()
end

function QualitySelectView:SetCommonlySetting()
  local setting = FunctionPerformanceSetting.Me()
  local screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
  setting:SetBegin()
  setting:SetOutLine(false)
  setting:SetSlim(true)
  setting:SetPeak(false)
  setting:SetScreenCount(screenCount)
  setting:SetShowOtherName(true)
  setting:SetShowOtherChar(true)
  setting:SetResolution(1)
  setting:SetFrameRate(1)
  setting:IsFirstTimeSigned(false)
  setting:SetEnd()
end

function QualitySelectView:SetGoodSetting()
  local setting = FunctionPerformanceSetting.Me()
  local screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High)
  setting:SetBegin()
  setting:SetOutLine(true)
  setting:SetSlim(true)
  setting:SetPeak(true)
  setting:SetScreenCount(screenCount)
  setting:SetShowOtherName(true)
  setting:SetShowOtherChar(true)
  setting:SetResolution(1)
  setting:SetFrameRate(2)
  setting:IsFirstTimeSigned(false)
  setting:SetEnd()
end

function QualitySelectView:OnEnter()
  QualitySelectView.super.OnEnter(self)
end

function QualitySelectView:OnExit()
  QualitySelectView.super.OnExit(self)
  if self.PreviousCommonTexture then
    PictureManager.Instance:UnLoadUI("picture_commonly", self.PreviousCommonTexture)
  end
  if self.PreviousGoodTexture then
    PictureManager.Instance:UnLoadUI("picture_good", self.PreviousGoodTexture)
  end
end

function QualitySelectView:OnShow()
  QualitySelectView.super.OnShow(self)
end

function QualitySelectView:OnHide()
  QualitySelectView.super.OnHide(self)
end

function QualitySelectView:OnDestroy()
  QualitySelectView.super.OnDestroy(self)
end
