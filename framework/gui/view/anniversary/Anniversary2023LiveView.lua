Anniversary2023LiveView = class("Anniversary2023LiveView", BaseView)
Anniversary2023LiveView.ViewType = UIViewType.NormalLayer
local BgTextureName = "anniversary_bg_04"

function Anniversary2023LiveView:Init()
  self:FindObjs()
  self:AddEvts()
end

function Anniversary2023LiveView:FindObjs()
  self.shareBtnGO = self:FindGO("ShareBtn")
  self:AddClickEvent(self.shareBtnGO, function()
    self:OnShareClicked()
  end)
  self.myNumBtnGO = self:FindGO("MyNumBtn")
  self:AddClickEvent(self.myNumBtnGO, function()
    self:OnMyNumClicked()
  end)
  local maskPanelGO = self:FindGO("MaskPanel")
  self.photo = self:FindComponent("photo", UITexture, maskPanelGO)
  local contentGO = self:FindGO("Content")
  self.cdGO = self:FindGO("CD", contentGO)
  self.cdTimer = self:FindComponent("Timer", UILabel, self.cdGO)
  local updateComp = self.cdGO:GetComponent(UpdateDelegate)
  updateComp = updateComp or self.cdGO:AddComponent(UpdateDelegate)
  self.updateComp = updateComp
  
  function self.updateComp.listener()
    self:OnUpdate()
  end
  
  self.appGO = self:FindGO("App", contentGO)
  self.wxGO = self:FindGO("Wx", self.appGO)
  self:AddClickEvent(self.wxGO, function()
    self:OpenUrl("wx")
  end)
  self.dyGO = self:FindGO("Dy", self.appGO)
  self:AddClickEvent(self.dyGO, function()
    self:OpenUrl("dy")
  end)
  self.resultLinkGO = self:FindGO("ResultLink", contentGO)
  self:AddClickEvent(self.resultLinkGO, function()
    local config = Anniversary2023Proxy.Instance:GetConfig()
    if not config or not config.ActivityUrl then
      return
    end
    Application.OpenURL(config.ActivityUrl)
  end)
  self.shareRewardGO = self:FindGO("ShareRewardTips")
  self.shareRewardIcon = self:FindComponent("FirstRewardIcon", UISprite, self.shareRewardGO)
  self.shareRewardLab = self:FindComponent("FirstRewardCountLbl", UILabel, self.shareRewardGO)
  local helpBtnGO = self:FindGO("HelpBtn", contentGO)
  self:RegistShowGeneralHelpByHelpID(35270, helpBtnGO)
  self:UpdateView()
end

function Anniversary2023LiveView:AddEvts()
  self:AddDispatcherEvt(AnniversaryLive.OnActivityEnd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ActivityCmdAnniversaryInfoSync, self.UpdateView)
end

function Anniversary2023LiveView:OnEnter()
  Anniversary2023LiveView.super.OnEnter(self)
  PictureManager.Instance:SetActivityTexture(BgTextureName, self.photo)
  ServiceActivityCmdProxy.Instance:CallAnniversaryInfoSync()
end

function Anniversary2023LiveView:OnExit()
  Anniversary2023LiveView.super.OnExit(self)
  PictureManager.Instance:UnloadActivityTexture(BgTextureName, self.photo)
  if self.updateComp then
    self.updateComp.listener = nil
  end
end

function Anniversary2023LiveView:OnShareClicked()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.Anniversary2023ShareView,
    viewdata = {}
  })
end

function Anniversary2023LiveView:OnMyNumClicked()
  local actData = Anniversary2023Proxy.Instance:GetActData()
  if not actData then
    return
  end
  local config = actData:GetConfig()
  if not config then
    return
  end
  local str = actData:GetLuckyNumStr(config.Params.MyLuckyNumPattern, config.Params.MyLuckyNumDelimiter)
  if str == "" then
    str = config.Params.NoLuckyNumDesc or ""
  else
    str = string.format(config.Params.MyLuckyNumDesc, str)
  end
  TipsView.Me():ShowGeneralHelp(str, ZhString.AnniversaryHelpTitle)
end

function Anniversary2023LiveView:OnUpdate()
  self:UpdateTimer()
end

function Anniversary2023LiveView:UpdateTimer()
  local actData = Anniversary2023Proxy.Instance:GetActData()
  if not actData then
    return
  end
  local timeLeft = actData:GetLiveCD()
  if not timeLeft or timeLeft <= 0 then
    self:UpdateView()
    return
  end
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(timeLeft)
  hour = hour + day * 24
  self.cdTimer.text = string.format("%02d:%02d:%02d", hour, min, sec)
end

function Anniversary2023LiveView:UpdateView()
  local actData = Anniversary2023Proxy.Instance:GetActData()
  if not actData then
    self:CloseSelf()
    return
  end
  local hasLiveEnded = actData:HasLiveEnded()
  local isInLivePeriod = actData:IsInLivePeriod()
  if hasLiveEnded then
    self.appGO:SetActive(false)
    self.cdGO:SetActive(false)
    self.resultLinkGO:SetActive(true)
  elseif isInLivePeriod then
    self.appGO:SetActive(true)
    self.cdGO:SetActive(false)
    self.resultLinkGO:SetActive(false)
  else
    self.appGO:SetActive(false)
    self.cdGO:SetActive(true)
    self.resultLinkGO:SetActive(false)
  end
  if actData.extraData and not actData.extraData:IsRewarded() then
    self.shareRewardGO:SetActive(true)
    local rewardItem = actData.extraData:GetRewardData(1)
    IconManager:SetItemIcon(rewardItem.itemData.staticData.Icon, self.shareRewardIcon)
    self.shareRewardLab.text = string.format("x%s", rewardItem.itemNum or 1)
  else
    self.shareRewardGO:SetActive(false)
  end
end

function Anniversary2023LiveView:OpenUrl(key)
  local config = Anniversary2023Proxy.Instance:GetConfig()
  if not config then
    return
  end
  local url = config.Params and config.Params.AppLiveUrl and config.Params.AppLiveUrl[key]
  if not url then
    return
  end
  Application.OpenURL(url)
end
