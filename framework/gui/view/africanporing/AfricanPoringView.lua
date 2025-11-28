autoImport("AfricanPoringPoolTipCell")
autoImport("AfricanPoringShopCell")
autoImport("AfricanPoringRewardCell")
autoImport("AfricanPoringPoolCell")
autoImport("ItemCell")
AfricanPoringView = class("AfricanPoringView", ContainerView)
AfricanPoringView.ViewType = UIViewType.BuildingLayer
local BgTextureName = "turnable_bg_01"
local BidAnimAudio = "ui_gen_polyspin"
local BidAnimStatus = {
  Init = 1,
  WaitResult = 2,
  RecvResult = 3,
  ShowResult = 4
}
local LockDuration = 10000

function AfricanPoringView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:UpdateView()
  self:ShowLeftPanel(0)
  self:ShowPoolContent()
end

function AfricanPoringView:OnEnter()
  AfricanPoringView.super.OnEnter(self)
  AfricanPoringProxy.Instance:CallQueryAfricanPoringItemCmd()
  AfricanPoringProxy.Instance:CallQueryShopConfigCmd()
end

function AfricanPoringView:OnExit()
  self.rewardPoolExtraItemCell = nil
  self:Unlock()
  self:StopBidAnim()
  self:StopResetAnim()
  self:StopNormalTipCountdown()
  AfricanPoringView.super.OnExit(self)
end

function AfricanPoringView:Lock()
  self.isLocked = true
  if self.lockTimer then
    self.lockTimer:Destroy()
  end
  self.lockTimer = TimeTickManager.Me():CreateOnceDelayTick(LockDuration, function()
    self:Unlock()
  end, self)
end

function AfricanPoringView:Unlock()
  self.isLocked = false
  if self.lockTimer then
    self.lockTimer:Destroy()
    self.lockTimer = nil
  end
end

function AfricanPoringView:FindObjs()
  local proxy = AfricanPoringProxy.Instance
  local actConfig = proxy:GetConfig()
  local actData = proxy:GetActData()
  self.panel = self.gameObject:GetComponent(UIPanel)
  local topLeftGO = self:FindGO("AnchorTopLeft")
  local goldGO = self:FindGO("Gold")
  self.goldIcon = self:FindComponent("Icon", UISprite, goldGO)
  IconManager:SetItemIcon("item_151", self.goldIcon)
  self.goldNum = self:FindComponent("Num", UILabel, goldGO)
  local addGoldGO = self:FindGO("AddBtn", goldGO)
  self:AddClickEvent(addGoldGO, function()
    if self.isLocked then
      return
    end
    self:CloseSelf()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
  end)
  local animSettingGO = self:FindGO("AnimSetting", topLeftGO)
  self:AddClickEvent(animSettingGO, function()
    self:OnAnimSettingClicked()
  end)
  self.animOnGO = self:FindGO("On", animSettingGO)
  self.animOffGO = self:FindGO("Off", animSettingGO)
  self.animTipGO = self:FindGO("Tip", animSettingGO)
  self.animTipWidget = self.animTipGO:GetComponent(UIWidget)
  self.animTipWidget.alpha = 0
  self.animTipTweener = self.animTipGO:GetComponent(UITweener)
  self.animTipTweener.enabled = false
  self.animTipLab = self:FindComponent("TipLab", UILabel, self.animTipGO)
  local topCenterGO = self:FindGO("AnchorTopCenter")
  local titleGO = self:FindGO("TitleContainer", topCenterGO)
  self.titleLab = self:FindComponent("Title", UILabel, titleGO)
  self.titleLab.text = actConfig.ActivityName or ""
  self.timeLab = self:FindComponent("Time", UILabel, titleGO)
  self.timeLab.text = actData and actData:GetTimePeriodStr() or ""
  local helpGO = self:FindGO("HelpBtn", titleGO)
  self:RegistShowGeneralHelpByHelpID(35258, helpGO)
  local topRightGO = self:FindGO("AnchorTopRight")
  local closeBtnGO = self:FindGO("CloseBtn", topRightGO)
  self:AddClickEvent(closeBtnGO, function()
    if self.isLocked then
      return
    end
    self:CloseSelf()
  end)
  local resetBtnGO = self:FindGO("ResetBtn", topRightGO)
  self:AddClickEvent(resetBtnGO, function()
    self:OnResetClicked()
  end)
  local centerLeftGO = self:FindGO("AnchorCenterLeft")
  self.rewardPanelGO = self:FindGO("RewardPanel", centerLeftGO)
  self.rewardPanelGO:GetComponent(CloseWhenClickOtherPlace).callBack = function()
    self:ShowLeftPanel(0)
  end
  local shopCoin1GO = self:FindGO("Coin1", self.rewardPanelGO)
  self.shopCoin1Icon = self:FindComponent("Icon", UISprite, shopCoin1GO)
  self.shopCoin1Num = self:FindComponent("Num", UILabel, shopCoin1GO)
  local shopCoin2GO = self:FindGO("Coin2", self.rewardPanelGO)
  self.shopCoin2Icon = self:FindComponent("Icon", UISprite, shopCoin2GO)
  self.shopCoin2Num = self:FindComponent("Num", UILabel, shopCoin2GO)
  self.rewardTabs = {}
  local shopTabGO = self:FindGO("ShopTab", self.rewardPanelGO)
  self:AddClickEvent(shopTabGO, function()
    self:OnLeftPanelTabClicked(1)
  end)
  self.rewardTabs[1] = {
    rootGO = shopTabGO,
    normalGO = self:FindGO("Normal", shopTabGO),
    selectedGO = self:FindGO("Selected", shopTabGO)
  }
  local rewardTabGO = self:FindGO("RewardTab", self.rewardPanelGO)
  self:AddClickEvent(rewardTabGO, function()
    self:OnLeftPanelTabClicked(2)
  end)
  self.rewardTabs[2] = {
    rootGO = rewardTabGO,
    normalGO = self:FindGO("Normal", rewardTabGO),
    selectedGO = self:FindGO("Selected", rewardTabGO)
  }
  self.rewardScrollGO = self:FindGO("RewardScroll", self.rewardPanelGO)
  self.rewardScroll = self.rewardScrollGO:GetComponent(UIScrollView)
  self.rewardScrollCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.rewardScrollGO), AfricanPoringRewardCell, "AfricanPoring/AfricanPoringRewardCell")
  self.rewardScrollCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnRewardItemClicked, self)
  self.shopScrollGO = self:FindGO("ShopScroll", self.rewardPanelGO)
  self.shopScroll = self.shopScrollGO:GetComponent(UIScrollView)
  self.shopScrollCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.shopScrollGO), AfricanPoringShopCell, "AfricanPoring/AfricanPoringShopCell")
  self.shopScrollCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnShopItemClicked, self)
  self.shopScrollCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnShopBuyClicked, self)
  self.tabPanels = {
    [1] = self.shopScrollGO,
    [2] = self.rewardScrollGO
  }
  self.tabScrolls = {
    [1] = self.shopScroll,
    [2] = self.rewardScroll
  }
  local centerGO = self:FindGO("AnchorCenter")
  self.bgTexture = self:FindComponent("BgTexture", UITexture, centerGO)
  self.rewardPoolContentGO = self:FindGO("RewardPoolContentPanel", centerGO)
  self.rewardPoolContentTitle = self:FindComponent("Title", UILabel, self.rewardPoolContentGO)
  self.rewardPoolContentGO:GetComponent(CloseWhenClickOtherPlace).callBack = function()
    self:ShowPoolContent()
  end
  self.rewardPoolBg = self:FindComponent("Bg", UISprite, self.rewardPoolContentGO)
  self.rewardPoolTable = self:FindComponent("Content", UITable, self.rewardPoolContentGO)
  self.rewardPoolContentCtrl = ListCtrl.new(self:FindComponent("Rewards", UIGrid, self.rewardPoolTable.gameObject), AfricanPoringPoolTipCell, "AfricanPoring/AfricanPoringPoolTipCell")
  self.rewardPoolContentCtrl:AddEventListener(UICellEvent.OnCellClicked, self.OnPoolSlotItemClicked, self)
  self.rewardPoolExtraGO = self:FindGO("ExtraReward", self.rewardPoolContentGO)
  self.rewardPoolExtraTitle = self:FindComponent("ExtraTitlte", UILabel, self.rewardPoolExtraGO)
  self.rewardPoolExtraItemGO = self:FindGO("ExtraItem", self.rewardPoolExtraGO)
  self.rewardPoolExtraItemCell = AfricanPoringPoolTipCell.new(self.rewardPoolExtraItemGO)
  self:AddClickEvent(self.rewardPoolExtraItemGO, function()
    self:OnPoolSlotItemClicked(self.rewardPoolExtraItemCell)
  end)
  local rewardPoolGO = self:FindGO("RewardPool")
  self.rewardPoolCtrl = ListCtrl.new(self:FindGO("RewardPoolContainer", rewardPoolGO).transform, AfricanPoringPoolCell, "AfricanPoring/AfricanPoringPoolCell")
  self.rewardPoolCtrl:AddEventListener(UICellEvent.OnCellClicked, self.OnPoolSlotClicked, self)
  self.rewardPoolCtrl:SetNoScrollView(true)
  self.rewardPoolCtrl:SetNoLayout(true)
  self.rewardPoolPositions = {}
  for i = 1, 12 do
    self.rewardPoolPositions[i] = self:FindGO("Pos_" .. i, rewardPoolGO).transform.position
  end
  local bottomLeftGO = self:FindGO("AnchorBottomLeft")
  local coin1GO = self:FindGO("Coin1", bottomLeftGO)
  self.coin1Icon = self:FindComponent("Icon", UISprite, coin1GO)
  self.coin1Num = self:FindComponent("Num", UILabel, coin1GO)
  local coin2GO = self:FindGO("Coin2", bottomLeftGO)
  self.coin2Icon = self:FindComponent("Icon", UISprite, coin2GO)
  self.coin2Num = self:FindComponent("Num", UILabel, coin2GO)
  self.bestRewardGO = self:FindGO("BestReward", bottomLeftGO)
  self.bestRewardContainerGO = self:FindGO("BestRewardItemContainer", self.bestRewardGO)
  self:AddClickEvent(self.bestRewardContainerGO, function()
    self:OnBestRewardClicked(self.bestRewardContainerGO)
  end)
  local bestRewardContainer = self.bestRewardContainerGO:GetComponent(UIWidget)
  local obj = self:LoadPreferb("cell/ItemCell", self.bestRewardContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  self.bestRewardCell = ItemCell.new(self.bestRewardContainerGO)
  self.bestRewardCell:SetMinDepth(bestRewardContainer.depth + 1, true)
  self.bestRewardEffectGO = self:FindGO("Effect", self.bestRewardGO)
  local rewardBtnGO = self:FindGO("RewardBtn", bottomLeftGO)
  self:AddClickEvent(rewardBtnGO, function()
    self:OnLeftPanelTabClicked(2)
  end)
  local shopBtnGO = self:FindGO("ShopBtn", bottomLeftGO)
  self:AddClickEvent(shopBtnGO, function()
    self:OnLeftPanelTabClicked(1)
  end)
  local bottomRightGO = self:FindGO("AnchorBottomRight")
  local normalBtnGO = self:FindGO("NormalBtn", bottomRightGO)
  self:AddClickEvent(normalBtnGO, function()
    self:OnNormalBidClicked()
  end)
  self.normalCostGO = self:FindGO("CostBg", normalBtnGO)
  self.normalCostIcon = self:FindComponent("CostIcon", UISprite, self.normalCostGO)
  self.normalCostNum = self:FindComponent("CostNum", UILabel, self.normalCostGO)
  self.normalCostLab = self:FindComponent("Lab", UILabel, normalBtnGO)
  self.normalTip = self:FindComponent("NormalTip", UILabel, bottomRightGO)
  local safeBtnGO = self:FindGO("SafeBtn", bottomRightGO)
  self:AddClickEvent(safeBtnGO, function()
    self:OnSafeBidClicked()
  end)
  self.safeCostIcon = self:FindComponent("CostIcon", UISprite, safeBtnGO)
  self.safeCostNum = self:FindComponent("CostNum", UILabel, safeBtnGO)
  self.safeCostTip = self:FindComponent("SafeTip", UILabel, bottomRightGO)
end

function AfricanPoringView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ItemQueryAfricanPoringItemCmd, self.HandleItemResult)
  self:AddListenEvt(ServiceEvent.ItemAfricanPoringLotteryItemCmd, self.HandleBidResult)
  self:AddListenEvt(ServiceEvent.ItemAfricanPoringUpdateItemCmd, self.HandleUpdatePool)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdateShopView)
  self:AddDispatcherEvt(AfricanPoring.OnAcvitityEnd, self.CloseSelf)
  self:AddDispatcherEvt(AfricanPoring.OnShopItemUpdated, self.UpdateShopView)
end

function AfricanPoringView:UpdateView()
  self:UpdateAnimSetting()
  self:UpdateCoins()
  self:UpdateRewardPool()
end

function AfricanPoringView:UpdateAnimSetting()
  local isAnimOn = AfricanPoringProxy.Instance:IsAnimOn()
  if isAnimOn then
    self.animOnGO:SetActive(true)
    self.animOffGO:SetActive(false)
    self.animTipLab.text = ZhString.AfricanPoring_AnimSettingOn
  else
    self.animOnGO:SetActive(false)
    self.animOffGO:SetActive(true)
    self.animTipLab.text = ZhString.AfricanPoring_AnimSettingOff
  end
end

function AfricanPoringView:UpdateCoins()
  self.goldNum.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  local coin1 = 0
  local coin2 = 0
  local config = AfricanPoringProxy.Instance:GetConfig()
  local bagProxy = BagProxy.Instance
  if config then
    coin1 = bagProxy:GetItemNumByStaticID(config.CoinID1) or 0
    IconManager:SetItemIconById(config.CoinID1, self.shopCoin1Icon)
    IconManager:FitAspect(self.shopCoin1Icon)
    IconManager:SetItemIconById(config.CoinID1, self.coin1Icon)
    IconManager:FitAspect(self.coin1Icon)
    coin2 = bagProxy:GetItemNumByStaticID(config.CoinID2) or 0
    IconManager:SetItemIconById(config.CoinID2, self.shopCoin2Icon)
    IconManager:FitAspect(self.shopCoin2Icon)
    IconManager:SetItemIconById(config.CoinID2, self.coin2Icon)
    IconManager:FitAspect(self.coin2Icon)
  end
  self.shopCoin1Num.text = StringUtil.NumThousandFormat(coin1)
  self.coin1Num.text = 999 < coin1 and "999+" or coin1
  self.shopCoin2Num.text = StringUtil.NumThousandFormat(coin2)
  self.coin2Num.text = 999 < coin2 and "999+" or coin2
end

function AfricanPoringView:HandleUpdatePool()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if self.isResetClicked then
    self:PlayResetAnim()
    self.isResetClicked = false
  end
end

function AfricanPoringView:HandleBidResult()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if actData.lastStatus == SceneItem_pb.EAFRICANPORINGSTATUS_INIT then
    if proxy:IsAnimOn() then
      self:PlayBidResultAnim()
    else
      self:StopBidAnim()
    end
  end
end

function AfricanPoringView:PostBidResult()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if actData.lastStatus == SceneItem_pb.EAFRICANPORINGSTATUS_INIT then
    if actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_INIT or actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_FINISH then
      proxy:ShowRewardItems()
    elseif actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_FAIL and not proxy:ShowRewardItems(function()
      self:TryReset()
    end) then
      self:TryReset()
    end
  end
end

function AfricanPoringView:TryReset()
  MsgManager.ConfirmMsgByID(43266, function()
    AfricanPoringProxy.Instance:CallAfricanPoringLotteryItemCmd(SceneItem_pb.EAFRICANPORING_RESET)
    self.isResetClicked = true
    self:Lock()
  end)
end

function AfricanPoringView:HandleItemResult()
  self:UpdateRewardPool()
  self:PostBidResult()
end

function AfricanPoringView:UpdateRewardPool()
  self:Unlock()
  self:UpdateRewardView()
  self:UpdateBidBtn()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  local datas = actData:GetPoolDatas() or {}
  self.rewardPoolCtrl:ResetDatas(datas)
  self:AdjustPoolCellsPosition()
  self:ShowHitCell()
end

function AfricanPoringView:ShowHitCell()
  local actData = AfricanPoringProxy.Instance:GetActData()
  if not actData then
    return
  end
  local hitPos = actData.hitPos
  local cells = self.rewardPoolCtrl:GetCells()
  if cells then
    for _, cell in ipairs(cells) do
      if cell.cellData and cell.cellData.pos == hitPos then
        cell:SetSelected(true)
      else
        cell:SetSelected(false)
      end
    end
  end
end

function AfricanPoringView:AdjustPoolCellsPosition()
  if not self.rewardPoolCtrl or not self.rewardPoolPositions then
    return
  end
  local cells = self.rewardPoolCtrl:GetCells()
  for i, cell in ipairs(cells) do
    local pos = self.rewardPoolPositions[i]
    if pos then
      LuaGameObject.SetPositionGO(cell.gameObject, pos[1], pos[2], pos[3])
    end
  end
end

function AfricanPoringView:UpdateBidBtn()
  local actData = AfricanPoringProxy.Instance:GetActData()
  if actData then
    local costItemId, costNum = actData:GetNormalBidCost()
    IconManager:SetItemIconById(costItemId, self.normalCostIcon)
    IconManager:FitAspect(self.normalCostIcon)
    local freeBidNum = actData:GetFreeNormalBidNum()
    if freeBidNum and 0 < freeBidNum then
      self:StopNormalTipCountdown()
      self.normalCostLab.text = ZhString.AfricanPoring_BidFree
      self.normalCostNum.text = 0
      self.normalTip.text = string.format(ZhString.AfricanPoring_FreeBidCount, freeBidNum)
    else
      self.normalCostLab.text = ZhString.AfricanPoring_BidOnce
      self.normalCostNum.text = costNum or 0
      self:UpdateNormalTipCountdown()
      self:StartNormalTipCountdown()
    end
    local safeCostItemId, safeCostNum = actData:GetSafeBidCost()
    if safeCostItemId then
      IconManager:SetItemIconById(safeCostItemId, self.safeCostIcon)
      IconManager:FitAspect(self.safeCostIcon)
    end
    self.safeCostNum.text = safeCostNum or 0
    if actData.nextHit == 0 then
      self.safeCostTip.text = ZhString.AfricanPoring_NextHitEnsured
    elseif actData.nextHit and 0 < actData.nextHit then
      self.safeCostTip.text = string.format(ZhString.AfricanPoring_NextHit, actData.nextHit + 1)
    end
  else
    self.normalCostNum.text = 0
    self.safeCostNum.text = 0
    self.safeCostTip.text = ""
  end
end

function AfricanPoringView:StartNormalTipCountdown()
  if not self.normalTipCountdownTimer then
    self.normalTipCountdownTimer = TimeTickManager.Me():CreateTick(0, 1000, function()
      self:UpdateNormalTipCountdown()
    end, self)
  end
end

function AfricanPoringView:StopNormalTipCountdown()
  if self.normalTipCountdownTimer then
    self.normalTipCountdownTimer:Destroy()
    self.normalTipCountdownTimer = nil
  end
end

function AfricanPoringView:UpdateNormalTipCountdown()
  local actData = AfricanPoringProxy.Instance:GetActData()
  if not actData then
    self:StopNormalTipCountdown()
    return
  end
  local h, m, s = actData:GetNextFreeBidCountdown()
  self.normalTip.text = string.format(ZhString.AfricanPoring_NextFreeBidCountDown, h or 0, m or 0, s or 0)
  if (not h or h == 0) and (not m or m == 0) and (not s or s == 0) then
    self:StopNormalTipCountdown()
    if self.needQueryWhenReachTime then
      self.needQueryWhenReachTime = nil
      AfricanPoringProxy.Instance:CallQueryAfricanPoringItemCmd()
    end
    return
  end
  self.needQueryWhenReachTime = true
end

function AfricanPoringView:UpdateRewardView()
  local datas = AfricanPoringProxy.Instance:GetRewardItems()
  self.rewardScrollCtrl:ResetDatas(datas)
  self:UpdateBestReward()
end

function AfricanPoringView:UpdateBestReward()
  local actData = AfricanPoringProxy.Instance:GetActData()
  if not actData then
    return
  end
  local itemData = actData:GetBestRewardItemData()
  self.bestRewardCell:SetData(itemData)
  self.bestRewardCell:HideBgSp()
end

function AfricanPoringView:UpdateShopView()
  local datas = AfricanPoringProxy.Instance:GetShopItems()
  self.shopScrollCtrl:ResetDatas(datas)
end

function AfricanPoringView:OnLeftPanelTabClicked(index)
  if self.isLocked then
    return
  end
  self:ShowLeftPanel(index)
end

function AfricanPoringView:ShowLeftPanel(index)
  if not index or index <= 0 then
    self.selectedTabIndex = nil
    self.rewardPanelGO:SetActive(false)
    return
  end
  self.rewardPanelGO:SetActive(true)
  if self.selectedTabIndex ~= index then
    self.selectedTabIndex = index
    for i, tab in ipairs(self.rewardTabs) do
      if i == index then
        tab.normalGO:SetActive(false)
        tab.selectedGO:SetActive(true)
        self.tabPanels[i]:SetActive(true)
        self.tabScrolls[i]:ResetPosition()
      else
        tab.normalGO:SetActive(true)
        tab.selectedGO:SetActive(false)
        self.tabPanels[i]:SetActive(false)
      end
    end
  end
end

function AfricanPoringView:ShowPoolContent(pos)
  self.selectedPoolPos = pos
  if not pos or pos == 0 then
    self.rewardPoolContentGO:SetActive(false)
    return
  end
  local actData = AfricanPoringProxy.Instance:GetActData()
  if not actData then
    return
  end
  local poolData = actData:GetPoolDataByPos(pos)
  if not poolData then
    return
  end
  local position = self.rewardPoolPositions[pos]
  if position then
    LuaGameObject.SetPositionGO(self.rewardPoolContentGO, position[1], position[2], position[3])
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.rewardPoolContentGO)
    LuaGameObject.SetLocalPositionGO(self.rewardPoolContentGO, x + 200, y + 30, z)
  end
  self.rewardPoolContentGO:SetActive(true)
  local rewardItems = poolData:GetRewardItems()
  self.rewardPoolContentCtrl:ResetDatas(rewardItems)
  self.rewardPoolContentTitle.text = ZhString.AfricanPoring_ContentTipTitle
  self.rewardPoolExtraTitle.text = ZhString.AfricanPoring_ContentTipExtraTitle
  self.rewardPoolExtraGO:SetActive(true)
  self.rewardPoolExtraItemCell:SetData(poolData.extraRewardItem)
  self.rewardPoolTable:Reposition()
  self.rewardPoolBg:UpdateAnchors()
  self.panel:ConstrainTargetToBounds(self.rewardPoolContentGO.transform, true)
end

function AfricanPoringView:CheckNeedReset(status)
  if status == SceneItem_pb.EAFRICANPORINGSTATUS_UNINIT or status == SceneItem_pb.EAFRICANPORINGSTATUS_FAIL or status == SceneItem_pb.EAFRICANPORINGSTATUS_FINISH then
    self:HandleResetEvent()
    return true
  end
  return false
end

function AfricanPoringView:OnNormalBidClicked()
  if self.isLocked then
    MsgManager.ShowMsgByID(49)
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    self:HandleNormalBidEvent()
  end)
end

function AfricanPoringView:HandleNormalBidEvent()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if self:CheckNeedReset(actData.status) then
    return
  end
  local costId, costNum
  if not actData:HasFreeBids() then
    costId, costNum = actData:GetNormalBidCost()
    local myItemNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costId)
    if costNum and costNum > myItemNum then
      if costId == 151 then
        MsgManager.ConfirmMsgByID(3551, function()
          self:CloseSelf()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
        end, nil, self)
      else
        MsgManager.ShowyFloatMsgTableParam(nil, ZhString.AfricanPoring_ItemNotEnough)
      end
      return
    end
  end
  local ownedNum = actData:GetOwnedPoolCount()
  if ownedNum and 3 <= ownedNum then
    MsgManager.DontAgainConfirmMsgByID(43307, function()
      self:TryCallBid(costNum)
    end, function()
      self:OnSafeBidClicked()
    end)
  else
    self:TryCallBid(costNum)
  end
end

function AfricanPoringView:OnSafeBidClicked()
  if self.isLocked then
    MsgManager.ShowMsgByID(49)
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    self:HandleSafeBidEvent()
  end)
end

function AfricanPoringView:HandleSafeBidEvent()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if self:CheckNeedReset(actData.status) then
    return
  end
  local costId, costNum = actData:GetSafeBidCost()
  local myItemNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costId)
  if costNum and costNum > myItemNum then
    if costId == 151 then
      MsgManager.ConfirmMsgByID(3551, function()
        self:CloseSelf()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
      end, nil, self)
    else
      MsgManager.ShowyFloatMsgTableParam(nil, ZhString.AfricanPoring_ItemNotEnough)
    end
    return
  end
  if costNum and 0 < costNum then
    MsgManager.DontAgainConfirmMsgByID(43268, function()
      self:CallBid(SceneItem_pb.EAFRICANPORING_SECURITY)
    end, nil, self, costNum)
  else
    self:CallBid(SceneItem_pb.EAFRICANPORING_SECURITY)
  end
end

function AfricanPoringView:TryCallBid(costNum)
  if costNum and 0 < costNum then
    MsgManager.DontAgainConfirmMsgByID(43268, function()
      self:CallBid(SceneItem_pb.EAFRICANPORING_NORMAL)
    end, nil, self, costNum)
  else
    self:CallBid(SceneItem_pb.EAFRICANPORING_NORMAL)
  end
end

function AfricanPoringView:CallBid(action)
  local proxy = AfricanPoringProxy.Instance
  if proxy:IsAnimOn() then
    self:PlayBidAnim()
  end
  proxy:CallAfricanPoringLotteryItemCmd(action)
  self:Lock()
end

function AfricanPoringView:OnResetClicked()
  if self.isLocked then
    MsgManager.ShowMsgByID(49)
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    self:HandleResetEvent()
  end)
end

function AfricanPoringView:HandleResetEvent()
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  if not actData then
    return
  end
  if actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_UNINIT then
    MsgManager.ConfirmMsgByID(43265, function()
      proxy:CallAfricanPoringLotteryItemCmd(SceneItem_pb.EAFRICANPORING_RESET)
      self.isResetClicked = true
      self:Lock()
    end, nil, self)
  elseif actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_FAIL then
    MsgManager.ConfirmMsgByID(43266, function()
      proxy:CallAfricanPoringLotteryItemCmd(SceneItem_pb.EAFRICANPORING_RESET)
      self.isResetClicked = true
      self:Lock()
    end, nil, self)
  elseif actData.status == SceneItem_pb.EAFRICANPORINGSTATUS_FINISH then
    MsgManager.ConfirmMsgByID(43267, function()
      proxy:CallAfricanPoringLotteryItemCmd(SceneItem_pb.EAFRICANPORING_RESET)
      self.isResetClicked = true
      self:Lock()
    end, nil, self)
  else
    local costId, costNum = actData:GetResetCost()
    local myItemNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costId)
    if costNum > myItemNum then
      if costId == 151 then
        MsgManager.ConfirmMsgByID(3551, function()
          self:CloseSelf()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
        end, nil, self)
      end
    else
      MsgManager.DontAgainConfirmMsgByID(43264, function()
        proxy:CallAfricanPoringLotteryItemCmd(SceneItem_pb.EAFRICANPORING_RESET)
        self.isResetClicked = true
        self:Lock()
      end, nil, self, costNum or 0)
    end
  end
end

function AfricanPoringView:OnHelpClicked()
  local helpData = Table_Help[35258]
  if helpData then
    TipsView.Me():ShowGeneralHelp(helpData.Desc)
  end
end

function AfricanPoringView:OnShopBuyClicked(cell)
  local cellData = cell and cell.cellData
  if not cellData then
    return
  end
  MsgManager.ConfirmMsgByID(43272, function()
    HappyShopProxy.Instance:BuyItemByShopItemData(cellData, 1)
  end, nil, self)
end

function AfricanPoringView:OnShopItemClicked(cell)
  local itemId = cell and cell.cellData and cell.cellData.goodsID
  if not itemId then
    return
  end
  self:ShowItemTip(itemId, cell.itemContainerGO, NGUIUtil.AnchorSide.Right, {220, -40})
end

function AfricanPoringView:OnBestRewardClicked(btnGO)
  local actData = AfricanPoringProxy.Instance:GetActData()
  local rewardItemData = actData and actData:GetBestRewardItemData()
  if not rewardItemData then
    return
  end
  self:ShowItemTipWithData(rewardItemData, btnGO, NGUIUtil.AnchorSide.Right, {240, 0})
end

function AfricanPoringView:OnRewardItemClicked(cell)
  local itemId = cell and cell.cellData and cell.cellData.itemId
  if not itemId then
    return
  end
  self:ShowItemTip(itemId, cell.itemContainerGO, NGUIUtil.AnchorSide.Right, {220, -40})
end

function AfricanPoringView:OnPoolSlotClicked(cell)
  local poolData = cell and cell.cellData
  if not poolData then
    return
  end
  self:ShowPoolContent(poolData.pos)
end

function AfricanPoringView:OnPoolSlotItemClicked(cell)
  local itemId = cell and cell.cellData and cell.cellData.itemId
  if not itemId then
    return
  end
  self:ShowItemTip(itemId, cell.gameObject, NGUIUtil.AnchorSide.Left, {-200, -40})
end

function AfricanPoringView:ShowItemTip(itemId, stick, anchor, offset)
  self:ShowItemTipWithData(ItemData.new("AfricanPoringReward", itemId), stick, anchor, offset)
end

function AfricanPoringView:ShowItemTipWithData(itemData, stick, anchor, offset)
  local sdata = {
    itemdata = itemData,
    funcConfig = {}
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick:GetComponent(UIWidget), anchor, offset)
end

function AfricanPoringView:PlayResetAnim()
  if not self.resetAnimTimer then
    self.resetAnimTimer = TimeTickManager.Me():CreateOnceDelayTick(500, self.DelayShowItem, self)
  end
  local cells = self.rewardPoolCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:ShowResetEffect(true)
    cell:PlayResetAnim()
  end
end

function AfricanPoringView:DelayShowItem()
  self:StopResetAnim()
  self:UpdateRewardPool()
end

function AfricanPoringView:StopResetAnim()
  if self.resetAnimTimer then
    self.resetAnimTimer:Destroy()
    self.resetAnimTimer = nil
  end
  local cells = self.rewardPoolCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:ShowResetEffect(false)
  end
end

local bidAnimIntervals = {
  1008,
  608,
  408,
  308,
  208,
  108,
  68
}
local minBidAnimInterval = 68
local showBidResultDelay = 1000
local bidAnimSlowdownDistance = 6

function AfricanPoringView:PlayBidAnim()
  local actData = AfricanPoringProxy.Instance:GetActData()
  if not self.bidAnimTimer then
    self.bidAnimStatus = BidAnimStatus.WaitResult
    self.bidAnimInterval = minBidAnimInterval
    self.bidAnimAccTime = 0
    self.bidAnimTotalTime = 0
    self.bidAnimPoolIndex = actData and actData.hitPos or 1
    self.bidAnimCircles = 0
    self.bidAnimSpinSteps = 0
    self.bidAnimStartSlowdown = false
    self.bidAnimTimer = TimeTickManager.Me():CreateTick(0, 16, self.UpdateBidAnim, self)
  end
end

function AfricanPoringView:PlayBidResultAnim()
  if self.bidAnimStatus == BidAnimStatus.WaitResult then
    self.bidAnimStatus = BidAnimStatus.RecvResult
  end
end

function AfricanPoringView:UpdateBidAnim(deltaTime)
  local cells = self.rewardPoolCtrl:GetCells()
  local cellNum = #cells
  local changed = false
  local finished = false
  self.bidAnimTotalTime = self.bidAnimTotalTime + deltaTime
  self.bidAnimAccTime = self.bidAnimAccTime + deltaTime
  local proxy = AfricanPoringProxy.Instance
  local actData = proxy:GetActData()
  local hitPos = actData.hitPos or 1
  while self.bidAnimAccTime > self.bidAnimInterval do
    if self.bidAnimStatus == BidAnimStatus.ShowResult then
      finished = true
      break
    end
    self.bidAnimAccTime = self.bidAnimAccTime - self.bidAnimInterval
    self.bidAnimPoolIndex = self.bidAnimPoolIndex + 1
    if cellNum < self.bidAnimPoolIndex then
      self.bidAnimPoolIndex = 1
    end
    self.bidAnimSpinSteps = self.bidAnimSpinSteps + 1
    if cellNum <= self.bidAnimSpinSteps then
      self.bidAnimSpinSteps = 0
      self.bidAnimCircles = self.bidAnimCircles + 1
    end
    changed = true
    if self.bidAnimStatus == BidAnimStatus.RecvResult and self.bidAnimCircles >= 3 then
      local distance = hitPos - self.bidAnimPoolIndex
      if distance < 0 then
        distance = distance + cellNum
      end
      if distance < 0 then
        distance = 0
      end
      if self.bidAnimStartSlowdown then
        if distance == 0 then
          self.bidAnimStatus = BidAnimStatus.ShowResult
          self.bidAnimInterval = showBidResultDelay
          break
        else
          self.bidAnimInterval = bidAnimIntervals[distance] or bidAnimIntervals[1]
        end
      elseif distance == bidAnimSlowdownDistance + 1 then
        self.bidAnimStartSlowdown = true
      end
    end
  end
  if changed then
    for i, cell in ipairs(cells) do
      cell:SetSelected(i == self.bidAnimPoolIndex)
    end
    AudioUtility.PlayOneShot2D_Path(AudioMap.UI.AfricanPoringSpin, AudioSourceType.UI)
  end
  if finished then
    self:StopBidAnim()
  elseif self.bidAnimTotalTime > LockDuration and self.bidAnimStatus < BidAnimStatus.RecvResult then
    self:StopBidAnim()
  end
end

function AfricanPoringView:StopBidAnim()
  if self.bidAnimTimer then
    self.bidAnimTimer:Destroy()
    self.bidAnimTimer = nil
  end
  self.bidAnimAccTime = 0
  self.bidAnimStatus = BidAnimStatus.Init
  self:UpdateRewardPool()
  self:PostBidResult()
end

function AfricanPoringView:OnAnimSettingClicked()
  local proxy = AfricanPoringProxy.Instance
  proxy:SetAnimOn(not proxy:IsAnimOn())
  self:UpdateAnimSetting()
  self.animTipWidget.alpha = 1
  self.animTipTweener:ResetToBeginning()
  self.animTipTweener:PlayForward()
end
