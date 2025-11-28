autoImport("ShopItemCell")
autoImport("ItemCell_Gift")
ShopItemWithGiftCell = class("ShopItemWithGiftCell", ShopItemCell)

function ShopItemWithGiftCell:Init()
  self:FindObjs()
  self:AddEvts()
  self.NormalColor = "[ffffff]"
  self.WarnColor = "[FF3B0D]"
end

function ShopItemWithGiftCell:FindObjs()
  ShopItemWithGiftCell.super.FindObjs(self)
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.mainItemCell = ItemCell.new(obj)
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  self.giftCellContainer = self:FindGO("GiftCellContainer")
end

function ShopItemWithGiftCell:AddEvts()
  ShopItemWithGiftCell.super.AddEvts(self)
  self:SetEvent(self.giftCellContainer, function()
    self:PassEvent(HappyShopEvent.GiftItemClick, self)
  end)
end

function ShopItemWithGiftCell:SetData(data)
  local id = data
  local _HappyShopProxy = HappyShopProxy.Instance
  data = self:GetShopItemData(id)
  self.gameObject:SetActive(data ~= nil)
  if data then
    self.data = data
    data:RefreshMenuUnlock()
    local itemData = data:GetItemData()
    local goodsCount = data.goodsCount
    if goodsCount and 1 < goodsCount then
      itemData.num = goodsCount
    end
    if self.mainItemCell then
      self.mainItemCell:SetData(itemData)
    end
    self.choose:SetActive(false)
    self:AddOrRemoveGuideId(self.gameObject)
    local itemId = data.goodsID
    if itemId ~= nil then
      self:Show(self.itemName.gameObject)
      if itemId == 12001 then
        self:AddOrRemoveGuideId(self.gameObject, 11)
      end
      if itemId == 14076 then
        self:AddOrRemoveGuideId(self.gameObject, 19)
      end
      if itemId == 5662 then
        self:AddOrRemoveGuideId(self.gameObject, 525)
      end
      if itemId == 5663 then
        self:AddOrRemoveGuideId(self.gameObject, 526)
      end
      if itemData then
        self.itemName.text = itemData:GetName()
      else
        local goodsData = Table_Item[itemId]
        self.itemName.text = goodsData and goodsData.NameZh
      end
      self:UpdateAdventureState(itemId)
    else
      errorLog("ShopItemCell data.goodsID = nil")
    end
    if data.Discount ~= nil and data.ItemCount ~= nil and data.ItemID ~= nil then
      local totalPrice, discount = data:GetBuyDiscountPrice(data.ItemCount, 1)
      if discount < 100 then
        self:Show(self.sellDiscount.gameObject)
        self.sellDiscount.text = string.format(ZhString.HappyShop_discount, 100 - discount)
        self:Show(self.primeCost.gameObject)
        self.primeCost.text = ZhString.HappyShop_originalCost .. StringUtil.NumThousandFormat(data.ItemCount)
      else
        self:Hide(self.sellDiscount.gameObject)
        self:Hide(self.primeCost.gameObject)
      end
      for i = 1, #self.costMoneySprite do
        local temp = i
        if temp == 1 then
          temp = ""
        end
        local moneyId = data["ItemID" .. temp]
        local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
        local isGuildMat = data.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek and moneyId == GameConfig.MoneyId.Quota
        if icon and not isGuildMat then
          self.costMoneySprite[i].gameObject:SetActive(true)
          IconManager:SetItemIcon(icon, self.costMoneySprite[i])
          self.costMoneyNums[i].text = StringUtil.NumThousandFormat((data:GetBuyDiscountPrice(data["ItemCount" .. temp], 1)))
        else
          self.costMoneySprite[i].gameObject:SetActive(false)
        end
      end
      self.costGrid:Reposition()
    else
      errorLog(string.format("ShopItemCell data.Discount = %s , data.ItemCount = %s , data.ItemID = %s", tostring(data.Discount), tostring(data.ItemCount), tostring(data.ItemID)))
    end
    if data:GetLock() then
      self:SetIconGrey(true)
      self.lock:SetActive(true)
      local menuDes = data.GetComplexLockDesc and data:GetComplexLockDesc() or data:GetMenuDes()
      if menuDes and 0 < #menuDes then
        self.buyCondition.text = menuDes
      end
    else
      self:SetIconGrey(false)
      self.lock:SetActive(false)
      self:RefreshBuyCondition(data)
    end
    self:SetActive(self.invalid, self:IsInvalid(data, itemData))
    local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(data)
    self.soldout:SetActive(canBuyCount == 0)
    self.itemtype = data.itemtype
    if data.itemtype == 2 then
      self.costGrid.gameObject:SetActive(false)
      self.exchangeButton:SetActive(true)
    else
      self.costGrid.gameObject:SetActive(true)
      self.exchangeButton:SetActive(false)
    end
    if data.presentType == ShopItemData.PresentType.Lock then
      self.fashionUnlock:SetActive(data:CheckPresentMenu())
    else
      self.fashionUnlock:SetActive(false)
    end
    self:TrySetGemData(itemData)
    if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_SHOP_COUPON, id) then
      RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_SHOP_COUPON, self.widget, 100, {0, 0}, NGUIUtil.AnchorSide.TopLeft, id)
    else
      RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_SHOP_COUPON, self.widget)
    end
    self:SetGiftItemData(data)
  end
  self.data = id
end

function ShopItemWithGiftCell:SetGiftItemData(data)
  local giftItem = data.giftItem
  if giftItem then
    if not self.giftItemCell then
      local obj = self:LoadPreferb("cell/ItemCell_Gift", self.giftCellContainer)
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      self.giftItemCell = ItemCell_Gift.new(obj)
    end
    self.giftItemCell:SetData(giftItem)
  elseif self.giftItemCell then
    GameObject.Destroy(self.giftItemCell.gameObject)
    self.giftItemCell = nil
  end
end
