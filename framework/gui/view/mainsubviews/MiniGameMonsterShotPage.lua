autoImport("MiniGameMonsterShotConditionCell")
autoImport("MiniGameMonsterShotRecordCell")
autoImport("ShortCutSkill")
autoImport("MiniGameTimeBonusCell")
MiniGameMonsterShotPage = class("MiniGameMonsterShotPage", ContainerView)
MiniGameMonsterShotPage.ViewType = UIViewType.ToolsLayer
local MonsterShotRaidId = 1003114

function MiniGameMonsterShotPage:Init()
  self:AddViewEvts()
  self:initView()
end

function MiniGameMonsterShotPage:OnEnter()
  self.super.OnEnter(self)
  ClickEffectView.disable = true
  self.panel:SetActive(false)
  self.recordList:ResetDatas()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, false)
  self.selectAutoNormalAtk = MyselfProxy.Instance.selectAutoNormalAtk
  if self.selectAutoNormalAtk then
    ServiceNUserProxy.Instance:CallSetNormalSkillOptionUserCmd(0)
  end
  self.uipanel.depth = self.uipanel.depth - 250
end

function MiniGameMonsterShotPage:OnExit()
  self:ClearTick()
  self.normalRecords = nil
  ClickEffectView.disable = false
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, true)
  self.skillShotCutList:RemoveAll()
  self.timeBonusList:RemoveAll()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.FocusLayer)
  if self.selectAutoNormalAtk then
    ServiceNUserProxy.Instance:CallSetNormalSkillOptionUserCmd(1)
  end
  self.uipanel.depth = self.uipanel.depth + 250
  self.super.OnExit(self)
end

function MiniGameMonsterShotPage:initView()
  self.uipanel = self.gameObject:GetComponent(UIPanel)
  self.panel = self:FindGO("Panel")
  self.countdown = self:FindGO("countdown"):GetComponent(UILabel)
  self:FindComponent("GameName", UILabel).text = ZhString.MiniGame_MonsterShot_Name
  self.condition = self:FindComponent("ConditionContainer", UIGrid)
  self.sizeWidget = self:FindComponent("Size", UIWidget)
  self.conditionList = UIGridListCtrl.new(self.condition, MiniGameMonsterShotConditionCell, "MiniGameMonsterShotConditionCell")
  self.lefttimes = self:FindGO("LeftTimes"):GetComponent(UILabel)
  self.photoButton = self:FindComponent("PhotoButton", BoxCollider)
  self:AddClickEvent(self.photoButton.gameObject, self.OpenPhotoGraph)
  self.Anchor_LeftTop = self:FindGO("LeftTop")
  self.Anchor_RightBottom = self:FindGO("RightBottom")
  self.challengeMode = self:FindGO("ChallengeMode")
  self.challengeBestNum = self:FindComponent("number1", UILabel, self.challengeMode)
  self.challengeCurNum = self:FindComponent("number2", UILabel, self.challengeMode)
  self.challengeLeftNum = self:FindComponent("number3", UILabel, self.challengeMode)
  self.normalMode = self:FindGO("NormalMode")
  self.normalGrid = self:FindComponent("NormalGrid", UIGrid, self.normalMode)
  self.recordList = UIGridListCtrl.new(self.normalGrid, MiniGameMonsterShotRecordCell, "MiniGameMonsterShotRecordCell")
  self.timeBonusGrid = self:FindComponent("TimeBonusGrid", UIGrid)
  self.timeBonusList = UIGridListCtrl.new(self.timeBonusGrid, MiniGameTimeBonusCell, "MiniGameTimeBonusCell")
  self.nextContainer = self:FindGO("NextContainer")
  self:AddClickEvent(self:FindGO("ButtonNext", self.nextContainer), function()
    self:DoGoNextRound()
  end)
  self.skipContainer = self:FindGO("SkipContainer")
  self.skipCollider = self:FindComponent("ButtonSkip", BoxCollider, self.skipContainer)
  self:AddClickEvent(self:FindGO("ButtonSkip", self.skipContainer), function()
    self:DoSkipRound()
  end)
  self.skipTime = self:FindComponent("skiptime", UILabel, self.skipContainer)
  self.skillContainer = self:FindGO("SkillContainer")
  self.skillgrid = self:FindComponent("SkillGrid", UIGrid)
  self.skillShotCutList = UIGridListCtrl.new(self.skillgrid, ShortCutSkill, "ShortCutSkill")
  self.buttonBack = self:FindGO("ButtonBack")
  self:AddClickEvent(self.buttonBack, function()
    self:CustomExit()
  end)
end

function MiniGameMonsterShotPage:AddViewEvts()
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_Shutdown, self.EndGame)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_Launch, self.StartGame)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfMonsterShot, self.UpdateProgress)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNextRound, self.HandleNextRound)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd, self.ShowResult)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_EnterPhotoGraph, self.OnEnterPhotoGraph)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_ExitPhotoGraph, self.OnExitPhotoGraph)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_TakePhotoGraph, self.OnTakePhotoGraph)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_ClosePhotoGraphResult, self.OnClosePhotoGraphResult)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.OnPlayerMapChange)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.RefreshSkillCD)
end

function MiniGameMonsterShotPage:OpenPhotoGraph()
  local viewCfg = FunctionUnLockFunc.Me():GetPanelConfigById(PanelConfig.PhotographPanel.id)
  if viewCfg then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = viewCfg})
  else
    MsgManager.FloatMsg("", ZhString.MiniGame_MonsterShot_FuncLock)
  end
end

function MiniGameMonsterShotPage:OnEnterPhotoGraph()
  self.photoButton.enabled = false
  self.Anchor_LeftTop:SetActive(false)
  self.Anchor_RightBottom:SetActive(false)
  self.isInPhotoing = true
end

function MiniGameMonsterShotPage:OnExitPhotoGraph()
  self.photoButton.enabled = true
  self.Anchor_LeftTop:SetActive(true)
  self.Anchor_RightBottom:SetActive(true)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, false)
  self.isInPhotoing = false
end

function MiniGameMonsterShotPage:OnTakePhotoGraph()
  self:ClearTick()
  self.panel:SetActive(false)
end

function MiniGameMonsterShotPage:OnClosePhotoGraphResult()
  self.panel:SetActive(false)
  self:ClientRoundEnd()
  self:DoGoNextRound()
end

function MiniGameMonsterShotPage:OnPlayerMapChange(note)
  if note.type == LoadSceneEvent.StartLoad and Game.MapManager:IsPVEMode_MonsterShot() and ServicePlayerProxy.Instance:GetCurMapImageId() ~= MonsterShotRaidId then
    Game.DungeonManager:Shutdown()
  end
end

function MiniGameMonsterShotPage:StartGame()
  self.curround = nil
  MsgManager.FloatMsg("", ZhString.MiniGame_MonsterShot_Start)
end

function MiniGameMonsterShotPage:EndGame()
  MsgManager.FloatMsg("", ZhString.MiniGame_MonsterShot_End)
  self:CloseSelf()
end

function MiniGameMonsterShotPage:ClientRoundEnd(isSkipRound, isTimeOut)
  local result = MiniGameProxy.Instance.monsterShotInfo
  if result then
    result.misstimerest = result.result and result.misstimerest or result.misstimerest - 1
    if result.mode == EMINIGAMEMODE.EMINIGAMEMODE_NORMAL then
      if self.curround <= #self.normalRecords then
        self.normalRecords[self.curround] = result.result and 1 or -1
        self.recordList:ResetDatas(self.normalRecords)
      end
      self.nextContainer:SetActive(self.curround < #self.normalRecords and result.misstimerest >= 0 and not isSkipRound)
    else
      if result.result then
        self.curtotal = self.curtotal and self.curtotal + 1 or 1
      end
      self:SetChallengeModeInfo()
      self.nextContainer:SetActive(result.misstimerest >= 0 and not isSkipRound and not isTimeOut)
    end
  end
  self.skipCollider.enabled = false
end

function MiniGameMonsterShotPage:StartCountdown()
  local gameTime = MiniGameProxy.Instance.monsterShotInfo.countdown or 0
  self.startTime = ServerTime.CurServerTime() / 1000
  self.endTime = self.startTime + gameTime
  leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
end

function MiniGameMonsterShotPage:UpdateCountDown()
  leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  self.countdown.text = string.format("%ss", math.floor(leftTime))
  if leftTime <= 0 then
    self:Timeout()
  end
end

function MiniGameMonsterShotPage:Timeout()
  self:ClearTick()
  MiniGameProxy.Instance.monsterShotInfo.result = false
  MsgManager.FloatMsg("", ZhString.MiniGame_MonsterShot_Timeout)
  self.panel:SetActive(true)
  self:ClientRoundEnd(false, true)
end

function MiniGameMonsterShotPage:ClearTick()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function MiniGameMonsterShotPage:UpdateProgress()
  self.panel:SetActive(true)
  local info = MiniGameProxy.Instance.monsterShotInfo
  if self.curround ~= info.curround then
    self.curround = info.curround
    self:ClearTick()
    self:StartCountdown()
    self.conditionList:ResetDatas(info.requires)
    self.sizeWidget.width = math.max(self.condition.cellWidth * #info.requires, self.condition.cellWidth)
  else
  end
  if info then
    self.lefttimes.text = string.format("X %d", info.misstimerest or 0)
  end
  local add_time, quick_fin_times = self:ParseAssistList()
  self.skipContainer:SetActive(true)
  self.skipTime.text = "x" .. quick_fin_times
  if 0 < quick_fin_times then
    self:SetTextureWhite(self.skipContainer, ColorUtil.ButtonLabelBlue)
    self.skipCollider.enabled = true
  else
    self.skipCollider.enabled = false
  end
  self.timeBonusList:ResetDatas(add_time)
  self.nextContainer:SetActive(false)
  if info.mode == EMINIGAMEMODE.EMINIGAMEMODE_NORMAL then
    self.normalMode:SetActive(true)
    self.challengeMode:SetActive(false)
    if not self.normalRecords then
      self.normalRecords = {}
      for i = 1, info.totalrounds do
        TableUtility.ArrayPushBack(self.normalRecords, 0)
      end
    end
    self.recordList:ResetDatas(self.normalRecords)
  else
    self.normalMode:SetActive(false)
    self.challengeMode:SetActive(true)
    self:SetChallengeModeInfo()
  end
  self:RefreshSkills()
end

function MiniGameMonsterShotPage:HandleNextRound()
  local add_time, quick_fin_times = self:ParseAssistList()
  self.skipContainer:SetActive(true)
  self.skipTime.text = "x" .. quick_fin_times
  if 0 < quick_fin_times then
    self:SetTextureWhite(self.skipContainer, ColorUtil.ButtonLabelBlue)
    self.skipCollider.enabled = true
  else
    self.skipCollider.enabled = false
  end
  self.timeBonusList:ResetDatas(add_time)
end

function MiniGameMonsterShotPage:ParseAssistList()
  local skipTime_assistList = MiniGameProxy.Instance:GetItemList(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO, EASSISTTYPE.EASSISTTYPE_QUICK_FINISH)
  local addTime_assistList = MiniGameProxy.Instance:GetItemList(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO, EASSISTTYPE.EASSISTTYPE_ADDTIME)
  local add_time = {}
  for i = 1, #addTime_assistList do
    add_time[#add_time + 1] = addTime_assistList[i].effect
  end
  return add_time, skipTime_assistList and skipTime_assistList[1] and skipTime_assistList[1].count or 0
end

function MiniGameMonsterShotPage:ShowResult()
  local finalResult = MiniGameProxy.Instance.monsterShotInfo.gameResult
  local finalPrompt = finalResult and ZhString.MiniGame_MonsterShot_GameWin or ZhString.MiniGame_MonsterShot_GameLose
  MsgManager.FloatMsg("", finalPrompt)
  self.panel:SetActive(false)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.FocusLayer)
  self:HandlePvpResult(finalResult)
end

function MiniGameMonsterShotPage:HandlePvpResult(result)
  local data = {}
  data.result = result and 1 or 2
  data.simply = true
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
end

function MiniGameMonsterShotPage:DoGoNextRound()
  ServiceMiniGameCmdProxy.Instance:CallMiniGameNextRound(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO)
  self.nextContainer:SetActive(false)
end

function MiniGameMonsterShotPage:DoSkipRound()
  ServiceMiniGameCmdProxy.Instance:CallMiniGameUseAssist(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO, EASSISTTYPE.EASSISTTYPE_QUICK_FINISH)
  self.skipContainer:SetActive(false)
  MiniGameProxy.Instance.monsterShotInfo.result = true
  self:ClientRoundEnd(true)
end

function MiniGameMonsterShotPage:CustomExit()
  if self.isInPhotoing then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.FocusLayer)
    self:OnExitPhotoGraph()
  else
    MsgManager.ConfirmMsgByID(41103, function()
      ServiceMiniGameCmdProxy.Instance:CallMiniGameReqOver(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO)
    end)
  end
end

function MiniGameMonsterShotPage:RefreshSkills()
  local skilldatas = {}
  local cfg_skills, skillid = GameConfig.MiniGame.MonsterShotSkills or {}
  for i = 1, #cfg_skills do
    skillid = cfg_skills[i]
    local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(skillid)
    if not skill then
      skill = SkillItemData.new(skillid, 0, 0, 0, 0)
      skill.learned = true
      if not SkillProxy.Instance:HasLearnedSkill(skillid) then
        SkillProxy.Instance:LearnedSkill(skill)
      end
    end
    TableUtility.ArrayPushBack(skilldatas, skill)
  end
  self.skillShotCutList:ResetDatas(skilldatas)
end

function MiniGameMonsterShotPage:RefreshSkillCD(note)
  local cells = self.skillShotCutList:GetCells()
  for _, o in pairs(cells) do
    o:TryStartCd()
  end
end

function MiniGameMonsterShotPage:SetChallengeModeInfo()
  local info = MiniGameProxy.Instance.monsterShotInfo
  local record_srv = MiniGameProxy.Instance:GetChallengeRecord(EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO) or 0
  self.challengeBestNum.text = math.max(self.curtotal or 0, record_srv)
  self.challengeCurNum.text = self.curtotal or 0
  self.challengeLeftNum.text = info.misstimerest
end
