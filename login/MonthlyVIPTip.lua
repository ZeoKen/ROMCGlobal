MonthlyVIPTip = class("MonthlyVIPTip")

function MonthlyVIPTip.Ins()
  if MonthlyVIPTip.ins == nil then
    MonthlyVIPTip.ins = MonthlyVIPTip.new()
  end
  return MonthlyVIPTip.ins
end

function MonthlyVIPTip:ReadyForLoginExpirationTip()
  self.readyForLoginExpirationTip = 0
end

function MonthlyVIPTip:OnReceiveFinishLoadScene()
  self:DoShowTip()
  self.readyForLoginExpirationTip = nil
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnReceiveFinishLoadScene, self)
end

function MonthlyVIPTip:ShowTip()
  if self.readyForLoginExpirationTip ~= nil then
    EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnReceiveFinishLoadScene, self)
  else
    self:DoShowTip()
  end
end

function MonthlyVIPTip:DoShowTip()
  MsgManager.ConfirmMsgByID(1102, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard, FunctionNewRecharge.InnerTab.Card_MonthlyVIP)
  end)
end
