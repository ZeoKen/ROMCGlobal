GOManager_TrainEscortBoard = class("GOManager_TrainEscortBoard")

function GOManager_TrainEscortBoard:ctor()
  self.objects = {}
  self.data = {state = 0}
  self.nextID = 0
  FunctionTrainEscort.Me():SetActivityOpen(false)
  self:AddListener()
end

function GOManager_TrainEscortBoard:AddListener()
  EventManager.Me():AddEventListener(ServiceEvent.ActivityCmdEscortActUpdateCmd, self.UpdateEscortAct, self)
end

function GOManager_TrainEscortBoard:RegisterGameObject(obj)
  self.nextID = self.nextID + 1
  obj.ID = self.nextID
  local objID = obj.ID
  self.objects[objID] = obj
  local tex = self:GetScreenUITexture()
  local screenMr = obj:GetComponentProperty(0)
  screenMr.material:SetTexture("_MainTex", tex)
  return true
end

function GOManager_TrainEscortBoard:UnregisterGameObject(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if testObj ~= nil and testObj == obj then
    self.objects[objID] = nil
    if not next(self.objects) then
      self:ClearScreenUITexture()
    end
    return true
  end
  return false
end

local texSize = 512

function GOManager_TrainEscortBoard:GetScreenUITexture()
  if not self.screenUI then
    self.screenUI = TrainEscortScreenUI.new()
    self.screenUITexture = RenderTexture.GetTemporary(texSize, texSize)
    self.screenUI.camera.targetTexture = self.screenUITexture
    self.screenUI.camera:Render()
    self.screenUI:SetData(self.data)
  end
  return self.screenUITexture
end

function GOManager_TrainEscortBoard:ClearScreenUITexture()
  if self.screenUI then
    self.screenUI:Dispose()
    self.screenUI = nil
  end
  if self.screenUITexture then
    RenderTexture.ReleaseTemporary(self.screenUITexture)
    self.screenUITexture = nil
  end
end

function GOManager_TrainEscortBoard:UpdateEscortAct(data)
  local data = data.data
  if not self.data then
    self.data = {}
  end
  self.data.state = data.state
  self.data.start_time = data.start_time
  self.data.process = data.process
  self.data.clientState = FunctionTrainEscort.Me():GetClientState()
  if self.screenUI then
    self.screenUI:SetData(self.data)
  end
end

function GOManager_TrainEscortBoard.btest(size)
  local gom = GOManager_TrainEscortBoard.new()
  local luago = GameObject.Find("3150(Clone)")
  luago = luago:GetComponentInChildren(LuaGameObject)
  gom:RegisterGameObject(luago)
  local screenMr = luago:GetComponentProperty(0)
  if not GOManager_TrainEscortBoard.screenUI then
    GOManager_TrainEscortBoard.screenUI = TrainEscortScreenUI.new()
  end
  local screenUI = GOManager_TrainEscortBoard.screenUI
  screenUI:SetData()
  screenUI:SetPhase1CountDown(100)
  local size = size or 512
  local renderTex = RenderTexture.GetTemporary(size, size)
  screenUI.camera.targetTexture = renderTex
  screenUI.camera:Render()
  screenMr.material:SetTexture("_MainTex", renderTex)
end

TrainEscortScreenUI = class("TrainEscortScreenUI")

function TrainEscortScreenUI:ctor()
  self:Init()
end

local resID = "GUI/v1/root/TrainEscortScreenUIRoot"

function TrainEscortScreenUI:Init()
  if self.gameObject == nil then
    self.gameObject = Game.AssetManager_UI:CreateAsset(resID)
    self.camera = self.gameObject:GetComponentInChildren(Camera)
  else
    self.gameObject:SetActive(true)
  end
  self:InitView()
end

function TrainEscortScreenUI:InitView()
  self.phase1Go = self:FindGO("Phase1")
  self.phase1ClockLb = self:FindComponent("clock", UILabel, self.phase1Go)
  self.phase1TitleLb = self:FindComponent("title", UILabel, self.phase1Go)
  self.phase2Go = self:FindGO("Phase2")
  self.phase2EffectContainer = self:FindGO("eff_container", self.phase2Go)
  self.phase3Go = self:FindGO("Phase3")
  self.phase3StartAnchor = self:FindGO("start_anchor", self.phase3Go)
  self.phase3EndAnchor = self:FindGO("end_anchor", self.phase3Go)
  self.phase3Checks = {}
  self.phase3CheckOri = self:FindGO("check0", self.phase3Go)
  self.phase3Checks[1] = self.phase3CheckOri
  if #self.phase3Checks < #GameConfig.TrainEscort.CheckPoint then
    local delta = #GameConfig.TrainEscort.CheckPoint - #self.phase3Checks
    for i = 1, delta do
      local check = GameObject.Instantiate(self.phase3CheckOri)
      check.transform:SetParent(self.phase3Go.transform, false)
      self.phase3Checks[#self.phase3Checks + 1] = check
    end
  end
  self.phase3descLb = self:FindComponent("desc", UILabel, self.phase3Go)
  self.phase3flagTween = self:FindComponent("flag", TweenPosition, self.phase3Go)
  self.phase3bird = self:FindGO("bird", self.phase3Go)
  self.phase3BirdContainer = self:FindGO("container", self.phase3Go)
  self.phase3birdAngry = self:FindGO("angry", self.phase3BirdContainer)
  self.phase3birdAngry:SetActive(false)
  self.phase3StartAnchorPos = self.phase3StartAnchor.transform.localPosition
  self.phase3EndAnchorPos = self.phase3EndAnchor.transform.localPosition
  self.phase3flagTween:ResetToBeginning()
  for i = 1, #self.phase3Checks do
    if GameConfig.TrainEscort.CheckPoint[i] then
      self.phase3Checks[i]:SetActive(true)
      self.phase3Checks[i].transform.localPosition = LuaVector3.Lerp(self.phase3StartAnchorPos, self.phase3EndAnchorPos, GameConfig.TrainEscort.CheckPoint[i])
    else
      self.phase3Checks[i]:SetActive(false)
    end
  end
  self.phase1TitleLb.text = ZhString.TrainEscort_Tip1
  self.phase3descLb.text = string.format(ZhString.TrainEscort_Tip2, GameConfig.TrainEscort.StartTime, GameConfig.TrainEscort.EndTime)
  self:CreateBirdEffect()
end

function TrainEscortScreenUI:SetData(data)
  if data.state == 2 then
    self.wait_sec = data.start_time - ServerTime.CurServerTime() / 1000
    if self.wait_sec < 0 then
      self.wait_sec = 0
    end
  else
    self.wait_sec = 0
  end
  if data.state == 1 or data.state == 3 then
    self.process = data.process / 100
    if 1 < self.process then
      self.process = 1
    elseif 0 > self.process then
      self.process = 0
    end
  else
    self.process = 0
  end
  self.state = data.state
  self.detailState = data.clientState
  self:UpdatePhase()
  self:UpdateOtherUI()
end

local phase = {
  init = 0,
  wait_start = 1,
  start_anim = 2,
  process = 3,
  fin_anim = 4,
  fin_end = 5
}

function TrainEscortScreenUI:UpdatePhase()
  self.phase = self.phase or 0
  if self.phase == 0 then
    if self.state == 0 then
      self:ToPhase0()
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
      self:ToPhase3()
    elseif (self.state == 1 or self.state == 3) and 1 <= self.process then
      self:ToPhase5()
    elseif self.state == 2 then
      self:ToPhase1()
    elseif self.state == 4 then
      self:ToPhase5()
    end
  elseif self.phase == 1 then
    if self.state == 0 then
      self:ToPhase0()
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
      self:ToPhase2()
    elseif (self.state == 1 or self.state == 3) and 1 <= self.process then
      self:ToPhase5()
    elseif self.state == 2 then
      self:ToPhase1()
    elseif self.state == 4 then
      self:ToPhase5()
    end
  elseif self.phase == 2 then
    if self.state == 0 then
      self:ToPhase0()
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
    elseif (self.state == 1 or self.state == 3) and 1 <= self.process then
      self:ToPhase5()
    elseif self.state == 2 then
      self:ToPhase1()
    elseif self.state == 4 then
      self:ToPhase5()
    end
  elseif self.phase == 3 then
    if self.state == 0 then
      self:ToPhase0()
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
      self:ToPhase3()
    elseif (self.state == 1 or self.state == 3) and 1 <= self.process then
      self:ToPhase4()
    elseif self.state == 2 then
      self:ToPhase1()
    elseif self.state == 4 then
      self:ToPhase5()
    end
  elseif self.phase == 4 then
    if self.state == 0 then
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
      self:ToPhase3()
    elseif self.state == 2 then
      self:ToPhase1()
    end
  elseif self.phase == 5 then
    if self.state == 0 then
      self:ToPhase0()
    elseif (self.state == 1 or self.state == 3) and 1 > self.process then
      self:ToPhase3()
    elseif (self.state == 1 or self.state == 3) and 1 <= self.process then
    elseif self.state == 2 then
      self:ToPhase1()
    end
  end
end

function TrainEscortScreenUI:LeavePhase(nextPhase)
  if self.phase == nextPhase then
    return
  end
  if self.phase == 0 then
  elseif self.phase == 1 then
    self:ClearPhase1CountDown()
  elseif self.phase == 2 then
    self:ClearPhase2CountDown()
  elseif self.phase == 3 then
  elseif self.phase == 4 then
    self:ClearPhase4CountDown()
  elseif self.phase == 5 then
  end
end

function TrainEscortScreenUI:UpdateOtherUI()
  self.phase3descLb.text = ""
  if self.detailState == FunctionTrainEscort.State.EVENT_ANGRY or self.detailState == FunctionTrainEscort.State.EVENT_GOODS then
    self.phase3birdAngry:SetActive(true)
  else
    self.phase3birdAngry:SetActive(false)
  end
  if self.detailState == FunctionTrainEscort.State.EVENT_GOODS then
    self.phase3descLb.text = ZhString.TrainEscort_TaskDesc_5
  elseif self.detailState == FunctionTrainEscort.State.EVENT_ANGRY then
    self.phase3descLb.text = ZhString.TrainEscort_TaskDesc_2
  elseif self.detailState == FunctionTrainEscort.State.IN_PROGRESS then
    self.phase3descLb.text = ZhString.TrainEscort_TaskDesc_1
  end
end

function TrainEscortScreenUI:ClearData()
  self.wait_sec = 0
  self.process = 0
  self.state = 0
  self.detailState = 0
end

function TrainEscortScreenUI:ToPhase0()
  self:LeavePhase(0)
  self.phase = 0
  self.phase1Go:SetActive(false)
  self.phase2Go:SetActive(false)
  self.phase3Go:SetActive(false)
end

function TrainEscortScreenUI:ToPhase1()
  self:LeavePhase(1)
  self.phase = 1
  self.phase1Go:SetActive(true)
  self.phase2Go:SetActive(false)
  self.phase3Go:SetActive(false)
  self:ClearPhase1CountDown()
  self:SetPhase1CountDown(self.wait_sec)
end

function TrainEscortScreenUI:ToPhase2()
  self:LeavePhase(2)
  self.phase = 2
  self.phase1Go:SetActive(false)
  self.phase2Go:SetActive(true)
  self.phase3Go:SetActive(false)
  self:ClearPhase2CountDown()
  self:PlayPhase2Effect()
  self:SetPhase2CountDown()
end

function TrainEscortScreenUI:ToPhase3()
  self:LeavePhase(3)
  self.phase = 3
  self.phase1Go:SetActive(false)
  self.phase2Go:SetActive(false)
  self.phase3Go:SetActive(true)
  self:SetPlayBirdEffect(true)
  self:UpdatePhase3BirdPosition()
  self.phase3flagTween.enabled = true
  self.phase3flagTween:Sample(0, true)
  self.phase3flagTween.enabled = false
end

function TrainEscortScreenUI:ToPhase4()
  self:LeavePhase(4)
  self.phase = 4
  self.phase1Go:SetActive(false)
  self.phase2Go:SetActive(false)
  self.phase3Go:SetActive(true)
  self:SetPlayBirdEffect(false)
  self:UpdatePhase3BirdPosition(1)
  self:ClearPhase4CountDown()
  self:SetPhase4CountDown()
  self.phase3flagTween.enabled = true
  self.phase3flagTween:ResetToBeginning()
  self.phase3flagTween:PlayForward()
end

function TrainEscortScreenUI:ToPhase5()
  self:LeavePhase(5)
  self.phase = 5
  self.phase1Go:SetActive(false)
  self.phase2Go:SetActive(false)
  self.phase3Go:SetActive(true)
  self:SetPlayBirdEffect(false)
  self:UpdatePhase3BirdPosition(1)
  self.phase3flagTween.enabled = true
  self.phase3flagTween:Sample(1, true)
  self.phase3flagTween.enabled = false
end

function TrainEscortScreenUI:SetPhase1CountDown(sec)
  TimeTickManager.Me():CreateTick(0, 1000, function(self)
    local time = os.date("%M", sec) .. ":" .. os.date("%S", sec)
    self.phase1ClockLb.text = time
    sec = sec - 1
    if sec < 0 then
      self:ClearPhase1CountDown()
      self:ToPhase2()
      self:ClearData()
    end
  end, self, 1001)
end

function TrainEscortScreenUI:ClearPhase1CountDown()
  TimeTickManager.Me():ClearTick(self, 1001)
end

function TrainEscortScreenUI:SetPhase2CountDown()
  TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:ToPhase3()
    self:UpdatePhase()
  end, self, 1002)
end

function TrainEscortScreenUI:ClearPhase2CountDown()
  TimeTickManager.Me():ClearTick(self, 1002)
end

function TrainEscortScreenUI:SetPhase4CountDown()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:ToPhase5()
    self:UpdatePhase()
  end, self, 1004)
end

function TrainEscortScreenUI:ClearPhase4CountDown()
  TimeTickManager.Me():ClearTick(self, 1004)
end

function TrainEscortScreenUI:PlayPhase2Effect()
  if self.phase2Effect and self.phase2Effect:Alive() then
    self.phase2Effect:Destroy()
  end
  self.phase2Effect = nil
  self.phase2Effect = self:PlayUIEffect(EffectMap.UI.TrainEscortGlow, self.phase2EffectContainer, true, nil, nil, 1)
end

function TrainEscortScreenUI:CreateBirdEffect()
  if not self.phase3BridEffect then
    self.phase3BridEffect = self:PlayUIEffect(EffectMap.UI.TrainEscortBird, self.phase3BirdContainer, false, function(obj, args, assetEffect)
      self.phase3BridAnimator = assetEffect.effectObj:GetComponentInChildren(Animator, true)
      if self.phase3BridAnimator_isPlay ~= nil then
        self:SetPlayBirdEffect(self.phase3BridAnimator_isPlay)
      end
    end)
  end
end

function TrainEscortScreenUI:SetPlayBirdEffect(isPlay)
  self.phase3BridAnimator_isPlay = isPlay
  if self.phase3BridAnimator then
    local isBlockEvent = self.detailState == 4 or self.detailState == 3
    if isPlay and not isBlockEvent then
      self.phase3BridAnimator:Play("ufx_escprt_bird_am", -1, 0)
      self.phase3BridAnimator.speed = 1
    else
      self.phase3BridAnimator:Play("ufx_escprt_bird_am", -1, 0)
      self.phase3BridAnimator.speed = 0
    end
  end
end

function TrainEscortScreenUI:UpdatePhase3BirdPosition(p)
  p = p or self.process or 0
  self.phase3bird.transform.localPosition = LuaVector3.Lerp(self.phase3StartAnchorPos, self.phase3EndAnchorPos, p)
end

function TrainEscortScreenUI:Dispose()
  TimeTickManager.Me():ClearTick(self)
  self.phase2Effect = nil
  self:DestroyUIEffects()
  self.camera.targetTexture = nil
  if self.gameObject and not self:ObjIsNil(self.gameObject) then
    GameObject.DestroyImmediate(self.gameObject)
  end
  Game.AssetManager_UI:UnLoadAsset(resID)
end

function TrainEscortScreenUI:ObjIsNil(obj)
  return LuaGameObject.ObjectIsNull(obj)
end

function TrainEscortScreenUI:FindGO(name, parent)
  parent = parent or self.gameObject
  return parent ~= nil and Game.GameObjectUtil:DeepFind(parent, name) or nil
end

function TrainEscortScreenUI:FindComponent(name, comp, parent)
  parent = parent or self.gameObject
  return parent ~= nil and Game.GameObjectUtil:DeepFindComponent(parent, comp, name) or nil
end

function TrainEscortScreenUI:PlayUIEffect(id, container, once, callback, callArgs, scale)
  return self:PlayEffectByFullPath(ResourcePathHelper.UIEffect(id), container, once, callback, callArgs, scale)
end

function TrainEscortScreenUI:PlayEffectByFullPath(path, container, once, callback, callArgs, scale)
  if once then
    return Asset_Effect.PlayOneShotOn(path, container and container.transform, function(go, args, assetEffect)
      if not args.owner then
        return
      end
      args.owner:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, args.params, path)
    end, {owner = self, params = callArgs}, scale)
  else
    local effect = Asset_Effect.PlayOn(path, container and container.transform, function(go, args, assetEffect)
      if not args.owner then
        return
      end
      args.owner:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, args.params, path)
    end, {owner = self, params = callArgs}, scale)
    if self.uieffects == nil then
      self.uieffects = {}
    end
    TableUtility.ArrayPushBack(self.uieffects, effect)
    return effect
  end
end

function TrainEscortScreenUI:DestroyUIEffects()
  if self.uieffects == nil then
    return
  end
  local effect
  for i = #self.uieffects, 1, -1 do
    effect = self.uieffects[i]
    if effect:Alive() then
      effect:Destroy()
    end
    self.uieffects[i] = nil
  end
end

function TrainEscortScreenUI:PlayUIEffectAsyncCallBack(container, assetEffect, go, callback, callArgs, path)
  if self:ObjIsNil(container) then
    if assetEffect then
      redlog("CoreView:PlayUIEffectAsyncCallBack obj is nil, Destroy AssetEffect ")
      assetEffect:Destroy()
    end
    return
  end
  local changeRqByTex = container:GetComponent(ChangeRqByTex)
  if changeRqByTex then
    changeRqByTex.excute = false
  end
  if callback then
    callback(go, callArgs, assetEffect)
  end
end

function GOManager_TrainEscortBoard.TestRecvMsg(state, start_time, process)
  local data = {
    state = state,
    start_time = start_time * 1000 + ServerTime.CurServerTime(),
    process = process
  }
  ServiceActivityCmdProxy.Instance:RecvEscortActUpdateCmd(data)
end
