autoImport("QuickBuyCombineCell")
QuickBuyView = class("QuickBuyView", ContainerView)
QuickBuyView.ViewType = UIViewType.PopUpLayer
local BuyReason = {Money = 1, Buying = 2}
local NumThousandFormat = StringUtil.NumThousandFormat
local RED = "[c][FF3B0D]%s[-][/c]"

function QuickBuyView:OnExit()
  QuickBuyProxy.Instance:Clear()
  QuickBuyView.super.OnExit(self)
end

function QuickBuyView:Init()
  self:FindObj()
  self:AddBtnEvt()
  self:AddViewEvt()
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.closeComp.enabled = false
  
  function self.closeComp.callBack()
    self:CloseSelf()
  end
  
  self:InitShow()
end

function QuickBuyView:FindObj()
  self.loadingRoot = self:FindGO("LoadingRoot")
  self.closeBtn = self:FindGO("CloseButton")
  self.buyBtn = self:FindGO("BuyBtn"):GetComponent(UIMultiSprite)
  self.buyBtnLabel = self:FindGO("Label", self.buyBtn.gameObject):GetComponent(UILabel)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBtn.value = false
end

function QuickBuyView:AddBtnEvt()
  self:AddClickEvent(self.closeBtn.gameObject, function()
    if self.canClose then
      self:CloseSelf()
    end
  end)
  self:AddClickEvent(self.buyBtn.gameObject, function()
    if BranchMgr.IsChina() or OverseaHostHelper:GuestExchangeForbid() ~= 1 then
      self:Buy()
    end
  end)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    QuickBuyProxy.Instance:TryCompareEquipPrice()
    self:UpdateBuyBtn()
    self.itemWrapHelper:ResetPosition()
  end)
end

function QuickBuyView:AddViewEvt()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleMyDataChange)
  self:AddListenEvt(QuickBuyEvent.Refresh, self.UpdateView)
  self:AddListenEvt(QuickBuyEvent.Close, self.CloseSelf)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
  self:AddListenEvt(SecurityEvent.Close, self.HandleSecurityClose)
end

function QuickBuyView:HandleSecurityClose()
  self.canClose = true
  self.closeComp.enabled = false
  self:UpdateCloseBtn()
  self:UpdateBuyReason(BuyReason.Buying, nil)
  self:UpdateBuyBtn()
end

local CostType = {
  [1] = 100,
  [2] = 110,
  [3] = 151
}

function QuickBuyView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.buyReasonMap = {}
  self.canClose = true
  self.closeComp.enabled = false
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 3,
    cellName = "QuickBuyCombineCell",
    control = QuickBuyCombineCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.itemWrapHelper:AddEventListener(QuickBuyEvent.Select, self.SelectItem, self)
  local totalCost = self:FindGO("TotalCost")
  self.totalCostGrid = totalCost:GetComponent(UITable)
  local totalCostTip = self:FindGO("TotalCostTip", totalCost):GetComponent(UILabel)
  totalCostTip.text = ZhString.QuickBuy_TotalCost
  self.cost = {}
  for i = 1, 3 do
    local go = self:FindGO("Cost" .. i, totalCost)
    local icon = go:GetComponent(UISprite)
    local num = self:FindGO("Label", go):GetComponent(UILabel)
    IconManager:SetItemIcon(Table_Item[CostType[i]].Icon, icon)
    self.cost[i] = {go = go, num = num}
  end
  local money = self:FindGO("Money")
  self.moneyGrid = money:GetComponent(UITable)
  local moneyTip = self:FindGO("MoneyTip", money):GetComponent(UILabel)
  moneyTip.text = ZhString.QuickBuy_Own
  self.money = {}
  for i = 1, 3 do
    local go = self:FindGO("Cost" .. i, money)
    local icon = go:GetComponent(UISprite)
    local num = self:FindGO("Label", go):GetComponent(UILabel)
    IconManager:SetItemIcon(Table_Item[CostType[i]].Icon, icon)
    self.money[i] = {go = go, num = num}
  end
  self:UpdateTotalCost()
  self:UpdateBuyBtn()
  self:UpdateCloseBtn()
  if ISNoviceServerType then
    QuickBuyProxy.Instance:CallHoldedItemCountTrade()
  else
    QuickBuyProxy.Instance:CallItemInfo()
  end
end

function QuickBuyView:UpdateView()
  self.loadingRoot:SetActive(false)
  self:UpdateItem()
  self:UpdateTotalCost()
  self:UpdateBuyBtn()
end

local BuyItemValid = function(pram, item)
  if item and item.id == "QuickBuy" then
    return false
  end
  return true
end

function QuickBuyView:UpdateItem()
  local hasShop = self.checkBtn.value
  local data = QuickBuyProxy.Instance:GetItemList() or {}
  local result = {}
  local exchangeList = {}
  local shopList = {}
  local blackMarketList = {}
  for i = 1, #data do
    if not data[i].origin or data[i].origin == QuickBuyOrigin.Exchange then
      table.insert(exchangeList, data[i])
    elseif data[i].origin and data[i].origin == QuickBuyOrigin.BlackMarket then
      table.insert(blackMarketList, data[i])
    else
      table.insert(shopList, data[i])
    end
  end
  for i = 1, #exchangeList do
    local hasShopData = false
    for j = 1, #shopList do
      if shopList[j].id == exchangeList[i].id and shopList[j].totalCount > 0 then
        hasShopData = true
        break
      end
    end
    local hasBlackMarketData = false
    for j = 1, #blackMarketList do
      if blackMarketList[j].id == exchangeList[i].id and blackMarketList[j].totalCount > 0 then
        hasBlackMarketData = true
        break
      end
    end
    if hasShop then
      if exchangeList[i].reason ~= QuickBuyReason.Publicity and exchangeList[i].totalCount > 0 or not hasBlackMarketData and not hasShopData then
        table.insert(result, exchangeList[i])
      end
    elseif exchangeList[i].reason ~= QuickBuyReason.Publicity and exchangeList[i].totalCount > 0 or not hasShopData then
      table.insert(result, exchangeList[i])
    end
  end
  for i = 1, #shopList do
    table.insert(result, shopList[i])
  end
  if hasShop then
    for i = 1, #blackMarketList do
      table.insert(result, blackMarketList[i])
    end
  end
  if result then
    self.itemWrapHelper:UpdateInfo(self:ReUniteCellData(result, 3), true)
  end
end

function QuickBuyView:UpdateTotalCost()
  local zenyCost, happyCost, lotteryCost = QuickBuyProxy.Instance:GetTotalCost(self.checkBtn.value)
  local zenyCostStr, happyCostStr, lotteryCostStr
  local _MyselfProxy = MyselfProxy.Instance
  local costStr = ""
  self.cost[1].go:SetActive(true)
  if zenyCost <= _MyselfProxy:GetROB() then
    self.cost[1].num.text = NumThousandFormat(zenyCost)
  else
    self.cost[1].num.text = string.format(RED, NumThousandFormat(zenyCost))
  end
  if 0 < happyCost then
    self.cost[2].go:SetActive(true)
    if happyCost <= _MyselfProxy:GetGarden() then
      self.cost[2].num.text = NumThousandFormat(happyCost)
    else
      self.cost[2].num.text = string.format(RED, NumThousandFormat(happyCost))
    end
  else
    self.cost[2].go:SetActive(false)
  end
  if 0 < lotteryCost then
    self.cost[3].go:SetActive(true)
    if lotteryCost <= _MyselfProxy:GetLottery() then
      self.cost[3].num.text = NumThousandFormat(lotteryCost)
    else
      self.cost[3].num.text = string.format(RED, NumThousandFormat(lotteryCost))
    end
  else
    self.cost[3].go:SetActive(false)
  end
  self.totalCostGrid:Reposition()
  self:UpdateBuyReason(BuyReason.Money, 0 < zenyCost or 0 < happyCost or 0 < lotteryCost)
  local _MyselfProxy = MyselfProxy.Instance
  local ownStr = ""
  self.money[1].go:SetActive(true)
  self.money[1].num.text = NumThousandFormat(_MyselfProxy:GetROB())
  if 0 < happyCost then
    self.money[2].go:SetActive(true)
    self.money[2].num.text = NumThousandFormat(_MyselfProxy:GetGarden())
  else
    self.money[2].go:SetActive(false)
  end
  if 0 < lotteryCost then
    self.money[3].go:SetActive(true)
    self.money[3].num.text = NumThousandFormat(_MyselfProxy:GetLottery())
  else
    self.money[3].go:SetActive(false)
  end
  self.moneyGrid:Reposition()
end

function QuickBuyView:UpdateMoney()
  local _MyselfProxy = MyselfProxy.Instance
  local info = string.format(ZhString.QuickBuy_Own, NumThousandFormat(_MyselfProxy:GetROB()), NumThousandFormat(_MyselfProxy:GetGarden()), NumThousandFormat(_MyselfProxy:GetLottery()))
  self.money:Reset()
  self.money:SetText(info, true)
end

function QuickBuyView:UpdateCloseBtn()
  if self.canClose then
    self.closeBtn:SetActive(true)
  else
    self.closeBtn:SetActive(false)
  end
end

function QuickBuyView:UpdateBuyBtn()
  if self:CanBuy() then
    self.buyBtn.CurrentState = 0
    self.buyBtnLabel.effectStyle = UILabel.Effect.Outline
  else
    self.buyBtn.CurrentState = 1
    self.buyBtnLabel.effectStyle = UILabel.Effect.None
  end
end

function QuickBuyView:ClickItem(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function QuickBuyView:SelectItem(cell)
  local data = cell.data
  if data then
    cell:SetChoose()
    self:UpdateTotalCost()
    self:UpdateBuyBtn()
  end
end

function QuickBuyView:Buy()
  self.delayTime = now
  if self:CanBuy() then
    local zenyCost, happyCost, lotteryCost = QuickBuyProxy.Instance:GetTotalCost(self.checkBtn.value)
    local _MyselfProxy = MyselfProxy.Instance
    if zenyCost > _MyselfProxy:GetROB() or happyCost > _MyselfProxy:GetGarden() or lotteryCost > _MyselfProxy:GetLottery() then
      MsgManager.ShowMsgByID(2969)
      return
    end
    QuickBuyProxy.Instance:StartBuyItem(self.checkBtn.value)
    self:UpdateBuyReason(BuyReason.Buying, false)
    self.canClose = false
    self.closeComp.enabled = not self:CanBuy()
    self:UpdateBuyBtn()
    self:UpdateCloseBtn()
  end
end

function QuickBuyView:HandleMyDataChange()
  self:UpdateTotalCost()
end

function QuickBuyView:CloseSelf()
  QuickBuyView.super.CloseSelf(self)
  EventManager.Me():PassEvent(QuickBuyEvent.CloseUI, self)
end

function QuickBuyView:UpdateBuyReason(reason, value)
  self.buyReasonMap[reason] = value
end

function QuickBuyView:CanBuy()
  for k, v in pairs(self.buyReasonMap) do
    if v == false then
      return false
    end
  end
  return true
end

function QuickBuyView:ReUniteCellData(datas, perRowNum)
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
