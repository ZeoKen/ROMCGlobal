autoImport("LotteryView")
autoImport("LotteryMonthGroupCell")
autoImport("LotteryMonthCell")
autoImport("DotCell")
autoImport("LotteryRecoverCombineCell")
autoImport("LotteryDetailCell")
LotteryHeadwearView = class("LotteryHeadwearView", LotteryView)
LotteryHeadwearView.ViewType = LotteryView.ViewType
local TabType = {
  Current = 1,
  Discount = 2,
  Past = 3
}
local config = GameConfig.Lottery
local tabConfig = config and config.TabConfig
local FilterDiscountMonthGroup = function(self, group)
  local info
  local monthList = group:GetMonth()
  for i = 1, #monthList do
    info = monthList[i]
    if self.discountMap[info.year * 100 + info.month] then
      return true
    end
  end
  return false
end
local FilterPastMonthGroup = function(self, group)
  return self.monthGroupId ~= group.id or #group:GetMonth() ~= 1
end
local FilterDiscountMonth = function(self, month)
  return self.discountMap[month.year * 100 + month.month]
end
local FilterPastMonth = function(self, month)
  return month.year ~= self.curYear or month.month ~= self.curMonth
end

function LotteryHeadwearView:OnEnter()
  LotteryHeadwearView.super.OnEnter(self)
  self:QueryLotteryExtraBonus()
end

function LotteryHeadwearView:OnExit()
  local cells = self.monthCtl:GetCells()
  for i = 1, #cells do
    cells[i]:DestroyPicture()
  end
  self:ClearAutoRefresh()
  LotteryHeadwearView.super.OnExit(self)
end

function LotteryHeadwearView:FindObjs()
  LotteryHeadwearView.super.FindObjs(self)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.monthGroup = self:FindGO("MonthGroup")
  self.monthGroupTrans = self.monthGroup.transform
  self.monthGroupScrollView = self.monthGroup:GetComponent(UIScrollView)
  self.monthGrid = self:FindGO("MonthGrid"):GetComponent(UIGrid)
  self.centerOnChild = self.monthGrid.gameObject:GetComponent("UICenterOnChild")
  self.sendBtn = self:FindGO("SendBtn")
  self.sendBtn:SetActive(not GameConfig.SystemForbid.LotteryExpress)
  local sendBtnSp = self.sendBtn:GetComponent(UISprite)
  IconManager:SetArtFontIcon("recharge_btn_give", sendBtnSp)
  local tabList = {}
  for k, v in pairs(TabType) do
    local data = {}
    local obj = self:FindGO(k .. "Tab")
    data.gameObject = obj
    data.transform = obj.transform
    data.label = self:FindComponent("Label", UILabel, obj)
    data.choose = self:FindGO("Choose", obj)
    tabList[v] = data
    if tabConfig and tabConfig[v] then
      data.label.text = tabConfig[v].text
    end
  end
  self.tabList = tabList
  self.tabGrid = self:FindComponent("TabGrid", UIGrid)
  if BranchMgr.IsJapan() then
    self.helpButton = self:LoadPreferb("cell/HelpButtonCell", self.detailRoot)
    self.helpButton.transform.localPosition = LuaGeometry.GetTempVector3(224, 320, 0)
    self.helpButton.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
    self:AddClickEvent(self:FindGO("HelpButton", self.helpButton), function(go)
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
    end)
  elseif BranchMgr.IsKorea() then
    local aedata = ActivityEventProxy.Instance:GetHeadwearLotteryReward()
    if aedata and aedata:GetRewardList() then
      self.helpButton = self:LoadPreferb("cell/HelpButtonCell", self.detailRoot)
      self.helpButton.transform.localPosition = LuaGeometry.GetTempVector3(560, 320, 0)
      self.helpButton.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
      do
        local panelId = PanelConfig.LotteryHeadwearView.id
        self:AddClickEvent(self:FindGO("HelpButton", self.helpButton), function(go)
          if self.extraReward == nil then
            self.extraReward = LuaStringBuilder.CreateAsTable()
          else
            self.extraReward:Clear()
          end
          local help = Table_Help[panelId]
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
        end)
      end
    end
  end
  if config.TabShowHide then
    for k, v in pairs(TabType) do
      self.tabList[v].gameObject:SetActive(config.TabShowHide[v] == 1)
    end
  end
end

function LotteryHeadwearView:AddEvts()
  LotteryHeadwearView.super.AddEvts(self)
  self:AddClickEvent(self.sendBtn, function()
    self:Send()
  end)
  local ticketBtn = self:FindGO("TicketBtn")
  self:AddClickEvent(ticketBtn, function()
    self:Ticket()
  end)
  local detailBtn = self:FindGO("DetailBtn")
  self:AddClickEvent(detailBtn, function()
    if self.monthData then
      self:ShowDetail(true)
      self:UpdateDetail(self.monthData)
    end
  end)
  
  function self.centerOnChild.onCenter(centeredObject)
    if self.centerMonthTrans and self.centerMonthTrans.gameObject ~= centeredObject then
      self:CenterOn(self.centerMonthTrans)
      return
    end
    for i = 1, #self.monthCtl:GetCells() do
      local cell = self.monthCtl:GetCells()[i]
      if cell.gameObject == centeredObject then
        local dot = self:GetSelectDotCell()
        if dot then
          dot:SetChoose(false)
        end
        dot = self.dotCtl:GetCells()[i]
        dot:SetChoose(true)
        self.monthData = cell.data
        self:UpdatePicUrl(cell)
        self:UpdateCost()
        self:UpdateTicketCost()
        self:UpdateDiscount()
        self:UpdateLimit()
        if GameConfig.Lottery.HeadwearAutoRefresh ~= nil then
          self:UpdateDetail(self.monthData)
        end
        self.centerMonthTrans = nil
        break
      end
    end
  end
  
  local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
  self:AddClickEvent(recoverReturnBtn, function()
    self:ShowRecover(false)
  end)
  local detailReturnBtn = self:FindGO("DetailReturnBtn")
  self:AddClickEvent(detailReturnBtn, function()
    self:ShowDetail(false)
  end)
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
  self:AddClickEvent(self.tabList[TabType.Current].gameObject, function()
    self:UpdateCurrentTab()
  end)
  self:AddClickEvent(self.tabList[TabType.Discount].gameObject, function()
    self:UpdateDiscountTab()
  end)
  self:AddClickEvent(self.tabList[TabType.Past].gameObject, function()
    self:UpdatePastTab()
  end)
  local helpBtn = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(35211, helpBtn)
end

function LotteryHeadwearView:AddViewEvts()
  LotteryHeadwearView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusItemCmd, self.OnRecvExtraBonusItemCmd)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd, self.OnRecvExtraBonusCfgCmd)
end

function LotteryHeadwearView:InitShow()
  LotteryHeadwearView.super.InitShow(self)
  self.lotteryType = LotteryType.Head
  self.monthGroupList = {}
  self.monthList = {}
  self.discountMap = {}
  self.recoverSelect = {}
  self.isUpdateRecover = true
  self.monthGroupCtl = UIGridListCtrl.new(self:FindComponent("MonthGroupGrid", UIGrid), LotteryMonthGroupCell, "LotteryMonthGroupCell")
  self.monthGroupCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMonthGroup, self)
  self.monthCtl = UIGridListCtrl.new(self.monthGrid, LotteryMonthCell, "LotteryMonthCell")
  grid = self:FindGO("MonthDotGrid"):GetComponent(UIGrid)
  self.dotCtl = UIGridListCtrl.new(grid, DotCell, "ChatDotCell")
  local container = self:FindGO("RecoverContainer")
  local wrapConfig = {}
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  wrapConfig.dir = 1
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
  self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)
  local detailGrid = self:FindGO("DetailGrid"):GetComponent(UIGrid)
  self.detailCtl = UIGridListCtrl.new(detailGrid, LotteryDetailCell, "LotteryHeadwearDetailCell")
  self.detailCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self:InitTicket()
  self:InitRecover()
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:ShowRecover(false)
  self:InitView()
  if config.HeadwearAutoRefresh ~= nil then
    self.autoRefresh = TimeTickManager.Me():CreateTick(0, 1000, self._AutoRefresh, self)
  end
  if config.HeadwearHideTab ~= nil then
    self.tabGrid.gameObject:SetActive(false)
  end
end

function LotteryHeadwearView:Send()
  if self.monthData ~= nil then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryExpressView,
      viewdata = self.monthData
    })
  end
end

function LotteryHeadwearView:Lottery()
  local month = self.monthData
  if month then
    self:CallLottery(month.price, month.year, month.month)
  end
end

function LotteryHeadwearView:LotteryTen()
  local month = self.monthData
  if month then
    self:CallLottery(month.price, month.year, month.month, 10)
  end
end

function LotteryHeadwearView:Ticket()
  local month = self.monthData
  if month then
    self:CallTicket(month.year, month.month)
  end
end

function LotteryHeadwearView:ClickMonthGroup(cell)
  local data = cell.data
  if data and self.lastMonthGroup ~= cell then
    if self.lastMonthGroup then
      self.lastMonthGroup:SetChoose(false)
    end
    cell:SetChoose(true)
    self.lastMonthGroup = cell
    if self.tabType == TabType.Discount then
      self:UpdateMonth(self:FilterMonth(data, FilterDiscountMonth))
    elseif self.tabType == TabType.Past then
      local monthData = data:GetData(self.curYear, self.curMonth)
      if monthData ~= nil then
        self:UpdateMonth(self:FilterMonth(data, FilterPastMonth))
      else
        local monthList = data:GetMonth()
        self:UpdateMonth(monthList)
      end
    end
  end
end

function LotteryHeadwearView:CenterOn(trans)
  self.centerMonthTrans = trans
  self.centerOnChild:CenterOn(trans)
end

function LotteryHeadwearView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    local currentTip = self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {-300, 0})
  end
end

function LotteryHeadwearView:InitView()
  LotteryHeadwearView.super.InitView(self)
  local serverTime = ServerTime.CurServerTime() / 1000
  local time = os.date("*t", serverTime)
  self.curYear = time.year
  self.curMonth = time.month
  self.monthGroupId = LotteryProxy.Instance:GetMonthGroupId(self.curYear, self.curMonth)
  if not self.forceSet then
    self:UpdateCurrentTab(true)
  else
    self:UpdateCurMonth()
  end
  self:ShowDiscountTab()
end

function LotteryHeadwearView:_UpdateMonth()
  self:ShowMonthGroup(false)
  local list = self.monthList
  TableUtility.ArrayClear(list)
  local month = LotteryProxy.Instance:GetData(self.lotteryType, self.curYear, self.curMonth)
  if month ~= nil then
    list[#list + 1] = month
  else
    local info = LotteryProxy.Instance:GetInfo(self.lotteryType)
    if info ~= nil then
      local groupList = info:GetMonthGroupList()
      if 0 < #groupList then
        local monthList = groupList[1]:GetMonth()
        if 0 < #monthList then
          list[#list + 1] = monthList[#monthList]
        end
      end
    end
  end
  self:UpdateMonth(list)
end

function LotteryHeadwearView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.Lottery)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryHeadwearView:UpdateDetail(data)
  if data then
    self.detailCtl:ResetDatas(data.items)
  end
end

function LotteryHeadwearView:UpdateCost()
  if self.monthData ~= nil then
    local onceMaxCount
    local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
    if data ~= nil then
      onceMaxCount = data.onceMaxCount
    end
    self:UpdateCostValue(self.monthData.price, onceMaxCount)
  end
end

function LotteryHeadwearView:UpdatePicUrl(monthCell)
  local monthData = monthCell.data
  if monthData ~= nil then
    local picUrl = self:GetLotteryBanner(monthData.year, monthData.month)
    monthCell:SetPicture(picUrl)
  end
end

function LotteryHeadwearView:GetDiscountByCoinType(cointype, price)
  if self.monthData ~= nil then
    return LotteryProxy.Instance:GetDiscountByCoinType(self.lotteryType, cointype, price, self.monthData.year, self.monthData.month)
  end
  return price
end

function LotteryHeadwearView:GetLotteryBanner(year, month)
  local list = ActivityEventProxy.Instance:GetLotteryBanner(self.lotteryType)
  if list ~= nil then
    for i = 1, #list do
      local data = list[i]
      local time = os.date("*t", data.begintime)
      if (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) and time.year == 2018 and time.month == 10 then
        time.month = 11
      end
      if time.year == year and time.month == month then
        return data:GetPath()
      end
    end
  end
end

function LotteryHeadwearView:HandleItemUpdate(note)
  self:UpdateTicket()
  if self.isShowRecover then
    self:TryUpdateRecover()
  else
    self.isUpdateRecover = true
  end
end

function LotteryHeadwearView:HandlePicture(note)
  local data = note.body
  if data then
    local cells = self.monthCtl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      local celldata = cell.data
      if celldata ~= nil then
        local url = self:GetLotteryBanner(celldata.year, celldata.month)
        if data.picUrl == url then
          cell:UpdatePicture(data.bytes)
          break
        end
      end
    end
  end
end

function LotteryHeadwearView:GetSelectDotCell()
  local cells = self.dotCtl:GetCells()
  if cells then
    local cell
    for i = 1, #cells do
      cell = cells[i]
      if cell:GetChoose() then
        return cell
      end
    end
  end
  return nil
end

function LotteryHeadwearView:_AutoRefresh()
  local time = os.date("*t", ServerTime.CurServerTime() / 1000)
  local config = GameConfig.Lottery.HeadwearAutoRefresh
  if time.day == config.day and time.hour == config.hour and time.min == config.min then
    local _LotteryProxy = LotteryProxy.Instance
    local data = _LotteryProxy:GetData(self.lotteryType, time.year, time.month)
    if data ~= nil then
      return
    end
    _LotteryProxy:CallQueryLotteryInfo(self.lotteryType, true)
    self:ClearAutoRefresh()
  end
end

function LotteryHeadwearView:ClearAutoRefresh()
  if self.autoRefresh ~= nil then
    TimeTickManager.Me():ClearTick(self)
    self.autoRefresh = nil
  end
end

function LotteryHeadwearView:ShowDiscountTab()
  local isActive = false
  local discountMap = self:GetDiscountYearMonth()
  for k, v in pairs(discountMap) do
    isActive = true
    break
  end
  local obj = self.tabList[TabType.Discount].gameObject
  if obj.activeInHierarchy ~= isActive then
    obj:SetActive(isActive)
    self.tabGrid:Reposition()
  end
end

function LotteryHeadwearView:ShowMonthGroup(show)
  self.monthGroup:SetActive(show)
end

function LotteryHeadwearView:UpdateCurrentTab(force)
  if self:SwitchTab(TabType.Current) or force then
    if force then
      self.forceSet = true
    end
    self:_UpdateMonth()
  end
end

function LotteryHeadwearView:UpdateDiscountTab(force)
  if self:SwitchTab(TabType.Discount) or force then
    self:ShowMonthGroup(true)
    self:UpdateMonthGroup(self:FilterMonthGroup(FilterDiscountMonthGroup))
  end
end

function LotteryHeadwearView:UpdatePastTab(force)
  if self:SwitchTab(TabType.Past) or force then
    self:ShowMonthGroup(true)
    self:UpdateMonthGroup(self:FilterMonthGroup(FilterPastMonthGroup))
  end
end

function LotteryHeadwearView:UpdateCurMonth()
  if nil ~= self.lastMonthGroup then
    return
  end
  if self.tabType == TabType.Past then
    self:ShowMonthGroup(true)
    self:UpdateMonthGroup(self:FilterMonthGroup(FilterPastMonthGroup))
  elseif self.tabType == TabType.Discount then
    self:ShowMonthGroup(true)
    self:UpdateMonthGroup(self:FilterMonthGroup(FilterDiscountMonthGroup))
  elseif self.tabType == TabType.Current then
    self:_UpdateMonth()
  end
end

local blueColor, blueEffectColor = LuaColor.New(0.25882352941176473, 0.3803921568627451, 0.7529411764705882), LuaColor.New(0.12156862745098039, 0.23137254901960785, 0.5215686274509804)

function LotteryHeadwearView:SwitchTab(tabType)
  if self.tabType == tabType then
    return false
  end
  if self.tabType ~= nil then
    local old = self.tabList[self.tabType]
    old.label.color = ColorUtil.NGUIWhite
    old.label.effectColor = blueEffectColor
    old.label.fontSize = 18
    old.choose:SetActive(false)
  end
  local cur = self.tabList[tabType]
  cur.label.color = blueColor
  cur.label.effectColor = ColorUtil.NGUIWhite
  cur.label.fontSize = 20
  cur.choose:SetActive(true)
  self.tabType = tabType
  return true
end

function LotteryHeadwearView:UpdateMonthGroup(data)
  self.monthGroupCtl:ResetDatas(data)
  self.monthGroupScrollView:ResetPosition()
  self.lastMonthGroup = nil
  local cells = self.monthGroupCtl:GetCells()
  if 0 < #cells then
    self:ClickMonthGroup(cells[1])
  end
end

local realData = {}

function LotteryHeadwearView:UpdateMonth(data)
  if config.FormerLottery and config.FormerLottery == 0 then
    TableUtility.TableClear(realData)
    for _, d in pairs(data) do
      if d.month == self.curMonth and d.year == self.curYear then
        table.insert(realData, d)
      end
    end
    self.monthCtl:ResetDatas(realData)
    self.dotCtl:ResetDatas(realData)
  else
    self.monthCtl:ResetDatas(data)
    self.dotCtl:ResetDatas(data)
  end
  local cells = self.monthCtl:GetCells()
  if 0 < #cells then
    self:CenterOn(cells[1].trans)
  end
end

function LotteryHeadwearView:FilterMonthGroup(filterFunc)
  local list = self.monthGroupList
  TableUtility.ArrayClear(list)
  local info = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if info ~= nil then
    local groupList = info:GetMonthGroupList()
    local group
    for i = 1, #groupList do
      group = groupList[i]
      if filterFunc == nil or filterFunc(self, group) then
        list[#list + 1] = group
      end
    end
  end
  return list
end

function LotteryHeadwearView:FilterMonth(group, filterFunc)
  local list = self.monthList
  TableUtility.ArrayClear(list)
  local month
  local monthList = group:GetMonth()
  for i = 1, #monthList do
    month = monthList[i]
    if filterFunc == nil or filterFunc(self, month) then
      list[#list + 1] = month
    end
  end
  return list
end

function LotteryHeadwearView:GetDiscountYearMonth()
  local discountMap = self.discountMap
  TableUtility.TableClear(discountMap)
  local events = ActivityEventProxy.Instance:GetEvents(ActivityEventType.LotteryDiscount)
  if events ~= nil then
    local event
    local _LotteryProxy = LotteryProxy.Instance
    for i = 1, #events do
      event = events[i]
      local list = event:GetDiscount(self.lotteryType)
      if list ~= nil then
        local data
        for j = 1, #list do
          data = list[j]
          if data:IsInActivity() and _LotteryProxy:GetData(self.lotteryType, math.floor(data.yearmonth / 100), data.yearmonth % 100) ~= nil then
            discountMap[data.yearmonth] = 1
          end
        end
      end
    end
  end
  return discountMap
end
