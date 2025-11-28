BTCooldown = class("BTCooldown", BTNode)
BTCooldown.TypeName = "Cooldown"
BTDefine.RegisterComposite(BTCooldown.TypeName, BTCooldown)

function BTCooldown:ctor(config)
  BTCooldown.super.ctor(self, config)
  self.nextExecTime = 0
  self.cd = config.cd or 0
end

function BTCooldown:Dispose()
  BTCooldown.super.Dispose(self)
end

function BTCooldown:Exec(time, deltaTime, context)
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  if self.preCondition and self.preCondition:Exec(time, deltaTime, context) ~= 0 then
    return 1
  end
  if time <= self.nextExecTime then
    return 1
  end
  local ret = 1
  for _, v in ipairs(self.children) do
    if v and v:Exec(time, deltaTime, context) == 0 then
      ret = 0
    end
  end
  if ret == 0 then
    self.nextExecTime = time + self.cd
  end
  return ret
end
