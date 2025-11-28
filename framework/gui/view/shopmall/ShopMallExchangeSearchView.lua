autoImport("ShopMallExchangeSearchCombineCell")
autoImport("ExchangePriceServerDetail")
ShopMallExchangeSearchView = class("ShopMallExchangeSearchView", ContainerView)
ShopMallExchangeSearchView.ViewType = UIViewType.PopUpLayer

function ShopMallExchangeSearchView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function ShopMallExchangeSearchView:FindObjs()
  self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
  self.searchButton = self:FindGO("SearchButton")
  self.contentBg = self:FindGO("ContentBg")
  self.historyContainer = self:FindGO("HistoryContainer")
  self.contentContainer = self:FindGO("ContentContainer")
  UIUtil.LimitInputCharacter(self.contentInput, 20)
  self:InitMerge()
end

function ShopMallExchangeSearchView:AddEvts()
  self:AddClickEvent(self.searchButton, function(g)
    self:ClickSearchBtn()
  end)
  EventDelegate.Set(self.contentInput.onSubmit, function()
    self:InputOnSubmit()
  end)
  EventDelegate.Set(self.contentInput.onChange, function()
    self:InputOnChange()
  end)
end

function ShopMallExchangeSearchView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeQueryMergePriceRecordTradeCmd, self.UpdateMergePrice)
end

function ShopMallExchangeSearchView:InitShow()
  self.contentBg:SetActive(false)
  self.mergeContainer:SetActive(false)
  local wrapConfig = {
    wrapObj = self.historyContainer,
    pfbNum = 6,
    cellName = "ShopMallExchangeSearchCombineCell",
    control = ShopMallExchangeSearchCombineCell,
    dir = 1
  }
  self.historyWrapHelper = WrapCellHelper.new(wrapConfig)
  self.historyWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickHistory, self)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = self.contentContainer
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "ShopMallExchangeSearchCombineCell"
  wrapConfig.control = ShopMallExchangeSearchCombineCell
  wrapConfig.dir = 1
  self.contentWrapHelper = WrapCellHelper.new(wrapConfig)
  self.contentWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickContent, self)
  if self.viewdata and self.viewdata.viewdata then
    self.isQueryPrice = self.viewdata.viewdata.isQueryPrice
  end
  if self.viewdata and self.viewdata.viewdata then
    self.isPreording = self.viewdata.viewdata.isPreording
  end
  self:UpdateHistory()
end

function ShopMallExchangeSearchView:UpdateHistory()
  local data
  if not self.isQueryPrice then
    data = ShopMallProxy.Instance:GetExchangeSearchHistory()
  else
    data = ShopMallProxy.Instance:GetQueryPriceHistory()
  end
  local newData = self:ReUniteCellData(data, 2)
  self.historyWrapHelper:UpdateInfo(newData, true)
  self.historyContainer:SetActive(true)
  self.contentContainer:SetActive(false)
  self.mergeContainer:SetActive(false)
end

function ShopMallExchangeSearchView:UpdateContent()
  local data = ShopMallProxy.Instance:GetExchangeSearchContent(self.contentInput.value)
  if 0 < #data then
    self.contentBg:SetActive(true)
    local newData = self:ReUniteCellData(data, 2)
    self.contentWrapHelper:UpdateInfo(newData, true)
  else
    self.contentBg:SetActive(false)
    MsgManager.ShowMsgByID(10252)
  end
  self.historyContainer:SetActive(false)
  self.contentContainer:SetActive(true)
  self.mergeContainer:SetActive(false)
end

function ShopMallExchangeSearchView:ClickSearchBtn()
  self:InputOnSubmit()
end

function ShopMallExchangeSearchView:InputOnSubmit()
  if #self.contentInput.value > 0 then
    self:UpdateContent()
  end
end

function ShopMallExchangeSearchView:ClickHistory(cellCtl)
  if not self.isQueryPrice then
    self:ClickCell(cellCtl)
  else
    self:ClickQueryPrice(cellCtl)
  end
end

function ShopMallExchangeSearchView:ClickContent(cellCtl)
  if not self.isQueryPrice then
    if cellCtl.data then
      LocalSaveProxy.Instance:AddExchangeSearchHistory(cellCtl.data)
    end
    self:ClickCell(cellCtl)
  else
    if cellCtl.data then
      LocalSaveProxy.Instance:AddQueryPriceHistory(cellCtl.data)
    end
    self:ClickQueryPrice(cellCtl)
  end
end

function ShopMallExchangeSearchView:ClickCell(cellCtl)
  local data = cellCtl.data
  if data and ItemData.CheckTradeTime(data) then
    cellCtl.isPreording = true
    self:sendNotification(ShopMallEvent.ExchangeSearchOpenDetail, cellCtl)
    self:CloseSelf()
  else
    MsgManager.ShowMsgByID(10252)
  end
end

local newData = {}

function ShopMallExchangeSearchView:ReUniteCellData(datas, perRowNum)
  TableUtility.TableClear(newData)
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

function ShopMallExchangeSearchView:InitMerge()
  self.mergeContainer = self:FindGO("MergeContainer")
  local CurrentGO = self:FindGO("Current", self.mergeContainer)
  local MergeGO = self:FindGO("Merge", self.mergeContainer)
  self.current = ExchangePriceServerDetail.new(CurrentGO)
  self.merge = ExchangePriceServerDetail.new(MergeGO)
  local currentTitle = self:FindGO("title", CurrentGO):GetComponent(UILabel)
  local mergeTitle = self:FindGO("title", MergeGO):GetComponent(UILabel)
  currentTitle.text = ZhString.ShopMall_CurrentPrice
  mergeTitle.text = ZhString.ShopMall_MergePrice
end

function ShopMallExchangeSearchView:ClickQueryPrice(cellCtl)
  local data = cellCtl.data
  if data and ItemData.CheckTradeTime(data) then
    ServiceRecordTradeProxy.Instance:CallQueryMergePriceRecordTradeCmd(data)
  end
end

function ShopMallExchangeSearchView:UpdateMergePrice(note)
  if note and note.body then
    local data = note.body
    self.contentBg:SetActive(false)
    self.mergeContainer:SetActive(true)
    self.historyWrapHelper:UpdateInfo({})
    local single = {}
    single.itemid = data.itemid
    single.price = data.current_price
    self.current:SetData(single)
    single.price = data.merge_price
    self.merge:SetData(single)
  end
end

function ShopMallExchangeSearchView:InputOnChange()
  if self.isQueryPrice then
    self:UpdateHistory()
    self.mergeContainer:SetActive(false)
  end
end
