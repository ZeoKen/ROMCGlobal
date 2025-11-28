autoImport("ShopItemInfoCell")
autoImport("ShopMultiplePriceCell")
autoImport("NewShopMultiplePriceCell")
HappyShopBuyItemCell = class("HappyShopBuyItemCell", ShopItemInfoCell)

function HappyShopBuyItemCell.CreateInstance(parent)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"), parent)
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  NGUIUtil.AdjustPanelDepthByParent(go)
  return HappyShopBuyItemCell.new(go)
end

local hideType = {hideClickSound = true, hideClickEffect = false}
local uiCamera

function HappyShopBuyItemCell:FindObjs()
  HappyShopBuyItemCell.super.FindObjs(self)
  self.bg = self:FindComponent("Bg", UISprite)
  self.priceTitle = self:FindGO("PriceTitle"):GetComponent(UILabel)
  self.totalPriceTitle = self:FindGO("TotalPriceTitle"):GetComponent(UILabel)
  self.countTitle = self:FindComponent("CountTitle", UILabel)
  self.rentDesc = self:FindComponent("RentDesc", UILabel)
  if self.rentDesc then
    self.rentDesc.text = ZhString.HappyShop_RentDesc
    self:Hide(self.rentDesc)
  end
  self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
  self.limitCount = self:FindGO("LimitCount"):GetComponent(UILabel)
  self.todayCanBuy = self:FindGO("TodayCanBuy"):GetComponent(UILabel)
  self.priceRoot = self:FindGO("PriceRoot")
  self.multiplePriceRoot = self:FindGO("MultiplePriceRoot")
  self.confirmSprite = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.confirmLab = self:FindComponent("Label", UILabel, self.confirmSprite.gameObject)
  self.countBg = self:FindGO("CountBg")
  self.helpButton = self:FindGO("HelpInfoButton")
  self.closeWhenClickOtherPlace = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.changeCostTipBtn = self:FindGO("ChangeCostTip", self.priceRoot)
end

function HappyShopBuyItemCell:AddEvts()
  HappyShopBuyItemCell.super.AddEvts(self)
  if self.helpButton then
    self:AddClickEvent(self.helpButton, function()
      if not self.data then
        return
      end
      OverseaHostHelper:ShowGiftProbability(self.data.staticData.id)
    end)
  end
  if self.changeCostTipBtn then
    local longPress = self.changeCostTipBtn:GetComponent(UILongPress)
    if longPress then
      function longPress.pressEvent(obj, state)
        if state then
          local widget = self.changeCostTipBtn:GetComponent(UIWidget)
          
          local data = {
            changeCost = self.itemData.changeCost,
            costID = self.itemData.ItemID
          }
          TipManager.Instance:SetShopChangeCostTip(data, widget, nil, {-150, 120})
        else
          TipsView.Me().currentTip:StartCountDown()
        end
      end
    end
  end
end

function HappyShopBuyItemCell:AddCloseWhenClickOtherPlaceCallBack(view)
  if not view then
    redlog("添加CloseWhenClickOtherPlace回调失败，请传入BuyItemCell所属的view")
    return
  end
  
  function self.closeWhenClickOtherPlace.callBack()
    if view.selectGo then
      local size = NGUIMath.CalculateAbsoluteWidgetBounds(view.selectGo.transform)
      if not uiCamera then
        uiCamera = NGUITools.FindCameraForLayer(Game.ELayer.UI)
      end
      local pos = uiCamera:ScreenToWorldPoint(Input.mousePosition)
      if not size:Contains(Vector3(pos.x, pos.y, pos.z)) then
        view.selectGo = nil
      elseif not self.gameObject.activeSelf then
        self.gameObject:SetActive(true)
      end
    end
  end
end

function HappyShopBuyItemCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    if self.confirmSprite.CurrentState == 1 then
      return
    end
    if self.shopdata.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek and self.shopdata.ItemID == GameConfig.MoneyId.Lottery then
      local goodsID = self.shopdata.goodsID
      local nameZh = Table_Item[goodsID] and Table_Item[goodsID].NameZh or ""
      MsgManager.ConfirmMsgByID(4047, function()
        self:Confirm()
      end, nil, nil, nameZh)
    else
      self:Confirm()
    end
  end, hideType)
end

function HappyShopBuyItemCell:UpdateRentInfo()
  if not self.rentDesc then
    return
  end
  if HappyShopProxy.Instance:IsRent() then
    self:Show(self.rentDesc)
    self.priceTitle.text = ZhString.HappyShop_PriceTitle_Rent
    self.totalPriceTitle.text = ZhString.HappyShop_TotalPriceTitle_Rent
    self.countTitle.text = ZhString.HappyShop_RentCount
    self.confirmLab.text = ZhString.HappyShop_Rent
  else
    self:Hide(self.rentDesc)
    self.priceTitle.text = ZhString.HappyShop_PriceTitle
    self.totalPriceTitle.text = ZhString.HappyShop_TotalPriceTitle
    self.countTitle.text = ZhString.HappyShop_PurchaseCount
    self.confirmLab.text = ZhString.HappyShop_Buy
  end
end

function HappyShopBuyItemCell:SetData(data)
  if data then
    local _HappyShopProxy = HappyShopProxy.Instance
    local _HappyShopProxyLimitType = HappyShopProxy.LimitType
    self.shopdata = data
    self.data = data:GetItemData()
    self:UpdateRentInfo()
    local moneyID = data.ItemID
    if self.shopdata.changeCost then
      self.moneycount = self.shopdata:GetChangeCost()
    else
      self.moneycount = self.shopdata.ItemCount
    end
    self.maxcount = nil
    local isGuildMaterial = data.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek
    self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(72, isGuildMaterial and -20 or -50)
    if data.ItemID2 then
      self:ShowMultiplePrice(true)
      local grid, tempVector = self.multiplePriceRoot:GetComponent(UIGrid), LuaGeometry.GetTempVector3()
      if isGuildMaterial then
        if not self.guildMultiPriceCtl then
          self.guildMultiPriceCtl = UIGridListCtrl.new(grid, NewShopMultiplePriceCell, "NewShopMultiplePriceCell")
        end
        tempVector:Set(0, -70, 0)
        grid.cellHeight = 92
      else
        if not self.multiplePriceCtl then
          self.multiplePriceCtl = UIGridListCtrl.new(grid, ShopMultiplePriceCell, "ShopMultiplePriceCell")
        end
        tempVector:Set(-17, -110, 0)
        grid.cellHeight = 60
      end
      self.multiplePriceRoot.transform.localPosition = tempVector
      local list = ReusableTable.CreateArray()
      list[1] = moneyID
      list[2] = data.ItemID2
      local ctl = self:GetCtl()
      if ctl then
        ctl:ResetDatas(list)
      end
      ReusableTable.DestroyArray(list)
    else
      self:ShowMultiplePrice(false)
      local moneyData = Table_Item[moneyID]
      if moneyData ~= nil then
        local icon = moneyData.Icon
        if icon ~= nil then
          IconManager:SetItemIcon(icon, self.priceIcon)
          IconManager:SetItemIcon(icon, self.totalPriceIcon)
        end
      end
    end
    local discountTotal
    self.discount, self.discountCount, discountTotal = data:GetTotalBuyDiscount(self.moneycount)
    if self.discount ~= 0 then
      self.salePrice:SetActive(true)
      self:UpdateSale(self.discount, self.discountCount)
    else
      self.salePrice:SetActive(false)
    end
    self:UpdateOwnInfo()
    self.todayCanBuy.gameObject:SetActive(false)
    if data.discountMax ~= 0 then
      local leftCount = math.max(0, data.discountMax - _HappyShopProxy:GetDiscountItemCount(data.id))
      if 0 < leftCount then
        self.todayCanBuy.gameObject:SetActive(true)
        self.todayCanBuy.text = string.format(ZhString.HappyShop_ActivityCanBuy, data.actDiscount / 10, leftCount, data.discountMax)
      end
    end
    local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(data)
    if canBuyCount ~= nil then
      self.maxcount = canBuyCount
      if self.todayCanBuy.gameObject.activeSelf == false then
        self.todayCanBuy.text = _HappyShopProxy:GetTodayCanBuyCountStr(data)
        self.todayCanBuy.gameObject:SetActive(limitType ~= _HappyShopProxyLimitType.GuildMaterialWeek)
      end
    end
    self:UpdateConfirmBtn(canBuyCount ~= 0)
    local limitCfg = data:GetItemData().staticData.GetLimit
    if _HappyShopProxy:CheckLimitCount(limitCfg) then
      self.canBuy = false
    else
      self.canBuy = true
    end
    self.limitCount.text = ""
    self:UpdateSoldCountInfo(data)
    if self.changeCostTipBtn then
      self.changeCostTipBtn:SetActive(data.changeCost ~= nil)
      if data.changeCost and BranchMgr.IsJapan() then
        TimeTickManager.Me():CreateOnceDelayTick(50, function()
          local widget = self.changeCostTipBtn:GetComponent(UIWidget)
          local tipData = {
            changeCost = data.changeCost,
            costID = data.ItemID
          }
          local tip = TipManager.Instance:SetShopChangeCostTip(tipData, widget, nil, {-150, 120})
          if tip then
            tip:AddIgnoreBounds(self.bg.gameObject)
          end
        end, 7)
      end
    end
  end
  self:UpdateHelpInfoButton()
  HappyShopBuyItemCell.super.SetData(self, data)
end

function HappyShopBuyItemCell:UpdateOwnInfo(checkBagTypes)
  local shopdata = self.shopdata
  if shopdata then
    if shopdata.source == HappyShopProxy.SourceType.UserGuild then
      local guildOwn = GuildProxy.Instance:GetGuildPackItemNumByItemid(shopdata.goodsID)
      self.ownInfo.text = string.format(ZhString.HappyShop_OwnGuild, guildOwn)
      return
    end
    local own
    if checkBagTypes then
      own = BagProxy.Instance:GetItemNumByStaticID(shopdata.goodsID, checkBagTypes)
    else
      own = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
    end
    if own then
      if shopdata.source == HappyShopProxy.SourceType.Guild then
        self.ownInfo.text = string.format(ZhString.HappyShop_OwnGuild, own)
      else
        if ItemData.CheckIsEquip(shopdata.goodsID) and AdventureDataProxy.Instance:IsEquipStored(shopdata.goodsID) then
          own = own + 1
        end
        self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, own)
      end
    else
      self.ownInfo.text = ""
    end
  else
    self.ownInfo.text = ""
  end
end

function HappyShopBuyItemCell:RealConfirm()
  helplog("Confirm 1")
  if not self.canBuy then
    MsgManager.ShowMsgByID(3242)
    return
  end
  local item = HappyShopProxy.Instance:GetSelectId()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
    count = self.count
  end
  if item then
    local isBuy
    if GameConfig.AutoQuestCompleteItems then
      local itemId = self.data.staticData.id
      if TableUtility.ArrayFindIndex(GameConfig.AutoQuestCompleteItems, itemId) > 0 then
        if HappyShopProxy.Instance:NeedQueryAutoQuestComplete() then
          ServiceQuestProxy.Instance:CallCompleteAvailableQueryQuestCmd(itemId)
        else
          isBuy = self:CheckAutoQuestComplete(item, count)
        end
      else
        isBuy = HappyShopProxy.Instance:BuyItem(item, count)
      end
    else
      isBuy = HappyShopProxy.Instance:BuyItem(item, count)
    end
    self:PlayBuySound(isBuy)
  end
  HappyShopBuyItemCell.super.Confirm(self)
end

function HappyShopBuyItemCell:PlayBuySound(isBuy)
  if isBuy then
    local isPlayAudio = false
    local moneyId = GameConfig.MoneyId
    for i = 1, 5 do
      local temp = i
      if temp == 1 then
        temp = ""
      end
      local itemID = self.shopdata["ItemID" .. temp]
      if itemID == moneyId.Lottery then
        isPlayAudio = true
        break
      end
    end
    if isPlayAudio then
      self:PlayUISound(AudioMap.UI.LotteryCoin)
    else
      self:PlayUISound(AudioMap.UI.Click)
    end
  else
    self:PlayUISound(AudioMap.UI.Click)
  end
end

function HappyShopBuyItemCell:Confirm()
  if BranchMgr.IsJapan() then
    self.gameObject:SetActive(false)
  end
  if tonumber(self.shopdata.ItemID) == 151 then
    OverseaHostHelper:GachaUseComfirm(self.xdetotal, function()
      self:RealConfirm()
    end, 650)
  elseif self.itemData.ItemID2 and tonumber(self.itemData.ItemID2) == 151 then
    OverseaHostHelper:GachaUseComfirm(self.xdetotal2, function()
      self:RealConfirm()
    end, 650)
  elseif self.shopdata.itemID == 8067 then
    local baseCheck = self:CheckBaseLevel()
    local jobCheck = self:CheckJobLevel()
    local msgid
    if baseCheck and jobCheck then
      msgid = 43044
    elseif jobCheck then
      msgid = 43043
    elseif baseCheck then
      msgid = 43042
    else
      msgid = 43041
    end
    MsgManager.ConfirmMsgByID(msgid, function()
      self:RealConfirm()
    end)
  else
    self:RealConfirm()
  end
end

function HappyShopBuyItemCell:UpdateCount(change)
  HappyShopBuyItemCell.super.UpdateCount(self, change)
  if 0 < change then
    FunctionGuide.Me():buyItemCheck(self.count)
  end
end

function HappyShopBuyItemCell:UpdateCurPrice(count)
  if self.itemData.changeCost then
    local curCount = self.itemData.sum_count or 0
    local curPrice = self.itemData:GetChangeCost(curCount + count)
    self.price.text = StringUtil.NumThousandFormat(curPrice)
  end
end

function HappyShopBuyItemCell:UpdatePrice(count)
  if count == nil then
    count = 1
  end
  local totalPrice, discount = self.itemData:GetBuyDiscountPrice(self.moneycount, count)
  local price = discount * self.moneycount / 100
  if self.itemData.ItemID2 then
    local moneycount2 = self.itemData.ItemCount2
    totalPrice, discount = self.itemData:GetBuyDiscountPrice(moneycount2, count)
    local price2 = discount * moneycount2 / 100
    local ctl = self:GetCtl()
    if nil ~= ctl then
      local cells = ctl:GetCells()
      cells[1]:SetPrice(price)
      cells[2]:SetPrice(price2)
    end
  else
    self.price.text = StringUtil.NumThousandFormat(price)
  end
end

function HappyShopBuyItemCell:UpdateTotalPrice(count)
  self.count = count
  local discountTotal
  discountTotal, self.discountCount = self.itemData:GetBuyFinalPrice(self.moneycount, count)
  if self.itemData.ItemID2 then
    local ctl = self:GetCtl()
    if nil ~= ctl then
      local discountTotal2 = self.itemData:GetBuyFinalPrice(self.itemData.ItemCount2, count)
      local cells = ctl:GetCells()
      cells[1]:SetTotalPrice(discountTotal)
      cells[2]:SetTotalPrice(discountTotal2)
      self.xdetotal2 = discountTotal2
    end
  else
    self.totalPrice.text = StringUtil.NumThousandFormat(discountTotal)
  end
  self.xdetotal = discountTotal
  self:UpdateSale(self.discount, self.discountCount)
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function HappyShopBuyItemCell:UpdateSale(discount, totalCost)
  self.salePriceTip.text = string.format(ZhString.HappyShop_BuyCheap, discount * 100, StringUtil.NumThousandFormat(totalCost))
end

function HappyShopBuyItemCell:UpdateSoldCountInfo(data)
  data = data or self.shopdata
  if data == nil then
    self.soldCount_Set = false
    return
  end
  local soldCount, produceNum = data.soldCount or 0, data.produceNum
  if produceNum and 0 < produceNum then
    self.soldCount_Set = true
    self.limitCount.text = string.format(ZhString.HappyShop_SoldCount, produceNum - soldCount, produceNum)
  else
    self.soldCount_Set = false
  end
end

function HappyShopBuyItemCell:UpdateConfirmBtn(canBuy)
  self.confirmSprite.CurrentState = canBuy and 0 or 1
  if canBuy then
    self.confirmLabel.text = HappyShopProxy.Instance:IsRent() and ZhString.HappyShop_Rent or ZhString.HappyShop_Buy
  else
    self.confirmLabel.text = ZhString.HappyShop_SoldOut
  end
  self.confirmLabel.effectStyle = canBuy and UILabel.Effect.Outline or UILabel.Effect.None
end

function HappyShopBuyItemCell:SetItemGetCount(data)
  if data == nil or self.itemData == nil then
    return
  end
  if self.soldCount_Set then
    return
  end
  local sources = data.sources
  if sources and TableUtility.ArrayFindIndex(sources, ProtoCommon_pb.ESOURCE_SHOP) == 0 then
    return
  end
  if data.itemid == self.itemData.goodsID then
    self.canBuy = true
    local left = math.max(0, ItemData.Get_GetLimitCount(self.itemData.goodsID) - data.count)
    self.limitCount.text = string.format(ZhString.HappyShop_LimitCount, ItemData.GetLimitPrefixFromCfg(self.itemData:GetItemData().staticData.GetLimit), left)
    self.maxcount = left
    local count = 1
    if left == 0 then
      count = 0
    end
    self.countInput.value = count
    self:InputOnChange()
  end
end

function HappyShopBuyItemCell:SetLimitCountText(text)
  if text ~= nil and text ~= "" then
    self.limitCount.gameObject:SetActive(true)
    self.limitCount.text = text
  else
    self.limitCount.gameObject:SetActive(false)
  end
end

function HappyShopBuyItemCell:ShowMultiplePrice(isShow)
  self.multiplePriceRoot:SetActive(isShow)
  self.priceRoot:SetActive(not isShow)
end

function HappyShopBuyItemCell:GetCtl()
  if self.shopdata.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek then
    return self.guildMultiPriceCtl
  else
    return self.multiplePriceCtl
  end
end

function HappyShopBuyItemCell:UpdateSkillGemSpecialTip(skillData)
  if not skillData then
    return false
  end
  self.contextDatas[ItemTipAttriType.SpecialTip] = {
    label = GemProxy.Instance:GetSkillGemExhibitEffectDescArray(skillData.id)
  }
  return true
end

function HappyShopBuyItemCell:UpdateHelpInfoButton()
  if self.helpButton then
    local isActive = self.data ~= nil and ItemTipBaseCell.ShowHelpInfoPredicate(self.data.staticData.id)
    self.helpButton:SetActive(isActive)
  end
end

function HappyShopBuyItemCell:RecvQuestCompleteQuery(data)
  local item = HappyShopProxy.Instance:GetSelectId()
  local count = tonumber(self.countInput.value)
  self:CheckAutoQuestComplete(item, count)
end

function HappyShopBuyItemCell:CheckAutoQuestComplete(item, count)
  if HappyShopProxy.Instance:NeedConfirmAutoQuestComplete() then
    MsgManager.ConfirmMsgByID(41515, function()
      HappyShopProxy.Instance:BuyItem(item, count)
    end)
  elseif HappyShopProxy.Instance:IsNotNeedAutoQuestComplete() then
    MsgManager.ShowMsgByID(28093)
  else
    return HappyShopProxy.Instance:BuyItem(item, count)
  end
end

function HappyShopBuyItemCell:CheckBaseLevel()
  local myLv = MyselfProxy.Instance:RoleLevel()
  return myLv < GameConfig.System.maxbaselevel
end

function HappyShopBuyItemCell:CheckJobLevel()
  if MyselfProxy.Instance:IsHero() then
    return false
  end
  local isHighestJob = MyselfProxy.Instance.in_max_profession
  if isHighestJob then
    local jobLv = MyselfProxy.Instance:JobLevel()
    local maxJobLv = MyselfProxy.Instance:CurMaxJobLevel()
    return jobLv < maxJobLv
  else
    return false
  end
end
