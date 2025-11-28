ExtractionSlotPopUp = class("PurchaseSaveSlotPopUp", ContainerView)
ExtractionSlotPopUp.ViewType = UIViewType.PopUpLayer

function ExtractionSlotPopUp:Init()
  self:InitView()
end

function ExtractionSlotPopUp:InitView()
  local _viewdata = self.viewdata.viewdata
  local costid = _viewdata.costid
  local costnum = _viewdata.costnum
  local icon = self:FindGO("icon"):GetComponent(UISprite)
  local label = self:FindGO("Label", icon.gameObject):GetComponent(UILabel)
  local itemConfig = Table_Item[costid]
  local iconName = itemConfig.Icon
  local currencyName = itemConfig.NameZh
  IconManager:SetItemIcon(iconName, icon)
  label.text = tostring(costnum)
  local moneyCount = 0
  local moneyId = GameConfig.MoneyId
  if costid == moneyId.Zeny then
    moneyCount = MyselfProxy.Instance:GetROB()
  elseif costid == moneyId.Lottery then
    moneyCount = MyselfProxy.Instance:GetLottery()
  end
  self:AddButtonEvent("ConfirmBtn", function()
    if moneyCount < costnum then
      MsgManager.ShowMsgByID(25419, currencyName)
    else
      ServiceNUserProxy.Instance:CallExtractionGridBuyUserCmd()
    end
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:CloseSelf()
  end)
  self:AddListenEvt(ServiceEvent.NUserExtractionGridBuyUserCmd, self.CloseSelf)
end
