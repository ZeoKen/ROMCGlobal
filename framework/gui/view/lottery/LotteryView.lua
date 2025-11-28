LotteryView = class("LotteryView", ContainerView)
LotteryView.ViewType = UIViewType.NormalLayer
local _Ten = 10
local _AEDiscountCoinTypeCoin = AELotteryDiscountData.CoinType.Coin
local _AEDiscountCoinTypeTicket = AELotteryDiscountData.CoinType.Ticket
local serverItems = {}

function LotteryView:OnEnter()
  LotteryView.super.OnEnter(self)
  local _LotteryProxy = LotteryProxy.Instance
  _LotteryProxy:CallQueryLotteryInfo(self.lotteryType)
  _LotteryProxy:SetIsOpenView(true)
  self:NormalCameraFaceTo()
  self:sendNotification(LotteryEvent.LotteryViewEnter)
end

function LotteryView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function LotteryView:OnExit()
  if self.progressTexture and self.progressTextureName then
    PictureManager.Instance:UnLoadUI(self.progressTextureName, self.progressTexture)
  end
  if self.progressBg and self.progressBgName then
    PictureManager.Instance:UnLoadUI(self.progressBgName, self.progressBg)
  end
  LotteryProxy.Instance:SetIsOpenView(false)
  self:CameraReset()
  LotteryView.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function LotteryView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function LotteryView:FindObjs()
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.lotteryDiscount = self:FindGO("LotteryDiscount"):GetComponent(UILabel)
  self.lotteryLimit = self:FindGO("LotteryLimit"):GetComponent(UILabel)
  self.lotteryLimitBg = self:FindGO("Bg1", self.lotteryLimit.gameObject):GetComponent(UISprite)
  self.lotteryBtn = self:FindGO("LotteryBtn")
  self.ticketDiscount = self:FindGO("TicketDiscount")
  if self.ticketDiscount then
    self.ticketDiscount = self.ticketDiscount:GetComponent(UILabel)
  end
  self.ticketLimit = self:FindGO("TicketLimit")
  if self.ticketLimit then
    self.ticketLimit = self.ticketLimit:GetComponent(UILabel)
  end
  self.tenCost = self:FindGO("TenCost")
  if self.tenCost then
    self.tenCost = self.tenCost:GetComponent(UILabel)
  end
  self.lotteryTenBtn = self:FindGO("LotteryTenBtn")
  self.btnGrid = self:FindGO("BtnGrid")
  if self.btnGrid then
    self.btnGrid = self.btnGrid:GetComponent(UIGrid)
  end
  self.lotteryRoot = self:FindGO("LotteryRoot")
  self.recoverRoot = self:FindGO("RecoverRoot")
  self.recoverEmpty = self:FindGO("RecoverEmpty")
  self.recoverTotalLabel = self:FindComponent("RecoverTotalLabel", UILabel)
  self.recoverLabel = self:FindComponent("RecoverLabel", UILabel)
  self.recoverBtn = self:FindComponent("RecoverBtn", UIMultiSprite)
  self.detailRoot = self:FindGO("DetailRoot")
  self.extraBonusRoot = self:FindGO("ExtraBonusRoot")
  if self.extraBonusRoot then
    self.progressTexture = self:FindComponent("progressTexture", UITexture, self.extraBonusRoot)
    self.progressBg = self:FindComponent("progressBg", UITexture, self.extraBonusRoot)
    self.progressSlider = self:FindComponent("ProgressSlider", UISlider, self.extraBonusRoot)
    self.progressSliderSp = self:FindComponent("ProgressSlider", UISprite, self.extraBonusRoot)
    self.progressBackground = self:FindComponent("ProgressBackground", UISprite, self.progressSlider.gameObject)
    self.progressGrid = self:FindComponent("progressGrid", UIGrid, self.extraBonusRoot)
  end
  self.rewardTip = self:FindGO("RewardTip")
  if self.rewardTip then
    self.rewardTipLabel = self:FindComponent("TipLabel", UILabel, self.rewardTip)
    self.rewardTipGrid = self:FindComponent("RewardGrid", UIGrid, self.rewardTip)
  end
  self.rewardDetailBoard = self:FindGO("RewardDetailBoard")
  if self.rewardDetailBoard then
    self.rewardDetailGrid = self:FindComponent("RewardDetailGrid", UIGrid, self.rewardDetailBoard)
    self.rewardDetailBgCollider = self:FindGO("BgCollider", self.rewardDetailBoard)
    self.rewardDetailConfirmBtn = self:FindGO("RewardDetailConfirmBtn", self.rewardDetailBoard)
    self.rewardDetailFakeConfirmBtn = self:FindGO("RewardDetailFakeConfirmBtn", self.rewardDetailBoard)
    self.rewardDetailFakeConfirmLabel = self:FindComponent("Label", UILabel, self.rewardDetailFakeConfirmBtn)
    self.rewardDetailCancelBtn = self:FindGO("RewardDetailCancelBtn", self.rewardDetailBoard)
  end
end

function LotteryView:AddEvts()
  local addMoney = self:FindGO("AddMoney")
  self:AddClickEvent(addMoney, function()
    self:JumpZenyShop()
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.lotteryBtn, function()
    OverseaHostHelper:GachaUseComfirm(self.costValue, function()
      self:Lottery()
    end)
  end)
  local toRecoverBtn = self:FindGO("ToRecoverBtn")
  if toRecoverBtn then
    self:AddClickEvent(toRecoverBtn, function()
      self:ToRecover()
    end)
  end
  if self.lotteryTenBtn then
    self:AddClickEvent(self.lotteryTenBtn, function()
      OverseaHostHelper:GachaUseComfirm(self.costValue * 10, function()
        self:LotteryTen()
      end)
    end)
  end
  if self.rewardDetailConfirmBtn then
    self:AddClickEvent(self.rewardDetailConfirmBtn, function()
      local stage = LotteryProxy.Instance:GetCurrentExtraStageByType(self.lotteryType)
      if not stage then
        return
      end
      ServiceItemProxy.Instance:CallGetLotteryExtraBonusItemCmd(self.lotteryType, stage, self.npcId, self.rewardDetailRewardIndex)
    end)
  end
  if self.rewardDetailCancelBtn then
    self:AddClickEvent(self.rewardDetailCancelBtn, function()
      self.rewardDetailBoard:SetActive(false)
    end)
  end
  if self.rewardDetailBgCollider then
    self:AddClickEvent(self.rewardDetailBgCollider, function()
      self.rewardDetailBoard:SetActive(false)
    end)
  end
end

function LotteryView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryInfo, self.InitView)
  self:AddListenEvt(LotteryEvent.EffectStart, self.HandleEffectStart)
  self:AddListenEvt(LotteryEvent.EffectEnd, self.HandleEffectEnd)
  self:AddListenEvt(LotteryEvent.RefreshCost, self.HandleRefreshCost)
  self:AddListenEvt(ServiceEvent.ItemLotteryCmd, self.UpdateLimit)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.HandleActivityEventNtf)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, self.HandleActivityEventNtfEventCnt)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(XDEUIEvent.LotteryAnimationEnd, self.lotteryAnimationEnd)
end

function LotteryView:InitShow()
  self.tipData = {
    funcConfig = {}
  }
  local npcdata = self:GetNpcDataFromViewData()
  self.npcId = npcdata == nil and 0 or npcdata.data.id
  local moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  local lotteryIcon = self:FindGO("LotteryIcon"):GetComponent(UISprite)
  local lotteryTenIcon = self:FindGO("LotteryTenIcon")
  lotteryTenIcon = lotteryTenIcon and lotteryTenIcon:GetComponent(UISprite)
  local money = Table_Item[GameConfig.MoneyId.Lottery]
  if money then
    local icon = money.Icon
    if icon then
      IconManager:SetItemIcon(icon, moneyIcon)
      IconManager:SetItemIcon(icon, lotteryIcon)
      if lotteryTenIcon then
        IconManager:SetItemIcon(icon, lotteryTenIcon)
      end
    end
  end
  if self.extraBonusRoot then
    self.extraBonusRoot:SetActive(false)
    autoImport("ExtraBonusCell")
    self.progressCtrl = UIGridListCtrl.new(self.progressGrid, ExtraBonusCell, "ExtraBonusCell")
    self.progressCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExtraBonus, self)
  end
  if self.rewardTip then
    autoImport("MaterialItemCell")
    self.rewardTipItemCtrl = UIGridListCtrl.new(self.rewardTipGrid, MaterialItemCell, "MaterialItemCell")
    self.rewardTipItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardTipCell, self)
  end
  if self.rewardDetailBoard then
    autoImport("MaterialSelectItemCell")
    self.rewardDetailItemCtrl = UIGridListCtrl.new(self.rewardDetailGrid, MaterialSelectItemCell, "MaterialSelectItemCell")
    self.rewardDetailItemCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressRewardDetailItem, self)
  end
  self:UpdateMoney()
  self:UpdateSkip()
end

function LotteryView:InitView()
  self:UpdateDiscount()
  self:UpdateLimit()
  self:UpdateOnceMaxCount()
end

function LotteryView:JumpZenyShop()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
end

function LotteryView:Skip()
  local skipType = LotteryProxy.Instance:GetSkipType(self.lotteryType)
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
end

function LotteryView:Lottery()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price)
  end
end

function LotteryView:LotteryTen()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price, nil, nil, _Ten)
  end
end

function LotteryView:ToRecover()
  self:ShowRecover(true)
  if self.isUpdateRecover then
    self:UpdateRecover()
    self.isUpdateRecover = false
  end
end

function LotteryView:Recover()
  local ticketName = self.ticketName
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  local rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
  ticketName = Table_Item[rItemId].NameZh
  if self.canRecover then
    local isExist, ticketCount = LotteryProxy.Instance:GetSpecialEquipCount(self.recoverSelect, self.lotteryType)
    if isExist then
      MsgManager.DontAgainConfirmMsgByID(3556, function()
        self:CheckRecover()
        helplog("CallLotteryRecoveryCmd")
        ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self:_GetRecoverList(), self.npcId, self.lotteryType)
      end, nil, nil, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName, ticketCount, ticketName)
    else
      MsgManager.ConfirmMsgByID(3552, function()
        self:CheckRecover()
        helplog("CallLotteryRecoveryCmd")
        ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self:_GetRecoverList(), self.npcId, self.lotteryType)
      end, nil, nil, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName)
    end
  end
end

function LotteryView:CheckRecover()
  local bagData = BagProxy.Instance.bagData
  if not bagData:IsFull() then
    self.isRecover = true
  end
end

function LotteryView:_GetRecoverList()
  TableUtility.ArrayClear(serverItems)
  local _LotteryProxy = LotteryProxy.Instance
  local id, data
  for i = 1, #self.recoverSelect do
    id = self.recoverSelect[i]
    data = _LotteryProxy:GetRecoverData(self.lotteryType, id)
    if data ~= nil then
      local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sitem.guid = id
      sitem.count = data.selectCount
      serverItems[#serverItems + 1] = sitem
    end
  end
  return serverItems
end

function LotteryView:CallLottery(price, year, month, times, free_count)
  FunctionSecurity.Me():OpenLottery(function()
    self:_CallLottery(price, year, month, times, free_count)
  end, arg)
end

function LotteryView:_CallLottery(price, year, month, times, free_count)
  local _LotteryProxy = LotteryProxy.Instance
  local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
  local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
  _LotteryProxy:CallLottery(self.lotteryType, year, month, self.npcId, price, self.costValue, skipValue, times, free_count)
end

function LotteryView:CallTicket(year, month, times)
  FunctionSecurity.Me():OpenLottery(function()
    self:_CallTicket(year, month, times)
  end, arg)
end

function LotteryView:_CallTicket(year, month, times)
  times = times or 1
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local cost, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count * times)
    if cost ~= self.ticketCostValue and not discount:IsInActivity() then
      MsgManager.ConfirmMsgByID(25314, function()
        self:UpdateTicketCost()
        self:UpdateDiscount()
        self:UpdateLimit()
      end)
      return
    end
    if cost > BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid) then
      MsgManager.ShowMsgByID(3554, self.ticketName)
      return
    end
    local _LotteryProxy = LotteryProxy.Instance
    local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
    local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
    ServiceItemProxy.Instance:CallLotteryCmd(year, month, self.npcId, skipValue, nil, Ticket.itemid, self.lotteryType, times)
  end
end

function LotteryView:InitTen()
  local lotteryTenIcon = self:FindGO("LotteryTenIcon"):GetComponent(UISprite)
  local money = Table_Item[GameConfig.MoneyId.Lottery]
  if money and money.Icon then
    IconManager:SetItemIcon(money.Icon, lotteryTenIcon)
  end
end

function LotteryView:InitTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local ticketIcon = self:FindGO("TicketIcon"):GetComponent(UISprite)
    local ticketCostIcon = self:FindGO("TicketCostIcon"):GetComponent(UISprite)
    local ticket = Table_Item[Ticket.itemid]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, ticketIcon)
      IconManager:SetItemIcon(ticket.Icon, ticketCostIcon)
      self.ticketName = ticket.NameZh
    end
  end
end

function LotteryView:InitRecover()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local recoverIcon = self:FindGO("RecoverIcon"):GetComponent(UISprite)
    local toRecoverIcon = self:FindGO("ToRecoverIcon"):GetComponent(UISprite)
    local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
    local rItemId = Ticket.itemid
    rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
    local ticket = Table_Item[rItemId]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, recoverIcon)
      IconManager:SetItemIcon(ticket.Icon, toRecoverIcon)
      recoverTitle.text = string.format(ZhString.Lottery_RecoverTitle, ticket.NameZh)
    end
  end
end

function LotteryView:ShowRecover(isShow)
  self.isShowRecover = isShow
  if self.lotteryRoot then
    self.lotteryRoot:SetActive(not isShow)
  end
  if self.recoverRoot then
    self.recoverRoot:SetActive(isShow)
  end
end

function LotteryView:ShowDetail(isShow)
  if self.lotteryRoot then
    self.lotteryRoot:SetActive(not isShow)
  end
  if self.detailRoot then
    self.detailRoot:SetActive(isShow)
  end
end

function LotteryView:UpdateMoney()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  end
end

function LotteryView:UpdateCost()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:UpdateCostValue(data.price, data.onceMaxCount)
  end
end

function LotteryView:UpdateCostValue(cost, onceMaxCount)
  self.costValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, cost)
  self.cost.text = self.costValue
  if self.tenCost and onceMaxCount == _Ten then
    self.tenCost.text = self.costValue * _Ten
  end
end

function LotteryView:UpdateTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid))
  end
end

function LotteryView:UpdateTicketCost()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticketCostValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count)
    self.ticketCost.text = self.ticketCostValue
  end
end

function LotteryView:UpdateSkip()
end

function LotteryView:getSkip()
  local _LotteryProxy = LotteryProxy.Instance
  local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
  return _LotteryProxy:IsSkipGetEffect(skipType)
end

function LotteryView:lotteryAnimationEnd()
  if self.isShowRecover and self:getSkip() == false then
    self:TryUpdateRecover(true)
  end
end

function LotteryView:TryUpdateRecover(animationEnd)
  if self.isRecover then
    self:UpdateRecover()
    self.isRecover = false
  elseif self:getSkip() == true or animationEnd then
    self:UpdateRecover()
  end
end

function LotteryView:UpdateRecover()
  local data = LotteryProxy.Instance:GetRecover(self.lotteryType)
  if data then
    local newData = self:ReUniteCellData(data, 3)
    self.recoverHelper:UpdateInfo(newData)
    self.recoverHelper:ResetPosition()
    self.recoverEmpty:SetActive(#data == 0)
  end
  TableUtility.ArrayClear(self.recoverSelect)
  self:UpdateRecoverBtn()
end

function LotteryView:UpdateRecoverBtn()
  local total = LotteryProxy.Instance:GetRecoverTotalCost(self.recoverSelect, self.lotteryType)
  self.recoverTotalLabel.text = total
  self.canRecover = #self.recoverSelect > 0
  if self.canRecover then
    self.recoverBtn.CurrentState = 0
    self.recoverLabel.effectStyle = UILabel.Effect.Outline
  else
    self.recoverBtn.CurrentState = 1
    self.recoverLabel.effectStyle = UILabel.Effect.None
  end
end

function LotteryView:UpdateDiscount()
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local discountValue = coinDiscount:GetDiscount()
    local isShow = discountValue ~= 100
    self.lotteryDiscount.gameObject:SetActive(isShow)
    if isShow then
      self.lotteryDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
    end
  elseif self.lotteryDiscount ~= nil then
    self.lotteryDiscount.gameObject:SetActive(false)
  end
  if self.ticketDiscount then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    if ticketDiscount ~= nil then
      local discountValue = ticketDiscount:GetDiscount()
      local isShow = discountValue ~= 100
      self.ticketDiscount.gameObject:SetActive(isShow)
      if isShow then
        self.ticketDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
      end
    else
      self.ticketDiscount.gameObject:SetActive(false)
    end
  end
end

function LotteryView:UpdateOnceMaxCount()
  if self.lotteryTenBtn then
    local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
    if data ~= nil then
      local isTen = data.onceMaxCount == _Ten
      self.lotteryTenBtn:SetActive(isTen)
      self.btnGrid.cellWidth = isTen and 220 or 290
      self.btnGrid:Reposition()
      local trans = self.lotteryLimit.transform
      local tempVector3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(trans))
      if isTen then
        tempVector3[1] = -356
      else
        tempVector3[1] = -393
      end
      trans.localPosition = tempVector3
    end
  end
end

function LotteryView:UpdateLimit()
  local sb = LuaStringBuilder.CreateAsTable()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data ~= nil then
    if data.maxCount ~= 0 then
      sb:Append(string.format(ZhString.Lottery_TodayLimit, data.todayCount, data.maxCount))
    end
    if self.lotteryType == LotteryType.Card or self.lotteryType == LotteryType.NewCard or self.lotteryType == LotteryType.NewCard_Activity then
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
  end
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local isShow = coinDiscount:IsInActivity() and coinDiscount.count ~= 0
    if isShow then
      if 0 < #sb.content then
        sb:Append("  ")
      end
      sb:Append(string.format(ZhString.Lottery_DiscountLimit, coinDiscount.usedCount, coinDiscount.count))
    end
  end
  if self.ticketLimit then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    local hidelimit = GameConfig.Lottery.ShowTicketLimit == false
    if ticketDiscount ~= nil and not hidelimit then
      local isShow = ticketDiscount:IsInActivity() and ticketDiscount.count ~= 0
      self.ticketLimit.gameObject:SetActive(isShow)
      if isShow then
        self.ticketLimit.text = string.format(ZhString.Lottery_DiscountLimit, ticketDiscount.usedCount, ticketDiscount.count)
      end
    else
      self.ticketLimit.gameObject:SetActive(false)
    end
  end
  local isShow = 0 < #sb.content
  if self.lotteryLimit and self.lotteryLimitBg then
    self.lotteryLimit.gameObject:SetActive(BranchMgr.IsChina() and isShow)
    if isShow then
      self.lotteryLimit.text = sb:ToString()
      self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 70
    end
  end
  sb:Destroy()
end

function LotteryView:GetDiscountByCoinType(cointype, price)
  return LotteryProxy.Instance:GetDiscountByCoinType(self.lotteryType, cointype, price)
end

function LotteryView:ClickRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, 1)
  end
end

function LotteryView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {-220, 0})
  end
end

function LotteryView:SelectRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, -1)
  end
end

function LotteryView:_SelectCount(cell, offset)
  local data = cell.data
  local originalCount = data.selectCount
  cell:SelectCount(offset)
  if originalCount == 0 and data.selectCount > 0 then
    TableUtility.ArrayPushBack(self.recoverSelect, data.itemData.id)
  elseif 0 < originalCount and data.selectCount == 0 then
    TableUtility.ArrayRemove(self.recoverSelect, data.itemData.id)
  end
  self:UpdateRecoverBtn()
end

function LotteryView:HandleEffectStart()
  self:SetActionBtnsActive(false)
  if LotteryProxy.Instance:IsPocketLotteryViewShowing() then
    return
  end
  self.gameObject:SetActive(false)
  self:CameraReset()
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    local viewPort = CameraConfig.Lottery_Effect_ViewPort
    local rotation = CameraConfig.Lottery_Rotation
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end

function LotteryView:HandleEffectEnd()
  self:SetActionBtnsActive(true)
  if LotteryProxy.Instance:IsPocketLotteryViewShowing() then
    return
  end
  self.gameObject:SetActive(true)
  self:CameraReset()
  self:NormalCameraFaceTo()
end

function LotteryView:HandleRefreshCost()
  self:UpdateCost()
  self:UpdateDiscount()
  self:UpdateLimit()
end

function LotteryView:HandleActivityEventNtf(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end

function LotteryView:HandleActivityEventNtfEventCnt(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end

function LotteryView:NormalCameraFaceTo()
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    local viewPort = CameraConfig.Lottery_ViewPort
    local rotation = CameraConfig.Lottery_Rotation
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end

function LotteryView:ReUniteCellData(datas, perRowNum)
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

function LotteryView:GetNpcDataFromViewData()
  local viewdata = self.viewdata.viewdata
  if not viewdata or type(viewdata) ~= "table" then
    return nil
  end
  return viewdata.npcdata
end

function LotteryView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
    GameFacade.Instance:sendNotification(LotteryEvent.LotteryViewClose)
  end)
end

function LotteryView:SetActionBtnsActive(isActive)
  isActive = isActive or false
  if self.btnGrid then
    self.btnGrid.gameObject:SetActive(isActive)
  else
    if self.lotteryBtn then
      self.lotteryBtn:SetActive(isActive)
    end
    if self.ticketBtn then
      self.ticketBtn:SetActive(isActive)
    end
  end
end

function LotteryView:CheckServerID(ServerIDs)
  if not ServerIDs or #ServerIDs == 0 then
    return false
  end
  local server = FunctionLogin.Me():getCurServerData()
  local linegroup = 0
  if server then
    linegroup = server.linegroup or 1
  end
  if ServerIDs then
    for n, m in pairs(ServerIDs) do
      if m == linegroup then
        return true
      end
    end
  end
  return false
end

function LotteryView:QueryLotteryExtraBonus()
  ServiceItemProxy.Instance:CallQueryLotteryExtraBonusCfgCmd(self.lotteryType)
  ServiceItemProxy.Instance:CallQueryLotteryExtraBonusItemCmd(self.lotteryType)
end

function LotteryView:OnRecvExtraBonusItemCmd()
  if self.extraBonusShown then
    self:UpdateExtraBonus()
  end
end

function LotteryView:OnRecvExtraBonusCfgCmd()
  if self.extraBonusShown then
    self:UpdateExtraBonus()
  else
    self:ShowExtraBonus()
    self.extraBonusShown = true
  end
end

local extraBonusProgressGridMap = {
  [3] = {
    cellHeight = 130,
    sliderHeight = 380,
    progressNode = {
      0.177,
      0.583,
      1
    }
  },
  [4] = {
    cellHeight = 130,
    sliderHeight = 475,
    progressNode = {
      0.138,
      0.423,
      0.72,
      1
    }
  },
  [5] = {
    cellHeight = 130,
    sliderHeight = 590,
    progressNode = {
      0.136,
      0.349,
      0.569,
      0.783,
      1
    }
  },
  [6] = {
    cellHeight = 130,
    sliderHeight = 736,
    progressNode = {
      0.136,
      0.2,
      0.349,
      0.569,
      0.783,
      1
    }
  }
}

function LotteryView:GetExtraBonusProgressGridCfg(index)
  return extraBonusProgressGridMap[index]
end

function LotteryView:ShowExtraBonus()
  local extraDatas = LotteryProxy.Instance:GetExtraBonusList(self.lotteryType)
  if not extraDatas then
    return
  end
  local gridconfig = self:GetExtraBonusProgressGridCfg(#extraDatas)
  if not gridconfig then
    return
  end
  if self.progressGrid then
    self.progressGrid.cellHeight = gridconfig.cellHeight or 0
  end
  if self.progressSliderSp then
    self.progressSliderSp.height = gridconfig.sliderHeight
  end
  if self.progressBackground then
    self.progressBackground.height = gridconfig.sliderHeight
  end
  if self.progressTexture then
    self.progressTextureName = gridconfig.text
    PictureManager.Instance:SetUI(self.progressTextureName, self.progressTexture)
    self.progressTexture:MakePixelPerfect()
  end
  if self.progressBg then
    self.progressBgName = gridconfig.bg
    PictureManager.Instance:SetUI(self.progressBgName, self.progressBg)
    self.progressBg:MakePixelPerfect()
  end
  self.stepMap = self.stepMap or {}
  TableUtility.TableClear(self.stepMap)
  local keylist = LotteryProxy.Instance:GetKeyList(self.lotteryType)
  local max = LotteryProxy.Instance:GetMaxExtraCount(self.lotteryType)
  for i = 1, #keylist do
    if not gridconfig.progressNode then
      self.stepMap[keylist[i]] = 1 / max
    else
      self.stepMap[keylist[i]] = (gridconfig.progressNode[i] - (gridconfig.progressNode[i - 1] or 0)) / (keylist[i] - (keylist[i - 1] or 0))
    end
  end
  self:UpdateExtraBonus()
end

function LotteryView:UpdateExtraBonus()
  if not self.extraBonusRoot then
    return
  end
  local current = LotteryProxy.Instance:GetCurrentExtraCount(self.lotteryType)
  if not current then
    return
  end
  if self.progressTexture then
    local keylist = LotteryProxy.Instance:GetKeyList(self.lotteryType)
    local currentAmount = 0
    for i = 1, #keylist do
      if current >= keylist[i] then
        currentAmount = currentAmount + self.stepMap[keylist[i]] * (keylist[i] - (keylist[i - 1] or 0))
      else
        local temp = current - (keylist[i - 1] or 0)
        if temp < 0 then
          temp = 0
        end
        currentAmount = currentAmount + (self.stepMap[keylist[i]] or 0) * temp
      end
    end
    self.progressTexture.fillAmount = currentAmount
  end
  local extraDatas = LotteryProxy.Instance:GetExtraBonusList(self.lotteryType)
  if extraDatas and self.progressCtrl then
    self.progressCtrl:ResetDatas(extraDatas)
    local cells = self.progressCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:UpdateStatus(current)
    end
    self.extraBonusRoot:SetActive(true)
  else
    self.extraBonusRoot:SetActive(false)
  end
  if self.rewardTip then
    self.rewardTip:SetActive(false)
  end
  if self.rewardDetailBoard then
    self.rewardDetailBoard:SetActive(false)
  end
end

function LotteryView:OnClickExtraBonus(cell)
  if not cell or not cell.data then
    return
  end
  local ins = LotteryProxy.Instance
  local stage = ins:GetCurrentExtraStageByType(self.lotteryType)
  if not stage then
    return
  end
  local list = cell.data.itemids
  if not list or #list < 1 then
    return
  end
  if #list == 1 then
    if stage <= ins:GetCurrentExtraCount(self.lotteryType) then
      ServiceItemProxy.Instance:CallGetLotteryExtraBonusItemCmd(self.lotteryType, stage, self.npcId, 1)
    else
      self:ShowRewardItemTip(cell.itemid, cell.itemIcon)
    end
  else
    self:ShowExtraRewardTip(cell.key, list)
  end
end

function LotteryView:OnClickRewardTipCell(cell)
  if not cell or not cell.data then
    return
  end
  self.rewardDetailRewardIndex = cell.data.rewardIndex or 0
  if self.rewardDetailRewardIndex < 1 then
    return
  end
  self.rewardDetailBoard:SetActive(true)
  self.rewardDetailItemDatas = self.rewardDetailItemDatas or {}
  self.rewardDetailItemDatas[1] = cell.data
  self.rewardDetailItemCtrl:ResetDatas(self.rewardDetailItemDatas)
  local ins = LotteryProxy.Instance
  local stage = ins:GetCurrentExtraStageByType(self.lotteryType)
  local canGet = stage and stage <= ins:GetCurrentExtraCount(self.lotteryType)
  local isReceived = ins:CheckReceive(self.lotteryType, self.rewardTipKey)
  local isShow = canGet and not isReceived
  self.rewardDetailConfirmBtn:SetActive(isShow)
  self.rewardDetailFakeConfirmBtn:SetActive(not isShow)
  self.rewardDetailFakeConfirmLabel.text = isReceived and ZhString.Tutor_TaskTake or ZhString.Tutor_ReceiveReward
end

function LotteryView:OnLongPressRewardDetailItem(param)
  local isPressing, cell = param[1], param[2]
  self:ShowRewardItemTip(cell.data.staticData.id, cell.icon)
end

function LotteryView:ShowExtraRewardTip(key, datas)
  if not datas or #datas <= 1 then
    return
  end
  self.rewardTip:SetActive(true)
  self.rewardTipKey = key
  self.rewardTipItemDatas = self.rewardTipItemDatas or {}
  local rData
  for i = 1, #datas do
    rData = datas[i]
    if rData then
      self.rewardTipItemDatas[i] = self.rewardTipItemDatas[i] or ItemData.new()
      self.rewardTipItemDatas[i]:ResetData(MaterialItemCell.MaterialType.Material, rData.itemid)
      self.rewardTipItemDatas[i].num = rData.count
      self.rewardTipItemDatas[i].rewardIndex = i
    end
  end
  for i = #datas + 1, #self.rewardTipItemDatas do
    self.rewardTipItemDatas[i] = nil
  end
  self.rewardTipLabel.text = string.format(ZhString.Lottery_ExtraRewardTipFormat, ZhString.ChinaNumber[#datas])
  self.rewardTipItemCtrl:ResetDatas(self.rewardTipItemDatas)
end

local rewardTipData, rewardTipOffset = {
  funcConfig = _EmptyTable,
  noSelfClose = false
}, {210, -220}

function LotteryView:ShowRewardItemTip(itemId, stick)
  if not rewardTipData.itemdata then
    rewardTipData.itemdata = ItemData.new()
  end
  rewardTipData.itemdata:ResetData("Reward", itemId)
  self:ShowItemTip(rewardTipData, stick, NGUIUtil.AnchorSide.Right, rewardTipOffset)
end
