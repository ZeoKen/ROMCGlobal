SecretEnterForFightPopUp = class("SecretEnterForFightPopUp", ContainerView)
SecretEnterForFightPopUp.ViewType = UIViewType.PopUpLayer

function SecretEnterForFightPopUp:Init()
  self:InitUI()
end

function SecretEnterForFightPopUp:InitUI()
  self.input = self:FindComponent("Input", UIInput)
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function(go)
    helplog("Enter PassWord", self.input.value)
    ServicePvpCmdProxy.Instance:CallJoinTeamMatch(self.pvp_type)
    self:CloseSelf()
    self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  end)
end

function SecretEnterForFightPopUp:OnEnter()
  SecretEnterForFightPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.pvp_type = viewdata.pvp_type
  end
end

function SecretEnterForFightPopUp:MapViewEvent()
end
