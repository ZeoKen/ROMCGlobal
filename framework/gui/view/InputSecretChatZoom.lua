InputSecretChatZoom = class("InputSecretChatZoom", ContainerView)
InputSecretChatZoom.ViewType = UIViewType.PopUpLayer

function InputSecretChatZoom:Init()
  self.labTitle = self:FindGO("Title"):GetComponent(UILabel)
  self.uiInput = self:FindGO("Input"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.uiInput, GameConfig.ChatRoom.PwdSize)
  self:Listen()
end

function InputSecretChatZoom:OnEnter()
  self.super.OnEnter(self)
  self:AddClickEvent(self:FindGO("Confirm"), function()
    self:OnButtonConfirmClick()
  end)
  self:AddClickEvent(self:FindGO("Cancel"), function()
    self:OnButtonCancelClick()
  end)
end

function InputSecretChatZoom:OnExit()
  self.super.OnExit(self)
end

function InputSecretChatZoom:Listen()
  self:AddListenEvt(ChatZoomEvent.TransmitChatZoomSummary, self.OnReceiveEventTransmitChatZoomSummary)
end

function InputSecretChatZoom:OnButtonConfirmClick()
  if self.uiInput.value == self.chatZoomSummary.pswd then
    ServiceChatRoomProxy.Instance:CallJoinChatRoom(self.chatZoomSummary.roomid, self.uiInput.value)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByID(804)
  end
end

function InputSecretChatZoom:OnButtonCancelClick()
  self:CloseSelf()
end

function InputSecretChatZoom:OnReceiveEventTransmitChatZoomSummary(message)
  print("FUN >>> InputSecretChatZoom:OnReceiveEventTransmitChatZoomSummary")
  print("chatZoomSummary following...")
  TableUtil.Print(message)
  if message == nil then
    return
  end
  local chatZoomSummary = message.body
  self.chatZoomSummary = chatZoomSummary
  local str = chatZoomSummary.name
  if string.len(str) > 21 then
    str = string.sub(str, 1, 21) .. ".."
  end
  self.labTitle.text = str
end
