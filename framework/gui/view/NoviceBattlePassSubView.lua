NoviceBattlePassSubView = class("NoviceBattlePassSubView", SubView)
local viewPath = ResourcePathHelper.UIView("NoviceBattlePassSubView")
autoImport("NoviceBattlePassLevelRewardCell")
autoImport("NewRechargeVirtualRecommendTShopGoodsCell")
autoImport("NoviceBattlePassBuyLevelCell")

function NoviceBattlePassSubView:Init()
  if self.inited then
    return
  end
  self.bPType = 1
  self:FindObjs()
  self:AddEvts()
  self:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.inited = true
end

function NoviceBattlePassSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "NoviceBattlePassSubView"
end

function NoviceBattlePassSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("NoviceBattlePassSubView")
  self:AddButtonEvent("CloseButton", function()
    self.container:CloseSelf()
  end)
  self:AddButtonEvent("helpBtn", function()
    self:OnHelpBtnClick()
  end)
  self.bgTexture = self:FindGO("BgH"):GetComponent(UITexture)
  self.innerBgTexture = self:FindGO("FixedTexture"):GetComponent(UITexture)
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
  self.receiveAllBtn_BoxCollider = self.receiveAllBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.receiveAllBtn, function()
    self:OnReceiveAllBtnClick()
  end)
  self.rewardScrollView = self:FindComponent("LevelRewardScrollview", UIScrollView)
  
  function self.rewardScrollView.onDragStarted()
    self:OnScrollStart()
  end
  
  function self.rewardScrollView.onStoppedMoving()
    self:OnScrollStop()
  end
  
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 7,
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

function NoviceBattlePassSubView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function NoviceBattlePassSubView:AddEvts()
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPRewardUpdateCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBPRewardUpdateCmd, self.RefreshPage)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.RefreshPage)
end

function NoviceBattlePassSubView:OnEnter()
  EventManager.Me():AddEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.CloseZeny, self.OnChargeLimitClose, self)
  local remainTime = self:GetEndTime() - ServerTime.CurServerTime() / 1000
  if remainTime <= 0 then
    return
  end
  self:RefreshPage()
  self:SetUpgradePanel()
  PictureManager.Instance:SetUI("Noviceactivity_bg2_bottom_01", self.bgTexture)
  PictureManager.Instance:SetUI("calendar_bg1_picture2", self.innerBgTexture)
end

function NoviceBattlePassSubView:OnExit()
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.CloseZeny, self.OnChargeLimitClose, self)
  TimeTickManager.Me():ClearTick(self, 998)
  if self.virtualTShopGoodsCell then
    self.virtualTShopGoodsCell:OnCellDestroy()
    self.virtualTShopGoodsCell:VirtualClearSetData()
    self.virtualTShopGoodsCell = nil
  end
  PictureManager.Instance:UnLoadUI("Noviceactivity_bg2_bottom_01", self.bgTexture)
  PictureManager.Instance:UnLoadUI("calendar_bg1_picture2", self.innerBgTexture)
end

function NoviceBattlePassSubView:InitData()
end

function NoviceBattlePassSubView:RefreshPage()
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
  self:UpdateShowNextLevelReward(true)
  if self.gameObject.activeSelf then
    self.container:TimeLeftCountDown(self:GetEndTime())
  end
end

function NoviceBattlePassSubView:RefreshRemainTimeLabel(remainTime)
  remainTime = math.max(remainTime, 0)
  local day, hour, min = ClientTimeUtil.FormatTimeBySec(remainTime)
  if day <= 0 and hour <= 0 then
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeMin, min)
  else
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTime, day, hour)
  end
end

function NoviceBattlePassSubView:OnHelpBtnClick()
  if self.bPType == 2 then
    if Table_Help[50001] then
      NoviceBattlePassView.super.OpenHelpView(self, Table_Help[50001])
    end
  elseif Table_Help[35210] then
    NoviceBattlePassView.super.OpenHelpView(self, Table_Help[35210])
  end
end

function NoviceBattlePassSubView:OnTaskBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.NoviceBattlePassTaskView,
    viewdata = {
      bPType = self.bPType
    }
  })
end

function NoviceBattlePassSubView:OnUpgradeBtnClick()
  if BranchMgr.IsJapan() then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ChargeLimitPanel"
    })
  end
  self.upgradePanel:SetActive(true)
end

function NoviceBattlePassSubView:OnReceiveAllBtnClick()
  self:CallBPTargetRewardCmd(true)
end

function NoviceBattlePassSubView:SetLevelReward()
  local levelRewards = {}
  local maxLv = self:GetMaxBPLevel()
  for i = 1, maxLv do
    TableUtility.ArrayPushBack(levelRewards, self:GetLevelConfig(i))
  end
  self.itemWrapHelper:UpdateInfo(levelRewards, false)
  local cells = self.itemWrapHelper:GetCellCtls()
  for _, cell in pairs(cells) do
    cell:SetBPType(self.bPType)
  end
  self.itemWrapHelper:SetStartPositionByIndex(self:GetCurBPLevel(), true)
  self:UpdateShowNextLevelReward()
  local canReceiveAll = self:GetIsHaveAvailableReward()
  if canReceiveAll then
    self:SetTextureWhite(self.receiveAllBtn, LuaColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706))
  else
    self:SetTextureGrey(self.receiveAllBtn)
  end
  self.receiveAllBtn_BoxCollider.enabled = canReceiveAll
  local isPro = self:GetIsPro()
  self.upgradeBtn:SetActive(not isPro)
  self.advLock:SetActive(not isPro)
end

function NoviceBattlePassSubView:SetUpgradePanel()
  local datas = ReusableTable.CreateArray()
  datas = self:GetProReward(datas)
  self.proItemList:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
  local depositId = self:GetDepositId()
  local depositData = Table_Deposit[depositId]
  if depositData then
    self.priceLabel.text = depositData.CurrencyType .. depositData.Rmb
    if not self.virtualTShopGoodsCell then
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
end

function NoviceBattlePassSubView:HandleSelectRewardIcon(itemId)
  self:SetAllRewardUnSelect()
end

function NoviceBattlePassSubView:SetAllRewardUnSelect()
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:SetAllRewardUnSelect()
  end
  self.nextLevelRewardCell:SetAllRewardUnSelect()
end

function NoviceBattlePassSubView:OnScrollStart()
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function NoviceBattlePassSubView:OnScrollStop()
  TimeTickManager.Me():ClearTick(self, 998)
end

function NoviceBattlePassSubView:UpdateShowNextLevelReward(forceUpdate)
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

function NoviceBattlePassSubView:OnBuyBtnClick()
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

function NoviceBattlePassSubView:OnRewardUpdate()
  self:SetLevelReward()
end

function NoviceBattlePassSubView:HandleClickProItem(cellCtrl)
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

function NoviceBattlePassSubView:OnBuyLevelBtnClick()
  if not self.buylevelCell then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("BattlePassBuyLevelCell"))
    go.transform:SetParent(self.gameObject.transform, false)
    self.buylevelCell = NoviceBattlePassBuyLevelCell.new(go)
  end
  self.buylevelCell:SetBPType(self.bPType)
  self.buylevelCell.gameObject:SetActive(true)
  self.buylevelCell:SetData()
end

function NoviceBattlePassSubView:ShopItemPurchase(data)
  if data and data.m_funcRmbBuy then
    data.m_funcRmbBuy()
  end
end

function NoviceBattlePassSubView:OnChargeLimitConfirm(id)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "ChargeComfirmPanel",
    cid = id
  })
end

function NoviceBattlePassSubView:OnChargeLimitClose()
  self.upgradePanel:SetActive(false)
end

function NoviceBattlePassSubView:OnChargeLimitSelect()
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

function NoviceBattlePassSubView:GetTitle()
  if self.bPType == 2 then
    return GameConfig.ReturnBattlePass.Name
  end
  return GameConfig.NoviceBattlePass.Name
end

function NoviceBattlePassSubView:GetEndTime()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnEndtime
  end
  return NoviceBattlePassProxy.Instance.endTime
end

function NoviceBattlePassSubView:GetDepositId()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnDepositID
  end
  return GameConfig.NoviceBattlePass and GameConfig.NoviceBattlePass.DepositId
end

function NoviceBattlePassSubView:GetWarningTime()
  if self.bPType == 2 then
    return GameConfig.ReturnBattlePass and GameConfig.ReturnBattlePass.WarningTime or 0
  end
  return GameConfig.NoviceBattlePass and GameConfig.NoviceBattlePass.WarningTime or 0
end

function NoviceBattlePassSubView:GetCurBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetCurReturnBPLevel()
  end
  return NoviceBattlePassProxy.Instance:GetCurBPLevel()
end

function NoviceBattlePassSubView:GetMaxBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnMaxBPLevel
  end
  return NoviceBattlePassProxy.Instance.maxBPLevel
end

function NoviceBattlePassSubView:GetLevelConfig(level)
  if self.bPType == 2 then
    local datas = NoviceBattlePassProxy.Instance.returnBPLevelData
    return datas and datas[level]
  end
  return NoviceBattlePassProxy.Instance:LevelConfig(level)
end

function NoviceBattlePassSubView:GetCurExp()
  if self.bPType == 2 then
    return Game.Myself.data.userdata:Get(UDEnum.RETURN_BP_EXP)
  end
  return Game.Myself.data.userdata:Get(UDEnum.NOVICE_BP_EXP)
end

function NoviceBattlePassSubView:GetIsHaveAvailableReward()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsHaveAvailableReturnReward()
  end
  return NoviceBattlePassProxy.Instance:IsHaveAvailableReward()
end

function NoviceBattlePassSubView:GetIsPro()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnIsPro
  end
  return NoviceBattlePassProxy.Instance.isPro
end

function NoviceBattlePassSubView:GetProReward(datas)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetProReturnReward(datas)
  end
  return NoviceBattlePassProxy.Instance:GetProReward(datas)
end

function NoviceBattlePassSubView:GetNextImportantLv(maxShowLv)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetNextReturnImportantLv(maxShowLv)
  end
  return NoviceBattlePassProxy.Instance:GetNextImportantLv(maxShowLv)
end

function NoviceBattlePassSubView:CallBPTargetRewardCmd(is_all, lv, is_pro)
  if self.bPType == 2 then
    ServiceNoviceBattlePassProxy.Instance:CallReturnBPTargetRewardCmd(is_all, lv, is_pro)
    return
  end
  ServiceNoviceBattlePassProxy.Instance:CallNoviceBPTargetRewardCmd(is_all, lv, is_pro)
end
