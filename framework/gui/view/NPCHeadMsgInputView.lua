NPCHeadMsgInputView = class("NPCHeadMsgInputView", ContainerView)
NPCHeadMsgInputView.ViewType = UIViewType.NormalLayer

function NPCHeadMsgInputView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function NPCHeadMsgInputView:FindObjs()
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.textInput = self:FindComponent("Input", UIInput)
  self.inputLabel = self:FindComponent("InputLabel", UILabel)
  self.titleLabel = self:FindComponent("TipLabel", UILabel)
  self.npcInfo = self.viewdata.viewdata.npcdata
  self.msgType = self.viewdata.viewdata.msgType
  self.data = self.viewdata.viewdata.data
  if self.msgType then
    if self.msgType == 1 then
      self.titleLabel.text = ZhString.AdventureToys_EditHeadText
    elseif self.msgType == 2 then
      self.titleLabel.text = ZhString.AdventureToys_EditDefaultDialog
    end
  end
end

function NPCHeadMsgInputView:InitView()
end

function NPCHeadMsgInputView:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    local input = self.inputLabel.text
    local length = StringUtil.Utf8len(input)
    if self.inputLabel.text == "" then
      MsgManager.ShowMsgByIDTable(2901)
    elseif FunctionMaskWord.Me():CheckMaskWord(self.inputLabel.text, GameConfig.MaskWord.HeadEdit) then
      MsgManager.ShowMsgByIDTable(2604)
    elseif self.msgType == 1 and GameConfig.System.headtext_max and length > GameConfig.System.headtext_max then
      MsgManager.ShowMsgByIDTable(40959)
    elseif self.msgType == 2 and GameConfig.System.npcdialog_max and length > GameConfig.System.npcdialog_max then
      MsgManager.ShowMsgByIDTable(40960)
    else
      if self.msgType == 1 then
        ServiceMapProxy.Instance:CallEditNpcTextMapCmd(self.msgType, self.npcInfo.data.id, self.inputLabel.text)
      elseif self.msgType == 2 then
        ServiceMapProxy.Instance:CallEditNpcTextMapCmd(self.msgType, self.npcInfo, self.inputLabel.text)
        FunctionItemFunc.DoUseItem(self.data, nil, 1)
      end
      self:CloseSelf()
    end
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self:CloseSelf()
  end)
end
