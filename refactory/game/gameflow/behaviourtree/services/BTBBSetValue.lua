BTBBSetValue = class("BTBBSetValue", BTService)
BTBBSetValue.TypeName = "BBSetValue"
BTDefine.RegisterService(BTBBSetValue.TypeName, BTBBSetValue)

function BTBBSetValue:ctor(config)
  BTBBSetValue.super.ctor(self, config)
  self.paramKey = config.bbParam and config.bbParam.name
  self.paramVal = config.bbParam and config.bbParam.value
end

function BTBBSetValue:Dispose()
  BTBBSetValue.super.Dispose(self)
end

function BTBBSetValue:Exec(time, deltaTime, context)
  local bb = context and context.blackboard
  if bb and self.paramKey then
    bb:SetGlobalData(self.paramKey, self.paramVal)
  end
  return 0
end
