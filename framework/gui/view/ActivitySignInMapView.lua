autoImport("NewServerSignInMapView")
ActivitySignInMapView = class("ActivitySignInMapView", NewServerSignInMapView)
ActivitySignInMapView.ViewType = UIViewType.NormalLayer

function ActivitySignInMapView:InitData()
  self.proxyInstance = ActivitySignInProxy.Instance
  self.isFromCat = false
  self.activityCfg = self.proxyInstance:GetNowConfigData()
  if not self.activityCfg then
    LogUtility.Error("Cannot get config data for now while initializing ActivitySignInMapView!")
    return
  end
  self.periodDayCount = self.activityCfg.SignInMax
  self.catPrefabName = self.activityCfg.CatModel
  self.mapBgTexName = self.activityCfg.Background
  self.cellPartName = "SignInCells" .. tostring(self.periodDayCount)
end

function ActivitySignInMapView:OnEnter()
  ActivitySignInMapView.super.OnEnter(self)
  self.tipButton:SetActive(false)
  self.flowEffectParent:SetActive(false)
  self.helpBtn:SetActive(true)
  self:TryOpenHelpViewById(2020, nil, self.helpBtn)
  local startDate, endDate = self.proxyInstance:GetNowConfigPeriodDateStrs()
  self.dateLabel.gameObject:SetActive(startDate ~= nil)
  if startDate then
    self.dateLabel.text = string.format(ZhString.ActivitySignIn_DateLabelFormat, startDate, endDate)
  end
end

function ActivitySignInMapView:HandleSignInNotify()
  self:UpdateShow(not self.proxyInstance.isTodaySigned)
end

function ActivitySignInMapView:SendMapViewCloseEvent()
end
