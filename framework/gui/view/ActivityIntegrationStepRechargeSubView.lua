autoImport("StepRechargeCell")
autoImport("ColliderItemCell")
autoImport("ActivityPaySignView")
ActivityIntegrationStepRechargeSubView = class("ActivityIntegrationStepRechargeSubView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationStepRechargeSubView")

function ActivityIntegrationStepRechargeSubView:Init()
  if self.inited then
    return
  end
  self.activityId = not self.subViewData or self.subViewData.ActivityId or self.subViewData.activityId
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvents()
  self.inited = true
end

function ActivityIntegrationStepRechargeSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationStepRechargeSubView"
  self.gameObject = obj
end

function ActivityIntegrationStepRechargeSubView:FindObjs()
  self.titleLabel = self:FindComponent("TitleLabel", UILabel, self.gameObject)
  self.timeLabel = self:FindComponent("TimeLabel", UILabel, self.gameObject)
  self.descLabel = self:FindComponent("Desc", UILabel, self.gameObject)
  self.bgTex = self:FindComponent("BgTexture", UITexture, self.gameObject)
  self.panelGO = self:FindGO("Panel", self.gameObject)
  if self.panelGO then
    self.scrollView = self:FindComponent("Scroll View", UIScrollView, self.panelGO)
  else
    self.scrollView = self:FindComponent("Scroll View", UIScrollView, self.gameObject)
  end
  self.freePart = self:FindGO("FreePart", self.gameObject)
  self.getFreeBtn = self:FindGO("GetFreeBtn", self.gameObject)
  self.geted = self:FindGO("Geted", self.gameObject)
  self.dayRewardIcon = self.freePart and self:FindComponent("Icon", UISprite, self.freePart)
  self.dayRewardLabel = self.freePart and self:FindComponent("ItemLabel", UILabel, self.freePart)
  self.dayRewardScrollView = self.freePart and self:FindComponent("Scroll View", UIScrollView, self.freePart)
  local dayRewardGrid = self.freePart and self:FindComponent("Grid", UIGrid, self.freePart)
  if dayRewardGrid then
    self.dayRewardList = UIGridListCtrl.new(dayRewardGrid, ColliderItemCell, "ColliderItemCell")
    self.dayRewardList:AddEventListener(MouseEvent.MouseClick, self.HandleClickDayRewardCell, self)
    if self.dayRewardIcon then
      self.dayRewardIcon.gameObject:SetActive(false)
    end
    if self.dayRewardLabel then
      self.dayRewardLabel.gameObject:SetActive(false)
    end
  elseif self.dayRewardIcon then
    self:AddClickEvent(self.dayRewardIcon.gameObject, function()
      self:HandleClickDayRewardIcon()
    end)
  end
  if self.getFreeBtn then
    self:AddClickEvent(self.getFreeBtn, function()
      self:OnClickDayReward()
    end)
  end
  self.stageCells = {}
  local holderCount = 0
  for i = 1, 9 do
    local go = self:FindGO(tostring(i), self.gameObject)
    if go then
      holderCount = holderCount + 1
      local cell = StepRechargeCell.new(go)
      cell:AddEventListener(StepRechargeEvent.Buy, self.HandleClickBuy, self)
      cell:AddEventListener(StepRechargeEvent.Receive, self.HandleClickReceive, self)
      self.stageCells[i] = cell
    end
  end
  if holderCount == 0 then
    local grid
    if self.panelGO then
      grid = self:FindComponent("Grid", UIGrid, self.panelGO)
    else
      grid = self:FindComponent("Grid", UIGrid, self.gameObject)
    end
    if grid then
      self.stageList = UIGridListCtrl.new(grid, StepRechargeCell, "StepRechargeCell")
      self.stageList:AddEventListener(StepRechargeEvent.Buy, self.HandleClickBuy, self)
      self.stageList:AddEventListener(StepRechargeEvent.Receive, self.HandleClickReceive, self)
    end
  end
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      local helpConfig = self.helpID and Table_Help[self.helpID]
      if helpConfig then
        self:OpenHelpView(helpConfig)
      end
    end)
  end
end

function ActivityIntegrationStepRechargeSubView:HandleClickDayRewardCell(cell)
  if cell and cell.data then
    self:ShowDayRewardItemTip(cell.data, cell.icon or cell.gameObject)
  end
end

function ActivityIntegrationStepRechargeSubView:HandleClickDayRewardIcon()
  if self.dayRewardItemData then
    self:ShowDayRewardItemTip(self.dayRewardItemData, self.dayRewardIcon)
  end
end

function ActivityIntegrationStepRechargeSubView:ShowDayRewardItemTip(itemData, stick)
  if not itemData or not stick then
    return
  end
  self.dayRewardTipData = self.dayRewardTipData or {
    funcConfig = {}
  }
  self.dayRewardTipData.itemdata = itemData
  local go = stick.gameObject or stick
  local x = go and NGUIUtil.GetUIPositionXYZ(go) or 0
  if 0 < x then
    self:ShowItemTip(self.dayRewardTipData, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
  else
    self:ShowItemTip(self.dayRewardTipData, stick, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function ActivityIntegrationStepRechargeSubView:AddEvents()
  self:AddListenEvt(ServiceEvent.ActivityCmdTieredBundleSyncActCmd, self.HandleTieredBundleUpdate)
  self:AddListenEvt(ServiceEvent.ActivityCmdTieredBundleDayRewardActCmd, self.HandleTieredBundleUpdate)
  self:AddListenEvt(ServiceEvent.ActivityCmdTieredBundleRewardActCmd, self.HandleTieredBundleUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleTieredBundleUpdate)
end

function ActivityIntegrationStepRechargeSubView:ResolveActivityId(id)
  if self.subViewData and (self.subViewData.ActivityId or self.subViewData.activityId) then
    return self.subViewData.ActivityId or self.subViewData.activityId
  end
  local newData = id and Table_ActivityNew and Table_ActivityNew[id]
  if newData and tonumber(newData.Type) == ActivityCmd_pb.GACTIVITY_ACT_TIERED_BUNDLE then
    return id
  end
  local integrationData = id and Table_ActivityIntegration and Table_ActivityIntegration[id]
  return integrationData and integrationData.Params and integrationData.Params.ActivityId or self.activityId or id
end

function ActivityIntegrationStepRechargeSubView:OnEnter(id)
  self:UnRegisterRedTips()
  self.activityId = self:ResolveActivityId(id)
  self.staticData = Table_ActivityNew and Table_ActivityNew[self.activityId]
  if not self.staticData and id and Table_ActivityIntegration then
    self.staticData = Table_ActivityIntegration[id]
  end
  local newData = id and Table_ActivityNew and Table_ActivityNew[id]
  local integrationData = id and Table_ActivityIntegration and Table_ActivityIntegration[id]
  if newData and tonumber(newData.Type) == ActivityCmd_pb.GACTIVITY_ACT_TIERED_BUNDLE then
    self.helpID = newData.HelpID
  else
    self.helpID = (not integrationData or not integrationData.HelpID) and self.staticData and self.staticData.HelpID
  end
  self:RefreshBaseInfo()
  self:RefreshView()
  TimeTickManager.Me():ClearTick(self, 1061)
  TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self, 1061)
  ActivityIntegrationStepRechargeSubView.super.OnEnter(self)
end

function ActivityIntegrationStepRechargeSubView:OnShow()
  self:RefreshView()
end

function ActivityIntegrationStepRechargeSubView:OnHide()
  self:UnRegisterRedTips()
  TimeTickManager.Me():ClearTick(self, 1061)
end

function ActivityIntegrationStepRechargeSubView:OnExit()
  self:UnRegisterRedTips()
  if self.bgTexName and self.bgTex then
    PictureManager.Instance:UnloadActivityTexture(self.bgTexName, self.bgTex)
    self.bgTexName = nil
  end
  TimeTickManager.Me():ClearTick(self, 1061)
  ActivityIntegrationStepRechargeSubView.super.OnExit(self)
end

function ActivityIntegrationStepRechargeSubView:HandleTieredBundleUpdate()
  self:RefreshView()
end

function ActivityIntegrationStepRechargeSubView:RefreshBaseInfo()
  if self.helpBtn then
    self:Preprocess_HelpColiderObj(self.helpID, self.helpBtn)
  end
  if not self.staticData then
    return
  end
  if self.titleLabel then
    self.titleLabel.text = self.staticData.TitleName or ""
  end
  if self.descLabel then
    local params = self.staticData.Params_Inte or self.staticData.Params
    local desc = params and params.Desc or self.staticData.Desc
    self.descLabel.text = desc and desc ~= "" and OverSea.LangManager.Instance():GetLangByKey(desc) or ""
    self.descLabel.gameObject:SetActive(desc ~= nil and desc ~= "")
  end
  if self.bgTex then
    local params = self.staticData.Params_Inte or self.staticData.Params
    local texName = "TieredBundle_bg"
    if texName and texName ~= "" and texName ~= self.bgTexName then
      if self.bgTexName then
        PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
      end
      self.bgTexName = texName
      PictureManager.Instance:SetUI(texName, self.bgTex)
    end
  end
end

function ActivityIntegrationStepRechargeSubView:RefreshView()
  if not self.activityId then
    self:UnRegisterRedTips()
    return
  end
  self:RefreshDayReward()
  self:RefreshStages()
  self:UpdateLeftTime()
  self:RefreshRedTips()
end

function ActivityIntegrationStepRechargeSubView:RefreshRedTips()
  if not self.gameObject or not self.gameObject.activeSelf then
    self:UnRegisterRedTips()
    return
  end
  self:RefreshDayRewardRedTip()
  self:RefreshStageReceiveRedTips()
end

function ActivityIntegrationStepRechargeSubView:RefreshDayRewardRedTip()
  if not self.getFreeBtn then
    return
  end
  RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, self.getFreeBtn)
  if self.activityId and ActivityTieredBundleProxy.Instance:CanReceiveDayReward(self.activityId) then
    RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, self.getFreeBtn, 42, nil, nil, self.activityId)
  end
end

function ActivityIntegrationStepRechargeSubView:RefreshStageReceiveRedTips()
  self:UnRegisterStageReceiveRedTips()
  if not self.activityId then
    return
  end
  if self.stageList then
    local cells = self.stageList:GetCells()
    for i = 1, #cells do
      self:RegisterStageReceiveRedTip(cells[i])
    end
    return
  end
  if self.stageCells then
    for i = 1, #self.stageCells do
      self:RegisterStageReceiveRedTip(self.stageCells[i])
    end
  end
end

function ActivityIntegrationStepRechargeSubView:RegisterStageReceiveRedTip(cell)
  if not (cell and cell.receiveBtn and cell.gameObject) or not cell.gameObject.activeSelf then
    return
  end
  local cfg = cell.staticData
  if cfg and ActivityTieredBundleProxy.Instance:CanReceive(self.activityId, cfg) then
    RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE, cell.receiveBtn, 42, nil, nil, self.activityId)
  end
end

function ActivityIntegrationStepRechargeSubView:UnRegisterStageReceiveRedTips()
  if self.stageList then
    local cells = self.stageList:GetCells()
    for i = 1, #cells do
      if cells[i].receiveBtn then
        RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE, cells[i].receiveBtn)
      end
    end
  end
  if self.stageCells then
    for i = 1, #self.stageCells do
      local cell = self.stageCells[i]
      if cell and cell.receiveBtn then
        RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE, cell.receiveBtn)
      end
    end
  end
end

function ActivityIntegrationStepRechargeSubView:UnRegisterRedTips()
  if self.getFreeBtn then
    RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_TIERED_BUNDLE_DAY_REWARD, self.getFreeBtn)
  end
  self:UnRegisterStageReceiveRedTips()
end

function ActivityIntegrationStepRechargeSubView:GetDayReward()
  local staticData = Table_ActivityNew and Table_ActivityNew[self.activityId]
  local misc = staticData and staticData.Misc
  return misc and misc.DayRewardItems
end

function ActivityIntegrationStepRechargeSubView:GetDayRewardItems()
  local reward = self:GetDayReward()
  if not reward then
    return
  end
  if reward[1] and type(reward[1]) == "table" then
    return reward
  end
  if reward[1] then
    return {reward}
  end
end

function ActivityIntegrationStepRechargeSubView:RefreshDayReward()
  local rewards = self:GetDayRewardItems()
  local hasReward = rewards and rewards[1]
  if self.freePart then
    self.freePart:SetActive(hasReward ~= nil)
  end
  if not hasReward then
    if self.dayRewardList then
      self.dayRewardList:ResetDatas(_EmptyTable)
    end
    self.dayRewardItemData = nil
    return
  end
  local canReceive = ActivityTieredBundleProxy.Instance:CanReceiveDayReward(self.activityId)
  if self.getFreeBtn then
    self.getFreeBtn:SetActive(canReceive)
  end
  if self.geted then
    self.geted:SetActive(not canReceive)
  end
  local reward = rewards[1]
  self.dayRewardItemData = nil
  if reward then
    self.dayRewardItemData = ItemData.new("Reward", reward[1])
    if self.dayRewardItemData then
      self.dayRewardItemData:SetItemNum(reward[2] or 1)
    end
  end
  if self.dayRewardList then
    local datas = {}
    for i = 1, #rewards do
      local reward = rewards[i]
      local itemData = reward and ItemData.new("Reward", reward[1])
      if itemData then
        itemData:SetItemNum(reward[2] or 1)
        datas[#datas + 1] = itemData
      end
    end
    self.dayRewardList:ResetDatas(datas)
    local cells = self.dayRewardList:GetCells()
    for i = 1, #cells do
      LuaGameObject.SetLocalScaleGO(cells[i].gameObject, 0.78, 0.78, 1)
    end
    if self.dayRewardScrollView then
      self.dayRewardScrollView:ResetPosition()
    end
  end
  if not self.dayRewardList and self.dayRewardIcon then
    local itemStatic = Table_Item[reward[1]]
    if itemStatic and itemStatic.Icon then
      IconManager:SetItemIcon(itemStatic.Icon, self.dayRewardIcon)
    end
  end
  if not self.dayRewardList and self.dayRewardLabel then
    self.dayRewardLabel.text = "x" .. tostring(reward[2] or 1)
  end
end

function ActivityIntegrationStepRechargeSubView:RefreshStages()
  local list = ActivityTieredBundleProxy.Instance:GetBundleList(self.activityId)
  if self.stageList then
    local datas = {}
    for i = 1, #list do
      datas[#datas + 1] = {
        activityId = self.activityId,
        staticData = list[i]
      }
    end
    self.stageList:ResetDatas(datas)
    if self.scrollView then
      self.scrollView:ResetPosition()
    end
    return
  end
  for i = 1, #self.stageCells do
    local cell = self.stageCells[i]
    if cell then
      local cfg = list[i]
      cell:SetData(cfg and {
        activityId = self.activityId,
        staticData = cfg
      } or nil)
    end
  end
end

function ActivityIntegrationStepRechargeSubView:UpdateLeftTime()
  if not self.timeLabel or not self.activityId then
    return
  end
  local _, endTime = ActivityTieredBundleProxy.Instance:GetGlobalActTime(self.activityId)
  if not endTime and LoopActIntegrationProxy and LoopActIntegrationProxy.Instance and self.staticData then
    _, endTime = LoopActIntegrationProxy.Instance:GetActivityTime(self.staticData)
  end
  if not endTime then
    self.timeLabel.gameObject:SetActive(false)
    return
  end
  local leftTime = endTime - ServerTime.CurServerTime() / 1000
  if leftTime <= 0 then
    self.timeLabel.gameObject:SetActive(false)
    TimeTickManager.Me():ClearTick(self, 1061)
    return
  end
  self.timeLabel.gameObject:SetActive(true)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if 0 < day then
    self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, day) .. ZhString.PlayerTip_Day
  else
    local timeText = string.format("%02d:%02d:%02d", hour, min, sec)
    self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
  end
end

function ActivityIntegrationStepRechargeSubView:OnClickDayReward()
  if not self.activityId then
    return
  end
  local batchID = ActivityTieredBundleProxy.Instance:GetBatchID(self.activityId)
  ServiceActivityCmdProxy.Instance:CallTieredBundleDayRewardActCmd(self.activityId, batchID)
end

function ActivityIntegrationStepRechargeSubView:HandleClickReceive(cell)
  local cfg = cell and cell.staticData
  if not self.activityId or not cfg then
    return
  end
  if not ActivityTieredBundleProxy.Instance:IsUnlocked(self.activityId, cfg) then
    MsgManager.FloatMsg(nil, ZhString.ActivityIntegrationStepRecharge_UnlockPreTip)
    return
  end
  local batchID = ActivityTieredBundleProxy.Instance:GetBatchID(self.activityId)
  ServiceActivityCmdProxy.Instance:CallTieredBundleRewardActCmd(self.activityId, batchID, cfg.id)
end

function ActivityIntegrationStepRechargeSubView:HandleClickBuy(cell)
  local cfg = cell and cell.staticData
  if not self.activityId or not cfg then
    return
  end
  if not ActivityTieredBundleProxy.Instance:IsUnlocked(self.activityId, cfg) then
    MsgManager.FloatMsg(nil, ZhString.ActivityIntegrationStepRecharge_UnlockPreTip)
    return
  end
  if ActivityTieredBundleProxy.Instance:IsDepositStage(cfg) then
    local info = cell:GetDepositInfo()
    if not info then
      redlog("ActivityIntegrationStepRechargeSubView no deposit info", ActivityTieredBundleProxy.Instance:GetDepositID(cfg))
      return
    end
    self:DoPurchaseDeposit(info, 1)
    return
  end
  if ActivityTieredBundleProxy.Instance:IsCostStage(cfg) then
    if not ActivityTieredBundleProxy.Instance:HasCostEnough(cfg) then
      MsgManager.ShowMsgByID(8)
      return
    end
    local itemId, itemNum = ActivityTieredBundleProxy.Instance:GetCostItem(cfg)
    MsgManager.RichConfirmMsgByID(206, function()
      self:DoPurchaseCostItem(cfg)
    end, nil, nil, nil, nil, itemId, itemId, itemNum)
    return
  end
end

function ActivityIntegrationStepRechargeSubView:DoPurchaseCostItem(cfg)
  if not self.activityId or not cfg then
    return
  end
  if not ActivityTieredBundleProxy.Instance:HasCostEnough(cfg) then
    MsgManager.ShowMsgByID(8)
    return
  end
  local batchID = ActivityTieredBundleProxy.Instance:GetBatchID(self.activityId)
  ServiceActivityCmdProxy.Instance:CallTieredBundleRewardActCmd(self.activityId, batchID, cfg.id)
end

function ActivityIntegrationStepRechargeSubView:DoPurchaseDeposit(info, count)
  self:PurchaseDeposit(info, count)
end

function ActivityIntegrationStepRechargeSubView:PurchaseDeposit(info, count)
  if ActivityPaySignView and ActivityPaySignView.PurchaseDeposit then
    return ActivityPaySignView.PurchaseDeposit(self, info, count)
  end
end
