autoImport("NewHappyShopBuyItemCell")
NewPeddlerShopBuyTips = class("NewPeddlerShopBuyTips", NewHappyShopBuyItemCell)

function NewPeddlerShopBuyTips:FindObjs()
  NewPeddlerShopBuyTips.super.FindObjs(self)
  self.m_tipWidget = self:FindGO("tipWidget")
end

function NewPeddlerShopBuyTips:AddEvts()
  NewPeddlerShopBuyTips.super.AddEvts(self)
end

function NewPeddlerShopBuyTips:SetData(data)
  NewPeddlerShopBuyTips.super.SetData(self, data)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(data)
  local buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(data.id)
  buyCount = buyCount == nil and 0 or buyCount
  local unlock = PeddlerShopProxy.Instance:CheckUnlockByPre(data.id)
  if unlock then
    if canBuyCount and canBuyCount == 0 then
      self:UpdateConfirmBtn(false)
      self.todayCanBuy.text = ZhString.PeddlerShop_SaleOut
    else
      self:UpdateConfirmBtn(true)
      self.todayCanBuy.text = buyCount .. "/" .. data.LimitNum
    end
  else
    self:UpdateConfirmBtn(false)
    self.todayCanBuy.text = ZhString.PeddlerShop_Unlock
    self.confirmLabel.text = ZhString.HappyShop_Buy
  end
end

function NewPeddlerShopBuyTips:UpdateAttriContext()
  TableUtility.TableClear(self.contextDatas)
  local shopdata = self.shopdata
  local ownNum = 0
  if shopdata then
    if shopdata.source == HappyShopProxy.SourceType.UserGuild then
      ownNum = GuildProxy.Instance:GetGuildPackItemNumByItemid(shopdata.goodsID)
    else
      ownNum = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
    end
  end
  self.contextDatas[ItemTipAttriType.ObsidianSoulCrystalTip] = {
    label = string.format("%s：%s", ZhString.HomeBP_HaveNum, "  " .. StringUtil.NumThousandFormat(ownNum))
  }
  local moneyData = Table_Item[shopdata.ItemID]
  if moneyData ~= nil and moneyData.Icon ~= nil then
    local icon = "priceicon=" .. shopdata.ItemID
    local priceDesc = self:getRealPrice()
    local codeData = {
      label = string.format("%s：{" .. icon .. ",%s}", ZhString.HappyShop_PriceTitle, priceDesc)
    }
    self.contextDatas[ItemTipAttriType.Code] = codeData
  end
  local sData = self.data and self.data.staticData
  if sData.Desc and sData.Desc ~= "" then
    local desc = {}
    local descStr = sData.Desc
    if self.data.IsLoveLetter and self.data:IsLoveLetter() then
      local time = os.date("*t", self.data.createtime)
      descStr = string.format(descStr, self.data.loveLetter.name, time.year, time.month, time.day)
    elseif self.data:IsMarryInviteLetter() then
      local weddingData = self.data.weddingData
      local timeStr = os.date(ZhString.ItemTip_WeddingCememony_TimeFormat, weddingData.starttime)
      descStr = string.format(descStr, weddingData.myname, weddingData.partnername, timeStr)
    elseif StringUtil.HasItemIdToClick(descStr) then
      descStr = StringUtil.AdaptItemIdClickUrl(descStr)
      
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickItemUrl, string.sub(url, 8))
      end
    elseif self.data.cup_name ~= nil then
      descStr = string.format(descStr, self.data.cup_name)
    end
    descStr = ZhString.ItemTip_Desc .. descStr
    desc.label = descStr
    desc.hideline = true
    self.contextDatas[ItemTipAttriType.Desc] = desc
  end
  self:ResetAttriDatas()
end

function NewPeddlerShopBuyTips:getRealPrice()
  local price = self.shopdata.ItemCount
  if self.shopdata.Discount ~= 0 and self.shopdata.Discount < 100 then
    price = price * (self.shopdata.Discount / 100)
  end
  local a, b = math.modf(price)
  if 0 < b then
    b = math.floor(b * 100) / 100
  end
  return a + b
end

function NewPeddlerShopBuyTips:RealConfirm()
  local ret = false
  if self.shopdata.m_isMysticalShop then
    local item = PeddlerShopProxy.Instance:GetShopDataByTypeId(self.shopdata.id)
    if item == nil then
      ret = false
    else
      ret = HappyShopProxy.Instance:BuyItemByShopItemData(item, self.count, nil, true)
    end
  else
    ret = HappyShopProxy.Instance:BuyItem(self.shopdata.id, self.count, true)
    if ret then
      NewRechargeProxy.Instance:readyTriggerEventId(117)
      NewRechargeProxy.Instance:setIsRecordEvent(true)
    else
      NewRechargeProxy.Instance:readyTriggerEventId(0)
      NewRechargeProxy.Instance:setIsRecordEvent(false)
    end
  end
  self:Cancel()
end

function NewPeddlerShopBuyTips:Cancel()
  self:closeUrlTips()
  NewPeddlerShopBuyTips.super.Cancel(self)
end

function NewPeddlerShopBuyTips:onShowClickItemUrlTip(value)
  self:closeUrlTips()
  self.m_urlTips = ItemFloatTip.new("ItemFloatTip", self.m_tipWidget)
  self.m_urlTips:SetData(value)
  self.m_urlTips:OnEnter()
end

function NewPeddlerShopBuyTips:closeUrlTips()
  if self.m_urlTips ~= nil and self.m_urlTips:OnExit() then
    self.m_urlTips:DestroySelf()
  end
  self.m_urlTips = nil
end
