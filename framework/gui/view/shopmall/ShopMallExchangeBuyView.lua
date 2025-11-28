autoImport("ShopMallExchangeTypesCombineCell")
autoImport("ShopMallExchangeClassifyCombineCell")
autoImport("ShopMallExchangeDetailCombineCell")
autoImport("PreorderCombineCell")
ShopMallExchangeBuyView = class("ShopMallExchangeBuyView", SubView)
local OutlineColor = {
  Normal = Color(0.6196078431372549, 0.33725490196078434, 0),
  Grey = Color(0.3686274509803922, 0.3686274509803922, 0.3686274509803922)
}
local SpriteColor = {
  Normal = Color(1, 1, 1),
  Grey = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
}
local RecommendCategoryType = {
  [50007] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_SHIELD,
  [50008] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_ARMOUR,
  [50009] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_ROBE,
  [50010] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_SHOES,
  [50011] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_ACCESSORY1,
  [50006] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_WEAPON,
  [50012] = RecordTrade_pb.ETRADERECOMMEND_CATEGORY_CARD
}

function ShopMallExchangeBuyView:OnExit()
  if self.safeLT then
    self.safeLT:Destroy()
    self.safeLT = nil
  end
  if self.refineDelayTimer then
    self.refineDelayTimer:Destroy()
    self.refineDelayTimer = nil
  end
  if self.priceSortDelayTime then
    self.priceSortDelayTime:Destroy()
    self.priceSortDelayTime = nil
  end
  for i = 1, #self.detailWrapHelper:GetCellCtls() do
    self.detailWrapHelper:GetCellCtls()[i]:OnDestroy()
  end
  self.classifyScrollView.OnBackToStop = nil
  self.classifyScrollView.OnStop = nil
  self.classifyScrollView.OnPulling = nil
  self.classifyScrollView.OnRevertFinished = nil
  local cells = self.preorderWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:OnDestroy()
  end
  ShopMallExchangeBuyView.super.OnExit(self)
end

function ShopMallExchangeBuyView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvts()
  self:AddViewEvts()
end

function ShopMallExchangeBuyView:FindObjs()
  self.normalStick = self.container.normalStick
  self.buyView = self:FindGO("BuyView", self.container.exchangeView)
  self.searchBtn = self:FindGO("SearchBtn", self.buyView)
  self.typesTable = self:FindGO("TypesTable", self.buyView):GetComponent(UITable)
  self.money = self:FindGO("Money", self.buyView):GetComponent(UILabel)
  self.moneyIcon = self:FindGO("MoneyType", self.buyView):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.moneyIcon)
  self.classify = self:FindGO("Classify", self.buyView)
  self.detail = self:FindGO("Detail", self.buyView)
  self.turnLeft = self:FindGO("TurnLeft", self.buyView)
  self.turnRight = self:FindGO("TurnRight", self.buyView)
  self.page = self:FindGO("Page", self.buyView):GetComponent(UILabel)
  self.pageInput = self:FindGO("TurnPage"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.pageInput, 4)
  self.buyButton = self:FindGO("BuyButton", self.buyView)
  self.returnButton = self:FindGO("ReturnButton", self.buyView)
  self.buyButtonScale = self.buyButton:GetComponent(UIButtonScale)
  self.buyButtonSprite = self.buyButton:GetComponent(UISprite)
  self.buyLabel = self:FindGO("BuyLabel", self.buyButton):GetComponent(UILabel)
  self.selfProfession = self:FindGO("SelfProfession", self.classify):GetComponent(UIToggle)
  self.selfProfessionRoot = self:FindGO("SelfProfessionRoot")
  self.levelFilter = self:FindGO("LevelFilter", self.classify):GetComponent(UIPopupList)
  self.levelFilterRoot = self:FindGO("LevelFilterRoot")
  self.fashionFilter = self:FindGO("FashionFilter", self.classify):GetComponent(UIPopupList)
  self.fashionFilterRoot = self:FindGO("FashionFilterRoot")
  self.classifyTitle = self:FindGO("ClassifyTitle", self.classify):GetComponent(UILabel)
  self.classifyScrollView = self:FindGO("ClassifyScrollView"):GetComponent(ROUIScrollView)
  self.classifyContainer = self:FindGO("ClassifyContainer", self.classify)
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.emptyClassify = self:FindGO("Empty", self.classify)
  self.emptyLabelClassify = self:FindGO("EmptyLabel", self.classify):GetComponent(UILabel)
  self.tradeFilter = self:FindGO("TradeFilter", self.detail):GetComponent(UIPopupList)
  self.refineSortBtn = self:FindGO("RefineSortBtn", self.detail)
  self.priceSortBtn = self:FindGO("PriceSortBtn", self.detail)
  self.refineSortLabel = self:FindGO("RefineSortLabel", self.detail):GetComponent(UILabel)
  self.priceSortLabel = self:FindGO("PriceSortLabel", self.detail):GetComponent(UILabel)
  self.detailContainer = self:FindGO("DetailContainer", self.detail)
  self.emptyDetail = self:FindGO("Empty", self.detail)
  self.detailSortSelect = self:FindGO("SortSelect", self.detail)
  self.lock = self:FindGO("Lock", self.classify):GetComponent(UIToggle)
  self.lockRoot = self:FindGO("LockRoot")
  self.filterTable = self:FindGO("FilterTable"):GetComponent(UITable)
  self.preorderContainer = self:FindGO("PreorderContainer", self.buyView)
  self.preorderWrap = self:FindGO("PreorderWrap", self.preorderContainer)
  self.preorderScrollView = self:FindGO("PreorderScrollView", self.preorderContainer):GetComponent(UIScrollView)
  self.unlockPreorderBtn = self:FindGO("UnlockPreorderBtn", self.preorderContainer)
  self.preorderButton = self:FindGO("PreorderButton")
  self.unlockPreorderBtn:SetActive(not ShopMallPreorderProxy.Instance:IsFunctionUnlocked())
  self.preorderHelpButton = self:FindGO("PreorderHelpButton")
  self:TryOpenHelpViewById(35279, nil, self.preorderHelpButton)
  self.preorderTip = self:FindGO("preorderTip"):GetComponent(UILabel)
  self.preorderTip.text = ZhString.ShopMallPreorder_UnlockTip
  self.detailName = self:FindGO("DetailName", self.detail):GetComponent(UILabel)
end

function ShopMallExchangeBuyView:AddEvts()
  self:AddClickEvent(self.searchBtn, function(g)
    self:ClickSearchBtn()
  end)
  self:AddClickEvent(self.turnLeft, function(g)
    self:ClickTurnLeft()
  end)
  self:AddClickEvent(self.turnRight, function(g)
    self:ClickTurnRight()
  end)
  EventDelegate.Set(self.pageInput.onSubmit, function()
    self:PageInputOnSubmit()
  end)
  self:AddClickEvent(self.buyButton, function(g)
    self:ClickBuyButton()
  end)
  self:AddClickEvent(self.returnButton, function(g)
    self:ClickReturnButton()
  end)
  self:AddClickEvent(self.preorderButton, function(g)
    self:ClickPreorderButton()
  end)
  self:AddClickEvent(self.unlockPreorderBtn, function()
    self:ClickUnlockPreorderButton()
  end)
  local delayTime = 5000
  self:AddClickEvent(self.refineSortBtn, function(g)
    if not BranchMgr.IsSEA() or not self.refineDelayTimer then
      self.refineDelayTimer = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        self.refineDelayTimer = nil
      end, self)
      self:ClickRefineSortBtn()
    else
      MsgManager.FloatMsg(nil, ZhString.TouchSoFast)
    end
  end)
  self:AddClickEvent(self.priceSortBtn, function(g)
    if not BranchMgr.IsSEA() or not self.priceSortDelayTime then
      self.priceSortDelayTime = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        self.priceSortDelayTime = nil
      end, self)
      self:ClickPriceSortBtn()
    else
      MsgManager.FloatMsg(nil, ZhString.TouchSoFast)
    end
  end)
  EventDelegate.Add(self.selfProfession.onChange, function()
    if self.isSelfProfession ~= self.selfProfession.value then
      self.isSelfProfession = self.selfProfession.value
      self:UpdateClassifyBySelfProfessionAndLevelFilter()
    end
  end)
  EventDelegate.Add(self.levelFilter.onChange, function()
    if self.levelFilter.data == nil then
      return
    end
    if self.filter == ShopMallFilterEnum.Level and self.levelFilterData ~= self.levelFilter.data then
      self.levelFilterData = self.levelFilter.data
      self:CallClassify()
    end
  end)
  EventDelegate.Add(self.fashionFilter.onChange, function()
    if self.fashionFilter.data == nil then
      return
    end
    if self.filter == ShopMallFilterEnum.Fashion and self.fashionFilterData ~= self.fashionFilter.data then
      self.fashionFilterData = self.fashionFilter.data
      self:CallClassify()
    end
  end)
  EventDelegate.Add(self.tradeFilter.onChange, function()
    if self.tradeFilter.data == nil then
      return
    end
    if self.tradeFilterData ~= self.tradeFilter.data then
      self.tradeFilterData = self.tradeFilter.data
      self:CallDetailList()
    end
  end)
  local scrollView = self:FindGO("DetailScrollView"):GetComponent(UIScrollView)
  NGUIUtil.HelpChangePageByDrag(scrollView, function()
    self:ClickTurnLeft()
  end, function()
    self:ClickTurnRight()
  end, 50)
  
  function self.classifyScrollView.OnBackToStop()
    self.waitting.text = ZhString.ShopMall_ExchangeRefreshing
  end
  
  function self.classifyScrollView.OnStop()
    if self.currentTypeData then
      if self.safeLT then
        self.safeLT:Destroy()
        self.safeLT = nil
      end
      self.safeLT = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
        self.safeLT = nil
        self:UpdateClassify()
      end, self)
      if RecommendCategoryType[self.currentTypeData.id] then
        self:CallRecommendItems(RecommendCategoryType[self.currentTypeData.id])
      else
        self:CallClassify()
      end
    end
  end
  
  function self.classifyScrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and ZhString.ShopMall_ExchangePullRefresh or ZhString.ShopMall_ExchangeCanRefresh
  end
  
  function self.classifyScrollView.OnRevertFinished()
    self.waitting.text = ZhString.ShopMall_ExchangePullRefresh
  end
  
  EventDelegate.Add(self.lock.onChange, function()
    if self.isFiltertingLock ~= self.lock.value then
      self.isFiltertingLock = self.lock.value
      self:UpdateClassify()
    end
  end)
end

function ShopMallExchangeBuyView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateRoleData)
  self:AddListenEvt(ServiceEvent.RecordTradeBriefPendingListRecordTradeCmd, self.RecvClassifyList)
  self:AddListenEvt(ServiceEvent.RecordTradeHotItemidRecordTrade, self.UpdateClassify)
  self:AddListenEvt(ServiceEvent.RecordTradeDetailPendingListRecordTradeCmd, self.RecvDetailList)
  self:AddListenEvt(ServiceEvent.RecordTradeBuyItemRecordTradeCmd, self.RecvBuyItem)
  self:AddListenEvt(ShopMallEvent.ExchangeSearchOpenDetail, self.SearchOpenDetail)
  self:AddListenEvt(ShopMallEvent.ExchangeUpdateBuyView, self.UpdateView)
  self:AddListenEvt(ServiceEvent.RecordTradePreorderListRecordTradeCmd, self.UpdatePreorderView)
  self:AddListenEvt(ServiceEvent.RecordTradePreorderItemRecordTradeCmd, self.UpdatePreorderView)
  self:AddListenEvt(ServiceEvent.RecordTradeTodayFinanceRank, self.UpdateClassify)
  self:AddListenEvt(ServiceEvent.RecordTradeRecommendItemTradeCmd, self.UpdateClassify)
end

function ShopMallExchangeBuyView:InitShow()
  self.isSelfProfession = true
  self.isRefineSortDes = true
  self.isPriceSortDes = false
  self.rolelevel = MyselfProxy.Instance:RoleLevel()
  self.rankType = RecordTrade_pb.RANKTYPE_ITEM_PRICE_INC
  ShopMallProxy.Instance:ResetExchangeBuyClassify()
  self:ResetPage()
  self:InitPreorder()
  self:ShowClassifyView(true)
  self.typesListCtl = UIGridListCtrl.new(self.typesTable, ShopMallExchangeTypesCombineCell, "ShopMallExchangeTypesCombineCell")
  self.typesListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTypes, self)
  self.typesListCtl:AddEventListener(ShopMallEvent.ExchangeClickFatherTypes, self.ClickFatherTypes, self)
  local data = {
    wrapObj = self.classifyContainer,
    pfbNum = 5,
    cellName = "ShopMallExchangeClassifyCombineCell",
    control = ShopMallExchangeClassifyCombineCell,
    dir = 1
  }
  self.classifyWrapHelper = WrapCellHelper.new(data)
  self.classifyWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickClassify, self)
  self.classifyWrapHelper:AddEventListener(ShopMallEvent.ExchangeClassifyClickIcon, self.ClickClassifyIcon, self)
  TableUtility.TableClear(data)
  data.wrapObj = self.detailContainer
  data.pfbNum = 5
  data.cellName = "ShopMallExchangeDetailCombineCell"
  data.control = ShopMallExchangeDetailCombineCell
  data.dir = 1
  self.detailWrapHelper = WrapCellHelper.new(data)
  self.detailWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self:UpdateTypes()
  if self.viewdata.viewdata and self.viewdata.viewdata.searchId then
    self:SelectTypes(self.viewdata.viewdata.searchId)
  else
    self.selfProfessionRoot:SetActive(false)
    self.levelFilterRoot:SetActive(false)
    self.fashionFilterRoot:SetActive(false)
    self.classifyTitle.gameObject:SetActive(false)
    self.classifyScrollView.enabled = false
    self.lockRoot:SetActive(false)
    self.filterTable:Reposition()
  end
  self:InitFilter()
  self:UpdateGold()
  if self.viewdata.viewdata and self.viewdata.viewdata.searchId then
    TableUtility.TableClear(data)
    data.data = self.viewdata.viewdata.searchId
    self:ClickClassify(data)
  end
  self.preorderButton:SetActive(ShopMallPreorderProxy.Instance:IsFunctionUnForbidden())
end

function ShopMallExchangeBuyView:InitTypes()
  local typesCells = self.typesListCtl:GetCells()
  if 0 < #typesCells then
    local cellCtl = typesCells[1]
    cellCtl:ClickFather(cellCtl)
    local childData = ShopMallProxy.Instance:GetExchangeBuyChildTypes(cellCtl.data.id)
    if childData then
      local childCells = cellCtl.childCtl:GetCells()
      if 0 < #childCells then
        local childCellCtl = cellCtl.childCtl:GetCells()[1]
        cellCtl:ClickChild(childCellCtl)
      end
    end
  end
end

function ShopMallExchangeBuyView:InitFilter()
  self.levelFilter:Clear()
  self.fashionFilter:Clear()
  self.tradeFilter:Clear()
  local rangeList = ShopMallProxy.Instance:GetExchangeFilter(GameConfig.Exchange.ExchangeLevel)
  for i = 1, #rangeList do
    local rangeData = GameConfig.Exchange.ExchangeLevel[rangeList[i]]
    local str
    if rangeData.name then
      str = rangeData.name
    else
      str = string.format(ZhString.ShopMall_ExchangeLevelFilter, tostring(rangeData.minlv), tostring(rangeData.maxlv))
    end
    self.levelFilter:AddItem(str, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.levelFilterData = range
    local rangeData = GameConfig.Exchange.ExchangeLevel[range]
    if rangeData.name then
      self.levelFilter.value = rangeData.name
    else
      self.levelFilter.value = string.format(ZhString.ShopMall_ExchangeLevelFilter, tostring(rangeData.minlv), tostring(rangeData.maxlv))
    end
  end
  rangeList = ShopMallProxy.Instance:GetExchangeFilter(GameConfig.Exchange.ExchangeFashion)
  for i = 1, #rangeList do
    local rangeData = GameConfig.Exchange.ExchangeFashion[rangeList[i]]
    self.fashionFilter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.fashionFilterData = range
    local rangeData = GameConfig.Exchange.ExchangeFashion[range]
    self.fashionFilter.value = rangeData
  end
  rangeList = ShopMallProxy.Instance:GetExchangeFilter(GameConfig.Exchange.ExchangeTrade)
  for i = 1, #rangeList do
    local rangeData = GameConfig.Exchange.ExchangeTrade[rangeList[i]]
    self.tradeFilter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.tradeFilterData = range
    local rangeData = GameConfig.Exchange.ExchangeTrade[range]
    self.tradeFilter.value = rangeData
  end
end

function ShopMallExchangeBuyView:SelectTypes(itemId)
  local parent, child = ShopMallProxy.Instance:GetExchangeParentAndChildType(itemId)
  if parent then
    local parentCell = self:GetParentTypeCellById(parent)
    if parentCell then
      parentCell:ClickFather(parentCell, true)
      if child then
        local childCell = self:GetChildTypeCellById(parentCell, child)
        if childCell then
          parentCell:ClickChild(childCell)
        end
      end
    end
  end
end

function ShopMallExchangeBuyView:ClickSearchBtn()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ShopMallExchangeSearchView
  })
end

function ShopMallExchangeBuyView:ClickTurnLeft()
  local page = self.currentPage - 1
  if 1 <= page then
    if self:CheckLimitCallDetail() then
      MsgManager.ShowMsgByID(49)
      return
    end
    self.currentPage = page
    self:CallDetailList()
    self:SetLimitCallDetail()
  end
end

function ShopMallExchangeBuyView:ClickTurnRight()
  local page = self.currentPage + 1
  if page <= ShopMallProxy.Instance:GetExchangeBuyDetailTotalPageCount() then
    if self:CheckLimitCallDetail() then
      MsgManager.ShowMsgByID(49)
      return
    end
    self.currentPage = page
    self:CallDetailList()
    self:SetLimitCallDetail()
  end
end

function ShopMallExchangeBuyView:PageInputOnSubmit()
  if #self.pageInput.value > 0 then
    local value = tonumber(self.pageInput.value)
    local totalPage = ShopMallProxy.Instance:GetExchangeBuyDetailTotalPageCount()
    if value < 1 then
      value = 1
    elseif totalPage < value then
      value = totalPage
    end
    self.currentPage = value
    self:UpdatePage()
    self:CallDetailList()
  end
end

function ShopMallExchangeBuyView:ClickBuyButton()
  if self.currentDetalCell and self.currentDetalCell.data then
    if self.currentDetalCell.data.isEmpty then
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopMallExchangeBuyInfoView,
      viewdata = {
        data = self.currentDetalCell.data
      }
    })
  else
    MsgManager.ShowMsgByIDTable(10114)
  end
end

function ShopMallExchangeBuyView:ClickReturnButton()
  self:ShowClassifyView(true)
end

function ShopMallExchangeBuyView:ClickRefineSortBtn()
  if self:CheckLimitCallDetail() then
    MsgManager.ShowMsgByID(49)
    return
  end
  local icon = ""
  self.isRefineSortDes = not self.isRefineSortDes
  if self.isRefineSortDes then
    icon = ZhString.ShopMall_ExchangeSortDes
    self.rankType = RecordTrade_pb.RANKTYPE_REFINE_LV_INC
  else
    icon = ZhString.ShopMall_ExchangeSortInc
    self.rankType = RecordTrade_pb.RANKTYPE_REFINE_LV_DES
  end
  self:UpdateDetailSortSelect(self.refineSortBtn.transform)
  self:CallDetailList()
  self:SetLimitCallDetail()
  self.refineSortLabel.text = ZhString.ShopMall_ExchangeRefine .. icon
end

function ShopMallExchangeBuyView:ClickPriceSortBtn()
  if self:CheckLimitCallDetail() then
    MsgManager.ShowMsgByID(49)
    return
  end
  local icon = ""
  self.isPriceSortDes = not self.isPriceSortDes
  if self.isPriceSortDes then
    icon = ZhString.ShopMall_ExchangeSortDes
    self.rankType = RecordTrade_pb.RANKTYPE_ITEM_PRICE_INC
  else
    icon = ZhString.ShopMall_ExchangeSortInc
    self.rankType = RecordTrade_pb.RANKTYPE_ITEM_PRICE_DES
  end
  self:UpdateDetailSortSelect(self.priceSortBtn.transform)
  self:CallDetailList()
  self:SetLimitCallDetail()
  self.priceSortLabel.text = ZhString.ShopMall_ExchangePrice .. icon
end

function ShopMallExchangeBuyView:ClickTypes(cellCtl)
  if cellCtl.data then
    if self:CheckLimitCallClassify() then
      MsgManager.ShowMsgByID(49)
      return
    end
    if self.nowFather then
      self:UpdateClassifyOption(self.nowFather.cellCtl)
    end
    self:ShowClassifyView(true)
    ShopMallProxy.Instance:CallTodayFinanceRank(4, 0)
    self.classifyTitle.text = string.format(ZhString.ShopMall_ExchangeClassify, cellCtl.data.name)
    self.currentTypeData = cellCtl.data
    self:ResetPage()
    if self.nowTypes ~= cellCtl then
      if cellCtl.data.id == 50004 then
        self:ClickPreorderFilter()
        self:ShowPreorderView(true)
      else
        self:ShowClassifyView(true)
        self:ResetSelfProfession()
        self:ResetLockFilter()
        if RecommendCategoryType[cellCtl.data.id] then
          self:CallRecommendItems(RecommendCategoryType[cellCtl.data.id])
        else
          self:UpdateClassifyBySelfProfessionAndLevelFilter()
        end
      end
    elseif cellCtl.data.id == 50004 then
      self:ClickPreorderFilter()
      self:ShowPreorderView(true)
    else
      self:ShowClassifyView(true)
      if RecommendCategoryType[cellCtl.data.id] then
        self:CallRecommendItems(RecommendCategoryType[cellCtl.data.id])
      else
        self:CallClassify()
      end
    end
    self:SetLimitCallClassify()
    self.nowTypes = cellCtl
  end
end

function ShopMallExchangeBuyView:ClickFatherTypes(param)
  if self.nowFather and param.cellCtl ~= self.nowFather.cellCtl then
    self.nowFather.combine:SetChoose(false)
    if self.nowFather.combine.animDir then
      self.nowFather.combine:PlayAnim(not self.nowFather.combine.animDir)
    end
  end
  self.nowFather = param
  self.nowFather.combine:SetChoose(true)
end

function ShopMallExchangeBuyView:ClickClassify(cellCtl, id)
  if cellCtl.data then
    if self:CheckLimitCallDetail() then
      MsgManager.ShowMsgByID(49)
      return
    end
    self:ShowClassifyView(false)
    if id == nil then
      id = cellCtl.data.id
    end
    self.currentDetailId = id
    self:ResetRank()
    self:ResetPage()
    self:CallDetailList()
    self:SetLimitCallDetail()
    ShopMallProxy.Instance:ResetExchangeBuyDetail()
    self:UpdateDetail()
    self:UpdateDetailOption(cellCtl)
  end
end

local tipOffset = {-210, 0}

function ShopMallExchangeBuyView:ClickClassifyIcon(tipData)
  local tip = self:ShowItemTip(tipData, self.normalStick, nil, tipOffset)
  if tip then
    tip:HideShowUpBtn()
  end
end

function ShopMallExchangeBuyView:ClickDetail(cellCtl)
  if self.currentDetalCell and self.currentDetalCell ~= cellCtl then
    self.currentDetalCell:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.currentDetalCell = cellCtl
  self:ActiveBuyButton(not self.currentDetalCell.data.isEmpty)
end

function ShopMallExchangeBuyView:ActiveBuyButton(active)
  self.buyButtonScale.enabled = active == true
  if active then
    self.buyLabel.effectColor = OutlineColor.Normal
    self.buyButtonSprite.color = SpriteColor.Normal
  else
    self.buyLabel.effectColor = OutlineColor.Grey
    self.buyButtonSprite.color = SpriteColor.Grey
  end
end

function ShopMallExchangeBuyView:UpdateClassifyBySelfProfessionAndLevelFilter()
  self:CallClassify(data)
end

function ShopMallExchangeBuyView:UpdateTypes()
  local types = ShopMallProxy.Instance:GetExchangeBuyParentTypes()
  self.typesListCtl:ResetDatas(types)
end

function ShopMallExchangeBuyView:CallClassify(data)
  local profession = 0
  if self.isSelfProfession then
    profession = MyselfProxy.Instance:GetMyProfession()
  end
  ServiceRecordTradeProxy.Instance:CallBriefPendingListRecordTradeCmd(Game.Myself.data.id, self.currentTypeData.id, profession, self.fashionFilterData)
end

function ShopMallExchangeBuyView:UpdateClassify()
  local data = ShopMallProxy.Instance:GetExchangeBuyClassify(self.isFiltertingLock, self.currentTypeData and self.currentTypeData.id)
  local isEmpty = #data <= 0
  self.emptyClassify:SetActive(isEmpty)
  self.emptyLabelClassify.text = ZhString.ShopMall_ExchangeBuyEmpty
  self.classifyTitle.gameObject:SetActive(not isEmpty)
  local newData = self:ReUniteCellData(data, 2)
  self.classifyWrapHelper:UpdateInfo(newData)
  self.classifyWrapHelper:ResetPosition()
  self.classifyScrollView:Revert()
  self.classifyScrollView.enabled = not isEmpty
end

local emptyCellData = {}

function ShopMallExchangeBuyView:_Searching()
  self.classifyTitle.gameObject:SetActive(false)
  self.emptyClassify:SetActive(true)
  self.emptyLabelClassify.text = ZhString.ShopMall_ExchangeBuySearching
  self.classifyWrapHelper:UpdateInfo(emptyCellData)
  self.classifyWrapHelper:ResetPosition()
end

function ShopMallExchangeBuyView:UpdateDetail(isShowEmpty)
  local detail = ShopMallProxy.Instance:GetExchangeBuyDetail()
  self:ActiveBuyButton(true)
  if isShowEmpty then
    if 0 < #detail then
      self.emptyDetail:SetActive(false)
      self.pageInput.gameObject:SetActive(true)
    elseif not ShopMallPreorderProxy.Instance:IsFunctionUnForbidden() then
      self.emptyDetailLabel = self:FindComponent("EmptyLabel", UILabel, self.emptyDetail)
      self.emptyDetailLabel.text = ZhString.ShopMall_ExchangeBuyEmpty
      self.emptyDetail:SetActive(true)
      self:ResetPage()
    else
      local fakedata = ShopMallItemData.new({
        itemid = self.currentDetailId or 0
      })
      fakedata.isEmpty = true
      fakedata.count = 1
      detail[1] = fakedata
      self.emptyDetail:SetActive(false)
      self:ActiveBuyButton(false)
      self.pageInput.gameObject:SetActive(false)
    end
  end
  local item = Table_Item[self.currentDetailId or 0]
  self.detailName.text = item and item.NameZh or ""
  local newData = self:ReUniteCellData(detail, 2)
  self.detailWrapHelper:UpdateInfo(newData)
  self.detailWrapHelper:ResetPosition()
  self.currentDetalCell = nil
end

function ShopMallExchangeBuyView:UpdateClassifyOption(cellCtl)
  if cellCtl.data.jobOption == 1 then
    self.selfProfessionRoot:SetActive(true)
  else
    self.selfProfessionRoot:SetActive(false)
    self.isSelfProfession = false
  end
  if cellCtl.data.LockOption == 1 then
    self.lockRoot:SetActive(true)
  else
    self.lockRoot:SetActive(false)
  end
  self.filterTable:Reposition()
  if cellCtl.data.levelOption == 1 then
    self.levelFilterRoot:SetActive(true)
    self.fashionFilterRoot:SetActive(false)
    self.filter = ShopMallFilterEnum.Level
  elseif cellCtl.data.levelOption == 2 then
    self.levelFilterRoot:SetActive(false)
    self.fashionFilterRoot:SetActive(true)
    self.filter = ShopMallFilterEnum.Fashion
  else
    self.levelFilterRoot:SetActive(false)
    self.fashionFilterRoot:SetActive(false)
    self.levelFilterData = nil
    self.fashionFilterData = nil
    self.filter = nil
  end
end

function ShopMallExchangeBuyView:UpdateDetailOption(cellCtl)
  if self.currentTypeData.refineOption == 1 then
    self.refineSortBtn:SetActive(true)
  else
    self.refineSortBtn:SetActive(false)
  end
end

function ShopMallExchangeBuyView:UpdateRoleData()
  self.rolelevel = MyselfProxy.Instance:RoleLevel()
  self:UpdateGold()
end

function ShopMallExchangeBuyView:UpdateGold()
  self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function ShopMallExchangeBuyView:UpdatePage()
  self.pageInput.value = self.currentPage
  self.page.text = "/" .. self.totalPage
end

function ShopMallExchangeBuyView:SetLimitCallClassify()
  self.limitCallClassify = UnityUnscaledTime
end

function ShopMallExchangeBuyView:ClearLimitCallClassify()
  self.limitCallClassify = nil
end

function ShopMallExchangeBuyView:CheckLimitCallClassify()
  if self.limitCallClassify ~= nil and UnityUnscaledTime - self.limitCallClassify < 1 then
    return true
  end
  return false
end

function ShopMallExchangeBuyView:SetLimitCallDetail()
  self.limitCallDetail = UnityUnscaledTime
end

function ShopMallExchangeBuyView:ClearLimitCallDetail()
  self.limitCallDetail = nil
end

function ShopMallExchangeBuyView:CheckLimitCallDetail()
  if self.limitCallDetail ~= nil and UnityUnscaledTime - self.limitCallDetail < 1 then
    return true
  end
  return false
end

local search_cond = {}

function ShopMallExchangeBuyView:CallDetailList()
  TableUtility.TableClear(search_cond)
  search_cond.item_id = self.currentDetailId
  search_cond.page_index = self.currentPage - 1
  if self.rankType then
    search_cond.rank_type = self.rankType
  end
  search_cond.trade_type = self.tradeFilterData
  if NetConfig.PBC then
    self:ManualCall(search_cond)
  else
    ServiceRecordTradeProxy.Instance:CallDetailPendingListRecordTradeCmd(search_cond, Game.Myself.data.id)
  end
end

function ShopMallExchangeBuyView:ManualCall(search_cond)
  local msg = RecordTrade_pb.DetailPendingListRecordTradeCmd()
  if search_cond ~= nil and search_cond.item_id ~= nil then
    msg.search_cond.item_id = search_cond.item_id
  end
  if search_cond ~= nil and search_cond.page_index ~= nil then
    msg.search_cond.page_index = search_cond.page_index
  end
  if search_cond ~= nil and search_cond.page_count ~= nil then
    msg.search_cond.page_count = search_cond.page_count
  end
  if search_cond ~= nil and search_cond.rank_type ~= nil then
    msg.search_cond.rank_type = search_cond.rank_type
  end
  if search_cond ~= nil and search_cond.trade_type ~= nil then
    msg.search_cond.trade_type = search_cond.trade_type
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if lists ~= nil then
    for i = 1, #lists do
      table.insert(msg.lists, lists[i])
    end
  end
  if total_page_count ~= nil then
    msg.total_page_count = total_page_count
  end
  ServiceRecordTradeProxy.Instance:SendProto(msg)
end

function ShopMallExchangeBuyView:RecvClassifyList()
  self:ClearLimitCallClassify()
  self:UpdateClassify()
end

function ShopMallExchangeBuyView:RecvDetailList()
  self:ClearLimitCallDetail()
  self.totalPage = ShopMallProxy.Instance:GetExchangeBuyDetailTotalPageCount()
  local pageIndex = ShopMallProxy.Instance:GetExchangeBuyDetailCurrentPageIndex()
  if pageIndex then
    self.currentPage = pageIndex + 1
  end
  self:UpdatePage()
  self:UpdateDetail(true)
end

function ShopMallExchangeBuyView:RecvBuyItem(note)
  local data = note.body
  if data.type == BoothProxy.TradeType.Exchange then
    self:CallDetailList()
  end
end

function ShopMallExchangeBuyView:SearchOpenDetail(note)
  local cell = note.body
  local id = cell.data
  self:SelectTypes(id)
  self:ClickClassify(cell, id)
end

function ShopMallExchangeBuyView:UpdateView()
  self:CallDetailList()
end

function ShopMallExchangeBuyView:ResetPage()
  self.currentPage = 1
  self.totalPage = 1
  self:UpdatePage()
end

function ShopMallExchangeBuyView:ResetRank()
  self.rankType = nil
  local icon = ZhString.ShopMall_ExchangeSortInc
  self.refineSortLabel.text = ZhString.ShopMall_ExchangeRefine .. icon
  self.priceSortLabel.text = ZhString.ShopMall_ExchangePrice .. icon
  self.detailSortSelect:SetActive(false)
  self.isRefineSortDes = false
  self.isPriceSortDes = false
end

function ShopMallExchangeBuyView:ResetSelfProfession()
  if self.selfProfessionRoot.activeInHierarchy then
    self.isSelfProfession = self.selfProfession.value
  end
end

function ShopMallExchangeBuyView:ResetLockFilter()
  if self.lockRoot.activeInHierarchy then
    self.isFiltertingLock = self.lock.value
  end
end

function ShopMallExchangeBuyView:ShowClassifyView(isShow)
  self.classify:SetActive(isShow)
  self.detail:SetActive(not isShow)
  self.preorderContainer:SetActive(false)
  self.filterTable:Reposition()
end

function ShopMallExchangeBuyView:GetParentTypeCellById(parentId)
  local typesCells = self.typesListCtl:GetCells()
  for i = 1, #typesCells do
    if typesCells[i].data.id == parentId then
      return typesCells[i]
    end
  end
  return nil
end

function ShopMallExchangeBuyView:GetChildTypeCellById(parentCell, childId)
  local childCells = parentCell.childCtl:GetCells()
  for i = 1, #childCells do
    if childCells[i].data.id == childId then
      return childCells[i]
    end
  end
  return nil
end

function ShopMallExchangeBuyView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function ShopMallExchangeBuyView:UpdateDetailSortSelect(parent)
  local detailSortSelect = self.detailSortSelect
  local detailSortSelectTrans = detailSortSelect.transform
  if detailSortSelectTrans.parent ~= parent then
    detailSortSelectTrans:SetParent(parent, false)
  end
  if not detailSortSelect.activeInHierarchy then
    detailSortSelect:SetActive(true)
  end
end

function ShopMallExchangeBuyView:InitPreorder()
  local data = {
    wrapObj = self.preorderWrap,
    pfbNum = 5,
    cellName = "PreorderCombineCell",
    control = PreorderCombineCell,
    dir = 1
  }
  self.preorderWrapHelper = WrapCellHelper.new(data)
  self.preorderWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickPreorderCell, self)
end

function ShopMallExchangeBuyView:ClickPreorderFilter()
  self:ShowPreorderView(true)
  self:UpdatePreorderView()
  ServiceRecordTradeProxy.Instance:CallPreorderListRecordTradeCmd()
end

function ShopMallExchangeBuyView:ShowPreorderView(isShow)
  self.classify:SetActive(not isShow)
  self.detail:SetActive(not isShow)
  self.preorderContainer:SetActive(isShow)
end

function ShopMallExchangeBuyView:UpdatePreorderView()
  self:ClearLimitCallDetail()
  local pList = ShopMallPreorderProxy.Instance:GetPreoderList()
  local newData = self:ReUniteCellData(pList, 2)
  self.preorderWrapHelper:UpdateInfo(newData)
end

function ShopMallExchangeBuyView:ClickPreorderCell(cellCtl)
  cellCtl:ClickCell()
end

function ShopMallExchangeBuyView:ClickPreorderButton()
  if not ShopMallPreorderProxy.Instance:IsFunctionUnlocked() then
    MsgManager.ShowMsgByID(43383)
    return
  end
  if not ShopMallPreorderProxy.Instance:CheckEmptyOrder() then
    MsgManager.ShowMsgByID(43382)
    return
  end
  if self.currentDetalCell and self.currentDetalCell.data then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopMallPreorderEditView,
      viewdata = {
        itemid = self.currentDetailId
      }
    })
  else
    MsgManager.ShowMsgByIDTable(10114)
  end
end

function ShopMallExchangeBuyView:ClickUnlockPreorderButton()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard)
end

function ShopMallExchangeBuyView:CallRecommendItems(category)
  redlog("CallRecommendItems", category)
  if category then
    ServiceRecordTradeProxy.Instance:CallRecommendItemTradeCmd(category)
  end
end
