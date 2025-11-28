autoImport("ActivityBattlePassView")
autoImport("RecallActivityBattlePassBuyLevelCell")
autoImport("RecallActivityBattlePassBasicLevelRewardCell")
autoImport("RecallActivityBattlePassNextLevelRewardCell")
autoImport("RecallActivityBattlePassTaskCell")
RecallActivityBattlePassView = class("RecallActivityBattlePassView", ActivityBattlePassView)

function RecallActivityBattlePassView:Init()
  self:InitData()
  self:CheckIsBasic()
  self:LoadPrefab(Prefab_Path)
  self:FindObjs()
  self:AddEvts()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function RecallActivityBattlePassView:InitData()
  self.curIndex = RecallActivityBattlePassProxy.Instance:GetCurIndex()
  self.curConfigIndex = RecallActivityBattlePassProxy.Instance:GetCurConfigIndex()
  self.isTaskState = false
end

function RecallActivityBattlePassView:CheckIsBasic()
  self.isBasic = false
  local levelConfig = self:GetLevelConfig(1)
  if levelConfig then
    self.isBasic = not levelConfig.AdvanceReward or levelConfig.AdvanceReward == _EmptyTable
  end
end

function RecallActivityBattlePassView:FindObjs()
  local helpBtn = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(500004, helpBtn)
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
  local gameConfig = GameConfig.RecallActivityBattlePass[self.curConfigIndex]
  if gameConfig then
    local depositID = gameConfig.DepositId
    local depositConfig = Table_Deposit[depositID]
    if depositConfig then
      self.costLabel.text = depositConfig.priceStr or depositConfig.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(depositConfig.Rmb)
    end
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
  local className = self.isBasic and RecallActivityBattlePassBasicLevelRewardCell or RecallActivityBattlePassLevelRewardCell
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
  local nextLevelCellClass = self.isBasic and RecallActivityBattlePassBasicLevelRewardCell or RecallActivityBattlePassNextLevelRewardCell
  local go = self:LoadCellPfb(nextLevelCellName, self.levelRewardHolder)
  self.nextLevelRewardCell = nextLevelCellClass.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self.taskPanel = self:FindGO("task")
  self.taskScrollView = self:FindGO("LevelTaskScrollview")
  local taskGrid = self:FindComponent("LevelTaskGrid", UIGrid)
  self.taskListCtrl = UIGridListCtrl.new(taskGrid, RecallActivityBattlePassTaskCell, "RecallActivityBattlePassTaskCell")
  self.taskListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleGotoBtnClick, self)
  self.levelRewardBg = self:FindComponent("BG", UIMultiSprite)
  self.levelRewardBg.CurrentState = self.isBasic and 1 or 0
  self.activityIndexLabel = self:FindComponent("ActivityIndex", UILabel)
end

function RecallActivityBattlePassView:AddEvts()
  self:AddListenEvt(ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd, self.RefreshPanel)
end

function RecallActivityBattlePassView:OnEnter()
  ActivityBattlePassView.super.OnEnter(self)
  self:RefreshPanel()
end

function RecallActivityBattlePassView:SetExpPanel()
  RecallActivityBattlePassView.super.SetExpPanel(self)
  local activityIndex = RecallActivityBattlePassProxy.Instance:GetCurIndex()
  local totalCount = RecallInfoProxy.Instance:GetTotalBatchCount()
  self.activityIndexLabel.text = string.format(ZhString.RecallIntegration_BatchNumber, activityIndex, totalCount)
end

function RecallActivityBattlePassView:SetTaskTitle()
  local gameConfig = GameConfig.RecallActivityBattlePass[self.curConfigIndex]
  if gameConfig then
    self.titleLabel.text = self.isTaskState and gameConfig.TaskTitle or gameConfig.Title
  end
end

function RecallActivityBattlePassView:SetTaskPanel()
  local tasks = RecallActivityBattlePassProxy.Instance:GetTaskList()
  self.taskListCtrl:ResetDatas(tasks)
end

function RecallActivityBattlePassView:OnUpgradeBtnClick()
  local config = GameConfig.RecallActivityBattlePass[self.curConfigIndex]
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

function RecallActivityBattlePassView:OnReceiveAllBtnClick()
  self:CallBPTargetRewardCmd()
end

function RecallActivityBattlePassView:OnBuyLevelBtnClick()
  if self:GetCurBPLevel() >= self:GetMaxBPLevel() then
    MsgManager.FloatMsg("", ZhString.RecallActivityBattlePass_ReachMax)
    return
  end
  if not self.buylevelCell then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityBattlePassBuyLevelCell"))
    go.transform:SetParent(self.gameObject.transform, false)
    self.buylevelCell = RecallActivityBattlePassBuyLevelCell.new(go)
  end
  self.buylevelCell.gameObject:SetActive(true)
  self.buylevelCell:SetData()
end

function RecallActivityBattlePassView:HandleGotoBtnClick(cellCtrl)
  local staticData = Table_UserRecall_BattlePassTask[cellCtrl.data.id]
  if staticData then
    local go = staticData.Goto
    if go and 0 < #go then
      if 1 < #go then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ShortCutOptionPopUp,
          viewdata = {
            data = go,
            gotomode = go,
            functiontype = 1,
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
  end
end

function RecallActivityBattlePassView:CallBPTargetRewardCmd()
  ServiceRecallCCmdProxy.Instance:CallGetAllBattlePassRewardRecallCmd()
end

function RecallActivityBattlePassView:GetLevelConfig(level)
  return RecallActivityBattlePassProxy.Instance:LevelConfig(self.curConfigIndex, level)
end

function RecallActivityBattlePassView:GetCurBPLevel()
  return RecallActivityBattlePassProxy.Instance:GetCurBPLevel()
end

function RecallActivityBattlePassView:GetMaxBPLevel()
  return RecallActivityBattlePassProxy.Instance:GetMaxBPLevel()
end

function RecallActivityBattlePassView:GetCurExp()
  return RecallActivityBattlePassProxy.Instance:GetCurExp()
end

function RecallActivityBattlePassView:GetEndTime()
  return RecallActivityBattlePassProxy.Instance:GetEndTime()
end

function RecallActivityBattlePassView:GetIsPro()
  return RecallActivityBattlePassProxy.Instance:GetIsPro()
end

function RecallActivityBattlePassView:GetIsHaveAvailableReward()
  return RecallActivityBattlePassProxy.Instance:IsHaveAvailableReward()
end

function RecallActivityBattlePassView:GetNextImportantLv(maxShowLv)
  return RecallActivityBattlePassProxy.Instance:GetNextImportantLv(maxShowLv)
end
