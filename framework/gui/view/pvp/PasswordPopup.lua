PasswordPopup = class("PasswordPopup", BaseView)
PasswordPopup.ViewType = UIViewType.Lv4PopUpLayer

function PasswordPopup:Init()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.passwordInput = self:FindComponent("Input", UIInput)
  if self.passwordInput then
    UIUtil.LimitInputCharacter(self.passwordInput, GameConfig.ChatRoom.PwdSize)
    EventDelegate.Set(self.passwordInput.onChange, function()
      self.passwordInput.value = self.passwordInput.value:gsub("-", "")
      self.passwordInput.characterLimit = GameConfig.ChatRoom.PwdSize
    end)
    self.passwordInput.value = ""
  end
  self.cancelBtnGO = self:FindGO("Cancel")
  self:AddClickEvent(self.cancelBtnGO, function()
    self:OnCancelClicked()
  end)
  self.confirmBtnGO = self:FindGO("Confirm")
  self:AddClickEvent(self.confirmBtnGO, function()
    self:OnConfirmClicked()
  end)
  local viewData = self.viewdata
  if viewData then
    self.callbackTarget = viewData.callbackTarget
    self.cancelCallback = viewData.cancelCallback
    self.confirmCallback = viewData.confirmCallback
    self.titleLabel.text = viewData.title or ""
  end
end

function PasswordPopup:OnCancelClicked()
  if self.callbackTarget and self.cancelCallback then
    self.cancelCallback(self.callbackTarget)
  end
  self:CloseSelf()
end

function PasswordPopup:OnConfirmClicked()
  if string.len(self.passwordInput.value) ~= GameConfig.ChatRoom.PwdSize and string.len(self.passwordInput.value) ~= 0 then
    MsgManager.ShowMsgByID(805)
    return
  end
  if self.callbackTarget and self.confirmCallback then
    self.confirmCallback(self.callbackTarget, self.passwordInput.value)
  end
  self:CloseSelf()
end
