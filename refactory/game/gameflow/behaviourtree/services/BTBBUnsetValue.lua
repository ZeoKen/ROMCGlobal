BTBBUnsetValue = class("BTBBUnsetValue", BTService)
BTBBUnsetValue.TypeName = "BBUnsetValue"
BTDefine.RegisterService(BTBBUnsetValue.TypeName, BTBBUnsetValue)

function BTBBUnsetValue:ctor(config)
  BTBBUnsetValue.super.ctor(self, config)
  self.paramKey = config.bbParam and config.bbParam.name
end

function BTBBUnsetValue:Dispose()
  BTBBUnsetValue.super.Dispose(self)
end

function BTBBUnsetValue:Exec(time, deltaTime, context)
  local bb = context and context.blackboard
  if bb and self.paramKey then
    bb:UnsetGlobalData(self.paramKey)
  end
  return 0
end
