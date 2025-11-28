local UniqueConfirmView = autoImport("UniqueConfirmView")
DontShowAgainConfirmView = class("DontShowAgainConfirmView", UniqueConfirmView)
DontShowAgainConfirmView.ViewType = UIViewType.ConfirmLayer

function DontShowAgainConfirmView:Init()
  self.viewdata.title = self.viewdata.data.Title
  self.viewdata.confirmtext = self.viewdata.data.button ~= "" and self.viewdata.data.button or nil
  self.viewdata.canceltext = self.viewdata.data.buttonF ~= "" and self.viewdata.data.buttonF or nil
  self.viewdata.needCloseBtn = self.viewdata.data.Close == 1
  if self.viewdata.data.TimeInterval == 0 then
    self.viewdata.checkLabel = ZhString.DontShowAgainCheckString
  elseif self.viewdata.data.TimeInterval then
    self.viewdata.checkLabel = string.format(ZhString.DontShowAgainCheckStringWithDays, self.viewdata.data.TimeInterval)
  end
  DontShowAgainConfirmView.super.Init(self)
  self:FillTitle()
  self:FillCheckLabel()
  self:JudgeNeedShowToggle()
end

function DontShowAgainConfirmView:FindObjs()
  self._find = true
  self.isHandled = false
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.contentLabel = self:FindGO("ContentLabel"):GetComponent(UILabel)
  self.confirmLabel = self:FindGO("ConfirmLabel"):GetComponent(UILabel)
  self.cancelLabel = self:FindGO("CancelLabel"):GetComponent(UILabel)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.closeBtn = self:FindGO("CloseButton")
  self.textScrollView = self:FindGO("TextScrollView"):GetComponent(UIScrollView)
  self.textPanel = self:FindGO("TextScrollView"):GetComponent(UIPanel)
  self:AddButtonEvent("ConfirmBtn", function(go)
    self:DoConfirm()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function(go)
    self:DoCancel()
    self:CloseSelf()
  end)
  self.maskCollider = self:FindGO("Mask")
  self:AddClickEvent(self.maskCollider, function()
    if not self.viewdata.needCloseBtn then
      self:DoCancel()
    end
    self:CloseSelf()
  end)
end

function DontShowAgainConfirmView:JudgeNeedShowToggle()
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  local data = self.viewdata.data
  if data.TimeInterval == nil or data.TimeInterval == -1 then
    self:Hide(self.checkBtn)
    self:ResizeTaskScrollView(2)
  else
    self:Show(self.checkBtn)
    self:ResizeTaskScrollView(1)
  end
  self.textScrollView:ResetPosition()
end

local textSVParam = {
  [1] = {offsetY = 50, height = 130},
  [2] = {offsetY = 33, height = 158}
}

function DontShowAgainConfirmView:ResizeTaskScrollView(type)
  local param = textSVParam[type]
  if not param then
    return
  end
  local clip = self.textPanel.baseClipRegion
  local pos = self.textPanel.gameObject.transform.localPosition
  local targetOffsetY = param.offsetY - pos.y
  self.textPanel.clipOffset = LuaGeometry.GetTempVector2(self.textPanel.clipOffset.x, targetOffsetY)
  self.textPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
end

function DontShowAgainConfirmView:DoConfirm()
  self:HandleDontShowAgain(1)
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end

function DontShowAgainConfirmView:DoCancel()
  self:HandleDontShowAgain(2)
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end

function DontShowAgainConfirmView:CloseSelf()
  self.isHandled = true
  UniqueConfirmView.super.CloseSelf(self)
end

function DontShowAgainConfirmView:OnExit()
  if not self.isHandled then
    self:DoCancel()
  end
  DontShowAgainConfirmView.super.OnExit(self)
end

function DontShowAgainConfirmView:FillCheckLabel(text)
  text = text or self.viewdata.checkLabel
  if text ~= nil then
    self.checkLabel.text = text
  end
  local checkLabelX = self.checkLabel.transform.localPosition.x
  self.checkBtn.transform.localPosition = LuaGeometry.GetTempVector3(-(checkLabelX - self.checkBg.width / 2 + self.checkLabel.width) / 2, 76.4, 0)
end

function DontShowAgainConfirmView:HandleDontShowAgain(opt)
  local data = self.viewdata.data
  if self.checkBtn and data.TimeInterval ~= nil and data.TimeInterval ~= -1 and self.checkBtn.value then
    if data.SaveOpt == 1 then
      LocalSaveProxy.Instance:AddDontShowAgain(data.id, data.TimeInterval, opt)
    else
      LocalSaveProxy.Instance:AddDontShowAgain(data.id, data.TimeInterval)
    end
  end
end
