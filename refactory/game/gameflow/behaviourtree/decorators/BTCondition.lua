BTCondition = class("BTCondition", BTNode)

function BTCondition:ctor(config)
  BTCondition.super.ctor(self, config)
  self.invertResult = config.invertResult
  if config.failRet ~= nil then
    self.failRet = config.failRet
  end
  if config.passRet ~= nil then
    self.passRet = config.passRet
  end
end

function BTCondition:ProcessResult(ret)
  if self.invertResult then
    ret = ret == 0 and 1 or 0
  end
  return ret
end

function BTCondition:Dispose()
  BTCondition.super.Dispose(self)
end

function BTCondition:Exec(time, deltaTime, context)
  return 1
end
