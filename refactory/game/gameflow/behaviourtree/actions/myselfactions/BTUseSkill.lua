BTUseSkill = class("BTUseSkill", BTAction)
BTUseSkill.TypeName = "UseSkill"
BTDefine.RegisterAction(BTUseSkill.TypeName, BTUseSkill)

function BTUseSkill:ctor(config)
  BTUseSkill.super.ctor(self, config)
  self.skillId = config.skillId
end

function BTUseSkill:Dispose()
  BTUseSkill.super.Dispose(self)
end

function BTUseSkill:Exec(time, deltaTime, context)
  local ret = BTUseSkill.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self.skillId then
    return 0
  end
  FunctionSkill.Me():TryUseSkill(self.skillId)
  return 0
end
