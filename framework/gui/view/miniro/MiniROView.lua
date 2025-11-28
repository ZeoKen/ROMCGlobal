autoImport("MiniROCell")
MiniROView = class("MiniROView", BaseView)
MiniROView.ViewType = UIViewType.NormalLayer
local timeFormat = "%02d:%02d:%02d"
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local _ClearTable = TableUtility.TableClear
local moveCellSpeed = 500
local interval = 33
local rotationIdxMin = 10
local rotationIdxMax = 22
local playBoliIdle = "wait"
local playBoliWalk = "walk"
local playBtnNormal = "state1001"
local playBtnNormalClick = "state1002"
local playBtnDirect = "state2001"
local playBtnDirectClick = "state2002"

function MiniROView:Init()
  self:FindObjs()
  self:AddEvents()
  self:AddListenEvts()
end

function MiniROView:OnEnter()
  MiniROView.super.OnEnter(self)
  self:InitView()
end

function MiniROView:OnExit()
  if self.model then
    self.model:GetRoleComplete().gameObject:SetActive(true)
    self.model:Destroy()
    self.model = nil
  end
  UIModelUtil.Instance:ClearModel(self.modelTexture)
  _DestroyAndClearTable(self.listCell)
  _DestroyAndClearTable(self.listStepIndex)
  self:DestroyCDTimeTick()
  self:DestroyMoveTimeTick()
  self.currentPosition = VectorUtility.Destroy(self.currentPosition)
  self.targetPosition = VectorUtility.Destroy(self.targetPosition)
  self.diffPosition = VectorUtility.Destroy(self.diffPosition)
  self.rotationVector3 = VectorUtility.Destroy(self.rotationVector3)
  self.rotationEuler = VectorUtility.Destroy(self.rotationEuler)
  self.isMovingPerStep = false
  self.isShowDialog = false
  self.isShowDiceAnim = false
  self.sysMsg = nil
  PictureManager.Instance:UnLoadUIAndClearCache("miniro_bg_cat3", self.imgCanPlay)
  PictureManager.Instance:UnLoadUIAndClearCache("miniro_bg_cat4", self.imgCanPlay)
  TimeTickManager.Me():ClearTick(self)
  MiniROProxy.Instance:ClearData()
  MiniROView.super.OnExit(self)
end

function MiniROView:OnDestroy()
  MiniROView.super.OnDestroy(self)
end

function MiniROView:FindObjs()
  self.objEffectDice = self:FindGO("objEffectDice")
  self.objEffectSearch = self:FindGO("objEffectSearch")
  self.objEffectReceive = self:FindGO("objEffectReceive")
  self.objEffectPlay = self:FindGO("objEffectPlay")
  self.txtTitleBack = self:FindComponent("txtTitleBack", UILabel)
  self.txtTitleFront = self:FindComponent("txtTitleFront", UILabel)
  self.txtActivityTime = self:FindComponent("txtActivityTime", UILabel)
  self.txtDice1Count = self:FindComponent("txtDice1Count", UILabel)
  self.txtDice2Count = self:FindComponent("txtDice2Count", UILabel)
  self.txtRewardTip = self:FindComponent("txtRewardTip", UILabel)
  self.transformCellStart = self:FindGO("objCell0").transform
  self.listCell = _CreateTable()
  self.objCellCount = #Table_Monopoly
  local data
  for i = 0, self.objCellCount do
    data = Table_Monopoly[i]
    local objCell = self:FindGO("objCell" .. i)
    self.listCell[i] = MiniROCell.new(objCell, data)
  end
  self.objBoli = self:FindGO("objBoli")
  self.transformBoli = self.objBoli.transform
  self.txtFindDiceTip = self:FindComponent("txtFindDiceTip", UILabel)
  self.txtFreeDiceCount = self:FindComponent("txtFreeDiceCount", UILabel)
  self.objCD = self:FindGO("objCD")
  self.txtCDTime = self:FindComponent("txtCDTime", UILabel)
  self.objCanPlay = self:FindGO("imgCanPlay")
  self.imgCanPlay = self.objCanPlay:GetComponent(UITexture)
  self.btnPlay = self:FindComponent("btnPlay", UISprite)
  self.txtPlay = self:FindGO("txtPlay")
  self.objCantPlay = self:FindGO("objCantPlay")
  self.txtCantPlayTip = self:FindComponent("txtCantPlayTip", UILabel)
  self.listStepIndex = _CreateTable()
  self.objDialogInfo = self:FindGO("objDialogInfo")
  self.txtName = self:FindComponent("txtName", UILabel)
  self.txtContent = self:FindComponent("txtContent", UILabel)
  self.objContinue = self:FindGO("objContinue")
  self.btnCloseDialog = self:FindGO("btnCloseDialog")
  self.btnX = self:FindGO("btnX")
  self.btnO = self:FindGO("btnO")
  self.modelContainer = self:FindGO("ModelContainer")
  self.modelTexture = self.modelContainer:GetComponent(UITexture)
  self:PlayUIEffect(EffectMap.UI.MiniRO_Boilmoving, self.objBoli, false, MiniROView._EffectShowBoliMove, self)
  self:PlayUIEffect(EffectMap.UI.MiniRo_receive, self.objEffectReceive)
  self:PlayUIEffect(EffectMap.UI.MiniRO_searching, self.objEffectSearch)
  self:PlayUIEffect(EffectMap.UI.MiniRO_catspaw, self.objEffectPlay, false, MiniROView._EffectShowCast, self)
  self.imgDice1 = self:FindGO("imgDice1"):GetComponent(UISprite)
  self.imgDice1LongPress = self:FindGO("imgDice1"):GetComponent(UILongPress)
  self.imgDice2 = self:FindGO("imgDice2"):GetComponent(UISprite)
  self.imgDice2LongPress = self:FindGO("imgDice2"):GetComponent(UILongPress)
end

function MiniROView:AddEvents()
  function self.imgDice1LongPress.pressEvent(obj, state)
    self:PassEvent(TipLongPressEvent.MiniROView, {
      state,
      
      EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL
    })
  end
  
  function self.imgDice2LongPress.pressEvent(obj, state)
    self:PassEvent(TipLongPressEvent.MiniROView, {
      state,
      EACTMINIRODICETYPE.EACTMINIRODICETYPE_ASSIGN
    })
  end
  
  self:AddEventListener(TipLongPressEvent.MiniROView, self.HandleLongPress, self)
  self:AddButtonEvent("btnClose", function(go)
    if MiniROProxy.Instance:IsMoving() or self.isShowDialog then
      return
    end
    UIManagerProxy.Instance:LockAndroidKey(false)
    self:CloseSelf()
  end)
  self:TryOpenHelpViewById(35044, nil, self:FindGO("btnHelp"))
  self:AddButtonEvent("btnGetReward", function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MiniRORewardView,
      viewdata = {}
    })
  end)
  self:AddButtonEvent("btnRewardList", function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MiniRORewardView,
      viewdata = {}
    })
  end)
  self:AddButtonEvent("btnGetFreeDice", function(go)
    local activityData = MiniROProxy.Instance:GetActivityData()
    if activityData == nil then
      return
    end
    if MiniROProxy.Instance:IsMoving() or self.isShowDialog then
      return
    end
    local featureData = activityData.featureData
    if self.dice1Count < featureData.diceItem.normalMax then
      ServiceActMiniRoCmdProxy.Instance:CallActMiniRoGetOneKey()
    else
      MsgManager.ShowMsgByID(41345)
    end
  end)
  self:AddButtonEvent("btnUseDirectDice", function(go)
    self.useDirectDice = not self.useDirectDice
    self:PlayCastDiceAnim(self.useDirectDice and playBtnDirect or playBtnNormal)
    self:SetPlayBtnStatus()
  end)
  self:AddButtonEvent("btnPlay", function(go)
    if not MiniROProxy.Instance:IsActivityDateValid() then
      MsgManager.ShowMsgByID(41346)
      return
    end
    if MiniROProxy.Instance:IsMoving() or self.isShowDialog then
      return
    end
    if self.useDirectDice then
      if self.dice2Count > 0 then
        self:PlayCastDiceAnim(playBtnDirectClick)
        self:ShowAnimTips()
      end
    elseif 0 < self.dice1Count then
      self:PlayCastDiceAnim(playBtnNormalClick)
      self:ShowAnimTips()
    end
  end)
  self:AddButtonEvent("btnCloseDialog", function(go)
    self:SetActiveDialogView(false)
    self:MoveBoli()
  end)
  self:AddButtonEvent("btnX", function(go)
    self:SetActiveDialogView(false)
    ServiceActMiniRoCmdProxy.Instance:CallActMiniRoEventFAQS(MiniROProxy.Instance:GetLeftQuestionId(), 1)
  end)
  self:AddButtonEvent("btnO", function(go)
    self:SetActiveDialogView(false)
    ServiceActMiniRoCmdProxy.Instance:CallActMiniRoEventFAQS(MiniROProxy.Instance:GetLeftQuestionId(), 2)
  end)
end

function MiniROView:CheckDiceAnimTips()
  local info = LocalSaveProxy.Instance:GetMiniRODiceAnim()
  local split = string.split(info, "_")
  if 1 < #split then
    return tonumber(split[1]), tonumber(split[2])
  end
  return 1, ServerTime.CurServerTime()
end

function MiniROView:ShowAnimTips()
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(self.sysId)
  local customtext = string.format(self.sysMsg.Text, self.sysMsg.TimeInterval)
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByIDWithCustomText(customtext, self.sysId, function()
      LocalSaveProxy.Instance:SetMiniRODiceAnim(0)
      self:SendCastDice(false)
    end, function()
      LocalSaveProxy.Instance:SetMiniRODiceAnim(1)
      self:SendCastDice(true)
    end)
  elseif self:CheckDiceAnimTips() == 1 then
    self:SendCastDice(true)
  else
    self:SendCastDice(false)
  end
end

function MiniROView:SendCastDice(isShowAnim)
  MiniROProxy.Instance:SetIsShowAnim(isShowAnim)
  if self.useDirectDice then
    if self.dice2Count > 0 then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.MiniRODirectDiceView,
        viewdata = {}
      })
    end
  elseif 0 < self.dice1Count then
    ServiceActMiniRoCmdProxy.Instance:CallActMiniRoCastDice(EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL)
  end
end

function MiniROView:AddListenEvts()
  self:AddListenEvt(ServiceActMiniRoCmdProxy.CreateDiceModelEvent, self.CreateDiceModel)
  self:AddListenEvt(ServiceEvent.ActMiniRoCmdActMiniRoOpenPage, self.RefreshView)
  self:AddListenEvt(ServiceEvent.ActMiniRoCmdActMiniRoDiceSync, self.RefreshFreeDice)
  self:AddListenEvt(ServiceEvent.ActMiniRoCmdActMiniRoEventFAQS, self.FAQResult)
end

function MiniROView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  local info = index == EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL and ZhString.MiniRODice1Info or ZhString.MiniRODice2Info
  local stick = index == EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL and self.imgDice1 or self.imgDice2
  TabNameTip.OnLongPress(isPressing, info, true, stick, NGUIUtil.AnchorSide.Top, {150, 40})
end

function MiniROView:InitView()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  local featureData = activityData.featureData
  self.txtActivityTime.text = MiniROProxy.Instance:GetActDuringTime()
  self.txtTitleBack.text = featureData.activityName
  self.txtTitleFront.text = featureData.activityName
  self.currentPosition = LuaVector3.Zero()
  self.targetPosition = LuaVector3.Zero()
  self.diffPosition = LuaVector2.Zero()
  self.rotationVector3 = LuaVector2.Zero()
  self.rotationEuler = LuaQuaternion()
  self.isMovingPerStep = false
  self.useDirectDice = false
  self.isShowDialog = false
  self.isShowDiceAnim = false
  self.sysId = 41469
  self.sysMsg = Table_Sysmsg[self.sysId]
  MiniROProxy.Instance:InitCurIndex()
  MiniROProxy.Instance:SetIsNewTurn(true)
  self:RefreshView()
  ServiceActMiniRoCmdProxy.Instance:CallActMiniRoOpenPage()
  local currentState, time = self:CheckDiceAnimTips()
  if currentState ~= 1 and ServerTime.CurServerTime() > time + self.sysMsg.TimeInterval * 86400000 then
    LocalSaveProxy.Instance:SetMiniRODiceAnim(1)
  end
end

function MiniROView:RefreshView()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  local featureData = activityData.featureData
  if MiniROProxy.Instance:IsNewTurn() then
    self:ResetCell()
    MiniROProxy.Instance:SetIsNewTurn(false)
  end
  self:RefreshDiceCount(featureData)
  if self.dice1Count < featureData.diceItem.normalMax then
  else
    MsgManager.ShowMsgByID(41345)
  end
  if MiniROProxy.Instance:GetCurCompleteTurns() < #featureData.circleRewards then
    self.txtRewardTip.text = string.format(ZhString.MiniRORewardTip1, MiniROProxy.Instance:GetCurCompleteTurns(), #featureData.circleRewards)
  else
    self.txtRewardTip.text = ZhString.MiniRORewardTip2
  end
  self:RefreshFreeDice()
  self:SetPlayBtnStatus()
  self:MoveBoli()
end

function MiniROView:RefreshDiceCount(featureData, diceType)
  if not featureData then
    return
  end
  self.dice1Count = MiniROProxy.Instance:GetDiceCount(EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL)
  self.dice2Count = MiniROProxy.Instance:GetDiceCount(EACTMINIRODICETYPE.EACTMINIRODICETYPE_ASSIGN)
  if diceType then
    if diceType == EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL then
      self.txtDice1Count.text = self.dice1Count .. "/" .. featureData.diceItem.normalMax
    elseif diceType == EACTMINIRODICETYPE.EACTMINIRODICETYPE_ASSIGN then
      self.txtDice2Count.text = self.dice2Count .. "/" .. featureData.diceItem.advanceMax
    end
  else
    self.txtDice1Count.text = self.dice1Count .. "/" .. featureData.diceItem.normalMax
    self.txtDice2Count.text = self.dice2Count .. "/" .. featureData.diceItem.advanceMax
  end
end

function MiniROView:SetPlayBtnStatus()
  self.btnPlay.spriteName = self.useDirectDice and "miniro_icon_dice2" or "miniro_icon_dice1"
  self.txtCantPlayTip.text = self.useDirectDice and ZhString.MiniROCantPlayTip2 or ZhString.MiniROCantPlayTip1
  if self.useDirectDice then
    self.txtPlay:SetActive(self.dice2Count > 0)
    self.objCantPlay:SetActive(self.dice2Count < 1)
    self.objEffectPlay:SetActive(self.dice2Count > 0)
  else
    self.txtPlay:SetActive(0 < self.dice1Count)
    self.objCantPlay:SetActive(1 > self.dice1Count)
    self.objEffectPlay:SetActive(0 < self.dice1Count)
  end
end

function MiniROView:RefreshFreeDice()
  local freeDiceData = MiniROProxy.Instance:GetFreeDiceData()
  if not freeDiceData then
    return
  end
  if freeDiceData.store >= freeDiceData.storemax then
    self.txtFindDiceTip.text = ZhString.MiniROFullCountFreeDice
  elseif freeDiceData.store <= 0 then
    self.txtFindDiceTip.text = ZhString.MiniROSearchingFreeDice
  else
    self.txtFindDiceTip.text = ZhString.MiniROCanGetFreeDice
  end
  self.objEffectReceive:SetActive(freeDiceData.store > 0)
  self.objEffectSearch:SetActive(freeDiceData.store < freeDiceData.storemax)
  self.txtFreeDiceCount.text = freeDiceData.store .. "/" .. freeDiceData.storemax
  self.objCD:SetActive(freeDiceData.store < freeDiceData.storemax)
  self.endTime = freeDiceData.nexttimestamp
  if self.timeTickCD then
    return
  end
  self.timeTickId = self.timeTickId == nil and 100 or self.timeTickId + 1
  self.timeTickCD = TimeTickManager.Me():CreateTick(0, 1000, self.RefreshFreeDiceCD, self, self.timeTickId)
end

function MiniROView:FAQResult(note)
  if not note or not note.body then
    return
  end
  if not note.body.result then
    MsgManager.ShowMsgByID(41355)
  end
end

function MiniROView:RefreshFreeDiceCD()
  local currenttime = ServerTime.CurServerTime()
  local leftTime = (self.endTime * 1000 - currenttime) / 1000
  if leftTime < 0 then
    self.txtCDTime.text = string.format(timeFormat, 0, 0, 0)
    self:DestroyCDTimeTick()
    return false
  end
  local d, h, m, s = ClientTimeUtil.FormatTimeBySec(leftTime)
  self.txtCDTime.text = string.format(timeFormat, h, m, s)
  return true
end

function MiniROView:DestroyCDTimeTick()
  if self.timeTickCD then
    self.timeTickCD:Destroy()
    self.timeTickCD = nil
  end
end

function MiniROView:DestroyMoveTimeTick()
  if self.timeTickMove then
    self.timeTickMove:Destroy()
    self.timeTickMove = nil
  end
end

function MiniROView._EffectShowBoliMove(effectHandle, owner)
  if not owner then
    return
  end
  owner.moveAnimator = effectHandle.gameObject:GetComponent(Animator)
  owner.PlayBoliMoveAnim(owner, playBoliIdle)
end

function MiniROView:PlayBoliMoveAnim(aniName)
  if self.moveAnimator == nil then
    return
  end
  self.moveAnimator:Play(aniName, 0, 0)
end

function MiniROView._EffectShowCast(effectHandle, owner)
  if not owner then
    return
  end
  owner.castAnimator = effectHandle.gameObject:GetComponent(Animator)
  owner.PlayCastDiceAnim(owner, playBtnNormal)
end

function MiniROView:PlayCastDiceAnim(aniName)
  if self.castAnimator == nil then
    return
  end
  self.castAnimator:Play(aniName, 0, 0)
end

function MiniROView:CreateDiceModel(note)
  if not note or not note.body then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local diceNum = note.body == EACTMINIRODICETYPE.EACTMINIRODICETYPE_NORMAL and 2220 or 2219
  parts[Asset_Role.PartIndex.Body] = diceNum
  parts[Asset_Role.PartIndexEx.LoadFirst] = true
  self.model = nil
  UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.MiniRODice, 0.1, nil, nil, nil, function(obj)
    self.model = obj
    self.model:GetRoleComplete().gameObject:SetActive(true)
  end)
  UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
  Asset_Role.DestroyPartArray(parts)
  self.isShowDiceAnim = true
end

function MiniROView:PlayDiceAnim(actionName, callBack)
  if self.model == nil then
    return
  end
  self.model:GetRoleComplete().gameObject:SetActive(true)
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  params[7] = callBack
  self.model:PlayAction(params)
end

function MiniROView:MoveBoli()
  if self.isMovingPerStep then
    return
  end
  local curIndex = MiniROProxy.Instance:GetCurIndex()
  local nextIndex = MiniROProxy.Instance:GetNextStepIndex()
  if nextIndex then
    self.isMovingPerStep = true
    if self.isShowDiceAnim then
      self.isShowDiceAnim = false
      self.timeTickId = self.timeTickId == nil and 100 or self.timeTickId + 1
      TimeTickManager.Me():CreateOnceDelayTick(math.random(2, 3) * 1000, function(owner, deltaTime)
        local step = nextIndex > curIndex and nextIndex - curIndex + 1 or self.objCellCount - curIndex + nextIndex + 2
        self:PlayDiceAnim("state" .. step .. "001", function()
          self.model:GetRoleComplete().gameObject:SetActive(false)
        end)
        self.timeTickId = self.timeTickId == nil and 100 or self.timeTickId + 1
        TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
          self:MoveToNextIndex(nextIndex)
        end, self, self.timeTickId)
      end, self, self.timeTickId)
    else
      self:MoveToNextIndex(nextIndex)
    end
  else
    local targetPosition = curIndex == -1 and self.transformCellStart.localPosition or self:GetCellByIndex(curIndex):GetPosition()
    LuaVector3.Better_SetPosXYZ(self.currentPosition, targetPosition.x, targetPosition.y, targetPosition.z)
    self.transformBoli.localPosition = self.currentPosition
    self:SetBoliRotation(curIndex)
    self:ShowQuestion()
  end
end

function MiniROView:SetBoliRotation(index)
  local rotationY = index > rotationIdxMin and index < rotationIdxMax and 180 or 0
  self.rotationVector3[2] = rotationY
  LuaQuaternion.Better_SetEulerAngles(self.rotationEuler, self.rotationVector3)
  self.transformBoli.rotation = self.rotationEuler
end

function MiniROView:MoveToNextIndex(nextIndex)
  if nextIndex then
    local curIndex = MiniROProxy.Instance:GetCurIndex()
    _ClearTable(self.listStepIndex)
    local subStep = nextIndex - curIndex
    local moveStep = math.abs(subStep)
    local stepIndex = 0
    local tempStepIndex = 0
    local isMoveReverse = false
    if nextIndex < curIndex then
      if -6 <= subStep then
        isMoveReverse = true
      else
        moveStep = self.objCellCount - curIndex + nextIndex + 1
      end
    elseif 6 < moveStep then
      isMoveReverse = true
      moveStep = self.objCellCount - nextIndex + curIndex + 1
    end
    if isMoveReverse then
      local tempStepIndex = 0
      for i = 1, moveStep do
        stepIndex = curIndex - i
        if stepIndex < 0 then
          stepIndex = self.objCellCount - tempStepIndex
          tempStepIndex = tempStepIndex + 1
        end
        self.listStepIndex[i] = stepIndex
      end
    else
      for i = 1, moveStep do
        stepIndex = curIndex + i
        if stepIndex > self.objCellCount then
          stepIndex = tempStepIndex
          tempStepIndex = tempStepIndex + 1
        end
        self.listStepIndex[i] = stepIndex
      end
    end
    self:DestroyMoveTimeTick()
    self:PlayBoliMoveAnim(playBoliWalk)
    self:MoveToPerStep(self.listStepIndex)
  end
end

function MiniROView:MoveToPerStep(listStepIndex)
  local nextIndex = table.remove(self.listStepIndex, 1)
  if not nextIndex then
    self.isMovingPerStep = false
    local nextQuestion = MiniROProxy.Instance:GetNextQuestion()
    if nextQuestion and nextQuestion ~= 0 then
      self:ShowQuestion(nextQuestion)
    elseif not self.isShowDialog then
      MiniROProxy.Instance:SetIsMoving(false)
    end
    return
  end
  local targetPosition = self:GetCellByIndex(nextIndex):GetPosition()
  LuaVector3.Better_Set(self.targetPosition, targetPosition.x, targetPosition.y, targetPosition.z)
  VectorUtility.SubXY_2(self.targetPosition, self.currentPosition, self.diffPosition)
  MiniROProxy.Instance:SetCurIndex(nextIndex)
  self:SetBoliRotation(nextIndex)
  if self.timeTickMove then
    return
  end
  self.timeTickId = self.timeTickId == nil and 100 or self.timeTickId + 1
  self.timeTickMove = TimeTickManager.Me():CreateTick(0, interval, function(owner, deltaTime)
    if VectorUtility.AlmostEqual_3(self.currentPosition, self.targetPosition) then
      local curIndex = MiniROProxy.Instance:GetCurIndex()
      self:GetCellByIndex(curIndex):SetPassed()
      if TableUtil.TableIsEmpty(self.listStepIndex) then
        VectorUtility.Asign_3(self.currentPosition, self.targetPosition)
        self.transformBoli.localPosition = self.currentPosition
        self.isMovingPerStep = false
        local isEvent = false
        local dialogInfo = MiniROProxy.Instance:GetNextDialogInfo()
        if dialogInfo then
          isEvent = true
          self:ShowDialogView(dialogInfo)
        end
        local nextQuestion = MiniROProxy.Instance:GetNextQuestion()
        if nextQuestion and nextQuestion ~= 0 then
          isEvent = true
          self:ShowQuestion(nextQuestion)
        end
        if not isEvent then
          MiniROProxy.Instance:SetIsMoving(false)
          ServiceActMiniRoCmdProxy.Instance:CallActMiniRoCheckCircleReward()
        end
        self:PlayBoliMoveAnim(playBoliIdle)
        self:DestroyMoveTimeTick()
      else
        self:PlayBoliMoveAnim(playBoliWalk)
        self:MoveToPerStep(self.listStepIndex)
      end
    else
      local deltaDistance = interval * 100 / moveCellSpeed
      LuaVector3.SelfMoveTowards(self.currentPosition, self.targetPosition, deltaDistance)
      self.transformBoli.localPosition = self.currentPosition
    end
  end, self)
end

function MiniROView:ShowQuestion(questionid)
  questionid = questionid or MiniROProxy.Instance:GetLeftQuestionId()
  if questionid == 0 then
    return
  end
  local xoData = Table_xo[questionid]
  if not xoData then
    return
  end
  self:SetActiveDialogView(true)
  self.txtName.text = xoData.Title
  self.txtContent.text = xoData.Context
  self.objContinue:SetActive(false)
  self.btnCloseDialog:SetActive(false)
  self.btnX:SetActive(true)
  self.btnO:SetActive(true)
end

function MiniROView:ShowDialogView(dialogInfo)
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  self:SetActiveDialogView(true)
  local dialogMsg
  if dialogInfo.dialogId == activityData.moveForwardID then
    dialogMsg = ZhString.MiniRODialogInfo1
  elseif dialogInfo.dialogId == activityData.moveBackID then
    dialogMsg = ZhString.MiniRODialogInfo2
  end
  self.txtName.text = "Tips"
  self.txtContent.text = string.format(dialogMsg, dialogInfo.dialogStep)
  self.objContinue:SetActive(true)
  self.btnCloseDialog:SetActive(true)
  self.btnX:SetActive(false)
  self.btnO:SetActive(false)
end

function MiniROView:SetActiveDialogView(active)
  self.isShowDialog = active
  self.objDialogInfo:SetActive(active)
end

function MiniROView:GetCellByIndex(index)
  return self.listCell[index]
end

function MiniROView:ResetCell()
  local data
  for i = 1, self.objCellCount do
    data = Table_Monopoly[i]
    local miniROCell = self.listCell[i]
    miniROCell:SetData(data)
  end
end
