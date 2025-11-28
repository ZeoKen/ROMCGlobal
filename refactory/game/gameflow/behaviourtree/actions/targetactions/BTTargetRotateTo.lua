BTTargetRotateTo = class("BTTargetRotateTo", BTTargetAction)
BTTargetRotateTo.TypeName = "TargetRotateTo"
BTDefine.RegisterAction(BTTargetRotateTo.TypeName, BTTargetRotateTo)
local tempRotation = LuaQuaternion and LuaQuaternion.Identity()

function BTTargetRotateTo:ctor(config)
  BTTargetRotateTo.super.ctor(self, config)
  self.targetRotation = config.targetRotation and LuaQuaternion.New(config.targetRotation[1], config.targetRotation[2], config.targetRotation[3], config.targetRotation[4])
  self.rotateSpeed = config.rotateSpeed or 0
end

function BTTargetRotateTo:Dispose()
  BTTargetRotateTo.super.Dispose(self)
end

function BTTargetRotateTo:Exec(time, deltaTime, context)
  local ret = BTTargetRotateTo.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  if not self.targetRotation then
    return 0
  end
  local go = self.target.gameObject
  if self.rotateSpeed == 0 then
    LuaGameObject.SetRotationGO(go, self.targetRotation[1], self.targetRotation[2], self.targetRotation[3], self.targetRotation[4])
  else
    tempRotation[1], tempRotation[2], tempRotation[3], tempRotation[4] = LuaGameObject.GetRotationGO(go)
    LuaQuaternion.Better_RotateTowards(tempRotation, self.targetRotation, tempRotation, deltaTime * self.rotateSpeed)
    LuaGameObject.SetRotationGO(go, tempRotation[1], tempRotation[2], tempRotation[3], tempRotation[4])
  end
  return 0
end
