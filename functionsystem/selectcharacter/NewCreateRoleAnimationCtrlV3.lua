NewCreateRoleAnimationCtrlV3 = class("NewCreateRoleAnimationCtrlV3", CoreView)
NewCreateRoleAnimationCtrlEvent = {
  AnimStart = "NewCreateRoleAnimationCtrlEvent_AnimStart",
  AnimEnd = "NewCreateRoleAnimationCtrlEvent_AnimEnd"
}
local branchPointNames = {
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
local trunkPointNames = {
  "P",
  "A",
  "B",
  "C",
  "D"
}
local pointToCpLookup = {
  P = 0,
  A1 = 3,
  A2 = 4,
  B1 = 2,
  B2 = 1,
  C1 = 8,
  C2 = 7,
  C3 = 9,
  D1 = 5,
  D2 = 6
}
local oriPoint = trunkPointNames[1]
local hideBirdPointNames = {"A1", "A2"}
local trunkAnimNameFormat = "Trunk_%s-%s"
local branchAnimNameFormat = "Branch_%s-%s"
local newAnimNameFormat = "[%s-%s]%s-%s"
local artCameraAnimName = "Camera_%s-%s"
local priorityCmp = {
  "P",
  "A",
  "B",
  "C",
  "D",
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
local isPrior = function(p1, p2)
  return TableUtility.ArrayFindIndex(priorityCmp, p1) < TableUtility.ArrayFindIndex(priorityCmp, p2)
end
local isPointSameGroup = function(p1, p2)
  return p1 and p2 and string.sub(p1, 1, 1) == string.sub(p2, 1, 1)
end
local globalSpeedFactor = 1
local curPoint, destPoint, pendingPoint, blendPoint

function NewCreateRoleAnimationCtrlV3:ctor()
  globalSpeedFactor = GameConfig.CreateRole.CameraAnimSpeedFactor or 1
end

function NewCreateRoleAnimationCtrlV3:Init(transFindRootName)
  self.trans = GameObject.Find(transFindRootName).transform.parent.parent
  self.gameObject = self.trans.gameObject
  self:FindObjs()
end

function NewCreateRoleAnimationCtrlV3:FindObjs()
  self.rootCameraAnimator = self:FindComponent("Camera_cart", Animator)
  self.rootCameraAnimator:SetFloat("speed", globalSpeedFactor)
  self.birdModel = self:FindGO("B_Pecopeco")
end

function NewCreateRoleAnimationCtrlV3:OnStart()
  curPoint = oriPoint
  destPoint = nil
  self.rootCameraAnimator.enabled = true
  self.rootCameraAnimator:Play("Camera_" .. curPoint)
  Game.GUISystemManager:AddMonoUpdateFunction(self._Update, self)
end

function NewCreateRoleAnimationCtrlV3:OnDestroy()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
end

local nextFrameAnimEnd = false

function NewCreateRoleAnimationCtrlV3:SetDesPoint(des)
  redlog("SetDesPoint", des)
  if not des then
    return
  end
  if destPoint == des then
    return
  end
  local stateInfo = self.rootCameraAnimator:GetCurrentAnimatorStateInfo(0)
  if curPoint == des then
    if self:IsCurStateEnd(stateInfo) then
      nextFrameAnimEnd = true
      return
    end
    self:RewindCurrent()
    return
  end
  if destPoint == nil then
    self:Play(des)
  else
    self:Blend(des, stateInfo)
  end
end

function NewCreateRoleAnimationCtrlV3:IsCurStateEnd(stateInfo)
  local isInAnim = stateInfo.normalizedTime < 1 and stateInfo.speedMultiplier > 0 or stateInfo.normalizedTime > 0 and stateInfo.speedMultiplier < 0
  return not isInAnim
end

function NewCreateRoleAnimationCtrlV3:IsInState(name, stateInfo)
  local fstate = "Base Layer." .. name
  return stateInfo and stateInfo:IsName(fstate)
end

function NewCreateRoleAnimationCtrlV3:IsPlayAnimStarted(stateInfo)
  local stateName = string.format(artCameraAnimName, curPoint, destPoint)
  local rewind = not isPrior(curPoint, destPoint)
  if rewind then
    stateName = string.format(artCameraAnimName, destPoint, curPoint)
  end
  local speedSet = false
  if rewind then
    speedSet = stateInfo.speedMultiplier < 0
  else
    speedSet = stateInfo.speedMultiplier > 0
  end
  return self:IsInState(stateName, stateInfo) and speedSet
end

function NewCreateRoleAnimationCtrlV3:RewindCurrent()
  local speed = self.rootCameraAnimator:GetFloat("speed") * -1
  self.rootCameraAnimator:SetFloat("speed", speed)
  local swap = curPoint
  curPoint = destPoint
  destPoint = swap
end

function NewCreateRoleAnimationCtrlV3:Play(point)
  destPoint = point
  local anim, rewind = string.format(artCameraAnimName, curPoint, destPoint), false
  if not isPrior(curPoint, destPoint) then
    anim, rewind = string.format(artCameraAnimName, destPoint, curPoint), true
  end
  self.rootCameraAnimator:SetFloat("speed", rewind and -globalSpeedFactor or globalSpeedFactor)
  self.rootCameraAnimator:Play(anim, -1, rewind and 1 or 0)
  self:Notify(NewCreateRoleAnimationCtrlEvent.AnimStart)
  FunctionNewCreateRole.Me():ResetSelectCurrentRoleModel()
end

local cfTime = 0.5

function NewCreateRoleAnimationCtrlV3:Blend(point, stateInfo)
  destPoint = point
  local anim, rewind = string.format(artCameraAnimName, curPoint, destPoint), false
  if not isPrior(curPoint, destPoint) then
    anim, rewind = string.format(artCameraAnimName, destPoint, curPoint), true
  end
  local progress = math.clamp(stateInfo.normalizedTime, 0, 1)
  self.rootCameraAnimator:SetFloat("speed", rewind and -globalSpeedFactor or globalSpeedFactor)
  self.rootCameraAnimator:CrossFade(anim, cfTime, -1, rewind and 1 - progress or progress)
end

function NewCreateRoleAnimationCtrlV3:_Update()
  self:UpdateInterpolateDOFParam()
  if nextFrameAnimEnd then
    self:Notify(NewCreateRoleAnimationCtrlEvent.AnimEnd)
    nextFrameAnimEnd = false
    return
  end
  if destPoint ~= nil then
    local stateInfo = self.rootCameraAnimator:GetCurrentAnimatorStateInfo(0)
    if self:IsCurStateEnd(stateInfo) and self:IsPlayAnimStarted(stateInfo) then
      curPoint = destPoint
      destPoint = nil
      self:Notify(NewCreateRoleAnimationCtrlEvent.AnimEnd)
    end
  end
end

function NewCreateRoleAnimationCtrlV3:Notify(event, data)
  if nil == GameFacade then
    return
  end
  GameFacade.Instance:sendNotification(event, data)
end

function NewCreateRoleAnimationCtrlV3:SetDesPointToOri()
  self:SetDesPoint(oriPoint)
end

function NewCreateRoleAnimationCtrlV3:GetAnimationCurrentInfo()
  if not self.rootCameraAnimator then
    return
  end
  local stateInfo = self.rootCameraAnimator:GetCurrentAnimatorStateInfo(0)
  return stateInfo.fullPathHash, math.clamp(stateInfo.normalizedTime, 0, 1)
end

function NewCreateRoleAnimationCtrlV3:GetAnimationNextInfo()
  if not self.rootCameraAnimator then
    return
  end
  local stateInfo = self.rootCameraAnimator:GetNextAnimatorStateInfo(0)
  return stateInfo.fullPathHash, math.clamp(stateInfo.normalizedTime, 0, 1)
end

local paramUpdateOnPoint, paramUpdateOnAnimHash

function NewCreateRoleAnimationCtrlV3:UpdateInterpolateDOFParam()
  if self.supportDOF == nil then
    self.supportDOF = LoginRoleSelector.Ins():CheckSupportPPEffectDepthOfField()
  end
  if not self.supportDOF then
    return
  end
  if not destPoint or destPoint == curPoint and destPoint == oriPoint then
    if paramUpdateOnPoint ~= curPoint then
      paramUpdateOnPoint = curPoint
      local params = self:GetDOFParamAtPoint(curPoint)
      LoginRoleSelector.Ins():ChangePPEffectDepthOfField(params)
      paramUpdateOnAnimHash = nil
    end
    return
  end
  local aHash, aProgress = self:GetAnimationNextInfo()
  if aHash == 0 then
    aHash, aProgress = self:GetAnimationCurrentInfo()
  end
  if aHash ~= 0 and paramUpdateOnAnimHash ~= aHash and aProgress ~= 0 and aProgress ~= 1 then
    paramUpdateOnAnimHash = aHash
    self:SetDOFParamLerpStart(aProgress)
  end
  if paramUpdateOnAnimHash then
    self:DOFParamLerp(aProgress)
  end
end

local lerpStartProgress, lerpFullProgress
local lerpStartDOFParam = {}
local lerpTargetDOFParam = {}
local lerpDOFParam = {}

function NewCreateRoleAnimationCtrlV3:SetDOFParamLerpStart(startProgress)
  lerpStartProgress = startProgress
  local lerpTargetProgress = 1
  if self.rootCameraAnimator:GetFloat("speed") < 0 then
    lerpTargetProgress = 0
  end
  lerpFullProgress = math.abs(lerpStartProgress - lerpTargetProgress)
  lerpStartDOFParam[1], lerpStartDOFParam[2], lerpStartDOFParam[3] = LoginRoleSelector.Ins():GetPPEffectDepthOfFieldParams()
  lerpTargetDOFParam = self:GetDOFParamAtPoint(destPoint)
end

function NewCreateRoleAnimationCtrlV3:DOFParamLerp(progress)
  local lerpProgressPct = math.abs(progress - lerpStartProgress) / lerpFullProgress
  lerpDOFParam[1] = (1 - lerpProgressPct) * lerpStartDOFParam[1] + lerpProgressPct * lerpTargetDOFParam[1]
  lerpDOFParam[2] = (1 - lerpProgressPct) * lerpStartDOFParam[2] + lerpProgressPct * lerpTargetDOFParam[2]
  lerpDOFParam[3] = (1 - lerpProgressPct) * lerpStartDOFParam[3] + lerpProgressPct * lerpTargetDOFParam[3]
  LoginRoleSelector.Ins():ChangePPEffectDepthOfField(lerpDOFParam)
end

function NewCreateRoleAnimationCtrlV3:GetDOFParamAtPoint(point)
  if not GameConfig.CreateRole or not GameConfig.CreateRole.CP_DOF then
    return
  end
  local index = pointToCpLookup[point]
  if not index then
    return
  end
  return GameConfig.CreateRole.CP_DOF[index]
end
