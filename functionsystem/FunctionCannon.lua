FunctionCannon = class("FunctionCannon", EventDispatcher)
FunctionCannon.Type = {
  None = 0,
  Cannon = 1,
  Airdrop = 2
}
local _FixedDeltaTime = Time.fixedDeltaTime
local _Fire_Angle = GameConfig.Cannon and GameConfig.Cannon.angel or 0
local _TempVector3 = LuaVector3.Zero()
local _VecDown = LuaVector3(0, -1, 0)
local _VecForward = LuaVector3.Forward()
local _Gravity = 9.8
local _CameraCrl, _Camera
local _HitEffect = EffectMap.Maps.ItemSmoke
local _FireAE = AudioMap.UI.Picture
local _GetCamera = function()
  _CameraCrl = CameraController.Instance or CameraController.singletonInstance
  if _CameraCrl then
    return _CameraCrl.activeCamera
  end
  return Camera.main
end

function FunctionCannon:IsCannonRunning()
  return self.running and self.cannonType == FunctionCannon.Type.Cannon
end

function FunctionCannon:IsAirdropRunning()
  return self.running and self.cannonType == FunctionCannon.Type.Airdrop
end

function FunctionCannon:GetFireDuration(height)
  return math.sqrt(2 * height / _Gravity)
end

function FunctionCannon.Me()
  if nil == FunctionCannon.me then
    FunctionCannon.me = FunctionCannon.new()
  end
  return FunctionCannon.me
end

function FunctionCannon:ctor()
  self:Init()
end

function FunctionCannon:Init()
  self.verticalSpeed = LuaVector3.Zero()
  self.horizontalSpeed = LuaVector3.Zero()
  self.duration = 0
  self.cameraForwardDir = LuaVector3.Zero()
  self.birthEp = nil
  self.height = 0
  self.flyingTime = 0
end

function FunctionCannon:SetFlyInfo(transform)
  local x, y, z = LuaGameObject.GetPositionGO(transform.gameObject)
  LuaVector3.Better_Set(_TempVector3, x, y, z)
  local time = self:GetFireDuration(y)
  return _TempVector3, y, time
end

function FunctionCannon:LaunchCannon(npc_id, cannon_type)
  self.cannonType = cannon_type or FunctionCannon.Type.Cannon
  self.npcID = npc_id
  local nnpc = NSceneNpcProxy.Instance:Find(npc_id)
  if not nnpc then
    return
  end
  self.birthEp = nnpc.assetRole:GetEP(RoleDefines_EP.Top)
  _CameraCrl = CameraController.Instance or CameraController.singletonInstance
  _Camera = _GetCamera()
  if not _Camera then
    return
  end
  self.running = self:GetOn()
  local pos, height, time = self:SetFlyInfo(self.birthEp)
  self.height = height
  self.flyingTime = time
  if self:IsAirdropRunning() then
    Game.Myself:Logic_PlaceTo(pos)
    self:SetPlayerDir()
  end
end

function FunctionCannon:GetOn()
  if self.running then
    return false
  end
  if not _CameraCrl then
    return false
  end
  local nnpc = NSceneNpcProxy.Instance:Find(self.npcID)
  if not nnpc then
    redlog("未找到炮台npc : ", self.npcID)
    return false
  end
  Game.AreaTriggerManager:SetIgnore(true)
  FunctionCameraEffect.Me():Pause()
  local info = _CameraCrl.photographInfo
  self.originalFocus = info.focus
  self.originalFocusViewPort = info.focusViewPort
  self.originalFocusOffset = info.focusOffset
  self.originPhotographSwitchDuration = _CameraCrl.photographSwitchDuration
  self.originalRotateVertMinAngle = InputRotateProcesser.VertMinAngle
  self.originalRotateVertMaxAngle = InputRotateProcesser.VertMaxAngle
  InputRotateProcesser.VertMinAngle = 0
  InputRotateProcesser.VertMaxAngle = 0
  self.epTransform = nnpc.assetRole:GetEP(RoleDefines_EP.Top)
  info.focus = self.epTransform
  LuaVector3.Better_Set(_TempVector3, 0.5, 1, 0.5)
  info.focusViewPort = _TempVector3
  LuaVector3.Better_Set(_TempVector3, 0, 0, 0)
  info.focusOffset = _TempVector3
  Game.InputManager.model = InputManager.Model.PHOTOGRAPH
  _CameraCrl.photographSwitchDuration = 0
  _CameraCrl:ForceApplyCurrentInfo()
  Game.Myself:SetVisible(false, LayerChangeReason.InteractNpc)
  FunctionPlayerUI.Me():MaskAllUI(Game.Myself, PUIVisibleReason.InteractNpc)
  FunctionCameraEffect.Me():ForceDisableCameraPushOn(true)
  return true
end

function FunctionCannon:GetOff()
  Game.AreaTriggerManager:SetIgnore(false)
  FunctionCameraEffect.Me():Resume()
  InputRotateProcesser.VertMinAngle = self.originalRotateVertMinAngle
  InputRotateProcesser.VertMaxAngle = self.originalRotateVertMaxAngle
  Game.Myself:SetVisible(true, LayerChangeReason.InteractNpc)
  FunctionPlayerUI.Me():UnMaskAllUI(Game.Myself, PUIVisibleReason.InteractNpc)
  if not _CameraCrl then
    return
  end
  local info = _CameraCrl.photographInfo
  info.focus = self.originalFocus
  info.focusViewPort = self.originalFocusViewPort
  info.focusOffset = self.originalFocusOffset
  _CameraCrl:ForceApplyCurrentInfo()
  redlog("_CameraCrl.photographSwitchDuration: ", _CameraCrl.photographSwitchDuration)
  _CameraCrl.photographSwitchDuration = 0
  redlog("设置0")
  Game.InputManager.model = InputManager.Model.DEFAULT
  FunctionCameraEffect.Me():ForceDisableCameraPushOn(false)
end

function FunctionCannon:ResetSwitchDuration()
end

function FunctionCannon:ShutDown()
  if not self.running then
    return
  end
  self:GetOff()
  self.running = false
  self.cannonType = nil
  self.npcID = nil
end

function FunctionCannon:SetPower(var)
  if not var then
    return
  end
  if var == self.firePower then
    return
  end
  self.firePower = var
  self:_SetHorizontalSpeed()
end

function FunctionCannon:_SetHorizontalSpeed()
  local camera = _GetCamera()
  if not camera then
    return
  end
  self.cameraForwardDir = camera.transform.forward
  self.horizontalSpeed = LuaQuaternion.Euler(_Fire_Angle, 0, 0) * self.cameraForwardDir * self.firePower
end

function FunctionCannon:CreatBullet()
  local x, y, z = LuaGameObject.GetPositionGO(self.birthEp.gameObject)
  if self:IsCannonRunning() then
    self:DestroyBullet()
    self.bullet = GameObject.CreatePrimitive(PrimitiveType.Sphere)
    self.bullet.name = "CannonBullet"
    self.bulletHeight = y
    self.bullet.transform.position = LuaGeometry.GetTempVector3(x, y - 0.2, z)
    self.bullet.transform.eulerAngles = _Camera.transform.eulerAngles
    local testScale = 0.2
    LuaGameObject.SetLocalScaleGO(self.bullet, testScale, testScale, testScale)
  elseif self:IsAirdropRunning() then
    self:SetPlayerDir()
    self:GetOff()
  end
end

function FunctionCannon:SetPlayerDir()
  local _, toY = LuaGameObject.GetEulerAngles(_Camera.transform)
  Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, toY, true)
end

function FunctionCannon:FireBegin(power)
  AudioUtility.PlayOneShot2D_Path(_FireAE)
  self:SetPower(power)
  if nil ~= self.tick then
    self:FireEnd()
  end
  self:_InitFire()
  self.tick = TimeTickManager.Me():CreateTick(0, 10, self._UpdateTick, self)
end

function FunctionCannon:Hit(hit_point, isVertical)
  local p_hitYAxis = isVertical and 0 or hit_point.y
  if self:IsCannonRunning() then
    Asset_Effect.PlayOneShotAtXYZ(EffectMap.Maps.ItemSmoke, hit_point.x, p_hitYAxis, hit_point.z, nil, nil, nil)
  end
  self:FireEnd()
end

function FunctionCannon:_UpdateTick()
  self.duration = self.duration + _FixedDeltaTime
  self.verticalSpeed[2] = -_Gravity * self.duration
  local deltaPos = (self.horizontalSpeed + self.verticalSpeed) * _FixedDeltaTime
  if self:IsCannonRunning() then
    self.bullet.transform.position = self.bullet.transform.position + deltaPos
  else
    local pos = Game.Myself:GetPosition()
    local newpos = pos + deltaPos
    Game.Myself:Logic_PlaceXYZTo(newpos[1], newpos[2], newpos[3])
  end
  local originalPos = self:IsCannonRunning() and self.bullet.transform.position or Game.Myself:GetPosition()
  local isHit, hitInfo = Physics.Raycast(originalPos, _VecDown, LuaOut, 0.2, 1 << Game.ELayer.Terrain)
  if isHit then
    self:Hit(hitInfo.point)
    return
  end
  isHit, hitInfo = Physics.Raycast(originalPos, _VecForward, LuaOut, 0.2)
  if isHit then
    self:Hit(hitInfo.point, true)
  end
end

function FunctionCannon:_InitFire()
  self:CreatBullet()
  self:_ResetFireParam()
  self:RestoreAirDropCameraRotation()
end

function FunctionCannon:RestoreAirDropCameraRotation()
  local info = _CameraCrl.FreeDefaultInfo
  local x, y, z = LuaGameObject.GetEulerAngles(_Camera.transform)
  LuaVector3.Better_Set(_TempVector3, x, y, z)
  info.rotation = _TempVector3
  info = _CameraCrl.defaultInfo
  info.rotation = _TempVector3
end

function FunctionCannon:DestroyBullet()
  if self.bullet then
    GameObject.Destroy(self.bullet)
  end
end

function FunctionCannon:_ClearTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
end

function FunctionCannon:_ResetFireParam()
  self.cameraForwardDir = _Camera.transform.forward
  self.horizontalSpeed = LuaQuaternion.Euler(_Fire_Angle, 0, 0) * self.cameraForwardDir * self.firePower
  self.verticalSpeed[2] = 0
  self.duration = 0
  self.flyingTime = 0
end

function FunctionCannon:FireEnd()
  self:_ResetFireParam()
  self:_ClearTick()
  if self:IsCannonRunning() then
    self:DestroyBullet()
  end
end
