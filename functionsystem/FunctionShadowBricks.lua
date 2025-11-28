autoImport("BricksModel")
FunctionShadowBricks = class("FunctionShadowBricks", EventDispatcher)
local _prefix = "ShadowPuzzle_"
local _systemPos = {
  [1] = {0, 0},
  [2] = {0, 1},
  [3] = {0, 2},
  [4] = {1, 0},
  [5] = {1, 1},
  [6] = {1, 2},
  [7] = {2, 0},
  [8] = {2, 1},
  [9] = {2, 2}
}
local _power = 3

function FunctionShadowBricks.RowColumn2Pos(row, column)
  return row * _power + column + 1
end

function FunctionShadowBricks.Slot2RowColumn(slot)
  return _systemPos[slot]
end

local _brickMoveSpeed, _row, _column
local _tempV3 = LuaVector3()
local _tempV2 = LuaVector2()
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _InitBricksSlotPriority = {
  5,
  4,
  6,
  8
}
local _Top_UnitMove = -3
local _Down_UnitMove = 3
local _Left_UnitMove = -1
local _Right_UnitMove = 1
local _TopPos = {
  [1] = 1,
  [2] = 1,
  [3] = 1
}
local _DownPos = {
  [7] = 1,
  [8] = 1,
  [9] = 1
}
local _LeftPos = {
  [1] = 1,
  [4] = 1,
  [7] = 1
}
local _RightPos = {
  [3] = 1,
  [6] = 1,
  [9] = 1
}
local _SystemPos = {
  [1] = {0, 0},
  [2] = {0, 1},
  [3] = {0, 2},
  [4] = {1, 0},
  [5] = {1, 1},
  [6] = {1, 2},
  [7] = {2, 0},
  [8] = {2, 1},
  [9] = {2, 2}
}
local _CameraPointManager
FunctionShadowBricks.UnitMove = {
  [1] = _Top_UnitMove,
  [2] = _Down_UnitMove,
  [3] = _Left_UnitMove,
  [4] = _Right_UnitMove
}
FunctionShadowBricks.DirPosConfig = {
  [1] = _TopPos,
  [2] = _DownPos,
  [3] = _LeftPos,
  [4] = _RightPos
}
local _CompleteSec = GameConfig.Bricks and GameConfig.Bricks.completeSecond or 0.3
local _DefaultFadeTime = 2
local _config_lightDir = GameConfig.Bricks and GameConfig.Bricks.lightDirBaseOnColume
local _GuideConfig = GameConfig.Bricks and GameConfig.Bricks.guide
FunctionShadowBricks.GuideType = {
  chooseBrick = 1,
  move = 2,
  modelRotate = 3,
  uiRotate = 4,
  progress = 5
}
local _guideStep_chooseBrick = function(content, param)
  FunctionShadowBricks.Me():SetWaitChooseBrick(content, param)
end
local _guideStep_move = function(content, param)
  FunctionShadowBricks.Me():SetWaitMoveDir(content, param)
end
local _guideStep_model_rotate = function(content)
  FunctionShadowBricks.Me():SetWaitModelRotation(content, param)
end
local _guideStep_ui_rotate = function(content, param)
  FunctionShadowBricks.Me():SetWaitUIRotation(content, param)
end
local _guideStep_Progress = function(content)
  FunctionShadowBricks.Me():SetWaitProgress(content)
end
local _guideStep_func = {
  chooseBrick = _guideStep_chooseBrick,
  move = _guideStep_move,
  modelRotate = _guideStep_model_rotate,
  uiRotate = _guideStep_ui_rotate,
  progress = _guideStep_Progress
}

function FunctionShadowBricks.Me()
  if nil == FunctionShadowBricks.me then
    FunctionShadowBricks.me = FunctionShadowBricks.new()
  end
  return FunctionShadowBricks.me
end

function FunctionShadowBricks:ctor()
  self:Init()
end

function FunctionShadowBricks:Init()
  self.brickMap = {}
  self.doneBrickSlotMap = {}
  self.curRaidID = nil
  self.curBrick = nil
  self.done = false
  _brickMoveSpeed = GameConfig.Bricks and GameConfig.Bricks.moveSpeed or 8
  _CameraPointManager = CameraPointManager.Instance
  self.guideConfig = nil
  self.guideStep = 0
end

function FunctionShadowBricks:Launch(raidID, questData)
  if not questData then
    return
  end
  if not raidID then
    return
  end
  if self.curRaidID ~= raidID then
    helplog("diff imageRaidId | oldImageID : ", raidID, self.curRaidID)
    self:ShutDown()
  end
  self.questData = questData
  if _GuideConfig and _GuideConfig[raidID] then
    self.guideConfig = _GuideConfig[raidID]
  end
  if self.inited then
    self:Restore()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LightShadowView
    })
    return
  end
  self.curRaidID = raidID
  local configInitSuccess = self:_initConfig()
  if not configInitSuccess then
    return
  end
  local systemInitSuccess = self:_initSystem()
  if not systemInitSuccess then
    return
  end
  self.shadowPuzzleSystem:ShowLightEffect()
  self:_initSlots()
  self:_initLight()
  self:_initOthers()
  self:_initAnswer()
  self.inited = true
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.LightShadowView
  })
  self:CameraOnView()
end

function FunctionShadowBricks:SetQuestFinishCallback(func)
  self.finishCallback = func
end

function FunctionShadowBricks:TryNtfFinishQuest()
  if self.finishCallback then
    self.finishCallback()
  end
end

function FunctionShadowBricks:GetGuideConfig()
  return self.guideConfig
end

function FunctionShadowBricks:GuideBegin()
  if not self.guideConfig then
    return
  end
  if self.guideFinished then
    return
  end
  self:InitGuide()
  self:GuideStepUpdate()
end

function FunctionShadowBricks:OnGuideStepSuccess()
  self.guideStep = self.guideStep + 1
  if nil == self.guideConfig[self.guideStep] then
    self:GuideEnd()
    return
  end
  self:GuideStepUpdate()
end

function FunctionShadowBricks:SetWaitChooseBrick(content, brick_index)
  self.guideType = FunctionShadowBricks.GuideType.chooseBrick
  self.guideContent = content
  local bricks = self:GetBrickList()
  self.waitChooseBrickId = bricks[brick_index].ID
end

function FunctionShadowBricks:SetWaitMoveDir(content, dir)
  self.guideType = FunctionShadowBricks.GuideType.move
  self.guideContent = content
  self.waitMoveDir = dir
end

function FunctionShadowBricks:SetWaitModelRotation(content)
  self.guideType = FunctionShadowBricks.GuideType.modelRotate
  self.guideContent = content
end

function FunctionShadowBricks:SetWaitUIRotation(content, press_time)
  self.guideType = FunctionShadowBricks.GuideType.uiRotate
  self.guideContent = content
  self.pressRotateTime = press_time or 1
end

function FunctionShadowBricks:SetWaitProgress(content)
  self.guideType = FunctionShadowBricks.GuideType.progress
  self.guideContent = content
end

function FunctionShadowBricks:GuideStepUpdate()
  if not self.guideConfig then
    return
  end
  if not self.guideStep or self.guideStep < 0 or self.guideStep > #self.guideConfig then
    return
  end
  local stepConfig = self.guideConfig[self.guideStep]
  local stepFunc = stepConfig and stepConfig.type and _guideStep_func[stepConfig.type]
  if stepFunc then
    stepFunc(stepConfig.content, stepConfig.param)
    EventManager.Me():PassEvent(LightShadowEvent.GuideStepUpdate)
  end
end

function FunctionShadowBricks:GetGuideStep()
  return self.guideStep
end

function FunctionShadowBricks:IsLastGuideStep()
  return self.guideStep == #self.guideConfig
end

function FunctionShadowBricks:GuideEnd()
  if not self:InGuide() then
    return
  end
  self.guideFinished = true
  self:ClearGuide()
end

function FunctionShadowBricks:GetInitializedBrickSlot()
  for i = 1, #_InitBricksSlotPriority do
    local slot = _InitBricksSlotPriority[i]
    if not self:IsBrickDone(slot) then
      return slot
    end
  end
end

function FunctionShadowBricks:_initSystem()
  self.shadowPuzzleSystem = Game.GameObjectManagers[Game.GameObjectType.ShadowPuzzle]:GetShadowPuzzle()
  if nil == self.shadowPuzzleSystem then
    return false
  end
  self.shadowPuzzleSystem.completeEpsilon = self.config.CompleteEpsilon or 75
  return true
end

function FunctionShadowBricks:GetGlobalDisplayEpsilon()
  return self.config.DisplayProgressEpsilon
end

function FunctionShadowBricks:GetGlobalCompleteEpsilon()
  return self.shadowPuzzleSystem.completeEpsilon
end

function FunctionShadowBricks:_initConfig()
  helplog("_initConfig raidID: ", self.curRaidID)
  local configname = _prefix .. tostring(self.curRaidID)
  self.config = autoImport(configname)
  if not self.config then
    redlog("-------光影系统 未找到配置表，ShadowPuzzle_后缀： ", self.curRaidID)
    return false
  end
  return true
end

function FunctionShadowBricks:NotifyQuestStep()
  self:CameraOnDone()
  QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
  self.done = true
end

function FunctionShadowBricks:_initSlots()
  local configSlots = self.config.Slots
  if not configSlots then
    redlog("-------光影系统 未找到配置Slots字段,ShadowPuzzle后缀ID： ", self.curRaidID)
    return
  end
  for i = 1, #configSlots do
    LuaVector3.Better_Set(_tempV3, configSlots[i][1], configSlots[i][2], configSlots[i][3])
    _row, _column = _systemPos[i][1], _systemPos[i][2]
    self.shadowPuzzleSystem:AddSlot(_tempV3, _row, _column)
  end
  self.slots = configSlots
  helplog("-------光影系统 加载位置")
end

function FunctionShadowBricks:_initLight()
  local configLights = self.config.Lights
  if not configLights then
    redlog("-------光影系统 未找到配置Lights字段,ShadowPuzzle后缀ID： ", self.curRaidID)
    return
  end
  for i = 1, #configLights do
    LuaVector3.Better_Set(_tempV3, configLights[i][1], configLights[i][2], configLights[i][3])
    self.shadowPuzzleSystem:AddLight(_tempV3, i - 1)
  end
  helplog("-------光影系统 加载灯光")
end

function FunctionShadowBricks:_initOthers()
  local outlineColor = self.config.OutlineColor
  if outlineColor then
    self.shadowPuzzleSystem.outlineColor = Color(outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4])
  end
  local shadowColor = self.config.ShadowColor
  if shadowColor then
    self.shadowPuzzleSystem.shadowColor = Color(shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4])
  end
  if nil ~= self.config.OverrideOutline then
    self.shadowPuzzleSystem.overrideOutline = self.config.OverrideOutline
    if self.config.OverrideOutline == true then
      local outlineWidth = self.config.OverrideOutlineWidth
      if outlineWidth then
        self.shadowPuzzleSystem.overrideOutlineWidth = outlineWidth
      end
      local outlineAngle = self.config.OverrideOutlineAngle
      if outlineAngle then
        self.shadowPuzzleSystem.overrideOutlineAngle = outlineAngle
      end
    end
  end
end

function FunctionShadowBricks:_initAnswer()
  local configAnswer = self.config.Answer
  if not configAnswer then
    redlog("-------光影系统 未找到配置Answer字段,ShadowPuzzle后缀ID： ", self.curRaidID)
    return
  end
  for i = 1, #configAnswer do
    self:AddBricks(configAnswer[i], i)
  end
  helplog("-------光影系统 初始化Answer")
end

function FunctionShadowBricks:AddBricks(answer_config, sortID)
  local modelData = BricksModel.new(answer_config, sortID)
  self.brickMap[modelData.ID] = modelData
  return modelData
end

function FunctionShadowBricks:Restore()
  self.shadowPuzzleSystem:ShowLightEffect()
  if not self.brickMap then
    return
  end
  for k, v in pairs(self.brickMap) do
    v:Restore()
  end
  self:CameraOnView()
end

function FunctionShadowBricks:AllBrickFadeOut()
  for k, v in pairs(self.brickMap) do
    v:FadeOut()
  end
end

function FunctionShadowBricks:GetBrickList()
  if not self.brickList then
    self.brickList = {}
    for _, data in pairs(self.brickMap) do
      _ArrayPushBack(self.brickList, data)
    end
  end
  return self.brickList
end

function FunctionShadowBricks:OnImageMapChanged()
  if not self.curRaidID then
    return
  end
  local imageRaidId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if imageRaidId ~= self.curRaidID then
    self:ShutDown()
  end
end

function FunctionShadowBricks:ShutDown()
  if not self.inited then
    return
  end
  self.shadowPuzzleSystem:Shutdown()
  for id, modelData in pairs(self.brickMap) do
    modelData:OnClear()
  end
  _TableClear(self.brickMap)
  _ArrayClear(self.brickList)
  _TableClear(self.doneBrickSlotMap)
  self.curBrick = nil
  self.curRaidID = nil
  self.curSlot = nil
  self.questData = nil
  helplog("-----shadowPuzzleSystem System ShutDown")
  self.inited = false
  self.done = false
  self.brickList = nil
  self.uimodelShadowObj = nil
  self:RemoveTick()
  self:ClearGuide()
end

function FunctionShadowBricks:InitGuide()
  self.guideRunning = true
  self.guideStep = 1
end

function FunctionShadowBricks:InGuide()
  return self.guideRunning == true
end

function FunctionShadowBricks:InProgressGuide()
  return self:InGuide() and self.guideType == FunctionShadowBricks.GuideType.progress
end

function FunctionShadowBricks:InUIRotateGuide()
  return self:InGuide() and self.guideType == FunctionShadowBricks.GuideType.uiRotate
end

function FunctionShadowBricks:InModelRotateGuide()
  return self:InGuide() and self.guideType == FunctionShadowBricks.GuideType.modelRotate
end

function FunctionShadowBricks:InMoveGuide()
  return self:InGuide() and self.guideType == FunctionShadowBricks.GuideType.move
end

function FunctionShadowBricks:InChooseGuide()
  return self:InGuide() and self.guideType == FunctionShadowBricks.GuideType.chooseBrick
end

function FunctionShadowBricks:ClearGuide()
  self.guideRunning = false
  self.guideConfig = nil
  self.guideStep = 0
  self.guideType = nil
  self.guideContent = nil
  self.waitChooseBrickId = nil
  self.waitMoveDir = nil
end

function FunctionShadowBricks:Exit()
  for _, data in pairs(self.brickMap) do
    data:OnExit()
  end
  self.shadowPuzzleSystem:HideLightEffect()
  self:CameraOnReset()
  self:ClearGuide()
  if not self.done and self.questData then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
  end
end

function FunctionShadowBricks:MoveBegin(dir)
  if self.done then
    return
  end
  if self.isLerping then
    return
  end
  local cur = self.curSlot
  local newSlot
  local unitMove = FunctionShadowBricks.UnitMove[dir]
  if self:IsBrickDone(cur + unitMove) then
    newSlot = cur + unitMove * 2
  else
    newSlot = cur + unitMove
  end
  self:SetCurSlot(newSlot)
  EventManager.Me():PassEvent(LightShadowEvent.PosChanged, newSlot)
end

function FunctionShadowBricks:SetCurSlot(s)
  if s and s ~= self.curSlot then
    self.curSlot = s
  end
end

function FunctionShadowBricks:DoMove(targetPos)
  local row_column = _systemPos[targetPos]
  if not row_column then
    return
  end
  _row, _column = row_column[1], row_column[2]
  if not self.shadowPuzzleSystem then
    return
  end
  if not self.curBrick then
    return
  end
  if self.curBrick.done then
    return
  end
  local curShadow = self.curBrick:GetShadow()
  if not curShadow then
    return
  end
  self.shadowPuzzleSystem:StartMoveTarget(curShadow, _row, _column, _brickMoveSpeed, function(puzzleShadow)
    self:OnMoveEnd()
  end)
end

function FunctionShadowBricks:OnMoveEnd()
  self:DoCheck()
end

function FunctionShadowBricks:DoRotate(x, y, model)
  local curShadow = self.curBrick:GetShadow()
  if not curShadow then
    return
  end
  if self.curBrick.done then
    return
  end
  LuaVector2.Better_Set(_tempV2, x, y)
  self.shadowPuzzleSystem:RotateTarget(curShadow, _tempV2, model)
  self:DoCheck()
end

function FunctionShadowBricks:CheckOptionInValid()
  if not (not self.done and not self.isLerping and self.shadowPuzzleSystem) or self.enterViewMoving then
    return true
  end
  return false
end

function FunctionShadowBricks:DoRotateTargetAroundNormal(delta, model)
  if self:CheckOptionInValid() then
    return
  end
  local curShadow = self.curBrick:GetShadow()
  if not curShadow then
    return
  end
  if self.curBrick.done then
    return
  end
  self.shadowPuzzleSystem:RotateTargetAroundNormal(curShadow, delta, model)
  self:DoCheck()
end

function FunctionShadowBricks:DoPickBrick(id, slot, isAuto)
  _row, _column = _systemPos[slot][1], _systemPos[slot][2]
  local brick = self.brickMap[id]
  if nil ~= self.curBrick then
    self.curBrick:OnHide()
  end
  self.curBrick = brick
  self.curBrick:OnShow(_row, _column, isAuto)
  self.shadowPuzzleSystem:SetActiveUITarget(self.uimodelShadowObj, self.curBrick:GetShadow())
  return self.curBrick
end

function FunctionShadowBricks:DoCheck()
  if not self.shadowPuzzleSystem then
    return
  end
  if not self.curBrick then
    return
  end
  if self.curBrick.done then
    return
  end
  local curShadow = self.curBrick:GetShadow()
  if not curShadow then
    return
  end
  local curOutline = self.curBrick:GetOutline()
  if not curOutline then
    return
  end
  local displayEpsilon = self.curBrick.realDisplayEpsilon
  local completeEpsilon = self.curBrick.realCompleteEpsilon
  local isSuccess, forwardAngle, rightAngle, cellCorrect = self.shadowPuzzleSystem:CheckComplete(curShadow, curOutline)
  local angel = math.max(forwardAngle, rightAngle)
  if cellCorrect and displayEpsilon > angel then
    local percent = (displayEpsilon - angel) / (displayEpsilon - completeEpsilon)
    percent = math.floor(percent * 100)
    EventManager.Me():PassEvent(LightShadowEvent.DisplayProgress, percent)
    if not self.firstInProgress then
      self.firstInProgress = true
      EventManager.Me():PassEvent(LightShadowEvent.FirstInPrpgress)
      return
    end
  else
    EventManager.Me():PassEvent(LightShadowEvent.DisplayProgress, 0)
  end
  if isSuccess == 1 then
    self.completeTick = TimeTickManager.Me():CreateTick(0, 100, function()
      if self.completeStartTime then
        if UnityRealtimeSinceStartup - self.completeStartTime > _CompleteSec then
          self:BrickSuccess()
          self:RemoveTick()
        end
      else
        self.completeStartTime = UnityRealtimeSinceStartup
      end
    end, self)
  else
    self:RemoveTick()
  end
end

function FunctionShadowBricks:SetUIModelShadowObj(shadowPuzzleObject)
  self.uimodelShadowObj = shadowPuzzleObject
end

function FunctionShadowBricks:BrickSuccess()
  self.curBrick:OnSuccess()
  local slot = self.curBrick.targetSlotIndex
  self.doneBrickSlotMap[slot] = 1
  EventManager.Me():PassEvent(LightShadowEvent.SingleBrickSuccess)
  self.isLerping = true
  local curShadow = self.curBrick:GetShadow()
  local curOutline = self.curBrick:GetOutline()
  local targetRotation = curOutline.transform.rotation
  curShadow:StartRotateTo(targetRotation, 2, function()
    self:_LerpCallback()
  end)
  if self.uimodelShadowObj then
    self.uimodelShadowObj:StartRotateTo(targetRotation, 2, nil)
  end
end

function FunctionShadowBricks:_LerpCallback()
  local evtStr = self:IsAllBrickDone() and LightShadowEvent.BricksAllFinished or LightShadowEvent.BricksStepFinished
  EventManager.Me():PassEvent(evtStr)
  self.isLerping = false
end

function FunctionShadowBricks:RemoveTick()
  self.completeStartTime = nil
  if self.completeTick then
    TimeTickManager.Me():ClearTick(self)
    self.completeTick = nil
  end
end

function FunctionShadowBricks:IsBrickDone(s)
  return 0 < s and nil ~= self.doneBrickSlotMap[s]
end

function FunctionShadowBricks:IsAllBrickDone()
  for _, v in pairs(self.brickMap) do
    if not v.done then
      return false
    end
  end
  return true
end

function FunctionShadowBricks:GetSystem()
  return self.shadowPuzzleSystem
end

function FunctionShadowBricks:GetSystemRotation()
  return self.shadowPuzzleSystem and self.shadowPuzzleSystem.transform.rotation
end

function FunctionShadowBricks:GetConfig()
  return self.config
end

function FunctionShadowBricks:GetSlotByIndex(i)
  if not self.slots then
    return
  end
  local slotLength = #self.slots
  if i and i <= slotLength and 0 < i then
    return self.slots[i]
  end
end

function FunctionShadowBricks:GetTextureInfo()
  local config = self.config
  if config then
    return config.TexturePath, config.TextureOffset, config.TextureSize
  end
end

function FunctionShadowBricks:CameraOnView()
  if not _CameraPointManager then
    return
  end
  Game.AreaTriggerManager:SetIgnore(false)
  _CameraPointManager:DisableGroup(0)
  _CameraPointManager:EnableGroup(1)
end

function FunctionShadowBricks:CameraOnDone()
  if not _CameraPointManager then
    return
  end
  _CameraPointManager:DisableGroup(1)
  _CameraPointManager:EnableGroup(0)
end

function FunctionShadowBricks:CameraOnReset()
  if not _CameraPointManager then
    return
  end
  _CameraPointManager:DisableGroup(0)
  _CameraPointManager:DisableGroup(1)
  if CameraController.singletonInstance then
    CameraController.singletonInstance:RestoreDefault(0, nil)
  end
  Game.AreaTriggerManager:SetIgnore(true)
end

function FunctionShadowBricks:TryPlayAppearanceAni(puzzleShadow, fadeIn)
  if self.enterViewMoving then
    return
  end
  if not puzzleShadow then
    return
  end
  if fadeIn then
    puzzleShadow:FadeIn(_DefaultFadeTime)
  else
    puzzleShadow:FadeOut(_DefaultFadeTime)
  end
end
