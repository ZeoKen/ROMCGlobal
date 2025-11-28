BTTargetAction = class("BTTargetAction", BTAction)

function BTTargetAction:ctor(config)
  BTTargetAction.super.ctor(self, config)
  self.tag = config.tag
  self.id = config.id
  self.target = nil
end

function BTTargetAction:Dispose()
  BTTargetAction.super.Dispose(self)
  self.target = nil
end

function BTTargetAction:Exec(time, deltaTime, context)
  local ret = BTTargetAction.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self.target then
    self.target = BTDefine.GetTarget(self.tag, self.id, context)
  end
  if self.target == nil or LuaGameObject.ObjectIsNull(self.target) then
    self.target = nil
    return 1
  end
  return 0
end
