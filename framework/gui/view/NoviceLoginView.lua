NoviceLoginView = class("NoviceLoginView", SubView)
local viewPath = ResourcePathHelper.UIView("NoviceLoginView")
autoImport("NoviceDayLoginCell")
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  Decorate5 = "returnactivity_bg_decorate_05"
}

function NoviceLoginView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function NoviceLoginView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "NoviceLoginView"
end

function NoviceLoginView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("NoviceLoginView")
  self.loginCountLabel = self:FindGO("LoginCountLabel"):GetComponent(UILabel)
  self.dateLabel = self:FindGO("DateLabel"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView", self.gameObject):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.lastDayGO = self:FindGO("LastDay")
  self.lastDayCell = NoviceDayLoginCell.new(self.lastDayGO)
  self.lastDayCell:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleClickReward, self)
  self.lastDayCell:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickLastDayLogin, self)
  self.modelTexture = self:FindGO("ModelTexture"):GetComponent(UITexture)
  self:AddClickEvent(self.modelTexture.gameObject, function()
    xdlog("点击模型")
    self:PlayRandomAction()
  end)
  self:AddDragEvent(self.modelTexture.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self.dailyLoginGridCtrl = UIGridListCtrl.new(self.grid, NoviceDayLoginCell, "NoviceDayLoginCell")
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickDailyLogin, self)
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleClickReward, self)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  self.innerTexture = self:FindGO("InnerTexture", self.gameObject):GetComponent(UITexture)
end

function NoviceLoginView:AddViewEvts()
end

function NoviceLoginView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninInfoCmd, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninLoginAwardCmd, self.RefreshPage)
end

function NoviceLoginView:InitDatas()
  local _, activityid = DailyLoginProxy.Instance:isNoviceLoginOpen()
  self.activityid = activityid
  self.config = GameConfig.FestivalSignin and GameConfig.FestivalSignin[self.activityid]
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.clickValidTime = ServerTime.CurServerTime() / 1000
end

local monthStrEN = {
  [1] = "JAN",
  [2] = "FEB",
  [3] = "MAR",
  [4] = "APR",
  [5] = "MAY",
  [6] = "JUN",
  [7] = "JUL",
  [8] = "AUG",
  [9] = "SEPT",
  [10] = "OCT",
  [11] = "NOV",
  [12] = "DEC"
}

function NoviceLoginView:RefreshPage()
  local loginInfo = DailyLoginProxy.Instance:GetDaySignInfo(self.activityid)
  if not loginInfo then
    redlog("无签到数据")
    return
  end
  local curTime = ServerTime.CurServerTime() / 1000
  local curDate = os.date("*t", curTime)
  self.dateLabel.text = monthStrEN[curDate.month] .. "." .. curDate.year
  local entranceInfo = DailyLoginProxy.Instance:GetDaySignInActivity(self.activityid)
  if entranceInfo then
    local endTime = entranceInfo.endtime
    if not endTime or endTime == 0 then
      local actData = DailyLoginProxy.Instance:GetGlobalActData(self.activityid)
      endTime = actData and actData.endtime
    end
    self.container:TimeLeftCountDown(endTime)
  end
  local curLoginNum = loginInfo.signindaynum
  local awardeddays = loginInfo.awardeddays
  self.awardeddays = awardeddays
  self.curLoginNum = curLoginNum
  self.loginCountLabel.text = "0" .. curLoginNum
  local mySex = MyselfProxy.Instance:GetMySex() or 1
  local signInReward = self.config and self.config.SigninReward
  local rewardList = {}
  for i = 1, 6 do
    local data = {}
    data.active = i <= curLoginNum or false
    data.nextDay = i == curLoginNum + 1 or false
    data.received = 0 < TableUtility.ArrayFindIndex(awardeddays, i) or false
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
  lastData.nextDay = 7 == curLoginNum + 1 or false
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
  else
    self.lastDayCell:SetFuncLabel(ZhString.PaySignRewardView_Receive)
  end
  self:ShowRewardPreview()
end

function NoviceLoginView:ShowRewardPreview()
  local rewardPreview = self.config.RewardPreview
  if not rewardPreview then
    redlog("新手签到未配置展示NPC")
    self:Show3DModel(1050)
    return
  end
  local targetNpcid = rewardPreview and rewardPreview.NpcID
  if targetNpcid then
    self:Show3DModel(targetNpcid)
  end
end

function NoviceLoginView:Show3DModel(npcid)
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
end

function NoviceLoginView:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function NoviceLoginView:PlayRandomAction()
  local actionIds = self.config.RewardPreview and self.config.RewardPreview.ActionID
  if not actionIds then
    return
  end
  if ServerTime.CurServerTime() / 1000 < self.clickValidTime then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.model:PlayAction_Idle()
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

function NoviceLoginView:AdjustScrollView()
  local panel = self.scrollView.panel
  local cells = self.dailyLoginGridCtrl:GetCells()
  if self.awardeddays and #self.awardeddays > 0 then
    for i = self.curLoginNum, 1, -1 do
      if TableUtility.ArrayFindIndex(self.awardeddays, i) == 0 then
        local cellCtrl = cells[i]
        if cellCtrl then
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(offset.x, 0, 0)
          self.scrollView:MoveRelative(offset)
          break
        end
      end
    end
  end
end

function NoviceLoginView:HandleClickDailyLogin(cellCtrl)
  if not self:CheckActivityValid() then
    MsgManager.ShowMsgByID(40973)
    self.container:CloseSelf()
    return
  end
  local day = cellCtrl.indexInList or 7
  xdlog("申请签到", self.activityid, day)
  ServiceActivityCmdProxy.Instance:CallDaySigninLoginAwardCmd(self.activityid, {day})
end

function NoviceLoginView:HandleClickLastDayLogin()
  if not self:CheckActivityValid() then
    MsgManager.ShowMsgByID(40973)
    self.container:CloseSelf()
    return
  end
  local day = 7
  xdlog("申请签到", self.activityid, day)
  ServiceActivityCmdProxy.Instance:CallDaySigninLoginAwardCmd(self.activityid, {day})
end

function NoviceLoginView:HandleClickReward(cellCtrl)
  xdlog("recv HandleClickReward")
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0})
  end
end

function NoviceLoginView:CheckActivityValid()
  local inActivity = DailyLoginProxy.Instance:GetDaySignInActivity(self.activityid)
  if not inActivity then
    redlog("活动已结束", self.activityid)
    return false
  end
  return true
end

function NoviceLoginView:OnEnter()
  NoviceLoginView.super.OnEnter(self)
  DailyLoginProxy.Instance:TryCallSignInInfo()
  self.container:TimeLeftCountDown()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetReturnActivityTexture(texName, self[objName])
  end
  PictureManager.Instance:SetUI("calendar_bg1_picture2", self.innerTexture)
end

function NoviceLoginView:OnExit()
  NoviceLoginView.super.OnExit(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadReturnActivityTexture(texName, self[objName])
  end
  PictureManager.Instance:UnLoadUI("calendar_bg1_picture2", self.innerTexture)
end
