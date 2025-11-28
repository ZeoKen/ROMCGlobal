autoImport("BagCardCell")
CardBagCardSubPage = class("CardBagCardSubPage", SubView)
CardBagCardSubPage.SortFilter = {
  [1] = ZhString.CardMake_QualitySortAscend,
  [2] = ZhString.CardMake_QualitySortDescend,
  [3] = ZhString.CardMake_PriceSortAscend,
  [4] = ZhString.CardMake_PriceSortDescend
}

function CardBagCardSubPage:Init(initParam)
  self.tabIndex = initParam
  self.filterCardDatas = {}
  self.queryPriceCardMap = {}
  self.choosedCardDatas = {}
  self.choosedCardIdsMap = {}
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.filterData = {}
  self:LoadPrefab()
  self:FindObjs()
  self:InitTitle()
  self:InitMaterial()
  self:InitFilter()
  self:InitSortFilter()
end

function CardBagCardSubPage:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.filterBtn = self:FindGO("filterBtn")
  self.filterBtnSp = self.filterBtn:GetComponent(UISprite)
  local container = self:FindGO("CardContainer")
  self.bagCardsListCtl = WrapListCtrl.new(container, BagCardCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.bagCardsListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBagCard, self)
  self.bagCardsListCtl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  local resetBtn = self:FindGO("resetBtn")
  self:AddClickEvent(resetBtn, function()
    self:ResetAllChooseCards()
  end)
  self.selectAllBtn = self:FindGO("AllChooseBtn")
  self:AddClickEvent(self.selectAllBtn, function()
    self:SelectAllCards()
  end)
  self.queryPriceMessage = self:FindGO("queryMessage")
  self.loading = self:FindGO("loading", self.queryPriceMessage)
end

function CardBagCardSubPage:InitTitle()
  local npcFunc = Table_NpcFunction[self.tabIndex]
  if npcFunc then
    self.titleLabel.text = npcFunc.NameZh
  end
end

function CardBagCardSubPage:InitFilter()
  local filters = self:GetFilters()
  self:SetDefaultFilterData(filters)
  self:AddClickEvent(self.filterBtn, function()
    local tipData = {
      callback = self.FilterPropCallback,
      param = self,
      data = filters,
      curProps = self.filterData
    }
    TipManager.Instance:ShowSinglePropTypeTip(tipData, self.filterBtnSp, NGUIUtil.AnchorSide.AnchorSide, {230, -64})
  end)
end

function CardBagCardSubPage:SetDefaultFilterData(filters)
  for k, v in pairs(filters) do
    self.filterData[#self.filterData + 1] = k
  end
  table.sort(self.filterData, function(l, r)
    return l < r
  end)
end

function CardBagCardSubPage:GetFilters()
  return {}
end

function CardBagCardSubPage:GetMaxChooseCount()
  return 0
end

function CardBagCardSubPage:InitSortFilter()
  local go = self:FindGO("SortPop")
  local panel = self:FindComponent("ScrollView", UIPanel)
  self.sortFilter = PopupGridList.new(go, function(self, data)
    self:OnSortChoose(self, data)
  end, self, panel.depth + 2)
  local list = CardBagCardSubPage.SortFilter
  local datas = {}
  for i = 1, #list do
    local data = {}
    data.index = i
    data.text = list[i]
    datas[i] = data
  end
  self.sortFilter:SetData(datas)
end

function CardBagCardSubPage:OnEnter()
end

function CardBagCardSubPage:OnExit()
  if self.sortFilter then
    self.sortFilter:Destroy()
  end
end

function CardBagCardSubPage:Show()
  self.gameObject:SetActive(true)
end

function CardBagCardSubPage:Hide()
  self.gameObject:SetActive(false)
end

function CardBagCardSubPage:OnSortChoose(self, data)
  if not data then
    return
  end
  local isPrice = data.index == 3 or data.index == 4
  local descend = data.index == 2 or data.index == 4
  CardMakeProxy.Instance:SetDecomposeSortParam(isPrice, descend)
  if isPrice then
    local queryCardList = ReusableTable.CreateArray()
    for i = 1, #self.filterCardDatas do
      local itemData = self.filterCardDatas[i]
      local success = FunctionItemTrade.Me():GetTradePriceCache(itemData)
      if not success then
        local tradeData = {}
        tradeData.itemdata = {}
        tradeData.itemdata.base = {}
        tradeData.itemdata.base.id = itemData.staticData.id
        queryCardList[#queryCardList + 1] = tradeData
      end
    end
    if 0 < #queryCardList then
      self:SetCardPriceQueryMessage(true)
      FunctionItemTrade.Me():QueryCardListPrice(queryCardList)
    else
      self:UpdateChooseCards(true)
    end
    ReusableTable.DestroyAndClearArray(queryCardList)
  else
    self:UpdateChooseCards(true)
  end
end

local deltaAngle = LuaVector3(0, 0, 36)

function CardBagCardSubPage:SetCardPriceQueryMessage(state)
  self.queryPriceMessage:SetActive(state)
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
  if state then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 100, function()
      self.loading.transform:Rotate(deltaAngle)
    end, self)
  end
end

function CardBagCardSubPage:FilterPropCallback(props)
  if not self.filterData then
    return
  end
  TableUtility.ArrayClear(self.filterData)
  if not props or #props == 0 then
    local filters = self:GetFilters()
    self:SetDefaultFilterData(filters)
  else
    for i = 1, #props do
      self.filterData[i] = props[i]
    end
  end
  self:UpdateChooseCards(true)
end

function CardBagCardSubPage:ResetFilterCards()
  TableUtility.ArrayClear(self.filterCardDatas)
  local cardlistDatas = self:GetFilterCardsByFilterData(self.filterData)
  for i = 1, #cardlistDatas do
    local data = cardlistDatas[i]:Clone()
    local choosedNum = self.choosedCardIdsMap[data.id]
    if choosedNum then
      data.num = data.num - choosedNum
    end
    if data.num >= 0 then
      table.insert(self.filterCardDatas, data)
    end
  end
end

function CardBagCardSubPage:GetFilterCardsByFilterData(filterData)
  return {}
end

function CardBagCardSubPage:UpdateChooseCards(isLayout)
end

function CardBagCardSubPage:ClickBagCard(cell)
  if self.longPressEventDispatched then
    return
  end
  self.clickEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self.clickEventDispatched = nil
  end, self)
  local data = cell.data
  if not data then
    return
  end
  if data.num > 0 then
    self:AddChoosedCards(data, 1)
  end
  cell:SetCardSelectState(true)
  local cells = self.bagCardsListCtl:GetCells()
  for i = 1, #cells do
    if cells[i] ~= cell then
      cells[i]:SetCardSelectState(false)
    end
  end
end

function CardBagCardSubPage:OnSelectLongPress(cell)
  if self.clickEventDispatched then
    return
  end
  self.longPressEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self.longPressEventDispatched = nil
  end, self)
  local data = cell.data
  if data then
    local showData = {
      itemdata = data,
      showUpTip = true,
      ignoreBounds = cell.gameObject,
      hideGetPath = true
    }
    
    function showData.callback()
    end
    
    local itemTip = self:ShowItemTip(showData)
    local tipCell = itemTip:GetCell(1)
    tipCell:ActiveCountChooseBord(true)
    tipCell:AddTipFunc(ZhString.CardDecomposeView_PutCard, function(param, num)
      self:AddChoosedCards(data, num)
    end)
  end
end

function CardBagCardSubPage:ClickChoosedCard(cell)
  self:RemoveChoosedCards(cell.data, 1)
end

function CardBagCardSubPage:AddChoosedCards(data, num)
  self:AddChooseCard(data, num)
  local curIndex = #self.choosedCardDatas
  local maxRowCount = self.choosedCardsCtl.cellNum
  local curRow = math.floor(curIndex / self.choosedCardsCtl.cellChildNum) - 1
  self.choosedCardScrollView:SetDragAmount(0, math.clamp(curRow / maxRowCount, 0, 1), false)
  self:UpdateChooseCards()
end

function CardBagCardSubPage:AddChooseCard(data, num)
  if data == nil or num == 0 then
    return
  end
  local choosedCount = #self.choosedCardDatas
  local maxCount = self:GetMaxChooseCount()
  local spaceCount = math.min(maxCount - choosedCount, num)
  if spaceCount <= 0 then
    MsgManager.ShowMsgByIDTable(244)
    return
  end
  if num > spaceCount then
    MsgManager.ShowMsgByIDTable(244)
  end
  if self.choosedCardIdsMap[data.id] == nil then
    self.choosedCardIdsMap[data.id] = spaceCount
  else
    self.choosedCardIdsMap[data.id] = spaceCount + self.choosedCardIdsMap[data.id]
  end
  for i = 1, spaceCount do
    local cData = data:Clone()
    cData.num = 1
    table.insert(self.choosedCardDatas, cData)
  end
end

function CardBagCardSubPage:RemoveChoosedCards(data, removeNum)
  self:RemoveChooseCard(data, removeNum)
  self:UpdateChooseCards()
end

function CardBagCardSubPage:RemoveChooseCard(data, removeNum)
  if data == nil then
    return
  end
  if removeNum == 0 then
    return
  end
  local did = data.id
  local choosedNum = self.choosedCardIdsMap[did]
  if choosedNum == nil then
    return
  end
  for i = #self.choosedCardDatas, 1, -1 do
    if self.choosedCardDatas[i].id == did then
      table.remove(self.choosedCardDatas, i)
      choosedNum = choosedNum - 1
      removeNum = removeNum - 1
      if choosedNum == 0 or removeNum == 0 then
        break
      end
    end
  end
  if choosedNum == 0 then
    self.choosedCardIdsMap[did] = nil
  else
    self.choosedCardIdsMap[did] = choosedNum
  end
  if self.chooseAll then
    self.chooseAll = false
  end
end

function CardBagCardSubPage:SelectAllCards()
  if not self.chooseAll then
    local maxCount = self:GetMaxChooseCount()
    for i = 1, #self.filterCardDatas do
      local itemData = self.filterCardDatas[i]
      local freeCount = maxCount - #self.choosedCardDatas
      if freeCount >= itemData.num then
        self:AddChooseCard(itemData, itemData.num)
      else
        for j = 1, freeCount do
          self:AddChooseCard(itemData, 1)
        end
      end
    end
    self.chooseAll = true
    self:UpdateChooseCards()
  else
    self:ResetAllChooseCards()
    self.chooseAll = false
  end
end

function CardBagCardSubPage:ResetAllChooseCards()
  for i = #self.choosedCardDatas, 1, -1 do
    local itemData = self.choosedCardDatas[i]
    self:RemoveChooseCard(itemData, 1)
  end
  self:UpdateChooseCards()
end

function CardBagCardSubPage:SetConfirm(isGray)
  if isGray then
    self.confirmButton.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
    self.confirmCollider.enabled = false
  else
    self.confirmButton.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
    self.confirmCollider.enabled = true
  end
end

function CardBagCardSubPage:OnTradeReqPrice(note)
  self:UpdateChooseCards(true)
  self:SetCardPriceQueryMessage(false)
end
