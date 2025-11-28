SdkLoginPanel = class("SdkLoginPanel", BaseView)
SdkLoginPanel.ViewType = UIViewType.PopUpLayer

function SdkLoginPanel:Init()
  self.callback = self.viewdata.data
  self.moreTypes = false
  self:initView()
  self:AddEvt()
end

function SdkLoginPanel:initView()
  self.firstLayer = self:FindGO("FirstLayer")
  self.secondLayer = self:FindGO("SecondLayer")
  self.firstLayer:SetActive(true)
  self.secondLayer:SetActive(false)
  self.googleBtn_first = self:FindGO("FirstLayer/Google")
  self.appleBtn = self:FindGO("FirstLayer/Apple")
  self.facebookBtn = self:FindGO("FirstLayer/Facebook")
  self.guestBtn = self:FindGO("Guest")
  self.moreBtn = self:FindGO("More")
  self.moreSp = self.moreBtn:GetComponent("UISprite")
  self.moreLabel = self:FindComponent("Label", UILabel, self.moreBtn)
  self.loginGrid = self:FindGO("SecondLayer/Grid")
  self.gridComponent = self.loginGrid:GetComponent("UIGrid")
  self.googleBtn_second = self:FindGO("SecondLayer/Grid/Google")
  self.twitterBtn = self:FindGO("SecondLayer/Grid/Twitter")
  self.lineBtn = self:FindGO("SecondLayer/Grid/Line")
  self.taptapBtn = self:FindGO("SecondLayer/Grid/TapTap")
  self.closeBtn = self:FindGO("SecondLayer/Close")
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if (BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN()) and runtimePlatform == RuntimePlatform.IPhonePlayer then
    self.facebookBtn:SetActive(false)
  end
  if (BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN()) and (runtimePlatform == RuntimePlatform.Android or ApplicationInfo.IsWindows()) then
    self.moreBtn:SetActive(false)
  end
  self:AppleOrGoogle()
  self.blockClose = false
end

function SdkLoginPanel:AddEvt()
  self:AddClickEvent(self.guestBtn, function(go)
    self:LoginByType(0, self.callback)
  end)
  self:AddClickEvent(self.appleBtn, function(go)
    self:LoginByType(2, self.callback)
  end)
  self:AddClickEvent(self.googleBtn_first, function(go)
    self:LoginByType(3, self.callback)
  end)
  self:AddClickEvent(self.googleBtn_second, function(go)
    self:LoginByType(3, self.callback)
  end)
  self:AddClickEvent(self.facebookBtn, function(go)
    self:LoginByType(4, self.callback)
  end)
  self:AddClickEvent(self.lineBtn, function(go)
    self:LoginByType(6, self.callback)
  end)
  self:AddClickEvent(self.twitterBtn, function(go)
    self:LoginByType(7, self.callback)
  end)
  self:AddClickEvent(self.taptapBtn, function(go)
    self:LoginByType(5, self.callback)
  end)
  self:AddClickEvent(self.moreBtn, function(go)
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if (BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN()) and runtimePlatform == RuntimePlatform.IPhonePlayer then
      self:LoginByType(4, self.callback)
    else
      self:SortByBranch()
      self:SwitchLayer()
    end
  end)
  self:AddClickEvent(self.closeBtn, function(go)
    self:SwitchLayer()
  end)
end

function SdkLoginPanel:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    if self.blockClose then
      return
    end
    self:CloseSelf()
  end)
end

function SdkLoginPanel:AppleOrGoogle()
  local platStr = ApplicationInfo.GetRunPlatformStr()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  Debug.Log("sdk loginPanel :" .. tostring(platStr))
  if ApplicationInfo.IsWindows() then
    self.googleBtn_first:SetActive(true)
    self.googleBtn_second:SetActive(false)
  else
    if BranchMgr.IsJapan() then
      self.appleBtn:SetActive(true)
    else
      self.appleBtn:SetActive(platStr == "iOS")
    end
    self.googleBtn_first:SetActive(platStr == "Android")
    self.googleBtn_second:SetActive(platStr == "iOS")
    if (BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN()) and runtimePlatform == RuntimePlatform.IPhonePlayer then
      self.googleBtn_first:SetActive(true)
      self.googleBtn_second:SetActive(false)
      self.moreSp.spriteName = "sdk_btn_facebook"
      self.moreLabel.text = "Facebook"
    end
  end
end

function SdkLoginPanel:SortByBranch()
  self.twitterBtn:SetActive(BranchMgr.IsJapan())
  self.lineBtn:SetActive(BranchMgr.IsJapan())
  local hideTap = BranchMgr.IsJapan() or BranchMgr.IsKorea() or BranchMgr.IsTW() or BranchMgr.IsVN()
  self.taptapBtn:SetActive(not hideTap)
  self.gridComponent:Reposition()
end

function SdkLoginPanel:SwitchLayer()
  self.firstLayer:SetActive(self.moreTypes)
  self.secondLayer:SetActive(not self.moreTypes)
  self.moreTypes = not self.moreTypes
end

function SdkLoginPanel:LoginByType(loginType, callback)
  local index = 1
  local eventMap = {}
  local callbackTimer
  self.blockClose = true
  FunctionSDK.Instance:LoginByType(loginType, function(sucMsg)
    self.blockClose = false
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
    if callback then
      callback(FunctionLogin.LoginCode.SdkLoginSuc, sucMsg)
    end
    self:CloseSelf()
  end, function(failMsg)
    self.blockClose = false
    if callback then
      callback(FunctionLogin.LoginCode.SdkLoginFailure, failMsg)
    end
  end, function(failMsg)
    self.blockClose = false
    if callback then
      callback(FunctionLogin.LoginCode.SdkLoginCancel, failMsg)
    end
  end)
end
