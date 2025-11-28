ReturnActivityShopPage = class("ReturnActivityShopPage", SubView)
ReturnActivityShopPage.ViewType = UIViewType.NormalLayer
autoImport("RewardGridCell")
autoImport("ReturnActivityShopCell")
autoImport("NewHappyShopBuyItemCell")
autoImport("NewRechargeGiftTipCell")
local viewPath = ResourcePathHelper.UIView("ReturnActivityShopPage")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function ReturnActivityShopPage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function ReturnActivityShopPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.shopPageObj, true)
  obj.name = "ReturnActivityShopPage"
  self.gameObject = self:FindGO("ReturnActivityShopPage")
end

function ReturnActivityShopPage:FindObjs()
  self:LoadSubView()
  self.shopScrollView = self:FindGO("GoodsScrollView", self.gameObject):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.shopCtrl = UIGridListCtrl.new(self.shopGrid, ReturnActivityShopCell, "ReturnActivityShopCell")
  self.shopCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  
  function self.shopScrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
  
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
  self:InitGiftItemCell()
  self.costGO = self:FindGO("Cost", self.gameObject)
  self.costLabel = self:FindGO("CostLabel", self.costGO):GetComponent(UILabel)
  self.costIcon = self:FindGO("CostIcon", self.costGO):GetComponent(UISprite)
end

function ReturnActivityShopPage:AddEvts()
end

function ReturnActivityShopPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RecvQueryShopConfig)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
end

function ReturnActivityShopPage:InitDatas()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local globalActID = ReturnActivityProxy.Instance.curActID
  self.config = globalActID and GameConfig.Return.Feature[globalActID]
  self.shopType = ReturnActivityProxy.Instance.shopType
  self.shopID = self.config.ShopID
  self.costID = self.config and self.config.ShopItemID
end

function ReturnActivityShopPage:InitShow()
  xdlog("货币", self.costID)
  local itemData = Table_Item[self.costID]
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
  self:UpdateMoney()
end

function ReturnActivityShopPage:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function ReturnActivityShopPage:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell")
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.Confirm = ReturnActivityShopPage.BuyCellConfirm
  self.buyCell.gameObject:SetActive(false)
end

function ReturnActivityShopPage:BuyCellConfirm()
  local myRob = MyselfProxy.Instance:GetLottery()
  local moneyID = self.shopdata and self.shopdata.ItemID
  local discount = self.shopdata and self.shopdata.Discount or 100
  local moneyCount = self.shopdata and self.shopdata.ItemCount or 0
  local finalPrice = math.floor(moneyCount * discount / 100)
  if moneyID == 151 then
    MsgManager.DontAgainConfirmMsgByID(43445, function()
      if myRob < finalPrice then
        MsgManager.ConfirmMsgByID(3551, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
      else
        NewHappyShopBuyItemCell.super.Confirm(self)
      end
    end)
  else
    NewHappyShopBuyItemCell.super.Confirm(self)
  end
end

function ReturnActivityShopPage:InitGiftItemCell()
  local go = self:LoadCellPfb("NewRechargeGiftTipCell")
  self.giftCell = NewRechargeGiftTipCell.new(go)
  self.giftCell.gameObject:SetActive(false)
end

function ReturnActivityShopPage:RecvQueryShopConfig(note)
  self:UpdateShopInfo()
end

function ReturnActivityShopPage:RecvBuyShopItem(note)
  local data = note.body
  local isSuccess = data and data.success
  if isSuccess then
    ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(self.shopType, self.config.ShopID)
  end
end

function ReturnActivityShopPage:UpdateShopInfo()
  local result = {}
  if self.depositIDs and #self.depositIDs > 0 then
    for i = 1, #self.depositIDs do
      if ShopProxy.Instance:GetDepositItemCanBuy(self.depositIDs[i]) then
        local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.depositIDs[i])
        local tempData = {
          depositID = self.depositIDs[i],
          info = info,
          ShopOrder = self.depositIDs[i],
          id = self.depositIDs[i]
        }
        TableUtility.ArrayPushBack(result, tempData)
      end
    end
  end
  local commonShopList = {}
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.shopID)
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      if self:IsShopItemCanShow(v) then
        TableUtility.ArrayPushBack(result, v)
      end
    end
  end
  table.sort(result, ReturnActivityShopPage._SortItem)
  self.shopCtrl:ResetDatas(result)
end

function ReturnActivityShopPage:IsShopItemCanShow(shopItem)
  if not shopItem then
    return
  end
  if shopItem:IsCycleGift() then
    local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(shopItem) or 0
    if shopItem:HasPreUnlockId() then
      local preCanBuyCount = 0
      local preShopItem = NewRechargeProxy.Instance:GetShopItemData(shopItem.unlockpreid or 0)
      if preShopItem then
        preCanBuyCount = HappyShopProxy.Instance:GetCanBuyCount(preShopItem)
      end
      return preCanBuyCount <= 0
    elseif shopItem:HasNextUnlockId() then
      return 0 < canBuyCount
    else
      return true
    end
  else
    return true
  end
  return false
end

function ReturnActivityShopPage._SortItem(l, r)
  local _HappyShopProxy = HappyShopProxy.Instance
  local l_DepositID = l.depositID or 999
  local r_DepositID = r.depositID or 999
  local lCanByCount = 999
  local rCanByCount = 999
  if l.depositID then
    lCanByCount = l.info:IsSoldOut() and 0 or 999
  else
    lCanByCount = _HappyShopProxy:GetCanBuyCount(l) or 999
  end
  if r.depositID then
    rCanByCount = r.info:IsSoldOut() and 0 or 999
  else
    rCanByCount = _HappyShopProxy:GetCanBuyCount(r) or 999
  end
  if lCanByCount and rCanByCount then
    if 0 < lCanByCount and 0 < rCanByCount then
      if l_DepositID ~= r_DepositID then
        return l_DepositID < r_DepositID
      elseif l.ShopOrder == r.ShopOrder then
        return l.id < r.id
      else
        return l.ShopOrder < r.ShopOrder
      end
    else
      return lCanByCount > rCanByCount
    end
  end
end

function ReturnActivityShopPage:UpdateMoney()
  local own
  if self.costID == 151 then
    own = MyselfProxy.Instance:GetLottery()
  else
    own = BagProxy.Instance:GetItemNumByStaticID(self.costID) or 0
  end
  self.costLabel.text = StringUtil.NumThousandFormat(own)
end

function ReturnActivityShopPage:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    local positionX, positionY = self:GetScreenTouchedPos()
    if 0 < positionX then
      self.buyCell:updateLocalPostion(-217)
    else
      self.buyCell:updateLocalPostion(300)
    end
    self.buyCell:SetData(data, funcBuy)
    TipsView.Me():HideCurrent()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function ReturnActivityShopPage:HandleClickItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
    end
    self.currentItem = cellctl
  end
  xdlog("HandleClickItem")
  local data = cellctl.data
  if data and data.depositID then
    self:HandleClickDepositItem(cellctl)
  else
    self:HandleClickShopItem(cellctl)
  end
end

function ReturnActivityShopPage:HandleClickDepositItem(cellctl)
  local depositID = cellctl.depositID
  local info = cellctl.data and cellctl.data.info
  local cbfunc = function(count)
    local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
    if 0 < leftTime then
      self:PurchaseDeposit(count)
    end
  end
  local m_funcRmbBuy = function(count)
    if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
      self:Invoke_DepositConfirmPanel(cbfunc)
    else
      cbfunc(count)
    end
  end
  local tbItem = Table_Item[info.itemID]
  if tbItem ~= nil and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
    self.giftCell.gameObject:SetActive(true)
    self.giftCell:SetData(info, m_funcRmbBuy)
  else
    self.buyCell.gameObject:SetActive(true)
    self:UpdateBuyItemInfo(info, m_funcRmbBuy)
  end
end

function ReturnActivityShopPage:PurchaseDeposit(count)
  if not self.currentItem then
    return
  end
  local depositInfo = self.currentItem.data and self.currentItem.data.info
  local productConf = depositInfo.productConf
  local productID = depositInfo and depositInfo.productConf and depositInfo.productConf.ProductID
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
    FuncPurchase.Instance():Purchase(productConf.id, callbacks, count)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function ReturnActivityShopPage:Invoke_DepositConfirmPanel(cb)
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

function ReturnActivityShopPage:HandleClickShopItem(cellctl)
  local id = cellctl and cellctl.data and cellctl.data.id
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopID, id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

function ReturnActivityShopPage:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

local itemClickUrlTipData = {}

function ReturnActivityShopPage:OnClickItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    TipManager.Instance:CloseTip()
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    self:ShowClickItemUrlTip(itemClickUrlTipData)
  end
  
  self:ShowClickItemUrlTip(itemClickUrlTipData)
end

local clickItemUrlTipOffset = {196, 0}

function ReturnActivityShopPage:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function ReturnActivityShopPage:OnTipFashionPreviewShow(preview)
  self.CloseWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function ReturnActivityShopPage:OnTipFashionPreviewClose()
  self.CloseWhenClickOtherPlace:ReCalculateBound()
end

function ReturnActivityShopPage:OnEnter()
  ReturnActivityShopPage.super.OnEnter(self)
  if not self.inited then
    ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.config.ShopID)
    if self.depositIDs and #self.depositIDs > 0 then
      xdlog("申请充值项")
      ServiceUserEventProxy.Instance:CallQueryChargeCnt()
    end
    self.inited = true
  end
  self:UpdateShopInfo()
  HappyShopProxy.Instance:InitShop(nil, self.config.ShopID, self.shopType)
end
