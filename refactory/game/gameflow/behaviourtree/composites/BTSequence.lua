BTSequence = class("BTSequence", BTNode)
BTSequence.TypeName = "Sequence"
BTDefine.RegisterComposite(BTSequence.TypeName, BTSequence)

function BTSequence:ctor(config)
  BTSequence.super.ctor(self, config)
end

function BTSequence:Dispose()
  BTSequence.super.Dispose(self)
end

function BTSequence:Exec(time, deltaTime, context)
  if self.service then
    self.service:Exec(time, deltaTime, context)
  end
  if self.preCondition and self.preCondition:Exec(time, deltaTime, context) ~= 0 then
    return 1
  end
  for _, v in ipairs(self.children) do
    local ret = v:Exec(time, deltaTime, context)
    if ret == 1 then
      return ret
    end
  end
  return 0
end
