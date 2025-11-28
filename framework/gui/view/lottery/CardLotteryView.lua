autoImport("LotteryView")
autoImport("PopupCombineCell")
autoImport("CardLotteryCell")
CardLotteryView = class("CardLotteryView", LotteryView)
CardLotteryView.ViewType = LotteryView.ViewType
local wrapConfig = {}
local LotteryConfig = GameConfig.Lottery
local TextMap = {
  [1] = "mall_twistedegg_bg_bottom",
  [2] = "mall_twistedegg_01"
}

function CardLotteryView:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  CardLotteryView.super.OnExit(self)
  if self.text then
    for i = 1, 2 do
      PictureManager.Instance:UnLoadUI(TextMap[i], self.text[i])
    end
  end
end

function CardLotteryView:OnEnter()
  if self.viewdata then
    self.lotteryType = self.viewdata.viewdata.lotteryType
  end
  self.lotteryType = self.lotteryType or 0
  self.cardConfig = LotteryConfig.CardLottery[self.lotteryType]
  self.lotteryName.text = self.cardConfig.lotteryName
  CardLotteryView.super.OnEnter(self)
  self:QueryLotteryExtraBonus()
  self:SetTenToggle(false)
  self:InitFilter()
  self:InitView()
end

function CardLotteryView:SetDuration()
  if self.cardConfig.duration or self.cardConfig.TFduration then
    self.isRelease = EnvChannel.IsReleaseBranch()
    self.lotteryTime.text = self.isRelease and self.cardConfig.duration or self.cardConfig.TFduration
  else
    local begin, endtime = LotteryProxy.Instance:GetUpDuration(self.lotteryType)
    if begin and endtime then
      local beginDate = os.date("%m/%d %H:%M", begin)
      local endDate = os.date("%m/%d %H:%M", endtime)
      self.lotteryTime.text = string.format(ZhString.CardLottery_UPDuration, beginDate, endDate)
    else
      self.lotteryTime.text = ""
    end
  end
end

function CardLotteryView:FindObjs()
  CardLotteryView.super.FindObjs(self)
  self.costTip = self:FindGO("CostTip")
  self.popUp = self:FindGO("PopUp")
  self.popUpCtrl = PopupCombineCell.new(self.popUp)
  self.popUpCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickFilter, self)
  self.tenToggle = self:FindGO("LotteryTenToggle")
  self.tenTSp = self:FindGO("checkSprite", self.tenToggle)
  self:SetTenToggle(false)
  self:AddClickEvent(self.tenToggle, function()
    self:SetTenToggle(not self.tenToggleFlag)
    self:UpdateCost()
    self:UpdateLimit()
  end)
  self.safatyTip = self:FindGO("safatyTip"):GetComponent(UILabel)
  self.safetyButton = self:FindGO("SafetyButton")
  self:AddClickEvent(self.safetyButton, function()
    TipManager.Instance:SetLotterySafetyTip(self.lotteryType, self.safatyTip, nil, {100, 0})
  end)
  self.text = {}
  self.text[1] = self:FindGO("bg"):GetComponent(UITexture)
  self.text[1].height = Screen.height * 2
  self.text[1].width = Screen.width * 2
  self.text[2] = self:FindGO("lotteryText"):GetComponent(UITexture)
  self.text[3] = self:FindGO("plus"):GetComponent(UITexture)
  if self.text[3] then
    self:Hide(self.text[3])
  end
  for i = 1, 2 do
    PictureManager.Instance:SetUI(TextMap[i], self.text[i])
  end
  self.lotteryName = self:FindGO("lotteryName"):GetComponent(UILabel)
  self.lotteryTime = self:FindGO("lotteryTime"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("effectContainer")
  local tenDesc = self:FindGO("tenDesc"):GetComponent(UILabel)
  tenDesc.text = ZhString.Lottery_Eleven
end

function CardLotteryView:UpdateSafety()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    if data:HasSafety() then
      self.safetyButton:SetActive(true)
      self.safatyTip.gameObject:SetActive(true)
      local itemtype, count = data:GetMostSafetyInfo()
      if 0 < count then
        self.safatyTip.text = string.format(ZhString.CardLottery_MostSafetyTip, count, self.cardConfig.filter[itemtype])
      else
        self.safatyTip.text = string.format(ZhString.CardLottery_InSafetyTip, self.cardConfig.filter[itemtype])
      end
    else
      self.safetyButton:SetActive(false)
      self.safatyTip.gameObject:SetActive(false)
    end
  end
end

function CardLotteryView:SetTenToggle(v)
  self.tenToggleFlag = v
  self.tenTSp:SetActive(v)
end

local popFlag = false

function CardLotteryView:ClickFilter()
  self.goal = self.popUpCtrl.goal
  self:UpdateCard()
end

function CardLotteryView:AddEvts()
  CardLotteryView.super.AddEvts(self)
  local help = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(self.cardConfig.helpID, help)
end

function CardLotteryView:AddViewEvts()
  CardLotteryView.super.AddViewEvts(self)
  self:AddListenEvt(LotteryEvent.RecvLotteryCardNewResult, self.RecvLotteryCardNewResult)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusItemCmd, self.OnRecvExtraBonusItemCmd)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd, self.OnRecvExtraBonusCfgCmd)
end

function CardLotteryView:RecvLotteryCardNewResult()
  redlog("RecvLotteryCardNewResult")
  self:PlayUIEffect(EffectMap.UI.LotteryCard_New, self.effectContainer, true)
end

function CardLotteryView:InitShow()
  CardLotteryView.super.InitShow(self)
  local detailContainer = self:FindGO("DetailContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "CardLotteryCell"
  wrapConfig.control = CardLotteryCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.saleIcon = self:FindGO("saleIcon", self.lotteryBtn)
  self.saleIcon:SetActive(false)
end

function CardLotteryView:InitView()
  CardLotteryView.super.InitView(self)
  self:UpdateCost()
  self:UpdateCard()
  self:UpdateLimit()
  self:UpdateSafety()
  self:SetDuration()
end

local AccMap = {
  [31] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [32] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}

function CardLotteryView:UpdateCost()
  local free = LotteryProxy.Instance:CheckHasFree(self.lotteryType)
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  local todayCount = MyselfProxy.Instance:GetAccVarValueByType(AccMap[self.lotteryType]) or 0
  if data then
    self.costValue = LotteryProxy.Instance:CalculteCardCost(self.lotteryType, todayCount, self.tenToggleFlag and 10 or 1)
    self.cost.text = free and _FreeCostStr or self.costValue
  end
  self.tenToggle:SetActive(not free)
end

function CardLotteryView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryCard_NEW)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function CardLotteryView:Skip()
  local skipType = LotteryProxy.Instance:GetSkipType(self.lotteryType)
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Left, {-160, 50})
end

function CardLotteryView:InitFilter()
  self.popUpCtrl:SetData(self.cardConfig.filter, nil, 1)
  self.goal = self.popUpCtrl.goal
end

function CardLotteryView:ResetCard()
  self:UpdateCard()
  self.detailHelper:ResetPosition()
end

function CardLotteryView:UpdateCard()
  local list = LotteryProxy.Instance:GetCardByItemtype(self.lotteryType, self.goal)
  if list then
    self.detailHelper:UpdateInfo(list, true)
  end
end

function CardLotteryView:CallLottery(price, year, month, times)
  if self.tenToggleFlag then
    times = 10
  else
    times = 1
  end
  price = self.costValue / times
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    local id = 295
    if data:IsPriceIncrease(self.lotteryType) then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(id, function()
          CardLotteryView.super.CallLottery(self, price, year, month, times, data.freeCount > 0)
        end, nil, nil, self.costValue)
        return
      end
    else
      LocalSaveProxy.Instance:RemoveDontShowAgain(id)
    end
  end
  CardLotteryView.super.CallLottery(self, price, year, month, times, data.freeCount > 0)
end

function CardLotteryView:UpdateLimit()
  if not self.saleIcon then
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  local count = MyselfProxy.Instance:GetAccVarValueByType(AccMap[self.lotteryType]) or 0
  local limit = LotteryConfig and LotteryConfig.ButtonShowSaleTimes or 0
  self.saleIcon:SetActive(GameConfig.Lottery.ButtonShowSale == true and count < limit)
  local sb = LuaStringBuilder.CreateAsTable()
  if data ~= nil then
    local todayCount, maxCount = 0, 0
    if self.tenToggleFlag then
      todayCount, maxCount = data.todayTenCount, data.maxTenCount
    else
      todayCount, maxCount = data.todayCount, data.maxCount
    end
    if maxCount ~= 0 then
      sb:Append(string.format(ZhString.Lottery_TodayLimit, todayCount, maxCount))
    end
    local funcStateCFG = Table_FuncState[9]
    local serverTime = ServerTime.CurServerTime() / 1000
    local validtime = Table_FuncTime[funcStateCFG.TimeID]
    if not self:CheckServerID(funcStateCFG.ServerID) or serverTime < validtime.StartTimeStamp or serverTime > validtime.EndTimeStamp then
      if 0 < #sb.content then
        sb:Append("  ")
      end
      sb:Append(string.format(ZhString.Lottery_CardLimit, data.todayExtraCount, data.maxExtraCount))
    end
  end
  local isShow = 0 < #sb.content
  if self.lotteryLimit and self.lotteryLimitBg and isShow then
    self.lotteryLimit.text = sb:ToString()
    self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 70
  end
  sb:Destroy()
end

function CardLotteryView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end
