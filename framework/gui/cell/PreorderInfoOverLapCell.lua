PreorderInfoOverLapCell = class("PreorderInfoOverLapCell", ItemTipBaseCell)
local temp = {}

function PreorderInfoOverLapCell:Init()
  PreorderInfoOverLapCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function PreorderInfoOverLapCell:FindObjs()
  self.count = self:FindGO("BuyCount"):GetComponent(UILabel)
  local totalPreorderPrice = self:FindGO("totalPreorderPrice")
  self.totalPrice = self:FindGO("totalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("MoneyIcon", totalPreorderPrice):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.totalPriceIcon)
  local preorderPrice = self:FindGO("preorderPrice")
  self.price = self:FindGO("price"):GetComponent(UILabel)
  self.preorderPriceIcon = self:FindGO("MoneyIcon", preorderPrice):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.preorderPriceIcon)
  local leftMoney = self:FindGO("leftMoney")
  self.left = self:FindGO("left"):GetComponent(UILabel)
  self.leftMoneyIcon = self:FindGO("PriceIcon", leftMoney):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.leftMoneyIcon)
  self.closeBtn = self:FindGO("CloseButton")
  self.cancelBtn = self:FindGO("CancelButton")
  self.reOrderBtn = self:FindGO("ReOrderButton")
  self.btnGrid = self:FindGO("btnGrid"):GetComponent(UIGrid)
end

function PreorderInfoOverLapCell:AddEvts()
  self:SetEvent(self.closeBtn, function(g)
    self:PassEvent(PreoderEvent.ClosePreorderInfo, self)
  end)
  self:SetEvent(self.cancelBtn, function(g)
    self:Cancel()
  end)
  self:SetEvent(self.reOrderBtn, function(g)
    self:ReOrder()
  end)
end

function PreorderInfoOverLapCell:SetData(data)
  self.data = data
  self.preorderItemData = data.preorderItemData
  if data then
    self:UpdateAttriContext()
    self:UpdateTopInfo()
    self.count.text = self.preorderItemData.count
    self.totalPrice.text = StringUtil.NumThousandFormat(self.preorderItemData.price)
    self.price.text = StringUtil.NumThousandFormat(self.preorderItemData.price / self.preorderItemData.count)
    self.left.text = StringUtil.NumThousandFormat(self.preorderItemData.price - self.preorderItemData.buyprice)
    if self.preorderItemData.status == PreorderStatus.Finished and self.data.buycount == self.data.count then
      self.reOrderBtn:SetActive(true)
    else
      self.reOrderBtn:SetActive(false)
    end
    self.btnGrid:Reposition()
  end
end

function PreorderInfoOverLapCell:Cancel()
  if self.preorderItemData then
    ServiceRecordTradeProxy.Instance:CallPreorderCancelRecordTradeCmd(self.preorderItemData.id)
  end
  ServiceRecordTradeProxy.Instance:CallPreorderListRecordTradeCmd()
  self:PassEvent(PreoderEvent.ClosePreorderInfo, self)
end

function PreorderInfoOverLapCell:ReOrder()
  if self.preorderItemData then
    ServiceRecordTradeProxy.Instance:CallPreorderCancelRecordTradeCmd(self.preorderItemData.id)
  end
  ServiceRecordTradeProxy.Instance:CallPreorderListRecordTradeCmd()
  if self.preorderItemData.itemid then
    local cellCtl = {}
    cellCtl.data = self.preorderItemData.itemid
    self.itemData = Table_Exchange[self.preorderItemData.itemid]
    GameFacade.Instance:sendNotification(ShopMallEvent.ExchangeSearchOpenDetail, cellCtl)
  end
  self:PassEvent(PreoderEvent.ClosePreorderInfo, self)
end

function PreorderInfoOverLapCell:Exit()
  PreorderInfoOverLapCell.super.Exit(self)
end
