autoImport("NoviceBattlePassLevelRewardCell")
autoImport("NewRechargeVirtualRecommendTShopGoodsCell")
autoImport("NoviceBattlePassBuyLevelCell")
NoviceBattlePassView = class("NoviceBattlePassView", ContainerView)
NoviceBattlePassView.ViewType = UIViewType.NormalLayer
NoviceBattlePassView.BPType = {Novice = 1, Return = 2}

function NoviceBattlePassView:GetTitle()
  if self.bPType == 2 then
    return GameConfig.ReturnBattlePass.Name
  end
  return GameConfig.NoviceBattlePass.Name
end

function NoviceBattlePassView:GetEndTime()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnEndtime
  end
  return NoviceBattlePassProxy.Instance.endTime
end

function NoviceBattlePassView:GetDepositId()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnDepositID
  end
  return GameConfig.NoviceBattlePass and GameConfig.NoviceBattlePass.DepositId
end

function NoviceBattlePassView:GetWarningTime()
  if self.bPType == 2 then
    return GameConfig.ReturnBattlePass and GameConfig.ReturnBattlePass.WarningTime or 0
  end
  return GameConfig.NoviceBattlePass and GameConfig.NoviceBattlePass.WarningTime or 0
end

function NoviceBattlePassView:GetCurBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetCurReturnBPLevel()
  end
  return NoviceBattlePassProxy.Instance:GetCurBPLevel()
end

function NoviceBattlePassView:GetMaxBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnMaxBPLevel
  end
  return NoviceBattlePassProxy.Instance.maxBPLevel
end

function NoviceBattlePassView:GetLevelConfig(level)
  if self.bPType == 2 then
    local datas = NoviceBattlePassProxy.Instance.returnBPLevelData
    return datas and datas[level]
  end
  return NoviceBattlePassProxy.Instance:LevelConfig(level)
end

function NoviceBattlePassView:GetCurExp()
  if self.bPType == 2 then
    return Game.Myself.data.userdata:Get(UDEnum.RETURN_BP_EXP)
  end
  return Game.Myself.data.userdata:Get(UDEnum.NOVICE_BP_EXP)
end

function NoviceBattlePassView:GetIsHaveAvailableReward()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsHaveAvailableReturnReward()
  end
  return NoviceBattlePassProxy.Instance:IsHaveAvailableReward()
end

function NoviceBattlePassView:GetIsPro()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnIsPro
  end
  return NoviceBattlePassProxy.Instance.isPro
end

function NoviceBattlePassView:GetProReward(datas)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetProReturnReward(datas)
  end
  return NoviceBattlePassProxy.Instance:GetProReward(datas)
end

function NoviceBattlePassView:GetNextImportantLv(maxShowLv)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetNextReturnImportantLv(maxShowLv)
  end
  return NoviceBattlePassProxy.Instance:GetNextImportantLv(maxShowLv)
end

function NoviceBattlePassView:CallBPTargetRewardCmd(is_all, lv, is_pro)
  if self.bPType == 2 then
    ServiceNoviceBattlePassProxy.Instance:CallReturnBPTargetRewardCmd(is_all, lv, is_pro)
    return
  end
  ServiceNoviceBattlePassProxy.Instance:CallNoviceBPTargetRewardCmd(is_all, lv, is_pro)
end

function NoviceBattlePassView:Init()
  self.bPType = self.viewdata.viewdata and self.viewdata.viewdata.bPType
  self:FindObjs()
  self:AddEvts()
  self:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function NoviceBattlePassView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("helpBtn", function()
    self:OnHelpBtnClick()
  end)
  local bg = self:FindGO("BgH")
  local title = self:FindComponent("title", UILabel, bg)
  title.text = self:GetTitle() or title.text
  self.levelLabel = self:FindComponent("level", UILabel)
  self.expProgressBar = self:FindComponent("progressBar", UIProgressBar)
  self.expLabel = self:FindComponent("exp", UILabel, self.expProgressBar.gameObject)
  self.remainTimeLabel = self:FindComponent("remainTime", UILabel)
  self.taskBtn = self:FindGO("taskBtn")
  self:AddClickEvent(self.taskBtn, function()
    self:OnTaskBtnClick()
  end)
  self:RegisterRedTipCheck(10729, self.taskBtn, 42)
  local buyLevelBtn = self:FindGO("buylevelbtn")
  self:AddClickEvent(buyLevelBtn, function()
    self:OnBuyLevelBtnClick()
  end)
  self.rewardPanel = self:FindGO("reward")
  self.advLock = self:FindGO("advLock")
  self.upgradeBtn = self:FindGO("upgradeBtn", self.rewardPanel)
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.receiveAllBtn = self:FindGO("onekeyBtn", self.rewardPanel)
  self:AddClickEvent(self.receiveAllBtn, function()
    self:OnReceiveAllBtnClick()
  end)
  self.receiveAllDisableBtn = self:FindGO("onekeyBtnGray", self.rewardPanel)
  self.rewardScrollView = self:FindComponent("LevelRewardScrollview", UIScrollView)
  
  function self.rewardScrollView.onDragStarted()
    self:OnScrollStart()
  end
  
  function self.rewardScrollView.onStoppedMoving()
    self:OnScrollStop()
  end
  
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 9,
    cellName = "NoviceBattlePassLevelRewardCell",
    control = NoviceBattlePassLevelRewardCell,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  local go = self:LoadCellPfb("NoviceBattlePassNextLevelRewardCell", self:FindGO("bigLevelRewardHolder"))
  self.nextLevelRewardCell = NoviceBattlePassLevelRewardCell.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self.upgradePanel = self:FindGO("upgrade")
  local proItemGrid = self:FindComponent("container", UIGrid, self.upgradePanel)
  self.proItemList = UIGridListCtrl.new(proItemGrid, BagItemCell, "BagItemCell")
  self.proItemList:AddEventListener(MouseEvent.MouseClick, self.HandleClickProItem, self)
  self:AddButtonEvent("closeBtn", function()
    self.upgradePanel:SetActive(false)
  end)
  self.priceLabel = self:FindComponent("price", UILabel, self.upgradePanel)
  self.buyBtn = self:FindGO("buyBtn")
  self:AddClickEvent(self.buyBtn, function()
    self:OnBuyBtnClick()
  end)
end

function NoviceBattlePassView:AddEvts()
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, self.RefreshPanel)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPRewardUpdateCmd, self.RefreshPanel)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, self.RefreshPanel)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBPRewardUpdateCmd, self.RefreshPanel)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.RefreshPanel)
  self:AddListenEvt(NoviceBattlePassEvent.ReturnBPEnd, self.CloseSelf)
end

function NoviceBattlePassView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function NoviceBattlePassView:OnEnter()
  NoviceBattlePassView.super.OnEnter(self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.CloseZeny, self.OnChargeLimitClose, self)
  local remainTime = self:GetEndTime() - ServerTime.CurServerTime() / 1000
  if remainTime <= 0 then
    self:CloseSelf()
    return
  end
  self:RefreshPanel()
  self:SetUpgradePanel()
end

function NoviceBattlePassView:OnExit()
  NoviceBattlePassView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.CloseZeny, self.OnChargeLimitClose, self)
  TimeTickManager.Me():ClearTick(self, 998)
  if self.virtualTShopGoodsCell then
    self.virtualTShopGoodsCell:OnCellDestroy()
    self.virtualTShopGoodsCell:VirtualClearSetData()
    self.virtualTShopGoodsCell = nil
  end
end

function NoviceBattlePassView:InitData()
end

function NoviceBattlePassView:RefreshPanel()
  self:OnRewardUpdate()
  local curLevel = self:GetCurBPLevel()
  self.levelLabel.text = curLevel
  local maxLv = self:GetMaxBPLevel()
  local level = curLevel < maxLv and curLevel or curLevel - 1
  local curLevelExp = self:GetLevelConfig(level).NeedExp
  local curExp = self:GetCurExp() or 0
  local nextLevel = math.min(curLevel + 1, maxLv)
  local nextLevelExp = self:GetLevelConfig(nextLevel).NeedExp
  curExp = math.min(curExp, nextLevelExp)
  local curValue = curExp - curLevelExp
  local nextValue = nextLevelExp - curLevelExp
  self.expLabel.text = curValue .. "/" .. nextValue
  self.expProgressBar.value = curValue / nextValue
  local remainTime = self:GetEndTime() - ServerTime.CurServerTime() / 1000
  self:RefreshRemainTimeLabel(remainTime)
  self:UpdateShowNextLevelReward(true)
end

function NoviceBattlePassView:RefreshRemainTimeLabel(remainTime)
  remainTime = math.max(remainTime, 0)
  local day, hour, min = ClientTimeUtil.FormatTimeBySec(remainTime)
  if day <= 0 and hour <= 0 then
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeMin, min)
  else
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTime, day, hour)
  end
end

function NoviceBattlePassView:OnHelpBtnClick()
  if self.bPType == 2 then
    if Table_Help[50001] then
      NoviceBattlePassView.super.OpenHelpView(self, Table_Help[50001])
    end
  elseif Table_Help[35210] then
    NoviceBattlePassView.super.OpenHelpView(self, Table_Help[35210])
  end
end

function NoviceBattlePassView:OnTaskBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.NoviceBattlePassTaskView,
    viewdata = {
      bPType = self.bPType
    }
  })
end

function NoviceBattlePassView:OnUpgradeBtnClick()
  if BranchMgr.IsJapan() then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ChargeLimitPanel"
    })
  end
  self.upgradePanel:SetActive(true)
end

function NoviceBattlePassView:OnReceiveAllBtnClick()
  self:CallBPTargetRewardCmd(true)
end

function NoviceBattlePassView:SetLevelReward()
  local levelRewards = {}
  local maxLv = self:GetMaxBPLevel()
  for i = 1, maxLv do
    TableUtility.ArrayPushBack(levelRewards, self:GetLevelConfig(i))
  end
  self.itemWrapHelper:UpdateInfo(levelRewards)
  local cells = self.itemWrapHelper:GetCellCtls()
  for _, cell in pairs(cells) do
    cell:SetBPType(self.bPType)
  end
  self.itemWrapHelper:SetStartPositionByIndex(self:GetCurBPLevel(), true)
  self:UpdateShowNextLevelReward()
  local canReceiveAll = self:GetIsHaveAvailableReward()
  self.receiveAllBtn:SetActive(canReceiveAll)
  self.receiveAllDisableBtn:SetActive(not canReceiveAll)
  local isPro = self:GetIsPro()
  self.upgradeBtn:SetActive(not isPro)
  self.advLock:SetActive(not isPro)
end

function NoviceBattlePassView:SetUpgradePanel()
  local datas = ReusableTable.CreateArray()
  datas = self:GetProReward(datas)
  self.proItemList:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
  local depositId = self:GetDepositId()
  local depositData = Table_Deposit[depositId]
  if depositData then
    self.priceLabel.text = depositData.priceStr or depositData.CurrencyType .. depositData.Rmb
    self.virtualTShopGoodsCell = NewRechargeVirtualRecommendTShopGoodsCell.new()
    self.virtualTShopGoodsCell:Init()
    self.virtualTShopGoodsCell:SetPurchaseSuccessCB(function()
      self:OnRewardUpdate()
      self.upgradePanel:SetActive(false)
    end)
    self.virtualTShopGoodsCell:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, depositId)
    self.virtualTShopGoodsCell:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShopItemPurchase, self)
  end
end

function NoviceBattlePassView:HandleSelectRewardIcon(itemId)
  self:SetAllRewardUnSelect()
end

function NoviceBattlePassView:SetAllRewardUnSelect()
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:SetAllRewardUnSelect()
  end
  self.nextLevelRewardCell:SetAllRewardUnSelect()
end

function NoviceBattlePassView:OnScrollStart()
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function NoviceBattlePassView:OnScrollStop()
  TimeTickManager.Me():ClearTick(self, 998)
end

function NoviceBattlePassView:UpdateShowNextLevelReward(forceUpdate)
  local maxShowLv = 0
  local cells = self.itemWrapHelper:GetCellCtls()
  local cell
  for i = 1, #cells do
    cell = cells[i]
    if cell.gameObject.activeSelf and maxShowLv < cell.level then
      maxShowLv = cell.level
    end
  end
  local nextLv = self:GetNextImportantLv(maxShowLv)
  if forceUpdate == true or self.nextLevelRewardCell.level ~= nextLv then
    self.nextLevelRewardCell:SetData(self:GetLevelConfig(nextLv))
    self.nextLevelRewardCell:SetShowType(2)
    self.nextLevelRewardCell:SetBPType(self.bPType)
  end
end

function NoviceBattlePassView:OnBuyBtnClick()
  local remainTime = self:GetEndTime() - ServerTime.CurServerTime() / 1000
  local warningTime = self:GetWarningTime() or 0
  if remainTime <= warningTime * 3600 then
    local param = {}
    param[1] = math.ceil(warningTime / 24)
    
    function param.confirmHandler()
      if self.virtualTShopGoodsCell then
        self.virtualTShopGoodsCell:Pre_Purchase()
      end
    end
    
    MsgManager.ShowMsgByIDTable(1105, param)
    self:RefreshRemainTimeLabel(remainTime)
  elseif self.virtualTShopGoodsCell then
    self.virtualTShopGoodsCell:Pre_Purchase()
  end
end

function NoviceBattlePassView:OnRewardUpdate()
  self:SetLevelReward()
end

function NoviceBattlePassView:HandleClickProItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    local x, y, z = NGUIUtil.GetUIPositionXYZ(cellCtrl.icon.gameObject)
    if 0 < x then
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
    else
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end

function NoviceBattlePassView:OnBuyLevelBtnClick()
  if not self.buylevelCell then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("BattlePassBuyLevelCell"))
    go.transform:SetParent(self.gameObject.transform, false)
    self.buylevelCell = NoviceBattlePassBuyLevelCell.new(go)
  end
  self.buylevelCell:SetBPType(self.bPType)
  self.buylevelCell.gameObject:SetActive(true)
  self.buylevelCell:SetData()
end

function NoviceBattlePassView:ShopItemPurchase(data)
  if data and data.m_funcRmbBuy then
    data.m_funcRmbBuy()
  end
end

function NoviceBattlePassView:OnChargeLimitConfirm(id)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "ChargeComfirmPanel",
    cid = id
  })
end

function NoviceBattlePassView:OnChargeLimitClose()
  self.upgradePanel:SetActive(false)
end

function NoviceBattlePassView:OnChargeLimitSelect()
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left then
    local depositId = self:GetDepositId()
    local currency = Table_Deposit[depositId] and Table_Deposit[depositId].Rmb
    currency = currency or 0
    self:SetButtonEnable(self.buyBtn, left < currency)
  end
end
