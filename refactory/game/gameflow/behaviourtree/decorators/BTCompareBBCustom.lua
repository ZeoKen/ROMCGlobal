BTCompareBBCustom = class("BTCompareBBCustom", BTCondition)
BTCompareBBCustom.TypeName = "CompareBBCustom"
BTDefine.RegisterDecorator(BTCompareBBCustom.TypeName, BTCompareBBCustom)
local CompareFunc = BTDefine.LogicCompare

function BTCompareBBCustom:ctor(config)
  BTCompareBB2.super.ctor(self, config)
  self.name = config.bbParam and config.bbParam.name
  self.value = config.bbParam and config.bbParam.value
  self.op = config.op
end

function BTCompareBBCustom:Dispose()
  BTCompareBBCustom.super.Dispose(self)
end

function BTCompareBBCustom:Exec(time, deltaTime, context)
  if not context then
    return 1
  end
  local bb = context.blackboard
  if not bb then
    return 1
  end
  local bbVal = bb:GetGlobalData(self.name)
  local ret = CompareFunc(bbVal, self.value, self.op) and 0 or 1
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
