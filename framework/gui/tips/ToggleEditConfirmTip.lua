autoImport("BaseTip")
ToggleEditConfirmTip = class("ToggleEditConfirmTip", BaseTip)

function ToggleEditConfirmTip:OnEnter()
  ToggleEditConfirmTip.super.OnEnter(self)
  self.gameObject:SetActive(true)
end

function ToggleEditConfirmTip:Init()
  self:FindObjs()
  self:AddEvts()
end

function ToggleEditConfirmTip:FindObjs()
  self.text = self:FindComponent("Text", UILabel)
  self.toggle = self:FindComponent("Toggle", UIToggle)
  self:AddTabEvent(self.toggle.gameObject, function(go, value)
    self.togvalue = value
  end)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
end

function ToggleEditConfirmTip:AddEvts()
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function ToggleEditConfirmTip:SetData(data)
  ToggleEditConfirmTip.super.SetData(self, data)
  if data then
    if data.title then
      self.text.text = data.title
    end
    if data.value then
      self.toggle.value = data.value
    end
    self.togvalue = value
    if data.closecall then
      self.closecall = data.closecall
    end
  end
end

function ToggleEditConfirmTip:OnExit()
  if self.closecall then
    self.closecall(self.togvalue)
  end
  ToggleEditConfirmTip.super.OnExit(self)
end

function ToggleEditConfirmTip:CloseSelf()
  TipsView.Me():HideCurrent()
end
