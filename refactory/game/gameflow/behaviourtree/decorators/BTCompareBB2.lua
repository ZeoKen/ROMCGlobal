BTCompareBB2 = class("BTCompareBB2", BTCondition)
BTCompareBB2.TypeName = "CompareBB2"
BTDefine.RegisterDecorator(BTCompareBB2.TypeName, BTCompareBB2)
local CompareFunc = BTDefine.LogicCompare

function BTCompareBB2:ctor(config)
  BTCompareBB2.super.ctor(self, config)
  self.bbKey = config.bbKey
  self.bbKey2 = config.bbKey2
  self.op = config.op
  self.serviceKey = config.serviceKey
end

function BTCompareBB2:Dispose()
  BTCompareBB2.super.Dispose(self)
end

function BTCompareBB2:Exec(time, deltaTime, context)
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
  local bbVal2 = bb[self.bbKey2]
  local ret = CompareFunc(bbVal, bbVal2, self.op) and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
