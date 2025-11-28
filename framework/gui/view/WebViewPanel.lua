WebViewPanel = class("WebViewPanel", ContainerView)
WebViewPanel.ViewType = UIViewType.BoardLayer
local webViewIns

function WebViewPanel:Init()
  if not webViewIns then
    webViewIns = ROWebView.Instance
  end
  self:FindObjs()
  self:AddEvents()
  self:AddCloseButtonEvent()
  self:SetData()
end

function WebViewPanel:FindObjs()
  self.BG = self:FindGO("BG")
  self.backwardBtn = self:FindGO("Backward")
  self.forwardBtn = self:FindGO("Forward")
  self.refreshBtn = self:FindGO("Refresh")
end

function WebViewPanel:CloseThisPanel()
  self:HideView(false)
  self:CloseSelf()
end

function WebViewPanel:AddEvents()
  self:AddClickEvent(self.backwardBtn, function()
    self:ClickBackwardBtn()
  end)
  self:AddClickEvent(self.forwardBtn, function()
    self:ClickForwardBtn()
  end)
  self:AddClickEvent(self.refreshBtn, function()
    self:ClickRefreshBtn()
  end)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Quit, self.CloseThisPanel, self)
  eventManager:AddEventListener(AppStateEvent.BackToLogo, self.CloseThisPanel, self)
  eventManager:AddEventListener(AppStateEvent.Pause, self.CloseThisPanel, self)
  eventManager:AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  self:AddListenEvt(XDEUIEvent.CloseWebView, function()
    self:BackCloseThisPanel()
  end)
end

function WebViewPanel:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:HideView(true)
    self:CloseSelf()
  end)
end

function WebViewPanel:ClickBackwardBtn()
  webViewIns:GoBack()
end

function WebViewPanel:ClickForwardBtn()
  webViewIns:GoForward()
end

function WebViewPanel:ClickRefreshBtn()
  webViewIns:Reload()
end

function WebViewPanel:SetData()
  if self.viewdata and self.viewdata.viewdata then
    self.token = self.viewdata.viewdata.token
    self.directurl = self.viewdata.viewdata.directurl
  end
end

function WebViewPanel:OnEnter()
  self.isLandscapeLeft = true
  self:ShowView()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:HideView(true)
    self:CloseSelf()
  end)
end

function WebViewPanel:OnExit()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  local eventManager = EventManager.Me()
  eventManager:RemoveEventListener(AppStateEvent.Quit, self.CloseThisPanel, self)
  eventManager:RemoveEventListener(AppStateEvent.BackToLogo, self.CloseThisPanel, self)
  eventManager:RemoveEventListener(AppStateEvent.Pause, self.CloseThisPanel, self)
  eventManager:RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  WebViewPanel.super.OnExit(self)
end

function WebViewPanel:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  self.isLandscapeLeft = note.data
  self:UpdateInsets()
end

function WebViewPanel:ShowView()
  self.BG.gameObject:SetActive(not ApplicationInfo.IsWindows())
  local finalurl = string.format("https://api.xd.com/v1/user/get_login_url?access_token=%s&redirect=https://rotr.xd.com", self.token)
  if not BranchMgr.IsChina() and not BranchMgr.IsTW() then
    finalurl = self.viewdata and self.viewdata.viewdata.directurl
  end
  webViewIns.toolBarShow = false
  self:UpdateInsets()
  if BranchMgr.IsJapan() then
    if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
      webViewIns:SetUserAgent("ro uniwebview android")
    elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
      webViewIns:SetUserAgent("ro uniwebview ios")
    else
      webViewIns:SetUserAgent("ro uniwebview")
    end
  else
    webViewIns:SetUserAgent("ro uniwebview")
  end
  if self.directurl then
    self:_TryLoadAndShow(self.directurl)
    self.directurl = nil
  else
    Game.WWWRequestManager:SimpleRequest(finalurl, 5, function(www)
      local jsonRequest = json.decode(www.text)
      if jsonRequest and jsonRequest.login_url then
        self:_TryLoadAndShow(jsonRequest.login_url)
      else
        self:_TryLoadAndShow()
      end
    end, function(www, error)
      LogUtility.Info("wrong www")
      self:_TryLoadAndShow()
    end, function(www)
      self:_TryLoadAndShow()
    end)
  end
end

function WebViewPanel:_TryLoadAndShow(url)
  url = url or "https://rotr.xd.com"
  if not ApplicationInfo.IsWindows() then
    webViewIns:StartLoadAndShow(url)
  end
end

function WebViewPanel:UpdateInsets()
  local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  local minTop = Screen.height / 10
  if l then
    self:SetInsets(l, math.max(minTop, t), r, b)
  else
    self:SetInsets(nil, minTop)
  end
end

function WebViewPanel:HideView(fade)
  webViewIns:Hide(false)
  webViewIns:SetFrame(0, 0, 0, 0)
end

function WebViewPanel:Clear()
  webViewIns:CleanCache()
end

function WebViewPanel:CloseThisPanel()
  self:HideView(false)
  self:CloseSelf()
end

function WebViewPanel:BackCloseThisPanel()
  LogUtility.Info("WebViewPanel:BackCloseThisPanel")
  self:HideView(true)
  self:CloseSelf()
end

function WebViewPanel:SetInsets(left, top, right, bottom)
  left = left or 0
  top = top or 0
  right = right or 0
  bottom = bottom or 0
  webViewIns:SetFrame(left, top, math.max(Screen.width - left - right, 0), math.max(Screen.height - top - bottom, 0))
end

function WebViewPanel:CloseSelf()
  self.super.CloseSelf(self)
  if webViewIns ~= nil then
    local uniwebviewGo = webViewIns.webView and webViewIns.webView.gameObject
    if uniwebviewGo ~= nil and not Slua.IsNull(uniwebviewGo) then
      GameObject.DestroyImmediate(uniwebviewGo)
    end
  end
end
