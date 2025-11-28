SetViewServiceKRPage = class("SetViewServiceKRPage", SetViewSubPage)

function SetViewServiceKRPage:Init(initParama)
  SetViewServiceKRPage.super.Init(self, initParama)
  self.conditionBtn = self:FindGO("condition")
  self:AddClickEvent(self.conditionBtn, function(go)
    Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_terms")
  end)
  self.personalBtn = self:FindGO("personal")
  self:AddClickEvent(self.personalBtn, function(go)
    Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_privacy")
  end)
  self.policyBtn = self:FindGO("policy")
  self:AddClickEvent(self.policyBtn, function(go)
    Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_policy")
  end)
  self.serviceBtn = self:FindGO("service")
  self:AddClickEvent(self.serviceBtn, function(go)
    Application.OpenURL("http://member.gnjoy.com/mobile/inquiry/rom")
  end)
  self.accountCancel = self:FindGO("accountCancel")
  if GameConfig.Logout_MenuId == 1 then
    self.accountCancel:SetActive(true)
    self:AddClickEvent(self.accountCancel, function(go)
      OverSeas_TW.OverSeasManager.GetInstance():AccountCancellation()
      Game.Me():BackToLogo()
    end)
  else
    self.accountCancel:SetActive(false)
  end
  self.notiToggle = self:FindGO("noticeTog"):GetComponent("UIToggle")
  self.oldStatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  self.notiToggle.value = self.oldStatus
  EventDelegate.Add(self.notiToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus)
    local exFirstToggleChanged = self.firstToggleChanged
    self.firstToggleChanged = true
    if not exFirstToggleChanged then
      return
    end
    if self.notiToggle.value then
      local y, m, d = self:GetSaveTime()
      MsgManager.ShowMsgByIDTable(1000011, {
        y,
        m,
        d
      })
      return
    end
    local y, m, d = self:GetSaveTime()
    MsgManager.ShowMsgByIDTable(1000012, {
      y,
      m,
      d
    })
  end)
end

function SetViewServiceKRPage:Save()
  self.oldStatus = self.notiToggle.value
  OverSeas_TW.OverSeasManager.GetInstance():SetNotification(self.notiToggle.value)
  ServiceOverseasTaiwanCmdProxy.Instance:CallFirebaseNotifyUpdateCmd(self.notiToggle.value)
end

function SetViewServiceKRPage:GetSaveTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local year = os.date("%Y", curServerTime)
  local month = os.date("%m", curServerTime)
  local day = os.date("%d", curServerTime)
  return year, month, day
end

function SetViewServiceKRPage:IsChanged()
  return self.oldStatus ~= self.notiToggle.value
end
