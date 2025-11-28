autoImport("NewRechargeCommonSubView")
autoImport("NewRechargeTShopData")
autoImport("NewRechargeRecommendTShopGoodsCell")
autoImport("NewRechargeNormalTShopGoodsCell")
autoImport("NewRechargeCombinePackCell")
autoImport("NewRechargeCombinePackTipCell")
autoImport("NewRechargeCombinePackPurchaseCell")
autoImport("NewRechargeTHotMixGoodsCell")
autoImport("HappyShopBuyItemCell")
NewRechargeTHotSubView = class("NewRechargeTHotSubView", NewRechargeCommonSubView)
NewRechargeTHotSubView.manuallyInit = true
NewRechargeTHotSubView.Tab = GameConfig.NewRecharge.TabDef.Hot
NewRechargeTHotSubView.innerTab = {
  MixRecommend = 1,
  Normal1 = 2,
  Normal2 = -1,
  HiddenHeroGift = 101
}
if BranchMgr.IsJapan() then
  NewRechargeTHotSubView.innerTab = {
    MixRecommend = 1,
    Normal1 = 2,
    Normal2 = 3
  }
end

function NewRechargeTHotSubView:OnShow()
  NewRechargeTHotSubView.super.OnShow(self)
  if NewRechargeProxy.Instance:GetShouldShowHeroGift() ~= (self.heroGiftInnerSelectorLoaded ~= nil) then
    self:LoadInnerSelector(GameConfig.NewRecharge.Tabs[self.Tab].Inner)
  end
end

function NewRechargeTHotSubView:OnExit()
  NewRechargeTHotSubView.super.OnExit(self)
  self:Func_RemoveListenEvent()
  self.type0CellListCtrl:Destroy()
  self.type1CellListCtrl:Destroy()
  self.type2CellListCtrl:Destroy()
  self.type3CellListCtrl:Destroy()
end

function NewRechargeTHotSubView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function NewRechargeTHotSubView:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end

function NewRechargeTHotSubView:RequestQuerySpeedUp()
  ServiceUserEventProxy.Instance:CallQuerySpeedUpUserEvent()
end

function NewRechargeTHotSubView:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
  EventManager.Me():AddEventListener(NewRechargeEvent.CombinePackList_ForceRefresh, self.OnReceiveCombinePackListForceRefresh, self)
end

function NewRechargeTHotSubView:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
  EventManager.Me():RemoveEventListener(NewRechargeEvent.CombinePackList_ForceRefresh, self.OnReceiveCombinePackListForceRefresh, self)
end

function NewRechargeTHotSubView:OnReceiveQueryChargeCnt(data)
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end

function NewRechargeTHotSubView:OnReceiveBuyLuckyBag(message)
  NewRechargeProxy.Instance:UseLastSort(true)
  if self.Tab == GameConfig.NewRecharge.TabDef.Hot then
    if self.innerSelectTab == self.innerTab.MixRecommend or self.innerSelectTab == self.innerTab.HiddenHeroGift then
      NewRechargeProxy.Instance:CallClientPayLog(104)
    elseif self.innerSelectTab == self.innerTab.Normal1 then
      NewRechargeProxy.Instance:CallClientPayLog(105)
    elseif self.innerSelectTab == self.innerTab.Normal2 then
      NewRechargeProxy.Instance:CallClientPayLog(106)
    end
  end
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end

function NewRechargeTHotSubView:OnReceiveQueryShopConfigCmd(message)
  self:InitData()
  self:UpdateViewGoods(false)
  if self.jumpToIndex and self.jumpToIndex > 0 then
    local listCtrl
    if self.innerSelectTab == self.innerTab.MixRecommend or self.innerSelectTab == self.innerTab.HiddenHeroGift then
      listCtrl = self.type0CellListCtrl
    elseif self.innerSelectTab == self.innerTab.Normal1 then
      listCtrl = self.type1CellListCtrl
    elseif self.innerSelectTab == self.innerTab.Normal2 then
      listCtrl = self.type2CellListCtrl
    end
    listCtrl:ScrollToIndex(self.jumpToIndex)
    local cells = listCtrl:GetCells()
    local cell = cells[self.jumpToIndex]
    if cell then
      cell:Pre_Purchase()
    end
    self.jumpToIndex = nil
  end
  self:UpdateRedTips()
end

function NewRechargeTHotSubView:OnReceiveUpdateShopGotItem(data)
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end

function NewRechargeTHotSubView:Init(manually)
  if self.inited then
    return
  end
  if self.manuallyInit and not manually then
    return
  end
  self:FindObjs()
  self:Func_AddListenEvent()
  self:InitView()
  self:RequestQuerySpeedUp()
  self.inited = true
end

function NewRechargeTHotSubView:InitView()
  self:LoadInnerSelector(GameConfig.NewRecharge.Tabs[self.Tab].Inner)
  self:UpdateRedTips()
  self:RefreshView(self.innerSelect_validIndex[1])
end

function NewRechargeTHotSubView:LoadInnerSelector(_list)
  if not self.innerSelect_validIndex then
    self.innerSelect_validIndex = {}
  else
    TableUtility.ArrayClear(self.innerSelect_validIndex)
  end
  self.heroGiftInnerSelectorLoaded = nil
  local list = {}
  for i = 1, #_list do
    local item = _list[i]
    if item.Invalid ~= true then
      if item.ID == NewRechargeTHotSubView.innerTab.HiddenHeroGift then
        if NewRechargeProxy.Instance:GetShouldShowHeroGift() then
          TableUtility.ArrayPushBack(list, item)
          self.heroGiftInnerSelectorLoaded = true
        end
      else
        local dataList
        if item.ID == NewRechargeTHotSubView.innerTab.MixRecommend then
          dataList = NewRechargeProxy.Instance:THot_GetHotMixItemList()
        else
          dataList = NewRechargeProxy.Instance:THot_GetHotItemList(item.ID)
        end
        if dataList ~= nil and 0 < #dataList then
          TableUtility.ArrayPushBack(list, item)
        end
      end
    end
  end
  for i = 1, #list do
    TableUtility.ArrayPushBack(self.innerSelect_validIndex, list[i].ID)
  end
  self.innerSelectListCtrl:ResetDatas(list, nil, true)
  self.innerSelectLine.width = #self.innerSelect_validIndex * self:getSelectorLen()
end

function NewRechargeTHotSubView:RefreshView(selectInnerTab)
  NewRechargeTHotSubView.super.RefreshView(self, selectInnerTab)
  self:InitData()
  self:LoadView()
  self:SelectInnerSelector()
end

function NewRechargeTHotSubView:InitData()
  if self.innerSelectTab == self.innerTab.MixRecommend then
    self.itemList_r = NewRechargeProxy.Instance:THot_GetHotMixItemList()
  elseif self.innerSelectTab == self.innerTab.HiddenHeroGift then
    self.itemList_r = NewRechargeProxy.Instance:THot_GetHotHeroGiftList()
  else
    self.itemList_r = NewRechargeProxy.Instance:THot_GetHotItemList(self.innerSelectTab)
  end
  local jumpToShopId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.jumpToShopItem
  if jumpToShopId then
    for i = 1, #jumpToShopId do
      local shopid = jumpToShopId[i]
      _, self.jumpToIndex = TableUtility.ArrayFindByPredicate(self.itemList_r, function(v, args)
        return v.ShopID == args
      end, shopid)
      if self.jumpToIndex > 0 then
        break
      end
    end
  end
  self.shopItemDatas = NewRechargeProxy.Instance:GetShopConf()
  if self.arrShopItemData == nil then
    self.arrShopItemData = {}
  end
  TableUtility.ArrayClear(self.arrShopItemData)
  for k, v in pairs(self.shopItemDatas) do
    table.insert(self.arrShopItemData, v)
  end
  table.sort(self.arrShopItemData, function(x, y)
    return x.ShopOrder < y.ShopOrder
  end)
end

function NewRechargeTHotSubView:FindObjs()
  self.gameObject = self:FindGO("NewRechargeTHotSubView")
  NewRechargeTHotSubView.super.FindObjs(self)
  local goodsList = self:FindGO("GoodsList", self.gameObject)
  self.type0CellListContainer = self:FindComponent("Table0", UITable, goodsList)
  self.type0CellListCtrl = UIGridListCtrl.new(self.type0CellListContainer, NewRechargeTHotMixGoodsCell, "NewRechargeTHotMixGoodsCell")
  self.type0CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type0CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.type0CellListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_ShowTip, self.ShowCombinePackItemTip, self)
  self.type0CellListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_PrePurchase, self.PrePurchase_CombinePack, self)
  self.type0CellListCtrl:AddEventListener(NewRechargeEvent.RemoveTimeEnd, self.LoadView, self)
  self.type1CellListContainer = self:FindComponent("Table1", UIGrid, goodsList)
  self.type1CellListCtrl = UIGridListCtrl.new(self.type1CellListContainer, NewRechargeRecommendTShopGoodsCell, "NewRechargeCommonGoodsCellType1")
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.RemoveTimeEnd, self.LoadView, self)
  self.type2CellListContainer = self:FindComponent("Table2", UIGrid, goodsList)
  self.type2CellListCtrl = UIGridListCtrl.new(self.type2CellListContainer, NewRechargeNormalTShopGoodsCell, "NewRechargeCommonGoodsCellType2")
  self.type2CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type2CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.type3CellListContainer = self:FindComponent("Table3", UITable, goodsList)
  self.type3CellListCtrl = UIGridListCtrl.new(self.type3CellListContainer, NewRechargeCombinePackCell, "NewRechargeCombinePackCell")
  self.type3CellListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_ShowTip, self.ShowCombinePackItemTip, self)
  self.type3CellListCtrl:AddEventListener(NewRechargeEvent.CombinePackItemCell_PrePurchase, self.PrePurchase_CombinePack, self)
  self.type3CellListCtrl:AddEventListener(NewRechargeEvent.RemoveTimeEnd, self.LoadView, self)
  local cellTableScrollView = goodsList:GetComponent(UIScrollView)
  local cellTableScrollBar = cellTableScrollView.horizontalScrollBar
  local leftTriggerAction = function(invoker, switchIndex)
    local trueIndex = TableUtility.ArrayFindIndex(self.innerSelect_validIndex, self.innerSelectTab)
    local newIndex = (switchIndex + trueIndex - 1) % #self.innerSelect_validIndex + 1
    newIndex = self.innerSelect_validIndex[newIndex]
    self:RefreshView(newIndex)
  end
  self:ResetScrollUpdateParams(cellTableScrollView, cellTableScrollBar, leftTriggerAction, -1, leftTriggerAction, 1)
  self.cellTableScrollView = cellTableScrollView
end

function NewRechargeTHotSubView:ShowShopItemPurchaseDetail(data)
  local subId = data.info and data.info.id
  if self.redTipCellMap[subId] then
    local redIdMap = self.redTipCellMap[subId].__RedIdMap
    if redIdMap then
      for redId, _ in pairs(redIdMap) do
        RedTipProxy.Instance:SeenNew(redId, subId)
      end
    end
  elseif self.redTipSeenMap and self.redTipSeenMap[subId] then
    for redId, _ in pairs(self.redTipSeenMap[subId]) do
      RedTipProxy.Instance:SeenNew(redId, subId)
    end
  end
  NewRechargeTHotSubView.super.ShowShopItemPurchaseDetail(self, data)
end

function NewRechargeTHotSubView:LoadView()
  self:UpdateViewGoods(true)
end

function NewRechargeTHotSubView:UpdateViewGoods(retPos)
  self:UnRegisterCellRedTip()
  local containerType = -1
  if self.innerSelectTab == self.innerTab.MixRecommend or self.innerSelectTab == self.innerTab.HiddenHeroGift then
    containerType = 0
  elseif self.innerSelectTab == self.innerTab.Normal1 then
    containerType = 1
  elseif self.innerSelectTab == self.innerTab.Normal2 then
    containerType = 2
  end
  self.type0CellListContainer.gameObject:SetActive(containerType == 0)
  self.type1CellListContainer.gameObject:SetActive(containerType == 1)
  self.type2CellListContainer.gameObject:SetActive(containerType == 2)
  self.type3CellListContainer.gameObject:SetActive(false)
  local listctrl
  if containerType == 0 then
    self.type0CellListCtrl:ResetDatas(self.itemList_r)
    if retPos then
      self.type0CellListCtrl:ResetPosition()
    end
    listctrl = self.type0CellListCtrl
    self:RegisterCellRedByCtrl(self.type0CellListCtrl)
    self:FocusAdviseGoods_MixRecommend(retPos)
  elseif containerType == 1 then
    self.type1CellListCtrl:ResetDatas(self.itemList_r)
    if retPos then
      self.type1CellListCtrl:ResetPosition()
    end
    listctrl = self.type1CellListCtrl
    self:RegisterCellRedByCtrl(self.type1CellListCtrl)
  else
    self.type2CellListCtrl:ResetDatas(self.itemList_r)
    if retPos then
      self.type2CellListCtrl:ResetPosition()
    end
    listctrl = self.type2CellListCtrl
    self:RegisterCellRedByCtrl(self.type2CellListCtrl)
  end
  if #self.itemList_r == 1 and self.gameObject.activeSelf then
    local cell = listctrl:GetCells()[1]
    if cell.data._mix_type == 1 then
      self:ShowShopItemGiftRightDetail()
    elseif cell.goodsType and cell.goodsType == NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit then
      self:ShowShopItemGiftRightDetail({
        info = cell.info
      }, cell.gameObject.transform, {290, 50})
    else
      self:ShowShopItemGiftRightDetail({
        info = cell.info.shopItemData
      }, cell.gameObject.transform, {290, 50})
    end
  else
    self:ShowShopItemGiftRightDetail()
  end
  self:ResetScrollBarTriggerSize()
end

function NewRechargeTHotSubView:UpdateRedTips()
  local cells = self.innerSelectListCtrl:GetCells()
  for i = 1, #cells do
    local ret, array = NewRechargeProxy.Instance:GetTHotPage_RedTip(cells[i].data.ID)
    if ret then
      for j = 1, #array do
        self:RegisterRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, cells[i].gameObject, 9, {-30, -16}, nil, array[j])
      end
    end
  end
end

function NewRechargeTHotSubView:ShowCombinePackItemTip(pinfo)
  if self.m_packTipCell == nil then
    if self.m_goPackTipView == nil then
      self.m_goPackTipView = self:LoadPreferb("cell/NewRechargeCombinePackTipCell", self.gameObject, true)
    end
    self.m_packTipCell = NewRechargeCombinePackTipCell.new(self.m_goPackTipView)
  end
  self:onShowPackTipView(true)
  local cell = pinfo.cell
  local list = pinfo.list
  self.m_packTipCell:SetData(cell.info.shopItemData, cell, list)
end

function NewRechargeTHotSubView:PrePurchase_CombinePack(cell)
  NewRechargeProxy.Instance:UseLastSort(true)
  local selectedCnt, fullCnt, current_items = cell:GetSelectSatatus()
  if 0 < selectedCnt and selectedCnt == fullCnt then
    local flag, func = cell:IsHaveEnoughVirtualCurrency()
    if not flag and func ~= nil then
      func()
      return
    end
    local md5 = Table_PackageSale.MD5 or ""
    FunctionSecurity.Me():NormalOperation(function(price)
      ServiceSessionShopProxy.Instance:CallBuyPackageSaleShopCmd(cell.u_itemPrice.text, cell.data.staticData.id, md5, current_items)
    end)
    return
  end
  MsgManager.ConfirmMsgByID(43454, function()
    local flag, func = cell:IsHaveEnoughVirtualCurrency()
    if not flag and func ~= nil then
      func()
      return
    end
    local md5 = Table_PackageSale.MD5 or ""
    FunctionSecurity.Me():NormalOperation(function(price)
      ServiceSessionShopProxy.Instance:CallBuyPackageSaleShopCmd(cell.u_itemPrice.text, cell.data.staticData.id, md5, current_items)
    end)
  end)
  do return end
  local shop_item_data = cell.data
  if self.m_packPurchaseCell == nil then
    if self.m_goPackPurchaseView == nil then
      self.m_goPackPurchaseView = self:LoadPreferb("cell/NewRechargeCombinePackPurchaseCell", self.gameObject, true)
    end
    self.m_packPurchaseCell = NewRechargeCombinePackPurchaseCell.new(self.m_goPackPurchaseView)
  end
  self:onShowPackPurchaseView(true)
  self.m_packPurchaseCell:SetData(shop_item_data)
end

function NewRechargeTHotSubView:onShowPackTipView(value)
  if self.m_goPackTipView then
    self.m_goPackTipView:SetActive(value)
  end
end

function NewRechargeTHotSubView:onShowPackPurchaseView(value)
  if self.m_goPackPurchaseView then
    self.m_goPackPurchaseView:SetActive(value)
  end
end

function NewRechargeTHotSubView:OnReceiveCombinePackListForceRefresh(reposition)
  if self.innerSelectTab == self.innerTab.MixRecommend or self.innerSelectTab == self.innerTab.HiddenHeroGift then
    self.type0CellListCtrl:ResetDatas(self.itemList_r)
    if reposition then
      self.type0CellListCtrl:ResetPosition()
    end
  end
end

function NewRechargeTHotSubView:FocusAdviseGoods_MixRecommend(retPos)
  local combinePackAdvise = self.container and self.container.viewdata and self.container.viewdata.viewdata and self.container.viewdata.viewdata.combinePackAdvise
  if combinePackAdvise then
    self.container.viewdata.viewdata.combinePackAdvise = nil
    local cells, cell = self.type0CellListCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data._mix_type == 1 and cells[i].data.staticData.id == combinePackAdvise then
        cell = cells[i]
        break
      end
    end
    if cell then
      local panel = self.cellTableScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      if offset.x == 0 then
        if retPos then
          self.type0CellListCtrl:ResetPosition()
        end
      else
        offset = LuaGeometry.GetTempVector3(offset.x, 0, 0)
        self.cellTableScrollView:MoveRelative(offset)
      end
    elseif retPos then
      self.type0CellListCtrl:ResetPosition()
    end
  elseif retPos then
    self.type0CellListCtrl:ResetPosition()
  end
end
