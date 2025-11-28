BTSelectCondition = class("BTSelectCondition", BTCondition)
BTSelectCondition.TypeName = "SelectCondition"
BTDefine.RegisterDecorator(BTSelectCondition.TypeName, BTSelectCondition)

function BTSelectCondition:ctor(config)
  BTSelectCondition.super.ctor(self, config)
end

function BTSelectCondition:Dispose()
  BTSelectCondition.super.Dispose(self)
end

function BTSelectCondition:Exec(time, deltaTime, context)
  local outResult = 1
  local execResult, execOutput
  for _, v in ipairs(self.children) do
    execResult, execOutput = v:Exec(time, deltaTime, context)
    if execResult == 0 then
      if execOutput ~= nil then
        return 0, execOutput
      else
        return 0, outResult
      end
    end
    outResult = outResult + 1
  end
  if self.failRet ~= nil then
    return 1, self.failRet
  else
    return 1, outResult
  end
end
