BTCompareBB = class("BTCompareBB", BTCondition)
BTCompareBB.TypeName = "CompareBB"
BTDefine.RegisterDecorator(BTCompareBB.TypeName, BTCompareBB)
local CompareFunc = BTDefine.LogicCompare

function BTCompareBB:ctor(config)
  BTCompareBB2.super.ctor(self, config)
  self.bbKey = config.bbKey
  self.val = config.val
  self.op = config.op
  self.serviceKey = config.serviceKey
end

function BTCompareBB:Dispose()
  BTCompareBB.super.Dispose(self)
end

function BTCompareBB:Exec(time, deltaTime, context)
  if not context then
    return 1
  end
  local bb = context.blackboard
  if not bb then
    return 1
  end
  if self.serviceKey then
    bb = bb[self.serviceKey]
  else
    bb = bb.globalDatas
  end
  if not bb then
    return 1
  end
  local bbVal = bb[self.bbKey]
  local ret = CompareFunc(bbVal, self.val, self.op) and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
