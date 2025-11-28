RoadOfHeroView = class("RoadOfHeroView", ContainerView)
RoadOfHeroView.ViewType = UIViewType.NormalLayer
RoadOfHeroView.BrotherView = RaidEntranceCombineView
autoImport("RoadOfHeroTargetCell")
autoImport("PveDropItemCell")
autoImport("RaidDifficultyCell")
local _PveConfig = GameConfig.Pve
local _ChallengeRedColor = Color(0.8941176470588236, 0.34901960784313724, 0.23921568627450981, 1)
local _NewBlackColor = Color(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
local _sweepBtn = {
  sp = {"com_btn_1", "com_btn_13"},
  lab = {
    Color(0.06274509803921569, 0.16470588235294117, 0.5490196078431373, 1),
    Color(0.36470588235294116, 0.3568627450980392, 0.3568627450980392, 1)
  }
}
local BattleTimeStringColor = {
  [1] = "[555b6e]%d[-]",
  [2] = "[E4593D]%d[-]"
}
local _LeftRewardZhString = {
  [PveRaidType.GuildRaid] = ZhString.PveView_LeftTime_Boss,
  [PveRaidType.DeadBoss] = ZhString.PveView_LeftTime_DeadBoss
}

function RoadOfHeroView:Init()
  _EntranceProxy = PveEntranceProxy.Instance
  _RedTipProxy = RedTipProxy.Instance
  _PictureManager = PictureManager.Instance
  _BattleTimeData = BattleTimeDataProxy.Instance
  self.root = self:FindGO("Root")
  self.root:SetActive(false)
  self.loadingRoot = self:FindGO("LoadingRoot")
  self.loadingRoot:SetActive(true)
  self.isCombine = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.mainBg = self:FindGO("Bg")
  self.closeBtn = self:FindGO("CloseButton")
  self.closeBtn:SetActive(not self.isCombine)
  self.mainBg.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and -39 or -4, -13)
  self.root.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and -35 or 0)
  self:AddEvt()
  self:InitBuyItemCell()
  self:_Init()
end

function RoadOfHeroView:_Init()
  self:FindObj()
  self:AddUIEvts()
end

function RoadOfHeroView:FindObj()
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.raidHelpBtn = self:FindGO("RaidHelpTip", self.nameLab.gameObject)
  local rootBg = self:FindGO("RootBg", self.root)
  self.matchBtn = self:FindGO("MatchBtn")
  self.matchBtnSp = self.matchBtn:GetComponent(UISprite)
  self.matchBtnLab = self:FindComponent("Label", UILabel, self.matchBtn)
  self.matchBtnLab.text = ZhString.Pve_Match
  self.challengeBtn = self:FindGO("ChallengeBtn")
  self.challengeBtnSp = self.challengeBtn:GetComponent(UISprite)
  self:AddOrRemoveGuideId(self.challengeBtn, 489)
  self:AddOrRemoveGuideId(self.challengeBtn, 493)
  self.challengeBtnLab = self:FindComponent("Label", UILabel, self.challengeBtn)
  self.challengeBtnLab.text = ZhString.Pve_Challenge
  self.shopBtn = self:FindGO("ShopBtn")
  self.shopBtnLab = self:FindComponent("Label", UILabel, self.shopBtn)
  self.shopBtnLab.text = ZhString.Pve_Shop
  self.challengeCostLabel = self:FindComponent("ChallengeCost", UILabel)
  self.challengeNumLab = self:FindComponent("ChallengeNum", UILabel)
  self.addMaxCount = self:FindGO("AddMaxCount")
  self.raidTypeSv = self:FindComponent("PveScrollView", UIScrollView, self.root)
  self.raidTypeTable = self:FindComponent("RaidTypeTable", UITable)
  self.pveWraplist = UIGridListCtrl.new(self.raidTypeTable, PveTypeCell, "PveTypeCell")
  self.pveWraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickRaidTypeCell, self)
  self.infoScrollView = self:FindComponent("InfoScrollView", UIScrollView)
  self.infoTable = self:FindComponent("InfoTable", UITable)
  self.unlockTipLabel = self:FindGO("UnlockTipLabel"):GetComponent(UILabel)
  self.unlockTipGrid = self:FindGO("Grid", self.unlockTipLabel.gameObject):GetComponent(UIGrid)
  self.unlockTipCtrl = UIGridListCtrl.new(self.unlockTipGrid, RoadOfHeroTargetCell, "RoadOfHeroTargetCell")
  self.challengeTipLabel = self:FindGO("Challenge", self.infoTable.gameObject):GetComponent(UILabel)
  self.challengeGrid = self:FindGO("Grid", self.challengeTipLabel.gameObject):GetComponent(UIGrid)
  self.challengeCtrl = UIGridListCtrl.new(self.challengeGrid, RoadOfHeroTargetCell, "RoadOfHeroTargetCell")
  self.rewardTipLabel = self:FindGO("Reward", self.infoTable.gameObject):GetComponent(UILabel)
  self.rewardGrid = self:FindGO("RewardGrid", self.rewardTipLabel.gameObject):GetComponent(UIGrid)
  self.rewardHelpBtn = self:FindGO("RewardHelpBtn", self.rewardTipLabel.gameObject)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  self.difficultyPanel = self:FindComponent("DiffScrollView", UIPanel, self.root)
  self.difficultyGrid = self:FindComponent("DifficultyGrid", UIGrid, self.difficultyPanel.gameObject)
  self.difficultyCtl = UIGridListCtrl.new(self.difficultyGrid, RaidDifficultyCell, "RaidDifficultyCell")
  self.difficultyCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDifficulty, self)
  self.sweepBtn = self:FindGO("SweepBtn")
  self.initialSweepXAxis = self.sweepBtn.transform.localPosition.x
  self:AddClickEvent(self.sweepBtn, function()
    if self.call_lock then
      MsgManager.ShowMsgByID(49)
      return
    end
    if not self:CheckSweepValid() then
      return
    end
    self:LockCall()
    self:ConfirmOption(function()
      self:DoSweep()
    end)
  end)
  self.sweepSp = self.sweepBtn:GetComponent(UISprite)
  self.sweepBtnLab = self:FindComponent("Label", UILabel, self.sweepBtn)
end

function RoadOfHeroView:AddUIEvts()
  self:AddClickEvent(self.shopBtn, function()
    self:OnClickShopBtn()
  end)
  self:AddClickEvent(self.challengeBtn, function()
    if not self.curIsOpen then
      self:ShowUnlockMsg()
      return
    end
    local guideParam = FunctionGuide.Me():tryTakeCustomGuideParam(nil, "fake_crackraid")
    if guideParam then
      self:CloseSelf()
      return
    end
    if not (self.curData and self.curData.staticEntranceData:IsHeadWear()) or not _BattleTimeData:CheckBattleTimelen(true) then
    end
    self:ConfirmOption(function()
      if FunctionPve.Me():DoChallenge() then
        self:CloseSelf()
      end
    end)
  end)
end

function RoadOfHeroView:AddEvt()
  self:AddListenEvt(PVEEvent.SyncPvePassInfo, self.UpdateServerInfoData)
end

function RoadOfHeroView:CloseSelf()
  GameFacade.Instance:sendNotification(UICloseEvent.CloseSubView)
  RoadOfHeroView.super.CloseSelf(self)
end

function RoadOfHeroView:InitBuyItemCell()
  self.happyShopPanel = self:FindGO("HappyShopPanel")
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"), self.happyShopPanel)
  if not go then
    return
  end
  go.transform.localPosition = LuaGeometry.GetTempVector3(185, 40, 0)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:Hide()
  local shopCfg = _PveConfig.AddPlayTimeDepositeId
  if shopCfg then
    local sType, sId = next(shopCfg)
    if sType and sId and type(sId) == "table" then
      HappyShopProxy.Instance:InitShop(Game.Myself, sId[1], sType)
    end
  end
end

function RoadOfHeroView:OnDifficultyChange(diff_mode)
  if self.curDifficultyMode == diff_mode then
    return
  end
  local isBoss = self.curData.staticEntranceData:IsBoss()
  local bossDiffs
  if isBoss then
    bossDiffs = self.curData:GetServerBoss(diff_mode)
    if #bossDiffs == 0 then
      MsgManager.ShowMsgByID(43290)
      return
    end
  end
  self.curDifficultyMode = diff_mode
  self:_updateGroupTog()
  if isBoss then
    self:ReInitBossDiffRaid(bossDiffs)
    self.monsterIndex = 1
    self:UpdateRewardMonster()
  else
    self:InitDifficultyRaid()
  end
end

function RoadOfHeroView:InitDifficultyRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, self.curDifficultyMode)
  self.difficultyCtl:ResetDatas(diffs)
  if not self:ChooseBestFit(diffs) then
    self:UpdateViewData(diffs[1])
  end
  self:ChooseDiff(self.curData.staticEntranceData.staticDifficulty)
end

function RoadOfHeroView:OnClickRaidTypeCell(cell, auto)
  local pveData = cell.data
  if not pveData then
    return
  end
  local entranceData = pveData.staticEntranceData
  local isGridType = entranceData:IsCrack() or entranceData:IsBoss()
  local clickSameTypeCell = self.curData and self.curData.staticEntranceData.groupid == entranceData.groupid
  local clickDiffRaid = self.curData and self.curData.staticEntranceData.raidType ~= entranceData.raidType
  if clickSameTypeCell or clickDiffRaid then
    if isGridType then
      if clickDiffRaid and self.gridTypeCell then
        self:ReverseCrack(true)
      end
      self.gridTypeCell = cell
      if not auto then
        self:ReverseCrack()
      end
    end
    if not clickDiffRaid then
      return
    end
  end
  local isNew = _RedTipProxy:IsNew(ERedSys, entranceData.groupid)
  if isNew then
    _RedTipProxy:RegisterUI(ERedSys, self.checkBtn, 8, {-6, -2})
  else
    _RedTipProxy:UnRegisterUI(ERedSys, self.checkBtn)
  end
  if isGridType then
    self.gridTypeCell = cell
  end
  self:UpdateViewData(pveData)
  self:SetChooseRaidType(entranceData.id)
  self.curDifficultyMode = nil
  self:InitDiffRaid()
end

function RoadOfHeroView:InitDiffRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, self.curDifficultyMode)
  self.difficultyCtl:ResetDatas(diffs)
  self:ChooseBestFit(diffs)
  self:ChooseDiff(self.curData.staticEntranceData.staticDifficulty)
end

function RoadOfHeroView:ChooseBestFit(diffs)
  self.difficultyCtl:ResetPosition()
  local diffCells = self.difficultyCtl:GetCells()
  for i = #diffs, 1, -1 do
    if self.initialEntranceData and self.initialEntranceData.id == diffs[i].id or type(diffs[i]) == "table" and diffs[i]:CheckPass() and diffs[i].open then
      if 4 < i then
        local diffScrollView = self.difficultyCtl.scrollView
        local panel = diffScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, diffCells[i].gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(offset.x, 0, 0)
        diffScrollView:MoveRelative(offset)
      end
      self:UpdateViewData(diffs[i])
      return true
    end
  end
  return false
end

function RoadOfHeroView:UpdateViewData(data)
  if self.curData and data and self.curData.id == data.id then
    return
  end
  self.curData = data
  TipsView.Me():TryShowGeneralHelpByHelpId(self.curData.staticEntranceData.staticData.HelpID, self.raidHelpBtn)
  self.curIsOpen = _EntranceProxy:IsOpen(data.id)
  xdlog("副本是否开启", self.curIsOpen)
  local isBoss = data.staticEntranceData:IsBoss()
  if not isBoss then
    self.curBossId = nil
    self.initialBossDifficulty = nil
    self.costTime = data.staticEntranceData.staticData.TimeCost
    FunctionPve.Me():SetServerBossid(nil)
  end
  FunctionPve.Me():SetCurPve(data.staticEntranceData)
  self.nameLab.text = data.staticEntranceData.name
  self:UpdateOptionBtn()
  self:UpdateContentLabel()
  self:UpdateUnlockTips()
  self:UpdateStarChallenge()
  self:UpdateRewards()
  self.infoTable:Reposition()
  self.infoScrollView:ResetPosition()
end

function RoadOfHeroView:UpdateOptionBtn()
  local id = self.curData and self.curData.id
  if not id then
    return
  end
  local open = self.curIsOpen
  if not open then
    self:ShowUnlockMsg()
  end
  local hasShop = self.curData.staticEntranceData:HasShopConfig()
  if hasShop then
    local _shopid = self.curData.staticEntranceData.shopid
    local _shoptype = self.curData.staticEntranceData.shoptype
    if _shopid ~= nil and _shoptype ~= nil and (_shopid ~= self.shopid or _shoptype ~= self.shoptype) then
      xdlog("请求商店", _shopid, _shoptype)
      ShopProxy.Instance:CallQueryShopConfig(_shoptype, _shopid)
    end
    self.shopid = self.curData.staticEntranceData.shopid
    self.shoptype = self.curData.staticEntranceData.shoptype
  else
    self.shopid = nil
    self.shoptype = nil
  end
  self.shopBtn:SetActive(hasShop)
  local goalid = self.curData.staticEntranceData.staticData.Goal or 0
  self:_UpdateSweep(open)
  self:_UpdateChallenge(open)
end

function RoadOfHeroView:UpdateContentLabel()
  if self.curData then
    self.challengeCostLabel.text = ""
    self.challengeNumLab.text = ""
    self:SetContentLabel(self.curData.staticEntranceData.staticData.RecommendPlayerNum, self.curData.staticEntranceData.staticData.PlayerNumCount, self.challengeCostLabel)
    self:SetContentLabel(self.curData.staticEntranceData.staticData.ChallengeContent, self.curData.staticEntranceData.staticData.ChallengeCount, self.challengeNumLab)
  end
end

function RoadOfHeroView:SetContentLabel(contentFormat, contentParam, contentLabel)
  if not contentFormat then
    return
  end
  contentLabel.color = _NewBlackColor
  if contentFormat == 1 then
    self.addMaxCount.gameObject:SetActive(false)
    contentLabel.text = string.format(ZhString.Pve_RecommendPlayerNum, contentParam)
  elseif contentFormat == 2 then
    local max_challengeCount = self.curData:GetMaxChallengeCnt()
    local server_challengeCount = self.curData:GetPassTime()
    local leftTime = self.curData:GetLeftRewardTime()
    local raidType = self.curData.staticEntranceData.raidType
    local _leftRewardStr = _LeftRewardZhString[raidType] or ZhString.PveView_LeftTime_Common
    contentLabel.text = string.format(_leftRewardStr, leftTime, max_challengeCount)
    if leftTime <= 0 then
      contentLabel.color = _ChallengeRedColor
    end
  elseif contentFormat == 3 then
    if not self.costTime then
      return
    end
    self.addMaxCount.gameObject:SetActive(self.curIsOpen == true and nil ~= _AddPlayTimeItmeID)
    self.sufficientTime = 2
    local timeType
    if ISNoviceServerType then
      timeType = BattleTimeDataProxy.ETime.PLAY
      local battleTime = _BattleTimeData:GetLeftTime(timeType)
      if battleTime >= self.costTime then
        self.sufficientTime = 1
      end
    else
      timeType = _BattleTimeData:GetGameTimeSetting()
      local battleTime = _BattleTimeData:GetLeftTime(timeType)
      if battleTime >= self.costTime then
        self.sufficientTime = 1
      else
        local repTimeType = BattleTimeDataProxy.ReverseType[timeType]
        local repBattleTime = _BattleTimeData:GetLeftTime(repTimeType)
        if repBattleTime >= self.costTime then
          self.sufficientTime = 1
          timeType = repTimeType
        end
      end
    end
    self.timeType = timeType
    local str = timeType == BattleTimeDataProxy.ETime.PLAY and ZhString.PveView_CostPlayTime or ZhString.PveEntranceContent_3
    if self.curData and self.curData:IsFree() then
      contentLabel.text = string.format(str, ZhString.PveView_FreeTime)
    else
      contentLabel.text = string.format(str, string.format(BattleTimeStringColor[self.sufficientTime], self.costTime // 60))
    end
    ColorUtil.WhiteUIWidget(contentLabel)
    self:SetDifferenceTime()
    if self:HasDifferenceTime() then
      self.sufficientTime = 1
    end
  elseif contentFormat == 4 then
    local max_challengeCount = contentParam
    local server_challengeCount = ISNoviceServerType and PveEntranceProxy.Instance:GetCrackPassTime() or self.curData:GetPassTime()
    local str = ISNoviceServerType and ZhString.PveEntranceContent_4_Novice or ZhString.PveEntranceContent_4
    local num = math.max(max_challengeCount - server_challengeCount, 0)
    contentLabel.text = string.format(str, num, max_challengeCount)
    if max_challengeCount <= server_challengeCount then
      contentLabel.color = _ChallengeRedColor
    end
  end
end

function RoadOfHeroView:SetDifferenceTime()
  self.differenceCostTime = nil
  if self.costTime and not ISNoviceServerType then
    local time = _BattleTimeData:GetLeftTime()
    if 0 < time and time < self.costTime then
      local timeType = _BattleTimeData:GetGameTimeSetting()
      local reverseTime = _BattleTimeData:GetLeftTime(BattleTimeDataProxy.ReverseType[timeType])
      if reverseTime + time >= self.costTime then
        self.differenceCostTime = (self.costTime - time) // 60
      end
    end
  end
end

function RoadOfHeroView:HasDifferenceTime()
  return nil ~= self.differenceCostTime
end

function RoadOfHeroView:UpdateUnlockTips()
  local open = self.curIsOpen
  if open then
    self.unlockTipLabel.gameObject:SetActive(false)
    return
  end
  local openCond = self.curData.staticEntranceData.staticData.OpenCond
  if not openCond then
    redlog("无解锁条件")
    return
  end
  local result = {}
  local unlockType = openCond.type
  if unlockType == "level" then
    local level = openCond.param and openCond.param.level or 999
    local unlockStr = string.format("玩家Base等级达到 %s", level)
    local myLv = MyselfProxy.Instance:RoleLevel()
    local unlock = level <= myLv
    result[#result + 1] = {unlock = unlock, desc = unlockStr}
  elseif unlockType == "pass_raid" then
    local unlockStr = "完成上一个难度"
    result[#result + 1] = {unlock = false, desc = unlockStr}
  end
  self.unlockTipCtrl:ResetDatas(result)
end

function RoadOfHeroView:UpdateStarChallenge()
  self.challengeTipLabel.gameObject:SetActive(false)
end

function RoadOfHeroView:UpdateRewards()
  if not self.curData then
    self.rewardTipLabel.gameObject:SetActive(false)
    return
  end
  self.rewardTipLabel.gameObject:SetActive(true)
  local result = self.curData:TryGetExtraRewards() or {}
  local dropItems = self.curData:GetAllRewards()
  TableUtil.InsertArray(result, dropItems)
  local emptyNum = 15 - #result
  if 0 < emptyNum then
    for i = 1, emptyNum do
      result[#result + 1] = PveDropItemCell.Empty
    end
  end
  self.rewardCtrl:ResetDatas(result)
  local buffID = ReturnActivityProxy.Instance:GetReturnBufferID()
  if buffID and Game.Myself.data:HasBuffID(buffID) then
    local buffConfig = Table_Buffer[buffID]
    local buffEffect = buffConfig and buffConfig.BuffEffect
    local baseMuliply, jobMultiply = buffEffect.BaseExpPer, buffEffect.JobExpPer
    local cells = self.rewardCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data.staticData then
        if cells[i].data.staticData.id == 300 then
          cells[i]:SetReturnExtra(1 + baseMuliply)
        elseif cells[i].data.staticData.id == 400 then
          cells[i]:SetReturnExtra(1 + jobMultiply)
        end
      end
    end
  end
  self.rewardCtrl:ResetPosition()
end

function RoadOfHeroView:ShowUnlockMsg()
  if not self.curData then
    return
  end
  local unlockMsg = self.curData.staticEntranceData.unlockMsgId
  if unlockMsg and unlockMsg ~= 0 then
    MsgManager.ShowMsgByID(unlockMsg)
  else
    redlog("策划未配置 unlockMsgId.  PveRaidEntrance表ID ： ", id)
  end
end

function RoadOfHeroView:_UpdateChallenge(open)
  self.challengeBtnSp.spriteName = open and "com_btn_2" or "com_btn_13"
  self.challengeBtnLab.effectColor = open and ColorUtil.ButtonLabelOrange or Color(0.36470588235294116, 0.3568627450980392, 0.3568627450980392, 1)
end

function RoadOfHeroView:_UpdateSweep(open)
  if not self.curData.staticEntranceData.staticData.ShowSweep or self.curData.staticEntranceData.staticData.ShowSweep == 0 then
    self.sweepBtn:SetActive(false)
  else
    self.sweepBtn:SetActive(true)
    if open then
      local x, y, z = LuaGameObject.GetLocalPositionGO(self.sweepBtn)
      x = self.curData.staticEntranceData:IsHeadWear() and self.initialPublishXAxis or self.initialSweepXAxis
      LuaGameObject.SetLocalPositionGO(self.sweepBtn, x, y, z)
    end
    if self:CanQuick() then
      ColorUtil.WhiteUIWidget(self.sweepSp)
      self.sweepSp.spriteName = _sweepBtn.sp[1]
      self.sweepBtnLab.effectColor = _sweepBtn.lab[1]
    else
      self.sweepSp.spriteName = _sweepBtn.sp[2]
      self.sweepBtnLab.effectColor = _sweepBtn.lab[2]
    end
  end
end

function RoadOfHeroView:CanQuick()
  if not self.curData then
    return
  end
  if self.curBossId and self.curBossId > 0 then
    return PveEntranceProxy.Instance:CheckBossCanQuick(self.curBossId)
  end
  return self.curData:GetQuick()
end

function RoadOfHeroView:SetChooseRaidType(id)
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end

function RoadOfHeroView:ChooseDiff(id)
  local cells = self.difficultyCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end

function RoadOfHeroView:CheckSweepValid()
  if not self.curData then
    return false
  end
  local entranceData = self.curData.staticEntranceData
  local type = entranceData.raidType
  if not self:CanQuick() then
    local msg = GameConfig.Pve and GameConfig.Pve.SweepInvalidMsg and GameConfig.Pve.SweepInvalidMsg[type] or 43114
    MsgManager.ShowMsgByID(msg)
    return false
  end
  if self.sufficientTime ~= 1 and not self.curData:IsFree() then
    MsgManager.ShowMsgByID(43115)
    return false
  end
  return true
end

function RoadOfHeroView:DoSweep()
  if not self.curData then
    return
  end
  local entranceData = self.curData.staticEntranceData
  local type = entranceData.raidType
  local raidid = entranceData.difficultyRaid
  local groupid = entranceData.groupid
  local func = self.sweepFunc[type] or self._DoSweep_Default
  if func then
    func(self, raidid, groupid)
  end
end

function RoadOfHeroView:OnClickShopBtn()
  if not self.curData then
    return
  end
  if not self.curData.staticEntranceData:HasShopConfig() then
    return
  end
  local shop_id, shop_type = self.curData.staticEntranceData.shopid, self.curData.staticEntranceData.shoptype
  HappyShopProxy.Instance:InitShop(nil, shop_id, shop_type)
  local groupId = self.curData.staticEntranceData.groupid
  local endCall = function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView,
      viewdata = {initialGroupId = groupId}
    })
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {onExit = endCall})
end

function RoadOfHeroView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:CancelLockCall()
    end, self)
  end
end

function RoadOfHeroView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function RoadOfHeroView:ConfirmOption(handler)
  if self:CheckCoinIsFull() then
    MsgManager.ConfirmMsgByID(43512, handler)
    return
  end
  if self:HasDifferenceTime() then
    local timeType = _BattleTimeData:GetGameTimeSetting()
    local id = timeType == BattleTimeDataProxy.ETime.PLAY and 43242 or 43243
    MsgManager.ConfirmMsgByID(id, handler, nil, nil, self.differenceCostTime)
    return
  end
  handler()
end

function RoadOfHeroView:CheckCoinIsFull()
  if self.shopid and self.shoptype then
    local costList = HappyShopProxy.Instance:GetTotalCost(self.shoptype, self.shopid)
    for _moneyid, _cost in pairs(costList) do
      if 0 < _cost then
        local _ownCount = HappyShopProxy.Instance:GetItemNum(_moneyid)
        if _moneyid < _ownCount then
          return true
        end
      end
    end
  end
  return false
end

function RoadOfHeroView:UpdateRedTips()
  local cells = self.pveWraplist and self.pveWraplist:GetCells()
  if cells then
    for _, cell in ipairs(cells) do
      cell:UpdateRedtip()
    end
  end
end

function RoadOfHeroView:OnClickDifficulty(cell)
  local data = cell.data
  if not data then
    return
  end
  if data == PveEntranceProxy.EmptyDiff then
    return
  end
  if self.curData and self.curData.id == data.id then
    return
  end
  self:UpdateViewData(data)
  self:ChooseDiff(data.staticEntranceData.staticDifficulty)
end

function RoadOfHeroView:OnClickRewardItem(cellctl)
  local data = cellctl.data
  if data == PveDropItemCell.Empty then
    return
  end
  if cellctl and cellctl ~= self.chooseReward then
    local stick = cellctl.icon
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function RoadOfHeroView:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function RoadOfHeroView:UpdateServerInfoData()
  self:InitShow()
end

function RoadOfHeroView:InitData()
end

function RoadOfHeroView:InitShow()
  self.loadingRoot:SetActive(false)
  self.root:SetActive(true)
  local _raidCatalogMap = _EntranceProxy:GetAllRoadOfHeroData()
  local result = {}
  self.pveWraplist:ResetDatas(_raidCatalogMap)
  local cells = self.pveWraplist:GetCells()
  self:OnClickRaidTypeCell(cells[1], true)
end

function RoadOfHeroView:OnEnter()
  FunctionPve.DoQuery()
  PveView.super.OnEnter(self)
end

function RoadOfHeroView:OnExit()
  RoadOfHeroView.super.OnExit(self)
  FunctionPve.Me():ClearClientData()
  TimeTickManager.Me():ClearTick(self)
  if self.pveWraplist then
    self.pveWraplist:Destroy()
  end
end
