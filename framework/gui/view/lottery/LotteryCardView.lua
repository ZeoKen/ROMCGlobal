autoImport("LotteryView")
autoImport("LotteryDetailCombineCell")
LotteryCardView = class("LotteryCardView", LotteryView)
LotteryCardView.ViewType = LotteryView.ViewType
local wrapConfig = {}
local LotteryConfig = GameConfig.Lottery

function LotteryCardView:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  LotteryCardView.super.OnExit(self)
end

function LotteryCardView:FindObjs()
  LotteryCardView.super.FindObjs(self)
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.costTip = self:FindGO("CostTip")
end

function LotteryCardView:AddEvts()
  LotteryCardView.super.AddEvts(self)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:ResetCard()
    end
  end)
  local help = self:FindGO("HelpButton")
  self:AddClickEvent(help, function()
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    if BranchMgr.IsJapan() then
      local lines = string.split(ZhString.CardLotteryHelp, "\n")
      for _, v in pairs(lines) do
        self.rateSb:AppendLine(v)
      end
      self.rateSb:AppendLine("")
    elseif not GameConfig.SystemForbid.LotteryRateUrl then
      self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
    end
    local list = LotteryProxy.Instance:FilterCard(0)
    for i = 1, #list do
      local single = list[i]
      if single.rate ~= 0 then
        self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip2, Table_Item[single.itemid].NameZh or "", single.rate / 10000))
      end
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  end)
end

function LotteryCardView:AddViewEvts()
  LotteryCardView.super.AddViewEvts(self)
  self:AddListenEvt(ServiceEvent.ItemLotteryRateQueryCmd, self.HandleLotteryRateQuery)
end

function LotteryCardView:InitShow()
  LotteryCardView.super.InitShow(self)
  self.lotteryType = LotteryType.Card
  local detailContainer = self:FindGO("DetailContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "LotteryDetailCombineCell"
  wrapConfig.control = LotteryDetailCombineCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.saleIcon = self:FindGO("saleIcon", self.lotteryBtn)
  self.saleIcon:SetActive(false)
  self:InitFilter()
  self:InitView()
end

function LotteryCardView:InitView()
  LotteryCardView.super.InitView(self)
  self:UpdateCost()
  self:UpdateCard()
  self:UpdateLimit()
end

function LotteryCardView:UpdateCost()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self.costTip:SetActive(data:IsPriceIncrease(self.lotteryType) and not BranchMgr.IsSEA() and not BranchMgr.IsEU())
  end
  LotteryCardView.super.UpdateCost(self)
end

function LotteryCardView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryCardView:InitFilter()
  self.filter:Clear()
  local randomFilter = GameConfig.CardMake.RandomFilter
  local rangeList = CardMakeProxy.Instance:GetFilter(randomFilter)
  for i = 1, #rangeList do
    local rangeData = randomFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = randomFilter[range]
    self.filter.value = rangeData
  end
end

function LotteryCardView:ResetCard()
  self:UpdateCard()
  self.detailHelper:ResetPosition()
end

function LotteryCardView:UpdateCard()
  local list = LotteryProxy.Instance:FilterCard(self.filterData)
  if list then
    local newData = self:ReUniteCellData(list, 3)
    self.detailHelper:UpdateInfo(newData)
  end
end

function LotteryCardView:CallLottery(price, year, month, times)
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    local id = 295
    if data:IsPriceIncrease(self.lotteryType) then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(id, function()
          LotteryCardView.super.CallLottery(self, price, year, month, times)
        end, nil, nil, self.costValue)
        return
      end
    else
      LocalSaveProxy.Instance:RemoveDontShowAgain(id)
    end
  end
  LotteryCardView.super.CallLottery(self, price, year, month, times)
end

function LotteryCardView:HandleLotteryRateQuery(note)
  local data = note.body
  if data and data.type == self.lotteryType then
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    if BranchMgr.IsJapan() then
      local lines = string.split(ZhString.CardLotteryHelp, "\n")
      for _, v in pairs(lines) do
        self.rateSb:AppendLine(v)
      end
      self.rateSb:AppendLine("")
    end
    if not GameConfig.SystemForbid.LotteryRateUrl then
      self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
    end
    local _ItemType = GameConfig.Lottery.ItemType
    local leftRate = 100
    for i = 1, #data.infos do
      local info = data.infos[i]
      if info.rate ~= 0 then
        self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip2, Table_Item[info.type].NameZh or "", info.rate / 10000))
        leftRate = leftRate - info.rate / 10000
      end
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  end
end

function LotteryCardView:UpdateLimit()
  LotteryCardView.super.UpdateLimit(self)
  if not self.saleIcon then
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  local count = data and data.todayCount or 0
  local limit = LotteryConfig and LotteryConfig.ButtonShowSaleTimes or 0
  self.saleIcon:SetActive(GameConfig.Lottery.ButtonShowSale == true and count < limit)
end
