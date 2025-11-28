BattleFundConfirmPopup = class("BattleFundConfirmPopup", BaseView)
BattleFundConfirmPopup.ViewType = UIViewType.ConfirmLayer

function BattleFundConfirmPopup:Init()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.cancelBtnGO = self:FindGO("Cancel")
  self:AddClickEvent(self.cancelBtnGO, function()
    self:OnCancelClicked()
  end)
  self.confirmBtnGO = self:FindGO("Confirm")
  self:AddClickEvent(self.confirmBtnGO, function()
    self:OnConfirmClicked()
  end)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.numLabel = self:FindComponent("ItemNum", UILabel)
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  local viewData = self.viewdata and self.viewdata.viewdata
  if viewData then
    self.callbackTarget = viewData.callbackTarget
    self.cancelCallback = viewData.cancelCallback
    self.confirmCallback = viewData.confirmCallback
    if viewData.title then
      self.titleLabel.text = viewData.title
    end
    if viewData.confirmText then
      local confirmLab = self:FindComponent("ConfirmLabel", UILabel, self.confirmBtnGO)
      confirmLab.text = viewData.confirmText
    end
    if viewData.cancelText then
      local cancelLab = self:FindComponent("CancelLabel", UILabel, self.confirmBtnGO)
      cancelLab.text = viewData.cancelText
    end
    self.contentLabel.text = viewData.content or ""
    if viewData.itemIcon then
      IconManager:SetItemIcon(viewData.itemIcon, self.itemIcon)
    end
    if viewData.itemNum then
      self.numLabel.text = "x" .. viewData.itemNum
    end
  end
end

function BattleFundConfirmPopup:OnCancelClicked()
  if self.callbackTarget and self.cancelCallback then
    self.cancelCallback(self.callbackTarget)
  end
  self:CloseSelf()
end

function BattleFundConfirmPopup:OnConfirmClicked()
  if self.callbackTarget and self.confirmCallback then
    self.confirmCallback(self.callbackTarget)
  end
  self:CloseSelf()
end
