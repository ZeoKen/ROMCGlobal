BTAction = class("BTAction", BTNode)
BTAction.TypeName = "EmptyAction"
BTDefine.RegisterAction(BTAction.TypeName, BTAction)

function BTAction:ctor(config)
  BTAction.super.ctor(self, config)
  self.preConditionOutput = nil
  self.enable = true
end

function BTAction:Dispose()
  BTAction.super.Dispose(self)
end

function BTAction:Exec(time, deltaTime, context)
  if not self.enabled then
    return 1
  end
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  local ret = 0
  if self.preCondition then
    ret, self.preConditionOutput = self.preCondition:Exec(time, deltaTime, context)
  end
  return ret
end
