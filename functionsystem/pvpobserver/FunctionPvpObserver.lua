FunctionPvpObserver = class("FunctionPvpObserver", EventDispatcher)
local _MaxCameraDis = 10
local _InitObFov = 46

function FunctionPvpObserver.Me()
  if nil == FunctionPvpObserver.me then
    FunctionPvpObserver.me = FunctionPvpObserver.new()
  end
  return FunctionPvpObserver.me
end

function FunctionPvpObserver:ctor()
  self:Init()
end

function FunctionPvpObserver:Init()
end

function FunctionPvpObserver:OnLeaveScene()
  self:ClearCheckTargetTick()
  self.curTargetGUID = nil
  self.targetCreature = nil
end

function FunctionPvpObserver:SwitchToTarget(guid)
  if self.curTargetGUID == guid then
    return
  end
  self.curTargetGUID = guid
  if guid then
    if not self.tickCheckTarget then
      self.tickCheckTarget = TimeTickManager.Me():CreateTick(0, 100, self.UpdateCheckTarget, self, 2)
    end
  else
    self:ClearCheckTargetTick()
    self:_SwitchToTargetCreature(Game.Myself)
  end
end

function FunctionPvpObserver:UpdateCheckTarget()
  if not self.curTargetGUID then
    self:_SwitchToTargetCreature(Game.Myself)
    self:ClearCheckTargetTick()
    return
  end
  local nCreature = SceneCreatureProxy.FindCreature(self.curTargetGUID)
  if not nCreature or not self:_SwitchToTargetCreature(nCreature) then
    return
  end
  self:ClearCheckTargetTick()
end

function FunctionPvpObserver:ClearCheckTargetTick()
  if not self.tickCheckTarget then
    return
  end
  TimeTickManager.Me():ClearTick(self, 2)
  self.tickCheckTarget = nil
end

function FunctionPvpObserver:ReAddCreature(creature)
  if not creature then
    return
  end
  if MyselfProxy.Instance:IsObTarget(creature.data.id) then
    self:_SwitchToTargetCreature(creature)
  end
end

function FunctionPvpObserver:_SwitchToTargetCreature(creature)
  if not creature then
    LogUtility.Error("FunctionPvpObserver: Target Creature is nil")
    return true
  end
  local cameraController = CameraController.singletonInstance
  if not cameraController then
    LogUtility.Error("FunctionPvpObserver: Cannot Find CameraController When SwitchToTargetCreature: " .. creature.data.id)
    return false
  end
  local focusTrans = creature:GetRoleComplete().transform
  local info = cameraController.defaultInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.FreeDefaultInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.photographInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  info = cameraController.currentInfo
  if info and info.focus ~= focusTrans then
    info.focus = focusTrans
  end
  cameraController:ForceApplyCurrentInfo()
  if creature == Game.Myself then
    self.targetCreature = nil
  else
    self.targetCreature = creature
    local position = creature:GetPosition()
    MyselfProxy.Instance:UpdateObPosition(creature.data.id, position[1], position[2], position[3])
  end
  return true
end

function FunctionPvpObserver:ResetViewPort()
  local cameraCtl = CameraController.singletonInstance
  if not cameraCtl then
    return
  end
  local viewPort = cameraCtl.focusViewPort
  local port = LuaGeometry.GetTempVector3(viewPort.x, viewPort.y, _MaxCameraDis)
  cameraCtl:ResetFocusViewPort(port)
  cameraCtl:ResetFieldOfView(_InitObFov)
end

function FunctionPvpObserver:ObserverdPlayerOffline(charid)
  if self.targetCreature and self.targetCreature.data.id == charid then
    self.targetCreature = nil
    self.curTargetGUID = nil
    PvpObserveProxy.Instance:BeGhost()
    self:ClearCheckTargetTick()
    self:_SwitchToTargetCreature(Game.Myself)
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.AttachOb, true)
  end
end
