MiniGameMonsterQAPage = class("MiniGameMonsterQAPage", ContainerView)
MiniGameMonsterQAPage.ViewType = UIViewType.ToolsLayer
autoImport("MonsterQARecordCell")
local QuestionConfig = GameConfig.MiniGame.MonsterQA
local MonsterQARaidId = 1003113
local GameType = MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_ANSWER
local SkipItemType = MiniGameCmd_pb.EASSISTTYPE_QUICK_FINISH
local AddTimeTtemType = MiniGameCmd_pb.EASSISTTYPE_ADDTIME
local grey = LuaColor.New(0.7137254901960784, 0.7137254901960784, 0.7137254901960784)
local AlmostEqual = NumberUtility.AlmostEqual
local green = {
  LuaColor.New(0.6196078431372549, 0.8980392156862745, 0.43529411764705883),
  LuaColor.New(0.9176470588235294, 0.9607843137254902, 0.8392156862745098)
}
local red = {
  LuaColor.New(1, 1.5378700499807765E-5),
  LuaColor.New(1, 0.7254901960784313, 0.7254901960784313)
}

function MiniGameMonsterQAPage:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:initCameraData()
  self.challengeFilterData = 99
end

local value

function MiniGameMonsterQAPage:FindObjs()
  self.questionLabel = self:FindGO("QuestionLabel"):GetComponent(UILabel)
  self.countdown = self:FindGO("countdown"):GetComponent(UILabel)
  self.input = self:FindGO("AnswerInput"):GetComponent(UIInput)
  self.inputLabel = self:FindGO("Label", self.input.gameObject):GetComponent(UILabel)
  self.result = self:FindGO("ResultContainer")
  self.correctAnswer = self:FindGO("CorrectAnswer")
  self.correctAnswerLabel = self:FindGO("Label", self.correctAnswer):GetComponent(UILabel)
  self.recordGrid = self:FindGO("recordGrid"):GetComponent(UIGrid)
  self.recordGridCtrl = UIGridListCtrl.new(self.recordGrid, MonsterQARecordCell, "MonsterQARecordCell")
  self.challengeContainer = self:FindGO("challengeContainer")
  self.totalwrong = self:FindGO("totalwrong"):GetComponent(UILabel)
  self.totalcorrect = self:FindGO("totalcorrect"):GetComponent(UILabel)
  self.recordCount = self:FindGO("recordCount"):GetComponent(UILabel)
  self.content = self:FindGO("content")
  self.effectContainer = self:FindGO("effectContainer")
  self.timeEffectContainer = self:FindGO("timeEffectContainer")
  local effectPath = ResourcePathHelper.EffectUI("Eff_TimeBeat_LittleGame")
  self.timerGo = self:LoadPreferb_ByFullPath(effectPath, self.timeEffectContainer)
  self.timerGo:SetActive(false)
  self.timeEffctLabel = self:FindGO("+3s", self.timerGo):GetComponent(UILabel)
  self.timeEffctLabel.effectStyle = UILabel.Effect.Shadow
  self.timeAnimator = self.timerGo:GetComponent(Animator)
  self.comfirmButton = self:FindGO("ComfirmButton")
  self:AddClickEvent(self.comfirmButton, function()
    value = tonumber(self.input.value)
    if not value or value < 0 then
      return
    end
    self.myAnswer = value
    ServiceMiniGameCmdProxy.Instance:CallMiniGameSubmitMonsterAnswer(tonumber(value))
  end)
  self:AddButtonEvent("CloseButton", function()
    self:CustomExit()
  end)
  self.skipBtn = self:FindGO("SkipButton")
  self:AddClickEvent(self.skipBtn, function()
    itemCount = MiniGameProxy.Instance:GetItemList(GameType, SkipItemType) or {}
    count = 0
    for i = 1, #itemCount do
      count = count + itemCount[i].count
    end
    if count > 0 then
      ServiceMiniGameCmdAutoProxy:CallMiniGameUseAssist(GameType, SkipItemType)
    end
  end)
  self.skipCount = self:FindGO("skipCount"):GetComponent(UILabel)
  self.nextBtn = self:FindGO("NextButton")
  self:AddClickEvent(self.nextBtn, function()
    ServiceMiniGameCmdAutoProxy:CallMiniGameNextRound(GameType)
  end)
  self.fovScrollBar = self:FindChild("FovScrollBar")
  self.fovScrollBarCpt = self:FindGO("BackGround", self.fovScrollBar):GetComponent(UICustomScrollBar)
  EventDelegate.Add(self.fovScrollBarCpt.onChange, function()
    if not self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
      return
    end
    local value = self.fovScrollBarCpt.value
    local zoom = (self.fovMax - self.fovMin) * value + self.fovMin
    local fieldOfView = self:calFOVValue(zoom)
    self.cameraController:ResetFieldOfView(fieldOfView)
  end)
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  self.scrollTick = TimeTickManager.Me():CreateTick(0, 100, self.updateScrollBar, self, 2)
end

function MiniGameMonsterQAPage:CustomExit()
  MsgManager.ConfirmMsgByID(41103, function()
    ServiceMiniGameCmdProxy.Instance:CallMiniGameReqOver(GameType)
  end)
end

function MiniGameMonsterQAPage:PlayAddTimeEffect(time)
  self.timeEffctLabel.text = string.format("+%d", time)
  self.timeEffctLabel.color = green[1]
  self.timeEffctLabel.effectColor = green[2]
  self.timeAnimator:Play("Eff_TimeBeat_LittleGame_UP", -1, 0)
end

function MiniGameMonsterQAPage:PlayMinusTimeEffect(time)
  self.timeEffctLabel.text = string.format("%d", time)
  self.timeEffctLabel.color = red[1]
  self.timeEffctLabel.effectColor = red[2]
  self.timeAnimator:Play("Eff_TimeBeat_LittleGame_UP", -1, 0)
end

local fieldOfView, fov, sclValue, barCptValue

function MiniGameMonsterQAPage:updateScrollBar()
  if self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
    return
  end
  if Slua.IsNull(self.fovScrollBarCpt) then
    return
  end
  fieldOfView = self.cameraController.cameraFieldOfView
  fieldOfView = Mathf.Clamp(fieldOfView, self.fovMinValue, self.fovMaxValue)
  fov = self:calZoom(fieldOfView)
  sclValue = (fov - self.fovMin) / (self.fovMax - self.fovMin)
  sclValue = math.floor(sclValue * 100 + 0.5) / 100
  barCptValue = math.floor(self.fovScrollBarCpt.value * 100 + 0.5) / 100
  if sclValue ~= barCptValue then
    self.fovScrollBarCpt.value = sclValue
  end
end

function MiniGameMonsterQAPage:calZoom(del)
  return 21.635 / math.tan(del / 2 / 180 * math.pi)
end

function MiniGameMonsterQAPage:AddViewEvts()
  self:AddListenEvt(PVEEvent.MiniGameMonsterQA_Shutdown, self.EndGame)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfMonsterAnswer, self.UpdateQuestion)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd, self.EndGame)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.OnPlayerMapChange)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfRoundOver, self.HandleRoundOver)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNextRound, self.HandleNextRound)
end

function MiniGameMonsterQAPage:InitView()
  self.content:SetActive(true)
  self.difficulty = MiniGameProxy.Instance:GetCurrentGameDifficulty()
  self.corrects = 0
  self.wrongs = 0
  if not self.difficulty then
    return
  end
  if self.difficulty < self.challengeFilterData then
    self.challengeContainer:SetActive(false)
    self.maxCell = Table_MiniGame_MonsterAnswer[self.difficulty].Required_Turn[2] or 0
    if not self.recordData then
      self.recordData = {}
    else
      TableUtility.ArrayClear(self.recordData)
    end
    for i = 1, self.maxCell do
      local result = 0
      TableUtility.ArrayPushBack(self.recordData, result)
    end
    self.recordGridCtrl:ResetDatas(self.recordData)
  else
    self.challengeMode = true
    self.tolerance = Table_MiniGame_MonsterAnswer[self.difficulty].Required_Turn[1] or 0
    self.challengeContainer:SetActive(true)
    self:UpdateChallengeRecord()
  end
end

function MiniGameMonsterQAPage:OnPlayerMapChange(note)
  if note.type == LoadSceneEvent.StartLoad and Game.MapManager:IsPVEMode_MonsterQA() and ServicePlayerProxy.Instance:GetCurMapImageId() ~= MonsterQARaidId then
    Game.DungeonManager:Shutdown()
  end
end

local lastreplystatus = 0

function MiniGameMonsterQAPage:HandleRoundOver(note)
  if note and note.body then
    lastreplystatus = note.body.lastreplystatus
    if lastreplystatus == MiniGameCmd_pb.ELASTREPLYSTATUS_RIGHT then
      self.corrects = self.corrects + 1
      if not self.record then
        self.record = MiniGameProxy.Instance:GetChallengeRecord(GameType)
      end
      if self.corrects > self.record then
        self.record = self.corrects
        self.recordCount.text = self.record
      end
    else
      self.wrongs = self.wrongs + 1
    end
    self:SetCorrectAnswer(note.body.answer)
    self.input.gameObject:SetActive(false)
    self.correctAnswer:SetActive(true)
    self.nextBtn:SetActive(true)
    self.comfirmButton:SetActive(false)
    self:PauseCountDown()
    if not self.challengeMode then
      self:UpdateRecord(lastreplystatus)
    else
      self:UpdateChallengeRecord()
    end
    self:ShowResultEffect(lastreplystatus)
  end
end

function MiniGameMonsterQAPage:UpdateRecord(lastreplystatus)
  for i = 1, self.maxCell do
    if self.recordData[i] == 0 then
      self.recordData[i] = lastreplystatus == MiniGameCmd_pb.ELASTREPLYSTATUS_RIGHT and 1 or -1
      break
    end
  end
  self.recordGridCtrl:ResetDatas(self.recordData)
end

function MiniGameMonsterQAPage:SetRecord()
  self.record = MiniGameProxy.Instance:GetChallengeRecord(GameType)
  self.recordCount.text = self.record
end

local left = 0

function MiniGameMonsterQAPage:UpdateChallengeRecord()
  self.totalcorrect.text = self.corrects
  left = self.tolerance - self.wrongs
  self.totalwrong.text = 0 < left and left or 0
end

function MiniGameMonsterQAPage:SetCorrectAnswer(answer)
  self.correctAnswerLabel.text = string.format(ZhString.MiniGame_CorrectAnswer, answer)
end

local itemCount, count

function MiniGameMonsterQAPage:HandleNextRound(note)
  itemCount = MiniGameProxy.Instance:GetItemList(GameType, SkipItemType) or {}
  count = 0
  for i = 1, #itemCount do
    count = count + itemCount[i].count
  end
  self.skipCount.text = string.format("X%d", count)
  itemCount = MiniGameProxy.Instance:GetItemList(GameType, AddTimeTtemType) or {}
  count = 0
  for i = 1, #itemCount do
    count = count + itemCount[i].effect
  end
  if 0 < count then
    self:PlayAddTimeEffect(count)
  end
end

function MiniGameMonsterQAPage:StartCountdown(gameTime)
  self.startTime = ServerTime.CurServerTime() / 1000
  self.endTime = self.startTime + gameTime
  leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
end

function MiniGameMonsterQAPage:UpdateCountDown()
  leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  self.countdown.text = string.format("%ss", math.ceil(leftTime))
  if leftTime <= 0 then
    self:ClearTick()
  end
end

function MiniGameMonsterQAPage:PauseCountDown()
  self:ClearTick()
end

local resultNote

function MiniGameMonsterQAPage:EndGame(note)
  MsgManager.ShowMsgByIDTable(40924)
  self:CloseSelf()
end

function MiniGameMonsterQAPage:ShowResult(result)
  local data = {}
  data.result = result and 1 or 2
  data.simply = true
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
  self:CloseSelf()
end

function MiniGameMonsterQAPage:ClearTick()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
  if not self.myAnswer then
    self.countdown.text = "0s"
  end
end

local body
local question = ""
local questparts, quest
local linkMap = {
  [MiniGameCmd_pb.EMONSTERANSWER_LINKSYMBOL_NONE] = "",
  [MiniGameCmd_pb.EMONSTERANSWER_LINKSYMBOL_AND] = ZhString.MiniGame_LinkAnd,
  [MiniGameCmd_pb.EMONSTERANSWER_LINKSYMBOL_OR] = ZhString.MiniGame_LinkOr
}
local resultMap = {
  [MiniGameCmd_pb.ELASTREPLYSTATUS_NONE] = nil,
  [MiniGameCmd_pb.ELASTREPLYSTATUS_ERROR] = EffectMap.UI.Eff_WrongAnswer,
  [MiniGameCmd_pb.ELASTREPLYSTATUS_RIGHT] = EffectMap.UI.Eff_CorrectAnswer
}
local questIndex = 0
local result = 1
local resultLT
local link = ""

function MiniGameMonsterQAPage:UpdateQuestion(note)
  if not self.inited then
    self:InitView()
    self.inited = true
    if self.challengeMode then
      self:SetRecord()
      self:UpdateChallengeRecord()
    end
  end
  if note and note.body then
    body = note.body
    self.myAnswer = nil
    self.input.value = ""
    self.input.gameObject:SetActive(true)
    self.correctAnswer:SetActive(false)
    self.nextBtn:SetActive(false)
    self.comfirmButton:SetActive(true)
    self.inputLabel.text = ZhString.MiniGame_InputTip
    self.inputLabel.color = grey
    if body.countdown then
      self:StartCountdown(body.countdown)
    end
    if body.linksymbol then
      link = linkMap[body.linksymbol] or ""
    end
    questparts = body.questparts
    question = ""
    for i = 1, #questparts do
      quest = questparts[i]
      sub = quest.subparam
      if quest.type then
        question = question .. QuestionConfig[quest.type][sub]
      end
      if i ~= #questparts then
        question = question .. link
      end
    end
    question = string.format(ZhString.MiniGame_Question, question)
    self.questionLabel.text = question
  end
end

function MiniGameMonsterQAPage:ShowResultEffect(lastreplystatus)
  if lastreplystatus and resultMap[lastreplystatus] then
    self:PlayUIEffect(resultMap[lastreplystatus], self.result, true)
  end
end

function MiniGameMonsterQAPage:OnEnter()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, false)
  MiniGameMonsterQAPage.super.OnEnter(self)
end

function MiniGameMonsterQAPage:OnExit()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, true)
  Game.DungeonManager:Shutdown()
  self:ClearTick()
  self:ResetCameraData()
  if self.scrollTick and self.scrollTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 2)
    self.scrollTick = nil
  end
  ServiceMiniGameCmdProxy.Instance:CallMiniGameReqOver(GameType)
end

function MiniGameMonsterQAPage:initCameraData()
  self.originFovMin = nil
  self.originFovMax = nil
  self.originAllowLowerThanFocus = nil
  if not self.cameraId then
    local currentMap = SceneProxy.Instance.currentScene
    if currentMap then
      self.cameraId = Table_Map[currentMap.mapID].Camera
    end
  end
  if not self.cameraId then
    self.cameraId = 1
  end
  self.cameraData = Table_Camera[self.cameraId]
  if not self.cameraData or not self.cameraController then
    return
  end
  self.originNearClipPlane = self.cameraController.activeCamera.nearClipPlane
  self.originFarClipPlane = self.cameraController.activeCamera.farClipPlane
  self.cameraController.activeCamera.nearClipPlane = self.cameraData.ClippingPlanes[1]
  self.cameraController.activeCamera.farClipPlane = self.cameraData.ClippingPlanes[2]
  self.originFovMin = Game.InputManager.cameraFieldOfViewMin
  self.originFovMax = Game.InputManager.cameraFieldOfViewMax
  self.fovMin = self.cameraData.Zoom[1]
  self.fovMax = self.cameraData.Zoom[2]
  self.fovMinValue = self:calFOVValue(self.fovMax)
  self.fovMaxValue = self:calFOVValue(self.fovMin)
  Game.InputManager.cameraFieldOfViewMin = self.fovMinValue
  Game.InputManager.cameraFieldOfViewMax = self.fovMaxValue
  self.originFieldOfView = Camera.main.fieldOfView
end

function MiniGameMonsterQAPage:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end

function MiniGameMonsterQAPage:ResetCameraData()
  Game.InputManager.model = InputManager.Model.DEFAULT
  if nil ~= self.cameraController then
    if self.originNearClipPlane then
      self.cameraController.activeCamera.nearClipPlane = self.originNearClipPlane
      self.cameraController.activeCamera.farClipPlane = self.originFarClipPlane
    end
    if self.originFieldOfView then
      self.cameraController:ResetFieldOfView(self.originFieldOfView)
    end
  end
  if self.originFovMax then
    Game.InputManager.cameraFieldOfViewMin = self.originFovMin
    Game.InputManager.cameraFieldOfViewMax = self.originFovMax
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end
