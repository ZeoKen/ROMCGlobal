autoImport("LotteryBaseView")
autoImport("LotteryDollCell")
LotteryDollView = class("LotteryDollView", LotteryBaseView)
LotteryDollView.ViewType = LotteryBaseView.NormalLayer

function LotteryDollView:OnEnter()
  LotteryDollView.super.OnEnter(self)
  self.coverPanelGO:SetActive(true)
  self.detailPanelGO:SetActive(false)
  ServiceItemProxy.Instance:CallLotteryDollQueryItemCmd()
end

function LotteryDollView:OnExit()
  LotteryDollView.super.OnExit(self)
end

function LotteryDollView:FindObjs()
  LotteryDollView.super.FindObjs(self)
  self.detailContainer = self:FindGO("DetailContainer")
  self.detailHelper = WrapListCtrl.new(self.detailContainer, LotteryDollCell, "LotteryDollCell", WrapListCtrl_Dir.Vertical, 1, 0, true)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.costMenuIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  self.costMenuLabel = self:FindGO("Money"):GetComponent(UILabel)
  self.detailPanelGO = self:FindGO("DetailPanel")
  self.detailCloseBtnGO = self:FindGO("Back", self.detailPanelGO)
  self.detailHelpBtnGO = self:FindGO("HelpButton", self.detailPanelGO)
  self.lotteryRootGO = self:FindGO("LotteryRoot")
  self.coverPanelGO = self:FindGO("CoverPanel")
  self.coverImage = self:FindGO("CoverBackground", self.coverPanelGO):GetComponent(UITexture)
  self.detailBtnGO = self:FindGO("DetailBtn", self.coverPanelGO)
  self.skipBtnGO = self:FindGO("SkipBtn")
  self.skipBtn = self.skipBtnGO:GetComponent(UISprite)
  self:AddOrRemoveGuideId(self.lotteryBtnGO, 509)
end

function LotteryDollView:AddEvts()
  self:AddClickEvent(self.lotteryBtnGO, function()
    self:OnUseTicketClicked()
  end)
  self:AddClickEvent(self.detailBtnGO, function()
    self:OnGotoDetailClicked()
  end)
  self:AddClickEvent(self.detailCloseBtnGO, function()
    self:OnGoToCoverClicked()
  end)
  self:AddClickEvent(self.skipBtnGO, function()
    self:OnSkipClicked()
  end)
  self:RegistShowGeneralHelpByHelpID(35040, self.detailHelpBtnGO)
end

function LotteryDollView:AddViewEvts()
  LotteryDollView.super.AddViewEvts(self)
  self:AddListenEvt(LotteryEvent.EffectStart, self.HandleEffectStart)
  self:AddListenEvt(LotteryEvent.EffectEnd, self.HandleEffectEnd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCostView)
  self:AddListenEvt(ServiceEvent.ItemLotteryDollQueryItemCmd, self.UpdateDollInfoView)
  self:AddListenEvt(LotteryEvent.RecvLotteryDollResult, self.OnRecvLotteryResult)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function LotteryDollView:InitShow()
  LotteryDollView.super.InitShow(self)
  self.showSkipBtn = LocalSaveProxy.Instance:GetShowLotteryDollSkip()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self:InitCoverImage()
  self:InitCostView()
  self:UpdateCostView()
  self:UpdateDollInfoView()
  self:UpdateSkip()
end

function LotteryDollView:InitCoverImage()
  if GameConfig.Doll and GameConfig.Doll.CoverImage then
    PictureManager.Instance:SetLotteryCover(GameConfig.Doll.CoverImage, self.coverImage)
  end
end

function LotteryDollView:InitCostView()
  local iconPath = Table_Item[GameConfig.Doll.CostItemId].Icon
  IconManager:SetItemIcon(iconPath, self.costMenuIcon)
  IconManager:SetItemIcon(iconPath, self.costBtnIcon)
  self.costBtnLabel.text = GameConfig.Doll.CostItemCount
end

function LotteryDollView:UpdateCostView()
  local cost = GameConfig.Doll.CostItemCount
  local ticketCount = BagProxy.Instance:GetItemNumByStaticID(GameConfig.Doll.CostItemId) or 0
  self.costMenuLabel.text = ticketCount
end

function LotteryDollView:UpdateDollInfoView()
  local lotteryProxy = LotteryDollProxy.Instance
  local lotteryDollInfo = lotteryProxy.lotteryDollInfo
  if lotteryDollInfo then
    self.detailHelper:ResetDatas(lotteryDollInfo)
  end
  local allOwned = LotteryDollProxy.Instance:IsAllItemOwned()
  self.lotteryBtnGO:SetActive(not allOwned)
  if self.soldoutBtnGO then
    self.soldoutBtnGO:SetActive(allOwned)
  end
end

function LotteryDollView:OnRecvLotteryResult(data)
  local body = data and data.body
  if not body or not body.itemId then
    return
  end
  if not self.showSkipBtn then
    self.showSkipBtn = true
    LocalSaveProxy.Instance:SetShowLotteryDollSkip(1)
    self:UpdateSkip()
  end
  self:UpdateDollInfoView()
  self:ShowAward(body.itemId)
end

function LotteryDollView:OnUseTicketClicked()
  if ServiceItemProxy.Instance:IsWaitForLotteryDollResult() then
    MsgManager.ShowMsgByID(49)
    return
  end
  local cost = GameConfig.Doll.CostItemCount
  local ticketCount = BagProxy.Instance:GetItemNumByStaticID(GameConfig.Doll.CostItemId) or 0
  if cost <= ticketCount then
    self:DoUseTicket()
  else
    MsgManager.ShowMsgByID(41230)
  end
end

function LotteryDollView:DoUseTicket()
  local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.LotteryDoll)
  if isSkip then
    self:SendPurchaseMessage()
  else
    self:PlayAnimation(GameConfig.Doll.AnimDuration or 3000, GameConfig.Doll.RunAnimName or "functional_action", GameConfig.Doll.IdleAnimName or "wait")
  end
end

function LotteryDollView:SendPurchaseMessage()
  ServiceItemProxy.Instance:CallLotteryDollPayItemCmd()
end

function LotteryDollView:OnGotoDetailClicked()
  self.coverPanelGO:SetActive(false)
  self.detailPanelGO:SetActive(true)
end

function LotteryDollView:OnGoToCoverClicked()
  self.coverPanelGO:SetActive(true)
  self.detailPanelGO:SetActive(false)
end

function LotteryDollView:OnSkipClicked()
  TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.LotteryDoll, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
end

function LotteryDollView:UpdateSkip()
  self.skipBtnGO:SetActive(self.showSkipBtn)
end

function LotteryDollView:OnCellClicked(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function LotteryDollView:OnEffectStart()
  LotteryDollView.super.OnEffectStart(self)
  self.lotteryRootGO:SetActive(false)
end

function LotteryDollView:OnEffectEnd()
  LotteryDollView.super.OnEffectEnd(self)
  self.lotteryRootGO:SetActive(true)
end
