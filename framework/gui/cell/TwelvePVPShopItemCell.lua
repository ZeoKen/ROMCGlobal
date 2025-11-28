autoImport("ShopItemCell")
TwelvePVPShopItemCell = class("TwelvePVPShopItemCell", ShopItemCell)
local ShopType = GameConfig.TwelvePvp.ShopConfig.shoptype
local ShopID = GameConfig.TwelvePvp.ShopConfig.shopid

function TwelvePVPShopItemCell:Init()
  TwelvePVPShopItemCell.super.Init(self)
  self.gameObject:SetActive(false)
end

function TwelvePVPShopItemCell:FindObjs()
  TwelvePVPShopItemCell.super.FindObjs(self)
  self.purchaseButton = self:FindGO("PurchaseButton")
  self.countdown = self:FindGO("Countdown")
  self.countdown:SetActive(false)
  self.countdownLabel = self:FindGO("Label", self.countdown):GetComponent(UILabel)
  self:AddClickEvent(self.purchaseButton, function()
    if not self.data then
      return
    end
    if self.lefttime and self.lefttime > 0 then
      MsgManager.ShowMsgByID(26255)
      return
    end
    self:CallBuyShopItem()
  end)
end

function TwelvePVPShopItemCell:GetShopItemData(id)
  return ShopProxy.Instance:GetShopItemDataByTypeId(ShopType, ShopID, id)
end

local owned, price

function TwelvePVPShopItemCell:CallBuyShopItem()
  price = self.shopitemdata:GetBuyFinalPrice(self.shopitemdata.ItemCount, 1)
  owned = TwelvePvPProxy.Instance:GetGold()
  if price > owned then
    MsgManager.ShowMsgByID(10154)
    return
  end
  if not self.nextTime or self.nextTime <= ServerTime.CurServerTime() / 1000 then
    ServiceSessionShopProxy.Instance:CallBuyShopItem(self.data, 1, nil, nil, nil, nil, true)
  end
end

function TwelvePVPShopItemCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  TwelvePVPShopItemCell.super.SetData(self, data)
  self.shopitemdata = self:GetShopItemData(self.data)
  if self.shopitemdata then
    local nextTime = self.shopitemdata:GetNextBuyTime() or 0
    if 0 < nextTime then
      self:StartCountDown(nextTime)
    end
  end
end

function TwelvePVPShopItemCell:StartCountDown(nextTime)
  if not self.timetick then
    self.nextTime = nextTime
    self.timetick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 11)
  end
end

local day, hour, min, sec

function TwelvePVPShopItemCell:UpdateCountDown()
  self.lefttime = self.nextTime - ServerTime.CurServerTime() / 1000
  if self.lefttime > 0 then
    day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(self.lefttime)
  else
    self.countdown:SetActive(false)
    if self.timetick then
      TimeTickManager.Me():ClearTick(self)
      self.timetick = nil
    end
    return
  end
  if not self.countdown.activeSelf then
    self.countdown:SetActive(true)
  end
  self.countdownLabel.text = string.format(ZhString.TwelvePVPShop_Countdown, min, sec)
end

function TwelvePVPShopItemCell:ClearTick()
  if self.timetick then
    TimeTickManager.Me():ClearTick(self)
    self.timetick = nil
  end
end

function TwelvePVPShopItemCell:OnCellDestroy()
  self:ClearTick()
end
