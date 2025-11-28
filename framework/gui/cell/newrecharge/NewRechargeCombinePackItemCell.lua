autoImport("NewRechargeNormalTShopGoodsCell")
NewRechargeCombinePackItemCell = class("NewRechargeCombinePackItemCell", NewRechargeNormalTShopGoodsCell)

function NewRechargeCombinePackItemCell:FindObjs()
  NewRechargeCombinePackItemCell.super.FindObjs(self)
  self.selectToggle = self:FindGO("Toggle"):GetComponent(UIToggle)
  self.bgLineObj = self:FindGO("BGLine")
  self.u_buyTimes = self:FindComponent("BuyTimes", UILabel)
  self.itemNameScroll = self:FindComponent("ItemNameAS", UIScrollView)
  if self.itemNameScroll then
    autoImport("UIAutoScrollCtrl")
    self.itemNameLabelCtrl = UIAutoScrollCtrl.new(self.itemNameScroll, self.u_labProductName, 4, 40)
    local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
    self.itemNameScroll.panel.depth = upPanel.depth + 1
  end
  self.dot1 = self:FindGO("uiImgTitleBg")
  self.dot2 = self:FindGO("uiImgTitleBg (1)")
  local monoComp = self.gameObject:GetComponent(RelateGameObjectActive)
  if monoComp then
    function monoComp.enable_Call()
      self:OnEnable()
    end
    
    function monoComp.disable_Call()
      self:OnDisable()
    end
  end
end

function NewRechargeCombinePackItemCell:OnEnable()
  NewRechargeCombinePackItemCell.super.OnEnable(self)
  self:UpdateSetName()
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:ResetInitialScroll()
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.itemNameLabelCtrl:Start(false, true)
    end, self)
  end
end

function NewRechargeCombinePackItemCell:OnDisable()
  NewRechargeCombinePackItemCell.super.OnDisable(self)
  TimeTickManager.Me():ClearTick(self)
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:Stop(true)
  end
end

function NewRechargeCombinePackItemCell:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(NewRechargeEvent.CombinePackItemCell_ShowTip, self)
  end)
  self:AddClickEvent(self.selectToggle.gameObject, function(obj)
    self.data.select = self.selectToggle.value
    self:PassEvent(NewRechargeEvent.CombinePackItemCell_Toggle, self)
  end)
end

function NewRechargeCombinePackItemCell:SetData(data)
  NewRechargeCombinePackItemCell.super.SetData(self, data)
  self:SetData_BuyTimes()
  if self.data.alreadyBought then
    self.selectToggle.value = false
    self.data.select = false
    self.selectToggle.enabled = false
    self:Set_SoldOutMark(true)
  else
    self.selectToggle.enabled = true
    self.selectToggle.value = self:IsSelected()
  end
  self:ShowBgLine(true)
end

function NewRechargeCombinePackItemCell:SetCell_Shop()
  NewRechargeCombinePackItemCell.super.SetCell_Shop(self)
  self:UpdateSetName()
end

function NewRechargeCombinePackItemCell:UpdateSetName()
  local len = self.u_labProductName.width
  local offset = math.min(len / 2 + 12, 80)
  self.dot1.transform.localPosition = LuaGeometry.GetTempVector3(-offset, 0, 0)
  self.dot2.transform.localPosition = LuaGeometry.GetTempVector3(offset, 0, 0)
end

function NewRechargeCombinePackItemCell:Set_SoldOutMark(active)
  NewRechargeCombinePackItemCell.super.Set_SoldOutMark(self, active)
  if active then
    self.selectToggle.value = false
    self.data.select = false
    self.u_container.alpha = 0.5
    self.u_itemPricePH:SetActive(false)
    self.selectToggle.gameObject:SetActive(false)
  else
    self.u_container.alpha = 1
    self.u_itemPricePH:SetActive(true)
    self.selectToggle.gameObject:SetActive(true)
  end
  if not self.u_soldOutMark then
    return
  end
  self.u_soldOutMark:SetActive(active)
  if self.SetAlpha then
    self:SetAlpha(active and 0.5 or 1)
  end
end

function NewRechargeCombinePackItemCell:IsSelected()
  return self.data.select == true
end

function NewRechargeCombinePackItemCell:ShowBgLine(istrue)
  if self.bgLineObj then
    self.bgLineObj:SetActive(istrue)
  end
end

function NewRechargeCombinePackItemCell:SetData_BuyTimes()
  local purchasedTimes, purchaseLimitTimes
  local noLimitTime = 9999
  purchasedTimes = self.info.purchaseTimes or 0
  purchaseLimitTimes = self.info.shopItemData.LimitNum or 0
  local hasPurchaseLimit = 0 < purchaseLimitTimes and noLimitTime > purchaseLimitTimes
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.info.shopItemData)
  if canBuyCount then
    if limitType == HappyShopProxy.LimitType.AccWeek then
      if self.info.shopItemData.accMaxBuyLimitNum ~= 0 and self.info.shopItemData.accAreadyBuyCount <= self.info.shopItemData.accMaxBuyLimitNum then
        canBuyCount = self.info.shopItemData.accAreadyBuyCount
        self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, canBuyCount, self.info.shopItemData.accMaxBuyLimitNum))
      end
    else
      local max = 0
      if self.info.shopItemData.maxlimitnum ~= nil and 0 < self.info.shopItemData.maxlimitnum then
        max = self.info.shopItemData.maxlimitnum
      else
        max = self.info.shopItemData.LimitNum
      end
      if 0 <= canBuyCount then
        self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, max - canBuyCount, max))
      end
    end
  else
    self:Set_BuyTimesMark(false, "")
  end
end

function NewRechargeCombinePackItemCell:updateItemPricePosition()
end
