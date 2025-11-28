autoImport("LotteryCardCell")
autoImport("PopupCombineCell")
LotteryCard = class("LotteryCard", SubView)
local _LotteryConfig = GameConfig.Lottery
local _DontShowAgainMsgID = 295

function LotteryCard:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  self.popUpCtl:ClearCallBack()
  LotteryCard.super.OnExit(self)
end

function LotteryCard:DoEnter()
  self:ResetCard()
  self.container:ActivePurchaseRoot(true)
  self:UpdateLotterySaleIcon()
  self.container:ActiveLotteryTime(true)
end

function LotteryCard:OnEnter()
  LotteryCard.super.OnEnter(self)
  self:DoEnter()
end

function LotteryCard:Show()
  self.root:SetActive(true)
  self:DoEnter()
end

function LotteryCard:Hide()
  self.root:SetActive(false)
end

function LotteryCard:Init()
  self:FindObjs()
  self:InitShow()
end

function LotteryCard:FindObjs()
  self.root = self:FindGO("CardRoot")
  self.popUp = self:FindGO("PopUp", self.root)
  self.goal = 0
  self.popUpCtl = PopupCombineCell.new(self.popUp)
  self.popUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFilter, self)
  self.popUpCtl:SetData(GameConfig.CardMake.RandomFilter, nil, 1)
end

function LotteryCard:OnClickFilter()
  if self.goal == self.popUpCtl.goal then
    return
  end
  self.goal = self.popUpCtl.goal
  self:ResetCard()
end

function LotteryCard:InitShow()
  self.lotteryType = self.container.lotteryType
  local detailContainer = self:FindGO("WrapContainer", self.root)
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryCardCell"
  wrapConfig.control = LotteryCardCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
  self:UpdateCard()
end

function LotteryCard:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotteryCard:ResetCard()
  self:UpdateCard()
  self.detailHelper:ResetPosition()
end

function LotteryCard:UpdateCard()
  local list = LotteryProxy.Instance:FilterCard(self.goal)
  if list then
    self.detailHelper:UpdateInfo(list)
  end
end

function LotteryCard:HandleLotteryRateQuery(data)
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

function LotteryCard:OnClickLotteryHelp()
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
  else
    if not GameConfig.SystemForbid.LotteryRateUrl then
      self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
    end
    local list = LotteryProxy.Instance:FilterCard(0)
    for i = 1, #list do
      local single = list[i]
      if single.rate ~= 0 then
        self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip2, Table_Item[single.itemid].NameZh or "", single.rate / 10000))
      end
    end
  end
  TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
end

function LotteryCard:Lottery()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    if data:IsPriceIncrease(self.lotteryType) then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(_DontShowAgainMsgID)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(_DontShowAgainMsgID, function()
          self.container:CallLottery(data.price, nil, nil, 1, data.freeCount)
        end, nil, nil, self.container.lotteryCostValue)
        return
      end
    else
      LocalSaveProxy.Instance:RemoveDontShowAgain(_DontShowAgainMsgID)
    end
  end
  self.container:CallLottery(data.price, nil, nil, 1, data.freeCount)
end

function LotteryCard:UpdateLimit()
  self.container:BaseUpdateLimit()
  self:UpdateLotterySaleIcon()
end

function LotteryCard:UpdateLotterySaleIcon()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  local count = data and data.todayCount or 0
  local limit = _LotteryConfig and _LotteryConfig.ButtonShowSaleTimes or 0
  self.container.lotterySaleIcon:SetActive(_LotteryConfig and _LotteryConfig.ButtonShowSale == true and count < limit)
end

function LotteryCard:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end

function LotteryCard:HandleQueryLotteryInfo()
  self:ResetCard()
end
