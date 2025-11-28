BTSequenceCondition = class("BTSequenceCondition", BTCondition)
BTSequenceCondition.TypeName = "SequenceCondition"
BTDefine.RegisterDecorator(BTSequenceCondition.TypeName, BTSequenceCondition)

function BTSequenceCondition:ctor(config)
  BTSequenceCondition.super.ctor(self, config)
end

function BTSequenceCondition:Dispose()
  BTSequenceCondition.super.Dispose(self)
end

function BTSequenceCondition:Exec(time, deltaTime, context)
  for _, v in ipairs(self.children) do
    local ret, output = v:Exec(time, deltaTime, context)
    if ret ~= 0 then
      return 1, self.failRet
    end
  end
  return 0, self.passRet
end
