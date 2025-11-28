SecurityPanel = class("SecurityPanel", ContainerView)
SecurityPanel.ViewType = UIViewType.ConfirmLayer
SecurityPanel.ActionType = {
  Modify = 1,
  Setting = 2,
  Confirm = 3
}
local tempVector3 = LuaVector3.Zero()

function SecurityPanel:Init()
  self.characterMaxLimit = GameConfig.System and GameConfig.System.safe_pwd_max and GameConfig.System.safe_pwd_max or 12
  self.characterMinLimit = GameConfig.System and GameConfig.System.safe_pwd_min and GameConfig.System.safe_pwd_min or 6
  self:initView()
  self:initData()
  self:addViewEventListener()
  self:addListEventListener()
end

function SecurityPanel:initData()
  self.actionType = self.viewdata.viewdata and self.viewdata.viewdata.ActionType or 0
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data or nil
  if self.actionType == SecurityPanel.ActionType.Modify then
    self:Show(self.securityCodeInputConfirmCt)
    self:Show(self.originSecurityCodeInputCt)
    self:Hide(self.pwFormatTip.gameObject)
    self.Title.text = ZhString.SecurityPanel_Title_Set
  elseif self.actionType == SecurityPanel.ActionType.Setting then
    self:Show(self.securityCodeInputConfirmCt)
    self:Hide(self.originSecurityCodeInputCt)
    self:Show(self.pwFormatTip.gameObject)
    self.Title.text = ZhString.SecurityPanel_Title_Set
  elseif self.actionType == SecurityPanel.ActionType.Confirm then
    self:Hide(self.originSecurityCodeInputCt)
    self:Hide(self.securityCodeInputConfirmCt)
    self.Title.text = ZhString.SecurityPanel_Title_Confirm
    self:Hide(self.pwFormatTip.gameObject)
    self:Show(self.unMask.gameObject)
  end
  self.grid:Reposition()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.grid.transform, false)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.grid.transform)
  if self.actionType == SecurityPanel.ActionType.Setting then
    tempVector3[2] = y - height - 90
    self.bg.height = height + 270
  else
    tempVector3[2] = y - height - 50
    self.bg.height = height + 230
  end
  self.confirmBtn.transform.localPosition = tempVector3
  self.isShowPs = false
end

function SecurityPanel:initView()
  self.Title = self:FindComponent("Title", UILabel)
  self.bg = self:FindComponent("bg", UISprite)
  self.confirmBtn = self:FindGO("confirm")
  self.grid = self:FindComponent("grid", UIGrid)
  self.securityCodeInput = self:FindComponent("securityCodeInput", UIInput)
  self.securityCodeInputConfirm = self:FindComponent("securityCodeInputConfirm", UIInput)
  self.originSecurityCodeInputInput = self:FindComponent("originSecurityCodeInputInput", UIInput)
  self.securityCodeInputConfirmCt = self:FindGO("securityCodeInputConfirmCt")
  self.originSecurityCodeInputCt = self:FindGO("originSecurityCodeInputCt")
  self.unMask = self:FindComponent("unMask", UISprite)
  self.securityCodeInput.characterLimit = self.characterMaxLimit
  UIEventListener.Get(self.securityCodeInput.gameObject).onSelect = {
    "+=",
    function(obj, state)
      local value = self.securityCodeInput.value
      if self.isShowPs then
        self.securityCodeInputTip2.text = value
      else
        local len = string.len(value)
        if 0 < len then
          local lastCh = string.sub(value, len, len)
          self.securityCodeInputTip2.text = string.rep("*", len - 1) .. lastCh
        else
          self.securityCodeInputTip2.text = ""
        end
      end
    end
  }
  EventDelegate.Set(self.securityCodeInput.onChange, function(result)
    local value = self.securityCodeInput.value
    if self.isShowPs then
      self.securityCodeInputTip2.text = value
    else
      local len = string.len(value)
      if 0 < len then
        local lastCh = string.sub(value, len, len)
        self.securityCodeInputTip2.text = string.rep("*", len - 1) .. lastCh
      else
        self.securityCodeInputTip2.text = ""
      end
    end
  end)
  UIEventListener.Get(self.securityCodeInputConfirm.gameObject).onSelect = {
    "+=",
    function(obj, state)
      local value = self.securityCodeInputConfirm.value
      if self.isShowPs then
        self.securityCodeInputConfirmTip2.text = value
      else
        local len = string.len(value)
        if 0 < len then
          local lastCh = string.sub(value, len, len)
          self.securityCodeInputConfirmTip2.text = string.rep("*", len - 1) .. lastCh
        else
          self.securityCodeInputConfirmTip2.text = ""
        end
      end
    end
  }
  EventDelegate.Set(self.securityCodeInputConfirm.onChange, function(result)
    local value = self.securityCodeInputConfirm.value
    if self.isShowPs then
      self.securityCodeInputConfirmTip2.text = value
    else
      local len = string.len(value)
      if 0 < len then
        local lastCh = string.sub(value, len, len)
        self.securityCodeInputConfirmTip2.text = string.rep("*", len - 1) .. lastCh
      else
        self.securityCodeInputConfirmTip2.text = ""
      end
    end
  end)
  UIEventListener.Get(self.originSecurityCodeInputInput.gameObject).onSelect = {
    "+=",
    function(obj, state)
      local value = self.originSecurityCodeInputInput.value
      if self.isShowPs then
        self.originSecurityCodeInputTip2.text = value
      else
        local len = string.len(value)
        if 0 < len then
          local lastCh = string.sub(value, len, len)
          self.originSecurityCodeInputTip2.text = string.rep("*", len - 1) .. lastCh
        else
          self.originSecurityCodeInputTip2.text = ""
        end
      end
    end
  }
  EventDelegate.Set(self.originSecurityCodeInputInput.onChange, function(result)
    local value = self.originSecurityCodeInputInput.value
    if self.isShowPs then
      self.originSecurityCodeInputTip2.text = value
    else
      local len = string.len(value)
      if 0 < len then
        local lastCh = string.sub(value, len, len)
        self.originSecurityCodeInputTip2.text = string.rep("*", len - 1) .. lastCh
      else
        self.originSecurityCodeInputTip2.text = ""
      end
    end
  end)
  self:AddClickEvent(self.unMask.gameObject, function()
    local value = self.securityCodeInput.value
    self.isShowPs = not self.isShowPs
    if self.isShowPs then
      self.unMask.spriteName = "com_icon_hide"
      self.securityCodeInputTip2.text = value
    else
      self.unMask.spriteName = "com_icon_show"
      local len = string.len(value)
      if 0 < len then
        local lastCh = string.sub(value, len, len)
        self.securityCodeInputTip2.text = string.rep("*", len - 1) .. lastCh
      else
        self.securityCodeInputTip2.text = ""
      end
    end
  end)
  local confirmLabel = self:FindComponent("confirmLabel", UILabel)
  confirmLabel.text = ZhString.UniqueConfirmView_Confirm
  self.pwFormatTip = self:FindComponent("pwFormatTip", UILabel)
  self.pwFormatTip.text = string.format(ZhString.SecurityPanel_PwFormatTip, self.characterMinLimit, self.characterMaxLimit)
  UIUtil.LimitInputCharacter(self.securityCodeInputConfirm, self.characterMaxLimit, function(str)
    str = string.gsub(str, " ", "")
    local tmp = ""
    for w in string.gmatch(str, "%w") do
      tmp = tmp .. tostring(w)
    end
    return tmp
  end)
  UIUtil.LimitInputCharacter(self.originSecurityCodeInputInput, self.characterMaxLimit, function(str)
    str = string.gsub(str, " ", "")
    local tmp = ""
    for w in string.gmatch(str, "%w") do
      tmp = tmp .. tostring(w)
    end
    return tmp
  end)
  local originSecurityCodeInputTip1 = self:FindComponent("originSecurityCodeInputTip1", UILabel)
  self.originSecurityCodeInputTip2 = self:FindComponent("originSecurityCodeInputTip2", UILabel)
  originSecurityCodeInputTip1.text = ZhString.SecurityPanel_CodeInputTipOrigin
  self.originSecurityCodeInputTip2.text = ZhString.SecurityPanel_CodeInputTipType
  local securityCodeInputTip1 = self:FindComponent("securityCodeInputTip1", UILabel)
  self.securityCodeInputTip2 = self:FindComponent("securityCodeInputTip2", UILabel)
  securityCodeInputTip1.text = ZhString.SecurityPanel_CodeInputTip
  self.securityCodeInputTip2.text = ZhString.SecurityPanel_CodeInputTipType
  local securityCodeInputConfirmTip1 = self:FindComponent("securityCodeInputConfirmTip1", UILabel)
  self.securityCodeInputConfirmTip2 = self:FindComponent("securityCodeInputConfirmTip2", UILabel)
  securityCodeInputConfirmTip1.text = ZhString.SecurityPanel_CodeInputTipConfirm
  self.securityCodeInputConfirmTip2.text = ZhString.SecurityPanel_CodeInputTipType
end

function SecurityPanel:checkRegMatch(str)
  if string.find(str, "^%d+$") then
    return false
  elseif string.find(str, "^[A-Za-z]+$") then
    return false
  else
    return string.len(str) >= self.characterMinLimit and string.len(str) <= self.characterMaxLimit
  end
end

function SecurityPanel:addViewEventListener()
  self:AddButtonEvent("cancel", function()
    self:CloseSelf()
  end)
  local params = {}
  params[1] = self.characterMinLimit
  params[2] = self.characterMaxLimit
  self:AddClickEvent(self.confirmBtn, function()
    if self.actionType == SecurityPanel.ActionType.Modify then
      local psword = self.securityCodeInputConfirm.value
      local confirm = self.securityCodeInput.value
      local origin = self.originSecurityCodeInputInput.value
      if origin and origin ~= "" then
        if psword ~= confirm then
          MsgManager.ShowMsgByIDTable(6001)
        elseif not self:checkRegMatch(psword) then
          MsgManager.ShowMsgByIDTable(6000, params)
        elseif psword and psword ~= "" and psword == confirm then
          ServiceAuthorizeProxy.Instance:CallSetAuthorizeUserCmd(psword, origin)
          self.userInputPw = psword
        elseif not psword or psword == "" then
          MsgManager.ShowMsgByIDTable(6000, params)
        end
      else
        MsgManager.ShowMsgByIDTable(6000, params)
      end
    elseif self.actionType == SecurityPanel.ActionType.Setting then
      local psword = self.securityCodeInputConfirm.value
      local confirm = self.securityCodeInput.value
      if psword ~= confirm then
        MsgManager.ShowMsgByIDTable(6001)
      elseif not self:checkRegMatch(psword) then
        MsgManager.ShowMsgByIDTable(6000, params)
      elseif psword and psword ~= "" and psword == confirm then
        ServiceAuthorizeProxy.Instance:CallSetAuthorizeUserCmd(psword)
        self.userInputPw = psword
      elseif not psword or psword == "" then
        MsgManager.ShowMsgByIDTable(6000, params)
      end
    elseif self.actionType == SecurityPanel.ActionType.Confirm then
      local psword = self.securityCodeInput.value
      if psword and psword ~= "" then
        ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(psword)
        self.userInputPw = psword
      else
        MsgManager.ShowMsgByIDTable(6000, params)
      end
    end
  end)
end

function SecurityPanel:HandleRecvAuthorizeInfo()
  local myself = FunctionSecurity.Me()
  if myself.verifySecuriySus then
    if self.data then
      local callback = self.data.callback
      local arg = self.data.arg
      if callback then
        callback(arg)
      end
    end
    myself.verifySecuriyCode = self.userInputPw
    if self.actionType == SecurityPanel.ActionType.Confirm then
      MsgManager.ShowMsgByIDTable(6011)
    end
  else
    myself.verifySecuriyCode = nil
    if myself.verifySecuriyhasSet then
      MsgManager.ShowMsgByIDTable(6012)
      if self.data and self.data.arg then
        local fc = self.data.arg.failureAct
        if fc then
          fc(arg)
        end
      end
    end
  end
  self:CloseSelf()
end

function SecurityPanel:addListEventListener()
  self:AddListenEvt(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, self.HandleRecvAuthorizeInfo)
end

function SecurityPanel:OnExit(...)
  self:sendNotification(SecurityEvent.Close)
  self.securityCodeInput = nil
  self.securityCodeInputConfirm = nil
  self.originSecurityCodeInputInput = nil
end
