GemAskForArrangeRangePopUp = class("GemAskForArrangeRangePopUp", BaseView)
GemAskForArrangeRangePopUp.ViewType = UIViewType.Lv4PopUpLayer
GemAskForArrangeIndexLevelMap = {
  [1] = 5,
  [2] = 10
}

function GemAskForArrangeRangePopUp:Init()
  self:FindObjs()
  self:AddEvents()
end

function GemAskForArrangeRangePopUp:FindObjs()
  self.confirmButton = self:FindGO("ConfirmBtn")
  self.cancelButton = self:FindGO("CancelBtn")
  self.toggles = {}
  local toggleGO
  for i = 1, 2 do
    toggleGO = self:FindGO("Toggle" .. i)
    self.toggles[i] = toggleGO:GetComponent(UIToggle)
  end
end

function GemAskForArrangeRangePopUp:AddEvents()
  self:AddClickEvent(self.confirmButton, function()
    self:TryArrange()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.cancelButton, function()
    self:CloseSelf()
  end)
  for i = 1, 2 do
    EventDelegate.Add(self.toggles[i].onChange, function()
      if self.toggles[i].value then
        self.curToggleIndex = i
      end
    end)
  end
end

function GemAskForArrangeRangePopUp:TryArrange()
  ServiceItemProxy.Instance:CallGemAttrComposeItemCmd(GemAskForArrangeIndexLevelMap[self.curToggleIndex or 1])
end
