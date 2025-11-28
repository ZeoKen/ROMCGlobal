AuctionItemData = class("AuctionItemData")
local SpecialOrderConfig = GameConfig.Auction and GameConfig.Auction.SpecialOrder

function AuctionItemData:ctor(data)
  self:SetData(data)
end

function AuctionItemData:SetData(data)
  if data then
    self.itemid = data.itemid
    if data.price then
      self.price = data.price
    end
    if data.seller then
      self.seller = data.seller
    end
    if data.sellerid then
      self.sellerid = data.sellerid
    end
    if data.result then
      self.result = data.result
    end
    if data.trade_price then
      self.tradePrice = data.trade_price
    end
    if data.auction_time then
      self.auctionTime = data.auction_time
    end
    if data.cur_price then
      self.currentPrice = data.cur_price
    end
    if data.mask_price then
      self.maskPrice = data.mask_price
    end
    if data.signup_id then
      self.orderid = AuctionProxy.GetOrderID(data.signup_id, self.itemid)
      self.originOrder = data.signup_id
    end
    if self.originOrder == 0 then
      self.seller = SpecialOrderConfig[self.originOrder]
    end
    local itemData = data.itemdata
    if itemData and itemData.base and itemData.base.id ~= 0 then
      self.itemData = ItemData.new(itemData.base.guid, itemData.base.id)
      self.itemData:ParseFromServerData(itemData)
      if self.itemData.equipInfo then
        self.itemData.equipInfo.extra_refine_value = 0
      end
    end
  end
end

function AuctionItemData:SetMyPrice(myPrice)
  self.myPrice = myPrice
end

function AuctionItemData:SetMaskPrice(maskPrice)
  self.maskPrice = maskPrice
end

function AuctionItemData:CheckOverTakePrice()
  if self.myPrice and self.myPrice ~= 0 then
    return self.currentPrice > self.myPrice
  end
  return false
end

function AuctionItemData:CheckAtAuction()
  return self.result == AuctionItemState.AtAuction
end

function AuctionItemData:CheckAuctionEnd()
  return self.result == AuctionItemState.Fail or self.result == AuctionItemState.Sucess
end

function AuctionItemData:CheckMask(level)
  if self.maskPrice then
    return self.maskPrice & level > 0
  end
  return false
end

function AuctionItemData:GetItemData()
  if self.itemData == nil then
    self.itemData = ItemData.new("Auction", self.itemid)
  end
  return self.itemData
end

function AuctionItemData:HasQuench()
  if not self.itemid then
    return false
  end
  local items = BagProxy.Instance:GetItemsByStaticID(self.itemid)
  if items then
    for i = 1, #items do
      if items[i]:HasQuench() then
        return true
      end
    end
  end
  return false
end

function AuctionItemData:GetPriceString()
  if self.price then
    return StringUtil.NumThousandFormat(self.price)
  end
  return 0
end

function AuctionItemData:GetCurrentPriceString()
  if self.currentPrice then
    return StringUtil.NumThousandFormat(self.currentPrice)
  end
  return 0
end

function AuctionItemData:GetTradePriceString()
  if self.tradePrice then
    return StringUtil.NumThousandFormat(self.tradePrice)
  end
  return 0
end

function AuctionItemData:GetMyPrice()
  return self.myPrice
end
