BTTargetMoveTo = class("BTTargetMoveTo", BTTargetAction)
BTTargetMoveTo.TypeName = "TargetMoveTo"
BTDefine.RegisterAction(BTTargetMoveTo.TypeName, BTTargetMoveTo)
local curPos = LuaVector3 and LuaVector3.Zero()
local newPos = LuaVector3 and LuaVector3.Zero()

function BTTargetMoveTo:ctor(config)
  BTTargetMoveTo.super.ctor(self, config)
  self.targetPosition = config.targetPosition and LuaVector3.New(config.targetPosition[1], config.targetPosition[2], config.targetPosition[3])
  self.speed = config.speed or 0
end

function BTTargetMoveTo:Dispose()
  BTTargetMoveTo.super.Dispose(self)
end

function BTTargetMoveTo:Exec(time, deltaTime, context)
  local ret = BTTargetMoveTo.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  if not self.targetPosition then
    return 0
  end
  local go = self.target.gameObject
  curPos[1], curPos[2], curPos[3] = LuaGameObject.GetPositionGO(go)
  LuaUtils.SetRotation(go, curPos, self.targetPosition)
  if self.speed == 0 then
    LuaGameObject.SetPositionGO(go, self.targetPosition[1], self.targetPosition[2], self.targetPosition[3])
  else
    LuaVector3.Better_MoveTowards(curPos, self.targetPosition, newPos, deltaTime * self.speed)
    LuaGameObject.SetPositionGO(go, newPos[1], newPos[2], newPos[3])
  end
  return 0
end
