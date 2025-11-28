local ItemConfirmView = class("ItemConfirmView", BaseView)
ItemConfirmView.ViewType = UIViewType.ConfirmLayer

function ItemConfirmView:Init()
  self:FindObjs()
  self:FillContent()
  self:FillButton()
end

function ItemConfirmView:FindObjs()
  self.titleLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "TitleLabel"):GetComponent(UILabel)
  self.contentLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "ContentLabel"):GetComponent(UILabel)
  self.confirmLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "ConfirmLabel"):GetComponent(UILabel)
  self.cancelLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "CancelLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.closeBtn = self:FindGO("CloseBtn")
  self.btns = self:FindGO("Btns"):GetComponent(UIWidget)
  self.scrollView = self:FindGO("Scroll View"):GetComponent(UIScrollView)
  self.grid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemCtrl = UIGridListCtrl.new(self.grid, BagItemCell, "BagItemCell")
  self.noneTip = self:FindGO("NoneTip")
  self:AddButtonEvent("ConfirmBtn", function(go)
    self:DoConfirm()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function(go)
    self:DoCancel()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function ItemConfirmView:CloseSelf()
  self.isHandled = true
  ItemConfirmView.super.CloseSelf(self)
end

function ItemConfirmView:DoConfirm()
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end

function ItemConfirmView:DoCancel()
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end

function ItemConfirmView:OnExit()
  if self.isHandled == false and self.viewdata.needExitDefaultHandle then
    self:DoCancel()
  end
  UIManagerProxy.ItemConfirmView = nil
  self.viewdata = nil
end

function ItemConfirmView:FillContent(text)
  text = text or self.viewdata.content
  if self.viewdata.lockreason then
    self.contentLabel.text = text .. "\n" .. self.viewdata.lockreason
  else
    self.contentLabel.text = text
  end
  local height = self.contentLabel.printedSize.y
  if 30 < height then
    self.contentLabel.pivot = UIWidget.Pivot.Left
  else
    self.contentLabel.pivot = UIWidget.Pivot.Center
  end
  items = self.viewdata.items or {}
  if items and #items >= 6 then
    self.scrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.scrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.itemCtrl:ResetDatas(items)
  self.scrollView:ResetPosition()
  self.noneTip:SetActive(#items == 0)
end

function ItemConfirmView:FillButton()
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

return ItemConfirmView
