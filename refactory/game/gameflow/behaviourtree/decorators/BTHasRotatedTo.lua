BTHasRotatedTo = class("BTHasRotatedTo", BTTargetCondition)
BTHasRotatedTo.TypeName = "HasRotatedTo"
BTDefine.RegisterDecorator(BTHasRotatedTo.TypeName, BTHasRotatedTo)
local tempRotation = LuaQuaternion and LuaQuaternion.Identity()

function BTHasRotatedTo:ctor(config)
  BTHasRotatedTo.super.ctor(self, config)
  self.targetRotation = config.targetRotation and LuaQuaternion.New(config.targetRotation[1], config.targetRotation[2], config.targetRotation[3], config.targetRotation[4])
  self.tolerance = config.tolerance or 0.99
end

function BTHasRotatedTo:Dispose()
  BTHasRotatedTo.super.Dispose(self)
end

function BTHasRotatedTo:Exec(time, deltaTime, context)
  local ret = BTHasRotatedTo.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret, self.failRet
  end
  if not self.targetRotation then
    return 1, self.failRet
  end
  tempRotation[1], tempRotation[2], tempRotation[3], tempRotation[4] = LuaGameObject.GetRotationGO(self.target.gameObject)
  ret = LuaQuaternion.Dot(tempRotation, self.targetRotation) > self.tolerance and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
