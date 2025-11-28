autoImport("LotteryDetailCell")
autoImport("PopupCombineCell")
LotteryHeadwear = class("LotteryHeadwear", SubView)
local _config = GameConfig.Lottery
local _LotteryProxy, _LotteryFunc
local _Eleven = 11

function LotteryHeadwear:Init()
  _LotteryProxy = LotteryProxy.Instance
  _LotteryFunc = FunctionLottery.Me()
  self.lotteryType = self.container.lotteryType
  self:FindObjs()
  self:InitShow()
end

function LotteryHeadwear:DoEnter()
  self.container.lotterySaleIcon:SetActive(false)
  self.container:ActivePurchaseRoot(true)
  self.container:ActiveLotteryName(true)
  self:InitMonthData()
end

function LotteryHeadwear:OnEnter()
  LotteryHeadwear.super.OnEnter(self)
  self:DoEnter()
end

function LotteryHeadwear:Show()
  self.root:SetActive(true)
  self:DoEnter()
  self:UpdateTimeMonthByYear()
end

function LotteryHeadwear:Hide()
  self.root:SetActive(false)
end

function LotteryHeadwear:OnExit()
  self:ClearAutoRefresh()
  self.yearPopUpCtrl:ClearCallBack()
  self.monthPopUpCtrl:ClearCallBack()
  LotteryHeadwear.super.OnExit(self)
end

function LotteryHeadwear:FindObjs()
  self.root = self:FindGO("HeadRoot")
  local beforeRoot = self:FindGO("BeforePanel", self.root)
  self.yearPopUp = self:FindGO("YearPopUp", beforeRoot)
  self.yearPopUpCtrl = PopupCombineCell.new(self.yearPopUp)
  self.yearPopUpCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickYearFilter, self)
  self.monthPopUp = self:FindGO("MonthPopUp", beforeRoot)
  self.monthPopUpCtrl = PopupCombineCell.new(self.monthPopUp)
  self.monthPopUpCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMonthFilter, self)
end

function LotteryHeadwear:OnClickYearFilter()
  if self.yearGoal == self.yearPopUpCtrl.goal then
    return
  end
  self.yearGoal = self.yearPopUpCtrl.goal
  self.curYear = self.yearPopUpCtrl:GetCurConfigValue().year
  self.monthPopUpCtrl:SetData(_LotteryProxy:GetHeadLotteryMonthFilter(self.curYear), true)
  self.monthGoal = self.monthPopUpCtrl.goal
  self.curMonth = self.monthPopUpCtrl:GetCurConfigValue().month
  self:UpdateMonthList(true)
  self:UpdateCost()
  self.container:UpdateDiscount()
  self:UpdateTimeMonthByYear()
end

function LotteryHeadwear:UpdateTimeMonthByYear()
  if not self.curYear then
    return
  end
  local isConfigYear = HeadLotteryData.IsConfigYear(self.curYear)
  self.monthPopUp:SetActive(not isConfigYear)
  self.container:ActiveLotteryTime(not isConfigYear)
end

function LotteryHeadwear:OnClickMonthFilter()
  if self.monthGoal == self.monthPopUpCtrl.goal then
    return
  end
  self.monthGoal = self.monthPopUpCtrl.goal
  self.curMonth = self.monthPopUpCtrl:GetCurConfigValue().month
  self:UpdateMonthList(true)
end

function LotteryHeadwear:InitShow()
  self.container.isUpdateRecover = true
  local container = self:FindGO("WrapContainer", self.root)
  local _wrapConfig = ReusableTable.CreateTable()
  _wrapConfig.wrapObj = container
  _wrapConfig.pfbNum = 7
  _wrapConfig.cellName = "LotteryCell"
  _wrapConfig.control = LotteryDetailCell
  self.detailHelper = WrapCellHelper.new(_wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.detailHelper:AddEventListener(LotteryCell.ClickEvent, self.ClickCell, self)
  ReusableTable.DestroyAndClearTable(_wrapConfig)
  if _config.HeadwearAutoRefresh ~= nil then
    self.autoRefresh = TimeTickManager.Me():CreateTick(0, 1000, self._AutoRefresh, self)
  end
end

function LotteryHeadwear:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotteryHeadwear:InitMonthData()
  if nil == LotteryProxy.Instance:GetHeadLottery() then
    return
  end
  self:InitDressModel()
  self.yearPopUpCtrl:SetData(_LotteryProxy:GetHeadLotteryFilter(), true)
  self.yearGoal = self.yearPopUpCtrl.goal
  self.curYear = self.yearPopUpCtrl:GetCurConfigValue().year
  self.monthPopUpCtrl:SetData(_LotteryProxy:GetHeadLotteryMonthFilter(self.curYear), true)
  self.monthGoal = self.monthPopUpCtrl.goal
  self.curMonth = self.monthPopUpCtrl:GetCurConfigValue().month
  local isSingle = LotteryProxy.Instance:IsHeadWearSingleMonth()
  self.yearPopUpCtrl:SetFatherColliderState(not isSingle)
  self.monthPopUpCtrl:SetFatherColliderState(not isSingle)
  self:UpdateMonthList(true)
  self:UpdateCost()
end

function LotteryHeadwear:InitDressModel()
  local dressData = FunctionLottery.Me():InitDefaultDress(self.lotteryType) or _LotteryProxy:GetInitializedDressData(self.lotteryType)
  local _ = _LotteryFunc:InitDressMap(dressData, LotteryDressType.Head)
  if _ then
    self.container:ShowModel()
  end
end

function LotteryHeadwear:HandleItemUpdate(note)
  self.container:UpdateTicket()
  if self.container.isShowRecover then
    self.container:TryUpdateRecover()
  else
    self.container.isUpdateRecover = true
  end
  self:UpdateMonthList(false)
end

function LotteryHeadwear:ClickCell(cell)
  self.container:ClickCell(cell)
  self:UpdateMonthList(false)
end

function LotteryHeadwear:_AutoRefresh()
  local time = os.date("*t", ServerTime.CurServerTime() / 1000)
  local config = _config.HeadwearAutoRefresh
  if time.day == config.day and time.hour == config.hour and time.min == config.min then
    local data = _LotteryProxy:GetData(self.lotteryType, time.year, time.month)
    if nil ~= data then
      return
    end
    _LotteryProxy:CallQueryLotteryInfo(self.lotteryType, true)
    self:ClearAutoRefresh()
  end
end

function LotteryHeadwear:ClearAutoRefresh()
  if self.autoRefresh ~= nil then
    TimeTickManager.Me():ClearTick(self)
    self.autoRefresh = nil
  end
end

function LotteryHeadwear:UpdateMonthList(reposition)
  if not (self.lotteryType and self.curYear) or not self.curMonth then
    return
  end
  self.monthData = _LotteryProxy:GetHeadLotteryData(self.curYear, self.curMonth)
  if nil ~= self.monthData then
    self.detailHelper:UpdateInfo(self.monthData.items, reposition)
  end
end

function LotteryHeadwear:TicketTen()
  if not self.curYear or not self.curMonth then
    return
  end
  self.container:CallTicket(self.curYear, self.curMonth, _Eleven)
end

function LotteryHeadwear:HandleQueryLotteryInfo()
  self:InitMonthData()
end

function LotteryHeadwear:UpdateCost()
  if self.monthData ~= nil then
    local onceMaxCount
    local data = _LotteryProxy:GetInfo(self.lotteryType)
    if data ~= nil then
      onceMaxCount = data.onceMaxCount
    end
    self.container:UpdateCostValue(self.monthData.price, onceMaxCount)
  end
end

function LotteryHeadwear:GetDiscountByCoinType(cointype, price)
  if self.monthData ~= nil then
    return _LotteryProxy:GetDiscountByCoinType(self.lotteryType, cointype, price, self.monthData.year, self.monthData.month)
  end
  return price
end

function LotteryHeadwear:Lottery()
  local month = self.monthData
  if month then
    local freeCnt = LotteryProxy.Instance:GetHeadLotteryFreeCount()
    self.container:CallLottery(month.price, month.year, month.month, 1, freeCnt)
  end
end

function LotteryHeadwear:LotteryTen()
  local month = self.monthData
  if month then
    self.container:CallLottery(month.price, month.year, month.month, 10, 0)
  end
end

function LotteryHeadwear:Ticket()
  local month = self.monthData
  if month then
    self.container:CallTicket(month.year, month.month)
  end
end

function LotteryHeadwear:OnClickLotteryHelp()
  if BranchMgr.IsJapan() then
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    local lines = string.split(ZhString.HeaderLotteryHelp, "\n")
    for _, v in pairs(lines) do
      self.rateSb:AppendLine(v)
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  elseif BranchMgr.IsKorea() then
    local aedata = ActivityEventProxy.Instance:GetHeadwearLotteryReward()
    if self.extraReward == nil then
      self.extraReward = LuaStringBuilder.CreateAsTable()
    else
      self.extraReward:Clear()
    end
    local help = Table_Help[990]
    local Desc = help and help.Desc or ZhString.Help_RuleDes
    local lines = string.split(Desc, "\n")
    for _, v in pairs(lines) do
      self.extraReward:AppendLine(v)
    end
    local rewardlist = aedata:GetRewardList()
    for i = 1, #rewardlist do
      local name = Table_Item[rewardlist[i].itemid].NameZh or ""
      self.extraReward:AppendLine(string.format(ZhString.HeaderLotteryHelp_KR, i, rewardlist[i].edge, rewardlist[i].count, name))
    end
    TipsView.Me():ShowGeneralHelp(self.extraReward:ToString(), help.Title)
  end
end

function LotteryHeadwear:UpdateHelpBtn()
  if BranchMgr.IsJapan() then
    self.container:ActiveHelpBtn(true)
  elseif BranchMgr.IsKorea() then
    local aedata = ActivityEventProxy.Instance:GetHeadwearLotteryReward()
    if aedata and aedata:GetRewardList() then
      self.container:ActiveHelpBtn(true)
    else
      self.container:ActiveHelpBtn(false)
    end
  else
    self.container:ActiveHelpBtn(false)
  end
end
