autoImport("ActivityPaySignImportantRewardCell")
autoImport("SpriteLabel")
ActivityPaySignView = class("ActivityPaySignView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityPaySignView")
local LabelEnabledEffectColor = Color(0.7686274509803922, 0.5254901960784314, 0, 1)

function ActivityPaySignView:Init()
  self.activityId = self.subViewData and self.subViewData.ActivityId
  redlog("ActivityPaySignView activityId", tostring(self.activityId))
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvents()
end

function ActivityPaySignView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityPaySignView"
  self.gameObject = obj
end

function ActivityPaySignView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function ActivityPaySignView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bannerTex = self:FindComponent("Banner", UITexture)
  local descGO = self:FindGO("Desc")
  self.descLabel = SpriteLabel.new(descGO, nil, nil, nil, true)
  self.helpBTN = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(32644, self.helpBTN)
  self.rewardScrollView = self:FindComponent("LevelRewardScrollview", UIScrollView)
  
  function self.rewardScrollView.onDragStarted()
    self:OnScrollStart()
  end
  
  function self.rewardScrollView.onStoppedMoving()
    self:OnScrollStop()
  end
  
  local cellName = "ActivityBattlePassLevelRewardCell"
  local className = ActivityPaySignRewardCell
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 7,
    cellName = cellName,
    control = className,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.levelRewardHolder = self:FindGO("bigLevelRewardHolder")
  local nextLevelCellName = "ActivityBattlePassNextLevelRewardCell"
  local nextLevelCellClass = ActivityPaySignImportantRewardCell
  local go = self:LoadCellPfb(nextLevelCellName, self.levelRewardHolder)
  self.nextLevelRewardCell = nextLevelCellClass.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self.upgradeBtn = self:FindGO("upgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.upgradeBtnLabel = self:FindComponent("text3", UILabel, self.upgradeBtn)
  self.receiveAllBtn = self:FindGO("onekeyBtn")
  self:AddClickEvent(self.receiveAllBtn, function()
    self:OnReceiveAllBtnClick()
  end)
  self.rewardBg = self:FindComponent("BG", UISprite)
end

function ActivityPaySignView:AddEvents()
  self:AddListenEvt(ServiceEvent.ActivityCmdPaySignSyncActCmd, self.HandlePaySignSyncActCmd)
end

function ActivityPaySignView:HandlePaySignSyncActCmd()
  self:RefreshView()
  local maxSignDay = ActivityPaySignProxy.Instance:GetMaxSignDay(self.activityId)
  local curSignedDay = ActivityPaySignProxy.Instance:GetCurSignedDay(self.activityId)
  local isPro = ActivityPaySignProxy.Instance:IsPro(self.activityId)
  if curSignedDay == maxSignDay and not isPro then
    MsgManager.ConfirmMsgByID(43664, function()
      self:OnUpgradeBtnClick()
    end)
  end
end

function ActivityPaySignView:RefreshView()
  local maxSignDay = ActivityPaySignProxy.Instance:GetMaxSignDay(self.activityId)
  local datas = {}
  for i = 1, maxSignDay do
    local data = ActivityPaySignProxy.Instance:GetSignDayConfig(self.activityId, i)
    TableUtility.ArrayPushBack(datas, data)
  end
  self.itemWrapHelper:UpdateInfo(datas, nil, true)
  local canReceiveAll = ActivityPaySignProxy.Instance:IsHaveAvailableReward(self.activityId)
  self:SetButtonEnable(self.receiveAllBtn, canReceiveAll, LabelEnabledEffectColor)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.receiveAllBtn)
  local isPro = ActivityPaySignProxy.Instance:IsPro(self.activityId)
  x = isPro and 116 or 287
  LuaGameObject.SetLocalPositionGO(self.receiveAllBtn, x, y, z)
  self.rewardBg.width = self.itemWrapHelper.wrap.itemSize * #datas + 8
  self:UpdateShowNextLevelReward(true)
  self.upgradeBtn:SetActive(not isPro)
end

function ActivityPaySignView:OnEnter()
  local gameConfig = GameConfig.ActPaySign and GameConfig.ActPaySign[self.activityId]
  if gameConfig then
    self.titleLabel.text = gameConfig.Title
    PictureManager.Instance:SetActivityTexture(gameConfig.Banner, self.bannerTex)
    self.descLabel:SetText(gameConfig.Desc)
    local depositID = gameConfig.DepositId
    local depositConfig = Table_Deposit[depositID]
    if depositConfig then
      self.upgradeBtnLabel.text = string.format(ZhString.ActivityPaySignView_Upgrade, depositConfig.priceStr or depositConfig.CurrencyType .. FunctionNewRecharge.FormatMilComma(depositConfig.Rmb))
    end
  end
  self:RefreshView()
end

function ActivityPaySignView:OnExit()
  local gameConfig = GameConfig.ActPaySign and GameConfig.ActPaySign[self.activityId]
  if gameConfig then
    PictureManager.Instance:UnloadActivityTexture(gameConfig.Banner, self.bannerTex)
  end
  TimeTickManager.Me():ClearTick(self, 998)
end

function ActivityPaySignView:OnUpgradeBtnClick()
  local config = GameConfig.ActPaySign and GameConfig.ActPaySign[self.activityId]
  local depositID = config and config.DepositId
  if depositID then
    local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(depositID)
    if not info then
      redlog("no deposit info, depositID:", depositID)
      return
    end
    self:PurchaseDeposit(info, 1)
  end
end

function ActivityPaySignView:OnReceiveAllBtnClick()
  if self.activityId then
    ServiceActivityCmdProxy.Instance:CallPaySignRewardActCmd(self.activityId)
  end
end

function ActivityPaySignView:OnScrollStart()
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function ActivityPaySignView:OnScrollStop()
  TimeTickManager.Me():ClearTick(self, 998)
end

function ActivityPaySignView:UpdateShowNextLevelReward(forceUpdate)
  local maxShowDay = 0
  local cells = self.itemWrapHelper:GetCellCtls()
  local cell
  for i = 1, #cells do
    cell = cells[i]
    if cell.gameObject.activeSelf and maxShowDay < cell.level then
      maxShowDay = cell.level
    end
  end
  local nextDay = ActivityPaySignProxy.Instance:GetNextImportantDay(self.activityId, maxShowDay)
  if forceUpdate == true or self.nextLevelRewardCell.level ~= nextDay then
    self.nextLevelRewardCell:SetData(ActivityPaySignProxy.Instance:GetSignDayConfig(self.activityId, nextDay))
  end
end

function ActivityPaySignView:PurchaseDeposit(info, count)
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
