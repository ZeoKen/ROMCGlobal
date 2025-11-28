autoImport("GunShootConditionCell")
autoImport("PhotographPanel")
GunShootPanel = class("GunShootPanel", ContainerView)
GunShootPanel.ViewType = UIViewType.FocusLayer
local shoot_effect = "Skill/Eff_Shooting_atk"
GunShootPanel.FRONT_SIGHT_RANGE_NEAR = {
  x = {0.46, 0.54},
  y = {0.46, 0.54}
}
GunShootPanel.FRONT_SIGHT_RANGE_CLAMP = {
  x = {0.03, -0.03},
  y = {0.03, -0.03}
}
GunShootPanel.CLAMP_RANGE_PCT = {6, 90}
GunShootPanel.SHOOT_RANGE = 50
local tempVector3 = LuaVector3.Zero()
local PHOTOGRAPHER_StickArea = Rect(0, 0, 0, 0)
local qws_tex = "activity_bg_title"
local _pointColor = {
  Color(0.5647058823529412, 1.0, 0.4117647058823529, 1),
  Color(1.0, 0.4196078431372549, 0.4196078431372549, 1)
}
local lastPointLocalPos_X, lastPointLocalPos_Y
local lastPointObjTweenPosOffset = 40
local mid, sceneUI, point

function GunShootPanel:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end

function GunShootPanel:calZoom(del)
  local value = 21.635 / math.tan(del / 2 / 180 * math.pi)
  return value
end

function GunShootPanel:GetComposition(index)
  index = index or self.compositionIndex
  if nil == self.cameraData or nil == self.cameraData.Composition then
    return nil
  end
  return self.cameraData.Composition[index]
end

function GunShootPanel:SetCompositionIndex(index)
  self.compositionIndex = index
end

function GunShootPanel:setForceRotation()
  self:calFOVByPos()
  if nil ~= self.forceRotation then
    Game.InputManager.photograph.useForceRotation = true
    Game.InputManager.photograph.forceRotation = self.forceRotation
  else
    Game.InputManager.photograph.useForceRotation = false
  end
end

function GunShootPanel:calFOVByPos()
  local position
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      local topFocusUI = creatureObj:GetSceneUI().roleTopUI.topFocusUI
      position = topFocusUI:getPosition()
    end
  elseif self.symbol then
    position = self.symbol:getTarPosition()
  end
  if position then
    LuaVector3.Better_Set(tempVector3, Game.Myself.assetRole:GetCPOrRootPosition(RoleDefines_CP.Hair))
    LuaVector3.Better_Sub(position, tempVector3, tempVector3)
    if not self.forceRotation then
      self.forceRotation = LuaVector3.zero
    end
    self.forceRotation = LuaVector3.Better_Clone(tempVector3)
  end
end

function GunShootPanel:updateCameraAxis()
  local axisY = self.uiCm.transform.rotation.eulerAngles.y % 360
  self.cameraAxisY = self.cameraAxisY or 0
  local diff = math.abs(self.cameraAxisY - axisY)
  if 5 < diff then
    ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
    self.cameraAxisY = axisY
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
  end
  if self.needCheckReady and Game.InputManager.photograph.ready then
    self.needCheckReady = false
    FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.Self)
  end
end

function GunShootPanel:resetCameraData()
  Game.InputManager.model = InputManager.Model.DEFAULT
  if nil ~= self.cameraController then
    if self.originNearClipPlane then
      self.cameraController.activeCamera.nearClipPlane = self.originNearClipPlane
      self.cameraController.activeCamera.farClipPlane = self.originFarClipPlane
    end
    if self.originFocusViewPort then
      self.cameraController.photographInfo.focusViewPort = self.originFocusViewPort
    end
    if self.originFieldOfView then
      self.cameraController.photographInfo.fieldOfView = self.originFieldOfView
    end
  end
  if self.originStickArea then
    Game.InputManager.forceJoystickArea = self.originStickArea
  end
  if self.originFovMax then
    Game.InputManager.cameraFieldOfViewMin = self.originFovMin
    Game.InputManager.cameraFieldOfViewMax = self.originFovMax
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end

function GunShootPanel:_AddMonsterPoint()
  if not self.isQWS_BirdType then
    return
  end
  local creatures = NSceneNpcProxy.Instance:GetAll()
  for k, creature in pairs(creatures) do
    self:_AddPointSymbol(creature)
  end
end

function GunShootPanel:UpdateMonsterPointPanel()
  if not self.isQWS_BirdType then
    return
  end
  local scoreList = {}
  for k, v in pairs(self.monsters) do
    local data = {
      id = k,
      count = v.count
    }
    table.insert(scoreList, data)
  end
  table.sort(scoreList, function(l, r)
    return l.count > r.count
  end)
  for i = 1, 3 do
    if scoreList[i] then
      IconManager:SetNpcMonsterIconByID(scoreList[i].id, self.monsterScore[i].icon)
      self.monsterScore[i].score.text = scoreList[i].count
      if scoreList[i].count > 0 then
        self.monsterScore[i].score.color = LuaGeometry.GetTempVector4(0.5647058823529412, 1, 0.4117647058823529, 1)
      elseif scoreList[i].count < 0 then
        self.monsterScore[i].score.color = LuaGeometry.GetTempVector4(1, 0.4196078431372549, 0.4196078431372549, 1)
      end
    else
      self.monsterScore[i].go:SetActive(false)
    end
  end
end

function GunShootPanel:_AddPointSymbol(creature)
  if not (creature and creature.data) or not creature.data.staticData then
    return
  end
  mid = creature.data.staticData.id
  if not self.monsters then
    return
  end
  if not self.monsters[mid] then
    return
  end
  point = self.monsters[mid].count
  sceneUI = creature:GetSceneUI()
  if sceneUI and sceneUI.roleTopUI then
    sceneUI.roleTopUI:SetTopPointSymbol(point)
  end
end

function GunShootPanel:_RemoveMonsterPoint()
  if not self.isQWS_BirdType then
    return
  end
  local creatures = NSceneNpcProxy.Instance:GetAll()
  for k, creature in pairs(creatures) do
    sceneUI = creature:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:RemoveTopPointSymbol()
    end
  end
end

function GunShootPanel:Init()
  self:InitView()
end

function GunShootPanel:InitView()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraController then
    printRed("cameraController is nil")
    self:CloseSelf()
    return
  end
  self.uiCm = NGUIUtil:GetCameraByLayername("UI")
  self.sceneUiCm = NGUIUtil:GetCameraByLayername("Default")
  self.quitBtn = self:FindChild("quitBtn")
  self.takePicBtn = self:FindChild("takePicBtn")
  self:AddButtonEvent("quitBtn", function(go)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.takePicBtn, function(go)
    self:gunshoot()
    self:PlayUISound(AudioMap.UI.Picture)
  end)
end

function GunShootPanel:OnEnter()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.questData = viewdata.questData
    self.isQWS_BirdType = viewdata.birdShoot == true
    if not self.questData then
      self:CloseSelf()
      return
    end
  end
  self.shotMonsterMap = {}
  local isqws = self.isQWS_BirdType
  if isqws then
    self.qwsShootTimeContainer = self:FindGO("QWS_ShootTimeContainer")
    self.qwsTex = self:FindComponent("Texture", UITexture, self.qwsShootTimeContainer)
    self.qwsShootTimeContainer:SetActive(isqws)
    self.curShootMark = 0
    self.traceinfo = self:FindComponent("Traceinfo", UILabel, self.qwsShootTimeContainer)
    PictureManager.Instance:SetUI(qws_tex, self.qwsTex)
    self.lastPointLab = self:FindComponent("lastPoint", UILabel, self.qwsShootTimeContainer)
    self.lastPointLab.text = ""
    lastPointLocalPos_X, lastPointLocalPos_Y = LuaGameObject.GetLocalPosition(self.lastPointLab.gameObject.transform)
    self.scoreRoot = self:FindGO("ScoreRoot")
    self.scoreRoot:SetActive(true)
    self.monsterScore = {}
    for i = 1, 3 do
      local go = self:FindGO("MonsterCell" .. i, self.scoreRoot)
      self.monsterScore[i] = {}
      self.monsterScore[i].go = go
      self.monsterScore[i].icon = self:FindGO("Icon", go):GetComponent(UISprite)
      self.monsterScore[i].score = self:FindGO("ScoreLabel", go):GetComponent(UILabel)
    end
  else
    self.traceinfo = self:FindGO("countdown"):GetComponent(UILabel)
    self.sizeWidget = self:FindComponent("Size", UIWidget)
    self.condition = self:FindComponent("ConditionContainer", UIGrid)
    self.sizeWidget.width = math.max(self.condition.cellWidth * math.floor(#self.questData.params.monster / 2), self.condition.cellWidth)
    self.sizeWidget.width = math.max(self.sizeWidget.width, self.traceinfo.width + 100)
  end
  Game.QuestMiniMapEffectManager:SetEffectVisible(false, self.questData.id)
  self.traceinfo.text = self.questData.traceInfo or ""
  self.monsters = {}
  if isqws then
    self.qws_ShootTarget = self.questData.params.target
  end
  local paramMonster = self.questData.params.monster
  for i = 1, #paramMonster, 2 do
    if paramMonster[i + 1] then
      self.monsters[paramMonster[i]] = {
        shootOn = 0,
        count = paramMonster[i + 1]
      }
    end
  end
  self:UpdateMonsterPointPanel()
  self:UpdateShootMonsters()
  if self:CheckShootMonsters() then
    self:CloseSelf()
    return
  end
  self.shootRange = self.questData.params.range or GunShootPanel.SHOOT_RANGE
  self:initCameraCfgData()
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:ShowAll()
  FloatingPanel.Instance:SetMidMsgVisible(false)
  FunctionPet.Me():PetGiftActiveSelf(false)
  TimeTickManager.Me():CreateTick(0, 100, self.UpdateGunShootTargetSymbol, self, 1)
end

function GunShootPanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:ClearGunShootTargetSymbol()
  FloatingPanel.Instance:SetMidMsgVisible(true)
  Game.QuestMiniMapEffectManager:SetEffectVisible(true, self.questData.id)
  if self.questData.params.filter then
    FunctionSceneFilter.Me():EndFilter(self.questData.params.filter)
  end
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  if self.cameraAxisY then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY)
  end
  Game.AreaTriggerManager:SetIgnore(false)
  FunctionCameraEffect.Me():Resume()
  self:resetCameraData()
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  if self.originInputTouchSenseInch then
    Game.InputManager.touchSenseInch = self.originInputTouchSenseInch
    Game.InputManager:ResetParams()
  end
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:ResetLODEffect()
  _PerformanceManager:ResetLOD()
  _PerformanceManager:SkinWeightHigh(false)
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:HideAll()
  ReusableTable.DestroyAndClearTable(self.vpRange)
  if self.isQWS_BirdType then
    PictureManager.Instance:UnLoadUI(qws_tex, self.qwsTex)
  end
  FunctionPet.Me():PetGiftActiveSelf(true)
  self.super.OnExit(self)
end

function GunShootPanel:initCameraCfgData()
  FunctionCameraEffect.Me():Pause()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local id = viewdata.cameraId
    if id then
      printRed("PhotographPanel:from carrier cameraId:", id)
      self.cameraId = id
    end
  end
  Game.AreaTriggerManager:SetIgnore(true)
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:HighLODEffect()
  _PerformanceManager:LODHigh()
  _PerformanceManager:SkinWeightHigh(true)
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
  local layer = LayerMask.NameToLayer("UI")
  if layer then
    self.uiCemera = UICamera.FindCameraForLayer(layer)
    if self.uiCemera then
      self.originUiCmTouchDragThreshold = self.uiCemera.touchDragThreshold
      self.uiCemera.touchDragThreshold = 1
    end
  end
  self.originInputTouchSenseInch = Game.InputManager.touchSenseInch
  Game.InputManager.touchSenseInch = 0
  Game.InputManager:ResetParams()
  Game.InputManager.model = InputManager.Model.PHOTOGRAPH
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
  self:SetCompositionIndex(1)
  local pgInfo = self.cameraController.photographInfo
  if pgInfo then
    self.originFocusViewPort = pgInfo.focusViewPort
    local composition = self:GetComposition()
    if nil ~= composition then
      LuaVector3.Better_Set(tempVector3, composition[1], composition[2], self.cameraData.Radius)
    else
      LuaVector3.Better_Set(tempVector3, self.originFocusViewPort[1], self.originFocusViewPort[2], self.cameraData.Radius)
    end
    pgInfo.focusViewPort = tempVector3
    local defaultZoom = self.cameraData.DefaultZoom
    if defaultZoom then
      self.originFieldOfView = pgInfo.fieldOfView
      local fieldOfView = self:calFOVValue(defaultZoom)
      pgInfo.fieldOfView = fieldOfView
    end
  end
  local defaultDir = self.cameraData.DefaultDir
  if self.questData and self.questData.params and self.questData.params.faceDir then
    self.forceRotation = LuaVector3(self.questData.params.faceDir[1], self.questData.params.faceDir[2], self.questData.params.faceDir[3])
  end
  local defaultRoleDir = self.cameraData.DefaultRoleDir
  if defaultRoleDir and #defaultRoleDir ~= 0 then
    local x, y, z = Game.Myself.assetRole:GetEulerAnglesXYZ()
    local cx = defaultRoleDir[1] or 0
    local cy = defaultRoleDir[2] or 0
    local cz = defaultRoleDir[3] or 0
    x = x + cx
    y = y + cy
    z = z + cz
    self.forceRotation = LuaVector3(0, y, z)
  end
  if self.questData.params.filter then
    FunctionSceneFilter.Me():StartFilter(self.questData.params.filter)
  end
  self.originStickArea = Game.InputManager.forceJoystickArea
  self:changeToPHOTOGRAPHER()
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end

function GunShootPanel:changeToPHOTOGRAPHER()
  self:setForceRotation()
  if self.selfieStickArea then
    Game.InputManager.forceJoystickArea = self.selfieStickArea
  else
    Game.InputManager.forceJoystickArea = PHOTOGRAPHER_StickArea
  end
  self.curPhotoMode = FunctionCameraEffect.PhotographMode.PHOTOGRAPHER
  self.needCheckReady = true
  ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
  local forbidAction = self.actEmoj
  if self.actEmoj == 1 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
    forbidAction = 0
  elseif self.actEmoj == 3 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
    forbidAction = 1
  end
  self:sendNotification(PhotographModeChangeEvent.ModeChangeEvent, forbidAction)
  TimeTickManager.Me():CreateTick(500, 100, self.updateCameraAxis, self, PhotographPanel.TickType.UpdateAxis)
end

function GunShootPanel:UpdateGunShootTargetSymbol()
  local newTarget = NSceneNpcProxy.Instance:FindNearestInNearNpc(Game.Myself:GetPosition(), self.shootRange, function(npc)
    return self:checkShootTarget(npc, self.shootRange) == PhotographPanel.FocusStatus.Fit
  end)
  local id
  if newTarget ~= nil then
    id = newTarget.data.id
  end
  if self.shootRangeMonsterID ~= id then
    self:ClearGunShootTargetSymbol()
    self.shootRangeMonsterID = id
    self:SetGunShootTargetSymbol()
  end
end

function GunShootPanel:SetGunShootTargetSymbol()
  if self.shootRangeMonsterID ~= nil then
    local monster = NSceneNpcProxy.Instance:Find(self.shootRangeMonsterID)
    if monster ~= nil then
      local nsui = monster:GetSceneUI()
      nsui = nsui and nsui.roleTopUI
      if nsui then
        nsui:PlayMonsterShotFocusSymbol()
      end
    end
  end
end

function GunShootPanel:ClearGunShootTargetSymbol()
  if self.shootRangeMonsterID ~= nil then
    local monster = NSceneNpcProxy.Instance:Find(self.shootRangeMonsterID)
    if monster ~= nil then
      local nsui = monster:GetSceneUI()
      nsui = nsui and nsui.roleTopUI
      if nsui then
        nsui:RemoveMonsterShotFocusSymbol()
      end
    end
  end
  self.shootRangeMonsterID = nil
end

function GunShootPanel:gunshoot()
  if not self.resultEffect then
    self.resultEffect = self:PlayEffectByFullPath(self.questData.params.effect or shoot_effect, self.gameObject, false, function(go)
      go.transform.localPosition = LuaGeometry.Const_V3_zero
    end)
  else
    self.resultEffect:SetActive(false)
    self.resultEffect:SetActive(true)
  end
  CameraAdditiveEffectManager.Me():StartShake(0.1, 0.2)
  if self.shootRangeMonsterID ~= nil then
    ServiceNUserProxy.Instance:CallShootNpcUserCmd(self.shootRangeMonsterID)
  end
  self:UpdateShootMonsters()
  if self:CheckShootMonsters() then
    self:CloseSelf()
    return
  end
end

function GunShootPanel:checkShootTarget(creature, nearFocus)
  local result = PhotographPanel.FocusStatus.FarMore
  local playerPos = Game.Myself:GetPosition()
  local targetPosition = creature:GetPosition()
  local distance = LuaVector3.Distance(playerPos, targetPosition)
  local dis = nearFocus and nearFocus or self.shootRange
  local isFit = distance <= dis
  if isFit then
    local viewportRange = self:GetShootViewportRange(distance)
    local viewport = self.sceneUiCm:WorldToViewportPoint(targetPosition)
    local isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
    if isVisible then
      return PhotographPanel.FocusStatus.Fit
    end
    if creature.assetRole then
      local posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Middle)
      if posX then
        LuaVector3.Better_Set(tempVector3, posX, posY, posZ)
        viewport = self.sceneUiCm:WorldToViewportPoint(tempVector3)
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
      posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Top)
      if posX then
        LuaVector3.Better_Set(tempVector3, posX, posY, posZ)
        viewport = self.sceneUiCm:WorldToViewportPoint(tempVector3)
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
    end
  end
  return result
end

function GunShootPanel:GetShootViewportRange(dis)
  if not self.vpRange then
    self.vpRange = ReusableTable.CreateTable()
    self.vpRange.x = {}
    self.vpRange.y = {}
  end
  local clampRate = math.clamp((dis * 100 / self.shootRange - GunShootPanel.CLAMP_RANGE_PCT[1]) / (GunShootPanel.CLAMP_RANGE_PCT[2] - GunShootPanel.CLAMP_RANGE_PCT[1]), 0, 1)
  self.vpRange.x[1] = GunShootPanel.FRONT_SIGHT_RANGE_NEAR.x[1] + clampRate * GunShootPanel.FRONT_SIGHT_RANGE_CLAMP.x[1]
  self.vpRange.x[2] = GunShootPanel.FRONT_SIGHT_RANGE_NEAR.x[2] + clampRate * GunShootPanel.FRONT_SIGHT_RANGE_CLAMP.x[2]
  self.vpRange.y[1] = GunShootPanel.FRONT_SIGHT_RANGE_NEAR.y[1] + clampRate * GunShootPanel.FRONT_SIGHT_RANGE_CLAMP.y[1]
  self.vpRange.y[2] = GunShootPanel.FRONT_SIGHT_RANGE_NEAR.y[2] + clampRate * GunShootPanel.FRONT_SIGHT_RANGE_CLAMP.y[2]
  return self.vpRange
end

function GunShootPanel:UpdateShootMonsters()
  if self.shootRangeMonsterID then
    local mguid = self.shootRangeMonsterID
    if self.shotMonsterMap[mguid] == 1 then
      return
    else
      self.shotMonsterMap[mguid] = 1
    end
    local monster = NSceneNpcProxy.Instance:Find(mguid)
    if monster == nil then
      return
    end
    mid = monster.data.staticData.id
    if self.monsters[mid] then
      self.monsters[mid].shootOn = self.monsters[mid].shootOn + 1
      if self.isQWS_BirdType then
        point = self.monsters[mid].count
        self.curShootMark = math.max(0, self.curShootMark + self.monsters[mid].count)
        local pointColor = 0 < point and _pointColor[1] or _pointColor[2]
        local prefix = 0 < point and "+" or ""
        LuaVector3.Better_Set(tempVector3, lastPointLocalPos_X, lastPointLocalPos_Y, 0)
        self.lastPointLab.gameObject.transform.localPosition = tempVector3
        self.lastPointLab.text = prefix .. point
        self.lastPointLab.color = pointColor
        TweenAlpha.Begin(self.lastPointLab.gameObject, 0.5, 0)
        tempVector3[2] = tempVector3[2] + lastPointObjTweenPosOffset
        TweenPosition.Begin(self.lastPointLab.gameObject, 0.5, tempVector3, false)
      end
    end
  end
  self:UpdateConditionList()
end

function GunShootPanel:UpdateConditionList()
  if self.isQWS_BirdType then
    self:_updateQWS_Condition()
  else
    self:_updateNormalCondition()
  end
end

function GunShootPanel:_updateQWS_Condition()
  if not self.qws_curShootMarkLab then
    self.qws_curShootMarkLab = self:FindComponent("qws_curShootMark", UILabel)
  end
  if self.qws_curShootMarkLab then
    self.qws_curShootMarkLab.text = tostring(self.curShootMark) .. "/" .. tostring(self.qws_ShootTarget)
  end
end

function GunShootPanel:_updateNormalCondition()
  if not self.conditionList then
    self.condition = self:FindComponent("ConditionContainer", UIGrid)
    self.conditionList = UIGridListCtrl.new(self.condition, GunShootConditionCell, "GunShootConditionCell")
  end
  local tmpList = ReusableTable.CreateArray()
  for k, v in pairs(self.monsters) do
    TableUtility.ArrayPushBack(tmpList, {
      mid = k,
      shootOn = v.shootOn,
      count = v.count
    })
  end
  self.conditionList:ResetDatas(tmpList)
  ReusableTable.DestroyAndClearArray(tmpList)
end

function GunShootPanel:CheckShootMonsters()
  if self.isQWS_BirdType then
    return self:_checkQWS_ShootMonster()
  else
    return self:_checkNormalShoot()
  end
end

function GunShootPanel:HandleAddNpc(note)
  if not self.isQWS_BirdType then
    return
  end
  local creatures = note.body
  for _, creature in pairs(creatures) do
    self:_AddPointSymbol(creature)
  end
end

function GunShootPanel:_checkNormalShoot()
  self.fin = true
  for _, v in pairs(self.monsters) do
    if v.shootOn < v.count then
      self.fin = false
      break
    end
  end
  return self.fin
end

function GunShootPanel:_checkQWS_ShootMonster()
  self.fin = self.curShootMark >= self.qws_ShootTarget
  return self.fin
end

function GunShootPanel:CloseSelf()
  if self.questData then
    if self.fin then
      if self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FinishJump then
        QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
      else
        redlog("射击：任务数据有误")
      end
    elseif self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FailJump then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
    else
      redlog("射击：任务数据有误")
    end
  end
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    GunShootPanel.super.CloseSelf(self)
  end, self)
end
