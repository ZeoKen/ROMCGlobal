autoImport("NewRechargeInnerSelectCell")
NewRechargeCommonSubView = class("NewRechargeCommonSubView", SubView)
local RechargeRedTips = {
  SceneTip_pb.EREDSYS_SHOP_BUY_NOTIFY,
  SceneTip_pb.EREDSYS_GIFT_TIME_LIMIT
}

function NewRechargeCommonSubView:ctor(container, initParama, subViewData)
  NewRechargeCommonSubView.super.ctor(self, container, initParama, subViewData)
  self.redTipCellMap = {}
end

local selectorLen = 190
local tickInstance

function NewRechargeCommonSubView:OnEnter()
  if not tickInstance then
    tickInstance = TimeTickManager.Me()
  end
  self:ShowShopItemGiftRightDetail()
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
end

function NewRechargeCommonSubView:OnExit()
  if tickInstance then
    tickInstance:ClearTick(self)
    self.scrollUpdateTick = nil
  end
  self:ClearScrollViewEvents()
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
end

function NewRechargeCommonSubView:UpdateGetLimit(note)
  local buyCell = self.parentView and self.parentView.ctrlShopItemPurchaseDetail
  if buyCell then
    buyCell:SetItemGetCount(note.data)
  end
end

function NewRechargeCommonSubView:OnInnerSelectionChange(cell)
  self:RefreshView(cell.data.ID)
end

function NewRechargeCommonSubView:getSelectorLen()
  return selectorLen
end

function NewRechargeCommonSubView:RefreshView(selectInnerTab)
  if self.innerSelectTab == selectInnerTab then
    return
  end
  if selectInnerTab ~= nil then
    if self.innerSelect_validIndex and TableUtility.ArrayFindIndex(self.innerSelect_validIndex, selectInnerTab) == 0 then
      selectInnerTab = self.innerSelect_validIndex[1]
    end
    self.innerSelectTab = selectInnerTab
  end
end

function NewRechargeCommonSubView:LoadInnerSelector(list)
  if not self.innerSelect_validIndex then
    self.innerSelect_validIndex = {}
  else
    TableUtility.ArrayClear(self.innerSelect_validIndex)
  end
  local item
  for i = 1, #list do
    item = list[i]
    if item.Invalid ~= true then
      TableUtility.ArrayPushBack(self.innerSelect_validIndex, item.ID)
    end
  end
  if 1 < #list then
    self.innerSelectListCtrl:ResetDatas(list, nil, true)
    self.innerSelectLine.gameObject:SetActive(true)
    self.innerSelectLine.width = #self.innerSelect_validIndex * self:getSelectorLen()
  else
    self.innerSelectListCtrl:ResetDatas(_EmptyTable, nil, true)
    self.innerSelectLine.gameObject:SetActive(false)
  end
end

function NewRechargeCommonSubView:SelectInnerSelector()
  local cells = self.innerSelectListCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetSelect(cell.data.ID == self.innerSelectTab)
  end
end

function NewRechargeCommonSubView:FindObjs()
  local innerSelect = self:FindGO("InnerSelector")
  local innerSelectContainer = self:FindComponent("Grid", UIGrid, innerSelect)
  self.innerSelectListCtrl = UIGridListCtrl.new(innerSelectContainer, NewRechargeInnerSelectCell, "NewRechargeInnerSelectCell")
  self.innerSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnInnerSelectionChange, self)
  self.innerSelectLine = self:FindComponent("BGLine", UISprite, innerSelect)
  self:LoadInnerSelector(GameConfig.NewRecharge.Tabs[self.Tab].Inner)
end

function NewRechargeCommonSubView:ShowShopItemPurchaseDetail(data)
  local shop_item_data = data.info
  if self.parentView and shop_item_data then
    self.parentView:ShopItemPurchaseDetailCell_Load(shop_item_data, data.m_funcRmbBuy)
    HappyShopProxy.Instance:SetSelectId(shop_item_data.id)
  end
end

function NewRechargeCommonSubView:ShowShopItemGiftRightDetail(data, parent, pos)
  if not data then
    self.parentView:onShowGiftRightDetailView(false)
    return
  end
  local shop_item_data = data.info
  if self.parentView and shop_item_data then
    self.parentView:ShopItemGiftRightDetailCell_Load(shop_item_data, data.m_funcRmbBuy, parent, pos)
  end
end

local tipData, tipOffset = {}, {0, -90}

function NewRechargeCommonSubView:ShowGoodsItemTip(itemConfID)
  if itemConfID ~= nil then
    tipData.itemdata = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowItemFloatTip(tipData, self.parentView.widgetTipRelative, NGUIUtil.AnchorSide.Center, tipOffset)
  end
end

function NewRechargeCommonSubView:ClearScrollViewEvents()
  if self.imScrollView then
    self.imScrollView.onDragStarted = nil
    self.imScrollView.onStoppedMoving = nil
  end
end

local checkBoundTriggerFactor = 0.6

function NewRechargeCommonSubView:ResetScrollUpdateParams(scrollView, scrollBar, leftTriggerCB, leftTriggerCBP, rightTriggerCB, rightTriggerCBP)
  self:ClearScrollViewEvents()
  self.imScrollView = scrollView
  self.imScrollBar = scrollBar
  if self.imScrollView and self.imScrollBar then
    function self.imScrollView.onDragStarted()
      self:OnScrollStart(self.imScrollView)
    end
    
    function self.imScrollView.onStoppedMoving()
      self:OnScrollStop(self.imScrollView)
    end
    
    self.imScrollBarTriggerSize = scrollBar.barSize * checkBoundTriggerFactor
    self.imScrollBarLeftTriggerCB = leftTriggerCB
    self.imScrollBarLeftTriggerCBP = leftTriggerCBP
    self.imScrollBarRightTriggerCB = rightTriggerCB
    self.imScrollBarRightTriggerCBP = rightTriggerCBP
  end
  if self.m_springPanel == nil then
    self.m_springPanel = scrollView.gameObject:GetComponent(SpringPanel)
  end
end

function NewRechargeCommonSubView:ResetScrollBarTriggerSize()
  if self.imScrollView and self.imScrollBar then
    self.imScrollBarTriggerSize = self.imScrollBar.barSize * checkBoundTriggerFactor
  end
end

function NewRechargeCommonSubView:OnScrollStart(scrollView)
  self.scrollUpdateTick = tickInstance:CreateTick(0, 200, self.CheckScrollProcess, self, 998)
end

function NewRechargeCommonSubView:OnScrollStop(scrollView)
  TimeTickManager.Me():ClearTick(self, 998)
  self.scrollUpdateTick = nil
  local sbSize = self.imScrollBar.barSize
  if 0.992 < sbSize then
    self.imScrollBar.value = 0
  end
end

function NewRechargeCommonSubView:CheckScrollProcess()
  local cells = self.innerSelectListCtrl:GetCells()
  if cells == nil or #cells <= 1 then
    return
  end
  if not self.imScrollBar then
    return
  end
  local sbValue = self.imScrollBar.value
  local sbSize = self.imScrollBar.barSize
  if sbSize <= self.imScrollBarTriggerSize then
    if sbValue <= 0 and self.imScrollBarLeftTriggerCB then
      self.imScrollBarLeftTriggerCB(self, self.imScrollBarLeftTriggerCBP)
    elseif 1 <= sbValue and self.imScrollBarRightTriggerCB then
      self.imScrollBarRightTriggerCB(self, self.imScrollBarRightTriggerCBP)
    end
  end
end

function NewRechargeCommonSubView:OnHide()
  self:HandleRedWhenHide()
  NewRechargeCommonSubView.super.OnHide(self)
end

NewRechargeCommonSubView.SeenRedWhenHide = true

function NewRechargeCommonSubView:HandleRedWhenHide()
  self:ClearUpdateScrollRedTip()
  if self.redTipSeenMap then
    if NewRechargeCommonSubView.SeenRedWhenHide then
      for subId, redIdMap in pairs(self.redTipSeenMap) do
        for redId, _ in pairs(redIdMap) do
          RedTipProxy.Instance:SeenNew(redId, subId)
        end
      end
    end
    self.redTipSeenMap = nil
  end
  self.redTipSeenCellMap = nil
end

function NewRechargeCommonSubView:UnRegisterCellRedTip()
  for k, cell in pairs(self.redTipCellMap) do
    if not Slua.IsNull(cell.u_container) and cell.__RedIdMap then
      for redId, _ in pairs(cell.__RedIdMap) do
        self:UnRegisterSingleRedTipCheck(redId, cell.u_container)
      end
    end
    self.redTipCellMap[k] = nil
  end
  if self.redTipSeenCellMap then
    for k, cell in pairs(self.redTipSeenCellMap) do
      if not Slua.IsNull(cell.u_container) and cell.__RedIdMap then
        for redId, _ in pairs(cell.__RedIdMap) do
          self:UnRegisterSingleRedTipCheck(redId, cell.u_container)
        end
      end
    end
    self.redTipSeenCellMap = nil
  end
end

function NewRechargeCommonSubView:RegisterCellRedByCtrl(ctrl)
  if not ctrl then
    return
  end
  local cells = ctrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local subId = cell.info and cell.info.shopItemData and cell.info.shopItemData.id
    if subId then
      local redId
      for i = 1, #RechargeRedTips do
        redId = RechargeRedTips[i]
        if RedTipProxy.Instance:IsNew(redId, subId) then
          self:RegisterRedTipCheck(redId, cell.u_container, 9, {0, 0}, nil, subId)
          self.redTipCellMap[subId] = cell
          if cell.__RedIdMap then
            cell.__RedIdMap[redId] = 1
          else
            cell.__RedIdMap = {
              [redId] = 1
            }
          end
        end
      end
    end
  end
  self:UpdateScrollRedTip()
end

function NewRechargeCommonSubView:ClearUpdateScrollRedTip()
  if self.redTipCheckTick then
    TimeTickManager.Me():ClearTick(self, 121)
    self.redTipCheckTick = nil
  end
end

function NewRechargeCommonSubView:UpdateScrollRedTip()
  self:ClearUpdateScrollRedTip()
  if not self.redTipCellMap or not next(self.redTipCellMap) then
    return
  end
  self.redTipCheckTick = TimeTickManager.Me():CreateTick(0, 33, self.mUpdateScrollRedTip, self, 121)
end

function NewRechargeCommonSubView:mUpdateScrollRedTip(deltatime)
  if not self.redTipCellMap or not next(self.redTipCellMap) then
    self:ClearUpdateScrollRedTip()
    return
  end
  if not self.scrollPanel then
    self.scrollPanel = self:FindComponent("GoodsList", UIPanel)
    if not self.scrollPanel then
      return
    end
  end
  if not self.redTip_VisibleTime then
    self.redTip_VisibleTime = {}
  end
  self.redTipSeenMap = self.redTipSeenMap or {}
  self.redTipSeenCellMap = self.redTipSeenCellMap or {}
  for subId, cell in pairs(self.redTipCellMap) do
    if cell.u_container and cell.u_container.isVisible and self.scrollPanel:IsVisible(cell.u_container) then
      if not self.redTip_VisibleTime[subId] then
        self.redTip_VisibleTime[subId] = deltatime
      else
        self.redTip_VisibleTime[subId] = self.redTip_VisibleTime[subId] + deltatime
      end
    else
      self.redTip_VisibleTime[subId] = 0
    end
    if self.redTip_VisibleTime[subId] > 500 then
      self.redTip_VisibleTime[subId] = nil
      self.redTipSeenMap[subId] = cell.__RedIdMap
      self.redTipSeenCellMap[subId] = cell
      self.redTipCellMap[subId] = nil
    end
  end
end
