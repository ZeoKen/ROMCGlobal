autoImport("BatteryCannonShortCutSkill")
BatteryCannonView = class("BatteryCannonView", BaseView)
BatteryCannonView.ViewType = UIViewType.NormalLayer
local _Game = Game
BatteryCannonView.SkillBtnScale = 1.22
BatteryCannonViewEvent = {
  SkillUnlock = "BatteryCannonViewEvent_SkillUnlock"
}

function BatteryCannonView:Init()
  self:InitViewData()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function BatteryCannonView:FindObjs()
  self.opGrid = self:FindComponent("opGrid", UIGrid)
  self.skillShotCutList = UIGridListCtrl.new(self.opGrid, BatteryCannonShortCutSkill, "ShortCutSkill")
  self.skillShotCutList:AddEventListener(BatteryCannonViewEvent.SkillUnlock, self.ShowUnlockSkillEffect, self)
  self.quitBtn = self:FindGO("quitBtn")
  self.trace4raid = self:FindGO("trace4raid")
  self.trace4raidLabel = self.trace4raid:GetComponentInChildren(UILabel)
  self.phaseSkillEffect = self:FindChild("PhaseSkillSelectEffect")
end

function BatteryCannonView:AddEvts()
end

function BatteryCannonView:AddViewEvts()
  self:AddButtonEvent("quitBtn", function(go)
    if Game.MapManager:IsRaidMode(false) then
      MsgManager.ConfirmMsgByID(7, function()
        ServiceNUserProxy.Instance:ReturnToHomeCity()
      end)
    else
      self:CloseSelf()
    end
  end)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.RecvPlayerMapChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdateHandler)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.ItemUpdateHandler)
  self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.UpdateQuestTrace)
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, self.UpdateQuestTrace)
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenClearInfoCmd, self.UpdateQuestTrace)
  self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseSkillEffect)
  self:AddListenEvt(SkillEvent.SkillWaitNextUse, self.WaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillCancelWaitNextUse, self.CancelWaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.StartSkillCD)
end

function BatteryCannonView:ItemUpdateHandler(note)
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:UpdatePreCondition()
    cells[i]:UpdateExInfo()
  end
end

function BatteryCannonView:RefreshCannonSkill()
  if not self.raw_skilldatas then
    self.raw_skilldatas = {}
  end
  local skilllist = {}
  local whitelist = {}
  local rm = {}
  for k, _ in pairs(self.raw_skilldatas) do
    if not self.cannon_skill[k] then
      rm[#rm + 1] = k
    end
  end
  for k, v in pairs(self.cannon_skill) do
    local skilldata = self.raw_skilldatas[k]
    if not skilldata then
      skilldata = SkillItemData.new(k, 0, 0, 0, 0)
      skilldata.learned = true
      if not SkillProxy.Instance:HasLearnedSkill(k) then
        SkillProxy.Instance:LearnedSkill(skilldata)
      end
    end
    skilldata.cannon_skill_config = v
    self.raw_skilldatas[k] = skilldata
    TableUtility.ArrayPushBack(skilllist, skilldata)
    TableUtility.ArrayPushBack(whitelist, k)
  end
  for i = 1, #rm do
    local k = rm[i]
    self.raw_skilldatas[k] = nil
    local skilldata = SkillProxy.Instance:GetLearnedSkill(k)
    if skilldata then
      SkillProxy.Instance:RemoveLearnedSkill(skilldata)
    end
  end
  SkillProxy.Instance:SetForbitUseWhiteList(whitelist)
  table.sort(skilllist, function(a, b)
    return a.id < b.id
  end)
  self.skillShotCutList:ResetDatas(skilllist)
  local all_empty = true
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    if cells[i]:ExtraCheckHasFitSpecialCost() then
      all_empty = false
      break
    end
  end
  if all_empty then
    self.quitBtn:SetActive(true)
  end
end

function BatteryCannonView:ClearCannonSkill()
  for k, v in pairs(self.cannon_skill) do
    local skilldata = SkillProxy.Instance:GetLearnedSkill(k)
    if skilldata then
      SkillProxy.Instance:RemoveLearnedSkill(skilldata)
    end
  end
  SkillProxy.Instance:SetForbitUseWhiteList()
end

function BatteryCannonView:InitViewData()
end

function BatteryCannonView:InitView()
  local npcfunctiondata = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcfunctiondata
  self.cannon_skill = FunctionBatteryCannon.Me():GetSkillConfig(npcfunctiondata)
  redlog("BatteryCannonView:InitView")
  self:RefreshCannonSkill()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.questDataParams then
    self:InitViewAsServerCannon()
  end
end

function BatteryCannonView:InitViewAsServerCannon()
  self.quitBtn:SetActive(self.hyxMode == true)
  self.isRaid = true
  self:UpdateQuestTrace()
  self.farAwayMode = self.viewdata.viewdata.questDataParams.faraway == 1
  self.sceneUIScale = self.viewdata.viewdata.questDataParams.uiscale
  if self.farAwayMode == true then
    AudioUtility.SetForceAssetRoleSE2D(true)
    Game.MapManager:SetIgnoreSceneUIMapCellLod(true)
  end
  self.defaultDir = self.viewdata.viewdata.questDataParams.defaultdir
  local defaultAction = self.viewdata.viewdata.questDataParams.defaultaction
  local actionData = Table_ActionAnime[defaultAction]
  if actionData then
    self.defaultActionName = actionData.Name
  end
  if self.defaultDir or self.defaultActionName then
    TimeTickManager.Me():CreateTick(0, 2000, function()
      self:UpdateResetMyselfIdleState()
    end, self, 1)
  end
end

function BatteryCannonView:UpdateQuestTrace()
  if not self.isRaid then
    return
  end
  local raidTaskData = QuestProxy.Instance:getTraceFubenQuestData()
  if raidTaskData then
    self.trace4raid:SetActive(true)
    self.trace4raidLabel.text = raidTaskData:parseTranceInfo()
  else
    self.trace4raid:SetActive(false)
  end
end

function BatteryCannonView:CameraRotate(delta)
  delta = delta or self.vec2CameraRotateDelta
  if delta[1] == 0 or self.isCameraMoving then
    return
  end
  VectorUtility.Asign_3(self.vecCameraLookPoint, self.vecCurCameraPos)
  self.tabCameraWorld.tsfRotateRoot:RotateAround(self.vecCameraLookPoint, LuaGeometry.GetTempVector3(0, 1, 0), delta[1])
  self.tabCameraWorld.tsfRotateRoot.parent = self.tsfWorldRoot
  self.tabCameraWorld.tsfRotateRoot:LookAt(self.vecCameraLookPoint)
  local eulerAngles = LuaGeometry.TempGetEulerAngles(self.tabCameraWorld.tsfRotateRoot)
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, eulerAngles.y, 0)
  self.tabCameraWorld.tsfRotateRoot.parent = self.tabCameraWorld.tsfMoveRoot
  self.isCameraRotating = true
  self.isForbidOperate = true
  local targetPos = LuaGeometry.TempGetPosition(self.tabCameraWorld.tsfRotateRoot)
  TweenPosition.Begin(self.tabCameraWorld.gameObject, 0.05, targetPos, true):SetOnFinished(function()
    self.tabCameraWorld.transform:LookAt(self.vecCameraLookPoint)
    self.isCameraRotating = false
    self.isForbidOperate = false
  end)
end

function BatteryCannonView:CameraMove(delta, limitedDistance)
  if self.isCameraRotating then
    return
  end
  local pos = VectorUtility.Asign_3(LuaGeometry.GetTempVector3(), self.vecCurCameraPos)
  local vecTempCameraVector = self.vecTempCameraVector
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformRight(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.x * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  LuaVector3.Better_Set(vecTempCameraVector, LuaGameObject.GetTransformForward(self.tabCameraWorld.tsfMoveRoot))
  LuaVector3.Mul(vecTempCameraVector, -delta.y * self.dragCameraSpeed)
  LuaVector3.Add(pos, vecTempCameraVector)
  local myselfPos = _Game.Myself:GetPosition()
  local newDistance = VectorUtility.DistanceXZ(myselfPos, pos)
  if newDistance > self.curDistance and newDistance > self.maxDistance then
    local deltaDistance = newDistance - self.curDistance
    if limitedDistance then
      newDistance = self.maxDistance
    else
      local extendPer = NumberUtility.Clamp01((self.curDistance - self.maxDistance) / self.springDistance)
      newDistance = self.curDistance + deltaDistance * (1 - math.pow(extendPer, self.springTight))
      if newDistance > self.extendMaxDistance then
        newDistance = self.extendMaxDistance
      end
    end
    pos:Sub(myselfPos)
    pos:Normalize()
    pos:Mul(newDistance)
    pos:Add(myselfPos)
  end
  self:CameraMoveTo(pos, newDistance)
end

function BatteryCannonView:ResetCameraToStartPos(callbackOnFinished)
  local tweeners = self.tabCameraWorld.gameObject:GetComponents(UITweener)
  if tweeners then
    for i = 1, #tweeners do
      GameObject.DestroyImmediate(tweeners[i])
    end
  end
  self.vecLastMyselfPos = VectorUtility.Asign_3(self.vecLastMyselfPos, _Game.Myself:GetPosition())
  self.tabCameraWorld.tsfMoveRoot.position = VectorUtility.Asign_3(self.vecCurCameraPos, _Game.Myself:GetPosition())
  local eulerX, eulerY, eulerZ = LuaGameObject.GetEulerAngles(self.tabCameraWorld.transform)
  self.tabCameraWorld.tsfMoveRoot.eulerAngles = LuaGeometry.GetTempVector3(0, eulerY, 0)
  local configOffset = GameConfig.Sniper.CameraStartOffset
  local cameraPos = LuaGeometry.GetTempVector3(configOffset[1] or 0, configOffset[2] or 12, configOffset[3] or -6)
  cameraPos = LuaGeometry.GetTempVector3(VectorHelper.RotateVector(cameraPos, 0, eulerY, 0))
  LuaVector3.Add(cameraPos, self.vecCurCameraPos)
  self.tabCameraWorld.tsfRotateRoot.position = cameraPos
  self.tabCameraWorld.tsfRotateRoot:LookAt(self.vecCurCameraPos)
  eulerX = LuaGameObject.GetEulerAngles(self.tabCameraWorld.tsfRotateRoot)
  self.tabCameraWorld.tsfRotateRoot.eulerAngles = LuaGeometry.GetTempVector3(eulerX, eulerY, 0)
  self.tabCameraWorld.cameraCopy.fieldOfView = FunctionCameraEffect.FreeCameraFov
  local switchDuration = GameConfig.Sniper.SwitchDuration or 0.5
  TweenFOV.Begin(self.tabCameraWorld.gameObject, switchDuration, FunctionCameraEffect.FreeCameraFov).method = 1
  TweenTransform.Begin(self.tabCameraWorld.gameObject, switchDuration, self.tabCameraWorld.tsfRotateRoot):SetOnFinished(function()
    if callbackOnFinished then
      callbackOnFinished()
    end
  end)
  self:ResetCurDistance(0)
end

function BatteryCannonView:IsInited()
  return self.isViewInited
end

function BatteryCannonView:CanOperate()
  return self:IsInited() and not self.isForbidOperate
end

function BatteryCannonView:WorldToScreenPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:WorldToScreenPoint(pos)
end

function BatteryCannonView:ScreenToWorldPoint(pos)
  if not self:IsInited() then
    redlog("Not Inited")
    return pos
  end
  return self.tabCameraWorld.cameraCopy:ScreenToWorldPoint(pos)
end

function BatteryCannonView:TryGetClickObjByLayers(layers, rayLength)
  rayLength = rayLength or 10000
  local ray = self.tabCameraWorld.camera:ScreenPointToRay(Input.mousePosition)
  local isHit, hitInfo
  for i = 1, #layers do
    isHit, hitInfo = Physics.Raycast(ray, LuaOut, rayLength, 1 << layers[i])
    if isHit then
      return hitInfo.collider.gameObject
    end
  end
end

function BatteryCannonView:DelayEnterWait()
  self:AddMonoUpdateFunction(self._CheckUpdate)
end

local lastTime, firstTime

function BatteryCannonView:_CheckUpdate()
  local ut = UnityRealtimeSinceStartup
  if not firstTime then
    firstTime = ut
  end
  if not lastTime then
    lastTime = ut
    return
  end
  if self:CheckCameraStatusOK() and (self:CheckPlayerStatusOK() and ut - lastTime < 0.07 or 10 <= ut - firstTime) then
    self:ClearDelayEnterWait()
    self:_OnEnter()
    return
  end
  lastTime = ut
end

function BatteryCannonView:ClearDelayEnterWait()
  self:RemoveMonoUpdateFunction()
  lastTime = nil
  firstTime = nil
end

function BatteryCannonView:OnEnter()
  self:DelayEnterWait()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeginChanged, self)
  UIViewAchievementPopupTip.Instance:PauseShowAchievementPopupTip()
  self.cannonType = self.viewdata.viewdata.questDataParams.cannonType or 1
  FunctionBatteryCannon.Me():Launch(self.cannonType)
  FunctionBatteryCannon.Me():SetViewInstance(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
  if Game.HotKeyManager.Running then
    self.needRestoreHotKey = true
    if Game.HotKeyManager.SetEnable then
      Game.HotKeyManager:SetEnable(false)
    else
      Game.HotKeyManager.Running = false
    end
  end
end

function BatteryCannonView:_GetCameraDir()
  local rotateDir = self.viewdata.viewdata.npcdata:GetAngleY()
  if self.viewdata.viewdata.questDataParams then
    if self.hyxMode then
      local faceDir = self.viewdata.viewdata.questDataParams.rotation[2]
      rotateDir = faceDir or rotateDir
    else
      local faceDir = self.viewdata.viewdata.questDataParams.dir
      rotateDir = faceDir or rotateDir
    end
  end
  return rotateDir
end

function BatteryCannonView:_GetCameraOffset()
  local cannonConfig = GameConfig.BatteryCannon and GameConfig.BatteryCannon[1]
  local offset = cannonConfig and cannonConfig.CameraView.offset or {
    0,
    0.5,
    0
  }
  if self.viewdata.viewdata.questDataParams then
    local targetPlayerOffset = self.viewdata.viewdata.questDataParams.offset or {
      0,
      0,
      0
    }
    offset[1] = offset[1] + targetPlayerOffset[1]
    offset[2] = offset[2] + targetPlayerOffset[2]
    offset[3] = offset[3] + targetPlayerOffset[3]
  end
  return offset
end

function BatteryCannonView:Show()
  BatteryCannonView.super.Show(self)
  self:_SetupSceneUIScale()
end

function BatteryCannonView:_SetupSceneUIScale()
  if self.farAwayMode == true then
    local scale = 1
    if self.sceneUIScale and self.sceneUIScale > 0 then
      scale = self.sceneUIScale
    else
      local scale1, scale2 = 1, 1
      local camera = CameraController.Instance or CameraController.singletonInstance
      if camera then
        local cameraPos = camera and camera.transform.position
        local cameraEuler = camera and camera.transform:TransformDirection(LuaVector3.forward)
        local isHit, hitInfo = Physics.Raycast(cameraPos, cameraEuler, LuaOut, 10000, 1 << Game.ELayer.Terrain | 1 << Game.ELayer.Cam_Filter)
        if isHit then
          scale1 = scale1 * hitInfo.distance / 5
        end
        isHit, hitInfo = Physics.Raycast(cameraPos, LuaVector3.down, LuaOut, 10000, 1 << Game.ELayer.Terrain | 1 << Game.ELayer.Cam_Filter)
        if isHit then
          scale2 = scale2 * hitInfo.distance / 5
        end
      end
      scale = (scale1 + scale2) / 2
      scale = math.clamp(scale, 1, 6)
    end
    SceneUIManager.Instance:SetCanvasScale(scale)
  end
end

function BatteryCannonView:_OnEnter()
  BatteryCannonView.super.OnEnter(self)
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraController then
    self:CloseSelf()
    return
  end
  local func = function()
    if not self.camCbSet then
      self.camCbSet = true
      TimeTickManager.Me():CreateTick(1000, 150, function(owner, deltaTime)
        if self.cameraController and self.cameraController.smoothToRunning == false then
          self:Show()
          FunctionBatteryCannon.Me():CreateFakeCannonNpc(self.cannonType)
          TimeTickManager.Me():ClearTick(self, 1001)
        end
      end, self, 1001)
    end
  end
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcdata then
    local viewdata = self.viewdata.viewdata
    self.cameraOriFov = self.cameraController.cameraFieldOfView
    self.cameraOriNearClipPlane = self.cameraController.activeCamera.nearClipPlane
    if self.viewdata.viewdata.questDataParams.target_pos and #self.viewdata.viewdata.questDataParams.target_pos > 0 then
      self.hyxMode = true
      local target_Pos = self.viewdata.viewdata.questDataParams.target_pos
      local camera_pos = self.viewdata.viewdata.questDataParams.pos
      local viewPort, rotation = FunctionBatteryCannon.Me():CalcCameraParams(camera_pos, target_Pos)
      local offset = self:_GetCameraOffset()
      offset = LuaVector3(offset[1], offset[2], offset[3])
      self.temp_targetTrans = GameObject("temp_targetTrans")
      self.temp_targetTrans.transform.localPosition = LuaGeometry.GetTempVector3(target_Pos[1], target_Pos[2], target_Pos[3])
      self.cameraController.activeCamera.nearClipPlane = 0.4
      self.cameraController:FieldOfViewTo(55, 0.01, nil)
      self:CameraFocusAndRotateTo(self.temp_targetTrans.transform, viewPort, rotation, 0.01, func, offset, true)
      if Game.MapManager:IsBigWorld() and BigWorld.BigWorldManager.Instance ~= nil then
        BigWorld.BigWorldManager.Instance:StartWatching(self.temp_targetTrans.transform.localPosition)
      end
      self.camResetDuration = 0
    elseif self.viewdata.viewdata.questDataParams.rotation and 0 < #self.viewdata.viewdata.questDataParams.rotation then
      self.hyxMode = true
      local camera_pos = self.viewdata.viewdata.questDataParams.pos
      local rotation = self.viewdata.viewdata.questDataParams.rotation
      local fov = self.viewdata.viewdata.questDataParams.fov or 55
      local viewPort, targetPos = FunctionBatteryCannon.Me():CalcCameraParams2(camera_pos, rotation)
      self.temp_targetTrans = GameObject("temp_targetTrans")
      self.temp_targetTrans.transform.localPosition = targetPos
      self.cameraController.activeCamera.nearClipPlane = 0.4
      self.cameraController:FieldOfViewTo(fov, 0.01, nil)
      self:CameraFocusAndRotateTo(self.temp_targetTrans.transform, viewPort, LuaVector3(rotation[1], rotation[2], rotation[3]), 0.01, func, nil, true)
      if Game.MapManager:IsBigWorld() and BigWorld.BigWorldManager.Instance ~= nil then
        BigWorld.BigWorldManager.Instance:StartWatching(self.temp_targetTrans.transform.localPosition)
      end
      self.camResetDuration = 0
    else
      local trans = viewdata.npcdata.assetRole.completeTransform
      local cannonType = 1
      local cannonConfig = GameConfig.BatteryCannon and GameConfig.BatteryCannon[cannonType]
      local viewPort = cannonConfig and cannonConfig.CameraView.viewPort
      local rotation = cannonConfig and cannonConfig.CameraView.rotation
      local rotateDir = self:_GetCameraDir()
      local offset = self:_GetCameraOffset()
      offset = LuaVector3(offset[1], offset[2], offset[3])
      self.cameraController.activeCamera.nearClipPlane = 0.4
      self.cameraController:FieldOfViewTo(55, CameraConfig.UI_Duration, nil)
      self:CameraFocusAndRotateTo(trans, LuaVector3(viewPort[1], viewPort[2], viewPort[3]), LuaVector3(rotation[1], rotateDir, rotation[3]), nil, func, offset, true)
    end
    self:SetCameraChangedContext()
  else
    func()
  end
  self:InitView()
end

function BatteryCannonView:SetCameraChangedContext()
  local context = {
    cft = self.cft,
    cameraOriFov = self.cameraOriFov,
    cameraOriNearClipPlane = self.cameraOriNearClipPlane,
    cameraController = self.cameraController,
    temp_targetTrans = self.temp_targetTrans,
    camResetDuration = self.camResetDuration
  }
  FunctionBatteryCannon.Me():SetIsCameraChanged(true, context)
end

function BatteryCannonView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  FunctionBatteryCannon.Me():SetViewInstance(nil)
  if self.hyxMode == true then
    FunctionBatteryCannon.Me():Shutdown_Misc()
  else
    FunctionBatteryCannon.Me():Shutdown()
  end
  if self.farAwayMode == true then
    AudioUtility.SetForceAssetRoleSE2D(nil)
    SceneUIManager.Instance:ResetCanvasScale()
    Game.MapManager:SetIgnoreSceneUIMapCellLod(nil)
    self.farAwayMode = nil
  end
  self:ClearCannonSkill()
  self.skillShotCutList:RemoveAll()
  self.isViewInited = false
  BatteryCannonView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeginChanged, self)
  UIViewAchievementPopupTip.Instance:ResumeShowAchievementPopupTip()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  if self.needRestoreHotKey then
    self.needRestoreHotKey = nil
    if Game.HotKeyManager.SetEnable then
      Game.HotKeyManager:SetEnable(true)
    else
      Game.HotKeyManager.Running = true
    end
  end
end

function BatteryCannonView:CheckPlayerStatusOK()
  return not Game.Myself.data:IsOnWolf()
end

function BatteryCannonView:CheckCameraStatusOK()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if self.cameraController ~= nil then
    return true
  end
end

function BatteryCannonView:OnSceneBeginChanged()
  self:CloseSelf()
  ServiceNUserProxy.Instance:ReturnToHomeCity()
end

function BatteryCannonView:OnDestroy()
  if self.tabCameraWorld then
    TableUtility.TableClear(self.tabCameraWorld)
  end
  BatteryCannonView.super.OnDestroy(self)
end

function BatteryCannonView:HandlePhaseSkillEffect(note)
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID == 0 then
    self:HidePhaseSkillEffect(skillID)
  else
    self:ShowPhaseSkillEffect(skillID)
  end
end

function BatteryCannonView:ShowPhaseSkillEffect(skillID)
  if SkillProxy.Instance:GetRandomSkillID() ~= nil then
    return
  end
  local cell = self:GetCell(skillID)
  if not cell then
    return
  end
  if self.phaseEffectCtrl == nil then
    self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay, self.phaseSkillEffect.transform, false, function(obj, args, effect)
      self.phaseEffectCtrl = effect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.phaseEffectCtrl:ResetLocalPositionXYZ(x, y, z)
      local scale = self.SkillBtnScale
      self.phaseEffectCtrl:ResetLocalScaleXYZ(scale, scale, scale)
    end)
  end
end

function BatteryCannonView:HidePhaseSkillEffect(skillID)
  if self.phaseEffectCtrl then
    self.phaseEffectCtrl:Destroy()
    self.phaseEffectCtrl = nil
  end
end

function BatteryCannonView:GetCell(skillID)
  if skillID then
    local cells = self.skillShotCutList:GetCells()
    for index, cell in pairs(cells) do
      if cell.data:GetID() == skillID then
        return cell
      end
    end
  end
  return nil
end

function BatteryCannonView:WaitNextUseHandler(note)
  local skillID = note.body
  if skillID then
    local cell = self:GetCell(skillID)
    if cell then
      self:_ShowWaitNextUseEffect(cell)
    end
  end
end

function BatteryCannonView:_ShowWaitNextUseEffect(cell)
  if self.nextEffectCtrl == nil then
    self.nextEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillWait, self.phaseSkillEffect.transform, false, function(obj, args, effect)
      self.nextEffectCtrl = effect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.nextEffectCtrl:ResetLocalPositionXYZ(x, y, z)
      local scale = self.SkillBtnScale
      self.nextEffectCtrl:ResetLocalScaleXYZ(scale, scale, scale)
    end)
  end
end

function BatteryCannonView:CancelWaitNextUseHandler(note)
  if self.nextEffectCtrl then
    self.nextEffectCtrl:Destroy()
    self.nextEffectCtrl = nil
  end
end

function BatteryCannonView:ShowUnlockSkillEffect(skillID)
  if SkillProxy.Instance:GetRandomSkillID() ~= nil then
    return
  end
  local cell = self:GetCell(skillID)
  if not cell then
    return
  end
  self:PlayUIEffect(EffectMap.UI.BatteryCannonSkillUnlock, self.phaseSkillEffect.transform, true, function(obj, args, effect)
    local unlockEffectCtrl = effect
    local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
    unlockEffectCtrl:ResetLocalPositionXYZ(x, y, z)
    local scale = self.SkillBtnScale
    unlockEffectCtrl:ResetLocalScaleXYZ(scale, scale, scale)
    AudioUtility.PlayOneShot2D_Path(AudioMap.UI.BatteryCannonSkillUnlock)
  end)
end

function BatteryCannonView:UpdateResetMyselfIdleState()
  if Game.Myself.skill:IsCastingSkill() or FunctionSkillTargetPointLauncher.Me():IsWorking() then
  else
    if self.defaultDir then
      Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.defaultDir)
    end
    if self.defaultActionName then
      Game.Myself:Client_PlayAction(self.defaultActionName, nil, true)
    end
  end
end

function BatteryCannonView:StartSkillCD(note)
  local cells = self.skillShotCutList:GetCells()
  local skill = note.body
  for _, o in pairs(cells) do
    o:TryStartCd()
  end
end
