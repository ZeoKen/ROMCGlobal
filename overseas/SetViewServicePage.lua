SetViewServicePage = class("SetViewServicePage", SetViewSubPage)

function SetViewServicePage:Init(initParama)
  SetViewServicePage.super.Init(self, initParama)
  self.helpBtn = self:FindGO("helpBtn")
  self:AddClickEvent(self.helpBtn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/help")
  end)
  self.noticeBtn = self:FindGO("noticeBtn")
  self:AddClickEvent(self.noticeBtn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member")
  end)
  self.privacyBtn = self:FindGO("privacyBtn")
  self:AddClickEvent(self.privacyBtn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rm/privacy")
  end)
  self.law1Btn = self:FindGO("law1Btn")
  self:AddClickEvent(self.law1Btn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/shikin")
  end)
  self.law2Btn = self:FindGO("law2Btn")
  self:AddClickEvent(self.law2Btn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/trade")
  end)
  self.law3Btn = self:FindGO("law3Btn")
  self:AddClickEvent(self.law3Btn, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryCoinInfo,
      viewdata = {}
    })
  end)
  self.law4Btn = self:FindGO("law4Btn")
  self:AddClickEvent(self.law4Btn, function(go)
    OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/rules/terms.html")
  end)
  self.law5Btn = self:FindGO("law5Btn")
  self:AddClickEvent(self.law5Btn, function(go)
    OverseaHostHelper:OpenWebView("https://ragnarokm.gungho.jp/member/credit")
  end)
  self.notiToggle = self:FindGO("noticeTog"):GetComponent("UIToggle")
  self.oldStatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  self.notiToggle.value = self.oldStatus
  EventDelegate.Add(self.notiToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus)
  end)
  self.accountCancel = self:FindGO("accountCancel")
  if GameConfig.Logout_MenuId == 1 then
    self.accountCancel:SetActive(true)
    self:AddClickEvent(self:FindGO("accountCancelBtn"), function(go)
      OverSeas_TW.OverSeasManager.GetInstance():AccountCancellation()
      Game.Me():BackToLogo()
    end)
  else
    self.accountCancel:SetActive(false)
  end
end

function SetViewServicePage:Save()
  self.oldStatus = self.notiToggle.value
  OverSeas_TW.OverSeasManager.GetInstance():SetNotification(self.notiToggle.value)
end

function SetViewServicePage:IsChanged()
  return self.oldStatus ~= self.notiToggle.value
end
