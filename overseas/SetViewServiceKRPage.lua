SetViewServiceKRPage = class("SetViewServiceKRPage", SetViewSubPage)

function SetViewServiceKRPage:Init(initParama)
  SetViewServiceKRPage.super.Init(self, initParama)
  self.conditionBtn = self:FindGO("condition")
  self:AddClickEvent(self.conditionBtn, function(go)
    if BranchMgr.IsNOKR() then
      Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=ROMC_terms")
    else
      Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_terms")
    end
  end)
  self.personalBtn = self:FindGO("personal")
  self:AddClickEvent(self.personalBtn, function(go)
    Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_privacy")
  end)
  self.policyBtn = self:FindGO("policy")
  self:AddClickEvent(self.policyBtn, function(go)
    if BranchMgr.IsNOKR() then
      Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=ROMC_policy")
    else
      Application.OpenURL("https://member.gnjoy.com/support/terms/common/commonterm.asp?category=mobile_policy")
    end
  end)
  self.serviceBtn = self:FindGO("service")
  self:AddClickEvent(self.serviceBtn, function(go)
    if BranchMgr.IsNOKR() then
      local functionLogin = FunctionLogin.Me()
      local serverData = functionLogin and functionLogin:getCurServerData()
      if serverData ~= nil and serverData.sid ~= nil then
        local accid = serverData.accid ~= nil and tostring(serverData.accid) or ""
        local playerName = "未登入"
        if Game ~= nil and Game.Myself ~= nil then
          playerName = Game.Myself.data:GetName()
          playerName = RemoveSpecialChara(playerName)
        end
        local charid = Game.Myself.data.id
        FunctionSDK.Instance:EnterBugReport(tostring(serverData.sid), charid, playerName)
      end
    else
      Application.OpenURL("http://member.gnjoy.com/mobile/inquiry/rom")
    end
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
  self.notiToggleGO = self:FindGO("noticeTog")
  self.notiToggle = self.notiToggleGO:GetComponent("UIToggle")
  self.oldStatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  self.notiToggle.value = self.oldStatus
  if BranchMgr.IsNOKR() then
    self.notiToggleGO:SetActive(false)
  else
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
  self.diamondDetailBtn = self:FindGO("diamondDetail")
  if BranchMgr.IsNOKR() then
    self.diamondDetailBtn:SetActive(true)
    self:AddClickEvent(self.diamondDetailBtn, function(go)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LotteryCoinInfo,
        viewdata = {}
      })
    end)
  else
    self.diamondDetailBtn:SetActive(false)
  end
  self.announcementBtn = self:FindGO("Announcement")
  if self.announcementBtn then
    self.announcementBtn:SetActive(BranchMgr.IsNOKR())
    self:AddClickEvent(self.announcementBtn, function(go)
      Application.OpenURL("https://game.naver.com/lounge/Ragnarok_M_Classic/board/3")
    end)
  end
end

function SetViewServiceKRPage:Save()
  if BranchMgr.IsNOKR() then
    return
  end
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
  if BranchMgr.IsNOKR() then
    return false
  end
  return self.oldStatus ~= self.notiToggle.value
end
