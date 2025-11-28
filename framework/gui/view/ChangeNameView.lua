ChangeNameView = class("ChangeNameView", ContainerView)
ChangeNameView.ViewType = UIViewType.PopUpLayer

function ChangeNameView:Init()
  self:InitView()
  self:AddEvts()
  self:AddViewEvt()
end

function ChangeNameView:InitView()
  self.input = self:FindComponent("Input", UIInput)
  UIUtil.LimitInputCharacter(self.input, 12)
  self.filterType = GameConfig.MaskWord.ChangeName
end

function ChangeNameView:AddEvts()
  self:AddButtonEvent("Confirm", function()
    if self.input.value == "" then
      MsgManager.ShowMsgByID(47)
      return
    end
    local value = self.input.value
    if FunctionMaskWord.Me():CheckMaskWord(value, self.filterType) then
      MsgManager.ShowMsgByIDTable(2604)
    end
    ServiceNUserProxy.Instance:CallChangeNameUserCmd(value)
  end)
end

function ChangeNameView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.NUserChangeNameUserCmd, self.CloseSelf)
end
