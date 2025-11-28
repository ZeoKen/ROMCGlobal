local UniqueConfirmView = class("UniqueConfirmView", BaseView)
UniqueConfirmView.ViewType = UIViewType.ConfirmLayer
local singleLineHeight = 34
local originBtnHeight = 13
local originBgHeight = 216
local tempPos = LuaVector3(0, 0, 0)

function UniqueConfirmView:Init()
  self:FindObjs()
  self:FillTitle()
  self:FillContent()
  self:FillButton()
  self:InitCloseBtn()
end

function UniqueConfirmView:GetUnique()
  return self.viewdata.unique
end

function UniqueConfirmView:FindObjs()
  self._find = true
  self.isHandled = false
  self.titleLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "Title"):GetComponent(UILabel)
  self.contentLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "ContentLabel"):GetComponent(UILabel)
  self.confirmLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "ConfirmLabel"):GetComponent(UILabel)
  self.cancelLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "CancelLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.closeBtn = self:FindGO("CloseButton")
  self.bg = self:FindGO("Bg"):GetComponent(UIWidget)
  self.btns = self:FindGO("Btns"):GetComponent(UIWidget)
  self.thaiFont = self:FindComponent("Thai", UIFont)
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
    if self.viewdata.needCloseBtn then
      self:CloseSelf()
    end
  end)
end

function UniqueConfirmView:InitCloseBtn()
  if self.closeBtn ~= nil then
    if self.viewdata.needCloseBtn then
      self:Show(self.closeBtn)
    else
      self:Hide(self.closeBtn)
    end
  end
end

function UniqueConfirmView:DoConfirm()
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end

function UniqueConfirmView:DoCancel()
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end

function UniqueConfirmView:CloseSelf()
  self.isHandled = true
  UniqueConfirmView.super.CloseSelf(self)
end

function UniqueConfirmView:OnEnter()
  UIManagerProxy.UniqueConfirmView = self
  UniqueConfirmView.super.OnEnter(self)
  EventManager.Me():AddEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function UniqueConfirmView:OnCHangeZ(data)
  local p = self.gameObject:GetComponent(UIPanel)
  p.depth = data.depth
end

function UniqueConfirmView:OnExit()
  if self.isHandled == false and self.viewdata.needExitDefaultHandle then
    self:DoCancel()
  end
  UIManagerProxy.UniqueConfirmView = nil
  self.viewdata = nil
  EventManager.Me():RemoveEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function UniqueConfirmView:FillTitle(text)
  text = text or self.viewdata.title
  if text ~= nil then
    self.titleLabel.text = text
  end
end

function UniqueConfirmView:FillContent(text)
  text = text or self.viewdata.content
  local patTai = OverSea.LangManager.Instance():GetLangByKey(ZhString.LangSwitchPanel_Thai)
  if text ~= nil then
    if string.match(text, patTai) then
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.thaiFont
    else
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.confirmLabel.bitmapFont
    end
    if self.viewdata.lockreason then
      self.contentLabel.text = text .. "\n" .. self.viewdata.lockreason
    else
      self.contentLabel.text = text
    end
    self:ResizeView()
  end
end

function UniqueConfirmView:FillButton()
  local confirmtext = self.viewdata.confirmtext
  if confirmtext == nil or confirmtext == "" then
    self:Hide(self.confirmBtn)
  end
  confirmtext = (confirmtext == nil or confirmtext == "") and ZhString.UniqueConfirmView_Confirm or confirmtext
  local canceltext = self.viewdata.canceltext
  if canceltext == nil or canceltext == "" then
    self:Hide(self.cancelBtn)
  end
  canceltext = (canceltext == nil or canceltext == "") and ZhString.UniqueConfirmView_CanCel or canceltext
  self.confirmLabel.text = confirmtext
  self.cancelLabel.text = canceltext
end

function UniqueConfirmView:ResizeView()
  if not self._find then
    return
  end
  local printedY = self.contentLabel.printedSize.y
  local svHeight = self.textPanel.baseClipRegion.w
  if printedY > svHeight then
    self.textScrollView.contentPivot = UIWidget.Pivot.Top
  else
    self.textScrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.textScrollView:ResetPosition()
end

return UniqueConfirmView
