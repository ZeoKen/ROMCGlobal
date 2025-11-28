autoImport("LotterySpaceTimeCell")
autoImport("PopupCombineCell")
LotterySpaceTime = class("LotterySpaceTime", SubView)
local _Eleven = 11
local _LotteryProxy, _LotteryFunc

function LotterySpaceTime:Init()
  _LotteryProxy = LotteryProxy.Instance
  _LotteryFunc = FunctionLottery.Me()
  self:FindObjs()
  self:InitShow()
end

function LotterySpaceTime:DoEnter()
  self.container.lotterySaleIcon:SetActive(false)
  self.container:ActivePurchaseRoot(true)
  self.container:ActiveLotteryName(true)
  self:InitDressModel()
  self:UpdateDetail()
end

function LotterySpaceTime:InitDressModel()
  local dressData = FunctionLottery.Me():InitDefaultDress(self.lotteryType) or _LotteryProxy:GetInitializedDressData(self.lotteryType)
  local _ = _LotteryFunc:InitDressMap(dressData, LotteryDressType.SpaceTime)
  if _ then
    self.container:ShowModel()
  end
end

function LotterySpaceTime:OnEnter()
  LotterySpaceTime.super.OnEnter(self)
  self.container:UpdateCost()
  self:DoEnter()
end

function LotterySpaceTime:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  self.popUpCtl:ClearCallBack()
  LotterySpaceTime.super.OnExit(self)
end

function LotterySpaceTime:Show()
  self.lotteryType = self.container.lotteryType
  self.root:SetActive(true)
  self:DoEnter()
  self.container:ActiveLotteryTime(true)
end

function LotterySpaceTime:Hide()
  self.root:SetActive(false)
end

function LotterySpaceTime:FindObjs()
  self.root = self:FindGO("SpaceTimeRoot")
  local beforePanel = self:FindGO("BeforePanel", self.root)
  self.popUpGo = self:FindGO("PopUp", beforePanel)
  self.popUpCtl = PopupCombineCell.new(self.popUpGo)
end

function LotterySpaceTime:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end

function LotterySpaceTime:OnClickLotteryHelp()
  if BranchMgr.IsJapan() then
    TipsView.Me():ShowGeneralHelpByHelpId(994)
  else
    ServiceItemProxy.Instance:CallLotteryRateQueryCmd(self.lotteryType)
  end
end

function LotterySpaceTime:InitShow()
  self.lotteryType = self.container.lotteryType
  self.popUpCtl:SetData(GameConfig.Lottery.SpaceTimeFilter)
  self.goal = self.popUpCtl.goal
  local detailContainer = self:FindGO("DetailContainer", self.root)
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMagicDetailCell"
  wrapConfig.control = LotterySpaceTimeCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.detailHelper:AddEventListener(LotteryCell.ClickEvent, self.ClickCell, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
end

function LotterySpaceTime:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotterySpaceTime:ClickCell(cell)
  self.container:ClickCell(cell)
  local cells = self.detailHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:UpdateDressLab()
  end
end

function LotterySpaceTime:UpdateDetail(noReposition)
  local items = _LotteryProxy:GetSpaceTimeLotteryData()
  if items then
    self.detailHelper:UpdateInfo(items)
    if not noReposition then
      self.detailHelper:ResetPosition()
    end
  end
end

function LotterySpaceTime:HandleItemUpdate(note)
  self.container:UpdateTicket()
  self:UpdateDetail(true)
end

function LotterySpaceTime:HandleLotteryRateQuery(data)
  if self.rateSb == nil then
    self.rateSb = LuaStringBuilder.CreateAsTable()
  else
    self.rateSb:Clear()
  end
  local desc = Table_Help[32645] and Table_Help[32645].Desc or ""
  local lines = string.split(desc, "\n")
  for _, v in pairs(lines) do
    self.rateSb:AppendLine(v)
  end
  self.rateSb:AppendLine("")
  if not GameConfig.SystemForbid.LotteryRateUrl then
    self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
  end
  if not BranchMgr.IsKorea() then
    self.rateSb:AppendLine(ZhString.Lottery_MagicRateTip)
    self.rateSb:AppendLine("")
    local _ItemType = GameConfig.Lottery.ItemType
    local leftRate = 100
    for i = 1, #data.infos do
      local info = data.infos[i]
      if info.rate ~= 0 then
        self.rateSb:Append(_ItemType[info.type] or "")
        self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip, info.rate / 10000))
        leftRate = leftRate - info.rate / 10000
      end
    end
  end
  TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
end

function LotterySpaceTime:HandleQueryLotteryInfo()
  self:InitDressModel()
  self:UpdateDetail()
end

function LotterySpaceTime:Ticket()
  self.container:CallTicket()
end

function LotterySpaceTime:TicketTen()
  self.container:CallTicket(nil, nil, _Eleven)
end
