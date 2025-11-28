BTTargetCondition = class("BTTargetCondition", BTCondition)

function BTTargetCondition:ctor(config)
  BTTargetCondition.super.ctor(self, config)
  self.tag = config.tag
  self.id = config.id
  self.target = nil
end

function BTTargetCondition:Dispose()
  BTTargetCondition.super.Dispose(self)
  self.target = nil
end

function BTTargetCondition:Exec(time, deltaTime, context)
  if not self.target then
    self.target = BTDefine.GetTarget(self.tag, self.id, context)
  end
  if self.target == nil or LuaGameObject.ObjectIsNull(self.target) then
    self.target = nil
    return 1, self.failRet
  end
  return 0, self.passRet
end
