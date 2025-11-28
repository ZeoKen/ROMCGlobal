autoImport("ItemCardCell")
NewCardRewardPopup = class("NewCardRewardPopup", ContainerView)
NewCardRewardPopup.ViewType = UIViewType.ConfirmLayer

function NewCardRewardPopup:Init()
  self:InitView()
end

function NewCardRewardPopup:InitView()
  self.cardItemGO = self:FindGO("ItemCardCell")
  self.cardItemCtrl = ItemCardCell.new(self.cardItemGO)
  local cancelBtnGO = self:FindGO("CancelButton")
  self:AddClickEvent(cancelBtnGO, function()
    self:OnCancelClicked()
  end)
  local confirmBtnGO = self:FindGO("ConfirmButton")
  self:AddClickEvent(confirmBtnGO, function()
    self:OnConfirmClicked()
  end)
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.itemProperty = self:FindComponent("ItemProperty", UILabel)
  if self.viewdata and self.viewdata.viewdata then
    local itemId = self.viewdata.viewdata.itemId
    self:SetDataByItemId(itemId)
  end
end

function NewCardRewardPopup:SetDataByItemId(itemId)
  if not itemId then
    return
  end
  local itemData = ItemData.new("NewCardReward", itemId)
  self.cardItemCtrl:SetData(itemData)
  local cardInfo = itemData.cardInfo
  if cardInfo then
    self.itemName.text = cardInfo.Name
    self.itemProperty.text = AdventureDataProxy.Instance:getUnlockRewardStr(itemData.staticData, ZhString.ItemTip_ChAnd) or ""
  end
end

function NewCardRewardPopup:OnConfirmClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AdventurePanel,
    viewdata = {tabId = 2}
  })
  self:CloseSelf()
end

function NewCardRewardPopup:OnCancelClicked()
  self:CloseSelf()
end
