BTParallel = class("BTParallel", BTNode)
BTParallel.TypeName = "Parallel"
BTDefine.RegisterComposite(BTParallel.TypeName, BTParallel)

function BTParallel:ctor(config)
  BTParallel.super.ctor(self, config)
end

function BTParallel:Dispose()
  BTParallel.super.Dispose(self)
end

function BTParallel:Exec(time, deltaTime, context)
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  if self.preCondition and self.preCondition:Exec(time, deltaTime, context) ~= 0 then
    return 1
  end
  local ret = 1
  for _, v in ipairs(self.children) do
    if v and v:Exec(time, deltaTime, context) == 0 then
      ret = 0
    end
  end
  return ret
end
