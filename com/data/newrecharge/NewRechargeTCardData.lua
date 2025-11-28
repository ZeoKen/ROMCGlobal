NewRechargeTCardData = class("NewRechargeTCardData")

function NewRechargeTCardData:GetMonthlyVIPConf()
  local discountDepositId = GameConfig.PurchaseMonthlyVIP and GameConfig.PurchaseMonthlyVIP.DiscountDepositId
  for _, v in pairs(Table_Deposit) do
    if v.Type == 2 and v.Rmb and v.id ~= discountDepositId then
      self.monthlyVIPShopItemConf = v
      break
    end
  end
  self.monthlyVIPShopItemOriginConf = nil
  if discountDepositId then
    local chargeCnt = NewRechargeProxy.Instance.CDeposit:GetChargeCnt(discountDepositId)
    if not chargeCnt or chargeCnt.canCharge ~= false and chargeCnt.count and chargeCnt.count <= 0 then
      local discountConf = Table_Deposit[discountDepositId]
      if discountConf then
        self.monthlyVIPShopItemOriginConf = self.monthlyVIPShopItemConf
        self.monthlyVIPShopItemConf = Table_Deposit[discountDepositId]
      end
    end
  end
  return self.monthlyVIPShopItemConf, self.monthlyVIPShopItemOriginConf
end

function NewRechargeTCardData:SetEPCards(ep_cards)
  self.server_epCards = ep_cards
  if self.epCards then
    TableUtility.ArrayClear(self.epCards)
  else
    self.epCards = {}
  end
  local versionCards = ep_cards
  for i = 1, #versionCards do
    local card = versionCards[i]
    local productConfID = card.id2
    if productConfID == nil or productConfID == 0 then
      productConfID = card.id1
    end
    if Table_Deposit[productConfID] then
      card.productConfID = productConfID
      table.insert(self.epCards, card)
    end
  end
end

function NewRechargeTCardData:GetEPCards()
  return self.epCards
end

function NewRechargeTCardData:GetServerEPCards()
  return self.server_epCards
end
