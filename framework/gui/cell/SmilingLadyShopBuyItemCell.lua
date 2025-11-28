autoImport("ShopItemInfoCell")
autoImport("ShopMultiplePriceCell")
autoImport("NewShopMultiplePriceCell")
SmilingLadyShopBuyItemCell = class("SmilingLadyShopBuyItemCell", ShopItemInfoCell)

function SmilingLadyShopBuyItemCell.CreateInstance(parent)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("SmilingLady/SmilingLadyShopBuyItemCell"), parent)
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  NGUIUtil.AdjustPanelDepthByParent(go)
  return SmilingLadyShopBuyItemCell.new(go)
end

local hideType = {hideClickSound = true, hideClickEffect = false}
local uiCamera

function SmilingLadyShopBuyItemCell:Exit()
  SmilingLadyShopBuyItemCell.super.Exit(self)
  self:CloseGainWayTip()
end

function SmilingLadyShopBuyItemCell:FindObjs()
  SmilingLadyShopBuyItemCell.super.FindObjs(self)
  self.bg = self:FindComponent("Bg", UISprite)
  self.totalPriceTitle = self:FindGO("TotalPriceTitle"):GetComponent(UILabel)
  self.todayCanBuy = self:FindGO("TodayCanBuy"):GetComponent(UILabel)
  self.priceRoot = self:FindGO("PriceRoot")
  self.confirmSprite = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
  self.countBg = self:FindGO("CountBg")
  self.helpButton = self:FindGO("HelpInfoButton")
  self.changeCostTipBtn = self:FindGO("ChangeCostTip", self.priceRoot)
  self.btnGrid = self:FindComponent("BtnGrid", UIGrid)
  self.getPathBtn = self:FindGO("GetPathBtn")
  if self.getPathBtn then
    self:AddClickEvent(self.getPathBtn, function(go)
      self:ShowGainWayTip()
    end)
  end
end

function SmilingLadyShopBuyItemCell:AddEvts()
  SmilingLadyShopBuyItemCell.super.AddEvts(self)
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

function SmilingLadyShopBuyItemCell:AddCloseWhenClickOtherPlaceCallBack(view)
  if not view then
    redlog("添加CloseWhenClickOtherPlace回调失败，请传入BuyItemCell所属的view")
    return
  end
  
  function self.closecomp.callBack()
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

function SmilingLadyShopBuyItemCell:AddConfirmClickEvent()
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

function SmilingLadyShopBuyItemCell:SetData(data)
  if data and data.GetLock and data:GetLock() then
    self.context = {
      lockType = data.lockType,
      lockArg = data.lockArg,
      lockDesc = (not data.GetComplexLockDesc or not data:GetComplexLockDesc()) and data.GetMenuDes and data:GetMenuDes()
    }
  else
    self.context = nil
  end
  if data then
    local _HappyShopProxy = HappyShopProxy.Instance
    local _HappyShopProxyLimitType = HappyShopProxy.LimitType
    self.shopdata = data
    self.data = data:GetItemData()
    local moneyID = data.ItemID
    self.moneyId = moneyID
    if self.shopdata.changeCost then
      self.moneycount = self.shopdata:GetChangeCost()
    else
      self.moneycount = self.shopdata.ItemCount
    end
    self.maxcount = nil
    local moneyData = Table_Item[moneyID]
    if moneyData ~= nil then
      local icon = moneyData.Icon
      if icon ~= nil then
        IconManager:SetItemIcon(icon, self.totalPriceIcon)
      end
    end
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
        local repStr
        if limitType == _HappyShopProxyLimitType.OneDay then
          repStr = ZhString.HappyShop_todayCanBuy
        elseif limitType == _HappyShopProxyLimitType.AccUser then
          repStr = ZhString.HappyShop_AccUserCanBuy
        elseif limitType == _HappyShopProxyLimitType.AccUserAlways or limitType == _HappyShopProxyLimitType.UserAlways then
          repStr = ZhString.HappyShop_AlwaysCanBuy
        elseif limitType == _HappyShopProxyLimitType.AccWeek then
          repStr = ZhString.HappyShop_AccWeekCanBuy
        elseif limitType == _HappyShopProxyLimitType.AccMonth then
          repStr = ZhString.HappyShop_AccMonthCanBuy
        elseif limitType == _HappyShopProxyLimitType.UserWeek then
          repStr = ZhString.HappyShop_AccUserWeekCanBuy
        end
        if repStr then
          local maxLimitStr = ""
          if data.maxlimitnum ~= nil and 0 < data.maxlimitnum then
            maxLimitStr = string.format(ZhString.HappyShop_MaxLimitCount, data.maxlimitnum)
          end
          self.todayCanBuy.text = string.format(repStr, maxLimitStr, self.maxcount)
        else
          self.todayCanBuy.text = ""
        end
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
  SmilingLadyShopBuyItemCell.super.SetData(self, data)
  self.btnGrid:Reposition()
end

function SmilingLadyShopBuyItemCell:RealConfirm()
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
  SmilingLadyShopBuyItemCell.super.Confirm(self)
end

function SmilingLadyShopBuyItemCell:PlayBuySound(isBuy)
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

function SmilingLadyShopBuyItemCell:Confirm()
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
  else
    self:RealConfirm()
  end
end

function SmilingLadyShopBuyItemCell:UpdateCount(change)
  SmilingLadyShopBuyItemCell.super.UpdateCount(self, change)
  if 0 < change then
    FunctionGuide.Me():buyItemCheck(self.count)
  end
end

function SmilingLadyShopBuyItemCell:UpdateTotalPrice(count)
  self.count = count
  local discountTotal = self.itemData:GetBuyFinalPrice(self.moneycount, count)
  self.totalPrice.text = StringUtil.NumThousandFormat(discountTotal)
  self.xdetotal = discountTotal
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function SmilingLadyShopBuyItemCell:UpdateSoldCountInfo(data)
  data = data or self.shopdata
  if not data then
    self.soldCount_Set = false
    return
  end
  local soldCount, produceNum = data.soldCount or 0, data.produceNum
  if produceNum and 0 < produceNum then
    self.soldCount_Set = true
  else
    self.soldCount_Set = false
  end
end

function SmilingLadyShopBuyItemCell:UpdateConfirmBtn(canBuy)
  self.confirmSprite.CurrentState = canBuy and 0 or 1
  self.confirmLabel.text = canBuy and ZhString.HappyShop_Buy or ZhString.HappyShop_SoldOut
  self.confirmLabel.effectStyle = canBuy and UILabel.Effect.Outline or UILabel.Effect.None
end

function SmilingLadyShopBuyItemCell:SetItemGetCount(data)
  if data == nil or self.itemData == nil then
    return
  end
  if self.soldCount_Set then
    return
  end
  if data.itemid == self.itemData.goodsID then
    self.canBuy = true
    local left = math.max(0, ItemData.Get_GetLimitCount(self.itemData.goodsID) - data.count)
    self.maxcount = left
    local count = 1
    if left == 0 then
      count = 0
    end
    self.countInput.value = count
    self:InputOnChange()
  end
end

function SmilingLadyShopBuyItemCell:UpdateSkillGemSpecialTip(skillData)
  if not skillData then
    return false
  end
  self.contextDatas[ItemTipAttriType.SpecialTip] = {
    label = GemProxy.Instance:GetSkillGemExhibitEffectDescArray(skillData.id)
  }
  return true
end

function SmilingLadyShopBuyItemCell:UpdateHelpInfoButton()
  if self.helpButton then
    local isActive = self.data ~= nil and ItemTipBaseCell.ShowHelpInfoPredicate(self.data.staticData.id)
    self.helpButton:SetActive(isActive)
  end
end

function SmilingLadyShopBuyItemCell:RecvQuestCompleteQuery(data)
  local item = HappyShopProxy.Instance:GetSelectId()
  local count = tonumber(self.countInput.value)
  self:CheckAutoQuestComplete(item, count)
end

function SmilingLadyShopBuyItemCell:CheckAutoQuestComplete(item, count)
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

function SmilingLadyShopBuyItemCell:ShowFashionPreview()
  SmilingLadyShopBuyItemCell.super.ShowFashionPreview(self)
  self:CloseGainWayTip()
end

function SmilingLadyShopBuyItemCell:ShowGainWayTip()
  self:CloseFashionPreview()
  self:CloseGainWayTip()
  local scale = 1
  self.gpContainer.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, self.gameObject.transform, Space.World)
  self.gpContainer.transform.localPosition = LuaGeometry.GetTempVector3(0 < x and -523 or 205, 272, 0)
  self.gainwayCtl = GainWayTip.new(self.gpContainer)
  self.gainwayCtl:SetData(self.data.staticData.id, self.context)
end

function SmilingLadyShopBuyItemCell:CloseGainWayTip()
  if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
    self.gainwayCtl:OnExit()
  end
  self.gainwayCtl = nil
end

function SmilingLadyShopBuyItemCell:PreUpdateNormalItemInfo(data)
  self:UpdateOwnInfo(data)
  self:UpdatePriceInfo(data)
end

function SmilingLadyShopBuyItemCell:UpdateOwnInfo(data)
  local shopdata = self.shopdata
  if shopdata then
    local own = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
    if own then
      local ownText = string.format(ZhString.ItemTip_Owned, own)
      local ctxData = {label = ownText}
      self.contextDatas[ItemTipAttriType.OwnCount] = ctxData
    end
  end
end

function SmilingLadyShopBuyItemCell:UpdatePriceInfo(data)
  local moneyData = self.moneyId and Table_Item[self.moneyId]
  if not moneyData then
    return
  end
  local totalPrice, discount = self.itemData:GetBuyDiscountPrice(self.moneycount, 1)
  local price = math.floor(discount * self.moneycount / 100)
  local moneyIcon = string.gsub(moneyData.Icon, "item_", "")
  self.contextDatas[ItemTipAttriType.BuyPrice] = {
    label = string.format("%s{priceicon=%s,%s}", ZhString.ItemTip_BuyPrice, moneyIcon, price)
  }
end

function SmilingLadyShopBuyItemCell:ShowMultiplePrice(isShow)
end

function SmilingLadyShopBuyItemCell:GetCtl()
end

function SmilingLadyShopBuyItemCell:UpdateCurPrice(count)
end

function SmilingLadyShopBuyItemCell:UpdatePrice(count)
end

function SmilingLadyShopBuyItemCell:UpdateSale(discount, totalCost)
end
