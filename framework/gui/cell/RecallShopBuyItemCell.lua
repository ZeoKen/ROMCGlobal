RecallShopBuyItemCell = class("RecallShopBuyItemCell", ShopItemInfoCell)

function RecallShopBuyItemCell:Init()
  RecallShopBuyItemCell.super.Init(self)
  self.recallShopData = nil
  self.buyCallback = nil
  self:FindExtraObjs()
  self:AddRecallShopEvents()
  self:HideUnnecessaryComponents()
end

function RecallShopBuyItemCell:FindExtraObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self.priceTitle = self:FindGO("PriceTitle"):GetComponent(UILabel)
  self.totalPriceTitle = self:FindGO("TotalPriceTitle"):GetComponent(UILabel)
  self.countTitle = self:FindComponent("CountTitle", UILabel)
  self.rentDesc = self:FindComponent("RentDesc", UILabel)
  self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
  self.limitCount = self:FindGO("LimitCount"):GetComponent(UILabel)
  self.todayCanBuy = self:FindGO("TodayCanBuy"):GetComponent(UILabel)
  self.priceRoot = self:FindGO("PriceRoot")
  self.multiplePriceRoot = self:FindGO("MultiplePriceRoot")
  self.confirmSprite = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.confirmLab = self:FindComponent("Label", UILabel, self.confirmSprite and self.confirmSprite.gameObject)
  self.countBg = self:FindGO("CountBg")
  self.helpButton = self:FindGO("HelpInfoButton")
  self.changeCostTipBtn = self:FindGO("ChangeCostTip", self.priceRoot)
  self.closeWhenClickOtherPlace = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.m_uiImgMask = self:FindGO("uiImgMask")
  self.m_uiTxtCountBgTitle = self:FindGO("CountTitle")
  self.m_uiBtnMax = self:FindGO("uiImgBtnMax")
  self.m_tipWidget = self:FindGO("tipWidget")
  if self.countInput then
    self.countInputBc = self.countInput.gameObject:GetComponent(BoxCollider)
  end
  self:adjustPanelDepth()
end

function RecallShopBuyItemCell:adjustPanelDepth()
  NGUIUtil.AdjustPanelDepthByParent(self.gameObject, 10, 6)
end

function RecallShopBuyItemCell:AddRecallShopEvents()
  if self.m_uiBtnMax then
    self:AddClickEvent(self.m_uiBtnMax, function()
      self:OnRecallMaxBtnClick()
    end)
  end
  if self.m_uiImgMask then
    self:AddClickEvent(self.m_uiImgMask, function()
      self:Cancel()
    end)
  end
end

function RecallShopBuyItemCell:HideUnnecessaryComponents()
  if self.depositBtn then
    self.depositBtn:SetActive(false)
  end
  if self.vipInfo then
    self.vipInfo:SetActive(false)
  end
  if self.salePrice then
    self.salePrice:SetActive(false)
  end
  if self.salePriceTip then
    self.salePriceTip.gameObject:SetActive(false)
  end
  if self.cardPreviewPos then
    self:Hide(self.cardPreviewPos)
  end
  if self.cardPreviewBtn then
    self.cardPreviewBtn.gameObject:SetActive(false)
  end
  if self.rentDesc then
    self.rentDesc.gameObject:SetActive(false)
  end
  if self.limitCount then
    self.limitCount.gameObject:SetActive(false)
  end
  if self.multiplePriceRoot then
    self.multiplePriceRoot:SetActive(false)
  end
  if self.changeCostTipBtn then
    self.changeCostTipBtn:SetActive(false)
  end
  if self.helpButton then
    self.helpButton:SetActive(false)
  end
  if self.m_uiTxtCountBgTitle then
    self.m_uiTxtCountBgTitle.gameObject:SetActive(false)
  end
  if self.totalPriceTitle then
    self.totalPriceTitle.gameObject:SetActive(false)
  end
  if self.cancelButton then
    self.cancelButton.gameObject:SetActive(false)
  end
  if self.ownInfo then
    self.ownInfo.gameObject:SetActive(false)
  end
  if self.m_uiBtnMax then
    self.m_uiBtnMax.gameObject:SetActive(true)
  end
  if self.countPlusBg then
    self.countPlusBg.gameObject:SetActive(true)
  end
  if self.countSubtractBg then
    self.countSubtractBg.gameObject:SetActive(true)
  end
  if self.countInput then
    self.countInput.enabled = true
  end
  if self.countInputBc then
    self.countInputBc.enabled = true
  end
  if self.totalPriceIcon then
    self.totalPriceIcon.gameObject:SetActive(true)
  end
  if self.todayCanBuy then
    self.todayCanBuy.transform.localPosition = LuaGeometry.GetTempVector3(0, -85)
  end
  if self.confirmButton then
    self.confirmButton:SetActive(true)
  end
end

function RecallShopBuyItemCell:SetData(data, buyCallback)
  if not data then
    xdlog("RecallShopBuyItemCell:SetData", "data为空")
    return
  end
  self.recallShopData = data
  self.buyCallback = buyCallback
  local serverData = data.serverData
  local goodInfo = serverData.good
  local costInfo = serverData.cost and serverData.cost[1]
  local itemData = ItemData.new("RecallShopItem", goodInfo.id)
  itemData.num = goodInfo.count or 1
  local shopData = self:CreateShopDataForBase(data, itemData)
  self.data = itemData
  self.itemData = shopData
  RecallShopBuyItemCell.super.SetData(self, itemData)
  self:SetPriceInfo(costInfo, serverData.off)
  self:SetPurchaseLimitInfo(serverData.buy_limit, serverData.bought_count)
  self:CalculateMaxCanBuy(costInfo, serverData)
  if self.countInput then
    self.countInput.value = "1"
    self:UpdateTotalPrice(1)
  end
  self:RefreshDisplay()
end

function RecallShopBuyItemCell:SetPriceInfo(costInfo, discount)
  if not costInfo then
    return
  end
  local originalPrice = costInfo.count
  local actualPrice = originalPrice
  if discount and discount < 100 then
    actualPrice = math.floor(originalPrice * discount / 100)
  end
  self.moneycount = actualPrice
  if self.price then
    self.price.text = StringUtil.NumThousandFormat(actualPrice)
  end
  if self.priceIcon and costInfo.id then
    local itemData = Table_Item[costInfo.id]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, self.priceIcon)
    end
  end
  if self.totalPriceIcon and costInfo.id then
    local itemData = Table_Item[costInfo.id]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, self.totalPriceIcon)
    end
  end
end

function RecallShopBuyItemCell:SetPurchaseLimitInfo(buyLimit, boughtCount)
  if not buyLimit or buyLimit <= 0 then
    if self.todayCanBuy then
      self.todayCanBuy.gameObject:SetActive(false)
    end
    return
  end
  local remainCount = buyLimit - (boughtCount or 0)
  if self.todayCanBuy then
    self.todayCanBuy.text = string.format(ZhString.NewRecharge_BuyLimit_Acc_Ever, remainCount, buyLimit)
    self.todayCanBuy.gameObject:SetActive(true)
  end
  if remainCount <= 0 then
    self:UpdateConfirmBtn(false)
  else
    self:UpdateConfirmBtn(true)
  end
end

function RecallShopBuyItemCell:CalculateMaxCanBuy(costInfo, serverData)
  local buyLimit = serverData.buy_limit or 0
  local boughtCount = serverData.bought_count or 0
  local stockLimit = buyLimit - boughtCount
  if stockLimit <= 0 then
    self.maxcount = 0
    return
  end
  local moneyLimit = stockLimit
  if costInfo and 0 < self.moneycount then
    local currentMoney = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costInfo.id)
    moneyLimit = math.floor(currentMoney / self.moneycount)
  end
  self.maxcount = math.min(stockLimit, moneyLimit)
end

function RecallShopBuyItemCell:OnRecallMaxBtnClick()
  if self.maxcount and self.maxcount > 0 then
    if self.countInput then
      self.countInput.value = tostring(self.maxcount)
    end
    self:UpdateTotalPrice(self.maxcount)
  end
end

function RecallShopBuyItemCell:UpdateTotalPrice(count)
  count = count or tonumber(self.countInput.value) or 1
  if self.maxcount then
    count = math.min(count, self.maxcount)
    count = math.max(1, count)
  end
  if self.countInput and self.countInput.value ~= tostring(count) then
    self.countInput.value = tostring(count)
  end
  local totalPrice = (self.moneycount or 0) * count
  if self.totalPrice then
    self.totalPrice.text = StringUtil.NumThousandFormat(totalPrice)
  end
  self.count = count
end

function RecallShopBuyItemCell:RefreshDisplay()
  self:HideUnnecessaryComponents()
  self:SetUILayout()
  if self.table then
    self.table:Reposition()
  end
  if self.main then
    self.main:UpdateAnchors()
  end
end

function RecallShopBuyItemCell:SetUILayout()
  if self.priceTitle and self.priceTitle.transform.parent then
    self.priceTitle.transform.parent.gameObject:SetActive(false)
  end
  if self.countBg then
    self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(0, -137)
  end
  if self.totalPrice and self.totalPrice.transform.parent then
    self.totalPrice.transform.parent.localPosition = LuaGeometry.GetTempVector3(0, -195)
  end
  if self.setCheckCanBuyFunc then
    self:setCheckCanBuyFunc(nil, nil)
  end
end

function RecallShopBuyItemCell:CreateShopDataForBase(recallData, itemData)
  local shopData = {}
  local serverData = recallData.serverData
  local goodInfo = serverData.good
  shopData.goodsCount = goodInfo.count or 1
  shopData.itemData = itemData
  
  function shopData:GetItemData()
    return itemData
  end
  
  shopData.staticData = itemData.staticData
  return shopData
end

function RecallShopBuyItemCell:UpdateConfirmBtn(canBuy)
  if self.confirmSprite then
    self.confirmSprite.CurrentState = canBuy and 0 or 1
  end
  if self.confirmLab or self.confirmLabel then
    local label = self.confirmLab or self.confirmLabel
    if canBuy then
      label.text = ZhString.HappyShop_Buy or "购买"
      if label.effectStyle then
        label.effectStyle = UILabel.Effect.Outline
      end
    else
      label.text = ZhString.HappyShop_SoldOut or "售罄"
      if label.effectStyle then
        label.effectStyle = UILabel.Effect.None
      end
    end
  end
end

function RecallShopBuyItemCell:UpdateCurPrice(count)
end

function RecallShopBuyItemCell:Confirm()
  if not self.recallShopData then
    return
  end
  local buyCount = tonumber(self.countInput.value) or 1
  if not self:CanBuyItem(buyCount) then
    return
  end
  xdlog("RecallShopBuyItemCell:Confirm", "购买商品", self.recallShopData.id, "数量:", buyCount)
  if self.buyCallback then
    self.buyCallback(self.recallShopData, buyCount)
  end
  self:Cancel()
end

function RecallShopBuyItemCell:CanBuyItem(buyCount)
  if not self.recallShopData or not self.recallShopData.serverData then
    return false
  end
  local serverData = self.recallShopData.serverData
  local inputCount = buyCount or 1
  local buyLimit = serverData.buy_limit or 0
  local boughtCount = serverData.bought_count or 0
  if 0 < buyLimit then
    if buyLimit <= boughtCount then
      MsgManager.ShowMsgByID(10158)
      return false
    end
    local remainCount = buyLimit - boughtCount
    if inputCount > remainCount then
      MsgManager.ShowMsgByID(10158)
      return false
    end
  end
  if serverData.cost then
    for _, costInfo in pairs(serverData.cost) do
      local totalCost = (self.moneycount or 0) * inputCount
      local currentAmount = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costInfo.id)
      if totalCost > currentAmount then
        MsgManager.ShowMsgByID(10154)
        return false
      end
    end
  end
  return true
end

function RecallShopBuyItemCell:Cancel()
  if self.gameObject then
    self.gameObject:SetActive(false)
  end
end

function RecallShopBuyItemCell:AddCloseWhenClickOtherPlaceCallBack(view)
  if not view then
    redlog("添加CloseWhenClickOtherPlace回调失败，请传入BuyItemCell所属的view")
    return
  end
  if not self.closeWhenClickOtherPlace then
    redlog("closeWhenClickOtherPlace组件未找到")
    return
  end
  
  function self.closeWhenClickOtherPlace.callBack()
    if view.selectGo then
      local size = NGUIMath.CalculateAbsoluteWidgetBounds(view.selectGo.transform)
      local uiCamera = NGUITools.FindCameraForLayer(Game.ELayer.UI)
      if uiCamera then
        local pos = uiCamera:ScreenToWorldPoint(Input.mousePosition)
        if not size:Contains(Vector3(pos.x, pos.y, pos.z)) then
          view.selectGo = nil
        elseif not self.gameObject.activeSelf then
          self.gameObject:SetActive(true)
        end
      end
    end
  end
end

function RecallShopBuyItemCell:updateLocalPostion(offsetX)
  if offsetX and self.m_uiImgMask and self.gameObject then
    self.m_uiImgMask.transform.localPosition = LuaGeometry.GetTempVector3(-offsetX, -22, 0)
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offsetX, 22, 0)
  elseif self.gameObject then
    local pos = self.gameObject.transform.localPosition
    pos.x = offsetX or pos.x
    self.gameObject.transform.localPosition = pos
  end
end

function RecallShopBuyItemCell:OnDestroy()
  self.recallShopData = nil
  self.buyCallback = nil
  RecallShopBuyItemCell.super.OnDestroy(self)
end
