BTIsLookingAt = class("BTIsLookingAt", BTTargetCondition)
BTIsLookingAt.TypeName = "IsLookingAt"
BTDefine.RegisterDecorator(BTIsLookingAt.TypeName, BTIsLookingAt)
local tempPosition = LuaVector3 and LuaVector3.Zero()
local tempForward = LuaVector3 and LuaVector3.Zero()

function BTIsLookingAt:ctor(config)
  BTIsLookingAt.super.ctor(self, config)
  self.targetPosition = config.targetPosition and LuaVector3.New(config.targetPosition[1], config.targetPosition[2], config.targetPosition[3])
  self.tolerance = config.tolerance or 0.99
end

function BTIsLookingAt:Dispose()
  BTIsLookingAt.super.Dispose(self)
end

function BTIsLookingAt:Exec(time, deltaTime, context)
  local ret = BTIsLookingAt.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 1, self.failRet
  end
  if not self.targetPosition then
    return 1, self.failRet
  end
  tempPosition[1], tempPosition[2], tempPosition[3] = LuaGameObject.GetPositionGO(self.target.gameObject)
  tempForward[1], tempForward[2], tempForward[3] = LuaGameObject.GetTransformForward(self.target)
  LuaVector3.Better_Sub(self.targetPosition, tempPosition, tempPosition)
  LuaVector3.Normalized(tempPosition)
  ret = LuaVector3.Dot(tempPosition, tempForward) > self.tolerance and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
