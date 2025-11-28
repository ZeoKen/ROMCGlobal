autoImport("HappyShopBuyItemCell")
NewHappyShopBuyItemCell = class("NewHappyShopBuyItemCell", HappyShopBuyItemCell)

function NewHappyShopBuyItemCell:FindObjs()
  NewHappyShopBuyItemCell.super.FindObjs(self)
  self.m_uiImgMask = self:FindGO("uiImgMask")
  self.m_uiTxtCountBgTitle = self:FindGO("CountTitle")
  self.m_uiBtnMax = self:FindGO("uiImgBtnMax")
  self.m_tipWidget = self:FindGO("tipWidget")
  self.m_uiTxtCountBgTitle.gameObject:SetActive(false)
  self.totalPriceTitle.gameObject:SetActive(false)
  self.cancelButton.gameObject:SetActive(false)
  self.todayCanBuy.gameObject:SetActive(false)
  self.ownInfo.gameObject:SetActive(false)
  self.todayCanBuy.transform.localPosition = LuaGeometry.GetTempVector3(0, -85)
  self.countInputBc = self.countInput.gameObject:GetComponent(BoxCollider)
  self:adjustPanelDepth()
end

function NewHappyShopBuyItemCell:AdjustTipPanelDepth()
end

function NewHappyShopBuyItemCell:adjustPanelDepth()
  NGUIUtil.AdjustPanelDepthByParent(self.gameObject, 10, 6)
end

function NewHappyShopBuyItemCell:AddEvts()
  NewHappyShopBuyItemCell.super.AddEvts(self)
  if self.m_uiImgMask then
    self:AddClickEvent(self.m_uiImgMask, function()
      self:Cancel()
    end)
  end
  if self.m_uiBtnMax then
    self:AddClickEvent(self.m_uiBtnMax, function()
      if self.shopdata.isDeposit then
        local buyCount = self.shopdata.purchaseTimes or 0
        local limitCount = self.shopdata.purchaseLimit_N or 0
        self:UpdateTotalPrice(limitCount - buyCount)
      else
        local total = 0
        if self.shopdata.ItemID == 151 then
          total = MyselfProxy.Instance:GetLottery()
        elseif self.shopdata.ItemID == GameConfig.MoneyId.Zeny then
          total = MyselfProxy.Instance:GetROB()
        else
          total = BagProxy.Instance:GetItemNumByStaticID(self.shopdata.ItemID, GameConfig.PackageMaterialCheck.shop)
        end
        if self.shopdata.changeCost then
          if not total then
            goto lbl_114
          end
          local finalPrice = 0
          local canBuyCount = 0
          local curCount = self.shopdata.sum_count or 0
          local limitCount = self.maxCount or 100
          for i = 1, limitCount do
            if total < finalPrice + self.shopdata:GetChangeCost(curCount + i) then
              break
            end
            finalPrice = finalPrice + self.shopdata:GetChangeCost(curCount + i)
            canBuyCount = i
          end
          self:UpdateTotalPrice(canBuyCount)
          self:UpdateAttriContext()
        else
          local price = self:getRealPrice()
          if total then
            local canBuyCount = math.floor(total / price)
            if canBuyCount >= self.maxcount then
              canBuyCount = self.maxcount
            end
            self:UpdateTotalPrice(canBuyCount)
          end
        end
      end
      ::lbl_114::
    end)
  end
  if self.getPathBtn then
    self:AddClickEvent(self.getPathBtn, function(go)
      self:ShowItemGetWay()
    end)
  end
end

function NewHappyShopBuyItemCell:SetData(data, m_funcRmbBuy)
  if m_funcRmbBuy ~= nil then
    self.m_depositBuyFunc = m_funcRmbBuy
    self.itemData = nil
    self:shopDeposit(data)
    self:UpdateHelpInfoButton()
    self:CloseFashionPreview()
    self:UpdateCardPreviewBtn()
  else
    self.m_depositBuyFunc = nil
    self.itemData = nil
    NewHappyShopBuyItemCell.super.SetData(self, data)
    self:shopNormal(data)
  end
end

function NewHappyShopBuyItemCell:shopNormal(data)
  self:setCheckCanBuyFunc(data.m_checkFunc, data.m_checkTable)
  self.priceTitle.transform.parent.gameObject:SetActive(false)
  self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(0, -137)
  self.totalPrice.transform.parent.localPosition = LuaGeometry.GetTempVector3(0, -195)
  self.m_uiBtnMax.gameObject:SetActive(true)
  self.countPlusBg.gameObject:SetActive(true)
  self.countSubtractBg.gameObject:SetActive(true)
  self.countInput.enabled = true
  self.countInputBc.enabled = true
  self.totalPriceIcon.gameObject:SetActive(true)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(data)
  local purchase_limit_str = NewRechargeShopGoodsData.GetLimitStr()[limitType] or ZhString.NoviceShop_BuyLimit
  if limitType == HappyShopProxy.LimitType.AccWeek then
    if data.accMaxBuyLimitNum ~= 0 and data.accAreadyBuyCount <= data.accMaxBuyLimitNum then
      canBuyCount = data.accAreadyBuyCount
      self.todayCanBuy.text = string.format(purchase_limit_str, canBuyCount, data.accMaxBuyLimitNum)
    end
    if data.accAreadyBuyCount == 0 and data.accMaxBuyLimitNum == 0 then
      self.todayCanBuy.gameObject:SetActive(false)
      self:UpdateConfirmBtn(true)
    else
      self.todayCanBuy.gameObject:SetActive(canBuyCount <= data.accMaxBuyLimitNum)
      self:UpdateConfirmBtn(canBuyCount < data.accMaxBuyLimitNum)
    end
  else
    local max = 0
    if data.maxlimitnum ~= nil and 0 < data.maxlimitnum then
      max = data.maxlimitnum
    else
      max = data.LimitNum
    end
    if canBuyCount == nil then
      canBuyCount = max
    end
    self.todayCanBuy.text = string.format(purchase_limit_str, max - canBuyCount, max)
    self.todayCanBuy.gameObject:SetActive(0 <= canBuyCount and 0 < max)
    if 0 < max then
      self:UpdateConfirmBtn(canBuyCount ~= 0)
    else
      self:UpdateConfirmBtn(true)
    end
  end
  self:UpdateAttriContext()
end

function NewHappyShopBuyItemCell:shopDeposit(data)
  self.priceTitle.transform.parent.gameObject:SetActive(false)
  self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(0, -137)
  self.totalPrice.transform.parent.localPosition = LuaGeometry.GetTempVector3(0, -195)
  self.hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP()
  self.showFullAttr = data and data.showFullAttr or false
  self.equipBuffUpSource = data and data.equipBuffUpSource or nil
  self.shopdata = data
  self.data = data:GetItemData()
  if self.itemData == nil then
    self.itemData = {}
    self.itemData.itemData = self.data
  end
  local buyCount = data.purchaseTimes or 0
  local limitCount = data.purchaseLimit_N or 0
  local formatString = data.purchaseLimitStr
  if formatString then
    self.todayCanBuy.text = string.format(formatString, buyCount, limitCount)
    self.todayCanBuy.gameObject:SetActive(true)
    self.limitCount.text = ""
    self.salePrice:SetActive(false)
    if data.isEnable ~= nil and not data.isEnable then
      self.todayCanBuy.text = string.format(formatString, limitCount, limitCount)
    end
  else
    self.todayCanBuy.gameObject:SetActive(false)
    self.salePrice:SetActive(false)
    self.limitCount.text = ""
  end
  self:UpdateConfirmBtn(data.isEnable == nil and true or data.isEnable)
  self:UpdateTopInfo()
  self:UpdateShowFpButton()
  self:SetCountPlus(1 < limitCount - buyCount and 1 or 0.5)
  self:SetCountSubtract(0.5)
  self.countChangeRate = 1
  self.countInput.value = 1
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer and (BranchMgr.IsNO() or BranchMgr.IsNOTW()) then
    self.m_uiBtnMax.gameObject:SetActive(true)
    self.countPlusBg.gameObject:SetActive(true)
    self.countSubtractBg.gameObject:SetActive(true)
    self.countInput.enabled = true
    self.countInputBc.enabled = true
    self.maxcount = limitCount - buyCount
    if self.maxcount > 10 then
      self.maxcount = 10
    end
  else
    self.m_uiBtnMax.gameObject:SetActive(false)
    self.countPlusBg.gameObject:SetActive(false)
    self.countSubtractBg.gameObject:SetActive(false)
    self.countInput.enabled = false
    self.countInputBc.enabled = false
  end
  self.totalPriceIcon.gameObject:SetActive(false)
  self.totalPrice.text = self.shopdata.productConf.priceStr or string.format("%s%s", self.shopdata.productConf.CurrencyType, StringUtil.NumThousandFormat(self:getRealPrice(), nil, true))
  self:UpdateAttriContext()
  if self.changeCostTipBtn then
    self.changeCostTipBtn:SetActive(data.changeCost ~= nil)
  end
end

function NewHappyShopBuyItemCell:ShowFashionPreview()
  if self.m_gwt then
    self.m_gwt:Hide()
  end
  NewHappyShopBuyItemCell.super.ShowFashionPreview(self)
end

function NewHappyShopBuyItemCell:ShowItemGetWay()
  if self.sfp then
    self:CloseFashionPreview()
  end
  if not self.m_gwt then
    self.m_gwt = GainWayTip.new(self.gpContainer)
    self.m_gwt:AddEventListener(GainWayTip.CloseGainWay, function()
      self.m_gwt = nil
      self.closecomp:ReCalculateBound()
      self:updateLocalPostion(0)
    end, self)
  end
  LuaGameObject.SetLocalPositionGO(self.gpContainer, 0, 0, 0)
  self.m_gwt:SetData(self.data.staticData.id)
  self.m_gwt:Show()
  self.m_gwt.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(203, 200, 0)
  self.m_gwt:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(self.m_gwt.gameObject)
  self:updateLocalPostion(-156)
end

function NewHappyShopBuyItemCell:Cancel()
  NewHappyShopBuyItemCell.super.Cancel(self)
  if self.countInput then
    self.countInput.value = 1
  end
  self:closeUrlTips()
  if self.m_gwt ~= nil then
    self.m_gwt:OnExit()
    self.m_gwt = nil
  end
  self:updateLocalPostion(0)
end

function NewHappyShopBuyItemCell:updateLocalPostion(x)
  self.m_uiImgMask.transform.localPosition = LuaGeometry.GetTempVector3(-x, -22, 0)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, 22, 0)
end

function NewHappyShopBuyItemCell:UpdateAttriContext()
  TableUtility.TableClear(self.contextDatas)
  local shopdata = self.shopdata
  local ownNum = 0
  if shopdata then
    if shopdata.isDeposit then
      self.contextDatas[ItemTipAttriType.Code] = {
        label = shopdata.productConf.priceStr or string.format("%s：%s%s", ZhString.HappyShop_PriceTitle, shopdata.productConf.CurrencyType, StringUtil.NumThousandFormat(self:getRealPrice(), nil, true))
      }
    else
      if shopdata.source == HappyShopProxy.SourceType.UserGuild then
        ownNum = GuildProxy.Instance:GetGuildPackItemNumByItemid(shopdata.goodsID)
      else
        ownNum = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
      end
      self.contextDatas[ItemTipAttriType.ObsidianSoulCrystalTip] = {
        label = string.format("%s：%s", ZhString.HomeBP_HaveNum, "  " .. StringUtil.NumThousandFormat(ownNum))
      }
      local moneyData = Table_Item[shopdata.ItemID]
      if moneyData ~= nil and moneyData.Icon ~= nil then
        local priceIcon = shopdata.ItemID or 151
        self.contextDatas[ItemTipAttriType.Code] = {
          label = string.format("%s：{priceicon=%s,%s}", ZhString.HappyShop_PriceTitle, priceIcon, self:getRealPrice())
        }
      end
    end
  end
  if self.data then
    self:UpdateNormalItemInfo(self.data)
    self:UpdateEquipAttriInfo(self.data)
    self:UpdateCardAttriInfo(self.data)
  end
  local sData = self.data and self.data.staticData
  local limitCfg = sData.GetLimit
  if limitCfg and limitCfg.type ~= nil then
    local getLimitData = {}
    local limitCount = ItemData.Get_GetLimitCount(sData.id)
    getLimitData.label = string.format("%s%s 0/%s", ItemData.GetLimitPrefixFromCfg(limitCfg), ZhString.ItemTip_GetLimit, limitCount)
    self.contextDatas[ItemTipAttriType.UseLimit] = getLimitData
    local source = limitCfg.source
    if limitCfg.uniform_source == 1 then
      source = {
        source[1]
      }
    end
    ServiceItemProxy.Instance:CallGetCountItemCmd(sData.id, nil, source)
  end
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
    elseif self.data:IsSelectRewardPackage() then
      local rewards = ItemUtil.GetRewardSelectContent(self.data.staticData.id)
      descStr = StringUtil.ParseItemsToClickUrl(rewards)
      
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickItemUrl, tonumber(string.sub(url, 8)))
      end
    elseif StringUtil.HasItemIdToClick(descStr) then
      descStr = StringUtil.AdaptItemIdClickUrl(descStr)
      
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickItemUrl, tonumber(string.sub(url, 8)))
      end
    elseif self.data.cup_name ~= nil then
      descStr = string.format(descStr, self.data.cup_name)
    elseif StringUtil.HasPreviewToClick(descStr) then
      descStr = StringUtil.AdaptItemPreviewClickUrl(descStr)
      
      function desc.clickurlcallback(url)
        if self.OnClickPreview then
          self:OnClickPreview()
        end
      end
    elseif StringUtil.HasBufferIdToClick(descStr) then
      descStr = StringUtil.AdaptBuffIdClickUrl(descStr)
      
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 11) ~= "enchantbuff" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickBufferUrl, sData.id)
      end
    end
    descStr = ZhString.ItemTip_Desc .. descStr
    desc.label = descStr
    desc.hideline = true
    self.contextDatas[ItemTipAttriType.Desc] = desc
  else
    local desc = {}
    local descStr = ""
    if self.data:IsSelectRewardPackage() then
      local rewards = ItemUtil.GetRewardSelectContent(self.data.staticData.id)
      descStr = StringUtil.ParseItemsToClickUrl(rewards)
      
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickItemUrl, tonumber(string.sub(url, 8)))
      end
    end
    if descStr and descStr ~= "" then
      desc.label = ZhString.ItemTip_Desc .. descStr
      self.contextDatas[ItemTipAttriType.Desc] = desc
    end
  end
  self:ResetAttriDatas()
end

function NewHappyShopBuyItemCell:getRealPrice()
  local price = 0
  if self.shopdata.isDeposit then
    price = self.shopdata.productConf.Rmb
  else
    local discount = 100
    if self.shopdata.changeCost then
      local curCount = self.shopdata.sum_count or 0
      local inputValue = self.countInput.value and tonumber(self.countInput.value) or 1
      local targetCount = curCount + inputValue
      price = self.shopdata:GetChangeCost(targetCount)
    else
      price = self.shopdata.ItemCount
    end
    if math.abs(self.shopdata:GetBuyFinalPrice(price, 1) - price) > math.Epsilon then
      if self.shopdata.actDiscount ~= 0 then
        discount = self.shopdata.actDiscount
      elseif self.shopdata.Discount ~= 0 then
        discount = self.shopdata.Discount
      end
    end
    if discount < 100 then
      price = price * (discount / 100)
    end
  end
  local a, b = math.modf(price)
  if 0 < b then
    b = math.floor(b * 100) / 100
  end
  return a + b
end

function NewHappyShopBuyItemCell:UpdateCount(change)
  NewHappyShopBuyItemCell.super.UpdateCount(self, change)
  if self.shopdata.changeCost then
    self:UpdateAttriContext()
  end
end

function NewHappyShopBuyItemCell:RealConfirm()
  if self.shopdata.isDeposit then
    local inputValue = self.countInput.value and tonumber(self.countInput.value) or 1
    self.m_depositBuyFunc(inputValue)
    self:Cancel()
  else
    local flag, func = true
    if self.m_checkFunc ~= nil and self.m_checkTable ~= nil then
      flag, func = self.m_checkFunc(self.m_checkTable)
    end
    if not flag and func ~= nil then
      func()
      self:Cancel()
      return
    end
    NewHappyShopBuyItemCell.super.RealConfirm(self)
    self:Cancel()
  end
end

function NewHappyShopBuyItemCell:setCheckCanBuyFunc(func, tb)
  self.m_checkFunc = func
  self.m_checkTable = tb
end

function NewHappyShopBuyItemCell:onShowClickItemUrlTip(value)
  self:closeUrlTips()
  self.m_urlTips = ItemFloatTip.new("ItemFloatTip", self.m_tipWidget)
  self.m_urlTips:OnEnter()
  self.m_urlTips:SetData(value)
end

function NewHappyShopBuyItemCell:closeUrlTips()
  if self.m_urlTips ~= nil and self.m_urlTips:OnExit() then
    self.m_urlTips:DestroySelf()
  end
  self.m_urlTips = nil
end

function NewHappyShopBuyItemCell:InputOnSubmit()
  NewHappyShopBuyItemCell.super.InputOnSubmit(self)
end

function NewHappyShopBuyItemCell:UpdateTotalPrice(count)
  if self.shopdata.isDeposit then
    self.totalPrice.text = self.shopdata.productConf.priceStr or string.format("%s%s", self.shopdata.productConf.CurrencyType, StringUtil.NumThousandFormat(self:getRealPrice(), nil, true))
    self.count = count
    if self.countInput.value ~= tostring(count) then
      self.countInput.value = count
    end
    xdlog("UpdateTotalPrice", count)
  else
    NewHappyShopBuyItemCell.super.UpdateTotalPrice(self, count)
  end
end

function NewHappyShopBuyItemCell:InputOnChange()
  self:_InputOnChange()
end

function NewHappyShopBuyItemCell:_InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif self.maxcount == 1 then
    count = 1
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function NewHappyShopBuyItemCell:SetItemGetCount(data)
  if data == nil or self.itemData == nil then
    return
  end
  if self.soldCount_Set then
    return
  end
  if data.itemid == self.itemData.goodsID then
    self.canBuy = true
    local left = math.max(0, ItemData.Get_GetLimitCount(self.itemData.goodsID) - data.count)
    self.limitCount.text = ""
    self.maxcount = left
    local count = 1
    if left == 0 then
      count = 0
    end
    self.countInput.value = count
    self:InputOnChange()
  end
end
