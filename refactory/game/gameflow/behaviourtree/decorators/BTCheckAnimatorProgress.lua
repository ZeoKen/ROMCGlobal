BTCheckAnimatorProgress = class("BTCheckAnimatorProgress", BTTargetCondition)
BTCheckAnimatorProgress.TypeName = "CheckAnimatorProgress"
BTDefine.RegisterDecorator(BTCheckAnimatorProgress.TypeName, BTCheckAnimatorProgress)
local CompareFunc = BTDefine.LogicCompare

function BTCheckAnimatorProgress:ctor(config)
  BTCheckAnimatorProgress.super.ctor(self, config)
  self.stateHash = config.stateName and Animator.StringToHash(config.stateName)
  self.normalizedTime = config.normalizedTime or 1
  self.op = config.op or BTDefine.LogicOp.Greater
  self.layer = config.layer or 0
  self.failInTransition = config.failInTransition
end

function BTCheckAnimatorProgress:Dispose()
  BTCheckAnimatorProgress.super.Dispose(self)
end

function BTCheckAnimatorProgress:Exec(time, deltaTime, context)
  local ret = BTCheckAnimatorProgress.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 1, self.failRet
  end
  if not self.animator then
    self.animator = self.target:GetComponent(Animator)
  end
  if not self.animator then
    ret = 1
  else
    local curState = self.animator:GetCurrentAnimatorStateInfo(self.layer)
    if self.stateHash and curState.shortNameHash ~= self.stateHash then
      ret = 1
    else
      ret = CompareFunc(curState.normalizedTime, self.normalizedTime, self.op) and 0 or 1
    end
  end
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
