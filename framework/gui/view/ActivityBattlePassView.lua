autoImport("ActivityBattlePassNextLevelRewardCell")
autoImport("ActivityBattlePassBasicLevelRewardCell")
autoImport("ActivityBattlePassBuyLevelCell")
autoImport("ActivityBattlePassTaskCell")
autoImport("NewRechargeGiftTipCell")
autoImport("NewHappyShopBuyItemCell")
ActivityBattlePassView = class("ActivityBattlePassView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityBattlePassView")

function ActivityBattlePassView:GetStartTime()
  return ActivityBattlePassProxy.Instance:GetStartTime(self.activityId)
end

function ActivityBattlePassView:GetEndTime()
  return ActivityBattlePassProxy.Instance:GetEndTime(self.activityId)
end

function ActivityBattlePassView:GetWarningTime()
  return GameConfig.ActivityBattlePass and GameConfig.ActivityBattlePass.WarningTime or 0
end

function ActivityBattlePassView:GetCurBPLevel()
  return ActivityBattlePassProxy.Instance:GetCurBPLevel(self.activityId)
end

function ActivityBattlePassView:GetMaxBPLevel()
  return ActivityBattlePassProxy.Instance.maxBPLevel[self.activityId]
end

function ActivityBattlePassView:GetLevelConfig(level)
  return ActivityBattlePassProxy.Instance:LevelConfig(self.activityId, level)
end

function ActivityBattlePassView:GetCurExp()
  return ActivityBattlePassProxy.Instance:GetCurExp(self.activityId)
end

function ActivityBattlePassView:GetIsHaveAvailableReward()
  return ActivityBattlePassProxy.Instance:IsHaveAvailableReward(self.activityId)
end

function ActivityBattlePassView:GetIsPro()
  return ActivityBattlePassProxy.Instance.isPro[self.activityId]
end

function ActivityBattlePassView:GetProReward(datas)
  return ActivityBattlePassProxy.Instance:GetProReward(self.activityId, datas)
end

function ActivityBattlePassView:GetNextImportantLv(maxShowLv)
  return ActivityBattlePassProxy.Instance:GetNextImportantLv(self.activityId, maxShowLv)
end

function ActivityBattlePassView:CallBPTargetRewardCmd(activityId)
  ServiceActivityCmdProxy.Instance:CallActBpGetRewardCmd(activityId)
end

local btnMiddleX = 116
local btnLeftX = -61
local btnRightX = 287
local tempVector3 = LuaVector3.Zero()

function ActivityBattlePassView:Init()
  self.activityId = self.subViewData and self.subViewData.ActivityId
  self:CheckIsBasic()
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvts()
  self:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityBattlePassView:CheckIsBasic()
  self.isBasic = false
  local levelConfig = self:GetLevelConfig(1)
  if levelConfig then
    self.isBasic = not levelConfig.ProRewardItems or levelConfig.ProRewardItems == _EmptyTable
  end
end

function ActivityBattlePassView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityBattlePassView"
  self.gameObject = obj
end

function ActivityBattlePassView:FindObjs()
  self.helpBTN = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(35275, self.helpBTN)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.levelLabel = self:FindComponent("level", UILabel)
  self.expProgressBar = self:FindComponent("progressBar", UIProgressBar)
  self.expLabel = self:FindComponent("exp", UILabel, self.expProgressBar.gameObject)
  self.remainTimeLabel = self:FindComponent("remainTime", UILabel)
  self.taskBtn = self:FindGO("taskBtn")
  self:AddClickEvent(self.taskBtn, function()
    self:OnTaskBtnClick()
  end)
  self.taskBtnSelect = self:FindGO("select", self.taskBtn)
  self.taskBtnIcon = self:FindGO("icon", self.taskBtn)
  self.taskBtnIcon_Back = self:FindGO("icon_back", self.taskBtn)
  local buyLevelBtn = self:FindGO("buylevelbtn")
  self:AddClickEvent(buyLevelBtn, function()
    self:OnBuyLevelBtnClick()
  end)
  buyLevelBtn:SetActive(not self.isBasic)
  self.rewardPanel = self:FindGO("reward")
  self.upgradeBtn = self:FindGO("upgradeBtn", self.rewardPanel)
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.cost = self:FindGO("cost")
  self.costLabel = self:FindComponent("num", UILabel, self.cost)
  self.costIcon = self:FindComponent("icon", UISprite, self.cost)
  if not self.isBasic then
    IconManager:SetItemIconById(GameConfig.ActivityBattlePass[self.activityId].UpgradeItem, self.costIcon)
    self.costLabel.text = GameConfig.ActivityBattlePass[self.activityId].UpgradePrice
  end
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
  
  local cellName = self.isBasic and "ActivityBattlePassBasicLevelRewardCell" or "ActivityBattlePassLevelRewardCell"
  local className = self.isBasic and ActivityBattlePassBasicLevelRewardCell or ActivityBattlePassLevelRewardCell
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 9,
    cellName = cellName,
    control = className,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.itemWrapHelper:AddEventListener(UICellEvent.OnCellClicked, self.HandleBuyCell, self)
  self.levelRewardHolder = self:FindGO("bigLevelRewardHolder")
  local nextLevelCellName = self.isBasic and "ActivityBattlePassBasicNextLevelRewardCell" or "ActivityBattlePassNextLevelRewardCell"
  local nextLevelCellClass = self.isBasic and ActivityBattlePassBasicLevelRewardCell or ActivityBattlePassNextLevelRewardCell
  local go = self:LoadCellPfb(nextLevelCellName, self.levelRewardHolder)
  self.nextLevelRewardCell = nextLevelCellClass.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self.taskPanel = self:FindGO("task")
  self.taskScrollView = self:FindGO("LevelTaskScrollview")
  local taskGrid = self:FindComponent("LevelTaskGrid", UIGrid)
  self.taskListCtrl = UIGridListCtrl.new(taskGrid, ActivityBattlePassTaskCell, "ActivityBattlePassTaskCell")
  self.taskListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleGotoBtnClick, self)
  self.upgradePanel = self:FindGO("upgrade")
  self.upgradeTitle = self:FindComponent("upgradeTitle", UILabel, self.upgradePanel)
  local proItemGrid = self:FindComponent("container", UIGrid, self.upgradePanel)
  self.proItemList = UIGridListCtrl.new(proItemGrid, BagItemCell, "BagItemCell")
  self.proItemList:AddEventListener(MouseEvent.MouseClick, self.HandleClickProItem, self)
  self:AddButtonEvent("closeBtn", function()
    self:CloseUpgradePanel()
  end)
  self.priceIcon = self:FindComponent("money", UISprite, self.upgradePanel)
  self.priceLabel = self:FindComponent("price", UILabel, self.upgradePanel)
  self.buyBtn = self:FindGO("buyBtn")
  self:AddClickEvent(self.buyBtn, function()
    self:OnBuyBtnClick()
  end)
  self:AddButtonEvent("cancelBtn", function()
    self:CloseUpgradePanel()
  end)
  self.checkToggle = self:FindComponent("noTipCheckBg", UIToggle, self.upgradePanel)
  self.levelRewardBg = self:FindComponent("BG", UIMultiSprite)
  self.levelRewardBg.CurrentState = self.isBasic and 1 or 0
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
  self:InitGiftItemCell()
end

function ActivityBattlePassView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell", self.gameObject)
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function ActivityBattlePassView:InitGiftItemCell()
  local go = self:LoadCellPfb("NewRechargeGiftTipCell", self.gameObject)
  self.giftCell = NewRechargeGiftTipCell.new(go)
  self.giftCell.RealConfirm = ActivityIntegrationTaskSubView.RealConfirm
  self.giftCell.gameObject:SetActive(false)
end

function ActivityBattlePassView:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdActBpUpdateCmd, self.RefreshPanel)
end

function ActivityBattlePassView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function ActivityBattlePassView:OnEnter()
  ActivityBattlePassView.super.OnEnter(self)
  self:RefreshPanel()
  if not self.isBasic then
    self:SetUpgradePanel()
  end
end

function ActivityBattlePassView:OnExit()
  ActivityBattlePassView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self, 998)
end

function ActivityBattlePassView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local subtab = viewdata and viewdata.subtab or 1
  self.isTaskState = subtab ~= 1 or false
end

function ActivityBattlePassView:RefreshPanel()
  self:SetExpPanel()
  self:SetInfoPanel()
end

function ActivityBattlePassView:SetExpPanel()
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
end

function ActivityBattlePassView:SetInfoPanel()
  self:SetTaskTitle()
  self.taskBtnSelect:SetActive(self.isTaskState)
  self.taskBtnIcon:SetActive(not self.isTaskState)
  self.taskBtnIcon_Back:SetActive(self.isTaskState)
  self.rewardScrollView.gameObject:SetActive(not self.isTaskState)
  self.levelRewardHolder:SetActive(not self.isTaskState)
  self.taskPanel:SetActive(self.isTaskState)
  self.receiveAllBtn:SetActive(not self.isTaskState)
  self.receiveAllDisableBtn:SetActive(not self.isTaskState)
  if self.isBasic then
    self.upgradeBtn:SetActive(false)
  else
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.upgradeBtn)
    x = self.isTaskState and btnMiddleX or btnLeftX
    LuaGameObject.SetLocalPositionGO(self.upgradeBtn, x, y, z)
    local isPro = self:GetIsPro()
    self.upgradeBtn:SetActive(not isPro)
  end
  if self.isTaskState then
    self:SetTaskPanel()
  else
    self:SetRewardPanel()
  end
end

function ActivityBattlePassView:SetRewardPanel()
  self:OnRewardUpdate()
  self:UpdateShowNextLevelReward(true)
end

function ActivityBattlePassView:SetTaskTitle()
  local gameConfig = GameConfig.ActivityBattlePass[self.activityId]
  self.titleLabel.text = self.isTaskState and gameConfig.TaskTitle or gameConfig.Title
end

function ActivityBattlePassView:RefreshRemainTimeLabel(remainTime)
  remainTime = math.max(remainTime, 0)
  local day, hour, min = ClientTimeUtil.FormatTimeBySec(remainTime)
  if day <= 0 and hour <= 0 then
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeMin, min)
  else
    self.remainTimeLabel.text = string.format(ZhString.NoviceBattlePassRemainTime, day, hour)
  end
end

function ActivityBattlePassView:OnTaskBtnClick()
  self.isTaskState = not self.isTaskState
  self:SetInfoPanel()
end

function ActivityBattlePassView:OnUpgradeBtnClick()
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(self.activityId)
  local curTime = ServerTime.CurServerTime()
  if not dont or 0 < dont and dont < curTime then
    self:OpenUpgradePanel()
  else
    self:OnBuyBtnClick()
  end
end

function ActivityBattlePassView:OnReceiveAllBtnClick()
  self:CallBPTargetRewardCmd(self.activityId)
end

function ActivityBattlePassView:SetLevelReward()
  local levelRewards = {}
  local maxLv = self:GetMaxBPLevel()
  for i = 1, maxLv do
    TableUtility.ArrayPushBack(levelRewards, self:GetLevelConfig(i))
  end
  self.itemWrapHelper:UpdateInfo(levelRewards)
  self.itemWrapHelper:SetStartPositionByIndex(self:GetCurBPLevel(), true)
  local canReceiveAll = self:GetIsHaveAvailableReward()
  self.receiveAllBtn:SetActive(canReceiveAll)
  self.receiveAllDisableBtn:SetActive(not canReceiveAll)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.receiveAllBtn)
  if self.isBasic then
    x = btnMiddleX
  else
    local isPro = self:GetIsPro()
    x = isPro and btnMiddleX or btnRightX
  end
  LuaGameObject.SetLocalPositionGO(self.receiveAllBtn, x, y, z)
  LuaGameObject.SetLocalPositionGO(self.receiveAllDisableBtn, x, y, z)
  self.levelRewardBg.width = self.itemWrapHelper.wrap.itemSize * #levelRewards + 8
end

function ActivityBattlePassView:SetUpgradePanel()
  self.upgradeTitle.text = GameConfig.ActivityBattlePass[self.activityId].UpgradeTitle
  local datas = ReusableTable.CreateArray()
  datas = self:GetProReward(datas)
  self.proItemList:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
  IconManager:SetItemIconById(GameConfig.ActivityBattlePass[self.activityId].UpgradeItem, self.priceIcon)
  self.priceLabel.text = GameConfig.ActivityBattlePass[self.activityId].UpgradePrice
end

function ActivityBattlePassView:OpenUpgradePanel()
  self.upgradePanel:SetActive(true)
end

function ActivityBattlePassView:CloseUpgradePanel()
  if self.checkToggle.value then
    LocalSaveProxy.Instance:AddDontShowAgain(self.activityId, 1)
  end
  self.upgradePanel:SetActive(false)
end

function ActivityBattlePassView:OnScrollStart()
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function ActivityBattlePassView:OnScrollStop()
  TimeTickManager.Me():ClearTick(self, 998)
end

function ActivityBattlePassView:UpdateShowNextLevelReward(forceUpdate)
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
  end
end

function ActivityBattlePassView:OnBuyBtnClick()
  local myCatGold = MyselfProxy.Instance:GetLottery()
  local needCatGold = GameConfig.ActivityBattlePass[self.activityId].UpgradePrice
  if myCatGold < needCatGold then
    MsgManager.ConfirmMsgByID(3551, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    end)
  else
    OverseaHostHelper:GachaUseComfirm(needCatGold, function()
      self:ShopItemPurchase()
    end)
  end
end

function ActivityBattlePassView:OnRewardUpdate()
  self:SetLevelReward()
end

function ActivityBattlePassView:HandleClickProItem(cellCtrl)
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

function ActivityBattlePassView:OnBuyLevelBtnClick()
  if not self.buylevelCell then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityBattlePassBuyLevelCell"))
    go.transform:SetParent(self.gameObject.transform, false)
    self.buylevelCell = ActivityBattlePassBuyLevelCell.new(go)
  end
  self.buylevelCell.gameObject:SetActive(true)
  self.buylevelCell:SetData(self.activityId)
end

function ActivityBattlePassView:ShopItemPurchase()
  local shopId = GameConfig.ActivityBattlePass[self.activityId].ShopId
  ServiceSessionShopProxy.Instance:CallBuyShopItem(shopId, 1)
  self:CloseUpgradePanel()
end

function ActivityBattlePassView:SetTaskPanel()
  local proxy = ActivityBattlePassProxy.Instance
  local datas = proxy:GetTaskList(self.activityId)
  table.sort(datas, function(a, b)
    local aData = proxy:GetTaskData(self.activityId, a)
    local bData = proxy:GetTaskData(self.activityId, b)
    local aSData = Table_ActBpTarget[a]
    local bSData = Table_ActBpTarget[b]
    if aData.state == EACTQUESTSTATE.EACT_QUEST_REWARDED or bData.state == EACTQUESTSTATE.EACT_QUEST_REWARDED then
      if aData.state == bData.state then
        if aSData.Type == bSData.Type then
          return aSData.id < bSData.id
        end
        return aSData.Type > bSData.Type
      end
      return bData.state == EACTQUESTSTATE.EACT_QUEST_REWARDED
    end
    if aSData.Type == bSData.Type then
      if aData.state == bData.state then
        return aSData.id < bSData.id
      else
        return aData.state < bData.state
      end
    else
      return aSData.Type > bSData.Type
    end
  end)
  self.taskListCtrl:ResetDatas(datas)
end

function ActivityBattlePassView:HandleGotoBtnClick(cellCtrl)
  local staticData = Table_ActBpTarget[cellCtrl.id]
  if staticData then
    local go = staticData.Goto
    if go and 0 < #go then
      if 1 < #go then
        local questIds = staticData.Param.quest_id
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ShortCutOptionPopUp,
          viewdata = {
            data = questIds or go,
            gotomode = go,
            functiontype = questIds and 2 or 1,
            alignIndex = true
          }
        })
      else
        FuncShortCutFunc.Me():CallByID(go[1])
      end
      if self.container then
        self.container:CloseSelf()
      end
      return
    end
    local msg = staticData.Message
    if msg and 0 < #msg then
      if 1 < #msg then
        local param = {}
        for i = 2, #msg do
          param[#param + 1] = msg[i]
        end
        MsgManager.ShowMsgByIDTable(msg[1], param)
      else
        MsgManager.ShowMsgByID(msg[1])
      end
    end
  end
end

function ActivityBattlePassView:HandleBuyCell(cellCtrl)
  xdlog("Handle buycell")
  local shopItemData = cellCtrl.shopItemData
  if shopItemData then
    self:HandleClickShopItem(shopItemData)
  elseif cellCtrl.data and cellCtrl.data.DepositID then
    self:HandleClickDepositItem(cellCtrl)
  end
end

function ActivityBattlePassView:HandleClickShopItem(shopItemData)
  xdlog("click shop item")
  local id = shopItemData and shopItemData.id
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopId, id)
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    local goodsID = data.goodsID
    local tbItem = Table_Item[goodsID]
    if tbItem and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
      self.buyCell.gameObject:SetActive(false)
      self.giftCell.gameObject:SetActive(true)
      self.giftCell:SetData(data)
      HappyShopProxy.Instance:SetSelectId(data.id)
    else
      self.giftCell.gameObject:SetActive(false)
      self.buyCell.gameObject:SetActive(true)
      self:UpdateBuyItemInfo(data)
    end
  end
end

function ActivityBattlePassView:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function ActivityBattlePassView:UpdateBuyItemInfo(data, funcBuy)
  if data then
    local itemType = data.itemtype
    local positionX, positionY = self:GetScreenTouchedPos()
    if 0 < positionX then
      self.buyCell:updateLocalPostion(-217)
    else
      self.buyCell:updateLocalPostion(300)
    end
    self.buyCell:SetData(data, funcBuy)
    TipsView.Me():HideCurrent()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function ActivityBattlePassView:HandleClickDepositItem(cellctl)
  local depositID = cellctl and cellctl.data and cellctl.data.DepositID
  xdlog("click deposit", depositID)
  local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
  if not info then
    redlog("no info")
    return
  end
  local cbfunc = function(count)
    self:PurchaseDeposit(info, count)
  end
  local m_funcRmbBuy = function(count)
    if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
      self:Invoke_DepositConfirmPanel(cbfunc)
    else
      cbfunc(count)
    end
  end
  local tbItem = Table_Item[info.itemID]
  if tbItem ~= nil and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
    self.giftCell.gameObject:SetActive(true)
    self.giftCell:SetData(info, m_funcRmbBuy)
  else
    self.buyCell.gameObject:SetActive(true)
    self:UpdateBuyItemInfo(info, m_funcRmbBuy)
  end
end

function ActivityBattlePassView:PurchaseDeposit(info, count)
  if not info then
    redlog("Purchase no info")
    return
  end
  local depositInfo = info
  local productConf = depositInfo.productConf
  local productID = depositInfo and depositInfo.productConf and depositInfo.productConf.ProductID
  if ApplicationInfo.IsPcWebPay() then
    if productConf.PcEnable == 1 then
      MsgManager.ConfirmMsgByID(43467, function()
        ApplicationInfo.OpenPCRechargeUrl()
      end, nil, nil, nil)
    else
      MsgManager.ShowMsgByID(43466)
    end
    return
  end
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {}
    callbacks[1] = function(str_result)
      local str_result = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPaySuccess, " .. str_result)
      local currency = productConf and productConf.Rmb or 0
      ChargeComfirmPanel:ReduceLeft(tonumber(currency))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      LogUtility.Warning("OnPaySuccess")
      NewRechargeProxy.CDeposit:SetFPRFlag2(productConf.id)
      xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
      NewRechargeProxy.Instance:CallClientPayLog(113)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks, count)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end

function ActivityBattlePassView:Invoke_DepositConfirmPanel(cb)
  local depositInfo = self.currentItem.data and self.currentItem.data.info
  local productConf = depositInfo.productConf
  local productID = depositInfo and depositInfo.productConf and depositInfo.productConf.ProductID
  if productID then
    local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
    local productPrice = productConf.Rmb
    local productCount = productConf.Count
    local currencyType = productConf.CurrencyType
    local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
    local productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
    if BranchMgr.IsKorea() then
      productD = " [0075BCFF]" .. productDesc .. "[-] "
    end
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      if cb then
        cb()
      end
    end)
  end
end
