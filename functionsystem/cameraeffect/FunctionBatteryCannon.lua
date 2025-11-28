FunctionBatteryCannon = class("FunctionBatteryCannon", CoreView)

function FunctionBatteryCannon.Me()
  if nil == FunctionBatteryCannon.me then
    FunctionBatteryCannon.me = FunctionBatteryCannon.new()
  end
  return FunctionBatteryCannon.me
end

function FunctionBatteryCannon:ctor()
  self:AddListener()
end

function FunctionBatteryCannon:AddListener()
  EventManager.Me():AddEventListener(MyselfEvent.BeginSkillBroadcast, self.SkillBroadcastCheck, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.HandleSceneLoaded, self)
end

function FunctionBatteryCannon:HandleSceneLoaded()
  self:Shutdown()
end

function FunctionBatteryCannon:Launch(cannonType)
  if not self.isWorking then
    Game.InputManager.disableMove = Game.InputManager.disableMove + 1
    self.ori_disableHorizontalFreeCamera = Game.InputManager.disableHorizontalFreeCamera
    self.ori_disableVerticalFreeCamera = Game.InputManager.disableVerticalFreeCamera
    Game.InputManager.disableHorizontalFreeCamera = true
    Game.InputManager.disableVerticalFreeCamera = true
    Game.InputManager:ResetFreeCameraParams()
    Game.Myself:Client_NoMove(true)
    Game.Myself:Client_SetAutoBattle(false)
    Game.Myself:Client_SetAutoBattleStanding(true)
    local cannonType = cannonType or 1
    self.filterID = GameConfig.BatteryCannon[cannonType] and GameConfig.BatteryCannon[cannonType].Filter or 54
    FunctionSceneFilter.Me():StartFilter(self.filterID)
    if Game.Myself.data:IsOnWolf() then
      self.playerEverOnWolf = true
      local skill = SkillProxy.Instance:GetLearnedSkillBySortID(1240)
      if skill then
        if self.waitOffTick then
          TimeTickManager.Me():ClearTick(self, 1225)
          self.waitOffTick = nil
        end
        do
          local safeTime = 0
          self.waitOffTick = TimeTickManager.Me():CreateTick(0, 500, function(o, deltaTime)
            safeTime = safeTime + deltaTime
            if not Game.Myself.data:IsOnWolf() or 50000 < deltaTime then
              TimeTickManager.Me():ClearTick(self, 1225)
              self.waitOffTick = nil
              GameFacade.Instance:sendNotification(MyselfEvent.EnterBatteryCannon)
            else
              Game.Myself:Client_UseSkill(skill.staticData.id)
            end
          end, self, 1225)
        end
      end
    else
      GameFacade.Instance:sendNotification(MyselfEvent.EnterBatteryCannon)
    end
  end
  self.isWorking = true
  self.totalUsedTime = 0
end

function FunctionBatteryCannon:Shutdown()
  self:Shutdown_Misc()
  self:Shutdown_ResetCamera()
end

function FunctionBatteryCannon:SetIsCameraChanged(changed, context)
  self.isCameraChanged = changed
  self.cameraChangedContext = context
end

function FunctionBatteryCannon:Shutdown_Misc()
  if self.isWorking then
    self.totalUsedTime = 0
    self.isWorking = nil
    Game.InputManager.disableMove = Game.InputManager.disableMove - 1
    Game.InputManager.disableHorizontalFreeCamera = self.ori_disableHorizontalFreeCamera
    Game.InputManager.disableVerticalFreeCamera = self.ori_disableVerticalFreeCamera
    Game.InputManager:ResetFreeCameraParams()
    Game.Myself:Client_NoMove(false)
    Game.Myself:Client_SetAutoBattleStanding(false)
    if self.filterID then
      FunctionSceneFilter.Me():EndFilter(self.filterID)
    end
    GameFacade.Instance:sendNotification(MyselfEvent.ExitBatteryCannon)
    self:ClearFakeCannonNpc()
    if self.ViewInstance then
      self.ViewInstance:CloseSelf()
    end
    self.ViewInstance = nil
    self.skillBroadcastCache = nil
    self.serverSkillConfig = nil
    if self.playerEverOnWolf then
      self.playerEverOnWolf = nil
      if not Game.Myself.data:IsOnWolf() then
        local skill = SkillProxy.Instance:GetLearnedSkillBySortID(1240)
        if skill then
          Game.Myself:Client_UseSkill(skill.staticData.id)
        end
      end
    end
  end
end

function FunctionBatteryCannon:Shutdown_ResetCamera()
  if self.isCameraChanged and self.cameraChangedContext ~= nil then
    self.isCameraChanged = nil
    local cxt = self.cameraChangedContext
    if cxt.cft ~= nil then
      if cxt.camResetDuration then
        cxt.cft.duration = cxt.camResetDuration
      end
      FunctionCameraEffect.Me():End(cxt.cft)
      cxt.cft = nil
    end
    Game.Myself:UpdateEpNodeDisplay(false)
    if cxt.cameraController and cxt.cameraController.activeCamera then
      cxt.cameraController:FieldOfViewTo(cxt.cameraOriFov, cxt.camResetDuration or CameraConfig.UI_Duration, nil)
      cxt.cameraController.activeCamera.nearClipPlane = cxt.cameraOriNearClipPlane
    end
    if cxt.temp_targetTrans then
      GameObject.Destroy(cxt.temp_targetTrans)
      cxt.temp_targetTrans = nil
    end
    if Game.MapManager:IsBigWorld() and BigWorld.BigWorldManager.Instance ~= nil then
      BigWorld.BigWorldManager.Instance:StopWatching()
    end
    Game.MapCellManager:ResetCenterTransform(Game.Myself.assetRole.completeTransform)
    Game.AreaTriggerManager:SetIgnore(false)
    self.cameraChangedContext = nil
  end
end

function FunctionBatteryCannon:InitAsServerCannonAndOpenView(questData)
  self:SetServerSkillConfig(questData.params.skills, questData.params.locked, questData.params.cannonType)
  if not self.ViewInstance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BatteryCannonView,
      viewdata = {
        npcdata = Game.Myself,
        questDataParams = table.deepcopy(questData.params)
      }
    })
  else
    self.ViewInstance:RefreshCannonSkill()
  end
end

function FunctionBatteryCannon:IsWorking()
  return self.isWorking == true
end

function FunctionBatteryCannon:SetServerSkillConfig(config, locked, cannonType)
  if not self.serverSkillConfig then
    self.serverSkillConfig = {}
  end
  local cannonType = cannonType or 1
  local baseConfig = GameConfig.BatteryCannon and GameConfig.BatteryCannon[cannonType] and GameConfig.BatteryCannon[cannonType].CannonSkill
  local defaultConfig
  for _, v in pairs(baseConfig) do
    defaultConfig = v
    break
  end
  local rm = {}
  for k, _ in pairs(self.serverSkillConfig) do
    if not config[k] then
      rm[#rm + 1] = k
    end
  end
  for k, v in pairs(config) do
    if not self.serverSkillConfig[k] then
      self.serverSkillConfig[k] = table.deepcopy(baseConfig[k] or defaultConfig)
    end
    self.serverSkillConfig[k].useTime = v
  end
  for i = 1, #rm do
    self.serverSkillConfig[rm[i]] = nil
  end
  self:UpdateServerSkillConfigLocked(locked)
end

function FunctionBatteryCannon:UpdateServerSkillConfigLocked(locked)
  for k, v in pairs(self.serverSkillConfig) do
    v.locked = locked ~= nil and TableUtility.ArrayFindIndex(locked, k) > 0
  end
end

function FunctionBatteryCannon:GetSkillConfig(npcFunctionData)
  local inRaid = Game.MapManager:IsRaidMode()
  if inRaid or self.serverSkillConfig ~= nil and next(self.serverSkillConfig) then
    return self.serverSkillConfig
  else
    if not self.localSkillConfig then
      local npcFunctionConfig = npcFunctionData and npcFunctionData.Parama.CannonSkill
      local cannonType = npcFunctionData and npcFunctionData.Parama and npcFunctionData.Parama.cannonType or 1
      local baseConfig = GameConfig.BatteryCannon and GameConfig.BatteryCannon[cannonType]
      baseConfig = baseConfig and baseConfig.CannonSkill
      self.localSkillConfig = {}
      for i = 1, #npcFunctionConfig do
        local skillId = npcFunctionConfig[i]
        local skillConfig = baseConfig[skillId]
        if skillConfig then
          skillConfig.costItem = SkillProxy.GetSkillCostItemId(skillId)
          self.localSkillConfig[skillId] = skillConfig
        end
      end
    end
    return self.localSkillConfig
  end
end

function FunctionBatteryCannon:GetTempCamera()
  local camera = NGUIUtil:GetCameraByLayername("Default")
  return camera
end

function FunctionBatteryCannon:CalcCameraParams(camera_pos, target_pos)
  local camera = NGUIUtil:GetCameraByLayername("Default")
  local newObj = GameObject("temp_camera")
  local temp_camera = newObj:AddComponent(Camera)
  temp_camera:CopyFrom(camera)
  temp_camera.fieldOfView = 55
  temp_camera.nearClipPlane = 0.4
  newObj.transform.localPosition = LuaGeometry.GetTempVector3(camera_pos[1], camera_pos[2], camera_pos[3])
  local target_pos_vec = LuaGeometry.GetTempVector3(target_pos[1], target_pos[2], target_pos[3])
  newObj.transform:LookAt(target_pos_vec)
  local viewPort = temp_camera:WorldToViewportPoint(target_pos_vec)
  newObj:SetActive(false)
  GameObject.Destroy(newObj)
  return viewPort, newObj.transform.localEulerAngles
end

function FunctionBatteryCannon:CalcCameraParams2(camera_pos, camera_euler, fov)
  local camera = NGUIUtil:GetCameraByLayername("Default")
  local newObj = GameObject("temp_camera")
  local temp_camera = newObj:AddComponent(Camera)
  temp_camera:CopyFrom(camera)
  temp_camera.fieldOfView = fov or 55
  temp_camera.nearClipPlane = 0.4
  newObj.transform.localPosition = LuaGeometry.GetTempVector3(camera_pos[1], camera_pos[2], camera_pos[3])
  newObj.transform.localEulerAngles = LuaGeometry.GetTempVector3(camera_euler[1], camera_euler[2], camera_euler[3])
  local viewPortPos = LuaVector3.New(0.5, 0.5, temp_camera.nearClipPlane)
  local targetPos = temp_camera:ViewportToWorldPoint(viewPortPos)
  newObj:SetActive(false)
  GameObject.Destroy(newObj)
  return viewPortPos, targetPos
end

function FunctionBatteryCannon:DestroyTempCamera()
  if not Slua.IsNull(self.temp_camera) then
    GameObject.DestroyImmediate(self.temp_camera.gameObject)
    self.temp_camera = nil
  end
end

function FunctionBatteryCannon:CreateFakeCannonNpc(cannonType)
  if self.fakeCannonNpc1 or self.fakeCannonNpc2 then
    redlog("CreateFakeCannonNpc already exist")
    return
  end
  local cannonType = cannonType or 1
  local cannonConfig = GameConfig.BatteryCannon and GameConfig.BatteryCannon[cannonType]
  local bodyid = cannonConfig and cannonConfig.CannonNpcBody
  local camera, radAngle, halfRadHFOV, hFOV, rotateDelta, clipPlaneFactor, clipPlane, transConfig, inputWorldPos1, inputWorldPos2, camRotateDir
  local init_params = function()
    if camera then
      return
    end
    camera = self:GetTempCamera()
    radAngle = math.rad(camera.fieldOfView * 0.5)
    halfRadHFOV = math.atan(math.tan(radAngle) * camera.aspect)
    hFOV = math.deg(halfRadHFOV) * 2
    rotateDelta = hFOV / 2 - 46.12
    clipPlaneFactor = math.cos(halfRadHFOV) / 0.6932
    clipPlane = camera.nearClipPlane * 2 * clipPlaneFactor
    transConfig = cannonConfig and cannonConfig.CannonTransform
    inputWorldPos1 = camera:ViewportToWorldPoint(LuaGeometry.GetTempVector3(transConfig.viewPort[1], transConfig.viewPort[2], clipPlane))
    inputWorldPos2 = camera:ViewportToWorldPoint(LuaGeometry.GetTempVector3(1 - transConfig.viewPort[1], transConfig.viewPort[2], clipPlane))
    camRotateDir = self.ViewInstance:_GetCameraDir()
  end
  self.fakeCannonNpc1 = Asset_RolePart.Create(Asset_Role.PartIndex.Body, bodyid, function(rolePart, arg, assetRolePart)
    init_params()
    self.fakeCannonNpc1 = assetRolePart
    self.fakeCannonNpc1:SetLayer(Game.ELayer.Outline)
    self.fakeCannonNpc1:ResetLocalPosition(inputWorldPos1)
    self.fakeCannonNpc1:ResetLocalEulerAngles(LuaGeometry.GetTempVector3(transConfig.Rotate[1], 90 + rotateDelta + camRotateDir, transConfig.Rotate[3]))
    self.fakeCannonNpc1:ResetLocalScaleXYZ(transConfig.Scale[1], transConfig.Scale[2], transConfig.Scale[3])
    self.fakeCannonNpc1:ResetParent(camera.gameObject.transform, true)
    if not self.fakeCannonNpc1:GetPartAction_() then
      self.fakeCannonNpc1:SetPartAction_(true)
    end
  end, nil, Asset_RolePart.SkinQuality.Bone4)
  self.fakeCannonNpc1:RegisterWeakObserver(self)
  self.fakeCannonNpc2 = Asset_RolePart.Create(Asset_Role.PartIndex.Body, bodyid, function(rolePart, arg, assetRolePart)
    init_params()
    self.fakeCannonNpc2 = assetRolePart
    self.fakeCannonNpc2:SetLayer(Game.ELayer.Outline)
    self.fakeCannonNpc2:ResetLocalPosition(inputWorldPos2)
    self.fakeCannonNpc2:ResetLocalEulerAngles(LuaGeometry.GetTempVector3(transConfig.Rotate[1], 90 - rotateDelta + camRotateDir, transConfig.Rotate[3]))
    self.fakeCannonNpc2:ResetLocalScaleXYZ(transConfig.Scale[1], transConfig.Scale[2], transConfig.Scale[3])
    self.fakeCannonNpc2:ResetParent(camera.gameObject.transform, true)
    if not self.fakeCannonNpc2:GetPartAction_() then
      self.fakeCannonNpc2:SetPartAction_(true)
    end
  end, nil, Asset_RolePart.SkinQuality.Bone4)
  self.fakeCannonNpc2:RegisterWeakObserver(self)
end

function FunctionBatteryCannon:ObserverDestroyed(obj)
  if obj == self.fakeCannonNpc1 then
    self.fakeCannonNpc1:UnregisterWeakObserver(self)
    self.fakeCannonNpc1 = nil
  end
  if obj == self.fakeCannonNpc2 then
    self.fakeCannonNpc2:UnregisterWeakObserver(self)
    self.fakeCannonNpc2 = nil
  end
end

function FunctionBatteryCannon:ClearFakeCannonNpc()
  if self.fakeCannonNpc1 and self.fakeCannonNpc1:Alive() then
    self.fakeCannonNpc1:SetEpNodesDisplay(false)
    self.fakeCannonNpc1:Destroy()
  end
  self.fakeCannonNpc1 = nil
  if self.fakeCannonNpc2 and self.fakeCannonNpc2:Alive() then
    self.fakeCannonNpc2:SetEpNodesDisplay(false)
    self.fakeCannonNpc2:Destroy()
  end
  self.fakeCannonNpc2 = nil
  self:DestroyTempCamera()
end

function FunctionBatteryCannon:SetViewInstance(view)
  self.ViewInstance = view
  if view then
    self:GetTempCamera()
  end
end

function FunctionBatteryCannon:SkillBroadcastCheck(sbInfo)
  if not self.isWorking then
    return
  end
  local skillIDAndLevel = sbInfo[1]
  local skillPhase = sbInfo[2]
  if skillPhase ~= nil and skillPhase < 0 then
    return
  end
  if not self.skillBroadcastCache then
    self.skillBroadcastCache = {}
  end
  if self.skillBroadcastCache[skillIDAndLevel] and skillPhase > self.skillBroadcastCache[skillIDAndLevel] then
    return
  end
  self.skillBroadcastCache[skillIDAndLevel] = skillPhase
  local current_SkillConfig = self:GetSkillConfig()
  current_SkillConfig = current_SkillConfig and current_SkillConfig[skillIDAndLevel]
  if not current_SkillConfig then
    return
  end
  if Game.MapManager:IsRaidMode() and current_SkillConfig.leftTime then
    current_SkillConfig.leftTime = current_SkillConfig.leftTime - 1
  end
  if not current_SkillConfig.usedTime then
    current_SkillConfig.usedTime = 0
  end
  current_SkillConfig.usedTime = current_SkillConfig.usedTime + 1
  self.totalUsedTime = self.totalUsedTime + 1
  local fakeCannonNpc
  if self.totalUsedTime % 2 == 0 then
    fakeCannonNpc = self.fakeCannonNpc1
  else
    fakeCannonNpc = self.fakeCannonNpc2
  end
  if fakeCannonNpc then
    fakeCannonNpc:PlayAction_("attack", "")
  end
  if self.ViewInstance then
    self.ViewInstance:RefreshCannonSkill()
  end
  AudioUtility.PlayOneShot2D_Path(AudioMap.Maps.BatteryCannonFire)
end

autoImport("Asset_RolePart")

function Asset_RolePart:PlayAction_(name, defaultName, speed, normalizedTime, callback, callbackArg)
  local rolePart = self.args[9]
  if not rolePart or not rolePart.partAction then
    return
  end
  local nameHash = ActionUtility.GetNameHash(name)
  if not self:HasAction_(rolePart, nameHash) then
    name = ActionName.Idle
    defaultName = ActionName.Idle
  end
  defaultName = defaultName or ActionName.Idle
  nameHash = ActionUtility.GetNameHash(name)
  local defaultNameHash = ActionUtility.GetNameHash(defaultName)
  if callback == nil then
    rolePart:PlayAction(nameHash, defaultNameHash, speed or 1, normalizedTime or 0)
  else
    rolePart:PlayAction(nameHash, defaultNameHash, speed or 1, normalizedTime or 0, callback, callbackArg)
  end
end

function Asset_RolePart:HasAction_(rolePart, nameHash)
  if not rolePart then
    return false
  end
  local animator = rolePart.animators[1]
  if not animator then
    return false
  end
  return animator:HasState(0, nameHash)
end

function Asset_RolePart:SetPartAction_(isPartAction)
  if self.args[9] then
    self.args[9].partAction = isPartAction
  end
end

function Asset_RolePart:GetPartAction_()
  if self.args[9] then
    return self.args[9].partAction
  end
  return false
end
