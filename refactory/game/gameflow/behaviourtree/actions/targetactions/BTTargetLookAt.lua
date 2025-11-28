BTTargetLookAt = class("BTTargetLookAt", BTTargetAction)
BTTargetLookAt.TypeName = "TargetLookAt"
BTDefine.RegisterAction(BTTargetLookAt.TypeName, BTTargetLookAt)
local tempPos = LuaVector3 and LuaVector3.Zero()
local tempTargetRotation = LuaQuaternion and LuaQuaternion.Identity()
local tempCurRotation = LuaQuaternion and LuaQuaternion.Identity()

function BTTargetLookAt:ctor(config)
  BTTargetLookAt.super.ctor(self, config)
  self.targetPosition = config.targetPosition and LuaVector3.New(config.targetPosition[1], config.targetPosition[2], config.targetPosition[3])
  self.rotateSpeed = config.rotateSpeed or 0
end

function BTTargetLookAt:Dispose()
  BTTargetLookAt.super.Dispose(self)
end

function BTTargetLookAt:Exec(time, deltaTime, context)
  local ret = BTTargetLookAt.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  if not self.targetPosition then
    return 0
  end
  local go = self.target.gameObject
  tempPos[1], tempPos[2], tempPos[3] = LuaGameObject.GetPositionGO(go)
  if self.rotateSpeed == 0 then
    LuaUtils.SetRotation(go, tempPos, self.targetPosition)
  else
    LuaVector3.Better_Sub(self.targetPosition, tempPos, tempPos)
    LuaVector3.Normalized(tempPos)
    LuaQuaternion.Better_LookRotation(tempTargetRotation, tempPos)
    tempCurRotation[1], tempCurRotation[2], tempCurRotation[3], tempCurRotation[4] = LuaGameObject.GetRotationGO(go)
    LuaQuaternion.Better_RotateTowards(tempCurRotation, tempTargetRotation, tempCurRotation, deltaTime * self.rotateSpeed)
    LuaGameObject.SetRotationGO(go, tempCurRotation[1], tempCurRotation[2], tempCurRotation[3], tempCurRotation[4])
  end
  return 0
end
