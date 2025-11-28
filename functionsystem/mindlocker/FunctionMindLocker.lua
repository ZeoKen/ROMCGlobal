FunctionMindLocker = class("FunctionMindLocker")
local sceneName = "MindLockerScene"
local lockerName = "MindLocker"
local chainObjID = 1000
local fullScreenEffect = "ufx_Xinsuo_zc_001_prf"

function FunctionMindLocker.Me()
  if not FunctionMindLocker.instance then
    FunctionMindLocker.instance = FunctionMindLocker.new()
  end
  return FunctionMindLocker.instance
end

function FunctionMindLocker:ctor()
  self.manager = Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]
  self.lockers = {}
end

function FunctionMindLocker:AddEventListener()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.OnPlayerMapChange, self)
  EventManager.Me():AddEventListener(MyselfEvent.PlaceTo, self.OnSceneGoToUser, self)
end

function FunctionMindLocker:RemoveEventListener()
  EventManager.Me():RemoveEventListener(ServiceEvent.PlayerMapChange, self.OnPlayerMapChange, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.PlaceTo, self.OnSceneGoToUser, self)
end

function FunctionMindLocker:OnMindEnter(questData)
  if not self.isEntered then
    local params = questData.params
    if params then
      local questId = questData.id
      self.npcId = params.npc
      local effect = GameConfig.MindLocker and GameConfig.MindLocker.fullScreenEffect
      effect = effect or fullScreenEffect
      local duration = GameConfig.MindLocker and GameConfig.MindLocker.fullScreenEffectDuration
      duration = duration or 2
      FloatingPanel.Instance:PlayMidEffect(EffectMap.UI[effect], function(effectHandle)
        TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function()
          FloatingPanel.Instance:DestroyUIEffects()
          self:PlayEnterEffect(questId, params.lockers)
        end, self, 20000)
        self:SceneEnter()
        local roleEnterId = params.roleEnterId
        local roleData = GameConfig.MindRoleEnter and GameConfig.MindRoleEnter[roleEnterId]
        if roleData then
          self:RoleEnter(roleData.xOffset, roleData.yOffset, roleData.angleY, roleData.scale, roleData.actionId, roleData.expressionId, roleData.speed, roleData.isOnceAction)
        else
          self:RoleEnter()
        end
        local delay = GameConfig.MindLocker and GameConfig.MindLocker.cameraDelay
        delay = delay or 1
        TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function()
          self:CameraEnter()
          self:EnterView()
        end, self, 20005)
      end, true, true)
      self.isEntered = true
      self.questId = questId
    end
    self:AddEventListener()
    Game.Myself:Client_PauseIdleAI()
  else
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
end

function FunctionMindLocker:OnMindExit(questData)
  if self.isEntered then
    local questId = questData.id
    self:ExitAll(questId)
  end
end

function FunctionMindLocker:ExitAll(questId)
  if self.isEntered then
    local effect = GameConfig.MindLocker and GameConfig.MindLocker.fullScreenEffect
    effect = effect or fullScreenEffect
    FloatingPanel.Instance:PlayMidEffect(EffectMap.UI[effect], function(effectHandle)
      local delay = GameConfig.MindLocker and GameConfig.MindLocker.cameraDelay
      delay = delay or 1
      TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function()
        self:ClearAll()
        self:OnEffectPlayEnd(questId)
      end, self, 20006)
      local duration = GameConfig.MindLocker and GameConfig.MindLocker.fullScreenEffectDuration
      duration = duration or 2
      TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function()
        FloatingPanel.Instance:DestroyUIEffects()
      end, self, 20003)
    end, true, true)
  end
end

function FunctionMindLocker:ClearAll()
  self:ExitView()
  self:CameraExit()
  self:RoleExit()
  self:SceneExit()
  TableUtility.TableClearByDeleter(self.lockers, function(locker)
    GameObject.Destroy(locker)
  end)
  self.isEntered = false
  self.questId = nil
  self:RemoveEventListener()
  Game.Myself:Client_ResumeIdleAI()
end

function FunctionMindLocker:SceneEnter()
  local scenePath = ResourcePathHelper.UIModel(sceneName)
  local asset = Game.AssetManager:Load(scenePath)
  self.sceneRoot = GameObject.Instantiate(asset)
  self.sceneRoot.transform.position = LuaGeometry.GetTempVector3(1000, 1000, 0)
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, false)
  GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHideHead, false)
end

function FunctionMindLocker:SceneExit()
  if self.sceneRoot then
    GameObject.Destroy(self.sceneRoot)
    local scenePath = ResourcePathHelper.UIModel(sceneName)
    Game.AssetManager:UnloadAsset(scenePath)
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, true)
  GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHideHead, true)
end

function FunctionMindLocker:RoleEnter(xOffset, yOffset, angleY, scale, actionId, expressionId, speed, isOnce)
  if self.npcId then
    local parts = Asset_RoleUtility.CreateNpcRoleParts(self.npcId)
    if parts then
      self.role = Asset_Role.Create(parts, nil, function(assetRole)
        if GameConfig.MindLocker and GameConfig.MindLocker.npcLightColor then
          local color = GameConfig.MindLocker.npcLightColor
          assetRole:ActiveMulColor(LuaGeometry.GetTempColor(color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255))
        end
        actionId = actionId or 0
        self:PlayAction(assetRole, actionId, expressionId, speed, isOnce)
      end, self.npcId)
    end
    if self.role then
      local rolePos = Game.GameObjectUtil:DeepFind(self.sceneRoot, "RolePos")
      if rolePos then
        self.role:SetParent(rolePos.transform)
        xOffset = xOffset or 0
        yOffset = yOffset or 0
        self.role:SetPosition(LuaGeometry.GetTempVector3(xOffset, yOffset, 0))
        angleY = angleY or 0
        self.role:SetEulerAngleY(angleY)
        scale = scale or 1
        self.role:SetScale(scale)
      end
    end
  end
end

function FunctionMindLocker:RoleExit()
  if self.role then
    ReusableObject.Destroy(self.role)
    self.role = nil
  end
end

function FunctionMindLocker:PlayEnterEffect(questId, lockers)
  if self.manager then
    local enterAnim = GameConfig.MindLocker and GameConfig.MindLocker.enterAnim
    if enterAnim then
      self.manager:PlayAnimation(chainObjID, enterAnim)
    end
    local duration = GameConfig.MindLocker and GameConfig.MindLocker.enterAnimDuration
    duration = duration or 5
    TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function()
      local animator = self.manager:GetAnimator(chainObjID)
      if animator and lockers then
        for i = 1, #lockers do
          local id = lockers[i]
          local ep = Game.GameObjectUtil:DeepFind(animator.gameObject, "EP_" .. id)
          if ep then
            local path = ResourcePathHelper.UIModel(lockerName)
            local asset = Game.AssetManager:Load(path)
            local locker = GameObject.Instantiate(asset)
            locker.transform:SetParent(ep.transform, false)
            self.lockers[id] = locker
          end
        end
      end
      self:OnEffectPlayEnd(questId)
    end, self, 20001)
  end
end

local offset = LuaVector3(0, 1.13, 0)

function FunctionMindLocker:CameraEnter()
  if not self.cameraEntered then
    local pos = CameraConfig.Mind_Focus_Pos
    local viewPort = CameraConfig.Mind_ViewPort
    local rotation = CameraConfig.Mind_Rotation
    local fov = CameraConfig.Mind_FOV
    local duration = 0
    if not self.cameraFocus then
      self.cameraFocus = GameObject("cameraFocus")
    end
    self.cameraFocus.transform.position = pos
    local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
    local vp_x = 0.5 - (0.5 - viewPort[1]) * 1280 / viewWidth
    local fovFactor = math.tan(math.rad(24)) / math.tan(math.rad(fov))
    local vp = LuaVector3(vp_x, viewPort[2], viewPort[3] * fovFactor)
    self.cameraEffect = CameraEffectFocusAndRotateTo.new(self.cameraFocus.transform, offset, vp, rotation, duration, function()
      CameraController.singletonInstance:FieldOfViewTo(fov)
    end)
    FunctionCameraEffect.Me():Start(self.cameraEffect)
    Game.InputManager.disable = true
    self.cameraEntered = true
  end
end

function FunctionMindLocker:CameraExit()
  if self.cameraEntered then
    if self.cameraEffect then
      FunctionCameraEffect.Me():End(self.cameraEffect)
      self.cameraEffect = nil
    end
    if self.cameraFocus then
      GameObject.Destroy(self.cameraFocus)
      self.cameraFocus = nil
    end
    Game.InputManager.disable = false
    self.cameraEntered = false
  end
end

function FunctionMindLocker:EnterView()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MindLockerView
  })
end

function FunctionMindLocker:ExitView()
  local node = UIManagerProxy.Instance:GetNodeByPanelConfig(PanelConfig.MindLockerView)
  if node then
    local viewCtrl = node.viewCtrl
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, viewCtrl)
  end
end

function FunctionMindLocker:PlayUnlockEffect(questData)
  local params = questData.params
  local lockerId = params and params.lockerid
  local locker = self.lockers[lockerId]
  if locker then
    local animator = locker:GetComponent(Animator)
    local unlockAnim = GameConfig.MindLocker and GameConfig.MindLocker.unlockAnim
    if unlockAnim then
      animator:Play(unlockAnim)
    end
  end
  local duration = GameConfig.MindLocker and GameConfig.MindLocker.unlockAnimDuration
  duration = duration or 2
  TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function()
    self:OnEffectPlayEnd(questData.id)
  end, self, 20002)
end

function FunctionMindLocker:OnEffectPlayEnd(questId)
  if questId then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questId, questData.staticData.FinishJump)
    end
  end
end

function FunctionMindLocker:PlaySceneAnim(questData)
  local params = questData.params
  if params and self.manager then
    self.manager:PlayAnimation(params.objID, params.anim)
    local duration = params.duration or 2
    TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function()
      self:OnEffectPlayEnd(questData.id)
    end, self, 20004)
  end
end

local roleActionFinish = function(guid, args)
  local role = args[1]
  local isOnce = args[2]
  if role and isOnce == 1 then
    role:PlayAction_Idle()
  end
end

function FunctionMindLocker:PlayRoleAction(actionId, expressionId, speed, isOnce)
  self:PlayAction(self.role, actionId, expressionId, speed, isOnce)
end

function FunctionMindLocker:PlayAction(role, actionId, expressionId, speed, isOnce)
  if role then
    if speed then
      role:SetSpeedScale(speed)
    end
    local actionData = Table_ActionAnime[actionId]
    if actionData then
      local params = Asset_Role.GetPlayActionParams(actionData.Name, Asset_Role.ActionName.Idle, 1)
      params[7] = roleActionFinish
      params[8] = {role, isOnce}
      params[14] = true
      role:PlayAction(params)
    end
    if expressionId then
      role:SetExpression(expressionId, true)
    end
  end
end

function FunctionMindLocker:PlayRaidEffect(questData)
  local params = questData.params
  if params then
    local effect = params.effect
    local pos = params.pos
    local isAdd = params.add == 1
    local isRemove = params.add == 0
    local isButton = params.isButton == 1
    local buttonPos = params.buttonPos
    local buttonSize = params.buttonSize
    local node = UIManagerProxy.Instance:GetNodeByPanelConfig(PanelConfig.MindLockerView)
    if node then
      do
        local viewCtrl = node.viewCtrl
        if isAdd then
          if effect then
            viewCtrl:PlayEffect(EffectMap.UI[effect], function(effectHandle)
              local go = effectHandle.gameObject
              LuaGameObject.SetLocalPositionGO(go, pos[1], pos[2], 0)
            end)
          end
          if buttonSize then
            local confirmFunc = function()
              QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
            end
            local cancelFunc = function()
              ServiceQuestProxy.Instance:CallCloseUICmd(questData.id)
              self:ClearAll()
            end
            viewCtrl:AddCustomButton(function()
              MsgManager.ConfirmMsgByID(42101, confirmFunc, cancelFunc)
            end, buttonPos, buttonSize)
          end
        elseif isRemove then
          if effect then
            viewCtrl:DestroyEffect(EffectMap.UI[effect])
          end
          if isButton then
            viewCtrl:RemoveCustomButton()
          end
        end
      end
    end
  end
end

function FunctionMindLocker:OnPlayerMapChange()
  if self.isEntered then
    self:Clear(self.questId)
  end
end

function FunctionMindLocker:OnSceneGoToUser()
  if self.isEntered then
    self:Clear(self.questId)
  end
end

function FunctionMindLocker:Clear(questId)
  self:ClearAll()
  ServiceQuestProxy.Instance:CallCloseUICmd(questId)
end
