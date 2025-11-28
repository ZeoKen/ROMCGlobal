autoImport("TimeTickManager")
autoImport("QuestMini1Point")
autoImport("QuestMini1Line")
autoImport("QuestMini1StillPoint")
QuestMiniGame1Panel = class("QuestMiniGame1Panel", BaseView)
QuestMiniGame1Panel.ViewType = UIViewType.NormalLayer
local pointPfb = "QuestMini1Point"
local linePfb = "QuestMini1Line"
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local isRunOnStandalone = Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.OSXPlayer
local screenWidth, screenHeight, tickInstance
local pointVaild, lineVaild = 50, 60
pointVaild = pointVaild * Screen.width / 1280
lineVaild = lineVaild * Screen.width / 1280

function QuestMiniGame1Panel:Init()
  tickInstance = TimeTickManager.Me()
  self.title = self:FindComponent("title", UILabel)
  self.container = self:FindGO("container")
  self.effectContainer = self:FindGO("effectContainer")
  self.closeBtn = self:FindGO("CloseButton")
end

function QuestMiniGame1Panel:OnEnter()
  QuestMiniGame1Panel.super.OnEnter(self)
  screenWidth, screenHeight = NGUITools.screenSize.x, NGUITools.screenSize.y
  if 1.7777777777777777 < screenWidth / screenHeight then
    screenWidth = screenHeight / 9 * 16
  else
    screenHeight = screenWidth / 16 * 9
  end
  Game.GUISystemManager:AddMonoLateUpdateFunction(self.LateUpdate, self)
  self:ShowUI()
end

function QuestMiniGame1Panel:OnExit()
  Game.GUISystemManager:ClearMonoLateUpdateFunction(self)
  if self.stillPoint then
    self.stillPoint:Destroy()
    self.stillPoint = nil
  end
  self:RemoveAllTick()
  QuestMiniGame1Panel.super.OnExit(self)
end

function QuestMiniGame1Panel:ShowUI()
  self:RemoveTimeoutTick()
  self.questData = self.viewdata.viewdata
  self.Params = self.questData.params
  if self.Params then
    self:ParseStep(self.Params)
    self.title.text = self.opType == "drag" and ZhString.QuestMiniGame1_for_drag or ZhString.QuestMiniGame1_for_click
  end
end

function QuestMiniGame1Panel:ParseStep(Params)
  self.container:SetActive(true)
  self.time = Params and Params.qteTime / 1000
  self.opType = Params and Params.qteType
  self.usePrecent = Params and Params.qteUsePrecent or 0
  self.posIndex = 0
  if self.opType == "click" then
    self.pos = Params.qtePos and LuaVector2(screenWidth * Params.qtePos[1] / 100 + NGUITools.screenSize.x / 2, screenHeight * Params.qtePos[2] / 100 + NGUITools.screenSize.y / 2)
  elseif self.opType == "drag" then
    if not self.posList then
      self.posList = {}
    else
      TableUtility.ArrayClear(self.posList)
    end
    for i = 2, #Params.qtePos, 2 do
      TableUtility.ArrayPushBack(self.posList, LuaVector2(screenWidth * Params.qtePos[i - 1] / 100 + NGUITools.screenSize.x / 2, screenHeight * Params.qtePos[i] / 100 + NGUITools.screenSize.y / 2))
    end
    self.progress = 0
  elseif self.opType == "stillclick" then
    self.stillPoint = QuestMini1StillPoint.Create(self.gameObject)
    self.stillPoint:AddEventListener(MouseEvent.MouseClick, self.ClickStillPoint, self)
    self.stillPoint:AddEventListener(QuestMini1StillPoint.ClickBackground, self.ClickStillBackground, self)
    self.stillPoint:SetProgress(0, self.Params.qteNumber)
    self.stillPoint:PlayMarkEffect(true)
    self.stillPoint:SetPos(self.Params.qtePos[1], self.Params.qtePos[2], 0)
  end
  self:DrawStep()
end

function QuestMiniGame1Panel:ClickStillPoint()
  if self.stillClickFinish then
    return
  end
  if not self.stillClickCount then
    self.stillClickCount = 1
  else
    self.stillClickCount = self.stillClickCount + 1
  end
  self.stillPoint:SetProgress(self.stillClickCount, self.Params.qteNumber)
  if self.stillClickCount == self.Params.qteNumber then
    self.stillClickFinish = true
    self:SubmitResult(true)
  end
end

function QuestMiniGame1Panel:ClickStillBackground()
  self.stillClickFinish = true
  self:SubmitResult(false)
end

function QuestMiniGame1Panel:DrawStep()
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return
  end
  if not self.pointList then
    self.pointList = {}
  else
    TableUtility.ArrayClear(self.pointList)
  end
  if not self.lineList then
    self.lineList = {}
  else
    TableUtility.ArrayClear(self.lineList)
  end
  if self.opType == "click" then
    local pointpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(pointPfb))
    pointpfb.transform:SetParent(self.container.transform, false)
    pointpfb.transform.position = uiCamera:ScreenToWorldPoint(LuaGeometry.GetTempVector3(self.pos.x, self.pos.y, 0))
    local point = QuestMini1Point.new(pointpfb)
    point:SetText("")
    point:SetEffectContainer(self.effectContainer)
    TableUtility.ArrayPushBack(self.pointList, point)
  elseif self.opType == "drag" then
    for i = 1, #self.posList do
      local pointpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(pointPfb))
      pointpfb.transform:SetParent(self.container.transform, false)
      pointpfb.transform.position = uiCamera:ScreenToWorldPoint(LuaGeometry.GetTempVector3(self.posList[i].x, self.posList[i].y, 0))
      local point = QuestMini1Point.new(pointpfb)
      point:SetText(i)
      point:SetEffectContainer(self.effectContainer)
      TableUtility.ArrayPushBack(self.pointList, point)
    end
    for i = 1, #self.pointList - 1 do
      local linepfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(linePfb))
      linepfb.transform:SetParent(self.container.transform, false)
      local line = QuestMini1Line.new(linepfb)
      line:SetLine(self.pointList[i].gameObject.transform.localPosition, self.pointList[i + 1].gameObject.transform.localPosition, i)
      TableUtility.ArrayPushBack(self.lineList, line)
    end
  end
  self:MarkPoint(1)
  tickInstance:ClearTick(self)
  tickInstance:CreateTickFromTo(0, 1, 0, self.time * 1000, function(owner, deltaTime, curValue)
    if self.pointList and #self.pointList > 0 then
      for i = 1, #self.pointList do
        self.pointList[i]:SetTimeOut(curValue)
      end
    elseif self.stillPoint then
      self.stillPoint:SetTimeOut(curValue)
    end
  end, self, 1):SetCompleteFunc(function(owner, id)
    self.stillClickFinish = true
    self:SubmitResult(false)
  end)
end

function QuestMiniGame1Panel:MarkPoint(idx)
  for i = 1, #self.pointList do
    self.pointList[i]:PlayMarkEffect(false)
  end
  idx = idx or self.posIndex + 1
  if self.pointList and self.pointList[idx] then
    self.pointList[idx]:PlayMarkEffect(true)
  end
end

function QuestMiniGame1Panel:ResultPoint(result, idx)
  idx = idx or self.posIndex
  if not idx then
    return
  end
  idx = result and idx or idx + 1
  if self.pointList and self.pointList[idx] then
    self.pointList[idx]:PlayResultEffect(result, idx)
  end
  if self.stillPoint then
    self.stillPoint:PlayResultEffect(result)
  end
end

function QuestMiniGame1Panel:LateUpdate()
  if not self.opType then
    return
  end
  if isRunOnStandalone or isRunOnEditor then
    local touchPos = LuaVector2(Input.mousePosition.x, Input.mousePosition.y)
    if self.opType == "drag" then
      if Input.GetMouseButtonDown(0) then
        if LuaVector2.Magnitude(touchPos - self.posList[1]) > lineVaild then
          self:SubmitResult(false)
          return
        else
          self.posIndex = 1
          self:MarkPoint()
          self:ResultPoint(true)
        end
      end
      if Input.GetMouseButtonUp(0) and 0 < self.posIndex then
        if LuaVector2.Magnitude(touchPos - self.posList[#self.posList]) > lineVaild or self.posIndex < #self.posList then
          self:SubmitResult(false)
          return
        else
          self:SubmitResult(true)
          return
        end
      end
      if Input.GetMouseButton(0) and 0 < self.posIndex then
        local checkdis, enddis, progress = self:LineRangeDistance(self.posList[self.posIndex], self.posList[math.min(self.posIndex + 1, #self.posList)], touchPos)
        self.progress = math.max(self.progress, progress)
        local curLine = self.lineList[self.posIndex]
        if curLine then
          curLine:SetProgress(self.progress)
        end
        if checkdis > lineVaild then
          self:SubmitResult(false)
          return
        elseif enddis < lineVaild then
          if curLine then
            curLine:SetProgress(1)
          end
          self.progress = 0
          self.posIndex = self.posIndex + 1
          if self.posIndex >= #self.posList then
            self:SubmitResult(true)
            return
          else
            self:MarkPoint()
            self:ResultPoint(true)
          end
        end
      end
    elseif self.opType == "click" and Input.GetMouseButtonDown(0) then
      if LuaVector2.Magnitude(touchPos - self.pos) > pointVaild then
        self:SubmitResult(false)
        return
      else
        self.posIndex = 1
        self:SubmitResult(true)
        return
      end
    end
    return
  end
  if 0 < Input.touchCount then
    local touch = Input.GetTouch(0)
    local touchPhase, touchPos = touch.phase, touch.position
    if self.opType == "drag" then
      if touchPhase == TouchPhase.Began then
        if LuaVector2.Magnitude(touchPos - self.posList[1]) > lineVaild then
          self:SubmitResult(false)
          return
        else
          self.posIndex = 1
          self:MarkPoint()
          self:ResultPoint(true)
        end
      elseif (touchPhase == TouchPhase.Ended or touchPhase == TouchPhase.Cancelled) and 0 < self.posIndex then
        if LuaVector2.Magnitude(touchPos - self.posList[#self.posList]) > lineVaild or self.posIndex < #self.posList then
          self:SubmitResult(false)
          return
        else
          self:SubmitResult(true)
          return
        end
      elseif touchPhase == TouchPhase.Moved and 0 < self.posIndex then
        local checkdis, enddis, progress = self:LineRangeDistance(self.posList[self.posIndex], self.posList[math.min(self.posIndex + 1, #self.posList)], touchPos)
        self.progress = math.max(self.progress, progress)
        local curLine = self.lineList[self.posIndex]
        if curLine then
          curLine:SetProgress(self.progress)
        end
        if checkdis > lineVaild then
          self:SubmitResult(false)
          return
        elseif enddis < lineVaild then
          if curLine then
            curLine:SetProgress(1)
          end
          self.progress = 0
          self.posIndex = self.posIndex + 1
          if self.posIndex >= #self.posList then
            self:SubmitResult(true)
            return
          else
            self:MarkPoint()
            self:ResultPoint(true)
          end
        end
      end
    elseif self.opType == "click" and touchPhase == TouchPhase.Began then
      if LuaVector2.Magnitude(touchPos - self.pos) > pointVaild then
        self:SubmitResult(false)
        return
      else
        self.posIndex = 1
        self:SubmitResult(true)
        return
      end
    end
  end
end

function QuestMiniGame1Panel:CloseSelf()
  self.closeBtn:SetActive(false)
  if self.opType ~= nil then
    self:EndGame(false)
    self:DoSubmitResult()
  end
  self.cancel_quit = true
  self:RemoveAllTick()
  self:ClearAllWidgets()
  self.super.CloseSelf(self)
end

function QuestMiniGame1Panel:SubmitResult(result)
  if self.cancel_quit then
    return
  end
  self.closeBtn:SetActive(false)
  self:ResultPoint(result)
  self:EndGame(result)
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:DoSubmitResult()
    self:RemoveAllTick()
    if not self.result or self.Params.qteEnd == 1 then
      self.super.CloseSelf(self)
    end
  end, self, 2)
end

function QuestMiniGame1Panel:EndGame(result)
  self.result = result
  self.opType = nil
  self:RemoveTimeoutTick()
  self.container:SetActive(false)
end

function QuestMiniGame1Panel:DoSubmitResult()
  if self.result then
    if self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FinishJump then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
    else
      redlog("qte小游戏：任务数据有误")
    end
  elseif self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FailJump then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
  else
    redlog("qte小游戏：任务数据有误")
  end
end

local vec1, vec2, vec3 = LuaVector2.Zero(), LuaVector2.Zero(), LuaVector2.Zero()

function QuestMiniGame1Panel:LineRangeDistance(p1, p2, p)
  LuaVector2.Better_Sub(p1, p, vec1)
  LuaVector2.Better_Sub(p2, p, vec2)
  LuaVector2.Better_Sub(p1, p2, vec3)
  local p1Dis = LuaVector2.Magnitude(vec1)
  local p2Dis = LuaVector2.Magnitude(vec2)
  local len = LuaVector2.Magnitude(vec3)
  local lDis = math.abs((vec1[1] * vec2[2] - vec1[2] * vec2[1]) / len / 2)
  LuaVector2.Better_Sub(p2, p1, vec3)
  local prog = LuaVector2.Dot(-vec1, vec3) / len / len
  return math.min(math.min(p1Dis, p2Dis), lDis), p2Dis, prog
end

function QuestMiniGame1Panel:RemoveTimeoutTick()
  tickInstance:ClearTick(self, 1)
end

function QuestMiniGame1Panel:RemoveAllTick()
  tickInstance:ClearTick(self)
end

function QuestMiniGame1Panel:ClearAllWidgets()
  if self.pointList then
    for i = 1, #self.pointList do
      self.pointList[i]:DestroyEffects()
      GameObject.DestroyImmediate(self.pointList[i].gameObject)
    end
    TableUtility.ArrayClear(self.pointList)
  end
  if self.lineList then
    for i = 1, #self.lineList do
      self.lineList[i]:DestroyEffects()
      GameObject.DestroyImmediate(self.lineList[i].gameObject)
    end
    TableUtility.ArrayClear(self.lineList)
  end
end
