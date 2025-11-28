PetPackagePopView = class("PetPackagePopView", BaseView)
PetPackagePopView.ViewType = UIViewType.ConfirmLayer

function PetPackagePopView:Init()
  self:GetComponents()
  self:InitView()
end

function PetPackagePopView:GetComponents()
  self:AddButtonEvent("ConfirmButton", function()
    self:CloseSelf()
    EventManager.Me():DispatchEvent(UICloseEvent.PetPackagePopViewClose)
  end)
  self.notice = self:FindComponent("Notice", UILabel)
  self.noticeToggle = self:FindComponent("NoticeToggle", UIToggle)
end

function PetPackagePopView:InitView()
end

function PetPackagePopView:OnEnter()
  PetPackagePopView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local msgid = viewdata.msgid
    if msgid == 8026 then
      local msgData = Table_Sysmsg[8026]
      if msgData then
        self.notice.text = msgData.Text
        EventDelegate.Add(self.noticeToggle.onChange, function()
          FunctionPlayerPrefs.Me():SetBool(PetPackagePart.IsNoticeShow, self.noticeToggle.value)
        end)
      end
    elseif msgid == 27180 then
      local msgData = Table_Sysmsg[27180]
      if msgData then
        self.notice.text = msgData.Text
        EventDelegate.Add(self.noticeToggle.onChange, function()
          local setting = FunctionPerformanceSetting.Me()
          setting:SetBegin()
          setting:SetShowFpsFrameHint(not self.noticeToggle.value)
          setting:SetEnd()
        end)
      end
    end
  else
  end
end

function PetPackagePopView:OnExit()
  self.super.OnExit(self)
  self.noticeToggle = nil
end
