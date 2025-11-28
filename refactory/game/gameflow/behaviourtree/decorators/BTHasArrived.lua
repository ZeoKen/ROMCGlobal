BTHasArrived = class("BTHasArrived", BTTargetCondition)
BTHasArrived.TypeName = "HasArrived"
BTDefine.RegisterDecorator(BTHasArrived.TypeName, BTHasArrived)
local tempPos = LuaVector3 and LuaVector3.Zero()

function BTHasArrived:ctor(config)
  BTHasArrived.super.ctor(self, config)
  self.targetPosition = config.targetPosition and LuaVector3.New(config.targetPosition[1], config.targetPosition[2], config.targetPosition[3])
  self.tolerance = config.tolerance or 0.01
  self.toleranceSqr = self.tolerance * self.tolerance
end

function BTHasArrived:Dispose()
  BTHasArrived.super.Dispose(self)
end

function BTHasArrived:Exec(time, deltaTime, context)
  local ret = BTHasArrived.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 1, self.failRet
  end
  if not self.targetPosition then
    return 1, self.failRet
  end
  tempPos[1], tempPos[2], tempPos[3] = LuaGameObject.GetPositionGO(self.target.gameObject)
  ret = LuaVector3.Distance_Square(tempPos, self.targetPosition) <= self.toleranceSqr and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
