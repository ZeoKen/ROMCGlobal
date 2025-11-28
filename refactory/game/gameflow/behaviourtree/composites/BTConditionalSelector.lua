BTConditionalSelector = class("BTConditionalSelector", BTNode)
BTConditionalSelector.TypeName = "ConditionalSelector"
BTDefine.RegisterComposite(BTConditionalSelector.TypeName, BTConditionalSelector)
BTConditionalSelector.Schema = {
  {
    ParamType = "boolean",
    ParamName = "alwaysExec",
    Required = true
  }
}

function BTConditionalSelector:ctor(config)
  BTConditionalSelector.super.ctor(self, config)
  if config.alwaysExec ~= nil then
    self.alwaysExec = config.alwaysExec
  else
    self.alwaysExec = true
  end
  self.lastRet = 1
end

function BTConditionalSelector:Dispose()
  BTConditionalSelector.super.Dispose(self)
end

function BTConditionalSelector:Exec(time, deltaTime, context)
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  if not self.preCondition then
    redlog("[bt] BTConditionalSelector must define a preCondition")
    return 1
  end
  local ret, childIndex = self.preCondition:Exec(time, deltaTime, context)
  if not childIndex then
    return ret
  end
  local child = self.children[childIndex]
  if not child then
    return 1
  end
  if self.lastChildIndex ~= childIndex or self.alwaysExec then
    self.lastChildIndex = childIndex
    self.lastRet = child:Exec(time, deltaTime, context)
    return self.lastRet
  end
  return self.lastRet
end
