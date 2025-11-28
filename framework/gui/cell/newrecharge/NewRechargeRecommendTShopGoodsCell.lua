autoImport("NewRechargePrototypeGoodsCell")
NewRechargeRecommendTShopGoodsCell = class("NewRechargeRecommendTShopGoodsCell", NewRechargePrototypeGoodsCell)
local noLimitTime = 9999
local gReusableLuaColor = LuaColor(0, 0, 0, 0)
local BG_TEX = "Sevenroyalfamilies_bg_decoration10"
local math_floor = math.floor
local F_CurServerTime = ServerTime.CurServerTime
local _ArrayPushBack = TableUtility.ArrayPushBack

function NewRechargeRecommendTShopGoodsCell:FindObjs()
  self.widgetList = {}
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.u_spItemIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.m_uiTexBg = self:FindGO("BG3"):GetComponent(UITexture)
  _ArrayPushBack(self.widgetList, self.m_uiTexBg)
  self.u_container = self:FindComponent("container", UIWidget)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  _ArrayPushBack(self.widgetList, self.u_itemPriceBtnBg)
  self.u_itemPriceBtnBc = self.gameObject:GetComponent(BoxCollider)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_desMark = self:FindGO("DesMark", self.gameObject)
  self.u_desMarkText = self:FindComponent("Des", UILabel, self.u_desMark)
  _ArrayPushBack(self.widgetList, self.u_desMarkText)
  self.u_desMarkBg = self:FindComponent("DesBg", UISprite, self.u_desMark)
  if self.u_desMarkBg then
    _ArrayPushBack(self.widgetList, self.u_desMarkBg)
    self.u_desMarkBg1 = self:FindComponent("DesBg (1)", UISprite, self.u_desMark)
    if self.u_desMarkBg1 then
      _ArrayPushBack(self.widgetList, self.u_desMarkBg1)
    end
  end
  self.bgTop = self:FindComponent("BgTop", UISprite)
  if self.bgTop then
    _ArrayPushBack(self.widgetList, self.bgTop)
  end
  self.u_soldOutMark = self:FindGO("SoldOutMark", self.gameObject)
  self.u_discountMark = self:FindGO("DiscountMark", self.gameObject)
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  self.u_discountSymbol = self:FindComponent("Value2", UILabel, self.u_discountMark)
  self.u_discountBG = self:FindComponent("BG", UIMultiSprite, self.u_discountMark)
  self.u_discountBg = self:FindComponent("BG", UISprite, self.u_discountMark)
  _ArrayPushBack(self.widgetList, self.u_discountValue)
  _ArrayPushBack(self.widgetList, self.u_discountSymbol)
  if self.u_discountBG then
    _ArrayPushBack(self.widgetList, self.u_discountBG)
  end
  if self.u_discountBg then
    _ArrayPushBack(self.widgetList, self.u_discountBg)
  end
  self.u_freeBonusMark = self:FindGO("FreeBonusMark", self.gameObject)
  self.u_freeBonus = self:FindComponent("FreeBonus", UILabel, self.u_freeBonusMark)
  self.u_gainMoreMark = self:FindGO("GainMoreMark", self.gameObject)
  self.u_gainMore = self:FindComponent("GainMore", UILabel, self.u_gainMoreMark)
  self.u_firstDoubleMark = self:FindGO("FirstDoubleMark", self.gameObject)
  self.u_leftTimeMark = self:FindGO("LeftTimeMark", self.gameObject)
  self.u_leftTime = self:FindComponent("LeftTime", UILabel, self.u_leftTimeMark)
  self.u_leftTimeBg = self:FindComponent("BG", UISprite, self.u_leftTimeMark)
  _ArrayPushBack(self.widgetList, self.u_leftTime)
  _ArrayPushBack(self.widgetList, self.u_leftTimeBg)
  self.u_content = self:FindGO("Content", self.gameObject)
  self.u_contentPH = self:FindGO("PosHolder", self.u_content)
  self.u_contentIcon = self:FindComponent("contentIcon", UISprite, self.u_content)
  self.u_contentNum = self:FindComponent("contentNum", UILabel, self.u_content)
  self.u_buyTimes = self:FindComponent("BuyTimes", UILabel)
  _ArrayPushBack(self.widgetList, self.u_buyTimes)
  self.u_instBtn = self:FindGO("InstBtn", self.gameObject)
  self.u_buyBtn = self:FindGO("PriceBtn", self.gameObject)
  self.m_goSuperValue = self:FindGO("SuperValueMark", self.gameObject)
  self.m_uiTxtSuperValueNum = self:FindComponent("Value1", UILabel, self.m_goSuperValue)
  self.superValueNumBg = self:FindComponent("BG", UISprite, self.m_goSuperValue)
  _ArrayPushBack(self.widgetList, self.m_uiTxtSuperValueNum)
  if self.superValueNumBg then
    _ArrayPushBack(self.widgetList, self.superValueNumBg)
  end
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(BG_TEX, self.m_uiTexBg)
  self.is_InitObj = true
  self:FindIconTip()
end

function NewRechargeRecommendTShopGoodsCell:SetAlpha(a)
  for k, v in pairs(self.widgetList) do
    v.alpha = a
  end
end

function NewRechargeRecommendTShopGoodsCell:ResizePrice()
  self.u_itemPrice.overflowMethod = 2
  self.u_itemPrice:MakePixelPerfect()
  if self.u_itemPrice.width >= 180 then
    self.u_itemPrice.overflowMethod = 0
    self.u_itemPrice.width = 180
    self.u_itemPrice.height = 30
    if self.u_itemPriceIcon.gameObject.activeInHierarchy then
      LuaGameObject.SetLocalPositionGO(self.u_itemPrice.gameObject, 20, 1, 0)
    else
      LuaGameObject.SetLocalPositionGO(self.u_itemPrice.gameObject, 0, 1, 0)
    end
  else
    self.u_itemPrice.overflowMethod = 2
    LuaGameObject.SetLocalPositionGO(self.u_itemPrice.gameObject, 0, 1, 0)
  end
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
end

function NewRechargeRecommendTShopGoodsCell:RegisterClickEvent()
  self:AddClickEvent(self.u_spItemIcon.gameObject, function()
    self:OnClickForViewGoodsItem()
  end)
  self:RegistShowGeneralHelpByHelpID(1202, self.u_instBtn)
  self:AddClickEvent(self.gameObject, function()
    self:Pre_Purchase()
  end)
end

function NewRechargeRecommendTShopGoodsCell:GetGoodsType()
  return NewRechargeRecommendTShopGoodsCell.super.GetGoodsType(self)
end

function NewRechargeRecommendTShopGoodsCell:SetData(data)
  self.isForbidPurchase = nil
  NewRechargeRecommendTShopGoodsCell.super.SetData(self, data)
  self:UpdateIconTip(data and data.IconTip)
  self.depositRemoveTime = 0
  if self:IsDepositGoods() then
    FunctionNewRecharge.Instance():AddProductPurchase(self.info.productConf.ProductID, function()
      self:OnClickForButtonPurchase()
    end)
    _, self.depositRemoveTime = ShopProxy.Instance:GetDepositShowTimeInterval(self.info.productConf.id)
  end
  self:RefreshZenyCell()
  if not Slua.IsNull(self.gameObject) then
    self.gameObject:SetActive(true)
  end
  self:Set_LeftTimeMark(false)
  self:removeTickTime()
  local totalSec, d, h, m, s = self:GetRemoveLeftTime()
  if totalSec then
    if totalSec <= 0 then
      if not Slua.IsNull(self.gameObject) then
        self.gameObject:SetActive(false)
      end
    elseif self.u_leftTime ~= nil and d <= 365 then
      if d == 0 and h == 0 then
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 1000, self.updateLeftTime, self, 988)
      else
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 60000, self.updateLeftTime, self, 988)
      end
    end
  end
end

function NewRechargeRecommendTShopGoodsCell:GetRemoveLeftTime()
  local removeTime
  if self.info and self.info.shopItemData then
    removeTime = self.info.shopItemData:GetRemoveDate() or 0
  else
    removeTime = self.depositRemoveTime or 0
  end
  local totalSec
  if removeTime and 0 < removeTime then
    totalSec = math_floor(removeTime - F_CurServerTime() / 1000)
    if 0 < totalSec then
      return totalSec, ClientTimeUtil.FormatTimeBySec(totalSec)
    else
      return totalSec
    end
  end
  return nil
end

function NewRechargeRecommendTShopGoodsCell:updateLeftTime()
  local totalSec, d, h, m, s = self:GetRemoveLeftTime()
  if totalSec <= 0 then
    self:Set_LeftTimeMark(false)
    self:removeTickTime()
    self:PassEvent(NewRechargeEvent.RemoveTimeEnd, self)
    return
  end
  self:Set_LeftTimeMark(true)
  if 0 < d then
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime, d, h)
  elseif 0 < h then
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime_Hour, h, m)
  else
    self.u_leftTime.text = string.format(ZhString.NewRecharge_LeftTime_Min, m, s)
  end
end

function NewRechargeRecommendTShopGoodsCell:removeTickTime()
  if self.m_tickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 988)
    self.m_tickTime = nil
  end
end

function NewRechargeRecommendTShopGoodsCell:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end

function NewRechargeRecommendTShopGoodsCell:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChargeNtfUserEvent, self.OnReceivePurchaseSuccess, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
  self:removeTickTime()
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(BG_TEX, self.m_uiTexBg)
end

function NewRechargeRecommendTShopGoodsCell:SetData_Deposit()
  self.info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.data.ShopID)
  self.info.isDeposit = true
  self.depositGoodsInfo = self.info
end

function NewRechargeRecommendTShopGoodsCell:SetData_Shop()
  self.info = NewRechargeProxy.Ins:GenerateShopGoodsInfo(self.data.ShopID)
  self.info.isDeposit = false
  self.shopGoodsInfo = self.info
end

function NewRechargeRecommendTShopGoodsCell:SetCell()
  NewRechargeRecommendTShopGoodsCell.super.SetCell(self)
  if self.data.Icon then
  end
  if self.data.Picture then
    if not IconManager:SetZenyShopItem(self.data.Picture, self.u_spItemIcon) then
      IconManager:SetItemIcon(self.data.Picture, self.u_spItemIcon)
    end
    self.u_spItemIcon:MakePixelPerfect()
    if self.data.IconScale then
      self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(self.data.IconScale, self.data.IconScale, self.data.IconScale)
    end
  end
end

local purchasedTimes, purchaseLimitTimes

function NewRechargeRecommendTShopGoodsCell:SetCell_Deposit()
  self:SetPurchaseButtonEnable(true)
  self:Set_FirstDoubleMark(false)
  self:Set_SoldOutMark(false)
  self:Set_InstMark(false)
  self:Set_GainMoreMark(false)
  self:Set_DiscountMark(false)
  self:Set_LeftTimeMark(false)
  self:Set_ContentMark(false)
  self:Set_DescMark(false)
  local spriteName
  if self.info.isOnSale then
    spriteName = self.info.productConf.Picture
  else
    spriteName = "fudai_02"
  end
  IconManager:SetZenyShopItem(spriteName, self.u_spItemIcon)
  self.u_spItemIcon:MakePixelPerfect()
  self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.u_labProductNum.text = ""
  self.u_labProductName.text = self.info.productConf.Desc
  purchasedTimes = self.info.purchaseTimes or 0
  purchaseLimitTimes = self.info.purchaseLimit_N or 0
  if self.info.isOnSale then
    if self.info.purchaseTimes ~= nil then
      local formatString = self.info.purchaseLimitStr
      if BranchMgr.IsSEA() and self.info.ItemID == 1000062 then
        formatString = ZhString.NewRecharge_BuyLimit_Acc_Ever
      end
      if purchaseLimitTimes >= noLimitTime or purchaseLimitTimes <= 0 or not formatString then
        self:Set_BuyTimesMark(false)
      else
        self:Set_BuyTimesMark(true, string.format(formatString, purchasedTimes, purchaseLimitTimes))
      end
    end
  else
    self:Set_BuyTimesMark(false)
  end
  self.u_itemPriceIcon.gameObject:SetActive(false)
  if self.info.isOnSale then
    self.u_buyBtn:SetActive(true)
    self.u_labProductName.enabled = true
    self.u_itemPrice.text = self.info.productConf.priceStr or self.info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(self.info.productConf.Rmb)
    self.u_itemPrice:MakePixelPerfect()
    self.u_itemPriceIcon:ResetAndUpdateAnchors()
  else
    self.u_buyBtn:SetActive(false)
  end
  if self.info.purchaseTimes ~= nil and 0 < self.info.purchaseLimit_N and self.info.purchaseTimes >= self.info.purchaseLimit_N then
    self.isForbidPurchase = true
  end
  if self.info.discountActivity ~= nil then
    local dActivityEndTime = self.info.discountActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if dActivityEndTime > serverTime then
      self.info.activityTimes = self.info.discountActivity[1]
      self.info.activityUsedTimes = self.info.discountActivity[3]
      purchasedTimes = (self.info.purchaseTimes or 0) + (self.info.activityUsedTimes or 0)
      purchaseLimitTimes = (self.info.activityTimes or 0) + (self.info.purchaseLimit_N or 0)
      if purchaseLimitTimes >= noLimitTime or purchaseLimitTimes <= 0 or not self.info.purchaseLimitStr then
        self:Set_BuyTimesMark(false)
      else
        self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, purchasedTimes, purchaseLimitTimes))
      end
      if self.info.activityTimes > self.info.activityUsedTimes and self.info.ori_productConf then
        self:Set_DiscountMark(true, self.info.ori_productConf.Rmb, self.info.productConf.Rmb, true)
        self.isForbidPurchase = false
      end
    end
  end
  if self.info.gainMoreActivity ~= nil then
    local gActivityEndTime = self.info.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      self.info.activityTimes = self.info.gainMoreActivity[1]
      self.info.activityUsedTimes = self.info.gainMoreActivity[3]
      purchasedTimes = (self.info.purchaseTimes or 0) + (self.info.activityUsedTimes or 0)
      purchaseLimitTimes = (self.info.activityTimes or 0) + (self.info.purchaseLimit_N or 0)
      if purchaseLimitTimes >= noLimitTime or purchaseLimitTimes <= 0 or not self.info.purchaseLimitStr then
        self:Set_BuyTimesMark(false)
      else
        self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, purchasedTimes, purchaseLimitTimes))
      end
      if self.info.activityTimes > self.info.activityUsedTimes then
        self:Set_GainMoreMark(true, self.info.gainMoreActivity[2])
        self.isForbidPurchase = false
      end
    end
  end
  if self.info.moreTimesActivity ~= nil then
    local mActivityEndTime = self.info.moreTimesActivity[3]
    local serverTime = ServerTime.CurServerTime() / 1000
    if mActivityEndTime > serverTime then
      local mActivityTimes = self.info.moreTimesActivity[1]
      local mActivityUsedTimes = self.info.moreTimesActivity[5]
      if self.info.activityTimes == nil then
        self.info.activityTimes = mActivityTimes
        self.info.activityUsedTimes = mActivityUsedTimes
      else
        self.info.activityTimes = self.info.activityTimes + mActivityTimes
        self.info.activityUsedTimes = self.info.activityUsedTimes + mActivityUsedTimes
      end
      purchasedTimes = (self.info.purchaseTimes or 0) + (self.info.activityUsedTimes or 0)
      purchaseLimitTimes = (self.info.activityTimes or 0) + (self.info.purchaseLimit_N or 0)
      if 0 < self.info.activityTimes then
        if purchaseLimitTimes >= noLimitTime or purchaseLimitTimes <= 0 or not self.info.purchaseLimitStr then
          self:Set_BuyTimesMark(false)
        else
          self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, purchasedTimes, purchaseLimitTimes))
        end
        if self.info.activityTimes > self.info.activityUsedTimes then
          self.isForbidPurchase = false
        end
      end
    end
  end
  self:isShowSuperValue(self.data.SuperValue)
  if self.info.purchaseState == 0 then
    self.isForbidPurchase = true
    if self.info.batch_is_Origin and self.info.purchaseLimitStr then
      self:Set_BuyTimesMark(true, string.format(self.info.purchaseLimitStr, purchaseLimitTimes, purchaseLimitTimes))
      self.u_itemPrice.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    else
      self:Set_BuyTimesMark(false)
      self.u_itemPrice.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    end
    self:SetAlpha(0.5)
  elseif self.info.purchaseState == 1 then
    if self.info.batch_is_Batch and self.info.batch_DailyCount == 1 then
      self:Set_BuyTimesMark(false, ZhString.NewRechargeRecommendTShopGoodsCell_FeedAgain)
    elseif self.info.batch_is_Batch and 1 < self.info.batch_DailyCount then
      self:Set_BuyTimesMark(true, string.format(ZhString.NewRechargeRecommendTShopGoodsCell_LeftDay, self.info.batch_DailyCount - 1))
    end
    self:SetAlpha(1)
  elseif self.info:IsSoldOut() then
    self.u_itemPrice.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
    self:SetAlpha(0.5)
  end
  if self.info.productConf ~= nil and not StringUtil.IsEmpty(self.info.productConf.ExtraDes) then
    self:Set_DescMark(true, self.info.productConf.ExtraDes)
  end
  local id = self.info.productConf.id
  local post_id = NewRechargeTHotData.IsDepositItem_PreBuy(id)
  if post_id then
    local post_productConf = Table_Deposit[post_id]
    if post_productConf then
      self:Set_DiscountMark(true, post_productConf.Rmb, self.info.productConf.Rmb, false, self.info.productConf.CurrencyType .. " ")
      local pct = self.info.productConf.Rmb / post_productConf.Rmb
      if BranchMgr.IsChina() then
        self:Set_BuyTimesMark(true, string.format(ZhString.NewRechargeTHotDepositPreBuyInfo, pct * 10))
      else
        self:Set_BuyTimesMark(true, string.format(ZhString.NewRechargeTHotDepositPreBuyInfo_Oversea, math.floor((1 - pct) * 100)))
      end
    end
  end
  self:updateItemPricePosition()
  self:showRedTip()
end

function NewRechargeRecommendTShopGoodsCell:SetCell_Shop()
  self:SetPurchaseButtonEnable(true)
  self:Set_FirstDoubleMark(false)
  self:Set_SoldOutMark(false)
  self:Set_InstMark(false)
  self:Set_GainMoreMark(false)
  self:Set_DiscountMark(false)
  self:Set_LeftTimeMark(false)
  self:Set_ContentMark(false)
  local desc = self.info.shopItemData.extraDes
  self:Set_DescMark(not StringUtil.IsEmpty(desc), desc)
  self.u_labProductNum.text = self.info.shopItemData.goodsCount
  self.u_labProductName.text = self.info.itemConf.NameZh
  IconManager:SetItemIcon(self.info.itemConf.Icon, self.u_spItemIcon)
  self.u_spItemIcon:MakePixelPerfect()
  self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  purchasedTimes = self.info.purchaseTimes or 0
  purchaseLimitTimes = self.info.shopItemData.LimitNum or 0
  local hasPurchaseLimit = 0 < purchaseLimitTimes and purchaseLimitTimes < noLimitTime
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
  self.u_buyBtn:SetActive(true)
  self.u_itemPriceIcon.gameObject:SetActive(true)
  local priceIcon = Table_Item[self.info.shopItemData.ItemID].Icon
  IconManager:SetItemIcon(priceIcon, self.u_itemPriceIcon)
  local oriPrice = self.info.shopItemData.ItemCount
  if self.info.shopItemData.changeCost then
    local curCount = self.info.shopItemData.sum_count or 0
    oriPrice = self.info.shopItemData:GetChangeCost(curCount + 1)
  end
  self.u_itemPrice.text = curPrice
  self.u_itemPrice:MakePixelPerfect()
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
  if hasPurchaseLimit and self.info.purchaseTimes >= purchaseLimitTimes then
    self.isForbidPurchase = true
  end
  if self.isForbidPurchase ~= nil then
    self:SetPurchaseButtonEnable(not self.isForbidPurchase)
  end
  local limitCanBuyCount = self.info:GetLimitCanBuyCount()
  local actDiscountLeftCount = not limitCanBuyCount and self.info.shopItemData:GetActDiscountCanBuyCount()
  local hasDisCount = self.info:GetDisCount() < 100 and (not actDiscountLeftCount or actDiscountLeftCount ~= 0)
  if hasDisCount then
    self:Set_DiscountMark(true, oriPrice, self.info:GetCurPrice(), true)
  else
    self:Set_DiscountMark(false, oriPrice)
  end
  self:isShowSuperValue(self.data.SuperValue)
  self:showRedTip()
end

function NewRechargeRecommendTShopGoodsCell:Pre_Purchase()
  if self:IsShopGoods() then
    if self.info.id and not ShopProxy.Instance:IsThisItemCanBuyNow(self.info.id) then
      MsgManager.ShowMsgByID(25833)
      return
    end
    self:Purchase()
  elseif self:IsDepositGoods() then
    self:Purchase()
  end
  if self.u_fxxk_redtip and self.u_fxxk_redtip.activeSelf then
    local shopId
    if self.info.shopItemData ~= nil then
      shopId = self.info.shopItemData.id
    else
      shopId = self.info.itemConf.id
    end
    RedTipProxy.Instance:RemoveRedTip(SceneTip_pb.EREDSYS_GIFT_TIME_LIMIT, {shopId})
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_GIFT_TIME_LIMIT, self.info.id)
    self:showRedTip()
  end
end

function NewRechargeRecommendTShopGoodsCell:Invoke_DepositConfirmPanel(cb)
  local productID = self.info.productConf.ProductID
  if productID then
    local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[self.info.productConf.ItemId].NameZh)
    local productPrice = self.info.productConf.Rmb
    local productCount = self.info.productConf.Count
    local currencyType = self.info.productConf.CurrencyType
    local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[self.info.productConf.id].Desc)
    local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
    if BranchMgr.IsKorea() then
      productD = " [0075BCFF]" .. productDesc .. "[-] "
    end
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      if cb then
        cb()
      end
    end)
  end
end

function NewRechargeRecommendTShopGoodsCell:GetBattlePassRechargeInfo()
  local noviceDepositId, noviceEndTime, noviceWarningTime
  if GameConfig.NoviceBattlePass then
    noviceDepositId = GameConfig.NoviceBattlePass.DepositId
    noviceEndTime = NoviceBattlePassProxy.Instance.endTime or 9999999
    noviceWarningTime = GameConfig.NoviceBattlePass.WarningTime
  end
  local returnDepositID = NoviceBattlePassProxy.Instance.returnDepositID
  local returnEndtime = NoviceBattlePassProxy.Instance.returnEndtime
  local returnWarningTime = GameConfig.ReturnBattlePass and GameConfig.ReturnBattlePass.WarningTime
  return noviceDepositId, noviceEndTime, noviceWarningTime, returnDepositID, returnEndtime, returnWarningTime
end

function NewRechargeRecommendTShopGoodsCell:Purchase_Deposit()
  if self.forbidPurchase then
    return
  end
  local cbfunc = function(count)
    if self.info.activityTimes and self.info.activityTimes > 0 and self.info.activityTimes > self.info.activityUsedTimes then
      if self:Exec_Deposit_Purchase(count) then
        self.isActivity = true
      end
    else
      self.requestBuyCount = count
      local nDid, nEndtime, nWtime, rDid, rEndtime, rWtime = self:GetBattlePassRechargeInfo()
      local depositId, endTime, warningTime
      if self.info.productConf.id == nDid then
        depositId = nDid
        endTime = nEndtime
        warningTime = nWtime
      elseif self.info.productConf.id == rDid then
        depositId = rDid
        endTime = rEndtime
        warningTime = rWtime
      end
      if depositId then
        local remainTime = endTime - ServerTime.CurServerTime() / 1000
        if remainTime <= warningTime * 3600 then
          local param = {}
          param[1] = math.ceil(warningTime / 24)
          
          function param.confirmHandler()
            self:RequestQueryChargeCnt()
            self.requestIsForVerifyPurchase = true
          end
          
          MsgManager.ShowMsgByIDTable(1105, param)
        else
          self:RequestQueryChargeCnt()
          self.requestIsForVerifyPurchase = true
        end
      else
        self:RequestQueryChargeCnt()
        self.requestIsForVerifyPurchase = true
      end
    end
  end
  local data = {}
  data.info = self.info
  
  function data.m_funcRmbBuy(count)
    if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
      self:Invoke_DepositConfirmPanel(cbfunc)
    else
      cbfunc(count)
    end
  end
  
  self:PassEvent(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, data)
end

function NewRechargeRecommendTShopGoodsCell:Purchase_Shop()
  if not self.info.shopItemData:CheckCanRemove() then
    self.info.shopItemData.m_checkFunc = self.IsHaveEnoughVirtualCurrency
    self.info.shopItemData.m_checkTable = self
    self:PassEvent(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, {
      info = self.info.shopItemData
    })
  end
end

function NewRechargeRecommendTShopGoodsCell:IsHaveEnoughVirtualCurrency()
  local combinePackAdvise = NewRechargeProxy.Instance:TryAdviseCombinePack(self.info.shopItemData.id)
  if combinePackAdvise then
    local _func = function()
      MsgManager.ConfirmMsgByID(43449, function()
        autoImport("NewRechargeTHotSubView")
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THot, NewRechargeTHotSubView.innerTab.MixRecommend, {combinePackAdvise = combinePackAdvise})
      end)
    end
    return false, _func
  end
  local limitCanBuyCount = self.info:GetLimitCanBuyCount()
  local actDiscountLeftCount = not limitCanBuyCount and self.info.shopItemData:GetActDiscountCanBuyCount()
  local hasDisCount = self.info:GetDisCount() < 100 and (not actDiscountLeftCount or actDiscountLeftCount ~= 0)
  local needCount = hasDisCount and self.info:GetCurPrice() or self.info.shopItemData.ItemCount
  local func
  local gachaCoin = 0
  if self.info.shopItemData.ItemID == GameConfig.MoneyId.Zeny then
    function func()
      MsgManager.ShowMsgByID(40803)
    end
    
    gachaCoin = MyselfProxy.Instance:GetROB()
  elseif self.info.shopItemData.ItemID == GameConfig.MoneyId.Lottery then
    function func()
      MsgManager.ConfirmMsgByID(3551, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
      end)
    end
    
    gachaCoin = MyselfProxy.Instance:GetLottery()
  else
    local itemSData = Table_Item[self.info.shopItemData.ItemID]
    
    function func()
      MsgManager.ShowMsgByID(9620, tostring(itemSData and itemSData.NameZh))
    end
    
    gachaCoin = BagProxy.Instance:GetItemNumByStaticID(self.info.shopItemData.ItemID, GameConfig.PackageMaterialCheck.shop)
  end
  local retValue = needCount <= gachaCoin
  return retValue, not retValue and func or nil
end

function NewRechargeRecommendTShopGoodsCell:RequestBuyLuckyBag(shop_item_id)
  ServiceSessionShopProxy.Instance:CallBuyShopItem(shop_item_id, 1)
end

function NewRechargeRecommendTShopGoodsCell:OnClickForViewGoodsItem()
  local itemConfID = self.info.itemID
  if itemConfID ~= nil then
    self:PassEvent(NewRechargeEvent.GoodsCell_ShowTip, itemConfID)
  end
end

function NewRechargeRecommendTShopGoodsCell:OnReceivePurchaseSuccess(message)
  NewRechargeProxy.Instance:UseLastSort(true)
  local confID = message and message.dataid
  if self:IsDepositGoods() and confID == self.info.id and not self.isActivity then
    NewRechargeProxy.CDeposit:AddLuckyBagPurchaseTimes(confID)
  end
  self:SetData()
end

function NewRechargeRecommendTShopGoodsCell:OnReceiveQueryChargeCnt(data)
  if self:IsDepositGoods() then
    local info = self.info
    if self.requestIsForVerifyPurchase then
      info:UpdatePurchaseLimit()
      self:SetData()
      self:SetCell()
      if info.purchaseTimes < info.purchaseLimit_N or info.purchaseLimit_N <= 0 then
        if self:Exec_Deposit_Purchase() then
          self.isActivity = false
        end
      else
        MsgManager.ShowMsgByIDTable(31020, {
          info.purchaseLimit_N
        })
      end
      self.requestIsForVerifyPurchase = false
    end
  else
  end
end

function NewRechargeRecommendTShopGoodsCell:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function NewRechargeRecommendTShopGoodsCell:OnReceiveUpdateActivityCnt(data)
  self:SetData()
  self:SetCell()
end

function NewRechargeRecommendTShopGoodsCell:Exec_Deposit_Purchase()
  if not self:IsDepositGoods() then
    return
  end
  local productConf = self.info.productConf
  local productID = productConf.ProductID
  if ApplicationInfo.IsPcWebPay() then
    if productConf.PcEnable == 1 then
      MsgManager.ConfirmMsgByID(43467, function()
        ApplicationInfo.OpenPCRechargeUrl()
      end, nil, nil, nil)
    else
      MsgManager.ShowMsgByID(43466)
    end
    return
  end
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {}
    callbacks[1] = function(str_result)
      local str_result = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPaySuccess, " .. str_result)
      local currency = productConf and productConf.Rmb or 0
      ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      LogUtility.Warning("OnPaySuccess")
      NewRechargeProxy.CDeposit:SetFPRFlag2(productConf.id)
      xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      NewRechargeProxy.Instance:CallClientPayLog(113)
      self:SetData(self.data)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks, self.requestBuyCount)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function NewRechargeRecommendTShopGoodsCell:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.info.productConf and self.info.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency or self.isForbidPurchase then
      self:SetPurchaseButtonEnable(false)
    else
      self:SetPurchaseButtonEnable(true)
    end
  else
    helplog("unlimit")
    self:SetPurchaseButtonEnable(not self.isForbidPurchase)
  end
end

function NewRechargeRecommendTShopGoodsCell:SetPurchaseButtonEnable(enable)
  self.forbidPurchase = not enable
  if not self.is_InitObj then
    return
  end
  self.u_itemPrice.gameObject:SetActive(enable)
  if self.info and self.info.isOnSale then
    self.u_itemPriceIcon.gameObject:SetActive(false)
  else
    self.u_itemPriceIcon.gameObject:SetActive(enable)
  end
  self:Set_SoldOutMark(not enable)
end

function NewRechargeRecommendTShopGoodsCell:showRedTip()
end
