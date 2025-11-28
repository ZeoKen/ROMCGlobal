BTSelector = class("BTSelector", BTNode)
BTSelector.TypeName = "Selector"
BTDefine.RegisterComposite(BTSelector.TypeName, BTSelector)

function BTSelector:ctor(config)
  BTSelector.super.ctor(self, config)
end

function BTSelector:Dispose()
  BTSelector.super.Dispose(self)
end

function BTSelector:Exec(time, deltaTime, context)
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  if self.preCondition and self.preCondition:Exec(time, deltaTime, context) ~= 0 then
    return 1
  end
  for _, v in ipairs(self.children) do
    local ret = v:Exec(time, deltaTime, context)
    if ret == 0 then
      return ret
    end
  end
  return 1
end
