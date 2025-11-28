MainViewThanksgivingRaidPage = class("MainViewThanksgivingRaidPage", SubView)

function MainViewThanksgivingRaidPage:Init()
  self:ReLoadPerferb("view/MainViewThanksgivingRaidPage")
  self:InitView()
  self:ResetData()
  self:Hide()
end

function MainViewThanksgivingRaidPage:InitView()
  self.mainViewTrans = self.gameObject.transform.parent
  self.traceInfoParent = Game.GameObjectUtil:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(self.traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(-115, -106, 0)
  self.eliteSlider = self:FindComponent("EliteSlider", UISlider)
  self.elitePercentLabel = self:FindComponent("ElitePercent", UILabel)
  self.estradeLabel = self:FindComponent("EstradeLabel", UILabel)
  self.mvpLabel = self:FindComponent("MVPLabel", UILabel)
  self.mvpSprite = self:FindComponent("MVPSprite", UISprite)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.desc = self:FindComponent("ThanksgivingDesc", UILabel)
end

function MainViewThanksgivingRaidPage:ResetData()
  IconManager:SetUIIcon("ui_HP_1", self.mvpSprite)
  self:UpdateAll()
end

function MainViewThanksgivingRaidPage:Show(tarObj)
  MainViewThanksgivingRaidPage.super.Show(self, tarObj)
  if not tarObj then
    self:ResetData()
  end
end

function MainViewThanksgivingRaidPage:UpdateAll(data)
  self:UpdateDesc()
  self:UpdateElite(data and data.elitenum)
  self:UpdateEstrade(data and data.mininum)
  self:UpdateMVP(data and data.mvpnum)
end

function MainViewThanksgivingRaidPage:UpdateDesc()
  self.titleLabel.text = string.format("◆ %s ◆", GameConfig.ThanksGiving.activityTitle or "")
  self.desc.text = GameConfig.ThanksGiving.activityContent or ""
end

function MainViewThanksgivingRaidPage:UpdateElite(eliteDefCount)
  local ratio = eliteDefCount and math.clamp(eliteDefCount / GameConfig.ThanksGiving.show_jingying_count, 0, 1) or 0
  self.eliteSlider.value = ratio
  self.elitePercentLabel.text = string.format("%.1f%%", ratio * 100)
end

function MainViewThanksgivingRaidPage:UpdateEstrade(estradeDefCount)
  local countText = estradeDefCount and 0 <= estradeDefCount and string.format(ZhString.Thanksgiving_RestEstradeCountFormat, GameConfig.ThanksGiving.show_mvp_mini - estradeDefCount) or ZhString.Thanksgiving_TargetNotAppeared
  self.estradeLabel.text = ZhString.Thanksgiving_RestEstradeCountLabel .. countText
end

function MainViewThanksgivingRaidPage:UpdateMVP(mvpDefCount)
  local maxMvpCount = 1
  local countText = mvpDefCount and 0 <= mvpDefCount and (mvpDefCount == maxMvpCount and ZhString.Thanksgiving_MVPDefeated or string.format(ZhString.Thanksgiving_MVPCountFormat, maxMvpCount - mvpDefCount, maxMvpCount)) or ZhString.Thanksgiving_TargetNotAppeared
  self.mvpLabel.text = ZhString.Thanksgiving_MVPCountLabel .. countText
end
