NewCreateRoleAnimationCtrl = class("NewCreateRoleAnimationCtrl", CoreView)
NewCreateRoleAnimationCtrlEvent = {
  AnimStart = "NewCreateRoleAnimationCtrlEvent_AnimStart",
  AnimEnd = "NewCreateRoleAnimationCtrlEvent_AnimEnd"
}
local tempV3 = LuaVector3()
local semiPointNames = {
  "A1",
  "A2",
  "B1",
  "B2",
  "C1",
  "C2",
  "C3",
  "D1",
  "D2"
}
local animPointNames = {
  "P",
  "A",
  "B",
  "C",
  "D"
}
local oriPoint = "P"
local hideBirdPointNames = {"A1", "A2"}
local cameraAnimNameFormat = "Camera_%s-%s"
local semiAnimDuration = 0.4
local isPointSameGroup = function(p1, p2)
  return p1 and p2 and string.sub(p1, 1, 1) == string.sub(p2, 1, 1)
end

function NewCreateRoleAnimationCtrl:ctor()
end

function NewCreateRoleAnimationCtrl:Init(transFindRootName)
  self.trans = GameObject.Find(transFindRootName).transform.parent.parent
  self.gameObject = self.trans.gameObject
  self:FindObjs()
end

function NewCreateRoleAnimationCtrl:FindObjs()
  self.rootCameraAnimator = self:FindComponent("Camera_cart", Animator)
  self.birdModel = self:FindGO("B_Pecopeco")
  self.cameraTransClone = self:FindGO("CLONE")
  local pointsGO = self:FindGO("CameraAnimPoints")
  for i = 1, #animPointNames do
    self.animPoints[i] = self:FindGO(animPointNames[i], pointsGO).transform
  end
  pointsGO = self:FindGO("CameraSemiPoints")
  for i = 1, #semiPointNames do
    self.semiPoints[i] = self:FindGO(semiPointNames[i], pointsGO).transform
    self.pointTransDict[semiPointNames[i]] = self.semiPoints[i]
  end
end

NewCreateRoleAnimationCtrl.animPoints = {}
NewCreateRoleAnimationCtrl.semiPoints = {}
NewCreateRoleAnimationCtrl.pendingVisitPoints = {}
NewCreateRoleAnimationCtrl.pointTransDict = {}
local isInOriAnim = false
local isInSemiAnim = false
local currentOnPoint
local pendingQueue = {}

function NewCreateRoleAnimationCtrl:PendingQueueCount()
  return #pendingQueue
end

function NewCreateRoleAnimationCtrl:PendingQueuePeek()
  return pendingQueue[1]
end

function NewCreateRoleAnimationCtrl:PendingQueueEnqueue(point)
  TableUtility.ArrayPushBack(pendingQueue, point)
end

function NewCreateRoleAnimationCtrl:PendingQueueDequeue()
  if 0 < #pendingQueue then
    table.remove(pendingQueue, 1)
  end
end

function NewCreateRoleAnimationCtrl:PendingQueueClear()
  TableUtility.TableClear(pendingQueue)
end

function NewCreateRoleAnimationCtrl:SetDesPoint(des)
  redlog("SetDesPoint", des)
  if not des then
    return
  end
  local curPeek = self:PendingQueuePeek()
  self:PendingQueueClear()
  local cmpPoint = currentOnPoint
  if curPeek then
    self:PendingQueueEnqueue(curPeek)
    cmpPoint = curPeek
  end
  if isPointSameGroup(cmpPoint, des) then
    self:PendingQueueEnqueue(des)
    return
  end
  if string.len(cmpPoint) > 1 then
    self:PendingQueueEnqueue(string.sub(cmpPoint, 1, 1))
  end
  if string.len(des) > 1 then
    self:PendingQueueEnqueue(string.sub(des, 1, 1))
  end
  self:PendingQueueEnqueue(des)
end

function NewCreateRoleAnimationCtrl:SetDesPointToOri()
  self:SetDesPoint(oriPoint)
end

function NewCreateRoleAnimationCtrl:OriAnimTo(animPoint)
  local curIdx = TableUtility.ArrayFindIndex(animPointNames, currentOnPoint)
  local animIdx = TableUtility.ArrayFindIndex(animPointNames, animPoint)
  if curIdx == animIdx or curIdx < 0 or animIdx < 0 then
    isInOriAnim = false
    return
  end
  self.rootCameraAnimator.enabled = true
  self.rootCameraAnimator:StopPlayback()
  if curIdx < animIdx then
    self.rootCameraAnimator:SetFloat("speed", 1)
    self.rootCameraAnimator:Play(string.format(cameraAnimNameFormat, currentOnPoint, animPoint), -1, 0)
  else
    self.rootCameraAnimator:SetFloat("speed", -1)
    self.rootCameraAnimator:Play(string.format(cameraAnimNameFormat, animPoint, currentOnPoint), -1, 1)
  end
  isInOriAnim = true
  isInSemiAnim = false
end

function NewCreateRoleAnimationCtrl:SemiAnimTo(sameGroupPoint)
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalPosition(self.rootCameraAnimator.transform))
  self.cameraTransClone.transform.localPosition = tempV3
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalEulerAngles(self.rootCameraAnimator.transform))
  self.cameraTransClone.transform.localEulerAngles = tempV3
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalScale(self.rootCameraAnimator.transform))
  self.cameraTransClone.transform.localScale = tempV3
  local tween = TweenTransform.Begin(self.rootCameraAnimator.gameObject, semiAnimDuration, self.cameraTransClone.transform, self.pointTransDict[sameGroupPoint])
  tween:SetOnFinished(function()
    isInSemiAnim = false
    currentOnPoint = self:PendingQueuePeek()
  end)
  isInOriAnim = false
  isInSemiAnim = true
  self.rootCameraAnimator.enabled = false
end

function NewCreateRoleAnimationCtrl:CheckInOriAnim()
  if isInOriAnim then
    local stateInfo = self.rootCameraAnimator:GetCurrentAnimatorStateInfo(0)
    isInOriAnim = stateInfo.normalizedTime < 1 and 0 < stateInfo.speedMultiplier or 0 < stateInfo.normalizedTime and 0 > stateInfo.speedMultiplier
    if not isInOriAnim then
      currentOnPoint = self:PendingQueuePeek()
      if not self.pointTransDict[currentOnPoint] then
        local index = TableUtility.ArrayFindIndex(animPointNames, currentOnPoint)
        local trans = self.animPoints[index]
        if trans then
          LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalPosition(self.rootCameraAnimator.transform))
          trans.localPosition = tempV3
          LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalEulerAngles(self.rootCameraAnimator.transform))
          trans.localEulerAngles = tempV3
          LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalScale(self.rootCameraAnimator.transform))
          trans.localScale = tempV3
          self.pointTransDict[currentOnPoint] = trans
        end
      end
    end
  end
  return isInOriAnim
end

function NewCreateRoleAnimationCtrl:OnStart()
  currentOnPoint = animPointNames[1]
  self.rootCameraAnimator.enabled = true
  self.rootCameraAnimator:Play("Camera_" .. currentOnPoint)
  Game.GUISystemManager:AddMonoUpdateFunction(self.OnUpdate, self)
end

function NewCreateRoleAnimationCtrl:OnDestroy()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  TableUtility.ArrayClear(self.animPoints)
  TableUtility.ArrayClear(self.semiPoints)
  TableUtility.ArrayClear(self.pendingVisitPoints)
  TableUtility.TableClear(self.pointTransDict)
end

function NewCreateRoleAnimationCtrl:OnUpdate()
  if TableUtility.ArrayFindIndex(hideBirdPointNames, currentOnPoint) > 0 or 0 < self:PendingQueueCount() and 0 < TableUtility.ArrayFindIndex(hideBirdPointNames, self:PendingQueuePeek()) then
    self.birdModel:SetActive(false)
  else
    self.birdModel:SetActive(true)
  end
  if self:CheckInOriAnim() then
    return
  end
  if isInSemiAnim then
    return
  end
  if 0 < self:PendingQueueCount() then
    local peek = self:PendingQueuePeek()
    if currentOnPoint == peek then
      self:PendingQueueDequeue()
      isInOriAnim = false
      isInSemiAnim = false
      if self:PendingQueueCount() == 0 then
        self:Notify(NewCreateRoleAnimationCtrlEvent.AnimEnd)
      end
      return
    end
    if isPointSameGroup(currentOnPoint, peek) then
      self:SemiAnimTo(peek)
    else
      self:OriAnimTo(peek)
    end
    self:Notify(NewCreateRoleAnimationCtrlEvent.AnimStart)
    FunctionNewCreateRole.Me():ResetSelectCurrentRoleModel()
  end
end

function NewCreateRoleAnimationCtrl:Notify(event, data)
  if nil == GameFacade then
    return
  end
  GameFacade.Instance:sendNotification(event, data)
end
