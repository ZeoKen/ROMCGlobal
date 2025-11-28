SignInCatEncounterView = class("SignInCatEncounterView", BaseView)
SignInCatEncounterView.ViewType = UIViewType.NormalLayer
SignInCatAnimState = {
  WalkIn = 1,
  TurnLeft = 2,
  BoardDrop = 3,
  Wait = 4,
  TurnRight = 5,
  WalkOut = 6
}
SignInCatAnimDuration = {
  Walk = 1.1,
  Turn = 0.5,
  Functional_Action = 1.333
}
local modelEulerAngleY0, modelEulerAngleWaitDelta = 98, -90

function SignInCatEncounterView.CanShow()
  local ins = NewServerSignInProxy.Instance
  return ins:IsSignInNotifyReceived() and not ins.isCatShowed
end

function SignInCatEncounterView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function SignInCatEncounterView:Init()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
end

function SignInCatEncounterView:FindObjs()
  self.modelContainer = self:FindGO("ModelContainer")
  self.clickZone = self:FindGO("ClickZone")
  self.modelTexture = self.modelContainer:GetComponent(UITexture)
  self.catTweenTransform = self.modelContainer:GetComponent(TweenTransform)
  self.wayPoints = {
    walkInFrom = self:FindGO("WalkInFrom").transform,
    turnLeftFrom = self:FindGO("TurnLeftFrom").transform,
    wait = self:FindGO("Wait").transform,
    turnRightTo = self:FindGO("TurnRightTo").transform,
    walkOutTo = self:FindGO("WalkOutTo").transform
  }
end

function SignInCatEncounterView:InitView()
  self.catMoveState = 0
  self.keyFrames = {}
  self.keyFrameCalls = {}
  self.catTweenTransform:SetOnFinished(function()
    self:MoveToNextState()
  end)
  self:AddClickEvent(self.clickZone, function()
    if not self.clickZoneEnabled then
      return
    end
    self:CloseSelf()
  end)
end

function SignInCatEncounterView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleTryBeginEncounterAnim)
end

local onCatCreated = function(model, self)
  self.model = model
  self.catTweenRotation = model.completeTransform.gameObject:AddComponent(TweenRotation)
  local viewData = self.viewdata.viewdata
  if viewData and viewData.isPlayFarewellAnim == true then
    self:BeginFarewellAnim()
  else
    self:BeginEncounterAnim()
  end
  NewServerSignInProxy.Instance.isCatShowed = true
end

function SignInCatEncounterView:OnEnter()
  SignInCatEncounterView.super.OnEnter(self)
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = 1595
  parts[Asset_Role.PartIndexEx.LoadFirst] = true
  UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.SignInCat, nil, nil, nil, nil, onCatCreated, self)
  Asset_Role.DestroyPartArray(parts)
  UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
end

function SignInCatEncounterView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.model then
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    self.modelTexture = nil
    self.model = nil
  end
  SignInCatEncounterView.super.OnExit(self)
end

function SignInCatEncounterView:HandleTryBeginEncounterAnim()
  self:BeginEncounterAnim()
end

function SignInCatEncounterView:BeginEncounterAnim()
  self.catMoveState = SignInCatAnimState.WalkIn
  self:BeginWalkAnim(self.wayPoints.walkInFrom, self.wayPoints.turnLeftFrom, SignInCatAnimDuration.Walk)
end

function SignInCatEncounterView:BeginFarewellAnim()
  self.catMoveState = SignInCatAnimState.TurnRight
  self:BeginWalkAnim(self.wayPoints.wait, self.wayPoints.turnRightTo, SignInCatAnimDuration.Turn)
end

function SignInCatEncounterView:BeginWalkAnim(from, to, duration)
  if self.catMoveState == SignInCatAnimState.WalkIn then
    self.tickTime = 0
    self:ClearKeyFrameCall()
    local durations = SignInCatAnimDuration
    self:AddKeyFrameCall(durations.Walk + durations.Turn + 0.5, function()
      if self.catMoveState == SignInCatAnimState.BoardDrop then
        return
      end
      for i = 1, #self.keyFrames do
        self.keyFrames[i] = self.keyFrames[i] + 0.5
      end
      self.catMoveState = SignInCatAnimState.BoardDrop
      self.model:SetPosition(LuaGeometry.Const_V3_zero)
      self.model:SetEulerAngleY(modelEulerAngleY0 + modelEulerAngleWaitDelta)
      self:PlayCatAction("functional_action")
    end)
    self:AddKeyFrameCall(durations.Walk + 1.2, function()
      self:SetClickZoneEnabled(true)
    end)
    self:AddKeyFrameCall(durations.Walk + durations.Turn + durations.Functional_Action, function()
      self:PlayCatAction("functional_action2")
    end)
    self.keyFrameCallsTick = TimeTickManager.Me():CreateTick(0, 33, self.TryKeyFrameCalls, self)
  end
  self:SetClickZoneEnabled(false)
  self:SetTweenTransformAndPlay(from, to, duration)
  self:PlayCatAction("walk")
end

function SignInCatEncounterView:TryKeyFrameCalls(interval)
  self.tickTime = self.tickTime + interval / 1000
  if not next(self.keyFrames) then
    self.keyFrameCallsTick:ClearTick()
    return
  end
  if self.tickTime > self.keyFrames[1] then
    self.keyFrameCalls[1]()
    self:PopFrontKeyFrameCall()
  end
end

function SignInCatEncounterView:AddKeyFrameCall(keyFrameTime, keyFrameCall)
  TableUtility.ArrayPushBack(self.keyFrames, keyFrameTime)
  TableUtility.ArrayPushBack(self.keyFrameCalls, keyFrameCall)
end

function SignInCatEncounterView:ClearKeyFrameCall()
  TableUtility.ArrayClear(self.keyFrames)
  TableUtility.ArrayClear(self.keyFrameCalls)
end

function SignInCatEncounterView:PopFrontKeyFrameCall()
  TableUtility.ArrayPopFront(self.keyFrames)
  TableUtility.ArrayPopFront(self.keyFrameCalls)
end

function SignInCatEncounterView:MoveToNextState()
  self.catMoveState = self.catMoveState + 1
  if self.catMoveState == SignInCatAnimState.TurnLeft then
    self:SetTweenTransformAndPlay(self.wayPoints.turnLeftFrom, self.wayPoints.wait, SignInCatAnimDuration.Turn)
  elseif self.catMoveState == SignInCatAnimState.BoardDrop then
    self:PlayCatAction("functional_action")
    self.catTweenTransform.enabled = false
  elseif self.catMoveState == SignInCatAnimState.WalkOut then
    self:SetTweenTransformAndPlay(self.wayPoints.turnRightTo, self.wayPoints.walkOutTo, SignInCatAnimDuration.Walk)
  elseif self.catMoveState > SignInCatAnimState.WalkOut then
    self:CloseSelf()
  end
end

function SignInCatEncounterView:SetClickZoneEnabled(enabled)
  enabled = enabled or false
  self.clickZoneEnabled = enabled
  if enabled and not self.clickHintGO then
    self.clickHintGO = self:CreateClickHint()
  elseif not enabled and self.clickHintGO then
    GameObject.Destroy(self.clickHintGO)
    self.clickHintGO = nil
  end
end

function SignInCatEncounterView:SetTweenTransformAndPlay(from, to, duration)
  local t = self.catTweenTransform
  t.from = from
  t.to = to
  t.duration = duration
  t:ResetToBeginning()
  t:PlayForward()
  local r = self.catTweenRotation
  r.from = LuaGeometry.GetTempVector3(0, modelEulerAngleY0 + (from == self.wayPoints.wait and modelEulerAngleWaitDelta or 0), 0)
  r.to = LuaGeometry.GetTempVector3(0, modelEulerAngleY0 + (to == self.wayPoints.wait and modelEulerAngleWaitDelta or 0), 0)
  r.duration = duration
  r:ResetToBeginning()
  r:PlayForward()
end

function SignInCatEncounterView:PlayCatAction(actionName)
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  self.model:PlayAction(params)
end

function SignInCatEncounterView:CreateClickHint()
  local effect = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.EffectUI(EffectMap.UI.StartDian), self.gameObject)
  effect.transform.localPosition = LuaGeometry.GetTempVector3(-85, 52)
  local effectComp = effect:GetComponent(ChangeRqByTex)
  effectComp.depth = 12
  return effect
end
