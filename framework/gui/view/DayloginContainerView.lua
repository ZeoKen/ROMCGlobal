DayloginContainerView = class("DayloginContainerView", BaseView)
DayloginContainerView.ViewType = UIViewType.NormalLayer
autoImport("DayloginCell")
autoImport("RewardGridCell")

function DayloginContainerView.CanShow()
  local canShow = DailyLoginProxy.Instance.inited
  if canShow then
    DailyLoginProxy.Instance:TryCallSignInInfo()
    return true
  end
  return false
end

function DayloginContainerView:Init()
  local customMediatorName = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.mediatorName
  if customMediatorName and self.uiMediator then
    xdlog("DayloginContainerView 使用自定义 MediatorName:", customMediatorName)
    self.uiMediator.mediatorName = customMediatorName
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddEvts()
  self:InitData()
  self:InitShow()
end

function DayloginContainerView:FindObjs()
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.lastDayGO = self:FindGO("LastDay")
  self.lastDayCell = DayloginCell.new(self.lastDayGO)
  self.lastDayCell:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleClickReward, self)
  self.lastDayCell:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickLastDayLogin, self)
  self.modelTexture = self:FindGO("ModelTexture", self.detailPanel):GetComponent(UITexture)
  self:AddClickEvent(self.modelTexture.gameObject, function()
    xdlog("点击模型")
    self:PlayRandomAction()
  end)
  self:AddDragEvent(self.modelTexture.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  local tipGO = self:LoadPreferb("tip/DayLoginRewardTip", self.gameObject)
  self.rewardTip = DayLoginRewardTip.new(tipGO)
  self.rewardTip:HideSelf(false)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel, tipGO)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  local startDepth = upPanel.depth + 3
  for i = 1, #panels do
    panels[i].depth = panels[i].depth - minDepth + startDepth
  end
end

function DayloginContainerView:AddViewEvts()
end

function DayloginContainerView:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninInfoCmd, self.InitShow)
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninLoginAwardCmd, self.HandleLoginSuccess)
end

function DayloginContainerView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.activityid = viewdata and viewdata.id
  self.config = GameConfig.FestivalSignin and GameConfig.FestivalSignin[self.activityid]
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.clickValidTime = ServerTime.CurServerTime() / 1000
  local helpBtn = self:FindGO("HelpBtn")
  helpID = self.config.HelpID
  self:RegistShowGeneralHelpByHelpID(helpID, helpBtn)
  self.inited = false
end

function DayloginContainerView:InitShow()
  local loginInfo = DailyLoginProxy.Instance:GetDaySignInfo(self.activityid)
  if not loginInfo then
    redlog("无签到数据")
    return
  end
  self.inited = true
  self.nameLabel.text = self.config.ActivityName or "---"
  if not self.config.ShowTime or self.config.ShowTime == 1 then
    local actData = DailyLoginProxy.Instance:GetGlobalActData(self.activityid)
    if actData then
      local activityStart = actData.starttime
      local activityEnd = actData.endtime
      local startTime = os.date("%m/%d %H:%M", activityStart)
      local endTime = os.date("%m/%d %H:%M", activityEnd)
      self.timeLabel.text = string.format("%s ~ %s", startTime, endTime)
    else
      self.timeLabel.text = ""
    end
  else
    self.timeLabel.gameObject:SetActive(false)
  end
  local curLoginNum = loginInfo.signindaynum
  local awardeddays = loginInfo.awardeddays
  self.awardeddays = awardeddays
  self.curLoginNum = curLoginNum
  local mySex = MyselfProxy.Instance:GetMySex() or 1
  local signInReward = self.config and self.config.SigninReward
  local rewardList = {}
  for i = 1, 6 do
    local data = {}
    data.active = i <= curLoginNum or false
    data.received = TableUtility.ArrayFindIndex(awardeddays, i) > 0 or false
    local rewardGroup = signInReward[i]
    if mySex == 1 then
      data.rewards = rewardGroup.Item
    elseif rewardGroup.FemaleItem then
      data.rewards = rewardGroup.FemaleItem
    else
      data.rewards = rewardGroup.Item
    end
    table.insert(rewardList, data)
  end
  self.dailyLoginGridCtrl:ResetDatas(rewardList)
  local lastData = {}
  lastData.active = 7 <= curLoginNum or false
  lastData.received = 0 < TableUtility.ArrayFindIndex(awardeddays, 7) or false
  local rewardGroup = signInReward[7]
  if mySex == 1 then
    lastData.rewards = rewardGroup.Item
  elseif rewardGroup.FemaleItem then
    lastData.rewards = rewardGroup.FemaleItem
  else
    lastData.rewards = rewardGroup.Item
  end
  self.lastDayCell:SetData(lastData)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:AdjustScrollView()
  end, self, 9)
  local cells = self.dailyLoginGridCtrl:GetCells()
  if curLoginNum <= 5 then
    cells[curLoginNum]:SetFuncLabel(ZhString.PaySignRewardView_Receive)
    cells[curLoginNum + 1]:SetFuncLabel(ZhString.DayLogin_ReceiveTomorrow)
  elseif curLoginNum == 6 then
    cells[6]:SetFuncLabel(ZhString.PaySignRewardView_Receive)
    self.lastDayCell:SetFuncLabel(ZhString.DayLogin_ReceiveTomorrow)
  end
end

function DayloginContainerView:OnEnter()
  DayloginContainerView.super.OnEnter(self)
  DailyLoginProxy.Instance:TryCallSignInInfo()
end

function DayloginContainerView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  DayloginContainerView.super.OnExit(self)
end

function DayloginContainerView:Show3DModel(npcid)
  if not npcid then
    return
  end
  local sdata = Table_Npc[npcid]
  if not sdata then
    return
  end
  local otherScale = 1
  if sdata.Shape then
    otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
  else
    helplog(string.format("Npc:%s Not have Shape", sdata.id))
  end
  if sdata.Scale then
    otherScale = sdata.Scale
  end
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  if self.model and self.model:Alive() then
    local npcParts = Asset_RoleUtility.CreateNpcRoleParts(sdata.id)
    self.model:Redress(npcParts)
    Asset_Role.DestroyPartArray(npcParts)
  else
    self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modelTexture, sdata.id)
  end
  local showPos = sdata.LoadShowPose
  if showPos and #showPos == 3 then
    self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
  end
  if sdata.LoadShowRotate then
    self.model:SetEulerAngleY(sdata.LoadShowRotate)
  end
  if sdata.LoadShowSize then
    otherScale = sdata.LoadShowSize
  end
  self.model:SetScale(otherScale)
  UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
end

function DayloginContainerView:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function DayloginContainerView:PlayRandomAction()
  local actionIds = self.config.RewardPreview and self.config.RewardPreview.ActionID
  if not actionIds then
    return
  end
  if ServerTime.CurServerTime() / 1000 < self.clickValidTime then
    MsgManager.ShowMsgByID(49)
    return
  end
  local actionCount = #self.config.RewardPreview.ActionID
  local random = math.random(1, actionCount)
  local actionid = self.config.RewardPreview.ActionID[random]
  if self.model then
    local actionData = Table_ActionAnime[actionid]
    if actionData then
      self.model:PlayAction_Simple(actionData.Name)
      self.clickValidTime = self.clickValidTime + 2
    end
  end
end

function DayloginContainerView:AdjustScrollView()
  local panel = self.scrollView.panel
  local cells = self.dailyLoginGridCtrl:GetCells()
  if self.awardeddays and #self.awardeddays > 0 then
    for i = self.curLoginNum, 1, -1 do
      if TableUtility.ArrayFindIndex(self.awardeddays, i) == 0 then
        local cellCtrl = cells[i]
        if cellCtrl then
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(0, offset.y, 0)
          self.scrollView:MoveRelative(offset)
          break
        end
      end
    end
  end
end

function DayloginContainerView:HandleClickDailyLogin(cellCtrl)
  if not self.inited then
    return
  end
  if not self:CheckActivityValid() then
    MsgManager.ShowMsgByID(40973)
    self:CloseSelf()
    return
  end
  local day = cellCtrl.indexInList or 7
  xdlog("申请签到", self.activityid, day)
  ServiceActivityCmdProxy.Instance:CallDaySigninLoginAwardCmd(self.activityid, {day})
end

function DayloginContainerView:HandleClickLastDayLogin()
  if not self.inited then
    return
  end
  if not self:CheckActivityValid() then
    MsgManager.ShowMsgByID(40973)
    self:CloseSelf()
    return
  end
  local day = 7
  xdlog("申请签到", self.activityid, day)
  ServiceActivityCmdProxy.Instance:CallDaySigninLoginAwardCmd(self.activityid, {day})
end

function DayloginContainerView:HandleClickReward(cellCtrl)
  xdlog("recv HandleClickReward")
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
  end
end

function DayloginContainerView:HandleLoginSuccess(note)
  self:InitShow()
  local data = note.body
  local lastSignDay = data.days and data.days[1] or 7
  xdlog("签到日", lastSignDay)
  local mySex = MyselfProxy.Instance:GetMySex() or 1
  local loginInfo = DailyLoginProxy.Instance:GetDaySignInfo(self.activityid)
  local curLoginNum = loginInfo.signindaynum
  local awardeddays = loginInfo.awardeddays
  if 7 <= lastSignDay then
    xdlog("最后一日签到 无事")
    return
  elseif lastSignDay == curLoginNum and TableUtility.ArrayFindIndex(awardeddays, lastSignDay + 1) == 0 then
    local signInReward = self.config and self.config.SigninReward
    local rewardGroup = signInReward[lastSignDay]
    local nextRewardGroup = signInReward[lastSignDay + 1]
    local tempData = {}
    if mySex == 1 then
      tempData.rewards = rewardGroup.Item
      tempData.nextRewards = nextRewardGroup.Item
    else
      if rewardGroup.FemaleItem then
        tempData.rewards = rewardGroup.FemaleItem
      else
        tempData.rewards = rewardGroup.Item
      end
      if nextRewardGroup.FemaleItem then
        tempData.nextRewards = nextRewardGroup.FemaleItem
      else
        tempData.nextRewards = nextRewardGroup.Item
      end
    end
    tempData.nextDayTip = self.config and self.config.NextDayTip or ZhString.NoticeTitle
    tempData.nextDayConfirm = self.config and self.config.NextDayConfirm or ZhString.UniqueConfirmView_Confirm
    self.rewardTip:HideSelf(true)
    self.rewardTip:SetData(tempData)
  end
end

function DayloginContainerView:CheckActivityValid()
  local inActivity = DailyLoginProxy.Instance:GetDaySignInActivity(self.activityid)
  if not inActivity then
    redlog("活动已结束", self.activityid)
    return false
  end
  return true
end
