autoImport("LotteryMagicDetailCell")
autoImport("PopupCombineCell")
LotteryMagic = class("LotteryMagic", SubView)
local _Eleven = 11
local _LotteryProxy, _LotteryFunc

function LotteryMagic:Init()
  _LotteryProxy = LotteryProxy.Instance
  _LotteryFunc = FunctionLottery.Me()
  self:FindObjs()
  self:InitShow()
end

function LotteryMagic:DoEnter()
  self.container.lotterySaleIcon:SetActive(false)
  self.container:ActivePurchaseRoot(true)
  self.container:ActiveLotteryName(true)
  self:InitDressModel()
  self:UpdateDetail()
end

function LotteryMagic:InitDressModel()
  local dressData = FunctionLottery.Me():InitDefaultDress(self.lotteryType) or _LotteryProxy:GetInitializedDressData(self.lotteryType)
  local _ = _LotteryFunc:InitDressMap(dressData, LotteryDressType.Magic)
  if _ then
    self.container:ShowModel()
  end
end

function LotteryMagic:OnEnter()
  LotteryMagic.super.OnEnter(self)
  self.container:UpdateCost()
  self:DoEnter()
end

function LotteryMagic:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  self.popUpCtl:ClearCallBack()
  LotteryMagic.super.OnExit(self)
end

function LotteryMagic:Show()
  self.lotteryType = self.container.lotteryType
  self.root:SetActive(true)
  self:DoEnter()
  self.container:ActiveLotteryTime(true)
end

function LotteryMagic:Hide()
  self.root:SetActive(false)
end

function LotteryMagic:FindObjs()
  self.root = self:FindGO("MagicRoot")
  self.discountRoot = self:FindGO("DiscountRoot")
  self.discount = self:FindComponent("Discount", UILabel, self.discountRoot)
  self.discountTime = self:FindComponent("DiscountTime", UILabel, self.discountRoot)
  local beforePanel = self:FindGO("BeforePanel", self.root)
  self.newTag = self:FindGO("NewTag", beforePanel)
  if self.newTag then
    self.newTag:SetActive(false)
  end
  self.popUpGo = self:FindGO("PopUp", beforePanel)
  self.popUpCtl = PopupCombineCell.new(self.popUpGo)
  self.popUpCtl:AddEventListener(MouseEvent.MouseClick, self.ClickFilter, self)
end

function LotteryMagic:ClickFilter()
  if self.goal == self.popUpCtl.goal then
    return
  end
  self.goal = self.popUpCtl.goal
  self:UpdateDetail()
end

function LotteryMagic:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end

function LotteryMagic:OnClickLotteryHelp()
  if BranchMgr.IsJapan() then
    TipsView.Me():ShowGeneralHelpByHelpId(994)
  else
    ServiceItemProxy.Instance:CallLotteryRateQueryCmd(self.lotteryType)
  end
end

function LotteryMagic:InitShow()
  self.lotteryType = self.container.lotteryType
  self.container.isUpdateRecover = true
  self.popUpCtl:SetData(GameConfig.Lottery.MagicFilter)
  self.goal = self.popUpCtl.goal
  local detailContainer = self:FindGO("DetailContainer", self.root)
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMagicDetailCell"
  wrapConfig.control = LotteryMagicDetailCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.detailHelper:AddEventListener(LotteryCell.ClickEvent, self.ClickCell, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
end

function LotteryMagic:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotteryMagic:ClickCell(cell)
  self.container:ClickCell(cell)
  local cells = self.detailHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:UpdateDressLab()
  end
end

function LotteryMagic:UpdateDetail(noReposition)
  local data = _LotteryProxy:FilterMagic(self.lotteryType, self.goal)
  if data then
    self.detailHelper:UpdateInfo(data)
    if not noReposition then
      self.detailHelper:ResetPosition()
    end
  end
end

function LotteryMagic:HandleItemUpdate(note)
  self.container:UpdateTicket()
  if self.container.isShowRecover then
    self.container:TryUpdateRecover()
  else
    self.container.isUpdateRecover = true
  end
  self:UpdateDetail(true)
end

function LotteryMagic:HandleLotteryRateQuery(data)
  if self.rateSb == nil then
    self.rateSb = LuaStringBuilder.CreateAsTable()
  else
    self.rateSb:Clear()
  end
  local desc = Table_Help[20008].Desc or ""
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

function LotteryMagic:HandleQueryLotteryInfo()
  self:InitDressModel()
  self:UpdateDetail()
end

function LotteryMagic:Ticket()
  self.container:CallTicket()
end

function LotteryMagic:TicketTen()
  self.container:CallTicket(nil, nil, _Eleven)
end

function LotteryMagic:UpdateDiscount()
  local aeDiscount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, AELotteryDiscountData.CoinType.Coin)
  if aeDiscount ~= nil and aeDiscount:IsInActivity() then
    self.discountRoot:SetActive(true)
    self.discount.text = string.format(ZhString.Lottery_Discount, 100 - aeDiscount.discount)
    local beginTime = os.date("*t", aeDiscount.beginTime)
    local endTime = os.date("*t", aeDiscount.endTime)
    self.discountTime.text = string.format(ZhString.Lottery_DiscountTime, beginTime.month, beginTime.day, endTime.month, endTime.day)
  else
    self.discountRoot:SetActive(false)
  end
end
