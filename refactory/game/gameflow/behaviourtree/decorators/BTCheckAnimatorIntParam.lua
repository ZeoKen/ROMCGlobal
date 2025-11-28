BTCheckAnimatorIntParam = class("BTCheckAnimatorIntParam", BTTargetCondition)
BTCheckAnimatorIntParam.TypeName = "CheckAnimatorIntParam"
BTDefine.RegisterDecorator(BTCheckAnimatorIntParam.TypeName, BTCheckAnimatorIntParam)
local CompareFunc = BTDefine.LogicCompare

function BTCheckAnimatorIntParam:ctor(config)
  BTCheckAnimatorIntParam.super.ctor(self, config)
  self.paramHash = config.paramName and Animator.StringToHash(config.paramName)
  self.paramVal = config.paramVal
  self.op = config.op or BTDefine.LogicOp.Greater
end

function BTCheckAnimatorIntParam:Dispose()
  BTCheckAnimatorIntParam.super.Dispose(self)
end

function BTCheckAnimatorIntParam:Exec(time, deltaTime, context)
  local ret = BTCheckAnimatorIntParam.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 1, self.failRet
  end
  if not self.animator then
    self.animator = self.target:GetComponent(Animator)
  end
  if not self.animator then
    ret = 1
  else
    local curParamVal = self.animator:GetInteger(self.paramHash)
    ret = CompareFunc(curParamVal, self.paramVal, self.op) and 0 or 1
  end
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
