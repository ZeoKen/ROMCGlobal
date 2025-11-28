BTAbort = class("BTAbort", BTAbort)
BTAbort.TypeName = "Abort"
BTDefine.RegisterAction(BTAbort.TypeName, BTAbort)

function BTAbort:ctor(config)
  BTAbort.super.ctor(self, config)
end

function BTAbort:Dispose()
  BTAbort.super.Dispose(self)
end

function BTAbort:Exec(time, deltaTime, context)
  local ret = BTAbort.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  context.enabled = false
  return 0
end
